Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035DF135EAE
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbgAIQtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:49:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727738AbgAIQtT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 11:49:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578588558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KrP42ZZX4/LcDQ7SYYauYYSKRhpk+Ugq3lsZdVo10WE=;
        b=Gtb8O6vqjDvqVrv2TuZzAsJZVenFOOmpUrj6vx616xJhKT7FQ3/VrGbpjmxh2UZxF1q8fd
        Gu8UdOz0zg0J8MT+OVNbmKZV2yTXbt7sVjZfsej4zmX6nPfQeslNzKUOzoUEU4b0CLAiq1
        luebgsIFV9d84XJZH8rJ7ehabAkiVgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-TIWoVtdbOIueIWQIrAFRXw-1; Thu, 09 Jan 2020 11:49:11 -0500
X-MC-Unique: TIWoVtdbOIueIWQIrAFRXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0FB4113FD20;
        Thu,  9 Jan 2020 16:49:10 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C97681C2E;
        Thu,  9 Jan 2020 16:49:07 +0000 (UTC)
Date:   Thu, 9 Jan 2020 17:49:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: check if kernel irqchip is actually enabled
Message-ID: <20200109174905.138269ca.cohuck@redhat.com>
In-Reply-To: <dd1ea7ee-d848-63ae-8b4d-857185e32b44@de.ibm.com>
References: <20200109134713.14755-1-cohuck@redhat.com>
        <dd1ea7ee-d848-63ae-8b4d-857185e32b44@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jan 2020 15:06:22 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 09.01.20 14:47, Cornelia Huck wrote:
> > On s390, we only allow userspace to create an in-kernel irqchip
> > if it has first enabled the KVM_CAP_S390_IRQCHIP vm capability.
> > Let's assume that a userspace that enabled that capability has
> > created an irqchip as well.
> > 
> > Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")
> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > ---
> > 
> > A more precise check would be to add a field in kvm_arch that tracks
> > whether an irqchip has actually been created; not sure if that is
> > really needed.  
> 
> I think this is semantically wrong. We always have in-kernel irq handling.
> It is actually not possible to not use it. So I understand where you are coming
> from but this feels kind of wrong. 

You cannot actually call create_irqchip if not enabled, though... as I
said in my other reply, the intended semantics here are a bit unclear.

> 
> > 
> > Found while trying to hunt down QEMU crashes with kvm-irqchip=off;
> > this is not sufficient, though. I *think* everything but irqfds
> > should work without kvm-irqchip as well, but have not found the problem
> > yet.
> > 
> > ---
> >  arch/s390/kvm/irq.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/kvm/irq.h b/arch/s390/kvm/irq.h
> > index 484608c71dd0..30e13d031379 100644
> > --- a/arch/s390/kvm/irq.h
> > +++ b/arch/s390/kvm/irq.h
> > @@ -13,7 +13,7 @@
> >  
> >  static inline int irqchip_in_kernel(struct kvm *kvm)
> >  {
> > -	return 1;
> > +	return !!kvm->arch.use_irqchip;
> >  }
> >  
> >  #endif
> >   
> 

