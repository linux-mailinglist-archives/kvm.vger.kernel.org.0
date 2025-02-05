Return-Path: <kvm+bounces-37317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E1CA28749
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86498169499
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C5021C192;
	Wed,  5 Feb 2025 10:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="alq/5FvK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F8B1547D8
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 10:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738749846; cv=none; b=EyguRgfnEH3exxmms/25wyLGO8KQApQuuDmpJssd8iKQrLNyOd6Kh/rbr7dRFxhKXovr0i2wQtv/Q5VRXzCF03tEf/Yh+UKka57FPRW0WECJOKsKYAi1+z5qppWxx96JwHS1Yl8Gm8uqLdbuag3pCJle0+uDCPH+wSyCI0xSWdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738749846; c=relaxed/simple;
	bh=82fc+VmARm260icKaXEErWbrNxkHZkRFxsf3XJLyAqU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BTmsWC49GtW2E8DxP7tTBRr5s8W65OIhHx7VnXlY7M8coYOnqjolouhu44Bju+5ejp0oCHojehsLJ4/2N2SplHM8wowIYe0U8p+d4BJKznhpqqCrLDLMvzdWaNpY+IjME8iwqjxRRXKnVCeAs/Aos8pZhx1LgJOXXU2BxMNCKF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=alq/5FvK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738749842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VzUQ4vCBJpKzzDMO8biGgL6OeuyevSJKcbaC42p67oY=;
	b=alq/5FvKAWyxUUFZvqNHWU+jgxbAGBg4xQLFz+ePnBDPcw9yFVGYWldnlyNQpYMeTqdB+k
	OJLR9I1+HnNg7AA+7vqj4S1QXOCLxXHAQEClCPirq6lzW19bgcaxxu4wbdUuphRJItKpjz
	6ePhYU74ablcMRvxAX6o76qoJYkEdKA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-vQG75amlMDejvhFzrI5qyQ-1; Wed,
 05 Feb 2025 05:03:58 -0500
X-MC-Unique: vQG75amlMDejvhFzrI5qyQ-1
X-Mimecast-MFC-AGG-ID: vQG75amlMDejvhFzrI5qyQ
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B43BD1956094;
	Wed,  5 Feb 2025 10:03:55 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.40])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1C0918004A7;
	Wed,  5 Feb 2025 10:03:53 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 6D80521E6A28; Wed, 05 Feb 2025 11:03:51 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Eric Blake <eblake@redhat.com>,
  Markus Armbruster <armbru@redhat.com>,  Michael Roth
 <michael.roth@amd.com>,  Daniel P . =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,
  Eduardo Habkost <eduardo@habkost.net>,  Marcelo Tosatti
 <mtosatti@redhat.com>,  Shaoqin Huang <shahuang@redhat.com>,  Eric Auger
 <eauger@redhat.com>,  Peter Maydell <peter.maydell@linaro.org>,  Laurent
 Vivier <lvivier@redhat.com>,  Thomas Huth <thuth@redhat.com>,  Sebastian
 Ott <sebott@redhat.com>,  Gavin Shan <gshan@redhat.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  Dapeng Mi <dapeng1.mi@intel.com>,  Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 1/5] qapi/qom: Introduce kvm-pmu-filter object
In-Reply-To: <20250122090517.294083-2-zhao1.liu@intel.com> (Zhao Liu's message
	of "Wed, 22 Jan 2025 17:05:13 +0800")
References: <20250122090517.294083-1-zhao1.liu@intel.com>
	<20250122090517.294083-2-zhao1.liu@intel.com>
Date: Wed, 05 Feb 2025 11:03:51 +0100
Message-ID: <871pwc3dyw.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Quick & superficial review for now.

Zhao Liu <zhao1.liu@intel.com> writes:

> Introduce the kvm-pmu-filter object and support the PMU event with raw
> format.
>
> The raw format, as a native PMU event code representation, can be used
> for several architectures.
>
> Considering that PMU event related fields are commonly used in
> hexadecimal, define KVMPMURawEventVariant, KVMPMUFilterEventVariant, and
> KVMPMUFilterPropertyVariant in kvm.json to support hexadecimal number
> strings in JSON.
>
> Additionally, define the corresponding numeric versions of
> KVMPMURawEvent, KVMPMUFilterEvent, and KVMPMUFilterProperty in kvm.json.
> This allows to handle numeric values more effectively and take advantage
> of the qapi helpers.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

[...]

> diff --git a/qapi/kvm.json b/qapi/kvm.json
> new file mode 100644
> index 000000000000..d51aeeba7cd8
> --- /dev/null
> +++ b/qapi/kvm.json
> @@ -0,0 +1,116 @@
> +# -*- Mode: Python -*-
> +# vim: filetype=python
> +
> +##
> +# = KVM based feature API

This is a top-level section.  It ends up between sections "QMP
introspection" and "QEMU Object Model (QOM)".  Is this what we want?  Or
should it be a sub-section of something?  Or next to something else?

