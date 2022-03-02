Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861974CB19B
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 22:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245435AbiCBVzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 16:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245432AbiCBVzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 16:55:17 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAAF5EBE3
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 13:54:33 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id x14so2499687ill.12
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 13:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jw0yJGgLc5yPP7bHbqVAnm6+30TMRh44wS9dzRA7C+8=;
        b=dDIXsau5642w3JFkWor/MbAKmtgx95zufN+ROJnAMFEc2LWnGYAzI6LStgBUI4hHlW
         3/uISbs3FjJODVXfKOAjFycKcddLaYGwZRriguf9/nS+13Wxx97XmNitobwTTy+JvThp
         fDV8MuRuM+4soarmneGT9e4sJZlbCSK9JVIY/50XPrD6gysUhe7TYeA4de7XePuhRItF
         kpdU11AuVK2XhEhwtHjXeby/ggRpo8UxaZ51nKo2jv/nArG/snXPpYp2pbOZ952vY913
         jH9VJy1MirMzizRV4OMSnNeW6BEyC6vgumB1bMIYyWhktzs5ODlOTbegJHHpHTnvmiiG
         LFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jw0yJGgLc5yPP7bHbqVAnm6+30TMRh44wS9dzRA7C+8=;
        b=YG+5Xgx94a9wAohM3Y/HkJzl/vPNWWIP2o5EgwWdvlrjGhFcinatPw35koMtG1kpoQ
         Q1RCfWUoKn7qkxZX0H0BmQR72PdU5m08DQ++mxRHro4PmUaohQzsa6Izw3r78ZdA1AXX
         ZxULkw3GtqfUKv3RTGDANKFGlvAcM8q9DLUxDQhk9ElfG0irrjUYdSLwE5J3GBbbuFSv
         MdXTf1D4OxkD1j0uF8gsgJohXAepLFXb/pQxp7NpXa/hIrW2QGbqPTO6CLNQwigv6Cjt
         pFEU1HOQg6fvj0uc4wx8bwJra0zUzpRysq3FvIm9gz0IAPWaTd8RtAMEUgrxu76V2Bed
         KGrA==
X-Gm-Message-State: AOAM532ngVwPqfgoMxPJzDW8dq3gro7RgdBNhWMABctaOE44Y8qbxgvg
        w+erK9OXxgC6KXE1nuwZwemYlQ==
X-Google-Smtp-Source: ABdhPJwsyRIqv4wzmfdZVd4RdBCzBW27Jl+F+fUXhzMF4DktQUmkrXeG9wNacYb2+E0XOQZ8Qfdhrg==
X-Received: by 2002:a05:6e02:1aab:b0:2c2:60ba:b21f with SMTP id l11-20020a056e021aab00b002c260bab21fmr29770116ilv.133.1646258072367;
        Wed, 02 Mar 2022 13:54:32 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id n5-20020a056e02148500b002c426e077d4sm171767ilk.19.2022.03.02.13.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:54:31 -0800 (PST)
Date:   Wed, 2 Mar 2022 21:54:28 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <Yh/nlOXzIhaMLzdk@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-2-oupton@google.com>
 <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
 <Yh5pYhDQbzWQOdIx@google.com>
 <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com>
 <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 10:22:43PM +0100, Paolo Bonzini wrote:
> On 3/2/22 21:51, Oliver Upton wrote:
> > On Wed, Mar 02, 2022 at 01:21:23PM +0100, Paolo Bonzini wrote:
> > > On 3/1/22 19:43, Oliver Upton wrote:
> > > > Right, a 1-setting of '{load,clear} IA32_BNDCFGS' should really be the
> > > > responsibility of userspace. My issue is that the commit message in
> > > > commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when
> > > > guest MPX disabled") suggests that userspace can expect these bits to be
> > > > configured based on guest CPUID. Furthermore, before commit aedbaf4f6afd
> > > > ("KVM: x86: Extract kvm_update_cpuid_runtime() from
> > > > kvm_update_cpuid()"), if userspace clears these bits, KVM will continue
> > > > to set them based on CPUID.
> > > > 
> > > > What is the userspace expectation here? If we are saying that changes to
> > > > IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS after userspace writes these MSRs is a
> > > > bug, then I agree aedbaf4f6afd is in fact a bugfix. But, the commit
> > > > message in 5f76f6f5ff96 seems to indicate that userspace wants KVM to
> > > > configure these bits based on guest CPUID.
> > > 
> > > Yes, but I think it's reasonable that userspace wants to override them.  It
> > > has to do that after KVM_SET_CPUID2, but that's okay too.
> > > 
> > 
> > In that case, I can rework the tests at the end of this series to ensure
> > userspace's ability to override w/o a quirk. Sorry for the toil,
> > aedbaf4f6afd caused some breakage for us internally, but really is just
> > a userspace bug.
> 
> How did vanadium break?

Maybe I can redirect you to a test case to highlight a possible
regression in KVM, as seen by userspace ;-)

from Patch 7/8:

> +	/*
> +	 * Test that KVM will set these bits regardless of userspace if the
> +	 * guest CPUID exposes a supporting vPMU.
> +	 */
> +	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
> +			     0,						/* set */
> +			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,	/* clear */
> +			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,	/* exp_set */
> +			     0);					/* exp_clear */
> +	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS,
> +			     0,						/* set */
> +			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,	/* clear */
> +			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,	/* exp_set */
> +			     0);					/* exp_clear */

Same goes for the "{load,clear} IA32_BNDCFGS" bits too.

--
Thanks,
Oliver
