Return-Path: <kvm+bounces-36237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C625A19044
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 12:04:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE1EA1889F9F
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 11:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93515211A22;
	Wed, 22 Jan 2025 11:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="Jl2geMuk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC3F18AE2
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 11:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737543865; cv=none; b=J5kEEshZknMKtwHhCzOhuEShjZtlRfNVn8mBE/ry/ZMbGYFjS+ZkLUaJ3oz42VLA8F9/jyinpZjT2tnKoy0XVcXNo8Ju3MIeUCiQy2aEjBCCMXiD8j2K83p8ImKundpiPQNdw6l6cVYrF/xZQZikjiMsaGCBF1iM+lcvM0eW0gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737543865; c=relaxed/simple;
	bh=IPwOR+QABLGmrAGVaCprzuYcm04lJJQyT+nIiqTObII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdSK+yKWnbwvmQp96WpvunIsfO0diE7oCjtnGmer164J6wyjzeFUUT0mcXdtKjMZtlTyWj0CclM/47fr3n9U1jCpc0DvhuNRkMLLmhTlV4e2DPX43WnOv61BdxQnCea2GlWyGr1kFyPP3ACU9BRBRpC/6s6tzoyGmJ9mrJ2Ot+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=Jl2geMuk; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43635796b48so4788275e9.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 03:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1737543862; x=1738148662; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QNKmVEJcMrt9FOhks8QfT0sMjwbw3/rMij1vUdNuVQw=;
        b=Jl2geMuk6zryJJ/qlSxvW1XOIeTMAehoIrdWmKGTlx97oJ5B7p2MsqRxkjnXQ+wsBq
         m10Y/GOnPcnFJUpyQPJX00HD/Z4T4r+XwRh0XwBMeqsNuxBgVUW7Hr/aMxXTGdNDMyQx
         bu1MKml3lGRUv8DUXafQiDEJvElZXY0UqlBQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737543862; x=1738148662;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QNKmVEJcMrt9FOhks8QfT0sMjwbw3/rMij1vUdNuVQw=;
        b=nWlXSIi7A0FPFXetb8fsw/Utc6V0ww0ndVP64slJx0itgWGk1NB1ve0syhZhcaQ93i
         4WotSstTaxKRtWa+73jSkgOjwpVNUvNwgB5EvzZBDV2zrPc0jkXnLYoLKWWCBSE/lNAi
         fsLoo2vX2BZxPdIfXZjCjvJ0ni3rwRzsvxx2yZQPWX6bdg47P1Xlts/HRvOn0vci4XaT
         +ePa64EYQG52/mdC60iITa2t9xyFCJxO5I2rfMe+ltmnmc+yjeylNeamoKA16KOmSvd1
         x4fUxmJlPQSbgS7FipqSDpRd46Q+xzge5L6KYUbyYu9f4Tf9q5nOmPA5wYR+ZmxtlI1R
         /YRw==
X-Forwarded-Encrypted: i=1; AJvYcCUFK5IOelKCqQqS3xZkO9rmxfb7iKoDvWubk7BsJV+8h3MLrdXxe5dB4dnQXrHTgZUuTIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2B6CSkmevYRjNEA4HLPeaNzTFA+fgCRsyS8P3f778YkB9NI0h
	uZQVMVYOE/YXN84BghIIEFmMBWZ7TBcAjdEXgDGMhfxeAfIbc8DpT7KnosYVIZI=
X-Gm-Gg: ASbGncvw3WzmXvmqQgQMsv+t/8Dx1Pq4iLylBxXwE8Tu/oQW5BWFWKw9Iy5VF3quRy5
	S+KOd7SZ1kdQy9QUtUG0n5j22BqX1QYeC58zu6Xkbxw37DEdRcOVe/JKNTV2vBG/J4uVxf+2YSt
	G0Ambssvqv4yhx1oBnGYDQ4nHXx2HIq5+I+y4MxoVOJc5Kj1kP/GOLVMAQPaCLBTLIfestdl5jp
	YINI26S50GxYd5a3XpKCdQuydFY5bgTNZap/CKt+6NOcpvecKcP5eoP1FTJvRzBwoAuPPsTBzOa
	be02yQ==
X-Google-Smtp-Source: AGHT+IEyLgGKKTKgVENVFLO5GBMmAJ9GgorJjnEixPjjatW2PZ/Ftnlip0nIwGzazHP30Xryps3t1w==
X-Received: by 2002:a05:600c:5029:b0:436:1b77:b5aa with SMTP id 5b1f17b1804b1-437c6afdbd9mr250429015e9.8.1737543861822;
        Wed, 22 Jan 2025 03:04:21 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:5485:d4b2:c087:b497])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31af925sm20526915e9.23.2025.01.22.03.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 03:04:21 -0800 (PST)
