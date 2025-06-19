Return-Path: <kvm+bounces-49979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C86ACAE0631
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 14:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7402617F8E1
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 12:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440E8241CB2;
	Thu, 19 Jun 2025 12:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="jzF6xH9v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DB222F75B
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 12:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750337355; cv=none; b=MHAkGw2paxhlnVPasDcSORfzX/LCBEPBPxGTZaU8i2fu+RXGhrt00o8kn214v4x8b3yn1NER8/UQe6KU2DcAb1+1ZoL0zMyvv55mIz/k+3VErRwRLprYx346LzC3eLS5KuCmj53IRxbLXh69bwN100L5AAWN8CQQ7T6LMJ5Tkdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750337355; c=relaxed/simple;
	bh=CQ1Ynby7HjlrMEtuy9V+AUygvAtb7qYcvRXtArHF/QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aw4Vj795gmcgjzUoG+C4xVU0rl+Q1CXAnRgJ7oIJhJfcat0DcINwA9zrqz+v+IevXHHOOdWBevTTRnKoSzHUujlYbjk29VzghLyho8qG9i96GYkBQRF0ZPAI418iVi9HK5yZUBOtNSMLkvsMBuSTYLAF5t2Y5Yh14RiffUOcRVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=jzF6xH9v; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-235ea292956so8360855ad.1
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 05:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750337353; x=1750942153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Q/lJ+JUjVVRbd58/OtFVRAYdVLmgcDw+VEZqa5SvKA=;
        b=jzF6xH9vCWfwFKWOtxVQdhTOu+g3pZR1iqe5t5kR0vHkDbJSSQJYcoSbEBqBHruEjP
         a7DBA0/MBpqPzLdEmDGe9+C9gYq1c7UIQv3iZ/wiSxNNA7COg6/J82p1GzGDhDK3LU6N
         Kl0CGfabEuH0PjtDzhXg2eH06M9J8LqMb+c7FOfoRpQQ9DAg2eROuj028soRdZTZf2z4
         MPVIfc1Y7qCwj2wFxIjimjnBQzZlFalzBrbKzsIhLMLSusPNT4bnyCYRxE4ncMUsNZ9+
         IaF3YFGevQkKsVu+naUS+AjcM6UgpriTM5beTFK2+g5xd7oe17l7q+4Qxa77sNinob2s
         4hrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750337353; x=1750942153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Q/lJ+JUjVVRbd58/OtFVRAYdVLmgcDw+VEZqa5SvKA=;
        b=r/Cg5+cNuINoiVDXUcG6yajalOFmISGS+lD7A96l+/oyA+OV5Taz6z7hzDc0PVZeyJ
         +Me4bzukd0DjEKjMUHY0BwhEWlucYVJeGZHb6WMFH2z87EDtnrQKbFXafGhmJ+4bUdw7
         oc7eB9ppOBviwtQDhdfbcTlTB6Td9SIzJA8t8wHW+INE0JvLdCtDQ5zE1cRn5w3xfSHY
         WUgWWDxdhi11TF57nPKGbTju5mIhVmXm6P4bncoY7QgbFNCQDJufVwldg4nQ/T7b99Iq
         R/pbyvSk1R+Ft+ajb82wb4Pbdsnc3USx+m1o9GeH9T2VXSKXBRuLr5jZi90OV8DYQCtT
         hU+A==
X-Forwarded-Encrypted: i=1; AJvYcCUBQ9g6OQVxBxUzFvrjVwcECwtKh48gZRUURlSE63e2ThmM+Ky/WWgUfxO6heSbeR/SMxw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM9TlMphhRqRbCAcDfyX3dFkrU1ji/vZ0Yo6XFaHpAd/LkRodN
	+SbI3LXl6taAXJt+s/3/QuwMZ+PRUO85MXLMX9CJTytyCh718BZp/fNQmUQxFJSlzK0b8G7OtCA
	PvV9m
X-Gm-Gg: ASbGncsPX9AstG8ePaF9fc5gLCsD54FE+gtpuHdiSjqLPzLrAV4sVBkNStsJGWBJIEg
	Ip4tvtSFOMu9wLUgm3/R9FBKuo768/T5bpUhLOCBTss+mm+ers7LGys6u4mvnM8U+AiZOGxQ9Zd
	rhGob0CI5fdt617cSQTRyRvRxhROi5TKjTSN7N8kY0y0JX0ZX2hlL5phQT0xu6uS03kIgQAzEtu
	Y6oReL5vmqoz9MDjEsQcmzyBtbdnsLDy2rPgTRVLooxERUQ3Rg2O4LYbD8VD35as1es/7EgBV89
	bK5nrEnO/Hg1hCqmo4+M43JYXpjGnkIu+5t2hfax73y/ipLDMxFpm1Ll16Giy27GY3JxMVWoAM/
	9w3FK+ytpDLdY7w==
X-Google-Smtp-Source: AGHT+IH69LtPDdAgrBovWhMgrSjTEeMKCzKN63Bmw3qGTAGNPNoBSMtG8u3ZPMyzGP1TzYebG5OJzw==
X-Received: by 2002:a17:902:d50e:b0:235:1706:2002 with SMTP id d9443c01a7336-2366aeff7a1mr337959005ad.0.1750337353103;
        Thu, 19 Jun 2025 05:49:13 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d8a5b4bsm119579195ad.54.2025.06.19.05.49.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Jun 2025 05:49:12 -0700 (PDT)
From: lizhe.67@bytedance.com
To: jgg@ziepe.ca
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Date: Thu, 19 Jun 2025 20:49:04 +0800
Message-ID: <20250619124906.47505-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250619123504.GA1643390@ziepe.ca>
References: <20250619123504.GA1643390@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 19 Jun 2025 09:35:04 -0300, jgg@ziepe.ca wrote:
 
> On Thu, Jun 19, 2025 at 05:05:42PM +0800, lizhe.67@bytedance.com wrote:
> 
> > As I understand it, there seem to be some issues with this
> > implementation. How can we obtain the value of dma->has_reserved
> > (acquiring it within vfio_pin_pages_remote() might be a good option)
> 
> Yes, you record it during vfio_pin_pages operations. If VFIO call
> iommu_map on something that went down the non-GUP path then it sets
> the flag.
> 
> > and ensure that this value remains unchanged from the time of
> > assignment until we perform the unpin operation? 
> 
> Map/unmap are paired and not allowed to race so that isn't an issue.
> 
> > I've searched through the code and it appears that there are
> > instances where SetPageReserved() is called outside of the
> > initialization phase.  Please correct me if I am wrong.
> 
> It should not be relevant here, pages under use by VFIO are not
> permitted to change it will break things.

Then this approach appears to be no problem, and there’s no need to
introduce any new interfaces. All modifications remain internal to
vfio. I’ll send out a v5 patch based on this approach.

Thanks,
Zhe

