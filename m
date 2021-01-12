Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB532F2E1C
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 12:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbhALLhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 06:37:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728547AbhALLhx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 06:37:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610451386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2AOgxTLMTIdTZKNC7B3wsjgAb0AUyN6gAO1jJbajxeI=;
        b=IbFdHFcxSWF7bnr7bQ2mJIP36I7lZP9Q0hXydR4j7JKxjF67g1z+DiWm0hAX54k0w6suc3
        m1JC6AwQqZZ1RRlFKgIfnNWdlYgKEbE3RwG+KesPKHrPoqJdcnDih5VEybDzNmhPFEv0Ql
        K5TJBAr0fyELkPrp83fBYxoH926Vv9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-RAM-GMsoNzW6ODFs7TuxSA-1; Tue, 12 Jan 2021 06:36:24 -0500
X-MC-Unique: RAM-GMsoNzW6ODFs7TuxSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38FEEDF8CF;
        Tue, 12 Jan 2021 11:36:22 +0000 (UTC)
Received: from gondolin (ovpn-114-102.ams2.redhat.com [10.36.114.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15A9D10016FB;
        Tue, 12 Jan 2021 11:36:09 +0000 (UTC)
Date:   Tue, 12 Jan 2021 12:36:07 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, pasic@linux.ibm.com,
        brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        qemu-devel@nongnu.org, andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, mdroth@linux.vnet.ibm.com,
        richard.henderson@linaro.org, kvm@vger.kernel.org,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        mst@redhat.com, qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 13/13] s390: Recognize confidential-guest-support
 option
Message-ID: <20210112123607.39597e3d.cohuck@redhat.com>
In-Reply-To: <fcafba03-3701-93af-8eb7-17bd0d14d167@de.ibm.com>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
        <20210112044508.427338-14-david@gibson.dropbear.id.au>
        <fcafba03-3701-93af-8eb7-17bd0d14d167@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 09:15:26 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 12.01.21 05:45, David Gibson wrote:
> > At least some s390 cpu models support "Protected Virtualization" (PV),
> > a mechanism to protect guests from eavesdropping by a compromised
> > hypervisor.
> > 
> > This is similar in function to other mechanisms like AMD's SEV and
> > POWER's PEF, which are controlled by the "confidential-guest-support"
> > machine option.  s390 is a slightly special case, because we already
> > supported PV, simply by using a CPU model with the required feature
> > (S390_FEAT_UNPACK).
> > 
> > To integrate this with the option used by other platforms, we
> > implement the following compromise:
> > 
> >  - When the confidential-guest-support option is set, s390 will
> >    recognize it, verify that the CPU can support PV (failing if not)
> >    and set virtio default options necessary for encrypted or protected
> >    guests, as on other platforms.  i.e. if confidential-guest-support
> >    is set, we will either create a guest capable of entering PV mode,
> >    or fail outright.
> > 
> >  - If confidential-guest-support is not set, guests might still be
> >    able to enter PV mode, if the CPU has the right model.  This may be
> >    a little surprising, but shouldn't actually be harmful.
> > 
> > To start a guest supporting Protected Virtualization using the new
> > option use the command line arguments:
> >     -object s390-pv-guest,id=pv0 -machine confidential-guest-support=pv0  
> 
> 
> This results in
> 
> [cborntra@t35lp61 qemu]$ qemu-system-s390x -enable-kvm -nographic -m 2G -kernel ~/full.normal 
> **
> ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent->instance_size <= ti->instance_size)
> Bail out! ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent->instance_size <= ti->instance_size)
> Aborted (core dumped)
> 

> > +static const TypeInfo s390_pv_guest_info = {
> > +    .parent = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> > +    .name = TYPE_S390_PV_GUEST,
> > +    .instance_size = sizeof(S390PVGuestState),
> > +    .interfaces = (InterfaceInfo[]) {
> > +        { TYPE_USER_CREATABLE },
> > +        { }
> > +    }
> > +};

I think this needs TYPE_OBJECT in .parent and
TYPE_CONFIDENTIAL_GUEST_SUPPORT as an interface to fix the crash.

