Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7253460F5D0
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 13:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbiJ0LAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 07:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbiJ0LAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 07:00:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA6771BED
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 04:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666868410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ewpNeeK9teRIRP1chmCe5VEKG8+W3PiYqjJImOa83HA=;
        b=JWDGI5jeL0Zk9+chFAwEl5Kysz2g8+cNOkj9exfrKQMBkifZ2jtfgzbiuBeTmuxUS060YX
        Qb5mLG6LeAWnod6GfAhGfwMnrHm1WOCByyH4p+bhQhEPA0YSNgf0SXM2WjXdJdM8eiifgn
        IDLK1EZgth4KCicYjcLYiTPISJ07Jgg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-212e-TtjN3OwcO89Y06tBA-1; Thu, 27 Oct 2022 07:00:07 -0400
X-MC-Unique: 212e-TtjN3OwcO89Y06tBA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC876101A52A;
        Thu, 27 Oct 2022 11:00:06 +0000 (UTC)
Received: from starship (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 893D22166B26;
        Thu, 27 Oct 2022 11:00:05 +0000 (UTC)
Message-ID: <df085771c95517538f6056adfe6f5f656de5d2be.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 16/16] add IPI loss stress test
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 27 Oct 2022 14:00:04 +0300
In-Reply-To: <Y1bJMF7HV4QesDsl@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-17-mlevitsk@redhat.com>
         <Y1GuXoYm6JLpkUvq@google.com>
         <d20ce69105402e4adc9ba6cb2c922fa2653bc80a.camel@redhat.com>
         <Y1bJMF7HV4QesDsl@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-10-24 at 17:19 +0000, Sean Christopherson wrote:
> On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> > On Thu, 2022-10-20 at 20:23 +0000, Sean Christopherson wrote:
> > > On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > > > +static void wait_for_ipi(volatile u64 *count)
> > > > +{
> > > > +       u64 old_count = *count;
> > > > +       bool use_halt;
> > > > +
> > > > +       switch (hlt_allowed) {
> > > > +       case -1:
> > > > +               use_halt = get_random(0,10000) == 0;
> > > 
> > > Randomly doing "halt" is going to be annoying to debug.  What about tying the
> > > this decision to the iteration and then providing a knob to let the user specify
> > > the frequency?  It seems unlikely that this test will expose a bug that occurs
> > > if and only if the halt path is truly random.
> > 
> > This is stress test, it is pretty much impossible to debug, it is more like
> > pass/fail test.
> 
> There's a big difference between "hard to debug because there's a lot going on"
> and "hard to debug because failures are intermittent due to use of random numbers
> with no way to ensure a deterministic sequence.  I completely understand that this
> type of test is going to be really hard to debug, but that's argument for making
> the test as deterministic as possible, i.e. do what we can to make it slightly
> less awful to debug.

I agree with you mostly, but I think that using a PRNG and a seed is the best way
to acheeve both randomness and determenism at the same time.

> 
> > > > +                       asm volatile ("sti;nop;cli");
> > > 
> > > sti_nop_cli();
> > I think you mean sti_nop(); cli();
> 
> I was thinking we could add another helper since it's such a common pattern.

This is a good overall idea.

I;ll would call it process_pending_interrupts() with a comment that it
enables interrupts for one CPU cycle.

And BTW I also do use that semicolon, because I either forgot about the gcc rule
or I didn't knew about it. I'll fix it.


> 
> > > > +
> > > > +       } while (old_count == *count);
> > > 
> > > There's no need to loop in the use_halt case.  If KVM spuriously wakes the vCPU
> > > from halt, then that's a KVM bug.  Kinda ugly, but it does provide meaningfully
> > > coverage for the HLT case.
> > 
> > Nope - KVM does spuriously wake up the CPU, for example when the vCPU thread
> > recieves a signal and anything else that makes the kvm_vcpu_check_block
> > return -EINTR.
> 
> That doesn't (and shouldn't) wake the vCPU from the guest's perspective.  If/when
> userspace calls KVM_RUN again, the vCPU's state should still be KVM_MP_STATE_HALTED
> and thus KVM will invoke vcpu_block() until there is an actual wake event.

Well HLT is allowed to do suprious wakeups so KVM is allowed to not do it correclty,
so I thought that KVM doesn't do this correclty, but I glad to hear that it does.
Thanks for the explanation!

