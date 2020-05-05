Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278491C578D
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 15:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgEENzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 09:55:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26968 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729172AbgEENzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 09:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588686943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pXrOAfCFvipXRIcJyZ+dDDMWU53cvZmBUSYYX5xCE50=;
        b=UtI04eUjlHduuFeeg1UPOaEp3bK1AIuTwtu6Z3SS9QLTtzpm4pAnwEMDDPfCkK7+4KW56O
        nnX7KD8Ngr1HRlw47HpFzAf6wUGQ3sVhQQ+wewjiwC2FIZQokBicPRS9IJCQO6FWLitN+2
        NfrggR3cWfJ85QrNMh/VkjaEl3+ttlk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-QNki8uNcMRaYAiwKvU_DJA-1; Tue, 05 May 2020 09:55:42 -0400
X-MC-Unique: QNki8uNcMRaYAiwKvU_DJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42AC81895A29
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 13:55:41 +0000 (UTC)
Received: from paraplu.localdomain (unknown [10.36.110.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD0101002387;
        Tue,  5 May 2020 13:55:40 +0000 (UTC)
Received: by paraplu.localdomain (Postfix, from userid 1001)
        id 4C3623E048A; Tue,  5 May 2020 15:55:38 +0200 (CEST)
Date:   Tue, 5 May 2020 15:55:38 +0200
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, dgilbert@redhat.com, cohuck@redhat.com,
        vkuznets@redhat.com
Subject: Re: [PATCH v3] docs/virt/kvm: Document configuring and running
 nested guests
Message-ID: <20200505135538.GL25680@paraplu>
References: <20200505112839.30534-1-kchamart@redhat.com>
 <c8bb56a1-8556-a9ff-7b69-caf116729a23@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8bb56a1-8556-a9ff-7b69-caf116729a23@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 02:02:58PM +0200, Paolo Bonzini wrote:
> On 05/05/20 13:28, Kashyap Chamarthy wrote:

[...]

> > +Limitations on Linux kernel versions older than 5.3 (x86)
> > +---------------------------------------------------------
> > +
> > +On Linux kernel versions older than 5.3, once an L1 guest has started an
> > +L2 guest, the L1 guest would no longer capable of being migrated, saved,
> > +or loaded (refer to QEMU documentation on "save"/"load") until the L2
> > +guest shuts down.
> > +
> > +Attempting to migrate or save-and-load an L1 guest while an L2 guest is
> > +running will result in undefined behavior.  You might see a ``kernel
> > +BUG!`` entry in ``dmesg``, a kernel 'oops', or an outright kernel panic.
> > +Such a migrated or loaded L1 guest can no longer be considered stable or
> > +secure, and must be restarted.
> > +
> > +Migrating an L1 guest merely configured to support nesting, while not
> > +actually running L2 guests, is expected to function normally.
> > +Live-migrating an L2 guest from one L1 guest to another is also expected
> > +to succeed.
> > +
> 
> This is a bit optimistic, as AMD is not supported yet.  Please review
> the following incremental patch:
> 
> diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documentation/virt/kvm/running-nested-guests.rst
> --- a/Documentation/virt/kvm/running-nested-guests.rst
> +++ b/Documentation/virt/kvm/running-nested-guests.rst
> @@ -182,11 +182,23 @@ Enabling "nested" (s390x)
>  Live migration with nested KVM
>  ------------------------------
>  
> -The below live migration scenarios should work as of Linux kernel 5.3
> -and QEMU 4.2.0 for x86; for s390x, even older versions might work.
> -In all the below cases, L1 exposes ``/dev/kvm`` in it, i.e. the L2 guest
> -is a "KVM-accelerated guest", not a "plain emulated guest" (as done by
> -QEMU's TCG).
> +Migrating an L1 guest, with a  *live* nested guest in it, to another
> +bare metal host, works as of Linux kernel 5.3 and QEMU 4.2.0 for
> +Intel x86 systems, and even on older versions for s390x.
> +
> +On AMD systems, once an L1 guest has started an L2 guest, the L1 guest
> +should no longer be migrated or saved (refer to QEMU documentation on
> +"savevm"/"loadvm") until the L2 guest shuts down.  Attempting to migrate
> +or save-and-load an L1 guest while an L2 guest is running will result in
> +undefined behavior.  You might see a ``kernel BUG!`` entry in ``dmesg``, a
> +kernel 'oops', or an outright kernel panic.  Such a migrated or loaded L1
> +guest can no longer be considered stable or secure, and must be restarted.
> +Migrating an L1 guest merely configured to support nesting, while not
> +actually running L2 guests, is expected to function normally even on AMD
> +systems but may fail once guests are started.
> +
> +Migrating an L2 guest is expected to succeed, so all the following
> +scenarios should work even on AMD systems:
>  
>  - Migrating a nested guest (L2) to another L1 guest on the *same* bare
>    metal host.
> @@ -194,30 +206,7 @@ QEMU's TCG).
>  - Migrating a nested guest (L2) to another L1 guest on a *different*
>    bare metal host.
>  
> -- Migrating an L1 guest, with an *offline* nested guest in it, to
> -  another bare metal host.
> -
> -- Migrating an L1 guest, with a  *live* nested guest in it, to another
> -  bare metal host.
> -
> -Limitations on Linux kernel versions older than 5.3 (x86)
> ----------------------------------------------------------
> -
> -On Linux kernel versions older than 5.3, once an L1 guest has started an
> -L2 guest, the L1 guest would no longer capable of being migrated, saved,
> -or loaded (refer to QEMU documentation on "save"/"load") until the L2
> -guest shuts down.
> -
> -Attempting to migrate or save-and-load an L1 guest while an L2 guest is
> -running will result in undefined behavior.  You might see a ``kernel
> -BUG!`` entry in ``dmesg``, a kernel 'oops', or an outright kernel panic.
> -Such a migrated or loaded L1 guest can no longer be considered stable or
> -secure, and must be restarted.
> -
> -Migrating an L1 guest merely configured to support nesting, while not
> -actually running L2 guests, is expected to function normally.
> -Live-migrating an L2 guest from one L1 guest to another is also expected
> -to succeed.
> +- Migrating a nested guest (L2) to a bare metal host.
>  
>  Reporting bugs from nested setups
>  -----------------------------------

Thanks for the important corrections, Paolo.  Your `diff` reads well to
me.  FWIW: 

    Reviewed-by: Kashyap Chamarthy <kchamart@redhat.com> 

-- 
/kashyap

