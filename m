Return-Path: <kvm+bounces-37318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 66AC6A287A8
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5E367A9240
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80D322ACFB;
	Wed,  5 Feb 2025 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZuaZSqTV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3BE22A4DB
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 10:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738750041; cv=none; b=KhkXLZc5QJyrc+IEGgFbPcd1IGO1NizqWH+fwYKqfCujTiVGINC/oeTQi1OX/BUPApaMkasHdQ8RDEw8fLt6zX42MDJ+ULxMRu1te1hi7Ved7xGJWQ8zpjgVoeWHr8FMSLwvOwZ0Fv8oVuY47IFHNk+ttpfLYWqww1anQQ73uDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738750041; c=relaxed/simple;
	bh=AgN3rnMJ1Kifx81r54s8UblOI2eyRbC2f4ndI+Qi1b8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZjjKCw+mbEwKbAFjwCCTtObuqjfy52xs6J6Mul7DVC5UOa0xXX3HRVY3J08KRagjNPKKuQGjdH3h21be0ZTcJ7OLTLr4SQO+4QRqq/KgTsfpMbOFDB2uGICJOyQ/8qPESd7T6JhrGAEUvqQrk18RWfUr7lOXo9K20P5yGt1a1IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZuaZSqTV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738750038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zDoZmkitSBKZ8WS2tPZOpQfMN+YQSBeT3+5PJja8Yo=;
	b=ZuaZSqTVizq/iC4yhNpMaHlWsbugFiVqrpaTM2OMgic70vXtuaMusB5FJ1REaMeTatHdQf
	CzZxoFQkN0mK4Vbht8RGdmlSfa8nlLzF77KntmcIKYRTH1lYhhvbFnmcG3nG0NOsH+shNF
	+rr7/US2CszMo4Dkn8SlUqsVeu6YgAg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-240-_xxC_nefP8Gptcel8UouCw-1; Wed,
 05 Feb 2025 05:07:15 -0500
X-MC-Unique: _xxC_nefP8Gptcel8UouCw-1
X-Mimecast-MFC-AGG-ID: _xxC_nefP8Gptcel8UouCw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BE0819560B6;
	Wed,  5 Feb 2025 10:07:13 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.40])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABD7019560A3;
	Wed,  5 Feb 2025 10:07:12 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 64CC221E6A28; Wed, 05 Feb 2025 11:07:10 +0100 (CET)
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
Subject: Re: [RFC v2 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
In-Reply-To: <20250122090517.294083-4-zhao1.liu@intel.com> (Zhao Liu's message
	of "Wed, 22 Jan 2025 17:05:15 +0800")
References: <20250122090517.294083-1-zhao1.liu@intel.com>
	<20250122090517.294083-4-zhao1.liu@intel.com>
Date: Wed, 05 Feb 2025 11:07:10 +0100
Message-ID: <87zfj01z8x.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Zhao Liu <zhao1.liu@intel.com> writes:

> The select&umask is the common way for x86 to identify the PMU event,
> so support this way as the "x86-default" format in kvm-pmu-filter
> object.

So, format 'raw' lets you specify the PMU event code as a number, wheras
'x86-default' lets you specify it as select and umask, correct?

Why do we want both?

> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

[...]

> diff --git a/qapi/kvm.json b/qapi/kvm.json
> index d51aeeba7cd8..93b869e3f90c 100644
> --- a/qapi/kvm.json
> +++ b/qapi/kvm.json
> @@ -27,11 +27,13 @@
>  #
>  # @raw: the encoded event code that KVM can directly consume.
>  #
> +# @x86-default: standard x86 encoding format with select and umask.

Why is this named -default?

> +#
>  # Since 10.0
>  ##
>  { 'enum': 'KVMPMUEventEncodeFmt',
>    'prefix': 'KVM_PMU_EVENT_FMT',
> -  'data': ['raw'] }
> +  'data': ['raw', 'x86-default'] }
>  
>  ##
>  # @KVMPMURawEvent:
> @@ -46,6 +48,25 @@
>  { 'struct': 'KVMPMURawEvent',
>    'data': { 'code': 'uint64' } }
>  
> +##
> +# @KVMPMUX86DefalutEvent:

Default, I suppose.

> +#
> +# x86 PMU event encoding with select and umask.
> +# raw_event = ((select & 0xf00UL) << 24) | \
> +#              (select) & 0xff) | \
> +#              ((umask) & 0xff) << 8)

Sphinx rejects this with "Unexpected indentation."

Is the formula needed here?

> +#
> +# @select: x86 PMU event select field, which is a 12-bit unsigned
> +#     number.
> +#
> +# @umask: x86 PMU event umask field.
> +#
> +# Since 10.0
> +##
> +{ 'struct': 'KVMPMUX86DefalutEvent',
> +  'data': { 'select': 'uint16',
> +            'umask': 'uint8' } }
> +
>  ##
>  # @KVMPMUFilterEvent:
>  #
> @@ -58,7 +79,8 @@
>  { 'union': 'KVMPMUFilterEvent',
>    'base': { 'format': 'KVMPMUEventEncodeFmt' },
>    'discriminator': 'format',
> -  'data': { 'raw': 'KVMPMURawEvent' } }
> +  'data': { 'raw': 'KVMPMURawEvent',
> +            'x86-default': 'KVMPMUX86DefalutEvent' } }
>  
>  ##
>  # @KVMPMUFilterProperty:
> @@ -86,6 +108,23 @@
>  { 'struct': 'KVMPMURawEventVariant',
>    'data': { 'code': 'str' } }
>  
> +##
> +# @KVMPMUX86DefalutEventVariant:
> +#
> +# The variant of KVMPMUX86DefalutEvent with the string, rather than
> +# the numeric value.
> +#
> +# @select: x86 PMU event select field.  This field is a 12-bit
> +#     unsigned number string.
> +#
> +# @umask: x86 PMU event umask field. This field is a uint8 string.

Why are these strings?  How are they parsed into numbers?

> +#
> +# Since 10.0
> +##
> +{ 'struct': 'KVMPMUX86DefalutEventVariant',
> +  'data': { 'select': 'str',
> +            'umask': 'str' } }
> +
>  ##
>  # @KVMPMUFilterEventVariant:
>  #
> @@ -98,7 +137,8 @@
>  { 'union': 'KVMPMUFilterEventVariant',
>    'base': { 'format': 'KVMPMUEventEncodeFmt' },
>    'discriminator': 'format',
> -  'data': { 'raw': 'KVMPMURawEventVariant' } }
> +  'data': { 'raw': 'KVMPMURawEventVariant',
> +            'x86-default': 'KVMPMUX86DefalutEventVariant' } }
>  
>  ##
>  # @KVMPMUFilterPropertyVariant:

[...]


