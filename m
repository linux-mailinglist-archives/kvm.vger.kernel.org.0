Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B55A751931
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 08:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbjGMG6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 02:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbjGMG6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 02:58:12 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A21C2126;
        Wed, 12 Jul 2023 23:58:00 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f13c41c957so113369e87.1;
        Wed, 12 Jul 2023 23:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689231478; x=1691823478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=waLkOtUqCND3qWnpRClFSJQ2X9auVT8M1bxrT+zC32s=;
        b=lkJ3b5RTx6w3MyFX8udYb+6bfSqY5fGhbd3/VmC88DRC4qmBC8NvK476cfUp+EbYLb
         jpH5dRbA/Ie71jL1erH6cMPDCcsXjMbxPLeSUDKOJJEYVTNI0ZvcfuBG+6KD3s/bHeha
         yWxDSfAo9jJyQ5BKcs10LpTCzSC7T/BNf00X2IB8fTxqf+35YW3dFcxHlOlSFZd70eiv
         /RPS47nctt5ShCtIIzHN8SYYuG1WzDDAoDuAOaVw+55QRBe4Iqx8d5QMJqxpw96qhyMK
         GlqdbXoXdAXe511DVM8VscHVuW8nOHvLymH8+UlTdM0U0UxIWc3Bvdp4+01R0j7wrRQ/
         Rb2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689231478; x=1691823478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=waLkOtUqCND3qWnpRClFSJQ2X9auVT8M1bxrT+zC32s=;
        b=Np422g79o1cvdmqFCaOGoK2Zjnhy5xMd6WpL3LEKptf4XQiedUGRk8Qn2SjmypjMp4
         jfxdjt6uHRAam6AjUvdGdvFYIKXT+hYBx12901kyaYeQjiw//KANbTSR0eA8X42dqYmc
         9VVs0xgBNSF3RmLqsG/DLTJF7c32hDbB9wkCAQT9AoEbn6yK2TmPy0yEiw2zb877Fuwn
         6JbsRb75aQmng5Ru9gJjGEap+mvaO7DaeKQkUeN1YBeOMsneCcrke9Yw6ADbx68/bKfU
         /VS+lbtMTUasPsBFv/Ap6U/Y6z+RhhmmhryH73YK0kkPAnMjbdMwLdDhFXBDi8jJ5+4p
         7LQg==
X-Gm-Message-State: ABy/qLYaUeHmp/FIH4KGEgT+KLIMDAe9GoUiyFoobNfyaskw6xPmLRHu
        pVVdFfLdwdz3iWT8+jymhaA=
X-Google-Smtp-Source: APBJJlGVnrPEcc9UdApCLIJJqpkO39LjES50E2PV2g3yqmqcV0fjY+OeLF+Trw3uESLdC4DR/FZ3Iw==
X-Received: by 2002:ac2:5ed1:0:b0:4fb:7381:952e with SMTP id d17-20020ac25ed1000000b004fb7381952emr387400lfq.2.1689231478176;
        Wed, 12 Jul 2023 23:57:58 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id y24-20020a197518000000b004fb953f74d3sm999273lfe.264.2023.07.12.23.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 23:57:57 -0700 (PDT)
Date:   Thu, 13 Jul 2023 09:57:55 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Wang Jianchao <jianchwa@outlook.com>
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, arkinjob@outlook.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] KVM: x86: introduce pv feature lazy tscdeadline
Message-ID: <20230713095755.00003d27.zhi.wang.linux@gmail.com>
In-Reply-To: <BYAPR03MB4133E3A1487ED160FBB59E0CCD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
References: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
        <20230712211453.000025f6.zhi.wang.linux@gmail.com>
        <BYAPR03MB4133E3A1487ED160FBB59E0CCD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jul 2023 10:50:36 +0800
Wang Jianchao <jianchwa@outlook.com> wrote:

> 
> 
> On 2023.07.13 02:14, Zhi Wang wrote:
> > On Fri,  7 Jul 2023 14:17:58 +0800
> > Wang Jianchao <jianchwa@outlook.com> wrote:
> > 
> >> Hi
> >>
> >> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
> >> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
> >> and host side handle it. However, a lot of the vm-exit is unnecessary
> >> because the timer is often over-written before it expires. 
> >>
> >> v : write to msr of tsc deadline
> >> | : timer armed by tsc deadline
> >>
> >>          v v v v v        | | | | |
> >> --------------------------------------->  Time  
> >>
> >> The timer armed by msr write is over-written before expires and the
> >> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
> >>
> >>          v v v v v        |       |
> >> --------------------------------------->  Time  
> >>                           '- arm -'
> >>
> > 
> > Interesting patch.
> > 
> > I am a little bit confused of the chart above. It seems the write of MSR,
> > which is said to cause VM exit, is not reduced in the chart of lazy
> > tscdeadline, only the times of arm are getting less. And the benefit of
> > lazy tscdeadline is said coming from "less vm exit". Maybe it is better
> > to imporve the chart a little bit to help people jump into the idea
> > easily?
> 
> Thanks so much for you comment and sorry for my poor chart.
> 

You don't have to say sorry here. :) Save it for later when you actually
break something. 

