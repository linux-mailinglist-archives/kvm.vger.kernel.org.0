Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB753909A0
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 21:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhEYT20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 15:28:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58117 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231843AbhEYT2Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 15:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621970814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3bNCLO/OrXJC5iKea7Zd/v1Vdsjb5Mad2I2/dfdLnew=;
        b=SBfbe3KSI4/AH4e8oEzu66HToOpz2uWwCCI9qgypdIcPq2G+5ROIPeFIbqgyFlSHqrIBOj
        Of8GKDXLdBCaWI9oPUkQk0jNhbtLLfMuSNO8W6XePy9FXDQmAOIBnMEPz6OA+E4KQ8DR18
        HorD2Y94CErqiGuAM5LMV0d9HSe6BXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-M-tzl1VEOyC01ar6B1_1rQ-1; Tue, 25 May 2021 15:26:53 -0400
X-MC-Unique: M-tzl1VEOyC01ar6B1_1rQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47B6E107ACE3;
        Tue, 25 May 2021 19:26:52 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DED9A1001B2C;
        Tue, 25 May 2021 19:26:42 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id B0E764172ED4; Tue, 25 May 2021 16:26:37 -0300 (-03)
Date:   Tue, 25 May 2021 16:26:37 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 2/3] KVM: rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK
Message-ID: <20210525192637.GC365242@fuller.cnet>
References: <20210525134115.135966361@redhat.com>
 <20210525134321.303768132@redhat.com>
 <YK1MmcHqJGCR631n@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK1MmcHqJGCR631n@t490s>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 03:14:33PM -0400, Peter Xu wrote:
> On Tue, May 25, 2021 at 10:41:17AM -0300, Marcelo Tosatti wrote:
> > KVM_REQ_UNBLOCK will be used to exit a vcpu from
> > its inner vcpu halt emulation loop.
> > 
> > Rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK, switch
> > PowerPC to arch specific request bit.
> > 
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > 
> > Index: kvm/include/linux/kvm_host.h
> > ===================================================================
> > --- kvm.orig/include/linux/kvm_host.h
> > +++ kvm/include/linux/kvm_host.h
> > @@ -146,7 +146,7 @@ static inline bool is_error_page(struct
> >   */
> >  #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > -#define KVM_REQ_PENDING_TIMER     2
> > +#define KVM_REQ_UNBLOCK           2
> >  #define KVM_REQ_UNHALT            3
> >  #define KVM_REQUEST_ARCH_BASE     8
> >  
> > Index: kvm/virt/kvm/kvm_main.c
> > ===================================================================
> > --- kvm.orig/virt/kvm/kvm_main.c
> > +++ kvm/virt/kvm/kvm_main.c
> > @@ -2794,6 +2794,8 @@ static int kvm_vcpu_check_block(struct k
> >  		goto out;
> >  	if (signal_pending(current))
> >  		goto out;
> > +	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
> > +		goto out;
> >  
> >  	ret = 0;
> >  out:
> > Index: kvm/Documentation/virt/kvm/vcpu-requests.rst
> > ===================================================================
> > --- kvm.orig/Documentation/virt/kvm/vcpu-requests.rst
> > +++ kvm/Documentation/virt/kvm/vcpu-requests.rst
> > @@ -118,10 +118,11 @@ KVM_REQ_MMU_RELOAD
> >    necessary to inform each VCPU to completely refresh the tables.  This
> >    request is used for that.
> >  
> > -KVM_REQ_PENDING_TIMER
> > +KVM_REQ_UNBLOCK
> >  
> >    This request may be made from a timer handler run on the host on behalf
> > -  of a VCPU.  It informs the VCPU thread to inject a timer interrupt.
> > +  of a VCPU, or when device assignment is performed. It informs the VCPU to
> > +  exit the vcpu halt inner loop.
> >  
> >  KVM_REQ_UNHALT
> >  
> > Index: kvm/arch/powerpc/include/asm/kvm_host.h
> > ===================================================================
> > --- kvm.orig/arch/powerpc/include/asm/kvm_host.h
> > +++ kvm/arch/powerpc/include/asm/kvm_host.h
> > @@ -51,6 +51,7 @@
> >  /* PPC-specific vcpu->requests bit members */
> >  #define KVM_REQ_WATCHDOG	KVM_ARCH_REQ(0)
> >  #define KVM_REQ_EPR_EXIT	KVM_ARCH_REQ(1)
> > +#define KVM_REQ_PENDING_TIMER	KVM_ARCH_REQ(2)
> >  
> >  #include <linux/mmu_notifier.h>
> >  
> > Index: kvm/arch/x86/kvm/lapic.c
> > ===================================================================
> > --- kvm.orig/arch/x86/kvm/lapic.c
> > +++ kvm/arch/x86/kvm/lapic.c
> > @@ -1657,7 +1657,7 @@ static void apic_timer_expired(struct kv
> >  	}
> >  
> >  	atomic_inc(&apic->lapic_timer.pending);
> > -	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
> > +	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> >  	if (from_timer_fn)
> >  		kvm_vcpu_kick(vcpu);
> >  }
> 
> Pure question on the existing code: why do we need kvm_make_request() for
> timer?  As I see kvm_vcpu_check_block() already checks explicitly for timers:
> 
> static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> {
>         ...
> 	if (kvm_cpu_has_pending_timer(vcpu))
> 		goto out;
>         ...
> }
> 
> for x86:
> 
> int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> {
> 	if (lapic_in_kernel(vcpu))
> 		return apic_has_pending_timer(vcpu);
> 
> 	return 0;
> }
> 
> So wondering why we can drop the two references to KVM_REQ_PENDING_TIMER in x86
> directly..

See commit 06e05645661211b9eaadaf6344c335d2e80f0ba2

