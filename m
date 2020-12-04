Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3AA2CEEC3
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 14:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgLDN04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 08:26:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgLDN04 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 08:26:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607088329;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=X/a++xww5bzaRfGpbjrSlypbsSv7INhqHTSBjxbZQlc=;
        b=X6fSz39psvX/BpdUhpe7r6FVBGV8hFcuGi7dG2ySJV/D85dwwVSr2Fuf7Xhwi5rZXvC0cp
        2qukAEtfxexaLQy4l2DBBGG0mNN0mNWMGvJ9PFEHXLumioe2qmOVRHpLjRITQNkcPK5lOW
        53TE1t8iiqkkw8rVutzZz/ZoS8iWliI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-monpTWtON_mFFFUnjNVkCw-1; Fri, 04 Dec 2020 08:25:17 -0500
X-MC-Unique: monpTWtON_mFFFUnjNVkCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 189C1800D55;
        Fri,  4 Dec 2020 13:25:15 +0000 (UTC)
Received: from redhat.com (ovpn-115-10.ams2.redhat.com [10.36.115.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 55A805C22B;
        Fri,  4 Dec 2020 13:25:03 +0000 (UTC)
Date:   Fri, 4 Dec 2020 13:25:00 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org, thuth@redhat.com,
        pbonzini@redhat.com, rth@twiddle.net,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
Message-ID: <20201204132500.GI3056135@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
 <20201204140205.66e205da.cohuck@redhat.com>
 <20201204130727.GD2883@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201204130727.GD2883@work-vm>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 04, 2020 at 01:07:27PM +0000, Dr. David Alan Gilbert wrote:
> * Cornelia Huck (cohuck@redhat.com) wrote:
> > On Fri, 4 Dec 2020 09:06:50 +0100
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > 
> > > On 04.12.20 06:44, David Gibson wrote:
> > > > A number of hardware platforms are implementing mechanisms whereby the
> > > > hypervisor does not have unfettered access to guest memory, in order
> > > > to mitigate the security impact of a compromised hypervisor.
> > > > 
> > > > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > > > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > > > to accomplish this in a different way, using a new memory protection
> > > > level plus a small trusted ultravisor.  s390 also has a protected
> > > > execution environment.
> > > > 
> > > > The current code (committed or draft) for these features has each
> > > > platform's version configured entirely differently.  That doesn't seem
> > > > ideal for users, or particularly for management layers.
> > > > 
> > > > AMD SEV introduces a notionally generic machine option
> > > > "machine-encryption", but it doesn't actually cover any cases other
> > > > than SEV.
> > > > 
> > > > This series is a proposal to at least partially unify configuration
> > > > for these mechanisms, by renaming and generalizing AMD's
> > > > "memory-encryption" property.  It is replaced by a
> > > > "securable-guest-memory" property pointing to a platform specific  
> > > 
> > > Can we do "securable-guest" ?
> > > s390x also protects registers and integrity. memory is only one piece
> > > of the puzzle and what we protect might differ from platform to 
> > > platform.
> > > 
> > 
> > I agree. Even technologies that currently only do memory encryption may
> > be enhanced with more protections later.
> 
> There's already SEV-ES patches onlist for this on the SEV side.
> 
> <sigh on haggling over the name>
> 
> Perhaps 'confidential guest' is actually what we need, since the
> marketing folks seem to have started labelling this whole idea
> 'confidential computing'.

I think we shouldn't worry about the specific name too much, as it
won't be visible much outside QEMU and the internals of the immediate
layer above such as libvirt. What matters much more is that we have
documentation that clearly explains what the different levels of
protection are for each different architecture, and/or generation of
architecture. Mgmt apps / end users need understand exactly what
kind of unicorns they are being promised for a given configuration.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

