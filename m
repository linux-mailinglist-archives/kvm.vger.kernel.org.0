Return-Path: <kvm+bounces-30713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E314B9BCA30
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:19:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D4491C2156B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457711D2B21;
	Tue,  5 Nov 2024 10:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fgvv9pBK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549771D1F57
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 10:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801967; cv=none; b=SJmwBBezNE9l1K/+8XArhZksuvyTJHMimcyxQzyp+95LOjLxV075FCWVQKtqHWUemWDGVQ1gm2Nv/nPrd5pCrKcBGK7lypJsXFACegKFtH9pjxEJguFAw508N8Vj5zPPAeUDTVEfdPOyDrdTKvzciaV2B5T1T3ZrvnUBnTcKwRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801967; c=relaxed/simple;
	bh=/aiVgg0IatpDWEAVnxjPnwlLrTYNFYkdY0/vByZLxkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i59mgxo333+pDkyMQRPHxhYsEFgHTrBNLI2lLLguqIrK+gOO4lUW9YeT2arYpZ5v7rnt3yLB90fpadyBt/G/nrwjpP3/CwkfujyBdactxsku7X+ddpYgZk2aLulu8DOcwFMTxZNrzrvMEfS8YRqCI9pp9QHt8HFCxJEUF8cImOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fgvv9pBK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730801964;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=6ZC6370UWBg4YtvmjDXxHcFg+06eNs7J9tIqjeHqP8g=;
	b=Fgvv9pBKpwY5X1WjdZKNpNe5EbcpoLBXNrcRxsLfA39RTRqTqfKSOuim77jbydhL0DAsd5
	qIy7w6GOHsi/yNjz9tURXQJAg/9+YkSPihIRNdp5rz1ZdENB13wRlpOoqG2k8usoaVfMxY
	xxjMFvN0e5tWCcuMsMFyUo+hEXCkzg0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-472-1tYzfYwlP-2I4FZ3zui1uA-1; Tue,
 05 Nov 2024 05:19:10 -0500
X-MC-Unique: 1tYzfYwlP-2I4FZ3zui1uA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF8CA19560AF;
	Tue,  5 Nov 2024 10:19:07 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0138E19560A3;
	Tue,  5 Nov 2024 10:18:59 +0000 (UTC)
Date: Tue, 5 Nov 2024 10:18:55 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 02/60] i386: Introduce tdx-guest object
Message-ID: <ZynxD6crcL5Qouhe@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-3-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-3-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Nov 05, 2024 at 01:23:10AM -0500, Xiaoyao Li wrote:
> Introduce tdx-guest object which inherits X86_CONFIDENTIAL_GUEST,
> and will be used to create TDX VMs (TDs) by
> 
>   qemu -machine ...,confidential-guest-support=tdx0	\
>        -object tdx-guest,id=tdx0
> 
> It has one QAPI member 'attributes' defined, which allows user to set
> TD's attributes directly.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> Acked-by: Markus Armbruster <armbru@redhat.com>
> ---
> Chanegs in v6:
>  - Make tdx-guest inherits X86_CONFIDENTIAL_GUEST;
>  - set cgs->require_guest_memfd;
>  - allow attributes settable via QAPI;
>  - update QAPI version to since 9.2;
> 
> Changes in v4:
>  - update the new qapi `since` filed from 8.2 to 9.0
> 
> Changes in v1
>  - make @attributes not user-settable
> ---
>  configs/devices/i386-softmmu/default.mak |  1 +
>  hw/i386/Kconfig                          |  5 +++
>  qapi/qom.json                            | 15 ++++++++
>  target/i386/kvm/meson.build              |  2 ++
>  target/i386/kvm/tdx.c                    | 45 ++++++++++++++++++++++++
>  target/i386/kvm/tdx.h                    | 19 ++++++++++
>  6 files changed, 87 insertions(+)
>  create mode 100644 target/i386/kvm/tdx.c
>  create mode 100644 target/i386/kvm/tdx.h
> 
> diff --git a/configs/devices/i386-softmmu/default.mak b/configs/devices/i386-softmmu/default.mak
> index 4faf2f0315e2..bc0479a7e0a3 100644
> --- a/configs/devices/i386-softmmu/default.mak
> +++ b/configs/devices/i386-softmmu/default.mak
> @@ -18,6 +18,7 @@
>  #CONFIG_QXL=n
>  #CONFIG_SEV=n
>  #CONFIG_SGA=n
> +#CONFIG_TDX=n
>  #CONFIG_TEST_DEVICES=n
>  #CONFIG_TPM_CRB=n
>  #CONFIG_TPM_TIS_ISA=n
> diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
> index 32818480d263..86bc10377c4f 100644
> --- a/hw/i386/Kconfig
> +++ b/hw/i386/Kconfig
> @@ -10,6 +10,10 @@ config SGX
>      bool
>      depends on KVM
>  
> +config TDX
> +    bool
> +    depends on KVM
> +
>  config PC
>      bool
>      imply APPLESMC
> @@ -26,6 +30,7 @@ config PC
>      imply QXL
>      imply SEV
>      imply SGX
> +    imply TDX
>      imply TEST_DEVICES
>      imply TPM_CRB
>      imply TPM_TIS_ISA
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 321ccd708ad1..129b25edf495 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1008,6 +1008,19 @@
>              '*host-data': 'str',
>              '*vcek-disabled': 'bool' } }
>  
> +##
> +# @TdxGuestProperties:
> +#
> +# Properties for tdx-guest objects.
> +#
> +# @attributes: The 'attributes' of a TD guest that is passed to
> +#     KVM_TDX_INIT_VM
> +#
> +# Since: 9.2
> +##

