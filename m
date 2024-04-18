Return-Path: <kvm+bounces-15117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD468A9FF3
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:23:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D8391C20E65
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578F416F90F;
	Thu, 18 Apr 2024 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SNuobibY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF87E16C84E
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713457401; cv=none; b=LFy1nkEP29pvoKe+XOq46B8N8nbRBWCHHMOvo6rvZc3qOf8MJT76CqJLoThRzvRNafqGWxAeZkNWg+8jNgvNWhQey0yA9TPe61EPtg4pi4gfLomvnGR5EA6laDdeA+iKNdJK0TDSvMm87Pz+GeJ7fUdaBafPZi7jpqGJbxD1xLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713457401; c=relaxed/simple;
	bh=TjOvDbdSH+dx9HkxftsUqbLvpLxJA7iClDmwglPSNDI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XKfOFa904Vc0EZyfl8AnY+UUW1DdFKa1lYiM0V6T2KFx2azjXMzK8nYFfiisQjYVTO7kBtq7kRz3TM8Q39mR8m7RFnjnuAG5LrntUDIkgQNsbWXYGE4N529SDqVRrKG+VHWZ/UKkNSbUWbsYoN9uYg91VfoMhChGyRFFo5sP+pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SNuobibY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713457398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OpPhF8w7waMvk5Q41LU8inZX3Uugvi3adKbK1DhEk7o=;
	b=SNuobibYq04lJnrgikZnxW6m8K61R7wFoLv5S/iN+lqjaQvx53UAAolNiCn6ulmascx6WY
	cS3Zhg5quay1fBseWCJHRC5i9T3EtDsuABmWhYE127wJ54hPWBu98DhBSY2yR7g0a1Dsfb
	A5TXClLt9MfTfhE1BVAeJleItjYS45w=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-n1Rr5Mk7O5ykzWFd85Ys2g-1; Thu, 18 Apr 2024 12:23:17 -0400
X-MC-Unique: n1Rr5Mk7O5ykzWFd85Ys2g-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7da435d3306so8067839f.2
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 09:23:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713457396; x=1714062196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OpPhF8w7waMvk5Q41LU8inZX3Uugvi3adKbK1DhEk7o=;
        b=Oy38RbbxX8dvsUlAnHXPIwaqiwi3JwpAFTi03VD19/yUfIoUgMSyMzrwIAPYKhQ/D1
         Zoo2+xkA0mtt+PiOhnzguVlYy4Ycy+XK2NNovhDBT7h/aBs80wuszPiZUoSzCzfne1FG
         VLnQ6SPTT7vWnS+i6SthQQ2tZXf3T6UL7y3LZCZRWk99Wg5nuOTsmgGJh442zPl5vaMA
         ydHgpEjNXRliM+A7+D7lEP0v6DD4YWrJYt1bTfhtd0VpNthpR1+rnnw55f4VmEcpEJZR
         eSSmjm1P/rJP5P0moFBbZgIgHnSMSzBWRcH6xbqOp6BE9roDK9wLYFUUyhA2OjxbtlVw
         LjNA==
X-Forwarded-Encrypted: i=1; AJvYcCWK7+uk1Jtqba7wnP+6Op0Rdz4ri/hym9oEJriiRNxYEAJ549hBTEdpAfUsb3qmx+rh2LuTsNmV6EjAT2OLG8A8mut6
X-Gm-Message-State: AOJu0YxW/ctuoboim6vZwAg81I/HMO0Xe2BE6VAaZPt+pA/4q0fiFVU/
	2DQ14UO3yX2RjaceSxjCQfaIXXLdiEf1xboteMS3qrEQ7tY4zS03vlyGx1RPM6S8+HSsiTpGLgU
	exmbFOQ0Dm7gOtR68xSvq2q54o7z4enzql8So9EsBGFGYmx+Gcg==
X-Received: by 2002:a05:6602:2289:b0:7d5:f591:2cc2 with SMTP id d9-20020a056602228900b007d5f5912cc2mr3572773iod.17.1713457396758;
        Thu, 18 Apr 2024 09:23:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfNtiABViCn51G//5YknWbS0WdR7g/EL6w1vtnNGKLFbqCipmFcU3Cc0Lw1gIFArYQDtFutw==
