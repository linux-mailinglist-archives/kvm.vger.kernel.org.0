Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB360B5CE
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 20:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiJXSkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 14:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiJXSkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 14:40:02 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E555578AF
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 10:22:05 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id s22-20020a17090a075600b002130d2ad62aso2800577pje.2
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 10:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AtQuDUARxlCh73hPuBPsqQZ+KcXq6YI07Q3eEDwHdKw=;
        b=Mj1p/DZ0QLFNlOYCnq7Fo6K1Gie1shnIuH8mVCMkmUM/4lGllg1dSDDthPrVhMJpO7
         yb8tXaxFTO0Z8hDmJ5Pu7LOYLyMPYOwWr4M5YiZLgxiViFjVNbtP19SINvAT3ftmoZhP
         ZNPl2QxnpHiJroqVN6YAMkJCItyb/d7Gg8POQEffAiU/B88zTCgg+YPaiUsqMRBg2bHF
         O8+dF/MIzdPYETlOxGsG1cZjIdNCNO3blIwWYTjAAs/gnaIvBPlRqOBqvnuefRFAdtdk
         T3BERhko5/YtkLDNMjLX8zmnI/8unmsGlZkOHmQKv3wLx0PS9qQHC3riGS6K9AMOnN9C
         gVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AtQuDUARxlCh73hPuBPsqQZ+KcXq6YI07Q3eEDwHdKw=;
        b=tAMbSdaTyMPeEbhq6zovd5QZbQgrza/zD91Mr0H1N71Q8qo+WBibEXhwfgjDOL7Aj/
         lbEg2lKaRP19UMmfHqESOdL1KmELCEGJeOmknnHKaC7jNiZnj4VurLKVEEzPWU3xXgup
         LT+vtttqUG0x/vPlCE/Fv2ILayhmWSgCH2dL+RArWkDEMrzgJmAIe8bsTf3mlFXCumLd
         WgK0MB1ulKc1KKmpeDbo7K0yBIfdSb4KjN4n8XmtnbnBGIwaqSlX8RBVhPti7/HNUD5T
         WicRYH+0xia4rBy8+PI5w9W0e/xUFDFGsXFo8PtgxIGr6BmE5+1/xTXWGV3mGJA0pclL
         Gq+Q==
X-Gm-Message-State: ACrzQf3ombexe1Ov2VvPnzuDAq0kBUuQjm1BVQbJZ8k0HD0zFt5/W2K3
        5D8UQrfvJItfnVNSrLczMm1Lrg==
X-Google-Smtp-Source: AMsMyM7nHpXnTX4ANbH9BFcwSwjCwOLUWz3M+e2i+3QAb5p3ng9b0Nzw5W1YrjpEJGGRo/EQwChxzg==
X-Received: by 2002:a17:90b:2317:b0:213:26a3:246f with SMTP id mt23-20020a17090b231700b0021326a3246fmr3396299pjb.148.1666631988503;
        Mon, 24 Oct 2022 10:19:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a17090a6b4b00b0020ddea12227sm4122438pjl.55.2022.10.24.10.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 10:19:48 -0700 (PDT)
Date:   Mon, 24 Oct 2022 17:19:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 16/16] add IPI loss stress test
Message-ID: <Y1bJMF7HV4QesDsl@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-17-mlevitsk@redhat.com>
 <Y1GuXoYm6JLpkUvq@google.com>
 <d20ce69105402e4adc9ba6cb2c922fa2653bc80a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d20ce69105402e4adc9ba6cb2c922fa2653bc80a.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> On Thu, 2022-10-20 at 20:23 +0000, Sean Christopherson wrote:
