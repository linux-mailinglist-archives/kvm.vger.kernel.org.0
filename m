Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDAE4BE073
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380330AbiBUQXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380241AbiBUQXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D616827161
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tYb6r12HjD9UpDIda2UW5abpGynZm1DBV0FT29YnZw8=;
        b=XviavweiSoF8Gw4AFUPqIqQFgTsU6ck41I/FfYeYYR7HJ4L19uCIiItQJXamUaCX1Xwlbx
        DVGiKbBoE9fzawo01vfeEZJtuxSeyKA/bW9/dBA8ccWWdvbG1RsRNXgexbdfG8nevFWlou
        MJIbqkumhBqOq36AmxnVpOcBex7h8pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-k8-hEfrVOziRuPUf0IzjnA-1; Mon, 21 Feb 2022 11:22:52 -0500
X-MC-Unique: k8-hEfrVOziRuPUf0IzjnA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B06F801B0C;
        Mon, 21 Feb 2022 16:22:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D79E7611B;
        Mon, 21 Feb 2022 16:22:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 14/25] KVM: x86/mmu: store shadow EFER.NX in the MMU role
Date:   Mon, 21 Feb 2022 11:22:32 -0500
Message-Id: <20220221162243.683208-15-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the MMU role is separate from the CPU mode, it can be a
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
index 725aef55c08f..bbb5f50d3dcc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4405,16 +4405,6 @@ static inline u64 reserved_hpa_bits(void)
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
@@ -4426,7 +4416,8 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-				context->shadow_root_level, uses_nx,
+				context->shadow_root_level,
+				context->mmu_role.base.efer_nx,
 				guest_can_use_gbpages(vcpu), is_pse, is_amd);
 
 	if (!shadow_me_mask)
@@ -4784,6 +4775,16 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
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


