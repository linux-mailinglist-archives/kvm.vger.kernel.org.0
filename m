Return-Path: <kvm+bounces-17070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD89E8C073C
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 00:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EEE2B210F0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 22:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31311332B5;
	Wed,  8 May 2024 22:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UtAdvgx/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78337132C38
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715206482; cv=none; b=SJlfIsTXnHfob8nUXVkgWZD8oFW8kwoBNhQVghkF4k6RjyVngyoigMOq5qS5BQKLmXFw8NNtyznuFFyeEz9A3ht818zX/dcnR2MZJ/tNxmI87QvQDdAKVyNNpzaNOeOdExt4Q00+o4E1GqizxbBFO3HMgoxvwikijXysROZesVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715206482; c=relaxed/simple;
	bh=+Ao4yAI4mBjlM1cqgglOXt+RF11lFCvP7EpPBkwdEWE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8i9INtryopqted2P7kpx6vx+huK1M/vONq5cVGkp1jOLN1v8P3q5ITnvxsclWrHt5U155Cy42bMqkt4bOKDWkbn755qtHsBX0C0aUpaVBw2JepVAPCrqCP3pSs5gS+ojJaUgtd2FfGuU6vcyMJ6yokHor7xcIzuLuw+jvokTUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UtAdvgx/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715206478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i3G13vP2j90cJ9q1iIJXsqeuLSqXZ2uwWRDCL6P8CGI=;
	b=UtAdvgx/8QfwJtZsTvX/xBbjLyT/lJP3y8zVksjMdMJ2BxD3+j20uazsFYymYoixvkFBZr
	axfca7cwjknxQDa7AmaO0rCXllbsjdG2B/Mb1K6aHp0Ry23Bxn0+uRtmalx9oku726dqgv
	eLHirCVOZj+Afbepvp3RTmVidii+gKE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-nHepFtTDNHGenbvjApLE0g-1; Wed, 08 May 2024 18:14:37 -0400
X-MC-Unique: nHepFtTDNHGenbvjApLE0g-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2b3717c5decso237424a91.2
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 15:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715206476; x=1715811276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i3G13vP2j90cJ9q1iIJXsqeuLSqXZ2uwWRDCL6P8CGI=;
        b=MHpAC+MlGhNSfMscHybBW5sJSzGmsvuwP2YWnz+BdVbvPsw2ZJwx2mp+EjAOzcblki
         1lTQmLgWCKsynBCmKxWOKSN/btpvvWMbXk1HQS9X3/x+IV7lqQPwvHjcWscrufMvN3yD
         DLT2+8nIsy7jEzAFCz5aGKSgNACLdQ85z6+ixuJOJTE+Kju0EtmBFRZc5cdsxRcV4RAH
         9VHu/tXgCRws9iZ+L/OIQZRVIMR7Jg1DaQUDsBb4u4Qxr2CT1URLfaxF5XMILCVts+7+
         hgC48A+ra+gafgBOmjeCk4CeMvCiYHfL4pKTDUx4yAFRDPLsU19Wc6z/+xs5NodLyZPd
         W3Ug==
X-Forwarded-Encrypted: i=1; AJvYcCWPnrQx//zCjzDe14/VcxV0We4mLIw7GS590HQ0GMbgsAYG6QM9F8KcGNAoHP8T15m5KS8lCR212Uq+wik3UM156OKG
X-Gm-Message-State: AOJu0YyqJDRtHpmcYYn5550GnyO2WEl2lonwOUwSfjCWVz07FCqFptwK
	nTBKIQxKNaci/80iwUgPXWowrWbCkPW7Sr9CT0biRNJEZ2if8yQZY3slbW21g5qmqgCNd0Yjj68
	E0axRmtVwwWAD9kvYYAzVTWqEulPOTg4W4QQOHEvISFbmKJoH2w==
X-Received: by 2002:a17:90b:212:b0:2b3:28be:df00 with SMTP id 98e67ed59e1d1-2b61649c518mr3754976a91.4.1715206476124;
        Wed, 08 May 2024 15:14:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqekJWhaOCFpDvgUHfEsURtD8vvaEirNcpayRV4i36jyg3fF3di+TgBruB/JIdNfVDBYiP1w==
