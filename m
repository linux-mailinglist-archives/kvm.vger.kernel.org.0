Return-Path: <kvm+bounces-49274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFAAAD748D
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 16:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AED5B18998E3
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 14:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C14025A331;
	Thu, 12 Jun 2025 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HONrkpFf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA0925393B
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749739440; cv=none; b=L4IDAuCPN5aFsnEErb0OrKPHr9FyMfpVe4nbf4N02MtHhebfTLHMVO0pmsThjMqpIYkQ3v7yU2H7nRCHWPzl9UXa/deYaL7NcuYlUtSy1v6UqX/sAUFFAN9s/mO3kNW7E78MBtj956ujcETE0t5mR82znrg2xFwl3SHbMVthr2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749739440; c=relaxed/simple;
	bh=Rkm3+v3Yxu0W/sz8x69bBcz7rS1lWbwdMzunVivz1kA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jp/WDtCirgGLwxUUrgv8WNjLZRdyhnHd8/JrW9A6aq+T70JrLfjs15Kp2FdzkzIBOYjCJTy/CcwDwfldngO+q46HAW4YuD9AyAV9mglw4xkmb/7SofdV+2XrDKfS2k5fqQRh+ZKoxTU9S/7R/C0SlA9gJr4Vgw1GxPBA1p/1jGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HONrkpFf; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-235e389599fso212625ad.0
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 07:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749739438; x=1750344238; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oN6CHeaSqFkDgulddMIy2hQlkOrtNeXTtQB4Zu1fP+o=;
        b=HONrkpFf/1GI1Axs++TQnhOaepNQ7u+sGnBdxsjzMhPYSt29ibKNTYEC7DnYeDyA5z
         O45swGfUsM0gw2jArmKGPIO4rbGaDD5dduv7gred5h4SUmipU/qr3GTO0KCH2M7TY4pb
         Fx5+NctipNZiwMtwrtzT7IYEuPWaGFPIW7vjZalWhZBpwPhlbB9EUU8hgpvRwoXD+YS9
         K3Y8vfARIcOr5GsvQOuCyTToX/104rKv3wil0oIs5Iz1Id8aq/8yXbwCC0fqzlG7ab15
         Lgu2ACxcFg26S5EXpEAkcjwHTbqVV4wGrXulBn7nNRpE+GcIkjPVP297rOdE4SY8Ceo8
         YQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749739438; x=1750344238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oN6CHeaSqFkDgulddMIy2hQlkOrtNeXTtQB4Zu1fP+o=;
        b=ee0h6wbQyM6WaaUg24bJKtVVFQJUYzrffkHzCX6ZErW62skMbOCEiikO1HE5DYOafi
         8hqn++GLrChuZQiQ+6YhrB7G6P90loTr4uMDh4/QxxaARa56rdTdfSG6aAxQr8lCp6+z
         1drHClI8f0iNqabMSDsEkWWk3Gq63SFU7Kdgsg6C22BdJG8Za6ELRxfihbvYms50UdK2
         xLIyqEgNq5fcDTHAL9EUbOhmFUGOEXNtn54Il7O/bP8kmQqgicLWULeVrI/M4v/vR0Bl
         IYssPatugw3jqM4JI05er6LFwiPQg4owabEXvkVoR+FIrxVN0v8OI6JdPBKhRQqzp7aY
         zW1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWOJ2sgw4LgcJBO6Wh6DwG1Etc4VaSy5YhXnHHrbSqpWFB7NEcG4ch99+X2OMAU7NQXX9M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOBjyhiaYL5ggKZ5EIzi2jySilWfrm9remK4Xb02hSUckSQ2b5
	OhOdF/sXeOXr9Ccin3WThoB8LHnT9YSOttqMR4Y584aSBzZphBio5UG11L11wIjQyDltLl9iS4h
	NUf0YcanfEpVEisZg2mn9R8ZDszYFC8p4mlz2vCRg
X-Gm-Gg: ASbGncu2/kPwMaH5GvBtawOylraOl6+b+wmNjqHIuvBZZpdZ6/wusWAA9+lRUB52u33
	LhSX11cIo2FQVDtXKnX31LOQM5Nl7/PcLlLWBLjfGZ2rMlXUMMPofTZqecL5nPFZP8Mn6a2Tfsj
	kah+WDBPl0IuBDzb7ruq99s65Cgj9oKl4yHQdxjBlKmKP+EAbIC9meFcMcelLrlw2KYeCoIrqmC
	pRS
