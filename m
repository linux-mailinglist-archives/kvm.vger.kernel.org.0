Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7A9461100
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 10:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbhK2J05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 04:26:57 -0500
Received: from mga18.intel.com ([134.134.136.126]:49003 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239963AbhK2JY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 04:24:57 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10182"; a="222814491"
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="222814491"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 01:16:17 -0800
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="511610085"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.99])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 01:16:13 -0800
Date:   Mon, 29 Nov 2021 17:26:07 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 53/59] KVM: x86: Add a helper function to restore
 4 host MSRs on exit to user space
Message-ID: <20211129092605.GA30191@gao-cwp>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <4ede5c987a4ae938a37ab7fe70d5e1d561ee97d4.1637799475.git.isaku.yamahata@intel.com>
 <878rxcht3g.ffs@tglx>
 <20211126091913.GA11523@gao-cwp>
 <CAJhGHyAbBUyyVKL7=Cior_uat9rij1BB4iBwX+EDCAUVs1Npgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyAbBUyyVKL7=Cior_uat9rij1BB4iBwX+EDCAUVs1Npgg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 03:08:39PM +0800, Lai Jiangshan wrote:
>On Mon, Nov 29, 2021 at 2:00 AM Chao Gao <chao.gao@intel.com> wrote:
>>
>> On Thu, Nov 25, 2021 at 09:34:59PM +0100, Thomas Gleixner wrote:
>> >On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
>> >> From: Chao Gao <chao.gao@intel.com>
>> >
>> >> $Subject: KVM: x86: Add a helper function to restore 4 host MSRs on exit to user space
>> >
>> >Which user space are you talking about? This subject line is misleading
>>
>> Host Ring3.
>>
>> >at best. The unconditional reset is happening when a TDX VM exits
>> >because the SEAM firmware enforces this to prevent unformation leaks.
>>
>> Yes.
>>
>> >
>> >It also does not matter whether this are four or ten MSR.
>>
>> Indeed, the number of MSRs doesn't matter.
>>
>> >Fact is that
>> >the SEAM firmware is buggy because it does not save/restore those MSRs.
>>
>> It is done deliberately. It gives host a chance to do "lazy" restoration.
>> "lazy" means don't save/restore them on each TD entry/exit but defer
>> restoration to when it is neccesary e.g., when vCPU is scheduled out or
>> when kernel is about to return to Ring3.
>>
>> The TDX module unconditionally reset 4 host MSRs (MSR_SYSCALL_MASK,
>> MSR_START, MSR_LSTAR, MSR_TSC_AUX) to architectural INIT state on exit from
>> TDX VM to KVM.
>
>I did not find the information in intel-tdx-module-1eas.pdf nor
>intel-tdx-cpu-architectural-specification.pdf.
>
>Maybe the version I downloaded is outdated.

Hi Jiangshan,

Please refer to Table 22.162 MSRs that may be Modified by TDH.VP.ENTER,
in section 22.2.40 TDH.VP.ENTER leaf.

>
>I guess that the "lazy" restoration mode is not a valid optimization.
>The SEAM module should restore it to the original value when it tries
>to reset it to architectural INIT state on exit from TDX VM to KVM
>since the SEAM module also does it via wrmsr (correct me if not).

Correct.

>
>If the SEAM module doesn't know "the original value" of the these
>MSRs, it would be mere an optimization to save an rdmsr in SEAM.

Yes. Just a rdmsr is saved in TDX module at the cost of host's
restoring a MSR. If restoration (wrmsr) can be done in a lazy fashion
or even the MSR isn't used by host, some CPU cycles can be saved.

>But there are a lot of other ways for the host to share the values
>to SEAM in zero overhead.

I am not sure. Looks it requests a new interface between host and TDX
module. I guess one problem is how/when to verify host's inputs in case
they are invalid.

Thanks
Chao

>
>Could you provide more information?
