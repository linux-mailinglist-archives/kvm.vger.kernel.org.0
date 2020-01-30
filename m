Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BED014D929
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 11:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgA3Kjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 05:39:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31934 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726893AbgA3Kjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 05:39:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580380793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zUvMSNl99Jwy3aPQU5yVQFcXIlRXEbblcUjGKucu2hE=;
        b=WAek6IywAAOUyykcUL4JfiCzm2n9poS39wmcO5GOpWAi75OPnzi0tNNn0NYkwgM18DjQPU
        ElFN+t5c3iJEmpZjCo8Xf6FDZCWrgQFcQjuZVnQaqMXANuWNV02xlrzqnkgQK1AJoDUeld
        DSfUupIzcAyc/ZTu1sJ9XOMLXhqcIVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-H9m9G7F1Ok6g0BZICdkEUg-1; Thu, 30 Jan 2020 05:39:49 -0500
X-MC-Unique: H9m9G7F1Ok6g0BZICdkEUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EFDD8017CC;
        Thu, 30 Jan 2020 10:39:48 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CEFE1001B07;
        Thu, 30 Jan 2020 10:39:43 +0000 (UTC)
Date:   Thu, 30 Jan 2020 11:39:41 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, stable@kernel.org
Subject: Re: [PATCH/FIXUP FOR STABLE BEFORE THIS SERIES] KVM: s390: do not
 clobber user space fpc during guest reset
Message-ID: <20200130113941.78e4bf2e.cohuck@redhat.com>
In-Reply-To: <7b40856d-8153-ad3f-bea8-110fa6e1aea6@redhat.com>
References: <20200129200312.3200-2-frankja@linux.ibm.com>
        <1580374500-31247-1-git-send-email-borntraeger@de.ibm.com>
        <7b40856d-8153-ad3f-bea8-110fa6e1aea6@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 10:49:35 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 30.01.20 09:55, Christian Borntraeger wrote:
> > The initial CPU reset currently clobbers the userspace fpc. This was an
> > oversight during a fixup for the lazy fpu reloading rework.  The reset
> > calls are only done from userspace ioctls. No CPU context is loaded, so
> > we can (and must) act directly on the sync regs, not on the thread
> > context. Otherwise the fpu restore call will restore the zeroes fpc to
> > userspace.
> > 
> > Cc: stable@kernel.org
> > Fixes: 9abc2a08a7d6 ("KVM: s390: fix memory overwrites when vx is disabled")
> > Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index c059b86..eb789cd 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2824,8 +2824,7 @@ static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
> >  	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
> >  					CR14_UNUSED_33 |
> >  					CR14_EXTERNAL_DAMAGE_SUBMASK;
> > -	/* make sure the new fpc will be lazily loaded */
> > -	save_fpu_regs();
> > +	vcpu->run->s.regs.fpc = 0;
> >  	current->thread.fpu.fpc = 0;
> >  	vcpu->arch.sie_block->gbea = 1;
> >  	vcpu->arch.sie_block->pp = 0;
> >   
> 
> kvm_arch_vcpu_ioctl() does a vcpu_load(vcpu), followed by the call to
> kvm_arch_vcpu_ioctl_initial_reset(), followed by a vcpu_put().
> 
> What am I missing?

I have been staring at this patch for some time now, and I fear I'm
missing something as well. Can we please get more explanation?

> 
> (we could get rid of the kvm_arch_vcpu_ioctl_initial_reset() wrapper)
> 

