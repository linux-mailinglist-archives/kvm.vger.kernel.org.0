Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF35140025E
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349711AbhICPcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:32:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349680AbhICPcE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 11:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630683063;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=CzPb8MlbLx41oQqysfJ8QyV0MvR1gCZguZRQ8mTaaK4=;
        b=DNgksK0re68B9R4HvVKec8qIYNj6Fi6d9BilBx0sd6ArJ+M6lFxXuxVKT0oZrhO4wlSkw7
        8oiqN/c7y3OmNaRrV0q9BlDYes8GSotjn1i+ENJlO6bfpxDVUf9sQXIvFmFf9o6JQIxSJA
        MAViJvuh8+YNxvgwdjJLL+C2rwkqikQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-uJrZ-_7SOISk6KCCwMLCZQ-1; Fri, 03 Sep 2021 11:31:02 -0400
X-MC-Unique: uJrZ-_7SOISk6KCCwMLCZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DC9384A5E1;
        Fri,  3 Sep 2021 15:31:01 +0000 (UTC)
Received: from redhat.com (unknown [10.39.193.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A27195D9D3;
        Fri,  3 Sep 2021 15:30:50 +0000 (UTC)
Date:   Fri, 3 Sep 2021 16:30:48 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>, qemu-devel@nongnu.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC PATCH v2 12/12] i386/sev: update query-sev QAPI format to
 handle SEV-SNP
Message-ID: <YTI/qB4uk477/lQP@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-13-michael.roth@amd.com>
 <87tuj4qt71.fsf@dusky.pond.sub.org>
 <20210903151316.zveiegbo42o2gttq@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210903151316.zveiegbo42o2gttq@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 10:13:16AM -0500, Michael Roth wrote:
> On Wed, Sep 01, 2021 at 04:14:10PM +0200, Markus Armbruster wrote:
> > Michael Roth <michael.roth@amd.com> writes:
> > 
> > > Most of the current 'query-sev' command is relevant to both legacy
> > > SEV/SEV-ES guests and SEV-SNP guests, with 2 exceptions:
> > >
> > >   - 'policy' is a 64-bit field for SEV-SNP, not 32-bit, and
> > >     the meaning of the bit positions has changed
> > >   - 'handle' is not relevant to SEV-SNP
> > >
> > > To address this, this patch adds a new 'sev-type' field that can be
> > > used as a discriminator to select between SEV and SEV-SNP-specific
> > > fields/formats without breaking compatibility for existing management
> > > tools (so long as management tools that add support for launching
> > > SEV-SNP guest update their handling of query-sev appropriately).
> > 
> > Technically a compatibility break: query-sev can now return an object
> > that whose member @policy has different meaning, and also lacks @handle.
> > 
> > Matrix:
> > 
> >                             Old mgmt app    New mgmt app
> >     Old QEMU, SEV/SEV-ES       good            good(1)
> >     New QEMU, SEV/SEV-ES       good(2)         good
> >     New QEMU, SEV-SNP           bad(3)         good
> > 
> > Notes:
> > 
> > (1) As long as the management application can cope with absent member
> > @sev-type.
> > 
> > (2) As long as the management application ignores unknown member
> > @sev-type.
> > 
> > (3) Management application may choke on missing member @handle, or
> > worse, misinterpret member @policy.  Can only happen when something
> > other than the management application created the SEV-SNP guest (or the
> > user somehow made the management application create one even though it
> > doesn't know how, say with CLI option passthrough, but that's always
> > fragile, and I wouldn't worry about it here).
> > 
> > I think (1) and (2) are reasonable.  (3) is an issue for management
> > applications that support attaching to existing guests.  Thoughts?
> 
> Hmm... yah I hadn't considering 'old mgmt' trying to interact with a SNP
> guest started through some other means.
> 
> Don't really see an alternative other than introducing a new
> 'query-sev-snp', but that would still leave 'old mgmt' broken, since
> it might still call do weird stuff like try to interpret the SNP policy
> as an SEV/SEV-ES and end up with some very unexpected results. So if I
> did go this route, I would need to have QMP begin returning an error if
> query-sev is run against an SNP guest. But currently for non-SEV guests
> it already does:
> 
>   error_setg(errp, "SEV feature is not available")
> 
> so 'old mgmt' should be able to handle the error just fine.
> 
> Would that approach be reasonable?

This ties into the question I've just sent in my other mail.

If the hardware strictly requires that guest are created in SEV-SNP
mode only, and will not support SEV/SEV-ES mode, then we need to
ensure "query-sev" reports the feature as not-available, so that
existing mgmt apps don't try to use SEV/SEV-ES.

If the SEV-SNP hardware is functionally back-compatible with a gues
configured in SEV/SEV-ES mode, then we souldn't need a new command,
just augment th eexisting command with additional field(s), to
indicate existance of SEV-SNP features.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

