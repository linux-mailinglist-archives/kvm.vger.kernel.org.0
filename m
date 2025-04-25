Return-Path: <kvm+bounces-44280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89AF9A9C324
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 11:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B4ED9A5498
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65264234973;
	Fri, 25 Apr 2025 09:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WrewBO8M"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC23B1D63CF
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 09:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745572765; cv=none; b=l2KyJNIEx5n19vBMyl0J9rx17GHfyw9I5OzzPOuoICE+vk6HNdp0lXkV2B+6zQJ2LW3GbfJb4IVDtY1hTra5OTIKUOMUr8SruBq/8AkVi2/7f3TvglPZ3soDES4oKMfebyW5ym2YxocFadhGYs++Fem6FGSopgosgJKsysCN06k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745572765; c=relaxed/simple;
	bh=+QAp4VYv3fmUaD1XK73SkAR89Qzki7SiKgCZ+0iFM4Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QjnmFRIgrdk8AYBoyxLZ6QH6VW6LI/TN48OAnQOanTD5JJMzQx4KmakjdZWe3tnYZ8qI3h9L0vyxzS0eLylbfdaXYTHiTGiG6QZK0jJRdiZqbCgmWH9CHJpgS+m8NIZ2mpPDbAtorVZfWANqWnmJe+Q/sEcb5jmxbW7XrCU9A6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WrewBO8M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745572762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ZutwbOjXGr5bGwYW46iHYOEUi2TGqqNhr0ZW2OCt4A=;
	b=WrewBO8MSScKtTMBqK29atTOqFW8iZRFqYSOibHkSoeE+TpGY3Hk5qrNjLajPII3OxbZTu
	eoq3iD7IFzLGM2ATz97o96m2PgJIQNK9zpWfcZmLHOs4NEW2KuxR0Kyzr2MboWR5H0YZRk
	k291MaKecg6qGphcBhTybLBog38I9Lo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-15-LdiWRZCINieW0mfEquIkpQ-1; Fri,
 25 Apr 2025 05:19:17 -0400
X-MC-Unique: LdiWRZCINieW0mfEquIkpQ-1
X-Mimecast-MFC-AGG-ID: LdiWRZCINieW0mfEquIkpQ_1745572755
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65F7E19560AE;
	Fri, 25 Apr 2025 09:19:15 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 886F030001AB;
	Fri, 25 Apr 2025 09:19:13 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id EB81421E6766; Fri, 25 Apr 2025 11:19:10 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Eric Blake <eblake@redhat.com>,
  Michael Roth <michael.roth@amd.com>,  Daniel P . =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eduardo Habkost <eduardo@habkost.net>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  Shaoqin Huang <shahuang@redhat.com>,  Eric
 Auger <eauger@redhat.com>,  Peter Maydell <peter.maydell@linaro.org>,
  Laurent Vivier <lvivier@redhat.com>,  Thomas Huth <thuth@redhat.com>,
  Sebastian Ott <sebott@redhat.com>,  Gavin Shan <gshan@redhat.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  Dapeng Mi <dapeng1.mi@intel.com>,  Yi Lai <yi1.lai@intel.com>,
    =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
In-Reply-To: <20250409082649.14733-2-zhao1.liu@intel.com> (Zhao Liu's message
	of "Wed, 9 Apr 2025 16:26:45 +0800")
References: <20250409082649.14733-1-zhao1.liu@intel.com>
	<20250409082649.14733-2-zhao1.liu@intel.com>
Date: Fri, 25 Apr 2025 11:19:10 +0200
Message-ID: <87a584ha41.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Philippe, there's a question for you on target-specific QAPI schema.

Zhao Liu <zhao1.liu@intel.com> writes:

> Introduce the kvm-pmu-filter object and support the PMU event with raw
> format.
>
> The raw format, as a native PMU event code representation, can be used
> for several architectures.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>

[...]

> diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
> new file mode 100644
> index 000000000000..22f749bf9183
> --- /dev/null
> +++ b/accel/kvm/kvm-pmu.c

[...]

