Return-Path: <kvm+bounces-48001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C47CAC836F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:02:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D3641BA4367
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806F629208E;
	Thu, 29 May 2025 21:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4L/U8GeP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A3F1AAE28
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 21:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748552523; cv=none; b=C6nnOEilbzOAl0/al1KkYqqXDvQ6UXB6e6z95kQ2sr2IMMK9wmACrJtJYwHXv4nGuAA8zJBssO1nJB6jOGG5f7Yppbx19FqcQT4CnX30EjibXXdWLEMbxzMZPOv4nmttZvlWS/RjcLy1fZm44Ev3qTve1lL4wfP3NM3Te67z9LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748552523; c=relaxed/simple;
	bh=dxWPimiAc6uFSC/ZL4Ww0aJbcgjWopjFE3OHX4GBxvs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qJlOiioNJbA6Xwl073QZ6tISzsH+w0Nhb+voStqmpe9AgOrLB3qPkPdNx9EYDPT8EtpLtxt7DMVKOuas0sq2HTbRRq00niac453bNfqSfBSO/l6zGcTSz3OK3FHHK4UtmSNv29pkCAPfOABG+NJXWRCbz1hFBjTzLh6cnPoHZyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4L/U8GeP; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747a9ef52a4so1766664b3a.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 14:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748552520; x=1749157320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ks3H5GfFmWti/3iKVQUIdYGlb2QWvn/N2uQVD8qiXbc=;
        b=4L/U8GePSE03S5X0GIuZolSokYz6pMtuQd0SLDjTR4PQkMQm3OjWAZTZ7xnqUvG9yp
         T0hcztawHKtJWA7p6t+gARJrB0A1bN+2iUIcKRxh4T1E4kP9g9iWrRwLqkuxJbc5lu3g
         3sluZcB74WerNqAAqbdG+BvD8DNcFWx67GQ2cJ2SVaJqkZMLY90mdCs9xUubi5gdlpVk
         Sd4ig9g4JZ6OK6GAF3ZNk+WOSRTVeqcs8FvEnzhy9tOGdnsslYs+55VaEK/kdt+FirlL
         n0iHGjxYDhw1B1kjsXPWH/MVzaQZF3pnUiLnJRBKOZxmB8Y2v0e5ZXiIJbMoF/ub8koI
         Sx+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748552520; x=1749157320;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ks3H5GfFmWti/3iKVQUIdYGlb2QWvn/N2uQVD8qiXbc=;
        b=iP1GCQ7hqICdnuAJAuZfv4TblBm3xxksBmPNPym6AUd8msYfTpfo0GXOUqJVwwERRH
         +BJoz+DML12KmIar4IYbY79ndIiOFGmxjfVO6zcIQzwexU3BJAzPee7H5cok6qza8Lmr
         ytZF43AHy11Um7vp3k7mg+EiVjhKH5JrqA/lQdmLJpoV0Otqv2i7fUwIWz44/2wBG5Ag
         fkbaSGyWaul2vZiDOZMnq9ImtrenXqNp5Iye55ONvY2zccyQvo3xojs4eKmDrHI1IUwp
         qX2Dr7bm0IS2wnjEeATyaYEwFIcoqjBVrTaI0F+8YEQzfyRUT5VMCC3crQdekAF9sOo+
         yUkg==
X-Gm-Message-State: AOJu0Yw4QyN2LlR1GYF1FrupAMkRFxiHiVR2+VNJ7JSZ3Ou/Dn2KonpI
	7lipa6t4g0BzghzYGSlvE7IuqUqIsQ1GeYDbvhearR2NF3JgIXQz94ahB8m2DIEVwm0EW/1j29y
	JddMoYA==
X-Google-Smtp-Source: AGHT+IHLFxbY2g6iQCvb3Y65zBbD0xm4WsGxIf/Tl87uiJ8SXODEN6GKovfWUXigZ06SH3QI+BtATbS2XhQ=
X-Received: from pfbjc19.prod.google.com ([2002:a05:6a00:6c93:b0:746:2ceb:2ec0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9a7:b0:742:9f58:ccce
 with SMTP id d2e1a72fcca58-747bd980db5mr1251681b3a.12.1748552519709; Thu, 29
 May 2025 14:01:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 14:01:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529210157.3791397-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86/pmu: Explicitly zero PERF_GLOBAL_CTRL at
 start of PMU test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly zero PERF_GLOBAL_CTRL at the start of the PMU test as the
architectural RESET value of PERF_GLOBAL_CTRL is to set all enable bits
for general purpose counters (for backwards compatibility with software
that was written for v1 PMUs).  Leaving PERF_GLOBAL_CTRL set can result in
false failures due to counters unexpectedly being left active.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 8cf26b12..9bd0c186 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -905,9 +905,6 @@ static void set_ref_cycle_expectations(void)
 	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
 		return;
 
-	if (this_cpu_has_perf_global_ctrl())
-		wrmsr(pmu.msr_global_ctl, 0);
-
 	t0 = fenced_rdtsc();
 	start_event(&cnt);
 	t1 = fenced_rdtsc();
@@ -956,6 +953,9 @@ int main(int ac, char **av)
 	handle_irq(PMI_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
 
+	if (this_cpu_has_perf_global_ctrl())
+		wrmsr(pmu.msr_global_ctl, 0);
+
 	check_invalid_rdpmc_gp();
 
 	if (pmu.is_intel) {

base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
-- 
2.49.0.1204.g71687c7c1d-goog


