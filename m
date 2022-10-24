Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC3160B94A
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 22:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiJXUIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 16:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiJXUHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 16:07:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1080D80525
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 11:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666636005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JiJmPY+idV7JJrzbMHMqiqrQtQYa2lTI3Nz+yNlVdys=;
        b=C1RP76xxFTcgcs9gI6kxrgz+Ix8Q/8yuvmG/id3cU4QGoPA0GQ0tPUoNunnaC9Q/sa9QQC
        seBlRthj7Z9xxJ/VzB4jGEuEvlBBO63CyODrzuwktAfxC5qThcnpY82Q+wjbyoaIVprCcB
        h/z1Gz2oq4oVjNEfw1LD2D8hCtV2BZE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-219-pYMGrGGGNhKmejpHUl9fYQ-1; Mon, 24 Oct 2022 08:54:41 -0400
X-MC-Unique: pYMGrGGGNhKmejpHUl9fYQ-1
Received: by mail-qt1-f197.google.com with SMTP id k9-20020ac85fc9000000b00399e6517f9fso6943967qta.18
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JiJmPY+idV7JJrzbMHMqiqrQtQYa2lTI3Nz+yNlVdys=;
        b=5y2rjjV4k3F64dRp0833KVsVHJJLbcXhv48IhBCy0O/YvyeIYPM6iLeLEcb4go9Db7
         qb+XITlHDuCtxXtsdsHQtGs28SZH2SPqToYUvNNGSzDrytq1wDXIlnpXHENinj+qDLrB
         MWjlBSgP8AvzvwuOpAcOeeCYoWMh1SMg/V2p9HC89liOVPeNDg2bQOuF3Qm0XBxIQUco
         4BpjA22kIQymBlvcikWmC9h8J+leb6R5hhMSC3LxxiLP+ULTUY4rwvwVuQRdfO2PSX+W
         iccc3GmtHpJqj7SrqsNI0b785+Ex4PG2X1NqgKGLvXlE7z30IGiDr5wvFPaArwBo1E7E
         TmIw==
X-Gm-Message-State: ACrzQf3ucvQdG7GpFX2bQ8dh2f66HITNBdQOFDftKHsUM6URS/93Un9V
        8Zaq38oYdC9OvDXdCtVNRCAO3+xLJtCxca5JE4am85B6X70XU2GmUpm+re1iihWhJt+xxgXLnQ1
        9gXKA4wm/149e
X-Received: by 2002:a05:620a:67b:b0:6cd:1bce:47e1 with SMTP id a27-20020a05620a067b00b006cd1bce47e1mr22620458qkh.666.1666616080189;
        Mon, 24 Oct 2022 05:54:40 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4ctTl7ud4Kw7TnIo1bEFwcpEstaiS/VPU6lAMm29mIKSbJNyFYlyXOah0uoDacBIKeBDaRyg==
X-Received: by 2002:a05:620a:67b:b0:6cd:1bce:47e1 with SMTP id a27-20020a05620a067b00b006cd1bce47e1mr22620444qkh.666.1666616079844;
        Mon, 24 Oct 2022 05:54:39 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id y13-20020a37f60d000000b006e2d087fd63sm14713729qkj.63.2022.10.24.05.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:54:39 -0700 (PDT)
Message-ID: <d20ce69105402e4adc9ba6cb2c922fa2653bc80a.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 16/16] add IPI loss stress test
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Oct 2022 15:54:36 +0300
In-Reply-To: <Y1GuXoYm6JLpkUvq@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-17-mlevitsk@redhat.com>
         <Y1GuXoYm6JLpkUvq@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 20:23 +0000, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > +u64 num_iterations = -1;
