Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001B6453668
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238455AbhKPP4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:56:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238507AbhKPP4K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 10:56:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637077992;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8FaFGs8nf3xBlk5dpJT8caEOeoHk5nOorg1mQkaa9f8=;
        b=aF0e7BDVH522CsrxeSzAB5m8VemcFRk62WmW0XrRMXLAlMpiyuGdAsvbZy52B03eLbgPsh
        Xh5iohvyeJadSO9gqWCwnHKnEstD7qo56Ne4k3obMCuMwNsuG0QxxO357/2vL7Zd3DPbOI
        jDrNmAoHXCnUhVK29Pee3k7XBD6LNqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-Smg062Q2OvOtMCQaSioZZA-1; Tue, 16 Nov 2021 10:53:09 -0500
X-MC-Unique: Smg062Q2OvOtMCQaSioZZA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CAC91DE1D;
        Tue, 16 Nov 2021 15:53:08 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A28035D9DE;
        Tue, 16 Nov 2021 15:53:05 +0000 (UTC)
Date:   Tue, 16 Nov 2021 15:53:02 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Tyler Fanelli <tfanelli@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        armbru@redhat.com, pbonzini@redhat.com, eblake@redhat.com
Subject: Re: [PATCH] sev: allow capabilities to check for SEV-ES support
Message-ID: <YZPT3ojgzdmH3lkq@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20211115193804.294529-1-tfanelli@redhat.com>
 <YZN3OECfHBXd55M5@redhat.com>
 <26204690-493f-67a8-1791-c9c9d38c0240@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26204690-493f-67a8-1791-c9c9d38c0240@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 10:29:35AM -0500, Tyler Fanelli wrote:
> On 11/16/21 4:17 AM, Daniel P. Berrangé wrote:
> > On Mon, Nov 15, 2021 at 02:38:04PM -0500, Tyler Fanelli wrote:
> > > Probe for SEV-ES and SEV-SNP capabilities to distinguish between Rome,
> > > Naples, and Milan processors. Use the CPUID function to probe if a
> > > processor is capable of running SEV-ES or SEV-SNP, rather than if it
> > > actually is running SEV-ES or SEV-SNP.
> > > 
> > > Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> > > ---
> > >   qapi/misc-target.json | 11 +++++++++--
> > >   target/i386/sev.c     |  6 ++++--
> > >   2 files changed, 13 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> > > index 5aa2b95b7d..c3e9bce12b 100644
> > > --- a/qapi/misc-target.json
> > > +++ b/qapi/misc-target.json
> > > @@ -182,13 +182,19 @@
> > >   # @reduced-phys-bits: Number of physical Address bit reduction when SEV is
> > >   #                     enabled
> > >   #
> > > +# @es: SEV-ES capability of the machine.
> > > +#
> > > +# @snp: SEV-SNP capability of the machine.
> > > +#
> > >   # Since: 2.12
> > >   ##
> > >   { 'struct': 'SevCapability',
> > >     'data': { 'pdh': 'str',
> > >               'cert-chain': 'str',
> > >               'cbitpos': 'int',
> > > -            'reduced-phys-bits': 'int'},
> > > +            'reduced-phys-bits': 'int',
> > > +            'es': 'bool',
> > > +            'snp': 'bool'},
> > >     'if': 'TARGET_I386' }
> > >   ##
> > > @@ -205,7 +211,8 @@
> > >   #
> > >   # -> { "execute": "query-sev-capabilities" }
> > >   # <- { "return": { "pdh": "8CCDD8DDD", "cert-chain": "888CCCDDDEE",
> > > -#                  "cbitpos": 47, "reduced-phys-bits": 5}}
> > > +#                  "cbitpos": 47, "reduced-phys-bits": 5
> > > +#                  "es": false, "snp": false}}
> > We've previously had patches posted to support SNP in QEMU
> > 
> >    https://lists.gnu.org/archive/html/qemu-devel/2021-08/msg04761.html
> > 
> > and this included an update to query-sev for reporting info
> > about the VM instance.
> > 
> > Your patch is updating query-sev-capabilities, which is a
> > counterpart for detecting host capabilities separate from
> > a guest instance.
> 
> Yes, that's because with this patch, I'm more interested in determining
> which AMD processor is running on a host, and less if ES or SNP is actually
> running on a guest instance or not.

> > None the less I wonder if the same design questions from
> > query-sev apply. ie do we need to have the ability to
> > report any SNP specific information fields, if so we need
> > to use a discriminated union of structs, not just bool
> > flags.
> > 
> > More generally I'm some what wary of adding this to
> > query-sev-capabilities at all, unless it is part of the
> > main SEV-SNP series.
> > 
> > Also what's the intended usage for the mgmt app from just
> > having these boolean fields ? Are they other more explicit
> > feature flags we should be reporting, instead of what are
> > essentially SEV generation codenames.
> 
> If by "mgmt app" you're referring to sevctl, in order to determine which
> certificate chain to use (Naples vs Rome vs Milan ARK/ASK) we must query
> which processor we are running on. Although sevctl has a feature which can
> do this already, we cannot guarantee that sevctl is running on the same host
> that a VM is running on, so we must query this capability from QEMU. My
> logic was determining the processor would have been the following:

I'm not really talking about a specific, rather any tool which wants
to deal with SEV and QEMU, whether libvirt or an app using libvirt,
or something else using QEMU directly.

Where does the actual cert chain payload come from ? Is that something
the app has to acquire out of band, or can the full cert chain be
acquired from the hardware itself ? 

> !es && !snp --> Naples
> 
> es && !snp --> Rome
> 
> es && snp --> Milan

This approach isn't future proof if subsequent generations introduce
new certs. It feels like we should be explicitly reporting something
about the certs rather than relying on every app to re-implement tihs
logic.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

