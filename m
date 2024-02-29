Return-Path: <kvm+bounces-10459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E8C86C3E6
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76F15B233B5
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1FBE50278;
	Thu, 29 Feb 2024 08:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ng0SVDxQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D57E20312
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 08:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709196051; cv=none; b=E0XLcJ8opFQnDhIocPsw21V5zABrDcd666TY7zPBz1mLi8O2Up6vwk1vinRTDttkfkMmMKF5oF5nEUdFKxAfENq/QNNwFSlBoFtbxuQcjeG5l34rl6Vsd4NtvYmILYhEPQzJI0F2oCr9nn6auScwH7ndvivg9c0PcUddk6JcNw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709196051; c=relaxed/simple;
	bh=IroeLsezKkq3rt5Q97PKrFEIaX0FMh5BkYz9MTnDj4o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DTk4PzY3PThH0nrqse+MIjz7wl0UNtk9Zj9ef2vbWojnymAFPd3qudH+fV0nuwRwCf0bSdIhyoJ5seqAcSXQheoOW+0cLlahrxC50sjKYCov7CrFmqxnXlqZ0W8TolUpL8d2jVrFJMiTza6y9yAO4PkoclFX+CFVFU11BIt8IXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ng0SVDxQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709196048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rozUkA7YmjSZBYZPaitBHBpceqBKQJKfQX410G5xPfQ=;
	b=Ng0SVDxQJRnoWEXH3sUyiEcrHJSEPSpe9PkrBsPQuE8QVmfmQYK7OezunwbeaqEMNlfyPC
	PxkOnBLBxnZRqyQXalRHGbsCS1LgbV6jlmaxQLe2WX1oMg0gV7X9S4J1u3PYf/yAeGItDc
	FMU8NMCr3qFkIac0/bZcS1h/RJnptTw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-56JoIbzHMneTVQn2tFAxYQ-1; Thu,
 29 Feb 2024 03:40:45 -0500
X-MC-Unique: 56JoIbzHMneTVQn2tFAxYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CA331C04181;
	Thu, 29 Feb 2024 08:40:44 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 35799C185C0;
	Thu, 29 Feb 2024 08:40:44 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 0073221E6740; Thu, 29 Feb 2024 09:40:42 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S. Tsirkin" <mst@redhat.com>,  Richard
 Henderson <richard.henderson@linaro.org>,  Ani Sinha
 <anisinha@redhat.com>,  Peter Xu <peterx@redhat.com>,  Cornelia Huck
 <cohuck@redhat.com>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric
 Blake <eblake@redhat.com>,  Markus Armbruster <armbru@redhat.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  kvm@vger.kernel.org,
  qemu-devel@nongnu.org,  Michael Roth <michael.roth@amd.com>,  Claudio
 Fontana <cfontana@suse.de>,  Gerd Hoffmann <kraxel@redhat.com>,  Isaku
 Yamahata <isaku.yamahata@gmail.com>,  Chenyi Qiang
 <chenyi.qiang@intel.com>
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
In-Reply-To: <20240229063726.610065-50-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Thu, 29 Feb 2024 01:37:10 -0500")
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
	<20240229063726.610065-50-xiaoyao.li@intel.com>
Date: Thu, 29 Feb 2024 09:40:42 +0100
Message-ID: <87a5nj1x4l.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add property "quote-generation-socket" to tdx-guest, which is a property
> of type SocketAddress to specify Quote Generation Service(QGS).
>
> On request of GetQuote, it connects to the QGS socket, read request
> data from shared guest memory, send the request data to the QGS,
> and store the response into shared guest memory, at last notify
> TD guest by interrupt.
>
> command line example:
>   qemu-system-x86_64 \
>     -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>     -machine confidential-guest-support=tdx0
>
> Note, above example uses vsock type socket because the QGS we used
> implements the vsock socket. It can be other types, like UNIX socket,
> which depends on the implementation of QGS.
>
> To avoid no response from QGS server, setup a timer for the transaction.
> If timeout, make it an error and interrupt guest. Define the threshold of
> time to 30s at present, maybe change to other value if not appropriate.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

[...]

> diff --git a/qapi/qom.json b/qapi/qom.json
> index cac875349a3a..7b26b0a0d3aa 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -917,13 +917,19 @@
>  #     (base64 encoded SHA384 digest). (A default value 0 of SHA384 is
>  #     used when absent).
>  #
> +# @quote-generation-socket: socket address for Quote Generation
> +#     Service (QGS).  QGS is a daemon running on the host.  User in
> +#     TD guest cannot get TD quoting for attestation if QGS is not
> +#     provided.  So admin should always provide it.

This makes me wonder why it's optional.  Can you describe a use case for
*not* specifying @quote-generation-socket?

> +#
>  # Since: 9.0
>  ##
>  { 'struct': 'TdxGuestProperties',
>    'data': { '*sept-ve-disable': 'bool',
>              '*mrconfigid': 'str',
>              '*mrowner': 'str',
> -            '*mrownerconfig': 'str' } }
> +            '*mrownerconfig': 'str',
> +            '*quote-generation-socket': 'SocketAddress' } }
>  
>  ##
>  # @ThreadContextProperties:

[...]


