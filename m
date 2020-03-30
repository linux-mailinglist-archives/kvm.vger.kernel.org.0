Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312C4198221
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 19:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgC3RVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 13:21:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:28187 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgC3RVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 13:21:53 -0400
IronPort-SDR: E1zoANh8CBtGJ+mJCCAjyWN5TgkGvSeqEQwAMRpOjLqtiPMIfkDO9kBGwN4AYktROE+3oBp2oe
 HhLas9ozOTfg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 10:21:52 -0700
IronPort-SDR: lAFY4IqQ7clIr0678b617mSpps15tXYGkqSz/NkLtmZDop9HvFVrD1osx8tlC0W3XDcx1NMDf3
 ywclHsKHjI8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="421996405"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2020 10:21:52 -0700
Date:   Mon, 30 Mar 2020 10:21:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Kang, Luwei" <luwei.kang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [PATCH] KVM: VMX: Disable Intel PT before VM-entry
Message-ID: <20200330172152.GE24988@linux.intel.com>
References: <1584503298-18731-1-git-send-email-luwei.kang@intel.com>
 <20200318154826.GC24357@linux.intel.com>
 <82D7661F83C1A047AF7DC287873BF1E1738A9724@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E1738A9724@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 02:20:01AM -0700, Kang, Luwei wrote:
> > On Wed, Mar 18, 2020 at 11:48:18AM +0800, Luwei Kang wrote:
> > > If the logical processor is operating with Intel PT enabled (
> > > IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the “load
> > > IA32_RTIT_CTL” VM-entry control must be 0(SDM 26.2.1.1).
> > >
> > > The first disabled the host Intel PT(Clear TraceEn) will make all the
> > > buffered packets are flushed out of the processor and it may cause an
> > > Intel PT PMI. The host Intel PT will be re-enabled in the host Intel
> > > PT PMI handler.
> > >
> > > handle_pmi_common()
> > >     -> intel_pt_interrupt()
> > >             -> pt_config_start()
> > 
> > IIUC, this is only possible when PT "plays nice" with VMX, correct?
> > Otherwise pt->vmx_on will be true and pt_config_start() would skip the
> > WRMSR.
> > 
> > And IPT PMI must be delivered via NMI (though maybe they're always
> > delivered via NMI?).
> > 
> > In any case, redoing WRMSR doesn't seem safe, and it certainly isn't
> > performant, e.g. what prevents the second WRMSR from triggering a second
> > IPT PMI?
> > 
> > pt_guest_enter() is called after the switch to the vCPU has already been
> > recorded, can't this be handled in the IPT code, e.g. something like this?
> > 
> > diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c index
> > 1db7a51d9792..e38ddae9f0d1 100644
> > --- a/arch/x86/events/intel/pt.c
> > +++ b/arch/x86/events/intel/pt.c
> > @@ -405,7 +405,7 @@ static void pt_config_start(struct perf_event *event)
> >         ctl |= RTIT_CTL_TRACEEN;
> >         if (READ_ONCE(pt->vmx_on))
> >                 perf_aux_output_flag(&pt->handle, PERF_AUX_FLAG_PARTIAL);
> > -       else
> > +       else (!(current->flags & PF_VCPU))
> >                 wrmsrl(MSR_IA32_RTIT_CTL, ctl);
> 
> Intel PT can work in SYSTEM and HOST_GUEST mode by setting the kvm-intel.ko
> parameter "pt_mode".  In SYSTEM mode, the host and guest PT trace will be
> saved in the host buffer. The KVM do nothing during VM-entry/exit in SYSTEM
> mode and Intel PT PMI may happened on any place. The PT trace may be disabled
> when running in KVM(PT only needs to be disabled before VM-entry in
> HOST_GUEST mode).

Ah, right.  What about enhancing intel_pt_handle_vmx() and 'struct pt' to
replace vmx_on with a field that incorporates the KVM mode?  From an
outsider's perspective, that'd be an improvment irrespective of this bug
fix as 'vmx_on' is misleading, e.g. it can be %false when the CPU is post-
VMXON, and really means "post-VMXON and Intel PT can't trace it".
