Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C372524E4D4
	for <lists+kvm@lfdr.de>; Sat, 22 Aug 2020 05:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgHVD2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 23:28:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:34089 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbgHVD2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 23:28:16 -0400
IronPort-SDR: P2scfH/5s7YMOzHGQSjHvKjCVIjAbA8M36yW95HBmoRUlaQ6pP7pKVAOza3TmRlX1a8KEZkMIR
 lD9SsQ7u8QQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="217211107"
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="217211107"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 20:28:15 -0700
IronPort-SDR: nsM4aCt2i5lvTdCGU7pXH7jlQrUjfp44RDbCGqRMWk9MTj5iDgwwXx9dd0Tb+1RZAt/DwterPF
 8johV+E/B4Mw==
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="280417981"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 20:28:15 -0700
Date:   Fri, 21 Aug 2020 20:28:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/7] KVM: VMX: Expose IA32_PKRS MSR
Message-ID: <20200822032813.GC4769@sjchrist-ice>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-3-chenyi.qiang@intel.com>
 <CALMp9eQiyRxJ0jkvVi+fWMZcDQbvyCcuTwH1wrYV-u_E004Bhg@mail.gmail.com>
 <34b083be-b9d5-fd85-b42d-af0549e3b002@intel.com>
 <CALMp9eS=dO7=JvvmGp-nt-LBO9evH-bLd2LQMO9wdYJ5V6S0_Q@mail.gmail.com>
 <268b0ee4-e56f-981c-c03e-6dca8a4e99da@intel.com>
 <CALMp9eSAkzGPp4zPVakypR1McSJtJ1x4j1zAAj1sM1bHxd01zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSAkzGPp4zPVakypR1McSJtJ1x4j1zAAj1sM1bHxd01zg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 11:23:47AM -0700, Jim Mattson wrote:
> On Tue, Aug 18, 2020 at 12:28 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> >
> >
> >
> > On 8/14/2020 1:31 AM, Jim Mattson wrote:
> > > On Wed, Aug 12, 2020 at 10:42 PM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> > >>
> > >>
> > >>
> > >> On 8/13/2020 5:21 AM, Jim Mattson wrote:
> > >>> On Fri, Aug 7, 2020 at 1:46 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> > >>>>
> > >>>> Protection Keys for Supervisor Pages (PKS) uses IA32_PKRS MSR (PKRS) at
> > >>>> index 0x6E1 to allow software to manage supervisor protection key
> > >>>> rights. For performance consideration, PKRS intercept will be disabled
> > >>>> so that the guest can access the PKRS without VM exits.
> > >>>> PKS introduces dedicated control fields in VMCS to switch PKRS, which
> > >>>> only does the retore part. In addition, every VM exit saves PKRS into
> > >>>> the guest-state area in VMCS, while VM enter won't save the host value
> > >>>> due to the expectation that the host won't change the MSR often. Update
> > >>>> the host's value in VMCS manually if the MSR has been changed by the
> > >>>> kernel since the last time the VMCS was run.
> > >>>> The function get_current_pkrs() in arch/x86/mm/pkeys.c exports the
> > >>>> per-cpu variable pkrs_cache to avoid frequent rdmsr of PKRS.
> > >>>>
> > >>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > >>>> ---
> > >>>
> > >>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > >>>> index 11e4df560018..df2c2e733549 100644
> > >>>> --- a/arch/x86/kvm/vmx/nested.c
> > >>>> +++ b/arch/x86/kvm/vmx/nested.c
> > >>>> @@ -289,6 +289,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
> > >>>>           dest->ds_sel = src->ds_sel;
> > >>>>           dest->es_sel = src->es_sel;
> > >>>>    #endif
> > >>>> +       dest->pkrs = src->pkrs;
> > >>>
> > >>> Why isn't this (and other PKRS code) inside the #ifdef CONFIG_X86_64?
> > >>> PKRS isn't usable outside of long mode, is it?
> > >>>
> > >>
> > >> Yes, I'm also thinking about whether to put all pks code into
> > >> CONFIG_X86_64. The kernel implementation also wrap its pks code inside
> > >> CONFIG_ARCH_HAS_SUPERVISOR_PKEYS which has dependency with CONFIG_X86_64.
> > >> However, maybe this can help when host kernel disable PKS but the guest
> > >> enable it. What do you think about this?
> > >
> > > I see no problem in exposing PKRS to the guest even if the host
> > > doesn't have CONFIG_ARCH_HAS_SUPERVISOR_PKEYS.
> > >
> >
> > Yes, but I would prefer to keep it outside CONFIG_X86_64. PKS code has
> > several code blocks and putting them under x86_64 may end up being a
> > mess. In addition, PKU KVM related code isn't under CONFIG_X86_64 as
> > well. So, is it really necessary to put inside?
> 
> I'll let someone who actually cares about the i386 build answer that question.

Ha, I care about the i386 build to the extent that it doesn't break.  I
don't care at all shaving cycles/memory for things like this.  Given how
long some KVM i386 bugs have gone unnoticed I'm not sure there's anyone that
cares about KVM i386 these days :-)
