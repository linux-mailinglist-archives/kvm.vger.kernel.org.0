Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A6054B844
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 20:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245051AbiFNSIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 14:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238035AbiFNSI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 14:08:29 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9A83527C
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 11:08:28 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id w2so16486895ybi.7
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 11:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C78v/CAN8C2z22MVaDl0QxTyyJoCfPguMq8MOK3tOJc=;
        b=KPQRP+y1/9biwSKOdmOrA7l+Ng8mYs2ZKqEsk1EcYmkGcOWMD3eVJOVUvBbrZYLqLa
         XxmEyIa3+nMLYvLo8wsYQD6u2h6vJ69PlvvEWBU4hwT/ftXEt28sTdms2tNq2oqAwkJ2
         xCAMYyeEgKvWmnPoO7td7+2N+gClf9AyQwwCLajgaaQu89TWxl4Z3nrdDmLCzj2nvrDt
         iEDgjcTO60gIUOVeCKdV4ZZl/HvoU7NaI0kNlP+lV1x3XSzN1cMxBhRoG5rEWorAbSrH
         Bc+DXxtEPmMLZj2PPf9qEivHmu0mikMk2gU1zLrWRRh2zuFLQceSL6wcyYVB3HSoZP1/
         nNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C78v/CAN8C2z22MVaDl0QxTyyJoCfPguMq8MOK3tOJc=;
        b=TXNzaI95q+XVKO86HHcBm7lzyUzNv3Z7A68MjNQZjS/ggn4JYD5/uLhbQnLVNYoRaI
         ssDuULwuLPW4dLnonyw+ny2Q22nEbMMjgmRbBh/F/5CPp6Wb4ZVaHlfyvysH/dRD82t2
         bhL3b/YD1hAT4f5SnWog7saaLO4X63S/1ptmeKgMHSF6ICkVFxp1RVyM8n4U4lWc4WLh
         wuADxhIhM4C/yGZRCqjKqNLJoI6jOqM7vT0l+5+rAS1S3FsYTqOu9xXec+kgaH7JyL5p
         5yhLn4MUHkm9IGAbZl0V43c1snG2sog8kqGaI5xS37g+bOkF1AGQ9Bk7MOA5yM01e8KE
         jPNg==
X-Gm-Message-State: AJIora8EYwoB5sNgbQ6dsgelQORGZmFC0YXX5rXHphjy+ocOEFAQmnXB
        LNdE2FxW1Oct0CF/RNJ6VRtPkv0WQrXGRGIhfKhIVyOyEyw=
X-Google-Smtp-Source: AGRyM1srZeha6aWpFJbD1p8y4wYjg8EMJ2RoztXJmVyLYONCPC4TSE6IGnH1wzu0dpdgL/3uTx0GgDipYFQRNz1mLZs=
X-Received: by 2002:a25:5d0d:0:b0:633:25c8:380 with SMTP id
 r13-20020a255d0d000000b0063325c80380mr5966062ybb.167.1655230107606; Tue, 14
 Jun 2022 11:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651774250.git.isaku.yamahata@intel.com> <ea5e6a1fc740cfe69167c8713b63fdb952a98e8b.1651774251.git.isaku.yamahata@intel.com>
