Return-Path: <kvm+bounces-49691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 413E2ADC6ED
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 11:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9EE271894795
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96613295D95;
	Tue, 17 Jun 2025 09:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="MkUrAEwK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6CB20D4FF
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750153642; cv=none; b=sg3PGBir/fHzF5NaskQCUK+BVW1DOk6jbU7Y9/Yok+M+rmDIISWy+jy44X8ysyQytR834BfFAuw5jCv/KL0UA2EiqS/3CByN9Z25tOXlGvVySL1VPuTfbPZmisuzSmjMFCKNN5IGq8FvLu+KkrlC/R4oe267ZcM1eJy1uQVIHKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750153642; c=relaxed/simple;
	bh=hbAOen0mndnPVGThYal48b6Qsq8ss72uXnGVk6FVKsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONOIn8Pi+cMdfI8D8TrMaLXHIfasQJ7os5q68oIG44ItVJQTliJhY8KOIQdmmoFb9NnBIPN1RT479XFjEaZUuUxPCQHcqQx8OkOEAtkucUrZGgIefPTRjUV5/Qw+gfWaDtAR5Ihtzyyq3M2L/WZ1XIR4cy81I8k0AJUSnuvoWWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=MkUrAEwK; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23649faf69fso53534025ad.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 02:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750153640; x=1750758440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2kX7kwU00/VILvEVMTOYheAsMG6cGeF8RMM8/0Bh3M=;
        b=MkUrAEwK4ZO20hxafHRzVYQqAQYR1X1nBJlbObr9mEfq1j4StlF/OU55/RW8WVXbDH
         Xr1O8DATOQADHUQ3CUD8P0z6ToQibcyatijCUkbJHiJvtJaXi/FX7JwyQfnwWH/SlJ3m
         RiRH8z5nCLaqE6YckjSQd9WRXBl/iqTyExIWOPzDvodXDggT2mOtyvFmdH+LfLg9BpZI
         rcKPD3VENeokf5A1pCUK5Zi88w83S0+sRND0x40rw/2EAvGsbFGtP/aJ88D+r6O4oPfj
         vXz6yddLO/r+sqSek8bwrptXez26wN+ujM6tN+bzsF4dP4OMf/Yj1vsrO30KNpDJlRxn
         rXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750153640; x=1750758440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2kX7kwU00/VILvEVMTOYheAsMG6cGeF8RMM8/0Bh3M=;
        b=iFRezQA0iGn7lbeUiZ1BQ7iyTIOlCipIH5FJFgtkxj7jaLn9S8EPV3Z6Zv5/3YpDsL
         ub0D1VrgFAsxpeuzboQWOFYl5NOBGPCHmjMWhDGCaA7g99QehJfsEYCiUrgKSogzCgIN
         nC8XT/SSv6hbNVRx8e4zTLvLfonuGCzLUtQEVy5L8mtR8UBeBBZcQrIMen8solMwiBTK
         8Tm+F23VfF3tAsiUlPjF6ECwZKAhqbE0axQrKwuG51eyyexaDB6xP02lTkMj9e4sCpxd
         ZxKTFlas64bf8zfxX3a62stM99TcV+JOuxxgAML5rmO+wuJGwyr591CBB5uaT9Y8wjnW
         HAUA==
X-Forwarded-Encrypted: i=1; AJvYcCUzK3JtJJsTYhChKOzKFSAgHl/Dx+pOKr5FI+L50yiJGqXnGqNNaz8VSajPWc2fYyBhqlk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYWiD0SSjFXZZnriQhAfrmbiHCci5PXuT+NmrMc+zf8pzz6M3B
	x+MJ0JdtwhpyvT/zSF5BwPydr94W7w29yS0LkK5TcBId0n61LZbucWOaZ0E6sKMq2b8=
X-Gm-Gg: ASbGncsCYvR3aVy3LSR58fI29BkZdDO4YjBHGiO7sbEMV6vkS+E56p0avctTQkuGQY1
	S7yv/0VS81ddJ6+QB7WhIqGaJeeJPRD9DIy4ohhX5DTIt6iPi9lNv/mjfI6t89j3eclEBpJwDQx
	CrRvFrLNYMNRBDNJY+pErxmd8WeHiWe6aNwSIKa/ZlD/Us3LKPlRNy4rlTOujoTRSPhgr6rJ4oX
	U30kbEw/tv3uzZ4G3mEUh+iIOZyXwhYPdLz9hH3DSbbhRg3PygUrrLkk6+2cDpuj4BJ5z0pbNKH
	vWTVIGRXH5FvygIjciIXrO+uBNKM7I2iq7lXXKH9zgyT0o867YcMi2Ol4f9a+o9h9ciiK8aBint
	yuA3fOy5HwwB9
X-Google-Smtp-Source: AGHT+IESDTvDlZtVICySxxTxUX5c7za0ABSNQvG2zk5eRdds5SR0YkPg1SIYIgfPcl4/b4u45DB0YA==
X-Received: by 2002:a17:903:22c5:b0:235:779:edfd with SMTP id d9443c01a7336-2366b14f864mr187735825ad.39.1750153640379;
        Tue, 17 Jun 2025 02:47:20 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365de781dfsm75975395ad.131.2025.06.17.02.47.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Jun 2025 02:47:20 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 3/3] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Tue, 17 Jun 2025 17:47:13 +0800
Message-ID: <20250617094713.12501-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <e0c741a0-450a-4512-8796-bd83a5618409@redhat.com>
References: <e0c741a0-450a-4512-8796-bd83a5618409@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Jun 2025 09:43:56 +0200, david@redhat.com wrote:
 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index e952bf8bdfab..d7653f4c10d5 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -801,16 +801,43 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >          return pinned;
> >   }
> >   
> > +/* Returned number includes the provided current page. */
> > +static inline unsigned long folio_remaining_pages(struct folio *folio,
> > +               struct page *page, unsigned long max_pages)
> > +{
> > +       if (!folio_test_large(folio))
> > +               return 1;
> > +       return min_t(unsigned long, max_pages,
> > +                    folio_nr_pages(folio) - folio_page_idx(folio, page));
> > +}
> 
> Note that I think that should go somewhere into mm.h, and also get used 
> by GUP. So factoring it out from GUP and then using it here.

I think I need to separate this out into a distinct patch within the
patchset. Is that correct?

Thanks,
Zhe

