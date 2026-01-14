Return-Path: <kvm+bounces-68056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4166FD206D5
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 18:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8027A301471F
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 17:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218B72EACF2;
	Wed, 14 Jan 2026 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cfa/T5Jh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C52B2E62D1
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410560; cv=none; b=mdsy2J34i33JH/67/DY3qkWP2ntbZuxPMrPDwJ+cg+/SMVk+cbTeO+jrHWRT7JRLdNFJswSbzWAd598tv6GqIUMXwou36/2bIb72eKQ214F7P05xZ3wPvyrslSdLT/aVDgXU1IbGlbFZ2+7OfSXdu+8nLdf8p8FNC2nSsRaB+Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410560; c=relaxed/simple;
	bh=+3Chiej/V2vv8Lu1RxO+ht/B8amMg1UNl1RJEQiP/P0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RsBTYIZNETrGuRYyGhSELHeWrwwhAIi4+c0NkovY6QTzZu9A6coXMEvZz0BDXLksfG/fgO4nqae/E9k/PX5ku329ppfpnELkSM2X1un2WhXIh1x9ot6mqCsHERK9/hXf4yeZKbcfB/sGf5d4ltSgBSMJkWyhFlj6kRel+xtxA9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cfa/T5Jh; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-81f4dfa82edso8871b3a.0
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 09:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768410558; x=1769015358; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oWw5eeZqFi5AzR5qbLUrsNPCYJAY6GsH21cNOByTI/Y=;
        b=cfa/T5JhARoiQLLDy/aRENBxl4dHqsBI78SXNckfXgX0145OAQgAyMGw68skeq0jiM
         stYLXuDUGkggjYbPJfRbxOJZNbs+nKRwqhs32lA4FRIevSUgu9yxS6McKv+5wc56n9jo
         KBQKWSXS8LGAoxzdk2BGYy6m+nhPpJxDphCpJ6EfL5Elg7frjlJVFlZqDJMFPtwbhPn4
         hp+m3IU28fz8eOYk/ZiIUTz9RL6/J8qFSh8K/mqg86ziLz7Pkd0kaTAp9aj3mkgSXcl7
         xMmtkiMitMZ9F5W//uquabMZ7f70mt/o2tA2kUBONWbzhqxVJ3T1mVvS8Sa8/qRxCtzt
         kCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410558; x=1769015358;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oWw5eeZqFi5AzR5qbLUrsNPCYJAY6GsH21cNOByTI/Y=;
        b=FK6hPY9UzfmOnqwMA4PrUnokV0S7cYrO4r3ehATKlmBO3dyJzVZjqXIbOWC7DLr5zQ
         JXwh7PzINJESVtc2mr7oTnRfR9Nx1mImNj6nM1Me6wW1LWy1quTuMQ9FJDPZyV4pnxSk
         bBXxSKgNbTdjUhDmUN3ExaEwxcnX0BoLgsxQ4xueg5hhTxnciNqbKAtE9HVw0W5eRveY
         U74QZHJLMwHIA4PWy7FFthXDy86BpW2Pd30zBYaITnFXeY7Yr1nKJKKVUG2a9lKbp+Uf
         pu9cx7t3OFzg97wDF2G4gZxyirX3CwfJlDJNhBMsaYOypTBdB7/yjMIJ4R6qxA20GouY
         ZdvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNPnImRfdqdTpvI3GDRSELwKpOKrtKiYqyyX++3v5F0hw3PiiXeBjv+2/ZuGtF9kFYc8s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCdo3EjcGMUun6qjR3Hn/z9qQZvJdEA4v7bBxWAidUTRta6SPO
	Xb90XoIl12V79Ul9ONBUvo/vMLXpbaquC8CvXxL4taCwk86TKio/g/qmuhaq+VQaO0JSzr+SBGR
	XYJKavg==
X-Gm-Gg: AY/fxX7EQXkG1yuTKfSh1GS9St+pNC1HoEdqGETA+32bD9axfcMYGWpsf6k5v7NEErn
	9DZNIpHfknk4jxhQ7Sva5HiH2uzQGquf6PTX2JORYKmifSsMloRIuCqp6TP8PNJ+vkv4Zlx99FA
	4ixdoi0zFGs6VygdeVFg5t/lsGa07ElaPM324VLx3nD3HD6PvqWJ0+web7j2jqkBWoUdkQPiS6J
	T4t2PnZRaACMiUCUdxo0715cWFVg2BPOtFd/Ic64FNo2zFSrUw/tABnOa3GnkjIe2JMjS8lhtdU
	Zt+A5BWZ1CobVZG9Q1Sa9vftU2xOYX6WrFOP2rJudC0PQaPOaaI7bOxjHRhRPS7brR1sJQd1jyi
	aHV97WK+XS4CLKepvKaLo3lu3Bl+rmGudWJj2hWOMHDDqLCpnjsByqfo0CDkC+1R+9NHYeaafyg
	7knUgIh5rSKJRMTmdZzLnAUlYBZT3y9F7Ppeo+CydlOL8o
X-Received: by 2002:a05:6a00:3926:b0:81f:852b:a931 with SMTP id d2e1a72fcca58-81f852bab64mr2088869b3a.35.1768410558136;
        Wed, 14 Jan 2026 09:09:18 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81f8e6a972dsm105528b3a.61.2026.01.14.09.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:09:16 -0800 (PST)
Date: Wed, 14 Jan 2026 17:09:12 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] vfio: selftests: Add tests to validate SR-IOV UAPI
Message-ID: <aWfNuFtifJZAS1a0@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-7-rananta@google.com>
 <aV7qwp4N_G6f_Bt7@google.com>
 <CAJHc60wHXkZm_QU=SUtCGHRrMWfBhBdy209wmdQqnox8Z0-mQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60wHXkZm_QU=SUtCGHRrMWfBhBdy209wmdQqnox8Z0-mQg@mail.gmail.com>

On 2026-01-09 11:05 AM, Raghavendra Rao Ananta wrote:
> On Wed, Jan 7, 2026 at 3:22 PM David Matlack <dmatlack@google.com> wrote:
> > On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:

> > > +static struct vfio_pci_device *test_vfio_pci_device_init(const char *bdf,
> > > +                                                      struct iommu *iommu,
> > > +                                                      const char *vf_token,
> > > +                                                      int *out_ret)
> > > +{
> > > +     struct vfio_pci_device *device;
> > > +
> > > +     device = calloc(1, sizeof(*device));
> > > +     VFIO_ASSERT_NOT_NULL(device);
> > > +
> > > +     device->iommu = iommu;
> > > +     device->bdf = bdf;
> >
> > Can you put this in a helper exposed by vfio_pci_device.h? e.g.
> > vfio_pci_device_alloc()
> >
> Is that just to wrap the ASSERT() within? Or were you thinking of
> initializing the members as well in there?

I was thinking it would include all of the above.

