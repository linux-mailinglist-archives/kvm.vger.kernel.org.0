Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A5E2F5D0A
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 10:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbhANJOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 04:14:54 -0500
Received: from 2.mo52.mail-out.ovh.net ([178.33.105.233]:39584 "EHLO
        2.mo52.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbhANJOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 04:14:39 -0500
X-Greylist: delayed 163784 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2021 04:14:37 EST
Received: from mxplan5.mail.ovh.net (unknown [10.109.146.173])
        by mo52.mail-out.ovh.net (Postfix) with ESMTPS id 3CA46230150;
        Thu, 14 Jan 2021 09:55:10 +0100 (CET)
Received: from kaod.org (37.59.142.100) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 14 Jan
 2021 09:55:09 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-100R00352f46628-57d0-46e2-9de7-07363bd0adac,
                    0A7C53367AF3A9CD096E542ECC3C8B2C2D100868) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 82.253.208.248
Date:   Thu, 14 Jan 2021 09:55:08 +0100
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     <brijesh.singh@amd.com>, <pair@us.ibm.com>, <dgilbert@redhat.com>,
        <pasic@linux.ibm.com>, <qemu-devel@nongnu.org>,
        <cohuck@redhat.com>,
        "Richard Henderson" <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, <borntraeger@de.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, <mst@redhat.com>,
        <jun.nakajima@intel.com>, <thuth@redhat.com>,
        <pragyansri.pathi@intel.com>, <kvm@vger.kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>, <qemu-s390x@nongnu.org>,
        <qemu-ppc@nongnu.org>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>, <andi.kleen@intel.com>
Subject: Re: [PATCH v7 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <20210114095508.3ef1db7e@bahia.lan>
In-Reply-To: <20210113235811.1909610-8-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-8-david@gibson.dropbear.id.au>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.100]
X-ClientProxiedBy: DAG4EX1.mxp5.local (172.16.2.31) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 1b4eaa1f-9249-4295-af14-40e7aee9315b
X-Ovh-Tracer-Id: 499336611335149980
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedukedrtdeggdduvdeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeefuddtieejjeevheekieeltefgleetkeetheettdeifeffvefhffelffdtfeeljeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddttdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtoheprghnughirdhklhgvvghnsehinhhtvghlrdgtohhm
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:05 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

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
> 

Since this is a strong requirement for any new cgs implementation, I
guess it could be advertised a bit more with some extra documentation
in the confidential-guest-support.h header file as well.

Anyway,

Reviewed-by: Greg Kurz <groug@kaod.org>


Unrelated. I've just spotted mdroth@linux.vnet.ibm.com in the Cc list
of this thread, but, as you know, Mike is now working on other topics
at AMD :)

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

