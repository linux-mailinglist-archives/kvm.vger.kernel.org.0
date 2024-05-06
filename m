Return-Path: <kvm+bounces-16650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF868BC6F2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:35:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68390280E34
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C1B14389D;
	Mon,  6 May 2024 05:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SKyaCDgP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D927D06E
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973503; cv=none; b=o6mfrPLY30tZ7o17P0wkRZfyQsHA5JVQtUWUIKeTDfuPiAEUtzR2P+3B+4L9pnrywXXm5fYNzR2flx2UhCpRZhU7Awwwm46bDmvKAFvX+WS41FbWXE6+OXzLqGEuJjcekhy+vf1nZ14lFIquwWyj1ZFV+XyR7sTnfHZMgwU2U+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973503; c=relaxed/simple;
	bh=DZSWdRseL57JFKlw31VsawawKE+k1mERzVTXnFwL8t8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oqW3UvjJtQqgkfoG6w+0SY+yqN5WIQ6fDYP2sEAGY8mmZ1/eXYj2bIkexsp9QQkg6U/CPhfGeqqie3TBVeElTs9lR2p4WojtEKr/q/9P4T7zKTJSMs06Cl7suck9AtBzot0z4R94dNlN1bbAIsETpNnXJnvZLxIxSXwdGG/0Phk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SKyaCDgP; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61e0949fc17so31927587b3.0
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973499; x=1715578299; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+tZnFPelKgQ9+tzFE8Krjkx+y5cOXsHDjgrtYLK1tdU=;
        b=SKyaCDgPs0SqsQvtFpKVxVIpRWGasksJcKtMFQfI39e8WrT2pV4N+RJv4BmsyS1xQf
         z5+GQqSNIpCY9s2YmFNsO38pNRWY76WwBlTZTn9J7XksF85+M8kM2a4SuP5dQZqpeZuk
         ZOIgiqxiGhX6cOFJalTiuPIh25i6rT8gU3XoiIt5DFF0gHUymACINF7RMga5eyyRwVOn
         FH2ub62doRtadLWWyBKD4lvXlhT6IXzuxmDNgmI+09F8Pun6nMsYN18YdGwYNLAy8S1u
         DhOgDWq8V4qBrYdqrCpyCK2Gyo8tzcKkmpx2r0cO0uiln1hQx/tfAneeUwbpL+b50Rn/
         4bpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973499; x=1715578299;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+tZnFPelKgQ9+tzFE8Krjkx+y5cOXsHDjgrtYLK1tdU=;
        b=FBWkNVpfh4iIhOiaZbJPoFPxO8lcyk3Y0ZZoJ31O7L9Q+KAeVuQnMk69LcQmc2fkn+
         rVERRfrc7UI42i4oKRYvsvLyUDsH5gL8D22ZNPnyJFBEz1E9vKvvxcal9b24qkBx3mx1
         kFOYPXKkyGlCer8S8lt69RTFZ2IBGS67tKiak0UcPErFIETX5zGnXtB89FIwpMrzMU2t
         6G8E7oo3dCj8o/hg2Kun2RAa9qnwWr1Jc5ma4XTBwKkwf+H07UQ9fPfMxBWM9cZgKcZW
         O1iy8uvvwFc1am+tvdOaW1EBHjofQ2P/i44/NqVWKxnwTtWxFpKWxBJqsMZ4IxpeIwuM
         w/Fw==
X-Forwarded-Encrypted: i=1; AJvYcCXrVLLuO6YWjpxsZpGt5wv6IcLabX1jjOl1cvZ5b3MhR/MTigOU4ox9Hzg++CR2/bT8ZaOdVGZQJShCQ1XvMcAvKphH
X-Gm-Message-State: AOJu0YzhXfgv4KBsUXvKrTzs0gTTxakXhVzWw9b/VJ7Pe9LDzRrPNy10
	PxkMdsxQ0uu8ypxSIPfBZpzr5EdQcy3a0X52/MSlPb7KTJtOPaZyir4yYNTfhwMkxY8XV+v1zTY
	pSh7eBQ==
X-Google-Smtp-Source: AGHT+IFxvZEFzZ0XjsZJVKcgg1TsSUA3w/oGHhz5UHk6n/ARs05crQP25w+vO++u4YwKRI3SvMzeI9D4Wg9Y
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a0d:d857:0:b0:61b:e524:f91a with SMTP id
 a84-20020a0dd857000000b0061be524f91amr2194694ywe.10.1714973499542; Sun, 05
 May 2024 22:31:39 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:03 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-39-mizhang@google.com>
Subject: [PATCH v2 38/54] KVM: x86/pmu: Call perf_guest_enter() at PMU context switch
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

perf subsystem should stop and restart all the perf events at the host
level when entering and leaving passthrough PMU respectively. So invoke
the perf API at PMU context switch functions.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/events/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index f5a043410614..6fe467bca809 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -705,6 +705,8 @@ void x86_perf_guest_enter(u32 guest_lvtpc)
 {
 	lockdep_assert_irqs_disabled();
 
+	perf_guest_enter();
+
 	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
 			       (guest_lvtpc & APIC_LVT_MASKED));
 }
@@ -715,6 +717,8 @@ void x86_perf_guest_exit(void)
 	lockdep_assert_irqs_disabled();
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
+	perf_guest_exit();
 }
 EXPORT_SYMBOL_GPL(x86_perf_guest_exit);
 
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


