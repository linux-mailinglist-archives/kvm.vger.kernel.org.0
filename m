Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733D222F41A
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 17:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgG0PvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 11:51:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48038 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729316AbgG0PvG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 11:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595865064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ARmbm4s+y+16lt5FdeIbOxsqNwbpuRKXPWXf6hvfytg=;
        b=UEEJBclFq+jewjcRrrju6J0vmG38xwgE0OixJuPnWChOD7frffPgIU6gd0sVJVAyxgBVNs
        Jgsf1GsgOBhqPClhOxmfFPakqV3QnKl1w7TyYS9GghP49les5ZK4Ghw+BoRcHuWSvbVx3S
        Bsw7zb9NJRg1MfHvLimdG+5h35jGoxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-Xhdf0Z5mPw-lOThKx1tpbw-1; Mon, 27 Jul 2020 11:50:59 -0400
X-MC-Unique: Xhdf0Z5mPw-lOThKx1tpbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D60FE18FF67B;
        Mon, 27 Jul 2020 15:50:56 +0000 (UTC)
Received: from gondolin (ovpn-112-210.ams2.redhat.com [10.36.112.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C77685D9F3;
        Mon, 27 Jul 2020 15:50:44 +0000 (UTC)
Date:   Mon, 27 Jul 2020 17:50:40 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
Message-ID: <20200727175040.7beca3dd.cohuck@redhat.com>
In-Reply-To: <20200724025744.69644-11-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
        <20200724025744.69644-11-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Jul 2020 12:57:44 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> At least some s390 cpu models support "Protected Virtualization" (PV),
> a mechanism to protect guests from eavesdropping by a compromised
> hypervisor.
> 
> This is similar in function to other mechanisms like AMD's SEV and
> POWER's PEF, which are controlled bythe "host-trust-limitation"
> machine option.  s390 is a slightly special case, because we already
> supported PV, simply by using a CPU model with the required feature
> (S390_FEAT_UNPACK).
> 
> To integrate this with the option used by other platforms, we
> implement the following compromise:
> 
>  - When the host-trust-limitation option is set, s390 will recognize
>    it, verify that the CPU can support PV (failing if not) and set
>    virtio default options necessary for encrypted or protected guests,
>    as on other platforms.  i.e. if host-trust-limitation is set, we
>    will either create a guest capable of entering PV mode, or fail
>    outright
> 
>  - If host-trust-limitation is not set, guest's might still be able to
>    enter PV mode, if the CPU has the right model.  This may be a
>    little surprising, but shouldn't actually be harmful.

This could be workable, I guess. Would like a second opinion, though.

> 
> To start a guest supporting Protected Virtualization using the new
> option use the command line arguments:
>     -object s390-pv-guest,id=pv0 -machine host-trust-limitation=pv0
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/s390x/pv.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
> index ab3a2482aa..4bf3b345b6 100644
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
> +#include "exec/host-trust-limitation.h"
>  #include "hw/s390x/ipl.h"
>  #include "hw/s390x/pv.h"
>  
> @@ -111,3 +114,61 @@ void s390_pv_inject_reset_error(CPUState *cs)
>      /* Report that we are unable to enter protected mode */
>      env->regs[r1 + 1] = DIAG_308_RC_INVAL_FOR_PV;
>  }
> +
> +#define TYPE_S390_PV_GUEST "s390-pv-guest"
> +#define S390_PV_GUEST(obj)                              \
> +    OBJECT_CHECK(S390PVGuestState, (obj), TYPE_S390_PV_GUEST)
> +
> +typedef struct S390PVGuestState S390PVGuestState;
> +
> +/**
> + * S390PVGuestState:
> + *
> + * The S390PVGuestState object is basically a dummy used to tell the
> + * host trust limitation system to use s390's PV mechanism.  guest.
> + *
> + * # $QEMU \
> + *         -object s390-pv-guest,id=pv0 \
> + *         -machine ...,host-trust-limitation=pv0
> + */
> +struct S390PVGuestState {
> +    Object parent_obj;
> +};
> +
> +static int s390_pv_kvm_init(HostTrustLimitation *gmpo, Error **errp)
> +{
> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
> +        error_setg(errp,
> +                   "CPU model does not support Protected Virtualization");
> +        return -1;
> +    }
> +
> +    return 0;
> +}

So here's where I'm confused: If I follow the code correctly, the
->kvm_init callback is invoked before kvm_arch_init() is called. The
kvm_arch_init() implementation for s390x checks whether
KVM_CAP_S390_PROTECTED is available, which is a pre-req for
S390_FEAT_UNPACK. Am I missing something? Can someone with access to PV
hardware check whether this works as intended?

> +
> +static void s390_pv_guest_class_init(ObjectClass *oc, void *data)
> +{
> +    HostTrustLimitationClass *gmpc = HOST_TRUST_LIMITATION_CLASS(oc);
> +
> +    gmpc->kvm_init = s390_pv_kvm_init;
> +}
> +
> +static const TypeInfo s390_pv_guest_info = {
> +    .parent = TYPE_OBJECT,
> +    .name = TYPE_S390_PV_GUEST,
> +    .instance_size = sizeof(S390PVGuestState),
> +    .class_init = s390_pv_guest_class_init,
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_HOST_TRUST_LIMITATION },
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

