Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E264C4DD7B5
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 11:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiCRKLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 06:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiCRKLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 06:11:13 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4C51FC9CA;
        Fri, 18 Mar 2022 03:09:47 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id z8so14981555ybh.7;
        Fri, 18 Mar 2022 03:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iBlbICW23CBGTF3so1ajLzBTrtOLAUSZttkTvYtR9U4=;
        b=KnCaC9+6NKn7pDuY3hd2njUC1wF3s5xGR9C0PDWkiqUlDIqnvdtG6OrPmErrmk2bBl
         i/WPQzcLnkRhywTHSUmDMZHZ0GlowVQoJeH2g4mL6X6U3jG3AI4IvhKZJJFmjPbYUXKm
         R7UAeKnMiALz4HvQk26o1tzbV5c9m84gDcW9HQjKn/SxT4eQO+JwXWEH07wvgj2i/Z1T
         O6cro+exHmh1+bAB8sRl6KBdc32uIv0fzi3pmUYeL0DcPvjMwnHklX2n0F9O7bJNGOcu
         8jIxG3jpP6nrWC1EGm5Ve2Dxy9nrAS0579oGxj+AKV6y7aGUhQO+lPJrhPYAyHq1cxzn
         40Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iBlbICW23CBGTF3so1ajLzBTrtOLAUSZttkTvYtR9U4=;
        b=A47RpgpnEpdM7hx2hl+pn+Y37bqOX0PZwrSv8dcQU/ekI0eknyXk2Df5rgRkN4uaQg
         EnFBGFEgRtcB2NUpS1wTOeitY/fL5doJVmQNurSer5O2QeEpbm0OVq2sVfgnHsVt0edV
         eYkoMr3aIcY+y35aK8Cp7/b1eZ7QUy7mYwLjViVAQ+mZ9998bGd+mypIhhFB4b56MEJ1
         QKx/MJzOf/Ei3PSJw/7xL76EhMFXf/WJIqlYskMsGHzapAUlwzuI2Bx/lQYt6bJUVEPR
         RwDZxOIAl9eWV6rMqjar+qR8gH+3hyW4nmpcfCM4DFQbLL7+F7+aHCEH9bcH5qM4tjVh
         h8uw==
X-Gm-Message-State: AOAM5326ymbuirqYk98FzppuJMSSI/2efkkunEjOu1613jtxfy6jO0nM
        N946lZDDtQzyPTlnx5yeqSfyD5pAf8XtGufj9fpjGnZctLM=
X-Google-Smtp-Source: ABdhPJwIdDnVNEDU80uHFFUxuzkAqD7VZYbyHnJJrzK5rhGtuTtx1motzqejrVY10v71l4Ql13DBTL9pU8Cr1oGoexg=
X-Received: by 2002:a25:588b:0:b0:633:a978:79b2 with SMTP id
 m133-20020a25588b000000b00633a97879b2mr6131924ybb.138.1647598186680; Fri, 18
 Mar 2022 03:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 18 Mar 2022 18:09:35 +0800
Message-ID: <CANRm+CycTii50jwRwVsyG0X-jRRZY8YaypYHNKO1ObYbcSuuaw@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: X86: Scaling Guest OS Critical Sections with boosting
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kindly ping, :)
On Fri, 11 Mar 2022 at 16:30, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> The missing semantic gap that occurs when a guest OS is preempted
> when executing its own critical section, this leads to degradation
> of application scalability. We try to bridge this semantic gap in
> some ways, by passing guest preempt_count to the host and checking
> guest irq disable state, the hypervisor now knows whether guest
> OSes are running in the critical section, the hypervisor yield-on-spin
> heuristics can be more smart this time to boost the vCPU candidate
> who is in the critical section to mitigate this preemption problem,
> in addition, it is more likely to be a potential lock holder.
>
> Testing on 96 HT 2 socket Xeon CLX server, with 96 vCPUs VM 100GB RAM,
> one VM running benchmark, the other(none-2) VMs running cpu-bound
> workloads, There is no performance regression for other benchmarks
> like Unixbench etc.
>
> 1VM
>             vanilla    optimized    improved
>
> hackbench -l 50000
>               28         21.45        30.5%
> ebizzy -M
>              12189       12354        1.4%
> dbench
>              712 MB/sec  722 MB/sec   1.4%
>
> 2VM:
>             vanilla    optimized    improved
>
> hackbench -l 10000
>               29.4        26          13%
> ebizzy -M
>              3834        4033          5%
> dbench
>            42.3 MB/sec  44.1 MB/sec   4.3%
>
> 3VM:
>             vanilla    optimized    improved
>
> hackbench -l 10000
>               47         35.46        33%
> ebizzy -M
>              3828        4031         5%
> dbench
>            30.5 MB/sec  31.16 MB/sec  2.3%
>
> Wanpeng Li (5):
>   KVM: X86: Add MSR_KVM_PREEMPT_COUNT support
>   KVM: X86: Add guest interrupt disable state support
>   KVM: X86: Boost vCPU which is in the critical section
>   x86/kvm: Add MSR_KVM_PREEMPT_COUNT guest support
>   KVM: X86: Expose PREEMT_COUNT CPUID feature bit to guest
>
>  Documentation/virt/kvm/cpuid.rst     |  3 ++
>  arch/x86/include/asm/kvm_host.h      |  7 ++++
>  arch/x86/include/uapi/asm/kvm_para.h |  2 +
>  arch/x86/kernel/kvm.c                | 10 +++++
>  arch/x86/kvm/cpuid.c                 |  3 +-
>  arch/x86/kvm/x86.c                   | 60 ++++++++++++++++++++++++++++
>  include/linux/kvm_host.h             |  1 +
>  virt/kvm/kvm_main.c                  |  7 ++++
>  8 files changed, 92 insertions(+), 1 deletion(-)
>
> --
> 2.25.1
>
