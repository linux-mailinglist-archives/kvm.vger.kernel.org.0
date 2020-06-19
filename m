Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216462005AD
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 11:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732225AbgFSJpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 05:45:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57977 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729718AbgFSJpr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 05:45:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592559945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=girqsAB7scwypOzLVrMu9QZwQRjdhR1EvBT/sBZ/kQQ=;
        b=a7fZfDOrVPqFsFsI0lNQ3EN18QSt77q1n3NIps+jqCtpOWCiiOVkBruIibr/zWM8anH+Gn
        McmCUTIhiJCYf3OjEWhTj1I9eAfTLL5oeJrCEWly1yWXLCzKPdE1cS5UFI0tR6EBiML+DU
        NNLfACLUKCPeOR2kK5d4bAwq67STGYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-31x90bOgOwuXqNM715sfcg-1; Fri, 19 Jun 2020 05:45:44 -0400
X-MC-Unique: 31x90bOgOwuXqNM715sfcg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A1588015CB;
        Fri, 19 Jun 2020 09:45:42 +0000 (UTC)
Received: from gondolin (ovpn-112-224.ams2.redhat.com [10.36.112.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D6BD7C1E8;
        Fri, 19 Jun 2020 09:45:29 +0000 (UTC)
Date:   Fri, 19 Jun 2020 11:45:26 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200619114526.6a6f70c6.cohuck@redhat.com>
In-Reply-To: <e045e202-cd56-4ddc-8c1d-a2fe5a799d32@redhat.com>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
        <e045e202-cd56-4ddc-8c1d-a2fe5a799d32@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Jun 2020 10:28:22 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 19.06.20 04:05, David Gibson wrote:
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> > 
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.  
> 
> Each architecture finds its own way to vandalize the original
> architecture, some in more extreme/obscure ways than others. I guess in
> the long term we'll regret most of that, but what do I know :)
> 
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
> > "host-trust-limitation" property pointing to a platform specific
> > object which configures and manages the specific details.
> >   
> 
> I consider the property name sub-optimal. Yes, I am aware that there are
> other approaches being discussed on the KVM list to disallow access to
> guest memory without memory encryption. (most of them sound like people
> are trying to convert KVM into XEN, but again, what do I know ... :)  )
> 
> "host-trust-limitation"  sounds like "I am the hypervisor, I configure
> limited trust into myself". Also, "untrusted-host" would be a little bit
> nicer (I think trust is a black/white thing).
> 
> However, once we have multiple options to protect a guest (memory
> encryption, unmapping guest pages ,...) the name will no longer really
> suffice to configure QEMU, no?

Hm... we could have a property that accepts bits indicating where the
actual limitation lies. Different parts of the code could then make
more fine-grained decisions of what needs to be done. Feels a bit
overengineered today; but maybe there's already stuff with different
semantics in the pipeline somewhere?

> 
> > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > can be extended to cover the Intel and s390 mechanisms as well,
> > though.  
> 
> The only approach on s390x to not glue command line properties to the
> cpu model would be to remove the CPU model feature and replace it by the
> command line parameter. But that would, of course, be an incompatible break.

Yuck.

We still need to provide the cpu feature to the *guest* in any case, no?

> 
> How do upper layers actually figure out if memory encryption etc is
> available? on s390x, it's simply via the expanded host CPU model.
> 

