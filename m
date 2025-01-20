Return-Path: <kvm+bounces-36059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21BC7A1728E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 19:09:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2B5018893C8
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 18:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F791EE7A1;
	Mon, 20 Jan 2025 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ircpq1Bg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B021EE010
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737396567; cv=none; b=X8e1kXqvQAv+X5ncDe6tRtVunq9rxAIHmesD2cHGmu/AevDx9pxhVfoxLcjZfHkCQr+ThHEyZ7VRfrap6gYrB2z2HrH+zahfBmbGCHRO5uXvAY7+h1kZHkdlmWh0i/FgZiNofDsMABA2PNoel9KIBcGq53cm/3fgSffytM8Jwm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737396567; c=relaxed/simple;
	bh=mM/kOGa0f71PPZ9gTVB4e6nsdgYUKdfVs7f4RnmhbaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Je57/ATUT/wsU6jObFFNZZxvxmkpAapdAtpOv0PcarI2ogI0hmtKBlAM8K7ScrKnZoi0L/FWNYPpPUyMJXl0OkoPqtoSpWrwEIT0SEDqpjVQTNvt0EozQfONSl3P5ekiOMWbBPVfCcq1xM/Nv0dS8FVOKk+sLN96kdOk+Aw6ykc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ircpq1Bg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737396565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EHf31zdeRsN+LrETSE3SYi4HGjOctajALm9Hz8KGoDY=;
	b=Ircpq1Bg/AZ+YG84IETLpUv6ArwuvtHDTvLDfzt0aWebklfh6gnrQzCP3HoJBPfJWl54ul
	psYisxnCqXOxUJwMlEnkjclPiZFsAJFWLbHG+gww62GkCAeefewvwE2klaYNDrslIP35MN
	0+DG21a1TRXvm/sTTRZLwGAE30mnQSY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-bXzhMgisMjahVFlMR8Q3qQ-1; Mon, 20 Jan 2025 13:09:24 -0500
X-MC-Unique: bXzhMgisMjahVFlMR8Q3qQ-1
X-Mimecast-MFC-AGG-ID: bXzhMgisMjahVFlMR8Q3qQ
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6dadae92652so110123696d6.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 10:09:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737396563; x=1738001363;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EHf31zdeRsN+LrETSE3SYi4HGjOctajALm9Hz8KGoDY=;
        b=j+YWdnh9Nd9W6By+gN35O3fhHSajyZeLKhroQx6PZfrZhkq9RYCNGPcdepBX7XoLu3
         z6QJoGEQ+lQtizUXupar3MM/r2Ciz5V1MYvIltyCUcp6yET7M48Myu43MQUtkfJzMo1P
         wJeKKs/ySXQrNhFUEFEHWyICzJXtTmS2vlBAwK47Yer5d5mkPg37wOvtZP8FuMogFipy
         PsWFTkN/TYMOOBEQ9ZDc6lUMNE9362r4g3qyQ4a8DUNj2LwYv6mnwl2Ei56F8wrS9QMr
         D0XknLmopvDt2EjVe3DCqLl50/KO3JkNetv6ytGzfhujR257sQVXG0EMbi4Bi3NqZOI/
         Oqpw==
X-Forwarded-Encrypted: i=1; AJvYcCVNDLZiifMxK0Rb2Ib68XvG/gezrTEsux5Epn5iDaNDQHJlKz954yhxYEpO+6drOukc350=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzqr3Y1qlrsMePwu3z2i3GtbOsQ6RtCy4h4asOmSvdu+PGXRlHJ
	6sFu3d0f8IqXLdj0XP10byXzruaPPk86eWDCUwufWU2//p5oz+41KIqxI7r91HWvPK1YS0I4BPj
	FjY5mdiRzO1UjcrJz3zBX17smfftFxdp3gc25Nk56mHlQmIDfxJPEqPPsGQ==
X-Gm-Gg: ASbGncuExOXF50v4xdG82MUPZUHo+rRR+SAwu046QVxRBiOxLip1qCGCwDeb1DFzn7Z
	7j0B6k+R4pTh6VfpV2Yv5jTUmZyZQYlaR0TyUCmnGLeRT8MnHHTBFlNox+1NK9uSSujVfcDezzq
	xyWz+5XPvUMrd6rwcx734xIV0eHSebEHz6sEvFlzKtZPrQTakuaP4diQ1DNkwneECSmxSIXgshf
	ctCb/7tTl1uaGpLB9UBSg0KpLUJjwql1QqlZ0eWN52T9FRC4VwML/jQLrFexZwSA4y+iDOUkmm8
	sDv1TKWiF9428u/G6wlh8P8XHKpbFas=
X-Received: by 2002:a05:6214:3d87:b0:6d8:b562:efd7 with SMTP id 6a1803df08f44-6e1b2229dc0mr261336016d6.31.1737396562817;
        Mon, 20 Jan 2025 10:09:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjzZIqFhBIxeSLxy8x+gO/zeP93RnHT4J++T8bkx1vgiv7xGXlLPbRz5jRLbhzBjJp51vTiQ==
X-Received: by 2002:a05:6214:3d87:b0:6d8:b562:efd7 with SMTP id 6a1803df08f44-6e1b2229dc0mr261335756d6.31.1737396562607;
        Mon, 20 Jan 2025 10:09:22 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1afc22e4asm43517376d6.56.2025.01.20.10.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 10:09:22 -0800 (PST)
Date: Mon, 20 Jan 2025 13:09:19 -0500
From: Peter Xu <peterx@redhat.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z46RT__q02nhz3dc@x1n>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241213070852.106092-3-chenyi.qiang@intel.com>

Two trivial comments I spot:

On Fri, Dec 13, 2024 at 03:08:44PM +0800, Chenyi Qiang wrote:
> +struct GuestMemfdManager {
> +    Object parent;
> +
> +    /* Managed memory region. */
> +    MemoryRegion *mr;
> +
> +    /*
> +     * 1-setting of the bit represents the memory is populated (shared).
> +     */
> +    int32_t bitmap_size;
> +    unsigned long *bitmap;

Might be clearer to name the bitmap directly as what it represents.  E.g.,
shared_bitmap?

> +
> +    /* block size and alignment */
> +    uint64_t block_size;

Can we always fetch it from the MR/ramblock? If this is needed, better add
some comment explaining why.

> +
> +    /* listeners to notify on populate/discard activity. */
> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
> +};

-- 
Peter Xu


