Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9FC3BC4F8
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 05:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhGFDIR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 5 Jul 2021 23:08:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:44953 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229919AbhGFDIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 23:08:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="270168143"
X-IronPort-AV: E=Sophos;i="5.83,327,1616482800"; 
   d="scan'208";a="270168143"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 20:05:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,327,1616482800"; 
   d="scan'208";a="647080111"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 05 Jul 2021 20:05:38 -0700
Received: from shsmsx602.ccr.corp.intel.com (10.109.6.142) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 5 Jul 2021 20:05:37 -0700
Received: from shsmsx603.ccr.corp.intel.com (10.109.6.143) by
 SHSMSX602.ccr.corp.intel.com (10.109.6.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 6 Jul 2021 11:05:35 +0800
Received: from shsmsx603.ccr.corp.intel.com ([10.109.6.143]) by
 SHSMSX603.ccr.corp.intel.com ([10.109.6.143]) with mapi id 15.01.2242.008;
 Tue, 6 Jul 2021 11:05:35 +0800
From:   "Hu, Robert" <robert.hu@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
Thread-Topic: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
Thread-Index: AQHXZIuB9zPySR3qkk2RxIcrlGLzAKseKLEAgAAIJYCAFyq6oA==
Date:   Tue, 6 Jul 2021 03:05:35 +0000
Message-ID: <da6c715345954a7b91c044ad685eb0f2@intel.com>
References: <20210618214658.2700765-1-seanjc@google.com>
 <c847e00a-e422-cdc9-3317-fbbd82b6e418@redhat.com>
 <YNDHfX0cntj72sk6@google.com>
In-Reply-To: <YNDHfX0cntj72sk6@google.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Tuesday, June 22, 2021 01:08
> To: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li
> <wanpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Joerg
> Roedel <joro@8bytes.org>; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for
> vmcs12
> 
> On Mon, Jun 21, 2021, Paolo Bonzini wrote:
> > On 18/06/21 23:46, Sean Christopherson wrote:
> > > Calculate the max VMCS index for vmcs12 by walking the array to find
> > > the actual max index.  Hardcoding the index is prone to bitrot, and
> > > the calculation is only done on KVM bringup (albeit on every CPU,
> > > but there aren't _that_ many null entries in the array).
> > >
> > > Fixes: 3c0f99366e34 ("KVM: nVMX: Add a TSC multiplier field in
> > > VMCS12")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >
> > > Note, the vmx test in kvm-unit-tests will still fail using stock
> > > QEMU, as QEMU also hardcodes and overwrites the MSR.  The test
> > > passes if I hack KVM to ignore userspace (it was easier than rebuilding
> QEMU).
> >
> > Queued, thanks.  Without having checked the kvm-unit-tests sources
> > very thoroughly, this might be a configuration issue in
> > kvm-unit-tests; in theory "-cpu host" (unlike "-cpu
> > host,migratable=no") should not enable TSC scaling.
> 
> As noted in the code comments, KVM allows VMREAD/VMWRITE to all defined
> fields, whether or not the field should actually exist for the vCPU model doesn't
> enter into the equation.  That's technically wrong as there are a number of
> fields that the SDM explicitly states exist iff a certain feature is supported.  To
> fix that we'd need to add a "feature flag" to vmcs_field_to_offset_table that is
> checked against the vCPU model, though updating the MSR would probably fall
> onto userspace's shoulders?
[Hu, Robert] 
Perhaps more easier and proper to do this in KVM side.
QEMU sets actual feature set down to KVM, and KVM updates IA32_VMX_VMCS_ENUM
MSR accordingly. We don't see a channel that QEMU constructs a VMCS and sets a whole
to KVM.

> 
> And FWIW, this is the QEMU code:
> 
>   #define VMCS12_MAX_FIELD_INDEX (0x17)
> 
>   static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
>   {
>       ...
> 
>       /*
>        * Just to be safe, write these with constant values.  The CRn_FIXED1
>        * MSRs are generated by KVM based on the vCPU's CPUID.
>        */
>       kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR0_FIXED0,
>                         CR0_PE_MASK | CR0_PG_MASK | CR0_NE_MASK);
>       kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR4_FIXED0,
>                         CR4_VMXE_MASK);
>       kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM,
>                         VMCS12_MAX_FIELD_INDEX << 1);
>   }

