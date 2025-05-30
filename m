Return-Path: <kvm+bounces-48091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35E6DAC8A39
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 10:54:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC33617973A
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 08:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F24421CA0A;
	Fri, 30 May 2025 08:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ITvpNzTN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283DA21ADD3
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 08:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748595239; cv=none; b=g55deKqu1Yhyv7Luq3l0+EdeKMWT+zr3yjYOf7d1PgOmLs0C0Yc1kI6kmsN92hn5QkzCBq9MdvxC2evvuDZPtqhuAb70Hc6oiMs4TBftPeY8t0Xy+8+mBJXm5FiE0atE2fuqtBNq6HpHLg1rVcw6UN8SH1iQ5H3LHAplEB0pwlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748595239; c=relaxed/simple;
	bh=trVd84a33ivYKAJg9TE37WT5ARtue713nOBQM6WgbLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pq/Cmm6VVr6ueodcJvFD5MBQHD62Hm4QCDZ2O1cuhkYzdTQjDiTt4eNkPFiW3OrqH6KZ5ZGvJcByUdtjA7tl+ygW7spD9eNGXrnYcB+u7rIWk4o3F9zRA0JnkPZLFPbUQ6dcNL9jJWjifrXf9TaZJJVDfYfEuqY6CiYLLfKfZRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ITvpNzTN; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-47e9fea29easo235451cf.1
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 01:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748595237; x=1749200037; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z8u647ndNYzdA27OG8TNeuQiC3z4GVpVKrED4QXwYPU=;
        b=ITvpNzTN8/Q4CtxRafoLinx+/KF6kS8u02MT2vw16dhtJpjjS1iQ39KS9+1TLfpul5
         E/KbvmaDazMOkC68YhavXUDeK4m8LWKO5AH0NUQ5DDZ1kchh0k6wauZtImivv++jTsem
         OYn7bGQAM0E4MN832r16WaIWdUtV8ubXNRJ97tjIKl4jzHBo91wF9E3Xf+TeGfunaWjI
         ALGBP7OEoC3Hl8+0jMVX4+V1zMuRzBerablzATIcP4Te0piRx3Qe3WNbqIHWm1iOWoLE
         n8x/w/0sM5XFe0xl3FAwC1+CPVrNO34jPaPz+urfaCxB+GJBrGJf+5ZHoSoQ6CWBD7uh
         iolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748595237; x=1749200037;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z8u647ndNYzdA27OG8TNeuQiC3z4GVpVKrED4QXwYPU=;
        b=uvAc7Xx88UIt4u9sCBlXkpt6xVQWB1wFg06SZcJyw9dkIqwOb1jdU7L0Yj5SpPaTZW
         lph8dD3ZiDU2GZY+zER2qqfOpZOOIiqhhrxn/z06CZhxA0Zc/YRlaWBo+trIJlibDx5k
         qJtP40Ex7U3rpRCHQUhQwzqNTHgLtrox0OBaSgDqU9EsnLogBn42/p/FbEiYow4EdMIt
         dId0iJd3uOXY6Kg5Fkn+Hn7sRD0p/TMT4+i9kAkg1YLU5vsupvvdl5i+n/8b4NWS2WLs
         qU3WNhlGKHoVzMdekrA7vgWubbXG8aBnDQrndp3o3uM7NmLapQ7hoPslJ0+2B8IjbxED
         WTlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtQKG2nf3nh/9FRpM2uam+V+mJRpwecRK3FMo8qhNPNQKKXQKB6p0SVYHGhWc787pVcfA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXh/w9ru9MdMTbe4F8npmhmIVhCxD9zkVWkaWJFmBvKaN9YWr0
	6O0Mo5HHPCKCLMuHjHT8OnCDGRDHOoN0xDZ3jsDSt8gFXVM36Ugnx3TgL2gMgHVsqhnuR/xof5W
	Ss+k7sxB1Lbsz77uIyjkWOvgjrkcjkdHUZgwVGJzP
