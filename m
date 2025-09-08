Return-Path: <kvm+bounces-56968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0340B4867B
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 10:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6536517965A
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 08:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF982EA170;
	Mon,  8 Sep 2025 08:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QwKM46jP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D9172602
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 08:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757319560; cv=none; b=HsW4BLQvma/zz7NHsD+RSVYi/0PxhB205rR5y3wvmMrRFcfQjTAR9P210btr20hq1ZcAS+5rWqI0cpFnqnuWPiAUDUJaH51aXYQsXuijKkBeccShAvsYVSbV1WVOq2viaZ87N/oAzNTARxP9fnz3MNd7g9AZCQrQ8+NTToHTv+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757319560; c=relaxed/simple;
	bh=3PyJV+StjgIVkEWtX4H6Ny6VkrS5cQI04R3gvWkP2eA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvojXjebQ2MsdKwMaOGOkjWsyNp7ZUga6NzBF/vbwhya1U3LCFo4Ny7Ig3TxSCekA1zhV6Y2GC4ejL/SA9zeXy9wm8QNnz6frP2/IZLMpGpGUIikIAKUpkQcNLnzgiStBRhWZisenEdiT31nqmyOxxrRjUTm4K93mqZfuUNlAI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QwKM46jP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757319557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0UyJSlxbrHIBuXnJqZ+U4qOcyo39On7CqIS0Perb7I=;
	b=QwKM46jPIftlpi52TQQcmYWW7+jNiZsm1YWAvCZO1bITZaTIi8AbFrlIGgWDqmU4/Xo4mb
	orS3ABSWpYRZODttpJspvH//5+9M9x/jcSH0hZ7rc8PKQ8QIc3jK3Y8LrjaO0N1maUUdXZ
	Ez522QYnpx67K37zKJKkxayGc5Atdb0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-Gad0zGYjOiaWPQ7JGvz-dA-1; Mon, 08 Sep 2025 04:19:16 -0400
X-MC-Unique: Gad0zGYjOiaWPQ7JGvz-dA-1
X-Mimecast-MFC-AGG-ID: Gad0zGYjOiaWPQ7JGvz-dA_1757319555
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3db89e4f443so2519396f8f.1
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 01:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757319555; x=1757924355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W0UyJSlxbrHIBuXnJqZ+U4qOcyo39On7CqIS0Perb7I=;
        b=Dvy9TiLIC6VwgqMV/VBwLuEaymYpK/U77CSBbxGFGcfz6AJN1UXAFAwpIlDqvBZGub
         GmkzetlIoPoxc7jRJOjXTtBRZOaKBk7L2BcA6Yv+1xaB/92jpPSxQ+duG15SVpcNmfff
         oWkdUpT7PwtDLVIZSl3EHSXGMiVz/gVtszS1D+07w2krhGfaCN3UnjRFpjuv8OeKodoJ
         NVGT/F2oyUwQovnzYe7amnph/cn7/AenojABg5dntbAzPen+nKwiiPQg89oNaUN4/RpV
         9LXgFv/qI4WLrqTOy6Hc9wLQzNWTtP6J6umi8L9+/0staBhZljk005dsbe9GUiyeHmuX
         yWhA==
X-Gm-Message-State: AOJu0Yx+HDS/Zs6z9RXF0Nb6YsEj/8gyN54jMc8HuWrkM+4493w7scTK
	dGfiSkwBsLAAGbRUbSI9MG8sd+kLf+2riob1Fi6RZIrBFuhfKcXqcqOIuxgKtsoY7XMm+eewXxn
	M1pGb+GMlMJknGJPIyZOs7VJLXfhGT3lwi7aJRdB/FCluc/WicxaxzUWv857sSNS9ebLFgE5zn2
	Ci+ZN+6ebRE/wFM7pOvwCma85e8NxcXFwrQyfLOw==
