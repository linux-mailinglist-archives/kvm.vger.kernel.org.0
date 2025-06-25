Return-Path: <kvm+bounces-50694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FB6AE8592
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:06:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98FAF16EBA3
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1183226528F;
	Wed, 25 Jun 2025 14:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4b8aoftD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E441525FA07
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750860335; cv=none; b=Aioq2PZ3HNE2A1aKASzG/yq9Wjo6u/R3KpOMOomSmb6l3rtT7M+iFzwz/xtHi3WLOjtD5Zdx88A0FyRq9bgnmQPFUbSPAJddxmX0dnqUhHg4K/bKeEfenaPoZRB+TT7XXF9cy+jssQgiOsfoaJjpvvc8yFgNkoVO5ALpeOTNx08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750860335; c=relaxed/simple;
	bh=k4HVyaqjM3pqT9Wr2KUojiGSkbVMogoZWDuBaEa4Xu0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BW5YQ0vifEoOXHRkQ1pIH7tc8lB4GwgYHbz4omC7JrteWmcjIkvziyQX3QmVzf4Czhks1UkPR9frJG03aHRjJRBqNyKudGkpUa4J8jcLlCrE1neqbimh4gka/PJsx7V+kRq96xumoM6xY4Xw7IH4zF3vkRCz/+kZosbBF5JfsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4b8aoftD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c8437ffso7332415a91.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750860333; x=1751465133; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5LiZuxU0X4stkx25S4vH5DV1hISN4p0EdhdVeAOMiJ8=;
        b=4b8aoftDFSGR3pcQ+cIT9nFWqLmt0s1sUOZvXuS6s6lm95/kYP0jQRVIRHsU1wnwjA
         STkR19ph0lRf29UNFHW7sRm1PZfvpcq7SGMIfFgYWBHYAqfpK65rsEhtMn2fJpjfdVue
         0J4UMdgefLJ2WntOWmvbOcAzApi4+vGUj9Iqyl0tj1MzJm34NJd5I3N+khfrZY0emvhM
         Hjr6QlBj+JqXn1hVperIdEXzolt2FIxIjoxca9Fa48l2Tq7fSwUO64gNhrUDHIaMMWDw
         YQCb/JPQnGrJBwrbwDPoy521wlz8AvEYmkoFoeSlhlAJ8C/8cZe8d+YEUJGqYdI4W6yr
         5dlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750860333; x=1751465133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5LiZuxU0X4stkx25S4vH5DV1hISN4p0EdhdVeAOMiJ8=;
        b=TXI0IOXBO4v0XYjKFhcZdL120Z/87F97XHK7OsWXLhaD1ygR/yqEGJpaMT6hGdkPY7
         exbyO/Br24//r29ihyioH400iIjDCYT1XG+YFAbz2WdW2+H/1RQDoAH6Bj818rmQU/sv
         PXv4Dy3Oz20szOcB9G8hA9r8M1PvCZYx6LO0YsbOzKGhNIbnspNDIZ/+NhB5qSaxZKDA
         ryeMQXlARA4hukyygy8utm2laUUaObf/S6/74IZj9PDDCE6ESqV1+7u+HSuRwu7U9ySW
         EVNAcam+4thTigF5N3xck9hrQ/7tzpLBGqlz0T2m/lgX2PZ31+qrxcsnLr46S0l2soPg
         8fJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyKivXIx2FxWU1oq5rcKR/ZICtwIm4fH/1VBzBwDVHhyR0ZX5LuYwVKzz7BqBfKQJKzBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzF0iTWcjOuqy1Owhh6GdzNwlaffxbXs+/y4gi/Gxdhm5BH7Qo
	z2uxfU0sTbcVI08zQDUKwygNDSiMjv7WT2NskKfhsbDRYwejxR9WC+PSu1XR2LUOjLl/fZ4eKTQ
	pmZkeYQ==
X-Google-Smtp-Source: AGHT+IGckEOfVl/RfPz4QxWmjhV4cTi9NaNXbPxlrvg9sKJy9zwdKZPKfKQ2WqXnR/25QNts35bfKQ1MbcY=
X-Received: from pjboe18.prod.google.com ([2002:a17:90b:3952:b0:312:f88d:25f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ed0:b0:311:9e59:7aba
 with SMTP id 98e67ed59e1d1-315f25ca4e3mr4777982a91.2.1750860333261; Wed, 25
 Jun 2025 07:05:33 -0700 (PDT)
Date: Wed, 25 Jun 2025 07:05:31 -0700
In-Reply-To: <2f4603f4c74ba21776ad6beff5f5b98025c99973.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-19-Neeraj.Upadhyay@amd.com> <2f4603f4c74ba21776ad6beff5f5b98025c99973.camel@intel.com>
Message-ID: <aFwCK3g-dDv5ZJQR@google.com>
Subject: Re: [RFC PATCH v7 18/37] x86/apic: Simplify bitwise operations on
 apic bitmap
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"Neeraj.Upadhyay@amd.com" <Neeraj.Upadhyay@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"tiala@microsoft.com" <tiala@microsoft.com>, "Vasant.Hegde@amd.com" <Vasant.Hegde@amd.com>, 
	"Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"huibo.wang@amd.com" <huibo.wang@amd.com>, "Santosh.Shukla@amd.com" <Santosh.Shukla@amd.com>, 
	"nikunj@amd.com" <nikunj@amd.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "naveen.rao@amd.com" <naveen.rao@amd.com>, 
	"David.Kaplan@amd.com" <David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 24, 2025, Kai Huang wrote:
> On Tue, 2025-06-10 at 23:24 +0530, Neeraj Upadhyay wrote:
> > Use 'regs' as a contiguous linear bitmap in  apic_{set|
> 					      ^
> 					      double whitespace here
> 
> > clear|test}_vector() while doing bitwise operations.
> > This makes the code simpler by eliminating the need to
> > determine the offset of the 32-bit register and the vector
> > bit location within that register prior to performing
> > bitwise operations.
> > 
> > This change results in slight increase in generated code
> > size for gcc-14.2.
> 
> Seems the text wrap here is different from other patches, i.e., the
> 'textwidth' seems much smaller.

Yeah, wrap closer to ~75 chars.

