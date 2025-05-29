Return-Path: <kvm+bounces-47915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE06AC7532
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 02:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B553F1891CA9
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 00:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B191A5BBE;
	Thu, 29 May 2025 00:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BS6iv+2k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F1715D1
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748479911; cv=none; b=g83QItx2S19dA/3AUyqP1AQDKnAO+a0UPgoaHJrfDW/pDcafUN4CraP3qHob4uRMEMLyuztJqcIIooUQhMFMDibP1puEOdNDLl2AKehJorZcCdwQ3QqTNxQU9HqX1CiS7IhHuR3Lte4dCXJyMqq02beNNFcPQbBVbEFt5Tk+ioA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748479911; c=relaxed/simple;
	bh=+rTKQnGeZgGs8YdLx5axg77Ntzhcx/Ihh/cognEzwc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=raucAhEan5liFQQrmXa00UEMltLpSZ9fRW91h9ptFFZjmKCOP4uAg6Fbd86agwpVHSFY2ycEjmXcxu1LFy/Cedy3UYDnM0eh2MxgIFIBP4CucoocnC+kkBq4/TaT/YC0rE/j6bWessm/QFd6vKlRTWIERkyckxi/d+q6UpleSI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=BS6iv+2k; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6f2c45ecaffso4323566d6.2
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 17:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748479908; x=1749084708; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m7hRdgXGTQcuakis/eDxmYU/0eDxi3NnS4HETM1OC1w=;
        b=BS6iv+2kOb9vopg+dkpNMTqE3pVepFkqbpLFmFYPQLmjuauAg6nq0itmLCBO/sskwD
         HLI87HikmV/nQbC+v6gPEx1GGkYJayW22o+3HteJuKP36RCIgMuQCEr+5SgJTNcn0ea0
         JZXXr9Ib93RH3NFkqvrhGrMppckAYpEVr9QI2zmuriCdb9vLb+EF4cyUTE4vlLF7wGPr
         oEvWFb/UaVKdtV/1YQ4LbKTiKSPsyh4JoH3j7RI+VhvFzpN54twfxwTDgsklOAuGh5zJ
         67UpswwVyLCPFqgyhIggADBGzhLASeX0DYjbVRTGUBSuER/Va4+PEomyRINJZe9huUDP
         hLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748479908; x=1749084708;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m7hRdgXGTQcuakis/eDxmYU/0eDxi3NnS4HETM1OC1w=;
        b=EHoZER1TqKzYi8Hd4i6bmPLqM7SC/Gi0km8lj4KehI0sixt2YNaszL+vZI0Tbwqeee
         4Tif+06l1s1Wnl5DkXQbBByTG69ZXPxClnHuLJCu4dME3nkJqanEs+TsVbSQSYV5pjqi
         g5u1ReT1nL12urQNjpUTLkB4FUSr99oq5TLRUDfznxjuIcslkdY5C84dDc4363hS8rFy
         b1aAvtZCkYrqbY87p56pZcFh4Cclc83HfEmlfb6Ra1kVU+TT9V+ZFkM+BppZc8h9US+u
         fYGalCStjCWWTIMAc9fKz0urxGSAKcWwWJSv7JJOqdONmRDu34kTu8/g/wLxP0ylpEj4
         u6sA==
X-Forwarded-Encrypted: i=1; AJvYcCVeBsPM5i7W23V0phBDTD6mMI6THDep1YylAU25NciwwW/Lqij4gQe9Nny/NcD3G4Yur50=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfkO46CLe9SZN7mkTBE8QR6zqA+NAQ8ZsbKkWH3nAnEO4RF+tU
	XIapR1Pdk/x2EjXlkwydNCXqJpWQgxm2pkCSeJ/yh4jlL7Z+m0DYkL0NfhJSwfG0tXs=
X-Gm-Gg: ASbGncvtdPgMlsVkOVstcqJmynRssKCJiUg3V3ojkBMV9MNej2451VqiruBbRhVABk7
	fA3VVOpmOnGZhA6dVgfSwD14bp6kxwJUkNrbNIhSkvZakbRWJe6A2LK1oL/pnpbzU0rCmli/4nJ
	RRhCrXkc8hcABY5vEEZgAieBk2AuoYcpt5Vig8+XcImdRN2mPBFQo7qQEsJVoj2UshRfDZVfpUX
	ICWI2ZTxz+RjskldHjzuB30PGqMId86gX4RyAFjkHNHbhAaAsxrNkDEvJcjENokfLkinU/e1qv7
	k9YFVSHIUMLiOS++LfMof2b9bVJZfE2tlM8GHVPpEd8upT7KcvCPUPsRAy2mEaME8B22tSl5O6N
	EEzz7alhw9UkkZ1dyo51qB83bB9A=
X-Google-Smtp-Source: AGHT+IGpc+ZrCcP1p+D1/956SbBLMRbvPN3eHwEszsC6VMHgEK1hA2/nvP0rMBMUIf+3RQJEGLeGmg==
X-Received: by 2002:ad4:5bcf:0:b0:6fa:c0ca:c75c with SMTP id 6a1803df08f44-6fac0cad375mr62565836d6.42.1748479908389;
        Wed, 28 May 2025 17:51:48 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fac6d5b139sm2637706d6.53.2025.05.28.17.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 17:51:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uKRUp-00000000qrb-1bN9;
	Wed, 28 May 2025 21:51:47 -0300
Date: Wed, 28 May 2025 21:51:47 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, lizhe.67@bytedance.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge
 folio
Message-ID: <20250529005147.GC192517@ziepe.ca>
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
 <3f51d180-becd-4c0d-a156-7ead8a40975b@redhat.com>
 <20250520162125.772d003f.alex.williamson@redhat.com>
 <ff914260-6482-41a5-81f4-9f3069e335da@redhat.com>
 <20250521105512.4d43640a.alex.williamson@redhat.com>
 <20250526201955.GI12328@ziepe.ca>
 <20250527135252.7a7cfe21.alex.williamson@redhat.com>
 <20250527234627.GB146260@ziepe.ca>
 <20250528140941.151b2f70.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250528140941.151b2f70.alex.williamson@redhat.com>

On Wed, May 28, 2025 at 02:09:41PM -0600, Alex Williamson wrote:

> To be fair to libvirt, we'd really like libvirt to make use of iommufd
> whenever it's available, but without feature parity this would break
> users.  

If people ask there should be no issue with making API functionality
discoverable with a query command of some kind. Alot of new stuff is
already discoverable by invoking an ioctl with bogus arguments and
checking for EOPNOTSUPP/ENOTTY.

But most likely P2P will use the same ioctl as memfd so it will not
work that way.

So for now libvirt could assume no P2P support in iommufd. A simple
algorithm would be to look for more than 1 VFIO device. Or add an xml
"disable P2P" which is a useful thing anyhow.

> Zhe, so if you have no dependencies on P2P DMA within your device
> assignment VMs, the options above may be useful or at least a data
> point for comparison of type1 vs IOMMUFD performance.  Thanks,

Even if Zhe does have P2P DMA I have a feeling the OOT P2P patch may
be workable <shrug>

Jason