> +##
> +
> +##
> +# @KVMPMUFilterAction:
> +#
> +# Actions that KVM PMU filter supports.
> +#
> +# @deny: disable the PMU event/counter in KVM PMU filter.
> +#
> +# @allow: enable the PMU event/counter in KVM PMU filter.
> +#
> +# Since 10.0
> +##
> +{ 'enum': 'KVMPMUFilterAction',
> +  'prefix': 'KVM_PMU_FILTER_ACTION',
> +  'data': ['allow', 'deny'] }
> +
> +##
> +# @KVMPMUEventEncodeFmt:

Please don't abbreviate Format to Fmt.  We use Format elsewhere, and
consistency is desirable.

> +#
> +# Encoding formats of PMU event that QEMU/KVM supports.
> +#
> +# @raw: the encoded event code that KVM can directly consume.
> +#
> +# Since 10.0
> +##
> +{ 'enum': 'KVMPMUEventEncodeFmt',
> +  'prefix': 'KVM_PMU_EVENT_FMT',
> +  'data': ['raw'] }
> +
> +##
> +# @KVMPMURawEvent:
> +#
> +# Raw PMU event code.
> +#
> +# @code: the raw value that has been encoded, and QEMU could deliver
> +#     to KVM directly.
> +#
> +# Since 10.0
> +##
> +{ 'struct': 'KVMPMURawEvent',
> +  'data': { 'code': 'uint64' } }
> +
> +##
> +# @KVMPMUFilterEvent:
> +#
> +# PMU event filtered by KVM.
> +#
> +# @format: PMU event format.
> +#
> +# Since 10.0
> +##
> +{ 'union': 'KVMPMUFilterEvent',
> +  'base': { 'format': 'KVMPMUEventEncodeFmt' },
> +  'discriminator': 'format',
> +  'data': { 'raw': 'KVMPMURawEvent' } }
> +
> +##
> +# @KVMPMUFilterProperty:
> +#
> +# Property of KVM PMU Filter.
> +#
> +# @events: the KVMPMUFilterEvent list.
> +#
> +# Since 10.0
> +##
> +{ 'struct': 'KVMPMUFilterProperty',
> +  'data': { '*events': ['KVMPMUFilterEvent'] } }
> +
> +##
> +# @KVMPMURawEventVariant:
> +#
> +# The variant of KVMPMURawEvent with the string, rather than the
> +# numeric value.
> +#
> +# @code: the raw value that has been encoded, and QEMU could deliver
> +#     to KVM directly.  This field is a uint64 string.
> +#
> +# Since 10.0
> +##
> +{ 'struct': 'KVMPMURawEventVariant',
> +  'data': { 'code': 'str' } }
> +
> +##
> +# @KVMPMUFilterEventVariant:
> +#
> +# The variant of KVMPMUFilterEvent.
> +#
> +# @format: PMU event format.
> +#
> +# Since 10.0
> +##
> +{ 'union': 'KVMPMUFilterEventVariant',
> +  'base': { 'format': 'KVMPMUEventEncodeFmt' },
> +  'discriminator': 'format',
> +  'data': { 'raw': 'KVMPMURawEventVariant' } }
> +
> +##
> +# @KVMPMUFilterPropertyVariant:
> +#
> +# The variant of KVMPMUFilterProperty.
> +#
> +# @action: action that KVM PMU filter will take.
> +#
> +# @events: the KVMPMUFilterEventVariant list.
> +#
> +# Since 10.0
> +##
> +{ 'struct': 'KVMPMUFilterPropertyVariant',
> +  'data': { 'action': 'KVMPMUFilterAction',
> +            '*events': ['KVMPMUFilterEventVariant'] } }
> diff --git a/qapi/meson.build b/qapi/meson.build
> index e7bc54e5d047..856439c76b67 100644
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
> index b1581988e4eb..742818d16e45 100644
> --- a/qapi/qapi-schema.json
> +++ b/qapi/qapi-schema.json
> @@ -64,6 +64,7 @@
>  { 'include': 'compat.json' }
>  { 'include': 'control.json' }
>  { 'include': 'introspect.json' }
> +{ 'include': 'kvm.json' }
>  { 'include': 'qom.json' }
>  { 'include': 'qdev.json' }
>  { 'include': 'machine-common.json' }
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 28ce24cd8d08..c75ec4b21e95 100644
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
> +      'kvm-pmu-filter':             'KVMPMUFilterPropertyVariant',

The others are like

         'mumble': 'MumbleProperties'

Let's stick to that, and also avoid running together multiple
capitalized acronyms: KvmPmuFilterProperties.

>        'main-loop':                  'MainLoopProperties',
>        'memory-backend-epc':         { 'type': 'MemoryBackendEpcProperties',
>                                        'if': 'CONFIG_LINUX' },


