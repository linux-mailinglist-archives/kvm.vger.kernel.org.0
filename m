Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530F72FAA8B
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 20:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437640AbhARTti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 14:49:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437410AbhARTtP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 14:49:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610999268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MhZad9UHyV5bfJ/NZreQvSZ/wofQuPMMkJX3iQbf4II=;
        b=KCV59UVi1zd4jnqhPxBvW/GF1UvGylUWYehk0178rRrAzs0+/1PzYrQdkGPKpydXgw0ePj
        XV3SN2nzoHjjwk0ECVOpG7U9Y4hmOO+4XDcHoXWLNVuls5BwbjfJrp5n4a/IH8kB76Z0Yi
        eht9jlR8eBH55sWsfWsUUSdO3Jvj3Hw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-v6w6ETmROtyji68K0QykFA-1; Mon, 18 Jan 2021 14:47:46 -0500
X-MC-Unique: v6w6ETmROtyji68K0QykFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F86D1005504;
        Mon, 18 Jan 2021 19:47:43 +0000 (UTC)
Received: from work-vm (ovpn-115-197.ams2.redhat.com [10.36.115.197])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE2D660C9C;
        Mon, 18 Jan 2021 19:47:32 +0000 (UTC)
Date:   Mon, 18 Jan 2021 19:47:30 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, pasic@linux.ibm.com,
        qemu-devel@nongnu.org, cohuck@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <20210118194730.GH9899@work-vm>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-8-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113235811.1909610-8-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Gibson (david@gibson.dropbear.id.au) wrote:
> The platform specific details of mechanisms for implementing
> confidential guest support may require setup at various points during
> initialization.  Thus, it's not really feasible to have a single cgs
> initialization hook, but instead each mechanism needs its own
> initialization calls in arch or machine specific code.
> 
> However, to make it harder to have a bug where a mechanism isn't
> properly initialized under some circumstances, we want to have a
> common place, relatively late in boot, where we verify that cgs has
> been initialized if it was requested.
> 
> This patch introduces a ready flag to the ConfidentialGuestSupport
> base type to accomplish this, which we verify just before the machine
> specific initialization function.

You may find you need to define 'ready' and the answer might be a bit
variable; for example, on SEV there's a setup bit and then you may end
up doing an attestation and receiving some data before you actaully let
the guest execute code.   Is it ready before it's received the
attestation response or only when it can run code?
Is a Power or 390 machine 'ready' before it's executed the magic
instruction to enter the confidential mode?

Dave

> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/core/machine.c                         | 8 ++++++++
>  include/exec/confidential-guest-support.h | 2 ++
>  target/i386/sev.c                         | 2 ++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 94194ab82d..5a7433332b 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -1190,6 +1190,14 @@ void machine_run_board_init(MachineState *machine)
>      }
>  
>      if (machine->cgs) {
> +        /*
> +         * Where confidential guest support is initialized depends on
> +         * the specific mechanism in use.  But, we need to make sure
> +         * it's ready by now.  If it isn't, that's a bug in the
> +         * implementation of that cgs mechanism.
> +         */
> +        assert(machine->cgs->ready);
> +
>          /*
>           * With confidential guests, the host can't see the real
>           * contents of RAM, so there's no point in it trying to merge
> diff --git a/include/exec/confidential-guest-support.h b/include/exec/confidential-guest-support.h
> index 5f131023ba..bcaf6c9f49 100644
> --- a/include/exec/confidential-guest-support.h
> +++ b/include/exec/confidential-guest-support.h
> @@ -27,6 +27,8 @@ OBJECT_DECLARE_SIMPLE_TYPE(ConfidentialGuestSupport, CONFIDENTIAL_GUEST_SUPPORT)
>  
>  struct ConfidentialGuestSupport {
>      Object parent;
> +
> +    bool ready;
>  };
>  
>  typedef struct ConfidentialGuestSupportClass {
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index e2b41ef342..3d94635397 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -737,6 +737,8 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
>      qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
>  
> +    cgs->ready = true;
> +
>      return 0;
>  err:
>      sev_guest = NULL;
> -- 
> 2.29.2
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

