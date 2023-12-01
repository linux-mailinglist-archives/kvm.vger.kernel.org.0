Return-Path: <kvm+bounces-3103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 529FB800940
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 12:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 839A41C20ED3
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523DD20DF3;
	Fri,  1 Dec 2023 11:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3L0lueU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F66193
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 03:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701428539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hFdOs1CKBCcZmt4jrpvGA5vZPLyGHB7koIvV+uXcRd0=;
	b=B3L0lueUC0QfJUykX8S0YUInCgr4LZogWCtmfoZAgMjPufZIMYWwGicEbQS9epDtVvHhjB
	LvmfqbG/ZfP6GcnTmhgyEordIAiUIJrvaatiAAFodIvzDAi4641Wa6mmpmZBWG1ppGzT65
	uuEafmoY6drU6H0ynlCfKdcrj9FWZyw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-597-148F8G_nNdK9zbjoFmhQbw-1; Fri,
 01 Dec 2023 06:02:12 -0500
X-MC-Unique: 148F8G_nNdK9zbjoFmhQbw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D235629ABA28;
	Fri,  1 Dec 2023 11:02:11 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE7661C060AE;
	Fri,  1 Dec 2023 11:02:11 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 84B7E21E6A1F; Fri,  1 Dec 2023 12:02:10 +0100 (CET)
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
Subject: Re: [PATCH v3 52/70] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
	<20231115071519.2864957-53-xiaoyao.li@intel.com>
Date: Fri, 01 Dec 2023 12:02:10 +0100
In-Reply-To: <20231115071519.2864957-53-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Wed, 15 Nov 2023 02:15:01 -0500")
Message-ID: <87jzpyw5hp.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> For GetQuote, delegate a request to Quote Generation Service.
> Add property "quote-generation-socket" to tdx-guest, whihc is a property
> of type SocketAddress to specify Quote Generation Service(QGS).
>
> On request, connect to the QGS, read request buffer from shared guest
> memory, send the request buffer to the server and store the response
> into shared guest memory and notify TD guest by interrupt.
>
> command line example:
>   qemu-system-x86_64 \
>     -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \
>     -machine confidential-guest-support=tdx0
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v3:
> - rename property "quote-generation-service" to "quote-generation-socket";
> - change the type of "quote-generation-socket" from str to
>   SocketAddress;
> - squash next patch into this one;
> ---
>  qapi/qom.json         |   5 +-
>  target/i386/kvm/tdx.c | 430 ++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h |   6 +
>  3 files changed, 440 insertions(+), 1 deletion(-)
>
> diff --git a/qapi/qom.json b/qapi/qom.json
> index fd99aa1ff8cc..cf36a1832ddd 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -894,13 +894,16 @@
>  #
>  # @mrownerconfig: base64 MROWNERCONFIG SHA384 digest
>  #
> +# @quote-generation-socket: socket address for Quote Generation Service(QGS)
> +#

Long line.  Better:

   # @quote-generation-socket: socket address for Quote Generation
   #     Service(QGS)

>  # Since: 8.2
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


