Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA5230DF83
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 17:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhBCQRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 11:17:17 -0500
Received: from 8.mo51.mail-out.ovh.net ([46.105.45.231]:51479 "EHLO
        8.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbhBCQQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 11:16:44 -0500
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.141])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id 8B62A261D4A;
        Wed,  3 Feb 2021 17:15:58 +0100 (CET)
Received: from kaod.org (37.59.142.104) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 3 Feb 2021
 17:15:54 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-104R005d03d0090-901e-436c-a398-7faaa0e21e1c,
                    14764A637080470E006017DF0F40374BD57DCD59) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Wed, 3 Feb 2021 17:15:48 +0100
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     <dgilbert@redhat.com>, <pair@us.ibm.com>, <qemu-devel@nongnu.org>,
        <brijesh.singh@amd.com>, <pasic@linux.ibm.com>,
        <pragyansri.pathi@intel.com>, <richard.henderson@linaro.org>,
        <berrange@redhat.com>, David Hildenbrand <david@redhat.com>,
        <mdroth@linux.vnet.ibm.com>, <kvm@vger.kernel.org>,
        "Marcel Apfelbaum" <marcel.apfelbaum@gmail.com>,
        <pbonzini@redhat.com>, <mtosatti@redhat.com>,
        <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
        <qemu-ppc@nongnu.org>, <qemu-s390x@nongnu.org>, <thuth@redhat.com>,
        <mst@redhat.com>, <frankja@linux.ibm.com>,
        <jun.nakajima@intel.com>, <andi.kleen@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v8 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <20210203171548.0d8e0494@bahia.lan>
In-Reply-To: <20210202041315.196530-8-david@gibson.dropbear.id.au>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
        <20210202041315.196530-8-david@gibson.dropbear.id.au>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.104]
X-ClientProxiedBy: DAG8EX2.mxp5.local (172.16.2.72) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: af5f4bdd-8cd5-43de-941a-fb2932b2f48a
X-Ovh-Tracer-Id: 14717200635796625759
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrgedvgdekgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgihesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepfedutdeijeejveehkeeileetgfelteekteehtedtieefffevhffflefftdefleejnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopegvhhgrsghkohhsthesrhgvughhrghtrdgtohhm
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  2 Feb 2021 15:13:09 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

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

s/fasible/feasible

Anyway,

Reviewed-by: Greg Kurz <groug@kaod.org>

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

