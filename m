Return-Path: <kvm+bounces-13892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2839289C530
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:54:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3CF92832E8
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B947BAEC;
	Mon,  8 Apr 2024 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="Jq49BESc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BC46EB72
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584456; cv=none; b=LkoVafbA+G/lRuP2NYuZHRsSbp5WskqxPYl030S1AvMl8KbuSltvU6sXpkvCJVHZf5au7+I8jzmtf08EO2OwSVaXx8Jk/Y8nBm7K++kdcJH2XD+4Asdy38brhil8WxtXyCfLMS//wwk8ioCBs8gJ/wifSHlugMtEsxCy7KytOgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584456; c=relaxed/simple;
	bh=gh4tpdih8esLI25MktXhFMkdTYnw/T/NHIj4HYT3EbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A1X67IWJPkHHyv4VipKXKTdzyHrv8kZIVMoVF9CYK3sexb0MFAN4srV1hJguchvH4xVuw6x98rNWRyoK80+71mWvOnrPxN5x/DVe9wsY1HBBAE3JzTLHYdsoKYJlJ07fWJ8fARnvWHxZzEvV+byBBTSFXR/dIJuNGPDFzesmyfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=Jq49BESc; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dcc84ae94c1so4665745276.1
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 06:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712584454; x=1713189254; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6kKl1aVWYliHDaR8y7CAp1UicpeJTf7oqPqbEf20fQ=;
        b=Jq49BEScC06+wCNJ9QgSlmh7eHiZZ4IWSBL2RNFdYJ0mJ30HmdCibEUW6A/fBJtZUq
         vMZ2mFrksCGWwLM2NJ05c8PJ/5anSh8yDEwOYRtpMt20cS7r7IW/TgHQphYgJ93r+Fr3
         sjstIp3cNuyb2PJLAjI1ihbqkMbSLZPJqHpGLKxeLMClRmhSJv+AFoeAzAQsA+N/XTnD
         ZeahT5BAYxjpN5ufms7R09wfFb1yAkr9o4vEyAc/0ooiBOu8XBMDyWATiaY/6SiM2hgY
         qhhbB/4Nw/qm2ZQGF4tg6BhxbdQe++nnzfNqHCrbe7fDEskNMSqDEfEXm5qTbpjwJx4y
         kJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712584454; x=1713189254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6kKl1aVWYliHDaR8y7CAp1UicpeJTf7oqPqbEf20fQ=;
        b=LID8j0Lrqpjv8noMBN73jYn6Tj0Ba35sW+L6na6FkiSWDEGfsBE+wazs45qfEuojoR
         NOgXD4Rfwi2f1MHpPQV7TBpJyLsH2uYh71MI7mXFHYrKMOcGbLfNxhLWt3ORsfJf8eMX
         CyqNeaQICn3FLusOJlpx1TvX1V9tqzHevfV78mQuW318eIVYuP1SoLEeUsNFWSQijnvB
         1h3djHED0R+6+j7q15VbjKrpnCDpp5Kxm5OpGIMsEUg3e8rticf0phbJYrZ70R9vFRg1
         r1ApDwMKqFOc1a2JW3X0ZaESqIK5zzWwUNXUWKOAQFSpGPrJUMxgOxuer8v7o/g/lmLQ
         AnmA==
X-Forwarded-Encrypted: i=1; AJvYcCWBNv6WKTyQjE1maWKH7I7Cb0ocfYcdkF91GF/ecx8PS7axyJsLlffF2Noa9uc7tE0FpxO2Jw4xGV+joh6DaMiapbTH
X-Gm-Message-State: AOJu0Yw+TXEx0r12RaBhjqSnaBjizzyf6LL25HpshCYAhUlFJ674EC0j
	ljdI0bDS2RyTVuahWP6Q0KJ7tnBEaiiN7m6KGS+quj+zJcFH7GIVED+AGDX3O5zaeofO+8fHK5Y
	S7hucRFloiL+i5SgsB0o4U96yqlNhNRmXK6mRAg==
X-Google-Smtp-Source: AGHT+IH6aYXDJY7AtBiVf3L56XP6JRG4Itct4K0aXsB9PQJoxGQyOcejapCFG8ilC7sE1YFX78GSj6rciiivOwMMtq8=
X-Received: by 2002:a25:360a:0:b0:de0:e368:fa59 with SMTP id
 d10-20020a25360a000000b00de0e368fa59mr3644918yba.31.1712584453724; Mon, 08
 Apr 2024 06:54:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
In-Reply-To: <20240403140116.3002809-1-vineeth@bitbyteword.org>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Mon, 8 Apr 2024 09:54:03 -0400
Message-ID: <CAO7JXPiiN+w+Liuov3rXAbr1QLwt+eUq=4Weoy8gB0fXaC7D3Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
To: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Joel Fernandes <joel@joelfernandes.org>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>, 
	David Vernet <dvernet@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry I missed sched_ext folks, adding them as well.

