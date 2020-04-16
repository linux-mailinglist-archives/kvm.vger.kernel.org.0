Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043791AB836
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 08:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408424AbgDPGjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 02:39:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60726 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408413AbgDPGjI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 02:39:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587019146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RTmAQ268tugfVTRXJKw1CU2xHVuS6n2tvRxMg9gDw58=;
        b=eoOpIMHGRrxmtsZftgoaF7drxlBJctG6gW1NE0runh+QV4KFvLYHj2CE/n3JNQN0meoI+W
        knTbayJRaYuj1bKa6UG3aVZjktK/d0NOtNSaKhIMiA5fq6tpGq3HTFrhMy4os+6es3WeNS
        iS3aQ/r2louINtvBybEFrRQ1mX2WVVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-30UXiYtANCScSqAVZLBLNA-1; Thu, 16 Apr 2020 02:39:04 -0400
X-MC-Unique: 30UXiYtANCScSqAVZLBLNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A15B1005510;
        Thu, 16 Apr 2020 06:39:03 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40B722718D;
        Thu, 16 Apr 2020 06:38:58 +0000 (UTC)
Date:   Thu, 16 Apr 2020 08:38:55 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] KVM: s390: Fix PV check in deliverable_irqs()
Message-ID: <20200416083855.22892f3b.cohuck@redhat.com>
In-Reply-To: <e8720727-ceee-e668-2a52-54b2b5039087@de.ibm.com>
References: <20200415190353.63625-1-farman@linux.ibm.com>
        <e8720727-ceee-e668-2a52-54b2b5039087@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Apr 2020 08:17:21 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 15.04.20 21:03, Eric Farman wrote:
> > The diag 0x44 handler, which handles a directed yield, goes into a
> > a codepath that does a kvm_for_each_vcpu() and ultimately
> > deliverable_irqs().  The new check for kvm_s390_pv_cpu_is_protected()
> > contains an assertion that the vcpu->mutex is held, which isn't going
> > to be the case in this scenario.
> > 
> > The result is a plethora of these messages if the lock debugging
> > is enabled, and thus an implication that we have a problem.
> > 
> >   WARNING: CPU: 9 PID: 16167 at arch/s390/kvm/kvm-s390.h:239 deliverable_irqs+0x1c6/0x1d0 [kvm]
> >   ...snip...
> >   Call Trace:
> >    [<000003ff80429bf2>] deliverable_irqs+0x1ca/0x1d0 [kvm]
> >   ([<000003ff80429b34>] deliverable_irqs+0x10c/0x1d0 [kvm])
> >    [<000003ff8042ba82>] kvm_s390_vcpu_has_irq+0x2a/0xa8 [kvm]
> >    [<000003ff804101e2>] kvm_arch_dy_runnable+0x22/0x38 [kvm]
> >    [<000003ff80410284>] kvm_vcpu_on_spin+0x8c/0x1d0 [kvm]
> >    [<000003ff80436888>] kvm_s390_handle_diag+0x3b0/0x768 [kvm]
> >    [<000003ff80425af4>] kvm_handle_sie_intercept+0x1cc/0xcd0 [kvm]
> >    [<000003ff80422bb0>] __vcpu_run+0x7b8/0xfd0 [kvm]
> >    [<000003ff80423de6>] kvm_arch_vcpu_ioctl_run+0xee/0x3e0 [kvm]
> >    [<000003ff8040ccd8>] kvm_vcpu_ioctl+0x2c8/0x8d0 [kvm]
> >    [<00000001504ced06>] ksys_ioctl+0xae/0xe8
> >    [<00000001504cedaa>] __s390x_sys_ioctl+0x2a/0x38
> >    [<0000000150cb9034>] system_call+0xd8/0x2d8
> >   2 locks held by CPU 2/KVM/16167:
> >    #0: 00000001951980c0 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x90/0x8d0 [kvm]
> >    #1: 000000019599c0f0 (&kvm->srcu){....}, at: __vcpu_run+0x4bc/0xfd0 [kvm]
> >   Last Breaking-Event-Address:
> >    [<000003ff80429b34>] deliverable_irqs+0x10c/0x1d0 [kvm]
> >   irq event stamp: 11967
> >   hardirqs last  enabled at (11975): [<00000001502992f2>] console_unlock+0x4ca/0x650
> >   hardirqs last disabled at (11982): [<0000000150298ee8>] console_unlock+0xc0/0x650
> >   softirqs last  enabled at (7940): [<0000000150cba6ca>] __do_softirq+0x422/0x4d8
> >   softirqs last disabled at (7929): [<00000001501cd688>] do_softirq_own_stack+0x70/0x80
> > 
> > Considering what's being done here, let's fix this by removing the
> > mutex assertion rather than acquiring the mutex for every other vcpu.
> > 
> > Fixes: 201ae986ead7 ("KVM: s390: protvirt: Implement interrupt injection")  
> 
> Yes, when adding that check I missed that path. We do have other places that use
> kvm_s390_pv_cpu_get_handle instead of kvm_s390_pv_cpu_is_protected when we know
> that this place has cases without the mutex being hold. And yes kvm_vcpu_on_spin
> is such a place. 
> 
> The alternative would be to copy kvm_s390_vcpu_has_irq into a newly create
> s390 version of kvm_arch_dy_runnable with a private copy of kvm_s390_vcpu_has_irq.
> I think your patch is preferrable as it avoids code duplication with just tiny 
> difference. After all it is just a sanity check.

I agree, calling kvm_s390_pv_cpu_get_handle() in that code path without
the mutex is fine, and I don't think we would benefit a lot from
keeping the check in the general case and using a special case for the
directed yield check.

> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

> 
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >  arch/s390/kvm/interrupt.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> > index 8191106bf7b9..bfb481134994 100644
> > --- a/arch/s390/kvm/interrupt.c
> > +++ b/arch/s390/kvm/interrupt.c
> > @@ -393,7 +393,7 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
> >  	if (psw_mchk_disabled(vcpu))
> >  		active_mask &= ~IRQ_PEND_MCHK_MASK;
> >  	/* PV guest cpus can have a single interruption injected at a time. */
> > -	if (kvm_s390_pv_cpu_is_protected(vcpu) &&
> > +	if (kvm_s390_pv_cpu_get_handle(vcpu) &&
> >  	    vcpu->arch.sie_block->iictl != IICTL_CODE_NONE)
> >  		active_mask &= ~(IRQ_PEND_EXT_II_MASK |
> >  				 IRQ_PEND_IO_MASK |
> >   
> 

