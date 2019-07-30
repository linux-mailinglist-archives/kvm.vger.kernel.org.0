Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A58279ECC
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 04:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbfG3CjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 22:39:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40950 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731194AbfG3CjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 22:39:16 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so28205724pla.7
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 19:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wReqp9T1oK4mr56/nSrpCrYWEbXPuHu8s1BizlxDEM0=;
        b=m1OLVmoaFZ6CcOMDxf7bpEkIlbpHV9N9ice0fxVP4C8kYo7Y/8v6ai629o3PG2Bg4V
         tMzgIl3teD0ZMxJz9+5DsL4L3uIhkgNcL4txGgsbO/USc0EPRcZJcFDMpHA4lWmnWTtX
         5LoLfMvjB7mQRCK5vPGbn569yBHKWBN2GhREV0/9kvEmDlW0uuIXaiG/x+EIKQQ7/Y2D
         LuLbgb3baKDW6EtcYqiwYz8VwkVKP4/kFvF/WZU4HjByeMaA2B9/Poh+RA4wh6rgCkJw
         +WBdckobwUO+AsY0UrvQJAZKuyxwAp3/yIKHxs3ZiAhIA6pfogS7sBPwdNUqxIS65URS
         FISg==
X-Gm-Message-State: APjAAAW0P6alaaJ0xSmT8huMXqtzW8PQ3m8SMU+/itDrXeUgQGw0Q3KO
        Xzl2IPBiEqPYFAu0lSX7AuUvkQ==
X-Google-Smtp-Source: APXvYqwLlzYb8D3lTDDHrJKLH1FSGOX8kPg0ujnjWwKZ47ZBz/lWBL1a968q2rx0cjAuhaoeRtvzFQ==
X-Received: by 2002:a17:902:820c:: with SMTP id x12mr114196640pln.216.1564454355767;
        Mon, 29 Jul 2019 19:39:15 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 65sm65891354pgf.30.2019.07.29.19.39.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 19:39:14 -0700 (PDT)
Date:   Tue, 30 Jul 2019 10:39:04 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <zhexu@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190730023904.GG19232@xz-x1>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-4-peterx@redhat.com>
 <20190729162338.GE21120@linux.intel.com>
 <20190730014339.GC19232@xz-x1>
 <20190730020607.GJ21120@linux.intel.com>
 <20190730021245.GE19232@xz-x1>
 <20190730022525.GF19232@xz-x1>
 <20190730022844.GK21120@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190730022844.GK21120@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 29, 2019 at 07:28:44PM -0700, Sean Christopherson wrote:
> On Tue, Jul 30, 2019 at 10:25:25AM +0800, Peter Xu wrote:
> > On Tue, Jul 30, 2019 at 10:12:45AM +0800, Peter Xu wrote:
> > > On Mon, Jul 29, 2019 at 07:06:07PM -0700, Sean Christopherson wrote:
> > > > > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > > > > index d98eac371c0a..cc1f98130e6a 100644
> > > > > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > > > > @@ -5214,7 +5214,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
> > > > > > >  	if (vmx->ple_window != old)
> > > > > > >  		vmx->ple_window_dirty = true;
> > > > > > >  
> > > > > > > -	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
> > > > > > > +	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);
> > > > > > 
> > > > > > No need for the macro, the snippet right about already checks 'new != old'.
> > > > > > Though I do like the rename, i.e. rename the trace function to
> > > > > > trace_kvm_ple_window_changed().
> > > > > 
> > > > > Do you mean this one?
> > > > > 
> > > > > 	if (vmx->ple_window != old)
> > > > > 		vmx->ple_window_dirty = true;
> > > > 
> > > > Yep.
> > > > 
> > > > > It didn't return, did it? :)
> > > > 
> > > > You lost me.  What's wrong with:
> > > > 
> > > > 	if (vmx->ple_window != old) {
> > > > 		vmx->ple_window_dirty = true;
> > > > 		trace_kvm_ple_window_update(vcpu->vcpu_id, vmx_ple->window, old);
> > > > 	}
> > > 
> > > Yes this looks fine to me.  I'll switch.
> > 
> > Btw, I noticed we have this:
> > 
> >   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
> > 
> > Is that trying to expose the tracepoints to the outter world?  Is that
> > whole chunk of EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_*) really needed?
> 
> It's needed to invoke tracepoints from VMX/SVM as the implementations live
> in kvm.ko.  Same reason functions in x86.c and company need to be exported
> if they're called by VMX/SVM code.

Ah right.  Then I assume it's pretty safe to change the symbol name here.

Thanks!

-- 
Peter Xu
