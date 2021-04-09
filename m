Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40C2359FF1
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 15:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhDINgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 09:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhDINgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 09:36:17 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308E9C061760
        for <kvm@vger.kernel.org>; Fri,  9 Apr 2021 06:36:04 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id v140so9771137lfa.4
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 06:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3iD4YPxW/GP1gLZhw0O0u7ekYYA6XBjCYhKSDPDU1Uk=;
        b=ASn6nOKS/A0qn9YbTJ8T7s3Rq/GyJIDqVwQh4KiNp31Eu3x1Z/F6vdVZf2cgPIK4zI
         9nbsfUTIbO2JRyeaJYHen9ytoZlrAJXlcm6EkaWSpfDpX6ekzT8I0CBgVwDVfYVuSZGH
         uNSECLSqHmIbLXWEiO3AtafEPSqnn5WRXro3iW4S1bBjjeWd5nWA8xZVhTLYylCniNv5
         A7fmusxTFdLHj7gPteXorF3GK/ZzdG8ymUzXqOOw5ppKh2fsC4ldnoVskZJc/GZ+CdW8
         O2+W2TDIqFKsba2/j7t7/wE8gAYNZb9/F+MlO8bQiEJ3FUEYm+/Ik+8F308mb0Kr/q3C
         /TVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3iD4YPxW/GP1gLZhw0O0u7ekYYA6XBjCYhKSDPDU1Uk=;
        b=jydKTgTQJSU7C/fyrn20PNkf0FeY6+ttMEDTvTmIZ45aXRqeDIIvuECfy3wcr0bOPz
         ATfXmoRTLlfXDuSt0Uu9QLbACwDWGfVQCXWiyCIMn2SDBityP2PkEQYeGT6Onu96T3Ye
         2NgECbonHazte0cMJGwY/DjK1q8UOtnL5LM0E+GBAIoeyJbn2VMB7vO9IDwUJltc7pHc
         6HhKtrgX46lnhpRYkPZ5JfWOaEWU0JWvjE8JYd/cxFre2yZRO+oPMFlCiPvJ+JEf/TYR
         1zsJtuimLRgoX7NmkZzDhH9R+/MuL6LdTOdGZlC+q7oZJPjl+HyrBCRwb8yNO27LSlWF
         fVrA==
X-Gm-Message-State: AOAM533RCuC+l2uay1jzuTiWrN3KA9rauOWD/hrMHLPg1pO5JKgyz3Dx
        9RP4JVKcyMTqNNNPVuo4HYLKsg==
X-Google-Smtp-Source: ABdhPJzH0HSzYIfAmTefFcmEs8zRV9QQ2kRmVMCTFZ1Mop7ndZjumchbz1SmhaQhEudIYYGEbZGfTg==
X-Received: by 2002:a05:6512:304c:: with SMTP id b12mr9772234lfb.3.1617975362748;
        Fri, 09 Apr 2021 06:36:02 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id k11sm272080ljg.119.2021.04.09.06.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 06:36:02 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 96C0F102498; Fri,  9 Apr 2021 16:36:01 +0300 (+03)
Date:   Fri, 9 Apr 2021 16:36:01 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv1 2/7] x86/kvm: Introduce KVM memory protection feature
Message-ID: <20210409133601.2qepfc77stujulhf@box>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-3-kirill.shutemov@linux.intel.com>
 <20210408095235.GH10192@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408095235.GH10192@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 11:52:35AM +0200, Borislav Petkov wrote:
> On Fri, Apr 02, 2021 at 06:26:40PM +0300, Kirill A. Shutemov wrote:
> > Provide basic helpers, KVM_FEATURE, CPUID flag and a hypercall.
> > 
> > Host side doesn't provide the feature yet, so it is a dead code for now.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  arch/x86/include/asm/cpufeatures.h   |  1 +
> >  arch/x86/include/asm/kvm_para.h      |  5 +++++
> >  arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
> >  arch/x86/kernel/kvm.c                | 18 ++++++++++++++++++
> >  include/uapi/linux/kvm_para.h        |  3 ++-
> >  5 files changed, 28 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 84b887825f12..5b6f23e6edc4 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -238,6 +238,7 @@
> >  #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
> >  #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
> >  #define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
> > +#define X86_FEATURE_KVM_MEM_PROTECTED	( 8*32+22) /* KVM memory protection extenstion */
> 										    ^^^^^^^^^^
> What's that feature bit for?

The patchset is still in path-finding stage. I'll be more specific once we
settle on how the feature works.
 
> Also, use a spellchecker pls: "extenstion".

Ouch. Thanks.

-- 
 Kirill A. Shutemov
