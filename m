Return-Path: <kvm+bounces-3100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8F380091E
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2CC8B21354
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C4A20B39;
	Fri,  1 Dec 2023 10:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fi4CaiSP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD5C19B7
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 02:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701428016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oFydMwBlCdGsCyFLsZj+nrybJG0md9CPG5ArQvt7VQw=;
	b=Fi4CaiSP6fN4TypDRQsBEuAg8QXIrEufoZAmYHo9srf8bK8uyMg/7SgJTsCzubauQTK4Zr
	Dhwok8a9YEz4Qe73AEj3mV/IF57qMPqQj9/XnRZuBzXRPvtT3lXnAVcNHz9XCl59lth49p
	RfqLuhdO3pAbiBSEgoDPzfWl8sn00vg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-CBAWIX9BNh6gYIQIQp4DwA-1; Fri, 01 Dec 2023 05:53:34 -0500
X-MC-Unique: CBAWIX9BNh6gYIQIQp4DwA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70559811E86;
	Fri,  1 Dec 2023 10:53:33 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CEED2026D6E;
	Fri,  1 Dec 2023 10:53:33 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 6C77221E6A1F; Fri,  1 Dec 2023 11:53:32 +0100 (CET)
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
Subject: Re: [PATCH v3 27/70] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
	<20231115071519.2864957-28-xiaoyao.li@intel.com>
Date: Fri, 01 Dec 2023 11:53:32 +0100
In-Reply-To: <20231115071519.2864957-28-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Wed, 15 Nov 2023 02:14:36 -0500")
Message-ID: <87sf4mw5w3.fsf@pond.sub.org>
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

> Bit 28 of TD attribute, named SEPT_VE_DISABLE. When set to 1, it disables
> EPT violation conversion to #VE on guest TD access of PENDING pages.
>
> Some guest OS (e.g., Linux TD guest) may require this bit as 1.
> Otherwise refuse to boot.
>
> Add sept-ve-disable property for tdx-guest object, for user to configure
> this bit.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
> Changes in v3:
> - update the comment of property @sept-ve-disable to make it more
>   descriptive and use new format. (Daniel and Markus)
> ---
>  qapi/qom.json         |  7 ++++++-
>  target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 8e08257dac2f..3a29659e0155 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -883,10 +883,15 @@
>  #
>  # Properties for tdx-guest objects.
>  #
> +# @sept-ve-disable: toggle bit 28 of TD attributes to control disabling
> +#     of EPT violation conversion to #VE on guest TD access of PENDING
> +#     pages.  Some guest OS (e.g., Linux TD guest) may require this to
> +#     be set, otherwise they refuse to boot.
> +#
>  # Since: 8.2
>  ##
>  { 'struct': 'TdxGuestProperties',
> -  'data': { }}
> +  'data': { '*sept-ve-disable': 'bool' } }
>  
>  ##
>  # @ThreadContextProperties:

Acked-by: Markus Armbruster <armbru@redhat.com>

[...]