X-Gm-Gg: ASbGncuNKuNBEX3X2k5JUDOJkkYsW2ks4uIfO7blyV9f6jvNsRBRoDkX1hQo282GN2L
	Sk91GDwNxTb7gF5hQVGW9Bm6R/6sNFcBeAuEFjxb85b6G0DJXcymB1ztQYEpup8cmgIx3jmH4TX
	Y7U5oJ3uQhjq4t7JFy0r2Nv+1P1sTZycAKYU429AyRX0sFBIFR1gZ6d6sjYGOfC5uErOXg0IUdU
	jNph47ZeVSX1zyK17F0vRjqpsnafXkLb53E53VoJrokUXuaSpnHGQbmjUc1gvuDHRKJisl0e/Mp
	yNc8cfz+3katn0UWUQpN+LuGgGMiRw==
X-Received: by 2002:a05:6000:4211:b0:3ce:f0a5:d597 with SMTP id ffacd0b85a97d-3e64c1c34aamr5197063f8f.47.1757319554810;
        Mon, 08 Sep 2025 01:19:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhrG4edjuXDTWsmvler8GvnQcaqp0UUEKLDO7epfAHY6sF25XXjcTOZhmKA4T9ODQNL7/diQ==
X-Received: by 2002:a05:6000:4211:b0:3ce:f0a5:d597 with SMTP id ffacd0b85a97d-3e64c1c34aamr5197039f8f.47.1757319554365;
        Mon, 08 Sep 2025 01:19:14 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3db9b973869sm22113178f8f.18.2025.09.08.01.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 01:19:13 -0700 (PDT)
Date: Mon, 8 Sep 2025 10:19:12 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 0/5] x86: add HPET counter tests
Message-ID: <20250908101912.4707b580@fedora>
In-Reply-To: <20250725095429.1691734-1-imammedo@redhat.com>
References: <20250725095429.1691734-1-imammedo@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 25 Jul 2025 11:54:24 +0200
Igor Mammedov <imammedo@redhat.com> wrote:


Paolo,
gentle ping

> Changelog:
>   v4:
>      * fix smap/pku/pks tests that were failing CI
>      * on_cpus() wasn't running task on CPUs above 255,
>        fix x86/smp code to correctly account for APIC IDs
>        above 255
>      * bump max cpus limit to 1024 
>      * hpet: count 0 latency as failure to avoid missing
>        APs that doesn't run reader task
>      * hpet: replace on_cpus() with on_cpus_async() to
>        to run reader task only on explicitly selected APs.
>   v3:
>      * fix test running long time due to control thread
>        also running read test and stalling starting other threads 
>      * improve latency accuracy 
>      * increase max number of vcpus to 448
>        (that's what I had in hands for testing)
> 
> previous rev:
>    "[kvm-unit-tests PATCH v3 0/2] x86: add HPET counter tests"
>    https://yhbt.net/lore/all/20250718155738.1540072-1-imammedo@redhat.com/T/#t
> 
> Igor Mammedov (5):
>   x86: resize id_map[] elements to u32
>   x86: fix APs with APIC ID more that 255 not showing in id_map
>   x86: move USERBASE to 32Mb in smap/pku/pks tests
>   x86: bump number of max cpus to 1024
>   x86: add HPET counter read micro benchmark and enable/disable torture
>     tests
> 
>  lib/x86/apic.h       |  2 +-
>  lib/x86/smp.h        |  2 +-
>  lib/x86/apic.c       |  2 +-
>  lib/x86/setup.c      |  2 +-
>  x86/Makefile.common  |  2 +
>  x86/cstart.S         |  2 +-
>  x86/hpet_read_test.c | 93 ++++++++++++++++++++++++++++++++++++++++++++
>  x86/pks.c            |  2 +-
>  x86/pku.c            |  2 +-
>  x86/smap.c           |  2 +-
>  10 files changed, 103 insertions(+), 8 deletions(-)
>  create mode 100644 x86/hpet_read_test.c
> 


