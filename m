Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FB23D88F5
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 09:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhG1HiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 03:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbhG1HiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 03:38:16 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86ACC061764
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 00:38:13 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id hf7-20020a0562140e87b02902dc988b8675so1482674qvb.3
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 00:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=asLoTJNqDsfECIu06kGnrrPYYB9PZTwQlOwbk5q3NAY=;
        b=qukG12Z/5Nrd4x0xu8iYn5S/7pdbbT9yVlD/dAdygZX9/E3KtDj1aTiTrta9NVNUQ1
         E+Op3DmX9UhPs9Gil54NdVZwtGzEz36g5x1l6vva1RSX5V6jrOmKITvwF/+PIfeCTHZ2
         5tZJS/ss5EflJYoLz8ZzxBDDAeW2YxAyT+R+vpchq3RJtcTWK23D3SL+4+D4jrDQNCbD
         eGz+Vi6+dqBeI1HBbLb3doTUY1XKMpxDES4PMJ8xi3GeoHBkGrYwL89RlPuts9xTM1ee
         gMiaeB3PukYt+hbONAJ5GzkJJXZzUlTR+4CDgZlultHHbNNxSwAqqSH/AmMf7dauH4xk
         uzcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=asLoTJNqDsfECIu06kGnrrPYYB9PZTwQlOwbk5q3NAY=;
        b=URyD5OPgb4BvzdDNywJsZ36RTVj/NQdTfVu1f5VNsPNFbYIjgZ+kH1dwOlaqDKYY5X
         K1s5ZVSr1oWvbsvGGFC//+c61Pp6bMZLNB8Tu8EB/Fjr/E6R8IOtYDbXckc9W1bYmx01
         HG02Z0/SwjuMoulcqXxz0mPIsw36gKtrK/aI+PLc4J9vcMVhSllEcmPCMBdNPB1+aCkl
         yFcfwhsvVp/FOiLQtkNuvvdFZzbFqpRlJ0K0HO0V6T6emDI5csDBXFMlgMhgfGYVmUgP
         yNpTPlYeHUmnHy67lYdx+Se3F3JO72SJq6t4W4QpKYFDvmsFR34R17LgJpDuhcR0fUVX
         6HPw==
X-Gm-Message-State: AOAM533l5E59Rj73phnx4q+MWNAX8p6jBUY7wlgb7R7mgohcX39nahVw
        DC4c6JNgHGxDw+YXgNcrFGTagKPdWwTjWA==
X-Google-Smtp-Source: ABdhPJx5VvLxvtRUc/taUqbearHx8itI0n4tywtAKoa5QJvM9uPJ919xyloKTTne7y5kiE3u02U5EN/OEdmD2Q==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:44f4:48a1:aec5:6e5b])
 (user=suleiman job=sendgmr) by 2002:a05:6214:9d2:: with SMTP id
 dp18mr2657261qvb.46.1627457893101; Wed, 28 Jul 2021 00:38:13 -0700 (PDT)
Date:   Wed, 28 Jul 2021 16:37:00 +0900
In-Reply-To: <20210728073700.120449-1-suleiman@google.com>
Message-Id: <20210728073700.120449-3-suleiman@google.com>
Mime-Version: 1.0
References: <20210728073700.120449-1-suleiman@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [RFC PATCH 2/2] kvm,x86: Report preempt_count to host.
From:   Suleiman Souhlal <suleiman@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     ssouhlal@FreeBSD.org, joelaf@google.com, senozhatsky@chromium.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM_PREEMPT_COUNT_REPORTING is enabled, the host can use
preempt_count to determine if the guest is in a critical section,
if it also has CONFIG_KVM_HETEROGENEOUS_RT enabled, in order to
use heterogeneous RT VCPU configurations.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/Kconfig      | 11 +++++++++++
 arch/x86/kernel/kvm.c | 10 ++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 49270655e827..d8b62789df57 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -846,6 +846,17 @@ config PARAVIRT_TIME_ACCOUNTING
 config PARAVIRT_CLOCK
 	bool
 
+config KVM_PREEMPT_COUNT_REPORTING
+	bool "KVM preempt_count reporting to the host"
+	depends on KVM_GUEST && PREEMPT_COUNT
+	default n
+	help
+	  Select this option to enable KVM preempt_count reporting to the host,
+	  which can be useful in cases where some VCPUs are RT and the rest
+	  aren't.
+
+	  If in doubt, say N here.
+
 config JAILHOUSE_GUEST
 	bool "Jailhouse non-root cell support"
 	depends on X86_64 && PCI
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a26643dc6bd6..7ec53ea3f979 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -363,6 +363,16 @@ static void kvm_guest_cpu_init(void)
 
 	if (has_steal_clock)
 		kvm_register_steal_time();
+
+#ifdef CONFIG_KVM_PREEMPT_COUNT_REPORTING
+	if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_COUNT)) {
+		unsigned long pa;
+
+		pa = slow_virt_to_phys(this_cpu_ptr(&__preempt_count)) |
+		    KVM_MSR_ENABLED;
+		wrmsrl(MSR_KVM_PREEMPT_COUNT, pa);
+	}
+#endif
 }
 
 static void kvm_pv_disable_apf(void)
-- 
2.32.0.432.gabb21c7263-goog

