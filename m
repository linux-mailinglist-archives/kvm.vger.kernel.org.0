Return-Path: <kvm+bounces-3099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC0C800910
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:52:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BE5E1C208E0
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66AA820B21;
	Fri,  1 Dec 2023 10:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJ6ymi2+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B568129
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 02:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701427965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9WB/DrQbi3LPDzD90+cir5HMSCD/2WMQTN7AHc14k3Q=;
	b=NJ6ymi2+JtCc9ao7ByKGvVjIVpC/ttuP+e6LZCTddwND5Juc5ou/AgUqhEuStOSIHsqKui
	WuGJAVGMohjbe/pOQsYt6oTYg09Osjcb9FeH4bWNXsq2Axi14RW3M3ffQRdOv7WGH/r8+L
	xblIpViFiex4dUKs0lF86IfVFsdYkoU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-P4sm2rC3N0K-pLezUbXi4g-1; Fri, 01 Dec 2023 05:52:42 -0500
X-MC-Unique: P4sm2rC3N0K-pLezUbXi4g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 950618007B3;
	Fri,  1 Dec 2023 10:52:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FBA02166B26;
	Fri,  1 Dec 2023 10:52:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 665FC21E6A1F; Fri,  1 Dec 2023 11:52:40 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  "Michael S .
 Tsirkin" <mst@redhat.com>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Richard Henderson <richard.henderson@linaro.org>,  Peter Xu
 <peterx@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Cornelia Huck <cohuck@redhat.com>,  Daniel P . =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric Blake <eblake@redhat.com>,  Markus Armbruster
 <armbru@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org,  Michael Roth
 <michael.roth@amd.com>,  Sean Christopherson <seanjc@google.com>,  Claudio
 Fontana <cfontana@suse.de>,  Gerd Hoffmann <kraxel@redhat.com>,  Isaku
 Yamahata <isaku.yamahata@gmail.com>,  Chenyi Qiang
 <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 13/70] i386: Introduce tdx-guest object
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
	<20231115071519.2864957-14-xiaoyao.li@intel.com>
Date: Fri, 01 Dec 2023 11:52:40 +0100
In-Reply-To: <20231115071519.2864957-14-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Wed, 15 Nov 2023 02:14:22 -0500")
Message-ID: <87ttp2w5xj.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Introduce tdx-guest object which implements the interface of
> CONFIDENTIAL_GUEST_SUPPORT, and will be used to create TDX VMs (TDs) by
>
>   qemu -machine ...,confidential-guest-support=tdx0	\
>        -object tdx-guest,id=tdx0
>
> It has only one member 'attributes' with fixed value 0 and not
> configurable so far.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> Acked-by: Markus Armbruster <armbru@redhat.com>

[...]

> diff --git a/qapi/qom.json b/qapi/qom.json
> index c53ef978ff7e..8e08257dac2f 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -878,6 +878,16 @@
>              'reduced-phys-bits': 'uint32',
>              '*kernel-hashes': 'bool' } }
>  
> +##
> +# @TdxGuestProperties:
> +#
> +# Properties for tdx-guest objects.
> +#
> +# Since: 8.2

Going to be 9.0.

> +##
> +{ 'struct': 'TdxGuestProperties',
> +  'data': { }}
> +
>  ##
>  # @ThreadContextProperties:
>  #
> @@ -956,6 +966,7 @@
>      'sev-guest',
>      'thread-context',
>      's390-pv-guest',
> +    'tdx-guest',
>      'throttle-group',
>      'tls-creds-anon',
>      'tls-creds-psk',
> @@ -1022,6 +1033,7 @@
>        'secret_keyring':             { 'type': 'SecretKeyringProperties',
>                                        'if': 'CONFIG_SECRET_KEYRING' },
>        'sev-guest':                  'SevGuestProperties',
> +      'tdx-guest':                  'TdxGuestProperties',
>        'thread-context':             'ThreadContextProperties',
>        'throttle-group':             'ThrottleGroupProperties',
>        'tls-creds-anon':             'TlsCredsAnonProperties',

[...]


