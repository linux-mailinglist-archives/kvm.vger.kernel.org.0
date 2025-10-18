Return-Path: <kvm+bounces-60448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B805BEDCB9
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 00:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23D0D5819E6
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 22:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B03828505E;
	Sat, 18 Oct 2025 22:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UAbNi8cy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8F9242D98
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 22:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760827996; cv=none; b=j3jgQtGcuJ4ZcfoqRov2B/rMnjczT15rAoO/ztFBqJvzL/E6qVaN22yYNOyaM/HqIouynicvGka7cStA3yjuynHIYp6JlFGfEikebBKAAUiKg/J+siZ8PIchrHQ9UmjYTJt0cr4JaBXdi7wJut/rXEASmlRtU4E86jI+E9kYpjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760827996; c=relaxed/simple;
	bh=7qLVYcdBi8bpEpnS4F0eADPD2Bf5b4Eo3btCpBmFKVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiuccKdIhRB9RM7PqizTIsoYOcJcbY4OoS50WwRoHcOkIbrB4Bn1oHwUyGz4C2v0SpFpJWBLbvCV15IcNbxn+ttffggSXLAWDeHph47OfCpCVo2+JG7pMgii0NCyqiG0Q2YD0EetY39Mhm1JdNwZgLuXk2T1xpEx3nkpd6knfRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UAbNi8cy; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-27d67abd215so155335ad.0
        for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 15:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760827994; x=1761432794; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ExoVcTIek9AdjVCMkiYpZILDA0YvBh98/+0VTxUThlI=;
        b=UAbNi8cyjQbjrZyXCTT4a8vAp+AHgWvBfwiir9ZAZjgl1sA3IJj/GvQI3uf8xKsIXM
         lwL8tt0xwwordOaFzkyxegDoovfaXTshVMyFD8oWeZmVLtDhik0U2lcIRq15Dr/LejDq
         snj12IfKQSWfdL5LKVfhXhLE/kAbt6tqzMtOijBiv3pOIeAk0QfXKjmaWBI2Tepg3QFy
         MNxAtm3zcrMgyeCeyodHMq1o48Tvli5QY+z2z1hjktBZJsklS6bZ7dosbbrpApGUB/1E
         ET/hFglPHZzfOfygTVWCPR8kf2gv3DUBA7DigMaY5sGxaOa1kh1Hfxb/ImgVw0794oDG
         rcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760827994; x=1761432794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ExoVcTIek9AdjVCMkiYpZILDA0YvBh98/+0VTxUThlI=;
        b=XNFpHx2sqfUZmMA1XQTVGJyJrETpGLGHF3ccl1UenCR1yP7T4LLOpsWEVW4mdPhQqm
         2shVH7WKatgRemwtrlci3Br2t2IaQzciGi7/UIeeHkcBVumiTW3+HJAvzXAfSlyyOEm0
         1XpS6ge3VGb1+w7O0VB56EXjVzPjMIRhlmJ1iSN8S5+8Gza9JshsNDQ3rm1foNAn7p/x
         RiYbX3WkLn1y+2QVK0rM00b1dnGDSLpqvsCzf0mhyMfHW4UJJz7d6x+7O145q7mOClh0
         /FNxl/HMDO/7Lv1itSuTQZVP1FMif2zj/qPflaC/cQD7DOTUDzvlhkp1gBj1E0t2W9DN
         tbDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZNjMQ2+1BHCJ2wiI2nf5vqcbrzP5Nq43yuZ9i1OrBZfEw3593SjCqKKMFJcyHmrBa5Z4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx35dE+LiEwkYJLyUFw3oaHDWXHwro8ARbroVeos0/Pv8Yqsckj
	UNJVhiDoQAd+CgX1WswU7MG6DdBe5Xi8euh4WS8ChJay1c04DvrZdxAZZ0ZKu0EJ9g==
X-Gm-Gg: ASbGncufoJstjgq5GgVsAFaY2rSB3rH0cibB8LB/pVvDqj0DyTJCRfRo2ryxXYTZTXc
	Ob0j6O51wcPGQvGb2EkeHG955Pm9RU1I5LeeUDHhqm2ouXIek/zgmZDosTyuUdONnkXhLQJ1hcX
	ByN/k1jD1Nb7VnGOGxAEsy/lRQ9o/tc7D7zXbAo7RdrxQ0oJdCb2y2a4AA1tYOrhSwIgMcj/vCR
	eLii4Gwm3Cj8h/BBjz8YgUMqVW83mMf65hxif4xmZVBYx33cfMm1JGBlmJ3sz63leFLYGJh1nIH
	8RhMQihKk4Gy1aLN8X6ieX/F8W70+ZKbVb5DAXa75RCD+AKTxJvunh3lRz9kJcn74/c+hMUXWCL
	KTmyr3U+jgOdoCUfKsOZtsNObfUy1hifwSSS0Go0doh6jnkbhX47pKverzVgjq7Y7x/S07Klrsg
	Ycs7mBcy+Lmjat+Zo/1dguUvOTg62CMG/ctmug5MsK2BvnK9c=
X-Google-Smtp-Source: AGHT+IHYSWZKJqORVU2MlERhdd7pLQTU+bgumM/RJ5rxntS44MT/2pojFpL/YQ8TyquwryI9b7dpMA==
X-Received: by 2002:a17:903:380d:b0:26a:befc:e7e1 with SMTP id d9443c01a7336-29087a1668emr19722635ad.12.1760827994094;
        Sat, 18 Oct 2025 15:53:14 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a834de75bsm1268723a12.12.2025.10.18.15.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 15:53:13 -0700 (PDT)
Date: Sat, 18 Oct 2025 15:53:09 -0700
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
Message-ID: <20251018225309.GF1034710.vipinsh@google.com>
References: <20251018000713.677779-1-vipinsh@google.com>
 <20251018172130.GQ3938986@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018172130.GQ3938986@ziepe.ca>

On 2025-10-18 14:21:30, Jason Gunthorpe wrote:
> On Fri, Oct 17, 2025 at 05:06:52PM -0700, Vipin Sharma wrote:
> > 2. Integration with IOMMUFD and PCI series for complete workflow where a
> >    device continues a DMA while undergoing through live update.
> 
> It is a bit confusing, this series has PCI components so how does it
> relate the PCI series? Is this self contained for at least limited PCI
> topologies?

This series has very minimal PCI support. For example, it is skipping
DMA disable on the VFIO PCI device during kexec reboot and saving initial PCI
state during first open (bind) of the device.

We do need proper PCI support, few examples:

- Not disabling DMA bit on bridges upstream of the leaf VFIO PCI device node. 
- Not writing to PCI config during device enumeration.
- Not autobinding devices to their default driver. My testing works on
  devices which don't have driver bulit in the kernel so there is no
  probing by other drivers.
- PCI enable and disable calls support.

These things I think should be solved in PCI series.

