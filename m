Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C188F45EA02
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 10:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245030AbhKZJOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 04:14:39 -0500
Received: from mga05.intel.com ([192.55.52.43]:48223 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhKZJMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 04:12:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10179"; a="321868485"
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="321868485"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 01:09:26 -0800
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="498342613"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.99])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 01:09:21 -0800
Date:   Fri, 26 Nov 2021 17:19:15 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 53/59] KVM: x86: Add a helper function to restore
 4 host MSRs on exit to user space
Message-ID: <20211126091913.GA11523@gao-cwp>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <4ede5c987a4ae938a37ab7fe70d5e1d561ee97d4.1637799475.git.isaku.yamahata@intel.com>
 <878rxcht3g.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rxcht3g.ffs@tglx>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021 at 09:34:59PM +0100, Thomas Gleixner wrote:
>On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
>> From: Chao Gao <chao.gao@intel.com>
>
>> $Subject: KVM: x86: Add a helper function to restore 4 host MSRs on exit to user space
>
>Which user space are you talking about? This subject line is misleading

Host Ring3.

>at best. The unconditional reset is happening when a TDX VM exits
>because the SEAM firmware enforces this to prevent unformation leaks.

Yes.

>
>It also does not matter whether this are four or ten MSR.

Indeed, the number of MSRs doesn't matter.

>Fact is that
>the SEAM firmware is buggy because it does not save/restore those MSRs.

It is done deliberately. It gives host a chance to do "lazy" restoration.
"lazy" means don't save/restore them on each TD entry/exit but defer
restoration to when it is neccesary e.g., when vCPU is scheduled out or
when kernel is about to return to Ring3.

>
>So the proper subject line is:
>
>   KVM: x86: Add infrastructure to handle MSR corruption by broken TDX firmware

I rewrote the commit message:

    KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o wrmsr

    Several MSRs are constant and only used in userspace. But VMs may have
    different values. KVM uses kvm_set_user_return_msr() to switch to guest's
    values and leverages user return notifier to restore them when kernel is
    to return to userspace. In order to save unnecessary wrmsr, KVM also caches
    the value it wrote to a MSR last time.

    TDX module unconditionally resets some of these MSRs to architectural INIT
    state on TD exit. It makes the cached values in kvm_user_return_msrs are
    inconsistent with values in hardware. This inconsistency needs to be fixed
    otherwise, it may mislead kvm_on_user_return() to skip restoring some MSRs
    to host's values. kvm_set_user_return_msr() can help to correct this case
    but it is not optimal as it always does a wrmsr. So, introduce a variation
    of kvm_set_user_return_msr() to update the cached value but skip the wrmsr.

>
>> The TDX module unconditionally reset 4 host MSRs (MSR_SYSCALL_MASK,
>> MSR_START, MSR_LSTAR, MSR_TSC_AUX) to architectural INIT state on exit from
>> TDX VM to KVM.  KVM needs to save their values before TD enter and restore
>> them on exit to userspace.
>>
>> Reuse current kvm_user_return mechanism and introduce a function to update
>> cached values and register the user return notifier in this new function.
>>
>> The later patch will use the helper function to save/restore 4 host
>> MSRs.
>
>'The later patch ...' is useless information. Of course there will be a
>later patch to make use of this which is implied by 'Add infrastructure
>...'. Can we please get rid of these useless phrases which have no value
>at patch submission time and are even more confusing once the pile is
>merged?

Of course. Will remove all "later patch" phrases.

Thanks
Chao

>
>Thanks,
>
>        tglx
