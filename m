Return-Path: <kvm+bounces-28069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A209930D3
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 17:12:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CF57284B53
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 15:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AFD1EB25;
	Mon,  7 Oct 2024 15:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Fp4pIDqs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D949F1D9337
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 15:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728313866; cv=none; b=cKbdaIMGLOvLn8TGcVuvYLnF5raYZeTrzzIpaFCwIOJzba+1C2inWZWV3Z1u2U6Lev2AFSglOxzhQZhXqGcKCm4uOhOw+0LzZpvLKWEysd9WiS2B7JSA4JKvsmGMTY82uLMHReANn74mvdpojJVisTVoQNi6FJvJHiXJEIEvk9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728313866; c=relaxed/simple;
	bh=7sRwQOu6EuU7X4TK7vsW/hz6zSDAVaacvkEkJknd0C4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TdgdKuklyjS3mNFPFcqAh2H7am72cxK4Lc11+SMh+qxcEc6fJblLU1KqB/bVz2M/QR68wali2a59T8P9jGdC0wHRzcF5zZLBeBA5IQKY/pkFGgQF/ebKpkUyh5y8YBY/IVDCfuZCp4cB137jKmNAUVDx2ukT8onLIIcriKYeJ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Fp4pIDqs; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7a9acc6f22dso424034485a.0
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 08:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1728313864; x=1728918664; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CHmDKz6VoCoOWhFGRrnQD6b1xtdA1wt9ENap+Algfjk=;
        b=Fp4pIDqsVbqRs9imFwC+JRk1/Bkfmj93+eFIYUlWihbjcXrJVNN/BBzmwX73hUPeAB
         PyHFtgznJct7VPfQZP3nLev1QH4Um6irpRWB0vnDYJPS2Q2dgBhBUSaHhtGpIjwxx/wJ
         p6I9ae7Y2s7xxTG/xnEBCEML2IhA2EGYAcRorlSwPF4tR/OlZ4dl7HWHgQ+Ik5XpcTU3
         tGFQ/j/Z81JLX3ONw0vRGI1QH5WNW1/hRYyp/5sTRdmgL5o18mRnURck19webG1TGO1Q
         nCEPm1LrJyOGcm/YEfZ/COKEs8wsoq7tQODRO+7uTTnNbGm4rhXvXWGpefoOYAfMPQO9
         oaYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728313864; x=1728918664;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHmDKz6VoCoOWhFGRrnQD6b1xtdA1wt9ENap+Algfjk=;
        b=LSNL6TrlmgrXhk42+KlsTzQD1e1AfUHKfphYUTeba0r0JsEdnjA0DL9AaGR4SuydSJ
         9Ouzd0glLCj18ABtNvxWANz6f+jMiE9wJZVG7MwbKMJO+jCu2bWHmiM7YRAR4jzjxfBY
         uxnfo5c522f6s0wiEUr3S2TZdyEfMO6IDs9xN6XkETDzPzWuKSGIfZ91W9r1+otfvdjK
         3/cnFt4neALPoxmXlAr6EKagA5eM6MtnCjc4Rnp0wFMg/JeFqkkJL2QAprxKXF5be+kp
         uDl6VwmQ5gEPZt4YtBBSlRnOx4jxVrDTlpwD/0XuwGHYhgJv5FsDOkvWyXn3bF9rSNtX
         Imrw==
X-Forwarded-Encrypted: i=1; AJvYcCUVy7uiffqcCGp5CHm6V08JcVyp+OCDF6Z3SBfF9xklt2w3y2Jn3K806jEtD9s0Y26fT08=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbHP8KEkbH1kC6m3CBAHrVDGZvcPnkkab3Kd/H1H501Q+Oaw1p
	d33RZ7Eji1GxFb3iYYRIAwH4Cj3N+8ZpBMFoRO6Q0oyiNdL6r619ZCt4sXwQbbX3JUS7vwnjuwj
	I
X-Google-Smtp-Source: AGHT+IG9gun4r5qe4Piv/4D/AVhBJRCFK/ZGEgynw3hqWzjEFdyFae9aEowZ/wsmNcBJlrHvcbyaVw==
X-Received: by 2002:a05:620a:f0e:b0:7ab:3511:4eda with SMTP id af79cd13be357-7ae6f458964mr1726379885a.34.1728313863822;
        Mon, 07 Oct 2024 08:11:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45da74ef1c0sm27187531cf.35.2024.10.07.08.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 08:11:02 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sxpO2-002ZKU-Cr;
	Mon, 07 Oct 2024 12:11:02 -0300
Date: Mon, 7 Oct 2024 12:11:02 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Gowans, James" <jgowans@amazon.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "kw@linux.com" <kw@linux.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Saenz Julienne, Nicolas" <nsaenz@amazon.es>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"steven.sistare@oracle.com" <steven.sistare@oracle.com>,
	"Graf (AWS), Alexander" <graf@amazon.de>,
	"will@kernel.org" <will@kernel.org>,
	"joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Message-ID: <20241007151102.GN2456194@ziepe.ca>
References: <20240916113102.710522-1-jgowans@amazon.com>
 <20240916113102.710522-6-jgowans@amazon.com>
 <20241002185520.GL1369530@ziepe.ca>
 <d6328467adc9b7512f6dd88a6f8f843b8efdc154.camel@amazon.com>
 <e458d48a797043b7efc853fc65b9c4d043b12ed4.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e458d48a797043b7efc853fc65b9c4d043b12ed4.camel@infradead.org>

On Mon, Oct 07, 2024 at 09:47:53AM +0100, David Woodhouse wrote:
> On Mon, 2024-10-07 at 08:39 +0000, Gowans, James wrote:
> > 
> > I think we have two other possible approaches here:
> > 
> > 1. What this RFC is sketching out, serialising fields from the structs
> > and setting those fields again on deserialise. As you point out this
> > will be complicated.
> > 
> > 2. Get userspace to do the work: userspace needs to re-do the ioctls
> > after kexec to reconstruct the objects. My main issue with this approach
> > is that the kernel needs to do some sort of trust but verify approach to
> > ensure that userspace constructs everything the same way after kexec as
> > it was before kexec. We don't want to end up in a state where the
> > iommufd objects don't match the persisted page tables.
> 
> To what extent does the kernel really need to trust or verify? 

If iommufd is going to adopt an existing iommu_domain then that
iommu_domain must have exactly the IOPTEs it expects it to have
otherwise there will be functional problems in iommufd.

So, IMHO, some kind of validation would be needed to ensure that
userspace has created the same structure as the old kernel had.

 >At LPC we seemed to speak of a model where userspace builds a "new"
> address space for each device and then atomically switches to the
> new page tables instead of the original ones inherited from the
> previous kernel.

The hitless replace model would leave the old translation in place
while userspace builds up a replacement translation that is
equivalent. Then hitless replace would adopt the new translation and
we discard the old ones memory.

IMHO this is easiest to make correct and least maintenance burden
because the only kernel thing you are asking for in iommufd is hitless
iommu_domain replace, which we already want to add to the drivers
anyhow. (ARM already has it)

Jason

