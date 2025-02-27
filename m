Return-Path: <kvm+bounces-39522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F63A472E3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E88C18853EA
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A116723FC4C;
	Thu, 27 Feb 2025 02:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o5tSABgJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9794C23BF9A
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622804; cv=none; b=UaxzIflor8pyMB+EMIa7J18vASo0lUet5H2jMQ5fuZNmO5WfD1+MG6bRy2hAiRmJIi3ErNblt+cpTHIjh6ubNvSJl5XxWwYmKmOSdGREP1Dst1owHjFyvKjg/EPtDroiBRDxcNCWr0ahrh7CcoLGrpA5jB4G3VDoTadkuvggJB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622804; c=relaxed/simple;
	bh=3Om1yDQGTJbRQMaVDcoK4RL2pv7jGwTkVpwEklnlv5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sW82hkl0sfqJxV6Rl04a6rhUmUiWl6FFPpDu6VG/tw8cntyqOuLUvRLarI+dtAMMSBT6AjX8Uj2Rcgez/pIZxfqgf+YW/D63LvqIDh1dH8mqK+DLuXHOAxqKx59MZC+uPGqAUgsUUB2eVuHNXXLwWiwqd6MM2xFLIsfny+ogFKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o5tSABgJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe9527c041so1101454a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622802; x=1741227602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=evC/AJYAKH4bntjSNStZX5d0W0KQw/JlJZazMUftcQU=;
        b=o5tSABgJASXFZUmKl+VdieZrjxfJcyhzhDWh7HjPF8xZS9Hl7IsB2i948WsiibIjVQ
         TWeQyAER81FznSdvJBoQlfwM25KeNy7fnOJwijqECLhe1ea6qF7tekPwy+e1vuK6uGml
         HGulWujjt5LEpnMHzmME1wj/cuQw19h2wIprAAP0taUS2J5FyGZSASuA5mhHMVwGFU2w
         vtRao6ZICuQ9J8OhLSMzjIxqZqbHJp39NYj6mmB+2Yio0MhQ/UiMbGWmtG1cJNE2hrPR
         tXBB7uLJWARTkguRjzRstizABnyZ1iGYh/OOTdz6yZ9P0dK+v1ZiA/G48M9cRd5CKH3E
         T/sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622802; x=1741227602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=evC/AJYAKH4bntjSNStZX5d0W0KQw/JlJZazMUftcQU=;
        b=if0X2US7JXxBEdfdAp3stxn1WxamvBk/3ktq3fpvHh0XJVmDZjM69HUXToLWkcklBL
         68J7Eo+VZK1rrH6elq+GiPhLSgOHhgmtVSVMbUz/i0i6Wlwi5AEeRbSdg88vQD65CSys
         cQGZ9PcI7OKtaBygtyEsggzgjBX3b1bSnCDR3p0WrVpDE10JBaDkkH6iTTkKyLmwGiBA
         8PvsNZqEX2hfnVaFr0L+NPLUaRAuvl6uMR8NakQXAswpbJUIP2RoMWlGH/t6qcqryayr
         iOZ11azXvoQM1nmt4D9Hwq7bpixy3MrUaEqNYRVYO1cdOtb76mg3MUsRtjIBk4CQKWEH
         Rw4g==
X-Forwarded-Encrypted: i=1; AJvYcCWyhn4hc8axM2/gQIXTP+gKLWhhDIUSZQH9Mf6mtk6nGVwAuQBa8/8OAUzKUfE1T8xz+QY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzu/en28tq8pQumOMyj7eChc8vd8tAM/i+Ez5vUPEbNQtvsqTv
	9Ei/fam1yU6PY4TH2rkI/9WtEtBIWU6LiP+6u4kp//X+1YjF+E340PtTwQ2TfoteFO+CrpBHJth
	wAA==
X-Google-Smtp-Source: AGHT+IGv/zpuplWrcklhWH3aZ9H+bWJRwaJtozM+byhaXyymURPHFd4oTcq5U1mZsa54ViZesa4/C8fD/pk=
X-Received: from pjvb12.prod.google.com ([2002:a17:90a:d88c:b0:2ea:aa56:49c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5101:b0:2fe:955d:cdb1
 with SMTP id 98e67ed59e1d1-2fe955dd224mr3596029a91.23.1740622802051; Wed, 26
 Feb 2025 18:20:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:50 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-35-seanjc@google.com>
Subject: [PATCH v2 34/38] x86/kvmclock: Get CPU base frequency from CPUID when
 it's available
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"

If CPUID.0x16 is present and valid, use the CPU frequency provided by
CPUID instead of assuming that the virtual CPU runs at the same
frequency as TSC and/or kvmclock.  Back before constant TSCs were a
thing, treating the TSC and CPU frequencies as one and the same was
somewhat reasonable, but now it's nonsensical, especially if the
hypervisor explicitly enumerates the CPU frequency.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/kvmclock.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index b924b19e8f0f..c45b321533e5 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -188,6 +188,20 @@ void kvmclock_cpu_action(enum kvm_guest_cpu_action action)
 	}
 }
 
+static unsigned long kvm_get_cpu_khz(void)
+{
+	unsigned int cpu_khz;
+
+	/*
+	 * Prefer CPUID over kvmclock when possible, as the base CPU frequency
+	 * isn't necessarily the same as the kvmlock "TSC" frequency.
+	 */
+	if (!cpuid_get_cpu_freq(&cpu_khz))
+		return cpu_khz;
+
+	return pvclock_tsc_khz(this_cpu_pvti());
+}
+
 /*
  * If we don't do that, there is the possibility that the guest
  * will calibrate under heavy load - thus, getting a lower lpj -
@@ -418,7 +432,7 @@ void __init kvmclock_init(void)
 
 	kvm_sched_clock_init(stable);
 
-	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz,
+	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_cpu_khz,
 					  tsc_properties);
 
 	x86_platform.get_wallclock = kvm_get_wallclock;
-- 
2.48.1.711.g2feabab25a-goog


