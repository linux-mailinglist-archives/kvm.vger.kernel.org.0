Return-Path: <kvm+bounces-3102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B4280093B
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 12:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E30F0B2129C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E9820DF3;
	Fri,  1 Dec 2023 11:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4Jbxebk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862F819F
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 03:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701428452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qRiYz0KsDOvOBLsROaIONZoFzQaJWhfEYMXPjc3M04o=;
	b=Q4Jbxebk+kaOukO261qWR8neet1GfpgZ86Pv2GgkDCn5jBiJjtfm9ybGMZEy0dSg6b2fO+
	TlxGxs9Mo02gKT/V7vV38e2xG+Pi2tW6oNn5FF17skqKic/rILaHa/bQfumRFRqy5ztrDK
	0oUdveLkrI+4KoHjFgi0DIBLHqfnFFY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-krGbPwFzNTehsuSzaVqdmw-1; Fri, 01 Dec 2023 06:00:48 -0500
X-MC-Unique: krGbPwFzNTehsuSzaVqdmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B26385A58C;
	Fri,  1 Dec 2023 11:00:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCC612026D4C;
	Fri,  1 Dec 2023 11:00:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DA28121E6A1F; Fri,  1 Dec 2023 12:00:46 +0100 (CET)
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
Subject: Re: [PATCH v3 31/70] i386/tdx: Allows
 mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
	<20231115071519.2864957-32-xiaoyao.li@intel.com>
Date: Fri, 01 Dec 2023 12:00:46 +0100
In-Reply-To: <20231115071519.2864957-32-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Wed, 15 Nov 2023 02:14:40 -0500")
Message-ID: <87o7faw5k1.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
> can be provided for TDX attestation.
>
> So far they were hard coded as 0. Now allow user to specify those values
> via property mrconfigid, mrowner and mrownerconfig. They are all in
> base64 format.
>
> example
> -object tdx-guest, \
>   mrconfigid=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>   mrowner=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>   mrownerconfig=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v3:
>  - use base64 encoding instread of hex-string;
> ---
>  qapi/qom.json         | 11 +++++-
>  target/i386/kvm/tdx.c | 85 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h |  3 ++
>  3 files changed, 98 insertions(+), 1 deletion(-)
>
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 3a29659e0155..fd99aa1ff8cc 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -888,10 +888,19 @@
>  #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>  #     be set, otherwise they refuse to boot.
>  #
> +# @mrconfigid: base64 encoded MRCONFIGID SHA384 digest
> +#
> +# @mrowner: base64 encoded MROWNER SHA384 digest
> +#
> +# @mrownerconfig: base64 MROWNERCONFIG SHA384 digest

Can we come up with a description that tells the user a bit more clearly
what we're talking about?  Perhaps starting with this question could
lead us there: what's an MRCONFIGID, and why should I care?

> +#
>  # Since: 8.2
>  ##
>  { 'struct': 'TdxGuestProperties',
> -  'data': { '*sept-ve-disable': 'bool' } }
> +  'data': { '*sept-ve-disable': 'bool',
> +            '*mrconfigid': 'str',
> +            '*mrowner': 'str',
> +            '*mrownerconfig': 'str' } }
>  
>  ##
>  # @ThreadContextProperties:

[...]


