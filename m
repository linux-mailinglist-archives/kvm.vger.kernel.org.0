Return-Path: <kvm+bounces-36465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11624A1AF66
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 05:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBC8C3A8E2A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 04:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148BB1D88AD;
	Fri, 24 Jan 2025 04:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PBb05AXI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4EB23B0
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 04:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737692787; cv=none; b=RG+29hBsOpbgoMC52UmG9jAt22yQTtQYAcQwnIXNqShxc2QToanuNgrxeioIc0cFZvvwHkqI3zTRH6x5hRwiT98uo+Ax7kYtomzKVxboIhVQjdG92JertfYu6doCLWBBWH9dkC/9glrjumPAkTLFvznDw9ZZ/QdS4hNFPtDLzGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737692787; c=relaxed/simple;
	bh=aXa8G+UwR4b+grlTDq708P7uJ8uZWjkDDEo0FNlieAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kEwG/cHBGUudnoYZYTfqNjEHUZsfROATySH6f5Im8To7k0elqMNYvtHG19j5U1izAkhSLOnqdNtJqOdGEhJqfTdN7lO4d/E0iKV49ZJ2NIUMHalAS1qghCsEvILxBw+eEYhg051LcZfQXDKsejj2LpxWQICa54ckdo5fS6jXwnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PBb05AXI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737692782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W4x8wgZEyKuHwORGDCpsHEEkdJ39AEqwRDp8OAcY8lk=;
	b=PBb05AXIEPByXUPF7JMfrIcPKzvdSf7N00CsX3U0fok4DnM4VMjPQaZXqJlLtFfxc5w2+B
	JL+znsGtv76hibMAFP7XjmzTw0BZPRrRwW3Gwh1fQNZWuJJONJrxVSdF482dZvWglgOKNv
	mlUEe+NLbhNbU3v7HOz4YeNmpgowUIc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-mv4PgtBaPaqON5zqur9NAQ-1; Thu, 23 Jan 2025 23:26:20 -0500
X-MC-Unique: mv4PgtBaPaqON5zqur9NAQ-1
X-Mimecast-MFC-AGG-ID: mv4PgtBaPaqON5zqur9NAQ
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ef79403c5eso4927475a91.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 20:26:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737692779; x=1738297579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4x8wgZEyKuHwORGDCpsHEEkdJ39AEqwRDp8OAcY8lk=;
        b=Xm97DjoDuCd5PnezKhtCQpglDdER03iANSALX3psLswuyS/9roC2FYQRjRiMaFxxKj
         7EWDYs01JTkqossunuTJxLevltcIVuwN0SQMLmEFmYwbhoyFc7BIswCF/ECQoeErfXeH
         TWGXrjK4I9Yft77NfYkjCvDmLBJ4cq8O/I+XCbwzJwG9JHmKjmxnzjgecoHDQQkJKexj
         R5Dau2Ys4hp5wI3lovEpAaLyFES5grzb4ZsmlVrPjW8umo8tns9wu9wmflSf9u4PP92H
         Ep5XDwdqdPd1dtLMTsCHFeRRPtvEtmcJ2/xZ+nGBHdA2RfaH6Iubf/0NKHzUrbwk2mYl
         w87w==
X-Forwarded-Encrypted: i=1; AJvYcCXJbK7oQ8tCr4zZbogFoKVlTquSiNHm8Vt4Fv6a+VVJTdAG+35RmM9OgJ6dbWZl3IzYhjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBf4z7A1korEZNde1XMsbGXaSx8lLD3jLa1XYpE9FOXi22ywmn
	fUOmMBTZEYetaxmmWQ/tfAHzM0Bp9op8D9qrJmBvmT+QQEO3uO4K8a1Wt0tnSREahYIpsCEqkPl
	z3njzUH7FsTnAECizU/WaX85NSXYYxgQcv1M+iTu8/JRN6FwPMQ==
X-Gm-Gg: ASbGncsPo1Q4Y5/mFx4RH01Ufcs6CYyaJmsnY/5dAjZpmqVPlHU/XrOCYKIE15+rwLD
	/oTqkBX3HIZrglkyXfUCtTVlAZGpns9ULiAKrGralP9hwaXZciGwudt+N3P6TXL2cI9aO2pxBUq
	fay5kG0gRNWsTVf37d1LCSH1eo7RayoRupuRCIBFT6GSYjfb+blkPcUxA6w/3WT5yRxXaUgHkK0
	LnodV2buCjaUbBvOdU7apUPOiSMSV+OjzFDX3s4anevhjDLjMvy53XG8MWKhR9wUYM8IPw=
