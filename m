Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CAC35E809
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 23:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346618AbhDMVIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 17:08:47 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:56992 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344575AbhDMVIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 17:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1618348106; x=1649884106;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=oXscWfXptDs7/ZJws9fZMwjKGAhwqVVLijAjsYycvy4=;
  b=Ret1hHFI49xuJ0yhp3a+0xPZfaP2M9CETQmC9dNPqItgPCVXVe8APaLw
   IroTGE7tphWiNFpeId9dAhImxcIK+aq3DLEDydAiCkO62Lf1qVnNF91+E
   8S/O22z6d4FSP8w7p1MlnNZ3Io8HoGLKG/uOZ4VwHprPP7anZPxRtKXHS
   g=;
X-IronPort-AV: E=Sophos;i="5.82,220,1613433600"; 
   d="scan'208";a="118195962"
Subject: Re: [PATCH v2 3/4] KVM: x86: kvm_hv_flush_tlb use inputs from XMM registers
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 13 Apr 2021 21:08:18 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id 45C3FBD5C2;
        Tue, 13 Apr 2021 21:08:11 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.39) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 13 Apr 2021 21:08:03 +0000
Date:   Tue, 13 Apr 2021 23:07:59 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>
Message-ID: <20210413210758.GA10240@uc8bbc9586ea454.ant.amazon.com>
References: <cover.1618244920.git.sidcha@amazon.de>
 <da036c786700032b32e68ebece06fd1a6b6bf344.1618244920.git.sidcha@amazon.de>
 <87sg3u5l8z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87sg3u5l8z.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.39]
X-ClientProxiedBy: EX13D20UWA003.ant.amazon.com (10.43.160.97) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 04:09:48PM +0200, Vitaly Kuznetsov wrote:
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> > Hyper-V supports the use of XMM registers to perform fast hypercalls.
> > This allows guests to take advantage of the improved performance of the
> > fast hypercall interface even though a hypercall may require more than
> > (the current maximum of) two input registers.
> >
> > The XMM fast hypercall interface uses six additional XMM registers (XMM0
> > to XMM5) to allow the guest to pass an input parameter block of up to
> > 112 bytes. Hyper-V can also return data back to the guest in the
> > remaining XMM registers that are not used by the current hypercall.
> >
> > Add framework to read/write to XMM registers in kvm_hv_hypercall() and
> > use the additional hypercall inputs from XMM registers in
> > kvm_hv_flush_tlb() when possible.
> >
> > Cc: Alexander Graf <graf@amazon.com>
> > Co-developed-by: Evgeny Iakovlev <eyakovl@amazon.de>
> > Signed-off-by: Evgeny Iakovlev <eyakovl@amazon.de>
> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > ---
> >  arch/x86/kvm/hyperv.c | 109 ++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 90 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 8f6babd1ea0d..1f9959aba70d 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -36,6 +36,7 @@
> >
> >  #include "trace.h"
> >  #include "irq.h"
> > +#include "fpu.h"
> >
> >  /* "Hv#1" signature */
> >  #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
> > @@ -1623,6 +1624,8 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
> >       return vcpu_bitmap;
> >  }
> >
> > +#define KVM_HV_HYPERCALL_MAX_XMM_REGISTERS  6
> 
> Nitpick: this is not KVM-specific so could probably go to arch/x86/include/asm/hyperv-tlfs.h

Ack.

