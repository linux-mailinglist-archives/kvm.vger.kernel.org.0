Return-Path: <kvm+bounces-16624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 832218BC6D5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEE6C1F21E10
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0001411DF;
	Mon,  6 May 2024 05:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tsV731uT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1305C140E4D
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973451; cv=none; b=F/K4sGTvrICKuYjY2rOY2DUTPfBI2qKpUHELJWE3rjfUDTES/KZ2AcXSd62GL7Ac+AOkvRAhqcoQ2leHI5o7SVe1rekx3LyO4lYGyU2ElyZ6L7QqGztnckzo1tBbeFwiQyK4j+KeGoJjvVNggN/nxsmk6YLZxe5x1+3SS1XlqVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973451; c=relaxed/simple;
	bh=OKVnKqjqLes500+TVVKHCbNHVn805ASKjv1fJgD46/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jCL4Xd6Hje5QLa2Kh8o4N7BnLxwXnd38IXptQ+EkcLqhlxFBUZuuw2by4zQhLc9+o4c+2NIybeVu/DSA0bAuoyW72lz6gbe1tif2Gn+WvF21bIi5yxiId/wSgOU9zSSGmp0HixH3cNO+DTSSBfjS6/5IBFP7owT6yVNH8XGFg2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tsV731uT; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f446a1ec59so1735902b3a.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973449; x=1715578249; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=L3LCM1OsaYiIlnrBibBFz2xG/zfA/cshhJRla+qWYkk=;
        b=tsV731uTrqRxA7Vjs5I1TYT8urvii6Hg7Nifcybq6LSKV7rZGjSha8t3VIFlSNYWyd
         4xh/Wlf2OmbYe9PCDkP2wdHkWleaaGCQYXAOCqArbSGp0qAG731P7h9JaBm2na+wJAJE
         YKEoe3cR0Gr0dvvBUSNaY9SYulp7Z+njSsLZgfLY3fy1JeGSwTRnOuXrKd8hw25F0GCr
         gB8ybAdI0yxkeHgFT/ZbIBTacNgcsg3VpyiQPDfl5G+VrTAj0kH9vCjTvvTEbF1K1XHX
         8Za9UkezTfYTa/DphTEDX3sGsUCVn+VkWhZEtOajKRxdhqjCW1HzHDNco6bv/MywhNJ7
         QSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973449; x=1715578249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L3LCM1OsaYiIlnrBibBFz2xG/zfA/cshhJRla+qWYkk=;
        b=OuP1SyS9Bwv5pJ3GzF3bJJGh686S9rKQhkroLNVM4jRZBu3mlz7wed4YnYaPS4vl1v
         EUC68u3AcbvNz2ntFdLAt0Yo6i7T3mrb3QImLky6jzwArVjYB/z4D4yJGcZA39El4YcJ
         OOqi+UGAsOhgpzXUHXY/7pzklgkCgotnOwACCpUPvQITZDgt6doSGJdnBnmM79fXZzlm
         EzJiINBsk2+Idy0I0Wuig2A0RU4C6Xxz6LvduTEfkua48BDpEktAjcsa7ofBkox+yWEn
         EzHvBpxxO1iqfpTDaVb50TFKMQafQdE4qgJIne9Uc5PcQ0SUZbrJ8YrePqoOhKdIAHjI
         h5Lw==
X-Forwarded-Encrypted: i=1; AJvYcCV8pKUEHabBJiHHUYcBtov1HCLnfzpXjQW2OmqaL9QdJs4NSmynvLCQ2Sd42/vqk8wvcbZ0oK5jG3dTA24S8AdYd/71
X-Gm-Message-State: AOJu0YyiNv1v/uy952CXHz+Ao9NEZK3GrkGcWBQjZhaFmGjKxIpvdi0q
	uLL+liR+hW5st24zcob1lCuLVKZxCNZumO5o1Wb8ltgfObRxxFVDuOj/AEFTi01JviF1563IcTh
	IaQc+sw==
X-Google-Smtp-Source: AGHT+IEoDoKL6bIcsKXu5g80INJRprO1/lLAhr+CEcEGoJrqGc2N33Bj0ShzzTtaYaOJs/MTq2tsW/TfUFFh
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:39a1:b0:6ec:ceb4:d9e2 with SMTP id
 fi33-20020a056a0039a100b006ecceb4d9e2mr239424pfb.0.1714973449476; Sun, 05 May
 2024 22:30:49 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:37 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-13-mizhang@google.com>
Subject: [PATCH v2 12/54] perf: x86: Add x86 function to switch PMI handler
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

Add x86 specific function to switch PMI handler since passthrough PMU and host
PMU use different interrupt vectors.

x86_perf_guest_enter() switch PMU vector from NMI to KVM_GUEST_PMI_VECTOR,
and guest LVTPC_MASK value should be reflected onto HW to indicate whether
guest has cleared LVTPC_MASK or not, so guest lvt_pc is passed as parameter.

x86_perf_guest_exit() switch PMU vector from KVM_GUEST_PMI_VECTOR to NMI.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/events/core.c            | 17 +++++++++++++++++
 arch/x86/include/asm/perf_event.h |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 09050641ce5d..8167f2230d3a 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -701,6 +701,23 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
 }
 EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
+void x86_perf_guest_enter(u32 guest_lvtpc)
+{
+	lockdep_assert_irqs_disabled();
+
+	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
+			       (guest_lvtpc & APIC_LVT_MASKED));
+}
+EXPORT_SYMBOL_GPL(x86_perf_guest_enter);
+
+void x86_perf_guest_exit(void)
+{
+	lockdep_assert_irqs_disabled();
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+}
+EXPORT_SYMBOL_GPL(x86_perf_guest_exit);
+
 /*
  * There may be PMI landing after enabled=0. The PMI hitting could be before or
  * after disable_all.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 3736b8a46c04..807ea9c98567 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -577,6 +577,9 @@ static inline void perf_events_lapic_init(void)	{ }
 static inline void perf_check_microcode(void) { }
 #endif
 
+void x86_perf_guest_enter(u32 guest_lvtpc);
+void x86_perf_guest_exit(void);
+
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 extern void x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


