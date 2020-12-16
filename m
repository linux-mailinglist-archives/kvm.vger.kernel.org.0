Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C81D2DC820
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 22:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgLPVGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 16:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgLPVGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 16:06:40 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01501C06179C
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 13:06:00 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 131so17383814pfb.9
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 13:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TaU9p63XhvWNhY6D/qJiSam8sjXJmlJiAOjcENiYbJc=;
        b=bNXjpByCKgOosTIt5c7REa1FXJQnnPrFfh/Ktk59hc7JWyFfCsy4zoi9fTxjqrPaef
         /3FNiMUtqTDchcD7nRkYty+LVxecYSct+G3GAUfp2DlWNQRYJ8ULovPuHZzRikL7JpRm
         +fNjkvCT2Wp9PrPEu+LZ6GeuJd3JTzYElkPB7c/Zt6cJnC797LF82jAzl4W98ZYp1reK
         x1kUUOhru4t9oVt1bEqObz9v+FK4TbBh6s131gZ7b+8R1kEJ1HltoJx4IjlBNCNZCdoc
         JZxYPzvckBHPio5ifbRhkm7GLVaOeqatTteJUAcY6hZ+w3CwsyUhAOX+Em2DmSlZqRSU
         6Q8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TaU9p63XhvWNhY6D/qJiSam8sjXJmlJiAOjcENiYbJc=;
        b=fmpEZX7HPm4AuKKIJvZXMXt71bwg4a/ER6gIzwpm7Lkh/fNKM2WHlth0AUdK1wNKYv
         15lkh5O0z3ILdURAW4rucxrSL0vlYV+Xu8OCGYXhHlGLFNL2rik2iIT/llJUzaAqRi7W
         IlXias/ZX7Q/BYWKZbF6BbVLAte+7scgzDBRzObZQ5DVVfJv7R8xjMGNOVDd2LzWSs56
         FnP7u/89Sbh7KjX3NG20PoJliU0SK93MLwyz39Zl2cjw6Crx0WAXK9p/y+60n9mFnLcc
         Nk1sDFQdF9AHcGlvhilDRKTykoGfB4yQMa4p0AfOoYgtwZegKjsRH/1CEd10rd7npDx+
         9d5w==
X-Gm-Message-State: AOAM530/kCkzzIDq9AoLY5mFb7IFU9aD2hjVk/VPXbvm1PTs13XAPLKj
        X8TjNnrhOHypSMfKHAyhuyEBeg==
X-Google-Smtp-Source: ABdhPJxR1+wOui1rk4K1WVCogFybFQRo0PstIcBIKL8cEivwnW7iocdWC2VB9ZYTEbFhOcaDgDUo1g==
X-Received: by 2002:a62:844b:0:b029:19e:62a0:ca18 with SMTP id k72-20020a62844b0000b029019e62a0ca18mr3033382pfd.46.1608152759348;
        Wed, 16 Dec 2020 13:05:59 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id v3sm3075218pjn.7.2020.12.16.13.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 13:05:58 -0800 (PST)
Date:   Wed, 16 Dec 2020 13:05:52 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM/nVMX: Use __vmx_vcpu_run in
 nested_vmx_check_vmentry_hw
Message-ID: <X9p2sHrG0ezvSetC@google.com>
References: <20201029134145.107560-1-ubizjak@gmail.com>
 <CAFULd4av_xehfPBBL76dH+On4ezLa6rqU6YkqBuLhPcvZTr5pQ@mail.gmail.com>
 <c0f5129e-a04a-5b9c-f561-1132283077f1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0f5129e-a04a-5b9c-f561-1132283077f1@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020, Krish Sadhukhan wrote:
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index d14c94d0aff1..0f390c748b18 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -6591,8 +6591,6 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
> > >          }
> > >   }
> > > 
> > > -bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
> > > -
> > >   static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> > >                                          struct vcpu_vmx *vmx)
> > >   {
> > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > index f6f66e5c6510..32db3b033e9b 100644
> > > --- a/arch/x86/kvm/vmx/vmx.h
> > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > @@ -339,6 +339,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
> > >   struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
> > >   void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
> > >   void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
> > > +bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
> > >   int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
> > >   void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
> > > 
> > > --
> > > 2.26.2
> > > 
> Semantically __vmx_vcpu_run() is called to enter guest mode. In
> nested_vmx_check_vmentry_hw(), we are not entering guest mode. Guest mode is
> entered when nested_vmx_enter_non_root_mode() calls enter_guest_mode().

Naming aside, this patch intentionally redefines the semantics to mean "execute
VM-Enter that may or may not succeed".  And as called out in the changelog, the
overhead of the GPR save/load/restore is tolerable; reusing code and avoiding
ugly inline asm is more important.

> Secondly, why not just replace the first half of the assembly block with a
> call to vmx_update_host_rsp() and leave the rest as is ?

As above, though not called out in the changelog, the goal is to move away from
the inline asm without introducing another asm subroutine.

Uros, I'll try to double check and review this later today.
