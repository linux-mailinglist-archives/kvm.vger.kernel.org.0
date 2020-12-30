Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A923A2E7AEE
	for <lists+kvm@lfdr.de>; Wed, 30 Dec 2020 17:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgL3QJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 11:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgL3QJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 11:09:01 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529D2C06179B
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 08:08:21 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id be12so8856293plb.4
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 08:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aRPxq69b0s6YyE9IMOU3IkeEA2uT88gTKGFeUqIWHOA=;
        b=hKnZ51WpOT7N9HWyhzfsmfBFt7griLBhla/Hve+R+/CRnTx/dijzPDGkUYAys2gGfh
         JmEPzx6ha8wZABizGGK+9rzyvbYsmdFTExGi3GjjAgdA64YrcB1YYzJc0U1ceb/YaHze
         6p6X289FZPOR8CFBCHWJ6t4NzK8inlu89/hdposacb8109KFQetfi6sCeM0B2NA1Sf0+
         7ZXFY+RHl/RQ6oxowb/7MRhYFhH/KaPSBbsyWzNKxExKRh4pqURLfnWss5y8zuPqUand
         AGhj2hC4uNI2GWfJwwAYT0zqJ93fUxjnbCoaPxzKScyWa0Cn6sCPGWNS5kHFOncMQdQy
         HRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aRPxq69b0s6YyE9IMOU3IkeEA2uT88gTKGFeUqIWHOA=;
        b=HK1I6XmwjH6eEUTplwOqncRIkZ0hc9RiGkl8axI4Nv6D4Jqp8QwfWpxOBSBdRuZmaj
         7j9XO6NEH9XCs9BgEZNzRoK7hsZui1ESorjZX/EqO5Tg91g0NIcuI3DIt9+7xvasf5r2
         jWRaT7Nnl6YfowTzoBxzL3OoznmHT9ciFxxFMBhmEo24UgTV/l9Y0iQQorMYimP2+Yi7
         dDZfY/I2ljqwOrY4lJos/mjDwOaFBdE1EvSRmVCbZ6klma2k13S0qVW+g1ZO9L5d8KXs
         MUa7K9OF/vZd6akYkJp7GTR5w7cSc+hz9aJ4Y4cDcPY+kpkYqN+gTn/xZLKCfyc9qM2I
         K0og==
X-Gm-Message-State: AOAM531txWaelfYpajHCSe8mXDVTQaO5+3J+P2W7AGxcFq2DgRE8Xoc4
        96WS5It0ifLGXCHcAHRCgU+jrQ==
X-Google-Smtp-Source: ABdhPJwF6hUDXIQmKDxLBeDTgA7k9Uj/29oWIu8YvpRJocGJUGN2K+9kvYm5ryKo6b4PX4oaAuksaQ==
X-Received: by 2002:a17:902:7008:b029:dc:38b7:c592 with SMTP id y8-20020a1709027008b02900dc38b7c592mr45794216plk.9.1609344500708;
        Wed, 30 Dec 2020 08:08:20 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id q9sm46975364pgb.82.2020.12.30.08.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 08:08:15 -0800 (PST)
Date:   Wed, 30 Dec 2020 08:08:07 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, fenghua.yu@intel.com,
        tony.luck@intel.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, peterz@infradead.org, joro@8bytes.org,
        x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com, jmattson@google.com
Subject: Re: [PATCH v2 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
Message-ID: <X+yl57S8vuU2pRil@google.com>
References: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
 <160867631505.3471.3808049369257008114.stgit@bmoger-ubuntu>
 <20201230071501.GB22022@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230071501.GB22022@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 30, 2020, Borislav Petkov wrote:
> On Tue, Dec 22, 2020 at 04:31:55PM -0600, Babu Moger wrote:
> > @@ -2549,7 +2559,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
> >  			return 1;
> >  
> > -		msr_info->data = svm->spec_ctrl;
> > +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +			msr_info->data = svm->vmcb->save.spec_ctrl;
> > +		else
> > +			msr_info->data = svm->spec_ctrl;
> >  		break;
> >  	case MSR_AMD64_VIRT_SPEC_CTRL:
> >  		if (!msr_info->host_initiated &&
> > @@ -2640,6 +2653,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >  			return 1;
> >  
> >  		svm->spec_ctrl = data;
> > +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +			svm->vmcb->save.spec_ctrl = data;
> >  		if (!data)
> >  			break;
> >  
> 
> Are the get/set_msr() accessors such a fast path that they need
> static_cpu_has() ?

Nope, they can definitely use boot_cpu_has().
