Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5645150897
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 15:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgBCOmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 09:42:17 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32510 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727454AbgBCOmR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 09:42:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580740935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2bnE3GeIl0nl5S25a2a73Dt1njOmPNbpaRPXj/yC62E=;
        b=iPmnOXRl4aBB9t0XkSrzyTa8J58nLG8Q8/KsfELUBYzwKoRhVjCLOVSR/sBYXV8QW0xQo9
        Zscn0Dds/7WRaINIKjuIV45hUWqypDUjHr/R3bze9SDbJXySBhV2OkQVDDIlX9RNcTY/gA
        DmBHFxJQC74GlQFVWWgEw6Dg5MyRJbY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-WHpMKSVVOrS4mToA93976Q-1; Mon, 03 Feb 2020 09:42:11 -0500
X-MC-Unique: WHpMKSVVOrS4mToA93976Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DA19107ACC4;
        Mon,  3 Feb 2020 14:42:10 +0000 (UTC)
Received: from gondolin (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E6DB1001281;
        Mon,  3 Feb 2020 14:42:06 +0000 (UTC)
Date:   Mon, 3 Feb 2020 15:42:03 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 00/37] KVM: s390: Add support for protected VMs
Message-ID: <20200203154203.28b9b3ca.cohuck@redhat.com>
In-Reply-To: <388d6049-a83e-ced3-ac32-303b3e8b8960@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203142329.5779068f.cohuck@redhat.com>
        <388d6049-a83e-ced3-ac32-303b3e8b8960@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Feb 2020 14:32:52 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 03.02.20 14:23, Cornelia Huck wrote:
> > On Mon,  3 Feb 2020 08:19:20 -0500
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's state
> >> like guest memory and guest registers anymore. Instead the PVMs are
> >> mostly managed by a new entity called Ultravisor (UV), which provides
> >> an API, so KVM and the PV can request management actions.
> >>
> >> PVMs are encrypted at rest and protected from hypervisor access while
> >> running. They switch from a normal operation into protected mode, so
> >> we can still use the standard boot process to load a encrypted blob
> >> and then move it into protected mode.
> >>
> >> Rebooting is only possible by passing through the unprotected/normal
> >> mode and switching to protected again.
> >>
> >> All patches are in the protvirtv2 branch of the korg s390 kvm git
> >> (on top of Janoschs reset rework).
> >>
> >> Claudio presented the technology at his presentation at KVM Forum
> >> 2019.  
> > 
> > Do you have a changelog from v1 somewhere?  
> 
> Probably too many things have changed.
> 
> There is still the old branch protvirt that rebases almost fine on top of v5.5
> so here are the differences that I can see
> - docs as rst instead of txt
> - memory management now with paging
> - MEMOP interface now different (new code points instead of abusing the old ones)
> - prefix page handling with intercept 112 (prefix not secure)
> - interrupt refreshing exits reworked according to review
> - fencing in several ioctls
> - based on reset rework
> - fixes fixes and fixes

And also some fixes? :)

Ok, I think I'll be able to make my way through this.

