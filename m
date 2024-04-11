Return-Path: <kvm+bounces-14285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDE28A1D63
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5C3E1F22472
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518531D8EAE;
	Thu, 11 Apr 2024 17:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XjuyDxQs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446D21D639C
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712855059; cv=none; b=fN+HTDWW2wptD3HMRmltJvEQb+dEgg7B6HQmR2ow1q4q+3fQqjmnTo1t0SaIhABn5xJfjd0J5EehKMPXoLLx9sAFdFu4893eXpl8XWlMG1Uf5mT2U+zB0kIXoO/w231BgBjVUvzdEzhOfHuhaMwBcEDVgXNgJbntX7N512Y2xng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712855059; c=relaxed/simple;
	bh=QElmSC3bxNhYYUYZcpYqZWOnauAT+nnkD1ECMHNRsa0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c+0BKcxqR/q7UvAvVcNtz0AAFtIEBSF0J09zf0WXOZq1nuI+xz5TItL3qWWa5aeiSjXZhJvx4QAky4nOcFS2fRRj3r4FRQbJBDtWOza8Haz75BDila1JhDotl1SAm/dTy1umZa3L1aNvaFuRjUqxetUJfWFyUW7PsColZGFiKFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XjuyDxQs; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so36984276.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712855057; x=1713459857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wcI+w0jxD+jVMQpaBlv4eiJI48tJxddyR3AVpCAV8/0=;
        b=XjuyDxQsySmT1aw1XMjeSVmD0QOsLb5/m620JgishPaNvmKOy0iYE6RMeEhK1kUuww
         joHO6iZFRrWYwMUBTjwwFRfoVZN0RZ7X+pu8UFuW/p4O2++lr/zyAKgFVkPdN12iGogn
         RDw5tlt+wLQU4Xp5e/02kckNPaPXs/WYYWyfW15ATB6if2FfZn59cKlzBAMffYsN/tw+
         4gvXDj0/5/B0jMNvSHBcODIllPwWMYa+jHKPPVQgfcshI3XT9izok3B+LigxOkGTVmqc
         Al89od5Rkb2bR8L3Qd0iN60VzAIR2WXNdlgMmiNketcYXZ4nX57eA9eJoRKKAGZ0Vrbb
         wYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712855057; x=1713459857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wcI+w0jxD+jVMQpaBlv4eiJI48tJxddyR3AVpCAV8/0=;
        b=a5ypJmTrpi7B+fmfXXab10KvpY5hQGbbtVDG6HsyvvpbKNUavHw5/twqz6Cc+T1sIg
         D/GqjG7/9EXHFS+Qzr58s8Bbli5OZTgoxPv9npbn11sX+QdmucoW3lIm/TaCfO0ip/s7
         Y9535rK6YNoocilF/4ZLCwZoixXH43zYow1Brg/tJlqYqXDxNRujb+CpHetZbVer78w+
         s8xb94dcEFnu1uFhAsQ/WMYo4HJ5rEYju11WWyZbzPyPM2k6eBK6i0DFecIdfcn9kBsC
         c//HCrqoMDg5UcAVVajF1JXI0xBn9N9HSyyHkrZjZ5D/GPMddGGVtUkLPylYnN8kUCvU
         HUwA==
X-Forwarded-Encrypted: i=1; AJvYcCXXGSbL61qL5yovEKLreZeHnIQuaTmsyTffSTIp0Pq4gf35wvySAP0pPzall+NDqEdJ1F6HH9O4Bk59bkh58r9UaF8X
X-Gm-Message-State: AOJu0YyLW9Y5C8EzGSaquMEbJd4KmSEP/s59PAJd+uRzB6GGQrfEjFEn
	iGKKmJ7tQItljkefCwbku/B9hgniWvdT0sA70oWnz3jTWhm66J4YNUmWgdjJbeG0q20bc+0nZYK
	arg==
X-Google-Smtp-Source: AGHT+IF+kQ/A1q51nGdz/1jgB0BZ4jm+Y8FVRBtTG7jOydoNQbvoOHP3rKC1bCcsOLvoRnXL34a7l/KFutg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100b:b0:dcd:875:4c40 with SMTP id
 w11-20020a056902100b00b00dcd08754c40mr23995ybt.10.1712855057304; Thu, 11 Apr
 2024 10:04:17 -0700 (PDT)
Date: Thu, 11 Apr 2024 10:04:15 -0700
In-Reply-To: <20240126085444.324918-2-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-2-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhgYD4B1szpbvlHq@google.com>
Subject: Re: [RFC PATCH 01/41] perf: x86/intel: Support PERF_PMU_CAP_VPMU_PASSTHROUGH
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Kan Liang <kan.liang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> Define and apply the PERF_PMU_CAP_VPMU_PASSTHROUGH flag for the version 4
> and later PMUs

Why?  I get that is an RFC, but it's not at all obvious to me why this needs to
take a dependency on v4+.

