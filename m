Return-Path: <kvm+bounces-58206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6996EB8B647
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD1D3586224
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C292D59E3;
	Fri, 19 Sep 2025 21:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LAhRYCS0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD4C2D322C
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758318419; cv=none; b=phYhV61qIiXZrKXxkwU0hoFHjvSEhORQ4RgdCEKXy56y39WzJKVQgxvTQpHSsfKHb4IfE4rpvQph8Y5DU3aq9xBoxZOUiuM8WuIFgdPFfPhr3OIW1iGZes/oj8VZZqveKi276vZihSJpagBiGHPdNyJXIvnwsk9BnaqzxHcwDLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758318419; c=relaxed/simple;
	bh=GHMlzr2FhTOv+c4T5nvr/lgKTQoMQ7IduiCxorVExs4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oVCO9kLmF5eZmXmQS1vNdOwdtd4/1VyUf2cp+UdnH0lbG/l/FRwiF9Gvi9MlXGXE1ZHFN95ThfZjuHIZwxfIhBn0kfJpy2QCWnbdD1g0eRdRXLzVC6Jvso8TPLm8+fuy93gC48Os6QIr0VeoooePuUdInV7xXNtTtxmNM8HXJ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LAhRYCS0; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4f8e079bc1so1785660a12.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758318417; x=1758923217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=R7qTTFNHE+fMvr5BObVOavYnDFvgMV9D5f5f8nLVk4s=;
        b=LAhRYCS0vE8so1Q1Ox7uRZeP+ZXLL7yyUwqmQQdBIr93jenJrkPk7xiYauOoUboF7b
         iSF3WnJ6X4bDAQ7q5tm9Y8MXfsA/M6PVLuYRv5ejYMw9gnhmGoQo2lzFx5j521ZSWI3R
         UI/iXZZvVhuo7W39B0KDvP728tWT62tYCn4caEPsQimVlGDBE+LL8K+EYft5lprHSqk3
         nypQLVnWOzg8wWaZKs7duuGj19ZwNdnS5J5q6xxGgS1ttyphn1V52LrU0Imcop/gEh62
         Hq244SZsheWMpjlGlsD3/Xfu+Vp6SRI/ZSWG2sxmhxHGM8yDTOJ1iGLNhMBSo9MJrIid
         XGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758318417; x=1758923217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R7qTTFNHE+fMvr5BObVOavYnDFvgMV9D5f5f8nLVk4s=;
        b=rTmv7qCh3c3q4NTc+0EPF7J74IZIBU8M5RPWNKBev017TJWG15IlQlf0lihCq7m8Hc
         6Bz8i0Eu4DiLUNRW5i5CAUeD1uE/UM0DxPYDcQhy+C6QXMRC4TEQxJoEBrmTTfrnmYma
         6vOsR6/AvnWDvyr3JjCDSRAVFbKu2HzeY2drTx7FH16Yd+lReZ4bYKpFDwYAyYA7ju80
         j08IMIqaMxS/Zy/913m0FvAHzO2ulTkpXYFaYaOBsCr9NqWmIYZ9JcdMFHArzTQVkgYp
         cK9WzH+INwrjY6rsdjPdNCpGyg/Ibs8ijkcnpf5ve6qc48Tccrol4Pdgk1GTEspHEyw+
         Y75g==
X-Gm-Message-State: AOJu0YyURjaM0UN7BqFXvWMN5YW265VE5gcIo7gvZl5MZdwQbMuNPFO4
	DX1Zn6D6I4ybdetCjQthJvRr/dunEWHgUU3FXgi5XaksGGBgZXNziZOT9jLIPUih7avhEUX4N3p
	WbgEMtg==
X-Google-Smtp-Source: AGHT+IEZljZOGTUraRGVdL/nj4lz0qH3PqD/86oBB8T5J7CxU479VaglC7ZnBhDO+rPG4PwvP3GFqa/EZEU=
X-Received: from pjbsl14.prod.google.com ([2002:a17:90b:2e0e:b0:32b:58d1:a610])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5586:b0:330:84c8:92d7
 with SMTP id 98e67ed59e1d1-33097feda46mr5986136a91.12.1758318416971; Fri, 19
 Sep 2025 14:46:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:46:44 -0700
In-Reply-To: <20250919214648.1585683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919214648.1585683-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919214648.1585683-2-seanjc@google.com>
Subject: [PATCH v4 1/5] KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

A new bit PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
to indicated if PEBS supports to record timing information in a new
"Retried Latency" field.

Since KVM requires user can only set host consistent PEBS capabilities,
otherwise the PERF_CAPABILITIES setting would fail, add pebs_timing_info
into the "immutable_caps" to block host inconsistent PEBS configuration
and cause errors.

Opportunistically drop the anythread_deprecated bit.  It isn't and likely
never was a PERF_CAPABILITIES flag, the test's definition snuck in when
the union was copy+pasted from the kernel's definition.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
[sean: call out anythread_deprecated change]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
index a1f5ff45d518..f8deea220156 100644
--- a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
@@ -29,7 +29,7 @@ static union perf_capabilities {
 		u64 pebs_baseline:1;
 		u64	perf_metrics:1;
 		u64	pebs_output_pt_available:1;
-		u64	anythread_deprecated:1;
+		u64	pebs_timing_info:1;
 	};
 	u64	capabilities;
 } host_cap;
@@ -44,6 +44,7 @@ static const union perf_capabilities immutable_caps = {
 	.pebs_arch_reg = 1,
 	.pebs_format = -1,
 	.pebs_baseline = 1,
+	.pebs_timing_info = 1,
 };
 
 static const union perf_capabilities format_caps = {
-- 
2.51.0.470.ga7dc726c21-goog


