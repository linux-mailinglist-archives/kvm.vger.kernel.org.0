Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF05B1E3481
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 03:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgE0BNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 21:13:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:18432 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgE0BNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 21:13:45 -0400
IronPort-SDR: py7p8fMaw4tceMHTwrsQCnG0wMKlnkqf63IrO3DN7nmNI7jS/79v9+l14DEuKqxBcoCUJ0qmG9
 zrmOI7IVrCAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 18:13:44 -0700
IronPort-SDR: 9jMI1OJubFItcw0uUF95VJxqCdwr/Fm79p/anfETW7JOcoRpdrUW+X3lpeYWF9eLqqZnY0MA+I
 jrKUlbviMKow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="414017709"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 26 May 2020 18:13:44 -0700
Date:   Tue, 26 May 2020 18:13:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tao Xu <tao3.xu@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH 0/2] Fix issue with not starting nesting guests on my
 system
Message-ID: <20200527011344.GB31696@linux.intel.com>
References: <20200523161455.3940-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523161455.3940-1-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 07:14:53PM +0300, Maxim Levitsky wrote:
> On my AMD machine I noticed that I can't start any nested guests,
> because nested KVM (everything from master git branches) complains
> that it can't find msr MSR_IA32_UMWAIT_CONTROL which my system doesn't support
> at all anyway.
> 
> I traced it to the recently added UMWAIT support to qemu and kvm.
> The kvm portion exposed the new MSR in KVM_GET_MSR_INDEX_LIST without
> checking that it the underlying feature is supported in CPUID.
> It happened to work when non nested because as a precation kvm,
> tries to read each MSR on host before adding it to that list,
> and when read gets a #GP it ignores it.
> 
> When running nested, the L1 hypervisor can be set to ignore unknown
> msr read/writes (I need this for some other guests), thus this safety
> check doesn't work anymore.
> 
> V2: * added a patch to setup correctly the X86_FEATURE_WAITPKG kvm capability
>     * dropped the cosmetic fix patch as it is now fixed in kvm/queue
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (2):
>   kvm/x86/vmx: enable X86_FEATURE_WAITPKG in KVM capabilities
>   kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally

Standard scoping in the shortlog is "KVM: VMX:" and "KVM: x86:".

> 
>  arch/x86/kvm/vmx/vmx.c | 3 +++
>  arch/x86/kvm/x86.c     | 4 ++++
>  2 files changed, 7 insertions(+)
> 
> -- 
> 2.26.2
> 
> 
