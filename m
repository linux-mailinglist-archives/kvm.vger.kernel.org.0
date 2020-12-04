Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2109A2CEEA4
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgLDNJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 08:09:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726257AbgLDNJM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 08:09:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607087266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PoCy07Jhx9ZhLB65FF7tvAhqv4jMjLhVcKJsuwA2TV8=;
        b=MR6IxcSZpT3IkupSTSHirLWioMw+O/Abcq2GthPYRCt79PsL9jg7UDrq4chqgrKRqZJvW2
        QdrSr/1uLjvVTajTzqTmeX78zg//pEiqikskXALoC89r6gnhaRJrDQ3A/2ekYSzSMlZEqS
        bxv3sBXJaW/EmCTGOgeKNU7QhyszQm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-rUVhyzMJNXuJdqsgKAkCag-1; Fri, 04 Dec 2020 08:07:42 -0500
X-MC-Unique: rUVhyzMJNXuJdqsgKAkCag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C4211005504;
        Fri,  4 Dec 2020 13:07:40 +0000 (UTC)
Received: from work-vm (ovpn-114-202.ams2.redhat.com [10.36.114.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71F1F5D9CA;
        Fri,  4 Dec 2020 13:07:30 +0000 (UTC)
Date:   Fri, 4 Dec 2020 13:07:27 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, brijesh.singh@amd.com,
        qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-ppc@nongnu.org, rth@twiddle.net, thuth@redhat.com,
        berrange@redhat.com, mdroth@linux.vnet.ibm.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org, pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
Message-ID: <20201204130727.GD2883@work-vm>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
 <20201204140205.66e205da.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204140205.66e205da.cohuck@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Cornelia Huck (cohuck@redhat.com) wrote:
> On Fri, 4 Dec 2020 09:06:50 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > On 04.12.20 06:44, David Gibson wrote:
> > > A number of hardware platforms are implementing mechanisms whereby the
> > > hypervisor does not have unfettered access to guest memory, in order
> > > to mitigate the security impact of a compromised hypervisor.
> > > 
> > > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > > to accomplish this in a different way, using a new memory protection
> > > level plus a small trusted ultravisor.  s390 also has a protected
> > > execution environment.
> > > 
> > > The current code (committed or draft) for these features has each
> > > platform's version configured entirely differently.  That doesn't seem
> > > ideal for users, or particularly for management layers.
> > > 
> > > AMD SEV introduces a notionally generic machine option
> > > "machine-encryption", but it doesn't actually cover any cases other
> > > than SEV.
> > > 
> > > This series is a proposal to at least partially unify configuration
> > > for these mechanisms, by renaming and generalizing AMD's
> > > "memory-encryption" property.  It is replaced by a
> > > "securable-guest-memory" property pointing to a platform specific  
> > 
> > Can we do "securable-guest" ?
> > s390x also protects registers and integrity. memory is only one piece
> > of the puzzle and what we protect might differ from platform to 
> > platform.
> > 
> 
> I agree. Even technologies that currently only do memory encryption may
> be enhanced with more protections later.

There's already SEV-ES patches onlist for this on the SEV side.

<sigh on haggling over the name>

Perhaps 'confidential guest' is actually what we need, since the
marketing folks seem to have started labelling this whole idea
'confidential computing'.

Dave
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

