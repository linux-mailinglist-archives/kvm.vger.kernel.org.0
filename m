Return-Path: <kvm+bounces-61242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A0ED8C1216F
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5CFE64E0EDE
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1742F5A2D;
	Mon, 27 Oct 2025 23:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q+kXJyKI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB41990A7
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 23:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761608736; cv=none; b=gynONwViboc22xCIpzdTth3FZp0OsO3vVskBAEVs+U++U7WDpp7hR731BBaLjlbxEAc3TIXP7Am32U8h4+2Ca+1+IdouJXXx9WPULHPcxhCAdkvrrya64/zgX7F/KKB886AjrU/jbp2+bGc5SN28TTXI4YgiBufEVPCIxqvVrqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761608736; c=relaxed/simple;
	bh=dZQxNB5KuU1XoEbzrSnnELpukG4dptgBnBVMxRq9wMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dV2+VXXFjqK6dwJ2ehE9y/ShFcryJPgJWzLfwrjlHWJf7m0JA49LdDxjsaxj5U08r+eIv1Uq2U9w4DrcXyBw3bt2jQA4GEHQE9CW5uOx6r2c/Oxo+21bmNRq9svy/l1C8lODZ2EwUGNZ7jCEA854EbfX0uy+3Ym6gOapc2dC1vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q+kXJyKI; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-292322d10feso44274735ad.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761608734; x=1762213534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cEemqZcZH9VIrEYhJ5L+BJG602q+giyBc/b7QanZLlc=;
        b=Q+kXJyKIjAzWSwD/0fp1RH688+IGauHj+ukuC8YKbCNXpgytdKYZPf6RyjhKmA98H8
         wTRvDaOsofTTyuz0GPmmiDxiqW0tvGbTpMQwLQx+csZpaoaD6+JJHz3x0cQPNkVvsc04
         P26JPd2lKbJEv2pxr6+02Wu8+0c7ImvsvEcUGXZWfSZkazpM7zmSZnqWcVCWgQnozNR7
         GPscwbCk8FaXjjcZm0TK/y9KRgtiYlSCEHHSoNGLHRQu7vlDqAL83P6Q5PEHGsXYB4/b
         6oXZlLo+vumCYBX+zJkMYfl9nqlWY1SuHm2o41AtneUyYmtzF5VtfppEY94EYyyHXbd1
         C0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761608734; x=1762213534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEemqZcZH9VIrEYhJ5L+BJG602q+giyBc/b7QanZLlc=;
        b=FN7m+8wUaCuAhzhubczDPuEN4gf/pkt1JcIScQU9MWV6EUv1L5xoFkuCpTMeIRaT+m
         75I4smSOb4uLVrH3BemGYWiaR37lYwbBoVZ7c0cVQt3wHUu4oO5sOLdKECTvOFOM5gOI
         TvjtfSUGLLPjbVwVe/yGVV3cm28gNBdrrHp+8YepRqm4aL3LVv4IHBUt7DVovsnUDyAd
         qczC8DJePV94vmgxThQElDdT+tEWX/9wyzX89pbvFj5yUB8m8nlfvCzoEXk6EiSrkEBN
         UASf4s6Oq7x118q/9RdDAiDzNSpUqkRkBbeFQe+gsEc47khG8/peMf9KjkefdwbiHvpc
         5MFw==
X-Forwarded-Encrypted: i=1; AJvYcCWS9RP+3tgplM9+NcsCx++fpWGr5/zDd8HCaralFLUq4ntw1lPmrSchPEPvVnJlEvMT99E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqbAfvplSgYfgpllI4S72/tOXO1ahJ6osnYKw99q9Jyt4lzwh4
	unY/FnsXVfLXtPow8E1tjZ9y90KgDpiRCa0dL6/dkLYIzP1/5KTrA7CAcJro6yHoSA==
X-Gm-Gg: ASbGncu0gi2gimGdhFn4dee1Y0zoa2ubPv60jmFolyYmKZPQSzfoVp6mNxH8vihJE/F
	C7diAyVe/zacR3rXjKwE6HxmBYMSzZ3QNCXUJ6l+7EhYuewCfHhFwYkGJDqHo0pFY8hJVG6OAGB
	ynRuPfUNEQDsCtfFzJcVu20jAkhLXdZQ3paSZ+0Ivuvtlg6+Jnm4TOBogOp+TdC6JhuCOqKzTFM
	1AF9z7D6f33EQNYgxFYbVxu9fRhurcRxquK7lwJx2pq89h0UjYWaw9VSeydh7uq4tXgf2d5nm8b
	5EK7Pz1hC5jV2EpAUYtTzuIN78Je/FlxvOBnvKXarslanqLoThLt6xDAcB+OLhNHFBlcBnJ8C34
	mE7iOgdUTeW+8U7ylM0eXS4FtSjdma3GevxuUgPKWKBXZ9WeYIpS9KzQo580o4pcDmygDOJcI3U
	rWYB+7RZuVEKmp7K7MtLQMdZYbOe7yZl2nww3pcWIGfGvrDQVxLGIf
X-Google-Smtp-Source: AGHT+IH0Lr9nFodnqzO98adK3x0S7wkfdClpnJx8lhGHPtPd/KFUnH4pAfX8+j6RSORZT40CKGzYhQ==
X-Received: by 2002:a17:903:3c4e:b0:267:8b4f:df36 with SMTP id d9443c01a7336-294cc77bf41mr12486175ad.29.1761608733609;
        Mon, 27 Oct 2025 16:45:33 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e4117esm93624045ad.93.2025.10.27.16.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 16:45:32 -0700 (PDT)
Date: Mon, 27 Oct 2025 23:45:28 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/5] vfio: selftests: add end of address space DMA
 map/unmap tests
Message-ID: <aQAEGNLbiCFhq-LG@google.com>
References: <20251027-fix-unmap-v5-0-4f0fcf8ffb7d@fb.com>
 <20251027-fix-unmap-v5-5-4f0fcf8ffb7d@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027-fix-unmap-v5-5-4f0fcf8ffb7d@fb.com>

On 2025-10-27 10:33 AM, Alex Mastro wrote:
> Add tests which validate dma map/unmap at the end of address space. Add
> negative test cases for checking that overflowing ioctl args fail with
> the expected errno.
> 
> Signed-off-by: Alex Mastro <amastro@fb.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> +FIXTURE_SETUP(vfio_dma_map_limit_test)
> +{
> +	u64 region_size = getpagesize();

nit: Add a blank line after variable declarations.

> +	/*
> +	 * Over-allocate mmap by double the size to provide enough backing vaddr
> +	 * for overflow tests
> +	 */
> +	self->mmap_size = 2 * region_size;
> +	struct vfio_dma_region *region = &self->region;

nit: Declare variables at the beginning of blocks.

