Return-Path: <kvm+bounces-9081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7CD185A3C1
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:48:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 788B1B24AE4
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A2F2E83F;
	Mon, 19 Feb 2024 12:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hGDpuIc6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB19129408
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 12:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708346913; cv=none; b=b6kb+wToUtepwo2xS8Dj8u4uCRCVUmEbUF3LQYKp9zGQXMeC5V9ObILVLh7mSyZjJAbB+g/Pk6C2xNa4wTmE5u5CPF+noxm9tQtz+H6oRXvwHmXAJAVmrzawbQMtbGtk7SLYyN8D/WJ/ofwtLf7mAciC8YXpZen9tcu5RYXbPtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708346913; c=relaxed/simple;
	bh=+F8C9GMABsRA82TtVjcloOcFhqfEL2IOPd0MH3K7Ohs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DaNIsCNUP/8AU9rXxgYRmf7dh6mh/VrnTZJ8iNZ6EfXhpr1f2JTPWB8qLMon78xOVcEPEuCkcfSIkuC8ptA3lGHN1XZErMaMf0fYTUIWPCaXCjWmSiQ73s8XQSwKYhFumBisTz4JQsk9Nf3WX+Ys5LFs4aPqAdj9xn1fEVfGubc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hGDpuIc6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708346910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QcQdbJQiRwyXUf1YN0AAQ3gmNVsZVc4jKp1T43zkGs=;
	b=hGDpuIc6YGPGCXzafH2KfL2zfOwUUJjsBuRsxz+nOMWCKGjZTlE1lSj6CSnVwNy23+QmNu
	OuS1sIrckbzsJxnw1YerpcWuE6MkfJvWO4GLFj3GZi4pGt4YZlcqRRO1Hxd8OTRsHjEUXv
	K+WcR5ZPqbgKVVIQkJ/0beSV2ZwSLDc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-kw20aGcYNy--qNOwiAH3Uw-1; Mon, 19 Feb 2024 07:48:27 -0500
X-MC-Unique: kw20aGcYNy--qNOwiAH3Uw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C6EE185A780;
	Mon, 19 Feb 2024 12:48:26 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.55])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C699CC185C0;
	Mon, 19 Feb 2024 12:48:25 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id B222321E6740; Mon, 19 Feb 2024 13:48:24 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  "Michael S .
 Tsirkin" <mst@redhat.com>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Richard Henderson <richard.henderson@linaro.org>,  Peter Xu
 <peterx@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Cornelia Huck <cohuck@redhat.com>,  Daniel P . =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric Blake <eblake@redhat.com>,  Marcelo Tosatti
 <mtosatti@redhat.com>,  qemu-devel@nongnu.org,  kvm@vger.kernel.org,
  Michael Roth <michael.roth@amd.com>,  Sean Christopherson
 <seanjc@google.com>,  Claudio Fontana <cfontana@suse.de>,  Gerd Hoffmann
 <kraxel@redhat.com>,  Isaku Yamahata <isaku.yamahata@gmail.com>,  Chenyi
 Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v4 29/66] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
In-Reply-To: <20240125032328.2522472-30-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Wed, 24 Jan 2024 22:22:51 -0500")
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
	<20240125032328.2522472-30-xiaoyao.li@intel.com>
Date: Mon, 19 Feb 2024 13:48:24 +0100
Message-ID: <875xykfwmf.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
> can be provided for TDX attestation. Detailed meaning of them can be
> found: https://lore.kernel.org/qemu-devel/31d6dbc1-f453-4cef-ab08-4813f4e=
0ff92@intel.com/
>
> Allow user to specify those values via property mrconfigid, mrowner and
> mrownerconfig. They are all in base64 format.
>
> example
> -object tdx-guest, \
>   mrconfigid=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRW=
eJq83v,\
>   mrowner=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq=
83v,\
>   mrownerconfig=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wE=
jRWeJq83v
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>
> ---
> Changes in v4:
>  - describe more of there fields in qom.json
>  - free the old value before set new value to avoid memory leak in
>    _setter(); (Daniel)
>
> Changes in v3:
>  - use base64 encoding instread of hex-string;
> ---
>  qapi/qom.json         | 14 ++++++-
>  target/i386/kvm/tdx.c | 87 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h |  3 ++
>  3 files changed, 103 insertions(+), 1 deletion(-)
>
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 2177f3101382..15445f9e41fc 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -905,10 +905,22 @@
>  #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>  #     be set, otherwise they refuse to boot.
>  #
> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
> +#     e.g., run-time or OS configuration.  base64 encoded SHA384 digest.

"base64 encoded SHA384" is not a sentence.

Double-checking: the data being hashed here is the "non-owner-defined
configuration of the guest TD", and the resulting hash is the "ID"?

> +#
> +# @mrowner: ID for the guest TD=E2=80=99s owner.  base64 encoded SHA384 =
digest.

Likewise.

> +#
> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
> +#     e.g., specific to the workload rather than the run-time or OS.
> +#     base64 encoded SHA384 digest.

Likewise.

> +#
>  # Since: 9.0
>  ##
>  { 'struct': 'TdxGuestProperties',
> -  'data': { '*sept-ve-disable': 'bool' } }
> +  'data': { '*sept-ve-disable': 'bool',
> +            '*mrconfigid': 'str',
> +            '*mrowner': 'str',
> +            '*mrownerconfig': 'str' } }

The new members are optional, but their description in the doc comment
doesn't explain behavior when present vs. behavior when absent.

>=20=20
>  ##
>  # @ThreadContextProperties:

[...]


