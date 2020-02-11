Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59813158FB6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgBKNVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:21:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35035 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728460AbgBKNVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:21:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581427293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VvEvaSBDRVHrMA6kt83bhvPKM3ic03ikIZ0HFfjWGD0=;
        b=TD/+tnr/l4obfLnT2Odjr19VZLH2KnTWIcFwv/OdrCeTTmFEfPttpYm+P2pMl42NMHfQc/
        CsOpaeE2YWR35LOh6RInIZnr/Fx1vTnYRFgm7EBkySHMENwnXzG+xuUggJMXnAvZcDx81U
        3LvQGCgL73VxiRSXgBdl4w6O2su/NGw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-0uzOiFKCMqODvXes5O9GPQ-1; Tue, 11 Feb 2020 08:21:29 -0500
X-MC-Unique: 0uzOiFKCMqODvXes5O9GPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F09CDB22;
        Tue, 11 Feb 2020 13:21:27 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C710C5C100;
        Tue, 11 Feb 2020 13:21:22 +0000 (UTC)
Date:   Tue, 11 Feb 2020 14:21:20 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 21/35] KVM: s390/mm: handle guest unpin events
Message-ID: <20200211142120.6a57b970.cohuck@redhat.com>
In-Reply-To: <2fd5c392-a2b7-c6b8-f079-8b87ee60f65e@redhat.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-22-borntraeger@de.ibm.com>
        <2fd5c392-a2b7-c6b8-f079-8b87ee60f65e@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Feb 2020 15:58:11 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 07/02/2020 12.39, Christian Borntraeger wrote:
> > From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > 
> > The current code tries to first pin shared pages, if that fails (e.g.
> > because the page is not shared) it will export them. For shared pages
> > this means that we get a new intercept telling us that the guest is
> > unsharing that page. We will make the page secure at that point in time
> > and revoke the host access. This is synchronized with other host events,
> > e.g. the code will wait until host I/O has finished.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> > Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > ---
> >  arch/s390/kvm/intercept.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> > 
> > diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> > index 2a966dc52611..e155389a4a66 100644
> > --- a/arch/s390/kvm/intercept.c
> > +++ b/arch/s390/kvm/intercept.c
> > @@ -16,6 +16,7 @@
> >  #include <asm/asm-offsets.h>
> >  #include <asm/irq.h>
> >  #include <asm/sysinfo.h>
> > +#include <asm/uv.h>
> >  
> >  #include "kvm-s390.h"
> >  #include "gaccess.h"
> > @@ -484,12 +485,35 @@ static int handle_pv_sclp(struct kvm_vcpu *vcpu)
> >  	return 0;
> >  }
> >  
> > +static int handle_pv_uvc(struct kvm_vcpu *vcpu)
> > +{
> > +	struct uv_cb_share *guest_uvcb = (void *)vcpu->arch.sie_block->sidad;
> > +	struct uv_cb_cts uvcb = {
> > +		.header.cmd	= UVC_CMD_UNPIN_PAGE_SHARED,
> > +		.header.len	= sizeof(uvcb),
> > +		.guest_handle	= kvm_s390_pv_handle(vcpu->kvm),
> > +		.gaddr		= guest_uvcb->paddr,
> > +	};
> > +	int rc;
> > +
> > +	if (guest_uvcb->header.cmd != UVC_CMD_REMOVE_SHARED_ACCESS) {
> > +		WARN_ONCE(1, "Unexpected UVC 0x%x!\n", guest_uvcb->header.cmd);  
> 
> Is there a way to signal the failed command to the guest, too?

I'm wondering at which layer the actual problem occurs here. Is it
because a (new) command was not interpreted or rejected by the
ultravisor so that it ended up being handled by the hypervisor? If so,
what should the guest know?

> 
>  Thomas
> 
> 
> > +		return 0;
> > +	}
> > +	rc = uv_make_secure(vcpu->arch.gmap, uvcb.gaddr, &uvcb);
> > +	if (rc == -EINVAL && uvcb.header.rc == 0x104)

This wants a comment.

> > +		return 0;
> > +	return rc;
> > +}
> > +
> >  static int handle_pv_notification(struct kvm_vcpu *vcpu)
> >  {
> >  	if (vcpu->arch.sie_block->ipa == 0xb210)
> >  		return handle_pv_spx(vcpu);
> >  	if (vcpu->arch.sie_block->ipa == 0xb220)
> >  		return handle_pv_sclp(vcpu);
> > +	if (vcpu->arch.sie_block->ipa == 0xb9a4)
> > +		return handle_pv_uvc(vcpu);

Is it defined by the architecture what the possible commands are
for which the hypervisor may get control? If we get something
unexpected, is returning 0 the right strategy?

> >  
> >  	return handle_instruction(vcpu);
> >  }
> >   
> 

