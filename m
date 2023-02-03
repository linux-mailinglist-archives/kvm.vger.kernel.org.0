Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738BC68A036
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 18:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbjBCR2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 12:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjBCR2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 12:28:22 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D104299D5E
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 09:28:20 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id pj3so5703593pjb.1
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 09:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ivfgvtp7uyI6tFocYx9rlHpXWHlxTiWABls8e5bmayM=;
        b=cII6dLlsUwSoucT/nmPeQoMnw/26U3F9vvjbcZ4OHwLnNL7MbuUXkoVM614WvT3/u+
         MqRtckfcicHKnzzU/LhfSR1OWXypKA3bQUCHE2YxkBrtxTlr9se0FHvHU9dru6RvWwkr
         fIdN/XxhLiRVwp44QHsUjIdCONrA8NcoTzPMaRjOJ2kAIxjfnPCVJ+U8RvZcF0RH2rOZ
         hhdDQp9ZkW4voFM+ffTUQPTSpRsFVJImXLZggCnGX9UB9qBq0KDrMpEHIHjcI4MXGrB6
         jnwwQTSxmc6vsbxYcn8l5Y+nB0yyHq+z61YUEQRbt0gzDteCWzLUM/rJU/BjPDyPq2i3
         27ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ivfgvtp7uyI6tFocYx9rlHpXWHlxTiWABls8e5bmayM=;
        b=otF147tagGzpDdFOOzWkXttg3wTKKZTkRs+R2yt/pTe9EXcavAfV4HSA/OH4tUUIYZ
         XqcuiE3NnOrSQwsjj54JjE0WG3ikpEak4Yp/kesxFpzjhWQAcHTpgGtjg0BLBsoV/kRf
         5DCgESgijHlNmNt2cWnCcbZXDp7IH/uT5n1FgF6C71ku3suXk4rnDkQNmPbmb+Zr/H9F
         NYpGUgP/O3rWow3D+7wmyqdBerQoXkCZAvZ+92P6LhS4E4FEIybNpYEQAVikzXrz1RMq
         SX4QkTPUVhCScSHPXlZEgqpa2Kxd1YHK3sDs2afsIkrDkBc8E2qw3C7JCQc0RA5U6Jc7
         d68g==
X-Gm-Message-State: AO0yUKWDISLkotse+Nf46Tkqt+Vq5gr3Ej3Bw+s6Z7AGqf676IiA70ly
        NK4ojmA1lYYX7NbTKT0eeiUtNw==
X-Google-Smtp-Source: AK7set8pTRwRmGavRUH0Zl4ThwgbwvysCaK8vH1nc0DIWFJ9BC2u2xn5S1kIJOnjSBNVaYdUkyU+/A==
X-Received: by 2002:a17:902:f803:b0:198:af4f:de0f with SMTP id ix3-20020a170902f80300b00198af4fde0fmr123258plb.15.1675445300118;
        Fri, 03 Feb 2023 09:28:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y2-20020a62b502000000b00581013fcbe1sm2030578pfe.159.2023.02.03.09.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:28:19 -0800 (PST)
Date:   Fri, 3 Feb 2023 17:28:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianfeng Gao <jianfeng.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] KVM: x86/pmu: Disable all vPMU features support on
 Intel hybrid CPUs
Message-ID: <Y91DUmMjCLzIXlp+@google.com>
References: <20230131085031.88939-1-likexu@tencent.com>
 <Y9k7eyfmXjqW9lYF@google.com>
 <afe1fdd8-9f3e-c988-cd38-476a6da26d46@gmail.com>
 <Y9v7tEXPlki7YOT4@google.com>
 <7dc66398-aa0c-991f-3fa9-43aac8c710fd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dc66398-aa0c-991f-3fa9-43aac8c710fd@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023, Like Xu wrote:
