Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEC02CCB0A
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 01:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgLCAfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 19:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgLCAfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 19:35:07 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3686C0617A6
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 16:34:20 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id v1so127370pjr.2
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 16:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=L56VCJacW1q2c0bHUonnqO3sZEHGpPYCKrI7PJZeV18=;
        b=bzscgACWYc3NUKhdAGji4SgKcfDJVJkF+yXxV6yxbdh1qhcafmxgf4Pu5euI16pCgT
         kDAbPD/T8/TxwCo7vykXENNbWhmbWyLjTiY1+uJQzQPDFvZG4BhxDeVSWs28CkCSoO7G
         slUhuLp3WEnD9UZHpRMUZFcc2juBUh9I3gybu70uOsPke6hmk4nq/WAIDiz7xsItS+OO
         Ix5X3TxPKvD79KclsDJOi3H/MvnD3HtNmqPMU4PxttgGYhB4WKLuRV/WpSIlXccZ0sG6
         R1fvITBHAzw0SdT34EpjWpjLZeKHyL8bBBwkjDeg6e2dmpdF6EooIzDpLZo5/eQfK2w1
         LeAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=L56VCJacW1q2c0bHUonnqO3sZEHGpPYCKrI7PJZeV18=;
        b=OdTnO/oma2hNm3ijh6LEm5TVFPvCeDa0ahD8CVFt2qvUWqyB3Ls9McQdmY2GFu/o2k
         VtC7/S9vNESLKhtTFpv2wANqGanfKo+AaNfinCs/w0MilxBxlEL2+FKNuGCneEWjq0XP
         Yla/6YAisM1WVfWhWR+/RisYBp7rdNQK8OGlWqBZ2xyNM1DN/JfIeTqBVA/za/R1WDNC
         sfK7BePoaxWReiuAG8TEaEyot9IEDTsPQ4Id77CcmpQLeDSlKkAdHJ8harPV9ej918a2
         nhEiJZMTlo63kRxdBDKe7ofPmalOGaaMH7mXMlDkABNkkoqnabzAIOHaqMO+EqFcBGmL
         lS7w==
X-Gm-Message-State: AOAM531b3Uap5eaYFgxVN1glHj0kuTp31kOh6lyCrvXp5As9jzCB8Bj3
        tpTLwZ3o7dzEk1phqOMjXfs1Mw==
X-Google-Smtp-Source: ABdhPJxqypXKe6FQ2p7bMz8nSZ4/SvwZtiHbun2SpE8LadQ6NSeXdctJSImynfpBWexsdCaeDUb9Zg==
X-Received: by 2002:a17:90a:e2ce:: with SMTP id fr14mr527792pjb.89.1606955660397;
        Wed, 02 Dec 2020 16:34:20 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id e2sm83742pjv.10.2020.12.02.16.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 16:34:19 -0800 (PST)
Date:   Wed, 2 Dec 2020 16:34:12 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <X8gyhCsEMf8QU9H/@google.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 01, 2020, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> KVM hypercall framework relies on alternative framework to patch the
> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> apply_alternative() is called then it defaults to VMCALL. The approach
> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> will be able to decode the instruction and do the right things. But
> when SEV is active, guest memory is encrypted with guest key and
> hypervisor will not be able to decode the instruction bytes.
> 
> Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> will be used by the SEV guest to notify encrypted pages to the hypervisor.

What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
think there are any existing KVM hypercalls that happen before alternatives are
patched, i.e. it'll be a nop for sane kernel builds.

I'm also skeptical that a KVM specific hypercall is the right approach for the
encryption behavior, but I'll take that up in the patches later in the series.

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 338119852512..bc1b11d057fc 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -85,6 +85,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>  	return ret;
>  }
>  
> +static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
> +				      unsigned long p2, unsigned long p3)
> +{
> +	long ret;
> +
> +	asm volatile("vmmcall"
> +		     : "=a"(ret)
> +		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
> +		     : "memory");
> +	return ret;
> +}
> +
>  #ifdef CONFIG_KVM_GUEST
>  bool kvm_para_available(void);
>  unsigned int kvm_arch_para_features(void);
> -- 
> 2.17.1
> 
