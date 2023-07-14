Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D1E753304
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbjGNHUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbjGNHUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:20:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8852E3A98;
        Fri, 14 Jul 2023 00:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319201; x=1720855201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=5CzqIi7Pagm76e5p+ceQcdp/nHSMn4lESsq6WuvF7BA=;
  b=aDtHqKtCZ5GOjyxTQ4MpugYAiV1ck3cvxF/BZlONoo0UkmnA8Y0iC8uG
   UmD4LtQ2xCzD5fgc9xc0kDaUcQfFOPJyI4X6CKHxV6Tk8I3+SKzqRR0vQ
   Ib40tCmnyemvwfAmXGGG+DrHdqYxMI3dbMpyoFqxceKcK+g1UTySqG+wU
   0jTGdC8MqSPJv4CMmAZBkEgIiBnwBjI23bn2+zdGFKmso5ok3e0P5PxVp
   bBTw1cfu66/U5/mzwAEsDuk2QItkoaxXVknBsTONABSMTW/DAsiyFdxXN
   z0dYoZuTV1lSG3Hs2/eJciH+srQAoGxEvIo2aw2JYHkrXkFV8TxTqLk6c
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="350283370"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="350283370"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:20:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="968900908"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="968900908"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:19:59 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 07/12] KVM: VMX: drop IPAT in memtype when CD=1 for KVM_X86_QUIRK_CD_NW_CLEARED
Date:   Fri, 14 Jul 2023 14:53:26 +0800
Message-Id: <20230714065326.20557-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For KVM_X86_QUIRK_CD_NW_CLEARED is on, remove the IPAT (ignore PAT) bit in
EPT memory types when cache is disabled and non-coherent DMA are present.

To correctly emulate CR0.CD=1, UC + IPAT are required as memtype in EPT.
However, as with commit
fb279950ba02 ("KVM: vmx: obey KVM_QUIRK_CD_NW_CLEARED"), WB + IPAT are
now returned to workaround a BIOS issue that guest MTRRs are enabled too
late. Without this workaround, a super slow guest boot-up is expected
during the pre-guest-MTRR-enabled period due to UC as the effective memory
type for all guest memory.

Absent emulating CR0.CD=1 with UC, it makes no sense to set IPAT when KVM
is honoring the guest memtype.
Removing the IPAT bit in this patch allows effective memory type to honor
PAT values as well, as WB is the weakest memtype. It means if a guest
explicitly claims UC as the memtype in PAT, the effective memory is UC
instead of previous WB. If, for some unknown reason, a guest meets a slow
boot-up issue with the removal of IPAT, it's desired to fix the blamed PAT
in the guest.

Besides, this patch is also a preparation patch for later fine-grained gfn
zap when guest MTRRs are honored, because it allows zapping only non-WB
ranges when CR0.CD toggles.

BTW, returning guest MTRR type as if CR0.CD=0 is also not preferred because
it still has to hardcode the MTRR type to WB during the
pre-guest-MTRR-enabled period to workaround the slow guest boot-up issue
(guest MTRR type when guest MTRRs are disabled is UC).
In addition, it will make the quirk unnecessarily complexer .

The change of removing IPAT has been verified with normal boot-up time
on old OVMF of commit c9e5618f84b0cb54a9ac2d7604f7b7e7859b45a7 as well,
dated back to Apr 14 2015.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..c1e93678cea4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7548,8 +7548,6 @@ static int vmx_vm_init(struct kvm *kvm)
 
 static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
-	u8 cache;
-
 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
 	 * memory aliases with conflicting memory types and sometimes MCEs.
 	 * We have to be careful as to what are honored and when.
@@ -7576,11 +7574,10 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-			cache = MTRR_TYPE_WRBACK;
+			return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
 		else
-			cache = MTRR_TYPE_UNCACHABLE;
-
-		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+			return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) |
+				VMX_EPT_IPAT_BIT;
 	}
 
 	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
-- 
2.17.1