I'll test if my test passes if I remove the loop in the halt case.

> 
> This is something that KVM _must_ get correct,
> 
> > > > +static void wait_for_ipi_in_l2(volatile u64 *count, struct svm_vcpu *vcpu)
> > > > +{
> > > > +       u64 old_count = *count;
> > > > +       bool irq_on_vmentry = get_random(0,1) == 0;
> > > 
> > > Same concerns about using random numbers.
> > 
> > I can also add a parameter to force this to true/false, or better long term,
> > is to provide a PRNG and just seed it with either RDRAND or a userspace given number.
> > RDRAND retrived value can be even printed so that the test can be replayed.
> > 
> > You know just like the tools we both worked on at Intel did....
> > 
> > In fact I'll just do it - just need to pick some open source PRNG code.
> > Do you happen to know a good one? Mersenne Twister? 
> 
> It probably makes sense to use whatever we end up using for selftests[*] in order
> to minimize the code we have to maintain.
> 
> [*] https://lore.kernel.org/all/20221019221321.3033920-2-coltonlewis@google.com

Makes sense. I'll then just take this generator and adopt it to the kvm unit tests.
Or do you want to actually share the code? via a kernel header or something?

> 
> > > > +               // GIF is set by VMRUN
> > > > +               SVM_VMRUN(vcpu->vmcb, &vcpu->regs);
> > > > +               // GIF is cleared by VMEXIT
> > > > +               asm volatile("cli;nop;stgi");
> > > 
> > > Why re-enable GIF on every exit?
> > 
> > And why not? KVM does this on each VMRUN.
> 
> Because doing work for no discernible reason is confusing.  E.g. if this were a
> "real" hypervisor, it should also context switch CR2.

I agree that my justification for this was not correct, but I might still want
to have the gif toggling here, because I think it might add some value to the test.
I'll think about it.

> 
> KVM enables STGI because GIF=0 blocks _all_ interrupts, i.e. KVM needs to recognize
> NMI, SMI, #MC, etc... asap and even if KVM stays in its tight run loop.  For KUT,
> there should be never be an NMI, SMI, #MC, etc... and so no need to enable GIF.
> 
> I suppose you could make the argument that the test should set GIF when running on
> bare metal, but that's tenuous at best as SMI is the only event that isn't fatal to
> the test.
> 
> > > > +
> > > > +       printf("test started, waiting to end...\n");
> > > > +
> > > > +       while (cpus_active() > 1) {
> > > > +
> > > > +               unsigned long isr_count1, isr_count2;
> > > > +
> > > > +               isr_count1 = isr_counts[1];
> > > > +               delay(5ULL*1000*1000*1000);
> > > 
> > > Please add a macro or two for nanoseconds/milliseconds/seconds or whatever this
> > > expands to.
> > 
> > That is the problem - the delay is just in TSC freq units, and knowing TSC freq
> > for some reason on x86 is next to impossible on AMD
> 
> Ah, delay() takes the number cycles.  Ugh.
> 
> We should fix that, e.g. use the CPUID-provided frequency when possible (KVM should
> emulate this if it doesn't already), and then #define an arbitrary TSC frequency as
> a fall back so that we can write readable code, e.g. 2.4Ghz is probably close enough
> to work.

KVM doesn't emulate the Intel's specific way of reporting TSC freq on AMD.
In some sense this is wrong to do as it is Intel specific.

I do think that it is a great idea to report the TSC freq via some KVM specific MSR.
That might though open a pandora box in regard to migration.

I don't like the 2.4Ghz idea at all - it is once again corner cutting. Its true
that most code doens't need exact delay, not to mention that delay is never going
to be exact, but once you expose (nano)second based interface, test writers
will start to use it, and then wonder why someone hardcoded it to 2.4 GHz.

> 
> > > And why not have multi configs, e.g. to run with and without x2APIC?
> > 
> > Good idea as well, although I don't know if I want to slow down the kvm unit
> > tests run too much.
> 
> We should add a way to flag and omit all "slow" tests, e.g. vmx_vmcs_shadow_test
> takes an absurd amount of time and is uninteresting for the vast majority of changes.

This is a good idea as well.


Best regards,
	Maxim Levitsky

> 


