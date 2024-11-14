Return-Path: <kvm+bounces-31826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CB19C7F25
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 01:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 279DB1F2275F
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 00:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C736846BF;
	Thu, 14 Nov 2024 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uuap7bAX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5549B566A
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 00:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543250; cv=none; b=Sn/LM0ibLG6fey8SrJFSpWcUm6bvK1Lu/yxy5g9RJol97kgyMUNigoCUL9C5V9wMMF2mGpshp2AXpnKJK9JKTXqY36S8oDpuPD4fpNQEoDpz2e1PlmDygNE3C3svDmbySxedvvTapxl79y2NqjTLgA3RZ4P8V8TidfS8mJChyBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543250; c=relaxed/simple;
	bh=Fjs8VpEmXUt6iO23GOaHv975z0fKszxrrhrkRyYsWZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pc6v/lK8+1qsb4Xt3YaRwodbNUFI5OPsUn0EQwfJ3gwXMlbeGtWVNEMpLjzKpxEaUMLuinuBO+vdpVTzap9Qd2RqbF4RhHoepesXYXDx00lnrjL4XpkgAn7EAJkg1b8awX1VSNiMSBEdSblzxOrG+gdt+qDB/RkDBa5T/otDc5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uuap7bAX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7f712829f05so1415178a12.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 16:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731543248; x=1732148048; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YG6vDBku7kMpeHZSi1IzY0q9n0Nu+10g7LnoUPeeLH8=;
        b=Uuap7bAXnOoRLIC99apdLtOwUdvI7RFqDCIdNozbQrbz1SrFPfWzRLuUGtG8gupC1q
         0wv/nmYBeulUgmwRkU4Mkauh+vxPZiJbgKvhzWZ4cJwJgL5xrWbHVGs7p0Ik99fKhxus
         JH4pPFtMrISOnSAhRuIFs5O74ia1Ok0reii/2nXG+GL6TUD+NDI5BYYBNV0mUr4XNBs6
         ToDNYYaItAmMGfO5NTElLSLL6Lg1ToePtTzzg47GqANqx3M8s3dG5BGZZ4ImSro5R31W
         iRWbZkcGX1dGsOQEAsbVLgUQ5bscbMRdLym3jiWQloNIK1PTE3BDhUA62n/jIHawn3Wx
         8RKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731543248; x=1732148048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YG6vDBku7kMpeHZSi1IzY0q9n0Nu+10g7LnoUPeeLH8=;
        b=EtGw/ddvOXbiSc3pTaN7nv1qjDoVC/2D+ACXYH9rK0wZ+Pw1xDeXhbBX2XxR0icRV3
         4g8RNg79aWZtqgINDfRpb7zeOvhcloNyGt7F7rCyYp3FR9w2+VeRI/TLcIxy+FxsFeBd
         Ze10CVjdnaG1wQwPszwJNOBzayxn3gUjL9qVkkzE8zfiLdGnTL7l3I1568wGDPhE/R7c
         jRDaehIDTZiy/patWr8uitpC3pbV/7vGE0ujX+6wXD3dG7uVAnAZeZvmovRAuGBYT3u1
         izv8T40H4zu+6K6H4kGqrBDyT2d1qo9xgFs8Su51A6sBJHqeDho8bGqpUdzTnWgEI8Fd
         oTYg==
X-Forwarded-Encrypted: i=1; AJvYcCWELKMw9YMVHB7QHLobB1MWi9UmN8Qgn4svi/QpXPUTXK3tM4cAVq3ODwD3h5JTaKfy16w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDg49FOsxvRKpDQFdwem5DTsfz4Md5IA82PavtNMg9ypox9cdA
	q7tLdeim4y88s6TCMjdsdZLrUo3F12k/ePLMADiw6sB8CFx6vulh7bJ2mrnyPOv8ezcVSXjQVVd
	XdQ==
X-Google-Smtp-Source: AGHT+IGZMQ7d8FpvW2bgMLdn/MljHJen2J/r3edwH0bkQQHKdtX1wOgkU5/8fa6SpxEOLLapwoaKKz8/jy8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:c602:b0:20c:bb19:d2ce with SMTP id
 d9443c01a7336-21183586702mr507345ad.8.1731543247464; Wed, 13 Nov 2024
 16:14:07 -0800 (PST)
Date: Wed, 13 Nov 2024 16:14:05 -0800
In-Reply-To: <20241108155056.332412-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108155056.332412-1-pbonzini@redhat.com> <20241108155056.332412-2-pbonzini@redhat.com>
Message-ID: <ZzVAzc3rVTW9OCJP@google.com>
Subject: Re: [PATCH 1/3] KVM: gmem: allocate private data for the gmem inode
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com
Content-Type: text/plain; charset="us-ascii"

