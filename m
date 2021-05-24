Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BBB38F2BE
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 20:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhEXSLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 14:11:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232789AbhEXSLR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 14:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621879788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iMjXbW9SM+WJ106CAXddqbI+c1ykzUuuZtqW2sf8qno=;
        b=R0bTGe0H4okAyfUSICLthxpOnJ7FmWu2IBV87qlKjQeOlcaqjNets5vGqS7SM3AIYNyv5C
        d1vl9X17f7ulP/Y68kwZDLpsGz2zSCw4A0kUnhmJ2Usa+GiiwU9vTp295XoT0oxQ+DJ6Rf
        cVHBP84YmPtLaTfnFI+NR/LZkIdTiag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97--I_ZvZtnPyeqK4wjpd9bag-1; Mon, 24 May 2021 14:09:46 -0400
X-MC-Unique: -I_ZvZtnPyeqK4wjpd9bag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E3B2801817;
        Mon, 24 May 2021 18:09:45 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F01525D71D;
        Mon, 24 May 2021 18:09:37 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id A33B74172EDB; Mon, 24 May 2021 14:53:29 -0300 (-03)
Date:   Mon, 24 May 2021 14:53:29 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>, Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210524175329.GA19468@fuller.cnet>
References: <20210510172646.930550753@redhat.com>
 <20210510172818.025080848@redhat.com>
 <e929da71-8f7d-52b2-2a71-30cb078535d3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e929da71-8f7d-52b2-2a71-30cb078535d3@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 05:55:18PM +0200, Paolo Bonzini wrote:
> On 10/05/21 19:26, Marcelo Tosatti wrote:
> > +void vmx_pi_start_assignment(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	int i;
> > +
> > +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> > +		return;
> > +
> > +	/*
> > +	 * Wakeup will cause the vCPU to bail out of kvm_vcpu_block() and
> > +	 * go back through vcpu_block().
> > +	 */
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		if (!kvm_vcpu_apicv_active(vcpu))
> > +			continue;
> > +
> > +		kvm_vcpu_wake_up(vcpu);
> 
> Would you still need the check_block callback, if you also added a
> kvm_make_request(KVM_REQ_EVENT)?
> 
> In fact, since this is entirely not a hot path, can you just do
> kvm_make_all_cpus_request(kvm, KVM_REQ_EVENT) instead of this loop?
> 
> Thanks,
> 
> Paolo

Hi Paolo,

Don't think so:

int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
{
        return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
}

static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
{
        int ret = -EINTR;
        int idx = srcu_read_lock(&vcpu->kvm->srcu);

        if (kvm_arch_vcpu_runnable(vcpu)) {
                kvm_make_request(KVM_REQ_UNHALT, vcpu);  <---- don't want KVM_REQ_UNHALT
                goto out;
        }
        if (kvm_cpu_has_pending_timer(vcpu))
                goto out;
        if (signal_pending(current))
                goto out;

        ret = 0;
out:
        srcu_read_unlock(&vcpu->kvm->srcu, idx);
        return ret;
}

See previous discussion:


Date: Wed, 12 May 2021 14:41:56 +0000                                                                                   
From: Sean Christopherson <seanjc@google.com>                                                                           
To: Marcelo Tosatti <mtosatti@redhat.com>                                                                               
Cc: Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, Alex Williamson             
        <alex.williamson@redhat.com>, Pei Zhang <pezhang@redhat.com>                                                    
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor when assigning device                        

On Tue, May 11, 2021, Marcelo Tosatti wrote:
> > The KVM_REQ_UNBLOCK patch will resume execution even any such event                                                 
>                                                                                                                       
>                                                 even without any such event                                           
>                                                                                                                       
> > occuring. So the behaviour would be different from baremetal.                                                       

I agree with Marcelo, we don't want to spuriously unhalt the vCPU.  It's legal,
albeit risky, to do something like

       	hlt
       	/* #UD to triple fault if this CPU is awakened. */
       	ud2

when offlining a CPU, in which case the spurious wake event will crash the guest.


