Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F82A135E99
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbgAIQq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:46:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25061 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729533AbgAIQq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 11:46:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578588385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wSZzBvprRoztiTIATHxsRzzyBxzHL8wN24+xg1mbWDI=;
        b=IpM6aWMlUx8n3Kuj2PqTr27TxJ5Vb1pnUh++k5IRQ8zBPnPOnF41YNSt9PovQSXTPM0hzd
        FprxcaRIf1W3vpa4xmdRaf+ADjTX4LCa9cgiF0xEk/FqIxdQw/hOixCR0G7WQsfA38e1L8
        r8O31+RX3gPxwZW3vJuQPj1rq7pGy90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-RfgrzRnBMDGr5IycvhKDYw-1; Thu, 09 Jan 2020 11:46:21 -0500
X-MC-Unique: RfgrzRnBMDGr5IycvhKDYw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B71148E22BE;
        Thu,  9 Jan 2020 16:46:20 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC1F410013A7;
        Thu,  9 Jan 2020 16:46:17 +0000 (UTC)
Date:   Thu, 9 Jan 2020 17:46:15 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: check if kernel irqchip is actually enabled
Message-ID: <20200109174615.5eeebab8.cohuck@redhat.com>
In-Reply-To: <6020c443-a5b4-8064-87b6-a61e1b0b7c40@redhat.com>
References: <20200109134713.14755-1-cohuck@redhat.com>
        <6020c443-a5b4-8064-87b6-a61e1b0b7c40@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jan 2020 14:57:43 +0100
David Hildenbrand <david@redhat.com> wrote:

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
> This function is used on s390x/common code only in
> 
> virt/kvm/irqchip.c:kvm_send_userspace_msi()
> 
> That function is only used with CONFIG_HAVE_KVM_MSI. That is not
> selected for s390x.
> 
> What does this patch fix?

Currently, only future callers... but maybe this should be an optional
function instead that is only defined by the architectures that can
actually do something useful here? TBH, I'm not completely sure what
this function is actually supposed to indicate...

