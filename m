Return-Path: <kvm+bounces-18785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E8F8FB4CA
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:07:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7707B1F21F77
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB3917C72;
	Tue,  4 Jun 2024 14:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B6/Xn33C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917B76FD5
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 14:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717510060; cv=none; b=UGpth+t65kPS9uugYpyuKzcDDTwAP0Vi3ieJBNTHS314TQO+FrfZSzkgAp/22QGo+h23eSfkRAb4o8S33WIyC4/qeUa6fMHuYthNP4PhWQHSWOnH17iyQWH5vZ0tHSTMNP6dvcy1PhAAmMu4SRRJbuo7dYY9+ItIC2ngohBO9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717510060; c=relaxed/simple;
	bh=Za6vpQQMMOgBdh748mftjXJoeY7OCkJMWvL+Mxek+0I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=imbCO7in90t8ZnPbX+XiTnetMphzMsLAgojBupylVWzL/SxlcmKB5U/Y+ipKG/ch1lskt9Hn9gs/Lc20JrpFQCSeB9RhGjKIAvJiN2NXsJxMInHWvzC2+brGPDJRs3nI7DLhkXqKsy3v3INEAq6vgbq+0yNCDz+OrFLBtKYUoKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B6/Xn33C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717510057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NulQeySQLaPenFmgEbDFhRugokbdz8U1aFsBsvhFMvk=;
	b=B6/Xn33CBup0Rt7SdJRYtryrXN2Tmh4ZuXr5yspq0tOxBy62h6q/Bmae2lIjWE4OPmj12i
	xVKe+sWlOsbGiPTGha3sS6Cvqu7EO1bWQUl0r5HjzXMTEz8J8rmreufmFjy0a96HgK61MZ
	pqqUZim9A96dq6CHb1kDvi5Z+KYpMpI=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-i2SWJ7NpN-6Wa0HebrTNNQ-1; Tue, 04 Jun 2024 10:07:36 -0400
X-MC-Unique: i2SWJ7NpN-6Wa0HebrTNNQ-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5b972c93b15so1085240eaf.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 07:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717510055; x=1718114855;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NulQeySQLaPenFmgEbDFhRugokbdz8U1aFsBsvhFMvk=;
        b=Je9rdVsWuGgg/DfTAvmblQkCNAOAwL9xgL1xEeqd5pEO3OCoZNZZgqEuxZdW1FluWH
         IP42B0vyrgwTnBqtQiB7PknZeARXkplVuCoW6kOkICdtUqsMguZXV62CwtE4mCv/whyP
         0ePSX0j210MJaAo9Uq8QtxO1W0dK5LuSZg3oZH1fLl/QEivkwiAkhYbFPAsZcRZvyMKM
         sheTlh332xi4YktWyl4zpyyuC3p/oB7LSK8Xl7Ri5ZgphBlQE37fsvzGNjbDekW7cw+h
         ZQ6Lnmf9Y2Dhn83w8b0wx6Lbq3iyAn0I4MSYrNNa5B2tEPVEMKhGrPt3z1PYeE/NS1cX
         6dVw==
X-Gm-Message-State: AOJu0YyG3oOar9WLbCN2OJvJzfm5KQzZEJb0HIPqsZN/ybiw143zn6Uu
	wyleLyXLOfcCyX4YqwjZiRrE+19Ugt3y8zz3p2skR0m2//BU5SkuFHqnVR363gaJxD2XG0yec//
	caLEzMGecwter9vMCC4IYL0WZkyVSHZUqrYSqt36uO/IIMEYoiw==
X-Received: by 2002:a05:6358:e49e:b0:199:a0e3:f8 with SMTP id e5c5f4694b2df-19b490c8e96mr1476657755d.29.1717510055079;
        Tue, 04 Jun 2024 07:07:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBPvoFux2NcLN0UbRy/Cz7xHd8SYCNBEmuj/dpDTqWmX8t2bohVO+LZqQhW3PCIHum9oS+JA==
