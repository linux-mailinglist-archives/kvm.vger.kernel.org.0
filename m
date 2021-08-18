Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1625A3EFA5B
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 07:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbhHRFva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 01:51:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:41725 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237889AbhHRFva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 01:51:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="279996974"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="279996974"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 22:50:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="449543028"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 17 Aug 2021 22:50:53 -0700
Message-ID: <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Date:   Wed, 18 Aug 2021 13:50:52 +0800
In-Reply-To: <YRvbvqhz6sknDEWe@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
         <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
         <YRvbvqhz6sknDEWe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-08-17 at 15:54 +0000, Sean Christopherson wrote:
> On Tue, Aug 17, 2021, Robert Hoo wrote:
> > In vmcs12_{read,write}_any(), check the field exist or not. If not,
> > return
> > failure. Hence their function prototype changed a little
> > accordingly.
> > In handle_vm{read,write}(), above function's caller, check return
> > value, if
> > failed, emulate nested vmx fail with instruction error of
> > VMXERR_UNSUPPORTED_VMCS_COMPONENT.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> 
> Assuming Yu is a co-author, this needs to be:
> 
>   Co-developed-by: Yu Zhang <yu.c.zhang@linux.intel.com>
>   Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
>   Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> 
> See "When to use Acked-by:, Cc:, and Co-developed-by:" in
> Documentation/process/submitting-patches.rst.
OK, thanks.

> 
> > ---
> >  arch/x86/kvm/vmx/nested.c | 20 ++++++++++++------
> >  arch/x86/kvm/vmx/vmcs12.h | 43 ++++++++++++++++++++++++++++++-----
> > ----
> >  2 files changed, 47 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index b8121f8f6d96..9a35953ede22 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -1547,7 +1547,8 @@ static void copy_shadow_to_vmcs12(struct
> > vcpu_vmx *vmx)
> >  	for (i = 0; i < max_shadow_read_write_fields; i++) {
> >  		field = shadow_read_write_fields[i];
> >  		val = __vmcs_readl(field.encoding);
> > -		vmcs12_write_any(vmcs12, field.encoding, field.offset,
> > val);
> > +		vmcs12_write_any(vmcs12, field.encoding, field.offset,
> > val,
> > +				 vmx-
> > >nested.vmcs12_field_existence_bitmap);
> 
> There is no need to perform existence checks when KVM is copying
> to/from vmcs12,
> the checks are only needed for VMREAD and VMWRITE.  Architecturally,
> the VMCS is
> an opaque blob, software cannot rely on any assumptions about its
> layout or data,
> i.e. KVM is free to read/write whatever it wants.   VMREAD and
> VMWRITE need to be
> enforced because architecturally they are defined to fail if the
> field does not exist.
OK, agree.

> 
> Limiting this to VMREAD/VMWRITE means we shouldn't need a bitmap and
> can use a
> more static lookup, e.g. a switch statement.  
Emm, hard for me to choose:

Your approach sounds more efficient for CPU: Once VMX MSR's updated, no
bother to update the bitmap. Each field's existence check will directly
consult related VMX MSR. Well, the switch statement will be long...

My this implementation: once VMX MSR's updated, the update needs to be
passed to bitmap, this is 1 extra step comparing to aforementioned
above. But, later, when query field existence, especially the those
consulting vm{entry,exit}_ctrl, they usually would have to consult both
MSRs if otherwise no bitmap, and we cannot guarantee if in the future
there's no more complicated dependencies. If using bitmap, this consult
is just 1-bit reading. If no bitmap, several MSR's read and compare
happen.
And, VMX MSR --> bitmap, usually happens only once when vCPU model is
settled. But VMRead/VMWrite might happen frequently, depends on guest
itself. I'd rather leave complicated comparison in former than in
later.


> And an idea to optimize for fields
> that unconditionally exist would be to use bit 0 in the field->offset 
> table to
> denote conditional fields, e.g. the VMREAD/VMRITE lookups could be
> something like:
Though all fields offset is even today, can we assert no new odd-offset 
field won't be added some day?
And, what if some day, some field's conditional/unconditional existence
depends on CPU model?

> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..ef8c48f80d1a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5064,7 +5064,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>         /* Decode instruction info and find the field to read */
>         field = kvm_register_read(vcpu, (((instr_info) >> 28) &
> 0xf));
> 
> -       offset = vmcs_field_to_offset(field);
> +       offset = vmcs_field_to_offset(vmx, field);
>         if (offset < 0)
>                 return nested_vmx_fail(vcpu,
> VMXERR_UNSUPPORTED_VMCS_COMPONENT);
> 
> @@ -5167,7 +5167,7 @@ static int handle_vmwrite(struct kvm_vcpu
> *vcpu)
> 
>         field = kvm_register_read(vcpu, (((instr_info) >> 28) &
> 0xf));
> 
> -       offset = vmcs_field_to_offset(field);
> +       offset = vmcs_field_to_offset(vmx, field);
>         if (offset < 0)
>                 return nested_vmx_fail(vcpu,
> VMXERR_UNSUPPORTED_VMCS_COMPONENT);
> 
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index 2a45f026ee11..3c27631e0119 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -364,7 +364,8 @@ static inline void vmx_check_vmcs12_offsets(void)
>  extern const unsigned short vmcs_field_to_offset_table[];
>  extern const unsigned int nr_vmcs12_fields;
> 
> -static inline short vmcs_field_to_offset(unsigned long field)
> +static inline short vmcs_field_to_offset(struct vcpu_vmx *vmx,
> +                                        unsigned long field)
>  {
>         unsigned short offset;
>         unsigned int index;
> @@ -378,9 +379,10 @@ static inline short
> vmcs_field_to_offset(unsigned long field)
> 
>         index = array_index_nospec(index, nr_vmcs12_fields);
>         offset = vmcs_field_to_offset_table[index];
> -       if (offset == 0)
> +       if (offset == 0 ||
> +           ((offset & 1) && !vmcs12_field_exists(vmx, field)))
>                 return -ENOENT;
> -       return offset;
> +       return offset & ~1;
>  }
> 
>  static inline u64 vmcs12_read_any(struct vmcs12 *vmcs12, unsigned
> long field,

