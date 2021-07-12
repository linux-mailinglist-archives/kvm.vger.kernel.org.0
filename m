Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9FD3C5E8A
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhGLOqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 10:46:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230363AbhGLOqq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 10:46:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626101038;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=/hur5bIhEYkoQXxvA1D+ZqSlUPy6prLJMFDVP9XQz8k=;
        b=XhQbIOghs0l6Qt10Q9BexWx/KBWkNMR4DvE8DpZkZr45FnMUtjNeIYWlOUFxd/8xXnt0Xw
        pIQPbpT8QmrAEwpZyJG3afKRUqA6xrnfotdlirngWH+5lt+Ame9nUpc21Og0y5B4N/sil0
        e13lJsdBzdDU+/xc3nJcpCWdgjU6wDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404--D6HKpjGPxaE6Dt4B6ImKQ-1; Mon, 12 Jul 2021 10:43:57 -0400
X-MC-Unique: -D6HKpjGPxaE6Dt4B6ImKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84DE71932482;
        Mon, 12 Jul 2021 14:43:55 +0000 (UTC)
Received: from redhat.com (ovpn-114-105.ams2.redhat.com [10.36.114.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC88D1962F;
        Mon, 12 Jul 2021 14:43:48 +0000 (UTC)
Date:   Mon, 12 Jul 2021 15:43:46 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
Message-ID: <YOxVIjuQnQnO9ytT@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210709215550.32496-3-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 04:55:46PM -0500, Brijesh Singh wrote:
> To launch the SEV-SNP guest, a user can specify up to 8 parameters.
> Passing all parameters through command line can be difficult.

This sentence applies to pretty much everything in QEMU and the
SEV-SNP example is nowhere near an extreme example IMHO.

>                                                              To simplify
> the launch parameter passing, introduce a .ini-like config file that can be
> used for passing the parameters to the launch flow.

Inventing a new config file format for usage by just one specific
niche feature in QEMU is something I'd say we do not want.

Our long term goal in QEMU is to move to a world where 100% of
QEMU configuration is provided in JSON format, using the QAPI
schema to define the accepted input set.  

> 
> The contents of the config file will look like this:
> 
> $ cat snp-launch.init
> 
> # SNP launch parameters
> [SEV-SNP]
> init_flags = 0
> policy = 0x1000
> id_block = "YWFhYWFhYWFhYWFhYWFhCg=="

These parameters are really tiny and trivial to provide on the command
line, so I'm not finding this config file compelling.

> 
> 
> Add 'snp' property that can be used to indicate that SEV guest launch
> should enable the SNP support.
> 
> SEV-SNP guest launch examples:
> 
> 1) launch without additional parameters
> 
>   $(QEMU_CLI) \
>     -object sev-guest,id=sev0,snp=on
> 
> 2) launch with optional parameters
>   $(QEMU_CLI) \
>     -object sev-guest,id=sev0,snp=on,launch-config=<file>
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  docs/amd-memory-encryption.txt |  81 +++++++++++-
>  qapi/qom.json                  |   6 +
>  target/i386/sev.c              | 227 +++++++++++++++++++++++++++++++++
>  3 files changed, 312 insertions(+), 2 deletions(-)

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

