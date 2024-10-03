Return-Path: <kvm+bounces-27846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2FD298F08A
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 15:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AA4FB243B8
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 13:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D5819CC1E;
	Thu,  3 Oct 2024 13:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="k2IO6VDr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3A586277
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 13:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727962621; cv=none; b=R9RZ1QtHz98BozMOhf5mO/anOaVaQL8zakogpnjCAeGd2kbHRMLCUjP9dGzxmWfsvhMyLwtKc6Rvd2AlVILUAy+y9wohLuXTR6v49Svm8NUKOui0sCLR8Md9Quznho70arkSLQx4Uar9mTj4VsYRMHLNwAtTPkckmZuQAfxTzDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727962621; c=relaxed/simple;
	bh=oKcjYtaHEPTRj+7CRpP5G980TAaVih1dYRjGdvPPRjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGZSvSsjoWTyHEoWHFNsX6hvTYW2jEpdv6PDNRJyU8cIsyGX+aqcbk7rw4O+N9tspNT/lOKXdP2e9DLwwOnbpx58HsCBJnYmvOjIRZ36/H0oPgZbqf4NIKlOuN1KBkUmytg2kJACNEG3mr4mCYEL+/3oZaTThMKdYjdD0s65x4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=k2IO6VDr; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7ae3e3db294so58731585a.2
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 06:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1727962619; x=1728567419; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tP7tolVS+NskbYnx6Ke2dpQNeCMyn7tnciZU6uuI/aM=;
        b=k2IO6VDrNWvOFBxGhdsxrtFEnB0OhGxar+bAhGV1IRLN+KHSQrRvoHiTKqqeazDHqT
         51BJZLciLg9CprNSg7ilohJ/zeX/EsqxF18tJRY381e7JsMXEPErL+WP1wU8QEFro/cK
         SCHBDJiXOXr8nVA2dJ0sENHFLbYBpDaM+C9U8d03gJWlEJMm2qPlKieQfXVqqD3WJXhP
         t/ZAwTVa0KJkOfrJZQ5Urr+3OXU1aLTje2ad/ZW+pRad3su0x0T2dhLi+m9CsmZR/35f
         2CY1+U3LCBwi3c/NYRa1tQPMU1i3zEu0F3TOIyaOyrit8QLaZ+73PNoeT8xKCanbwyq8
         gG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727962619; x=1728567419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tP7tolVS+NskbYnx6Ke2dpQNeCMyn7tnciZU6uuI/aM=;
        b=HMZ87Hbx0HPLFzVlbxAxfjTOzxPWaGNsQ3xBqYsaL4miYxX+4gHwCZn7zIyTFR2Ag6
         jnNNWxKftw8jCOFfBHF9/rHaDnsy2ZvqI/nxPeF0uM7MHp7k0rWofmSgwwlhJOEhIjDy
         yGwb4fwiTETsce+29hbpT1qM+UPucOvX6AkAMPE3Fbl8K5GBveaeupIOz0dizGXEC3T2
         8OSp5D5WLTo3EJiJs6kxWl6KDMTeDi+WxvthX5vEpNEPNd7ieZLU5qgdUn+TmZ2OYgz1
         cAyDhUVwYv9nUQ0tf6D35lr5eFogEhm2IS8p2zbxlq1rt4JU9imnJ1FnsW8A/W11A77j
         hTKw==
X-Forwarded-Encrypted: i=1; AJvYcCUVApt/KVh/4ELUYP5NM6P+EDp7mIe9M1lX7aLmD78r//+ul4WJ/S2XEWE7VF+gwlIgDPw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb+LxyEfQ/+Wqa90zf2p8ebkQZwvyEzHNlrjUQwNwXe5j/g7mq
	IkmvRvpt91SlGY6EPyZLae5DBz0M2R7c+1Er4/GHgB+b+bY3Qg+DeCr+G4YZpno=
X-Google-Smtp-Source: AGHT+IExX5PZU6X//DLAfhUc+pV/DvO3M0gA3yCG/nuBqNATFkOVsDt5pX3W468d8vfh0nt7guWskA==
X-Received: by 2002:a05:6214:3a8a:b0:6cb:4eb9:d279 with SMTP id 6a1803df08f44-6cb819d867dmr105528216d6.21.1727962619279;
        Thu, 03 Oct 2024 06:36:59 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cb9359c01esm6550426d6.2.2024.10.03.06.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 06:36:58 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1swM0o-00ASYX-0T;
	Thu, 03 Oct 2024 10:36:58 -0300
Date: Thu, 3 Oct 2024 10:36:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Gowans <jgowans@amazon.com>
Cc: linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
	iommu@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Alexander Graf <graf@amazon.de>, anthony.yznaga@oracle.com,
	steven.sistare@oracle.com, nh-open-source@amazon.com,
	"Saenz Julienne, Nicolas" <nsaenz@amazon.es>
Subject: Re: [RFC PATCH 12/13] iommufd, guestmemfs: Ensure persistent file
 used for persistent DMA
Message-ID: <20241003133658.GC2456194@ziepe.ca>
References: <20240916113102.710522-1-jgowans@amazon.com>
 <20240916113102.710522-13-jgowans@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916113102.710522-13-jgowans@amazon.com>

On Mon, Sep 16, 2024 at 01:31:01PM +0200, James Gowans wrote:

> +#ifdef CONFIG_GUESTMEMFS_FS
> +		struct vm_area_struct *vma;
> +		struct mm_struct *mm = current->mm;
> +
> +		mmap_read_lock(mm);
> +		vma = find_vma_intersection(current->mm,
> +				 cmd->user_va, cmd->user_va + cmd->length);
> +		if (!vma || !is_guestmemfs_file(vma->vm_file)) {
> +			mmap_read_unlock(mm);
> +			return -EFAULT;
> +		}
> +		mmap_read_unlock(mm);
> +#else

Any kind of FD interaction needs to go through the new FD path that
Steve is building:

https://lore.kernel.org/linux-iommu/1727190338-385692-1-git-send-email-steven.sistare@oracle.com

I'm expecting multiple kinds of fds to fall into that pattern,
including memfs, guestmemfd, and dmabuf. guestmemfd can just be one
more..

Jason