X-Google-Smtp-Source: AGHT+IHpiXzKeAtCO2stFoZ0moxEL5BG+uKUA7FqzPXE76Bh50p7p2GnAHbrdaAH4XoNw6cu2LSfRv2ByjGTRPF8taY=
X-Received: by 2002:a17:902:c402:b0:234:bfa1:da3e with SMTP id
 d9443c01a7336-2365bd03e64mr13635ad.5.1749739437338; Thu, 12 Jun 2025 07:43:57
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <diqzjz7azkmf.fsf@ackerleytng-ctop.c.googlers.com>
 <diqz8qmsfs5u.fsf@ackerleytng-ctop.c.googlers.com> <aC1221wU6Mby3Lo3@yzhao56-desk.sh.intel.com>
 <CAGtprH_chB5_D3ba=yqgg-ZGGE2ONpoMdB=4_O4S6k7jXcoHHw@mail.gmail.com>
 <aD5QVdH0pJeAn3+r@yzhao56-desk.sh.intel.com> <CAGtprH_XFpnBf_ZtEAs2MiZNJYhs4i+kJpmAj0QRVhcqWBqDsQ@mail.gmail.com>
 <aErK25Oo5VJna40z@yzhao56-desk.sh.intel.com>
In-Reply-To: <aErK25Oo5VJna40z@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 12 Jun 2025 07:43:45 -0700
X-Gm-Features: AX0GCFsBxXSxoI571qQ09Y-jDuWyjjNvY5Na7g5THwLq_OH-qmpD6FJcK1L4xBE
Message-ID: <CAGtprH8U7rKrnPFHrC_ppr0wx+G=tV+LZfYtueDMZy47U1Q80g@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, michael.roth@amd.com, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	jroedel@suse.de, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, amit.shah@amd.com, 
	pratikrajesh.sampat@amd.com, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, quic_eberman@quicinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 5:43=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Tue, Jun 03, 2025 at 11:28:35PM -0700, Vishal Annapurve wrote:
> > On Mon, Jun 2, 2025 at 6:34=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> =
wrote:
> > >
> > > On Mon, Jun 02, 2025 at 06:05:32PM -0700, Vishal Annapurve wrote:
> > > > On Tue, May 20, 2025 at 11:49=E2=80=AFPM Yan Zhao <yan.y.zhao@intel=
.com> wrote:
> > > > >
> > > > > On Mon, May 19, 2025 at 10:04:45AM -0700, Ackerley Tng wrote:
> > > > > > Ackerley Tng <ackerleytng@google.com> writes:
> > > > > >
> > > > > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > > > >
> > > > > > >> On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
> > > > > > >>> This patch would cause host deadlock when booting up a TDX =
VM even if huge page
> > > > > > >>> is turned off. I currently reverted this patch. No further =
debug yet.
> > > > > > >> This is because kvm_gmem_populate() takes filemap invalidati=
on lock, and for
> > > > > > >> TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(),=
 causing deadlock.
> > > > > > >>
> > > > > > >> kvm_gmem_populate
> > > > > > >>   filemap_invalidate_lock
> > > > > > >>   post_populate
> > > > > > >>     tdx_gmem_post_populate
> > > > > > >>       kvm_tdp_map_page
> > > > > > >>        kvm_mmu_do_page_fault
> > > > > > >>          kvm_tdp_page_fault
> > > > > > >>       kvm_tdp_mmu_page_fault
> > > > > > >>         kvm_mmu_faultin_pfn
> > > > > > >>           __kvm_mmu_faultin_pfn
> > > > > > >>             kvm_mmu_faultin_pfn_private
> > > > > > >>               kvm_gmem_get_pfn
> > > > > > >>                 filemap_invalidate_lock_shared
> > > > > > >>
> > > > > > >> Though, kvm_gmem_populate() is able to take shared filemap i=
nvalidation lock,
> > > > > > >> (then no deadlock), lockdep would still warn "Possible unsaf=
e locking scenario:
> > > > > > >> ...DEADLOCK" due to the recursive shared lock, since commit =
e918188611f0
> > > > > > >> ("locking: More accurate annotations for read_lock()").
> > > > > > >>
> > > > > > >
> > > > > > > Thank you for investigating. This should be fixed in the next=
 revision.
