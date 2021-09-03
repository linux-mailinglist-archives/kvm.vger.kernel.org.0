Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F78D4002D1
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbhICQCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 12:02:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349865AbhICQCf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 12:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630684894;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=ybHw7U4g3iVRZxIp5kFJ8XRmPMWIYv/Oqv8Fl2TUX8o=;
        b=NYZzEOjlU3Fwxl/z0vi6mpys/wLJ51NjIg8yZzE1/n6egZvdFxF4pnqpOOS9mtvb8qeJA3
        Ib4Z2E6GBwokvWo1zR6wIueq+oH7E0/GryK9W3qz9nijIfsg9CZ1KiaRjeubGchnh9I0fS
        mxsrJINgWC4m1PM9fiL/hahgfiPfa2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-gofoRV0fOo-HWvDl8q6ZYg-1; Fri, 03 Sep 2021 12:01:30 -0400
X-MC-Unique: gofoRV0fOo-HWvDl8q6ZYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7D01DF8A5;
        Fri,  3 Sep 2021 16:01:28 +0000 (UTC)
Received: from redhat.com (unknown [10.39.193.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52B7D19C59;
        Fri,  3 Sep 2021 16:01:21 +0000 (UTC)
Date:   Fri, 3 Sep 2021 17:01:18 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [RFC PATCH v2 12/12] i386/sev: update query-sev QAPI format to
 handle SEV-SNP
Message-ID: <YTJGzrnqO9vzUqNq@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-13-michael.roth@amd.com>
 <87tuj4qt71.fsf@dusky.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87tuj4qt71.fsf@dusky.pond.sub.org>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 04:14:10PM +0200, Markus Armbruster wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > Most of the current 'query-sev' command is relevant to both legacy
> > SEV/SEV-ES guests and SEV-SNP guests, with 2 exceptions:
> >
> >   - 'policy' is a 64-bit field for SEV-SNP, not 32-bit, and
> >     the meaning of the bit positions has changed
> >   - 'handle' is not relevant to SEV-SNP
> >
> > To address this, this patch adds a new 'sev-type' field that can be
> > used as a discriminator to select between SEV and SEV-SNP-specific
> > fields/formats without breaking compatibility for existing management
> > tools (so long as management tools that add support for launching
> > SEV-SNP guest update their handling of query-sev appropriately).
> 
> Technically a compatibility break: query-sev can now return an object
> that whose member @policy has different meaning, and also lacks @handle.
> 
> Matrix:
> 
>                             Old mgmt app    New mgmt app
>     Old QEMU, SEV/SEV-ES       good            good(1)
>     New QEMU, SEV/SEV-ES       good(2)         good
>     New QEMU, SEV-SNP           bad(3)         good
> 
> Notes:
> 
> (1) As long as the management application can cope with absent member
> @sev-type.
> 
> (2) As long as the management application ignores unknown member
> @sev-type.
> 
> (3) Management application may choke on missing member @handle, or
> worse, misinterpret member @policy.  Can only happen when something
> other than the management application created the SEV-SNP guest (or the
> user somehow made the management application create one even though it
> doesn't know how, say with CLI option passthrough, but that's always
> fragile, and I wouldn't worry about it here).
> 
> I think (1) and (2) are reasonable.  (3) is an issue for management
> applications that support attaching to existing guests.  Thoughts?

IIUC you can only reach scenario (3) if you have created a guest
using '-object sev-snp-guest', which is a new feature introduced
in patch 2.

IOW, scenario (3)  old mgmt app + new QEMU + sev-snp guest does
not exist as a combination. Thus the (bad) field is actually (n/a)

So I believe this proposed change is acceptable in all scenarios
with existing deployed usage, as well as all newly introduced
scenarios.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

