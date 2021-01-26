Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA26305D40
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313349AbhAZWf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730154AbhAZRFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:05:12 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02833C061573
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 09:00:54 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w14so10775285pfi.2
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 09:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ENlLmc+JejdwJwWT2OL+d2JHDx3OTLzS/BlF7JGq2nA=;
        b=aZ/ShnW8eg0eJ5zhC4gY7+YObNwS5lRBPfbAGJ4ULjVLsF55wBXe9n8giN7CT2SM/S
         /DhG85ScJiXlL0JBakWStEdk5M3H2FD/nemAq/AIG+jo2/oEzN/nFlhqJHdRvGmX5ckg
         f//nXQd0qCvuQymR64nsDY27lBtZBNl1KEQ5mE47uORe6pr9IRdvs6ewoYwBbiEzzzB5
         I4t9ku9OHD8eAp6XM9e87sB3533UzU8oa+xG5YS+i0xD3Wp2LPVifKg73pICaNyKzMma
         OE+Ps9wJU+TuEfyzftqI/wrZ6KVCmQihFVoNg8oo3Ng6DqQCbCpdLgADSyKcrgU5TlRS
         66CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ENlLmc+JejdwJwWT2OL+d2JHDx3OTLzS/BlF7JGq2nA=;
        b=b1WMEliPutdA3ckTpFKGwBYqw1RAmDOxefKKk511+a2BRMySYXRQsWnY/Tqge1paKy
         HnRoQxdDlUwfpozQ8ACeVghxcZoIq4A3Qn0ZF4kAguF/NcGUc+w0w58b6ZUBN5zp/syZ
         CwBl1ZvZGcPLyYk6CHk35p3ofWh5uBaug/DFMW0Ul+b2Luk+W1+Gfvuubg0LVhN2ZgsE
         27hyVK026opubFtZPc4dUGJdNwu3y8khuDjVxwRWUMAf/ZcJsLVNnHxcFm6PqQ1y0toq
         dhyzx21nXz83xTkUR+pNP3IQAuTXgAOg6QlGUrYu55pB0+wRiJCRkNu+g4LIZ1B/UzrX
         09sA==
X-Gm-Message-State: AOAM530syyRyKCZVSb5W+gyis9d3dO1scQZZlHgTUoPu6vTwTMjP6K3F
        T/57GGnwF9Wva3qvFsnYcmd9EA==
X-Google-Smtp-Source: ABdhPJyWOBKzyzUyfMtkAbOdRuR4zb43p89ImjgpolqyL65mgDafFCN9gIbSLho2Ez7hZxhmbwoDxQ==
X-Received: by 2002:a65:5283:: with SMTP id y3mr6502558pgp.174.1611680453424;
        Tue, 26 Jan 2021 09:00:53 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a2sm5382885pgq.94.2021.01.26.09.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 09:00:52 -0800 (PST)
Date:   Tue, 26 Jan 2021 09:00:45 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-ID: <YBBKvecRXYclMnpH@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
 <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021, Dave Hansen wrote:
> > -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > -		     IS_ENABLED(CONFIG_X86_SGX);
> > +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> > +			 cpu_has(c, X86_FEATURE_SGX1) &&
> > +			 IS_ENABLED(CONFIG_X86_SGX);
> 
> The X86_FEATURE_SGX1 check seems to have snuck in here.  Why?

It's a best effort check to handle the scenario where SGX is enabled by BIOS,
but was disabled by hardware in response to a machine check bank being disabled.
Adding a check on SGX1 should be in a different patch.  I thought we had a
dicscussion about why the check was omitted in the merge of bare metal support,
but I can't find any such thread.

> > +	enable_sgx_driver = enable_sgx_any &&
> > +			    cpu_has(c, X86_FEATURE_SGX_LC);
> > +	enable_sgx_kvm = enable_sgx_any && enable_vmx &&
> > +			  IS_ENABLED(CONFIG_X86_SGX_KVM);
> >  
> >  	if (msr & FEAT_CTL_LOCKED)
> >  		goto update_caps;
> > @@ -136,15 +146,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	 * i.e. KVM is enabled, to avoid unnecessarily adding an attack vector
> >  	 * for the kernel, e.g. using VMX to hide malicious code.
> >  	 */
> > -	if (cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM_INTEL)) {
> > +	if (enable_vmx) {
> >  		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> >  
> >  		if (tboot)
> >  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
> >  	}
> >  
> > -	if (enable_sgx)
> > -		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
> > +	if (enable_sgx_kvm || enable_sgx_driver) {
> > +		msr |= FEAT_CTL_SGX_ENABLED;
> > +		if (enable_sgx_driver)
> > +			msr |= FEAT_CTL_SGX_LC_ENABLED;
> > +	}
> >  
> >  	wrmsrl(MSR_IA32_FEAT_CTL, msr);
> >  
> > @@ -167,10 +180,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	}
> >  
> >  update_sgx:
> > -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> > -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> > -		if (enable_sgx)
> > -			pr_err_once("SGX disabled by BIOS\n");
> > +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
> > +		if (enable_sgx_kvm || enable_sgx_driver)
> > +			pr_err_once("SGX disabled by BIOS.\n");
> >  		clear_cpu_cap(c, X86_FEATURE_SGX);
> > +		return;
> > +	}
> 
> 
> Isn't there a pr_fmt here already?  Won't these just look like:
> 
> 	sgx: SGX disabled by BIOS.
> 
> That seems a bit silly.

Eh, I like the explicit "SGX" to clarify that the hardware feature was disabled.
