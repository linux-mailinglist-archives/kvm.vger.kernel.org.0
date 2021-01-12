Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CC02F2B9B
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 10:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbhALJsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 04:48:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726501AbhALJsF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 04:48:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610444798;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=ODVNYzSBgz4KYGkr1woEtTAcLg1nh9e/gD9NLL+j6AQ=;
        b=Nnkl4AabG1RoNhlqeNFLhn4PVqiAQuOYyjnfkw8bojsRGx3YH1hxZAHI0RRPdMkyjDWIgh
        V6bvBiW0YR7bSWQWH5GrtPqBigPVJQwj1ju4ISmLtysTyYcTFTHlanKcUc5UVT7JsEYY5r
        N8VvG+fKjTeD8hIPYYFutyLbWq5FDHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-Ethh6Yo1OkqBB43Yo1xOzA-1; Tue, 12 Jan 2021 04:46:36 -0500
X-MC-Unique: Ethh6Yo1OkqBB43Yo1xOzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C072215720;
        Tue, 12 Jan 2021 09:46:33 +0000 (UTC)
Received: from redhat.com (ovpn-115-107.ams2.redhat.com [10.36.115.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BE076A8FD;
        Tue, 12 Jan 2021 09:46:19 +0000 (UTC)
Date:   Tue, 12 Jan 2021 09:46:17 +0000
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
Subject: Re: [PATCH v6 02/13] confidential guest support: Introduce new
 confidential guest support class
Message-ID: <20210112094617.GB1360503@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-3-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210112044508.427338-3-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 03:44:57PM +1100, David Gibson wrote:
> Several architectures have mechanisms which are designed to protect guest
> memory from interference or eavesdropping by a compromised hypervisor.  AMD
> SEV does this with in-chip memory encryption and Intel's MKTME can do
> similar things.  POWER's Protected Execution Framework (PEF) accomplishes a
> similar goal using an ultravisor and new memory protection features,
> instead of encryption.
> 
> To (partially) unify handling for these, this introduces a new
> ConfidentialGuestSupport QOM base class.  "Confidential" is kind of vague,
> but "confidential computing" seems to be the buzzword about these schemes,
> and "secure" or "protected" are often used in connection to unrelated
> things (such as hypervisor-from-guest or guest-from-guest security).
> 
> The "support" in the name is significant because in at least some of the
> cases it requires the guest to take specific actions in order to protect
> itself from hypervisor eavesdropping.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  backends/confidential-guest-support.c     | 30 +++++++++++++++
>  backends/meson.build                      |  1 +
>  include/exec/confidential-guest-support.h | 46 +++++++++++++++++++++++
>  include/qemu/typedefs.h                   |  1 +
>  target/i386/sev.c                         |  3 +-
>  5 files changed, 80 insertions(+), 1 deletion(-)
>  create mode 100644 backends/confidential-guest-support.c
>  create mode 100644 include/exec/confidential-guest-support.h
> 
> diff --git a/backends/confidential-guest-support.c b/backends/confidential-guest-support.c
> new file mode 100644
> index 0000000000..2c7793c74f
> --- /dev/null
> +++ b/backends/confidential-guest-support.c
> @@ -0,0 +1,30 @@
> +/*
> + * QEMU Confidential Guest support
> + *
> + * Copyright: David Gibson, Red Hat Inc. 2020
> + *
> + * Authors:
> + *  David Gibson <david@gibson.dropbear.id.au>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * later.  See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +
> +#include "exec/confidential-guest-support.h"
> +
> +static const TypeInfo confidential_guest_support_info = {
> +    .parent = TYPE_OBJECT,
> +    .name = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> +    .class_size = sizeof(ConfidentialGuestSupportClass),
> +    .instance_size = sizeof(ConfidentialGuestSupport),
> +};
> +
> +static void confidential_guest_support_register_types(void)
> +{
> +    type_register_static(&confidential_guest_support_info);
> +}
> +
> +type_init(confidential_guest_support_register_types)

This should all be replaced by OBJECT_DEFINE_TYPE

> diff --git a/backends/meson.build b/backends/meson.build
> index 484456ece7..d4221831fc 100644
> --- a/backends/meson.build
> +++ b/backends/meson.build
> @@ -6,6 +6,7 @@ softmmu_ss.add([files(
>    'rng-builtin.c',
>    'rng-egd.c',
>    'rng.c',
> +  'confidential-guest-support.c',
>  ), numa])
>  
>  softmmu_ss.add(when: 'CONFIG_POSIX', if_true: files('rng-random.c'))
> diff --git a/include/exec/confidential-guest-support.h b/include/exec/confidential-guest-support.h
> new file mode 100644
> index 0000000000..f9cf170802
> --- /dev/null
> +++ b/include/exec/confidential-guest-support.h
> @@ -0,0 +1,46 @@
> +/*
> + * QEMU Confidential Guest support
> + *   This interface describes the common pieces between various
> + *   schemes for protecting guest memory or other state against a
> + *   compromised hypervisor.  This includes memory encryption (AMD's
> + *   SEV and Intel's MKTME) or special protection modes (PEF on POWER,
> + *   or PV on s390x).
> + *
> + * Copyright: David Gibson, Red Hat Inc. 2020
> + *
> + * Authors:
> + *  David Gibson <david@gibson.dropbear.id.au>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * later.  See the COPYING file in the top-level directory.
> + *
> + */
> +#ifndef QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
> +#define QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
> +
> +#ifndef CONFIG_USER_ONLY
> +
> +#include "qom/object.h"
> +
> +#define TYPE_CONFIDENTIAL_GUEST_SUPPORT "confidential-guest-support"
> +#define CONFIDENTIAL_GUEST_SUPPORT(obj)                                    \
> +    OBJECT_CHECK(ConfidentialGuestSupport, (obj),                          \
> +                 TYPE_CONFIDENTIAL_GUEST_SUPPORT)
> +#define CONFIDENTIAL_GUEST_SUPPORT_CLASS(klass)                            \
> +    OBJECT_CLASS_CHECK(ConfidentialGuestSupportClass, (klass),             \
> +                       TYPE_CONFIDENTIAL_GUEST_SUPPORT)
> +#define CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(obj)                          \
> +    OBJECT_GET_CLASS(ConfidentialGuestSupportClass, (obj),                 \
> +                     TYPE_CONFIDENTIAL_GUEST_SUPPORT)
> +

This should all be replaced by  OBJECT_DECLARE_TYPE


> +struct ConfidentialGuestSupport {
> +    Object parent;
> +};
> +
> +typedef struct ConfidentialGuestSupportClass {
> +    ObjectClass parent;
> +} ConfidentialGuestSupportClass;
> +
> +#endif /* !CONFIG_USER_ONLY */
> +
> +#endif /* QEMU_CONFIDENTIAL_GUEST_SUPPORT_H */

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

