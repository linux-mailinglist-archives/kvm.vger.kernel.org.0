Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A93C3D1BEA
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 04:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhGVCDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 22:03:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:30913 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229932AbhGVCDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 22:03:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="233363213"
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; 
   d="scan'208";a="233363213"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 19:43:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; 
   d="scan'208";a="495569549"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jul 2021 19:43:48 -0700
Message-ID: <30a8062f9b937b3245b073dd0002b61d99901ed7.camel@linux.intel.com>
Subject: Re: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        "Hu, Robert" <robert.hu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 22 Jul 2021 10:43:48 +0800
In-Reply-To: <YPhI6en2031rLpVT@google.com>
References: <20210618214658.2700765-1-seanjc@google.com>
         <c847e00a-e422-cdc9-3317-fbbd82b6e418@redhat.com>
         <YNDHfX0cntj72sk6@google.com>
         <DM4PR11MB5453A57DAAC025417C22BCA4E0E39@DM4PR11MB5453.namprd11.prod.outlook.com>
         <YPhI6en2031rLpVT@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-07-21 at 16:18 +0000, Sean Christopherson wrote:
> On Wed, Jul 21, 2021, Hu, Robert wrote:
> > > > Queued, thanks.  Without having checked the kvm-unit-tests
> > > > sources
> > > > very thoroughly, this might be a configuration issue in
> > > > kvm-unit-tests; in theory "-cpu host" (unlike "-cpu
> > > > host,migratable=no") should not enable TSC scaling.
> > > 
> > > As noted in the code comments, KVM allows VMREAD/VMWRITE to all
> > > defined
> > > fields, whether or not the field should actually exist for the
> > > vCPU model doesn't
> > > enter into the equation.  That's technically wrong as there are a
> > > number of
> > > fields that the SDM explicitly states exist iff a certain feature
> > > is supported.  
> > 
> > It's right that a number of fields' existence depends on some
> > certain feature.
> > Meanwhile, "IA32_VMX_VMCS_ENUM indicates to software the highest
> > index
> > value used in the encoding of any field *supported* by the
> > processor", rather than
> > *existed*.
> 
> Yes.
> 
> > So my understanding is no matter what VMCS exec control field's
> > value is set,
> > value of IA32_VMX_VMCS_ENUM shall not be affected, as it reports
> > the physical
> > CPU's capability rather than runtime VMCS configuration.
> 
> Yes.
> 
> > Back to nested case, L1's VMCS configuration lays the "physical"
> > capability
> > for L2, right?
> 
> Yes. 
> 
> > nested_vmx_msrs or at least nested_vmx_msrs.vmcs_enum shall be put
> > to vcpu
> > scope, rather than current kvm global.
> > 
> > Current nested_vmx_calc_vmcs_enum_msr() is invoked at early stage,
> > before
> > vcpu features are settled. I think should be moved to later stage
> > as well.
> 
> Just moving the helper (or adding another call) wouldn't fix the
> underlying
> problem that KVM doesn't correctly model the interplay between VMX
> features and
> VMCS fields.  It's arguably less wrong than letting userspace stuff
> an incorrect
> value, but it's not 100% correct and ignoring/overriding userspace is
> sketchy at
> best.  
I think IA32_VMX_VMCS_ENUM MSR shall not be set by QEMU, it is actually
already indirectly set by user space CPU feature set.

> As suggested below, the full fix is to fail VMREAD/VMWRITE to fields
> that
> shouldn't exist given the vCPU model.
> 
> > > To fix that we'd need to add a "feature flag" to
> > > vmcs_field_to_offset_table
> > > that is checked against the vCPU model, though updating the MSR
> > > would
> > > probably fall onto userspace's shoulders?
> > > 
> > > And FWIW, this is the QEMU code:
> > > 
> > >   #define VMCS12_MAX_FIELD_INDEX (0x17)
> > > 
> > >   static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray
> > > f)
> > >   {
> > >       ...
> > > 
> > >       /*
> > >        * Just to be safe, write these with constant values.  The
> > > CRn_FIXED1
> > >        * MSRs are generated by KVM based on the vCPU's CPUID.
> > >        */
> > >       kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR0_FIXED0,
> > >                         CR0_PE_MASK | CR0_PG_MASK | CR0_NE_MASK);
> > >       kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR4_FIXED0,
> > >                         CR4_VMXE_MASK);
> > >       kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM,
> > >                         VMCS12_MAX_FIELD_INDEX << 1);
> > >   }

