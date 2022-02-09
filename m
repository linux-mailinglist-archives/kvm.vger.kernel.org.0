Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74874AF77E
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiBIRBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbiBIRBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:01:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 372A7C05CBB6
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+02+sNgYCOuI9QfDVR0KE7R+hKxoZomtfsP09w88qVA=;
        b=cu1Hp2avo1IE8GfebqB5A1A+VX49PMlw5ahpoYPLcND/qwWDeCNIcUkULoLGj2w3PwUqTi
        iwl5XiO1+2wC+eGR+Bmu0bob0k/xDj7pwsbiTZBwzrm8I6BnBmDhWaWlG8eup5A152SqsT
        R44raYBdE1L413tjXvwtimMEWXd+OOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-kSAM0rXCM7SHfbBr7gI1jw-1; Wed, 09 Feb 2022 12:01:06 -0500
X-MC-Unique: kSAM0rXCM7SHfbBr7gI1jw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD56718397B3;
        Wed,  9 Feb 2022 17:00:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 503EF7CD66;
        Wed,  9 Feb 2022 17:00:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com
Subject: [PATCH 03/12] KVM: x86: do not deliver asynchronous page faults if CR0.PG=0
Date:   Wed,  9 Feb 2022 12:00:11 -0500
Message-Id: <20220209170020.1775368-4-pbonzini@redhat.com>
In-Reply-To: <20220209170020.1775368-1-pbonzini@redhat.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enabling async page faults is nonsensical if paging is disabled, but
it is allowed because CR0.PG=0 does not clear the async page fault
MSR.  Just ignore them and only use the artificial halt state,
similar to what happens in guest mode if async #PF vmexits are disabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e1298aef9e2..98aca0f2af12 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12272,7 +12272,9 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
 
 static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
+	if (is_guest_mode(vcpu)
+	    ? !vcpu->arch.apf.delivery_as_pf_vmexit
+	    : !is_cr0_pg(vcpu->arch.mmu))
 		return false;
 
 	if (!kvm_pv_async_pf_enabled(vcpu) ||
-- 
2.31.1


