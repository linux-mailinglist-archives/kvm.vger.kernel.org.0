Return-Path: <kvm+bounces-41316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E5BA6621B
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:54:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC16D17A5AE
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 22:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7481620468F;
	Mon, 17 Mar 2025 22:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J4bB+RNE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087891EEA20
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 22:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742252037; cv=none; b=A0bYLt0HfNSjIZ4B071EChh/3v28ZM97QXjCx9aRdIOTv8YRDKYMHsjizA+yd0yWuNQIgMtj1PM3LbVbKWLdpNVPQM2qVygXV7SQ/HKSiKDyhyo3UzsLQ13naMM7lifEdBbJnA4/A7l3ZCON1UMvt1LGLCSkC/ArbvQAe2v5K6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742252037; c=relaxed/simple;
	bh=UqqUcGLUoEgIzTCuGW12ZWOGkPyqd3Ag/HBeGljWbT0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJRLJm1fzL21p59kP+nPBpOLflqlntkEoLYpLL709wgwaG8Pj/SX5IT0NSQrNR4Svjok7uAdmp3LeZuQLvFHrH5TwS50Mud/BLhU/LrGBpm9Hpka6scm9wFTO5RZO0ZF6DtIaKJDyzQGcXXgcMw/GAc6G2PtWCTJjjsL/q5D9Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J4bB+RNE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742252034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqeIPRzyfwbqLejnBmV657w90fLz0MxvVllnZ0oEcM0=;
	b=J4bB+RNE904B2gwM26Gu0CJXdi3DCWPM5ITe+V8jjTEo43WMtTnntR+thVEKW/5Ttro5L1
	ucYpnNhvPFuDIHNDxFUHLzNSU6yzp+17MGfFbybwMIvyuT5NvwmH17uOZ7GgbGdBF1ERTv
	AbECwuEbgHj0/8rqGPcVsTVV2ErT7Eg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-499vvNvON9y1A0WQndSEog-1; Mon, 17 Mar 2025 18:53:53 -0400
X-MC-Unique: 499vvNvON9y1A0WQndSEog-1
X-Mimecast-MFC-AGG-ID: 499vvNvON9y1A0WQndSEog_1742252033
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-85da07ce5cbso75057439f.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 15:53:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742252032; x=1742856832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XqeIPRzyfwbqLejnBmV657w90fLz0MxvVllnZ0oEcM0=;
        b=BWr5+UwBClrwf5H7afIxNYNrGqd1Df/iJDDpkFvClqbiSlyro17FT+p4o1ov8TZSdg
         J/cbx+4v5DICnYwfy6zSpEKZn3U9rcmsp7jEMMCTINB/Z5L+aLYYE717KkMjmsiqUkoQ
         EXvQH9T+JSdpQdaIX5Edi3hFqN7Yv0YB3skiH9SlW+7CWN6JhZGWfMA+Hn97LXgrrkEU
         jSg8Fy4sZ9g9DL59WSNndEsvnr5RKpL9G4XMApN8L7YADV+/dWEGlnXz3QgJ2N99N1kg
         lzQQZ18aUsehhBR2DQ1V1n1xqFtDtM9e3kNGuI6rVxWSSOJLuSMn1y82EQgo44SEzc39
         uIlw==
X-Forwarded-Encrypted: i=1; AJvYcCWGRCGHKLjO6kEAj575S3KJPdqOYQw5BuXTcqh4GrsBHOEDOiDNSVb+iOR/gaQFKwMQiMk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2XZ4aFRqMU6SiFue0NnYAxBOohJSjYtg7vYBCgvuh0J7supE0
	Si5zF68A4h0otU3DHrhdjv7g7bkCFcqEHhGXrHFzHl2ukf6EBg1n+wuejuuKe3cMj5UY/lNMkLQ
	xRrO4LKIjUlHKAw5PxsKueGOj+3DGlff13U/sMcCPOsqPpOKJbwyQ7CGBzw==
