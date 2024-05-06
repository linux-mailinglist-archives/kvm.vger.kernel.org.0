Return-Path: <kvm+bounces-16633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D24038BC6E0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:33:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CCC728185D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9E84EB3A;
	Mon,  6 May 2024 05:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zMlrRBkU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1411422CA
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973469; cv=none; b=iF1huZlPboRDOZqEwqVvTKlTbwFQkBR2FJ8W+6AKPZkVZGBTyeRsCKAHoBrgcu8GLgBAnMPhxvdEI8VeqTfo6+r1HNt4xPtWCI8mLK0F7djFtVGsudXhGB1YphEZFwliPZEZmYpMfXyFhUnQRLqNGwiGXGXyH3lpn5qJOgqo3Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973469; c=relaxed/simple;
	bh=vaU/RZPmqYoH/464So36yGjdRJGfNXHZYDYj0KHcco8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dVkXGJy5EF3ExskjWAoxs7Rr/kkDAbLTrRMgpb4MmeWvnpB8XR7DvwBvMVH6dyjVV0U4dWVJsf0vUULShwnIWh6iODhB+X6fUqQO+al8wwjbVlvtprWTx+DvgV4q51jqDkVB753b2gpItUr18IuFPh+/ZfQc/mncroAHNaPc5/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zMlrRBkU; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61bea0c36bbso37304937b3.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973465; x=1715578265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MA8/Xi663IoS5zuz96wEjKjZSqTHfF7CFfxmKWJJZ0k=;
        b=zMlrRBkUp6JrOB6Y4MsSkGg2Rki/LZ1Sxkv6jsxsieX3iGdC5NX7mtvd/Kq0eENML0
         HyO/kvWd7YVG3iiIAg2Y9WS5R6mvCT0odx5iz1kZOoDWKu3WRA4yNiOnC83aD0gIufot
         r5qqjBg1dOTBJQJ5mZ0zlgyiqIxKTfL9WudC7zqTvbL0CIRGWKwRShaT3bpWylbM9fIT
         ZFfnA8hXrW3Kuo65RQKkjLzeMLa2zwDOsvoN7Aer6T7V6aMLDJ8fkZbvgEDWeVHjDPI4
         mf1aIBexf0EqRZZ/+il5jXRzJ3btSrgl3kg2J/+zRvVnBZfRxj3dkuWW7S881+CTNLd9
         9lKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973465; x=1715578265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MA8/Xi663IoS5zuz96wEjKjZSqTHfF7CFfxmKWJJZ0k=;
        b=BP/MxnP7otM3Ibf86mitDtoJPMsHd4vmRwlYQijL4vwjoLaUlKqoR2g15NfT4jYhZ2
         9IHz13pEedMLQObqWUEkCdAGadXG6zFR5PLrCe46mXEiusDi0bydBwKWMr/pImpS0yco
         35RMB8hA79aXf42M3WPu4H/HHetDvE9wAZUNAGeeBxvqqpUZCtgitQK0ZvWLk0vlwZts
         Sa/aEhQsJJ0G+pVzdhzS/0FlA9PokhFWfFgYtAG8sG9TBKkJ+ifMq4ImYIUAzP+j8iqf
         9BatNdqiD7WaTNDWi2Se88rd3wWSxL/T7s0D67JNB37HETdP4LRZp9tOpWbeva+ZEBqh
         Cj/A==
X-Forwarded-Encrypted: i=1; AJvYcCWMWN7dzEPH4XMRMQluXBIqM2VoHypWJxEB2s+L8zqvhyccdLLMkn14iPO7MH5PS1W4Ndjwdf4v5dc3t0dA0lSR8B87
X-Gm-Message-State: AOJu0Yxs4JrynubxfnwZtZmKQJYz2VF7NIOVRu+zyIbX8mxmHsfhLubF
	BsEp/6GbClllH8Ss4WLA+RCXf6QHnmJB+zCCWyaJ96f5CULfu8yXZ6LXVrgAUZucKZr1kJ9ueTb
	XxtgJgw==
X-Google-Smtp-Source: AGHT+IG0otdCAy/irYUs7PmYt0Bw7fxVVy5HVBRwQopMflopc5nOxvRQpebCuxTN5EIBP4vNTDPqfIv9K5Kb
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a0d:d450:0:b0:61b:e95d:f3f6 with SMTP id
 w77-20020a0dd450000000b0061be95df3f6mr2521445ywd.6.1714973465533; Sun, 05 May
 2024 22:31:05 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:46 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-22-mizhang@google.com>
Subject: [PATCH v2 21/54] KVM: x86/pmu: Introduce macro PMU_CAP_PERF_METRICS
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Define macro PMU_CAP_PERF_METRICS to represent bit[15] of
MSR_IA32_PERF_CAPABILITIES MSR. This bit is used to represent whether
perf metrics feature is enabled.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
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
2.45.0.rc1.225.g2a3ae87e7f-goog


