Return-Path: <kvm+bounces-48614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 624C3ACF9BA
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 00:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA6C17A88D9
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 22:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2672A27FD43;
	Thu,  5 Jun 2025 22:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MYBBilFv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B985415747D
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 22:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749162954; cv=none; b=OY0CVo1qU91QxD4+Bng6t1NocpR6/i8Cb9cfFuweLapX06aOYenyoC8eTvPVTyP07zseHAQnKVbRNIAm6t4sH32Lmjh2Im7SLJirjJMfAljkW+2Pr6uNZiSXurefveM/ytoB05k3xB4oVicStagKfwsEGixwwY7RsRkGj5Usu/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749162954; c=relaxed/simple;
	bh=ZvnpnSmG+oC7aGXomrAbDIbTgw/N5uw94jdE1VzTMQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=giCOerxFUvQKb2qTZXkeDv8IjcgGI/LDjKzdDdg9vMCGFYo6H/eD23OhlWy28esKCkk3yF0UoKVMGVAmhYl1Z4T2AXZ92u8AuVmQP9fvMwWOfnHi5B7qL0+bECy2bzddDWrNrUM9X5iymwSVOmC7/GeuGsXhe+FeL9NFZvKbtSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MYBBilFv; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234fedd3e51so13909635ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 15:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749162952; x=1749767752; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9TxNW5dV0RBRL9s3nKbXzPx5whc6jarKAXvdKWRe0X0=;
        b=MYBBilFvTa8Fu2nhzOQmRtpD3hU6MH1XYZ0+zuBmUcflbiZPObkpNzi7wcT+J87syp
         kx80IH/vDWb/mEp6FcSDjRO4pbQXrapsKH+bOQicHElnqgacaNa1Evpk+lseOa3ufeJV
         vaAekD/7MEYd6o3QJe5JhrHNpPG7DV2EhqQWS9UIk1JIE/mSuKS7lS7nAY5jMAnwKTVL
         QhLmo/qLygGYZE/0AMH0LlzuvBKg088kFk7F7rpQvGleZJZr9JSr/H6/AEcX8hknKruC
         SpaoVdJBnQ3jWW3tdRXrho1SaEpUJM1vzIKeV8WMwSM0WLHR+nDCiCEeKM5AhFPNHfwm
         YrMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749162952; x=1749767752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9TxNW5dV0RBRL9s3nKbXzPx5whc6jarKAXvdKWRe0X0=;
        b=ML0TmvYgMv+Hh9z5bJkHTPIVgf/am0FaV1OAJXk6Kg7+08fTel4kMnUk6BdtUeHZIf
         80BDx3Qb5DRsO5NU7aWrvrG1KuoyJZrGfDT8KLTVpRYpXf0diujzYgEMTdM2wGthQIXG
         Mt7vHl1pCv4I6uiMaEwdpZh3URTAGvb8F+rIgzjHyUqCRo1hlFLDl04xuV9jqJ8PWACh
         nbTu6bD00tnEdzJRCKnRTdFfUxNhMxbfb1zsd6LAvtQPW55z3G8ZK7COKeYM0vhkaY7r
         xwJj2EJujlmcmhe5isz24wxQBRRf+K0HaKOb/l2qmVdVVtikV4imRz3/sOS6Jyr6Ky/f
         hJKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0CEKZeWcpFQQVMHE6hckx4gMgjcWaNDAKwTiU4BtShO2/qPKpBe98YfhQ2Xjwr2BOIY8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBZqUxSo1SQ08Pyt3mMY50VrN1d+TUO5ENUq68L6oaLWkp3e3Q
	gAM2iWSsG2KdN2pQBWKd085N60j3uJeoBVCMSQjWtnNCzTZbTMVpL6RaeXK4EAfCuTztwAZrxZI
	MBKUxPP3cvdHldVMtxn0/G4jUpg==
