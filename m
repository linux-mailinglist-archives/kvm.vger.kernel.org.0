Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DD82EC574
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 22:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbhAFVFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 16:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbhAFVFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 16:05:41 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825CEC061757
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 13:05:01 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j13so2274985pjz.3
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 13:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zzg8Z6G+CvFPyP7nFVoZoHtwuut7F7/Tw5yEokQ4fdI=;
        b=BLPmK219CFBYmDwJaW7HJjLPtbO7ywMScjrybeK0vDFsgdOh98NldPEwXLGb8HWD3d
         OclQY0rbOHUzuyDmA1TZqHokEKBYlocyjPKsmth5FrTEPSsDa83hXJIEcdROK79rQfUd
         4sj+9SsitOZuAbRqVqKdJwUIm7cYQyJNrG9m82GYidDYqd0hPEfBVoE20DYl8rE/3qD1
         Ye9eS9N069x5z1pswa5U824d8qQeJ8NRY9i8eqwmmCOVECfv5ApTZzG67sO90aw6ekd3
         MhNAs2rUsNmsbbQGfSGuZl269gjEwKILQxIYq78jBm0+kZmWqSXA5so8E8/6C72Blw+Y
         w1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zzg8Z6G+CvFPyP7nFVoZoHtwuut7F7/Tw5yEokQ4fdI=;
        b=tGM6FEondzmTQccVNRRCANqSkrONhE0vYcWs6tUwKOd4ver20UXlhhqv6wtpR7GpJf
         mjskEWxE8b//UUoInq8/EhdbkvBfgXHPg73O/VHvnvjKYfUhY14UTmtKNxh4DhwcssHj
         +4sKXeO1La/SU5bkJ2rsg7fxFtV2PQA+vFZlLraumwmWuya9G7daxnV32oOtax5KKwbC
         vxPYWuxnO4h0QQUTFzkTewQ9DksefYskmSCUbWXHmKx1++vnq6gizrPlJSdy9Q1Q7J6+
         gn8+yxnkJHPWm0WmHNPKAH22m9wtUDh7a7gvEkvJ6L87f4F+8/ZF6lD7Hyf1cz7ZvDLn
         EaBA==
X-Gm-Message-State: AOAM5331uS8xKADEfNWRLPFnMpV2x/Fb9PZkJzWFjgJvTxY3MfYDSdLi
        b6K8Qtc86DRDFwKD/+AE+D5Wyg==
X-Google-Smtp-Source: ABdhPJzEEIqfesaZuVTFrp2qQjY8HkYEIA51RUHWiD2yGd6a8btuk6r4hNKMWT9bcUO84laTDl+uwg==
X-Received: by 2002:a17:902:ee86:b029:da:76bc:2aa4 with SMTP id a6-20020a170902ee86b02900da76bc2aa4mr6239627pld.62.1609967100848;
        Wed, 06 Jan 2021 13:05:00 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id x6sm3462621pfq.57.2021.01.06.13.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 13:05:00 -0800 (PST)
Date:   Wed, 6 Jan 2021 13:04:53 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 11/23] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <X/Yl9UTLhYHg6AVi@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
 <6b29d1ee66715b40aba847b31cbdac71cbb22524.1609890536.git.kai.huang@intel.com>
 <863820fc-f0d2-6be6-52db-ab3eefe36f64@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863820fc-f0d2-6be6-52db-ab3eefe36f64@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021, Dave Hansen wrote:
> On 1/5/21 5:56 PM, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Provide wrappers around __ecreate() and __einit() to hide the ugliness
> > of overloading the ENCLS return value to encode multiple error formats
> > in a single int.  KVM will trap-and-execute ECREATE and EINIT as part
> > of SGX virtualization, and on an exception, KVM needs the trapnr so that
> > it can inject the correct fault into the guest.
> 
> This is missing a bit of a step about how and why ECREATE needs to be
> run in the host in the first place.

There's (hopefully) good info in the KVM usage patch that can be borrowed:

  Add an ECREATE handler that will be used to intercept ECREATE for the
  purpose of enforcing and enclave's MISCSELECT, ATTRIBUTES and XFRM, i.e.
  to allow userspace to restrict SGX features via CPUID.  ECREATE will be
  intercepted when any of the aforementioned masks diverges from hardware
  in order to enforce the desired CPUID model, i.e. inject #GP if the
  guest attempts to set a bit that hasn't been enumerated as allowed-1 in
  CPUID.
 
> > diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> > new file mode 100644
> > index 000000000000..0d643b985085
> > --- /dev/null
> > +++ b/arch/x86/include/asm/sgx.h
> > @@ -0,0 +1,16 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_X86_SGX_H
> > +#define _ASM_X86_SGX_H
> > +
> > +#include <linux/types.h>
> > +
> > +#ifdef CONFIG_X86_SGX_VIRTUALIZATION
> > +struct sgx_pageinfo;
> > +
> > +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> > +		     int *trapnr);
> > +int sgx_virt_einit(void __user *sigstruct, void __user *token,
> > +		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
> > +#endif
> > +
> > +#endif /* _ASM_X86_SGX_H */
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> > index d625551ccf25..4e9810ba9259 100644
> > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -261,3 +261,58 @@ int __init sgx_virt_epc_init(void)
> >  
> >  	return misc_register(&sgx_virt_epc_dev);
> >  }
> > +
> > +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> > +		     int *trapnr)
> > +{
> > +	int ret;
> > +
> > +	__uaccess_begin();
> > +	ret = __ecreate(pageinfo, (void *)secs);
> > +	__uaccess_end();
> 
> The __uaccess_begin/end() worries me.  There are *very* few of these in
> the kernel and it seems like something we want to use as sparingly as
> possible.
> 
> Why don't we just use the kernel mapping for 'secs' and not have to deal
> with stac/clac?

The kernel mapping isn't readily available.  At this point, it's not even
guaranteed that @secs points at an EPC page.  Unlike the driver code, where the
EPC page is allocated on-demand by the kernel, the pointer here is userspace
(technically guest) controlled.  The caller (KVM) is responsible for ensuring
it's a valid userspace address, but the SGX/EPC specific checks are mostly
deferred to hardware.

It's also possible to either retrieve the existing kernel mapping or to generate
a new mapping by resolving the PFN; this is/was simpler.

> I'm also just generally worried about casting away an __user without
> doing any checking.  How is that OK?

Short answer, KVM validates the virtual addresses.

KVM validates the host virtual addresses (HVA) when creating a memslot (maps
GPA->HVA).  The HVAs that are passed to these helpers are generated/retrieved
by KVM translating GVA->GPA->HVA; the GPA->HVA stage ensures the address is in a
valid memslot, and thus a valid user address.

That being said, these aren't exactly fast operations, adding access_ok() checks
is probably a good idea.