X-Received: by 2002:a17:90b:4d05:b0:2ee:5958:828 with SMTP id 98e67ed59e1d1-2f782c70176mr42890438a91.9.1737692778660;
        Thu, 23 Jan 2025 20:26:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHF0DJWclieG8GIGsCzjY2k/MI/u8GaqIVA2CIVqY1sh8z4aaIMUWu09AlsDTA/tx+z6nHtoQ==
X-Received: by 2002:a17:90b:4d05:b0:2ee:5958:828 with SMTP id 98e67ed59e1d1-2f782c70176mr42890346a91.9.1737692777958;
        Thu, 23 Jan 2025 20:26:17 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5bbfbsm591962a91.19.2025.01.23.20.25.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 20:26:16 -0800 (PST)
Message-ID: <186047ea-a782-494b-bfcf-f5088806bbb4@redhat.com>
Date: Fri, 24 Jan 2025 14:25:56 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 02/15] KVM: guest_memfd: Make guest mem use guest
 mem inodes instead of anonymous inodes
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
References: <20250117163001.2326672-1-tabba@google.com>
 <20250117163001.2326672-3-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250117163001.2326672-3-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 1/18/25 2:29 AM, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Using guest mem inodes allows us to store metadata for the backing
> memory on the inode. Metadata will be added in a later patch to
> support HugeTLB pages.
> 
> Metadata about backing memory should not be stored on the file, since
> the file represents a guest_memfd's binding with a struct kvm, and
> metadata about backing memory is not unique to a specific binding and
> struct kvm.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/uapi/linux/magic.h |   1 +
>   virt/kvm/guest_memfd.c     | 119 ++++++++++++++++++++++++++++++-------
>   2 files changed, 100 insertions(+), 20 deletions(-)
> 
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index bb575f3ab45e..169dba2a6920 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -103,5 +103,6 @@
>   #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
>   #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
>   #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
> +#define GUEST_MEMORY_MAGIC	0x474d454d	/* "GMEM" */
>   
>   #endif /* __LINUX_MAGIC_H__ */
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 47a9f68f7b24..198554b1f0b5 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1,12 +1,17 @@
>   // SPDX-License-Identifier: GPL-2.0
> +#include <linux/fs.h>
> +#include <linux/mount.h>

This can be dropped since "linux/mount.h" has been included to "linux/fs.h".

