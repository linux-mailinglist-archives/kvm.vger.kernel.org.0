Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EAD42FD9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 21:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfFLTWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 15:22:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbfFLTWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 15:22:47 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3DFCE30872DD;
        Wed, 12 Jun 2019 19:22:47 +0000 (UTC)
Received: from flask (unknown [10.40.205.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id B49F118867;
        Wed, 12 Jun 2019 19:22:44 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Wed, 12 Jun 2019 21:22:43 +0200
Date:   Wed, 12 Jun 2019 21:22:43 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
Message-ID: <20190612192243.GA23583@flask>
References: <1560332419-17195-1-git-send-email-wanpengli@tencent.com>
 <20190612151447.GD20308@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612151447.GD20308@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 12 Jun 2019 19:22:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-06-12 08:14-0700, Sean Christopherson:
> On Wed, Jun 12, 2019 at 05:40:18PM +0800, Wanpeng Li wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > @@ -145,6 +145,12 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
> >  static int __read_mostly lapic_timer_advance_ns = -1;
> >  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
> >  
> > +/*
> > + * lapic timer vmentry advance (tscdeadline mode only) in nanoseconds.
> > + */
> > +u32 __read_mostly vmentry_advance_ns = 300;
> 
> Enabling this by default makes me nervous, e.g. nothing guarantees that
> future versions of KVM and/or CPUs will continue to have 300ns of overhead
> between wait_lapic_expire() and VM-Enter.
> 
> If we want it enabled by default so that it gets tested, the default
> value should be extremely conservative, e.g. set the default to a small
> percentage (25%?) of the latency of VM-Enter itself on modern CPUs,
> VM-Enter latency being the min between VMLAUNCH and VMLOAD+VMRUN+VMSAVE.

I share the sentiment.  We definitely must not enter the guest before
the deadline has expired and CPUs are approaching 5 GHz (in turbo), so
300 ns would be too much even today.

I wrote a simple testcase for rough timing and there are 267 cycles
(111 ns @ 2.4 GHz) between doing rdtsc() right after
kvm_wait_lapic_expire() [1] and doing rdtsc() in the guest as soon as
possible (see the attached kvm-unit-test).

That is on a Haswell, where vmexit.flat reports 2120 cycles for a
vmcall.  This would linearly (likely incorrect method in this case)
translate to 230 cycles on a machine with 1800 cycles for a vmcall,
which is less than 50 ns @ 5 GHz.

I wouldn't go above 25 ns for a hard-coded default.

(We could also do a similar measurement when initializing KVM and have a
 dynamic default, but I'm thinking it's going to be way too much code
 for the benefit.)

---
1: This is how the TSC is read in KVM.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index da24f1858acc..a7251ac0109b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6449,6 +6449,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
 		kvm_wait_lapic_expire(vcpu);
 
+	vcpu->last_seen_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
 	 * it's non-zero. Since vmentry is serialising on affected CPUs, there
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6200d5a51f13..5e0ce8ca31e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7201,6 +7201,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_SEND_IPI:
 		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
 		break;
+	case KVM_HC_LAST_SEEN_TSC:
+		ret = vcpu->last_seen_tsc;
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index abafddb9fe2c..7f70fe7a28b1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -323,6 +323,8 @@ struct kvm_vcpu {
 	bool preempted;
 	struct kvm_vcpu_arch arch;
 	struct dentry *debugfs_dentry;
+
+	u64 last_seen_tsc;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 6c0ce49931e5..dfbc6e9ad7a1 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -28,6 +28,7 @@
 #define KVM_HC_MIPS_CONSOLE_OUTPUT	8
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
+#define KVM_HC_LAST_SEEN_TSC		11
 
 /*
  * hypercalls use architecture specific
