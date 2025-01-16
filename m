Return-Path: <kvm+bounces-35666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D0CA13CC5
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 15:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B48323AC652
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 14:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1866B22A7E2;
	Thu, 16 Jan 2025 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="r4NCht0f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137F422E41B;
	Thu, 16 Jan 2025 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737038912; cv=none; b=tUjARbwsEULts3SYN3SR9OIpuXDujx8yR+9HP0q1OwEvgkoPhWrvO9y1UbTLTNOb6a5ngTc5JvFM/uOxEXxvOU/rqwkxXRajEr+IjQrDpZ+ftOddMn8qkJ3aF1rBzeq4WsgdBfQ8QlYcYj37DJGT+60wBlT/DzEbyQ2JfROdWsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737038912; c=relaxed/simple;
	bh=5dwVwQPbFrti9t7CAKA+y94hpM9MdXgbzD/qrj0kprA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=N3KCG36s9uZhPV3Qv6nCq9lHXGF8MPTE/XZewO+q4Xa3Xd749mIWDmo6M1klJQ0lODNVlfXqQWL+VL3/FDG3pXR4QpL4i2e4I4ux9adbTMHvhjv6p+d/044GIUzwPpF4hxqKXe8vyKdtyss13VhCgQZOqHjWQlJ2D29qSXpLn/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=r4NCht0f; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1737038910; x=1768574910;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fG4taAKUdQ5Hh7V+qy1Jc/FBV9g1o2/PtE50ldwn630=;
  b=r4NCht0feVTPWHYfCy4bbeqffTsf27OTN9qi2amCRAPHoTcMkWA34ZoV
   l34o7rvBO9AkBZrELUbQlfaaonMG78gcUkR9W73IM72F2L1267omTCGua
   eijg3KvtG5exS+QdgtdoPoj3H5qDMpkt2IRNqLmA/Ro+xf/XsqKCxhEc/
   M=;
X-IronPort-AV: E=Sophos;i="6.13,209,1732579200"; 
   d="scan'208";a="459317083"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 14:48:26 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:24824]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.59.12:2525] with esmtp (Farcaster)
 id d87e80ce-d7ed-4551-924f-bf0789fff6ba; Thu, 16 Jan 2025 14:48:25 +0000 (UTC)
X-Farcaster-Flow-ID: d87e80ce-d7ed-4551-924f-bf0789fff6ba
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 16 Jan 2025 14:48:22 +0000
Received: from email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Thu, 16 Jan 2025 14:48:22 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com (Postfix) with ESMTPS id 2E40D4041A;
	Thu, 16 Jan 2025 14:48:14 +0000 (UTC)
Message-ID: <31f1229d-40c8-4a75-b0f1-be315150379f@amazon.co.uk>
Date: Thu, 16 Jan 2025 14:48:13 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 00/14] KVM: Restricted mapping of guest_memfd at
 the host and arm64 support
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>, <mic@digikod.net>,
	<vbabka@suse.cz>, <vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <shuah@kernel.org>,
	<hch@infradead.org>, <jgg@nvidia.com>, <rientjes@google.com>,
	<jhubbard@nvidia.com>, <fvdl@google.com>, <hughd@google.com>,
	<jthoughton@google.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, James Gowans <jgowans@amazon.com>
References: <20241213164811.2006197-1-tabba@google.com>
From: Patrick Roy <roypat@amazon.co.uk>
Content-Language: en-US
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <20241213164811.2006197-1-tabba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Fuad!

I finally got around to giving this patch series a spin for my non-CoCo
usecase. I used the below diff to expose the functionality outside of pKVM
(Based on Steven P.'s ARM CCA patch for custom VM types on ARM [2]).
There's two small things that were broken for me (will post as responses
to individual patches), but after fixing those, I was able to boot some
guests using a modified Firecracker [1].

Just wondering, are you still looking into posting a separate series
with just the MMU changes (e.g. something to have a bare-bones
KVM_SW_PROTECTED_VM on ARM, like we do for x86), like you mentioned in
the guest_memfd call before Christmas? We're pretty keen to
get our hands something like that for our non-CoCo VMs (and ofc, am
happy to help with any work required to get there :)

Best, 
Patrick

[1]: https://github.com/roypat/firecracker/tree/secret-freedom-mmap
[2]: https://lore.kernel.org/kvm/20241004152804.72508-12-steven.price@arm.com/

---

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8dfae9183651..0b8dfb855e51 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -380,6 +380,8 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+
+	unsigned long type;
 };

 struct kvm_vcpu_fault_info {
@@ -1529,7 +1531,11 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))

-#define kvm_arch_has_private_mem(kvm)					\
-	(IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) && is_protected_kvm_enabled())
+#ifdef CONFIG_KVM_PRIVATE_MEM
+#define kvm_arch_has_private_mem(kvm)  \
+	((kvm)->arch.type == KVM_VM_TYPE_ARM_SW_PROTECTED || is_protected_kvm_enabled())
+#else
+#define kvm_arch_has_private_mem(kvm) false
+#endif

 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index fe3451f244b5..2da26aa3b0b5 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
 	select KVM_GMEM_MAPPABLE
 	help
 	  Support hosting virtualized guest machines.
@@ -84,4 +85,10 @@ config PTDUMP_STAGE2_DEBUGFS

 	  If in doubt, say N.