X-Google-Smtp-Source: AGHT+IGlG5GJ1HWNqo+cjnvtR5V5f1+eVyk1XUgcOxIutpy7rwoGgHN0Md/IxRkLf4knx+Y7AQXHsdQ9oJBjT22yCg==
X-Received: from plbba6.prod.google.com ([2002:a17:902:7206:b0:234:a0aa:5b34])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:228e:b0:235:1962:1c13 with SMTP id d9443c01a7336-23601d01c97mr14211395ad.14.1749162952062;
 Thu, 05 Jun 2025 15:35:52 -0700 (PDT)
Date: Thu, 05 Jun 2025 15:35:50 -0700
In-Reply-To: <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com>
Message-ID: <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: vannapurve@google.com, pbonzini@redhat.com, seanjc@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kirill.shutemov@intel.com, 
	tabba@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
>> Hi Yan,
>> 
>> While working on the 1G (aka HugeTLB) page support for guest_memfd
>> series [1], we took into account conversion failures too. The steps are
>> in kvm_gmem_convert_range(). (It might be easier to pull the entire
>> series from GitHub [2] because the steps for conversion changed in two
>> separate patches.)
> ...
>> [2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
>
> Hi Ackerley,
> Thanks for providing this branch.

Here's the WIP branch [1], which I initially wasn't intending to make
super public since it's not even RFC standard yet and I didn't want to
add to the many guest_memfd in-flight series, but since you referred to
it, [2] is a v2 of the WIP branch :)

