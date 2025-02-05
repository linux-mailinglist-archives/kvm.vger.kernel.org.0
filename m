Return-Path: <kvm+bounces-37311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97331A28664
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A69F23A75AE
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 09:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD3C22A7ED;
	Wed,  5 Feb 2025 09:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hyl2bIZ9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DEB22A4F6
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 09:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738747209; cv=none; b=WWoSz7ShpN4o8Dg62ZXL9dnIc2vuotaf8rcCoORzrGFbC7GI2Nesy6MaidyFjeD2kKtXDpVB5l+BCz1nWUaGLeuFBvvZlk+nxi9Eoxh4DusdXucYsKR3+aFNsIT9wjWQ+tbyPnw1OnUejgkuby11B0/Cmfebnzj+JIdMLPGiDCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738747209; c=relaxed/simple;
	bh=C5FlNtg9f1rIi4FV7GRUcTzoqztOmVXoh10s46EFTMU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dPZnoIih0w3bXN4wPREYp9EHu+ABpfhXLWZldqvfWfepPu1YY/7FzfkRoKAp6q4mgXvzVRIPZ062aXkwMUMKCodR2osPZYBugCtwhsYD+Ec4ryq+8sNz6mxd9KoGXoSxLkv6cWTd7aU6WkeKOTBcKhjeU8PsG5xL9LRXxRcBnC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hyl2bIZ9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738747207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RDDuMojfzA3TtjMm7/XpBRWReWktry4qKIVeq2mwHM4=;
	b=hyl2bIZ9pgCstsYTmU47qfC7iXeAOjZ/CnEKhjLjmacPfeZv/NdpCx1oWN/veXNF1BoTWh
	hx65VoE+A186SaHMZpSlTFaBAoLDUzyEbwHnBmyTz3L5HRX55w3WK1U+E1PEnHR1fcJiUa
	jYLs+C2S8R5ZBQgGjhCmmjhgnlizYnA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-096-Yk1wOR6Ql3cHg0YnXQ-1; Wed,
 05 Feb 2025 04:20:04 -0500
X-MC-Unique: 096-Yk1wOR6Ql3cHg0YnXQ-1
X-Mimecast-MFC-AGG-ID: 096-Yk1wOR6Ql3cHg0YnXQ
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6239A1800264;
	Wed,  5 Feb 2025 09:20:02 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.40])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9384818004A7;
	Wed,  5 Feb 2025 09:20:01 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 3D4EF21E6A28; Wed, 05 Feb 2025 10:19:59 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9?=
 <berrange@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  Igor
 Mammedov <imammedo@redhat.com>,  Zhao Liu <zhao1.liu@intel.com>,  "Michael
 S. Tsirkin" <mst@redhat.com>,  Eric Blake <eblake@redhat.com>,  Peter
 Maydell <peter.maydell@linaro.org>,  Marcelo Tosatti
 <mtosatti@redhat.com>,  Huacai Chen <chenhuacai@kernel.org>,  Rick
 Edgecombe <rick.p.edgecombe@intel.com>,  Francesco Lavra
 <francescolavra.fl@gmail.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org
Subject: Re: [PATCH v7 28/52] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
In-Reply-To: <20250124132048.3229049-29-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Fri, 24 Jan 2025 08:20:24 -0500")
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
	<20250124132048.3229049-29-xiaoyao.li@intel.com>
Date: Wed, 05 Feb 2025 10:19:59 +0100
Message-ID: <874j184ukg.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>
> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v6:
> - change error_code of GuestPanicInformationTdx from uint64_t to
>   uint32_t, to only contains the bit 31:0 returned in r12.
>
> Changes in v5:
> - mention additional error information in gpa when it presents;
> - refine the documentation; (Markus)
>
> Changes in v4:
> - refine the documentation; (Markus)
>
> Changes in v3:
> - Add docmentation of new type and struct; (Daniel)
> - refine the error message handling; (Daniel)
> ---
>  qapi/run-state.json   | 31 ++++++++++++++++++--
>  system/runstate.c     | 67 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.c | 24 +++++++++++++++-
>  3 files changed, 119 insertions(+), 3 deletions(-)
>
> diff --git a/qapi/run-state.json b/qapi/run-state.json
> index ce95cfa46b73..e63611780a2c 100644
> --- a/qapi/run-state.json
> +++ b/qapi/run-state.json
> @@ -501,10 +501,12 @@
>  #
>  # @s390: s390 guest panic information type (Since: 2.12)
>  #
> +# @tdx: tdx guest panic information type (Since: 9.0)

Since: 10.0

> +#
>  # Since: 2.9
>  ##
>  { 'enum': 'GuestPanicInformationType',
> -  'data': [ 'hyper-v', 's390' ] }
> +  'data': [ 'hyper-v', 's390', 'tdx' ] }
>  
>  ##
>  # @GuestPanicInformation:
> @@ -519,7 +521,8 @@
>   'base': {'type': 'GuestPanicInformationType'},
>   'discriminator': 'type',
>   'data': {'hyper-v': 'GuestPanicInformationHyperV',
> -          's390': 'GuestPanicInformationS390'}}
> +          's390': 'GuestPanicInformationS390',
> +          'tdx' : 'GuestPanicInformationTdx'}}
>  
>  ##
>  # @GuestPanicInformationHyperV:
> @@ -598,6 +601,30 @@
>            'psw-addr': 'uint64',
>            'reason': 'S390CrashReason'}}
>  
> +##
> +# @GuestPanicInformationTdx:
> +#
> +# TDX Guest panic information specific to TDX, as specified in the
> +# "Guest-Hypervisor Communication Interface (GHCI) Specification",
> +# section TDG.VP.VMCALL<ReportFatalError>.
> +#
> +# @error-code: TD-specific error code
> +#
> +# @message: Human-readable error message provided by the guest. Not
> +#     to be trusted.
> +#
> +# @gpa: guest-physical address of a page that contains more verbose
> +#     error information, as zero-terminated string.  Present when the
> +#     "GPA valid" bit (bit 63) is set in @error-code.
> +#
> +#
> +# Since: 10.0
> +##
> +{'struct': 'GuestPanicInformationTdx',
> + 'data': {'error-code': 'uint32',
> +          'message': 'str',
> +          '*gpa': 'uint64'}}
> +
>  ##
>  # @MEMORY_FAILURE:
>  #

With the since information corrected
Acked-by: Markus Armbruster <armbru@redhat.com>

[...]


