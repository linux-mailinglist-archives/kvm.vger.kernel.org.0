Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF84C2F64B5
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 16:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbhANPeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 10:34:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45542 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbhANPep (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 10:34:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610638399;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EtNuM8olaR7jZ6oi91Dt8+iP5QBXiEIcQy8JQqXwuNI=;
        b=amzjBS/ba6N5BwbLqmKy/U/a0O3e10B7jFIzME1w1G0Zcs3gyyCRvxF+EjFxptS+HR++RI
        9aLoic+36m36wwUm8JON0xRiECibduJHt8MXZ7ciyMCsCMaGiau9BTSxhNAK+bKCrg6DHH
        OzTmsvkgi3xbDXSrn9uj/lyMhWdd0Eo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-boN0XtuPNMyN0H2WksQqMQ-1; Thu, 14 Jan 2021 10:33:17 -0500
X-MC-Unique: boN0XtuPNMyN0H2WksQqMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34338100F340;
        Thu, 14 Jan 2021 15:33:15 +0000 (UTC)
Received: from redhat.com (ovpn-115-77.ams2.redhat.com [10.36.115.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 068E918AD6;
        Thu, 14 Jan 2021 15:33:03 +0000 (UTC)
Date:   Thu, 14 Jan 2021 15:33:01 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Boris Fiuczynski <fiuczy@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, pair@us.ibm.com,
        Marcelo Tosatti <mtosatti@redhat.com>, brijesh.singh@amd.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        david@redhat.com, Ram Pai <linuxram@us.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, pbonzini@redhat.com, thuth@redhat.com,
        rth@twiddle.net, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20210114153301.GL1643043@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210114103643.GD2905@work-vm>
 <db2295ce-333f-2a3e-8219-bfa4853b256f@de.ibm.com>
 <20210114120531.3c7f350e.cohuck@redhat.com>
 <20210114114533.GF2905@work-vm>
 <b791406c-fde2-89db-4186-e1660f14418c@de.ibm.com>
 <20210114122048.GG1643043@redhat.com>
 <20210114150422.5f74ca41.cohuck@redhat.com>
 <b0084527-97b3-3174-d988-bf0f6d6221fd@de.ibm.com>
 <20210114141535.GJ1643043@redhat.com>
 <e13aad37-97ba-de1b-f311-cd37044c1809@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e13aad37-97ba-de1b-f311-cd37044c1809@de.ibm.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 04:25:21PM +0100, Christian Borntraeger wrote:
> On 14.01.21 15:15, Daniel P. Berrangé wrote:
> > On Thu, Jan 14, 2021 at 03:09:01PM +0100, Christian Borntraeger wrote:
> >>
> >>
> >> On 14.01.21 15:04, Cornelia Huck wrote:
> >>
> >> What about a libvirt change that removes the unpack from the host-model as 
> >> soon as  only-migrateable is used. When that is in place, QEMU can reject
> >> the combination of only-migrateable + unpack.
> > 
> > I think libvirt needs to just unconditionally remove unpack from host-model
> > regardless, and require an explicit opt in. We can do that in libvirt
> > without compat problems, because we track the expansion of "host-model"
> > for existing running guests.
> 
> This is true for running guests, but not for shutdown and restart.
> 
> I would really like to avoid bad (and hard to debug) surprises that a guest boots
> fine with libvirt version x and then fail with x+1. So at the beginning
> I am fine with libvirt removing "unpack" from the default host model expansion
> if the --only-migrateable parameter is used. Now I look into libvirt and I 
> cannot actually find code that uses this parameter. Are there some patches
> posted somewhere?

Sorryy, I should have been clearer that we don't currently use
--only-migrateable.  I've been talking from the pov of the effects
if we were to introduce it into libvirt.

The way it would work would be for  'virsh start FOO' to start the guest
unconditionally, while  'virsh start --migratable FOO' would start the
same guest config but fail if it used a non-migratable feature. We need
the guest ABI to be the same in both cases.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

