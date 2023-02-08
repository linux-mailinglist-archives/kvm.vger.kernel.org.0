Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B5A68F8F6
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 21:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbjBHUmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 15:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjBHUmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 15:42:37 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8331D29152
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 12:42:36 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u15-20020a170902a60f00b001992a366c3bso66853plq.12
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 12:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=spQ5K2Y+c+YX5odb0jqHHYNwnHoVUZMaBIr5X38MZv4=;
        b=IGg5iW9dBxluaPpP9MmOQm07YtAy1EcfamOO4LcrJdDJfwKf0iO600HomKRLImIjez
         mTB/9lgPvla8ir7pr4Xet/LGie22EOCfZtmsWJ1ylwj4MJw0RdoiYw53iDL8N534wkR2
         M8RsiprCIS4xlG422ZFSTARxu46pfU4AxOF/C1MS97Nzr393lD+d0OGMrv+gsx/Sgoqj
         ummSPoA3wuhyFKovza13ay1UPWoVSvkmfsCgRKWoENmDiK44+cUyy35LQYkh/38XMV+J
         yQPpII9V7ahCwCI4KOUXPS7uRuu+e5cbLGOhURuyU8c4TlVgmlbXdSS0qyGC8tmw9Z6R
         h8iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=spQ5K2Y+c+YX5odb0jqHHYNwnHoVUZMaBIr5X38MZv4=;
        b=Cki1Sn83WQPqt4E5gi6UtzJKFxGuKOgkI4HKP589InviVwO8DmyumtQPthTZppbEQ9
         ERinZCxA+1M5cQcp2bfQXc+/eklU4HEHlgMcUbQ0+mV/OviU757yssWX0wbM3LA8PUE2
         nzTy5ub7e0xRF7wLw3fr9O67/hKQ71JdRGl1+4Bdn4CZNFkiYg++6DsejBGZWJ6n8x2Q
         dPpX4a4DKnK4/w3QYVGdVQmHDeD7rlXo9HDowsMartr2FeZUGdtcrpDOIcW2e8s/mm0e
         f/pOKx8OjMM9uBHQMHKgeeFA9m79ZUHXjTtTjTi7MiuU8GpEkgpF79+/a2ejhRhOgNrW
         iHCA==
X-Gm-Message-State: AO0yUKVBvziY7U8vD2mNF4shxocAHNMVwmDa1EoyL7IGMnpcfHsJ95uo
        l4vQUJJlwQI2Z3DzVpR0Yee1Lwlo/BI=
X-Google-Smtp-Source: AK7set/XkzJe6v8Fwp4qwGPePLsgeGVy/aC/jLjdx7j/+esPIr6q1kdrgg93gN/k7q+6LJLhNk3Js+GC+vM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f993:b0:230:cff0:52ef with SMTP id
 cq19-20020a17090af99300b00230cff052efmr1200025pjb.81.1675888956026; Wed, 08
 Feb 2023 12:42:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Feb 2023 20:42:29 +0000
In-Reply-To: <20230208204230.1360502-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230208204230.1360502-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230208204230.1360502-2-seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: x86/pmu: Disable vPMU support on hybrid CPUs
 (host PMUs)
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jianfeng Gao <jianfeng.gao@intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable KVM support for virtualizing PMUs on hosts with hybrid PMUs until
KVM gains a sane way to enumeration the hybrid vPMU to userspace and/or
gains a mechanism to let userspace opt-in to the dangers of exposing a
hybrid vPMU to KVM guests.  Virtualizing a hybrid PMU, or at least part of
a hybrid PMU, is possible, but it requires careful, deliberate
configuration from userspace.

E.g. to expose full functionality, vCPUs need to be pinned to pCPUs to
prevent migrating a vCPU between a big core and a little core, userspace
must enumerate a reasonable topology to the guest, and guest CPUID must be
curated per vCPU to enumerate accurate vPMU capabilities.

The last point is especially problematic, as KVM doesn't control which
pCPU it runs on when enumerating KVM's vPMU capabilities to userspace,
i.e. userspace can't rely on KVM_GET_SUPPORTED_CPUID in it's current form.

Alternatively, userspace could enable vPMU support by enumerating the
set of features that are common and coherent across all cores, e.g. by
filtering PMU events and restricting guest capabilities.  But again, that
requires userspace to take action far beyond reflecting KVM's supported
feature set into the guest.

For now, simply disable vPMU support on hybrid CPUs to avoid inducing
seemingly random #GPs in guests, and punt support for hybrid CPUs to a
future enabling effort.

Reported-by: Jianfeng Gao <jianfeng.gao@intel.com>
Cc: stable@vger.kernel.org
Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Link: https://lore.kernel.org/all/20220818181530.2355034-1-kan.liang@linux.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.h | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index cdb91009701d..ee67ba625094 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -165,15 +165,27 @@ static inline void kvm_init_pmu_capability(void)
 {
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 
-	perf_get_x86_pmu_capability(&kvm_pmu_cap);
-
-	 /*
-	  * For Intel, only support guest architectural pmu
-	  * on a host with architectural pmu.
-	  */
-	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
+	/*
+	 * Hybrid PMUs don't play nice with virtualization without careful
+	 * configuration by userspace, and KVM's APIs for reporting supported
+	 * vPMU features do not account for hybrid PMUs.  Disable vPMU support
+	 * for hybrid PMUs until KVM gains a way to let userspace opt-in.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
 		enable_pmu = false;
 
+	if (enable_pmu) {
+		perf_get_x86_pmu_capability(&kvm_pmu_cap);
+
+		/*
+		 * For Intel, only support guest architectural pmu
+		 * on a host with architectural pmu.
+		 */
+		if ((is_intel && !kvm_pmu_cap.version) ||
+		    !kvm_pmu_cap.num_counters_gp)
+			enable_pmu = false;
+	}
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
-- 
2.39.1.519.gcb327c4b5f-goog

