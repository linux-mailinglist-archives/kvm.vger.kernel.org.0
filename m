Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591FE2CEE94
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 14:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgLDNER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 08:04:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726024AbgLDNEQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 08:04:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607086970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=59X3aab27f3awYI+rGEwZiscQBjw1qgK2xysv2laeaI=;
        b=KpY1F0doNMTlFgRA3jOczytyYb19hpXp7gbeJSB36FgpP9vH2oxA+4jABQ2kjYYDfYkror
        t0Nj07ZLFPrMbmgG1E4Kj5THGzrPZbadDA2Z02YqoUUediFPKyQF4OVGiUGBtZsm7xDjLQ
        KPYxG+9tljBWJKK67BRZ2zwMHDDS27U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-GRo6l-eBPd62plelxZupKQ-1; Fri, 04 Dec 2020 08:02:46 -0500
X-MC-Unique: GRo6l-eBPd62plelxZupKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0F6218C8C12;
        Fri,  4 Dec 2020 13:02:43 +0000 (UTC)
Received: from gondolin (ovpn-113-97.ams2.redhat.com [10.36.113.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23F085D9CA;
        Fri,  4 Dec 2020 13:02:07 +0000 (UTC)
Date:   Fri, 4 Dec 2020 14:02:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, brijesh.singh@amd.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org, pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
Message-ID: <20201204140205.66e205da.cohuck@redhat.com>
In-Reply-To: <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Dec 2020 09:06:50 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 04.12.20 06:44, David Gibson wrote:
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> > 
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.
> > 
> > The current code (committed or draft) for these features has each
> > platform's version configured entirely differently.  That doesn't seem
> > ideal for users, or particularly for management layers.
> > 
> > AMD SEV introduces a notionally generic machine option
> > "machine-encryption", but it doesn't actually cover any cases other
> > than SEV.
> > 
> > This series is a proposal to at least partially unify configuration
> > for these mechanisms, by renaming and generalizing AMD's
> > "memory-encryption" property.  It is replaced by a
> > "securable-guest-memory" property pointing to a platform specific  
> 
> Can we do "securable-guest" ?
> s390x also protects registers and integrity. memory is only one piece
> of the puzzle and what we protect might differ from platform to 
> platform.
> 

I agree. Even technologies that currently only do memory encryption may
be enhanced with more protections later.

