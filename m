Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E0030F851
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 17:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbhBDQnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 11:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238022AbhBDQnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 11:43:11 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604E4C061788
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 08:42:31 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id my11so5314213pjb.1
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 08:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EEzkB6KBykSa84B36mWQtsqm2CNIxmUYCcv/2V8Jq/g=;
        b=SKF4eIuVg/lLzlwuixMf3U19cEbR9jy4AizAJnOQ5pIYJ6jmpBaBxa9QlsnHGf6Bgz
         qmGU1X98u0+ztfSTetCoYS72vf1RvBZWpiewzgf2K3IlnY+Wr3rQqEcZL+VuV+//4tZd
         yt4/4fKsA9TwIm4IKznxWjgZ5TlAIMWPfwUBC/tzb2DN+VCfketn4VHOpd3HwlhP0/kd
         nc8S2COcuhYY7v8vAi6mVfVW/4G/zQN8to3yVEhT0R8bZj+VvjCKSoBHXhvO10S2Zo0O
         II/pCsLZohgRnSRBiEPTg9h3krsg6mxl3q1Qh6qCb2I/x0W+pNwWtoB0szPDSZsZADRv
         Wg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EEzkB6KBykSa84B36mWQtsqm2CNIxmUYCcv/2V8Jq/g=;
        b=X4sgOyrlUsHKf4M6gT28o2+VS9m1HROC7aD5WXhtNebgH0HAHeRC71gqdQfJA1PzOc
         7uP3wyA7LKVNK/OYBGCii6RjMYx2ed5AM6ODv8kwZxFQCbvsH7qVuGis5hOvCYK47/Vw
         aYY4kretzgVZFMPVqZQQBnsYxKinnpUxLpXxzDcqduTFpTtQiz41Pce0Ir5CtgSOLXn7
         Mz97udDSQbwJKoAFT4LAUZwCvmW/UHwDDSPEJtUWXGSeYQnpWRhV7IzYU/y64jsrP7Im
         LuyvlCBhtHNOuOaqQmP4IofRVkoft/so7UdhBhujBZli1/5ouGLyRoi1pGk1gwNRk8xv
         PeLw==
X-Gm-Message-State: AOAM531k/Jrb84S4VpfMyYVvlNO5YgzQiw3TbaruRxtiWzyufLc3vyGn
        f/iztPkoazCmFKMc/yRLEc3GLA==
X-Google-Smtp-Source: ABdhPJzGptj9+SwXd4AANgey9HMIo3kKFzOkoPCSiJ7MsS+Qu19JvRFEx9zLyryYbckkmVfA6l1iFg==
X-Received: by 2002:a17:90b:ed0:: with SMTP id gz16mr341695pjb.7.1612456950755;
        Thu, 04 Feb 2021 08:42:30 -0800 (PST)
Received: from google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
        by smtp.gmail.com with ESMTPSA id bo1sm4822871pjb.7.2021.02.04.08.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 08:42:29 -0800 (PST)
Date:   Thu, 4 Feb 2021 08:42:23 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception
 dispatch
Message-ID: <YBwj78dE5iGZOLed@google.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-5-weijiang.yang@intel.com>
 <YBsZwvwhshw+s7yQ@google.com>
 <5b822165-9eff-bfa9-000f-ae51add59320@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b822165-9eff-bfa9-000f-ae51add59320@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Paolo Bonzini wrote:
> On 03/02/21 22:46, Sean Christopherson wrote:
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index dbca1687ae8e..0b6dab6915a3 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2811,7 +2811,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
> >                 /* VM-entry interruption-info field: deliver error code */
> >                 should_have_error_code =
> >                         intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
> > -                       x86_exception_has_error_code(vector);
> > +                       x86_exception_has_error_code(vcpu, vector);
> >                 if (CC(has_error_code != should_have_error_code))
> >                         return -EINVAL;
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 28fea7ff7a86..0288d6a364bd 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -437,17 +437,20 @@ EXPORT_SYMBOL_GPL(kvm_spurious_fault);
> >  #define EXCPT_CONTRIBUTORY     1
> >  #define EXCPT_PF               2
> > 
> > -static int exception_class(int vector)
> > +static int exception_class(struct kvm_vcpu *vcpu, int vector)
> >  {
> >         switch (vector) {
> >         case PF_VECTOR:
> >                 return EXCPT_PF;
> > +       case CP_VECTOR:
> > +               if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
> > +                       return EXCPT_BENIGN;
> > +               return EXCPT_CONTRIBUTORY;
> >         case DE_VECTOR:
> >         case TS_VECTOR:
> >         case NP_VECTOR:
> >         case SS_VECTOR:
> >         case GP_VECTOR:
> > -       case CP_VECTOR:

This removal got lost when squasing.

arch/x86/kvm/x86.c: In function ‘exception_class’:
arch/x86/kvm/x86.c:455:2: error: duplicate case value
  455 |  case CP_VECTOR:
      |  ^~~~
arch/x86/kvm/x86.c:446:2: note: previously used here
  446 |  case CP_VECTOR:
      |  ^~~~

> >                 return EXCPT_CONTRIBUTORY;
> >         default:
> >                 break;
> > @@ -588,8 +591,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
> >                 kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> >                 return;
> >         }
> > -       class1 = exception_class(prev_nr);
> > -       class2 = exception_class(nr);
> > +       class1 = exception_class(vcpu, prev_nr);
> > +       class2 = exception_class(vcpu, nr);
> >         if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
> >                 || (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
> >                 /*
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index a14da36a30ed..dce756ffb577 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -120,12 +120,16 @@ static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
> >  #endif
> >  }
> > 
> > -static inline bool x86_exception_has_error_code(unsigned int vector)
> > +static inline bool x86_exception_has_error_code(struct kvm_vcpu *vcpu,
> > +                                               unsigned int vector)
> >  {
> >         static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
> >                         BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
> >                         BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
> > 
> > +       if (vector == CP_VECTOR && (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET))
> > +               return false;
> > +
> >         return (1U << vector) & exception_has_error_code;
> >  }
> > 
> > 
> > 
> > 
> 
> Squashed, thanks.  I made a small change to the last hunk:
> 
>         if (!((1U << vector) & exception_has_error_code))
>                 return false;
> 
>         if (vector == CP_VECTOR)
>                 return !(vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET);
> 
>         return true;

Ha, I guessed wrong, that was my first pass at it :-)
