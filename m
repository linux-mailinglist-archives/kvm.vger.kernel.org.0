Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7513B462E41
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 09:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239479AbhK3INe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 03:13:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:36109 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239482AbhK3IN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 03:13:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="322409120"
X-IronPort-AV: E=Sophos;i="5.87,275,1631602800"; 
   d="scan'208";a="322409120"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 00:10:05 -0800
X-IronPort-AV: E=Sophos;i="5.87,275,1631602800"; 
   d="scan'208";a="676733454"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.99])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 00:10:01 -0800
Date:   Tue, 30 Nov 2021 16:19:55 +0800
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
Message-ID: <20211130081954.GA4357@gao-cwp>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <4ede5c987a4ae938a37ab7fe70d5e1d561ee97d4.1637799475.git.isaku.yamahata@intel.com>
 <878rxcht3g.ffs@tglx>
 <20211126091913.GA11523@gao-cwp>
 <CAJhGHyAbBUyyVKL7=Cior_uat9rij1BB4iBwX+EDCAUVs1Npgg@mail.gmail.com>
 <20211129092605.GA30191@gao-cwp>
 <CAJhGHyCiZn8ZwBbVepU+tfmTV6gcDhXxzvS39BwpgUj+6LCZ0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyCiZn8ZwBbVepU+tfmTV6gcDhXxzvS39BwpgUj+6LCZ0g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 12:58:47PM +0800, Lai Jiangshan wrote:
>On Mon, Nov 29, 2021 at 5:16 PM Chao Gao <chao.gao@intel.com> wrote:
>
>> >I did not find the information in intel-tdx-module-1eas.pdf nor
>> >intel-tdx-cpu-architectural-specification.pdf.
>> >
>> >Maybe the version I downloaded is outdated.
>>
>> Hi Jiangshan,
>>
>> Please refer to Table 22.162 MSRs that may be Modified by TDH.VP.ENTER,
>> in section 22.2.40 TDH.VP.ENTER leaf.
>
>No file in this link:
>https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html
>has chapter 22.

https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1.0-public-spec-v0.931.pdf

>
>>
>> >
>> >I guess that the "lazy" restoration mode is not a valid optimization.
>> >The SEAM module should restore it to the original value when it tries
>> >to reset it to architectural INIT state on exit from TDX VM to KVM
>> >since the SEAM module also does it via wrmsr (correct me if not).
>>
>> Correct.
>>
>> >
>> >If the SEAM module doesn't know "the original value" of the these
>> >MSRs, it would be mere an optimization to save an rdmsr in SEAM.
>>
>> Yes. Just a rdmsr is saved in TDX module at the cost of host's
>> restoring a MSR. If restoration (wrmsr) can be done in a lazy fashion
>> or even the MSR isn't used by host, some CPU cycles can be saved.
>
>But it adds overall overhead because the wrmsr in TDX module
>can't be skipped while the unneeded potential overhead of
>wrmsr is added in user return path.

It is a trade-off. In this way, TDX module needn't save some host MSRs.
Of course, host has to restore those MSRs. the overall impact depends
on the frequency of restoring: on every exit from TD VM, on vCPU being
scheduled out or on exit to userspace. In the last two cases, it is
supposed to have less overhead than saving host MSRs and restoring them
on every exit from TD VM.

>
>If TDX module restores the original MSR value, the host hypervisor
>doesn't need to step in.
>
>I think I'm reviewing the code without the code.  It is definitely
>wrong design to (ab)use the host's user-return-msr mechanism.

I cannot follow.

>
>>
>> >But there are a lot of other ways for the host to share the values
>> >to SEAM in zero overhead.
>>
>> I am not sure. Looks it requests a new interface between host and TDX
>> module. I guess one problem is how/when to verify host's inputs in case
>> they are invalid.
>>
>
>If the requirement of "lazy restoration" is being added (not seen in the
>published document yet), you are changing the ABI between the host and
>the TDX module.

No, it is already documented in public spec.

TDX module spec just says some MSRs are reset to INIT state by TDX module
(un)conditionally during TD exit. When to restore these MSRs to host's
values is decided by host.

