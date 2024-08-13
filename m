Return-Path: <kvm+bounces-24054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EB6950BEC
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 20:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C036D1F2876A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81A41A38D7;
	Tue, 13 Aug 2024 18:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="eMr3omEH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FFB1CD0C
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723572163; cv=none; b=a6IcYfu7xn+5Muv5VfgGguCA2zsaB53b5tUQz9WjuGqqyhHkGsny688ezyNIXy/eOFeU4wn1OjUfgFwCK7NYUG2MXhMWVP1FfcmHQXqy/8bD3EcMI/ptA3JMeQoxQxQBDiAAPenbwNVjhE+ZsXVhXvBNk2eHyZUHfJQX0WetOt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723572163; c=relaxed/simple;
	bh=vrtQ/rxWfjVSVNbQ1gBg2KYSndCaRiLYElwhGiZPZhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8XkumtwGvOgLiooy08lPmyuAMFU/nRK0n0kS7dD8/0yzAaeU+nbe73uyC0RKNbAChwyViZ9yd0GHp6Glf4yaHOryxTWSovbQliifPstfdOGTLXjxTIgKmSboNZL0QpDg1zgIX/0TEZyRPj92EMWGih7/HzDLigQcuJ0BGub2b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=eMr3omEH; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7a1d81dc0beso367752085a.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 11:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1723572160; x=1724176960; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vn3CowV616pJ25++xyRwQQlTN/qF7nW/uglL3n1FjnE=;
        b=eMr3omEHbmC2zP6labtGMBodgXHdGS7DgCxNq5IM36Rq/i7mbIuoYCU0bWQ/sbZ9mZ
         Rvxu6/J0vt+UicwCt31oHnWLLBN5i583ug/jxvC1PIWC0eAVLf5l1PDajPSsW5zM0P4E
         AeezEQjfrxPdoqAh+07yerXSgftXprSTK9swDqqQTC0l2IlyGJnNX+pDot5KsIvbn1RP
         Yf54Pc4n3pMJqmW6YfINvKXoXMraeMCdCltxYm28RvMA2MNcrYGfO1Slgcu/sHMXVLJx
         E5bhPTTvNCvbpnNkKzlMOXLu9evAFLKEmBMsxZFoH8cOxLH2ou5Dh1gez7pntzF+XEle
         PNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723572160; x=1724176960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vn3CowV616pJ25++xyRwQQlTN/qF7nW/uglL3n1FjnE=;
        b=NqJoe6+M2PePL7cyVnMZnuajhbD3z8y5D5Mz5ax/lxvGz5AxUX/mna3rQsjS90FHCj
         CVZIsDI7ocF2q88bC5ZjOwgH3BzPGfZuW9b0p6HiBNMoOh62xyQSayg2dHq7JiXtxbg6
         C9KmBmAytl1U/uCon1ohKPKNt5MZqvkhT52W/7ehP7i2k0PcVVX7ef4EFpE2nHI154yO
         V3twfF2UlVzqz6Fs+SUvkJ0/BeNAV95eEMZlRuDM1kcnUgyn23Vw4nhbnk4Gd1sLSk0k
         FL/2AHuddLl+188byCSijzofRztTE9H+En09vPjf4JLW03sHfR6p46XT6K/b6xrLQlTZ
         PmTw==
X-Forwarded-Encrypted: i=1; AJvYcCUJHV8ubrhGTk3NxYmFNH0gVFBi8+1D/Mz5Ibr37E3enWTqjM8PGiSQVHDoLTSJY7VNaU25l62VqU0GK9Wu3bry2wJO
X-Gm-Message-State: AOJu0YywxHMsUtdp/+4Hi4xcVsD1SUmk+yECi60HB/iMLj2iYFtQ3I1r
	O5aXqEOhe2J2W0iifERNtvcXTP1i79fN1xQr7mSi5yM81BzxXgttfRMKuxjoByA=
X-Google-Smtp-Source: AGHT+IEWJY+4tpN9nmfejak8hMkJE4i+LaMfkj7xN4DJxO0kJOQvW/mZForSzMHiCRh0N5xtI7EWQQ==
X-Received: by 2002:a05:620a:4442:b0:79f:758:9654 with SMTP id af79cd13be357-7a4ee33ed5amr45083585a.40.1723572160390;
        Tue, 13 Aug 2024 11:02:40 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.90])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7dedffcsm361365585a.80.2024.08.13.11.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 11:02:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sdvqw-008qzt-MW;
	Tue, 13 Aug 2024 15:02:38 -0300
Date: Tue, 13 Aug 2024 15:02:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240813180238.GP1985367@ziepe.ca>
References: <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
 <20240801175339.GB4830@ziepe.ca>
 <20240801121657.20f0fdb4.alex.williamson@redhat.com>
 <20240802115308.GA676757@ziepe.ca>
 <20240802110506.23815394.alex.williamson@redhat.com>
 <20240806165312.GI676757@ziepe.ca>
 <20240806124302.21e46cee.alex.williamson@redhat.com>
 <20240807141910.GG8473@ziepe.ca>
 <20240807114643.25f78652.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807114643.25f78652.alex.williamson@redhat.com>

On Wed, Aug 07, 2024 at 11:46:43AM -0600, Alex Williamson wrote:

> Please tell me how this is ultimately different from invoking a
> DEVICE_FEATURE call to request that a new device specific region be
> created with the desired mappings. 

I think this is more complex for userspace and the drivers to
implement than just asking for a new pgoff directly..

A new pgoff we can manage pretty much generically with some new core
code, some driver helpers, and adjusting the drivers to use the new
helpers. I did exactly this a few years back to rdma and it was not
hard.

Dynamic region indexes, and indexes that alias other regions, seems
more tricky to me. I'm not sure how this would look.

It gets to the same place, I agree.

Jason

