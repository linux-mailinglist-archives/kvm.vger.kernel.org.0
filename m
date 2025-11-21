Return-Path: <kvm+bounces-64200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C2C6C7B42D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A95BB34F09B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93AC82F25F7;
	Fri, 21 Nov 2025 18:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EF6l9RHe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5906F4204E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748763; cv=none; b=gcT5ynBoQaj7X0UCdhC+//xC5DyoVFJYbTRiWc63RRWdKp32hfoi+oJV8fjzaqiAdzANHLOdOGK47y1Yqdpc1JN5/Vg02krZ+lp6EMFxWSFYEPQK/qvbGOE9o4kS2Jt+tzmORuOWIls2ZAC0KD3zXfZfrmhmPjEdynKw9+ZCV5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748763; c=relaxed/simple;
	bh=jg+JsrEFRjeHYhh3zZCiCjoA5o+GLFbMmlKrBrQn/ms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TB2fXK22ysA2L64mQiJo2ayz7aB7Tdj/cRQRZYxN1p5BXyzkyNXhxtPkifKX5DDHGc9zP00szClbqgVmh40UqWhR8IznXXahM3X6Kq0eZWSs5uTt76oYPzCN5BZQjWxTtXD2IlgAlZS7ivRykA7vtjGoWSeiqYwNLe97PeO/tKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EF6l9RHe; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3416dc5752aso6618104a91.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748761; x=1764353561; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4r4WJd2OVzlwEapD46M6vHlbLZCHlF49gWRbSAjvOME=;
        b=EF6l9RHeiEM1ruGvHQNlHObVDmo1ZtgMKKsJKQVtv4S5m0r+wY5ISfWFGK3Kf0c2dN
         7EzlnLam9xCBjQMlYz3xWFgcU2qE6Hs64v2bn92lbOpQ452VYf9WBAe1eXyFsdZYZbUS
         9oXxXQnMyMCFSiy+ErWZuNN8gOodj1ZstBr+XXU78/04gvFJasuG6OVP1vTLPNSKKjML
         cLqG068OqxOTBhqIvENPoQnATNm7weqiaE6Sdpx3l8sg660pdUtHsN7FAxAcyLFVQG4r
         Y7vN4ERV4vUerescuz/9WsI5BT6g9Gb+GiVtMgZFmXiEWpXD3WIHI8oeBSwDEYlCs5MW
         GgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748761; x=1764353561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4r4WJd2OVzlwEapD46M6vHlbLZCHlF49gWRbSAjvOME=;
        b=p5ev/uWCDzlzSLvVFB/lTdnZPMl50hOFt8lFQDrbWYeG4neWmFty8ZaRM4Stg0jZZ7
         liSAO5wJEAHhul+XuuJdxXy+Av3Mnyznjb6HZ3PXQonZQ54R3ff75A4n8Pv3mNnK7WfF
         PVg7npyVmvWIsqUVf1Nd+cdxCWqbm0n/QtlvwEbZLfc8Toj1Zecp1o+FIXIWv1nItNJR
         HUO4FZcm4PV8ZKUv3XSYOInQYALTfRW0SPL72dHf3uiitnG5t+R73jKtahXZEX4npc2U
         XFzH/ADwiVD5wYUH81lj0yTtNTQYN5on41o9YbB+BNrOWolKx8NY7X2uScuhXh8VlHgE
         qmVg==
X-Gm-Message-State: AOJu0Yyg6w9pHJaiZMNhPn9Dr4vzZHgnUI9su5vk/4Pt0TiwKX0MOqzu
	B9OOXUkQJlNBA5P+jNcufeYYgNJoTmrb1mrkEukRsYgR8uMiwcUUvpMZgM6ke0z/41swAGH7r4O
	z67OWGw==
X-Google-Smtp-Source: AGHT+IE3G5N6ShxRjZAtBLTiyQ27bOEC77y8TUaVidg0GHVLLY3we0AuM1unUZqNHoKGDkho5K5bFO9Jirc=
X-Received: from pjtz18.prod.google.com ([2002:a17:90a:cb12:b0:343:387b:f2fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f4b:b0:33f:ebc2:645
 with SMTP id 98e67ed59e1d1-34733f2a471mr4009857a91.20.1763748761649; Fri, 21
 Nov 2025 10:12:41 -0800 (PST)
Date: Fri, 21 Nov 2025 10:12:38 -0800
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120233149.143657-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176374874648.273777.10899439469937167588.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 0/8] x86/pmu: Fix test errors on GNR/SRF/CWF
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 20 Nov 2025 15:31:41 -0800, Sean Christopherson wrote:
> Refreshed version of Dapeng's series to address minor flaws in v3.
> 
> This patchset fixes the pmu test errors on Granite Rapids (GNR), Sierra
> Forest (SRF) and Clearwater Forest (CWF).
> 
> GNR and SRF start to support the timed PEBS. Timed PEBS adds a new
> "retired latency" field in basic info group to show the timing info and
> the PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
> to indicated whether timed PEBS is supported. KVM module doesn't need to
> do any specific change to support timed PEBS except a perf change adding
> PERF_CAP_PEBS_TIMING_INFO flag into PERF_CAP_PEBS_MASK[1]. The patch 7/7
> supports timed PEBS validation in pmu_pebs test.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/8] x86/pmu: Add helper to detect Intel overcount issues
      https://github.com/kvm-x86/kvm-unit-tests/commit/de6d1319b8aa
[2/8] x86/pmu: Relax precise count validation for Intel overcounted platforms
      https://github.com/kvm-x86/kvm-unit-tests/commit/89e3f25e00ea
[3/8] x86/pmu: Fix incorrect masking of fixed counters
      https://github.com/kvm-x86/kvm-unit-tests/commit/803637b5280d
[4/8] x86/pmu: Handle instruction overcount issue in overflow test
      https://github.com/kvm-x86/kvm-unit-tests/commit/1b09357a2737
[5/8] x86/pmu: Relax precise count check for emulated instructions tests
      https://github.com/kvm-x86/kvm-unit-tests/commit/e8ad559c361d
[6/8] x86/pmu: Expand "llc references" upper limit for broader compatibility
      https://github.com/kvm-x86/kvm-unit-tests/commit/941fcfe6e46f
[7/8] x86: pmu_pebs: Remove abundant data_cfg_match calculation
      https://github.com/kvm-x86/kvm-unit-tests/commit/de8cd74ebbaf
[8/8] x86: pmu_pebs: Support to validate timed PEBS record on GNR/SRF
      https://github.com/kvm-x86/kvm-unit-tests/commit/f561b31d3dee

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