> On 3/2/2023 2:06 am, Sean Christopherson wrote:
> > On Thu, Feb 02, 2023, Like Xu wrote:
> > > On 1/2/2023 12:02 am, Sean Christopherson wrote:
> > > The perf interface only provides host PMU capabilities and the logic for
> > > choosing to disable (or enable) vPMU based on perf input should be left
> > > in the KVM part so that subsequent development work can add most code
> > > to the just KVM, which is very helpful for downstream users to upgrade
> > > loadable KVM module rather than the entire core kernel.
> > > 
> > > My experience interacting with the perf subsystem has taught me that
> > > perf change required from KVM should be made as small as possible.
> > 
> > I don't disagree, but I don't think that's relevant in this case.  Perf doesn't
> > provide the necessary bits for KVM to virtualize a hybrid PMU, so unless KVM is
> > somehow able to get away with enumerating a very stripped down vPMU, additional
> > modifications to perf_get_x86_pmu_capability() will be required.
> > 
> > What I care more about though is this ugliness in perf_get_x86_pmu_capability():
> > 
> > 	/*
> > 	 * KVM doesn't support the hybrid PMU yet.
> > 	 * Return the common value in global x86_pmu,
> > 	 * which available for all cores.
> 
> I would have expected w/ current code base, vpmu (excluding pebs and lbr, intel_pt)
> to continue to work on any type of pCPU until you decide to disable them completely.

Didn't follow this.

> Moreover, the caller of perf_get_x86_pmu_capability() may be more than just KVM,
> it may be technically ebpf helpers. The diff on comments from v1 can be applied to
> this version (restrict KVM semantics), and it makes the status quo clearer
> to KVM users.

In that case, eBPF is just as hosed, no?  And given that the only people that have
touched perf_get_x86_pmu_capability() in its 11+ years of existence are all KVM
people, I have a hard time believing there is meaningful use outside of KVM.

> > 	 */
> > 	cap->num_counters_gp	= x86_pmu.num_counters;
> > 
> > I really don't want to leave that comment lying around as it's flat out wrong in
> > that it obviously doesn't address the other differences beyond the number of
> > counters.  And since there are dependencies on perf, my preference is to disable
> > PMU enumeration in perf specifically so that whoever takes on vPMU enabling is
> > forced to consider the perf side of things, and get buy in from the perf folks.
> 
> The perf_get_x86_pmu_capability() obviously needs to be revamped,
> but until real effective KVM enabling work arrives, any inconsequential intrusion
> into perf/core code will only lead to trivial system maintenance.

Trivial doesn't mean useless or unnecessary though.  IMO, there's value in capturing,
in code, that perf_get_x86_pmu_capability() doesn't properly support hybrid vPMUs.

That said, poking around perf, checking is_hybrid() is wrong.  This quirk suggests
that if E-cores are disabled via BIOS, (a) X86_FEATURE_HYBRID_CPU is _supposed_ to
be cleared, and (b) the base PMU will reflect the P-core PMU.  I.e. someone can
enable vPMU by disabling E-cores.

                /*
                 * Quirk: For some Alder Lake machine, when all E-cores are disabled in
                 * a BIOS, the leaf 0xA will enumerate all counters of P-cores. However,
                 * the X86_FEATURE_HYBRID_CPU is still set. The above codes will
                 * mistakenly add extra counters for P-cores. Correct the number of
                 * counters here.
                 */
                if ((pmu->num_counters > 8) || (pmu->num_counters_fixed > 4)) {
                        pmu->num_counters = x86_pmu.num_counters;
                        pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
                }

Side topic, someone (*cough* Intel) should fix that, e.g. detect the scenario
during boot and manually clear X86_FEATURE_HYBRID_CPU.

I'm also ok explicitly disabling support in KVM, but since we need to update
perf as well (that KVM comment needs to go), I don't see any reason not to also
update perf_get_x86_pmu_capability().

How about this?  Maybe split over two patches to separate the KVM and perf changes?

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 85a63a41c471..d096b04bf80e 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2974,17 +2974,19 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
-       if (!x86_pmu_initialized()) {
+       /* This API doesn't currently support enumerating hybrid PMUs. */
+       if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) ||
+           !x86_pmu_initialized()) {
                memset(cap, 0, sizeof(*cap));
                return;
        }
 
+       /*
+        * Note, hybrid CPU models get tracked as having hybrid PMUs even when
+        * all E-cores are disabled via BIOS.  When E-cores are disabled, the
+        * base PMU holds the correct number of counters for P-cores.
+        */
        cap->version            = x86_pmu.version;
-       /*
-        * KVM doesn't support the hybrid PMU yet.
-        * Return the common value in global x86_pmu,
-        * which available for all cores.
-        */
        cap->num_counters_gp    = x86_pmu.num_counters;
        cap->num_counters_fixed = x86_pmu.num_counters_fixed;
        cap->bit_width_gp       = x86_pmu.cntval_bits;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index cdb91009701d..933165663703 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -165,15 +165,27 @@ static inline void kvm_init_pmu_capability(void)
 {
        bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 
-       perf_get_x86_pmu_capability(&kvm_pmu_cap);
-
-        /*
-         * For Intel, only support guest architectural pmu
-         * on a host with architectural pmu.
-         */
-       if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
+       /*
+        * Hybrid PMUs don't play nice with virtualization unless userspace
+        * pins vCPUs _and_ can enumerate accurate informations to the guest.
+        * Disable vPMU support for hybrid PMUs until KVM gains a way to let
+        * userspace opt into the dangers of hybrid vPMUs.
+       */
+       if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
                enable_pmu = false;
 
+       if (enable_pmu) {
+               perf_get_x86_pmu_capability(&kvm_pmu_cap);
+
+               /*
+                * For Intel, only support guest architectural pmu
+                * on a host with architectural pmu.
+                */
+               if ((is_intel && !kvm_pmu_cap.version) ||
+                   !kvm_pmu_cap.num_counters_gp)
+                       enable_pmu = false;
+       }
+
        if (!enable_pmu) {
                memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
                return;

