Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC3D3ED8DD
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhHPOYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:24:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229880AbhHPOYk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 10:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629123845;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=TU9WQqclCj5JWpeWLZIR7qY0KU/ywm/jjSLxeA7lujc=;
        b=LWhVsap6Ikb0Pfvke8ffZ9dGkSf9T5eqbHAnDZgcJVpArv1LYrDKUbUutX31erncWAhRQ5
        lLKuCA6GMi7n+/98LjbdVwMnu3IdiWUZqXNZ56kD3+3NkcWQPo2aPVjH83AoHNqv7EaAz3
        hJhb9mTgfeT2GkS/qFf1AH/aafYG5aw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-GDv6rcngPZi8eOuy76aKWQ-1; Mon, 16 Aug 2021 10:24:02 -0400
X-MC-Unique: GDv6rcngPZi8eOuy76aKWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D94F800493;
        Mon, 16 Aug 2021 14:24:00 +0000 (UTC)
Received: from redhat.com (unknown [10.39.192.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EFE75D9D3;
        Mon, 16 Aug 2021 14:23:52 +0000 (UTC)
Date:   Mon, 16 Aug 2021 15:23:50 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, qemu-devel@nongnu.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        tobin@ibm.com, jejb@linux.ibm.com, richard.henderson@linaro.org,
        frankeh@us.ibm.com, dgilbert@redhat.com,
        dovmurik@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YRp09sXRaNPefs2g@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 04:15:46PM +0200, Paolo Bonzini wrote:
> On 16/08/21 15:25, Ashish Kalra wrote:
> > From: Ashish Kalra<ashish.kalra@amd.com>
> > 
> > This is an RFC series for Mirror VM support that are
> > essentially secondary VMs sharing the encryption context
> > (ASID) with a primary VM. The patch-set creates a new
> > VM and shares the primary VM's encryption context
> > with it using the KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability.
> > The mirror VM uses a separate pair of VM + vCPU file
> > descriptors and also uses a simplified KVM run loop,
> > for example, it does not support any interrupt vmexit's. etc.
> > Currently the mirror VM shares the address space of the
> > primary VM.
> > 
> > The mirror VM can be used for running an in-guest migration
> > helper (MH). It also might have future uses for other in-guest
> > operations.
> 

snip

> With this implementation, the number of mirror vCPUs does not even have to
> be indicated on the command line.  The VM and its vCPUs can simply be
> created when migration starts.  In the SEV-ES case, the guest can even
> provide the VMSA that starts the migration helper.

I don't think management apps will accept that approach when pinning
guests. They will want control over how many extra vCPU threads are
created, what host pCPUs they are pinned to, and what schedular
policies might be applied to them.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