+Ackerley, who's also working on resurrecting the file system[*].  At a glance,
there appear to be non-trivial differences, e.g. Ackerley's version has a call
to security_inode_init_security_anon().  I've paged out much of the inode stuff,
so I trust Ackerley's judgment far, far more than my own :-)

[*] https://lore.kernel.org/all/d1940d466fc69472c8b6dda95df2e0522b2d8744.1726009989.git.ackerleytng@google.com

On Fri, Nov 08, 2024, Paolo Bonzini wrote:
> In preparation for removing the usage of the uptodate flag,
> reintroduce the gmem filesystem type.  We need it in order to
> free the private inode information.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/uapi/linux/magic.h |   1 +
>  virt/kvm/guest_memfd.c     | 117 +++++++++++++++++++++++++++++++++----
>  virt/kvm/kvm_main.c        |   7 ++-
>  virt/kvm/kvm_mm.h          |   8 ++-
>  4 files changed, 119 insertions(+), 14 deletions(-)
> 
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index bb575f3ab45e..d856dd6a7ed9 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -103,5 +103,6 @@
>  #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
>  #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
>  #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
> +#define KVM_GUEST_MEM_MAGIC	0x474d454d	/* "GMEM" */
>  
>  #endif /* __LINUX_MAGIC_H__ */
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 8f079a61a56d..3ea5a7597fd4 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,9 +4,74 @@
>  #include <linux/kvm_host.h>
>  #include <linux/pagemap.h>
>  #include <linux/anon_inodes.h>
> +#include <linux/pseudo_fs.h>
>  
>  #include "kvm_mm.h"
>  
> +/* Do all the filesystem crap just for evict_inode... */
> +
> +static struct vfsmount *kvm_gmem_mnt __read_mostly;
> +
> +static void gmem_evict_inode(struct inode *inode)
> +{
> +	kvfree(inode->i_private);
> +	truncate_inode_pages_final(&inode->i_data);
> +	clear_inode(inode);
> +}
> +
> +static const struct super_operations gmem_super_operations = {
> +	.drop_inode	= generic_delete_inode,
> +	.evict_inode    = gmem_evict_inode,
> +	.statfs         = simple_statfs,
> +};
> +
> +static int gmem_init_fs_context(struct fs_context *fc)
> +{
> +	struct pseudo_fs_context *ctx = init_pseudo(fc, KVM_GUEST_MEM_MAGIC);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ctx->ops = &gmem_super_operations;
> +	return 0;
> +}
> +
> +static struct file_system_type kvm_gmem_fs_type = {
> +	.name           = "kvm_gmemfs",
> +	.init_fs_context = gmem_init_fs_context,
> +	.kill_sb        = kill_anon_super,
> +};
> +
> +static struct file *kvm_gmem_create_file(const char *name, const struct file_operations *fops)
> +{
> +	struct inode *inode;
> +	struct file *file;
> +
> +	if (fops->owner && !try_module_get(fops->owner))
> +		return ERR_PTR(-ENOENT);
> +
> +	inode = alloc_anon_inode(kvm_gmem_mnt->mnt_sb);
> +	if (IS_ERR(inode)) {
> +		file = ERR_CAST(inode);
> +		goto err;
> +	}
> +	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, fops);
> +	if (IS_ERR(file))
> +		goto err_iput;
> +
> +	return file;
> +
> +err_iput:
> +	iput(inode);
> +err:
> +	module_put(fops->owner);
> +	return file;
> +}
> +
> +
> +struct kvm_gmem_inode {
> +	unsigned long flags;
> +};
> +
>  struct kvm_gmem {
>  	struct kvm *kvm;
>  	struct xarray bindings;
> @@ -308,9 +373,31 @@ static struct file_operations kvm_gmem_fops = {
>  	.fallocate	= kvm_gmem_fallocate,
>  };
>  
> -void kvm_gmem_init(struct module *module)
> +int kvm_gmem_init(struct module *module)
>  {
> +	int ret;
> +
> +	ret = register_filesystem(&kvm_gmem_fs_type);
> +	if (ret) {
> +		pr_err("kvm-gmem: cannot register file system (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs_type);
> +	if (IS_ERR(kvm_gmem_mnt)) {
> +		pr_err("kvm-gmem: kernel mount failed (%ld)\n", PTR_ERR(kvm_gmem_mnt));
> +		return PTR_ERR(kvm_gmem_mnt);
> +	}
> +
>  	kvm_gmem_fops.owner = module;
> +
> +	return 0;
> +}
> +
> +void kvm_gmem_exit(void)
> +{
> +	kern_unmount(kvm_gmem_mnt);
> +	unregister_filesystem(&kvm_gmem_fs_type);
>  }
>  
>  static int kvm_gmem_migrate_folio(struct address_space *mapping,
> @@ -394,15 +481,23 @@ static const struct inode_operations kvm_gmem_iops = {
>  
>  static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  {
> -	const char *anon_name = "[kvm-gmem]";
> +	const char *gmem_name = "[kvm-gmem]";
> +	struct kvm_gmem_inode *i_gmem;
>  	struct kvm_gmem *gmem;
>  	struct inode *inode;
>  	struct file *file;
>  	int fd, err;
>  
> +	i_gmem = kvzalloc(sizeof(struct kvm_gmem_inode), GFP_KERNEL);
> +	if (!i_gmem)
> +		return -ENOMEM;
> +	i_gmem->flags = flags;
> +
>  	fd = get_unused_fd_flags(0);
> -	if (fd < 0)
> -		return fd;
> +	if (fd < 0) {
> +		err = fd;
> +		goto err_i_gmem;
> +	}
>  
>  	gmem = kzalloc(sizeof(*gmem), GFP_KERNEL);
>  	if (!gmem) {
> @@ -410,19 +505,19 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  		goto err_fd;
>  	}
>  
> -	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
> -					 O_RDWR, NULL);
> +	file = kvm_gmem_create_file(gmem_name, &kvm_gmem_fops);
>  	if (IS_ERR(file)) {
>  		err = PTR_ERR(file);
>  		goto err_gmem;
>  	}
>  
> +	inode = file->f_inode;
> +
> +	file->f_mapping = inode->i_mapping;
> +	file->private_data = gmem;
>  	file->f_flags |= O_LARGEFILE;
>  
> -	inode = file->f_inode;
> -	WARN_ON(file->f_mapping != inode->i_mapping);
> -
> -	inode->i_private = (void *)(unsigned long)flags;
> +	inode->i_private = i_gmem;
>  	inode->i_op = &kvm_gmem_iops;
>  	inode->i_mapping->a_ops = &kvm_gmem_aops;
>  	inode->i_mode |= S_IFREG;
> @@ -444,6 +539,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	kfree(gmem);
>  err_fd:
>  	put_unused_fd(fd);
> +err_i_gmem:
> +	kvfree(i_gmem);
>  	return err;
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 279e03029ce1..8b7b4e0eb639 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -6504,7 +6504,9 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
>  	if (WARN_ON_ONCE(r))
>  		goto err_vfio;
>  
> -	kvm_gmem_init(module);
> +	r = kvm_gmem_init(module);
> +	if (r)
> +		goto err_gmem;
>  
>  	r = kvm_init_virtualization();
>  	if (r)
> @@ -6525,6 +6527,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
>  err_register:
>  	kvm_uninit_virtualization();
>  err_virt:
> +	kvm_gmem_exit();
> +err_gmem:
>  	kvm_vfio_ops_exit();
>  err_vfio:
>  	kvm_async_pf_deinit();
> @@ -6556,6 +6560,7 @@ void kvm_exit(void)
>  	for_each_possible_cpu(cpu)
>  		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
>  	kmem_cache_destroy(kvm_vcpu_cache);
> +	kvm_gmem_exit();
>  	kvm_vfio_ops_exit();
>  	kvm_async_pf_deinit();
>  	kvm_irqfd_exit();
> diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
> index 715f19669d01..91e4202574a8 100644
> --- a/virt/kvm/kvm_mm.h
> +++ b/virt/kvm/kvm_mm.h
> @@ -36,15 +36,17 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
>  #endif /* HAVE_KVM_PFNCACHE */
>  
>  #ifdef CONFIG_KVM_PRIVATE_MEM
> -void kvm_gmem_init(struct module *module);
> +int kvm_gmem_init(struct module *module);
> +void kvm_gmem_exit(void);
>  int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
>  int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		  unsigned int fd, loff_t offset);
>  void kvm_gmem_unbind(struct kvm_memory_slot *slot);
>  #else
> -static inline void kvm_gmem_init(struct module *module)
> +static inline void kvm_gmem_exit(void) {}
> +static inline int kvm_gmem_init(struct module *module)
>  {
> -
> +	return 0;
>  }
>  
>  static inline int kvm_gmem_bind(struct kvm *kvm,
> -- 
> 2.43.5
> 
> 

