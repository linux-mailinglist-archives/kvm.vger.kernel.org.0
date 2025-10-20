Return-Path: <kvm+bounces-60576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8245BF406F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 01:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46A6A3B34CD
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 23:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3406A26B2B0;
	Mon, 20 Oct 2025 23:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zo6r6J4A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC22239E61
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 23:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761003041; cv=none; b=rLEpCouuvz3PBF0/MwDgyV5PYyKN0oEBfm5h9PKT2xeTxTwS2qFLqrC4aRNOBiUaDUtJWoQl6O7ZGtW4p5KInzN/fjZ7O5mAhSXMF/5SNY1yjNuubSw7eSbhDJ66H1tFrOwmom7jNITHxwRRwAw79W4gERS14LB5x9StRKzAM7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761003041; c=relaxed/simple;
	bh=wBx5HU0NHsSDK23iXznXH3Oj8GG15Qr8iFROxkEtWPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWEeJGmt3Lo4Qe0wpDkPh2y1j7yExpChzqtiU5+HkOrQ4xWB9Acj1jKPt1Suofyu8Ev3jK3pKW/EDj0/ugL3I86Omv4I8EoYbziOKC7hQ9gxdDoMzExfI/pBPo/pXpsaxjmtufidcsPhnhRss1f7dUCujPxtZFeBOpiZziRw16c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zo6r6J4A; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-290d48e9f1fso56785ad.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 16:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761003030; x=1761607830; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2EojOJFcibgh1WcpC+qylb2gWt1s0H89duNTff3IMYc=;
        b=zo6r6J4AL4GIdCPnG7fdJSElKnv5fVxae3llaa3Z/Giwm6PznOJ28DnbcuUhb6bOPp
         3b5ZvLHz+R1mQtg2h0d6K+AF+nBje6kres9caqiHV15kuTJKkN6pfswEJ+TOUb6F+n3y
         Sm2zlj/uKfjxrCfyAmKQLlQPhvXEEWYZ7D+79YsPalj49vX9ERJ9gjo7s424ZlI/CAXN
         0HBzS0ynwrAgfb/9ZG2IwC5QYa2HHHZufcyh47u51lxmIizodz4pObTFsXQux5A3/2Wn
         ux8gKBvm3zZiZ6JW3yTmuR9xjqlVtF2tiMhyABvdgz4LIGymD3704/c42/D57M4+eEKo
         K3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761003030; x=1761607830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2EojOJFcibgh1WcpC+qylb2gWt1s0H89duNTff3IMYc=;
        b=KFVXpa4tZctLVwG77nW+78D6sHCQI6yQkQti4baYZJVtQYWLMYpZCbPolnc45JTOCU
         fe+Uvq3Q7JjnplEP7CXGY4Ge0Ez7fDV1nfx6zknjh0dg6hLQXBmjlNbQc6sNDTLTZyNH
         aLr8fhli/yBHuGv/zf0/SKnYp+TDsVpUUTMfUCJAGhmZSoeg6IM4d6UiHTgxOtWhjO8L
         lLzijqTm5DW0cC3n8OBjoEQYdVcyPZfeZwqDJPahRuGlk6WAwPVWzENqh42kU4Q05QND
         buQHARXTC5D6GYVgCQ1YSWf6q+Xd7aDe8nMdCtacCQM3B8n73y1DAjjSTETOlK9Wwjbn
         4YXw==
X-Forwarded-Encrypted: i=1; AJvYcCV3UPztV2bYhXWasFMUtOSMXjofKemHeUzwm6wBq5uzYP0A7ptEEuheXq2hWwkGHXHWB0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8whlGJYIXSCpHqrXdHqMpUy7gQk1IUdf2Iffu+ize6N6aO6t4
	sq8Cq5UoSxXAwTNOByXDwscxpxL9MQ8GRBqhvks/qEiByoZgWUfPYy+v4wHJ41P86g==
