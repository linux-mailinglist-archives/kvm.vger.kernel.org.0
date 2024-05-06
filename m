Return-Path: <kvm+bounces-16638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 652E28BC6E5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 969DF1C21094
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D4D1428FF;
	Mon,  6 May 2024 05:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b3WJtCc0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C64B14265C
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973478; cv=none; b=JkwrRcUUa/zpgzMNTwt6o4Ycyxhcz47Qdeo3QfW/YRJvFn8xWKugZuOTJq/PaTlyQoK086kYJQ8FLW23/BXTGGgQZ5Ly0suJFJtQ6Qq4tg8l3Z7NDDYRIMbTIRoRrSxX7vM5naVNdqFvA59KbwL3nanR99OHV1yklaxZULWKk0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973478; c=relaxed/simple;
	bh=TgkbQRP44YQHwST1GxWXx4WWxmgE0CMy9vQ3qMVMKv4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eoxJ+bmhjw2G1ulxYB9i/VP/2cx8ksw1XYIYp8kZUQQ/QDeIa0F01orTYGDRzlMv84+RgiITs41iLuCtG15PN7DoUAKavp2alzQhsItGZ1jY5Cm/GKkYHEUOzH11XbpunbPZEr2/8mWL1WYt8elWOj36LuL49rIEuTBtWjU8Cm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b3WJtCc0; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ed3b77d45aso21078905ad.0
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973477; x=1715578277; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iGfssPA7Ybu0SMT2b8P3qWxSEo+uR0AVKzZ6N6t8Kn4=;
        b=b3WJtCc0BMnATGmX/wVh8rHVinIBYsC/9NEjfoFEvL+QjPFUifXKSLYGNqRG0+N0f4
         bypX/vyULLPH/Gc5z6GNhIfmmUeN91yZOl1ISJEb9fNHvgCWV/0IPysbxCxoqaCF+2Cb
         4ZLyazmksebvJE3504qcs8vXUndQ21yYjmClNL9VBK9ZPmDoZXXRFejoz56QcMnap4TP
         RFA+UW5yqck6BaQNxP2YJfOY+VNBcSW9CcIbswNZfR8F//m3MQsgBJfUZb+Hy5RkZ3SW
         ZSqU9Lp/QWgq/Icki5T7z0B3u7TtoFLU+JgXBVqNJHz0SsHT5OH5dw9auGyaq0DbbaPW
         RQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973477; x=1715578277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iGfssPA7Ybu0SMT2b8P3qWxSEo+uR0AVKzZ6N6t8Kn4=;
        b=KFA3V+kiL1TKeDDbI6jhBBfhpb1GNPRW7b8TnLInDU4qnJB7/VAVotpL9cfCbbTcRS
         iqcjc1+QV8UCwB1iipwyAKOH6iyPv6jqr5o/yCEYDu6ZgxDM6TsDcUyrB2n14394JjHY
         ZK/1P0UDlTAiGwwxcVqhLhYF2wSewM0ioKQqwSQX48efCNyuSmqPKgk+vqm9P+f2yGwy
         a5z9PW+TQ9g6dZdrxt7jJlgTsQkkx2F1uKddCOnQ/Bns+D4xLRo8aOzI8ei56v39wQvU
         XjQqqysq7IXwtZz2pJM7u2agluc/3JLbCRXw6+hDH0E25LSL1eBbRtyyodNmB86RpA2S
         NLMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/Qd7RjAlhkegedCihj+v3raRfjh9yN4RfNURm9LOJNXvx5OT0SDoXraldIAXstfm3d4EMHuU8KS0/TwL5gC36M821
X-Gm-Message-State: AOJu0Yx2kPlm/L4JDPwWvELC5NcGu2ksaA3m55aSvx+vxotHSSFCXwKQ
	jEK8eeAcgtFerHHM4Msz2YUXVpoi3hbA+48Jknw+TVV05cFgp1WWLw5DsJJmanim0Wl4eiecMqG
	Vhql/tA==
X-Google-Smtp-Source: AGHT+IHFoWsTLrUb+RdIRagbboMw7d2AmrZUAfzmNMQ1T7fejvoraFcCnslpflfk88bfbc6nVQsiB6ZOWgpc
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:903:2312:b0:1eb:4c47:3457 with SMTP id
 d18-20020a170903231200b001eb4c473457mr493831plh.1.1714973476697; Sun, 05 May
 2024 22:31:16 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:51 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-27-mizhang@google.com>
Subject: [PATCH v2 26/54] KVM: x86/pmu: Avoid legacy vPMU code when accessing
 global_ctrl in passthrough vPMU
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

Avoid calling into legacy/emulated vPMU logic such as reprogram_counters()
when passthrough vPMU is enabled. Note that even when passthrough vPMU is
enabled, global_ctrl may still be intercepted if guest VM only sees a
subset of the counters.

Suggested-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bd94f2d67f5c..e9047051489e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -713,7 +713,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->global_ctrl != data) {
 			diff = pmu->global_ctrl ^ data;
 			pmu->global_ctrl = data;
-			reprogram_counters(pmu, diff);
+			if (!is_passthrough_pmu_enabled(vcpu))
+				reprogram_counters(pmu, diff);
 		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


