Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843012F2C08
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 10:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388733AbhALJ6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 04:58:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726223AbhALJ6A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 04:58:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610445394;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=EoTYF3Nqzmbw5uYQk5er+PvY1Ren6/rSY6QOq324q5M=;
        b=Y77th/+dosejHvIUCC+sdW+dF9mmB1v5j5HkaXhaVjWk7SrD9X7yz6Y66IzxjZPXnYVyNM
        VnCXcnQ9RG9YgI3wWbpE6grTlkfmSohdC2v/XF6ZY+eQg2JBuIS+Qvh9rXyY86y/vW2qP1
        cwi7ixHbd8h40z9Q1F9ZApdXC6Zm+oY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-kqjjbDiVO2e2GbaY_oj61g-1; Tue, 12 Jan 2021 04:56:29 -0500
X-MC-Unique: kqjjbDiVO2e2GbaY_oj61g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8035803622;
        Tue, 12 Jan 2021 09:56:26 +0000 (UTC)
Received: from redhat.com (ovpn-115-107.ams2.redhat.com [10.36.115.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 70EEC10016F5;
        Tue, 12 Jan 2021 09:56:15 +0000 (UTC)
Date:   Tue, 12 Jan 2021 09:56:12 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org, andi.kleen@intel.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 10/13] spapr: Add PEF based confidential guest support
Message-ID: <20210112095612.GE1360503@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-11-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210112044508.427338-11-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 03:45:05PM +1100, David Gibson wrote:
> Some upcoming POWER machines have a system called PEF (Protected
> Execution Facility) which uses a small ultravisor to allow guests to
> run in a way that they can't be eavesdropped by the hypervisor.  The
> effect is roughly similar to AMD SEV, although the mechanisms are
> quite different.
> 
> Most of the work of this is done between the guest, KVM and the
> ultravisor, with little need for involvement by qemu.  However qemu
> does need to tell KVM to allow secure VMs.
> 
> Because the availability of secure mode is a guest visible difference
> which depends on having the right hardware and firmware, we don't
> enable this by default.  In order to run a secure guest you need to
> create a "pef-guest" object and set the confidential-guest-support
> property to point to it.
> 
> Note that this just *allows* secure guests, the architecture of PEF is
> such that the guest still needs to talk to the ultravisor to enter
> secure mode.  Qemu has no directl way of knowing if the guest is in
> secure mode, and certainly can't know until well after machine
> creation time.
> 
> To start a PEF-capable guest, use the command line options:
>     -object pef-guest,id=pef0 -machine confidential-guest-support=pef0
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  docs/confidential-guest-support.txt |   2 +
>  docs/papr-pef.txt                   |  30 ++++++++
>  hw/ppc/meson.build                  |   1 +
>  hw/ppc/pef.c                        | 115 ++++++++++++++++++++++++++++
>  hw/ppc/spapr.c                      |  10 +++
>  include/hw/ppc/pef.h                |  26 +++++++
>  target/ppc/kvm.c                    |  18 -----
>  target/ppc/kvm_ppc.h                |   6 --
>  8 files changed, 184 insertions(+), 24 deletions(-)
>  create mode 100644 docs/papr-pef.txt
>  create mode 100644 hw/ppc/pef.c
>  create mode 100644 include/hw/ppc/pef.h
> 

> +static const TypeInfo pef_guest_info = {
> +    .parent = TYPE_OBJECT,
> +    .name = TYPE_PEF_GUEST,
> +    .instance_size = sizeof(PefGuestState),
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_CONFIDENTIAL_GUEST_SUPPORT },
> +        { TYPE_USER_CREATABLE },
> +        { }
> +    }
> +};

IIUC, the earlier patch defines TYPE_CONFIDENTIAL_GUEST_SUPPORT
as a object, but you're using it as an interface here. The later
s390 patch uses it as a parent, which makes more sense given it
is a declared as an object.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

