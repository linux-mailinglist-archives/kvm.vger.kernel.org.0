Return-Path: <kvm+bounces-56524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEDDB3F081
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 23:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D64261A86EDB
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 21:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DEA627BF99;
	Mon,  1 Sep 2025 21:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LmOU+ixj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9290221577
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 21:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756762276; cv=none; b=d/v/aUkHEQFkyUpyC23PPK9HhElrUzy7d+dIiomKk3+Xib14qOJQExriDjGuzU+czUJCsaQLSVdDjGkHe2Bteb5LlifGCI0vj/hw2a2LpVkHsEO/AKRBEHKpLvjw1sSFmuEeE+J/xif1waxZ7Ywpav+yiegNHjgytEbf2XVGH5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756762276; c=relaxed/simple;
	bh=Z+ej9pwp2++y8Si2a5LoNWa0dw/LyT1iXFjl51NEyGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctLr5E1vUbAbATdCUbralSZUqNpgDI5pxG2aTpOjqrTp0ZhMXMpHFMCqqCXBZPXUqJNxV1J/7fJHCGiSt7C17yTxsOgIsy4q763hgMGVdCE69+G9aa44dV34YGQwPI/KP/yyYjMrJJ8iIY/arOAe4CONfboWzlH+RGR/8dfV4Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LmOU+ixj; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45b886f92ccso134055e9.0
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 14:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756762273; x=1757367073; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iF6n6sHOgsKd1WpTX20Jc46RPi8oPME1VeuLjiWGbwI=;
        b=LmOU+ixjJ+aKbLpNcUjrLIW3NR25JCR93ZSId7SVjrifZEzJMEL/0L2mhegw5I90SW
         fXWJnHsqGpcsm7TXfv6g5LBuflgQk6fh4YCQ3kzUwOQg6tOxNcOrNElvyBEoSSO6NMvH
         ZZoG+/eoQacG8G0sBGE8gBfEse8xV6yLHdz3l9ApRYtu5LiHZFmRXgIjjJukJt8yYJhC
         qYtA8RjvkZjivx9bMqYu0aOmU8gk5075ITNfIFZO44MYWaxXqsvRkOD4q8odsbkRMnxM
         L3FsssYrp+kVXlHGfMM5uMxeYXhop7g/x2UcLFGRV3bgIUtaLDPh1akBiIqXPB41FuxR
         PjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756762273; x=1757367073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iF6n6sHOgsKd1WpTX20Jc46RPi8oPME1VeuLjiWGbwI=;
        b=fJQLW3lPDF9AlRPe5YiN2Hi5xBkH6yJ0qLF9T2uWl0PaCEctCrnaT56OwC8bq1FqpV
         68IvygXamgjdoTU9L2Vqn7h9JwMG10TK54RfK09CLNGxhAQ0qGFM1nSROMzxds4uF5Yd
         ksaGbKo1N2C4jXYhC5x3PxAcVlc9xsmFrhr83dCzpPgoSOcHw9rmGvt9kFpMck+a0G9z
         3ftTEdENsJIDHjccchMt4RY807p70Hf+cQKxeu5R9ur9z7ipEfk3deHTN0Y5cldC0GF9
         mYh9Lw887soDt7U58e/WEiMEX6MmmpxTFWsCLzv/s/hdAWw/Xaih2u/aBvGMhf4JCETT
         LBPw==
X-Gm-Message-State: AOJu0Yw21JrmWzp4k9/dLTRg/Rn+V5fI9ybaQGBZm67/ORYTxOgeDQ2s
	njsASrOoEWkY4YNzDsYz22v6FaQX5MMOgG9QBB13NTG/i6G4Uf6IdCLNEtBQA6T0EQ==
X-Gm-Gg: ASbGnctVXKABwdLtCL1BOEhqRVLsK1oElRKP+0LLwBb9NtQl8GuOEe6btg85saxDXqs
	EAmqv9tyVnCOF5kglHU0C1fVdUhOVNHstcwY6yVzwufI5hOkcu50HOMgz7fJNUS2r7+85s5Z66b
	wWbnXwpcKAeiq1jrE6HrnH9jkrkZDepDPKdMvjBWIk3RVQsIOsgaWyxN184f/0EzHlGibw71STc
	k/l69G8OfveRRGjDBo65dxWmYYPwvt9n99ss4SZ0NFITbKD7zRZMdhVqX0767FEywAv6aePdCPN
	V1tJTVxONroxt5pqVeVI8F/dQCZJHM5hoKXpRmxAnuwpRNN+kC2dppu+jkeQw/O8Fc2niFaObWi
	Qaq2WAVTLkmXhFmgIWbUciZPko9BPBNhhpEH+W4vfsHo2iiWxSJDhzE0dYkEbF7b2LjRRWbPJ+7
	IPIA==
X-Google-Smtp-Source: AGHT+IGLpKHQN9xZlHfjJ7Ii92fk9qbRgWzKQ/hHtlgk+3xGEtbYRWbas4SwWPxJAuhnPExKzRecwQ==
X-Received: by 2002:a05:600c:498a:b0:45b:7ac5:f48f with SMTP id 5b1f17b1804b1-45b84b62748mr2268795e9.5.1756762272856;
        Mon, 01 Sep 2025 14:31:12 -0700 (PDT)
Received: from google.com (26.38.155.104.bc.googleusercontent.com. [104.155.38.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e74b72esm174837265e9.0.2025.09.01.14.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 14:31:12 -0700 (PDT)
Date: Mon, 1 Sep 2025 21:31:08 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	eric.auger@redhat.com, praan@google.com
Subject: Re: [PATCH 0/2] vfio/platform: Deprecate vfio-amba and reset drivers
Message-ID: <aLYQnKGsslgoHRZh@google.com>
References: <20250825175807.3264083-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825175807.3264083-1-alex.williamson@redhat.com>

Hi Alex,

On Mon, Aug 25, 2025 at 11:57:59AM -0600, Alex Williamson wrote:
> Based on discussion[1] there's still interest in keeping vfio-platform
> itself, but the use case doesn't involve any of the current reset
> drivers and doesn't include vfio-amba.  To give any users a chance to
> speak up, let's mark these as deprecated and generate logs if they're
> used.
> 
> I intend to pull the vfio/fsl-mc removal from the previous series given
> there were no objections.  Thanks,
> 
> Alex
> 
> [1] https://lore.kernel.org/all/20250806170314.3768750-1-alex.williamson@redhat.com/
> 
> Alex Williamson (2):
>   vfio/amba: Mark for removal
>   vfio/platform: Mark reset drivers for removal
> 
>  drivers/vfio/platform/Kconfig                            | 5 ++++-
>  drivers/vfio/platform/reset/Kconfig                      | 6 +++---
>  drivers/vfio/platform/reset/vfio_platform_amdxgbe.c      | 2 ++
>  drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c    | 2 ++
>  drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 2 ++
>  drivers/vfio/platform/vfio_amba.c                        | 2 ++
>  6 files changed, 15 insertions(+), 4 deletions(-)

For the series:
Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> 
> -- 
> 2.50.1
> 

