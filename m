Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D9419C7C7
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 19:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388634AbgDBRTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 13:19:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:45953 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbgDBRTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 13:19:47 -0400
IronPort-SDR: 5+m17X8t592eKtAevbv88Vh7MGsCqX4YtobHDA9C0DifPESDxm758NgVg7FKtziHNWxSSQu53t
 D3HqtOwHNYSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2020 10:19:47 -0700
IronPort-SDR: pNllYi4iCE784FA8eCkCRKIpL6ciKpVCc+ww9j+dkVqV3Quv9sNaoi4NACrJ6cVZk757jAB7sL
 ZJhyeEkOVoCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,336,1580803200"; 
   d="scan'208";a="240882749"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 02 Apr 2020 10:19:46 -0700
Date:   Thu, 2 Apr 2020 10:19:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/split_lock: Refactor and export
 handle_user_split_lock() for KVM
Message-ID: <20200402171946.GH13879@linux.intel.com>
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
 <20200402155554.27705-3-sean.j.christopherson@intel.com>
 <87v9mhn7nf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9mhn7nf.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 07:01:56PM +0200, Thomas Gleixner wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> >
> > In the future, KVM will use handle_user_split_lock() to handle #AC
> > caused by split lock in guest. Due to the fact that KVM doesn't have
> > a @regs context and will pre-check EFLAGS.AC, move the EFLAGS.AC check
> > to do_alignment_check().
> >
> > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Reviewed-by: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/include/asm/cpu.h  | 4 ++--
> >  arch/x86/kernel/cpu/intel.c | 7 ++++---
> >  arch/x86/kernel/traps.c     | 2 +-
> >  3 files changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> > index ff6f3ca649b3..ff567afa6ee1 100644
> > --- a/arch/x86/include/asm/cpu.h
> > +++ b/arch/x86/include/asm/cpu.h
> > @@ -43,11 +43,11 @@ unsigned int x86_stepping(unsigned int sig);
> >  #ifdef CONFIG_CPU_SUP_INTEL
> >  extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
> >  extern void switch_to_sld(unsigned long tifn);
> > -extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
> > +extern bool handle_user_split_lock(unsigned long ip);
> >  #else
> >  static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
> >  static inline void switch_to_sld(unsigned long tifn) {}
> > -static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
> > +static inline bool handle_user_split_lock(unsigned long ip)
> 
> This is necessary because VMX can be compiled without CPU_SUP_INTEL?

Ya, it came about when cleaning up the IA32_FEATURE_CONTROL MSR handling
to consolidate duplicate code.

config KVM_INTEL
        tristate "KVM for Intel (and compatible) processors support"
        depends on KVM && IA32_FEAT_CTL

config IA32_FEAT_CTL
        def_bool y
        depends on CPU_SUP_INTEL || CPU_SUP_CENTAUR || CPU_SUP_ZHAOXIN