Date: Wed, 22 Jan 2025 12:04:19 +0100
From: Simona Vetter <simona.vetter@ffwll.ch>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <Z5DQsyV0vwX3Iabu@phenom.ffwll.local>
Mail-Followup-To: Jason Gunthorpe <jgg@nvidia.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
References: <20250114173103.GE5556@nvidia.com>
 <Z4d4AaLGrhRa5KLJ@phenom.ffwll.local>
 <420bd2ea-d87c-4f01-883e-a7a5cf1635fe@amd.com>
 <Z4psR1qoNQUQf3Q2@phenom.ffwll.local>
 <c10ae58f-280c-4131-802f-d7f62595d013@amd.com>
 <20250120175901.GP5556@nvidia.com>
 <Z46a7y02ONFZrS8Y@phenom.ffwll.local>
 <20250120194804.GT5556@nvidia.com>
 <Z4_HNA4QQbIsK8D9@phenom.ffwll.local>
 <20250121173633.GU5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250121173633.GU5556@nvidia.com>
X-Operating-System: Linux phenom 6.12.3-amd64 

On Tue, Jan 21, 2025 at 01:36:33PM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 21, 2025 at 05:11:32PM +0100, Simona Vetter wrote:
> > On Mon, Jan 20, 2025 at 03:48:04PM -0400, Jason Gunthorpe wrote:
> > > On Mon, Jan 20, 2025 at 07:50:23PM +0100, Simona Vetter wrote:
> > > > On Mon, Jan 20, 2025 at 01:59:01PM -0400, Jason Gunthorpe wrote:
> > > > > On Mon, Jan 20, 2025 at 01:14:12PM +0100, Christian König wrote:
> > > > > What is going wrong with your email? You replied to Simona, but
> > > > > Simona Vetter <simona.vetter@ffwll.ch> is dropped from the To/CC
> > > > > list??? I added the address back, but seems like a weird thing to
> > > > > happen.
> > > > 
> > > > Might also be funny mailing list stuff, depending how you get these. I
> > > > read mails over lore and pretty much ignore cc (unless it's not also on
> > > > any list, since those tend to be security issues) because I get cc'ed on
> > > > way too much stuff for that to be a useful signal.
> > > 
> > > Oh I see, you are sending a Mail-followup-to header that excludes your
> > > address, so you don't get any emails at all.. My mutt is dropping you
> > > as well.
> > > 
> > > > Yeah I'm not worried about cpu mmap locking semantics. drm/ttm is a pretty
> > > > clear example that you can implement dma-buf mmap with the rules we have,
> > > > except the unmap_mapping_range might need a bit fudging with a separate
> > > > address_space.
> > > 
> > > From my perspective the mmap thing is a bit of a side/DRM-only thing
> > > as nothing I'm interested in wants to mmap dmabuf into a VMA.
> >
> > I guess we could just skip mmap on these pfn exporters, but it also means
> > a bit more boilerplate. 
> 
> I have been assuming that dmabuf mmap remains unchanged, that
> exporters will continue to implement that mmap() callback as today.
> 
> My main interest has been what data structure is produced in the
> attach APIs.
> 
> Eg today we have a struct dma_buf_attachment that returns a sg_table.
> 
> I'm expecting some kind of new data structure, lets call it "physical
> list" that is some efficient coding of meta/addr/len tuples that works
> well with the new DMA API. Matthew has been calling this thing phyr..
> 
> So, I imagine, struct dma_buf_attachment gaining an optional
> feature negotiation and then we have in dma_buf_attachment:
> 
>         union {
>               struct sg_table *sgt;
> 	      struct physical_list *phyr;
> 	};
> 
> That's basicaly it, an alternative to scatterlist that has a clean
> architecture.
> 
> Now, if you are asking if the current dmabuf mmap callback can be
> improved with the above? Maybe? phyr should have the neccessary
> information inside it to populate a VMA - eventually even fully
> correctly with all the right cachable/encrypted/forbidden/etc flags.
> 
> So, you could imagine that exporters could just have one routine to
> generate the phyr list and that goes into the attachment, goes into
> some common code to fill VMA PTEs, and some other common code that
> will convert it into the DMABUF scatterlist. If performance is not a
> concern with these data structure conversions it could be an appealing
> simplification.
> 
> And yes, I could imagine the meta information being descriptive enough
> to support the private interconnect cases, the common code could
> detect private meta information and just cleanly fail.

