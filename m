Return-Path: <kvm+bounces-64745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EAC8C8BBBA
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 023433BD50E
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB65341642;
	Wed, 26 Nov 2025 19:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nEedwZVN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A2130E834
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 19:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764186856; cv=none; b=f4EgDApoDpS/QYM0/QO2YnxppNRayKLpykCXcYMmzEVaagyUrQ9brrJLn9bN9fT7ZJRNZLb5p7qEGpXnW54SXUQhzl0hKyiadf+CFLH3ye2oR3+Wg0+JvXOgoAVC6KbJNeD6VQdVaTXBhn3Y2+KNjCPkwJ3NzJCQhmzqhOXg0ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764186856; c=relaxed/simple;
	bh=yp5/wwWosx1DXbl8sdfuiitz1cVbFhZ38lI3u/ecB68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q9MvDECcPF348InD3uYJFqHGegPlILHA8n62taR4fuLhyLXsENefOLM/ATGsE7xyDvDOP2vIV1HmQPIJY85mCcZtcxM73cSXyT6+T5Dg3pU+gLSDW4qrX9sVmjDw5OflBre6rdUozmSTZbtRL3QT0qoYsX3f2l3VI5vC6F91Lgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=nEedwZVN; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed7a7ddc27so1716211cf.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 11:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1764186854; x=1764791654; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Onvw6GP9Fzkg1n+Cnh4Ybfq+WlrT4fhs4dte72kQfjA=;
        b=nEedwZVNbgsAiIauzdea0eTegh8SXdU3cQbDnLNAgGzTqSNrueEHZ2uesJuIXFhOZ7
         Pwyj8XKKVztsVKhDvOrDttTo2UkJxkBqFxd1M7kFCu1M+L7GOlSEZptHInIB6z8Bjz6x
         tIXpQZeRFA2glCQe03b/y/JDCTmwmneOVNnjk9R1nien+qS5l4maczUlecTSVvDFE2qW
         r+rpUGWDB/XjtIaole6ckFEp3rWsS7J8sGZMIFpjf8VUHRAKfHe7E5/yhdYrT9+F45Sw
         s2FBFnGd2O8tEyEjGElcltaLhdSXA2yDwCbZX+3xMsO3BO/KDXg0JN8+TwmVvndb9Qpb
         ODDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764186854; x=1764791654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Onvw6GP9Fzkg1n+Cnh4Ybfq+WlrT4fhs4dte72kQfjA=;
        b=dsnOMxjskHmm41k3minCZvE/+vDk0AgpPBXHvJ5F1RCe/rwTE4NsEN95EzVt/xBIhC
         GQo6r+GHJDdIhMce06yW/Xp+dDjxnPP7JEtbtsjLCOcoQnDemq4GTCzzb/IU7o0yyqRo
         mAWTwUdbuTd3HGWek8G1l1gSUrs9QiU/9Fs0nDPjd5tmd8G6nFPJBkK/qTfenbtiKcqP
         k24b6SZhQqmpBR8snjutoFfuoD+FUw8oLIgTulwb1i2MX3EyR0QSwjK7VfV+pRJ/8pAI
         73eYYQWQ33QMEqhtdnEwGHJEh0TuWUNoD6ZnFIjJZEySFAs9WiPjmuF/c2nwHBYHTRq4
         wuHw==
X-Gm-Message-State: AOJu0Yz8Xn52rumNRFJwo4QyaeHpF6V2e9d0CSUTA2JPXTdEBOpCKyXH
	deYXnROFw1ELpOBK9iVKPmEkrXdYGN8QleOTYWTGbMTmzf6KuTR8XJDx1z3fULeUzrw=
X-Gm-Gg: ASbGncv9MaqviFo2nzK7k/sJfXWMFxzj80aBsyceQAJTkCBpxsPtPsqQrIftTlnqGOh
	dtVGGBWupt4Fr87Muz9EXZvARk9lXvB8SuyDymh6AiL3q2WzwLIb/0lCYthtzJC5/nkKRprMM/c
	co22Dqf7KiwrO1HvXAqm8nagLvgYVH46vadyKi6yXWJbsmAkNeA+BR5HKGY/dXmYbNOkL4rLX67
	bKpQT7NYTADGHAmSbNMgBh3d14wZLusIA6HZ6L8meKuLSBAHybZtVsXchXQatoxLIcppi1peYE3
	vZRwBiQLgtUYTacfury+x0a8X+/Wh9DYXsfeNEw5rp/K1UQL9Gwo50VXP9aW4If3TdfRngW5Cxp
	YY0XYyfackOhy/8zBWFglyKAiFQktTNnOWbCtOv6nA5u6CHIvCqADItI3eEKnPyDUTML25iVnn3
	MFB6DU10IlxRjwGpXxTrFH4n+LhZxKs9p2bxoq5bIc95JzUskBFJdvF/+w
X-Google-Smtp-Source: AGHT+IGodrkMz29UMb7bpPnawLhXCGiDCja6rh4VmN/8imkihf7smpa3IipVp80dsHKufAC4mNwn5g==
X-Received: by 2002:a05:622a:589:b0:4ed:da3a:c0d4 with SMTP id d75a77b69052e-4efbdb1806fmr108644071cf.78.1764186854110;
        Wed, 26 Nov 2025 11:54:14 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48e86bdasm126977421cf.33.2025.11.26.11.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 11:54:13 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vOLae-000000036SQ-3jGW;
	Wed, 26 Nov 2025 15:54:12 -0400
Date: Wed, 26 Nov 2025 15:54:12 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex@shazbot.org>
Cc: kvm@vger.kernel.org, kevin.tian@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Use RCU for error/request triggers to avoid
 circular locking
Message-ID: <20251126195412.GB738503@ziepe.ca>
References: <20251124223623.2770706-1-alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124223623.2770706-1-alex@shazbot.org>

On Mon, Nov 24, 2025 at 03:36:22PM -0700, Alex Williamson wrote:
> From: Alex Williamson <alex.williamson@nvidia.com>
> 
> Thanks to a device generating an ACS violation during bus reset,
> lockdep reported the following circular locking issue:
> 
> CPU0: SET_IRQS (MSI/X): holds igate, acquires memory_lock
> CPU1: HOT_RESET: holds memory_lock, acquires pci_bus_sem
> CPU2: AER: holds pci_bus_sem, acquires igate
> 
> This results in a potential 3-way deadlock.
> 
> Remove the pci_bus_sem->igate leg of the triangle by using RCU
> to peek at the eventfd rather than locking it with igate.
> 
> Fixes: 3be3a074cf5b ("vfio-pci: Don't use device_lock around AER interrupt setup")
> Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c  | 68 ++++++++++++++++++++++---------
>  drivers/vfio/pci/vfio_pci_intrs.c | 52 ++++++++++++++---------
>  drivers/vfio/pci/vfio_pci_priv.h  |  4 ++
>  include/linux/vfio_pci_core.h     | 10 ++++-
>  4 files changed, 93 insertions(+), 41 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