>   #include <linux/backing-dev.h>
>   #include <linux/falloc.h>
>   #include <linux/kvm_host.h>
> +#include <linux/pseudo_fs.h>
>   #include <linux/pagemap.h>
>   #include <linux/anon_inodes.h>
>   
>   #include "kvm_mm.h"
>   
> +static struct vfsmount *kvm_gmem_mnt;
> +
>   struct kvm_gmem {
>   	struct kvm *kvm;
>   	struct xarray bindings;
> @@ -307,6 +312,38 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +static const struct super_operations kvm_gmem_super_operations = {
> +	.statfs		= simple_statfs,
> +};
> +
> +static int kvm_gmem_init_fs_context(struct fs_context *fc)
> +{
> +	struct pseudo_fs_context *ctx;
> +
> +	if (!init_pseudo(fc, GUEST_MEMORY_MAGIC))
> +		return -ENOMEM;
> +
> +	ctx = fc->fs_private;
> +	ctx->ops = &kvm_gmem_super_operations;
> +
> +	return 0;
> +}
> +
> +static struct file_system_type kvm_gmem_fs = {
> +	.name		 = "kvm_guest_memory",
> +	.init_fs_context = kvm_gmem_init_fs_context,
> +	.kill_sb	 = kill_anon_super,
> +};
> +
> +static void kvm_gmem_init_mount(void)
> +{
> +	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
> +	BUG_ON(IS_ERR(kvm_gmem_mnt));
> +
> +	/* For giggles. Userspace can never map this anyways. */
> +	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
> +}
> +
>   static struct file_operations kvm_gmem_fops = {
>   	.open		= generic_file_open,
>   	.release	= kvm_gmem_release,
> @@ -316,6 +353,8 @@ static struct file_operations kvm_gmem_fops = {
>   void kvm_gmem_init(struct module *module)
>   {
>   	kvm_gmem_fops.owner = module;
> +
> +	kvm_gmem_init_mount();
>   }
>   
>   static int kvm_gmem_migrate_folio(struct address_space *mapping,
> @@ -397,11 +436,67 @@ static const struct inode_operations kvm_gmem_iops = {
>   	.setattr	= kvm_gmem_setattr,
>   };
>   
> +static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
> +						      loff_t size, u64 flags)
> +{
> +	const struct qstr qname = QSTR_INIT(name, strlen(name));
> +	struct inode *inode;
> +	int err;
> +
> +	inode = alloc_anon_inode(kvm_gmem_mnt->mnt_sb);
> +	if (IS_ERR(inode))
> +		return inode;
> +
> +	err = security_inode_init_security_anon(inode, &qname, NULL);
> +	if (err) {
> +		iput(inode);
> +		return ERR_PTR(err);
> +	}
> +
> +	inode->i_private = (void *)(unsigned long)flags;
> +	inode->i_op = &kvm_gmem_iops;
> +	inode->i_mapping->a_ops = &kvm_gmem_aops;
> +	inode->i_mode |= S_IFREG;
> +	inode->i_size = size;
> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> +	mapping_set_inaccessible(inode->i_mapping);
> +	/* Unmovable mappings are supposed to be marked unevictable as well. */
> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> +
> +	return inode;
> +}
> +
> +static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
> +						  u64 flags)
> +{
> +	static const char *name = "[kvm-gmem]";
> +	struct inode *inode;
> +	struct file *file;
> +
> +	if (kvm_gmem_fops.owner && !try_module_get(kvm_gmem_fops.owner))
> +		return ERR_PTR(-ENOENT);
> +

The validation on 'kvm_gmem_fops.owner' can be removed since try_module_get()
and module_put() are friendly to a NULL parameter, even when CONFIG_MODULE_UNLOAD == N

A module_put(kvm_gmem_fops.owner) is needed in the various erroneous cases in
this function. Otherwise, the reference count of the owner (module) will become
imbalanced on any errors.


> +	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
> +	if (IS_ERR(inode))
> +		return ERR_CAST(inode);
> +

ERR_CAST may be dropped since there is nothing to be casted or converted?

> +	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR,
> +				 &kvm_gmem_fops);
> +	if (IS_ERR(file)) {
> +		iput(inode);
> +		return file;
> +	}
> +
> +	file->f_mapping = inode->i_mapping;
> +	file->f_flags |= O_LARGEFILE;
> +	file->private_data = priv;
> +

'file->f_mapping = inode->i_mapping' may be dropped since it's already correctly
set by alloc_file_pseudo().

alloc_file_pseudo
   alloc_path_pseudo
   alloc_file
     alloc_empty_file
     file_init_path         // Set by this function
   

> +	return file;
> +}
> +
>   static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>   {
> -	const char *anon_name = "[kvm-gmem]";
>   	struct kvm_gmem *gmem;
> -	struct inode *inode;
>   	struct file *file;
>   	int fd, err;
>   
> @@ -415,32 +510,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>   		goto err_fd;
>   	}
>   
> -	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
> -					 O_RDWR, NULL);
> +	file = kvm_gmem_inode_create_getfile(gmem, size, flags);
>   	if (IS_ERR(file)) {
>   		err = PTR_ERR(file);
>   		goto err_gmem;
>   	}
>   
> -	file->f_flags |= O_LARGEFILE;
> -
> -	inode = file->f_inode;
> -	WARN_ON(file->f_mapping != inode->i_mapping);
> -
> -	inode->i_private = (void *)(unsigned long)flags;
> -	inode->i_op = &kvm_gmem_iops;
> -	inode->i_mapping->a_ops = &kvm_gmem_aops;
> -	inode->i_mode |= S_IFREG;
> -	inode->i_size = size;
> -	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> -	mapping_set_inaccessible(inode->i_mapping);
> -	/* Unmovable mappings are supposed to be marked unevictable as well. */
> -	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> -
>   	kvm_get_kvm(kvm);
>   	gmem->kvm = kvm;
>   	xa_init(&gmem->bindings);
> -	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
> +	list_add(&gmem->entry, &file_inode(file)->i_mapping->i_private_list);
>   
>   	fd_install(fd, file);
>   	return fd;

Thanks,
Gavin