> 
> "Run indefinitely" is an odd default.  Why not set the default number of iterations
> to something reasonable and then let the user override that if the user wants to
> run for an absurdly long time?
> 
> > +
> > +volatile u64 *isr_counts;
> > +bool use_svm;
> > +int hlt_allowed = -1;
> 
> These can all be static.
> 
> > +
> > +static int get_random(int min, int max)
> > +{
> > +       /* TODO : use rdrand to seed an PRNG instead */
> > +       u64 random_value = rdtsc() >> 4;
> > +
> > +       return min + random_value % (max - min + 1);
> > +}
> > +
> > +static void ipi_interrupt_handler(isr_regs_t *r)
> > +{
> > +       isr_counts[smp_id()]++;
> > +       eoi();
> > +}
> > +
> > +static void wait_for_ipi(volatile u64 *count)
> > +{
> > +       u64 old_count = *count;
> > +       bool use_halt;
> > +
> > +       switch (hlt_allowed) {
> > +       case -1:
> > +               use_halt = get_random(0,10000) == 0;
> 
> Randomly doing "halt" is going to be annoying to debug.  What about tying the
> this decision to the iteration and then providing a knob to let the user specify
> the frequency?  It seems unlikely that this test will expose a bug that occurs
> if and only if the halt path is truly random.

This is stress test, it is pretty much impossible to debug, it is more like pass/fail test.
In addition to that as you see in the switch below the use_halt is trinary boolean,
it can be 0, 1 and -1, and the -1 means random, while 0,1 means that it will alway use halt.


> 
> > +               break;
> > +       case 0:
> > +               use_halt = false;
> > +               break;
> > +       case 1:
> > +               use_halt = true;
> > +               break;
> > +       default:
> > +               use_halt = false;
> > +               break;
> > +       }
> > +
> > +       do {
> > +               if (use_halt)
> > +                       asm volatile ("sti;hlt;cli\n");
> 
> safe_halt();
OK.

> 
> > +               else
> > +                       asm volatile ("sti;nop;cli");
> 
> sti_nop_cli();
I think you mean sti_nop(); cli();


> 
> > +
> > +       } while (old_count == *count);
> 
> There's no need to loop in the use_halt case.  If KVM spuriously wakes the vCPU
> from halt, then that's a KVM bug.  Kinda ugly, but it does provide meaningfully
> coverage for the HLT case.

Nope - KVM does spuriously wake up the CPU, for example when the vCPU thread recieves a signal
and anything else that makes the kvm_vcpu_check_block return -EINTR.


> 
>         if (use_halt) {
>                 safe_halt();
>                 cli();
>         } else {
>                 do {
>                         sti_nop_cli();
>                 } while (old_count == *count);
>         }
> 
>         assert(*count == old_count + 1);
> 
> > +}
> > +
> > +/******************************************************************************************************/
> > +
> > +#ifdef __x86_64__
> > +
> > +static void l2_guest_wait_for_ipi(volatile u64 *count)
> > +{
> > +       wait_for_ipi(count);
> > +       asm volatile("vmmcall");
> > +}
> > +
> > +static void l2_guest_dummy(void)
> > +{
> > +       asm volatile("vmmcall");
> > +}
> > +
> > +static void wait_for_ipi_in_l2(volatile u64 *count, struct svm_vcpu *vcpu)
> > +{
> > +       u64 old_count = *count;
> > +       bool irq_on_vmentry = get_random(0,1) == 0;
> 
> Same concerns about using random numbers.

I can also add a parameter to force this to true/false, or better long term,
is to provide a PRNG and just seed it with either RDRAND or a userspace given number.
RDRAND retrived value can be even printed so that the test can be replayed.

You know just like the tools we both worked on at Intel did....

In fact I'll just do it - just need to pick some open source PRNG code.
Do you happen to know a good one? Mersenne Twister? 

> 
> > +
> > +       vcpu->vmcb->save.rip = (ulong)l2_guest_wait_for_ipi;
> > +       vcpu->regs.rdi = (u64)count;
> > +
> > +       vcpu->vmcb->save.rip = irq_on_vmentry ? (ulong)l2_guest_dummy : (ulong)l2_guest_wait_for_ipi;
> > +
> > +       do {
> > +               if (irq_on_vmentry)
> > +                       vcpu->vmcb->save.rflags |= X86_EFLAGS_IF;
> > +               else
> > +                       vcpu->vmcb->save.rflags &= ~X86_EFLAGS_IF;
> > +
> > +               asm volatile("clgi;nop;sti");
> 
> Why a NOP between CLGI and STI?  And why re-enable GIF on each iteration?

Its a remain from the days I was too lazy to check which instructions have interrupt window.
Also still using comma here. I'll fix this.


> 
> > +               // GIF is set by VMRUN
> > +               SVM_VMRUN(vcpu->vmcb, &vcpu->regs);
> > +               // GIF is cleared by VMEXIT
> > +               asm volatile("cli;nop;stgi");
> 
> Why re-enable GIF on every exit?

And why not? KVM does this on each VMRUN.

> 
> > +
> > +               assert(vcpu->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> > +
> > +       } while (old_count == *count);
> 
> Isn't the loop only necessary in the irq_on_vmentry case?

Yes it is - the interrupts come from a different vCPU, so entering
the guest with IF set doesn't guarantee that it will get an
interrupt instantly, but the other way around is true,
with IF clear it will alway get the interrupt only after it set it later
in wait_for_ipi(). 

I need to rename irq_on_vmentry to IF_set_on_vmentry, or something.



> 
> static void run_svm_l2(...)
> {
>         SVM_VMRUN(vcpu->vmcb, &vcpu->regs);
>         assert(vcpu->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> }
> 
> E.g. can't this be:
> 
>         bool irq_on_vmentry = ???;
>         u64 old_count = *count;
> 
>         clgi();
>         sti();
> 
>         vcpu->regs.rdi = (u64)count;
> 
>         if (!irq_on_vmentry) {
>                 vcpu->vmcb->save.rip = (ulong)l2_guest_wait_for_ipi;
>                 vcpu->vmcb->save.rflags &= ~X86_EFLAGS_IF;
>                 run_svm_l2(...);
>         } else {
>                 vcpu->vmcb->save.rip = (ulong)l2_guest_dummy
>                 vcpu->vmcb->save.rflags |= X86_EFLAGS_IF;
>                 do {
>                         run_svm_l2(...);
>                 } while (old_count == *count);
>         }
> 
>         assert(*count == old_count + 1);
>         cli();
>         stgi();
> 
> > +}
> > +#endif
> > +
> > +/******************************************************************************************************/
> > +
> > +#define FIRST_TEST_VCPU 1
> > +
> > +static void vcpu_init(void *data)
> > +{
> > +       /* To make it easier to see iteration number in the trace */
> > +       handle_irq(0x40, ipi_interrupt_handler);
> > +       handle_irq(0x50, ipi_interrupt_handler);
> 
> Why not make it even more granular?  E.g. do vector == 32 + (iteration % ???)
> Regardless, a #define for the (base) vector would be helpful, the usage in
> vcpu_code() is a bit magical.

Don't see why not, but usually two vectors is enough. I can replace the magic
numbers with #defines.

> 
> 
> > +}
> > +
> > +static void vcpu_code(void *data)
> > +{
> > +       int ncpus = cpu_count();
> > +       int cpu = (long)data;
> > +#ifdef __x86_64__
> > +       struct svm_vcpu vcpu;
> > +#endif
> > +
> > +       u64 i;
> > +
> > +#ifdef __x86_64__
> > +       if (cpu == 2 && use_svm)
> 
> Why only CPU2?

Remain from the days when I had no code to run multiple guests.



> 
> > +               svm_vcpu_init(&vcpu);
> > +#endif
> > +
> > +       assert(cpu != 0);
> > +
> > +       if (cpu != FIRST_TEST_VCPU)
> > +               wait_for_ipi(&isr_counts[cpu]);
> > +
> > +       for (i = 0; i < num_iterations; i++)
> > +       {
> > +               u8 physical_dst = cpu == ncpus -1 ? 1 : cpu + 1;
> 
> Space after the '-'.
OK.

> 
> > +
> > +               // send IPI to a next vCPU in a circular fashion
> > +               apic_icr_write(APIC_INT_ASSERT |
> > +                               APIC_DEST_PHYSICAL |
> > +                               APIC_DM_FIXED |
> > +                               (i % 2 ? 0x40 : 0x50),
> > +                               physical_dst);
> > +
> > +               if (i == (num_iterations - 1) && cpu != FIRST_TEST_VCPU)
> > +                       break;
> > +
> > +#ifdef __x86_64__
> > +               // wait for the IPI interrupt chain to come back to us
> > +               if (cpu == 2 && use_svm) {
> > +                               wait_for_ipi_in_l2(&isr_counts[cpu], &vcpu);
> 
> Indentation is funky.
OK.
> 
> > +                               continue;
> > +               }
> > +#endif
> > +               wait_for_ipi(&isr_counts[cpu]);
> > +       }
> > +}
> > +
> > +int main(int argc, void** argv)
> > +{
> > +       int cpu, ncpus = cpu_count();
> > +
> > +       assert(ncpus > 2);
> > +
> > +       if (argc > 1)
> > +               hlt_allowed = atol(argv[1]);
> > +
> > +       if (argc > 2)
> > +               num_iterations = atol(argv[2]);
> > +
> > +       setup_vm();
> > +
> > +#ifdef __x86_64__
> > +       if (svm_supported()) {
> > +               use_svm = true;
> > +               setup_svm();
> > +       }
> > +#endif
> > +
> > +       isr_counts = (volatile u64 *)calloc(ncpus, sizeof(u64));
> > +
> > +       printf("found %d cpus\n", ncpus);
> > +       printf("running for %lld iterations - test\n",
> > +               (long long unsigned int)num_iterations);
> > +
> > +
> > +       for (cpu = 0; cpu < ncpus; ++cpu)
> > +               on_cpu_async(cpu, vcpu_init, (void *)(long)cpu);
> > +
> > +       /* now let all the vCPUs end the IPI function*/
> > +       while (cpus_active() > 1)
> > +                 pause();
> > +
> > +       printf("starting test on all cpus but 0...\n");
> > +
> > +       for (cpu = ncpus-1; cpu >= FIRST_TEST_VCPU; cpu--)
> 
> Spaces around the '-'.

I will find a way to run checkpatch.pl on the patches...

> 
> > +               on_cpu_async(cpu, vcpu_code, (void *)(long)cpu);
> 
> Why not use smp_id() in vcpu_code()?  ipi_interrupt_handler() already relies on
> that being correct.
> 
> > +
> > +       printf("test started, waiting to end...\n");
> > +
> > +       while (cpus_active() > 1) {
> > +
> > +               unsigned long isr_count1, isr_count2;
> > +
> > +               isr_count1 = isr_counts[1];
> > +               delay(5ULL*1000*1000*1000);
> 
> Please add a macro or two for nanoseconds/milliseconds/seconds or whatever this
> expands to.

That is the problem - the delay is just in TSC freq units, and knowing TSC freq
for some reason on x86 is next to impossible on AMD

(If someone from AMD listens, please add a CPUID for this!)


> 
> > +               isr_count2 = isr_counts[1];
> > +
> > +               if (isr_count1 == isr_count2) {
> > +                       printf("\n");
> > +                       printf("hang detected!!\n");
> > +                       break;
> > +               } else {
> > +                       printf("made %ld IPIs \n", (isr_count2 - isr_count1)*(ncpus-1));
> > +               }
> > +       }
> > +
> > +       printf("\n");
> > +
> > +       for (cpu = 1; cpu < ncpus; ++cpu)
> > +               report(isr_counts[cpu] == num_iterations,
> > +                               "Number of IPIs match (%lld)",
> 
> Indentation.
> 
> > +                               (long long unsigned int)isr_counts[cpu]);
> 
> Print num_iterations, i.e. expected vs. actual?
> 
> > +
> > +       free((void*)isr_counts);
> > +       return report_summary();
> > +}
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index ebb3fdfc..7655d2ba 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -61,6 +61,11 @@ smp = 2
> >  file = smptest.flat
> >  smp = 3
> >  
> > +[ipi_stress]
> > +file = ipi_stress.flat
> > +extra_params = -cpu host,-x2apic,-svm,-hypervisor -global kvm-pit.lost_tick_policy=discard -machine kernel-irqchip=on -append '0 50000'
> 
> Why add all the SVM and HLT stuff and then effectively turn them off by default?
> There's basically zero chance any other configuration will get regular testing.

This is because this is a stress test and it is mostly useful to run manually for some time.
The svm and hlt should be enabled though, it is a leftover from the fact that I almost never run the test
from the kvm unit test main script, I'll enable these.




> 
> And why not have multi configs, e.g. to run with and without x2APIC?

Good idea as well, although I don't know if I want to slow down the kvm unit tests run too much.
No x2apic is mostly because AVIC used to not work without it. I can drop it now.
'-hypervisor' is also some leftover don't know why it is there.


Best regards,
	Maxim Levitsky

> 
> > +smp = 4
> > +
> >  [vmexit_cpuid]
> >  file = vmexit.flat
> >  extra_params = -append 'cpuid'
> > -- 
> > 2.26.3
> > 
> 


