Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98C04002C1
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349788AbhICP7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:59:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235851AbhICP7l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 11:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630684720;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AotTT4cFDUcxarYUeWBvMDYMrkfWVw5v2aHjM+zv9gE=;
        b=Etc1VnVZejCzgTzL1D6ab6sMxFXMpV8MuMJ5HxiTvvozLLgF1RvwDfWGiC8SEJreDofNJR
        R2fGIrqOkdpkvXgs1aLHfpxPjvOH1D3kAd5ZzpToBQqWjaGR+PAN2r3qMZz9s7ofSPKCtZ
        ZEZbfPuf4bBVyBa9To5nqFH8haeei7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-xeEMUaq1OEC0G4Dj7tGyXw-1; Fri, 03 Sep 2021 11:58:39 -0400
X-MC-Unique: xeEMUaq1OEC0G4Dj7tGyXw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9155884A5ED;
        Fri,  3 Sep 2021 15:58:37 +0000 (UTC)
Received: from redhat.com (unknown [10.39.193.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A58460BF1;
        Fri,  3 Sep 2021 15:58:08 +0000 (UTC)
Date:   Fri, 3 Sep 2021 16:58:05 +0100
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
Message-ID: <YTJGDS9/8W7xVyqQ@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-13-michael.roth@amd.com>
 <87tuj4qt71.fsf@dusky.pond.sub.org>
 <20210903151316.zveiegbo42o2gttq@amd.com>
 <YTI/qB4uk477/lQP@redhat.com>
 <20210903154319.zxvgccxayjoabtck@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210903154319.zxvgccxayjoabtck@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 10:43:19AM -0500, Michael Roth wrote:
> On Fri, Sep 03, 2021 at 04:30:48PM +0100, Daniel P. Berrangé wrote:
> > On Fri, Sep 03, 2021 at 10:13:16AM -0500, Michael Roth wrote:
> > > On Wed, Sep 01, 2021 at 04:14:10PM +0200, Markus Armbruster wrote:
> > > > Michael Roth <michael.roth@amd.com> writes:
> > > > 
> > > > > Most of the current 'query-sev' command is relevant to both legacy
> > > > > SEV/SEV-ES guests and SEV-SNP guests, with 2 exceptions:
> > > > >
> > > > >   - 'policy' is a 64-bit field for SEV-SNP, not 32-bit, and
> > > > >     the meaning of the bit positions has changed
> > > > >   - 'handle' is not relevant to SEV-SNP
> > > > >
> > > > > To address this, this patch adds a new 'sev-type' field that can be
> > > > > used as a discriminator to select between SEV and SEV-SNP-specific
> > > > > fields/formats without breaking compatibility for existing management
> > > > > tools (so long as management tools that add support for launching
> > > > > SEV-SNP guest update their handling of query-sev appropriately).
> > > > 
> > > > Technically a compatibility break: query-sev can now return an object
> > > > that whose member @policy has different meaning, and also lacks @handle.
> > > > 
> > > > Matrix:
> > > > 
> > > >                             Old mgmt app    New mgmt app
> > > >     Old QEMU, SEV/SEV-ES       good            good(1)
> > > >     New QEMU, SEV/SEV-ES       good(2)         good
> > > >     New QEMU, SEV-SNP           bad(3)         good
> > > > 
> > > > Notes:
> > > > 
> > > > (1) As long as the management application can cope with absent member
> > > > @sev-type.
> > > > 
> > > > (2) As long as the management application ignores unknown member
> > > > @sev-type.
> > > > 
> > > > (3) Management application may choke on missing member @handle, or
> > > > worse, misinterpret member @policy.  Can only happen when something
> > > > other than the management application created the SEV-SNP guest (or the
> > > > user somehow made the management application create one even though it
> > > > doesn't know how, say with CLI option passthrough, but that's always
> > > > fragile, and I wouldn't worry about it here).
> > > > 
> > > > I think (1) and (2) are reasonable.  (3) is an issue for management
> > > > applications that support attaching to existing guests.  Thoughts?
> > > 
> > > Hmm... yah I hadn't considering 'old mgmt' trying to interact with a SNP
> > > guest started through some other means.
> > > 
> > > Don't really see an alternative other than introducing a new
> > > 'query-sev-snp', but that would still leave 'old mgmt' broken, since
> > > it might still call do weird stuff like try to interpret the SNP policy
> > > as an SEV/SEV-ES and end up with some very unexpected results. So if I
> > > did go this route, I would need to have QMP begin returning an error if
> > > query-sev is run against an SNP guest. But currently for non-SEV guests
> > > it already does:
> > > 
> > >   error_setg(errp, "SEV feature is not available")
> > > 
> > > so 'old mgmt' should be able to handle the error just fine.
> > > 
> > > Would that approach be reasonable?
> > 
> > This ties into the question I've just sent in my other mail.
> > 
> > If the hardware strictly requires that guest are created in SEV-SNP
> > mode only, and will not support SEV/SEV-ES mode, then we need to
> > ensure "query-sev" reports the feature as not-available, so that
> > existing mgmt apps don't try to use SEV/SEV-ES.
> 
> An SEV-SNP-capable host can run both 'legacy' SEV/SEV-ES, as well as
> SEV-SNP guests, at the same time. But as far as QEMU goes, we need
> to specify one or the other explicitly at launch time, via existing
> 'sev-guest', or the new 'sev-snp-guest' ConfidentialGuestSupport type.
> 
> > 
> > If the SEV-SNP hardware is functionally back-compatible with a gues
> > configured in SEV/SEV-ES mode, then we souldn't need a new command,
> > just augment th eexisting command with additional field(s), to
> > indicate existance of SEV-SNP features.
> 
> query-sev-info provides information specific to the guest instance,
> like the configured policy. Are you thinking of query-sev-capabilities,
> which reports some host-wide information and should indeed remain
> available for either case. (and maybe should also be updated to report
> on SEV-SNP availability for the host?)

Oh right, yes, I am getting confused with query-sev-capabilities.

I think this means everything is OK with your query-sev-info
changes proposed here, I'll reply direct to Markus' point though.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

