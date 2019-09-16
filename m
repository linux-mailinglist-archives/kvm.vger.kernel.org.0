Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60A6B42E0
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 23:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388001AbfIPVTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 17:19:13 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45197 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387869AbfIPVTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 17:19:13 -0400
Received: by mail-pl1-f195.google.com with SMTP id x3so445417plr.12
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 14:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NTduAprQpf5BXIgR32H4KO/vbajnVfJjK6aJJRIlN0w=;
        b=iyPY2Ly1eK2T24BnIP1wlwM6NBvQ4F/DRKK7sDnD1OdFualxmn9Y6f5NvB6hRxsIfY
         pqjoYo35pXwLMEzw+rDxoztmfaczxTOLUnU5qr40SzzX+f2h3UGBLplCy+XlLmZOJ+jC
         reohdtal9260EwNsLtaHTk6Z2jkUbPrkmxPxd85+GPdwt+4FqPgsPNsUD2W9m52Ul5pl
         9bIBQVv01ebfXbZThj1m6ICXi9QT0lTum/AWMB3PQc4PA3inh9OsuwXtVWHW8EMg9pFn
         dFcwp84m9PNwYMHbZyhfhnl2WJkOp2Hp/qyYgsSxIjza3miAZDeFYK+pxuvidK1HTutn
         15KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NTduAprQpf5BXIgR32H4KO/vbajnVfJjK6aJJRIlN0w=;
        b=ZFCb/8pHA3TJGucdeq+6w0O+mVllBCjZuHdtxCoR9sqy/A0L5x8J/2hs0WPIHsgO5a
         MlROVpQdUYbxxPHOwkqzycOxRqwk+ors2VEzRoA5yrGgdx51X6YedoNhCM7UIqk1mX7g
         ZcA1yl1A596CMhdKdb8PtlIP6GcJ0F5AXQ8sMk8SJcULJbzpVJOdamlZlT1CsrxF4Fd9
         fnn0GpW07K3jpV0LudPXIitzpLnsavxP5ESdoW011dT9AwWwEf9nuJjDYPzwaC3uu6UY
         +Msq4DUrAYDw4tAzN1qxyhjzvnYK28TKO7yxlFfL1Q5eiD414mhyjH9i0bRiWU27G+En
         cl6Q==
X-Gm-Message-State: APjAAAWBLfDzl/xZ7PnGx2x21oW6Dm2teOeewlmcwQdQAs7UieiQXEa1
        oF5atQBfVQSwrJV0sJIdS3ntxQ==
X-Google-Smtp-Source: APXvYqz9okX614M5//F969Ugh3JuP1pBtvDHPEEzjXYH4z4nxY8Ps/UcwYY7RuSNqjpKk2odEp//Ag==
X-Received: by 2002:a17:902:23:: with SMTP id 32mr172110pla.214.1568668752188;
        Mon, 16 Sep 2019 14:19:12 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id m9sm86056pjf.11.2019.09.16.14.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 14:19:11 -0700 (PDT)
Date:   Mon, 16 Sep 2019 14:19:08 -0700
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v4 4/9] KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on
 VM-Entry
Message-ID: <20190916211908.GB221782@google.com>
References: <20190906210313.128316-1-oupton@google.com>
 <20190906210313.128316-5-oupton@google.com>
 <20190916181003.GG18871@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916181003.GG18871@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 16, 2019 at 11:10:03AM -0700, Sean Christopherson wrote:
> On Fri, Sep 06, 2019 at 02:03:08PM -0700, Oliver Upton wrote:
> > Add condition to nested_vmx_check_guest_state() to check the validity of
> > GUEST_IA32_PERF_GLOBAL_CTRL. Per Intel's SDM Vol 3 26.3.1.1:
> > 
> >   If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, bits
> >   reserved in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that
> >   register.
> > 
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 9ba90b38d74b..6c3aa3bcede3 100644
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
> > @@ -2732,6 +2733,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
> >  					u32 *exit_qual)
> >  {
> >  	bool ia32e;
> > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> 
> Nit: I wouldn't bother with a local variable, just call vcpu_to_pmu() when
> invoking kvm_is_valid_perf_global_ctrl(), especially since you need a line
> break anyways.

Ack to both (here and on 5/9).

> >  
> >  	*exit_qual = ENTRY_FAIL_DEFAULT;
> >  
> > @@ -2748,6 +2750,11 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
> >  		return -EINVAL;
> >  	}
> >  
> > +	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL &&
> > +	    !kvm_is_valid_perf_global_ctrl(pmu,
> > +					   vmcs12->guest_ia32_perf_global_ctrl))
> > +		return -EINVAL;
> > +
> >  	/*
> >  	 * If the load IA32_EFER VM-entry control is 1, the following checks
> >  	 * are performed on the field for the IA32_EFER MSR:
> > -- 
> > 2.23.0.187.g17f5b7556c-goog
> > 
