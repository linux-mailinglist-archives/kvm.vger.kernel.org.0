Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D7D286677
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 20:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgJGSEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 14:04:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727904AbgJGSEq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 14:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602093885;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=hA/Ic/DvHRIWAAPJE/LGTu0E2S1egMhpGna2Sykdi3w=;
        b=gFsoczKD154lsyNb1b3O0vqhlDCSL57YrjDb+A99qai/65XVGYgxQ0BuzhqVwetDNDTpum
        iAhvK0k40ku/7K2vBOS0bIyAQzccdCYymBk7SQdgLmxVqWfs7pDiczmoi6WIwljdGG//jD
        bhQn1d0e8OR+OSKMFx0ZxYJ4Mz+OisM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-6FM-k7x8Mj2c74P_45QdLQ-1; Wed, 07 Oct 2020 14:04:36 -0400
X-MC-Unique: 6FM-k7x8Mj2c74P_45QdLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD39F18C9F59;
        Wed,  7 Oct 2020 18:04:34 +0000 (UTC)
Received: from redhat.com (ovpn-114-68.ams2.redhat.com [10.36.114.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F6C55DA2A;
        Wed,  7 Oct 2020 18:04:32 +0000 (UTC)
Date:   Wed, 7 Oct 2020 19:04:29 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>, John Snow <jsnow@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Markus Armbruster <armbru@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>
Subject: Re: KVM call for agenda for 2020-10-06
Message-ID: <20201007180429.GI2505881@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <874kndm1t3.fsf@secure.mitica>
 <20201005144615.GE5029@stefanha-x1.localdomain>
 <CAJSP0QVZcEQueXG1gjwuLszdUtXWi1tgB5muLL6QHJjNTOmyfQ@mail.gmail.com>
 <8fce8f99-56bd-6a87-9789-325d6ffff54d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8fce8f99-56bd-6a87-9789-325d6ffff54d@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07, 2020 at 07:50:20PM +0200, Paolo Bonzini wrote:
> On 06/10/20 20:21, Stefan Hajnoczi wrote:
> >     * Does command-line order matter?
> >         * Two options: allow any order OR left-to-right ordering
> >         * Andrea Bolognani: Most users expect left-to-right ordering,
> > why allow any order?
> >         * Eduardo Habkost: Can we enforce left-to-right ordering or do
> > we need to follow the deprecation process?
> >         * Daniel Berrange: Solve compability by introducing new
> > binaries without the burden of backwards compability
> 
> I think "new binaries" shouldn't even have a command line; all
> configuration should happen through QMP commands.  Those are naturally
> time-ordered, which is equivalent to left-to-right, and therefore the
> question is sidestepped.  Perhaps even having a command line in
> qemu-storage-daemon was a mistake.

Non-interactive configuration is a nice property for simpler integration
use cases. eg launching from the shell is tedious with QMP compared to
CLI args.

This could be addressed though by having a configuration file to load
config from, where the config entries can be mapped 1-1 onto QMP commands,
essentially making the config file a non-interactive QMP.

> The big question to me is whether the configuration should be
> QAPI-based, that is based on QAPI structs, or QMP-based.  If the latter,
> "object-add" (and to a lesser extent "device-add") are fine mechanisms
> for configuration.  There is still need for better QOM introspection,
> but it would be much simpler than doing QOM object creation via QAPI
> struct, if at all possible.



Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

