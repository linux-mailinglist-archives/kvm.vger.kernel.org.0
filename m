Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7BC2D9D2A
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 18:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394370AbgLNRCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 12:02:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732052AbgLNRC3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 12:02:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607965256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0B0YEDnoS8M0GXlt72UhVhZU/03A7MZBaySCY6cDkCI=;
        b=OJmMc1Ma3X27pTM3zSowYoiiKiGi9pI4BaAPtzfbpCVnkXLVQUSHt7kjGyaJLpDojs1li3
        r86x/Kaeu42P2AN2d8yNvps4yGbejxUMzxwW8zXaPzPuVi4BrOS0EeTTd9aIRW2AFu1zOn
        nE/WXCCkXWfcbU36iXuc9r4xEvwr3pw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-7ofVFPZmMuK2pj4vvakPIw-1; Mon, 14 Dec 2020 12:00:53 -0500
X-MC-Unique: 7ofVFPZmMuK2pj4vvakPIw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFA82612AD;
        Mon, 14 Dec 2020 17:00:50 +0000 (UTC)
Received: from gondolin (ovpn-113-171.ams2.redhat.com [10.36.113.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1524470497;
        Mon, 14 Dec 2020 17:00:38 +0000 (UTC)
Date:   Mon, 14 Dec 2020 18:00:36 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 08/13] securable guest memory: Introduce sgm
 "ready" flag
Message-ID: <20201214180036.3837693e.cohuck@redhat.com>
In-Reply-To: <20201204054415.579042-9-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-9-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Dec 2020 16:44:10 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> The platform specific details of mechanisms for implementing securable
> guest memory may require setup at various points during initialization.
> Thus, it's not really feasible to have a single sgm initialization hook,
> but instead each mechanism needs its own initialization calls in arch or
> machine specific code.
> 
> However, to make it harder to have a bug where a mechanism isn't properly
> initialized under some circumstances, we want to have a common place,
> relatively late in boot, where we verify that sgm has been initialized if
> it was requested.
> 
> This patch introduces a ready flag to the SecurableGuestMemory base type
> to accomplish this, which we verify just before the machine specific
> initialization function.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/core/machine.c                     | 8 ++++++++
>  include/exec/securable-guest-memory.h | 2 ++
>  target/i386/sev.c                     | 2 ++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 816ea3ae3e..a67a27d03c 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -1155,6 +1155,14 @@ void machine_run_board_init(MachineState *machine)
>      }
>  
>      if (machine->sgm) {
> +        /*
> +         * Where securable guest memory is initialized depends on the
> +         * specific mechanism in use.  But, we need to make sure it's
> +         * ready by now.  If it isn't, that's a bug in the
> +         * implementation of that sgm mechanism.
> +         */
> +        assert(machine->sgm->ready);

Under which circumstances might we arrive here with 'ready' not set?

- programming error, setup is happening too late -> assert() seems
  appropriate
- we tried to set it up, but some error happened -> should we rely on
  the setup code to error out first? (i.e. we won't end up here, unless
  there's a programming error, in which case the assert() looks fine)
  Is there a possible use case for "we could not set it up, but we
  support an unsecured guest (as long as it is clear what happens)"?
  Likely only for guests that transition themselves, but one could
  argue that QEMU should simply be invoked a second time without the
  sgm stuff being specified in the error case.

> +
>          /*
>           * With securable guest memory, the host can't see the real
>           * contents of RAM, so there's no point in it trying to merge

