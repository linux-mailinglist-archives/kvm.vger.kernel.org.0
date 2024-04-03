Return-Path: <kvm+bounces-13463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CC98971D7
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 16:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12756284B99
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6932A148FF9;
	Wed,  3 Apr 2024 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="W4j0S++4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC5B148305
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712152884; cv=none; b=sh+eEFnGjhsKsJHN0dv8eNQXTsrMDmAfs1icIgY8V44RiKOx1x9iF48Vjc9GbKec+28ILG6PkgKAWGjC3IrOuMpBuJeR3ubs98I/EO2SgYoPWb48gGdPP8bj6DQN3ebNDieK0yF9bwcAsGoDXfBfY5qAiL04J4FmsqHOyhbFCXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712152884; c=relaxed/simple;
	bh=ruDMjtVVp5BkrUEEsrxmZrEipStWn3hR+25ipM0MZrA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YRpODe66hRVCwBGEQ+gHEsM7/2Js4RtjFIxoZD/IivntkYSPTD9xt+GWDnt3JR8xv5ETnn/A0Bm1B4p0pxCnmaJxE0UBmDjBPG/pkAZwkaM3hRNfiAfkhd+Y1nAfwtnv6vpyZmUhwHRNKbKPhoy0iqFGeV5J6uZhcA2tpJNn2UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=W4j0S++4; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-29c14800a7fso4300529a91.2
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 07:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712152882; x=1712757682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U30JYseMFNAt2UEXcGUojDtvJPA7ZF2ITHecz2a6gdU=;
        b=W4j0S++4wFWTCIiiAEmMPMJLYPl02KhN6dShKLhmchSwTcxSwW4y2Pox7qawQgS/8w
         +KFJX1xEIiLhjr95TVJhZsG/p/0oXx3gY0efm0Idvu2x/AtKJ58osvbOWHeIanG4o0V9
         fOaNXbBKP9Mhw2kt2Dv8UC9bhg79xgGGxLHvxHOAd5/4Y22ERY5kEqpCZBnliD7yUA3u
         XFLEgP7nl9UF5gTehtTkY3zkA92m7+ByFCNSDzaXZ9V+kfMaArj6l0YSNA873Ik+kJwS
         UPWU8B52zMynR8sFh3T4iuWbazO1ZNf2APBtld4Dg+HfofIBH4/IOJgbSa6rdmuf+Son
         wEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712152882; x=1712757682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U30JYseMFNAt2UEXcGUojDtvJPA7ZF2ITHecz2a6gdU=;
        b=T1sYs9/bTo1ywIx3y04DZkjUAjuIpfMmQLvW01rxkx5GgyEbIrUrRMVPgca8F1Goj/
         Pod8bzEhbUAJz0h+jfgBNRkItif10+0VgDVUud1iXIytr52WPbIW17oKNPQcQNTyPifw
         rgfZmKx1ON27/rf0jNgui5Jq3Jok71ak767+SkyuKFYAltyO1AFXiBphkzIbyWTBqBLE
         njpraRN1+I38tJDhi68Qe1lMfhyJnWSjIMaL5YKZzBfM371E7MhVfwRaLvOWNu53AKiE
         h8IKAz2PM+f6c7JeWmZ+TF3fdmOTTUHyirCxFyf26i2G+xfqmLvesPnRUPrOQLeQO4CQ
         QdJw==
X-Forwarded-Encrypted: i=1; AJvYcCUwCTeSJ9tGfyPmwH4WrRsg3Iaby/OlvdqDWrNZcNk4E0Op84pGFpz8fXdCaM+9sCOGAOE/fYD6a0BB50pfxEQO3XUG
X-Gm-Message-State: AOJu0Yy0/FsNlKjjdLTUfrqlOozKTUTBcbtUeGfrZsO56uWlXIRRO+gC
	dboypAU+8UIR5/R61znhS95J8YcOzamgWOiInsJtDN/isnhWOGHQIKGJ+gSNOrV0tFQ51REcVWt
	u
X-Google-Smtp-Source: AGHT+IH/TtVeEQl1VFcRM22ZWQxWIV1mailFASsP/oYpLdJnHF0HixlBhF2wIonXlo0hY1PhuI+yBg==
X-Received: by 2002:a17:90a:68c6:b0:2a2:bc00:516a with SMTP id q6-20020a17090a68c600b002a2bc00516amr258848pjj.5.1712152881476;
        Wed, 03 Apr 2024 07:01:21 -0700 (PDT)
