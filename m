Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086E8A9852
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 04:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfIECZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 22:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbfIECZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 22:25:42 -0400
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 48A4519CF89
        for <kvm@vger.kernel.org>; Thu,  5 Sep 2019 02:25:42 +0000 (UTC)
Received: by mail-pf1-f197.google.com with SMTP id b204so677955pfb.11
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 19:25:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vtvo/zeS44XluKA6UrZH1GDURsTqvZOY2i7CAT/mFAA=;
        b=M7LnaEhArjYc1X06SeZvIAD6uOFYNph88VZJPpGih01LGvF1iwE1RlPIcuiakg2WF/
         xuqlMNLUOh/+wUYAU8jYRRTBbIhpLIti+vvRLKCdEXLsFeUD9ScjCvvtACO6nYr/x5nL
         dYPPlrf7NnNEHQOHiuTRmPgRAHCDHAuf5shLkWmKZF1b4h0Mi2E96NySTnluSz0ooSk1
         5qraH8GyPCElXUnxiVYtoH1D+pZvHR2QcQQtR49G3wb5CBoZ08Kra670XzSKgadoaYhs
         Y19chCI90ByBNdtzHKlTXYAkuNdwcX9PmfvwQyx3bQlqQYNFtJXbmRrta5bTClR14gB0
         ac1Q==
X-Gm-Message-State: APjAAAURzC4GNEKej1oTgAuXGngbwLRz1nUNpfkB934yhR9PmxdxlE93
        a6W/W7q5ZkqBOQPT9xaaA38yIpxpLSL+QjvthVBOFsUmXmjE4xZUOrjsc7AkrmUv6XxdW1M+SQN
        fcHNvlauz1pkz
X-Received: by 2002:a63:460c:: with SMTP id t12mr1005946pga.69.1567650341745;
        Wed, 04 Sep 2019 19:25:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8oF1G7awMLXh4TzNS/cU/1V6EzGkRmuf0tlRNLypxOEGgHRKOah4LkWJ577VOa4hXWDEClg==
X-Received: by 2002:a63:460c:: with SMTP id t12mr1005935pga.69.1567650341496;
        Wed, 04 Sep 2019 19:25:41 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f128sm452756pfg.143.2019.09.04.19.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 19:25:40 -0700 (PDT)
Date:   Thu, 5 Sep 2019 10:25:31 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v2 3/3] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190905022531.GE31707@xz-x1>
References: <20190815103458.23207-1-peterx@redhat.com>
 <20190815103458.23207-4-peterx@redhat.com>
 <20190904173254.GJ24079@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190904173254.GJ24079@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 04, 2019 at 10:32:54AM -0700, Sean Christopherson wrote:
> On Thu, Aug 15, 2019 at 06:34:58PM +0800, Peter Xu wrote:
> > The PLE window tracepoint triggers even if the window is not changed,
> > and the wording can be a bit confusing too.  One example line:
> > 
> >   kvm_ple_window: vcpu 0: ple_window 4096 (shrink 4096)
> > 
> > It easily let people think of "the window now is 4096 which is
> > shrinked", but the truth is the value actually didn't change (4096).
> > 
> > Let's only dump this message if the value really changed, and we make
> > the message even simpler like:
> > 
> >   kvm_ple_window: vcpu 4 old 4096 new 8192 (growed)
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  arch/x86/kvm/svm.c     | 16 ++++++++--------
> >  arch/x86/kvm/trace.h   | 21 ++++++---------------
> >  arch/x86/kvm/vmx/vmx.c | 14 ++++++++------
> >  arch/x86/kvm/x86.c     |  2 +-
> >  4 files changed, 23 insertions(+), 30 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index d685491fce4d..d5cb6b5a9254 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -1269,11 +1269,11 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
> >  							pause_filter_count_grow,
> >  							pause_filter_count_max);
> >  
> > -	if (control->pause_filter_count != old)
> > +	if (control->pause_filter_count != old) {
> >  		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> > -
> > -	trace_kvm_ple_window_grow(vcpu->vcpu_id,
> > -				  control->pause_filter_count, old);
> > +		trace_kvm_ple_window_update(vcpu->vcpu_id,
> > +					    control->pause_filter_count, old);
> > +	}
> >  }
> >  
> >  static void shrink_ple_window(struct kvm_vcpu *vcpu)
> > @@ -1287,11 +1287,11 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
> >  						    pause_filter_count,
> >  						    pause_filter_count_shrink,
> >  						    pause_filter_count);
> > -	if (control->pause_filter_count != old)
> > +	if (control->pause_filter_count != old) {
> >  		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> > -
> > -	trace_kvm_ple_window_shrink(vcpu->vcpu_id,
> > -				    control->pause_filter_count, old);
> > +		trace_kvm_ple_window_update(vcpu->vcpu_id,
> > +					    control->pause_filter_count, old);
> > +	}
> >  }
> >  
> >  static __init int svm_hardware_setup(void)
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index 76a39bc25b95..97df9d7cae71 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -890,36 +890,27 @@ TRACE_EVENT(kvm_pml_full,
> >  	TP_printk("vcpu %d: PML full", __entry->vcpu_id)
> >  );
> >  
> > -TRACE_EVENT(kvm_ple_window,
> > -	TP_PROTO(bool grow, unsigned int vcpu_id, int new, int old),
> > -	TP_ARGS(grow, vcpu_id, new, old),
> > +TRACE_EVENT(kvm_ple_window_update,
> > +	TP_PROTO(unsigned int vcpu_id, int new, int old),
> > +	TP_ARGS(vcpu_id, new, old),
> >  
> >  	TP_STRUCT__entry(
> > -		__field(                bool,      grow         )
> >  		__field(        unsigned int,   vcpu_id         )
> >  		__field(                 int,       new         )
> >  		__field(                 int,       old         )
> 
> Not your code, but these should really be 'unsigned int', especially now
> that they are directly compared when printing "growed" versus "shrinked".
> For SVM it doesn't matter since the underlying hardware fields are only
> 16 bits, but on VMX they're 32 bits, e.g. theoretically userspace could
> set ple_window and ple_window_max to a negative value.
> 
> The ple_window variable in struct vcpu_vmx and local snapshots of the
> field should also be updated, but that can be done separately.

Indeed.  Let me add a separated patch.  Thanks,

-- 
Peter Xu
