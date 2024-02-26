Return-Path: <kvm+bounces-9938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D42A58679B9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:13:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B6A8B35EC8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED0E134722;
	Mon, 26 Feb 2024 14:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IIKbD6Gp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAC5605C8
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959259; cv=none; b=NH1sM9MEddBlaVvz5uY4KrqKqtUrpOGwql/Ck00HPMdEYo36sZ7zzw+HzGgrt4yCu3ESWFmjfgEp6GcbApi4wWdE5130PwjtvR4a9038toLerod5P6qs2/KtH+GLvFz3AdIoVhBKVqK87LD8o5w0LC17ksEj6ACD79b/7MlcgWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959259; c=relaxed/simple;
	bh=+/3x0KqyHOPTRYlw4GtUE9dLmWgAf0LHJfu8+hfKIZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcnE8u+CcqpNJYWzBUOhZR0r7J3Bzw/TAjYQURi//VpvLrV1lCL8kCvHMwv2e6sWgPP3HBXL4+AZPfkfnXtZptojpsjvFSYK6vAOAEPOjSXOsbgNJL58/LuY9ZI6n8if8cWPG7Y7Pgbm5cQqMBbdbiT4E3UnyxC/g1i94B5zHIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=IIKbD6Gp; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-68f41af71ebso34269676d6.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 06:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1708959255; x=1709564055; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PhKx5RN8BGOt7qaJdVuPeh1gBcvVzdbEvZwAOUpborE=;
        b=IIKbD6Gpk6tLnl6A2U/g/Y8jzffN05jPhtiTP3e4dxaHKPNjxnSuxw/pfZXMO97ybH
         rcSB/CzJg5DDG/htzgxnjDEEBaxLgnMLWBEvAdEBrI+DYdfUabdS695WV3Wlqm4SUAoL
         8Oajb2NQbY7hNcXfm844kdsWP3WdGSQUP+qc/+Yi/7GHl+/d5/ujtgRGx8wpSghBxp6E
         yZEOb0nSNLOrcAXX08iYED+lpVJ6K/hDL5kzG2EMUtx3L24bg33YR9q5RuXmHsE5ckmk
         7ORbU74eu/lyqYWBDbObYLkPrkrwHb5bbV4lmqSV1x2r7iIuZjMQi/FQeqDMOflHafCx
         E4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708959255; x=1709564055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PhKx5RN8BGOt7qaJdVuPeh1gBcvVzdbEvZwAOUpborE=;
        b=puCLlPba5g4VWK8oAP4woHr6tdicy9irnOMxoqzODrOEtxs+tE+hbzlracp4Okk8v/
         M7nH7Z+OntHU3n2q3qQBIAHEiWbT8Qi3lggz/xeMIv05LfK4Wo4jr61CY/jm8xBJU6E2
         NtBtIFvTBo08HA32oC/q0eC+MZ7RqnAZJ5BJztm8yPFe8lwHI80tXaEpBC4jHMW3ekeM
         /szDkqKXFd3OQ51eBB/Q8aTVu1sBOfsLH/ylv2eTf+cEQqxDeyWGlxLxpCLD5mH7/vfv
         T7ti0pLgDj1a0PvaymnCaLEHnjtwLqCL727+zx0XNEVXMMyUUvIt/ULMuG/46innQomb
         35iA==
X-Forwarded-Encrypted: i=1; AJvYcCXxrJX4agsuJHvoPJa88M3+UxdiqVrx1dIhVKdt4BnrLize6IU/XEBCWZkPGkEEmBHRfKqgxRgk53uVgMiVG8sCj5W0
X-Gm-Message-State: AOJu0Yy0HgfqwVZaWLRoHuOmNgUtSljOrfD6RPyGi7aU5yLdoxRp31mM
	WdiUT69OTdYMg+QlqQFN73if+otjTnAJvchXImpSdawGMAa7KhMOhqDcj9KHNeHi/b5TBbnICbn
	Q
X-Google-Smtp-Source: AGHT+IFG8IA1MhzDu5mBfgrDa5+jfgySxX44NFn5JkVLCjSLzcXdc4sTcq8nfBI/KeHX+xqovKkBfg==
X-Received: by 2002:ad4:4ead:0:b0:690:1829:55c4 with SMTP id ed13-20020ad44ead000000b00690182955c4mr751409qvb.22.1708959255274;
        Mon, 26 Feb 2024 06:54:15 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id mf2-20020a0562145d8200b0068fef2bc3a6sm2774652qvb.135.2024.02.26.06.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 06:54:14 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1recMw-00HS9Y-0p;
	Mon, 26 Feb 2024 10:54:14 -0400
Date: Mon, 26 Feb 2024 10:54:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: amba: Rename pl330_ids[] to vfio_amba_ids[]
Message-ID: <20240226145414.GC3220539@ziepe.ca>
References: <1d1b873b59b208547439225aee1f24d6f2512a1f.1708945194.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d1b873b59b208547439225aee1f24d6f2512a1f.1708945194.git.geert+renesas@glider.be>

On Mon, Feb 26, 2024 at 12:09:26PM +0100, Geert Uytterhoeven wrote:
> Obviously drivers/vfio/platform/vfio_amba.c started its life as a
> simplified copy of drivers/dma/pl330.c, but not all variable names were
> updated.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/vfio/platform/vfio_amba.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

