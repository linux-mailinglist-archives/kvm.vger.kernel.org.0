Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8983A50074F
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbiDNHnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240330AbiDNHm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CD64205E0
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ej/w4HBGwYoDboGlilY+ru86ZG1EwdY47a9cBI8irf8=;
        b=PxAx6/iKwWKXpfYjDU+ghv1c+EQnKcBW1VwfwDj5q0Q1qsK6xd11JmCIUvzz3uaArqZlDF
        Hb4a6Y5/xaRL6q02l48hVdMlwGzZLH/+exgqs1eI/lpxi9QVChgfX8UEfRw8KLPuKFfxdQ
        hR8nQxeNW1Nl8Cdl+tAUN3ymxzLtZzw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-ySX8cCLOPfycE2mUYSWKFw-1; Thu, 14 Apr 2022 03:40:01 -0400
X-MC-Unique: ySX8cCLOPfycE2mUYSWKFw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64E6A296A61C;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 425A241D40E;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, David Matlack <dmatlack@google.com>
Subject: [PATCH 01/22] KVM: x86/mmu: nested EPT cannot be used in SMM
Date:   Thu, 14 Apr 2022 03:39:39 -0400
Message-Id: <20220414074000.31438-2-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The role.base.smm flag is always zero when setting up shadow EPT,
do not bother copying it over from vcpu->arch.root_mmu.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c623019929a7..797c51bb6cda 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4910,9 +4910,11 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
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


