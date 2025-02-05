Return-Path: <kvm+bounces-37310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD65A2861C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:07:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA302188645A
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 09:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570F722A4CD;
	Wed,  5 Feb 2025 09:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cPW9+adf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B8E219A6E
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 09:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738746419; cv=none; b=ZhOy3TSu4SXwwGuSpMPRmCjJfSxg1Il5HUGxez7HT5ugeGRgrNWdHJIR2Jv+F0/F9X+ooiOsxBt8QD+rHD+LaUva8FgBYs8XBSLdHgKTOmLG4Qv8GDh+YCs7W1ZcAlLm0++T2SlU/EKBtUIVbP4fVS8lmSyCH/995qPhMHIYcXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738746419; c=relaxed/simple;
	bh=4b43j9UBJq5Cuw7HFViA2rSQ4rhSkdLGk6228giOKVs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=sH9CMRHlrpucniom2JX/KmcL4qf85rkeDo7sqsXThpLMaCcBB41NbFCm4w7q0c9nKAdJO4CXcZxDtoyO9RdRZOWzMmjl065CXtTXv5TfoZrjeH6RmG29oWxiBuxECOjl6p0erM+eIOycukXCmXzpD0NjvlVxp6L4opTeVQpR+io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cPW9+adf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738746415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8VMVgiAdSJJx4Yt6je91mqO890uzHAfBCBH1el+e/CQ=;
	b=cPW9+adfVgYmq601W11HMcAiSgJTFZD+hUvQpf7DnnbH3cTpvjMMtqfg9kUQ3/yqH4Fzbt
	hUpRZFWw+miAukxQPV7JwVv4mzI11EoiqwNeifc4162FIKCvGJd6lj3FPPViqtHiUbseV0
	rbNixj0hUgilBx+upNJAVXU4EKm7+DU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-Wq6XyF8mPdSeR_g2vWNSrA-1; Wed,
 05 Feb 2025 04:06:51 -0500
X-MC-Unique: Wq6XyF8mPdSeR_g2vWNSrA-1
X-Mimecast-MFC-AGG-ID: Wq6XyF8mPdSeR_g2vWNSrA
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB455180087B;
	Wed,  5 Feb 2025 09:06:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.40])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F3561800872;
	Wed,  5 Feb 2025 09:06:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 1F9ED21E6A28; Wed, 05 Feb 2025 10:06:45 +0100 (CET)
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
Subject: Re: [PATCH v7 12/52] i386/tdx: Validate TD attributes
In-Reply-To: <20250124132048.3229049-13-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Fri, 24 Jan 2025 08:20:08 -0500")
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
	<20250124132048.3229049-13-xiaoyao.li@intel.com>
Date: Wed, 05 Feb 2025 10:06:45 +0100
Message-ID: <878qqk4v6i.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Validate TD attributes with tdx_caps that only supported bits arer
> allowed by KVM.
>
> Besides, sanity check the attribute bits that have not been supported by
> QEMU yet. e.g., debug bit, it will be allowed in the future when debug
> TD support lands in QEMU.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
> Changes in v7:
> - Define TDX_SUPPORTED_TD_ATTRS as QEMU supported mask, to validates
>   user's request. (Rick)
>
> Changes in v3:
> - using error_setg() for error report; (Daniel)
> ---
>  qapi/qom.json         |  16 +++++-
>  target/i386/kvm/tdx.c | 118 +++++++++++++++++++++++++++++++++++++++++-
>  target/i386/kvm/tdx.h |   3 ++
>  3 files changed, 134 insertions(+), 3 deletions(-)
>
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 8740626c4ee6..a53000ca6fb4 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1060,11 +1060,25 @@
>  #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>  #     be set, otherwise they refuse to boot.
>  #
> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
> +#     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
> +#     Defaults to all zeros.
> +#
> +# @mrowner: ID for the guest TD=E2=80=99s owner (base64 encoded SHA384 d=
igest).
> +#     Defaults to all zeros.
> +#
> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
> +#     e.g., specific to the workload rather than the run-time or OS
> +#     (base64 encoded SHA384 digest).  Defaults to all zeros.

All three members are IDs, but only the first one has "id" in its name.
Odd.  Any particular reason for that?

> +#
>  # Since: 10.0
>  ##
>  { 'struct': 'TdxGuestProperties',
>    'data': { '*attributes': 'uint64',
> -            '*sept-ve-disable': 'bool' } }
> +            '*sept-ve-disable': 'bool',
> +            '*mrconfigid': 'str',
> +            '*mrowner': 'str',
> +            '*mrownerconfig': 'str' } }

The member names are abbreviations all run together, wheras QAPI/QMP
favors words-separated-with-dashes.  If you invented them, please change
them to QAPI/QMP style.  If they are established TDX terminology, keep
them as they are, but please show us your evidence.

>=20=20
>  ##
>  # @ThreadContextProperties:

[...]


