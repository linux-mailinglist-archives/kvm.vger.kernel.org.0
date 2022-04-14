Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF2450074B
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240559AbiDNHnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240454AbiDNHm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B3F35418B
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GS5GXdXYcQZI1wo1x5s5S3htNZXur5jE8g9OaqoOCOs=;
        b=KpZzLXfEnx2+1mXd7eZNrKvg0DV63BQIiSNrE/edwgwErdMz8Q5D/FfrNLbQxER4sz8a4e
        lCRxOSZX0H06GBL7kwKtU9zzbr+lCwMInNlYlsX3M852L+PnAtYTamPV5hI7BMsFwCmG94
        IaiTZxAmPyzmvZWbszHZ591c54hqISY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-1dpg4S1vONy91vzehhuyqQ-1; Thu, 14 Apr 2022 03:40:03 -0400
X-MC-Unique: 1dpg4S1vONy91vzehhuyqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59AB119705DB;
        Thu, 14 Apr 2022 07:40:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C6CCC28109;
        Thu, 14 Apr 2022 07:40:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 13/22] KVM: x86/mmu: store shadow EFER.NX in the MMU role
Date:   Thu, 14 Apr 2022 03:39:51 -0400
Message-Id: <20220414074000.31438-14-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the MMU role is separate from the CPU role, it can be a
truthful description of the format of the shadow pages.  This includes
whether the shadow pages use the NX bit; so force the efer_nx field
of the MMU role when TDP is disabled, and remove the hardcoding it in
the callers of reset_shadow_zero_bits_mask.

In fact, the initialization of reserved SPTE bits can now be made common
to shadow paging and shadow NPT; move it to shadow_mmu_init_context.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 92dade92462c..f491d3c47ac8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4430,16 +4430,6 @@ static inline u64 reserved_hpa_bits(void)
 static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 					struct kvm_mmu *context)
 {
-	/*
-	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
-	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
-	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
-	 * The iTLB multi-hit workaround can be toggled at any time, so assume
-	 * NX can be used by any non-nested shadow MMU to avoid having to reset
-	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
-	 */
-	bool uses_nx = is_efer_nx(context) || !tdp_enabled;
-
 	/* @amd adds a check on bit of SPTEs, which KVM shouldn't use anyways. */
 	bool is_amd = true;
 	/* KVM doesn't use 2-level page tables for the shadow MMU. */
@@ -4451,7 +4441,8 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-				context->shadow_root_level, uses_nx,
+				context->shadow_root_level,
+				context->mmu_role.base.efer_nx,
 				guest_can_use_gbpages(vcpu), is_pse, is_amd);
 
 	if (!shadow_me_mask)
@@ -4815,6 +4806,16 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
 
+	/*
+	 * KVM forces EFER.NX=1 when TDP is disabled, reflect it in the MMU role.
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.
+	 */
+	role.base.efer_nx = true;
 	return role;
 }
 
-- 
2.31.1


