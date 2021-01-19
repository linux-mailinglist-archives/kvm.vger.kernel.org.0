Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C852FB3E1
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 09:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbhASISg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 03:18:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727459AbhASISA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 03:18:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611044185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6CpEdRf4B3o+kwhJ32w+4smIUz2I29084pCD5mmSA0=;
        b=QmnV4UrUswzSS53kYIypVONWHY3zpEp8TDqVZneuTHv5SEyAOzmhN8xChZbTnVDS6NjwXZ
        mXgOWUd2Rz7hjf8DDtka8XPfwer9HUd+t7T9lyH+NFTYeyeMGAWL3aS2tbT59Q2t107uKg
        uSTQGEUAwhRdmz8S7pCDyGtqgjoX26s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-E-QR9IApNyiHivYJ-u5Tug-1; Tue, 19 Jan 2021 03:16:24 -0500
X-MC-Unique: E-QR9IApNyiHivYJ-u5Tug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0B3F59;
        Tue, 19 Jan 2021 08:16:21 +0000 (UTC)
Received: from gondolin (ovpn-113-246.ams2.redhat.com [10.36.113.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A517A620D7;
        Tue, 19 Jan 2021 08:16:10 +0000 (UTC)
Date:   Tue, 19 Jan 2021 09:16:08 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, brijesh.singh@amd.com,
        pair@us.ibm.com, pasic@linux.ibm.com, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <20210119091608.34fff5dc.cohuck@redhat.com>
In-Reply-To: <20210118194730.GH9899@work-vm>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-8-david@gibson.dropbear.id.au>
        <20210118194730.GH9899@work-vm>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Jan 2021 19:47:30 +0000
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * David Gibson (david@gibson.dropbear.id.au) wrote:
> > The platform specific details of mechanisms for implementing
> > confidential guest support may require setup at various points during
> > initialization.  Thus, it's not really feasible to have a single cgs
> > initialization hook, but instead each mechanism needs its own
> > initialization calls in arch or machine specific code.
> > 
> > However, to make it harder to have a bug where a mechanism isn't
> > properly initialized under some circumstances, we want to have a
> > common place, relatively late in boot, where we verify that cgs has
> > been initialized if it was requested.
> > 
> > This patch introduces a ready flag to the ConfidentialGuestSupport
> > base type to accomplish this, which we verify just before the machine
> > specific initialization function.  
> 
> You may find you need to define 'ready' and the answer might be a bit
> variable; for example, on SEV there's a setup bit and then you may end
> up doing an attestation and receiving some data before you actaully let
> the guest execute code.   Is it ready before it's received the
> attestation response or only when it can run code?
> Is a Power or 390 machine 'ready' before it's executed the magic
> instruction to enter the confidential mode?

I would consider those machines where the guest makes the transition
itself "ready" as soon as everything is set up so that the guest can
actually initiate the transition. Otherwise, those machines would never
be "ready" if the guest does not transition.

Maybe we can define "ready" as "the guest can start to execute in
secure mode", where "guest" includes the bootloader and everything that
runs in a guest context, and "start to execute" implies that some setup
may be done only after the guest has kicked it off?

