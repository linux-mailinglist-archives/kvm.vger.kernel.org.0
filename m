Return-Path: <kvm+bounces-55222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA26B2E98A
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 02:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B0EC1CC2A99
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 00:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA9D1E32D3;
	Thu, 21 Aug 2025 00:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ip1JJzgr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E88D1DC994
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 00:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755737086; cv=none; b=XvNrb3PkW8m6Z0Z/BvyQSpiQ8fUlXv8Xp30deQw5D7N5NJ8h2TIi1CrHwAf7svPpFcadgtgf7dh2WyU1wHn66MSBKoMcSxU12RtHRnITtR7FcXVskYO9HlndPCAU4tMY5lHtnvUW83OH/k7HfPva9MxvxdDT0vdB2SxQ8lBo+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755737086; c=relaxed/simple;
	bh=VI4YATGAV6Ym+DsuQ7b7Vv/yuJyulwi5GTUFPFSI6s4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nYMgVy5GXdXVBDuQJq9Cx1jcHXCm5VJlNCEk48Vy4aAadnuZOB1ue+OwIciUkhaYMDrwzzgcpcoO8HNd5dZFN5xK/f7LZg/ssccr7XanpU842/t70oArXAUm2ehAnxi0rNk3yUyEetevCPHQzb9zBVCytZbhdwvTB8hFQ0WIZZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ip1JJzgr; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b474a689901so265434a12.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 17:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755737085; x=1756341885; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FvRmczNISAwtsuojMSWjNOah9ztyOwyZkoZkSR8Jha8=;
        b=ip1JJzgrtmjXBCg50xzONxjn42An4nf4Wb7kM9b9DTxl3H+FF1grxv/tAe7aYRaYsZ
         nmdyJ2Fbjr8gd2vor9EDD5ffu0nGSI04TmfRFYPQu0XMQNXfpyqGRWpQ0Bq6K3AOb2+4
         +75JbpJvSteXA5WYbYZ9MQChG7eW/qXBCSHYtqb047GQxBnF2sp6wN1Hd4TIdlW1v0wI
         XNH9phHgEAmn3BCZ1i5Z4C3wxub4xcQ7COdHHRBTeqRZgFmdZtsRsr/qRabaZo6TFMuQ
         Gfyxegry56jdcwmAo6hLsgy3ziqQM7vXFwkdIz/1MrBVnr5pPG6ggwhWLna9yMYUaSto
         UIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755737085; x=1756341885;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FvRmczNISAwtsuojMSWjNOah9ztyOwyZkoZkSR8Jha8=;
        b=hnqM4Kc8O6Alq5dt2d+sKfqDDkgutv+qPp2FJvzWsClgSLzC56VBdXRcTxtdT2j6mH
         H7CjmsHfXCZA5nwbK3hrl1V9r/1KWuhyyWZPlbLWUREp2suCiq8oMUSmxK822RKo7miN
         83RiVZEeW/642UF7iwU4Jusd3avcU5DYih5i2j7yxu8B8XsNwwu+/A1t/suHnOdwBlse
         TS0F8jbMHYCfMt+yKcCorTxJ87YcrOepCoFiqbYz6MM6yj/Y/lHQavqN48uVS6PNyFId
         BdjqidSZzCyy1yNIdhzUz6ODTPkiRBVWHuL2K7Vld9PABQ2ZQO7n5Nljip46HVsVLVF6
         MQxA==
X-Forwarded-Encrypted: i=1; AJvYcCU3ZrxCzt9dFlGbcSJrzQ4GOelzFh3C3owr06UiNxQzRCE2yueMgN9E9Z3vX4mkl3CnIxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEkDIrMpLVml/8EQ3c6Kk7Yhn0MqVlttnIuZiQud2LOCgsNgUG
	+ddz/JOKv/T03AqC1JCZw5LEitifj0WVbRHXD+ogw8oU5ZCnPNqNtfH8eZt8YvGgaqLl/MjEZkH
	mSbewjA==
X-Google-Smtp-Source: AGHT+IHCywj77PiiSBd9ot66gB446oV8EuXEPzwpq8DpcPnKD7okrtZlFs3FgcpSd8TvvHntDfrL1sEKApY=
X-Received: from pjbtd16.prod.google.com ([2002:a17:90b:5450:b0:31c:4a51:8b75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:914f:b0:240:1c36:79a3
 with SMTP id adf61e73a8af0-243307c8bb3mr600646637.22.1755737084805; Wed, 20
 Aug 2025 17:44:44 -0700 (PDT)
Date: Wed, 20 Aug 2025 17:44:43 -0700
In-Reply-To: <20250722055030.3126772-4-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250722055030.3126772-1-suleiman@google.com> <20250722055030.3126772-4-suleiman@google.com>
Message-ID: <aKZr-4sZWFZXL7hP@google.com>
Subject: Re: [PATCH v8 3/3] KVM: x86: Add "suspendsteal" cmdline to request
 host to add suspend duration in steal time
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	John Stultz <jstultz@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, Suleiman Souhlal wrote:
> Introduce a new command line parameter, "suspendsteal", enabling the
> guest to use MSR_KVM_SUSPEND_STEAL, which tells the host that it would
> like host suspend duration to be included in steal time.
> 
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---

And then if we reuse MSR_KVM_STEAL_TIME:

---
 Documentation/admin-guide/kernel-parameters.txt |  5 +++++
 arch/x86/kernel/kvm.c                           | 13 ++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 747a55abf494..8e80094317c3 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7178,6 +7178,11 @@
 			improve throughput, but will also increase the
 			amount of memory reserved for use by the client.
 
+	suspendsteal
+			[X86,PV_OPS]
+			Enable requesting the host to include the duration the
+			host was suspended in steal time. Disabled by default.
+
 	suspend.pm_test_delay=
 			[SUSPEND]
 			Sets the number of seconds to remain in a suspend test
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8ae750cde0c6..1eea3e82c85b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -71,6 +71,7 @@ static DEFINE_PER_CPU_READ_MOSTLY(bool, async_pf_enabled);
 static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
 static int has_steal_clock = 0;
+static bool suspend_steal;
 
 static int has_guest_poll = 0;
 /*
@@ -320,6 +321,15 @@ static void __init paravirt_ops_setup(void)
 #endif
 }
 
+static int __init suspendsteal_setup(char *s)
+{
+	if (kvm_para_has_feature(KVM_FEATURE_SUSPEND_STEAL))
+		suspend_steal = true;
+
+	return 0;
+}
+early_param("suspendsteal", suspendsteal_setup);
+
 static void kvm_register_steal_time(void)
 {
 	int cpu = smp_processor_id();
@@ -328,7 +338,8 @@ static void kvm_register_steal_time(void)
 	if (!has_steal_clock)
 		return;
 
-	wrmsrq(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
+	wrmsrq(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED) |
+				   (suspend_steal ? KVM_STEAL_SUSPEND_TIME : 0));
 	pr_debug("stealtime: cpu %d, msr %llx\n", cpu,
 		(unsigned long long) slow_virt_to_phys(st));
 }
--