Since QEMU soft-freeze for 9.2 is today, you've missed the
boat for that. Please update any version tags in this series
to 10.0, which is the first release of next year.

> +{ 'struct': 'TdxGuestProperties',
> +  'data': { '*attributes': 'uint64' } }
> +
>  ##
>  # @ThreadContextProperties:
>  #
> @@ -1092,6 +1105,7 @@
>      'sev-snp-guest',
>      'thread-context',
>      's390-pv-guest',
> +    'tdx-guest',
>      'throttle-group',
>      'tls-creds-anon',
>      'tls-creds-psk',
> @@ -1163,6 +1177,7 @@
>                                        'if': 'CONFIG_SECRET_KEYRING' },
>        'sev-guest':                  'SevGuestProperties',
>        'sev-snp-guest':              'SevSnpGuestProperties',
> +      'tdx-guest':                  'TdxGuestProperties',
>        'thread-context':             'ThreadContextProperties',
>        'throttle-group':             'ThrottleGroupProperties',
>        'tls-creds-anon':             'TlsCredsAnonProperties',
> diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
> index 3996cafaf29f..466bccb9cb17 100644
> --- a/target/i386/kvm/meson.build
> +++ b/target/i386/kvm/meson.build
> @@ -8,6 +8,8 @@ i386_kvm_ss.add(files(
>  
>  i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
>  
> +i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
> +
>  i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
>  
>  i386_system_ss.add_all(when: 'CONFIG_KVM', if_true: i386_kvm_ss)
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> new file mode 100644
> index 000000000000..166f53d2b9e3
> --- /dev/null
> +++ b/target/i386/kvm/tdx.c
> @@ -0,0 +1,45 @@
> +/*
> + * QEMU TDX support
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Xiaoyao Li <xiaoyao.li@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory

FYI, since KVM Forum we decided that we would prefer newly
created files to just use SPDX tags for license info.

> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qom/object_interfaces.h"
> +
> +#include "tdx.h"
> +
> +/* tdx guest */
> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
> +                                   tdx_guest,
> +                                   TDX_GUEST,
> +                                   X86_CONFIDENTIAL_GUEST,
> +                                   { TYPE_USER_CREATABLE },
> +                                   { NULL })
> +
> +static void tdx_guest_init(Object *obj)
> +{
> +    ConfidentialGuestSupport *cgs = CONFIDENTIAL_GUEST_SUPPORT(obj);
> +    TdxGuest *tdx = TDX_GUEST(obj);
> +
> +    cgs->require_guest_memfd = true;
> +    tdx->attributes = 0;
> +
> +    object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
> +                                   OBJ_PROP_FLAG_READWRITE);
> +}
> +
> +static void tdx_guest_finalize(Object *obj)
> +{
> +}
> +
> +static void tdx_guest_class_init(ObjectClass *oc, void *data)
> +{
> +}
> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> new file mode 100644
> index 000000000000..de687457cae6
> --- /dev/null
> +++ b/target/i386/kvm/tdx.h
> @@ -0,0 +1,19 @@
> +#ifndef QEMU_I386_TDX_H
> +#define QEMU_I386_TDX_H

Missing license info.

> +
> +#include "confidential-guest.h"
> +
> +#define TYPE_TDX_GUEST "tdx-guest"
> +#define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
> +
> +typedef struct TdxGuestClass {
> +    X86ConfidentialGuestClass parent_class;
> +} TdxGuestClass;
> +
> +typedef struct TdxGuest {
> +    X86ConfidentialGuest parent_obj;
> +
> +    uint64_t attributes;    /* TD attributes */
> +} TdxGuest;
> +
> +#endif /* QEMU_I386_TDX_H */
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


