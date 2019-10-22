Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B6AE0D9C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 23:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732044AbfJVVD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 17:03:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:60522 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbfJVVD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 17:03:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 14:03:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; 
   d="scan'208";a="349192117"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 22 Oct 2019 14:03:55 -0700
Date:   Tue, 22 Oct 2019 14:03:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, boris.ostrovsky@oracle.com, jgross@suse.com,
        peterz@infradead.org, will@kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v7 3/5] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
Message-ID: <20191022210355.GR2343@linux.intel.com>
References: <1571649076-2421-1-git-send-email-zhenzhong.duan@oracle.com>
 <1571649076-2421-4-git-send-email-zhenzhong.duan@oracle.com>
 <8736fl1071.fsf@vitty.brq.redhat.com>
 <dbc50272-a4f5-ce7c-ba71-75031521f420@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbc50272-a4f5-ce7c-ba71-75031521f420@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 08:46:46PM +0800, Zhenzhong Duan wrote:
> Hi Vitaly,
> 
> On 2019/10/22 19:36, Vitaly Kuznetsov wrote:
> 
> >Zhenzhong Duan<zhenzhong.duan@oracle.com>  writes:
> >
> ...snip
> 
> >>diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> >>index 249f14a..3945aa5 100644
> >>--- a/arch/x86/kernel/kvm.c
> >>+++ b/arch/x86/kernel/kvm.c
> >>@@ -825,18 +825,36 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
> >>   */
> >>  void __init kvm_spinlock_init(void)
> >>  {
> >>-	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
> >>-	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
> >>+	/*
> >>+	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
> >>+	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
> >>+	 * preferred over native qspinlock when vCPU is preempted.
> >>+	 */
> >>+	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
> >>+		pr_info("PV spinlocks disabled, no host support.\n");
> >>  		return;
> >>+	}
> >>+	/*
> >>+	 * Disable PV qspinlock and use native qspinlock when dedicated pCPUs
> >>+	 * are available.
> >>+	 */
> >>  	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
> >>-		static_branch_disable(&virt_spin_lock_key);
> >>-		return;
> >>+		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints.\n");
> >>+		goto out;
> >>  	}
> >>-	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
> >>-	if (num_possible_cpus() == 1)
> >>-		return;
> >>+	if (num_possible_cpus() == 1) {
> >>+		pr_info("PV spinlocks disabled, single CPU.\n");
> >>+		goto out;
> >>+	}
> >>+
> >>+	if (nopvspin) {
> >>+		pr_info("PV spinlocks disabled, forced by \"nopvspin\" parameter.\n");
> >>+		goto out;
> >>+	}
> >>+
> >>+	pr_info("PV spinlocks enabled\n");
> >>  	__pv_init_lock_hash();
> >>  	pv_ops.lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
> >>@@ -849,6 +867,8 @@ void __init kvm_spinlock_init(void)
> >>  		pv_ops.lock.vcpu_is_preempted =
> >>  			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
> >>  	}
> >>+out:
> >>+	static_branch_disable(&virt_spin_lock_key);
> >You probably need to add 'return' before 'out:' as it seems you're
> >disabling virt_spin_lock_key in all cases now).
> 
> virt_spin_lock_key is kept enabled in !kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)
> case which is the only case virt_spin_lock() optimization is used.
> 
> When PV qspinlock is enabled, virt_spin_lock() isn't called in
> __pv_queued_spin_lock_slowpath() in which case we don't care
> virt_spin_lock_key's value.
> 
> So adding 'return' or not are both ok, I chosed to save a line,
> let me know if you prefer to add a 'return' and I'll change it.

It'd be worth adding a comment here if you end up spinning another version
to change the logging prefix.  The logic is sound and I like the end
result, but I had the same knee jerk "this can't be right!?!?" reaction as
Vitaly.