> > +
> >  struct kvm_hv_hcall {
> >       u64 param;
> >       u64 ingpa;
> > @@ -1632,10 +1635,14 @@ struct kvm_hv_hcall {
> >       u16 rep_idx;
> >       bool fast;
> >       bool rep;
> > +     sse128_t xmm[KVM_HV_HYPERCALL_MAX_XMM_REGISTERS];
> > +     bool xmm_dirty;
> >  };
> >
> >  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
> >  {
> > +     int i, j;
> > +     gpa_t gpa;
> >       struct kvm *kvm = vcpu->kvm;
> >       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> >       struct hv_tlb_flush_ex flush_ex;
> > @@ -1649,8 +1656,15 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
> >       bool all_cpus;
> >
> >       if (!ex) {
> > -             if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush, sizeof(flush))))
> > -                     return HV_STATUS_INVALID_HYPERCALL_INPUT;
> > +             if (hc->fast) {
> > +                     flush.address_space = hc->ingpa;
> > +                     flush.flags = hc->outgpa;
> > +                     flush.processor_mask = sse128_lo(hc->xmm[0]);
> > +             } else {
> > +                     if (unlikely(kvm_read_guest(kvm, hc->ingpa,
> > +                                                 &flush, sizeof(flush))))
> > +                             return HV_STATUS_INVALID_HYPERCALL_INPUT;
> > +             }
> >
> >               trace_kvm_hv_flush_tlb(flush.processor_mask,
> >                                      flush.address_space, flush.flags);
> > @@ -1668,9 +1682,16 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
> >               all_cpus = (flush.flags & HV_FLUSH_ALL_PROCESSORS) ||
> >                       flush.processor_mask == 0;
> >       } else {
> > -             if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
> > -                                         sizeof(flush_ex))))
> > -                     return HV_STATUS_INVALID_HYPERCALL_INPUT;
> > +             if (hc->fast) {
> > +                     flush_ex.address_space = hc->ingpa;
> > +                     flush_ex.flags = hc->outgpa;
> > +                     memcpy(&flush_ex.hv_vp_set,
> > +                            &hc->xmm[0], sizeof(hc->xmm[0]));
> > +             } else {
> > +                     if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
> > +                                                 sizeof(flush_ex))))
> > +                             return HV_STATUS_INVALID_HYPERCALL_INPUT;
> > +             }
> >
> >               trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
> >                                         flush_ex.hv_vp_set.format,
> > @@ -1681,20 +1702,29 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
> >               all_cpus = flush_ex.hv_vp_set.format !=
> >                       HV_GENERIC_SET_SPARSE_4K;
> >
> > -             sparse_banks_len =
> > -                     bitmap_weight((unsigned long *)&valid_bank_mask, 64) *
> > -                     sizeof(sparse_banks[0]);
> > +             sparse_banks_len = bitmap_weight((unsigned long *)&valid_bank_mask, 64);
> >
> >               if (!sparse_banks_len && !all_cpus)
> >                       goto ret_success;
> >
> > -             if (!all_cpus &&
> > -                 kvm_read_guest(kvm,
> > -                                hc->ingpa + offsetof(struct hv_tlb_flush_ex,
> > -                                                     hv_vp_set.bank_contents),
> > -                                sparse_banks,
> > -                                sparse_banks_len))
> > -                     return HV_STATUS_INVALID_HYPERCALL_INPUT;
> > +             if (!all_cpus) {
> > +                     if (hc->fast) {
> > +                             if (sparse_banks_len > KVM_HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
> > +                                     return HV_STATUS_INVALID_HYPERCALL_INPUT;
> > +                             for (i = 0, j = 1; i < sparse_banks_len; i += 2, j++) {
> 
> Nitpick: you don't really need 'j' here as 'j == i/2 + 1', right?

Yes, you are right. Changed.

> > +                                     sparse_banks[i + 0] = sse128_lo(hc->xmm[j]);
> 
> Using ' + 0' for identation is ... unusual :-) I'm not opposed to it
> here though.

Old habit :-).

> > +                                     sparse_banks[i + 1] = sse128_hi(hc->xmm[j]);
> > +                             }
> > +                     } else {
> > +                             gpa = hc->ingpa;
> > +                             gpa += offsetof(struct hv_tlb_flush_ex,
> > +                                             hv_vp_set.bank_contents);
> 
> Nitpick: if splitting these into two lines is only done to fit into 80
> chars then I'd the requirement is no more so we can be a bit wider.
> 
>  gpa = hc->ingpa + offsetof(...)

Ack.

> > +                             if (unlikely(kvm_read_guest(kvm, gpa, sparse_banks,
> > +                                                         sparse_banks_len *
> > +                                                         sizeof(sparse_banks[0]))))
> > +                                     return HV_STATUS_INVALID_HYPERCALL_INPUT;
> > +                     }
> > +             }
> >       }
> >
> >       cpumask_clear(&hv_vcpu->tlb_flush);
> > @@ -1890,6 +1920,41 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *h
> >       return HV_STATUS_SUCCESS;
> >  }
> >
> > +static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
> > +{
> > +     switch (hc->code) {
> > +     case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
> > +     case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
> > +     case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
> > +     case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
> > +             return true;
> > +     }
> > +
> > +     return false;
> > +}
> > +
> > +static inline void kvm_hv_hypercall_read_xmm(struct kvm_hv_hcall *hc)
> > +{
> > +     int reg;
> > +
> > +     kvm_fpu_get();
> > +     for (reg = 0; reg < KVM_HV_HYPERCALL_MAX_XMM_REGISTERS; reg++)
> > +             _kvm_read_sse_reg(reg, &hc->xmm[reg]);
> > +     kvm_fpu_put();
> > +     hc->xmm_dirty = false;
> > +}
> > +
> > +static inline void kvm_hv_hypercall_write_xmm(struct kvm_hv_hcall *hc)
> > +{
> > +     int reg;
> > +
> > +     kvm_fpu_get();
> > +     for (reg = 0; reg < KVM_HV_HYPERCALL_MAX_XMM_REGISTERS; reg++)
> > +             _kvm_write_sse_reg(reg, &hc->xmm[reg]);
> > +     kvm_fpu_put();
> > +     hc->xmm_dirty = false;
> > +}
> > +
> >  int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_hv_hcall hc;
> > @@ -1926,6 +1991,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >       hc.rep_idx = (hc.param >> HV_HYPERCALL_REP_START_OFFSET) & 0xfff;
> >       hc.rep = !!(hc.rep_cnt || hc.rep_idx);
> >
> > +     if (hc.fast && is_xmm_fast_hypercall(&hc))
> > +             kvm_hv_hypercall_read_xmm(&hc);
> > +
> >       trace_kvm_hv_hypercall(hc.code, hc.fast, hc.rep_cnt, hc.rep_idx,
> >                              hc.ingpa, hc.outgpa);
> >
> > @@ -1961,28 +2029,28 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >                               kvm_hv_hypercall_complete_userspace;
> >               return 0;
> >       case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
> > -             if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
> > +             if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
> >                       ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> >                       break;
> >               }
> >               ret = kvm_hv_flush_tlb(vcpu, &hc, false);
> >               break;
> >       case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
> > -             if (unlikely(hc.fast || hc.rep)) {
> > +             if (unlikely(hc.rep)) {
> >                       ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> >                       break;
> >               }
> >               ret = kvm_hv_flush_tlb(vcpu, &hc, false);
> >               break;
> >       case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
> > -             if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
> > +             if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
> >                       ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> >                       break;
> >               }
> >               ret = kvm_hv_flush_tlb(vcpu, &hc, true);
> >               break;
> >       case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
> > -             if (unlikely(hc.fast || hc.rep)) {
> > +             if (unlikely(hc.rep)) {
> >                       ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> >                       break;
> >               }
> > @@ -2035,6 +2103,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >               break;
> >       }
> >
> > +     if (hc.xmm_dirty)
> > +             kvm_hv_hypercall_write_xmm(&hc);
> > +
> 
> Wei already mention that but as 'xmm_dirty' is not being used in this
> patch I'd suggest we move it out too.

Okay, I should remove HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE for now then.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



