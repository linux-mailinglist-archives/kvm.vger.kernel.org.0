Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A53402812
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 13:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245641AbhIGLyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 07:54:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244986AbhIGLyF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 07:54:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631015579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bDMFQmF9abA7FH3kW22IoOdwgo0kVH6NuYbQllxE+Qk=;
        b=S5nA6tr0JXmvn+aTe24RzA/Izj/SeVZBzwuN0m7rNMT/GQnS4F51hBvIjJv/+36KJdiSR6
        +pLKEjZriV0aE7RxGil3C+n0lWRyDmhR47xgSQgySxHM4B9oF1CVXlXXNoPT8+66ud3WXK
        QxdnbV41Mkm6r1Co3PG3d2bUSEjmOuk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-op2HHrMtOi-J6z4ZVCQ6Iw-1; Tue, 07 Sep 2021 07:52:58 -0400
X-MC-Unique: op2HHrMtOi-J6z4ZVCQ6Iw-1
Received: by mail-wm1-f72.google.com with SMTP id m16-20020a7bca50000000b002ee5287d4bfso1003971wml.7
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 04:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=bDMFQmF9abA7FH3kW22IoOdwgo0kVH6NuYbQllxE+Qk=;
        b=P8fTFLrxFFRPpTxVYKNzsohrYH2hoh7S+QHZQko2roSdE0xvQPUzV6fb+dWPslu6Ik
         GMMX3h2zrtuHJrq2hRTOC9ni+yI+xYmM43UfWFlC7eWS3ZtOLRv+r8YJ+25jmuJBATcM
         2XlSW+mveNRlQYXU/pVEWc9b+jX/2spposom3ixdM9EIVf5PYq7ZCg01xeKgixYPVA9W
         Ly8b0k1UxaCLawfYRD9hm5k2w39+AyJ+XtJ2iHTrL9Q7Y8wKe/6IKiGP7fDRQK4j3hk1
         nYoYRjCJG/7HmhiWnXWNw7oz2TB+3r3wVrB1vvBp4Y61uCsKZhIPXEkV7eiGhfx+gamd
         /sVA==
X-Gm-Message-State: AOAM5308TIXMqPdUw9z92hnAnt5a7syTaLd2OxFHecC43StHidSNy4Ou
        bg2Dqb0bdKjEvulI1gnKOWQaozASCAW7MAwNj5pb1BGvhiB1V8JwwVN71HseXF3xG+c128qDzm9
        4rQh0RJNldoez
X-Received: by 2002:a1c:7515:: with SMTP id o21mr3545408wmc.150.1631015576848;
        Tue, 07 Sep 2021 04:52:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHxe4yH6ilYBJA3hJkKY2poll1mO2ckp+SxguAMhtTrGcUJkvFGJmhevvElBczEpLytn66rA==
X-Received: by 2002:a1c:7515:: with SMTP id o21mr3545390wmc.150.1631015576666;
        Tue, 07 Sep 2021 04:52:56 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id f25sm479560wml.38.2021.09.07.04.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 04:52:56 -0700 (PDT)
Date:   Tue, 7 Sep 2021 12:52:54 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [RFC PATCH v2 12/12] i386/sev: update query-sev QAPI format to
 handle SEV-SNP
Message-ID: <YTdSlg5NymDQex5T@work-vm>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-13-michael.roth@amd.com>
 <87tuj4qt71.fsf@dusky.pond.sub.org>
 <YTJGzrnqO9vzUqNq@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YTJGzrnqO9vzUqNq@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Daniel P. Berrangé (berrange@redhat.com) wrote:
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
> IIUC you can only reach scenario (3) if you have created a guest
> using '-object sev-snp-guest', which is a new feature introduced
> in patch 2.
> 
> IOW, scenario (3)  old mgmt app + new QEMU + sev-snp guest does
> not exist as a combination. Thus the (bad) field is actually (n/a)
> 
> So I believe this proposed change is acceptable in all scenarios
> with existing deployed usage, as well as all newly introduced
> scenarios.

I wonder if it's worth going firther and renaming 'policy' in the 
SNP world to 'snppolicy' just to reduce the risk of accidentally
specifying the wrong one.

Dave

> Regards,
> Daniel
> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

