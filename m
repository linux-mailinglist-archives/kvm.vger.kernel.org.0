Return-Path: <kvm+bounces-70961-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJslCxjhjWlI8QAAu9opvQ
	(envelope-from <kvm+bounces-70961-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:18:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D635512E378
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 72F4C3035027
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DF035CB70;
	Thu, 12 Feb 2026 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Q3uRx0oV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE43D1D5CC6
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 14:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770905862; cv=none; b=TRuRLoRtyaJVVu7ZM6D2BgYYLHKjEDj/pIzR7CJV/Cd83QmfRV+v5V6PD1wE0MNlR7d/U1qnfnl8wd+cGQAoDupPvkn8wHLilZZE2DFfq/QnA6Yws9TEe+RMBps7Mwu4WgHQr6W5z5wxrNAnsSOWm1GBndC4YRorgih6Pi6cfLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770905862; c=relaxed/simple;
	bh=3b3igbvjtC6TzOflHJmS47zTEL8ymbacN0YsKIuJxWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMVkWiTj8N2h6bKGBRzQ/ShHWRkw/w/d5G+QLs6SkvqbaSaWlY6xllJhVe1WEASOfRMQ6ZJR68Unf/GDSU7JNIW2wasavJT0Ss/KggR8LYOF3RXB1EkU+P3izXM8hCXDVkxmmOLVI8uL2MvaHBJh3tlesgL65oBEMjliLv7iAmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Q3uRx0oV; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-895341058b1so88575576d6.3
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1770905860; x=1771510660; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3b3igbvjtC6TzOflHJmS47zTEL8ymbacN0YsKIuJxWU=;
        b=Q3uRx0oVkpBtjZMZbSndCvl0/QfZMt7MAbI3D53Txnr5ruSGu9lv2TFV5MAf2viUVP
         DBTTpZdyOU0CG9x13bvE8QdJ1Ws1qPBvvtbXzd3CGRZ/jPPL8wabZgieEAYpzhRGMF/O
         YPNOJTeSNw+dkZ/VtglpsW0d50nHTNJyHM+tyGNLHF+MRSikENW+5UT0wSzONaWcbioI
         0ySfyGpJ+0eaQEwRJrsNaAljb6ddCr+R4BrrICxJgWeaY8Ja6zeTgfwm7v9Cn/dmSKsy
         uuMMALbstQPH3dip8zt8iFv9o1DHdy4Mq3g+Srd2i9qde8R7TpaO/L1Q3TtoJxdNPstJ
         IS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770905860; x=1771510660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3b3igbvjtC6TzOflHJmS47zTEL8ymbacN0YsKIuJxWU=;
        b=jeVx7TubibMQnFToSCLZnZ8MAbdrGxfN3G+UjffHTYl7NVAaGjqzS+YhQ4K1jYn1x5
         5PNQ+aPbNoWhHfNbLY5C88zTvG0QAQhK84pXTvWHLlvsgYKbfp6OrDhUgA0EH1soEpMD
         6k2w4EhzL1qhGTwGc9J7m8gEtNvc5PpAxLZpLA/Liaqba5fEBdb2nGGXA5QtTaoiJFNu
         iDeb9pb0tMak1LZO7jiljzjVoK1yetgJU6q01PeUVCmRYHKSLOhrJBtqVA5qO1J16LXN
         WRik4yXLnSNqubI6F6nBX7H/ddVBWiTTFREH+fE1BAmkPs0/05KAKbQCuaqvKoKAqDr2
         oJkA==
X-Forwarded-Encrypted: i=1; AJvYcCX2HwIva/viqtrfQQeFTKYI0YkdFPKx/4Uuwr1SHBEZocBj6o+oMAxZnGs3iu+ozJvCN4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw18kFQbI+xzXqAjjRgk0sRoCE4iyViOyMp6t9nbnhIGLqcRLTx
	uY5/VJE0UtCgkoCAFGiIAFlG1bTHqWdSZ8COkD8eJVGtnDpb6yqZ1Y6KK9Z45AEuEbU=
X-Gm-Gg: AZuq6aIdF64DuR/AbYq3anub8IGJjKg0zwzZqoHoGv6jtcLNX5N0vHlM+seWJN0Zj1J
	J4n0oCqAx3Fmals6posNfElGlQN1eqwEm1nmH5iRko9P7hc1VkGMiFI7Z1AVkhmDotreKbEW2zn
	VyrsdgJCPT+yu90hLtekV6zJnkskKaEQlEi8mHZQaAFlDMmtIoAonk8BfI2dvtxrI9kPXK98j5m
	W0M+xee68kw8t+PP6I0+zYuyJLQ1FDGQ+KnTWlFoYLFmeCamk2QshSHj2hwDRd+xtF2/rXJB/Ql
	CbPc4SUL6578QffvFitK4eR6ivXUe+d8PEaRe0WvREsN6U0TpainRnegVVMpaPJyXyzDqyJWbz1
	xocqb1aSUT2HEU7zNp7jnAleSBGjGLf/LruJwr+XRcHTBZZhOidtojBUwlsdH5CrYpc1JnveWi/
	ptHPcuOJLV9Mw6xbiiRnShTfTGKB4UhUxwSYsC6MFux0dvgi2JlJLK7yk3k1WsUlipl5qc7PC6Q
	PInj2M=
X-Received: by 2002:a05:6214:b6d:b0:888:4939:c29 with SMTP id 6a1803df08f44-89727b28033mr38655036d6.71.1770905859509;
        Thu, 12 Feb 2026 06:17:39 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cddb9efsm45048286d6.51.2026.02.12.06.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 06:17:38 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vqXVi-000000013HU-0xrD;
	Thu, 12 Feb 2026 10:17:38 -0400
Date: Thu, 12 Feb 2026 10:17:38 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Julian Ruess <julianr@linux.ibm.com>
Cc: schnelle@linux.ibm.com, wintera@linux.ibm.com, ts@linux.ibm.com,
	oberpar@linux.ibm.com, gbayer@linux.ibm.com,
	Alex Williamson <alex@shazbot.org>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>, mjrosato@linux.ibm.com,
	alifm@linux.ibm.com, raspl@linux.ibm.com, hca@linux.ibm.com,
	agordeev@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] vfio/pci: Set VFIO_PCI_OFFSET_SHIFT to 48
Message-ID: <20260212141738.GM750753@ziepe.ca>
References: <20260212-vfio_pci_ism-v1-0-333262ade074@linux.ibm.com>
 <20260212-vfio_pci_ism-v1-1-333262ade074@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212-vfio_pci_ism-v1-1-333262ade074@linux.ibm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70961-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: D635512E378
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 03:02:15PM +0100, Julian Ruess wrote:
> Extend VFIO_PCI_OFFSET_SHIFT to 48 to use the vfio-pci
> VFIO_PCI_OFFSET_TO_INDEX() mechanism with the 256 TiB pseudo-BAR 0 of
> the ISM device on s390. This bar is never mapped.

Woah, this is dangerous, the size was selected to fit within a pgoff
of a 32bit system.. Does this entirely break vfio on 32 bit?

Jason

