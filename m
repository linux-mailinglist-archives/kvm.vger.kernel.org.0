Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9E979E06
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 03:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbfG3Bnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 21:43:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37974 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbfG3Bnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 21:43:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id f5so20338339pgu.5
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 18:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FXaTzP1hLwG47xm7qjiMP5lCkHTf2LC8myE+/2+tElk=;
        b=tKIb8codo02VsqhQ8ChPs6fVkC24IZ1RbevAov9Dity7IKuVxSYNJb9/BhmA+wW5lB
         f/TvfimyRY/33USVkHaTM4awHA/5aneHwWCveK5sjOtfSBTkv0LPRsOrj9DFCd3skpjF
         9MRV70vzYs/+s4tTAzNzNTICUKmNlNT7wkJy0KxB+DNsdeG2RUG8wiGm68gP+U3BbZRb
         GaiIDfST8gvlrfw8jlylFSnd7IlE70EyY506Gce64ZvepF0l3A+76vBtjSA5WOWho3cq
         O0Ioae1JU3NUAtKnIBTJxy1B4MCWzAI1aDTB+dOfFnnHe768j8iSgzKn6AiZJ+ceNDUi
         Id9Q==
X-Gm-Message-State: APjAAAWTb4EYFYXTzJ1rJN/Di9JT7GLfwpBZXASKX0vIWtwjYebAHZfa
        pI8F2dLAiYpdu5wvT9/mj/4i8g==
X-Google-Smtp-Source: APXvYqwB7F83JMtKyLlxCjCobao46wLZQz/mjPuLqDdF1mTAZJ3kgX7nSJ/B6XyMr5mVreA/n/TbHw==
X-Received: by 2002:a17:90a:8a17:: with SMTP id w23mr112087643pjn.139.1564451030613;
        Mon, 29 Jul 2019 18:43:50 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s67sm64453889pjb.8.2019.07.29.18.43.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 18:43:49 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Tue, 30 Jul 2019 09:43:39 +0800
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <zhexu@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190730014339.GC19232@xz-x1>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-4-peterx@redhat.com>
 <20190729162338.GE21120@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190729162338.GE21120@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 29, 2019 at 09:23:38AM -0700, Sean Christopherson wrote:
> On Mon, Jul 29, 2019 at 01:32:43PM +0800, Peter Xu wrote:
> > The PLE window tracepoint triggers easily and it can be a bit
> > confusing too.  One example line:
> > 
> >   kvm_ple_window: vcpu 0: ple_window 4096 (shrink 4096)
> > 
> > It easily let people think of "the window now is 4096 which is
> > shrinked", but the truth is the value actually didn't change (4096).
> > 
> > Let's only dump this message if the value really changed, and we make
> > the message even simpler like:
> > 
> >   kvm_ple_window: vcpu 4 (4096 -> 8192)
> 
> This seems a bit too terse, e.g. requires a decent amount of effort to
> do relatively simple things like show only cases where the windows was
> shrunk, or grew/shrunk by a large amount.  In this case, more is likely
> better, e.g.: 
> 
>   kvm_ple_window_changed: vcpu 4 ple_window 8192 old 4096 grow 4096
> 
> and
> 
>   kvm_ple_window_changed: vcpu 4 ple_window 4096 old 8192 shrink 4096

How about:

   kvm_ple_window: vcpu 4 (4096 -> 8192, growed)

Or:

   kvm_ple_window: vcpu 4 old 4096 new 8192 growed

I would prefer the arrow which is very clear to me to show a value
change, but I'd be fine to see what's your final preference or any
further reviewers.  Anyway I think any of them is clearer than the
original version...

> 
> 
> Tangentially related, it'd be nice to settle on a standard format for
> printing field+val.  Right now there are four different styles, e.g.
> "field=val", "field = val", "field: val" and "field val".

Right, I ses "field val" is used most frequently.  But I didn't touch
those up because they haven't yet caused any confusion to me.

[...]

> >  	TP_STRUCT__entry(
> > -		__field(                bool,      grow         )
> 
> Side note, if the tracepoint is invoked only on changes the "grow" field
> can be removed even if the tracepoint prints grow vs. shrink, i.e. there's
> no ambiguity since new==old will never happen.

But I do see it happen...  Please see below.

> 
> >  		__field(        unsigned int,   vcpu_id         )
> >  		__field(                 int,       new         )
> >  		__field(                 int,       old         )
> >  	),
> >  
> >  	TP_fast_assign(
> > -		__entry->grow           = grow;
> >  		__entry->vcpu_id        = vcpu_id;
> >  		__entry->new            = new;
> >  		__entry->old            = old;
> >  	),
> >  
> > -	TP_printk("vcpu %u: ple_window %d (%s %d)",
> > -	          __entry->vcpu_id,
> > -	          __entry->new,
> > -	          __entry->grow ? "grow" : "shrink",
> > -	          __entry->old)
> > +	TP_printk("vcpu %u (%d -> %d)",
> > +	          __entry->vcpu_id, __entry->old, __entry->new)
> >  );
> >  
> > -#define trace_kvm_ple_window_grow(vcpu_id, new, old) \
> > -	trace_kvm_ple_window(true, vcpu_id, new, old)
> > -#define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
> > -	trace_kvm_ple_window(false, vcpu_id, new, old)
> > +#define trace_kvm_ple_window_changed(vcpu, new, old)		\
> > +	do {							\
> > +		if (old != new)					\
> > +			trace_kvm_ple_window(vcpu, new, old);	\
> > +	} while (0)
> >  
> >  TRACE_EVENT(kvm_pvclock_update,
> >  	TP_PROTO(unsigned int vcpu_id, struct pvclock_vcpu_time_info *pvclock),
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index d98eac371c0a..cc1f98130e6a 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5214,7 +5214,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
> >  	if (vmx->ple_window != old)
> >  		vmx->ple_window_dirty = true;
> >  
> > -	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
> > +	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);
> 
> No need for the macro, the snippet right about already checks 'new != old'.
> Though I do like the rename, i.e. rename the trace function to
> trace_kvm_ple_window_changed().

Do you mean this one?

	if (vmx->ple_window != old)
		vmx->ple_window_dirty = true;

It didn't return, did it? :)

Thanks,

-- 
Peter Xu
