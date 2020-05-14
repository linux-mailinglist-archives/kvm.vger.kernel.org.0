Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9B31D4141
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 00:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgENWng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 18:43:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49518 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728229AbgENWng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 18:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589496215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EuByLHu0fVVYt80Znm7O1SLfFlYE97ZCfHsTDGMqNd0=;
        b=AHDQYtyrABbpNYj++hdR8pRzkFuDQPzHEgnQg1fPDfCkPyoi+ASWHXhK1pbtHyllkYrwh+
        Bl/hCJ4V8SHO4OBVwrPC+Oh+BhhBDFdw7W7HTU9xThIzenHBzPvUVCnvXwsLSFZMPfkqe9
        D5BauyPrzFp5Ujf9jvt221Cp996cgN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-k1tougtUNyKRQqEM0CMInQ-1; Thu, 14 May 2020 18:43:33 -0400
X-MC-Unique: k1tougtUNyKRQqEM0CMInQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C6FA107B265;
        Thu, 14 May 2020 22:43:32 +0000 (UTC)
Received: from w520.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8FC75D714;
        Thu, 14 May 2020 22:43:27 +0000 (UTC)
Date:   Thu, 14 May 2020 16:43:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Micah Morton <mortonm@chromium.org>,
        Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
Message-ID: <20200514164327.72734a77@w520.home>
In-Reply-To: <9d5d7eec-77dd-bca9-949f-8f39fcd7d8d7@redhat.com>
References: <20200511220046.120206-1-mortonm@chromium.org>
        <20200512111440.15caaca2@w520.home>
        <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
        <20200513083401.11e761a7@x1.home>
        <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com>
        <CAJ-EccPjU0Lh5gEnr0L9AhuuJTad1yHX-BzzWq21m+e-vY-ELA@mail.gmail.com>
        <0fdb5d54-e4d6-8f2f-69fe-1b157999d6cd@redhat.com>
        <CAJ-EccP6GNmyCGJZFfXUo2_8KEN_sJZ3=88f+3E-8SJ=JT8Pcg@mail.gmail.com>
        <9d5d7eec-77dd-bca9-949f-8f39fcd7d8d7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 May 2020 23:17:29 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 14/05/20 19:44, Micah Morton wrote:
> > I realize this may seem like an over-use of VFIO, but I'm actually
> > coming from the angle of wanting to assign _most_ of the important
> > hardware on my device to a VM guest, and I'm looking to avoid
> > emulation wherever possible. Of course there will be devices like the
> > IOAPIC for which emulation is unavoidable, but I think emulation is
> > avoidable here for the busses we've mentioned if there is a way to
> > forward arbitrary interrupts into the guest.
> > 
> > Since all these use cases are so close to working with vfio-pci right
> > out of the box, I was really hoping to come up with a simple and
> > generic solution to the arbitrary interrupt problem that can be used
> > for multiple bus types.  
> 
> I shall defer to Alex on this, but I think the main issue here is that
> these interrupts are not visible to Linux as pertaining to the pci-stub
> device.  Is this correct?

Yes.  Allowing a user to grant themselves access to an arbitrary
interrupt is a non-starter, vfio-pci needs to somehow know that the
user is entitled to that interrupt.  If we could do that, then we could
just add it as a device specific interrupt.  But how do we do that?

The quirk method to this might be to key off of the PCI vendor and
device ID of the PCI i2c controller, lookup DMI information to know if
we're on the platform that has this fixed association, and setup the
extra interrupt.  The more extensible, but potentially bloated solution
might be for vfio-pci to recognize the class code for a i2c controller
and implement a very simple bus walk at device probe time that collects
external dependencies.  I don't really know how the jump is made from
that bus walk to digging the interrupt resource out of ACPI though or
how many LoC would be required to perform the minimum possible
discovery to collect this association.

I notice in this RFC patch that you're using an exclusive interrupt for
level triggered interrupts and therefore masking at the APIC.
Requiring an exclusive interrupt is often a usability issue for PCI
devices that don't support DisINTx and obviously we don't have that for
non-PCI sub-devices.  What type of interrupt do you actually need for
this device?  Thanks,

Alex

