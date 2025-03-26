Return-Path: <kvm+bounces-42054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F34EA71F54
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 711883B475E
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7E9264A7C;
	Wed, 26 Mar 2025 19:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P+h1Ofhs"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7110A2561AA
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017829; cv=none; b=sTAbSpeTB3Bw+MDBd1ozMDcy7i+ar0xgXp1cNYUKH9YNQFEYuKmSsEWFCIv45v0WYK9bjN40dMjnSmnZtkf88xxFu3UqV9IFb6rWr7bxyJfjjVtm+XVqf9YFPPXc8uq66NCs8hUO3hdGm7JWuZ6I1LekVcDsGN+ZErkYgZ2qhqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017829; c=relaxed/simple;
	bh=kpX2Hv3Ns3UxCoKX6tVxj8f47gVGi0U8q7Q+/pzcrTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4WWFkKTVEDPu24xkwdjHP5Cj1ZtupMCS4C98CjknKefYbpSYlPeOU5HFPorN6vkN46/o2SFmudSprObaXuLLGQ6IC0i6tqLizz1ZCzhUxyHI+2TzyOQqGCXYRTW477w6NFyw9RGhlUB3R6+JuBaHxIpVALGc/AL7NEseuR00p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P+h1Ofhs; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l9a7sV51gGMamG7lbl5gcaoCKmIXlJVosIr7/PH8LQA=;
	b=P+h1OfhsJw6sW++kcvayFXKkqM9FatBS4sbnNL3UrWTf/e47iFphcoVEimunFn9gSZWRHT
	6sf3pdHGmIBoyMI4OpwkXhe4K/cGPmPWQmK2KJMnR+vTXsDAAlozC9JYp1fMT5BlAdeGhS
	I3QyxwGs03T4paR0H+0i81QWqNVVPpA=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 09/24] KVM: SEV: Generalize tracking ASID->vCPU with xarrays
Date: Wed, 26 Mar 2025 19:36:04 +0000
Message-ID: <20250326193619.3714986-10-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Following changes will track ASID to vCPU mappings for all ASIDs, not
just SEV ASIDs. Using per-CPU arrays with the maximum possible number of
ASIDs would be too expensive. Use xarrays to generalize tracking the
mappings instead. The logic is also mostly moved outside the SEV code to
allow future changes to reuse it for normal SVM VMs.

Storing into an xarray is more expensive than reading/writing to an
array, but is only done on vCPU load and should be mostly uncontended.
Also, the size of the xarray should be O(# of VMs), so it is not
expected to be huge. In fact, the xarray will probably use less memory
than the normal array even for SEV on machines that only run a few VMs.

When a new ASID is allocated, reserve an entry for it on all xarrays on
all CPUs. This allows the memory allocations to happen in a more relaxed
context (allowing reclaim and accounting), and failures to be handled at
VM creation time. However, entries will be allocated even on CPUs that
never run the VM.

The alternative is relying on on-demand GFP_ATOMIC allocations with
xa_store() on vCPU load.  These allocations are more likely to fail and
more difficult to handle since vCPU load cannot fail. Flushing the TLB
if the xa_store() fails is probably sufficient handling, but
preallocations are easier to reason about.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/sev.c | 25 ++++-----------------
 arch/x86/kvm/svm/svm.c | 50 +++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h |  7 +++---
 3 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1742f51d4c194..c11da3259c089 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -211,6 +211,9 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 		goto e_uncharge;
 	}
 
+	if (!svm_register_asid(asid))
+		goto e_uncharge;
+
 	__set_bit(asid, sev_asid_bitmap);
 
 	mutex_unlock(&sev_bitmap_lock);
@@ -231,18 +234,10 @@ unsigned int sev_get_asid(struct kvm *kvm)
 
 static void sev_asid_free(struct kvm_sev_info *sev)
 {
-	struct svm_cpu_data *sd;
-	int cpu;
+	svm_unregister_asid(sev->asid);
 
 	mutex_lock(&sev_bitmap_lock);
-
 	__set_bit(sev->asid, sev_reclaim_asid_bitmap);
-
-	for_each_possible_cpu(cpu) {
-		sd = per_cpu_ptr(&svm_data, cpu);
-		sd->sev_vcpus[sev->asid] = NULL;
-	}
-
 	mutex_unlock(&sev_bitmap_lock);
 
 	sev_misc_cg_uncharge(sev);
@@ -3076,18 +3071,6 @@ void sev_hardware_unsetup(void)
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
 }
 
