Return-Path: <kvm+bounces-9078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B29F85A38B
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:35:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B503F1F23427
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA07832193;
	Mon, 19 Feb 2024 12:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TDnNKEyx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184E631A89
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 12:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708346084; cv=none; b=MfWeS8uNZ+hZBio6feSYpfpL7P9+gjbM8D1PZSxjbBAd6V1HGHAiBaB9PdJNbZ2OeR/jO5LnpZhkD6c+Ba4652jGJFmBPxhQ8vK+CVBiwjo4NNCzC/aqR5PyEOucVQt5Z394on4UMrq3RmIUmZSWsxgf4hbELUu/IY72iVAFOjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708346084; c=relaxed/simple;
	bh=BSfPg5r6EJwBU3MhmT/jVsEW07bnFd2SEWTUdSL6FPA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Y4Hyvk44VPVrvQ07G7CJBoWIm7cgyfjAG95uwTiluILLZ3ld7z/xMiQNU9RpWY9LXNPsyScfdmGFOoNkcNtONv+zuX4wM2mwGIX8Z8xsjgIU5QBEmCd9EcGldp97O5JqZ+lP50YfBhypB5Um76KgTy37ea1X47nByJQbRonDpFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TDnNKEyx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708346080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i1xFjzrx1FsNyRKzs2KQj6cKvo6mP0Et2w5wO8f+wKY=;
	b=TDnNKEyxn4D6HbTVImquWCn5Ww13HwB05q1A657DeFlFHYep96R5+PX5rMSRhmX6lXJ4xs
	Sv+qxRzBKDnDPJdl+cRQL1gxKdvT5kaB59RQ6dESyENiAejIrOy0rD6oSPKLM9O+FrB8sl
	bIYt5uBxeDTUHbxRwaiUzpm0OJ/9dF4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-FbnK2GDEOG64yZwe4j2Z-g-1; Mon, 19 Feb 2024 07:34:39 -0500
X-MC-Unique: FbnK2GDEOG64yZwe4j2Z-g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F5F6863065;
	Mon, 19 Feb 2024 12:34:38 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.55])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66DBC112131D;
	Mon, 19 Feb 2024 12:34:38 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 697D821E6740; Mon, 19 Feb 2024 13:34:37 +0100 (CET)
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
Subject: Re: [PATCH v4 11/66] i386: Introduce tdx-guest object
In-Reply-To: <20240125032328.2522472-12-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Wed, 24 Jan 2024 22:22:33 -0500")
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
	<20240125032328.2522472-12-xiaoyao.li@intel.com>
Date: Mon, 19 Feb 2024 13:34:37 +0100
Message-ID: <87a5nwfx9e.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Introduce tdx-guest object which implements the interface of
> CONFIDENTIAL_GUEST_SUPPORT, and will be used to create TDX VMs (TDs) by
>
>   qemu -machine ...,confidential-guest-support=tdx0	\
>        -object tdx-guest,id=tdx0
>
> It has only one member 'attributes' with fixed value 0 and not
> configurable so far.

Really?  Can't see it.

Suggest to add something like "Configuration properties will be added
later in this series."

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> Acked-by: Markus Armbruster <armbru@redhat.com>

[...]

> diff --git a/qapi/qom.json b/qapi/qom.json
> index 95516ba325e5..5b3c3146947f 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -895,6 +895,16 @@
>              'reduced-phys-bits': 'uint32',
>              '*kernel-hashes': 'bool' } }
>  
> +##
> +# @TdxGuestProperties:
> +#
> +# Properties for tdx-guest objects.
> +#
> +# Since: 9.0
> +##
> +{ 'struct': 'TdxGuestProperties',
> +  'data': { }}
> +
>  ##
>  # @ThreadContextProperties:
>  #
> @@ -974,6 +984,7 @@
>      'sev-guest',
>      'thread-context',
>      's390-pv-guest',
> +    'tdx-guest',
>      'throttle-group',
>      'tls-creds-anon',
>      'tls-creds-psk',
> @@ -1041,6 +1052,7 @@
>        'secret_keyring':             { 'type': 'SecretKeyringProperties',
>                                        'if': 'CONFIG_SECRET_KEYRING' },
>        'sev-guest':                  'SevGuestProperties',
> +      'tdx-guest':                  'TdxGuestProperties',
>        'thread-context':             'ThreadContextProperties',
>        'throttle-group':             'ThrottleGroupProperties',
>        'tls-creds-anon':             'TlsCredsAnonProperties',

[...]