+config KVM_SW_PROTECTED_VM
+    bool "Enable support for KVM software-protected VMs"
+    depends on EXPERT
+    depends on KVM && ARM64
+    select KVM_GENERIC_PRIVATE_MEM
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..35683868c0e4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -181,6 +181,19 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	mutex_unlock(&kvm->lock);
 #endif

+	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
+		return -EINVAL;
+
+	switch (type & KVM_VM_TYPE_ARM_MASK) {
+	case KVM_VM_TYPE_ARM_NORMAL:
+	case KVM_VM_TYPE_ARM_SW_PROTECTED:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	kvm->arch.type = type & KVM_VM_TYPE_ARM_MASK;
+
 	kvm_init_nested(kvm);

 	ret = kvm_share_hyp(kvm, kvm + 1);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1c4b3871967c..9dbb472eb96a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -869,9 +869,6 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;

-	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
-		return -EINVAL;
-
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
 	if (is_protected_kvm_enabled()) {
 		phys_shift = kvm_ipa_limit;
@@ -2373,3 +2370,31 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)

 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range)
+{
+	/*
+	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM only
+	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
+	 * can simply ignore such slots.  But if userspace is making memory
+	 * PRIVATE, then KVM must prevent the guest from accessing the memory
+	 * as shared.  And if userspace is making memory SHARED and this point
+	 * is reached, then at least one page within the range was previously
+	 * PRIVATE, i.e. the slot's possible hugepage ranges are changing.
+	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
+	 * a hugepage can be used for affected ranges.
+	 */
+	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+		return false;
+
+	return kvm_unmap_gfn_range(kvm, range);
+}
+
+bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_gfn_range *range)
+{
+	return false;
+}
+#endif
\ No newline at end of file
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b34aed04ffa5..214f6b5da43f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -653,6 +653,13 @@ struct kvm_enable_cap {
  * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
  * value 0 implies the default IPA size, 40bits.
  */
+#define KVM_VM_TYPE_ARM_SHIFT		    8
+#define KVM_VM_TYPE_ARM_MASK		    (0xfULL << KVM_VM_TYPE_ARM_SHIFT)
+#define KVM_VM_TYPE_ARM(_type)		\
+	(((_type) << KVM_VM_TYPE_ARM_SHIFT) & KVM_VM_TYPE_ARM_MASK)
+#define KVM_VM_TYPE_ARM_NORMAL		    KVM_VM_TYPE_ARM(0)
+#define KVM_VM_TYPE_ARM_SW_PROTECTED    KVM_VM_TYPE_ARM(1)
+
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)


On Fri, 2024-12-13 at 16:47 +0000, Fuad Tabba wrote:
> This series adds restricted mmap() support to guest_memfd, as
> well as support for guest_memfd on arm64. It is based on Linux
> 6.13-rc2.  Please refer to v3 for the context [1].
> 
> Main changes since v3:
> - Added a new folio type for guestmem, used to register a
>   callback when a folio's reference count reaches 0 (Matthew
>   Wilcox, DavidH) [2]
> - Introduce new mappability states for folios, where a folio can
> be mappable by the host and the guest, only the guest, or by no
> one (transient state)
> - Rebased on Linux 6.13-rc2
> - Refactoring and tidying up
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20241010085930.1546800-1-tabba@google.com/
> [2] https://lore.kernel.org/all/20241108162040.159038-1-tabba@google.com/
> 
> Ackerley Tng (2):
>   KVM: guest_memfd: Make guest mem use guest mem inodes instead of
>     anonymous inodes
>   KVM: guest_memfd: Track mappability within a struct kvm_gmem_private
> 
> Fuad Tabba (12):
>   mm: Consolidate freeing of typed folios on final folio_put()
>   KVM: guest_memfd: Introduce kvm_gmem_get_pfn_locked(), which retains
>     the folio lock
>   KVM: guest_memfd: Folio mappability states and functions that manage
>     their transition
>   KVM: guest_memfd: Handle final folio_put() of guestmem pages
>   KVM: guest_memfd: Allow host to mmap guest_memfd() pages when shared
>   KVM: guest_memfd: Add guest_memfd support to
>     kvm_(read|/write)_guest_page()
>   KVM: guest_memfd: Add KVM capability to check if guest_memfd is host
>     mappable
>   KVM: guest_memfd: Add a guest_memfd() flag to initialize it as
>     mappable
>   KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
>     allowed
>   KVM: arm64: Skip VMA checks for slots without userspace address
>   KVM: arm64: Handle guest_memfd()-backed guest page faults
>   KVM: arm64: Enable guest_memfd private memory when pKVM is enabled
> 
>  Documentation/virt/kvm/api.rst                |   4 +
>  arch/arm64/include/asm/kvm_host.h             |   3 +
>  arch/arm64/kvm/Kconfig                        |   1 +
>  arch/arm64/kvm/mmu.c                          | 119 +++-
>  include/linux/kvm_host.h                      |  75 +++
>  include/linux/page-flags.h                    |  22 +
>  include/uapi/linux/kvm.h                      |   2 +
>  include/uapi/linux/magic.h                    |   1 +
>  mm/debug.c                                    |   1 +
>  mm/swap.c                                     |  28 +-
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/guest_memfd_test.c  |  64 +-
>  virt/kvm/Kconfig                              |   4 +
>  virt/kvm/guest_memfd.c                        | 579 +++++++++++++++++-
>  virt/kvm/kvm_main.c                           | 229 ++++++-
>  15 files changed, 1074 insertions(+), 59 deletions(-)
> 
> 
> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
> --
> 2.47.1.613.gc27f4b7a9f-goog

