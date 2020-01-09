Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D59813588F
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 12:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgAILyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 06:54:03 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43456 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728614AbgAILyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 06:54:03 -0500
Received: by mail-ot1-f65.google.com with SMTP id p8so6924932oth.10;
        Thu, 09 Jan 2020 03:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YAYlgekTsgeaDBrXoU9WxGkm6w3XRr6iefPrtixbA8A=;
        b=YHKWV1aBrhNBhz2E/XVEn/wt4cD3aId1ecW4kj5mawS1frC/t8F7HRqmmrWdbNnitF
         +bmQbKI1t6QOqXCh9jkI6LbitusrKuQQOxrHieNhcNlDu72ZQVX984mNV/fx3OlE+Bm5
         Y8J2XxP0ywtFzUL5GLnRwCQ/BSZH7K1myVtoSuW8bk51/08B3Y5KPZz/7822pw7fJbxI
         FhZJO7yeUiclL5RS1Zg6vOVBw/GPmWLE81VMgy2yetf8b09ZSvLXUlhZLZR3nNokpxgm
         fV/YtF2PixMXYBzBEwUURJ0o96W7E9iMzSrCgoAQaeO2+zeRI5al2DmWtwiZIHkej/ad
         O7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YAYlgekTsgeaDBrXoU9WxGkm6w3XRr6iefPrtixbA8A=;
        b=EihKP2ni9IoP+Z9YKsoAQVmZEvv8f1/9YJTcYc3MJWc74oDe+zfKVMjfT9NNBSVqcT
         n5BHWxyetZZouvP56GAFuzhAfk9E+SzPpMVi52o1B/D7F4ImetMB/l9H5cqEx5HNqZWF
         vdQzX4vATlOkX2aBNVkz2N8/0lbqKHxdPWgR3L4Tjk099b8ysojjKU0CsGASvf6GYnfh
         uHY+VZ6tWgNdDDE9CeWuU+xb2Per7Ubv2hE0qdG4JDEmgqIrjRb9d01S+yGuboaB+iFE
         iHLtdKYQwRhhB2hYlSm0kfw6BzLaMpuN/CLCVUmQDS7/iy3uE/7b5gfk6SE+NQoxSvh4
         2DtQ==
X-Gm-Message-State: APjAAAUMVBAjmdwPslYuwQ54DQaT9Ly/GF8GQY4fr8FsoLrGI/UmtaTM
        6XgMArbint1XOifU3FFHjc5HnWwOOJV3GWlMXJ8=
X-Google-Smtp-Source: APXvYqxswygfqzeBQ4CGKjqCe6uJyWSYn3MyJVi4AKzKxHuNg7HVG4MrBpHY7EGm6wAY5GaaU2reJAo1aYyppRfoV8I=
X-Received: by 2002:a05:6830:120b:: with SMTP id r11mr7574574otp.254.1578570842868;
 Thu, 09 Jan 2020 03:54:02 -0800 (PST)
MIME-Version: 1.0
References: <1578448201-28218-1-git-send-email-wanpengli@tencent.com>
 <20200108155040.GB2827@hirez.programming.kicks-ass.net> <00d884a7-d463-74b4-82cf-9deb0aa70971@redhat.com>
In-Reply-To: <00d884a7-d463-74b4-82cf-9deb0aa70971@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 9 Jan 2020 19:53:51 +0800
Message-ID: <CANRm+Cx0LMK1b2mJiU7edCDoRfPfGLzY1Zqr5paBEPcWFFALhQ@mail.gmail.com>
Subject: Re: [PATCH RFC] sched/fair: Penalty the cfs task which executes mwait/hlt
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peterz,
On Thu, 9 Jan 2020 at 01:15, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 08/01/20 16:50, Peter Zijlstra wrote:
> > On Wed, Jan 08, 2020 at 09:50:01AM +0800, Wanpeng Li wrote:
> >> From: Wanpeng Li <wanpengli@tencent.com>
> >>
> >> To deliver all of the resources of a server to instances in cloud, there are no
> >> housekeeping cpus reserved. libvirtd, qemu main loop, kthreads, and other agent/tools
> >> etc which can't be offloaded to other hardware like smart nic, these stuff will
> >> contend with vCPUs even if MWAIT/HLT instructions executed in the guest.
>
> ^^ this is the problem statement:
>
> He has VCPU threads which are being pinned 1:1 to physical CPUs.  He
> needs to have various housekeeping threads preempting those vCPU
> threads, but he'd rather preempt vCPU threads that are doing HLT/MWAIT
> than those that are keeping the CPU busy.

Indeed, thank you Paolo.

>
> >> The is no trap and yield the pCPU after we expose mwait/hlt to the guest [1][2],
> >> the top command on host still observe 100% cpu utilization since qemu process is
> >> running even though guest who has the power management capability executes mwait.
> >> Actually we can observe the physical cpu has already enter deeper cstate by
> >> powertop on host.
> >>
> >> For virtualization, there is a HLT activity state in CPU VMCS field which indicates
> >> the logical processor is inactive because it executed the HLT instruction, but
> >> SDM 24.4.2 mentioned that execution of the MWAIT instruction may put a logical
> >> processor into an inactive state, however, this VMCS field never reflects this
> >> state.
> >
> > So far I think I can follow, however it does not explain who consumes
> > this VMCS state if it is set and how that helps. Also, this:
>
> I think what Wanpeng was saying is: "KVM could gather this information
> using the activity state field in the VMCS.  However, when the guest
> does MWAIT the processor can go into an inactive state without updating
> the VMCS."  Hence looking at the APERFMPERF ratio.

Ditto. :)

>
> >> This patch avoids fine granularity intercept and reschedule vCPU if MWAIT/HLT
> >> instructions executed, because it can worse the message-passing workloads which
> >> will switch between idle and running frequently in the guest. Lets penalty the
> >> vCPU which is long idle through tick-based sampling and preemption.
> >
> > is just complete gibberish. And I have no idea what problem you're
> > trying to solve how.
>
> This is just explaining why MWAIT and HLT is not being trapped in his
> setup.  (Because vmexit on HLT or MWAIT is awfully expensive).

Ditto. Peterz, do you have nicer solution for this?

    Wanpeng

>
> > Also, I don't think the TSC/MPERF ratio is architected, we can't assume
> > this is true for everything that has APERFMPERF.
>
> Right, you have to look at APERF/MPERF, not TSC/MPERF.  My scheduler-fu
> is zero so I can't really help with a nicer solution.
>
> Paolo
>
