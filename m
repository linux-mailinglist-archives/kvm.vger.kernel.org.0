Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815FA4BDDD1
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380205AbiBUQXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380194AbiBUQXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B9E427174
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1Gzsv9tYBkuF5sOn5S6HL4uRB3TRk8wp+l3AAt1BvU=;
        b=CoR4rQOqShIB1GUHwkTt6NxF6LjVyyQsXuZRGg6LAj8T3DM9rW22S+N4RmUk6utyeAV6gB
        IQH+Cym1tlZqYkiVylo1Lm7Me/pXRF/mOPRR9nMVYprxKnvoJVRQv8LVd1KacRBKjNrP1t
        2JMZ+8V4GYHrExCvDk3o+94MGtIyVtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-1vr4Ohg_PUGXbIkjSjiNBg-1; Mon, 21 Feb 2022 11:22:46 -0500
X-MC-Unique: 1vr4Ohg_PUGXbIkjSjiNBg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC92E1006AA5;
        Mon, 21 Feb 2022 16:22:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CE4777468;
        Mon, 21 Feb 2022 16:22:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 02/25] KVM: x86/mmu: nested EPT cannot be used in SMM
Date:   Mon, 21 Feb 2022 11:22:20 -0500
Message-Id: <20220221162243.683208-3-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The role.base.smm flag is always zero when setting up shadow EPT,
do not bother copying it over from vcpu->arch.root_mmu.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7051040e15b3..4f9bbd02fb8b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4886,9 +4886,11 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 {
 	union kvm_mmu_role role = {0};
 
-	/* SMM flag is inherited from root_mmu */
-	role.base.smm = vcpu->arch.root_mmu.mmu_role.base.smm;
-
+	/*
+	 * KVM does not support SMM transfer monitors, and consequently does not
+	 * support the "entry to SMM" control either.  role.base.smm is always 0.
+	 */
+	WARN_ON_ONCE(is_smm(vcpu));
 	role.base.level = level;
 	role.base.has_4_byte_gpte = false;
 	role.base.direct = false;
-- 
2.31.1


