Return-Path: <kvm+bounces-22945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CAB8944DD3
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 16:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5A0B1F26116
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 14:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536031A4867;
	Thu,  1 Aug 2024 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="lUc1/9sF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B0616DECD
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722521959; cv=none; b=GyMNYYN/rydQ9DfIh5EPusxBPE2VizryRRm4Hyfkwh+b/QCyl4zPbPdJ5o4poZk2M3tQArieUjpREPnrFohHgRUXr9yxI35gDzAZVO0oXtaT6l/nvpU/zKtSYAlxD/P862KRXtQpksgmZH7nq/oPVfT/IqF0c6XSmZcSzhDpoC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722521959; c=relaxed/simple;
	bh=KlKHNQgNuF/4kWGdo4PTveuvbRwTQaZ/fqvJOwJmxEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mw/jQpIdLeXG0S6aRHrPz26eOo8F86KvSl/riaLpaqFrqBlRcjsjbrKoRkowAshkIn/SPZDVyWuB4JX4K0ndfWBcmMcFRDWdb4afiKARfJ1KGolxGaidjBBQxuD4TuFhHUfaa3J3VjLQRyhmsOGvHdlp26XYREdVNxzV6Qsqxn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=lUc1/9sF; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7a1d42da3baso487690185a.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 07:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722521955; x=1723126755; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4G88OGzZNR0hW6g86Xna3cIKDQd/S+yxNqdbP6oxzE=;
        b=lUc1/9sFn0rSuPQBwrUvajgpjdjKAmHtfRiYsRTtsz/oxa722Hr+x1irSxB+mKSVhY
         1zIDkTEudqJF1FoUAbagD3gf6M5zPC4BL6UVak6M/DzXgVw8OGxiBRMCf82q1FOVb1fR
         ipT85QCguGiwrf+tQ5QwBbS3I6hh0gOvH1CI9v31Ko6wY/WhFPNt5kAvdYhSniJp5d0X
         25OcdmwA8QXLvrubVYpUsSq/BIi3OPDsUbWYEb3HfRGhaHo+gqKcD4UMPFBXwNJZdA7B
         oKhdJfGGXDMoWJaFLgLzkgE7OktEwiTPw3SBM+fFcl3BMmhZvzKw30oMeK2wcEOHabAF
         TW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722521955; x=1723126755;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4G88OGzZNR0hW6g86Xna3cIKDQd/S+yxNqdbP6oxzE=;
        b=TLdaRq3pS5Y45cL384Ru3a3ciDorEJYINK6ZaE+6WkyOlFXuLYd9DFmrCCjej8881z
         c+amcCg7BteF693tkmBvFnqTX/3CqL6u/9DZjyGdPcFdRLAWdrzy39QsIgu5Zqsmr8HE
         Yg8s/ZsktSS60PxDuqNXK/78S62wiilbLw+vlDLMYZoNTuiHe6hzFL9LbgOJRPs5Ptxp
         Wz83WeE90MTSsK6s8SmPAjQuW2gPNZw2C70H7Y1LjFC2X1/36VmY0Dzl3eQqT9b6oDA7
         hh/PYClL/cDMuxpTaYOwVA2Ev4oHSW4w+2eMy2lnz8PVND42ll9EncuP4wzzcusHdVu/
         xPcQ==
X-Gm-Message-State: AOJu0YyVCavyvGZ+YcBJZ5V38FPzBDrIDtQ7mZ0c9QgO/J2aHhSsM2Jc
	Id09uz/DVtovCpcvSp3GJnJN1Jgu5FJCMmFKNiq5Sfrm3HAYQAE/j8z+IkpGfJplE6D5LEB5nW8
	5
X-Google-Smtp-Source: AGHT+IFzGc70jCq/t7X+8Nm1j2ktI5f1IclnXsr4eAp9BI539dthTx2BJSCGZ4meM0xZO82pRojsRg==
X-Received: by 2002:a05:620a:1a8e:b0:7a1:db8c:2adb with SMTP id af79cd13be357-7a34efd7d6amr15043285a.57.1722521955509;
        Thu, 01 Aug 2024 07:19:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1d73ea990sm846312685a.55.2024.08.01.07.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 07:19:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sZWeA-00C3CX-Bb;
	Thu, 01 Aug 2024 11:19:14 -0300
Date: Thu, 1 Aug 2024 11:19:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Keith Busch <kbusch@meta.com>
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240801141914.GC3030761@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731155352.3973857-1-kbusch@meta.com>

On Wed, Jul 31, 2024 at 08:53:52AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Write combining can be provide performance improvement for places that
> can safely use this capability.
> 
> Previous discussions on the topic suggest a vfio user needs to
> explicitly request such a mapping, and it sounds like a new vfio
> specific ioctl to request this is one way recommended way to do that.
> This patch implements a new ioctl to achieve that so a user can request
> write combining on prefetchable memory. A new ioctl seems a bit much for
> just this purpose, so the implementation here provides a "flags" field
> with only the write combine option defined. The rest of the bits are
> reserved for future use.

This is a neat hack for sure

But how about adding this flag to vfio_region_info ?

@@ -275,6 +289,7 @@ struct vfio_region_info {
 #define VFIO_REGION_INFO_FLAG_WRITE    (1 << 1) /* Region supports write */
 #define VFIO_REGION_INFO_FLAG_MMAP     (1 << 2) /* Region supports mmap */
 #define VFIO_REGION_INFO_FLAG_CAPS     (1 << 3) /* Info supports caps */
+#define VFIO_REGION_INFO_REQ_WC         (1 << 4) /* Request a write combining mapping*/
        __u32   index;          /* Region index */
        __u32   cap_offset;     /* Offset within info struct of first cap */
        __aligned_u64   size;   /* Region size (bytes) */


It specify REQ_WC when calling VFIO_DEVICE_GET_REGION_INFO

The kernel will then return an offset value that yields a WC
mapping. It doesn't displace the normal non-WC mapping?

Arguably we should fixup the kernel to put the mmap cookies into a
maple tree so they can be dynamically allocated and more densely
packed.

Jason

