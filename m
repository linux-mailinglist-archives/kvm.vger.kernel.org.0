Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B601758ED1D
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 15:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiHJNZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 09:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiHJNZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 09:25:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD15E2CE3B
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 06:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660137935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k7c0qAQ5W21TXh6W0fKJeJBpzWI2+8i+EKNMQTdJqw4=;
        b=ZvPgpIuilkQJNeMvu6sBeB08JK7PELOEylKHGhvpGHQDqPf1fn9mAAdxmNpXCz6lDpmwkI
        vKNWjqolko74fmxdbOCRI5dSgFBcIqCxBQ9+kDWWkyZmvGOvI0KuicyEjvK63T+4SLxsl0
        QpYgMA/s+2cblVMD4o2FxdDJHcysm2Q=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-SxxVHFjxN9C5izZs94ZGwA-1; Wed, 10 Aug 2022 09:25:34 -0400
X-MC-Unique: SxxVHFjxN9C5izZs94ZGwA-1
Received: by mail-qk1-f198.google.com with SMTP id q20-20020a05620a0d9400b006b6540e8d79so12592293qkl.14
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 06:25:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=k7c0qAQ5W21TXh6W0fKJeJBpzWI2+8i+EKNMQTdJqw4=;
        b=hZLi48aVlbNFrJA0MpSMjR2Si20cBvoGLS3m+IvjGSBXvIOVPTAZGgDrQaj7+70VkJ
         hYc6JZRmfa7zLJ1t0RpVVB+movAjHqj+DgY8rCbinSKZl/AtCfYB3V5y0j849ZYZHQ8C
         X6mypSRr3qLakyoqcHm30e6yEPHHweUfHbNmS8Tk4DtzsScEirwQe3pMQ63eyV1rfLYZ
         Z6IBPESzYTzmUKg/H+DIaZzSvyficq//LNJoYEuMIGwn0jqKx6YoMqUsOAhx3TY7eCjq
         J/XGWHXkTcf+/NsUS9Ff96e0zcsQ3DCBKVFeMLIxaZ5uTC8sNoy623INLd2+VxHv48QW
         pZ8w==
X-Gm-Message-State: ACgBeo0ra4LBQAhz/4XX4MOeZCbYV1b69qFUQ7tW/yFluxkf+jCdIn20
        7e7lPLM7HaYaOGvLrOpBLN3l7QXDobjyTpXVxPxsm4BoXZ+3ctcBd2Mz2x0R5nd5KUhy4ShxFk8
        WNkZLZkZUowQJ
X-Received: by 2002:ac8:5786:0:b0:343:3051:170d with SMTP id v6-20020ac85786000000b003433051170dmr5914751qta.429.1660137934064;
        Wed, 10 Aug 2022 06:25:34 -0700 (PDT)
X-Google-Smtp-Source: AA6agR47cu1ZKgu0YuBv7LikcDcvOPm4YCAsy8rs6byqvqDVrznU7I7iTFwhg569XGZ+0gomkkwzWA==
X-Received: by 2002:ac8:5786:0:b0:343:3051:170d with SMTP id v6-20020ac85786000000b003433051170dmr5914712qta.429.1660137933780;
        Wed, 10 Aug 2022 06:25:33 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id t26-20020a37ea1a000000b006b58fce19dasm13172726qkj.20.2022.08.10.06.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:25:33 -0700 (PDT)
Message-ID: <866df4004138ba18c6503266b61661a2ed8536c6.camel@redhat.com>
Subject: Re: [PATCH v3 00/13] SMM emulation and interrupt shadow fixes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Thomas Lamprecht <t.lamprecht@proxmox.com>, kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 10 Aug 2022 16:25:29 +0300
In-Reply-To: <96e0749a-6036-c728-d224-b812caadcd1b@proxmox.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
         <96e0749a-6036-c728-d224-b812caadcd1b@proxmox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-10 at 14:00 +0200, Thomas Lamprecht wrote:
> On 03/08/2022 17:49, Maxim Levitsky wrote:
> > This patch series is a result of long debug work to find out why
> > sometimes guests with win11 secure boot
> > were failing during boot.
> > 
> > During writing a unit test I found another bug, turns out
> > that on rsm emulation, if the rsm instruction was done in real
> > or 32 bit mode, KVM would truncate the restored RIP to 32 bit.
> > 
> > I also refactored the way we write SMRAM so it is easier
> > now to understand what is going on.
> > 
> > The main bug in this series which I fixed is that we
> > allowed #SMI to happen during the STI interrupt shadow,
> > and we did nothing to both reset it on #SMI handler
> > entry and restore it on RSM.
> > 
> > V3: addressed most of the review feedback from Sean (thanks!)
> > 
> > Best regards,
> >         Maxim Levitsky
> > 
> > Maxim Levitsky (13):
> >   bug: introduce ASSERT_STRUCT_OFFSET
> >   KVM: x86: emulator: em_sysexit should update ctxt->mode
> >   KVM: x86: emulator: introduce emulator_recalc_and_set_mode
> >   KVM: x86: emulator: update the emulation mode after rsm
> >   KVM: x86: emulator: update the emulation mode after CR0 write
> >   KVM: x86: emulator/smm: number of GPRs in the SMRAM image depends on
> >     the image format
> >   KVM: x86: emulator/smm: add structs for KVM's smram layout
> >   KVM: x86: emulator/smm: use smram structs in the common code
> >   KVM: x86: emulator/smm: use smram struct for 32 bit smram load/restore
> >   KVM: x86: emulator/smm: use smram struct for 64 bit smram load/restore
> >   KVM: x86: SVM: use smram structs
> >   KVM: x86: SVM: don't save SVM state to SMRAM when VM is not long mode
> >     capable
> >   KVM: x86: emulator/smm: preserve interrupt shadow in SMRAM
> > 
> >  arch/x86/include/asm/kvm_host.h |  11 +-
> >  arch/x86/kvm/emulate.c          | 305 +++++++++++++++++---------------
> >  arch/x86/kvm/kvm_emulate.h      | 223 ++++++++++++++++++++++-
> >  arch/x86/kvm/svm/svm.c          |  30 ++--
> >  arch/x86/kvm/vmx/vmcs12.h       |   5 +-
> >  arch/x86/kvm/vmx/vmx.c          |   4 +-
> >  arch/x86/kvm/x86.c              | 175 +++++++++---------
> >  include/linux/build_bug.h       |   9 +
> >  8 files changed, 497 insertions(+), 265 deletions(-)
> > 
> 
> FWIW, we tested the v2 on 5.19 and backported it to 5.15 with minimal adaption
> required (mostly unrelated context change) and now also updated that backport
> to the v3 of this patch series.
> 
> Our reproducer got fixed with either, but v3 now also avoids triggering logs like:
> 
>  Jul 29 04:59:18 mits4 QEMU[2775]: kvm: Could not update PFLASH: Stale file handle
>  Jul 29 04:59:18 mits4 QEMU[2775]: kvm: Could not update PFLASH: Stale file handle
>  Jul 29 07:15:46 mits4 kernel: kvm: vcpu 1: requested 191999 ns lapic timer period limited to 200000 ns
>  Jul 29 11:06:31 mits4 kernel: kvm: vcpu 1: requested 105786 ns lapic timer period limited to 200000 ns
> 
> which happened earlier (not sure how deep that correlates with the v2 vs. v3, but
> it stuck out, so mentioning for sake of completeness).

This is likely just a coincidence because V3 should not contain any functional changes vs v2.
(If I remember correctly)

> 
> For the backport to 5.15 we skipped "KVM: x86: emulator/smm: number of GPRs in
> the SMRAM image depends on the image format", as that constant was there yet and
> the actual values stayed the same for our case FWICT and adapted to slight context
> changes for the others.
> 
> So, the approach seems to fix our issue and we are already rolling out a kernel
> to users for testing and got positive feedback there too.
> 
> With above in mind:
> 
> Tested-by: Thomas Lamprecht <t.lamprecht@proxmox.com>

Thank you very much for testing!

> 
> It would be also great to see this backported to still supported upstream stable kernels
> from 5.15 onwards, as there the TDP MMU got by default enabled, and that is at least
> increasing the chance of our reproducer to trigger dramatically.

Best regards,
	Maxim Levitsky

> 
> thx & cheers
> Thomas
> 