X-Gm-Gg: ASbGncsfQkjYLsAvwvhKvKvkVTvFU409qpKVVpTxRv5yaV18MKHVABX562LuxNE2nN9
	b1R+SHxtuzr89LeOC9Y6bfGHCW8eCKeeL2Ar8c3OH1mg+AC2wa5UJljWLN1V1IJbfkY0+E0W/WL
	2ILEne7XscNib8+FQPI8DpgjVjSOQOEc68eTIxeCOS7Mc=
X-Google-Smtp-Source: AGHT+IFLqefnLn1v8keLkqAr4fPJAQHT//B+kwFb1ekkisV3CdeatG99dSsPZYAGw8By1B8I2vAaTr2y3/hbj85CkGA=
X-Received: by 2002:a05:622a:1a97:b0:494:b4dd:befd with SMTP id
 d75a77b69052e-4a441022360mr2905721cf.8.1748595236277; Fri, 30 May 2025
 01:53:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aDU3eL7qQYrXkE3T@yzhao56-desk.sh.intel.com>
In-Reply-To: <aDU3eL7qQYrXkE3T@yzhao56-desk.sh.intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 30 May 2025 09:53:19 +0100
X-Gm-Features: AX0GCFtqJXvp3p__kKdA5QDGvH461bYPNLmsSSbQFbO1K64Y28pB97ucjguB0DU
Message-ID: <CA+EHjTxgO4LmdYY83a+uzBshvFf8EcJzY58Rovvz=pZgyO2yow@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, linux-fsdevel@vger.kernel.org, 
	aik@amd.com, ajones@ventanamicro.com, akpm@linux-foundation.org, 
	amoorthy@google.com, anthony.yznaga@oracle.com, anup@brainfault.org, 
	aou@eecs.berkeley.edu, bfoster@redhat.com, binbin.wu@linux.intel.com, 
	brauner@kernel.org, catalin.marinas@arm.com, chao.p.peng@intel.com, 
	chenhuacai@kernel.org, dave.hansen@intel.com, david@redhat.com, 
	dmatlack@google.com, dwmw@amazon.co.uk, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, graf@amazon.com, haibo1.xu@intel.com, 
	hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, thomas.lendacky@amd.com, 
	usama.arif@bytedance.com, vannapurve@google.com, vbabka@suse.cz, 
	viro@zeniv.linux.org.uk, vkuznets@redhat.com, wei.w.wang@intel.com, 
	will@kernel.org, willy@infradead.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi,

.. snip..

