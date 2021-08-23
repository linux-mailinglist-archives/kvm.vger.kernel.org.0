Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0DC3F5158
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 21:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhHWTiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 15:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhHWTiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 15:38:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605AEC061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 12:37:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x5-20020a0569020505b0290592c25b8c59so17379957ybs.18
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 12:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=szW3JQG930FKvjzbx7RUR8NrPsOs8RDaZiZuKadIl/c=;
        b=mGb2GjPMpo5einI6v+vymMibeQDV2rcstCmDsFC+CTwfIzLpWCXzmDSNTW4Ng/VIbQ
         Lfbhzix8jYFd2bZSAH6OfK1X4P7nJw6unIzpXtwyNFhFEL9MPWWxXqfONjt1YOVqppMx
         Hs7kmUS4kItkmiwX9q3cs4JChgoOlpPMNESJCF5cXP9MJSwvPesYoBhZV7oSzwKZFAYs
         Im9GtijBfKykKkvQDFtvU44VrgXsA2ryF8u++9TFhkG1NHW92jgglvnOZuyO2GCLW+E6
         CXUUzRxwb8FEx3iGI3opuwxfn+iZtVzyGcmPyD/SRRVcx0uZUXLMuUyzxvDVHeeVvJu/
         qFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=szW3JQG930FKvjzbx7RUR8NrPsOs8RDaZiZuKadIl/c=;
        b=nA06uVnQPnMZKScmepSf6s7+2gCNVgh/S6L0dSeCaK64gUGqkEQcHDWQgcmQHO0GmY
         a+a5+xzELSMLl6HrKW7FOgJi2L6t0CD3A0W3JRvCmh7Kbk1fd2/H39pYJZ8PGb4S+tlS
         9bpLw7TEopDpCtY9aSDiuz9WH664RxmPKKIFy5axVBGvx5lOR+LhtW9J1xVD7Pne7ygu
         JmZHemW1hD8/JzNZn69AR0a+GAnKql1LJI6lSkBB1lkJpqzCrTCXTawavas2lx7lomJn
         KCCvPfhg52ShaNcwR52fsCmzq/fgp8FzsuWWapXkJMGSkfU56E9BQowNfDo2eptCKOqf
         VUyg==
X-Gm-Message-State: AOAM5329uHsUk24q1gqJlZ3xYMKSc1a+9KffN1WXFBPNdzI+w7q2yQEX
        unhGp3Qg3r9cxZ8vErdiPAcYCuRHfw0=
X-Google-Smtp-Source: ABdhPJzGdw59R4ZZC5Qm0Hcd7Zngfbqd+oYcitVy9RepBcUmJeqesrhD14kaUMzmcCzrr3k3N88AMz9RrAA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:109c:7eb8:d5ed:2e59])
 (user=seanjc job=sendgmr) by 2002:a25:804:: with SMTP id 4mr44395426ybi.346.1629747447617;
 Mon, 23 Aug 2021 12:37:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Aug 2021 12:37:08 -0700
In-Reply-To: <20210823193709.55886-1-seanjc@google.com>
Message-Id: <20210823193709.55886-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210823193709.55886-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 2/3] KVM: x86: Register Processor Trace interrupt hook iff PT
 enabled in guest
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Artem Kashkanov <artem.kashkanov@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Override the Processor Trace (PT) interrupt handler for guest mode if and
only if PT is configured for host+guest mode, i.e. is being used
independently by both host and guest.  If PT is configured for system
mode, the host fully controls PT and must handle all events.

Fixes: 8479e04e7d6b ("KVM: x86: Inject PMI for KVM guest")
Cc: stable@vger.kernel.org
Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reported-by: Artem Kashkanov <artem.kashkanov@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/pmu.h              | 1 +
 arch/x86/kvm/vmx/vmx.c          | 1 +
 arch/x86/kvm/x86.c              | 4 +++-
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09b256db394a..1ea4943a73d7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1494,6 +1494,7 @@ struct kvm_x86_init_ops {
 	int (*disabled_by_bios)(void);
 	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
+	bool (*intel_pt_intr_in_guest)(void);
 
 	struct kvm_x86_ops *runtime_ops;
 };
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0e4f2b1fa9fb..b06dbbd7eeeb 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -41,6 +41,7 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
+	void (*handle_intel_pt_intr)(void);
 };
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..f19d72136f77 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7896,6 +7896,7 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
+	.intel_pt_intr_in_guest = vmx_pt_mode_is_host_guest,
 
 	.runtime_ops = &vmx_x86_ops,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb6015f97f9e..b5ade47dad9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8305,7 +8305,7 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.is_in_guest		= kvm_is_in_guest,
 	.is_user_mode		= kvm_is_user_mode,
 	.get_guest_ip		= kvm_get_guest_ip,
-	.handle_intel_pt_intr	= kvm_handle_intel_pt_intr,
+	.handle_intel_pt_intr	= NULL,
 };
 
 #ifdef CONFIG_X86_64
@@ -11061,6 +11061,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
+	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
+		kvm_guest_cbs.handle_intel_pt_intr = kvm_handle_intel_pt_intr;
 	perf_register_guest_info_callbacks(&kvm_guest_cbs);
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-- 
2.33.0.rc2.250.ged5fa647cd-goog

