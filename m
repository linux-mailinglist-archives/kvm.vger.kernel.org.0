Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E56730D7DB
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 11:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhBCKo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 05:44:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233671AbhBCKo0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 05:44:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612348979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oj/fRtwaugb2KEHyNX5mAT8ioDdcAkdWaaBzV6FQItM=;
        b=NFX0Kk6F5+dCvFBXznCzIxnNnFiXJdJuzy98XfDBt2SsgzAA6YgvGcoAjhtMK+mMMdzzPt
        aQxFujBGWzF1ASSGVSvFeKq43sQnyem3gvVSQJLnNa0e+31Y6m2GoqGzKF5BmheMe4s3Ur
        DrlnCUf4M+mozour0FsUHxF8uYHiPb4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-l84PUT_BP26V9PpDkNfxBQ-1; Wed, 03 Feb 2021 05:42:57 -0500
X-MC-Unique: l84PUT_BP26V9PpDkNfxBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EE8F192D786;
        Wed,  3 Feb 2021 10:42:55 +0000 (UTC)
Received: from work-vm (ovpn-115-70.ams2.redhat.com [10.36.115.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC7E05D9E3;
        Wed,  3 Feb 2021 10:42:44 +0000 (UTC)
Date:   Wed, 3 Feb 2021 10:42:42 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pair@us.ibm.com, qemu-devel@nongnu.org, brijesh.singh@amd.com,
        pasic@linux.ibm.com, pragyansri.pathi@intel.com,
        Greg Kurz <groug@kaod.org>, richard.henderson@linaro.org,
        berrange@redhat.com, David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com, borntraeger@de.ibm.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        qemu-s390x@nongnu.org, thuth@redhat.com, mst@redhat.com,
        frankja@linux.ibm.com, jun.nakajima@intel.com,
        andi.kleen@intel.com, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v8 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <20210203104242.GD2950@work-vm>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
 <20210202041315.196530-8-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202041315.196530-8-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
> common place, late in boot, where we verify that cgs has been
> initialized if it was requested.
> 
> This patch introduces a ready flag to the ConfidentialGuestSupport
> base type to accomplish this, which we verify in
> qemu_machine_creation_done().
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  include/exec/confidential-guest-support.h | 24 +++++++++++++++++++++++
>  softmmu/vl.c                              | 10 ++++++++++
>  target/i386/sev.c                         |  2 ++
>  3 files changed, 36 insertions(+)
> 
> diff --git a/include/exec/confidential-guest-support.h b/include/exec/confidential-guest-support.h
> index 3db6380e63..5dcf602047 100644
> --- a/include/exec/confidential-guest-support.h
> +++ b/include/exec/confidential-guest-support.h
> @@ -27,6 +27,30 @@ OBJECT_DECLARE_SIMPLE_TYPE(ConfidentialGuestSupport, CONFIDENTIAL_GUEST_SUPPORT)
>  
>  struct ConfidentialGuestSupport {
>      Object parent;
> +
> +    /*
> +     * ready: flag set by CGS initialization code once it's ready to
> +     *        start executing instructions in a potentially-secure
> +     *        guest
> +     *
> +     * The definition here is a bit fuzzy, because this is essentially
> +     * part of a self-sanity-check, rather than a strict mechanism.
> +     *
> +     * It's not fasible to have a single point in the common machine
> +     * init path to configure confidential guest support, because
> +     * different mechanisms have different interdependencies requiring
> +     * initialization in different places, often in arch or machine
> +     * type specific code.  It's also usually not possible to check
> +     * for invalid configurations until that initialization code.
> +     * That means it would be very easy to have a bug allowing CGS
> +     * init to be bypassed entirely in certain configurations.
> +     *
> +     * Silently ignoring a requested security feature would be bad, so
> +     * to avoid that we check late in init that this 'ready' flag is
> +     * set if CGS was requested.  If the CGS init hasn't happened, and
> +     * so 'ready' is not set, we'll abort.
> +     */
> +    bool ready;
>  };
>  
>  typedef struct ConfidentialGuestSupportClass {
> diff --git a/softmmu/vl.c b/softmmu/vl.c
> index 1b464e3474..1869ed54a9 100644
> --- a/softmmu/vl.c
> +++ b/softmmu/vl.c
> @@ -101,6 +101,7 @@
>  #include "qemu/plugin.h"
>  #include "qemu/queue.h"
>  #include "sysemu/arch_init.h"
> +#include "exec/confidential-guest-support.h"
>  
>  #include "ui/qemu-spice.h"
>  #include "qapi/string-input-visitor.h"
> @@ -2497,6 +2498,8 @@ static void qemu_create_cli_devices(void)
>  
>  static void qemu_machine_creation_done(void)
>  {
> +    MachineState *machine = MACHINE(qdev_get_machine());
> +
>      /* Did we create any drives that we failed to create a device for? */
>      drive_check_orphaned();
>  
> @@ -2516,6 +2519,13 @@ static void qemu_machine_creation_done(void)
>  
>      qdev_machine_creation_done();
>  
> +    if (machine->cgs) {
> +        /*
> +         * Verify that Confidential Guest Support has actually been initialized
> +         */
> +        assert(machine->cgs->ready);
> +    }
> +
>      if (foreach_device_config(DEV_GDB, gdbserver_start) < 0) {
>          exit(1);
>      }
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 590cb31fa8..f9e9b5d8ae 100644
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

