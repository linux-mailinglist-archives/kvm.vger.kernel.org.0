Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0D3E0ABF
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 01:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhHDXOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 19:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhHDXOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 19:14:00 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BEAC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 16:13:46 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id j3so4807095plx.4
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 16:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hhzTmvNlWX5cKj6uzpJv9KHQQbPrBdXTpixCjT3/PRY=;
        b=CljRFbd5fhdRHtTbrFsjmE9HHVOxjA6WE3njAiFdB1gI6+JOk5KVge64dGAItgJVAI
         fgriTirhsOb+gXeVyHe6z/iUnGJspAQ2mJhT+o2awWo0dAqLDv7Pob5x2bKcY3ihPKZm
         0Gea0WZIVPuz96wmRUocfThv0ABdgr1lHO6LNxxkEhomg4GW2rF/JPa57f1KPmCSOvwg
         DtjxHxiXYEo06yiX5I0BAwkxeQ90Coxmon5FV2UgdsbpAd9Y91ZNftnWjVjHAvAvidfu
         qb0tBzwv5w6ZPv+Mx1JOhPavS5d/aOVQQrdoAZXrZCb83B+0Bra9rRoJLdbVfSGDDU58
         0RFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hhzTmvNlWX5cKj6uzpJv9KHQQbPrBdXTpixCjT3/PRY=;
        b=e9h1miy2sycac4CPuSI/tAn41bhJOmWb4IppEZffMwFi2PK+WI+6t5BXQz4bYTeZJ5
         yQJim2tMWLSg0MYUcJw41DVX0Cbsg5wjF181K7dV2ThqSZ/WNYSLvBGoe26aTtqK7EP5
         fvIcyFPLlSa75NoQ5dCvvt/WFMRq2NB5ax4QRgeq9OWgwHtFiaWem9GqXTf/rfYJn1I/
         M7n97840OlqiSf8va7VnYipj7fpF4/6lj60/u8+MQ5B5d3xM8y7K603s0FQo4FI882nk
         Q8u0MW+z2nO25HQWxznQOc/79EzZnVwRUzUlB34MgeQ3r3ATWiH7NPQ1JQ9DA5NoFAAZ
         4K7A==
X-Gm-Message-State: AOAM530EQAPiww0wTucQKfx+KZ7BjSt45CG3GYHi2BfRCqGSz2JBJ40r
        WknSqrJ3KSsFR/nfwjPIwHzJig==
X-Google-Smtp-Source: ABdhPJyM4JA7mt02CDJlruQVu5XDPKIQJxwCbXXn/wTHD7VWYf0SV3iqKmzCPDVbVd+hbS+HZZvZ/Q==
X-Received: by 2002:a17:90a:8404:: with SMTP id j4mr12028214pjn.66.1628118826210;
        Wed, 04 Aug 2021 16:13:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g19sm7279988pjl.25.2021.08.04.16.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 16:13:45 -0700 (PDT)
Date:   Wed, 4 Aug 2021 23:13:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Connor Kuehl <ckuehl@redhat.com>, x86 <x86@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
Subject: Re: [RFC PATCH v2 05/69] KVM: TDX: Add architectural definitions for
 structures and values
Message-ID: <YQsfJsZskiI2968+@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <d29b2ac2090f20e8de96888742feb413f597f1dc.1625186503.git.isaku.yamahata@intel.com>
 <CAAYXXYy=fn9dUMjY6b6wgCHSTLewnTZLKb00NMupDXSWbNC9OQ@mail.gmail.com>
 <1057bbfe-c73e-a182-7696-afc59a4786d8@intel.com>
 <CAAYXXYwDuRMQ16X3mshkGcBQXhvgoxPTCu8UGggYgfCzHOWwtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYXXYwDuRMQ16X3mshkGcBQXhvgoxPTCu8UGggYgfCzHOWwtQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021, Erdem Aktas wrote:
> On Mon, Aug 2, 2021 at 6:25 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> > > Is this information correct and is this included in the spec? I tried
> > > to find it but somehow I do not see it clearly defined.
> > >
> > >> +#define TDX1_NR_TDCX_PAGES             4
> > >> +#define TDX1_NR_TDVPX_PAGES            5
> > >> +
> > >> +#define TDX1_MAX_NR_CPUID_CONFIGS      6
> > > Why is this just 6? I am looking at the CPUID table in the spec and
> > > there are already more than 6 CPUID leaves there.
> >
> > This is the number of CPUID config reported by TDH.SYS.INFO. Current KVM
> > only reports 6 leaves.
> 
> I, personally, still think that it should be enumerated, rather than
> hardcoded. It is not clear to me why it is 6 and nothing in the spec
> says it will not change.

It's both hardcoded and enumerated.  KVM's hardcoded value is specifically the
maximum value expected for TDX-Module modules supporting the so called "1.0" spec.
It's certainly possible a spec change could bump the maximum, but KVM will refuse
to use a module with higher maximums until Linux/KVM is updated to play nice with
the new module.

Having hardcoded maximum allows for simpler and more efficient code, as loops and
arrays can be statically defined instead of having to pass around the enumerated
values.

And we'd want sanity checking anyways, e.g. if the TDX-module pulled a stupid and
reported that it needs 4000 TDCX pages.  This approach gives KVM documented values
to sanity check, e.g. instead of arbitrary magic numbers.

The downside of this approach is that KVM will need to be updated to play nice
with a new module if any of these maximums are raised.  But, IMO that's acceptable
because I can't imagine a scenario where anyone would want to load a TDX module
without first testing the daylights out of the specific kernel+TDX combination,
especially a TDX-module that by definition includes new features.

> > >> +#define TDX1_MAX_NR_CMRS               32
> > >> +#define TDX1_MAX_NR_TDMRS              64
> > >> +#define TDX1_MAX_NR_RSVD_AREAS         16
> > >> +#define TDX1_PAMT_ENTRY_SIZE           16
> > >> +#define TDX1_EXTENDMR_CHUNKSIZE                256
> > >
> > > I believe all of the defined variables above need to be enumerated
> > > with TDH.SYS.INFO.

And they are, though I believe the code for doing the actual SEAMCALL wasn't
posted in this series.  The output is sanity checked by tdx_hardware_enable():

+	tdx_caps.tdcs_nr_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE;
+	if (tdx_caps.tdcs_nr_pages != TDX1_NR_TDCX_PAGES)
+		return -EIO;
+
+	tdx_caps.tdvpx_nr_pages = tdsysinfo->tdvps_base_size / PAGE_SIZE - 1;
+	if (tdx_caps.tdvpx_nr_pages != TDX1_NR_TDVPX_PAGES)
+		return -EIO;
+
+	tdx_caps.attrs_fixed0 = tdsysinfo->attributes_fixed0;
+	tdx_caps.attrs_fixed1 = tdsysinfo->attributes_fixed1;
+	tdx_caps.xfam_fixed0 =	tdsysinfo->xfam_fixed0;
+	tdx_caps.xfam_fixed1 = tdsysinfo->xfam_fixed1;
+
+	tdx_caps.nr_cpuid_configs = tdsysinfo->num_cpuid_config;
+	if (tdx_caps.nr_cpuid_configs > TDX1_MAX_NR_CPUID_CONFIGS)
+		return -EIO;
+
