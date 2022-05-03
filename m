Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D31518867
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbiECPZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238338AbiECPZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:25:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00C9913DE3
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 08:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651591302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUYy8b+KeqsrmdeQpON3aR0duOx1u2ctuvoiS753EAk=;
        b=YbMqudZtnSTkVTI8T+W/bUxNCB2qW4fbvbcH9Mp4vPm+WCFrFnYwNgeTuDuZpzywtUGbsF
        2fOA35cBNavgkS2GLtzB85uXmRH1HeCNROJY1bsm9iSz6j9SZb+TdKph7ZxydA81+Kshb3
        bgkOrm8epf5ji2GOdBFhsdUyYhCg56k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-wGa7T4S7MCuxQUmvbAlhTg-1; Tue, 03 May 2022 11:21:21 -0400
X-MC-Unique: wGa7T4S7MCuxQUmvbAlhTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7AE6952760;
        Tue,  3 May 2022 15:12:13 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 680D92024CDC;
        Tue,  3 May 2022 15:12:11 +0000 (UTC)
Message-ID: <cbd4709bb499874c60986083489e17c93b48d003.camel@redhat.com>
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
Date:   Tue, 03 May 2022 18:12:10 +0300
In-Reply-To: <e11c21e99e7c4ac758b4417e0ae66d3a2f1fe663.camel@redhat.com>
References: <337332ca-835c-087c-c99b-92c35ea8dcd3@redhat.com>
         <Ymv1I5ixX1+k8Nst@google.com>
         <20e1e7b1-ece7-e9e7-9085-999f7a916ac2@redhat.com>
         <Ymv5TR76RNvFBQhz@google.com>
         <e5864cb4-cce8-bd32-04b0-ecb60c058d0b@redhat.com>
         <YmwL87h6klEC4UKV@google.com>
         <ac2001e66957edc8a3af2413b78478c15898f86c.camel@redhat.com>
         <f3ffad3aa8476156f369ff1d4c33f3e127b47d0c.camel@redhat.com>
         <82d1a5364f1cc479da3762b046d22f136db167e3.camel@redhat.com>
         <af15fd31f73e8a956da50db6104e690f9d308dad.camel@redhat.com>
         <YnAMKtfAeoydHr3x@google.com>
         <e11c21e99e7c4ac758b4417e0ae66d3a2f1fe663.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-03 at 12:12 +0300, Maxim Levitsky wrote:
> On Mon, 2022-05-02 at 16:51 +0000, Sean Christopherson wrote:
> > On Mon, May 02, 2022, Maxim Levitsky wrote:
> > > On Mon, 2022-05-02 at 10:59 +0300, Maxim Levitsky wrote:
> > > > > > Also I can reproduce it all the way to 5.14 kernel (last kernel I have installed in this VM).
> > > > > > 
> > > > > > I tested kvm/queue as of today, sadly I still see the warning.
> > > > > 
> > > > > Due to a race, the above statements are out of order ;-)
> > > > 
> > > > So futher investigation shows that the trigger for this *is* cpu_pm=on :(
> > > > 
> > > > So this is enough to trigger the warning when run in the guest:
> > > > 
> > > > qemu-system-x86_64  -nodefaults  -vnc none -serial stdio -machine accel=kvm
> > > > -kernel x86/dummy.flat -machine kernel-irqchip=on -smp 8 -m 1g -cpu host
> > > > -overcommit cpu-pm=on
> > > > 
> > > > 
> > > > '-smp 8' is needed, and the more vCPUs the more often the warning appears.
> > > > 
> > > > 
> > > > Due to non atomic memslot update bug, I use patched qemu version, with an
> > > > attached hack, to pause/resume vcpus around the memslot update it does, but
> > > > even without this hack, you can just ctrl+c the test after it gets the KVM
> > > > internal error, and then tdp mmu memory leak warning shows up (not always
> > > > but very often).
> > > > 
> > > > 
> > > > Oh, and if I run the above command on the bare metal, it  never terminates.
> > > > Must be due to preemption, qemu shows beeing stuck in kvm_vcpu_block. AVIC
> > > > disabled, kvm/queue.  Bugs, bugs, and features :)
> > > 
> > > All right, at least that was because I removed the '-device isa-debug-exit,iobase=0xf4,iosize=0x4',
> > > which is apparently used by KVM unit tests to signal exit from the VM.
> > 
> > Can you provide your QEMU command line for running your L1 VM?  And your L0 and L1
> > Kconfigs too?  I've tried both the dummy and ipi_stress tests on a variety of hardware,
> > kernels, QEMUs, etc..., with no luck.
> > 
> 
> So now both L0 and L1 run almost pure kvm/queue)
> (commit 2764011106d0436cb44702cfb0981339d68c3509)
> 
> I have some local patches but they are not relevant to KVM at all, more
> like various tweaks to sensors, a sad hack for yet another regression
> in AMDGPU, etc.
> 
> The config and qemu command line attached.
> 
> AVIC disabled in L0, L0 qemu is from master upstream.
> Bug reproduces too well IMHO, almost always.
> 
> For reference the warning is printed in L1's dmesg.

Tested this without any preemption in L0 and L1 - bug still reproduces just fine.
(kvm/queue)

Best regards,
	Maxim Levitsky

> 
> 
> 
> Best regards,
> 	Maxim Levitsky


