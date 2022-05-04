Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65D6519EF4
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349101AbiEDMMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbiEDMMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:12:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B95051DA62
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 05:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651666126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5JmwH3ZBgKgTWBBO0FhYbpl+Uw/L1BpVs00veAWR2mo=;
        b=CGFOBFSQW4W0VubrF1ae1nW7t04DME/XKh1x3y4aDqyf0pqOLrGlc17vY3I4XoH1eBEbSo
        Uhet0oKki5N+yFLLw9bI09YHKoFSGtXGa7KZ+aXNIIu8X0qvPEmi8AEv8cLahdYH/Oj1CR
        Rry/IOlRyMZBlZvMKgsvCMQ8Zl5/ZII=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-BcUTJm7bM8W5xJWmZeLYrw-1; Wed, 04 May 2022 08:08:45 -0400
X-MC-Unique: BcUTJm7bM8W5xJWmZeLYrw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AE403CF2AA0;
        Wed,  4 May 2022 12:08:45 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC972C28101;
        Wed,  4 May 2022 12:08:42 +0000 (UTC)
Message-ID: <42e9431ec2c716f1066fc282ebd97a7a24cbac72.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Date:   Wed, 04 May 2022 15:08:41 +0300
In-Reply-To: <YnGQyE60lHD7wusA@google.com>
References: <Ymv5TR76RNvFBQhz@google.com>
         <e5864cb4-cce8-bd32-04b0-ecb60c058d0b@redhat.com>
         <YmwL87h6klEC4UKV@google.com>
         <ac2001e66957edc8a3af2413b78478c15898f86c.camel@redhat.com>
         <f3ffad3aa8476156f369ff1d4c33f3e127b47d0c.camel@redhat.com>
         <82d1a5364f1cc479da3762b046d22f136db167e3.camel@redhat.com>
         <af15fd31f73e8a956da50db6104e690f9d308dad.camel@redhat.com>
         <YnAMKtfAeoydHr3x@google.com>
         <e11c21e99e7c4ac758b4417e0ae66d3a2f1fe663.camel@redhat.com>
         <cbd4709bb499874c60986083489e17c93b48d003.camel@redhat.com>
         <YnGQyE60lHD7wusA@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-03 at 20:30 +0000, Sean Christopherson wrote:
> On Tue, May 03, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-05-03 at 12:12 +0300, Maxim Levitsky wrote:
> > > On Mon, 2022-05-02 at 16:51 +0000, Sean Christopherson wrote:
> > > > On Mon, May 02, 2022, Maxim Levitsky wrote:
> > > > > On Mon, 2022-05-02 at 10:59 +0300, Maxim Levitsky wrote:
> > > > > > > > Also I can reproduce it all the way to 5.14 kernel (last kernel I have installed in this VM).
> > > > > > > > 
> > > > > > > > I tested kvm/queue as of today, sadly I still see the warning.
> > > > > > > 
> > > > > > > Due to a race, the above statements are out of order ;-)
> > > > > > 
> > > > > > So futher investigation shows that the trigger for this *is* cpu_pm=on :(
> > > > > > 
> > > > > > So this is enough to trigger the warning when run in the guest:
> > > > > > 
> > > > > > qemu-system-x86_64  -nodefaults  -vnc none -serial stdio -machine accel=kvm
> > > > > > -kernel x86/dummy.flat -machine kernel-irqchip=on -smp 8 -m 1g -cpu host
> > > > > > -overcommit cpu-pm=on
> 
> ...
> 
> > > > > All right, at least that was because I removed the '-device isa-debug-exit,iobase=0xf4,iosize=0x4',
> > > > > which is apparently used by KVM unit tests to signal exit from the VM.
> > > > 
> > > > Can you provide your QEMU command line for running your L1 VM?  And your L0 and L1
> > > > Kconfigs too?  I've tried both the dummy and ipi_stress tests on a variety of hardware,
> > > > kernels, QEMUs, etc..., with no luck.
> > > 
> > > So now both L0 and L1 run almost pure kvm/queue)
> > > (commit 2764011106d0436cb44702cfb0981339d68c3509)
> > > 
> > > I have some local patches but they are not relevant to KVM at all, more
> > > like various tweaks to sensors, a sad hack for yet another regression
> > > in AMDGPU, etc.
> > > 
> > > The config and qemu command line attached.
> > > 
> > > AVIC disabled in L0, L0 qemu is from master upstream.
> > > Bug reproduces too well IMHO, almost always.
> > > 
> > > For reference the warning is printed in L1's dmesg.
> > 
> > Tested this without any preemption in L0 and L1 - bug still reproduces just fine.
> > (kvm/queue)
> 
> Well, I officially give up, I'm out of ideas to try and repro this on my end.  To
> try and narrow the search, maybe try processing "all" possible gfns and see if that
> makes the leak go away?
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 7e258cc94152..a354490939ec 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -84,9 +84,7 @@ static inline gfn_t kvm_mmu_max_gfn(void)
>          * than hardware's real MAXPHYADDR.  Using the host MAXPHYADDR
>          * disallows such SPTEs entirely and simplifies the TDP MMU.
>          */
> -       int max_gpa_bits = likely(tdp_enabled) ? shadow_phys_bits : 52;
> -
> -       return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
> +       return (1ULL << (52 - PAGE_SHIFT)) - 1;
>  }
> 
>  static inline u8 kvm_get_shadow_phys_bits(void)
> 

Nope, still reproduces.

I'll think on how to trace this, maybe that will give me some ideas.
Anything useful to dump from the mmu pages that are still not freed at that point?

Also do you test on AMD? I test on my 3970X.


Best regards,
	Maxim Levitsky

