Return-Path: <kvm+bounces-9082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8534785A3DA
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:53:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5F701C2164F
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74DD02E859;
	Mon, 19 Feb 2024 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xt++iLrp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2869D2C195
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 12:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347209; cv=none; b=JjL+yvkAxL5fmhHRqRodxgMCMa7WDXEefmhFhpugRKLgYynn9XOKNsmuV3IEYdoJBQQhA3rAZqhp4hvM+cJrNxTCjzpNcTS718rytx+7g6r2Oe30m8DHH1ZlTjaixKtbNwug7Gts9Ol7AAntX3dSBDlYs6PQ6P+0QLpbd9VU498=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347209; c=relaxed/simple;
	bh=e1Ss7KelZrBhNhdZt0YfilZlN5LjTFNdC9lOzV2jVMY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aWK+G920WOC+ddPvbA2xHZket9peGorjIf62xDGMrNGhjWqVqfIwxajcAxRF2S79qA5kTVLIxh0ZFM1Wsp3X/lPMSasN2SDIS+B4w7E3c33sccsgIStHkd6CewrT8aTx+Fkvtp5+z5k7wcq+SNmEzaVZlO+bS5NhwwzSJWNi83I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xt++iLrp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708347207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rwp3K/tyco+S6GkYgXqIwUdNod+B1L1KCDzaUWv/qBs=;
	b=Xt++iLrpNWYxZj+/VQZs4/4/BP0cgkN6kXh0trAMk0WTG8jTezBRYh+Pe2dv/brL5uLpC6
	h7lxxgfHpzmBBJT/yRrkr2J02rev1/8gzMl6syozCIb5wJBHqv0YZdINZ51k3QdLbtgZms
	RttgUmfvtHSM/X2tcfs3Mq22HUFMhVM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-qI0YPT1hMNmUgpg2-n1b2w-1; Mon, 19 Feb 2024 07:53:21 -0500
X-MC-Unique: qI0YPT1hMNmUgpg2-n1b2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B017185A780;
	Mon, 19 Feb 2024 12:53:21 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.55])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6B0B8077;
	Mon, 19 Feb 2024 12:53:20 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id C84F221E66D0; Mon, 19 Feb 2024 13:53:19 +0100 (CET)
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
Subject: Re: [PATCH v4 53/66] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
In-Reply-To: <20240125032328.2522472-54-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Wed, 24 Jan 2024 22:23:15 -0500")
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
	<20240125032328.2522472-54-xiaoyao.li@intel.com>
Date: Mon, 19 Feb 2024 13:53:19 +0100
Message-ID: <87v86kehts.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>
> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v4:
> - refine the documentation; (Markus)
>
> Changes in v3:
> - Add docmentation of new type and struct; (Daniel)
> - refine the error message handling; (Daniel)
> ---
>  qapi/run-state.json   | 28 ++++++++++++++++++++--
>  system/runstate.c     | 54 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.c | 24 ++++++++++++++++++-
>  3 files changed, 103 insertions(+), 3 deletions(-)
>
> diff --git a/qapi/run-state.json b/qapi/run-state.json
> index 08bc99cb8561..5429116679e3 100644
> --- a/qapi/run-state.json
> +++ b/qapi/run-state.json
> @@ -485,10 +485,12 @@
>  #
>  # @s390: s390 guest panic information type (Since: 2.12)
>  #
> +# @tdx: tdx guest panic information type (Since: 8.2)
> +#
>  # Since: 2.9
>  ##
>  { 'enum': 'GuestPanicInformationType',
> -  'data': [ 'hyper-v', 's390' ] }
> +  'data': [ 'hyper-v', 's390', 'tdx' ] }
>  
>  ##
>  # @GuestPanicInformation:
> @@ -503,7 +505,8 @@
>   'base': {'type': 'GuestPanicInformationType'},
>   'discriminator': 'type',
>   'data': {'hyper-v': 'GuestPanicInformationHyperV',
> -          's390': 'GuestPanicInformationS390'}}
> +          's390': 'GuestPanicInformationS390',
> +          'tdx' : 'GuestPanicInformationTdx'}}
>  
>  ##
>  # @GuestPanicInformationHyperV:
> @@ -566,6 +569,27 @@
>            'psw-addr': 'uint64',
>            'reason': 'S390CrashReason'}}
>  
> +##
> +# @GuestPanicInformationTdx:
> +#
> +# TDX Guest panic information specific to TDX GCHI
> +# TDG.VP.VMCALL<ReportFatalError>.
> +#
> +# @error-code: TD-specific error code

Where could a user find information on these error codes?

> +#
> +# @gpa: guest-physical address of a page that contains additional
> +#     error data, in forms of zero-terminated string.

"in the form of a zero-terminated string"

> +#
> +# @message: Human-readable error message provided by the guest. Not
> +#     to be trusted.

How is this message related to the one pointed to by @gpa?

> +#
> +# Since: 9.0
> +##
> +{'struct': 'GuestPanicInformationTdx',
> + 'data': {'error-code': 'uint64',
> +          'gpa': 'uint64',
> +          'message': 'str'}}
> +
>  ##
>  # @MEMORY_FAILURE:
>  #

[...]


