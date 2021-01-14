Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A352F5DD8
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 10:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbhANJgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 04:36:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726822AbhANJgf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 04:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610616908;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=n6alxUJVO4HQG6wR5agsW6NkY2ZUnAv+dedVGMDRB4Q=;
        b=Vyc+jc9PybkBMSYgGslE0ADQ5wBSd0/I5sB4sS/e8wyNJM5BdTESFpVdBptcTiB6g8LE9p
        cXAPc1Y7o0lUb+OFkhMxEHWgTKHYsLGAFqfO43xpuj6vs+RBSzYNEDVeZhPtpuzY8v57iv
        Nl0sDMCZ7ZcNbGFfDK7bVAUHt2tKlY0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-GhMVSrBdMqi424dF7Si8Nw-1; Thu, 14 Jan 2021 04:34:54 -0500
X-MC-Unique: GhMVSrBdMqi424dF7Si8Nw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C991A190A7A0;
        Thu, 14 Jan 2021 09:34:51 +0000 (UTC)
Received: from redhat.com (ovpn-115-77.ams2.redhat.com [10.36.115.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C03C26A8F2;
        Thu, 14 Jan 2021 09:34:38 +0000 (UTC)
Date:   Thu, 14 Jan 2021 09:34:36 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org, cohuck@redhat.com,
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
        andi.kleen@intel.com
Subject: Re: [PATCH v7 02/13] confidential guest support: Introduce new
 confidential guest support class
Message-ID: <20210114093436.GB1643043@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-3-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210113235811.1909610-3-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 10:58:00AM +1100, David Gibson wrote:
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
>  backends/confidential-guest-support.c     | 33 ++++++++++++++++++++
>  backends/meson.build                      |  1 +
>  include/exec/confidential-guest-support.h | 38 +++++++++++++++++++++++
>  include/qemu/typedefs.h                   |  1 +
>  target/i386/sev.c                         |  3 +-
>  5 files changed, 75 insertions(+), 1 deletion(-)
>  create mode 100644 backends/confidential-guest-support.c
>  create mode 100644 include/exec/confidential-guest-support.h
> 
> diff --git a/backends/confidential-guest-support.c b/backends/confidential-guest-support.c
> new file mode 100644
> index 0000000000..9b0ded0db4
> --- /dev/null
> +++ b/backends/confidential-guest-support.c
> @@ -0,0 +1,33 @@
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
> +OBJECT_DEFINE_ABSTRACT_TYPE(ConfidentialGuestSupport,
> +                            confidential_guest_support,
> +                            CONFIDENTIAL_GUEST_SUPPORT,
> +                            OBJECT)
> +
> +static void confidential_guest_support_class_init(ObjectClass *oc, void *data)
> +{
> +}
> +
> +static void confidential_guest_support_init(Object *obj)
> +{
> +}
> +
> +static void confidential_guest_support_finalize(Object *obj)
> +{
> +}
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
> index 0000000000..5f131023ba
> --- /dev/null
> +++ b/include/exec/confidential-guest-support.h
> @@ -0,0 +1,38 @@
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
> +OBJECT_DECLARE_SIMPLE_TYPE(ConfidentialGuestSupport, CONFIDENTIAL_GUEST_SUPPORT)
> +
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
> diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
> index 976b529dfb..33685c79ed 100644
> --- a/include/qemu/typedefs.h
> +++ b/include/qemu/typedefs.h
> @@ -36,6 +36,7 @@ typedef struct BusState BusState;
>  typedef struct Chardev Chardev;
>  typedef struct CompatProperty CompatProperty;
>  typedef struct CoMutex CoMutex;
> +typedef struct ConfidentialGuestSupport ConfidentialGuestSupport;
>  typedef struct CPUAddressSpace CPUAddressSpace;
>  typedef struct CPUState CPUState;
>  typedef struct DeviceListener DeviceListener;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1546606811..6b49925f51 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -31,6 +31,7 @@
>  #include "qom/object.h"
>  #include "exec/address-spaces.h"
>  #include "monitor/monitor.h"
> +#include "exec/confidential-guest-support.h"
>  
>  #define TYPE_SEV_GUEST "sev-guest"
>  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> @@ -322,7 +323,7 @@ sev_guest_instance_init(Object *obj)
>  
>  /* sev guest info */
>  static const TypeInfo sev_guest_info = {
> -    .parent = TYPE_OBJECT,
> +    .parent = TYPE_CONFIDENTIAL_GUEST_SUPPORT,

If you're changing the parent QOM type, then you also need to change
the parent struct field type in SevguestState to match

>      .name = TYPE_SEV_GUEST,
>      .instance_size = sizeof(SevGuestState),
>      .instance_finalize = sev_guest_finalize,

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

