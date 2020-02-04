Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5EA1517D1
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 10:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgBDJ2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 04:28:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55403 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726151AbgBDJ2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 04:28:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580808510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iDSWNcvxjDzzqX+kj1KJM0VR4NOw6UVBKxkW/z4A4WE=;
        b=OHJo6krObxPRcruJnOYweEK4ge667bWP2H0XIHo69D3yn+32Tt7ixOLee3kOfcKg1vFg/k
        awt+TVFcoZOzwZSuba/Vl9yJQJZiu6H1VpxCWERZCYsC1WPQaDrR2GHulHcNVq4SzHsrkj
        P029tOnVRQuJgieWEg2PG8kxuv7sthc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-vtIpvrHsNhOrjbCbpopwlg-1; Tue, 04 Feb 2020 04:28:28 -0500
X-MC-Unique: vtIpvrHsNhOrjbCbpopwlg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E8908014DB;
        Tue,  4 Feb 2020 09:28:27 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03F2E8068E;
        Tue,  4 Feb 2020 09:28:22 +0000 (UTC)
Date:   Tue, 4 Feb 2020 10:28:20 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 02/37] s390/protvirt: introduce host side setup
Message-ID: <20200204102820.51081649.cohuck@redhat.com>
In-Reply-To: <0310f99f-6d1e-b1bb-9313-be2a92c601ba@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-3-borntraeger@de.ibm.com>
        <20200203181238.7c7ea03b.cohuck@redhat.com>
        <0310f99f-6d1e-b1bb-9313-be2a92c601ba@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Feb 2020 23:03:42 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 03.02.20 18:12, Cornelia Huck wrote:
> > On Mon,  3 Feb 2020 08:19:22 -0500
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> From: Vasily Gorbik <gor@linux.ibm.com>
> >>
> >> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
> >> protected virtual machines hosting support code.  
> > 
> > Hm... I seem to remember that you wanted to drop this config option and
> > always build the code, in order to reduce complexity. Have you
> > reconsidered this?  
> 
> I am still in favour of removing this, but I did not get an "yes, lets do
> it" answer. Since removing is easier than re-adding its still in.

ok

> 
>  [...]
> >> + * Copyright IBM Corp. 2019  
> > 
> > Happy new year?  
> 
> yep :-)
> [..]
> 
> >> +
> >> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> >> +int __bootdata_preserved(prot_virt_guest);  
> > 
> > Confused. You have this and uv_info below both in this file and in
> > boot/uv.c. Is there some magic happening in __bootdata_preserved()?  
> 
> Yes, this is information that is transferred from the decompressor
> to Linux. 
> I think we discussed about this the last time as well?

I think I was confused about different things last time...

But that is probably a sign that this wants a comment :)

> 
> 
> >   
> >> +#endif
> >> +
> >> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> >> +int prot_virt_host;
> >> +EXPORT_SYMBOL(prot_virt_host);
> >> +struct uv_info __bootdata_preserved(uv_info);
> >> +EXPORT_SYMBOL(uv_info);
> >> +
> >> +static int __init prot_virt_setup(char *val)
> >> +{
> >> +	bool enabled;
> >> +	int rc;
> >> +
> >> +	rc = kstrtobool(val, &enabled);
> >> +	if (!rc && enabled)
> >> +		prot_virt_host = 1;
> >> +
> >> +	if (is_prot_virt_guest() && prot_virt_host) {
> >> +		prot_virt_host = 0;
> >> +		pr_info("Running as protected virtualization guest.");  
> > 
> > Trying to disentangle that a bit in my mind...
> > 
> > If we don't have facility 158, is_prot_virt_guest() will return 0. If
> > protected host support has been requested, we'll print a message below
> > (and turn it off).  
> 
> yes, a guest cannot be a host. 
> > 
> > If the hardware provides the facilities for running as a protected virt
> > guest, we turn off protected virt host support if requested and print a
> > messages that we're a guest.
> > 
> > Two questions:
> > - Can the hardware ever provide both host and guest interfaces at the
> >   same time? I guess not; maybe add a comment?  
> 
> Right, you are either guest or host. 
> 
> > - Do we also want to print a message that we're running as a guest if
> >   the user didn't enable host support? If not, maybe prefix the message
> >   with "Cannot enable support for protected virtualization host:" or
> >   so? (Maybe also a good idea for the message below.)  
> 
> Line too long and I hate breaking string over multiple lines.
> I can change if somebody comes up with a proper message that is not too long.
> 

Fair enough; it's just that it's not very clear from the messages in
the log what happened. Maybe

"prot_virt: Running as protected virtualization guest."
"prot_virt: The ultravisor call facility is not available."

That at least links back to the kernel parameter.

[Aside: Would prot_virt_host be a better name? But that probably moves
us into bikeshed territory.]