-int sev_cpu_init(struct svm_cpu_data *sd)
-{
-	if (!sev_enabled)
-		return 0;
-
-	sd->sev_vcpus = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
-	if (!sd->sev_vcpus)
-		return -ENOMEM;
-
-	return 0;
-}
-
 /*
  * Pages used by hardware to hold guest encrypted state must be flushed before
  * returning them to the system.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce67112732e8c..b740114a9d9bc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -694,7 +694,7 @@ static void svm_cpu_uninit(int cpu)
 	if (!sd->save_area)
 		return;
 
-	kfree(sd->sev_vcpus);
+	xa_destroy(&sd->asid_vcpu);
 	__free_page(__sme_pa_to_page(sd->save_area_pa));
 	sd->save_area_pa = 0;
 	sd->save_area = NULL;
@@ -711,18 +711,11 @@ static int svm_cpu_init(int cpu)
 	if (!save_area_page)
 		return ret;
 
-	ret = sev_cpu_init(sd);
-	if (ret)
-		goto free_save_area;
+	xa_init(&sd->asid_vcpu);
 
 	sd->save_area = page_address(save_area_page);
 	sd->save_area_pa = __sme_page_pa(save_area_page);
 	return 0;
-
-free_save_area:
-	__free_page(save_area_page);
-	return ret;
-
 }
 
 static void set_dr_intercepts(struct vcpu_svm *svm)
@@ -1557,6 +1550,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	unsigned int asid;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
+	struct kvm_vcpu *prev;
 
 	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
@@ -1573,13 +1567,13 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (sev_guest(vcpu->kvm)) {
 		/*
 		 * Flush the TLB when a different vCPU using the same ASID is
-		 * run on the same CPU.
+		 * run on the same CPU. xa_store() should always succeed because
+		 * the entry is reserved when the ASID is allocated.
 		 */
 		asid = sev_get_asid(vcpu->kvm);
-		if (sd->sev_vcpus[asid] != vcpu) {
-			sd->sev_vcpus[asid] = vcpu;
+		prev = xa_store(&sd->asid_vcpu, asid, vcpu, GFP_ATOMIC);
+		if (prev != vcpu || WARN_ON_ONCE(xa_err(prev)))
 			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-		}
 	}
 }
 
@@ -5047,6 +5041,36 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	sev_vcpu_deliver_sipi_vector(vcpu, vector);
 }
 
+void svm_unregister_asid(unsigned int asid)
+{
+	struct svm_cpu_data *sd;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		sd = per_cpu_ptr(&svm_data, cpu);
+		xa_erase(&sd->asid_vcpu, asid);
+	}
+}
+
+bool svm_register_asid(unsigned int asid)
+{
+	struct svm_cpu_data *sd;
+	int cpu;
+
+	/*
+	 * Preallocate entries on all CPUs for the ASID to avoid memory
+	 * allocations in the vCPU load path.
+	 */
+	for_each_possible_cpu(cpu) {
+		sd = per_cpu_ptr(&svm_data, cpu);
+		if (xa_reserve(&sd->asid_vcpu, asid, GFP_KERNEL_ACCOUNT)) {
+			svm_unregister_asid(asid);
+			return false;
+		}
+	}
+	return true;
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3ab2a424992c1..4929b96d3d700 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -340,8 +340,7 @@ struct svm_cpu_data {
 
 	struct vmcb *current_vmcb;
 
-	/* index = sev_asid, value = vcpu pointer */
-	struct kvm_vcpu **sev_vcpus;
+	struct xarray asid_vcpu;
 };
 
 DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
@@ -655,6 +654,8 @@ void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
+bool svm_register_asid(unsigned int asid);
+void svm_unregister_asid(unsigned int asid);
 
 /* nested.c */
 
@@ -793,7 +794,6 @@ void sev_vm_destroy(struct kvm *kvm);
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
-int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
@@ -817,7 +817,6 @@ static inline void sev_vm_destroy(struct kvm *kvm) {}
 static inline void __init sev_set_cpu_caps(void) {}
 static inline void __init sev_hardware_setup(void) {}
 static inline void sev_hardware_unsetup(void) {}
-static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
-- 
2.49.0.395.g12beb8f557-goog


