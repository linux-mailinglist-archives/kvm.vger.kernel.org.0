Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1202D74D1
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 12:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394436AbgLKLjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 06:39:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391879AbgLKLjK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 06:39:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607686664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RqIjgNGP8EpRseSxFoBnqE8y63I178BwzCy3MXCM4mw=;
        b=dGzEMqk0j9e/Z6L3lTiQxCZYMmZaaKmobd7quwyWEoyYFLA5NA0gMxKTtIQ/Nydbghp7/v
        bqY8qTonJPMGK7m+KoEQe5TX0j0tHonmuuNBSXTJp9GxMvHqw7EQK633tgnAMa30JrpPNr
        KD2W3OzA7oIMf/hGphGKQBcqcnCkHPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-uYx1psuZPVahtzYjTJGM0w-1; Fri, 11 Dec 2020 06:37:40 -0500
X-MC-Unique: uYx1psuZPVahtzYjTJGM0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 282FC190A7A4;
        Fri, 11 Dec 2020 11:37:38 +0000 (UTC)
Received: from gondolin (ovpn-112-240.ams2.redhat.com [10.36.112.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 851305D705;
        Fri, 11 Dec 2020 11:37:32 +0000 (UTC)
Date:   Fri, 11 Dec 2020 12:37:29 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/4] s390/pci: track alignment/length strictness for
 zpci_dev
Message-ID: <20201211123729.37647fa0.cohuck@redhat.com>
In-Reply-To: <15132f7f-cad7-d663-a8b9-90f417e85c81@linux.ibm.com>
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
        <1607545670-1557-2-git-send-email-mjrosato@linux.ibm.com>
        <20201210113318.136636e2.cohuck@redhat.com>
        <15132f7f-cad7-d663-a8b9-90f417e85c81@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Dec 2020 10:26:22 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 12/10/20 5:33 AM, Cornelia Huck wrote:
> > On Wed,  9 Dec 2020 15:27:47 -0500
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> >> Some zpci device types (e.g., ISM) follow different rules for length
> >> and alignment of pci instructions.  Recognize this and keep track of
> >> it in the zpci_dev.
> >>
> >> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> >> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> >> ---
> >>   arch/s390/include/asm/pci.h     | 3 ++-
> >>   arch/s390/include/asm/pci_clp.h | 4 +++-
> >>   arch/s390/pci/pci_clp.c         | 1 +
> >>   3 files changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> >> index 2126289..f16ffba 100644
> >> --- a/arch/s390/include/asm/pci.h
> >> +++ b/arch/s390/include/asm/pci.h
> >> @@ -133,7 +133,8 @@ struct zpci_dev {
> >>   	u8		has_hp_slot	: 1;
> >>   	u8		is_physfn	: 1;
> >>   	u8		util_str_avail	: 1;
> >> -	u8		reserved	: 4;
> >> +	u8		relaxed_align	: 1;
> >> +	u8		reserved	: 3;
> >>   	unsigned int	devfn;		/* DEVFN part of the RID*/
> >>   
> >>   	struct mutex lock;
> >> diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
> >> index 1f4b666..9fb7cbf 100644
> >> --- a/arch/s390/include/asm/pci_clp.h
> >> +++ b/arch/s390/include/asm/pci_clp.h
> >> @@ -150,7 +150,9 @@ struct clp_rsp_query_pci_grp {
> >>   	u16			:  4;
> >>   	u16 noi			: 12;	/* number of interrupts */
> >>   	u8 version;
> >> -	u8			:  6;
> >> +	u8			:  4;
> >> +	u8 relaxed_align	:  1;	/* Relax length and alignment rules */
> >> +	u8			:  1;
> >>   	u8 frame		:  1;
> >>   	u8 refresh		:  1;	/* TLB refresh mode */
> >>   	u16 reserved2;
> >> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> >> index 153720d..630f8fc 100644
> >> --- a/arch/s390/pci/pci_clp.c
> >> +++ b/arch/s390/pci/pci_clp.c
> >> @@ -103,6 +103,7 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
> >>   	zdev->max_msi = response->noi;
> >>   	zdev->fmb_update = response->mui;
> >>   	zdev->version = response->version;
> >> +	zdev->relaxed_align = response->relaxed_align;
> >>   
> >>   	switch (response->version) {
> >>   	case 1:  
> > 
> > Hm, what does that 'relaxed alignment' imply? Is that something that
> > can apply to emulated devices as well?
> >   
> The relaxed alignment simply loosens the rules on the PCISTB instruction 
> so that it doesn't have to be on particular boundaries / have a minimum 
> length restriction, these effectively allow ISM devices to use PCISTB 
> instead of PCISTG for just about everything.  If you have a look at the 
> patch "s390x/pci: Handle devices that support relaxed alignment" from 
> the linked qemu set, you can get an idea of what the bit changes via the 
> way qemu has to be more permissive of what the guest provides for PCISTB.

Ok, so it is basically a characteristic of a specific device that
changes the rules of what pcistb will accept.

> 
> Re: emulated devices...  The S390 PCI I/O layer in the guest is always 
> issuing strict? aligned I/O for PCISTB, and if it decided to later 
> change that behavior it would need to look at this CLP bit to decide 
> whether that would be a valid operation for a given PCI function anyway. 
>   This bit will remain off in the CLP response we give for emulated 
> devices, ensuring that should such a change occur in the guest s390 PCI 
> I/O layer, we'd just continue getting strictly-aligned PCISTB.

My question was more whether that was a feature that might make sense
to emulate on the hypervisor side for fully emulated devices. I'd like
to leave the door open for emulated devices to advertise this and make
it possible for guests using those devices to use pcistb with the
relaxed rules, if it makes sense.

I guess we can easily retrofit this if we come up with a use case for it.

