Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D46203656
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 14:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgFVMDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 08:03:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60388 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726889AbgFVMDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 08:03:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592827393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVZM5JCuZkIi5xnj5bE3R/j/IYiq0+TYez1QiVgCgow=;
        b=TzFMjgtgWs0Qpb+/5FjB8F9QZeHmoDUDjw0uQjgHLU4N9uzqej6szP1RTv9tgR/sX6sMDb
        uieXHs0/R0VKmRGpLHlA1IDwUyPKS9rNndriQp9r9EM7vtg3+v0kK/WBLzbaNd2Uv6vWr2
        FTz6NJ2L/HBf0ssQbrBQRoqrT/CpIF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-EnuZ-F8lNi-ouCQj2c7U3Q-1; Mon, 22 Jun 2020 08:03:11 -0400
X-MC-Unique: EnuZ-F8lNi-ouCQj2c7U3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B3728014D4;
        Mon, 22 Jun 2020 12:03:09 +0000 (UTC)
Received: from gondolin (ovpn-113-56.ams2.redhat.com [10.36.113.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5742100238C;
        Mon, 22 Jun 2020 12:02:56 +0000 (UTC)
Date:   Mon, 22 Jun 2020 14:02:54 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200622140254.0dbe5d8c.cohuck@redhat.com>
In-Reply-To: <358d48e5-4c57-808b-50da-275f5e2a352c@redhat.com>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
        <e045e202-cd56-4ddc-8c1d-a2fe5a799d32@redhat.com>
        <20200619114526.6a6f70c6.cohuck@redhat.com>
        <79890826-f67c-2228-e98d-25d2168be3da@redhat.com>
        <20200619120530.256c36cb.cohuck@redhat.com>
        <358d48e5-4c57-808b-50da-275f5e2a352c@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Jun 2020 12:10:13 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 19.06.20 12:05, Cornelia Huck wrote:
> > On Fri, 19 Jun 2020 11:56:49 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> >   
> >>>>> For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> >>>>> can be extended to cover the Intel and s390 mechanisms as well,
> >>>>> though.      
> >>>>
> >>>> The only approach on s390x to not glue command line properties to the
> >>>> cpu model would be to remove the CPU model feature and replace it by the
> >>>> command line parameter. But that would, of course, be an incompatible break.    
> >>>
> >>> Yuck.
> >>>
> >>> We still need to provide the cpu feature to the *guest* in any case, no?    
> >>
> >> Yeah, but that could be wired up internally. Wouldn't consider it clean,
> >> though (I second the "overengineered" above).  
> > 
> > Could an internally wired-up cpu feature be introspected? Also, what  
> 
> Nope. It would just be e.g., a "machine feature" indicated to the guest
> via the STFL interface/instruction. I was tackling the introspect part
> when asking David how to sense from upper layers. It would have to be
> sense via a different interface as it would not longer be modeled as
> part of CPU features in QEMU.
> 
> > happens if new cpu features are introduced that have a dependency on or
> > a conflict with this one?  
> 
> Conflict: bail out in QEMU when incompatible options are specified.
> Dependency: warn and continue/fixup (e.g., mask off?)

Masking off would likely be surprising to the user.

> Not clean I think.

I agree.

Still unsure how to bring this new machine property and the cpu feature
together. Would be great to have the same interface everywhere, but
having two distinct command line objects depend on each other sucks.
Automatically setting the feature bit if pv is supported complicates
things further.

(Is there any requirement that the machine object has been already set
up before the cpu features are processed? Or the other way around?)

Does this have any implications when probing with the 'none' machine?

