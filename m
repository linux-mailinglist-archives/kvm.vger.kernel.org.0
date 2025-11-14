Return-Path: <kvm+bounces-63263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2200EC5F470
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:51:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF57A420ADC
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B331A2FD1B7;
	Fri, 14 Nov 2025 20:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dXO+0foo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE072FB965
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153479; cv=none; b=CtFsvyJGrQ2E0IW0cPArX0eqEXgwKQrgEa2vQ8CJK/K5XqW9ERP9n4zHG29P5A6r6zrKS8FkECCZGxP1Uq3zz89vnEvRXr3vJGv0V1zWCAtaiRQv+cAmW+ZR+yo+cb6h3RZGhBuzJEiciBTWTrKjJuXFxm7DbKIOtA1AZ//u15A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153479; c=relaxed/simple;
	bh=drnhf4HWccfdCRAqsv6Wpb1qqqVWH2tm3oJf1ZUDKTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=al8YEL45/iJ+prxJqIEvtEE0cW6MoeN08qcXs1fqVHoDoQpvuMoLPd50CMm883hFZrwdzwioD2KbqUZ0NihdUbyYiff7C+H6R71VLaOQI6qxjKkjfDkf370fZm5or/B4Q8/L5A3DfHuNBJ1Bp+MUAnvH+Ls0Z/sAaPEhGVehXVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dXO+0foo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3416dc5754fso3616309a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153478; x=1763758278; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QwhkZoiw2YNzZ9paPLFlvXCeWSMScaZEgEdXJUEBb0c=;
        b=dXO+0foou4L/M2qPF4/zZTcZIRZgfzue4KlE48RtQnKK73P7kf4xBxYvgcfqi2C8CX
         MVEf0mt4R6yzBGXeRP6cdf983OtvHNf8uDKl3nQyBGcnLwF1mH0sKqq02q8qgRdkyBP4
         fu4izCnJ7u4mXPpPitLMkH5XPIOBax6Yd9ZWC2myVWzjpjY3EuNcTAT7d/KwV/4hMY9V
         Stz+xh3zQrrmlx7SA3d0nk/R8W9YtDWgiYQq7ktJGY6LUfPdHsfRDe50ebmEn9h1f2l6
         b6IOkvD37IRanT1hFqhhZ8DWMKw2gr+ewjzPpfSoyxuWaVdmDS/szQv6/cGpTbo/VTyB
         vadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153478; x=1763758278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QwhkZoiw2YNzZ9paPLFlvXCeWSMScaZEgEdXJUEBb0c=;
        b=RSjYXmXDq7bmkwZFMIabxJXvkaRwYUK8a2fRBjxz0iBAH3/z8cVQjjkkg23BHvMt4q
         0tFBZKfmcho2WzE7Q5gRvINvuvnpHaAdtfBiZ5lgHQ9r27MSPdfiBNJt4ITXkWStRkC2
         vdPa3dUKca2tlXd87ipZFMeL2EXBSCqPYJvHcCR1CieGccV9P/FX6/Fr3NvvIrUq9blz
         1d3dsD2v+p9CAFLGkJXPXtCW/VWs3LmqnjsTpEK0o0eOtqTruuk+B8iTAdUhx/guFDH+
         kSofxBywVRqvZUwsJqOzQ8kcUMIP+az9BdjzuB4jEdTIICDj/ONCewJ2FZ6Xrzz/zGza
         J7Iw==
X-Gm-Message-State: AOJu0YxzsheAGqmuc4T+lXTt774ekJ1NuovtoANjDqUWJtXWzruEnABY
	btnkD4sWPIZQKg5YZfrZaP798VPU5OYJoc6FnhFOKdv+yY8JG2GAMq3vpw0QRk7W7kEG3NKiUhi
	cqyIa7Q==
X-Google-Smtp-Source: AGHT+IF8GCbq9QEVkWprkxuigqENELWtbdQ/DxhLKxkA9aM8ZlaupSuiLEktH9a/AS5nCcm2biDS1sQQb0k=
X-Received: from pjbck22.prod.google.com ([2002:a17:90a:fe16:b0:340:7740:281c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cc4:b0:340:2a16:94be
 with SMTP id 98e67ed59e1d1-343f9e9071amr4938551a91.4.1763153477827; Fri, 14
 Nov 2025 12:51:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:49 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 07/18] x86: cet: Validate writing unaligned
 values to SSP MSR causes #GP
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Validate that writing invalid values to SSP MSRs triggers a #GP exception.
This verifies that necessary validity checks are performed by the hardware
or the underlying VMM.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/cet.c b/x86/cet.c
index 8c2cf8c6..80864fb1 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -56,6 +56,7 @@ int main(int ac, char **av)
 	char *shstk_virt;
 	unsigned long shstk_phys;
 	pteval_t pte = 0;
+	u8 vector;
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
@@ -105,5 +106,9 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
 
+	/* SSP should be 4-Byte aligned */
+	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
+	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
+
 	return report_summary();
 }
-- 
2.52.0.rc1.455.g30608eb744-goog


