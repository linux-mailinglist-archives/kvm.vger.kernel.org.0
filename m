Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52065072BF
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354487AbiDSQSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346527AbiDSQSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:18:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9BF38BCE;
        Tue, 19 Apr 2022 09:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650384954; x=1681920954;
  h=from:to:cc:subject:date:message-id;
  bh=iMKoQZDObCSA8eZswz4OYIjDeRXrAucqZSnlpOy9fR0=;
  b=VV+qmhDLBK8i6F5Bsfyt05pOhPbXnlXJujWGsoFVnH4nnL8Cu0ShASk9
   o3HTqFbtNKFnW8wAbDF4/evNtq/WwpASw+AmXYBVNp0SSD/tFuHc6MzjY
   u/ij42LxMI9GL4Hr9R0FdUwZ1xvWLAbI/swUHO1020QUUDKDuc6mgLSLv
   BqgnVsE6Nxg7qT9On0MfqFYjiBhk3KOv92mpZuUO/MdlF3eU2QcJTGW+p
   sMzq6B+io+h7beXlUsHwXDoqlkO4IIKW4yxkrEeyBQ1isuYCk87gFYYcb
   WClAqvM6BlfCE0LonHo2nAPhgrXQZ80LMVk1/3pYWrD1tJINciXWHpLfU
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="245697303"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="245697303"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:15:54 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="529374607"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:15:46 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v9 7/9] KVM: Move kvm_arch_vcpu_precreate() under kvm->lock
Date:   Tue, 19 Apr 2022 23:44:09 +0800
Message-Id: <20220419154409.11842-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_vcpu_precreate() targets to handle arch specific VM resource
to be prepared prior to the actual creation of vCPU. For example, x86
platform may need do per-VM allocation based on max_vcpu_ids at the
first vCPU creation. It probably leads to concurrency control on this
allocation as multiple vCPU creation could happen simultaneously. From
the architectual point of view, it's necessary to execute
kvm_arch_vcpu_precreate() under protect of kvm->lock.

Currently only arm64, x86 and s390 have non-nop implementations at the
stage of vCPU pre-creation. Remove the lock acquiring in s390's design
and make sure all architecture can run kvm_arch_vcpu_precreate() safely
under kvm->lock without recrusive lock issue.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/s390/kvm/kvm-s390.c |  2 --
 arch/x86/kvm/x86.c       |  2 +-
 virt/kvm/kvm_main.c      | 10 ++++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 156d1c25a3c1..5c795bbcf1ea 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3042,9 +3042,7 @@ static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)
 	if (!sclp.has_esca || !sclp.has_64bscao)
 		return false;
 
-	mutex_lock(&kvm->lock);
 	rc = kvm->arch.use_esca ? 0 : sca_switch_to_extended(kvm);
-	mutex_unlock(&kvm->lock);
 
 	return rc == 0 && id < KVM_S390_ESCA_CPU_SLOTS;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c0ca599a353..277a0da8c290 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11168,7 +11168,7 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
-	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
+	if (kvm_check_tsc_unstable() && kvm->created_vcpus)
 		pr_warn_once("kvm: SMP vm created on host with unstable TSC; "
 			     "guest TSC will not be reliable\n");
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e05af5ebea..d719a15df17f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3731,13 +3731,15 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		return -EINVAL;
 	}
 
+	r = kvm_arch_vcpu_precreate(kvm, id);
+	if (r) {
+		mutex_unlock(&kvm->lock);
+		return r;
+	}
+
 	kvm->created_vcpus++;
 	mutex_unlock(&kvm->lock);
 
-	r = kvm_arch_vcpu_precreate(kvm, id);
-	if (r)
-		goto vcpu_decrement;
-
 	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
 	if (!vcpu) {
 		r = -ENOMEM;
-- 
2.27.0

