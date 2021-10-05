Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678C142284E
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhJENvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:51:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234636AbhJENvs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633441797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NwRUK5QQPWeF1trrs+wsxCyXJhcpX/CxoItjVPGldec=;
        b=PRGbZCbzMcFOi+fGoLF/axb2SgsjO6eSGjNe5Y+zVl4GSlrd5DNqBm2Xbh3iWD2F2NG5Hf
        shUAZyAd32o0yZHB7iNTLIc9JHM/F7Q2QFcBz4ST+dc7ggIytVzWQU9u5g0+bJDxZ1rcQR
        58H4gSw9NNR0bdjznlgbGlvsrhUf0zg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-7GxeBsunNi2bnsufdtO3wA-1; Tue, 05 Oct 2021 09:49:56 -0400
X-MC-Unique: 7GxeBsunNi2bnsufdtO3wA-1
Received: by mail-lf1-f70.google.com with SMTP id a28-20020a056512021c00b003f5883dcd4bso7627758lfo.1
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwRUK5QQPWeF1trrs+wsxCyXJhcpX/CxoItjVPGldec=;
        b=lgp1nwT2H5yf+D2r1KiySVX6WiPuX2zkyrj5p7bTlai66/lJi5zvrBhVO6PnatMZLz
         VtiysqKqbjABEfJJUHVY8Df9MpeIiww5Zg3IrsS0Ar1s7gc+FCPq7BmEd/k3Axnk7Dcc
         zxi/NQHPTXbAxRj71Qu9hrEfFC6FaLrM6BdcUdGh8B0qr1/eEwD7nsNduafvcxixNnU7
         JOiUSXb9fVAUaYkOAK/Rkhl4sEJ0itKg2JpDRhuRGflDgb+h0W1zqyR2G6EpI30eZEbY
         cLrNiKAr5o+v/RrOkvos2vTLvNE9J91b8GfWxKKxx7/RMqeC9ObWeysQa/kOww6a9emy
         PewQ==
X-Gm-Message-State: AOAM530toEiUzZpdDYzqjFGh7Wrc/+Yvw1Hekffwdz9ihTVtxQ91NOVh
        btBARjX0Pn6FaqGT6220go2jXX9zx54rQfakukuu7N9W5rJIZWxtm9rWQLrJVB+JYffVVHONYC3
        XQKp8SVp86fLnbs8QSd91KbSictfK
X-Received: by 2002:a2e:978a:: with SMTP id y10mr22201385lji.317.1633441795128;
        Tue, 05 Oct 2021 06:49:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTSOKxo8w5tu1zRnqUEtSRVav6LKD5IoSfTUbcxbGCkSh6Fdwm9ShQmWQsDK/EbuKsGt3x0bh9Xr9XmV9fZJA=
X-Received: by 2002:a2e:978a:: with SMTP id y10mr22201346lji.317.1633441794875;
 Tue, 05 Oct 2021 06:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <20211004222639.239209-1-nitesh@redhat.com> <e734691b-e9e1-10a0-88ee-73d8fceb50f9@redhat.com>
 <20211005105812.GA130626@fuller.cnet> <96f38a69-2ff8-a78c-a417-d32f1eb742be@redhat.com>
 <20211005132159.GA134926@fuller.cnet>
In-Reply-To: <20211005132159.GA134926@fuller.cnet>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Tue, 5 Oct 2021 09:49:43 -0400
Message-ID: <CAFki+LmR9bL67D9+dim25J8w3N71eA_BkNcNi3_dEmAB-J553A@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: isolation: retain initial mask for kthread VM worker
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 5, 2021 at 9:22 AM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Tue, Oct 05, 2021 at 01:25:52PM +0200, Paolo Bonzini wrote:
> > On 05/10/21 12:58, Marcelo Tosatti wrote:
> > > > There are other effects of cgroups (e.g. memory accounting) than just the
> > > > cpumask;
> > >
> > > Is kvm-nx-hpage using significant amounts of memory?
> >
> > No, that was just an example (and not a good one indeed, because
> > kvm-nx-hpage is not using a substantial amount of either memory or CPU).
> > But for example vhost also uses cgroup_attach_task_all, so it should have
> > the same issue with SCHED_FIFO?
>
> Yes. Would need to fix vhost as well.
>
> >
> > > > Why doesn't the scheduler move the task to a CPU that is not being hogged by
> > > > vCPU SCHED_FIFO tasks?
> > > Because cpuset placement is enforced:
> >
> > Yes, but I would expect the parent cgroup to include both isolated CPUs (for
> > the vCPU threads) and non-isolated housekeeping vCPUs (for the QEMU I/O
> > thread).
>
> Yes, the parent, but why would that matter? If you are in a child
> cpuset, you are restricted to the child cpuset mask (and not the
> parents).

Yes, and at the time of cpuset_attach, the task is attached to any one of
the CPUs that are in the effective cpumask.

>
> > The QEMU I/O thread is not hogging the CPU 100% of the time, and
> > therefore the nx-recovery thread should be able to run on that CPU.
>
> Yes, but:
>
> 1) The cpumask of the parent thread is not inherited
>
>         set_cpus_allowed_ptr(task, housekeeping_cpumask(HK_FLAG_KTHREAD));
>
> On __kthread_create_on_node should fail (because its cgroup, the one
> inherited from QEMU, contains only isolated CPUs).
>

Just to confirm, do you mean fail only for unbounded kthreads?


-- 
Thanks
Nitesh

