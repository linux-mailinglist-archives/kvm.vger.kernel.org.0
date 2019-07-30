Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEA079E7C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 04:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfG3CM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 22:12:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34845 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbfG3CM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 22:12:57 -0400
Received: by mail-pf1-f195.google.com with SMTP id u14so28994562pfn.2
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 19:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QzmpkA05z0mtZkoyWxRVkvigio3In7Q7o/LhFUGd8xY=;
        b=YRhglCJymZrY8iT1doc6spl2hKA6RQCSyKJCsZsY4fz7WRawpiz2LbEZ5SauGDfBIa
         V+b3x6pSlWNKRxUOAXjTXWUGeYHhMePNWeXsilSXIX5V4IsKc5D69NE1AUoY/4CYLSZz
         jINP9al2YCJ8ArFLdeKC8h8o4eiEsobKj7lR0K8XXYyOBKuwVHIEqZwyMAd8Rk9buMvE
         NQefMfJYp3OwSJmFETnFviP9bsucePdZqbL14RA3MU7mvUHmhpBhFBI6lp50WbvfB7HM
         2sP8lM+ncf8+pmxbuuRLIVYj+/5Xnf9Jmqsn5ZXo5hC5BMroakhseu/yi9CA3/3LxeAM
         tdAQ==
X-Gm-Message-State: APjAAAUZ1mVXqoXnpervSRsXbBrtq9ggTmMcS6KmXuoVO4CEeGUfhMRu
        /PNsDk0qPWAeq4l/KYNdXMkS+g==
X-Google-Smtp-Source: APXvYqxqSPlxO76Ij2A1mHHbdVXJDnXXam4LtLjVK/hASFOyLe7TNpE4nQ1nPmvpEvJtjISmlOwYRw==
X-Received: by 2002:a62:ae02:: with SMTP id q2mr38616550pff.1.1564452776311;
        Mon, 29 Jul 2019 19:12:56 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o11sm103447207pfh.114.2019.07.29.19.12.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 19:12:55 -0700 (PDT)
Date:   Tue, 30 Jul 2019 10:12:45 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <zhexu@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190730021245.GE19232@xz-x1>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-4-peterx@redhat.com>
 <20190729162338.GE21120@linux.intel.com>
 <20190730014339.GC19232@xz-x1>
 <20190730020607.GJ21120@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190730020607.GJ21120@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 29, 2019 at 07:06:07PM -0700, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > index d98eac371c0a..cc1f98130e6a 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > @@ -5214,7 +5214,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
> > > >  	if (vmx->ple_window != old)
> > > >  		vmx->ple_window_dirty = true;
> > > >  
> > > > -	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
> > > > +	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);
> > > 
> > > No need for the macro, the snippet right about already checks 'new != old'.
> > > Though I do like the rename, i.e. rename the trace function to
> > > trace_kvm_ple_window_changed().
> > 
> > Do you mean this one?
> > 
> > 	if (vmx->ple_window != old)
> > 		vmx->ple_window_dirty = true;
> 
> Yep.
> 
> > It didn't return, did it? :)
> 
> You lost me.  What's wrong with:
> 
> 	if (vmx->ple_window != old) {
> 		vmx->ple_window_dirty = true;
> 		trace_kvm_ple_window_update(vcpu->vcpu_id, vmx_ple->window, old);
> 	}

Yes this looks fine to me.  I'll switch.

Regards,

-- 
Peter Xu