> > > > > > >
> > > > > >
> > > > > > This was not fixed in v2 [1], I misunderstood this locking issu=
e.
> > > > > >
> > > > > > IIUC kvm_gmem_populate() gets a pfn via __kvm_gmem_get_pfn(), t=
hen calls
> > > > > > part of the KVM fault handler to map the pfn into secure EPTs, =
then
> > > > > > calls the TDX module for the copy+encrypt.
> > > > > >
> > > > > > Regarding this lock, seems like KVM'S MMU lock is already held =
while TDX
> > > > > > does the copy+encrypt. Why must the filemap_invalidate_lock() a=
lso be
> > > > > > held throughout the process?
> > > > > If kvm_gmem_populate() does not hold filemap invalidate lock arou=
nd all
> > > > > requested pages, what value should it return after kvm_gmem_punch=
_hole() zaps a
> > > > > mapping it just successfully installed?
> > > > >
> > > > > TDX currently only holds the read kvm->mmu_lock in tdx_gmem_post_=
populate() when
> > > > > CONFIG_KVM_PROVE_MMU is enabled, due to both slots_lock and the f=
ilemap
> > > > > invalidate lock being taken in kvm_gmem_populate().
> > > >
> > > > Does TDX need kvm_gmem_populate path just to ensure SEPT ranges are
> > > > not zapped during tdh_mem_page_add and tdh_mr_extend operations? Wo=
uld
> > > > holding KVM MMU read lock during these operations sufficient to avo=
id
> > > > having to do this back and forth between TDX and gmem layers?
> > > I think the problem here is because in kvm_gmem_populate(),
> > > "__kvm_gmem_get_pfn(), post_populate(), and kvm_gmem_mark_prepared()"
> > > must be wrapped in filemap invalidate lock (shared or exclusive), rig=
ht?
> > >
> > > Then, in TDX's post_populate() callback, the filemap invalidate lock =
is held
> > > again by kvm_tdp_map_page() --> ... ->kvm_gmem_get_pfn().
> >
> > I am contesting the need of kvm_gmem_populate path altogether for TDX.
> > Can you help me understand what problem does kvm_gmem_populate path
> > help with for TDX?
> There is a long discussion on the list about this.
>
> Basically TDX needs 3 steps for KVM_TDX_INIT_MEM_REGION.
> 1. Get the PFN
> 2. map the mirror page table
> 3. invoking tdh_mem_page_add().
> Holding filemap invalidation lock around the 3 steps helps ensure that th=
e PFN
> passed to tdh_mem_page_add() is a valid one.

Indulge me a bit here. If the above flow is modified as follows, will it wo=
rk?
1. Map the mirror page table
2. Hold the read mmu lock
3. Get the pfn from mirror page table walk
4. Invoke tdh_mem_page_add and mr_extend
5. drop the read mmu lock

If we can solve the initial memory region population this way for TDX
then at least for TDX:
1) Whole kvm_gmem_populate path is avoided
2) No modifications needed for the userspace-guest_memfd interaction
you suggested below.

>
> Rather then revisit it, what about fixing the contention more simply like=
 this?
