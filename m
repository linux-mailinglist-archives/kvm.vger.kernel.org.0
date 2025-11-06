Return-Path: <kvm+bounces-62137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A3176C38717
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 01:12:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9A0A24E97A2
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 00:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5DB1BC4E;
	Thu,  6 Nov 2025 00:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A1Ewc2pX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87916FBF
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 00:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762387933; cv=none; b=M+iONTi5ac/i20EBNOCOlSw4k9Ulk3pb1hRfebBCPrBiiTUp8LOIAM7LAl2Y7PdAmRRT+c8VNVuxQ/+b9OSiNORgxNlLEqlDGEMwumK0yTxR34QhDP0teOqK9MJund+CXfT9n9P80aoGGGwAjXbwOog2osTp3Xgeh1t1gO3IdKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762387933; c=relaxed/simple;
	bh=0bC+YF0uuNbhQCtupED9tKbcEeEMcAcwocuVIfmRMYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKjDehUmnPEJnbXbpDZWrh8dWx2MuISFJaxuxowH0DaRGQZZN49Sp9bp2FZBKAHVpnIfU9NzC2bMYRXTdvahndxVw+DaLCJusQdCyEzIHYhdE12UD7M+aMalXEa5KImL9n4OExxegWKyLtuvqcOEV3gMlkuRV4OSL2Hx7boowHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A1Ewc2pX; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2964d616df7so5336665ad.3
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 16:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762387931; x=1762992731; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BjKG1KhFcMCK3nhGqteZ5V7ruyWrAwYqXjl33IaIq2A=;
        b=A1Ewc2pXuWB6HiEby2sicNS4Egez/FYenJu52IxrM5g64LSH5xhOD20xgg4NJ5cakA
         qBDTOFRI/5PzykmEr/sUlsx3qik1PezdkSiH9ssi3j7cMxKastmzxj2PCtL4Cs3V34yZ
         yrkz8m+jcGXNuGCWTegswrCSm7/bfmpwjVf85R6Lx32QEA5Z8bQe7UcFq3+jbIwqOhlX
         FvG02U0GEzAw5xZkw7T7I0sAV5oGyNBwE4PZjCYilgOTijIKlOgvsyv2iXrez2+NPnuG
         JcjiPzlidnxq/oMla8Tp6qqkDTUg0Lv54jzPj/GtnRZfUwhXEPxibITW+6aTgr5AgEp7
         oW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762387931; x=1762992731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BjKG1KhFcMCK3nhGqteZ5V7ruyWrAwYqXjl33IaIq2A=;
        b=npUjAh8GVoLCuUJ5J0pZ8teitEKEEoQBmN6unrAttYOI8cANxBZxcQg/bGUVz+ZX94
         nhPOJeaF5rZKV/fMkTBXCIZpMNbSWZteOrWydx9nuLpmp0pqPfaXNGRimnBjST7PVDPv
         GKX1a/Z31gzq11xAScMzVeKLbJOzXcjYeLUXiTl2VsW7UH4zWmKB5vBIGpR/CkvLURPN
         8vVOcFnvIcjoXsQJZ9e1Cl2C0qEgbqe51UJ34AlujgTQQ3O+deMKn5I3NJwUMgQL3LHm
         SW9csTCNHIZR6iLy+1PbIGZBBI3hC/vvk4YXq1HJzRMhglz/ghEWaFTdYLeA+s4UBS7j
         kSKw==
X-Forwarded-Encrypted: i=1; AJvYcCXskiCVc1wNxCvhsWhyEKoDMfv8zISBQT5tQML7YTiC7HC2tgES/CfTCB741GNDdbc4G1I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY4h6BApW3x7qiRuEGHu//yqqK3Vc2pmZ2XlCle6kSDekZv3CQ
	YJD3NEZn9Ag8e29YJRWWNhahPEm3S1pX960oZzgEX1WTmsrZ/qPmgFU0FhtgAPVa5w==
X-Gm-Gg: ASbGncuu7r9/3rRg+wiZneHLr1JpikzXx/8bt7Vrh/LGybu4f52UcFtntR2cJgfTeIL
	YsOZo6AI5VwBGUR56EG7HgY3q1AeG7AJoe9gRQ7lRL4tLWK2hupQapIOGFEDXXG0C84wJqG7Y5P
	09vXDZXKW5ndZmC+//Q0HuzKHNR9E2VzbzVH/JOs09e0F3Yxe8W5VJhPb1RbpnTroO53HwikafT
	lhAtaf6/kUciWDxwurJy7QSXvCZfwQeg1B9KvBNaE7w+c9J2fPKpTpe2R0cL1bDhXbu0n4SkgUZ
	P2riZ9JePzMMRbMDqhjuyVHG2XMoC15qVxdBivpuVnge29TJ9huVfCV+o39pCWryI6kwKIckVzL
	i3YgugsFGlG6K5DMWHTOwHqc7cEugmDB4vlpr5uRc8GRe7cfzm7s6jrisy/NsLHLAHO+70ih/64
	KL/dvlatXpvanjotFyYk/DvE2udrEvKiD2UaAS/n706g==
X-Google-Smtp-Source: AGHT+IEaCd9qPDXRUzojzt+yrklyPttl04i3bg4Y4xCKKm1DEqaJwmaybBTc7n3FNKNkR7Y9u9IwEw==
X-Received: by 2002:a17:903:2b0e:b0:290:cd73:33f1 with SMTP id d9443c01a7336-2962ae5afe4mr71915935ad.59.1762387930895;
        Wed, 05 Nov 2025 16:12:10 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650c5ce87sm7196065ad.29.2025.11.05.16.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 16:12:09 -0800 (PST)
Date: Thu, 6 Nov 2025 00:12:05 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
Message-ID: <aQvn1b9sspmbYQVo@google.com>
References: <20251104003536.3601931-1-rananta@google.com>
 <20251104003536.3601931-2-rananta@google.com>
 <aQvjQDwU3f0crccT@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQvjQDwU3f0crccT@google.com>

On 2025-11-05 11:52 PM, David Matlack wrote:
> On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> 
> > -struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode);
> > +struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> > +					      const char *iommu_mode,
> > +					      const char *vf_token);
> 
> Vipin is also looking at adding an optional parameter to
> vfio_pci_device_init():
> https://lore.kernel.org/kvm/20251018000713.677779-20-vipinsh@google.com/
> 
> I am wondering if we should support an options struct for such
> parameters. e.g. something like this

Wait, patch 4 doesn't even use vfio_pci_device_init(). Do we need this
commit? It seems like we just need some of the inner functions to have
support for vf_token.