> > On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > > +static void wait_for_ipi(volatile u64 *count)
> > > +{
> > > +       u64 old_count = *count;
> > > +       bool use_halt;
> > > +
> > > +       switch (hlt_allowed) {
> > > +       case -1:
> > > +               use_halt = get_random(0,10000) == 0;
> > 
> > Randomly doing "halt" is going to be annoying to debug.  What about tying the
> > this decision to the iteration and then providing a knob to let the user specify
> > the frequency?  It seems unlikely that this test will expose a bug that occurs
> > if and only if the halt path is truly random.
> 
> This is stress test, it is pretty much impossible to debug, it is more like
> pass/fail test.

There's a big difference between "hard to debug because there's a lot going on"
and "hard to debug because failures are intermittent due to use of random numbers
with no way to ensure a deterministic sequence.  I completely understand that this
type of test is going to be really hard to debug, but that's argument for making
the test as deterministic as possible, i.e. do what we can to make it slightly
less awful to debug.

> > > +                       asm volatile ("sti;nop;cli");
> > 
> > sti_nop_cli();
> I think you mean sti_nop(); cli();

I was thinking we could add another helper since it's such a common pattern.

> > > +
> > > +       } while (old_count == *count);
> > 
> > There's no need to loop in the use_halt case.  If KVM spuriously wakes the vCPU
> > from halt, then that's a KVM bug.  Kinda ugly, but it does provide meaningfully
> > coverage for the HLT case.
> 
> Nope - KVM does spuriously wake up the CPU, for example when the vCPU thread
> recieves a signal and anything else that makes the kvm_vcpu_check_block
> return -EINTR.

That doesn't (and shouldn't) wake the vCPU from the guest's perspective.  If/when
userspace calls KVM_RUN again, the vCPU's state should still be KVM_MP_STATE_HALTED
and thus KVM will invoke vcpu_block() until there is an actual wake event.

This is something that KVM _must_ get correct,

> > > +static void wait_for_ipi_in_l2(volatile u64 *count, struct svm_vcpu *vcpu)
> > > +{
> > > +       u64 old_count = *count;
> > > +       bool irq_on_vmentry = get_random(0,1) == 0;
> > 
> > Same concerns about using random numbers.
> 
> I can also add a parameter to force this to true/false, or better long term,
> is to provide a PRNG and just seed it with either RDRAND or a userspace given number.
> RDRAND retrived value can be even printed so that the test can be replayed.
> 
> You know just like the tools we both worked on at Intel did....
> 
> In fact I'll just do it - just need to pick some open source PRNG code.
> Do you happen to know a good one? Mersenne Twister? 

It probably makes sense to use whatever we end up using for selftests[*] in order
to minimize the code we have to maintain.

[*] https://lore.kernel.org/all/20221019221321.3033920-2-coltonlewis@google.com

> > > +               // GIF is set by VMRUN
> > > +               SVM_VMRUN(vcpu->vmcb, &vcpu->regs);
> > > +               // GIF is cleared by VMEXIT
> > > +               asm volatile("cli;nop;stgi");
> > 
> > Why re-enable GIF on every exit?
> 
> And why not? KVM does this on each VMRUN.

Because doing work for no discernible reason is confusing.  E.g. if this were a
"real" hypervisor, it should also context switch CR2.

KVM enables STGI because GIF=0 blocks _all_ interrupts, i.e. KVM needs to recognize
NMI, SMI, #MC, etc... asap and even if KVM stays in its tight run loop.  For KUT,
there should be never be an NMI, SMI, #MC, etc... and so no need to enable GIF.

I suppose you could make the argument that the test should set GIF when running on
bare metal, but that's tenuous at best as SMI is the only event that isn't fatal to
the test.

> > > +
> > > +       printf("test started, waiting to end...\n");
> > > +
> > > +       while (cpus_active() > 1) {
> > > +
> > > +               unsigned long isr_count1, isr_count2;
> > > +
> > > +               isr_count1 = isr_counts[1];
> > > +               delay(5ULL*1000*1000*1000);
> > 
> > Please add a macro or two for nanoseconds/milliseconds/seconds or whatever this
> > expands to.
> 
> That is the problem - the delay is just in TSC freq units, and knowing TSC freq
> for some reason on x86 is next to impossible on AMD

Ah, delay() takes the number cycles.  Ugh.

We should fix that, e.g. use the CPUID-provided frequency when possible (KVM should
emulate this if it doesn't already), and then #define an arbitrary TSC frequency as
a fall back so that we can write readable code, e.g. 2.4Ghz is probably close enough
to work.

> > And why not have multi configs, e.g. to run with and without x2APIC?
> 
> Good idea as well, although I don't know if I want to slow down the kvm unit
> tests run too much.

We should add a way to flag and omit all "slow" tests, e.g. vmx_vmcs_shadow_test
takes an absurd amount of time and is uninteresting for the vast majority of changes.