Thanks,
Vineeth


On Wed, Apr 3, 2024 at 10:01=E2=80=AFAM Vineeth Pillai (Google)
<vineeth@bitbyteword.org> wrote:
>
> Double scheduling is a concern with virtualization hosts where the host
> schedules vcpus without knowing whats run by the vcpu and guest schedules
> tasks without knowing where the vcpu is physically running. This causes
> issues related to latencies, power consumption, resource utilization
> etc. An ideal solution would be to have a cooperative scheduling
> framework where the guest and host shares scheduling related information
> and makes an educated scheduling decision to optimally handle the
> workloads. As a first step, we are taking a stab at reducing latencies
> for latency sensitive workloads in the guest.
>
> v1 RFC[1] was posted in December 2023. The main disagreement was in the
> implementation where the patch was making scheduling policy decisions
> in kvm and kvm is not the right place to do it. The suggestion was to
> move the polcy decisions outside of kvm and let kvm only handle the
> notifications needed to make the policy decisions. This patch series is
> an iterative step towards implementing the feature as a layered
> design where the policy could be implemented outside of kvm as a
> kernel built-in, a kernel module or a bpf program.
>
> This design comprises mainly of 4 components:
>
> - pvsched driver: Implements the scheduling policies. Register with
>     host with a set of callbacks that hypervisor(kvm) can use to notify
>     vcpu events that the driver is interested in. The callback will be
>     passed in the address of shared memory so that the driver can get
>     scheduling information shared by the guest and also update the
>     scheduling policies set by the driver.
> - kvm component: Selects the pvsched driver for a guest and notifies
>     the driver via callbacks for events that the driver is interested
>     in. Also interface with the guest in retreiving the shared memory
>     region for sharing the scheduling information.
> - host kernel component: Implements the APIs for:
>     - pvsched driver for register/unregister to the host kernel, and
>     - hypervisor for assingning/unassigning driver for guests.
> - guest component: Implements a framework for sharing the scheduling
>     information with the pvsched driver through kvm.
>
> There is another component that we refer to as pvsched protocol. This
> defines the details about shared memory layout, information sharing and
> sheduling policy decisions. The protocol need not be part of the kernel
> and can be defined separately based on the use case and requirements.
> Both guest and the selected pvsched driver need to match the protocol
> for the feature to work. Protocol shall be identified by a name and a
> possible versioning scheme. Guest will advertise the protocol and then
> the hypervisor can assign the driver implementing the protocol if it is
> registered in the host kernel.
>
> This patch series only implements the first 3 components. Guest side
> implementation and the protocol framework shall come as a separate
> series once we finalize rest of the design.
>
> This series also implements a sample bpf program and a kernel-builtin
> pvsched drivers. They do not do any real stuff now, but just skeletons
> to demonstrate the feature.
>
> Rebased on 6.8.2.
>
> [1]: https://lwn.net/Articles/955145/
>
> Vineeth Pillai (Google) (5):
>   pvsched: paravirt scheduling framework
>   kvm: Implement the paravirt sched framework for kvm
>   kvm: interface for managing pvsched driver for guest VMs
>   pvsched: bpf support for pvsched
>   selftests/bpf: sample implementation of a bpf pvsched driver.
>
>  Kconfig                                       |   2 +
>  arch/x86/kvm/Kconfig                          |  13 +
>  arch/x86/kvm/x86.c                            |   3 +
>  include/linux/kvm_host.h                      |  32 +++
>  include/linux/pvsched.h                       | 102 +++++++
>  include/uapi/linux/kvm.h                      |   6 +
>  kernel/bpf/bpf_struct_ops_types.h             |   4 +
>  kernel/sysctl.c                               |  27 ++
>  .../testing/selftests/bpf/progs/bpf_pvsched.c |  37 +++
>  virt/Makefile                                 |   2 +-
>  virt/kvm/kvm_main.c                           | 265 ++++++++++++++++++
>  virt/pvsched/Kconfig                          |  12 +
>  virt/pvsched/Makefile                         |   2 +
>  virt/pvsched/pvsched.c                        | 215 ++++++++++++++
>  virt/pvsched/pvsched_bpf.c                    | 141 ++++++++++
>  15 files changed, 862 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/pvsched.h
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_pvsched.c
>  create mode 100644 virt/pvsched/Kconfig
>  create mode 100644 virt/pvsched/Makefile
>  create mode 100644 virt/pvsched/pvsched.c
>  create mode 100644 virt/pvsched/pvsched_bpf.c
>
> --
> 2.40.1
>

