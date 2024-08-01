Return-Path: <kvm+bounces-22963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87DD0945038
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:11:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E87E2821B4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 16:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52CAF1DA58;
	Thu,  1 Aug 2024 16:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mf4YQdxT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BD013D2B7
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722528694; cv=none; b=enZTm1e86iI1jwhtTx8YAtGqyXRu3gtuEFJ0q/pTqUnW2RqsjoHU7RVQJ3dnx08RB9V6lPbYHrcEOUfjtrIkgKUJwFMqUq+T798e5ivogFYAOMw/dr0oxpkRUccHRmdg9SyfPk3wnRLlNVQuZtWc0rSSGeGpwlCtdy0dxe21zx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722528694; c=relaxed/simple;
	bh=OAe7Fki8UdU0ncqxorlf29MiZy3v+k92dPe/lKQd9Z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWkHlGAGl4UJsyUvaJxOhB1iKF3yQirtmm0kUU7RBlWKtRIDvcNZf3zc631LC4Oa4ViEO7Xx9mh0egTD6VJ0Sd08POD9FqUKA+j6oI+ljQxsIOBcF/a6xpugIvbWfII5B+XCIHgtz64rALJu+vZJz4HTUMfZuZ3hBeI+FGJkTuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mf4YQdxT; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2611da054fbso4517372fac.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 09:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722528691; x=1723133491; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cViVO1JE7qn2DXZ4158R1HvCsr65F1ophhFWkVExwxA=;
        b=mf4YQdxTtGSyfqPW+dEi+y5VoTKCDodLfR8Qp5h6+7VvbWbsuk++fj7tk1ok0cRtiX
         po7jarKy1O9bChwcflamVtpk3vnBVihUyZLPUrmqnJjYO4pbd9yJSWaJ6nXCz/AWBSG0
         DIbwE9gv/g7XxnG2K0cShVt245c3llOwzcEN6652XHqb57Ar06rh1H/o0W9CPFga7M/g
         hsoDDvXnGEZs9RAGok3lYoS/rWIdxiGDJ/+thq9TtPZpMj44iupuKg1PoY4oFqy4nR4y
         yhYq3qkyuco5aB43FZ2fcj9gojLrU6KvIt6HIOAF6sv5J50HmQ3deHd2hPMErCPf0C0b
         xyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722528691; x=1723133491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cViVO1JE7qn2DXZ4158R1HvCsr65F1ophhFWkVExwxA=;
        b=uH+eJqXuQ4gKLz2t5E693r2A3+mxTeOMtV9xeM3O2vNhXWeQ2zFnNhDzfb7CZw72ea
         GVa9Zh+hZ/8r/YhrGDJCP4P6LB7CT0ZlPKLCPB3qZzsk3Hn7dp3Haj/g8YK6qZALfDUQ
         Pqa0arUVYJnHH5Qiv5rIZABtIN1Q8lS+M6jZQO8aPCMKuvsZQZWPgrI9UVey/Ylhr3a0
         Bg+lvNdz/IcYEfv4+PcBqQ4Kce8e+gwG11/NXeBt0LehDurzXMkfhGpuMLS5cMAt/Akh
         B5pO1TnT6PkqPZY3uj1E9EBuYNsCGOFSB5SuQil/PphslZhiJAdXQZEUR54RnjIy09kw
         HneQ==
X-Forwarded-Encrypted: i=1; AJvYcCX274fAuwOcXYnTC39ViB53O+yEn3d3PFyT0T9RX/E94o7RQtq73g90Xg4UVlH2HDnD91uufS03Svj6+NU+3EgFlWsC
X-Gm-Message-State: AOJu0Yze3cdV4e++kUiDbi9B5cXArs+BB7MQXEyzz901Tz1yEuuj0f9W
	i87Y6opIT+EnnOpVtPLm34y6MsBpTre/W4uj4QJJNcUCZwvjSnlSGWXRr50pnCg=
X-Google-Smtp-Source: AGHT+IEjpF/RXiI6GVpn3on4BtOSk+B2YUGz1di1MxG7KVSdyaNZheOepFNs2z2C/nrVRc0nFeeOnQ==
X-Received: by 2002:a05:6870:3924:b0:261:9fc:16b9 with SMTP id 586e51a60fabf-26891ea4e00mr719172fac.33.1722528691325;
        Thu, 01 Aug 2024 09:11:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a34f6dce75sm3324285a.14.2024.08.01.09.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 09:11:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sZYOo-00CeQl-7W;
	Thu, 01 Aug 2024 13:11:30 -0300
Date: Thu, 1 Aug 2024 13:11:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240801161130.GD3030761@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
 <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801094123.4eda2e91.alex.williamson@redhat.com>

On Thu, Aug 01, 2024 at 09:41:23AM -0600, Alex Williamson wrote:
> On Thu, 1 Aug 2024 11:19:14 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Wed, Jul 31, 2024 at 08:53:52AM -0700, Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > Write combining can be provide performance improvement for places that
> > > can safely use this capability.
> > > 
> > > Previous discussions on the topic suggest a vfio user needs to
> > > explicitly request such a mapping, and it sounds like a new vfio
> > > specific ioctl to request this is one way recommended way to do that.
> > > This patch implements a new ioctl to achieve that so a user can request
> > > write combining on prefetchable memory. A new ioctl seems a bit much for
> > > just this purpose, so the implementation here provides a "flags" field
> > > with only the write combine option defined. The rest of the bits are
> > > reserved for future use.  
> > 
> > This is a neat hack for sure
> > 
> > But how about adding this flag to vfio_region_info ?
> > 
> > @@ -275,6 +289,7 @@ struct vfio_region_info {
> >  #define VFIO_REGION_INFO_FLAG_WRITE    (1 << 1) /* Region supports write */
> >  #define VFIO_REGION_INFO_FLAG_MMAP     (1 << 2) /* Region supports mmap */
> >  #define VFIO_REGION_INFO_FLAG_CAPS     (1 << 3) /* Info supports caps */
> > +#define VFIO_REGION_INFO_REQ_WC         (1 << 4) /* Request a write combining mapping*/
> >         __u32   index;          /* Region index */
> >         __u32   cap_offset;     /* Offset within info struct of first cap */
> >         __aligned_u64   size;   /* Region size (bytes) */
> > 
> > 
> > It specify REQ_WC when calling VFIO_DEVICE_GET_REGION_INFO
> > 
> > The kernel will then return an offset value that yields a WC
> > mapping. It doesn't displace the normal non-WC mapping?
> > 
> > Arguably we should fixup the kernel to put the mmap cookies into a
> > maple tree so they can be dynamically allocated and more densely
> > packed.
> 
> vfio_region_info.flags in not currently tested for input therefore this
> proposal could lead to unexpected behavior for a caller that doesn't
> currently zero this field.  It's intended as an output-only field.

Perhaps a REGION_INFO2 then?

I still think per-request is better than a global flag

Jason

