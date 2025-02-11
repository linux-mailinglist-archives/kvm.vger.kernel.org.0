Return-Path: <kvm+bounces-37882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA4FA3106B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58E4C166372
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD23B253F03;
	Tue, 11 Feb 2025 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lJw8Ydsr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B166253B52
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739289495; cv=none; b=YA/7lmDRP6sQ4OUMp/jpZm4oyDurgUSXZEyBdgO4BfnG7o36HpuUOd0h5uSLrpkq7Te4o7huJ7JRaRXGU3JYeh1JMzo0AP4rQTHk8Czh1AQJ1YyBYQ7y3kAvAHnWRuuAWbew8Bk27VDdfF91BpaTAqn5oTNmG9OIRBT+B9ADHBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739289495; c=relaxed/simple;
	bh=zvnU0NS3wo5yuCXTiC8lb72VKjYGAUpSsw2CGe8+QwQ=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qndlK6ZDL+JB6HiSQ+7n6BkiHqb2x3bZDhvoJ9sWps7KuoQXVbY2WRjsmzysFQBOL2uPet4ioXbqDfRb0B9B6W+W0jqkagOcSgVTdiP311b3r6WanbLKPli83i3sd/BzTlRvOmtG10J7ZKZpuVtHkBixxcaWIwmt+A2oWM/PNec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lJw8Ydsr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fa1a3c0f1bso9236410a91.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739289492; x=1739894292; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KugYmNRHB/rqEl/hhsrUNCGrUgr0xKZ+F/TbEirDM6k=;
        b=lJw8YdsrrmwUa5FavHsEJyZGpWbg2rM60FbPMIiQzqzFodJVq6z+aIdtUsMXXyQMYM
         DyY+IJzUX0fbksiBv/LrAcJ4ZYQxJ0xRT11RGid7RiuUXk5EAHpd2C63+NX0XO+iDpAc
         HXR6zDPGZ3rdgCcaE0cKrQHlnkNkbxVuR3ZRew35uwQ2zVsug+6n/d/FGnYG8J6Cm1j8
         /tZQ4ZFtt6Ws8LA/A6fosaOZWFQvFyPsNsSprhMwTneRjkP22f52XxUzYXiTSVzh2lss
         hkgG+d10pXzFZdvgo6rEHfnuCdPMZkODQJfOa5P1e3lwofbYj7cC4gNHHrID2VKcmOb7
         81kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739289492; x=1739894292;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KugYmNRHB/rqEl/hhsrUNCGrUgr0xKZ+F/TbEirDM6k=;
        b=dLJ3Zv9a9Nq9ULryFqak/ftMyXUj0BjGLKmEtEAFCbawc4XklS6TdBuBdzvos8hJ0a
         UeRhrS2zjUFyVaOBkD4vFoOs1acg44IiQxV8WNJ4MPMHl4oy2l7b0IN4Ng6tWvqIBe6Z
         QlGYfIE4GMEmifn51Bj1OEf6vL5PM6tHFdL3suCBFhaUfEpGUZqfk+FwZaYfYEc17wFP
         A4enl+p/1nl6UOl72CyyTy0ON2i1ygo4WSxuV441VJAqC9XSBvdERwSPbtJhwgSVAEoE
         YYwaiSzrPNUZp3BCDbdr1iwevWak0m+lgbkuW+PiSCudLlL5EIHwH3p/0ikVFJTGGoud
         Gg/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUtP4F2TLVz6WRiWoKsJzkoWoGhiwW2UUwoOG/1l5Nnp6OlYweCr8iZm3GDKpwi6W7JQ+o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJnciuni7+T1PUIZgd9iYzDacplVYWwKI//+aknRaWtv4YyBu9
	v7+dntnfp5bzk5Rxzk7xqHYhF8o1GmHymt1uFtko/CJCLVpqRRngTSLrzkllb5b7EO2g+s2xlqT
	vzaxlNkvJz8h3dEM78eaPDQ==
