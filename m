Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01701647433
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLHQ0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLHQ0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:26:35 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B425C46650
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 08:26:34 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so2054296pjj.4
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 08:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lTgWx4scVyEdnNwP8DjnL1zHNWGeK2kwc0Zp2eRMXQk=;
        b=DtPAybS0x/Bv9SwEFO8iJm3Nt7GLaKJyB5eY3bSfC+VBuMJsbkTJk+3VLNLVGY97gW
         YROZkWwojaG47GUXQLrCTFJjvlpv88vKyYmpnOc7FWDgCcttWvm89GqcBOgYh8KN/QL8
         /9v/7LFByFTev9BlbnpF8R4jmudaKyQI6sPde3SvQxBvwc2GOTI4GXI5zvbTLRFvcEGx
         AGbHbEnLGeCwOozEKpTvyUxotEiTTnNjv6inA0lwY/Qszez/CUSG9OWGrms3an78tEEn
         tTpwS66zjdSS3hLf/dvzM1UXX6tyn+ws0DYwdZ39fO40IVLomt9gYa9j4OrSf3Oy0wmR
         g5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTgWx4scVyEdnNwP8DjnL1zHNWGeK2kwc0Zp2eRMXQk=;
        b=x4V1qhR6lDknjzmrImxJeHq8/jnwUmy7PeXc4zhuzdyJ/lR4mhysbJR4vQ9Nu2nHNU
         kMEsj/T5mTJ33gezFbEyTpHl4RJgPHeSxRR6KLybKPuu+5Lu4O/76kDQZm5LG8PXRVnd
         CQQmo7W8sFynAQoY0BSzDKb4LhOnvNcqMtWB51bvr0Gc/3n42LqcJRLzApOZkX+atRBE
         s6pd6F8xGWG68DxDOuhe+NopOLFUSrbXCJvDSb+BIvTEsXVs3Oyv/k5/YrtVEGCs31af
         yOh8vy9FlUue7psKs2UoN5BSlocbuE/1zmvJN3RA9ulyvC5QHaBrQj8wYijF7huLlSuF
         MpWA==
X-Gm-Message-State: ANoB5plDF4u/9OEnEC2loKczuValswQukkLfPHCdrOLAw1XvhibZWxK4
        6WNkaFbGxlGHMXgbUz2UnakQgg==
X-Google-Smtp-Source: AA0mqf7Bf1kskqLUj18tNkAcl3wyAWmGfpn9j1mAuma80CPFVrsgkisnFLZddTsm/ZeRKXFPmZsm1A==
X-Received: by 2002:a17:90a:fd0d:b0:219:828e:ba2 with SMTP id cv13-20020a17090afd0d00b00219828e0ba2mr1449958pjb.0.1670516794018;
        Thu, 08 Dec 2022 08:26:34 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h13-20020a65468d000000b00477f5ae26bbsm13286522pgr.50.2022.12.08.08.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:26:33 -0800 (PST)
Date:   Thu, 8 Dec 2022 16:26:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/cpu: Process all CPUID dependencies after
 identifying CPU info
Message-ID: <Y5IQNY/fZw2JFA0B@google.com>
References: <20221203003745.1475584-1-seanjc@google.com>
 <20221203003745.1475584-2-seanjc@google.com>
 <Y5INU3o+SFReGkLz@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5INU3o+SFReGkLz@zn.tnic>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022, Borislav Petkov wrote:
> On Sat, Dec 03, 2022 at 12:37:43AM +0000, Sean Christopherson wrote:
> > Process all CPUID dependencies to ensure that a dependent is disabled if
> > one or more of its parent features is unsupported.
> 
> Just out of curiosity: this is some weird guest configuration, right?

No, it's also relevant for bare metal.

> Not addressing a real hw issue...

But it's not really a hardware issue either.  More like an admin/user issue.

The problem is that if a kernel is built for subset of CPU types, e.g. just Intel
or just Centaur, and then booted on an "unsupported" CPU type, init_ia32_feat_ctl()
will never be invoked because ->c_init() will point a default_init(), and so the
kernel never checks MSR_IA32_FEAT_CTL to see if VMX and/or SGX are fully enabled.

E.g. if someone booted an "unsupported" kernel and also disabled VMX in BIOS, then
the CPU will enumerate support for VMX in CPUID, but attempting to actually enable
VMX will fail due to VMX being disabled in MSR_IA32_FEAT_CTL.

> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index bf4ac1cb93d7..094fc69dba63 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -1887,6 +1887,12 @@ static void identify_cpu(struct cpuinfo_x86 *c)
> >  
> >  	ppin_init(c);
> >  
> > +	/*
> > +	 * Apply CPUID dependencies to ensure dependent features are disabled
> > +	 * if a parent feature is unsupported but wasn't explicitly disabled.
> > +	 */
> > +	apply_cpuid_deps(c);
> 
> I'd probably call that resolve_cpuid_deps()...

"resolve" works for me.