> Let me try to rework the chart.
> 
> Before this patch, every time guest start or modify a hrtimer, we need to write the msr of tsc deadline,
> a vm-exit occurs and host arms a hv or sw timer for it.
> 
> 
> w: write msr
> x: vm-exit
> t: hv or sw timer
> 
> 
> Guest
>          w       
> --------------------------------------->  Time  
> Host     x              t         
>  
> 
> However, in some workload that needs setup timer frequently, msr of tscdeadline is usually overwritten
> many times before the timer expires. And every time we modify the tscdeadline, a vm-exit ocurrs
> 
> 
> 1. write to msr with t0
> 
> Guest
>          w0         
> ---------------------------------------->  Time  
> Host     x0             t0     
> 
>  
> 2. write to msr with t1
> Guest
>              w1         
> ------------------------------------------>  Time  
> Host         x1          t0->t1     
> 
> 
> 2. write to msr with t2
> Guest
>                 w2         
> ------------------------------------------>  Time  
> Host            x2          t1->t2     
>  
> 
> 3. write to msr with t3
> Guest
>                     w3         
> ------------------------------------------>  Time  
> Host                x3           t2->t3     
> 
> 
> 
> What this patch want to do is to eliminate the vm-exit of x1 x2 and x3 as following,
> 
> 
> Firstly, we have two fields shared between guest and host as other pv features, saying,
>  - armed, the value of tscdeadline that has a timer in host side, only updated by __host__ side
>  - pending, the next value of tscdeadline, only updated by __guest__ side
> 
> 
> 1. write to msr with t0
> 
>              armed   : t0
>              pending : t0
> Guest
>          w0         
> ---------------------------------------->  Time  
> Host     x0             t0     
> 
> vm-exit occurs and arms a timer for t0 in host side
> 
>  
> 2. write to msr with t1
> 
>              armed   : t0
>              pending : t1
> 
> Guest
>              w1         
> ------------------------------------------>  Time  
> Host                     t0    
> 
> the value of tsc deadline that has been armed, namely t0, is smaller than t1, needn't to write
> to msr but just update pending
> 
> 
> 3. write to msr with t2
> 
>              armed   : t0
>              pending : t2
>  
> Guest
>                 w2         
> ------------------------------------------>  Time  
> Host                      t0  
>  
> Similar with step 2, just update pending field with t2, no vm-exit
> 
> 
> 4.  write to msr with t3
> 
>              armed   : t0
>              pending : t3
> 
> Guest
>                     w3         
> ------------------------------------------>  Time  
> Host                       t0
> Similar with step 2, just update pending field with t3, no vm-exit
> 
> 
> 5.  t0 expires, arm t3
> 
>              armed   : t3
>              pending : t3
> 
> 
> Guest
>                             
> ------------------------------------------>  Time  
> Host                       t0  ------> t3
> 
> t0 is fired, it checks the pending field and re-arm a timer based on it.
> 
> 
> Here is the core ideal of this patch ;)
>

That's much better. Please keep this in the cover letter in the next RFC.

My concern about this approach is: it might slightly affect timing
sensitive workload in the guest, as the approach merges the deadline
interrupt. The guest might see less deadline interrupts than before. It
might be better to have a comparison of number of deadline interrupts
in the cover letter.

Note that I went through the whole patch series. The coding seems fine
except some sanity checks and typos. I think it is good enough to
demonstrate the idea. Let's wait for more folks to weigh in for the ideas.

For cover letter, besides the chart, you can also briefly describe what
each patch does in the cover letter and put more details in the comments
of each patch. So that people can grab the basic idea quickly without
switching between email threads.

For the comment body of patch, please refer to Sean's maintainer handbook.
They have patterns and they are quite helpful on improving the readability.
:) 

Also, don't worry if you doesn't have QEMU patches for people to try. You
can add a KVM selftest to the patch series to let people try.

> 
> Thanks
> Jianchao
> 
> > 
> >> The 1st timer is responsible for arming the next timer. When the armed
> >> timer is expired, it will check pending and arm a new timer.
> >>
> >> In the netperf test with TCP_RR on loopback, this lazy_tscdeadline can
> >> reduce vm-exit obviously.
> >>
> >>                          Close               Open
> >> --------------------------------------------------------
> >> VM-Exit
> >>              sum         12617503            5815737
> >>             intr      0% 37023            0% 33002
> >>            cpuid      0% 1                0% 0
> >>             halt     19% 2503932         47% 2780683
> >>        msr-write     79% 10046340        51% 2966824
> >>            pause      0% 90               0% 84
> >>    ept-violation      0% 584              0% 336
> >>    ept-misconfig      0% 0                0% 2
> >> preemption-timer      0% 29518            0% 34800
> >> -------------------------------------------------------
> >> MSR-Write
> >>             sum          10046455            2966864
> >>         apic-icr     25% 2533498         93% 2781235
> >>     tsc-deadline     74% 7512945          6% 185629
> >>
> >> This patchset is made and tested on 6.4.0, includes 3 patches,
> >>
> >> The 1st one adds necessary data structures for this feature
> >> The 2nd one adds the specific msr operations between guest and host
> >> The 3rd one are the one make this feature works.
> >>
> >> Any comment is welcome.
> >>
> >> Thanks
> >> Jianchao
> >>
> >> Wang Jianchao (3)
> >> 	KVM: x86: add msr register and data structure for lazy tscdeadline
> >> 	KVM: x86: exchange info about lazy_tscdeadline with msr
> >> 	KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
> >>
> >>
> >>  arch/x86/include/asm/kvm_host.h      |  10 ++++++++
> >>  arch/x86/include/uapi/asm/kvm_para.h |   9 +++++++
> >>  arch/x86/kernel/apic/apic.c          |  47 ++++++++++++++++++++++++++++++++++-
> >>  arch/x86/kernel/kvm.c                |  13 ++++++++++
> >>  arch/x86/kvm/cpuid.c                 |   1 +
> >>  arch/x86/kvm/lapic.c                 | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
> >>  arch/x86/kvm/lapic.h                 |   4 +++
> >>  arch/x86/kvm/x86.c                   |  26 ++++++++++++++++++++
> >>  8 files changed, 229 insertions(+), 9 deletions(-)
> > 

