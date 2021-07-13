Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891A63C7664
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 20:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhGMSYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 14:24:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhGMSYF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 14:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626200474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sXLLnSfjK/B1eKz6pEdghvizamnJJTYdmIrNmxq0yoo=;
        b=ZVJLw/Oq0S8nvgzjXoabYMYPDTU88V6LceVh6l1W4VEC3lC1KSWKF7SGN0tTqQxTypJdFR
        gRiZT1x7J0XLdf8QvzLNZNeeMWKHVgM6SW3RB/uYZW3HO8oL/pTSyCDs25Z8GQGBLRx3Xs
        v9YAxtARVOyx2/2z6we2tNQw0bjz92E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-BLKCnpVWO5mrv8Rp6zRKGQ-1; Tue, 13 Jul 2021 14:21:13 -0400
X-MC-Unique: BLKCnpVWO5mrv8Rp6zRKGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 132AE192D785;
        Tue, 13 Jul 2021 18:21:12 +0000 (UTC)
Received: from redhat.com (ovpn-113-49.phx2.redhat.com [10.3.113.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 24A135C225;
        Tue, 13 Jul 2021 18:21:06 +0000 (UTC)
Date:   Tue, 13 Jul 2021 13:21:04 -0500
From:   Eric Blake <eblake@redhat.com>
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
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
Message-ID: <20210713182104.t7fi62q7kovnyxfq@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709215550.32496-3-brijesh.singh@amd.com>
User-Agent: NeoMutt/20210205-569-37ed14
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 04:55:46PM -0500, Brijesh Singh wrote:
> To launch the SEV-SNP guest, a user can specify up to 8 parameters.
> Passing all parameters through command line can be difficult. To simplify
> the launch parameter passing, introduce a .ini-like config file that can be
> used for passing the parameters to the launch flow.

I agree with Markus' assessment that we are probably going to be
better off reusing what we already have for other complex options
rather than inventing yet another ini file.

Additional things I noted:

> +++ b/qapi/qom.json
> @@ -749,6 +749,10 @@
>  # @reduced-phys-bits: number of bits in physical addresses that become
>  #                     unavailable when SEV is enabled
>  #
> +# @snp: SEV-SNP is enabled (default: 0)

Here you list 0...

> +#
> +# @launch-config: launch config file to use

Both additions (if we keep the launch-config addition) are missing
'(since 6.1)' notations.

> +#
>  # Since: 2.12
>  ##
>  { 'struct': 'SevGuestProperties',
> @@ -758,6 +762,8 @@
>              '*policy': 'uint32',
>              '*handle': 'uint32',
>              '*cbitpos': 'uint32',
> +            '*snp': 'bool',

...but here you state snp is bool. That means the default is 'false', not '0'.

> +            '*launch-config': 'str',
>              'reduced-phys-bits': 'uint32' } }
>  

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org

