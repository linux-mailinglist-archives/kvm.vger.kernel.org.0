Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2D64F8B1B
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiDHAAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiDHAA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:00:28 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832C3149D32;
        Thu,  7 Apr 2022 16:58:27 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2eafabbc80aso78740927b3.11;
        Thu, 07 Apr 2022 16:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eJC07aHZt7z/wgAtShk+S/N+ZXk4jWI4fdogWYps2vw=;
        b=HnVe8VRgNBWpYrYXM8tIih6bBb/hhcapGg0IojyYJt1fTyzDd0jc/SQ6/CrDcA+eg0
         xF8dI8BWHfmTCF1+cZHVYZ8Npdps0TnA7IoupdsHo/Y8G4JURyvqYsQS+Ghi+70kQOOv
         lzxFDIfJbG3Zd3BhKEBkt3IIiaJrvcaZJW9ZtL0S2epqvr52o7jEQftfm1yhOkLM/SqT
         ThWouWSnc3xkoro9U8cGmxeXb+Ts47ok1v2UR9OcOQ++eC5MUWuzVZrFKfqMPkTiBwvi
         LeO0DHKLJar4oVCFczBDPtag1BiBIF6918JTFK471X6d/GLhL/wglmY9Vg3q0mLdP1VC
         PyGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eJC07aHZt7z/wgAtShk+S/N+ZXk4jWI4fdogWYps2vw=;
        b=T/+I6eg3L+PhsSr2GJ7VXmrDuYYAo0E/ieDxj6qo7w/Y+L+St7DS4F/zNfKSiqu9oj
         d6/WXULCL5F2SGtImq7ljUWZrJbZ1j1J0kJUSBIsJ94JSVNlZEe2H9XOKCTjpGXfl920
         4nZQepUhgTv7rnK5weFmz6FsIy4g3sJJqL+ZqFMMDslu5dckmk7PTwcVzvyCyJtvzO0G
         Cw208WRPraIzq9xZTk41EB4OtI+m7mJW8AflhMWBFHxSfQctec1TMeKeFAyN3zbE75OP
         jyW09qhfOozBdbzdbzKksO05ov15dRL6R63n7M1vOVtQGtB1vwnRWjQaZu8FejgisjlZ
         Eujw==
X-Gm-Message-State: AOAM530h5bwpnAOZ/BXLXJpd5y5cctmijy/BlM9SLKG4fRJs3CJV9pdx
        lARg/LpD4Wsv40jDVE0r5VqS73wgvzjN4SE9zrDDzUJ/
X-Google-Smtp-Source: ABdhPJzarkV5WZ0pt5e0QniC4U5QRkN/nzihhlmDXq+Rv1eVWNDVsJDCRfESGvVGyIHz4Pn4Zs+wrZ0wmZ8BHGofK1I=
X-Received: by 2002:a0d:e044:0:b0:2eb:4bf0:d0e7 with SMTP id
 j65-20020a0de044000000b002eb4bf0d0e7mr14140239ywe.17.1649375906625; Thu, 07
 Apr 2022 16:58:26 -0700 (PDT)
MIME-Version: 1.0
References: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 8 Apr 2022 07:58:15 +0800
Message-ID: <CANRm+CzfjegzGmou_MtPGLYnWzGuC5RExYs4f=mVhq0sD6j5Sg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] KVM: X86: Scaling Guest OS Critical Sections with boosting
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

ping,
On Fri, 1 Apr 2022 at 16:10, Wanpeng Li <kernellwp@gmail.com> wrote:
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
> v1 -> v2:
>  * add more comments to irq disable state
>  * renaming irq_disabled to last_guest_irq_disabled
>  * renaming, inverting the return, and also return a bool for kvm_vcpu_non_preemptable
>
> Wanpeng Li (5):
>   KVM: X86: Add MSR_KVM_PREEMPT_COUNT support
>   KVM: X86: Add last guest interrupt disable state support
>   KVM: X86: Boost vCPU which is in critical section
>   x86/kvm: Add MSR_KVM_PREEMPT_COUNT guest support
>   KVM: X86: Expose PREEMT_COUNT CPUID feature bit to guest
>
>  Documentation/virt/kvm/cpuid.rst     |  3 ++
>  arch/x86/include/asm/kvm_host.h      |  8 ++++
>  arch/x86/include/uapi/asm/kvm_para.h |  2 +
>  arch/x86/kernel/kvm.c                | 10 +++++
>  arch/x86/kvm/cpuid.c                 |  3 +-
>  arch/x86/kvm/x86.c                   | 60 ++++++++++++++++++++++++++++
>  include/linux/kvm_host.h             |  1 +
>  virt/kvm/kvm_main.c                  |  7 ++++
>  8 files changed, 93 insertions(+), 1 deletion(-)
>
> --
> 2.25.1
>
