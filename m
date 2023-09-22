Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E327ABACE
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 23:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjIVVCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 17:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjIVVCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 17:02:36 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3D9AC
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 14:02:29 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1c3cbfa40d6so25185515ad.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 14:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695416549; x=1696021349; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oYeUPedmUmta8Pk5u7ab1pPduSHhfb3/Gf+TT/G9pzE=;
        b=eMnYA82duWTKo/urPjFqMlTEGn3ttfRgWU1Ty+7ELkepATVBQldspXoOIru2TXIoWc
         CUjjSfvYwLPk9A/h2luzIahI7v+NAY7+RUCRmF/ngT0nmj2lnfhxdVMKprEthhRf1FdZ
         EPtpWRLwhMUqdXONUAPbxhbDVih7gN7JWt6MiAAqshaZxFcdnCOMJyD5VgTNF8TEBXPD
         x50M9+OrqPR896r5BbyDepJgWmueZCzsHlBSQjaJALQS7MOi3W3eUdQYc5iYypJQLEm6
         iz+G6iEKZKu12r+LJXNNlZ03/74lNNndLeNWFBv6cRdhx0nd7ocPGW0F2PmoIRo3PQuM
         H1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695416549; x=1696021349;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oYeUPedmUmta8Pk5u7ab1pPduSHhfb3/Gf+TT/G9pzE=;
        b=lGkHHMPA8gxkeP/PjiabQXXfArL05YYbDAAtf8KiZ6/D+WRLriUBgXdGhBsQz+mwE9
         Wb1FozriQaufC5rmKuzXUCpwfDlNgiWSDu+sLSqQSEP8rkZYQCthdsSMTeGRehefUvZy
         itRd0J5CwwaysFZtInvgcUsgbD8fDK+dxLG3br8AA7C5p/pbH9oUBBGJZl/U1Ee8bbD+
         1fOIcEr7NUU/PBQRRznN3dMKDU0BH40fgimm6rAJZXYCJX/HydhoP7ISsqHag2vkvaN4
         qjmcMduzNV1lWLYQQUMQ6E+0Nq9ixRy8KlGV/+p7CLA5bU3WhMumyWB/JUdxOhu1n9wb
         dlkg==
X-Gm-Message-State: AOJu0Yy8vzvDzyv8viboLBScbkq41PG5tJH4yhTqoPfChSwVSmsB8OPl
        wPoxsVqDnuhRsPz80gi0ZP5Ixg==
X-Google-Smtp-Source: AGHT+IGEbsmgLYdpqDRgytrhH1mBp3ExUkGi0qcTM1lRHh3ZXa+WfSlKpPEPf5+z+7w5Koe1Ls9UIw==
X-Received: by 2002:a17:903:120a:b0:1c4:2641:7744 with SMTP id l10-20020a170903120a00b001c426417744mr710753plh.25.1695416548934;
        Fri, 22 Sep 2023 14:02:28 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id kg14-20020a170903060e00b001b06c106844sm3964557plb.151.2023.09.22.14.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 14:02:28 -0700 (PDT)
Date:   Fri, 22 Sep 2023 21:02:24 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
Message-ID: <ZQ4A4KaSyygKHDUI@google.com>
References: <20230901185646.2823254-1-jmattson@google.com>
 <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com>
 <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com>
 <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> On Fri, Sep 22, 2023 at 1:34 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > > On Fri, Sep 22, 2023 at 12:21 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Fri, Sep 22, 2023, Jim Mattson wrote:
