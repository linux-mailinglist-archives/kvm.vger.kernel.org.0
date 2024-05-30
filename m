Return-Path: <kvm+bounces-18356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E4D8D43AB
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 04:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03064B256EA
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 02:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C561C6A7;
	Thu, 30 May 2024 02:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZWydcVt1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E80917BA4
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 02:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717035730; cv=none; b=fw/wqbdWrJPlAxGeanavFhmxTeyc/hJnudFByI0MhNOPU2bfBej3tqwBV75zuoDujzvp4cg06kW5uKJtV3R7Dqw0Ta0FyFnfEeGJumuXJ6fZLnaQebQ3LK1Xydh0aRxF0q0wmrRM/3widS2S5DqoVDiD6xCJSgAK0LSY5xXwkZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717035730; c=relaxed/simple;
	bh=q3N+L6iL+aCn0Ul1T8/3/qWBVpKRfJ8U8uEYcH9sEHg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P70EfjgpRajnT5KrmFxFp1tubxeJj/ZFn8+RRfJ09lZs2K2bkGf9WVMqlDNtyIE6YZMMKBy+bw9cnt1Ot+B2vXGBTXhjflGwfe/+B3AuLgkEItOft3M9/aWf8eAVDfv63SR7Wvxo20Mmvcgwen12CbAIZjKwK+85Px6pptUN4UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZWydcVt1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717035727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iewU9LB6G8hUbgAMmnzm/16RbymvUxiANCp2g+q6DiY=;
	b=ZWydcVt15CjpICuwnJ+j4DtMdLxzw1+uMf7OnRAXAX9wOK/Y/UdLE0WXzQtRApT6W1eJDm
	19p9s1SnYMNgbeVG/IwBUahjyo2VR0G1AK3EbalRwal6sMo5X5/ctBq4csBec0x4peBlUb
	Xib/aNrc8zcrPwFH4fqwcuiwsedc0YU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-7TrxKCSFMf6X-3In5XeKSQ-1; Wed, 29 May 2024 22:22:05 -0400
X-MC-Unique: 7TrxKCSFMf6X-3In5XeKSQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7eac3b73a53so38244339f.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 19:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717035725; x=1717640525;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iewU9LB6G8hUbgAMmnzm/16RbymvUxiANCp2g+q6DiY=;
        b=JYVTYuwdzSmXUIKwSS9kMtuXeAMkBeCH3sKDsQ+kOvNXAOjCSmKhmygNLDKmNHLTD6
         6b7T3EJwFPKzTMuDYZhwSzOmGXSHh2wl03ktjTxCslmcmvgsiQIfXNrIYSp+kNn2Pd0u
         tsevgr8LlW9noiU+/CbTOJTwUGHnp9OcJ1eHZgLtYaq2WPvkyWSLYNamF9IW76dz3nnP
         6LU4xPENl1vQ+OMHhlRjsfNXBozt3LkZX8OULFn9r4nAEp2MEsfxZn2e8yxYobkrg0kA
         syq2ycGaxWjDvf+sLGHaqVfSGvOlHU7qSAb5wzgsOdpKtgvIN3OsxitJRiYPoh9iKCFV
         LiWA==
X-Gm-Message-State: AOJu0Yz+enG7cr88Hs+cnS3t8AnuJbO9OaqNQhSQwfgYl2J5cva9uJNX
	FsYOTCSogYVFsNXRBpfL6bZsvlU53GP4jYbpK5/iGfSPXQ7d1XWgD1C7j2YlILh2OCUurcFo4Yw
	TcXmNrngcK+XRbYAAgx4RWuIfr4ys+j+mCR7RRiy5h7dEFHfblg==
X-Received: by 2002:a05:6602:1693:b0:7da:67fa:7da7 with SMTP id ca18e2360f4ac-7eaf5d120femr92533239f.3.1717035724969;
        Wed, 29 May 2024 19:22:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/J5P6HIrm2rVzE5Gg81QbaGbXuPysCDYZh/yQ9+GIkxOCY1dCg1mPlFgjsrlkpRbjEEY6rQ==
X-Received: by 2002:a05:6602:1693:b0:7da:67fa:7da7 with SMTP id ca18e2360f4ac-7eaf5d120femr92532239f.3.1717035724603;
        Wed, 29 May 2024 19:22:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e905ce2b7esm272804439f.34.2024.05.29.19.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 19:22:04 -0700 (PDT)
Date: Wed, 29 May 2024 20:22:01 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ajones@ventanamicro.com"
 <ajones@ventanamicro.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <20240529202201.7b55549b.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB52769DB022895F3D310F52458CF32@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
	<20240523195629.218043-3-alex.williamson@redhat.com>
	<BN9PR11MB52769DB022895F3D310F52458CF32@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 May 2024 00:09:49 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, May 24, 2024 3:56 AM
> > 
> > -/* Caller holds vma_lock */
> > -static int __vfio_pci_add_vma(struct vfio_pci_core_device *vdev,
> > -			      struct vm_area_struct *vma)
> > +static int vma_to_pfn(struct vm_area_struct *vma, unsigned long *pfn)
> >  {
> > -	struct vfio_pci_mmap_vma *mmap_vma;
> > -
> > -	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL_ACCOUNT);
> > -	if (!mmap_vma)
> > -		return -ENOMEM;
> > -
> > -	mmap_vma->vma = vma;
> > -	list_add(&mmap_vma->vma_next, &vdev->vma_list);
> > +	struct vfio_pci_core_device *vdev = vma->vm_private_data;
> > +	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT -
> > PAGE_SHIFT);
> > +	u64 pgoff;
> > 
> > -	return 0;
> > -}
> > +	if (index >= VFIO_PCI_ROM_REGION_INDEX ||
> > +	    !vdev->bar_mmap_supported[index] || !vdev->barmap[index])
> > +		return -EINVAL;  
> 
> Is a WARN_ON() required here? If those checks fail vfio_pci_core_mmap()
> will return error w/o installing vm_ops.

I think these tests largely come from previous iterations of the patch
where this function had more versatility, because yes, they do exactly
duplicate tests that we would have already passed before we established
this function in the vm_ops.fault path.

We could therefore wrap this in a WARN_ON, but actually with the
current usage it's really just a sanity test that vma->vm_pgoff hasn't
changed.  We don't change barmap or bar_mmap_supported while the device
is opened.  Is it all too much paranoia and we should remove the test
entirely and have this function return void?

> > @@ -2506,17 +2373,11 @@ static int vfio_pci_dev_set_hot_reset(struct
> > vfio_device_set *dev_set,
> >  				      struct vfio_pci_group_info *groups,
> >  				      struct iommufd_ctx *iommufd_ctx)  
> 
> the comment before this function should be updated too:
> 
> /*
>  * We need to get memory_lock for each device, but devices can share mmap_lock,
>  * therefore we need to zap and hold the vma_lock for each device, and only then
>  * get each memory_lock.
>  */

Good catch.  I think I'd just delete this comment altogether and expand
the existing comment in the loop body as:

                /*
		 * Take the memory write lock for each device and zap BAR
		 * mappings to prevent the user accessing the device while in
		 * reset.  Locking multiple devices is prone to deadlock,
		 * runaway and unwind if we hit contention.
                 */
                if (!down_write_trylock(&vdev->memory_lock)) {
                        ret = -EBUSY;
                        break;
                }

Sound good?  Thanks,

Alex


