Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA18551693
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 13:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238928AbiFTLHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 07:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238910AbiFTLHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 07:07:09 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BE31572D
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 04:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=9SCkUg6RVcBLlFwNe0+AFrt9G+zfWlBnbqgWsw1QYNE=; b=fsA8ufeyh5reRwAxsc+
        Dr4/brYe6RUpAxE5nf40OfEeePSi00vFeOA2gBmHW0MQZl2j2EMADIq6SxKN4i2WReM6+Ln5T3D4Y
        WLLaCBZPOFFjkrZfgxMEgso3rqaIcsYv5VCqH5MyHP2fffsaSIVCNNBhXIXCdrLzN4sstay4F2U=;
Received: from [192.168.16.160] (helo=mikhalitsyn-laptop)
        by relay.virtuozzo.com with esmtp (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1o3FEu-00604B-GC; Mon, 20 Jun 2022 13:06:40 +0200
Date:   Mon, 20 Jun 2022 14:06:56 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     babu.moger@amd.com,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, den@virtuozzo.com,
        ptikhomirov@virtuozzo.com
Subject: Re: [Question] debugging VM cpu hotplug (#GP -> #DF) which results
 in reset
Message-Id: <20220620140656.9b3db5987fb21d2321f10cec@virtuozzo.com>
In-Reply-To: <20220620140432.17273d8d58e1e3516457b951@virtuozzo.com>
References: <20220615171410.ab537c7af3691a0d91171a76@virtuozzo.com>
        <Yqn0GofIXFOHk6k4@google.com>
        <CAJqdLrrM7ttxM-psdLG0rLydS+HBPX3Yqi_TEtxizni4a4eySA@mail.gmail.com>
        <20220620140432.17273d8d58e1e3516457b951@virtuozzo.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Jun 2022 14:04:32 +0300
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:

> On Wed, 15 Jun 2022 22:47:57 +0300
> Alexander Mikhalitsyn <alexander@mihalicyn.com> wrote:
> 
> > Dear Sean,
> > 
> > Thanks a lot for your answer!
> > 
> > On Wed, Jun 15, 2022 at 6:00 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Wed, Jun 15, 2022, Alexander Mikhalitsyn wrote:
> > > > Dear friends,
> > > >
> > > > I'm sorry for disturbing you but I've getting stuck with debugging KVM
> > > > problem and looking for an advice. I'm working mostly on kernel
> > > > containers/CRIU and am newbie with KVM so, I believe that I'm missing
> > > > something very simple.
> > > >
> > > > My case:
> > > > - AMD EPYC 7443P 24-Core Processor (Milan family processor)
> > > > - OpenVZ kernel (based on RHEL7 3.10.0-1160.53.1) on the Host Node (HN)
> > > > - Qemu/KVM VM (8 vCPU assigned) with many different kernels from 3.10.0-1160 RHEL7 to mainline 5.18
> > > >
> > > > Reproducer (run inside VM):
> > > > echo 0 > /sys/devices/system/cpu/cpu3/online
> > > > echo 1 > /sys/devices/system/cpu/cpu3/online <- got reset here
> > > >
> > > > *Not* reproducible on:
> > > > - any Intel which we tried
> > > > - AMD EPYC 7261 (Rome family)
> > >
> > > Hmm, given that Milan is problematic but Rome isn't, that implies the bug is related
> > > to a feature that's new in Milan.  PCID is the one that comes to mind, and IIRC there
> > > were issues with PCID (or INVCPID?) in various kernels when running on Milan.
> > >
> > > Can you try hiding PCID and INVPCID from the guest?
> > 
> > Yep, I've tried to disable PCID and INVPCID features by nopcid and
> > noinvpcid kernel cmdline flags.
> > noinvpcid not effects on the problem, but nopcid does! Fantastic!
> > 
> > Of course, masking CPU feature from qemu side is also works:
> >   <cpu mode='host-model' check='partial'>
> >     <feature policy='disable' name='pcid'/>
> >   </cpu>
> > 
> > Now, thanks to your advice, I will try to understand why the PCID
> > feature breaks VMs. I see
> > that we've some support for this feature in our host kernel (based on
> > RHEL7 3.10.0-1160.53.1), probably
> > We have some bugs or are not handling something PCID-related from the KVM side.
> > 
> > Thanks again, I couldn't have pulled this off without your advice, Sean.
> > 
> > >
> > > > - without KVM (on Host)
> > >
> > > ...
> > >
> > > > ==== trace-cmd record -b 20000 -e kvm:kvm_cr -e kvm:kvm_userspace_exit -e probe:* =====
> > > >
> > > >              CPU-1834  [003] 69194.833364: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
> > > >              CPU-1838  [000] 69194.834177: kvm_multiple_exception_L9: (ffffffff814313c6) vcpu=0xffff93ee9a528000
> > > >              CPU-1838  [000] 69194.834180: kvm_multiple_exception_L41: (ffffffff81431493) vcpu=0xffff93ee9a528000 exception=0xd000001 has_error=0x0 nr=0xd error_code=0x0 has_payload=0x0
> > > >              CPU-1838  [000] 69194.834195: kvm_multiple_exception_L9: (ffffffff814313c6) vcpu=0xffff93ee9a528000
> > > >              CPU-1838  [000] 69194.834196: kvm_multiple_exception_L41: (ffffffff81431493) vcpu=0xffff93ee9a528000 exception=0x8000100 has_error=0x0 nr=0x8 error_code=0x0 has_payload=0x0
> > > >              CPU-1838  [000] 69194.834200: shutdown_interception_L8: (ffffffff8146e4a0)
> > >
> > > If you can modify the host kernel, throwing a WARN in kvm_multiple_exception() should
> > > pinpoint the source of the #GP.  Though you may get unlucky and find that KVM is just
> > > reflecting an intercepted a #GP that was first "injected" by hardware.  Note that this
> > > could spam the log if KVM is injecting a large number of #GPs.
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 9cea051ca62e..19d959bf97cc 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -612,6 +612,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
> > >         u32 prev_nr;
> > >         int class1, class2;
> > >
> > > +       WARN_ON(nr == GP_VECTOR);
> > > +
> > >         kvm_make_request(KVM_REQ_EVENT, vcpu);
> > >
> > >         if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
> > >
> > 
> > Thanks! I'll try to play with that.
> > 
> > Best regards,
> > Alex
> 
> Just in case if someone will meet the same issue with CPU hotplug on RHEL7 with AMD Milan.
> 
> This patch (authored by Babu Moger) helps:
> KVM: SVM: Clear the CR4 register on reset
> https://patchwork.kernel.org/project/kvm/patch/161471109108.30811.6392805173629704166.stgit@bmoger-ubuntu/
> 
> It's easy to apply it to RHEL7 kernel code:
> https://lists.openvz.org/pipermail/devel/2022-June/079762.html
> 
> It fixes problem because cpu hotplug triggers the same codepath as early start of kexec'ed kernel.
> 
> Huge thanks to Sean Christopherson for pointing me out to PCID and Babu Moger for the fix :-)
> 
> Regards,
> Alex

+CC Babu Moger
