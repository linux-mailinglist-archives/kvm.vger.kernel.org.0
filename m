Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEF81C215E
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 01:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgEAXsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 19:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgEAXsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 19:48:51 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4E7C061A0C
        for <kvm@vger.kernel.org>; Fri,  1 May 2020 16:48:51 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id k12so9292593qtm.4
        for <kvm@vger.kernel.org>; Fri, 01 May 2020 16:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sSvpbqeNlGTEYII01v+mpMn0W1osrSgICMHvmn/DMgA=;
        b=gWGCf025stv8cuf8MQw5PxCV4aPuAxv7llGNtSEpzOcItZXjtVswlNb19LJDXQArHh
         Nz+hqC6DtzBKdbsxNy8i1sgdlKb+BT9STcsX0zuE96Z3YKScP+yypNbfkc6knPmqNPHv
         vrU6v4d1c/xiosLld1nuIk2cvXUL2/sSTh06rsf7RsThvf+Hfj9rd7g3hJV9UhXlql+m
         PuH849Rb8UkUR8WsTG9KvZMLAl7sbQBPR2MAg+2aiFf2+qTCdeeWeCuBj2H7y8rvp4n3
         418YpW8KM6ALpTwiXKL8U7Cqom+CCXth3xguEVwqANNPtsZZe3CBJacuLJpoiSvza72Y
         psDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sSvpbqeNlGTEYII01v+mpMn0W1osrSgICMHvmn/DMgA=;
        b=pu0OLR4iBXBtsh2umEWaK5lA0twqAJm9O1K2zxUXixCp2v+K4CTNXRbu4ESRUMnkoO
         LTZNrgaP9sjTK1L7WUD8eLGowrYHUvdEhIEx8RB0wksdE058Kc5MlGjb0d1RbzAkSUZI
         ODwmKlzwBjT2rPzzGnGC+gh14YFn+sVacBZVbk3bvQdRU3LJKbK2DsqE1/kMeKmsqA/+
         aBcmIWZOxUeS8KjW4eo35B2fjq/PkX7UKNJg8hH/le3NMIcEMW3FabyBOq0RIitFvaR2
         jMSUfskXVCUUbygv/5FBI2LARzLTo23lNrieycMHYwzj4kCCQ/+ddRdp6fD7nKRKh1Q+
         RFwA==
X-Gm-Message-State: AGi0Pua5AIuX5+osJRaD/MbicEe1JbU7TgSbfZopXmZolA64RyFBsHtF
        aOdFE/C4gbLmkHSUtlFxA8cdwQ==
X-Google-Smtp-Source: APiQypKjD7A++0EO3hNYzB3rk4xQIDRRvGgqPGYNegvuGV/EAa+rBlHx13oXqliDeEynMxdik2AYBQ==
X-Received: by 2002:ac8:1885:: with SMTP id s5mr6260777qtj.253.1588376930816;
        Fri, 01 May 2020 16:48:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id m83sm3859503qke.117.2020.05.01.16.48.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 16:48:50 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jUfOj-0005t6-HO; Fri, 01 May 2020 20:48:49 -0300
Date:   Fri, 1 May 2020 20:48:49 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 3/3] vfio-pci: Invalidate mmaps and block MMIO access on
 disabled memory
Message-ID: <20200501234849.GQ26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
 <158836917028.8433.13715345616117345453.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158836917028.8433.13715345616117345453.stgit@gimli.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 03:39:30PM -0600, Alex Williamson wrote:

>  static int vfio_pci_add_vma(struct vfio_pci_device *vdev,
>  			    struct vm_area_struct *vma)
>  {
> @@ -1346,15 +1450,49 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct vfio_pci_device *vdev = vma->vm_private_data;
> +	vm_fault_t ret = VM_FAULT_NOPAGE;
>  
> -	if (vfio_pci_add_vma(vdev, vma))
> -		return VM_FAULT_OOM;
> +	/*
> +	 * Zap callers hold memory_lock and acquire mmap_sem, we hold
> +	 * mmap_sem and need to acquire memory_lock to avoid races with
> +	 * memory bit settings.  Release mmap_sem, wait, and retry, or fail.
> +	 */
> +	if (unlikely(!down_read_trylock(&vdev->memory_lock))) {
> +		if (vmf->flags & FAULT_FLAG_ALLOW_RETRY) {
> +			if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
> +				return VM_FAULT_RETRY;
> +
> +			up_read(&vma->vm_mm->mmap_sem);
> +
> +			if (vmf->flags & FAULT_FLAG_KILLABLE) {
> +				if (!down_read_killable(&vdev->memory_lock))
> +					up_read(&vdev->memory_lock);
> +			} else {
> +				down_read(&vdev->memory_lock);
> +				up_read(&vdev->memory_lock);
> +			}
> +			return VM_FAULT_RETRY;
> +		}
> +		return VM_FAULT_SIGBUS;
> +	}

So, why have the wait? It isn't reliable - if this gets faulted from a
call site that can't handle retry then it will SIGBUS anyhow?

The weird use of a rwsem as a completion suggest that perhaps using
wait_event might improve things:

disable:
  // Clean out the vma list with zap, then:

  down_read(mm->mmap_sem)
  mutex_lock(vma_lock);
  list_for_each_entry_safe()
     // zap and remove all vmas

  pause_faults = true;
  mutex_write(vma_lock);

fault:
  // Already have down_read(mmap_sem)
  mutex_lock(vma_lock);
  while (pause_faults) {
     mutex_unlock(vma_lock)
     wait_event(..., !pause_faults)
     mutex_lock(vma_lock)
  }
  list_add()
  remap_pfn()
  mutex_unlock(vma_lock)

enable:
  pause_faults = false
  wake_event()

The only requirement here is that while inside the write side of
memory_lock you cannot touch user pages (ie no copy_from_user/etc)

Jason
