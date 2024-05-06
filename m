Return-Path: <kvm+bounces-16656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDCF8BC6F8
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2B371F22F68
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865471442FB;
	Mon,  6 May 2024 05:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nbueZW1u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B304481D3
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973512; cv=none; b=gmgIciQNILGk/xqS+Un7HU66DVm0gsevPSLItOg57xNU6M7eIGcYQkUZJqimDPabJ88w4AbmufLocXO51sYYZo+G6w8R2hFnPypYBSlffVp92f4WVyLv+UiZCQQpehqI+1aPsuPwGc9QNAos3Z5hdfQvPtyMSzLDYuh/T9IfD6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973512; c=relaxed/simple;
	bh=g+qRBm4FYXKbi1z3LsBpGHrQcVVUFPXvFNmS1/Rnm6k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eYpddTWDfyP3LybPSfkT14Y+G1VmFDLcWGmT1W6p/04nYT4XgEM4U9cArrodcyOCTZl/12QPBfkatywmXAB939vRy4lSuW0ouZ6T5wv4q32pryL+XRckQ0Qakt7xx4GY2k+KKyPV5L29fi11/H7pEM3P5zBQcrmtN5tD0G8n9pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nbueZW1u; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de5a8638579so3251891276.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973510; x=1715578310; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ivmlmawdSbgW6MKum2TNcXAxoesaHajuZ3ujM7TcbKA=;
        b=nbueZW1uRX7y2vkLxxyMq6yi0yINcScO+N6iGUM2GC2I7qccRO7tXr5Kvt6MtVlylX
         dypF8AO7pY27WuGkHcpbZ/6spbzt7aXlvYIcFk1spOS17aJHZQkTc49uYWUADHKDKOUi
         UDhdnX2Jew+6EWchboIB916z3jldG0a+F9nCWB/iNIYFkJldyoCei4TYj403l4wqyILY
         guD0ekh95IlmVwmCgkVrtFFfqv0mxZo5TbzkGCpjhBL1i2dgTLmcSq8vmHUobZTAk34f
         BnuJHkP+Vi5dSZQwEXZ45svGC9IWrJIwS5pbehXv14H/1fSG2O2rf9dtLFD2zuTDClQJ
         8ctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973510; x=1715578310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ivmlmawdSbgW6MKum2TNcXAxoesaHajuZ3ujM7TcbKA=;
        b=cQR6Twu2EkGgy2DTbSlARtK/ge9Rnr3zQXRXZGs4ISlRjL+Bp8Q+32mXVaMgM1nVIE
         Vae4iM0efQs3V8Ohjck5Rl7nJUyk78gQwCURgyOWPj7OQXl9OUX+scHupnO0lEiAR8om
         aj8XxbOaEh5QPu2QHMv+rOy6fn27kXv0w6jyX/IfairaEeEtQmnHcZV4PrtG+sII4deb
         E1X+EnZFx5ECq311yc3jF8UVDxyUHqrOGsg/CVdVtIud4E3OWDxSfaPFzF3KEjHTzibS
         hBHnU2JK5WXkaHwPIkuhbLYNrnfQAWu9L1e3B/m3aL4vTIrN+s7RAxVXtOH2M40vwPm1
         ZpMg==
X-Forwarded-Encrypted: i=1; AJvYcCW24p/xmvNxeOYIr44w8/+g3HSdVGX5aEWFkfZbHlMnvE6ZMRPPL3cR9sj+MHs/zufs5MEpq4M2KMPMix5x47EY1GEr
X-Gm-Message-State: AOJu0Yx5kQhn0iT+JcMygh6qwi0zHqmXDGc9oyp5f2wgBcyr3qHkTYbs
	Xiqk3H9uRqVNKlRZB9QZs2BKdKCD4RtDyN88Rjy5KMEZLYxec6h/++Ro0tGdUfQQzY/9BhQIJcw
	hfAKodA==
X-Google-Smtp-Source: AGHT+IF9FGD5AfD9WMMiOcqjGF/60VXPiIhml76B2IdP85AsIqgyCBUPKR19NlTjttgDApGk3EOeJK+t83sH
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a25:d3cb:0:b0:dd1:38ec:905d with SMTP id
 e194-20020a25d3cb000000b00dd138ec905dmr915057ybf.11.1714973510580; Sun, 05
 May 2024 22:31:50 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:09 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-45-mizhang@google.com>
Subject: [PATCH v2 44/54] KVM: x86/pmu: Disconnect counter reprogram logic
 from passthrough PMU
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

Disconnect counter reprogram logic because passthrough PMU never use host
PMU nor does it use perf API to do anything. Instead, when passthrough PMU
is enabled, touching anywhere around counter reprogram part should be an
error.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 5 +++++
 arch/x86/kvm/pmu.h | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 12330d3f92f4..da8b27f2b71d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -478,6 +478,11 @@ static int reprogram_counter(struct kvm_pmc *pmc)
 	bool emulate_overflow;
 	u8 fixed_ctr_ctrl;
 
+	if (pmu->passthrough) {
+		pr_warn_once("Passthrough PMU never reprogram counter\n");
+		return 0;
+	}
+
 	emulate_overflow = pmc_pause_counter(pmc);
 
 	if (!pmc_event_is_allowed(pmc))
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7e006cb61296..10553bc1ae1d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -256,6 +256,10 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 
 static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
 {
+	/* Passthrough PMU never reprogram counters via KVM_REQ_PMU. */
+	if (pmc_to_pmu(pmc)->passthrough)
+		return;
+
 	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
@@ -264,6 +268,10 @@ static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 {
 	int bit;
 
+	/* Passthrough PMU never reprogram counters via KVM_REQ_PMU. */
+	if (pmu->passthrough)
+		return;
+
 	if (!diff)
 		return;
 
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


