Return-Path: <kvm+bounces-62640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 528F1C49B3F
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAEDA3A8577
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65AA302158;
	Mon, 10 Nov 2025 23:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n3r9yfSy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8D41B0413
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762816052; cv=none; b=bZejuI+vltBCPuVX5JK/ohKqEYG6DFWyp0X4WTb+LLxqbe3c+BvobXt5Fp7FH6K5ttkzWFcLPaRS+Bz0Qrx8DCJNMiWs3D9jog6RkVwvlVwYOLKH67duRmebGPb55XCcvnRE2Up+hHNZWtkmB8wBBG5Rbm6CcE/3Ze3IJwf3w5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762816052; c=relaxed/simple;
	bh=ifTxb2fd80Nni8oK6meGxFKTiLW9n9nNKijfIBRIngE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yzx6OdpgqmnknXMxjUFjSnhad7yQly+J5GmeWfbUN8pGwPL2rgU04Stf+YOZ/xSTaNcXQ7n4bcbziBMF3Dm9L9GsIcRm49ARpyquU39PNGpfvgRzqwBpOX4H7/9vP6qXOvDtpTlf6hjUVKt8K9rX28jFjV/3T/FBxlgWea5qpG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n3r9yfSy; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-5db308cddf0so1988742137.3
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762816049; x=1763420849; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+TEDRVllKiGheH9iPhSOnW7gc7oRa0YYtno5v9NCzU=;
        b=n3r9yfSyKE3IzQL9ORE1ZGcbG2uG7P5DX/Kqy/pLHe7WgBgeA2/PDMV+QyC1dFX2sx
         aIYtfX15fX2KuU0DwHQMlNT4rISWqVJyj9DEN+bwXDPP4djO+vQ85KQY7ZGGpzmgpNas
         3IVs8UZCbOmw9pfLkfNVerRp0fi3nhtDBFtM2MpDo0anbd0HoKpduCQTjuxZ26i5ycUD
         PKBGTo61avn4/6a3kUTl0hmDxTcPLsSKUmkDC80dQPEPQYn//TRKRZ31k0ZPGlUIt99v
         jfEdJFncRUavicFX8KUK5Jo6qv7iCoY6RbHVa8NBELvUwy8WSAXLGCKU9NcMOgDfs08c
         qECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762816049; x=1763420849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A+TEDRVllKiGheH9iPhSOnW7gc7oRa0YYtno5v9NCzU=;
        b=A2ODApycTk01+b5jHeX89nnZ/8+pM6DpcDtByA6pc1PGeC7heObzRAeoiuCFSX++v2
         hICwT1EehnZk5Qb+tMJup1rV4Zf1C0EbPSgAjDfQ3uZqLiSUNUjNdWqAabrgOIL2cM9q
         mz164US0ffN33kPnzYfWTvFb4X/BZ8wtH5QDYzaUTPaXD31Sr1V9RmCfam5vxdJvHZEk
         HkrMi1eYGMfLCopZQaxIK7m4B+ifrfKLvGb1z3aFAS8Za5qYLEYcy205c9xwlSRHww3J
         jLYheNteEzYY1Xl9gOXkMJ9m3HihnHiKe98KNHc8Rvf47sVLfQDSlh5SA7iAFD5PQQnk
         p9Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUzcogvOOklXZZR8m2IdpjaFgxX2B8PY8DH0Lor4LAxSNIr/lCzGHzhoBr4Y/BpMLWIEhk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3euXcdXclvZUwQ6Cce8ay8fBV6ylwRxsV1aUaXGT64XC4CdJl
	CrUiwwmHsC73AJRYwfB6bBAaQIKE+SYWYq60wgm76jMPljPECAYTVpQaG4D6wU3Mgx7z+x+ExSy
	MOiHd+rvLbokXz+Hp98Zco+3KcPPyiUZKzDn3plTL
X-Gm-Gg: ASbGncs9ZlSWU1FENzD4B6/F0FCc6IymHwLloCZ0mMaXXmvinU0LTS4lYndt8K4cAAX
	b/TWmwe/5I2pmA2bvHqeWtoI8saOcXqsWQA4w0SfEUSNhLWm6mw0VOSzDxv63fOyhzYoYBZqNvQ
	U9fiwCvL4boftQLAoqg+eTrUm9QQ+UMBRlYlkmqbo+HqVb5p5XBd/9OOicTYGZXnAP6sKisUXh1
	/0TQujmo5c02jakpq4i1bU5G9FsIV+yHJdNA2kZGs5ZxZi4cCCnu3b5NvIoKRushGnQNTvDnBBt
	/993RA==
X-Google-Smtp-Source: AGHT+IHjmwJDAFc2cXjg3msYUZA3lWk7d5XqAZpIUjQ6p7MF9o2gzZJ/MDrxTGoDvltOyMfSpTaTasHvkcT8023OaSE=
X-Received: by 2002:a05:6102:c88:b0:5db:e0fe:984a with SMTP id
 ada2fe7eead31-5ddc469b7f0mr3590347137.19.1762816049213; Mon, 10 Nov 2025
 15:07:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110-iova-ranges-v1-0-4d441cf5bf6d@fb.com>
In-Reply-To: <20251110-iova-ranges-v1-0-4d441cf5bf6d@fb.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 10 Nov 2025 15:06:58 -0800
X-Gm-Features: AWmQ_blpug0sXFFcDvfwK6kurgehZgkyn7cusv2Dm36toryt7-1iUtP1-uzEui4
Message-ID: <CALzav=e5JD4_4+vqa6udd0dSymW7W-=8Fnf-q0VaBv20+BvXBQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] vfio: selftests: update DMA mapping tests to use
 queried IOVA ranges
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 1:11=E2=80=AFPM Alex Mastro <amastro@fb.com> wrote:
>
> Not all IOMMUs support the same virtual address width as the processor,
> for instance older Intel consumer platforms only support 39-bits of
> IOMMU address space.  On such platforms, using the virtual address as
> the IOVA and mappings at the top of the address space both fail.
>
> VFIO and IOMMUFD have facilities for retrieving valid IOVA ranges,
> VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE and IOMMU_IOAS_IOVA_RANGES,
> respectively.  These provide compatible arrays of ranges from which
> we can construct a simple allocator and record the maximum supported
> IOVA address.
>
> Use this new allocator in place of reusing the virtual address, and
> incorporate the maximum supported IOVA into the limit testing.  This
> latter change doesn't test quite the same absolute end-of-address space
> behavior but still seems to have some value.  Testing for overflow is
> skipped when a reduced address space is supported as the desired errno
> is not generated.
>
> This series is based on Alex Williamson's "Incorporate IOVA range info"
> [1] along with feedback from the discussion in David Matlack's "Skip
> vfio_dma_map_limit_test if mapping returns -EINVAL" [2].
>
> Given David's plans to split IOMMU concerns from devices as described in
> [3], this series' home for `struct iova_allocator` is likely to be short
> lived, since it resides in vfio_pci_device.c. I assume that the rework
> can move this functionality to a more appropriate location next to other
> IOMMU-focused code, once such a place exists.

Yup, I'll rebase my iommu rework on top of this once it goes in, and
move the iova allocator to a new home.

And thanks for getting this out so quickly. We've had an unstaffed
internal task to get rid of iova=3Dvaddr open for a few months now, so
I'm very happy to see it get fixed.

