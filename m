Return-Path: <kvm+bounces-49356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59744AD80C1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 04:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 848623B8650
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8D51EDA2C;
	Fri, 13 Jun 2025 02:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSoECx/Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4480610C;
	Fri, 13 Jun 2025 02:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749780220; cv=none; b=WiIWzTowH3bDn4wjeCaIquofBgG7Sv6XCN8NyCFkvnmZLVLlD3mVShy1MNEnGPQ2tgqx0RcVoTA46LtMOCjqvU1yYQ6TbTyj2Fv/oiRQM8qFDwXXQcDV9X5ap9XFaPqqPhDQusHCmT31L4dC+jVXof/uWnyZ3/JLpvJEKDF/OSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749780220; c=relaxed/simple;
	bh=DbJgbMC9kNuTQ0O9LP8iTiW8/nxoO2aXmMm7k2OBOeE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=YmEhBGC0Bw6vDufnvFK1gOYI8YNV04DqD95msFeKIqtfrRhstV0Ni7zw6hA0qxhLAj9EU8Eb3qHYxt2rWspaI1YgwbhmKMoHZQx/3I5DUutNiiwqGKQqbGYwhAzTFRzCchA4hi4ioXB/W9m7uI9G561S6Br14MO3MZUYl4fF2Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSoECx/Q; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e7dc89108bfso1342785276.3;
        Thu, 12 Jun 2025 19:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749780218; x=1750385018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wy/uhLM4uWfwEUS86OoGZrfU4y1O/okTHJ9nm0xWHjw=;
        b=iSoECx/QMqab5pnlU/bU4sP5unqJ9bJEgUIO8RaFBvxMz1C6QdE7WhfvTkzuaNzhgM
         qInNewu4kaOgEE6ow5tnkLrcio5aZoIYYXhuj9VlNj1bAWZj8j/YNvN1Z++66i61e+Fu
         LM+alvg6PqW5LikYCxhQi5O0oNOPY6JA1VxCZ1xUUj0+q8z/pIfMAVwhd3oxeuS7laFp
         mdPjd3OJMVQg1yimBNtQV0lS2ovnw1XIciPE8EVMLxJ4EHg6TeUlK5SRb8xNGT3TRzJu
         iSLw7SdF8HPC5o2FhUs7Bp6AkdnrNCVVutJ5n1v6VGAFjAGi87gPnBPyZrEvm9hdaasF
         5A0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749780218; x=1750385018;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wy/uhLM4uWfwEUS86OoGZrfU4y1O/okTHJ9nm0xWHjw=;
        b=PFk53SiUE8JqD6PyYlG4axBp1I916QHV/i3tv2G1UOK4Yr5tLPEWrxxo9YcHxNCsgt
         1Ws13xj/V/GaiAW2oKYxhe56AwKWJDu0FgRIah9M0F8PWH5+mar+Xqw3sGXuImCoEfRA
         EN97fX1vftzFlE7L6gNg3iENROPAmB0Y5I/O9vQ1519ZbaXlMITzY71aZXvOQvm3+xG4
         1l6pBIFj8/XBQcaQ5AcR63mWBptxWUPjoD9o+47aqdmZGgDvofyih/9D4lIBPMSglAjd
         /TIDRCVNjeLDIIbdF8X+HUy3p4A4gVLNA4LOIPqnhFUJ7TNpUhbwSHgvs1TgFoD/hvLK
         N7Yw==
X-Forwarded-Encrypted: i=1; AJvYcCXUxpF3C3GKDWtRzQay40YmbLLze+rnpLoD3EuMyESEGPO08DFWLBYMO2Dop2OxNTSCc7TT2dPp@vger.kernel.org, AJvYcCXsxAMcYqzqme0JtnlfPnoaElC2xGsSWd9L+vDNZfWecKFVddG6udIu1HeRt6ws3sc6Ni8=@vger.kernel.org
X-Gm-Message-State: AOJu0YydYSWr5joWc0Bkqdm0JBETqP6lFBSd2nt9mj6wv5CKHjbj/5J7
	jxQASRIwPkdaHw02bkxn9tmrc42f+hFnqXZviSXtstnxbmoMnkLxNPke
X-Gm-Gg: ASbGncstgylIFALxCr3LSRlJDs1E2iMSPd6BSnE0v4qA9msrpJI8Xu697q+P+yUUZ8a
	Dkogo/K4pMT2SHDJjdxyAxc2ALxMeJKN+lREy50qk03YHiuvu2sR1piiNbrSiKZ25Df2AKbxXUP
	21L6uL4fQ7hbB/Mj7BvCqpAOnWeHD8GarCe7klWISFL8xI47tRG4iOqEpSOf7fbrJ4B03ig1dXC
	Slde6OOX6MstUBEaD2d1DFoxcJRHMOWJZOSa5+H1uN3cxUx+opv+sGesL9vDrYylAnkoxO9lIn6
	j9hJhWx7ecKDg1/shJq/QqSRhUt0sZE2W9gQOQXiIhfRB4ZTrJvgIr3Lje9s0h0HDjrc9CTq9rn
	A9Y1sBJtXcuh62FLIcLHo+Ghq3LLuAj5LGKoSCDiqdw==
X-Google-Smtp-Source: AGHT+IGhfFBS3ucnKhn/lux2ltNMn+fnATvgUPhFfUSkE0XmjQ2hZWkK9TSYAm0wp2Sp+W2K9B+1/A==
X-Received: by 2002:a05:6902:2210:b0:e81:9b3c:b79b with SMTP id 3f1490d57ef6-e821c34749emr1626258276.45.1749780217764;
        Thu, 12 Jun 2025 19:03:37 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 3f1490d57ef6-e820e33cb6csm786872276.50.2025.06.12.19.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 19:03:37 -0700 (PDT)
Date: Thu, 12 Jun 2025 22:03:36 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Jason Wang <jasowang@redhat.com>, 
 mst@redhat.com, 
 jasowang@redhat.com
Cc: eperezma@redhat.com, 
 kvm@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, 
 willemdebruijn.kernel@gmail.com, 
 davem@davemloft.net, 
 andrew+netdev@lunn.ch, 
 edumazet@google.com, 
 kuba@kernel.org, 
 pabeni@redhat.com
Message-ID: <684b86f8d9df9_dcc4529437@willemb.c.googlers.com.notmuch>
In-Reply-To: <20250612083213.2704-1-jasowang@redhat.com>
References: <20250612083213.2704-1-jasowang@redhat.com>
Subject: Re: [PATCH net-next 1/2] tun: remove unnecessary tun_xdp_hdr
 structure
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Jason Wang wrote:
> With f95f0f95cfb7("net, xdp: Introduce xdp_init_buff utility routine"),
> buffer length could be stored as frame size so there's no need to have
> a dedicated tun_xdp_hdr structure. We can simply store virtio net
> header instead.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>

