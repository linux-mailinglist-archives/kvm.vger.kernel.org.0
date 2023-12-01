Return-Path: <kvm+bounces-3104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B602800972
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 12:11:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE6091F20FA5
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD4A02110E;
	Fri,  1 Dec 2023 11:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LOF1GmZB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95AD193
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 03:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701429099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPv3Jx+QIt2r8IEaZwqfgtMIwpLQ7YWrhHGx4ms5qps=;
	b=LOF1GmZBDMKdqBmFTzMxbSfVDcycVcH0ao0XFciTdZvIfAGs5uXJ3+rK9hH7QjIK+fX3jp
	YDZ5ch2ymjcJQh7nDouhTaVKS7Yxk+6wUJhi3PUrXXWc+KwOvM7gg469ShRpmBF8n7x1Gz
	+OvIMrklVI8rXhvOM9E1OJ9BrpfnhkM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-wTVtNH08PxqpX9QG0oDRxg-1; Fri,
 01 Dec 2023 06:11:37 -0500
X-MC-Unique: wTVtNH08PxqpX9QG0oDRxg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C6B03C10142;
	Fri,  1 Dec 2023 11:11:37 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14532492BFC;
	Fri,  1 Dec 2023 11:11:37 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 22E9921E6A1F; Fri,  1 Dec 2023 12:11:36 +0100 (CET)
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
Subject: Re: [PATCH v3 57/70] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
	<20231115071519.2864957-58-xiaoyao.li@intel.com>
Date: Fri, 01 Dec 2023 12:11:36 +0100
In-Reply-To: <20231115071519.2864957-58-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Wed, 15 Nov 2023 02:15:06 -0500")
Message-ID: <87bkbaw51z.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>
> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes from v2:
> - Add docmentation of new type and struct (Daniel)
> - refine the error message handling (Daniel)
> ---
>  qapi/run-state.json   | 27 ++++++++++++++++++++--
>  system/runstate.c     | 54 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.c | 24 +++++++++++++++++--
>  3 files changed, 101 insertions(+), 4 deletions(-)
>
> diff --git a/qapi/run-state.json b/qapi/run-state.json
> index f216ba54ec4c..e18f62eaef77 100644
> --- a/qapi/run-state.json
> +++ b/qapi/run-state.json
> @@ -496,10 +496,12 @@
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
> @@ -514,7 +516,8 @@
>   'base': {'type': 'GuestPanicInformationType'},
>   'discriminator': 'type',
>   'data': {'hyper-v': 'GuestPanicInformationHyperV',
> -          's390': 'GuestPanicInformationS390'}}
> +          's390': 'GuestPanicInformationS390',
> +          'tdx' : 'GuestPanicInformationTdx'}}
>  
>  ##
>  # @GuestPanicInformationHyperV:
> @@ -577,6 +580,26 @@
>            'psw-addr': 'uint64',
>            'reason': 'S390CrashReason'}}
>  
> +##
> +# @GuestPanicInformationTdx:
> +#
> +# TDX GHCI TDG.VP.VMCALL<ReportFatalError> specific guest panic information

Long line.  Suggest

   # Guest panic information specific to TDX GHCI
   # TDG.VP.VMCALL<ReportFatalError>.

> +#
> +# @error-code: TD-specific error code
> +#
> +# @gpa: 4KB-aligned guest physical address of the page that containing
> +#     additional error data

"address of a page" implies the address is page-aligned.  4KB-aligned
feels redundant.  What about

   # @qpa: guest-physical address of a page that contains additional
   #     error data.

But in what format is the "additional error data"?

> +#
> +# @message: TD guest provided message string.  (It's not so trustable
> +#     and cannot be assumed to be well formed because it comes from guest)

guest-provided

For "well-formed" to make sense, we'd need an idea of the form / syntax.

If it's a human-readable error message, we could go with

   # @message: Human-readable error message provided by the guest.  Not
   #     to be trusted.

> +#
> +# Since: 8.2
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