> +static const TypeInfo kvm_pmu_filter_info = {
> +    .parent = TYPE_OBJECT,
> +    .name = TYPE_KVM_PMU_FILTER,
> +    .class_init = kvm_pmu_filter_class_init,
> +    .instance_size = sizeof(KVMPMUFilter),
> +    .instance_init = kvm_pmu_filter_instance_init,
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_USER_CREATABLE },
> +        { }
> +    }
> +};
> +
> +static void kvm_pmu_event_register_type(void)
> +{
> +    type_register_static(&kvm_pmu_filter_info);
> +}
> +
> +type_init(kvm_pmu_event_register_type);
> diff --git a/accel/kvm/meson.build b/accel/kvm/meson.build
> index 397a1fe1fd1e..dfab2854f3a8 100644
> --- a/accel/kvm/meson.build
> +++ b/accel/kvm/meson.build
> @@ -2,6 +2,7 @@ kvm_ss = ss.source_set()
>  kvm_ss.add(files(
>    'kvm-all.c',
>    'kvm-accel-ops.c',
> +  'kvm-pmu.c',
>  ))
>  
>  specific_ss.add_all(when: 'CONFIG_KVM', if_true: kvm_ss)

The new file is compiled into the binary when CONFIG_KVM.  Therefore,
object kvm-pmu-filter is available exactly then.  Makes sense.
However, ...

[...]

> diff --git a/qapi/kvm.json b/qapi/kvm.json
> new file mode 100644
> index 000000000000..1861d86a9726
> --- /dev/null
> +++ b/qapi/kvm.json
> @@ -0,0 +1,84 @@
> +# -*- Mode: Python -*-
> +# vim: filetype=python
> +#
> +# Copyright (C) 2025 Intel Corporation.
> +#
> +# Author: Zhao Liu <zhao1.liu@intel.com>
> +#
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +
> +##
> +# == KVM
> +##
> +
> +##
> +# === PMU stuff (KVM related)
> +##
> +
> +##
> +# @KvmPmuFilterAction:
> +#
> +# Actions that KVM PMU filter supports.
> +#
> +# @deny: disable the PMU event/counter in KVM PMU filter.
> +#
> +# @allow: enable the PMU event/counter in KVM PMU filter.
> +#
> +# Since 10.1
> +##
> +{ 'enum': 'KvmPmuFilterAction',
> +  'data': ['allow', 'deny'] }
> +
> +##
> +# @KvmPmuEventFormat:
> +#
> +# Encoding formats of PMU event that QEMU/KVM supports.
> +#
> +# @raw: the encoded event code that KVM can directly consume.
> +#
> +# Since 10.1
> +##
> +{ 'enum': 'KvmPmuEventFormat',
> +  'data': ['raw'] }
> +
> +##
> +# @KvmPmuRawEvent:
> +#
> +# Raw PMU event code.
> +#
> +# @code: the raw value that has been encoded, and QEMU could deliver
> +#     to KVM directly.
> +#
> +# Since 10.1
> +##
> +{ 'struct': 'KvmPmuRawEvent',
> +  'data': { 'code': 'uint64' } }
> +
> +##
> +# @KvmPmuFilterEvent:
> +#
> +# PMU event filtered by KVM.
> +#
> +# @format: PMU event format.
> +#
> +# Since 10.1
> +##
> +{ 'union': 'KvmPmuFilterEvent',
> +  'base': { 'format': 'KvmPmuEventFormat' },
> +  'discriminator': 'format',
> +  'data': { 'raw': 'KvmPmuRawEvent' } }
> +
> +##
> +# @KvmPmuFilterProperties:
> +#
> +# Properties of KVM PMU Filter.
> +#
> +# @action: action that KVM PMU filter will take for selected PMU events.
> +#
> +# @events: list of selected PMU events.
> +#
> +# Since 10.1
> +##
> +{ 'struct': 'KvmPmuFilterProperties',
> +  'data': { 'action': 'KvmPmuFilterAction',
> +            '*events': ['KvmPmuFilterEvent'] } }

... the QAPI schema doesn't reflect that.

To make it reflect, we'd have to add 'if': 'CONFIG_KVM'.  Since
CONFIG_KVM can only be used in target-specific code, we'd have to put
the definitions in a target-specific schema module kvm-target.json.

This makes the headers generated for the module target-specific, which
can be inconvenient.  Whether it's inconvenient here, I can't say.

I understand target-specific QAPI modules are problematic for the single
binary / heterogeneous machine work.  Philippe, thoughts on this one?

[...]


