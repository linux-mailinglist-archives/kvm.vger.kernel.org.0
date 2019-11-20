Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A8C104322
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 19:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfKTSTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 13:19:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:41417 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbfKTSTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 13:19:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 10:19:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,222,1571727600"; 
   d="scan'208,223";a="237838281"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 20 Nov 2019 10:19:14 -0800
Date:   Wed, 20 Nov 2019 10:19:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
Message-ID: <20191120181913.GA11521@linux.intel.com>
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
 <20191016112857.293a197d@x1.home>
 <20191016174943.GG5866@linux.intel.com>
 <53f506b3-e864-b3ca-f18f-f8e9a1612072@djy.llc>
 <20191022202847.GO2343@linux.intel.com>
 <4af8cbac-39b1-1a20-8e26-54a37189fe32@djy.llc>
 <20191024173212.GC20633@linux.intel.com>
 <36be1503-f6f1-0ed0-b1fe-9c05d827f624@djy.llc>
 <20191119200133.GD25672@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191119200133.GD25672@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Nov 19, 2019 at 12:01:33PM -0800, Sean Christopherson wrote:
> On Wed, Oct 30, 2019 at 11:44:09PM -0400, Derek Yerger wrote:
> > I noticed the following in the host kernel log around the time the guest
> > encountered BSOD on 5.2.7:
> > 
> > [  337.841491] WARNING: CPU: 6 PID: 7548 at arch/x86/kvm/x86.c:7963
> > kvm_arch_vcpu_ioctl_run+0x19b1/0x1b00 [kvm]
> 
> Rats, I overlooked this first time round.  In the future, if you get a
> WARN splat, try to make it very obvious in the bug report, they're almost
> always a smoking gun.
> 
> That WARN that fired is:
> 
>         /* The preempt notifier should have taken care of the FPU already.  */
>         WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
> 
> which was added part of a bug fix by commit:
> 
> 	240c35a3783a ("kvm: x86: Use task structs fpu field for user")
> 
> the buggy commit that was fixed is
> 
> 	5f409e20b794 ("x86/fpu: Defer FPU state load until return to userspace")
> 
> which was part of a FPU rewrite that went into 5.2[*].  So yep, big
> smoking gun :-)
> 
> My understanding of the WARN is that it means the kernel's FPU state is
> unexpectedly loaded when entry to the KVM guest is imminent.  As for *how*
> the kernel's FPU state is getting loaded, no clue.  But, I think it'd be
> pretty easy to find the the culprit by adding a debug flag into struct
> thread_info that gets set in vcpu_load() and clearing it in vcpu_put(),
> and then WARN in set_ti_thread_flag() if the debug flag is true when
> TIF_NEED_FPU_LOAD is being set.  I'll put together a debugging patch later
> today and send it your way.

Debug patch attached.  Hopefully it finds something, it took me an
embarassing number of attempts to get correct, I kept screwing up checking
a bit number versus checking a bit mask...

--xHFwDpU9dbj6ez1V
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w.patch"

From 6288031dacbe753b84515d330f62c1f8ed31d932 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 20 Nov 2019 10:12:56 -0800
Subject: [PATCH] thread_info: Add a debug hook to detect FPU changes while a
 vCPU is loaded

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/thread_info.h | 2 ++
 arch/x86/kvm/x86.c                 | 4 ++++
 include/linux/thread_info.h        | 1 +
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f9453536f9bb..7b697005cc51 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -56,6 +56,8 @@ struct task_struct;
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	u32			status;		/* thread synchronous flags */
+	bool			vcpu_loaded;
+
 };
 
 #define INIT_THREAD_INFO(tsk)			\
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a8ad3a4d86b1..3d9c049e749e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3303,6 +3303,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
+
+	current_thread_info()->vcpu_loaded = 1;
 }
 
 static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
@@ -3322,6 +3324,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
+	current_thread_info()->vcpu_loaded = 0;
+
 	if (vcpu->preempted)
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops->get_cpl(vcpu);
 
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 8d8821b3689a..016c2c887354 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -52,6 +52,7 @@ enum {
 
 static inline void set_ti_thread_flag(struct thread_info *ti, int flag)
 {
+	WARN_ON_ONCE(ti->vcpu_loaded && flag == TIF_NEED_FPU_LOAD);
 	set_bit(flag, (unsigned long *)&ti->flags);
 }
 
-- 
2.24.0


--xHFwDpU9dbj6ez1V--