X-Received: by 2002:a05:6358:e49e:b0:199:a0e3:f8 with SMTP id e5c5f4694b2df-19b490c8e96mr1476653855d.29.1717510054600;
        Tue, 04 Jun 2024 07:07:34 -0700 (PDT)
Received: from redhat.com ([172.56.17.220])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4b4179c0sm39614606d6.115.2024.06.04.07.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 07:07:34 -0700 (PDT)
Date: Tue, 4 Jun 2024 08:07:28 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH v2 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <20240604080728.3a25941e.alex.williamson@redhat.com>
In-Reply-To: <Zl6XdUkt/zMMGOLF@yzhao56-desk.sh.intel.com>
References: <20240530045236.1005864-1-alex.williamson@redhat.com>
	<20240530045236.1005864-3-alex.williamson@redhat.com>
	<ZlpgJ6aO+4xCF1+b@yzhao56-desk.sh.intel.com>
	<20240531231815.60f243fd.alex.williamson@redhat.com>
	<Zl6XdUkt/zMMGOLF@yzhao56-desk.sh.intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Jun 2024 12:26:29 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, May 31, 2024 at 11:18:15PM -0600, Alex Williamson wrote:
> > On Sat, 1 Jun 2024 07:41:27 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Wed, May 29, 2024 at 10:52:31PM -0600, Alex Williamson wrote:  
> > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > device BARs, which removes our vma_list and all the complicated lock
> > > > ordering necessary to manually zap each related vma.
> > > > 
> > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > corresponding to BAR mappings.
> > > > 
> > > > This also converts our mmap fault handler to use vmf_insert_pfn()
> > > > because we no longer have a vma_list to avoid the concurrency problem
> > > > with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> > > > huge_fault handler to avoid the additional faulting overhead, but
> > > > vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> > > >    
> > > Do we also consider looped vmf_insert_pfn() in mmap fault handler? e.g.
> > > for (i = vma->vm_start; i < vma->vm_end; i += PAGE_SIZE) {
> > > 	offset = (i - vma->vm_start) >> PAGE_SHIFT;
> > > 	ret = vmf_insert_pfn(vma, i, base_pfn + offset);
> > > 	if (ret != VM_FAULT_NOPAGE) {
> > > 		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
> > > 		goto up_out;
> > > 	}
> > > }  
> >  
> What about the prefault version? e.g.
> 
>         ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
> +       if (ret & VM_FAULT_ERROR)
> +               goto out_disabled;
> +
> +       /* prefault */
> +       for (i = vma->vm_start; i < vma->vm_end; i += PAGE_SIZE, pfn++) {
> +               if (i == vmf->address)
> +                       continue;
> +
> +               /* Don't return error on prefault */
> +               if (vmf_insert_pfn(vma, i, pfn) & VM_FAULT_ERROR)
> +                       break;
> +       }
> +
>  out_disabled:
>         up_read(&vdev->memory_lock);
> 
> 
> > We can have concurrent faults, so doing this means that we need to
> > continue to maintain a locked list of vmas that have faulted to avoid  
> But looks vfio_pci_zap_bars() always zap full PCI BAR ranges for vmas in
> core_vdev->inode->i_mapping.
> So, it doesn't matter whether a vma is fully mapped or partly mapped?

Yes, but without locking concurrent faults would all be re-inserting
the pfns concurrently from the fault handler.

> > duplicate insertions and all the nasty lock gymnastics that go along
> > with it.  I'd rather we just support huge_fault.  Thanks,  
> huge_fault is better. But before that, is this prefault one good?
> 

It seems like this would still be subject to the race that Jason noted
here[1], ie. call_mmap() occurs before vma_link_file(), therefore we
need to exclusively rely on fault to populate the vma or we risk a race
with unmap_mapping_range().  Thanks,

Alex


[1]https://lore.kernel.org/all/20240522183046.GG20229@nvidia.com/