I'm kinda leaning towards entirely separate dma-buf interfaces for the new
phyr stuff, because I fear that adding that to the existing ones will only
make the chaos worse. But that aside sounds all reasonable, and even that
could just be too much worry on my side and mixing phyr into existing
attachments (with a pile of importer/exporter flags probably) is fine.

For the existing dma-buf importers/exporters I'm kinda hoping for a pure
dma_addr_t based list eventually. Going all the way to a phyr based
approach for everyone might be too much churn, there's some real bad cruft
there. It's not going to work for every case, but it covers a lot of them
and might be less pain for existing importers.

But in theory it should be possible to use phyr everywhere eventually, as
long as there's no obviously api-rules-breaking way to go from a phyr back to
a struct page even when that exists.

> > At least the device mapping / dma_buf_attachment
> > side should be doable with just the pfn and the new dma-api?
> 
> Yes, that would be my first goal post. Figure out some meta
> information and a container data structure that allows struct
> page-less P2P mapping through the new DMA API.
> 
> > > I'm hoping we can get to something where we describe not just how the
> > > pfns should be DMA mapped, but also can describe how they should be
> > > CPU mapped. For instance that this PFN space is always mapped
> > > uncachable, in CPU and in IOMMU.
> > 
> > I was pondering whether dma_mmap and friends would be a good place to
> > prototype this and go for a fully generic implementation. But then even
> > those have _wc/_uncached variants.
> 
> Given that the inability to correctly DMA map P2P MMIO without struct
> page is a current pain point and current source of hacks in dmabuf
> exporters, I wanted to make resolving that a priority.
> 
> However, if you mean what I described above for "fully generic [dmabuf
> mmap] implementation", then we'd have the phyr datastructure as a
> dependency to attempt that work.
> 
> phyr, and particularly the meta information, has a number of
> stakeholders. I was thinking of going first with rdma's memory
> registration flow because we are now pretty close to being able to do
> such a big change, and it can demonstrate most of the requirements.
> 
> But that doesn't mean mmap couldn't go concurrently on the same agreed
> datastructure if people are interested.

Yeah cpu mmap needs a lot more, going with a very limited p2p use-case
first only makes sense.

> > > We also have current bugs in the iommu/vfio side where we are fudging
> > > CC stuff, like assuming CPU memory is encrypted (not always true) and
> > > that MMIO is non-encrypted (not always true)
> > 
> > tbf CC pte flags I just don't grok at all. I've once tried to understand
> > what current exporters and gpu drivers do and just gave up. But that's
> > also a bit why I'm worried here because it's an enigma to me.
> 
> For CC, inside the secure world, is some information if each PFN
> inside the VM is 'encrypted' or not. Any VM PTE (including the IOPTEs)
> pointing at the PFN must match the secure world's view of
> 'encrypted'. The VM can ask the secure world to change its view at
> runtime.
> 
> The way CC has been bolted on to the kernel so far laregly hides this
> from drivers, so it is troubled to tell in driver code if the PFN you
> have is 'encrypted' or not. Right now the general rule (that is not
> always true) is that struct page CPU memory is encrypted and
> everything else is decrypted.
> 
> So right now, you can mostly ignore it and the above assumption
> largely happens for you transparently.
> 
> However, soon we will have encrypted P2P MMIO which will stress this
> hiding strategy.

It's already breaking with stuff like virtual gpu drivers, vmwgfx is
fiddling around with these bits (at least last I tried to understand this
all) and I think a few others do too.

> > > > I thought iommuv2 (or whatever linux calls these) has full fault support
> > > > and could support current move semantics. But yeah for iommu without
> > > > fault support we need some kind of pin or a newly formalized revoke model.
> > > 
> > > No, this is HW dependent, including PCI device, and I'm aware of no HW
> > > that fully implements this in a way that could be useful to implement
> > > arbitary move semantics for VFIO..
> > 
> > Hm I thought we've had at least prototypes floating around of device fault
> > repair, but I guess that only works with ATS/pasid stuff and not general
> > iommu traffic from devices. Definitely needs some device cooperation since
> > the timeouts of a full fault are almost endless.
> 
> Yes, exactly. What all real devices I'm aware have done is make a
> subset of their traffic work with ATS and PRI, but not all their
> traffic. Without *all* traffic you can't make any generic assumption
> in the iommu that a transient non-present won't be fatal to the
> device.
> 
> Stuff like dmabuf move semantics rely on transient non-present being
> non-disruptive...

Ah now I get it, at the iommu level you have to pessimistically assume
whether a device can handle a fault, and none can for all traffic. I was
thinking too much about the driver level where generally the dma-buf you
importer are only used for the subset of device functions that can cope
with faults on many devices.

Cheers, Sima
-- 
Simona Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

