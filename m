Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373291E1176
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391065AbgEYPP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390911AbgEYPP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 11:15:27 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC71EC05BD43
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:15:26 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id x22so10687543lfd.4
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kYBoEhN96Rd2bTOOCtpwhH5a3zXfbXb8vg+QY2lOxCg=;
        b=kOFxbK1SPD4S5SY6soHeM+HeZetfnuSzhji+qxwHWT0CnYGiTqbZyd5Pheqma0e875
         +MeqLFtQktc2cDAhBp28exGqp9SwAbHfgwh33X7Te8RypMFK9HWnQkL2MrzsNAqCScK6
         JNLnQru0CXvZL1fQ60ltcd37sXmyjoIIwuA3QVgq6EEAGQFDP28U90KbysSCsAeJrZU+
         l4sNaJTOLAogUGRzOYArKj/L5yRHfKyz6aiMa9ry//yHODMO8hQzJ+4yZO8KA70LH7Du
         MKZy5UHT00e34txu1vJGIP8KP5A9zj1TgpxR4Y3ffECpWvGwe+FB9ovaeS2dyXSdWvZK
         Ptqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kYBoEhN96Rd2bTOOCtpwhH5a3zXfbXb8vg+QY2lOxCg=;
        b=kwfvUelu7svtXgh8TlcRUjC6YTuQeQRduqdYL90SqATBO6i6kYEK/cWBKOwvSorAXv
         mBKZTaeMTzKh3Rxfq86SVixAZ1Ri3oVsENwDq4r9NZ7sCan91epg6rLuyhJZGYeQUdNh
         PyWOhMfEXaTKh2MSg+zcWuytMmFieDHQalLi56Yu7GafZdfcaRhjjrFWyHO6zC6s8eDd
         t09f6lJRkMZ0QslhV1T5FbRMNAsVE1LfeyxhrrEBrY7mu+mNgNtSCpBwRa5P1M25MGU+
         NfKqUwYCb5qaF5AR7OUTUtmZ1hkHk4b20WUidZ2TfMRicc0AOyKU8IxrsJ6eq0wIYuuy
         Swew==
X-Gm-Message-State: AOAM530Q7qSiwuPXZ/GwwTh6Z0y1XyBXE0H/oKPm0cw9xPOpkTV25eQH
        aUvsEstmZP9zxuOlvUc4d+UXgw==
X-Google-Smtp-Source: ABdhPJzXLUWIYgQQ8mQTCK0ROPNDbamXhbZpVXtVtJCcCUP29y0cVktOsqQ6gbXEx34Ez3amGKFUwA==
X-Received: by 2002:a19:c505:: with SMTP id w5mr2287001lfe.201.1590419725196;
        Mon, 25 May 2020 08:15:25 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id f6sm4673999ljn.91.2020.05.25.08.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:15:24 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 79D1410230F; Mon, 25 May 2020 18:15:25 +0300 (+03)
Date:   Mon, 25 May 2020 18:15:25 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 02/16] x86/kvm: Introduce KVM memory protection feature
Message-ID: <20200525151525.qmfvzxbl7sq46cdq@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-3-kirill.shutemov@linux.intel.com>
 <87d06s83is.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d06s83is.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 04:58:51PM +0200, Vitaly Kuznetsov wrote:
> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
> 
> > Provide basic helpers, KVM_FEATURE and a hypercall.
> >
> > Host side doesn't provide the feature yet, so it is a dead code for now.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  arch/x86/include/asm/kvm_para.h      |  5 +++++
> >  arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
> >  arch/x86/kernel/kvm.c                | 16 ++++++++++++++++
> >  include/uapi/linux/kvm_para.h        |  3 ++-
> >  4 files changed, 25 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> > index 9b4df6eaa11a..3ce84fc07144 100644
> > --- a/arch/x86/include/asm/kvm_para.h
> > +++ b/arch/x86/include/asm/kvm_para.h
> > @@ -10,11 +10,16 @@ extern void kvmclock_init(void);
> >  
> >  #ifdef CONFIG_KVM_GUEST
> >  bool kvm_check_and_clear_guest_paused(void);
> > +bool kvm_mem_protected(void);
> >  #else
> >  static inline bool kvm_check_and_clear_guest_paused(void)
> >  {
> >  	return false;
> >  }
> > +static inline bool kvm_mem_protected(void)
> > +{
> > +	return false;
> > +}
> >  #endif /* CONFIG_KVM_GUEST */
> >  
> >  #define KVM_HYPERCALL \
> > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > index 2a8e0b6b9805..c3b499acc98f 100644
> > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > @@ -28,9 +28,10 @@
> >  #define KVM_FEATURE_PV_UNHALT		7
> >  #define KVM_FEATURE_PV_TLB_FLUSH	9
> >  #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
> > -#define KVM_FEATURE_PV_SEND_IPI	11
> > +#define KVM_FEATURE_PV_SEND_IPI		11
> 
> Nit: spurrious change
> 

I fixed indentation while there. (Look at the file, not the diff to see
what I mean).

> >  #define KVM_FEATURE_POLL_CONTROL	12
> >  #define KVM_FEATURE_PV_SCHED_YIELD	13
> > +#define KVM_FEATURE_MEM_PROTECTED	14
> >  
> >  #define KVM_HINTS_REALTIME      0
> >  
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 6efe0410fb72..bda761ca0d26 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -35,6 +35,13 @@
> >  #include <asm/tlb.h>
> >  #include <asm/cpuidle_haltpoll.h>
> >  
> > +static bool mem_protected;
> > +
> > +bool kvm_mem_protected(void)
> > +{
> > +	return mem_protected;
> > +}
> > +
> 
> Honestly, I don't see a need for kvm_mem_protected(), just rename the
> bool if you need kvm_ prefix :-)

For !CONFIG_KVM_GUEST it would not be a variable. We may want to change it
to static branch or something in the future.

> >  static int kvmapf = 1;
> >  
> >  static int __init parse_no_kvmapf(char *arg)
> > @@ -727,6 +734,15 @@ static void __init kvm_init_platform(void)
> >  {
> >  	kvmclock_init();
> >  	x86_platform.apic_post_init = kvm_apic_init;
> > +
> > +	if (kvm_para_has_feature(KVM_FEATURE_MEM_PROTECTED)) {
> > +		if (kvm_hypercall0(KVM_HC_ENABLE_MEM_PROTECTED)) {
> > +			pr_err("Failed to enable KVM memory protection\n");
> > +			return;
> > +		}
> > +
> > +		mem_protected = true;
> > +	}
> >  }
> 
> Personally, I'd prefer to do this via setting a bit in a KVM-specific
> MSR instead. The benefit is that the guest doesn't need to remember if
> it enabled the feature or not, it can always read the config msr. May
> come handy for e.g. kexec/kdump.

I think we would need to remember it anyway. Accessing MSR is somewhat
expensive. But, okay, I can rework it MSR if needed.

Note, that we can avoid the enabling algother, if we modify BIOS to deal
with private/shared memory. Currently BIOS get system crash if we enable
the feature from time zero.

> >  const __initconst struct hypervisor_x86 x86_hyper_kvm = {
> > diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> > index 8b86609849b9..1a216f32e572 100644
> > --- a/include/uapi/linux/kvm_para.h
> > +++ b/include/uapi/linux/kvm_para.h
> > @@ -27,8 +27,9 @@
> >  #define KVM_HC_MIPS_EXIT_VM		7
> >  #define KVM_HC_MIPS_CONSOLE_OUTPUT	8
> >  #define KVM_HC_CLOCK_PAIRING		9
> > -#define KVM_HC_SEND_IPI		10
> > +#define KVM_HC_SEND_IPI			10
> 
> Same spurrious change detected.

The same justification :)

> >  #define KVM_HC_SCHED_YIELD		11
> > +#define KVM_HC_ENABLE_MEM_PROTECTED	12
> >  
> >  /*
> >   * hypercalls use architecture specific
> 
> -- 
> Vitaly
> 
> 

-- 
 Kirill A. Shutemov