[1] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept
[2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2

This WIP branch has selftests that test 1G aka HugeTLB page support with
TDX huge page EPT mappings [7]:

1. "KVM: selftests: TDX: Test conversion to private at different
   sizes". This uses the fact that TDX module will return error if the
   page is faulted into the guest at a different level from the accept
   level to check the level that the page was faulted in.
2. "KVM: selftests: Test TDs in private_mem_conversions_test". Updates
   private_mem_conversions_test for use with TDs. This test does
   multi-vCPU conversions and we use this to check for issues to do with
   conversion races.
3. "KVM: selftests: TDX: Test conversions when guest_memfd used for
   private and shared memory". Adds a selftest similar to/on top of
   guest_memfd_conversions_test that does conversions via MapGPA.

Full list of selftests I usually run from tools/testing/selftests/kvm:

+ ./guest_memfd_test
+ ./guest_memfd_conversions_test
+ ./guest_memfd_provide_hugetlb_cgroup_mount.sh ./guest_memfd_wrap_test_check_hugetlb_reporting.sh ./guest_memfd_test
+ ./guest_memfd_provide_hugetlb_cgroup_mount.sh ./guest_memfd_wrap_test_check_hugetlb_reporting.sh ./guest_memfd_conversions_test
+ ./guest_memfd_provide_hugetlb_cgroup_mount.sh ./guest_memfd_wrap_test_check_hugetlb_reporting.sh ./guest_memfd_hugetlb_reporting_test
+ ./x86/private_mem_conversions_test.sh
+ ./set_memory_region_test
+ ./x86/private_mem_kvm_exits_test
+ ./x86/tdx_vm_test
+ ./x86/tdx_upm_test
+ ./x86/tdx_shared_mem_test
+ ./x86/tdx_gmem_private_and_shared_test

As an overview for anyone who might be interested in this WIP branch:

1.  I started with upstream's kvm/next
2.  Applied TDX selftests series [3]
3.  Applied guest_memfd mmap series [4]
4.  Applied conversions (sub)series and HugeTLB (sub)series [5]
5.  Added some fixes for 2 of the earlier series (as labeled in commit
    message)
6.  Updated guest_memfd conversions selftests to work with TDX
7.  Applied 2M EPT series [6] with some hacks
8.  Some patches to make guest_memfd mmap return huge-page-aligned
    userspace address
9.  Selftests for guest_memfd conversion with TDX 2M EPT

[3] https://lore.kernel.org/all/20250414214801.2693294-1-sagis@google.com/
[4] https://lore.kernel.org/all/20250513163438.3942405-11-tabba@google.com/T/
[5] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
[6] https://lore.kernel.org/all/Z%2FOMB7HNO%2FRQyljz@yzhao56-desk.sh.intel.com/
[7] https://lore.kernel.org/all/20250424030033.32635-1-yan.y.zhao@intel.com/

>
> I'm now trying to make TD huge pages working on this branch and would like to
> report to you errors I encountered during this process early.
>
> 1. symbol arch_get_align_mask() is not available when KVM is compiled as module.
>    I currently workaround it as follows:
>
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -102,8 +102,13 @@ static unsigned long kvm_gmem_get_align_mask(struct file *file,
>         void *priv;
>
>         inode = file_inode(file);
> -       if (!kvm_gmem_has_custom_allocator(inode))
> -             return arch_get_align_mask(file, flags);
> +       if (!kvm_gmem_has_custom_allocator(inode)) {
> +               page_size = 1 << PAGE_SHIFT;
> +               return PAGE_MASK & (page_size - 1);
> +       }
>
>

Thanks, will fix in the next revision.

> 2. Bug of Sleeping function called from invalid context 
>
> [  193.523469] BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:325
> [  193.539885] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3332, name: guest_memfd_con
> [  193.556235] preempt_count: 1, expected: 0
> [  193.564518] RCU nest depth: 0, expected: 0
> [  193.572866] 3 locks held by guest_memfd_con/3332:
> [  193.581800]  #0: ff16f8ec217e4438 (sb_writers#14){.+.+}-{0:0}, at: __x64_sys_fallocate+0x46/0x80
> [  193.598252]  #1: ff16f8fbd85c8310 (mapping.invalidate_lock#4){++++}-{4:4}, at: kvm_gmem_fallocate+0x9e/0x310 [kvm]
> [  193.616706]  #2: ff3189b5e4f65018 (&(kvm)->mmu_lock){++++}-{3:3}, at: kvm_gmem_invalidate_begin_and_zap+0x17f/0x260 [kvm]
> [  193.635790] Preemption disabled at:
> [  193.635793] [<ffffffffc0850c6f>] kvm_gmem_invalidate_begin_and_zap+0x17f/0x260 [kvm]
>
> This is because add_to_invalidated_kvms() invokes kzalloc() inside kvm->mmu_lock
> which is a kind of spinlock.
>
> I workarounded it as follows.
>
>  static int kvm_gmem_invalidate_begin_and_zap(struct kvm_gmem *gmem,
>                                              pgoff_t start, pgoff_t end,
> @@ -1261,13 +1268,13 @@ static int kvm_gmem_invalidate_begin_and_zap(struct kvm_gmem *gmem,
>                         KVM_MMU_LOCK(kvm);
>                         kvm_mmu_invalidate_begin(kvm);
>
> -                       if (invalidated_kvms) {
> -                               ret = add_to_invalidated_kvms(invalidated_kvms, kvm);
> -                               if (ret) {
> -                                       kvm_mmu_invalidate_end(kvm);
> -                                       goto out;
> -                               }
> -                       }
>                 }
>
>
> @@ -1523,12 +1530,14 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>         }
>
>  out:
> -       list_for_each_entry_safe(entry, tmp, &invalidated_kvms, list) {
> -               kvm_gmem_do_invalidate_end(entry->kvm);
> -               list_del(&entry->list);
> -               kfree(entry);
> -       }
> +       list_for_each_entry(gmem, gmem_list, entry)
> +               kvm_gmem_do_invalidate_end(gmem->kvm);
>
>         filemap_invalidate_unlock(inode->i_mapping);
>
>

I fixed this in WIP series v2 by grouping splitting with
unmapping. Please see this commit [8], the commit message includes an
explanation of what's done.

[8] https://github.com/googleprodkernel/linux-cc/commit/fd27635e5209b5e45a628d7fcf42a17a2b3c7e78

> Will let you know more findings later.
>
> Thanks
> Yan