> Otherwise we can revisit the history.
> (The code is based on Ackerley's branch
> https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-convers=
ions-hugetlb-2mept-v2, with patch "HACK: filemap_invalidate_lock() only for=
 getting the pfn" reverted).
>
>
> commit d71956718d061926e5d91e5ecf60b58a0c3b2bad
> Author: Yan Zhao <yan.y.zhao@intel.com>
> Date:   Wed Jun 11 18:17:26 2025 +0800
>
>     KVM: guest_memfd: Use shared filemap invalidate lock in kvm_gmem_popu=
late()
>
>     Convert kvm_gmem_populate() to use shared filemap invalidate lock. Th=
is is
>     to avoid deadlock caused by kvm_gmem_populate() further invoking
>     tdx_gmem_post_populate() which internally acquires shared filemap
>     invalidate lock in kvm_gmem_get_pfn().
>
>     To avoid lockep warning by nested shared filemap invalidate lock,
>     avoid holding shared filemap invalidate lock in kvm_gmem_get_pfn() wh=
en
>     lockdep is enabled.
>
>     Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 784fc1834c04..ccbb7ceb978a 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -2393,12 +2393,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_=
memory_slot *slot,
>         struct file *file =3D kvm_gmem_get_file(slot);
>         struct folio *folio;
>         bool is_prepared =3D false;
> +       bool get_shared_lock;
>         int r =3D 0;
>
>         if (!file)
>                 return -EFAULT;
>
> -       filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> +       get_shared_lock =3D !IS_ENABLED(CONFIG_LOCKDEP) ||
> +                         !lockdep_is_held(&file_inode(file)->i_mapping->=
invalidate_lock);
> +       if (get_shared_lock)
> +               filemap_invalidate_lock_shared(file_inode(file)->i_mappin=
g);
>
>         folio =3D __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared=
, max_order);
>         if (IS_ERR(folio)) {
> @@ -2423,7 +2427,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_me=
mory_slot *slot,
>         else
>                 folio_put(folio);
>  out:
> -       filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
> +       if (get_shared_lock)
> +               filemap_invalidate_unlock_shared(file_inode(file)->i_mapp=
ing);
>         fput(file);
>         return r;
>  }
> @@ -2536,7 +2541,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start=
_gfn, void __user *src, long
>         if (!file)
>                 return -EFAULT;
>
> -       filemap_invalidate_lock(file->f_mapping);
> +       filemap_invalidate_lock_shared(file->f_mapping);
>
>         npages =3D min_t(ulong, slot->npages - (start_gfn - slot->base_gf=
n), npages);
>         for (i =3D 0; i < npages; i +=3D npages_to_populate) {
> @@ -2587,7 +2592,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start=
_gfn, void __user *src, long
>                         break;
>         }
>
> -       filemap_invalidate_unlock(file->f_mapping);
> +       filemap_invalidate_unlock_shared(file->f_mapping);
>
>         fput(file);
>         return ret && !i ? ret : i;
>
>
> If it looks good to you, then for the in-place conversion version of
> guest_memfd, there's one remaining issue left: an AB-BA lock issue betwee=
n the
> shared filemap invalidate lock and mm->mmap_lock, i.e.,
> - In path kvm_gmem_fault_shared(),
>   the lock sequence is mm->mmap_lock --> filemap_invalidate_lock_shared()=
,
> - while in path kvm_gmem_populate(),
>   the lock sequence is filemap_invalidate_lock_shared() -->mm->mmap_lock.
>
> We can fix it with below patch. The downside of the this patch is that it
> requires userspace to initialize all source pages passed to TDX, which I'=
m not
> sure if everyone likes it. If it cannot land, we still have another optio=
n:
> disallow the initial memory regions to be backed by the in-place conversi=
on
> version of guest_memfd. If this can be enforced, then we can resolve the =
issue
> by annotating the lockdep, indicating that kvm_gmem_fault_shared() and
> kvm_gmem_populate() cannot occur on the same guest_memfd, so the two shar=
ed
> filemap invalidate locks in the two paths are not the same.
>
> Author: Yan Zhao <yan.y.zhao@intel.com>
> Date:   Wed Jun 11 18:23:00 2025 +0800
>
>     KVM: TDX: Use get_user_pages_fast_only() in tdx_gmem_post_populate()
>
>     Convert get_user_pages_fast() to get_user_pages_fast_only()
>     in tdx_gmem_post_populate().
>
>     Unlike get_user_pages_fast(), which will acquire mm->mmap_lock and fa=
ult in
>     physical pages after it finds the pages have not already faulted in o=
r have
>     been zapped/swapped out, get_user_pages_fast_only() returns directly =
in
>     such cases.
>
>     Using get_user_pages_fast_only() can avoid tdx_gmem_post_populate()
>     acquiring mm->mmap_lock, which may cause AB, BA lockdep warning with =
the
>     shared filemap invalidate lock when guest_memfd in-place conversion i=
s
>     supported. (In path kvm_gmem_fault_shared(), the lock sequence is
>     mm->mmap_lock --> filemap_invalidate_lock_shared(), while in path
>     kvm_gmem_populate(), the lock sequence is filemap_invalidate_lock_sha=
red()
>     -->mm->mmap_lock).
>
>     Besides, using get_user_pages_fast_only() and returning directly to
>     userspace if a page is not present in the primary PTE can help detect=
 a
>     careless case that the source pages are not initialized by userspace.
>     As initial memory region bypasses guest acceptance, copying an
>     uninitialized source page to guest could be harmful and undermine the=
 page
>     measurement.
>
>     Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 93c31eecfc60..462390dddf88 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3190,9 +3190,10 @@ static int tdx_gmem_post_populate_4k(struct kvm *k=
vm, gfn_t gfn, kvm_pfn_t pfn,
>          * Get the source page if it has been faulted in. Return failure =
if the
>          * source page has been swapped out or unmapped in primary memory=
.
>          */
> -       ret =3D get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> +       ret =3D get_user_pages_fast_only((unsigned long)src, 1, 0, &src_p=
age);
>         if (ret < 0)
>                 return ret;
> +
>         if (ret !=3D 1)
>                 return -ENOMEM;
>

