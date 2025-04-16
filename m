Return-Path: <kvm+bounces-43419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1EC5A8B911
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 14:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42F0018975C5
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 12:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A011E2914;
	Wed, 16 Apr 2025 12:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="YCjA7j7W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2278136B;
	Wed, 16 Apr 2025 12:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744806627; cv=none; b=Z07Drukxd8jy+nfFOOmRm64b8pcyagKDBUZJb8Dua5uGWku7yGwLrU7hS0zppdSF+JsT9xCEE63r8U2vWQCAc1NtRYaazwYF2nrzIGVn2aSQQIR1LO8i/ZZFivCWrOMuNyelNRAEO1ZU3AhVu1Wi2MyeYqrMIuFbCZCBvnR7dQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744806627; c=relaxed/simple;
	bh=w4TAR/yH3VcS9OoJH0esVNtvvSK6jM0c6R3XkuFx4Xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jd8cASZZndqIeQE8BUAIGl9g5O4Fca0/OntDd2xOAFoU0A/yFqKeXuOanHQK01rYYEFy/MjKpyOboWC0xTSfw8XToFaaBIMQIOgjIpOHxVFLYg0H3ze4U6lzdv6OY9POgF52vdbVrbTBtGCrz965rQ6Mg+MOaGn6bV4WwBmtHmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=YCjA7j7W; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1744806626; x=1776342626;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sFqE0U8biMo7h/rFvupA/Vgek3MDfQSR208Nzfq3VY8=;
  b=YCjA7j7Wq8NXJLPYeNndv7vJtO0lp+Q+GXU74rlVzxmNgral1IEiQ/Xe
   FKzCQWoGuttB6WJoBr5M0iTN6EUzJxnv+It4NsHybYUFSECFOpDNl7Y9M
   OZCdmhvwPZCGLWpUOgERo5eVh3BcD6AOKRSoZrWmUxyld7dGoyxQfPEz9
   4=;
X-IronPort-AV: E=Sophos;i="6.15,216,1739836800"; 
   d="scan'208";a="396347607"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 12:30:23 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.44.209:64083]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.62.158:2525] with esmtp (Farcaster)
 id 5cd90893-39c7-408c-bd64-a8f3f4ff1016; Wed, 16 Apr 2025 12:30:23 +0000 (UTC)
X-Farcaster-Flow-ID: 5cd90893-39c7-408c-bd64-a8f3f4ff1016
Received: from EX19EXOUEB002.ant.amazon.com (10.252.135.74) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 16 Apr 2025 12:30:17 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.108) by
 EX19EXOUEB002.ant.amazon.com (10.252.135.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 16 Apr 2025 12:30:17 +0000
Received: from email-imr-corp-prod-iad-all-1a-f1af3bd3.us-east-1.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1544.14 via Frontend Transport; Wed, 16 Apr 2025 12:30:17 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-iad-all-1a-f1af3bd3.us-east-1.amazon.com (Postfix) with ESMTPS id E8E47413B0;
	Wed, 16 Apr 2025 12:30:10 +0000 (UTC)
Message-ID: <392fc76a-5d2a-441d-99c8-532c0bbb052b@amazon.co.uk>
Date: Wed, 16 Apr 2025 13:30:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
	<kvm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <michael.roth@amd.com>, <wei.w.wang@intel.com>,
	<liam.merwick@oracle.com>, <isaku.yamahata@gmail.com>,
	<kirill.shutemov@linux.intel.com>, <suzuki.poulose@arm.com>,
	<steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <shuah@kernel.org>,
	<hch@infradead.org>, <jgg@nvidia.com>, <rientjes@google.com>,
	<jhubbard@nvidia.com>, <fvdl@google.com>, <hughd@google.com>,
	<jthoughton@google.com>, <peterx@redhat.com>
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-5-tabba@google.com>
 <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
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
In-Reply-To: <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi!

On Mon, 2025-04-14 at 12:51 +0100, David Hildenbrand wrote:
>

[...]

> On top of that, I was wondering if we could look into doing something like
> the following. It would also allow for pulling pages out of gmem for
> existing SW-protected VMs once they enable shared memory for GMEM IIUC.
> 
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 08eebd24a0e18..6f878cab0f466 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4495,11 +4495,6 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
>  {
>         int max_order, r;
> 
> -       if (!kvm_slot_has_gmem(fault->slot)) {
> -               kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> -               return -EFAULT;
> -       }
> -
>         r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
>                              &fault->refcounted_page, &max_order);
>         if (r) {
> @@ -4518,8 +4513,19 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>                                  struct kvm_page_fault *fault)
>  {
>         unsigned int foll = fault->write ? FOLL_WRITE : 0;
> +       bool use_gmem = false;
> +
> +       if (fault->is_private) {
> +               if (!kvm_slot_has_gmem(fault->slot)) {
> +                       kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +                       return -EFAULT;
> +               }
> +               use_gmem = true;
> +       } else if (kvm_slot_has_gmem_with_shared(fault->slot)) {
> +               use_gmem = true;
> +       }
> 
> -       if (fault->is_private)
> +       if (use_gmem)
>                 return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
> 
>         foll |= FOLL_NOWAIT;
> 
> 
> That is, we'd not claim that things are private when they are not, but instead
> teach the code about shared memory coming from gmem.
> 
> There might be some more missing, just throwing it out there if I am completely off.

I think I arrived at the need for this as well while experimenting with
building a Firecracker version that works with my direct map removal
patches.

With this patch series, on ARM, as soon as a memslot has a guest_memfd
associated with it, all guest faults go through kvm_gmem_get_pfn, but on
x86, they go through slot->userspace_addr by default, as
CONFIG_KVM_SW_PROTECTED_VM selects CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES.
There's no real difference between these if slot->userspace_addr can be
GUP'd, but if its a VMA of a guest_memfd without direct map entries,
faulting through slot->userspace_addr wont work. So on x86 Firecracker
has to formally set the memory attributes to private, while on ARM it
doesn't [1], which is a bit awkward.

David, I couldn't find an implementation of
kvm_slot_has_gmem_with_shared() in the branch you shared, but would it
be something like "slot->userspace_addr points to a gmem VMA,
particularly to a VMA of the gmem that's associated with this memslot,
mapped at the same offset"?

Best, 
Patrick

[1]: https://github.com/firecracker-microvm/firecracker/blob/feature/secret-hiding/src/vmm/src/builder.rs#L268

> -- 
> Cheers,
> 
> David / dhildenb
> 

