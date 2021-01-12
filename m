Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10C72F2C00
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 10:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389366AbhALJ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 04:56:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22984 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388333AbhALJ4C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 04:56:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610445275;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=kGuvj2CuWmf449SJt6M1wW6SPZG0GGSKJFrar63FBXU=;
        b=S7zBGJXEP0AUpO2gJ0mcNGtNlKNbxG1wn99WOQGL1ZU7P4mpV/fP73ZFYltvyMhz7wlHWV
        2Svnfz2dM8dMHFadjPZJihwtV0cLyvV+ZBuC15zNVGJFPwz2X9T/q8gBZ91Cuw2ZkPL3zG
        5JJU/+Hglu61+0RBkl4EEVUSkR0PkeI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-Zob9ETJ3OQOK0QO7ufUIsw-1; Tue, 12 Jan 2021 04:54:34 -0500
X-MC-Unique: Zob9ETJ3OQOK0QO7ufUIsw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3832CE646;
        Tue, 12 Jan 2021 09:54:31 +0000 (UTC)
Received: from redhat.com (ovpn-115-107.ams2.redhat.com [10.36.115.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 855905D9DB;
        Tue, 12 Jan 2021 09:54:20 +0000 (UTC)
Date:   Tue, 12 Jan 2021 09:54:17 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org, andi.kleen@intel.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 13/13] s390: Recognize confidential-guest-support
 option
Message-ID: <20210112095417.GD1360503@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-14-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210112044508.427338-14-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 03:45:08PM +1100, David Gibson wrote:
> At least some s390 cpu models support "Protected Virtualization" (PV),
> a mechanism to protect guests from eavesdropping by a compromised
> hypervisor.
> 
> This is similar in function to other mechanisms like AMD's SEV and
> POWER's PEF, which are controlled by the "confidential-guest-support"
> machine option.  s390 is a slightly special case, because we already
> supported PV, simply by using a CPU model with the required feature
> (S390_FEAT_UNPACK).
> 
> To integrate this with the option used by other platforms, we
> implement the following compromise:
> 
>  - When the confidential-guest-support option is set, s390 will
>    recognize it, verify that the CPU can support PV (failing if not)
>    and set virtio default options necessary for encrypted or protected
>    guests, as on other platforms.  i.e. if confidential-guest-support
>    is set, we will either create a guest capable of entering PV mode,
>    or fail outright.
> 
>  - If confidential-guest-support is not set, guests might still be
>    able to enter PV mode, if the CPU has the right model.  This may be
>    a little surprising, but shouldn't actually be harmful.
> 
> To start a guest supporting Protected Virtualization using the new
> option use the command line arguments:
>     -object s390-pv-guest,id=pv0 -machine confidential-guest-support=pv0
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  docs/confidential-guest-support.txt |  3 ++
>  docs/system/s390x/protvirt.rst      | 19 +++++++---
>  hw/s390x/pv.c                       | 58 +++++++++++++++++++++++++++++
>  include/hw/s390x/pv.h               |  1 +
>  target/s390x/kvm.c                  |  3 ++
>  5 files changed, 78 insertions(+), 6 deletions(-)


> diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
> index ab3a2482aa..85592e100a 100644
> --- a/hw/s390x/pv.c
> +++ b/hw/s390x/pv.c
> @@ -14,8 +14,11 @@
>  #include <linux/kvm.h>
>  
>  #include "cpu.h"
> +#include "qapi/error.h"
>  #include "qemu/error-report.h"
>  #include "sysemu/kvm.h"
> +#include "qom/object_interfaces.h"
> +#include "exec/confidential-guest-support.h"
>  #include "hw/s390x/ipl.h"
>  #include "hw/s390x/pv.h"
>  
> @@ -111,3 +114,58 @@ void s390_pv_inject_reset_error(CPUState *cs)
>      /* Report that we are unable to enter protected mode */
>      env->regs[r1 + 1] = DIAG_308_RC_INVAL_FOR_PV;
>  }
> +
> +#define TYPE_S390_PV_GUEST "s390-pv-guest"
> +#define S390_PV_GUEST(obj)                              \
> +    OBJECT_CHECK(S390PVGuestState, (obj), TYPE_S390_PV_GUEST)
> +
> +typedef struct S390PVGuestState S390PVGuestState;

Can use OBJECT_DECLARE_TYPE for this.  Also same comment about
struct naming vs type naming.

> +
> +/**
> + * S390PVGuestState:
> + *
> + * The S390PVGuestState object is basically a dummy used to tell the
> + * confidential guest support system to use s390's PV mechanism.
> + *
> + * # $QEMU \
> + *         -object s390-pv-guest,id=pv0 \
> + *         -machine ...,confidential-guest-support=pv0
> + */
> +struct S390PVGuestState {
> +    Object parent_obj;
> +};
> +
> +int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
> +{
> +    if (!object_dynamic_cast(OBJECT(cgs), TYPE_S390_PV_GUEST)) {
> +        return 0;
> +    }
> +
> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
> +        error_setg(errp,
> +                   "CPU model does not support Protected Virtualization");
> +        return -1;
> +    }
> +
> +    cgs->ready = true;
> +
> +    return 0;
> +}
> +
> +static const TypeInfo s390_pv_guest_info = {
> +    .parent = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> +    .name = TYPE_S390_PV_GUEST,
> +    .instance_size = sizeof(S390PVGuestState),
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_USER_CREATABLE },
> +        { }
> +    }
> +};
> +
> +static void
> +s390_pv_register_types(void)
> +{
> +    type_register_static(&s390_pv_guest_info);
> +}
> +
> +type_init(s390_pv_register_types);

This can all use OBJECT_DEFINE_TYPE_WITH_INTERFACES


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

