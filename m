Return-Path: <kvm+bounces-48364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB3DDACD762
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 07:09:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4DB13A7659
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 05:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C501263F5B;
	Wed,  4 Jun 2025 05:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aZpsQ2rd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9253A262FC7
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 05:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749013750; cv=none; b=V6d67yxg3xEFZCzRjF84GTuCsFReEDjhiXCohx0fC/rmTmuBhbw+EX8amf7cGOGMgT1JX0hFCdzEk6lXjC76G/rFBaPzYSQAZOi1WlKtOYRAlvQtVNYw0tXUW8kpCcxKTItBMd8I5EXqGFeGe9FSrptbGW6ZJ0yyC2R3jJZOxSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749013750; c=relaxed/simple;
	bh=+djBXRGZZ4KS/japPqQxkteXePbiEDHtGk4KYt6B518=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HSFUwFygZZ5qp7OWZQ42FuoB2OlpRSmK0LZfRh+jCxGCfR1vwqJBLQaGMtZolKGa5wsXOPirvjZBeo3KNmIpvePa8xkdHMMwdqNB3GMD6f5qsKoM82PWv1amh2hn6TELodZyOCMPzAt/QC8mFtLMPhd7y17r0cBh9XQwORkNg54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aZpsQ2rd; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2f02cd1daeso1248917a12.3
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 22:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749013748; x=1749618548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HXtiOD32k+3IRpg7Tl5Q1Nm4vKBBcoEeXUHabwSNFEc=;
        b=aZpsQ2rdXY2M/DO5xgroGh9FlkRp3fC+ZRpjKgqF947j0VsAfMZBqP3uIQOwOZ1Akv
         PasdGXbQXE2FC30LGwraR60z1aXE8dU0GDzyjiVPFmt7zlD/mopPE8n1HyzRIMsvz2gR
         fS0B/EG+2wG/M7a8JtoB+bJN3AO1URYgcbasrBMo390CLtcku9iBXbf37Wpz2Y4ado/B
         7JSbPPQ15gvEslhK90i0OTM2j+r8vMpTkiVi4BU/bz5kopezq6tpJZN/Rk7XYE6J1rJQ
         gsdRPKP+lqzULI98zrIu/5k0bGcBdvhPvhbW/70nu25Wkx6LKq/3r/7a4UavUUAFOAmH
         I14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749013748; x=1749618548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HXtiOD32k+3IRpg7Tl5Q1Nm4vKBBcoEeXUHabwSNFEc=;
        b=KT6eD2p0M3FXEKclh01pRwJQlAoWXZ4SxEk2h0Qw8uv6ws4andYr+HkIlXnpqNGPQv
         E2kvB1Jgj6UXbQ5X9DfLkN+KkWJcOYMlBmnfIqZkTUIdClPAe5gAwblGLxy0YYOrj52j
         QSyPzp2BnbGopI3WUDMVkqndcIEUa3j6XJMbdbC3lv60H/L4pxeoBLcEhlHPUyTj8xXz
         BkrkJn3migUNHjIcl7qjh/lOIYiOWKq2RI1K+f60PK8EL6mS2iK/iWEfzyjb3GXF6lDv
         yxnaA/s8LmdOMvnc34rwC9sl8yot1/WKh1PWmu+s1yZHnaMYiEIWSSzgYPpBObA1Ixuj
         yv5A==
X-Forwarded-Encrypted: i=1; AJvYcCXVIasYZSq5xqtoa0UNMNHeHd6b1eksPsW5eNPIif8jFws+IJWvPkSxbCEt+brvcHELD60=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjRYdhJtmMwmXoLilmmLYFnXck1NtPRcka+3zXT3XNMkFcpbrH
	i1h6iXfO7vO2F7lzhmjFDx1eX0LgYyh1wOjUJFD30u+MPmmGDuaex3nzeQ/RajiZ+0/1FYW0LsY
	91VuoetH9GpTT7g==
X-Google-Smtp-Source: AGHT+IE0yG+wVldA+Ut+AEkkDvhjuf8f2LJxfg7qHFUSl5PI3nGJnDA82B1khwNucVOGJtMX8A10UmFpgQtpEg==
X-Received: from pjh4.prod.google.com ([2002:a17:90b:3f84:b0:311:9b25:8e87])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28c7:b0:312:e731:5a6b with SMTP id 98e67ed59e1d1-3130cdfb38dmr1864793a91.32.1749013747721;
 Tue, 03 Jun 2025 22:09:07 -0700 (PDT)
Date: Wed,  4 Jun 2025 05:08:57 +0000
In-Reply-To: <20250604050902.3944054-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250604050902.3944054-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250604050902.3944054-3-jiaqiyan@google.com>
Subject: [PATCH v2 2/6] KVM: arm64: Set FnV for VCPU when FAR_EL2 is invalid
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Certain microarchitectures (e.g. Neoverse V2) do not keep track of
the faulting address for a memory load that consumes poisoned data
and results in a synchronous external abort (SEA). IOW, both
FAR_EL2 register and kvm_vcpu_get_hfar holds a garbage value.

In case VMM later totally relies on KVM to synchronously inject a
SEA into the guest, KVM should set FnV bit in VCPU's
- ESR_EL1 to let guest kernel know FAR_EL1 is invalid
- ESR_EL2 to let nested virtualization know FAR_EL2 is invalid

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/kvm/inject_fault.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a640e839848e6..b4f9a09952ead 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -81,6 +81,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
+	if (!kvm_vcpu_sea_far_valid(vcpu))
+		esr |= ESR_ELx_FnV;
+
 	esr |= ESR_ELx_FSC_EXTABT;
 
 	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC))) {
-- 
2.49.0.1266.g31b7d2e469-goog


