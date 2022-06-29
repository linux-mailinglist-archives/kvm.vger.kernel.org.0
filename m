Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF2C55FCFA
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 12:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbiF2KRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 06:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiF2KRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 06:17:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB642CE3F;
        Wed, 29 Jun 2022 03:17:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a15so14630298pfv.13;
        Wed, 29 Jun 2022 03:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xyEiHigKzx4VUsyVHUqj++7h/bAeyOOrhTGKC4bujf8=;
        b=ge3sSf4NWvgXrngzOZofKGy/PEzQBAwi3PMW7LLMkaWomoCRFxXSHl8OEN7hbMQdQF
         UoKBK65vL4Zu5yTJcwpgfJIIfJi/Vlt1V5Qz4ecj4WfXLPeycgM6hmxd4ldMw34N0SDZ
         Xyg3LexweXbFfHsVhRv3LZSIpRp4zwpspPjH4HlYRxzNnzqHO6YuogQHLvrNaCzhdt32
         LQgCp4iPhVRqkx6rlBRhAzTEfG7um/nzBILSNjxVVnM1bVqcY8+OdeEE0xp+ML9Q+drb
         avyNoAQWKcaItUpny/OfF5Elkhct5Y7Pmi9tKc/m+0E/MV0yEvwVRjMftOZ+jgHstpH/
         OCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xyEiHigKzx4VUsyVHUqj++7h/bAeyOOrhTGKC4bujf8=;
        b=w1GCptPM/Rm5GPn4rzuPcIC/vRNoQcg0vamOKVafLhoK6bG6tRKhFsvhXFvOVjNi9d
         w9QBr/bXsBiA+s5JT+XUOFxeOXNdlliYBcAt6PKZsLeq1BLDSjrJKywRZ35OGSMf5YcK
         Iz1zjO0GuJ9R2bCQI8zVXBnxpUmD8SXWJTIzBX6oT8hlWhR29MDz/gjd900o6FLg4oOz
         lTmxQrgto1cuFc9OBmQYb9H8CEHBgoBmzkdYT3FJRbbpuxMrC19eO71JHHrPVZqakrkP
         DWKXcgrQVIWk8RjDUWy0VggFb4mLYHg46iP2x1gHMjLIaUhPmwe/MUqdXqFsQyUWPBK3
         zXxQ==
X-Gm-Message-State: AJIora/YhzFqdm8RO53+vwO09shUoMLMO8mNr2WGX1Vo9yAenKkVYBU9
        7yhKTGfPG+wUT0PAQ5xY0Po=
X-Google-Smtp-Source: AGRyM1s6jizcY8Lc+dyBW04lMaaLWwllQ2r1AXYoVlNVy8Aev6olTAF0IK2AxWcXumezGPYn70isIQ==
X-Received: by 2002:a63:6ac3:0:b0:411:4aa9:9034 with SMTP id f186-20020a636ac3000000b004114aa99034mr2431769pgc.94.1656497866240;
        Wed, 29 Jun 2022 03:17:46 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id ms9-20020a17090b234900b001ec7c8919f0sm1678613pjb.23.2022.06.29.03.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 03:17:45 -0700 (PDT)
Date:   Wed, 29 Jun 2022 03:17:44 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v6 093/104] KVM: TDX: Handle TDX PV MMIO hypercall
Message-ID: <20220629101744.GB882746@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <ea5e6a1fc740cfe69167c8713b63fdb952a98e8b.1651774251.git.isaku.yamahata@intel.com>
 <CAAhR5DGHhPagnaiC=Bn9v0qhNQ5N9HjsrDyQkv4dtui7dfMAbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhR5DGHhPagnaiC=Bn9v0qhNQ5N9HjsrDyQkv4dtui7dfMAbA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 11:08:16AM -0700,
Sagi Shahar <sagis@google.com> wrote:

