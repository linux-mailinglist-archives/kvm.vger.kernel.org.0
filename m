Return-Path: <kvm+bounces-15520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 882CB8AD012
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:02:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9DC61C21981
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5257E152504;
	Mon, 22 Apr 2024 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jN3i3kcS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A6E15217D
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 15:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713798165; cv=none; b=DeGuLCjq3H5j232PiingfTKogrfrv0mqXRj6YaU+B7ox1MVMC8ktlA3g/pa20coBFS4KcT/Lfm/75tQqiiCkHpEZ3G+G44FMXALWfGwED7JYrhMsHCNFv40JAxXbb9L613PLgW01HZdR97Choaf1aZ5rFCp4Rxfilu/cAqskDCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713798165; c=relaxed/simple;
	bh=rMpFUEWkwDPA/o+zpi1h3WFENZSgNNmdiBUDwiAOYaE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UAYzY9AmZoLosIExZwUcp2KSbVbh6owaqjv13rcVJN4wHg/75xzNyCwxgJNAkbsSKZXk0cR4jG8OoSHU9bK0ppZ6XwiZCkB1fLIktDMpFCvpP4wdfxfAh8cD/RnTBivEeLp9tSI+95xKnjfPNegxivHJ9PetjxG2nKfhCWvsyf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jN3i3kcS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713798162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M8UKMDNMdht0xCYu34T3ZRMGnjNKWNSBm/ALK2IpUgE=;
	b=jN3i3kcSJvo2Y2DqtbSN9zeeqzPpdjjbSMpwqnEFW4alrgv3qxwclmTH7ATq+qQP0TEK9S
	xhrm+wgXK+IW9iMlRJJUp/S8JzDFQyM9vvCvJsSxT+jrOdABY+ReudqrsTbwa7GStks5Hh
	Ug5u094m+OQrUNo+iy9t04sURpvmIL8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-AYslrkmtNr-K4HsClg9zpQ-1; Mon, 22 Apr 2024 11:02:37 -0400
X-MC-Unique: AYslrkmtNr-K4HsClg9zpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D4C780253A;
	Mon, 22 Apr 2024 15:02:36 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.247])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C5541C0654C;
	Mon, 22 Apr 2024 15:02:36 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id A144621E66C8; Mon, 22 Apr 2024 17:02:35 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: <qemu-devel@nongnu.org>,  <kvm@vger.kernel.org>,  Tom Lendacky
 <thomas.lendacky@amd.com>,  "Paolo Bonzini" <pbonzini@redhat.com>,  Daniel
 P . =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Pankaj Gupta
 <pankaj.gupta@amd.com>,
  Xiaoyao Li <xiaoyao.li@intel.com>,  Isaku Yamahata
 <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 36/49] i386/sev: Add KVM_EXIT_VMGEXIT handling for
 Extended Guest Requests
In-Reply-To: <20240320083945.991426-37-michael.roth@amd.com> (Michael Roth's
	message of "Wed, 20 Mar 2024 03:39:32 -0500")
References: <20240320083945.991426-1-michael.roth@amd.com>
	<20240320083945.991426-37-michael.roth@amd.com>
Date: Mon, 22 Apr 2024 17:02:35 +0200
Message-ID: <87frvdcues.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Michael Roth <michael.roth@amd.com> writes:

> The GHCB specification[1] defines a VMGEXIT-based Guest Request
> hypercall to allow an SNP guest to issue encrypted requests directly to
> SNP firmware to do things like query the attestation report for the
> guest. These are generally handled purely in the kernel.
>
> In some some cases, it's useful for the host to be able to additionally
> supply the certificate chain for the signing key that SNP firmware uses
> to sign these attestation reports. To allow for, the GHCB specification
> defines an Extended Guest Request where this certificate data can be
> provided in a special format described in the GHCB spec. This
> certificate data may be global or guest-specific depending on how the
> guest was configured. Rather than providing interfaces to manage these
> within the kernel, KVM handles this by forward the Extended Guest
> Requests on to userspace so the certificate data can be provided in the
> expected format.
>
> Add a certs-path parameter to the sev-snp-guest object so that it can
> be used to inject any certificate data into these Extended Guest
> Requests.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  qapi/qom.json     |  7 +++-
>  target/i386/sev.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 91 insertions(+), 1 deletion(-)
>
> diff --git a/qapi/qom.json b/qapi/qom.json
> index b25a3043da..7ba778af91 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -957,6 +957,10 @@
>  #             SNP_LAUNCH_FINISH command in the SEV-SNP firmware ABI
>  #             (default: all-zero)
>  #
> +# @certs-path: path to certificate data that can be passed to guests via
> +#              SNP Extended Guest Requests. File should be in the format
> +#              described in the GHCB specification. (default: none)

Is this a filename, or is it a search path of sorts?

> +#
>  # Since: 7.2
>  ##
>  { 'struct': 'SevSnpGuestProperties',
> @@ -967,7 +971,8 @@
>              '*id-block': 'str',
>              '*id-auth': 'str',
>              '*auth-key-enabled': 'bool',
> -            '*host-data': 'str' } }
> +            '*host-data': 'str',
> +            '*certs-path': 'str' } }
>  
>  ##
>  # @ThreadContextProperties:

[...]


