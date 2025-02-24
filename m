Return-Path: <kvm+bounces-39023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5668A429A9
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A03A1888A95
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABAD266187;
	Mon, 24 Feb 2025 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MvWDRYjU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588CC263F31
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417959; cv=none; b=Uh+2lQntkmbvQCQ/sY8SpKbWOlh5UwtUlXU0ibZJTklBC6luE1whNNzFtgNftqNrXmQURoJcsYh7ppTe5I8q3BMJEl7hBXVav3661YjNabdBdrnpv6L1fBGI1Qy6GwAsC3dIpmQlBXNYki3+byLBV7qAc0gsbK29nLIwX6vciNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417959; c=relaxed/simple;
	bh=vWT1sTKT7GMDJ0/gjCofLki8D49lkkaMDvrbuPoKfB4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i16BzjTJtgF2KL5qfs/Lcs8t8gHmFKCTDdTaZh6w4uCL8HfZWxr02hGOiPPQ8RCF7oZSfApLgliP4260U8xoW81Cne1SScWaOaKIVuVzsHCIy9pRxIgzotZs6tdkpBtdXDHduiaVYfa0pdK03Bu5eYxKBGUM3lcyu+n4O/2iBQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MvWDRYjU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc3e239675so15210954a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417957; x=1741022757; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QozK1NVlJGJuvxzsbX+mUR7OElSXK56BE8xCGmmS820=;
        b=MvWDRYjUUqOL2jutZRxjIObTHr5ObQg6UU5ICeqm5PJSPP+gmldaRTXC69NXV/vdxi
         q7eMO7yNRkFueVa2JSwIqIb3CJWDk9F1Ed1jHKmz01VGyBkKUheJNw6NbpRrbTKmsrJ9
         N3mATkSn0qeqDFbwVQ+lZAYQqnPOZDvCDDtDLxexwUvJwDeh3tkC8YezV/sfSoYXnp0A
         6gnAU5HlBsCDcfNmeXZiLdrYMxy/mDrN9BV5ZJD1P7gOUyBTaYpoowno48szATAd5VhX
         uGP7dpRL+Zb3ABX9lMBzkGmthVXZkYOvtiAZDSSP/B8TLzKnOZx5WX4qLomj55zLKR2f
         1bNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417957; x=1741022757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QozK1NVlJGJuvxzsbX+mUR7OElSXK56BE8xCGmmS820=;
        b=ZEDSWs6xHYdiG2KE9c0fL8HeZK8cr9aA//OqE751gyMwRnmAVTqRiFlzzDtL+9FJ+R
         FAuxP0KZj1bR8QJYO12swoxjbZY/pP1ML2fC7wYTa9vUhlaO1ihgW+VikHedBecS/dtM
         tj6zN0v+xTw6rvr/wwrXwfAxmdiWHARIg9MzJiYjW3602iCZOdYU1JO89+fd/RjzRO/x
         bXCSz2s8aolqVukyyx2I9SQHOX7w/PuJKTmQfGKWAxsVIcMEYXUU3s1D2BqiOouIOojA
         G7ckR9h4LeFOo4il20pA3qRW8P0IswLyQEubqggumlAnerYgy0AyG4i8ahy1eiaToBW2
         zCgg==
X-Gm-Message-State: AOJu0YyaqZR+Z0VdmgHlbn6qSr/+M5+QzvWaSH7OAAmcnQE29edeIxDs
	XHJtviQpuNPO48ChkTXhoD0a2PC/DdDU1eS8dbZxohPWK0W48fTj6aLRH7np/L+I395yVKhJ+sf
	LXA==
X-Google-Smtp-Source: AGHT+IE4JKBFU0+JKvaYQs0IQwxRRHaLd2pedx2OD5g9+e9eATiYjBLAV5aavn4+U48YiFDNcN2VODUq7I4=
X-Received: from pjbqo14.prod.google.com ([2002:a17:90b:3dce:b0:2fa:a101:755])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5148:b0:2fa:17dd:6afa
 with SMTP id 98e67ed59e1d1-2fce86cdeddmr26513573a91.17.1740417957682; Mon, 24
 Feb 2025 09:25:57 -0800 (PST)
Date: Mon, 24 Feb 2025 09:24:07 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041748776.2351385.1912530534501091995.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 00/18] x86/pmu: Fixes and improvements
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Feb 2025 17:36:17 -0800, Sean Christopherson wrote:
> v7 of Dapeng's PMU fixes/cleanups series.  FWIW, I haven't gone through the
> changes all that carefully, I mostly focused on the high level "what" and the
> style.
> 
> This blows up without the per-CPU fixes:
> https://lore.kernel.org/all/20250215012032.1206409-1-seanjc@google.com
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[01/18] x86: pmu: Remove duplicate code in pmu_init()
        https://github.com/kvm-x86/kvm-unit-tests/commit/8d1acfe47c0c
[02/18] x86: pmu: Remove blank line and redundant space
        https://github.com/kvm-x86/kvm-unit-tests/commit/59d0ff80700d
[03/18] x86: pmu: Refine fixed_events[] names
        https://github.com/kvm-x86/kvm-unit-tests/commit/5d6a3a547c3c
[04/18] x86: pmu: Align fields in pmu_counter_t to better pack the struct
        https://github.com/kvm-x86/kvm-unit-tests/commit/9720e46c0a7a
[05/18] x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
        https://github.com/kvm-x86/kvm-unit-tests/commit/f21c809e50b1
[06/18] x86: pmu: Print measured event count if test fails
        https://github.com/kvm-x86/kvm-unit-tests/commit/d24d33813f10
[07/18] x86: pmu: Fix potential out of bound access for fixed events
        https://github.com/kvm-x86/kvm-unit-tests/commit/9c07c92b2d89
[08/18] x86: pmu: Fix cycles event validation failure
        https://github.com/kvm-x86/kvm-unit-tests/commit/f2a56148889b
[09/18] x86: pmu: Use macro to replace hard-coded branches event index
        https://github.com/kvm-x86/kvm-unit-tests/commit/f4e97f59869b
[10/18] x86: pmu: Use macro to replace hard-coded ref-cycles event index
        https://github.com/kvm-x86/kvm-unit-tests/commit/25cc1ea7a8fd
[11/18] x86: pmu: Use macro to replace hard-coded instructions event index
        https://github.com/kvm-x86/kvm-unit-tests/commit/85c755786de4
[12/18] x86: pmu: Enable and disable PMCs in loop() asm blob
        https://github.com/kvm-x86/kvm-unit-tests/commit/50f8e27e95e5
[13/18] x86: pmu: Improve instruction and branches events verification
        https://github.com/kvm-x86/kvm-unit-tests/commit/89126fa47d19
[14/18] x86: pmu: Improve LLC misses event verification
        https://github.com/kvm-x86/kvm-unit-tests/commit/38b5b42631c2
[15/18] x86: pmu: Adjust lower boundary of llc-misses event to 0 for legacy CPUs
        https://github.com/kvm-x86/kvm-unit-tests/commit/e0d0022fbd4c
[16/18] x86: pmu: Add IBPB indirect jump asm blob
        https://github.com/kvm-x86/kvm-unit-tests/commit/8dbfe326bec8
[17/18] x86: pmu: Adjust lower boundary of branch-misses event
        https://github.com/kvm-x86/kvm-unit-tests/commit/28437cdbec8b
[18/18] x86: pmu: Optimize emulated instruction validation
        https://github.com/kvm-x86/kvm-unit-tests/commit/5dcbe0dd0c33

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

