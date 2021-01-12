Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95522F2E65
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 12:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbhALLvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 06:51:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729154AbhALLvS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 06:51:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610452191;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=wF92suEHUUdnkBTHhVOLjTPtyZvBqmafJGqVYdU07Bw=;
        b=ET2EIe//47ovAKwSBdieJGZG/FKzpixLU7Fqv/DRpIr/QehUDAWtcpEG6FgdURIw9IFV/D
        VLe9TULL5SSsnff1hvu20u8wPfiVvr4idxDC2LxZmbCdLjxz95bJlLSO6J+t+U7HWwuK/Y
        mghlM3rTTa7mjCnI8vBwieLPvf4qzag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-y0BMXZfNMACzIg9zdWc7Eg-1; Tue, 12 Jan 2021 06:49:35 -0500
X-MC-Unique: y0BMXZfNMACzIg9zdWc7Eg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8B451005D53;
        Tue, 12 Jan 2021 11:49:32 +0000 (UTC)
Received: from redhat.com (ovpn-115-107.ams2.redhat.com [10.36.115.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1F8B60BE2;
        Tue, 12 Jan 2021 11:49:16 +0000 (UTC)
Date:   Tue, 12 Jan 2021 11:49:13 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, kvm@vger.kernel.org, david@redhat.com,
        qemu-devel@nongnu.org, frankja@linux.ibm.com, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        pragyansri.pathi@intel.com, andi.kleen@intel.com, thuth@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        richard.henderson@linaro.org, dgilbert@redhat.com,
        Greg Kurz <groug@kaod.org>, qemu-s390x@nongnu.org,
        jun.nakajima@intel.com, David Gibson <david@gibson.dropbear.id.au>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 13/13] s390: Recognize confidential-guest-support
 option
Message-ID: <20210112114913.GG1360503@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-14-david@gibson.dropbear.id.au>
 <fcafba03-3701-93af-8eb7-17bd0d14d167@de.ibm.com>
 <20210112123607.39597e3d.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210112123607.39597e3d.cohuck@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 12:36:07PM +0100, Cornelia Huck wrote:
> On Tue, 12 Jan 2021 09:15:26 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > On 12.01.21 05:45, David Gibson wrote:
> > > At least some s390 cpu models support "Protected Virtualization" (PV),
> > > a mechanism to protect guests from eavesdropping by a compromised
> > > hypervisor.
> > > 
> > > This is similar in function to other mechanisms like AMD's SEV and
> > > POWER's PEF, which are controlled by the "confidential-guest-support"
> > > machine option.  s390 is a slightly special case, because we already
> > > supported PV, simply by using a CPU model with the required feature
> > > (S390_FEAT_UNPACK).
> > > 
> > > To integrate this with the option used by other platforms, we
> > > implement the following compromise:
> > > 
> > >  - When the confidential-guest-support option is set, s390 will
> > >    recognize it, verify that the CPU can support PV (failing if not)
> > >    and set virtio default options necessary for encrypted or protected
> > >    guests, as on other platforms.  i.e. if confidential-guest-support
> > >    is set, we will either create a guest capable of entering PV mode,
> > >    or fail outright.
> > > 
> > >  - If confidential-guest-support is not set, guests might still be
> > >    able to enter PV mode, if the CPU has the right model.  This may be
> > >    a little surprising, but shouldn't actually be harmful.
> > > 
> > > To start a guest supporting Protected Virtualization using the new
> > > option use the command line arguments:
> > >     -object s390-pv-guest,id=pv0 -machine confidential-guest-support=pv0  
> > 
> > 
> > This results in
> > 
> > [cborntra@t35lp61 qemu]$ qemu-system-s390x -enable-kvm -nographic -m 2G -kernel ~/full.normal 
> > **
> > ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent->instance_size <= ti->instance_size)
> > Bail out! ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent->instance_size <= ti->instance_size)
> > Aborted (core dumped)
> > 
> 
> > > +static const TypeInfo s390_pv_guest_info = {
> > > +    .parent = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> > > +    .name = TYPE_S390_PV_GUEST,
> > > +    .instance_size = sizeof(S390PVGuestState),
> > > +    .interfaces = (InterfaceInfo[]) {
> > > +        { TYPE_USER_CREATABLE },
> > > +        { }
> > > +    }
> > > +};
> 
> I think this needs TYPE_OBJECT in .parent and
> TYPE_CONFIDENTIAL_GUEST_SUPPORT as an interface to fix the crash.

Except TYPE_CONFIDENTIAL_GUEST_SUPPORT is declared as an object, not
an interface. Clearly something in this series is wrong though, as
the ppc impl uses it as if it were an interface. 

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

