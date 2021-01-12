Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C842F2BDC
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 10:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388918AbhALJxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 04:53:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388077AbhALJxu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 04:53:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610445142;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=svdoJqewurzhnd48QrfHO28PiRZBp7LBFgvNrNgI/JA=;
        b=fH6VBPrCxqLNdpn4txzU/F3nTxK5y7Rk+rGi9knh79FuCXTU35ohkFdoLcuEXMykLy0rEZ
        sbQw80L4Z8n08KD2vKs45oP0D0umU1cQ4j5dA8SwDm/usRtHXYMFYpoRAfvCA59FnGExK5
        A+4m0ao4HdDo910ABVg+vzXerFYv/mo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-HnyDRtxKPlWTSgObeQSKEg-1; Tue, 12 Jan 2021 04:52:19 -0500
X-MC-Unique: HnyDRtxKPlWTSgObeQSKEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE03D107ACF8;
        Tue, 12 Jan 2021 09:52:16 +0000 (UTC)
Received: from redhat.com (ovpn-115-107.ams2.redhat.com [10.36.115.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E545C5D9DB;
        Tue, 12 Jan 2021 09:52:02 +0000 (UTC)
Date:   Tue, 12 Jan 2021 09:52:00 +0000
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
Subject: Re: [PATCH v6 10/13] spapr: Add PEF based confidential guest support
Message-ID: <20210112095200.GC1360503@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-11-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210112044508.427338-11-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 03:45:05PM +1100, David Gibson wrote:
> Some upcoming POWER machines have a system called PEF (Protected
> Execution Facility) which uses a small ultravisor to allow guests to
> run in a way that they can't be eavesdropped by the hypervisor.  The
> effect is roughly similar to AMD SEV, although the mechanisms are
> quite different.
> 
> Most of the work of this is done between the guest, KVM and the
> ultravisor, with little need for involvement by qemu.  However qemu
> does need to tell KVM to allow secure VMs.
> 
> Because the availability of secure mode is a guest visible difference
> which depends on having the right hardware and firmware, we don't
> enable this by default.  In order to run a secure guest you need to
> create a "pef-guest" object and set the confidential-guest-support
> property to point to it.
> 
> Note that this just *allows* secure guests, the architecture of PEF is
> such that the guest still needs to talk to the ultravisor to enter
> secure mode.  Qemu has no directl way of knowing if the guest is in
> secure mode, and certainly can't know until well after machine
> creation time.
> 
> To start a PEF-capable guest, use the command line options:
>     -object pef-guest,id=pef0 -machine confidential-guest-support=pef0
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  docs/confidential-guest-support.txt |   2 +
>  docs/papr-pef.txt                   |  30 ++++++++
>  hw/ppc/meson.build                  |   1 +
>  hw/ppc/pef.c                        | 115 ++++++++++++++++++++++++++++
>  hw/ppc/spapr.c                      |  10 +++
>  include/hw/ppc/pef.h                |  26 +++++++
>  target/ppc/kvm.c                    |  18 -----
>  target/ppc/kvm_ppc.h                |   6 --
>  8 files changed, 184 insertions(+), 24 deletions(-)
>  create mode 100644 docs/papr-pef.txt
>  create mode 100644 hw/ppc/pef.c
>  create mode 100644 include/hw/ppc/pef.h
> 


> diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> new file mode 100644
> index 0000000000..b227dc6905
> --- /dev/null
> +++ b/hw/ppc/pef.c
> @@ -0,0 +1,115 @@
> +/*
> + * PEF (Protected Execution Facility) for POWER support
> + *
> + * Copyright David Gibson, Redhat Inc. 2020
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +
> +#include "qapi/error.h"
> +#include "qom/object_interfaces.h"
> +#include "sysemu/kvm.h"
> +#include "migration/blocker.h"
> +#include "exec/confidential-guest-support.h"
> +#include "hw/ppc/pef.h"
> +
> +#define TYPE_PEF_GUEST "pef-guest"
> +#define PEF_GUEST(obj)                                  \
> +    OBJECT_CHECK(PefGuestState, (obj), TYPE_PEF_GUEST)
> +
> +typedef struct PefGuestState PefGuestState;

Can use  OBJECT_DECLARE_TYPE.

Also the struct naming ought to match the type naming.
eg use PefGuest for the struct, to match TYPE_PEF_GUEST.

> +
> +/**
> + * PefGuestState:
> + *
> + * The PefGuestState object is used for creating and managing a PEF
> + * guest.
> + *
> + * # $QEMU \
> + *         -object pef-guest,id=pef0 \
> + *         -machine ...,confidential-guest-support=pef0
> + */
> +struct PefGuestState {
> +    Object parent_obj;
> +};
> +
> +#ifdef CONFIG_KVM
> +static int kvmppc_svm_init(Error **errp)
> +{
> +    if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
> +        error_setg(errp,
> +                   "KVM implementation does not support Secure VMs (is an ultravisor running?)");
> +        return -1;
> +    } else {
> +        int ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_SECURE_GUEST, 0, 1);
> +
> +        if (ret < 0) {
> +            error_setg(errp,
> +                       "Error enabling PEF with KVM");
> +            return -1;
> +        }
> +    }
> +
> +    return 0;
> +}
> +
> +/*
> + * Don't set error if KVM_PPC_SVM_OFF ioctl is invoked on kernels
> + * that don't support this ioctl.
> + */
> +void kvmppc_svm_off(Error **errp)
> +{
> +    int rc;
> +
> +    if (!kvm_enabled()) {
> +        return;
> +    }
> +
> +    rc = kvm_vm_ioctl(KVM_STATE(current_accel()), KVM_PPC_SVM_OFF);
> +    if (rc && rc != -ENOTTY) {
> +        error_setg_errno(errp, -rc, "KVM_PPC_SVM_OFF ioctl failed");
> +    }
> +}
> +#else
> +static int kvmppc_svm_init(Error **errp)
> +{
> +    g_assert_not_reached();
> +}
> +#endif
> +
> +int pef_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
> +{
> +    if (!object_dynamic_cast(OBJECT(cgs), TYPE_PEF_GUEST)) {
> +        return 0;
> +    }
> +
> +    if (!kvm_enabled()) {
> +        error_setg(errp, "PEF requires KVM");
> +        return -1;
> +    }
> +
> +    return kvmppc_svm_init(errp);
> +}
> +
> +static const TypeInfo pef_guest_info = {
> +    .parent = TYPE_OBJECT,
> +    .name = TYPE_PEF_GUEST,
> +    .instance_size = sizeof(PefGuestState),
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_CONFIDENTIAL_GUEST_SUPPORT },
> +        { TYPE_USER_CREATABLE },
> +        { }
> +    }
> +};
> +
> +static void
> +pef_register_types(void)
> +{
> +    type_register_static(&pef_guest_info);
> +}
> +
> +type_init(pef_register_types);

Can use OBJECT_DEFINE_TYPE_WITH_INTERFACES here


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

