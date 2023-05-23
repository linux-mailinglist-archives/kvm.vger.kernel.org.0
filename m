Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6AF70E25B
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 18:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbjEWQnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 12:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237726AbjEWQnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 12:43:17 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DFE11A;
        Tue, 23 May 2023 09:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1684860177; x=1716396177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4cLn24dkdXYEj5ZgRvb+j624niie2xsz48lKPuQZSQs=;
  b=k+Y63rtPjf+1xh64dy4Uue9CI1xwKf1hEqmLNYE4pyS6HFZJQkjC5lMq
   DWP5REAx6N3rDhmHm1B4i7htDhQzPfj0zzk78Ymu+kzd0iVnkgjEe0C5p
   JPZrTfAXHUcmf+PQ7CUwLdmq/E0wIebcqDXxnZMlao1xLHJuk1AwRWZIc
   o=;
X-IronPort-AV: E=Sophos;i="6.00,186,1681171200"; 
   d="scan'208";a="215862704"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 16:42:54 +0000
Received: from EX19D016EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id 9ABD080C67;
        Tue, 23 May 2023 16:42:50 +0000 (UTC)
Received: from EX19D033EUC004.ant.amazon.com (10.252.61.133) by
 EX19D016EUA004.ant.amazon.com (10.252.50.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 23 May 2023 16:42:49 +0000
Received: from u40bc5e070a0153.ant.amazon.com (10.1.212.30) by
 EX19D033EUC004.ant.amazon.com (10.252.61.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 23 May 2023 16:42:46 +0000
Date:   Tue, 23 May 2023 18:42:40 +0200
From:   Roman Kagan <rkagan@amazon.de>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, <x86@kernel.org>,
        Eric Hankland <ehankland@google.com>,
        <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "kvm list" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
Message-ID: <ZGztAF1e5op6FlRQ@u40bc5e070a0153.ant.amazon.com>
Mail-Followup-To: Roman Kagan <rkagan@amazon.de>,
        Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Eric Hankland <ehankland@google.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <20230504120042.785651-1-rkagan@amazon.de>
 <de6acc7e-8e7f-2c54-11cc-822df4084719@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <de6acc7e-8e7f-2c54-11cc-822df4084719@gmail.com>
X-Originating-IP: [10.1.212.30]
X-ClientProxiedBy: EX19D042UWA003.ant.amazon.com (10.13.139.44) To
 EX19D033EUC004.ant.amazon.com (10.252.61.133)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 08:40:53PM +0800, Like Xu wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 4/5/2023 8:00 pm, Roman Kagan wrote:
> > Performance counters are defined to have width less than 64 bits.  The
> > vPMU code maintains the counters in u64 variables but assumes the value
> > to fit within the defined width.  However, for Intel non-full-width
> > counters (MSR_IA32_PERFCTRx) the value receieved from the guest is
> > truncated to 32 bits and then sign-extended to full 64 bits.  If a
> > negative value is set, it's sign-extended to 64 bits, but then in
> > kvm_pmu_incr_counter() it's incremented, truncated, and compared to the
> > previous value for overflow detection.
> 
> Thanks for reporting this issue. An easier-to-understand fix could be:
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index e17be25de6ca..51e75f121234 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -718,7 +718,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
> 
>  static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
>  {
> -       pmc->prev_counter = pmc->counter;
> +       pmc->prev_counter = pmc->counter & pmc_bitmask(pmc);
>        pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
>        kvm_pmu_request_counter_reprogram(pmc);
>  }
> 
> Considering that the pmu code uses pmc_bitmask(pmc) everywhere to wrap
> around, I would prefer to use this fix above first and then do a more thorough
> cleanup based on your below diff. What do you think ?

I did exactly this at first.  However, it felt more natural and easier
to reason about and less error-prone going forward, to maintain the
invariant that pmc->counter always fits in the assumed width.

> > That previous value is not truncated, so it always evaluates bigger than
> > the truncated new one, and a PMI is injected.  If the PMI handler writes
> > a negative counter value itself, the vCPU never quits the PMI loop.
> > 
> > Turns out that Linux PMI handler actually does write the counter with
> > the value just read with RDPMC, so when no full-width support is exposed
> > via MSR_IA32_PERF_CAPABILITIES, and the guest initializes the counter to
> > a negative value, it locks up.
> 
> Not really sure what the behavioral difference is between "it locks up" and
> "the vCPU never quits the PMI loop".

No difference, the second paragraph just illustrates the specific case
with Linux PMI handler and the system not exposing full-width counter
support so the problematic code path is triggered.

> > We observed this in the field, for example, when the guest configures
> > atop to use perfevents and runs two instances of it simultaneously.
> 
> A more essential case I found is this:
> 
>  kvm_msr: msr_write CTR1 = 0xffffffffffffffea
>  rdpmc on host: CTR1, value 0xffffffffffe3
>  kvm_exit: vcpu 0 reason EXCEPTION_NMI
>  kvm_msr: msr_read CTR1 = 0x83 // nmi_handler
> 
> There are two typical issues here:
> - the emulated counter value changed from 0xffffffffffffffffea to 0xffffffffffffe3,

Strange, why would the counter go backwards (disregarding the extra high
bits)?

>  triggering __kvm_perf_overflow(pmc, false);
> - PMI-handler should not reset the counter to a value that is easily overflowed,
>  in order to avoid overflow here before iret;

This is a legitimate guest behavior, isn't it?  The problem I'm trying
to fix is when the value written is sufficiently far from overflowing,
but it still ends up looking as an overflow and triggers a PMI.

> Please confirm whether your usage scenarios consist of these two types, or more.

The *usage* scenario is the one I wrote above.  I've identified an
easier repro since then:

  perf stat -e instructions -C 0 &
  sleep 1 && perf stat -e instructions,cycles -C 0 sleep 0.1 && kill -INT %

Please also see the kvm-unit-test I posted at
https://lore.kernel.org/kvm/20230504134908.830041-1-rkagan@amazon.de

> > To address the problem, maintain the invariant that the counter value
> > always fits in the defined bit width, by truncating the received value
> > in the respective set_msr methods.  For better readability, factor this
> > out into a helper function, pmc_set_counter, shared by vmx and svm
> > parts.
> > 
> > Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> > Signed-off-by: Roman Kagan <rkagan@amazon.de>
> 
> Tested-by: Like Xu <likexu@tencent.com>
> I prefer to use pmc_bitmask(pmc) to wrap around pmc->prev_counter as the first step.

My preference is to keep the counter within the limits all the time, so
I'd leave it up to the maintainers to decide.

Thanks,
Roman.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



