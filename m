Return-Path: <kvm+bounces-22857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E27E4944266
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:02:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 199EF1C21941
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4353E14430D;
	Thu,  1 Aug 2024 04:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TOSQzj5P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3284B14B07C
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488397; cv=none; b=noKihRZNMSrMki8jffhDrFmfFFCZI56d8WY3XE8Bmjs+i00vxJg/y6Ir2WNMu9YPkNpPwZqqE3mw1pviLRxljLiKfvvygDdEKB3a1GY4UFUV7PRhK1LN6IgdRTOiGJsQvZAEzaNUxDH2nnX/MC79VfxXUvvO8wYbmHpn8Le3gNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488397; c=relaxed/simple;
	bh=jr68039rWj3uJXfJ8bCfP8G9dMD/BnbvBWedRvXK6xo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uggtOrVfXF6scvfmLlSgkFpKbpKQiTzZvFFSTvF6kFKFlyrh5HmYft1El4ka7RDAEv+c4eUk7XOzJ6tE1lJgEQ/Y+lgAtJHD4msatE2QNcXwel05uz/FGmc3GxjuUHi2brK9kz0aeezKNN9U/+gIeTyrw3ilE7QoWMt+yIJWd7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TOSQzj5P; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc52d8bf24so19731115ad.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488395; x=1723093195; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TxaTUli0MW2WfeRTkV/gChz1AThZ25Knkg7O5SunQdo=;
        b=TOSQzj5Px6HT2XlpojUStH79OVI5ZiiqE/CSSaIa8Eanw/EbCcOkUodf+U8Dk475Wu
         NtR4nsQ8b4oFXpeJuX5OWEG1XuhbfoEGyLkd+9UG8ctnd8RAfB+DhK0GoQQNauuR8b16
         LU7G0moN3IgLSfzm3TwpiZ1+DXw+GR/Z25ZoT194DBBMZtaRrq5mcEjMFjd5YHx1+ugi
         j78SgkhOkX+zSAmceVwPi3GX4BuYeKUt0HooKuvptfdK+Oh1TgDbPDUBjLQ51S4Zsbrc
         5H2aJgxBtCQuWnnhSHNckMGl7N5wIhV2VAKJNRimKdFjtUl79fdUIgUhfhsUyM2la8u7
         clfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488395; x=1723093195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TxaTUli0MW2WfeRTkV/gChz1AThZ25Knkg7O5SunQdo=;
        b=DQsJQM4n+Fzx1PL9rzRQLPprmfz/P6RZAjimpBcWrdN+DKBixeX7fE0qV525ieFuVP
         IVUIPy6YD3yWDyPz+FeYZM3TN8d6492RAx65gWxU4Ce+/hho2Oc9XLSB1fBqIJ42vyHU
         yGw5bhm8KMfU9c0akb6iAt3jKa2woGZJeNowFlmO0eS0paP0ZDcfXsEaE9qdlW8xibf9
         yjo+Eg6FM0O+QAa+ddReC8/hQadpwVJyJmCy4iqz8I1MzNGlNWuducTfGa89zNuW8BI5
         jaCqP8lGVBrb521tUD/dgXHDKAAEQdDcIg+s8VHEXnbrso6h9+XDJL0nypUHwoQBMOIM
         womw==
X-Forwarded-Encrypted: i=1; AJvYcCVzISfGpukRrsTRt22Ls30NkDtCHT9/bKKeiApl+ziRLCOuIMKEhpUwwiqB65hLigPQTVDg1YLBSFRnQVhbxvbOXffx
X-Gm-Message-State: AOJu0YwWo5xVcY1S1WJ7hqtjHjJ1+7qBP1/lRtOfM1E/FmQJEVqYRRkc
	czvJgCrcD4s7Y9mpQ/3fx3NHPjVIIAM36dHWlpRYyNM44QMY1gOoUK4DPyI+COxpyKRTX5t+nJF
	aWJhysA==
X-Google-Smtp-Source: AGHT+IGHkM4r42/a/rH4G9daniUo06gyI0yMhqNdsk8wRgb2+jJwFdjmzK0/Eyk61kWilTzxiClGhhQvR1Ng
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:902:fac8:b0:1fb:bd8:f83e with SMTP id
 d9443c01a7336-1ff524a1bcdmr1645ad.4.1722488395148; Wed, 31 Jul 2024 21:59:55
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:33 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-25-mizhang@google.com>
Subject: [RFC PATCH v3 24/58] KVM: x86/pmu: Introduce macro PMU_CAP_PERF_METRICS
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Define macro PMU_CAP_PERF_METRICS to represent bit[15] of
MSR_IA32_PERF_CAPABILITIES MSR. This bit is used to represent whether
perf metrics feature is enabled.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..d8317552b634 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -22,6 +22,7 @@ extern int __read_mostly pt_mode;
 #define PT_MODE_HOST_GUEST	1
 
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
+#define PMU_CAP_PERF_METRICS	BIT_ULL(15)
 #define PMU_CAP_LBR_FMT		0x3f
 
 struct nested_vmx_msrs {
-- 
2.46.0.rc1.232.g9752f9e123-goog