> > > > > On Fri, Sep 22, 2023 at 11:46 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > > >
> > > > > > On Fri, Sep 01, 2023, Jim Mattson wrote:
> > > > > > > When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
> > > > > > > VM-exit that also invokes __kvm_perf_overflow() as a result of
> > > > > > > instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> > > > > > > before the next VM-entry.
> > > > > > >
> > > > > > > That shouldn't be a problem. The local APIC is supposed to
> > > > > > > automatically set the mask flag in LVTPC when it handles a PMI, so the
> > > > > > > second PMI should be inhibited. However, KVM's local APIC emulation
> > > > > > > fails to set the mask flag in LVTPC when it handles a PMI, so two PMIs
> > > > > > > are delivered via the local APIC. In the common case, where LVTPC is
> > > > > > > configured to deliver an NMI, the first NMI is vectored through the
> > > > > > > guest IDT, and the second one is held pending. When the NMI handler
> > > > > > > returns, the second NMI is vectored through the IDT. For Linux guests,
> > > > > > > this results in the "dazed and confused" spurious NMI message.
> > > > > > >
> > > > > > > Though the obvious fix is to set the mask flag in LVTPC when handling
> > > > > > > a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> > > > > > > convoluted.
> > > > > >
> > > > > > To address Like's question about whether not this is necessary, I think we should
> > > > > > rephrase this to explicitly state this is a bug irrespective of the whole LVTPC
> > > > > > masking thing.
> > > > > >
> > > > > > And I think it makes sense to swap the order of the two patches.  The LVTPC masking
> > > > > > fix is a clearcut architectural violation.  This is a bit more of a grey area,
> > > > > > though still blatantly buggy.
> > > > >
> > > > > The reason I ordered the patches as I did is that when this patch
> > > > > comes first, it actually fixes the problem that was introduced in
> > > > > commit 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring
> > > > > instructions"). If this patch comes second, it's less clear that it
> > > > > fixes a bug, since the other patch renders this one essentially moot.
> > > >
> > > > Yeah, but as Like pointed out, the way the changelog is worded just raises the
> > > > question of why this change is necessary.
> > > >
> > > > I think we should tag them both for stable.  They're both bug fixes, regardless
> > > > of the ordering.
> > >
> > > Agree. Both patches are fixing the general potential buggy situation
> > > of multiple PMI injection on one vm entry: one software level defense
> > > (forcing the usage of KVM_REQ_PMI) and one hardware level defense
> > > (preventing PMI injection using mask).
> > >
> > > Although neither patch in this series is fixing the root cause of this
> > > specific double PMI injection bug, I don't see a reason why we cannot
> > > add a "fixes" tag to them, since we may fix it and create it again.
> > >
> > > I am currently working on it and testing my patch. Please give me some
> > > time, I think I could try sending out one version today. Once that is
> > > done, I will combine mine with the existing patch and send it out as a
> > > series.
> >
> > Me confused, what patch?  And what does this patch have to do with Jim's series?
> > Unless I've missed something, Jim's patches are good to go with my nits addressed.
> 
> Let me step back.
> 
> We have the following problem when we run perf inside guest:
> 
> [ 1437.487320] Uhhuh. NMI received for unknown reason 20 on CPU 3.
> [ 1437.487330] Dazed and confused, but trying to continue
> 
> This means there are more NMIs that guest PMI could understand. So
> there are potentially two approaches to solve the problem: 1) fix the
> PMI injection issue: only one can be injected; 2) fix the code that
> causes the (incorrect) multiple PMI injection.
> 
> I am working on the 2nd one. So, the property of the 2nd one is:
> without patches in 1) (Jim's patches), we could still avoid the above
> warning messages.
> 
> Thanks.
> -Mingwei

This is my draft version. If you don't have full-width counter support, this
patch needs be placed on top of this one:
https://lore.kernel.org/all/20230504120042.785651-1-rkagan@amazon.de/

My initial testing on both QEMU and our GCP testing environment shows no
"Uhhuh..." dmesg in guest.

Please take a look...

From 47e629269d8b0ff65c242334f068300216cb7f91 Mon Sep 17 00:00:00 2001
From: Mingwei Zhang <mizhang@google.com>
Date: Fri, 22 Sep 2023 17:13:55 +0000
Subject: [PATCH] KVM: x86/pmu: Fix emulated counter increment due to
 instruction emulation

Fix KVM emulated counter increment due to instruction emulation. KVM
pmc->counter is always a snapshot value when counter is running. Therefore,
the value does not represent the actual value of counter. Thus it is
inappropriate to compare it with other counter values. In existing code
KVM directly compares pmc->prev_counter and pmc->counter directly. However,
pmc->prev_counter is a snaphot value assigned from pmc->counter when
counter may still be running.  So this comparison logic in
reprogram_counter() will generate incorrect invocations to
__kvm_perf_overflow(in_pmi=false) and generate duplicated PMI injection
requests.

Fix this issue by adding emulated_counter field and only the do the counter
calculation after we pause

Change-Id: I2d59e68557fd35f7bbcfe09ea42ad81bd36776b7
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 15 ++++++++-------
 arch/x86/kvm/svm/pmu.c          |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    |  2 ++
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..47bbfbc0aa35 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -494,6 +494,7 @@ struct kvm_pmc {
 	bool intr;
 	u64 counter;
 	u64 prev_counter;
+	u64 emulated_counter;
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edb89b51b383..47acf3a2b077 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -240,12 +240,13 @@ static void pmc_pause_counter(struct kvm_pmc *pmc)
 {
 	u64 counter = pmc->counter;

-	if (!pmc->perf_event || pmc->is_paused)
-		return;
-
 	/* update counter, reset event value to avoid redundant accumulation */
-	counter += perf_event_pause(pmc->perf_event, true);
-	pmc->counter = counter & pmc_bitmask(pmc);
+	if (pmc->perf_event && !pmc->is_paused)
+		counter += perf_event_pause(pmc->perf_event, true);
+
+	pmc->prev_counter = counter & pmc_bitmask(pmc);
+	pmc->counter = (counter + pmc->emulated_counter) & pmc_bitmask(pmc);
+	pmc->emulated_counter = 0;
 	pmc->is_paused = true;
 }

@@ -452,6 +453,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 reprogram_complete:
 	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
 	pmc->prev_counter = 0;
+	pmc->emulated_counter = 0;
 }

 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
@@ -725,8 +727,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)

 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
-	pmc->prev_counter = pmc->counter;
-	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
+	pmc->emulated_counter += 1;
 	kvm_pmu_request_counter_reprogram(pmc);
 }

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index a25b91ff9aea..b88fab4ae1d7 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -243,6 +243,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)

 		pmc_stop_counter(pmc);
 		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
+		pmc->emulated_counter = 0;
 	}

 	pmu->global_ctrl = pmu->global_status = 0;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 626df5fdf542..d03c4ec7273d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -641,6 +641,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)

 		pmc_stop_counter(pmc);
 		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
+		pmc->emulated_counter = 0;
 	}

 	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
@@ -648,6 +649,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)

 		pmc_stop_counter(pmc);
 		pmc->counter = pmc->prev_counter = 0;
+		pmc->emulated_counter = 0;
 	}

 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
--
2.42.0.515.g380fc7ccd1-goog