> On Thu, May 5, 2022 at 11:16 AM <isaku.yamahata@intel.com> wrote:
> >
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Export kvm_io_bus_read and kvm_mmio tracepoint and wire up TDX PV MMIO
> > hypercall to the KVM backend functions.
> >
> > kvm_io_bus_read/write() searches KVM device emulated in kernel of the given
> > MMIO address and emulates the MMIO.  As TDX PV MMIO also needs it, export
> > kvm_io_bus_read().  kvm_io_bus_write() is already exported.  TDX PV MMIO
> > emulates some of MMIO itself.  To add trace point consistently with x86
> > kvm, export kvm_mmio tracepoint.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/x86.c     |   1 +
> >  virt/kvm/kvm_main.c    |   2 +
> >  3 files changed, 117 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index ee0cf5336ade..6ab4a52fc9e9 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1057,6 +1057,118 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
> >         return ret;
> >  }
> >
> > +static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
> > +{
> > +       unsigned long val = 0;
> > +       gpa_t gpa;
> > +       int size;
> > +
> > +       WARN_ON(vcpu->mmio_needed != 1);
> > +       vcpu->mmio_needed = 0;
> > +
> > +       if (!vcpu->mmio_is_write) {
> > +               gpa = vcpu->mmio_fragments[0].gpa;
> > +               size = vcpu->mmio_fragments[0].len;
> > +
> > +               memcpy(&val, vcpu->run->mmio.data, size);
> > +               tdvmcall_set_return_val(vcpu, val);
> > +               trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> > +       }
> > +       return 1;
> > +}
> > +
> > +static inline int tdx_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, int size,
> > +                                unsigned long val)
> > +{
> > +       if (kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
> > +           kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
> > +               return -EOPNOTSUPP;
> > +
> > +       trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
> > +       return 0;
> > +}
> > +
> > +static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
> > +{
> > +       unsigned long val;
> > +
> > +       if (kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
> > +           kvm_io_bus_read(vcpu, KVM_MMIO_BUS, gpa, size, &val))
> > +               return -EOPNOTSUPP;
> > +
> > +       tdvmcall_set_return_val(vcpu, val);
> > +       trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> > +       return 0;
> > +}
> > +
> > +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
> > +{
> > +       struct kvm_memory_slot *slot;
> > +       int size, write, r;
> > +       unsigned long val;
> > +       gpa_t gpa;
> > +
> > +       WARN_ON(vcpu->mmio_needed);
> > +
> > +       size = tdvmcall_a0_read(vcpu);
> > +       write = tdvmcall_a1_read(vcpu);
> > +       gpa = tdvmcall_a2_read(vcpu);
> > +       val = write ? tdvmcall_a3_read(vcpu) : 0;
> > +
> > +       if (size != 1 && size != 2 && size != 4 && size != 8)
> > +               goto error;
> > +       if (write != 0 && write != 1)
> > +               goto error;
> > +
> > +       /* Strip the shared bit, allow MMIO with and without it set. */
> > +       gpa = gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(vcpu->kvm));
> > +
> > +       if (size > 8u || ((gpa + size - 1) ^ gpa) & PAGE_MASK)
> > +               goto error;
> > +
> > +       slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
> > +       if (slot && !(slot->flags & KVM_MEMSLOT_INVALID))
> > +               goto error;
> > +
> > +       if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
> > +               trace_kvm_fast_mmio(gpa);
> > +               return 1;
> > +       }
> > +
> > +       if (write)
> > +               r = tdx_mmio_write(vcpu, gpa, size, val);
> > +       else
> > +               r = tdx_mmio_read(vcpu, gpa, size);
> > +       if (!r) {
> > +               /* Kernel completed device emulation. */
> > +               tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> > +               return 1;
> > +       }
> > +
> > +       /* Request the device emulation to userspace device model. */
> > +       vcpu->mmio_needed = 1;
> > +       vcpu->mmio_is_write = write;
> > +       vcpu->arch.complete_userspace_io = tdx_complete_mmio;
> > +
> > +       vcpu->run->mmio.phys_addr = gpa;
> > +       vcpu->run->mmio.len = size;
> > +       vcpu->run->mmio.is_write = write;
> > +       vcpu->run->exit_reason = KVM_EXIT_MMIO;
> > +
> > +       if (write) {
> > +               memcpy(vcpu->run->mmio.data, &val, size);
> > +       } else {
> > +               vcpu->mmio_fragments[0].gpa = gpa;
> > +               vcpu->mmio_fragments[0].len = size;
> > +               trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL);
> > +       }
> > +       return 0;
> > +
> > +error:
> > +       tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> 
> We should return an error code here.

Yes, I'll fix it as follows. Thanks for catching it.

 error:
-       tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+       tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
        return 1;
 }

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