X-Received: by 2002:a05:6602:2289:b0:7d5:f591:2cc2 with SMTP id d9-20020a056602228900b007d5f5912cc2mr3572741iod.17.1713457396409;
        Thu, 18 Apr 2024 09:23:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id hj18-20020a0566021d9200b007d5d1e0ae05sm419393iob.44.2024.04.18.09.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 09:23:15 -0700 (PDT)
Date: Thu, 18 Apr 2024 10:23:14 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: <jgg@nvidia.com>, <kevin.tian@intel.com>, <joro@8bytes.org>,
 <robin.murphy@arm.com>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
 <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
 <iommu@lists.linux.dev>, <baolu.lu@linux.intel.com>,
 <zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>, Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [PATCH v2 1/4] ida: Add ida_get_lowest()
Message-ID: <20240418102314.6a3d344a.alex.williamson@redhat.com>
In-Reply-To: <e3531550-8644-4a7e-94bd-75bdb52182be@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<20240412082121.33382-2-yi.l.liu@intel.com>
	<20240416100329.35cede17.alex.williamson@redhat.com>
	<e3531550-8644-4a7e-94bd-75bdb52182be@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 15:02:46 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2024/4/17 00:03, Alex Williamson wrote:
> > On Fri, 12 Apr 2024 01:21:18 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> >> There is no helpers for user to check if a given ID is allocated or not,
> >> neither a helper to loop all the allocated IDs in an IDA and do something
> >> for cleanup. With the two needs, a helper to get the lowest allocated ID
> >> of a range can help to achieve it.
> >>
> >> Caller can check if a given ID is allocated or not by:
> >> 	int id = 200, rc;
> >>
> >> 	rc = ida_get_lowest(&ida, id, id);
> >> 	if (rc == id)
> >> 		//id 200 is used
> >> 	else
> >> 		//id 200 is not used
> >>
> >> Caller can iterate all allocated IDs by:
> >> 	int id = 0;
> >>
> >> 	while (!ida_is_empty(&pasid_ida)) {
> >> 		id = ida_get_lowest(pasid_ida, id, INT_MAX);
> >> 		if (id < 0)
> >> 			break;
> >> 		//anything to do with the allocated ID
> >> 		ida_free(pasid_ida, pasid);
> >> 	}
> >>
> >> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> >> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> >> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> >> ---
> >>   include/linux/idr.h |  1 +
> >>   lib/idr.c           | 67 +++++++++++++++++++++++++++++++++++++++++++++
> >>   2 files changed, 68 insertions(+)
> >>
> >> diff --git a/include/linux/idr.h b/include/linux/idr.h
> >> index da5f5fa4a3a6..1dae71d4a75d 100644
> >> --- a/include/linux/idr.h
> >> +++ b/include/linux/idr.h
> >> @@ -257,6 +257,7 @@ struct ida {
> >>   int ida_alloc_range(struct ida *, unsigned int min, unsigned int max, gfp_t);
> >>   void ida_free(struct ida *, unsigned int id);
> >>   void ida_destroy(struct ida *ida);
> >> +int ida_get_lowest(struct ida *ida, unsigned int min, unsigned int max);
> >>   
> >>   /**
> >>    * ida_alloc() - Allocate an unused ID.
> >> diff --git a/lib/idr.c b/lib/idr.c
> >> index da36054c3ca0..03e461242fe2 100644
> >> --- a/lib/idr.c
> >> +++ b/lib/idr.c
> >> @@ -476,6 +476,73 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
> >>   }
> >>   EXPORT_SYMBOL(ida_alloc_range);
> >>   
> >> +/**
> >> + * ida_get_lowest - Get the lowest used ID.
> >> + * @ida: IDA handle.
> >> + * @min: Lowest ID to get.
> >> + * @max: Highest ID to get.
> >> + *
> >> + * Get the lowest used ID between @min and @max, inclusive.  The returned
> >> + * ID will not exceed %INT_MAX, even if @max is larger.
> >> + *
> >> + * Context: Any context. Takes and releases the xa_lock.
> >> + * Return: The lowest used ID, or errno if no used ID is found.
> >> + */
> >> +int ida_get_lowest(struct ida *ida, unsigned int min, unsigned int max)
> >> +{
> >> +	unsigned long index = min / IDA_BITMAP_BITS;
> >> +	unsigned int offset = min % IDA_BITMAP_BITS;
> >> +	unsigned long *addr, size, bit;
> >> +	unsigned long flags;
> >> +	void *entry;
> >> +	int ret;
> >> +
> >> +	if (min >= INT_MAX)
> >> +		return -EINVAL;
> >> +	if (max >= INT_MAX)
> >> +		max = INT_MAX;
> >> +  
> > 
> > Could these be made consistent with the test in ida_alloc_range(), ie:
> > 
> > 	if ((int)min < 0)
> > 		return -EINVAL;
> > 	if ((int)max < 0)
> > 		max = INT_MAX;
> >   
> 
> sure.
> 
> >> +	xa_lock_irqsave(&ida->xa, flags);
> >> +
> >> +	entry = xa_find(&ida->xa, &index, max / IDA_BITMAP_BITS, XA_PRESENT);
> >> +	if (!entry) {
> >> +		ret = -ENOTTY;  
> > 
> > -ENOENT?  Same for all below too.  
> 
> I see.
> 
> >> +		goto err_unlock;
> >> +	}
> >> +
> >> +	if (index > min / IDA_BITMAP_BITS)
> >> +		offset = 0;
> >> +	if (index * IDA_BITMAP_BITS + offset > max) {
> >> +		ret = -ENOTTY;
> >> +		goto err_unlock;
> >> +	}
> >> +
> >> +	if (xa_is_value(entry)) {
> >> +		unsigned long tmp = xa_to_value(entry);
> >> +
> >> +		addr = &tmp;
> >> +		size = BITS_PER_XA_VALUE;
> >> +	} else {
> >> +		addr = ((struct ida_bitmap *)entry)->bitmap;
> >> +		size = IDA_BITMAP_BITS;
> >> +	}
> >> +
> >> +	bit = find_next_bit(addr, size, offset);
> >> +
> >> +	xa_unlock_irqrestore(&ida->xa, flags);
> >> +
> >> +	if (bit == size ||
> >> +	    index * IDA_BITMAP_BITS + bit > max)
> >> +		return -ENOTTY;
> >> +
> >> +	return index * IDA_BITMAP_BITS + bit;
> >> +
> >> +err_unlock:
> >> +	xa_unlock_irqrestore(&ida->xa, flags);
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL(ida_get_lowest);  
> > 
> > The API is a bit awkward to me, I wonder if it might be helped with
> > some renaming and wrappers...
> > 
> > int ida_find_first_range(struct ida *ida, unsigned int min, unsigned int max);  
> 
> ok.
> 
> > bool ida_exists(struct ida *ida, unsigned int id)
> > {
> > 	return ida_find_first_range(ida, id, id) == id;
> > }  
> 
> this does helps in next patch.
> 
> > 
> > int ida_find_first(struct ida *ida)
> > {
> > 	return ida_find_first_range(ida, 0, ~0);
> > }
> >  
> 
> perhaps it can be added in future. This series has two usages. One is to
> check if a given ID is allocated. This can be covered by your ida_exists().
> Another usage is to loop each IDs, do detach and free. This can still use
> the ida_find_first_range() like the example in the commit message. The
> first loop starts from 0, and next would start from the last found ID.
> This may be more efficient than starts from 0 in every loop.
> 
> 
> > _min and _max variations of the latter would align with existing
> > ida_alloc variants, but maybe no need to add them preemptively.  
> 
> yes.
> 
> > Possibly an ida_for_each() could be useful in the use case of
> > disassociating each id, but not required for the brute force iterative
> > method.  Thanks,  
> 
> yep. maybe we can start with the below code, no need for ida_for_each()
> today.
> 
> 
>   	int id = 0;
> 
>   	while (!ida_is_empty(&pasid_ida)) {
>   		id = ida_find_first_range(pasid_ida, id, INT_MAX);

You've actually already justified the _min function here:

static inline int ida_find_first_min(struct ida *ida, unsigned int min)
{
	return ida_find_first_range(ida, min, ~0);
}

Thanks,
Alex

>   		if (unlikely(WARN_ON(id < 0))
> 			break;
>   		iommufd_device_pasid_detach();
>   		ida_free(pasid_ida, pasid);
>   	}
> 
> >   
> >> +
> >>   /**
> >>    * ida_free() - Release an allocated ID.
> >>    * @ida: IDA handle.  
> >   
> 


