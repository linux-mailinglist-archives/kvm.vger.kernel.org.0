Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426553061A8
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 18:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhA0RPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhA0ROS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 12:14:18 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24812C06178A
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 09:13:19 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y205so1601902pfc.5
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 09:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=efbAr3xGl0vNWQhrAPFMIOemgSWTahbx/gfwbK/fDiY=;
        b=Tw/qSamoFoZYdipTMlu/3PFqpRP4OxRQFRy4pcWwzpWQO5OFh1XZpiXZMAgWcDaA7s
         CnNU8VGnU+6XWJTQ/py+LzX8zFkfspuFic6zgnWu6qJFix/7UfAnIklobeIfDTx1YyNO
         mcBHaplBZsTErNufK5Fl6ZDNJNaml1peHMg/Gocbx6szfp4YCfBJcdm0YIbYlED3FGeW
         X6w8bEgULTMWRz9lqmKdJOi+KEQdo47PzSLncUjGQ6Y2JMGYw63jdC22FgVycpY6GN8b
         wSizWxnR00hNzFjESp1wngH7CNCK4zT3X/UGXg82OixkGWq7rEI7fOqj1nEqQ6mg1pEo
         /MXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=efbAr3xGl0vNWQhrAPFMIOemgSWTahbx/gfwbK/fDiY=;
        b=X5Q5AjpW7BxiRdt3VKyCHemiyWHH7W35YzH+AJTJ3tWDcd3ETH+5HlK4XLYRfqeOyP
         QHJLphmaNsWXXDMTg3ux5gsEYvGImqQZCGR+ufu6fKt0VHwJItJDqgrw9clvxpNWPcWm
         5kpNck3g1jwFt8K+tP8F7sO5CCNdaclQ9AgdePBDkGHIWFgm0yWgep9K7CxPdFwfPQ/8
         jquXtX2JkhuO0P0aTj6qPi4uFIpeLu2YBCS1LCYbJCUpyhbxwaMd3BgRzsd+eXYE1P89
         T+b2fum8XID92GDjRdCciW82GpBU7kkeQWgoT5x+LoHRe4yqu9YChQS7q7VDpbtaCm9J
         a2lg==
X-Gm-Message-State: AOAM533xe4nXAmresAA1x66aH6m5+6NPX4she8yA/fh7obn6wHVS3pMc
        UalWmMAKI65tCz8e5qxyn8Vkgg==
X-Google-Smtp-Source: ABdhPJzjyvPn/UEyvPBc4oXcCgOgS5sVVPp/odbp3aUzApd+183VqPmkKatDQbc3k8W/7nxo3mHuLg==
X-Received: by 2002:a05:6a00:2296:b029:1b6:6972:2f2a with SMTP id f22-20020a056a002296b02901b669722f2amr11499462pfe.69.1611767598435;
        Wed, 27 Jan 2021 09:13:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id v9sm2502871pju.33.2021.01.27.09.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 09:13:17 -0800 (PST)
Date:   Wed, 27 Jan 2021 09:13:10 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-ID: <YBGfJn4smCd6JvWV@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
 <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
 <20210127125607.52795a882ace894b19f41d68@intel.com>
 <ecb0595b-76e9-9298-438d-80de28156371@intel.com>
 <20210127150224.5d7de004fb6b3fb72a969f07@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127150224.5d7de004fb6b3fb72a969f07@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 27, 2021, Kai Huang wrote:
> On Tue, 26 Jan 2021 16:18:31 -0800 Dave Hansen wrote:
> > On 1/26/21 3:56 PM, Kai Huang wrote:
> > > On Tue, 26 Jan 2021 08:26:21 -0800 Dave Hansen wrote:
> > >> On 1/26/21 1:30 AM, Kai Huang wrote:
> > >>> --- a/arch/x86/kernel/cpu/feat_ctl.c
> > >>> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > >>> @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
> > >>>  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> > >>>  {
> > >>>  	bool tboot = tboot_enabled();
> > >>> -	bool enable_sgx;
> > >>> +	bool enable_vmx;
> > >>> +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
> > >>>  	u64 msr;
> > >>>  
> > >>>  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
> > >>> @@ -114,13 +115,22 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> > >>>  		return;
> > >>>  	}
> > >>>  
> > >>> +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> > >>> +		     IS_ENABLED(CONFIG_KVM_INTEL);
> > >>
> > >> The reason it's called 'enable_sgx' below is because this code is
> > >> actually going to "enable sgx".  This code does not "enable vmx".  That
> > >> makes this a badly-named variable.  "vmx_enabled" or "vmx_available"
> > >> would be better.
> > > 
> > > It will also try to enable VMX if feature control MSR is not locked by BIOS.
> > > Please see below code:
> > 
> > Ahh, I forgot this is non-SGX code.  It's mucking with all kinds of
> > other stuff in the same MSR.  Oh, well, I guess that's what you get for
> > dumping a bunch of refactoring in the same patch as the new code.
> > 
> > 
> > >>> -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > >>> -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > >>> -		     IS_ENABLED(CONFIG_X86_SGX);
> > >>> +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> > >>> +			 cpu_has(c, X86_FEATURE_SGX1) &&
> > >>> +			 IS_ENABLED(CONFIG_X86_SGX);
> > >>
> > >> The X86_FEATURE_SGX1 check seems to have snuck in here.  Why?
> > > 
> > > Please see my reply to Sean's reply.
> > 
> > ... yes, so you're breaking out the fix into a separate patch,.
> 
> For the separate patch to fix SGX1 check, if I understand correctly, SGX driver
> should be changed too. I feel I am not the best person to do it. Jarkko or Sean
> is. 

SGX driver doesn't need to be changed, just this core feat_ctl.c code.

> So I'll remove SGX1 here in the next version, but I won't include another
> patch to fix the SGX1 logic. If Jarkko or Sean sent out that patch, and it is
> merged quickly, I can rebase on top of that.
> 
> Does this make sense?

Yep, adding a check on SGX1 is definitely not mandatory for this series.