X-Google-Smtp-Source: AGHT+IEwKVxw5NOUrw2sjKseSpgw8dhnRS7+vynrTOEPtOyl0zNsNiBtbqZzTyyHzPoVBnsReUJS+ENgEnR+DN/Q1A==
X-Received: from pjbsq11.prod.google.com ([2002:a17:90b:530b:b0:2f7:ff61:48e7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1807:b0:2fa:1d9f:c80 with SMTP id 98e67ed59e1d1-2faa099b33bmr5918634a91.17.1739289492486;
 Tue, 11 Feb 2025 07:58:12 -0800 (PST)
Date: Tue, 11 Feb 2025 15:58:11 +0000
In-Reply-To: <186047ea-a782-494b-bfcf-f5088806bbb4@redhat.com> (message from
 Gavin Shan on Fri, 24 Jan 2025 14:25:56 +1000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzlduc8odo.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v5 02/15] KVM: guest_memfd: Make guest mem use guest
 mem inodes instead of anonymous inodes
From: Ackerley Tng <ackerleytng@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"


Thanks for reviewing, Gavin! I'll also adopt these when I respin.

Gavin Shan <gshan@redhat.com> writes:

> Hi Fuad,
>
> On 1/18/25 2:29 AM, Fuad Tabba wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>> 
>> Using guest mem inodes allows us to store metadata for the backing
>> memory on the inode. Metadata will be added in a later patch to
>> support HugeTLB pages.
>> 
>> Metadata about backing memory should not be stored on the file, since
>> the file represents a guest_memfd's binding with a struct kvm, and
>> metadata about backing memory is not unique to a specific binding and
>> struct kvm.
>> 
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
>>   include/uapi/linux/magic.h |   1 +
>>   virt/kvm/guest_memfd.c     | 119 ++++++++++++++++++++++++++++++-------
>>   2 files changed, 100 insertions(+), 20 deletions(-)
>> 
>> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
>> index bb575f3ab45e..169dba2a6920 100644
>> --- a/include/uapi/linux/magic.h
>> +++ b/include/uapi/linux/magic.h
>> @@ -103,5 +103,6 @@
>>   #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
>>   #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
>>   #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
>> +#define GUEST_MEMORY_MAGIC	0x474d454d	/* "GMEM" */
>>   
>>   #endif /* __LINUX_MAGIC_H__ */
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 47a9f68f7b24..198554b1f0b5 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -1,12 +1,17 @@
>>   // SPDX-License-Identifier: GPL-2.0
>> +#include <linux/fs.h>
>> +#include <linux/mount.h>
>
> This can be dropped since "linux/mount.h" has been included to "linux/fs.h".
>
>>   #include <linux/backing-dev.h>
>>   #include <linux/falloc.h>
>>   #include <linux/kvm_host.h>
>> +#include <linux/pseudo_fs.h>
>>   #include <linux/pagemap.h>
>>   #include <linux/anon_inodes.h>
>>   
>>   #include "kvm_mm.h"
>>   
>> +static struct vfsmount *kvm_gmem_mnt;
>> +
>>   struct kvm_gmem {
>>   	struct kvm *kvm;
>>   	struct xarray bindings;
>> @@ -307,6 +312,38 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>>   }
>>   
>> +static const struct super_operations kvm_gmem_super_operations = {
>> +	.statfs		= simple_statfs,
>> +};
>> +
>> +static int kvm_gmem_init_fs_context(struct fs_context *fc)
>> +{
>> +	struct pseudo_fs_context *ctx;
>> +
>> +	if (!init_pseudo(fc, GUEST_MEMORY_MAGIC))
>> +		return -ENOMEM;
>> +
>> +	ctx = fc->fs_private;
>> +	ctx->ops = &kvm_gmem_super_operations;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct file_system_type kvm_gmem_fs = {
>> +	.name		 = "kvm_guest_memory",
>> +	.init_fs_context = kvm_gmem_init_fs_context,
>> +	.kill_sb	 = kill_anon_super,
>> +};
>> +
>> +static void kvm_gmem_init_mount(void)
>> +{
>> +	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
>> +	BUG_ON(IS_ERR(kvm_gmem_mnt));
>> +
>> +	/* For giggles. Userspace can never map this anyways. */
>> +	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
>> +}
>> +
>>   static struct file_operations kvm_gmem_fops = {
>>   	.open		= generic_file_open,
>>   	.release	= kvm_gmem_release,
>> @@ -316,6 +353,8 @@ static struct file_operations kvm_gmem_fops = {
>>   void kvm_gmem_init(struct module *module)
>>   {
>>   	kvm_gmem_fops.owner = module;
>> +
>> +	kvm_gmem_init_mount();
>>   }
>>   
>>   static int kvm_gmem_migrate_folio(struct address_space *mapping,
>> @@ -397,11 +436,67 @@ static const struct inode_operations kvm_gmem_iops = {
>>   	.setattr	= kvm_gmem_setattr,
>>   };
>>   
>> +static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>> +						      loff_t size, u64 flags)
>> +{
>> +	const struct qstr qname = QSTR_INIT(name, strlen(name));
>> +	struct inode *inode;
>> +	int err;
>> +
>> +	inode = alloc_anon_inode(kvm_gmem_mnt->mnt_sb);
>> +	if (IS_ERR(inode))
>> +		return inode;
>> +
>> +	err = security_inode_init_security_anon(inode, &qname, NULL);
>> +	if (err) {
>> +		iput(inode);
>> +		return ERR_PTR(err);
>> +	}
>> +
>> +	inode->i_private = (void *)(unsigned long)flags;
>> +	inode->i_op = &kvm_gmem_iops;
>> +	inode->i_mapping->a_ops = &kvm_gmem_aops;
>> +	inode->i_mode |= S_IFREG;
>> +	inode->i_size = size;
>> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>> +	mapping_set_inaccessible(inode->i_mapping);
>> +	/* Unmovable mappings are supposed to be marked unevictable as well. */
>> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>> +
>> +	return inode;
>> +}
>> +
>> +static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
>> +						  u64 flags)
>> +{
>> +	static const char *name = "[kvm-gmem]";
>> +	struct inode *inode;
>> +	struct file *file;
>> +
>> +	if (kvm_gmem_fops.owner && !try_module_get(kvm_gmem_fops.owner))
>> +		return ERR_PTR(-ENOENT);
>> +
>
> The validation on 'kvm_gmem_fops.owner' can be removed since try_module_get()
> and module_put() are friendly to a NULL parameter, even when CONFIG_MODULE_UNLOAD == N
>
> A module_put(kvm_gmem_fops.owner) is needed in the various erroneous cases in
> this function. Otherwise, the reference count of the owner (module) will become
> imbalanced on any errors.
>

Thanks for catching this! Will add module_put() for error paths.

>
>> +	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
>> +	if (IS_ERR(inode))
>> +		return ERR_CAST(inode);
>> +
>
> ERR_CAST may be dropped since there is nothing to be casted or converted?
>

This cast is necessary as it casts from a struct inode * to a struct
file *.

>> +	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR,
>> +				 &kvm_gmem_fops);
>> +	if (IS_ERR(file)) {
>> +		iput(inode);
>> +		return file;
>> +	}
>> +
>> +	file->f_mapping = inode->i_mapping;
>> +	file->f_flags |= O_LARGEFILE;
>> +	file->private_data = priv;
>> +
>
> 'file->f_mapping = inode->i_mapping' may be dropped since it's already correctly
> set by alloc_file_pseudo().
>
> alloc_file_pseudo
>    alloc_path_pseudo
>    alloc_file
>      alloc_empty_file
>      file_init_path         // Set by this function
>

Thanks!

>
>> +	return file;
>> +}
>> +
>>   static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>   {
>> -	const char *anon_name = "[kvm-gmem]";
>>   	struct kvm_gmem *gmem;
>> -	struct inode *inode;
>>   	struct file *file;
>>   	int fd, err;
>>   
>> @@ -415,32 +510,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>   		goto err_fd;
>>   	}
>>   
>> -	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
>> -					 O_RDWR, NULL);
>> +	file = kvm_gmem_inode_create_getfile(gmem, size, flags);
>>   	if (IS_ERR(file)) {
>>   		err = PTR_ERR(file);
>>   		goto err_gmem;
>>   	}
>>   
>> -	file->f_flags |= O_LARGEFILE;
>> -
>> -	inode = file->f_inode;
>> -	WARN_ON(file->f_mapping != inode->i_mapping);
>> -
>> -	inode->i_private = (void *)(unsigned long)flags;
>> -	inode->i_op = &kvm_gmem_iops;
>> -	inode->i_mapping->a_ops = &kvm_gmem_aops;
>> -	inode->i_mode |= S_IFREG;
>> -	inode->i_size = size;
>> -	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>> -	mapping_set_inaccessible(inode->i_mapping);
>> -	/* Unmovable mappings are supposed to be marked unevictable as well. */
>> -	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>> -
>>   	kvm_get_kvm(kvm);
>>   	gmem->kvm = kvm;
>>   	xa_init(&gmem->bindings);
>> -	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
>> +	list_add(&gmem->entry, &file_inode(file)->i_mapping->i_private_list);
>>   
>>   	fd_install(fd, file);
>>   	return fd;
>
> Thanks,
> Gavin

