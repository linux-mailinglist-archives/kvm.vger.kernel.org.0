Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C1E667C0
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 09:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfGLH0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 03:26:18 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44080 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfGLH0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 03:26:18 -0400
Received: by mail-ot1-f66.google.com with SMTP id b7so8505022otl.11;
        Fri, 12 Jul 2019 00:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VNJoqRcbKfhKDWhUvxkLWT9gQ3/MJRqP0B1UNXuiT+8=;
        b=jtk0aFMgPDlpMm17OP1lFrIdxOQ0uzR0e3NMANmavwJE6BItiooHjsecvrMVwueA67
         ceZGyHG/4TuyMk7CfqWZhfZ4VYBugW9pCFEa6a9o51IqD8WrRgzX29CF8nIMp6rHsbn3
         exyCxg65v5NW1T5VnJkHqyoDx0NHwaJlR7Tanb/N+aEyDZ0rnj47HqNV1t8N3/RkbVmr
         GR/2n9vDXMruYdWSmwOw14Bgl1EkfidHPoW5Cpuizhci+YGoMEOH55EbZWOabrPOacwM
         xtFf2t5nb5hfW7IGcfeBiqFTxDMIi5qGqpzLh1SmPeWlJhdQXwwBFLQo715gdsuN+n/C
         +QdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VNJoqRcbKfhKDWhUvxkLWT9gQ3/MJRqP0B1UNXuiT+8=;
        b=qaBhxibKqP1IDS3rXyQ/moNrOgBHuZN1NMXOBSoKDNMghRaPJ4Jpx0S2AeuMCPsZJ8
         Vm6pAI9/tq7cDAoF5/f7uT+++cnWVQbXjali34zUA4tGiaY6PYKIPULAoi/+7FJYD+4p
         Y0eBCIQGOZeyFoZO/VbGiB6RYoXY6ry1ohBCdVZikH3xgeFTAtvW9INrGrTYEbeiCgsO
         wX/QhNz1kNwmEthBCpP0MKa0BrIFu6TXJ04iDuBP5ng3IxeI1R9Gh9gtGg14qQ61CBbz
         CiFHrN1BMUyhwJ5pSOYpmSCTz2RXeMDyK8upx0hc/OUABUT0i9Y0RBM7QzzUclX9uhiH
         6TTQ==
X-Gm-Message-State: APjAAAW85i/ur0+QJ1pRjJvHxnCyie5cUbKLNluWbAeGAcwAVGZW9geU
        O3K601M5L45JFHlRdHbw6KRPnJfaR2IPY5zrTWoLvM4Y
X-Google-Smtp-Source: APXvYqxZ48Ky19BaIBic7RiSxjxV70cGtBoykOEGaL6a1fjG15SWP04gqSUsJOcP1Frrrm3Y0jMGzL1WW/fiAhUJs34=
X-Received: by 2002:a9d:4590:: with SMTP id x16mr6715741ote.254.1562916377053;
 Fri, 12 Jul 2019 00:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 12 Jul 2019 15:25:55 +0800
Message-ID: <CANRm+Cz-FuQ4hvDOUVn-1_H8hH9uOv=+N7R5YaFUw6kPFTC_4Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] KVM: Boosting vCPUs that are delivering interrupts
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Jul 2019 at 15:15, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Inspired by commit 9cac38dd5d (KVM/s390: Set preempted flag during vcpu w=
akeup
> and interrupt delivery), except the lock holder, we want to also boost vC=
PUs
> that are delivering interrupts. Actually most smp_call_function_many call=
s are
> synchronous ipi calls, the ipi target vCPUs are also good yield candidate=
s.
> This patch sets preempted flag during wakeup and interrupt delivery time.
>

I forgot to mention that I disable pv tlb shootdown during testing,
function call interrupts are not easy to be triggered directly by
userspace workloads, in addition, distros' guest kernel w/o pv tlb
shootdown support can also get benefit in both tlb shootdown and
function call interrupts scenarios.

> Testing on 80 HT 2 socket Xeon Skylake server, with 80 vCPUs VM 80GB RAM:
> ebizzy -M
>
>             vanilla     boosting    improved
> 1VM          23000       21232        -9%
> 2VM           2800        8000       180%
> 3VM           1800        3100        72%
>
> Testing on my Haswell desktop 8 HT, with 8 vCPUs VM 8GB RAM, two VMs,
> one running ebizzy -M, the other running 'stress --cpu 2':
>
> w/ boosting + w/o pv sched yield(vanilla)
>
>             vanilla     boosting   improved
>               1570         4000       55%
>
> w/ boosting + w/ pv sched yield(vanilla)
>
>             vanilla     boosting   improved
>               1844         5157       79%
>
> w/o boosting, perf top in VM:
>
>  72.33%  [kernel]       [k] smp_call_function_many
>   4.22%  [kernel]       [k] call_function_i
>   3.71%  [kernel]       [k] async_page_fault
>
> w/ boosting, perf top in VM:
>
>  38.43%  [kernel]       [k] smp_call_function_many
>   6.31%  [kernel]       [k] async_page_fault
>   6.13%  libc-2.23.so   [.] __memcpy_avx_unaligned
>   4.88%  [kernel]       [k] call_function_interrupt
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  virt/kvm/kvm_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b4ab59d..2c46705 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2404,8 +2404,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>         int me;
>         int cpu =3D vcpu->cpu;
>
> -       if (kvm_vcpu_wake_up(vcpu))
> +       if (kvm_vcpu_wake_up(vcpu)) {
> +               vcpu->preempted =3D true;
>                 return;
> +       }
>
>         me =3D get_cpu();
>         if (cpu !=3D me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> --
> 2.7.4
>