> I noticed that in [1], the kvm_gmem_mmap() does not check the range.
> So, the WARN() here can be hit when userspace mmap() an area larger than the
> inode size and accesses the out of band HVA.
>
> Maybe limit the mmap() range?
>
> @@ -1609,6 +1620,10 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>         if (!kvm_gmem_supports_shared(file_inode(file)))
>                 return -ENODEV;
>
> +       if (vma->vm_end - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT) > i_size_read(file_inode(file)))
> +               return -EINVAL;
> +
>         if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>             (VM_SHARED | VM_MAYSHARE)) {
>                 return -EINVAL;
>
> [1] https://lore.kernel.org/all/20250513163438.3942405-8-tabba@google.com/

I don't think we want to do that for a couple of reasons. We catch
such invalid accesses on faulting, and, by analogy, afaikt, neither
secretmem nor memfd perform a similar check on mmap (nor do
memory-mapped files in general).

There are also valid reasons why a user would want to deliberately
mmap more memory than the backing store, knowing that it's only going
to fault what it's going to use, e.g., alignment.

Cheers,
/fuad


> > +     return xa_to_value(entry);
> > +}
> > +
> > +static struct folio *kvm_gmem_get_shared_folio(struct inode *inode, pgoff_t index)
> > +{
> > +     if (kvm_gmem_shareability_get(inode, index) != SHAREABILITY_ALL)
> > +             return ERR_PTR(-EACCES);
> > +
> > +     return kvm_gmem_get_folio(inode, index);
> > +}
> > +
> > +#else
> > +
> > +static int kvm_gmem_shareability_setup(struct maple_tree *mt, loff_t size, u64 flags)
> > +{
> > +     return 0;
> > +}
> > +
> > +static inline struct folio *kvm_gmem_get_shared_folio(struct inode *inode, pgoff_t index)
> > +{
> > +     WARN_ONCE("Unexpected call to get shared folio.")
> > +     return NULL;
> > +}
> > +
> > +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> > +
> >  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >                                   pgoff_t index, struct folio *folio)
> >  {
> > @@ -333,7 +404,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> >
> >       filemap_invalidate_lock_shared(inode->i_mapping);
> >
> > -     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     folio = kvm_gmem_get_shared_folio(inode, vmf->pgoff);
> >       if (IS_ERR(folio)) {
> >               int err = PTR_ERR(folio);
> >
> > @@ -420,8 +491,33 @@ static struct file_operations kvm_gmem_fops = {
> >       .fallocate      = kvm_gmem_fallocate,
> >  };
> >
> > +static void kvm_gmem_free_inode(struct inode *inode)
> > +{
> > +     struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
> > +
> > +     kfree(private);
> > +
> > +     free_inode_nonrcu(inode);
> > +}
> > +
> > +static void kvm_gmem_destroy_inode(struct inode *inode)
> > +{
> > +     struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
> > +
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +     /*
> > +      * mtree_destroy() can't be used within rcu callback, hence can't be
> > +      * done in ->free_inode().
> > +      */
> > +     if (private)
> > +             mtree_destroy(&private->shareability);
> > +#endif
> > +}
> > +
> >  static const struct super_operations kvm_gmem_super_operations = {
> >       .statfs         = simple_statfs,
> > +     .destroy_inode  = kvm_gmem_destroy_inode,
> > +     .free_inode     = kvm_gmem_free_inode,
> >  };
> >
> >  static int kvm_gmem_init_fs_context(struct fs_context *fc)
> > @@ -549,12 +645,26 @@ static const struct inode_operations kvm_gmem_iops = {
> >  static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
> >                                                     loff_t size, u64 flags)
> >  {
> > +     struct kvm_gmem_inode_private *private;
> >       struct inode *inode;
> > +     int err;
> >
> >       inode = alloc_anon_secure_inode(kvm_gmem_mnt->mnt_sb, name);
> >       if (IS_ERR(inode))
> >               return inode;
> >
> > +     err = -ENOMEM;
> > +     private = kzalloc(sizeof(*private), GFP_KERNEL);
> > +     if (!private)
> > +             goto out;
> > +
> > +     mt_init(&private->shareability);
> Wrap the mt_init() inside "#ifdef CONFIG_KVM_GMEM_SHARED_MEM" ?
>
> > +     inode->i_mapping->i_private_data = private;
> > +
> > +     err = kvm_gmem_shareability_setup(private, size, flags);
> > +     if (err)
> > +             goto out;
> > +
> >       inode->i_private = (void *)(unsigned long)flags;
> >       inode->i_op = &kvm_gmem_iops;
> >       inode->i_mapping->a_ops = &kvm_gmem_aops;
> > @@ -566,6 +676,11 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
> >       WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> >
> >       return inode;
> > +
> > +out:
> > +     iput(inode);
> > +
> > +     return ERR_PTR(err);
> >  }
> >
> >  static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
> > @@ -654,6 +769,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >       if (kvm_arch_vm_supports_gmem_shared_mem(kvm))
> >               valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> >
> > +     if (flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED)
> > +             valid_flags |= GUEST_MEMFD_FLAG_INIT_PRIVATE;
> > +
> >       if (flags & ~valid_flags)
> >               return -EINVAL;
> >
> > @@ -842,6 +960,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >       if (!file)
> >               return -EFAULT;
> >
> > +     filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> > +
> >       folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> >       if (IS_ERR(folio)) {
> >               r = PTR_ERR(folio);
> > @@ -857,8 +977,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >               *page = folio_file_page(folio, index);
> >       else
> >               folio_put(folio);
> > -
> >  out:
> > +     filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
> >       fput(file);
> >       return r;
> >  }
> > --
> > 2.49.0.1045.g170613ef41-goog
> >
> >

