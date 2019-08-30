Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75C5A3ED3
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 22:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfH3UMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 16:12:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38439 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfH3UMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 16:12:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id o70so5321082pfg.5
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 13:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yYjMuXEpZz6xL6pY0Th+uD0kINa0w620n4uJl1zNDHE=;
        b=JdwT4YiS/sNa/0vjLxT2HzPI8B50kQY9SxvDcTZF3qk7BISxIKMPZSA8KjBI1k5Sv2
         E5sfry2738oZTW14aDSnksfHhfhYUxIgk/HjkyL57XtY1ZtwI3IncS0R/DIbeahqu2Nu
         7IDyX+j981g/TR58cO96hXu+wokP3vDEsYCO2mOZnjF8DoElAGbN5cM/DJcO7oeLzANk
         SBQgy5NDbUb2uMKzupYWHc/62Yh4uYl8VieF/tsJ0ZsUAAOMKBuM/vnREF4XemP0fCml
         EacHlZIu6wbYpu55usmPHXVzYs/WJmFDATs3LhZ/kD3KAOQIjx21sIln6jlq1u5WVTOG
         CgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yYjMuXEpZz6xL6pY0Th+uD0kINa0w620n4uJl1zNDHE=;
        b=CB+dxlG9dS9nYBePlQU1881AVG0JI/D8eq2ZR9LVeBx+HEG3maJB+rJgWOURp3fcdb
         sLuIrGRzqGP8fBAxbgvwCIYT/cu1pWWunjUx1prMMgODtxXn1A0L68/q4DVxTJwCnZqt
         58kj1MJWtWy5hvGBo+le5bl7Q+uriIP+Fp2GZs+gnkHZBTvonOsT8yfh6WMSrrNA1mih
         btrtortgPks1smFGHJw+x3gV8b2yhFuCcVUsZRtMkmUpHyMP8Ki9XToUCwZdDwEvfwHc
         GUYn3dA7O7SV0b9eu9tE/p+mGRQgyUqJOCt6fbkFC5bKdR/byeB1L1K9iv3I4dYau66n
         2L5g==
X-Gm-Message-State: APjAAAUt7jkOJHToRONmiUdD4mnT99K+2g51E5JHi8kMIaAQA6/wvts4
        ouB4flCjr5y/ZTmstJiIUkrVhDhXrWkzBg==
X-Google-Smtp-Source: APXvYqwU0ZbuaUTZuwSb+43YEjTDXQFWgc5IFMn7IihJ3X+cGREQDJXA2LD0x/SY7YEJ8LhN7+8mpQ==
X-Received: by 2002:a63:7c0d:: with SMTP id x13mr14259531pgc.360.1567195963966;
        Fri, 30 Aug 2019 13:12:43 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id e66sm16559701pfe.142.2019.08.30.13.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 13:12:43 -0700 (PDT)
Date:   Fri, 30 Aug 2019 13:12:39 -0700
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 4/7] KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on
 VM-Entry
Message-ID: <20190830201239.GC257167@google.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-5-oupton@google.com>
 <20190830183703.GG15405@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830183703.GG15405@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 11:37:03AM -0700, Sean Christopherson wrote:
> On Wed, Aug 28, 2019 at 04:41:31PM -0700, Oliver Upton wrote:
> > According to the SDM 26.3.1.1, "If the "load IA32_PERF_GLOBAL_CTRL" VM-entry
> > control is 1, bits reserved in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
> > field for that register".
> > 
> > Adding condition to nested_vmx_check_guest_state() to check the validity of
> > GUEST_IA32_PERF_GLOBAL_CTRL if the "load IA32_PERF_GLOBAL_CTRL" bit is
> > set on the VM-entry control.
> 
> Same comment on mood.  And for this case, it's probably overkill to
> give a play-by-play of the code, just state that you're adding a check
> as described in the SDM, e.g.:
> 
> Add a nested VM-Enter consistency check when loading the guest's
> IA32_PERF_GLOBAL_CTRL MSR from vmcs12.  Per Intel's SDM:
> 
>   If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, bits
>   reserved in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for
>   that register.

Ack. This is a style problem throughout, I will make sure to address in
the next set I send out. Thanks for the suggested text as well, reads a
lot better than what I had before!
> > 
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 9ba90b38d74b..8d6f0144b1bd 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -10,6 +10,7 @@
> >  #include "hyperv.h"
> >  #include "mmu.h"
> >  #include "nested.h"
> > +#include "pmu.h"
> >  #include "trace.h"
> >  #include "x86.h"
> >  
> > @@ -2748,6 +2749,11 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
> >  		return -EINVAL;
> >  	}
> >  
> > +	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL &&
> > +	    !kvm_is_valid_perf_global_ctrl(vcpu,
> > +					   vmcs12->guest_ia32_perf_global_ctrl))
> > +		return -EINVAL;
> > +
> >  	/*
> >  	 * If the load IA32_EFER VM-entry control is 1, the following checks
> >  	 * are performed on the field for the IA32_EFER MSR:
> > -- 
> > 2.23.0.187.g17f5b7556c-goog
> > 
