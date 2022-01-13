Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4219148DA9F
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 16:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiAMPWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 10:22:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234077AbiAMPWD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 10:22:03 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DEsTYG013407;
        Thu, 13 Jan 2022 15:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ILFW13XQR2R0Psh3QDuFQB4Mp2mZ2+sgRmiRfmOA2HI=;
 b=h3GiLW4ye9Oeb7/sP5E8wSA8Id4z0dC627V8qEiE+qz03vkFnZtRNwgjwPRNEN+VIItx
 74Jg0Hm/QRTss/j61zj/obR4M4OAtSYCIdUEIjb2tDCyC0ZxX35lVMDZgMyPdgBEWnH9
 USRuJAW7Yfbl8ae4E6hlky+ZNhYylEb/ta4LvwpFrytgoSKoAgPVQG+uJ0EtQqjU1Q03
 9UWdtiQk5zML+75yLZi5yKipgFgATg4b377pz7e80u+/eNZhILHLk+6TPkKXCoXPXvYm
 CmemMdllkiCKXU36HnzYQ2WTpksWwla1HDDiwY4/fxEyhjinweDj07eO0fUh+Nihpmeq tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djp8rrhy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 15:20:16 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DFHDD9005449;
        Thu, 13 Jan 2022 15:20:15 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djp8rrhx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 15:20:15 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DFDRYv009563;
        Thu, 13 Jan 2022 15:20:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3df289p0j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 15:20:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DFK9Pk47514010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 15:20:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03FC45207B;
        Thu, 13 Jan 2022 15:20:09 +0000 (GMT)
Received: from [9.171.57.64] (unknown [9.171.57.64])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7014F52065;
        Thu, 13 Jan 2022 15:20:07 +0000 (GMT)
Message-ID: <127a6117-85fb-7477-983c-daf09e91349d@linux.ibm.com>
Date:   Thu, 13 Jan 2022 16:20:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org
Cc:     aleksandar.qemu.devel@gmail.com, alexandru.elisei@arm.com,
        anup.patel@wdc.com, aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
        chenhuacai@kernel.org, dave.hansen@linux.intel.com,
        david@redhat.com, frankja@linux.ibm.com, frederic@kernel.org,
        gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        james.morse@arm.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        pbonzini@redhat.com, seanjc@google.com, suzuki.poulose@arm.com,
        tglx@linutronix.de, tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
References: <20220111153539.2532246-1-mark.rutland@arm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220111153539.2532246-1-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WR37CbVEvuCbYDLrnAi2fM689Gd4vQ6i
X-Proofpoint-GUID: nbzlFvdVP5ZeHJEIhsritLL70tdt8g1G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_07,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=927 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 11.01.22 um 16:35 schrieb Mark Rutland:
> Several architectures have latent bugs around guest entry/exit, most
> notably:
> 
> 1) Several architectures enable interrupts between guest_enter() and
>     guest_exit(). As this period is an RCU extended quiescent state (EQS) this
>     is unsound unless the irq entry code explicitly wakes RCU, which most
>     architectures only do for entry from usersapce or idle.
> 
>     I believe this affects: arm64, riscv, s390
> 
>     I am not sure about powerpc.
> 
> 2) Several architectures permit instrumentation of code between
>     guest_enter() and guest_exit(), e.g. KASAN, KCOV, KCSAN, etc. As
>     instrumentation may directly o indirectly use RCU, this has the same
>     problems as with interrupts.
> 
>     I believe this affects: arm64, mips, powerpc, riscv, s390
> 
> 3) Several architectures do not inform lockdep and tracing that
>     interrupts are enabled during the execution of the guest, or do so in
>     an incorrect order. Generally
>     this means that logs will report IRQs being masked for much longer
>     than is actually the case, which is not ideal for debugging. I don't
>     know whether this affects the correctness of lockdep.
> 
>     I believe this affects: arm64, mips, powerpc, riscv, s390
> 
> This was previously fixed for x86 specifically in a series of commits:
> 
>    87fa7f3e98a1310e ("x86/kvm: Move context tracking where it belongs")
>    0642391e2139a2c1 ("x86/kvm/vmx: Add hardirq tracing to guest enter/exit")
>    9fc975e9efd03e57 ("x86/kvm/svm: Add hardirq tracing on guest enter/exit")
>    3ebccdf373c21d86 ("x86/kvm/vmx: Move guest enter/exit into .noinstr.text")
>    135961e0a7d555fc ("x86/kvm/svm: Move guest enter/exit into .noinstr.text")
>    160457140187c5fb ("KVM: x86: Defer vtime accounting 'til after IRQ handling")
>    bc908e091b326467 ("KVM: x86: Consolidate guest enter/exit logic to common helpers")
> 
> But other architectures were left broken, and the infrastructure for
> handling this correctly is x86-specific.
> 
> This series introduces generic helper functions which can be used to
> handle the problems above, and migrates architectures over to these,
> fixing the latent issues.
> 
> I wasn't able to figure my way around powerpc and s390, so I have not

I think 2 later patches have moved the guest_enter/exit a bit out.
Does this make the s390 code clearer?

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 577f1ead6a51..5859207c2cc0 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4145,10 +4145,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
                  * As PF_VCPU will be used in fault handler, between
                  * guest_enter and guest_exit should be no uaccess.
                  */
-               local_irq_disable();
-               guest_enter_irqoff();
-               __disable_cpu_timer_accounting(vcpu);
-               local_irq_enable();
                 if (kvm_s390_pv_cpu_is_protected(vcpu)) {
                         memcpy(sie_page->pv_grregs,
                                vcpu->run->s.regs.gprs,
@@ -4156,8 +4152,16 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
                 }
                 if (test_cpu_flag(CIF_FPU))
                         load_fpu_regs();
+               local_irq_disable();
+               __disable_cpu_timer_accounting(vcpu);
+               guest_enter_irqoff();
+               local_irq_enable();
                 exit_reason = sie64a(vcpu->arch.sie_block,
                                      vcpu->run->s.regs.gprs);
+               local_irq_disable();
+               guest_exit_irqoff();
+               __enable_cpu_timer_accounting(vcpu);
+               local_irq_enable();
                 if (kvm_s390_pv_cpu_is_protected(vcpu)) {
                         memcpy(vcpu->run->s.regs.gprs,
                                sie_page->pv_grregs,
@@ -4173,10 +4177,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
                                 vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;
                         }
                 }
-               local_irq_disable();
-               __enable_cpu_timer_accounting(vcpu);
-               guest_exit_irqoff();
-               local_irq_enable();
                 vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
  
                 rc = vcpu_post_run(vcpu, exit_reason);