Received: from vinbuntup3.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id gf12-20020a056214250c00b00698d06df322sm5945706qvb.122.2024.04.03.07.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 07:01:21 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	himadrics@inria.fr,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
Date: Wed,  3 Apr 2024 10:01:11 -0400
Message-Id: <20240403140116.3002809-1-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Double scheduling is a concern with virtualization hosts where the host
schedules vcpus without knowing whats run by the vcpu and guest schedules
tasks without knowing where the vcpu is physically running. This causes
issues related to latencies, power consumption, resource utilization
etc. An ideal solution would be to have a cooperative scheduling
framework where the guest and host shares scheduling related information
and makes an educated scheduling decision to optimally handle the
workloads. As a first step, we are taking a stab at reducing latencies
for latency sensitive workloads in the guest.

v1 RFC[1] was posted in December 2023. The main disagreement was in the
implementation where the patch was making scheduling policy decisions
in kvm and kvm is not the right place to do it. The suggestion was to
move the polcy decisions outside of kvm and let kvm only handle the
notifications needed to make the policy decisions. This patch series is
an iterative step towards implementing the feature as a layered
design where the policy could be implemented outside of kvm as a
kernel built-in, a kernel module or a bpf program.

This design comprises mainly of 4 components:

- pvsched driver: Implements the scheduling policies. Register with
    host with a set of callbacks that hypervisor(kvm) can use to notify
    vcpu events that the driver is interested in. The callback will be
    passed in the address of shared memory so that the driver can get
    scheduling information shared by the guest and also update the
    scheduling policies set by the driver.
- kvm component: Selects the pvsched driver for a guest and notifies
    the driver via callbacks for events that the driver is interested
    in. Also interface with the guest in retreiving the shared memory
    region for sharing the scheduling information.
- host kernel component: Implements the APIs for:
    - pvsched driver for register/unregister to the host kernel, and
    - hypervisor for assingning/unassigning driver for guests.
- guest component: Implements a framework for sharing the scheduling
    information with the pvsched driver through kvm.

There is another component that we refer to as pvsched protocol. This
defines the details about shared memory layout, information sharing and
sheduling policy decisions. The protocol need not be part of the kernel
and can be defined separately based on the use case and requirements.
Both guest and the selected pvsched driver need to match the protocol
for the feature to work. Protocol shall be identified by a name and a
possible versioning scheme. Guest will advertise the protocol and then
the hypervisor can assign the driver implementing the protocol if it is
registered in the host kernel.

This patch series only implements the first 3 components. Guest side
implementation and the protocol framework shall come as a separate
series once we finalize rest of the design.

This series also implements a sample bpf program and a kernel-builtin
pvsched drivers. They do not do any real stuff now, but just skeletons
to demonstrate the feature.

Rebased on 6.8.2.

[1]: https://lwn.net/Articles/955145/

Vineeth Pillai (Google) (5):
  pvsched: paravirt scheduling framework
  kvm: Implement the paravirt sched framework for kvm
  kvm: interface for managing pvsched driver for guest VMs
  pvsched: bpf support for pvsched
  selftests/bpf: sample implementation of a bpf pvsched driver.

 Kconfig                                       |   2 +
 arch/x86/kvm/Kconfig                          |  13 +
 arch/x86/kvm/x86.c                            |   3 +
 include/linux/kvm_host.h                      |  32 +++
 include/linux/pvsched.h                       | 102 +++++++
 include/uapi/linux/kvm.h                      |   6 +
 kernel/bpf/bpf_struct_ops_types.h             |   4 +
 kernel/sysctl.c                               |  27 ++
 .../testing/selftests/bpf/progs/bpf_pvsched.c |  37 +++
 virt/Makefile                                 |   2 +-
 virt/kvm/kvm_main.c                           | 265 ++++++++++++++++++
 virt/pvsched/Kconfig                          |  12 +
 virt/pvsched/Makefile                         |   2 +
 virt/pvsched/pvsched.c                        | 215 ++++++++++++++
 virt/pvsched/pvsched_bpf.c                    | 141 ++++++++++
 15 files changed, 862 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/pvsched.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_pvsched.c
 create mode 100644 virt/pvsched/Kconfig
 create mode 100644 virt/pvsched/Makefile
 create mode 100644 virt/pvsched/pvsched.c
 create mode 100644 virt/pvsched/pvsched_bpf.c

-- 
2.40.1


