Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD4A43AD21
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 09:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhJZHYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 03:24:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33278 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232528AbhJZHYK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 03:24:10 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q4iNBE021439;
        Tue, 26 Oct 2021 07:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Olukvk8q/6M5vaMGvBvWcSri6ngs7Qe9V4nVbNTAMJQ=;
 b=Nyx3w1bGlQFD8DW3/nbHsdwCZZEZKGyQHe82atvEnyRHiFaWUP0o/LcZBhheUCum6Om6
 Hvt3TDj3dG/5nLAOtCpCj79o1m4T82eNP+stFdX61QoG9XYNt8WI04k33BOk+NWU7/pX
 o99JSi/86Ke8XVejmEPBLDeiuOIG7dXV+JeQDj01Q+0UEfjjnCW0QAKX7scrDv5LCZYd
 CfDljh2FyONxqT1znLtJ+r+R6igzoddCe3bl0Fke5neczs5v5mrIGfP2WPPkEGikjugR
 T+hvH4iJQ8hPkXNrEG0PzIBJD5OZI/DkkLVRrDdXD1ZzWIFzNHxluRDEJaeckjZ6jNYs qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4k83yef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 07:20:54 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19Q7GPjC031880;
        Tue, 26 Oct 2021 07:20:53 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4k83ydb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 07:20:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19Q7CNIf001730;
        Tue, 26 Oct 2021 07:20:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3bx4estw59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 07:20:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19Q7KlwR49480020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 07:20:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BB0352063;
        Tue, 26 Oct 2021 07:20:47 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.51.215])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DF3745204F;
        Tue, 26 Oct 2021 07:20:45 +0000 (GMT)
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <04b1a72e-47b4-4bde-eb9e-ba36c156ff0d@de.ibm.com>
Date:   Tue, 26 Oct 2021 09:20:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9pKTY4MsH4PMCMPB45BmL813hD3MQPUl
X-Proofpoint-ORIG-GUID: HiwQM4uJCHKEZaVYE6osYmazrosz4OIK
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_08,2021-10-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260039
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 09.10.21 um 04:11 schrieb Sean Christopherson:
> This is basically two series smushed into one.  The first "half" aims
> to differentiate between "halt" and a more generic "block", where "halt"
> aligns with x86's HLT instruction, the halt-polling mechanisms, and
> associated stats, and "block" means any guest action that causes the vCPU
> to block/wait.
> 
> The second "half" overhauls x86's APIC virtualization code (Posted
> Interrupts on Intel VMX, AVIC on AMD SVM) to do their updates in response
> to vCPU (un)blocking in the vcpu_load/put() paths, keying off of the
> vCPU's rcuwait status to determine when a blocking vCPU is being put and
> reloaded.  This idea comes from arm64's kvm_timer_vcpu_put(), which I
> stumbled across when diving into the history of arm64's (un)blocking hooks.
> 
> The x86 APICv overhaul allows for killing off several sets of hooks in
> common KVM and in x86 KVM (to the vendor code).  Moving everything to
> vcpu_put/load() also realizes nice cleanups, especially for the Posted
> Interrupt code, which required some impressive mental gymnastics to
> understand how vCPU task migration interacted with vCPU blocking.
> 
> Non-x86 folks, sorry for the noise.  I'm hoping the common parts can get
> applied without much fuss so that future versions can be x86-only.
> 
> v2:
>   - Collect reviews. [Christian, David]
>   - Add patch to move arm64 WFI functionality out of hooks. [Marc]
>   - Add RISC-V to the fun.
>   - Add all the APICv fun.

Have we actually followed up on the regression regarding halt_poll_ns=0 no longer disabling
polling for running systems?

