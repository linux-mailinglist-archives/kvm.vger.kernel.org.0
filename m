Return-Path: <kvm+bounces-53709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3444BB1569F
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 02:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AC65548448
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E07167DB7;
	Wed, 30 Jul 2025 00:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rIEJPSRb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63293801
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753835884; cv=none; b=hueQRuOuMgZMZkkILorbP8cpTOTpEOfm/aorJ7GQupvNH8W8dJyZ6tpb7YcpXbXcJt1HEk1vjAG6+Bzl8d5W2tedKXGjcxa63url3WsrVjm58AMZx7sYNcd0R9GbGy1fY0+24gNVk5LR3wPxCUhgnQi/jFqiFKiG23aye4PihCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753835884; c=relaxed/simple;
	bh=PoyA0CcW92FoQ3I73ytTZfPzdZaHEfO3pw0xz04Rz34=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uEyGKMntZcmDomPZbflreTuG/zeTKXo1kT3At1yIAiZL922l87xPi5bzDdQzK84u2UbuCdpCIU73mxtku7JnQ96q043eVNohEeAW3np++b3odzPtvj/pHon4WNgiBmOn7FJIw7Zzj+d5uVde3lUlxP/+lk7gGOT2mCYuKhrR3vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rIEJPSRb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so6792816a91.2
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 17:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753835882; x=1754440682; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PoyA0CcW92FoQ3I73ytTZfPzdZaHEfO3pw0xz04Rz34=;
        b=rIEJPSRbkLYzZS9u/HY3e65h9N6nYCZaG1rUZS/qgF7rVW3eyAqf7gWkXj7Oje4ozb
         CWC/tXNqXlYCRxQKb+guEfRsvpFrC3VcvsbGVn3h7tC6xx9OI4HKECvKb/wYYJCbhfLJ
         CYNmIS1jYtRfYNjGe/a+duv3Y1ci+Waez/O3pSex56H+j24dmZB4F0s4KrBLJLOdUIRE
         yYMqdbmBCB7hgeNF9oa+nuSW5KkXuPjhdIwAHCjK8DhIh8u2je/QDsIYy14ylYsy8c/7
         VnQnlAosuvuqpugjo9be5rZhhMGeJk3vXFQJVleHSsrO6/MRlMJH8CWbQvAo4hk/wyHV
         vwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753835882; x=1754440682;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PoyA0CcW92FoQ3I73ytTZfPzdZaHEfO3pw0xz04Rz34=;
        b=s6yP3ly3JeRbFdY4+22fybRwMy6y5ry+sGAR4IJoLEyQ4xEY54OZADFG3bs1liwBI5
         dfr82avbLTeV2YmOcZB3t/Gm1cmFc74KwJ6FExn+VuatVGOT+viIKUBikIKoJfKQP5cs
         9OWMXMC/xOzy7wvyYPkw+J3597YwwuQx8C1VScD3OeWyM2bNm7S+VGpAGKFEUN4RwUDU
         /0uRqOT4oHQdIK953thiOacSaBmXyHQPoYkAUSWgGMHa2qSMyaCBQ41eH2wKgmehlF4S
         YxFXWtZn4kx12B3tjqhMqjFxjSpcYJs9+d1PrBloYPcBMqkEjeg4ODmiq2q36UThyQsb
         lUMA==
X-Forwarded-Encrypted: i=1; AJvYcCXLl5ti2VX7ryH+QmLcry7CaxywlJD5JO9wRAGp88MkyPif4bzwWBwZyVbY+aQwXZ00J8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiHVyn2yc8GkZrjGnQylA9hApd5NSlLFilfZwmDS1GH87D+rtW
	1yKWF0X522yogdOkda2WiDufi2ajIMieXeEZ2rv763sCAX1p0jjqjVq7ZZmpaZisH7zdfMrZxJ2
	5R3OBKQ==
X-Google-Smtp-Source: AGHT+IFmEOk3LVUVJNWYxzRPuTmK+e+GHYpOt6lQopxXicjjLZ69T+VUxxaSfay3rEISbglMLxNY+x5v644=
X-Received: from pjbcz8.prod.google.com ([2002:a17:90a:d448:b0:31f:d4f:b20d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384e:b0:31f:2bd7:a4d2
 with SMTP id 98e67ed59e1d1-31f5de69998mr1735098a91.35.1753835882538; Tue, 29
 Jul 2025 17:38:02 -0700 (PDT)
Date: Tue, 29 Jul 2025 17:38:00 -0700
In-Reply-To: <7dc97db7-5eea-4b65-aed3-4fc2846e13a6@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-21-mizhang@google.com>
 <a700ab4c-0e8d-499d-be71-f24c4a6439cf@amd.com> <aG6QeTXrd7Can8PK@google.com> <7dc97db7-5eea-4b65-aed3-4fc2846e13a6@linux.intel.com>
Message-ID: <aIlpaL-yEU_0kgrD@google.com>
Subject: Re: [PATCH v4 20/38] KVM: x86/pmu: Check if mediated vPMU can
 intercept rdpmc
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sandipan Das <sandipan.das@amd.com>, Mingwei Zhang <mizhang@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yongwei Ma <yongwei.ma@intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Zide Chen <zide.chen@intel.com>, 
	Eranian Stephane <eranian@google.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 29, 2025, Dapeng Mi wrote:
> BTW, Sean, may I know your plan about the mediated vPMU v5 patch set? Thanks.

I'll get it out this week (hopefully tomorrow).

