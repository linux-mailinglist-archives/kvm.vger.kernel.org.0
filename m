Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3129679EA6
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 04:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbfG3CZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 22:25:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43005 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbfG3CZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 22:25:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id t132so29195485pgb.9
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 19:25:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GQ2MaKG+pGsOwrRXZ0T9gmFFyRpPl5Kuc0r3YWPsfk4=;
        b=KjVpk2Kc6zxIZnRlUfNI7mtp1MQfeyJzmTh0iPY9/J7h/M97SAJIn5jM8aRkku//QC
         3AiF35jj1SRWAkSq4MR6Hj1jDwqTg/u8WzfmRvc6Xd4O3DMBdTMAKhedH123UyaVCGRA
         XmlRp5eK5P8HJ1bjIQ/o6NPgzt3ZB14NqXbXuWusIKx7QiIRviaLy4vty8/9jdZdGBCG
         zrsywecK82gColTAqpKKQsmd60XvntNxPMjabSaeBWXizL88FNdyyRgTA29vGAhSrQt/
         UBoP4RzaNFhxwjJonMFqELdYf0jgfpjd4ugnQa65wapaI0SA3FqTuip1ksmXAXSRF2zU
         8HaQ==
X-Gm-Message-State: APjAAAWTdmEMgYgrsI2BAhB8gSPLHIfsOBzEBOSBphgwBXE95afbmsfi
        k6QKZkcQVnFEige+zxRSt118BzpyrPE=
X-Google-Smtp-Source: APXvYqxcrdZzmGIBJF2x9+2IC/75BBOYEBkllfgr9TFSQaQpnq1BaPykEjjiyYyviwF0NL3U+t4vnA==
X-Received: by 2002:a63:5550:: with SMTP id f16mr90856568pgm.426.1564453536235;
        Mon, 29 Jul 2019 19:25:36 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f3sm98592582pfg.165.2019.07.29.19.25.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 19:25:35 -0700 (PDT)
Date:   Tue, 30 Jul 2019 10:25:25 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <zhexu@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190730022525.GF19232@xz-x1>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-4-peterx@redhat.com>
 <20190729162338.GE21120@linux.intel.com>
 <20190730014339.GC19232@xz-x1>
 <20190730020607.GJ21120@linux.intel.com>
 <20190730021245.GE19232@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190730021245.GE19232@xz-x1>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 30, 2019 at 10:12:45AM +0800, Peter Xu wrote:
> On Mon, Jul 29, 2019 at 07:06:07PM -0700, Sean Christopherson wrote:
> > > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > > index d98eac371c0a..cc1f98130e6a 100644
> > > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > > @@ -5214,7 +5214,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
> > > > >  	if (vmx->ple_window != old)
> > > > >  		vmx->ple_window_dirty = true;
> > > > >  
> > > > > -	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
> > > > > +	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);
> > > > 
> > > > No need for the macro, the snippet right about already checks 'new != old'.
> > > > Though I do like the rename, i.e. rename the trace function to
> > > > trace_kvm_ple_window_changed().
> > > 
> > > Do you mean this one?
> > > 
> > > 	if (vmx->ple_window != old)
> > > 		vmx->ple_window_dirty = true;
> > 
> > Yep.
> > 
> > > It didn't return, did it? :)
> > 
> > You lost me.  What's wrong with:
> > 
> > 	if (vmx->ple_window != old) {
> > 		vmx->ple_window_dirty = true;
> > 		trace_kvm_ple_window_update(vcpu->vcpu_id, vmx_ple->window, old);
> > 	}
> 
> Yes this looks fine to me.  I'll switch.

Btw, I noticed we have this:

  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);

Is that trying to expose the tracepoints to the outter world?  Is that
whole chunk of EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_*) really needed?

Regards,

-- 
Peter Xu
