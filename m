Return-Path: <kvm+bounces-32290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7CA99D52ED
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 666621F20F23
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3D21DED55;
	Thu, 21 Nov 2024 18:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hFstuxpQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76F61DE4FD
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215205; cv=none; b=RVoA2pLxMPzpPZwFPW5hCI67vfn5IrbhBEG2zZkyIS1hPXKKhNFM/4ncq1xVFCdOauTtA1vpnz2I+5DHf6W5M2WnsqB4XByWs7x4ABKl0s7uY6a8RcEJrE0igV+XNHORtehCk8RJtEcquFWfCP6DuUP+Fp8viVGTA75q5kzIZiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215205; c=relaxed/simple;
	bh=/MlTsvEZhBm6lsxe7EmxCdECCTQKt4d+z1t/zvxQERw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FVNzkBys9MgV0bvGtYKWmUL2kBapCZ4UJrLlFWrL0Dbtdx33CmXKTdcl7elrcSVc6ENrqPmhMrzLljh9Y7s66Sy8pvSghIex+Ityd4iEJ7Bwh3cFk2REtJpmxMsxKfYcUMvJq4XwhfPsKgRxUrxu7Z5B1r6O0RhySa9qwJwISqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hFstuxpQ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e387e8e8426so3251367276.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215202; x=1732820002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rsHo0Py3TPU7pbh7g3h3HouheNFLNCt6iVoC0xc8Ffg=;
        b=hFstuxpQUnAlVZ3bZY0abEGefUG6T5jzWCjPKELKL2luMCA0BgWlYBnf/t8KI/Fcag
         gpjsF21oDoUURQfgS4Wtb3BXl+i//gNyaPJOEEjy94US8YihoTUdtW4SitxRCesVEUea
         vxHJdK4GDFgE30iC1NVwzwk3rhAHsEz/WzYnSvpT6QoXZn6VNSgF1bkyRmSRRfz8V28D
         mqOkCcoeTfkTgrENC3dl7X04Z54uYxMrQJFtuhQdY1xPkHd158oMT3CfiyF0wWNtQcRE
         VBs35tgJczBa26nosQ4/hsw0AJLMnOMQpyqBse7zc2u04zwX6FF31jQidRu6qcUJI78z
         LHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215202; x=1732820002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rsHo0Py3TPU7pbh7g3h3HouheNFLNCt6iVoC0xc8Ffg=;
        b=wRGM+/gff5VUx8JZevXj9MqXeWg5dh2hF22ih8TxHjFTdmfeLAeBfbKy56hBSAhXIy
         rhG7EQGRxsTEjCwAuyCYAV17SUc3MfOa7xEvoV1etapOVAQdJhibID8ZKJgmGbSLmTdu
         gNlRKWIl4JUkyTYMNL8iinXaUCsO2QpjWkVejl6ZLg42ebC/poMqmZSURToy8ycRve1Q
         pWRkEe8VwfsujzxBRXYGyA75WWUE3A5xCcqSFRUpvbNaApq3oRckwzwCfW7NXonYkLAZ
         8trI3KQfEzj/Rkhzw9hxfnh20kMsP3uuQNfKRkcx1Skj3l5JdOLXK/I2JI8D0vzgxXzK
         tqQw==
X-Forwarded-Encrypted: i=1; AJvYcCWgTNrpMEOsptzGgQOEDsZq39mibGaJV1HAqUdK0vPw1B5uVc2QZIsI4NV1EZ+GPpfQ69E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2WAsjTRI7uICd1B6Q3QYvAkFGcCDDaKhA3og3fbbpQJ2tzrD8
	tS0rSfhRX8XiJGU4vS9Xhzs8OSj9zw3NO1z4kTdmIW7d560Sk/5QzsC5aE9zlljXIByj9330fmn
	13Ko6Ig==
X-Google-Smtp-Source: AGHT+IEa89oTDs6AEs0b6qM9YtZe6l8s01zJVqD4TK4bwVkMk4+VBxvLRHFEIhtWa5nFhIw1lpDFQnaYmZLg
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a25:e90b:0:b0:e2e:317a:d599 with SMTP id
 3f1490d57ef6-e38f700d9c3mr998276.2.1732215202627; Thu, 21 Nov 2024 10:53:22
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:52:55 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-4-mizhang@google.com>
Subject: [RFC PATCH 03/22] x86/aperfmperf: Introduce restore_host_[am]perf()
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

Round out the {host,guest}[am]perf APIs by adding functions to restore
host values to the hardware MSRs. These functions:

1. Write the current host value (obtained via get_host_[am]perf()) to
   the corresponding MSR
2. Clear the per-CPU offset used to track the difference between guest
   and host values

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/topology.h  |  2 ++
 arch/x86/kernel/cpu/aperfmperf.c | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index fef5846c01976..8d4d4cd41bd84 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -309,6 +309,8 @@ extern u64 get_host_aperf(void);
 extern u64 get_host_mperf(void);
 extern void set_guest_aperf(u64 aperf);
 extern void set_guest_mperf(u64 mperf);
+extern void restore_host_aperf(void);
+extern void restore_host_mperf(void);
 
 extern void arch_scale_freq_tick(void);
 #define arch_scale_freq_tick arch_scale_freq_tick
diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index 8b66872aa98c1..4d6c0b8b39452 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -135,6 +135,22 @@ void set_guest_mperf(u64 guest_mperf)
 }
 EXPORT_SYMBOL_GPL(set_guest_mperf);
 
+void restore_host_aperf(void)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+	wrmsrl(MSR_IA32_APERF, get_host_aperf());
+	this_cpu_write(host_aperf_offset, 0);
+}
+EXPORT_SYMBOL_GPL(restore_host_aperf);
+
+void restore_host_mperf(void)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+	wrmsrl(MSR_IA32_MPERF, get_host_mperf());
+	this_cpu_write(host_mperf_offset, 0);
+}
+EXPORT_SYMBOL_GPL(restore_host_mperf);
+
 static bool __init turbo_disabled(void)
 {
 	u64 misc_en;
-- 
2.47.0.371.ga323438b13-goog