In-Reply-To: <ea5e6a1fc740cfe69167c8713b63fdb952a98e8b.1651774251.git.isaku.yamahata@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Tue, 14 Jun 2022 11:08:16 -0700
Message-ID: <CAAhR5DGHhPagnaiC=Bn9v0qhNQ5N9HjsrDyQkv4dtui7dfMAbA@mail.gmail.com>
Subject: Re: [RFC PATCH v6 093/104] KVM: TDX: Handle TDX PV MMIO hypercall
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 11:16 AM <isaku.yamahata@intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Export kvm_io_bus_read and kvm_mmio tracepoint and wire up TDX PV MMIO
> hypercall to the KVM backend functions.
>
> kvm_io_bus_read/write() searches KVM device emulated in kernel of the given
> MMIO address and emulates the MMIO.  As TDX PV MMIO also needs it, export
> kvm_io_bus_read().  kvm_io_bus_write() is already exported.  TDX PV MMIO
> emulates some of MMIO itself.  To add trace point consistently with x86
> kvm, export kvm_mmio tracepoint.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c     |   1 +
>  virt/kvm/kvm_main.c    |   2 +
>  3 files changed, 117 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ee0cf5336ade..6ab4a52fc9e9 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1057,6 +1057,118 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>         return ret;
>  }
>
> +static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long val = 0;
> +       gpa_t gpa;
> +       int size;
> +
> +       WARN_ON(vcpu->mmio_needed != 1);
> +       vcpu->mmio_needed = 0;
> +
> +       if (!vcpu->mmio_is_write) {
> +               gpa = vcpu->mmio_fragments[0].gpa;
> +               size = vcpu->mmio_fragments[0].len;
> +
> +               memcpy(&val, vcpu->run->mmio.data, size);
> +               tdvmcall_set_return_val(vcpu, val);
> +               trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> +       }
> +       return 1;
> +}
> +
> +static inline int tdx_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, int size,
> +                                unsigned long val)
> +{
> +       if (kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
> +           kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
> +               return -EOPNOTSUPP;
> +
> +       trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
> +       return 0;
> +}
> +
> +static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
> +{
> +       unsigned long val;
> +
> +       if (kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
> +           kvm_io_bus_read(vcpu, KVM_MMIO_BUS, gpa, size, &val))
> +               return -EOPNOTSUPP;
> +
> +       tdvmcall_set_return_val(vcpu, val);
> +       trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> +       return 0;
> +}
> +
> +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_memory_slot *slot;
> +       int size, write, r;
> +       unsigned long val;
> +       gpa_t gpa;
> +
> +       WARN_ON(vcpu->mmio_needed);
> +
> +       size = tdvmcall_a0_read(vcpu);
> +       write = tdvmcall_a1_read(vcpu);
> +       gpa = tdvmcall_a2_read(vcpu);
> +       val = write ? tdvmcall_a3_read(vcpu) : 0;
> +
> +       if (size != 1 && size != 2 && size != 4 && size != 8)
> +               goto error;
> +       if (write != 0 && write != 1)
> +               goto error;
> +
> +       /* Strip the shared bit, allow MMIO with and without it set. */
> +       gpa = gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(vcpu->kvm));
> +
> +       if (size > 8u || ((gpa + size - 1) ^ gpa) & PAGE_MASK)
> +               goto error;
> +
> +       slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
> +       if (slot && !(slot->flags & KVM_MEMSLOT_INVALID))
> +               goto error;
> +
> +       if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
> +               trace_kvm_fast_mmio(gpa);
> +               return 1;
> +       }
> +
> +       if (write)
> +               r = tdx_mmio_write(vcpu, gpa, size, val);
> +       else
> +               r = tdx_mmio_read(vcpu, gpa, size);
> +       if (!r) {
> +               /* Kernel completed device emulation. */
> +               tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +               return 1;
> +       }
> +
> +       /* Request the device emulation to userspace device model. */
> +       vcpu->mmio_needed = 1;
> +       vcpu->mmio_is_write = write;
> +       vcpu->arch.complete_userspace_io = tdx_complete_mmio;
> +
> +       vcpu->run->mmio.phys_addr = gpa;
> +       vcpu->run->mmio.len = size;
> +       vcpu->run->mmio.is_write = write;
> +       vcpu->run->exit_reason = KVM_EXIT_MMIO;
> +
> +       if (write) {
> +               memcpy(vcpu->run->mmio.data, &val, size);
> +       } else {
> +               vcpu->mmio_fragments[0].gpa = gpa;
> +               vcpu->mmio_fragments[0].len = size;
> +               trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL);
> +       }
> +       return 0;
> +
> +error:
> +       tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);

We should return an error code here.

> +       return 1;
> +}
> +
>  static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>  {
>         if (tdvmcall_exit_type(vcpu))
> @@ -1069,6 +1181,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>                 return tdx_emulate_hlt(vcpu);
>         case EXIT_REASON_IO_INSTRUCTION:
>                 return tdx_emulate_io(vcpu);
> +       case EXIT_REASON_EPT_VIOLATION:
> +               return tdx_emulate_mmio(vcpu);
>         default:
>                 break;
>         }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5f291470a6f6..f367d0dcef97 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13166,6 +13166,7 @@ bool kvm_arch_dirty_log_supported(struct kvm *kvm)
>
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4bf7178e42bd..7f01131666de 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2294,6 +2294,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>
>         return NULL;
>  }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>
>  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>  {
> @@ -5169,6 +5170,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>         r = __kvm_io_bus_read(vcpu, bus, &range, val);
>         return r < 0 ? r : 0;
>  }
> +EXPORT_SYMBOL_GPL(kvm_io_bus_read);
>
>  /* Caller must hold slots_lock. */
>  int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
> --
> 2.25.1
>

Sagi