X-Gm-Gg: ASbGncvjjcnuX5DqPCymDL1Zzdoy27Xp1GZhKHdDZE0u9Qpgn/b/WFJ070koiCREFQ3
	KacdiGVztwE/8V8aZQBW8ZgtKrViip/DzLioin5Z1pZGercy1jw92f31gNwlEKsJ/O6CrEKLHBT
	NBMn1XDZgPnBHh87CMLxx6I5DKNoassBah+lqi+LcUdEd9KC4N8SrTdqGmyOKiEiUPMLDJ3NJkE
	yRWfjthFEPhRM6ZvmWYGDjsyWwG13wBallMVU6tRhnqKjMsv9Juhjw+LP3XIZNQaQydB02B12LF
	CWarn3V/5syBktjAJNDgMQEHmoZ9ISyF1TBSoQVTF3VQS/v5JbAwW/PA1HPKXAF3GdSBwDGsEMD
	oHYqVSmXZFtywD8hTRUJqCiPQisOLuMWWtg+W8FyN5Cm85psPqye0yB4gSUE+FjwQvkbgJQmnPQ
	XlcDFEYxXPa+anrqWZTKhvk2VZnJVp4Mn3vA==
X-Google-Smtp-Source: AGHT+IGp67st8Wnp6/nSJ8EGcvRTlOdg+o3GxZOASU21XsdtW7vuEAf7PH3lMWQNe6ILam9RRnzuAA==
X-Received: by 2002:a17:903:9ce:b0:274:506d:7fea with SMTP id d9443c01a7336-292dc92664bmr869085ad.5.1761003029542;
        Mon, 20 Oct 2025 16:30:29 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a2301108f8sm9508302b3a.66.2025.10.20.16.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 16:30:28 -0700 (PDT)
Date: Mon, 20 Oct 2025 16:30:24 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: bhelgaas@google.com, alex.williamson@redhat.com,
	pasha.tatashin@soleen.com, dmatlack@google.com, graf@amazon.com,
	pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org,
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com,
	saeedm@nvidia.com, kevin.tian@intel.com, jrhilke@google.com,
	david@redhat.com, jgowans@amazon.com, dwmw2@infradead.org,
	epetron@amazon.de, junaids@google.com, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 00/21] VFIO live update support
Message-ID: <20251020233024.GA648579.vipinsh@google.com>
References: <20251018000713.677779-1-vipinsh@google.com>
 <20251018172130.GQ3938986@ziepe.ca>
 <20251018225309.GF1034710.vipinsh@google.com>
 <20251018230641.GR3938986@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018230641.GR3938986@ziepe.ca>

On 2025-10-18 20:06:41, Jason Gunthorpe wrote:
> On Sat, Oct 18, 2025 at 03:53:09PM -0700, Vipin Sharma wrote:
> > 
> > This series has very minimal PCI support. For example, it is skipping
> > DMA disable on the VFIO PCI device during kexec reboot and saving initial PCI
> > state during first open (bind) of the device.
> > 
> > We do need proper PCI support, few examples:
> > 
> > - Not disabling DMA bit on bridges upstream of the leaf VFIO PCI device node.
> 
> So limited to topology without bridges
> 
> > - Not writing to PCI config during device enumeration.
> 
> I think this should be included here
> 
> > - Not autobinding devices to their default driver. My testing works on
> >   devices which don't have driver bulit in the kernel so there is no
> >   probing by other drivers.
> 
> Good enough for now, easy to not build in such drivers.
> 
> > - PCI enable and disable calls support.
> 
> ?? Shouldn't vfio restore skip calling pci enable? Seems like there
> should be some solution here.

I think PCI subsystem when restores/enumerates a preserved device after
kexec, should enable the device and VFIO can skip calling this. By
default enable mostly does:

1. Increments enable_cnt.
2. Enables to bus master of upstream bridges.
3. Reset INTx Disable bit in command register.
4. Enables IO and Memory space bit in command register.
5. Apply fixups.
6. Sets power state to D0.

On a preserved and restored device, I think only item 1 needs to happen,
2-6 should remain same if device config space is not written during
enumeration and state is recreated by reading values in config space.

I believe this should be part of PCI preservation and restoration
series. VFIO can assume that device is enabled and skip the call or check if it is not enabled
then fail the restoration.


