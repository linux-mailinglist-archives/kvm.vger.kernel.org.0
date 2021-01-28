Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA8B307BE4
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhA1RL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbhA1RKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 12:10:05 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34044C0613D6
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:09:25 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id n10so4671062pgl.10
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PJ8vhRlRVNsnNigVA3H+x3MLmJHygV2g8jXvg7Vnj4Y=;
        b=kLroCc1xOeYMVKQR0s/ZTRX42tJ/fVbTONzC/+Y7nlPAB9ANbAatBAgie7gpPCjzXW
         Y2BvBl2+i9f+Ziz4nBFIcLoBoBAlJm1hWLFTbiJ1Si2k7PwvQNhflJGVbZio6DiwXiDX
         3QhggykFuj+J36w0q3sqHyHPH4DPP4/wsxBOmWqTCSBkL88ESZibZQoOLkGkjS861gGd
         OTEXpz4vrcYffjOCI01VN1Ovv6MbJOUfP/ZESb2JAqLw78rNUD2nvDogSsN8Cg95Hhg5
         4rrL0x9ERcull8gxyr/f4Z27WaXxnxeeoSDGXcdv5W0J+IfUFOVsEFNFEzdIsbQEk7I7
         CK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PJ8vhRlRVNsnNigVA3H+x3MLmJHygV2g8jXvg7Vnj4Y=;
        b=S0wzrEwbYoQShE4C6TQj+JZm21Jkk1OWVC5ege83bJsVbgcVSG/CSpn1bgLTSfBMRQ
         WzQe4R0sPnvNVKTHE84Ecxi22tIgI21Bgfjvb4Y3WSQeSNEz9GiHluTIZjGbo3iGZzga
         lm+gxAHsLdu1CYF10njmccZcP+VeHKBLh1Q4/4jDd6nDwYkVQ0nMzSekQd6j62rCm6+r
         wOO9LmQWihoDHTfxTwxJxrf6C6P2tqKmzdZzlOioq6VVLi1fV3uxsDnI0LdJmsV1LRNA
         zBhmyeH3jI8uIy7YLHoL5CAlGaS4r6qhFDvl44nuUzmA6lq7l06PHbGqR4FSQS+lwKq/
         ZFOA==
X-Gm-Message-State: AOAM531H/uvMTYQ2Qu4/jPxWs73mT/9YJSbp+05S+C4XQkOAVUK5SEod
        RUe5/HEqFsx+SnlTAGk+hwt+pg==
X-Google-Smtp-Source: ABdhPJxnMcoxMMfmamEou+2TlotHDWW8f0QfrKGSgKlCV6FqqyFfUIJe76KcBU9KACT92xkL360dbg==
X-Received: by 2002:a65:6453:: with SMTP id s19mr481327pgv.280.1611853764502;
        Thu, 28 Jan 2021 09:09:24 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 5sm5389515pjz.23.2021.01.28.09.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 09:09:23 -0800 (PST)
Date:   Thu, 28 Jan 2021 09:09:18 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 05/14] KVM: x86: Override reported SME/SEV feature
 flags with host mask
Message-ID: <YBLvvpeEORjVd2IP@google.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-6-seanjc@google.com>
 <74642db3-14dc-4e13-3130-dc8abe1a2b6e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74642db3-14dc-4e13-3130-dc8abe1a2b6e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 28, 2021, Paolo Bonzini wrote:
> On 14/01/21 01:36, Sean Christopherson wrote:
> > Add a reverse-CPUID entry for the memory encryption word, 0x8000001F.EAX,
> > and use it to override the supported CPUID flags reported to userspace.
> > Masking the reported CPUID flags avoids over-reporting KVM support, e.g.
> > without the mask a SEV-SNP capable CPU may incorrectly advertise SNP
> > support to userspace.
> > 
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/cpuid.c | 2 ++
> >   arch/x86/kvm/cpuid.h | 1 +
> >   2 files changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 13036cf0b912..b7618cdd06b5 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -855,6 +855,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >   	case 0x8000001F:
> >   		if (!boot_cpu_has(X86_FEATURE_SEV))
> >   			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> > +		else
> > +			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
> >   		break;
> >   	/*Add support for Centaur's CPUID instruction*/
> >   	case 0xC0000000:
> > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > index dc921d76e42e..8b6fc9bde248 100644
> > --- a/arch/x86/kvm/cpuid.h
> > +++ b/arch/x86/kvm/cpuid.h
> > @@ -63,6 +63,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
> >   	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
> >   	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
> >   	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
> > +	[CPUID_8000_001F_EAX] = {0x8000001f, 1, CPUID_EAX},
> >   };
> >   /*
> > 
> 
> I don't understand, wouldn't this also need a kvm_cpu_cap_mask call
> somewhere else?  As it is, it doesn't do anything.

Ugh, yes, apparently I thought the kernel would magically clear bits it doesn't
care about.

Looking at this again, I think the kvm_cpu_cap_mask() invocation should always
mask off X86_FEATURE_SME.  SME cannot be virtualized, and AFAIK it's not
emulated by KVM.  This would fix an oddity where SME would be advertised if SEV
is also supported.

Boris has queue the kernel change to tip/x86/cpu, I'll spin v4 against that.
