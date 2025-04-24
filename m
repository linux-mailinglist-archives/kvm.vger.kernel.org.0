Return-Path: <kvm+bounces-44127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52799A9AD17
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89C19462D71
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB3422B595;
	Thu, 24 Apr 2025 12:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXPYnWkO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E83D225A40
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 12:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745497120; cv=none; b=bDzr/5a7/DoCWpyXpjTDbJnXnxTMV4ktwIxmn6e3j05NyaddhKN6xaN7poMTRaRo6O6kZQFJ6kaq2AW6xZGuCfXV4z8MnheUEPtXrKGsvNpt3egzk6EcwrICLqY8V57Du+q/A+Lr4ZjTaoXe4r0OH0rH0j0LN2yUCuWYKKDcZLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745497120; c=relaxed/simple;
	bh=mcKkQ09cqsVRLUDUXb0u2KP55QQ/vNPz3pJzQ9VsnJU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iYJDf+lpxw7YNOIRtLaR1NPoLVbMthyQloiedBJ8BplS9ZuilOilA2ZxynIpVdb+YzPAfzhSfrEDrtvaxwXhBL2L0K4plv+809F6Z1eoUrl7Q6gZw014f02nhthSyAt0oVayfN+S9MAK8i1TS/2hzQ7czaM3cqB4XjbsszaOhFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eXPYnWkO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745497113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eqa/wyHkA5Rds0zkDQ8ijbjXqasl+g3gbnyFVrmdGMA=;
	b=eXPYnWkOKkcEH7+jkZPvy01rKO873Vlt5r/JTSqjXOKNbZky0W8oAbraXrL7QhKaHgENRJ
	bBG6qOdSZP71twOdkXLIlUpxR+un/Ed7QNQ4MsDBIWWihvaqmhj08/bDbLu/otl4tT+0A/
	PuphcsCQ6mcEI0BfRxtFSrAW6vQ65AU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-eDini4p0PFG706XdvBSijg-1; Thu,
 24 Apr 2025 08:18:30 -0400
X-MC-Unique: eDini4p0PFG706XdvBSijg-1
X-Mimecast-MFC-AGG-ID: eDini4p0PFG706XdvBSijg_1745497109
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7EA4F1800368;
	Thu, 24 Apr 2025 12:18:27 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77833180047F;
	Thu, 24 Apr 2025 12:18:25 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 08CA921E66C3; Thu, 24 Apr 2025 14:18:23 +0200 (CEST)
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
  Dapeng Mi <dapeng1.mi@intel.com>,  Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
In-Reply-To: <20250409082649.14733-2-zhao1.liu@intel.com> (Zhao Liu's message
	of "Wed, 9 Apr 2025 16:26:45 +0800")
References: <20250409082649.14733-1-zhao1.liu@intel.com>
	<20250409082649.14733-2-zhao1.liu@intel.com>
Date: Thu, 24 Apr 2025 14:18:22 +0200
Message-ID: <87tt6d4usx.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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

> diff --git a/qapi/accelerator.json b/qapi/accelerator.json
> new file mode 100644
> index 000000000000..1fe0d64be113
> --- /dev/null
> +++ b/qapi/accelerator.json
> @@ -0,0 +1,14 @@
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
> +# = Accelerators
> +##
> +
> +{ 'include': 'kvm.json' }
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

There's KVM-specific stuff elsewhere in the schema.  Some if of it
should probably be moved here.  Can you have a look?  This is not a
demand; it's fine if you can't.  If you can: separate patch preceding
this one to create kvm.json and move stuff there.

> +
> +##
> +# === PMU stuff (KVM related)

The KVM subsection contains just this subsubsection.  Awkward.  Can we
do without this subsubsection now?  We can always add it later, when we
have enough KVM stuff to warrant structuring it into subsubsections.

If we decide we want it:

   # === KVM performance monitor unit (PMU)

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

Maybe KvmPmuFilterEventFormat?  Or is that too long?

> +#
> +# Encoding formats of PMU event that QEMU/KVM supports.
> +#
> +# @raw: the encoded event code that KVM can directly consume.

Suggest

   # @raw: raw KVM PMU event code.

> +#
> +# Since 10.1
> +##
> +{ 'enum': 'KvmPmuEventFormat',
> +  'data': ['raw'] }
> +
> +##
> +# @KvmPmuRawEvent:

Maybe KvmPmuFilterEventRaw?  Or is that too long?

> +#
> +# Raw PMU event code.
> +#
> +# @code: the raw value that has been encoded, and QEMU could deliver
> +#     to KVM directly.

Suggest

   ##
   # @KvmPmuRawEvent
   #
   # @code: raw KVM PMU event code, to be passed verbatim to KVM.

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

Suggest

   # A KVM PMU event specification.

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

Here's my try:

   # Properties of kvm-pmu-filter objects.  A kvm-pmu-filter object
   # restricts the guest's access to the PMU with either an allowlist or
   # a denylist.
   #
   # @action: whether @events is an allowlist or a denylist.
   #
   # @events: list of KVM PMU event specifications.

> +#
> +# Since 10.1
> +##
> +{ 'struct': 'KvmPmuFilterProperties',
> +  'data': { 'action': 'KvmPmuFilterAction',
> +            '*events': ['KvmPmuFilterEvent'] } }
> diff --git a/qapi/meson.build b/qapi/meson.build
> index eadde4db307f..dba27ebc7489 100644
> --- a/qapi/meson.build
> +++ b/qapi/meson.build
> @@ -37,6 +37,7 @@ qapi_all_modules = [
>    'error',
>    'introspect',
>    'job',
> +  'kvm',
>    'machine-common',
>    'machine',
>    'machine-target',
> diff --git a/qapi/qapi-schema.json b/qapi/qapi-schema.json
> index c41c01eb2ab9..c7fed7940af7 100644
> --- a/qapi/qapi-schema.json
> +++ b/qapi/qapi-schema.json
> @@ -66,6 +66,7 @@
>  { 'include': 'compat.json' }
>  { 'include': 'control.json' }
>  { 'include': 'introspect.json' }
> +{ 'include': 'accelerator.json' }
>  { 'include': 'qom.json' }
>  { 'include': 'qdev.json' }
>  { 'include': 'machine-common.json' }
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 28ce24cd8d08..517f4c06c260 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -8,6 +8,7 @@
>  { 'include': 'block-core.json' }
>  { 'include': 'common.json' }
>  { 'include': 'crypto.json' }
> +{ 'include': 'kvm.json' }
>  
>  ##
>  # = QEMU Object Model (QOM)
> @@ -1108,6 +1109,7 @@
>        'if': 'CONFIG_LINUX' },
>      'iommufd',
>      'iothread',
> +    'kvm-pmu-filter',
>      'main-loop',
>      { 'name': 'memory-backend-epc',
>        'if': 'CONFIG_LINUX' },
> @@ -1183,6 +1185,7 @@
>                                        'if': 'CONFIG_LINUX' },
>        'iommufd':                    'IOMMUFDProperties',
>        'iothread':                   'IothreadProperties',
> +      'kvm-pmu-filter':             'KvmPmuFilterProperties',
>        'main-loop':                  'MainLoopProperties',
>        'memory-backend-epc':         { 'type': 'MemoryBackendEpcProperties',
>                                        'if': 'CONFIG_LINUX' },