> 
> v1: https://lkml.kernel.org/r/20210925005528.1145584-1-seanjc@google.com
> 
> Jing Zhang (1):
>    KVM: stats: Add stat to detect if vcpu is currently blocking
> 
> Sean Christopherson (42):
>    KVM: VMX: Don't unblock vCPU w/ Posted IRQ if IRQs are disabled in
>      guest
>    KVM: SVM: Ensure target pCPU is read once when signalling AVIC
>      doorbell
>    KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU
>    KVM: Force PPC to define its own rcuwait object
>    KVM: Update halt-polling stats if and only if halt-polling was
>      attempted
>    KVM: Refactor and document halt-polling stats update helper
>    KVM: Reconcile discrepancies in halt-polling stats
>    KVM: s390: Clear valid_wakeup in kvm_s390_handle_wait(), not in arch
>      hook
>    KVM: Drop obsolete kvm_arch_vcpu_block_finish()
>    KVM: arm64: Move vGIC v4 handling for WFI out arch callback hook
>    KVM: Don't block+unblock when halt-polling is successful
>    KVM: x86: Tweak halt emulation helper names to free up kvm_vcpu_halt()
>    KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
>    KVM: Split out a kvm_vcpu_block() helper from kvm_vcpu_halt()
>    KVM: Don't redo ktime_get() when calculating halt-polling
>      stop/deadline
>    KVM: x86: Directly block (instead of "halting") UNINITIALIZED vCPUs
>    KVM: x86: Invoke kvm_vcpu_block() directly for non-HALTED wait states
>    KVM: Add helpers to wake/query blocking vCPU
>    KVM: VMX: Skip Posted Interrupt updates if APICv is hard disabled
>    KVM: VMX: Clean up PI pre/post-block WARNs
>    KVM: VMX: Drop unnecessary PI logic to handle impossible conditions
>    KVM: VMX: Use boolean returns for Posted Interrupt "test" helpers
>    KVM: VMX: Drop pointless PI.NDST update when blocking
>    KVM: VMX: Save/restore IRQs (instead of CLI/STI) during PI pre/post
>      block
>    KVM: VMX: Read Posted Interrupt "control" exactly once per loop
>      iteration
>    KVM: VMX: Move Posted Interrupt ndst computation out of write loop
>    KVM: VMX: Remove vCPU from PI wakeup list before updating PID.NV
>    KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load
>    KVM: Drop unused kvm_vcpu.pre_pcpu field
>    KVM: Move x86 VMX's posted interrupt list_head to vcpu_vmx
>    KVM: VMX: Move preemption timer <=> hrtimer dance to common x86
>    KVM: x86: Unexport LAPIC's switch_to_{hv,sw}_timer() helpers
>    KVM: x86: Remove defunct pre_block/post_block kvm_x86_ops hooks
>    KVM: SVM: Signal AVIC doorbell iff vCPU is in guest mode
>    KVM: SVM: Don't bother checking for "running" AVIC when kicking for
>      IPIs
>    KVM: SVM: Unconditionally mark AVIC as running on vCPU load (with
>      APICv)
>    KVM: Drop defunct kvm_arch_vcpu_(un)blocking() hooks
>    KVM: VMX: Don't do full kick when triggering posted interrupt "fails"
>    KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this
>      vCPU
>    KVM: VMX: Pass desired vector instead of bool for triggering posted
>      IRQ
>    KVM: VMX: Fold fallback path into triggering posted IRQ helper
>    KVM: VMX: Don't do full kick when handling posted interrupt wakeup
> 
>   arch/arm64/include/asm/kvm_emulate.h |   2 +
>   arch/arm64/include/asm/kvm_host.h    |   1 -
>   arch/arm64/kvm/arch_timer.c          |   5 +-
>   arch/arm64/kvm/arm.c                 |  60 +++---
>   arch/arm64/kvm/handle_exit.c         |   5 +-
>   arch/arm64/kvm/psci.c                |   2 +-
>   arch/mips/include/asm/kvm_host.h     |   3 -
>   arch/mips/kvm/emulate.c              |   2 +-
>   arch/powerpc/include/asm/kvm_host.h  |   4 +-
>   arch/powerpc/kvm/book3s_pr.c         |   2 +-
>   arch/powerpc/kvm/book3s_pr_papr.c    |   2 +-
>   arch/powerpc/kvm/booke.c             |   2 +-
>   arch/powerpc/kvm/powerpc.c           |   5 +-
>   arch/riscv/include/asm/kvm_host.h    |   1 -
>   arch/riscv/kvm/vcpu_exit.c           |   2 +-
>   arch/s390/include/asm/kvm_host.h     |   4 -
>   arch/s390/kvm/interrupt.c            |   3 +-
>   arch/s390/kvm/kvm-s390.c             |   7 +-
>   arch/x86/include/asm/kvm-x86-ops.h   |   4 -
>   arch/x86/include/asm/kvm_host.h      |  29 +--
>   arch/x86/kvm/lapic.c                 |   4 +-
>   arch/x86/kvm/svm/avic.c              |  95 ++++-----
>   arch/x86/kvm/svm/svm.c               |   8 -
>   arch/x86/kvm/svm/svm.h               |  14 --
>   arch/x86/kvm/vmx/nested.c            |   2 +-
>   arch/x86/kvm/vmx/posted_intr.c       | 279 ++++++++++++---------------
>   arch/x86/kvm/vmx/posted_intr.h       |  14 +-
>   arch/x86/kvm/vmx/vmx.c               |  63 +++---
>   arch/x86/kvm/vmx/vmx.h               |   3 +
>   arch/x86/kvm/x86.c                   |  55 ++++--
>   include/linux/kvm_host.h             |  27 ++-
>   include/linux/kvm_types.h            |   1 +
>   virt/kvm/async_pf.c                  |   2 +-
>   virt/kvm/kvm_main.c                  | 138 +++++++------
>   34 files changed, 413 insertions(+), 437 deletions(-)
> 