X-Gm-Gg: ASbGncuH31FipBNuEOCalqGk+HnV31KK32Y02tmYH7UxKDGmnJoagn1516AD9smXNUC
	kRAh+HnSJtqFXyt50D5HsZtcsAUqfslpcvdGAAHG7BRT/IT+PM5m3We/6eWj1v0v9mp1B8EpDKP
	26VEwo41imjModcOI/NKnMuNycCOaZyKR/BMYCpwiGjrKpeLNhe7gEfr2izBGlBWyiofWrdYEfN
	2UaxiyhdjHSHqCG7L76d778eLiaCHac8e9I6oJA5tNpBleAS1p0H1oj1u/OHmAt9luipy1aUM16
	RIEGmgqMXgBUHMlIORo=
X-Received: by 2002:a05:6602:1409:b0:85d:9d7c:b89 with SMTP id ca18e2360f4ac-85dc47b5c8cmr488422739f.1.1742252032067;
        Mon, 17 Mar 2025 15:53:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlSewvQ29QnuXkQ61c+40Yzz0vpfEUUBSSfqQEV1xh1D9Rw7K7g3CylefoLZYw9k9hSl17UA==
X-Received: by 2002:a05:6602:1409:b0:85d:9d7c:b89 with SMTP id ca18e2360f4ac-85dc47b5c8cmr488422139f.1.1742252031712;
        Mon, 17 Mar 2025 15:53:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85dcbfdebfcsm179398639f.22.2025.03.17.15.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 15:53:50 -0700 (PDT)
Date: Mon, 17 Mar 2025 16:53:47 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <20250317165347.269621e5.alex.williamson@redhat.com>
In-Reply-To: <Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
References: <20250312225255.617869-1-kbusch@meta.com>
	<20250317154417.7503c094.alex.williamson@redhat.com>
	<Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Mar 2025 16:30:47 -0600
Keith Busch <kbusch@kernel.org> wrote:

> On Mon, Mar 17, 2025 at 03:44:17PM -0600, Alex Williamson wrote:
> > On Wed, 12 Mar 2025 15:52:55 -0700  
> > > @@ -679,6 +679,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> > >  
> > >  		if (unlikely(disable_hugepages))
> > >  			break;
> > > +		cond_resched();
> > >  	}
> > >  
> > >  out:  
> > 
> > Hey Keith, is this still necessary with:
> > 
> > https://lore.kernel.org/all/20250218222209.1382449-1-alex.williamson@redhat.com/  
> 
> Thank you for the suggestion. I'll try to fold this into a build, and
> see what happens. But from what I can tell, I'm not sure it will help.
> We're simply not getting large folios in this path and dealing with
> individual pages. Though it is a large contiguous range (~60GB, not
> necessarily aligned). Shoould we expect to only be dealing with PUD and
> PMD levels with these kinds of mappings?

IME with QEMU, PMD alignment basically happens without any effort and
gets 90+% of the way there, PUD alignment requires a bit of work[1].
 
> > This is currently in linux-next from the vfio next branch and should
> > pretty much eliminate any stalls related to DMA mapping MMIO BARs.
> > Also the code here has been refactored in next, so this doesn't apply
> > anyway, and if there is a resched still needed, this location would
> > only affect DMA mapping of memory, not device BARs.  Thanks,  
> 
> Thanks for the head's up. Regardless, it doesn't look like bad place to
> cond_resched(), but may not trigger any cpu stall indicator outside this
> vfio fault path.

Note that we already have a cond_resched() in vfio_iommu_map(), which
we'll hit any time we get a break in a contiguous mapping.  We may hit
that regularly enough that it's not an issue for RAM mapping, but I've
certainly seen soft lockups when we have many GiB of contiguous pfnmaps
prior to the series above.  Thanks,

Alex

[1]https://gitlab.com/qemu-project/qemu/-/commit/00b519c0bca0e933ed22e2e6f8bca6b23f41f950


