Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AC032D7D7
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 17:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbhCDQcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 11:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237729AbhCDQcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 11:32:22 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CADC06175F
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 08:31:42 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id r5so19295729pfh.13
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 08:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tfjZcU3b9XBszi13RocA+Z9H6iZikjohZpktcKNP5fc=;
        b=Y1vfUPKT1GHGCBY0dM8C+w9CbN7Ip3h+88hNE/NlXWIcyElau962o/KQMx8jYFFaOo
         s2ff2PW6zQeC0DAxTi73sAU727e23c9eIkfhmmGUV9eojoG9/dZdXs04VEz8v7+hOGMg
         EQfobU3ygD/63hSoTHfW+EPeV4h01iMofeqHyFYoNcZqRMUtlEOR5PEsYyH7ZCoXTuQj
         TiLwrg9psTBYOCSIAjKkR104Oj1wKyNecLlipeJeMoQ6WFNWUsiW5h1xiBKCDBL7doHs
         uuWgnizHmyXUNb1BBTLmLZXdkFl1G6o6FFXNBaiCUxTCqrgj301lyqEgjmQ4ToGwhBtE
         RamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tfjZcU3b9XBszi13RocA+Z9H6iZikjohZpktcKNP5fc=;
        b=LsMnhUaCuMBm33hzQi9eUv8pEaaRWzSHZKVPdj7d5HxNeJEwW02Ht9WYLNgUAtF7dj
         EXAYS2K8vRPjmbge/nNuiYNinBBl6LolhJu8zmpz/btQEC7aCmkJOSY1+tAfa4mdoRhj
         ivGKT7ms0JU9RwgHbcm8/g5GneFcuU6ySRtvB3Cu7rdn8ius5btJ3wCbVvYkwYQ+YlAP
         reLEnPwU816BTVnzwLr4gtZKnyT7cVZhA2z/tRfFgZPWXdgku6C+lpRH0yTdPPG+K8pQ
         4Yk2QmSGPykASKNu60oDL9BHLi1QbR2ORv/QVhPfRRpd9RVWKG+lToV1D2FA64pEGlWH
         6M+g==
X-Gm-Message-State: AOAM530/z1NeXLlxBEDJ1Pxyg34RrO9WjoaOPUmKJMr+q00oa6yxFoYq
        qAylm/qxhZYHcDNXaqqU9da8Ug==
X-Google-Smtp-Source: ABdhPJwNoHZ/3Js5xWBwohw3D7AGveEJqPGqJ+cg/f6v1ML2WyYoZUdZilbK5gLPT5Eleqo+4lgizQ==
X-Received: by 2002:aa7:93a6:0:b029:1ed:8b81:6a2e with SMTP id x6-20020aa793a60000b02901ed8b816a2emr4560406pff.29.1614875501447;
        Thu, 04 Mar 2021 08:31:41 -0800 (PST)
Received: from google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
        by smtp.gmail.com with ESMTPSA id h7sm3156541pfo.45.2021.03.04.08.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 08:31:40 -0800 (PST)
Date:   Thu, 4 Mar 2021 08:31:33 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 9/9] KVM: x86: Add XSAVE Support for Architectural LBRs
Message-ID: <YEELZUP3BjStSvHq@google.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-10-like.xu@linux.intel.com>
 <YD/PYp0DtZaw2HYh@google.com>
 <b6b3476b-3278-9a40-33a9-0014fed9bbfb@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6b3476b-3278-9a40-33a9-0014fed9bbfb@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021, Like Xu wrote:
> On 2021/3/4 2:03, Sean Christopherson wrote:
> >          if (vmx_umip_emulated())
> >                  kvm_cpu_cap_set(X86_FEATURE_UMIP);
> > 
> >          /* CPUID 0xD.1 */
> > -       supported_xss = 0;
> >          if (!cpu_has_vmx_xsaves())
> >                  kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
> 
> if (!cpu_has_vmx_xsaves())
> 	supported_xss = 0;

Argh, I forgot XSAVES has a VMCS control.  That's why kvm_arch_hardware_setup()
clears supported_xss if !XSAVES.  I guess just leave that existing code, but
maybe add a comment.

Paolo, any thoughts on how to keep supported_xss aligned with support_xcr0,
without spreading the logic around too much?

> 	kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
> 
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 7b0adebec1ef..5f9eb1f5b840 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -205,6 +205,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
> >                                  | XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> >                                  | XFEATURE_MASK_PKRU)
> > 
> > +#define KVM_SUPPORTED_XSS      XFEATURE_MASK_LBR
> > +
> >   u64 __read_mostly host_efer;
> >   EXPORT_SYMBOL_GPL(host_efer);
> > 
> > @@ -8037,6 +8039,11 @@ int kvm_arch_init(void *opaque)
> >                  supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
> >          }
> > 
> > +       if (boot_cpu_has(X86_FEATURE_XSAVES))
> 
> {
> 
> > +               rdmsrl(MSR_IA32_XSS, host_xss);
> > +               supported_xss = host_xss & KVM_SUPPORTED_XSS;
> > +       }
> > +
> >          if (pi_inject_timer == -1)
> >                  pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);
> >   #ifdef CONFIG_X86_64
> > @@ -10412,9 +10419,6 @@ int kvm_arch_hardware_setup(void *opaque)
> > 
> >          rdmsrl_safe(MSR_EFER, &host_efer);
> > 
> > -       if (boot_cpu_has(X86_FEATURE_XSAVES))
> > -               rdmsrl(MSR_IA32_XSS, host_xss);
> > -
> >          r = ops->hardware_setup();
> >          if (r != 0)
> >                  return r;
> > @@ -10422,9 +10426,6 @@ int kvm_arch_hardware_setup(void *opaque)
> >          memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
> >          kvm_ops_static_call_update();
> > 
> > -       if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> > -               supported_xss = 0;
> > -
> >   #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> >          cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> >   #undef __kvm_cpu_cap_has
> > 
> 