X-Received: by 2002:a17:90b:212:b0:2b3:28be:df00 with SMTP id 98e67ed59e1d1-2b61649c518mr3754803a91.4.1715206469754;
        Wed, 08 May 2024 15:14:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b628ea6ae7sm1941595a91.51.2024.05.08.15.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 15:14:29 -0700 (PDT)
Date: Wed, 8 May 2024 16:14:24 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
 <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
 <corbet@lwn.net>, "joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org"
 <will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "Liu, Yi L"
 <yi.l.liu@intel.com>
Subject: Re: [PATCH 1/5] x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR
 for untracked PAT range
Message-ID: <20240508161424.5bf4bdfc.alex.williamson@redhat.com>
In-Reply-To: <ZjnwiKcmdpDAjMQ5@yzhao56-desk.sh.intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
	<20240507061924.20251-1-yan.y.zhao@intel.com>
	<BN9PR11MB5276DA8F389AAE7237C7F48E8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
	<ZjnwiKcmdpDAjMQ5@yzhao56-desk.sh.intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 7 May 2024 17:12:40 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Tue, May 07, 2024 at 04:26:37PM +0800, Tian, Kevin wrote:
> > > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > > Sent: Tuesday, May 7, 2024 2:19 PM
> > > 
> > > However, lookup_memtype() defaults to returning WB for PFNs within the
> > > untracked PAT range, regardless of their actual MTRR type. This behavior
> > > could lead KVM to misclassify the PFN as non-MMIO, permitting cacheable
> > > guest access. Such access might result in MCE on certain platforms, (e.g.
> > > clflush on VGA range (0xA0000-0xBFFFF) triggers MCE on some platforms).  
> > 
> > the VGA range is not exposed to any guest today. So is it just trying to
> > fix a theoretical problem?  
> 
> Yes. Not sure if VGA range is allowed to be exposed to guest in future, given
> we have VFIO variant drivers.

include/uapi/linux/vfio.h:
        /*
         * Expose VGA regions defined for PCI base class 03, subclass 00.
         * This includes I/O port ranges 0x3b0 to 0x3bb and 0x3c0 to 0x3df
         * as well as the MMIO range 0xa0000 to 0xbffff.  Each implemented
         * range is found at it's identity mapped offset from the region
         * offset, for example 0x3b0 is region_info.offset + 0x3b0.  Areas
         * between described ranges are unimplemented.
         */
        VFIO_PCI_VGA_REGION_INDEX,

We don't currently support mmap for this region though, so I think we
still don't technically require this, but I guess an mmap through KVM
is theoretically possible.  Thanks,

Alex

> > > @@ -705,7 +705,17 @@ static enum page_cache_mode
> > > lookup_memtype(u64 paddr)
> > >   */
> > >  bool pat_pfn_immune_to_uc_mtrr(unsigned long pfn)
> > >  {
> > > -	enum page_cache_mode cm = lookup_memtype(PFN_PHYS(pfn));
> > > +	u64 paddr = PFN_PHYS(pfn);
> > > +	enum page_cache_mode cm;
> > > +
> > > +	/*
> > > +	 * Check MTRR type for untracked pat range since lookup_memtype()
> > > always
> > > +	 * returns WB for this range.
> > > +	 */
> > > +	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE))
> > > +		cm = pat_x_mtrr_type(paddr, paddr + PAGE_SIZE,
> > > _PAGE_CACHE_MODE_WB);  
> > 
> > doing so violates the name of this function. The PAT of the untracked
> > range is still WB and not immune to UC MTRR.  
> Right.
> Do you think we can rename this function to something like
> pfn_of_uncachable_effective_memory_type() and make it work under !pat_enabled()
> too?
> 
> >   
> > > +	else
> > > +		cm = lookup_memtype(paddr);
> > > 
> > >  	return cm == _PAGE_CACHE_MODE_UC ||
> > >  	       cm == _PAGE_CACHE_MODE_UC_MINUS ||  
> >   
> 


