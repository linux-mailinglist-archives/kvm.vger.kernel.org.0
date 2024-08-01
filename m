Return-Path: <kvm+bounces-22874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A2779944277
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CBA6B22E98
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25631487E2;
	Thu,  1 Aug 2024 05:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IEU5Yr2j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD17A14F9CA
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488429; cv=none; b=eZ/ACL9KvHe0GUpCBArC764TJAFY5L4BOsFuFQ4QJQeXalBwskfyXrBJ2OupSoO+vn4lBl5gOYcWVqK3TpVbkazPIxTRY3CZYNbq8vgRgA19L+ZDtdmZEvXMBRfAq0bWPQUIUFqJIxV0kFl1BD7W5z0yE6menhS4mn0lXHZh9nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488429; c=relaxed/simple;
	bh=Er1+rIamv8zqHCWIvU5+MdGxE5F17D0FaBd+GU9PuDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rXXu+nNRpujgschWnnDW392at7A36VjBJT40FvLFR5JOjMfefpmdZgrDaloRhCFYhcP1OGlI1pG8BldPwnEmu01JeWFOaNiMM/zVW2jQ2rBgxbVmA8wZL7qFLss/gfoQlR36Fr+u6p8/jNfN8AGIcHINlkzIuJmjJvXNgkeV6fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IEU5Yr2j; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70e923f6632so6085660b3a.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488427; x=1723093227; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hMe5GjAdDPvJgfCRTahsDqHRizME6fQZtVPI9cUADrw=;
        b=IEU5Yr2jCPuIOkgiag8TcQHtv5b0Ez6XvgYD2I0WwhQSXpqxrosbuAQ+tEldavrwSU
         PHRiaCZUuR+90fGoZTwze8Iapm5+tBaBnxaP9vkpEy4YCuvtuFnbRBlu28Uncr5PzvzV
         iox9flORua6pFGvV380kdNJ6dAp+tMPgHokpmfuotN80uu0ZPlQ+XTYahwJhBgpO5jzQ
         Fmp8P7xiXpcifjN/19pAydtW6uqU0BvF8XCcAvAN3D6tplZ0EpcR/BP9IFSaUg/5dsh4
         tdxAJQH7pi9DU4Ln0Be8UL7zqlA+91Ot0qQV4ZGgSpIq5yI14ZYTJJlw3U/UPwXI+L0f
         4vTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488427; x=1723093227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMe5GjAdDPvJgfCRTahsDqHRizME6fQZtVPI9cUADrw=;
        b=DZ0Mt5n1xcHiZvyPE2SMHxrDlqn5hzH9gE9Bj+KCmARMZ/0uqbS1QKZsN39NDi+mE6
         2I3pMVHBYtv/ivNZFJfh7YwOAJI6XFkIwo30rOlJOxCtbm86VvqlJccoxcPFtghmSa2W
         +4KrLstrE8mqwFk0hMwEnrrhhkw+oRVLRvGESsMa4X5hm0QlYCo6NgcHb0IrTDOjjbY0
         R2c5xn1IZkeZQRncu+liP5ZJ2RZrk0/dP0GjHTm+34LAN31X3F+4/tZqTyWA3JHd+zya
         wa+tsxNiMJwe/8XdCJlozWASF053gJBRnQPx9hhSHplyM56c80Dpx1RQ25lE10W/uWB6
         YJMw==
X-Forwarded-Encrypted: i=1; AJvYcCU+VvmvlBCUIjnc8b1q3CDhX3O1SiB3ltaQmlniGMINEOVIT75B6CFMCDtJh96ZxzUMnFtgBVx9Ru1MozUAy4goTr6Z
X-Gm-Message-State: AOJu0Yw+K9CD8+kG0m2JE6Mb9LXtRLDM7uYnnU/UgJimeKk9pJOwN5FP
	GYYvk7n3i8pZl1+44z2koQdSXiEk8eiVhC8KIg6lVyPTQoYPiveAvXHlAP8lBxbQqigUppct4VS
	mcJtavg==
X-Google-Smtp-Source: AGHT+IGQLdd9VIQeVQT4wYUeYXOg0Hx4N4Em1cpDz2c5QtwlNnmaxxHjY9+MSpq0udu3T1+5Rmfp56K1We6y
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:73b4:b0:710:4d94:f9aa with SMTP id
 d2e1a72fcca58-7105d83cbd1mr37503b3a.6.1722488427018; Wed, 31 Jul 2024
 22:00:27 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:50 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-42-mizhang@google.com>
Subject: [RFC PATCH v3 41/58] KVM: x86/pmu: Add support for PMU context switch
 at VM-exit/enter
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

Add correct PMU context switch at VM_entry/exit boundary.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd6d2c334d90..70274c0da017 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11050,6 +11050,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		kvm_pmu_restore_pmu_context(vcpu);
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {
@@ -11078,6 +11081,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		++vcpu->stat.exits;
 	}
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		kvm_pmu_save_pmu_context(vcpu);
+
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
-- 
2.46.0.rc1.232.g9752f9e123-goog


