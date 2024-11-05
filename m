Return-Path: <kvm+bounces-30722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7792E9BCB0D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E355DB22B00
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716211D2F61;
	Tue,  5 Nov 2024 10:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S67Jsyqh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDE71D27A9
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 10:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730804039; cv=none; b=CdL5eManIy7a711NRdQTv4R3pHjKGmdXvMxBF+vcbtjL1c4OO+60XYolIbiPDDXH1Adt22shsQO0k2atP9t68veG0Talo5hDEMc2m58RHZ7HlIaQtTla4HFKQqmdjsZLV7whnEPO9ivCWPaPmmM9zuk18VsxefIvd58/nzCFWHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730804039; c=relaxed/simple;
	bh=Ilo6w77boviCVdIK1Fxe4JPU6wVDvUDJQDHmSP/8m+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XH8qWO6RxjAODYNSMO1RdbuWfdXtmAEzvDxF+CIhVgVmSAra0GaVb/MdJp89h15fh3KJm0kpK9KpbhOpTGjMyDVQMb7MLVwZx6Ptfju5ZBg+FzOJXpA0Puqm/Sv3Rtq4+dh8hyYHJzZ0kterPRDBbBtlIU0PUXmsnwLp0+5zHQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S67Jsyqh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730804036;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=DIJJbGCFmGjzScRcqhQhqxPwcgLRUbIGY02auMsPAsU=;
	b=S67JsyqhW72AP6Yk5JM4tICdynVrzpvHswVNFsE2NnTq3poUTbryO3qeKw13Z9VVVPybKw
	ihPttiPM0pNNrx4buSFw8R7s5/uaxJcO3ABo79AcGjl7uDeuc9PnxEBJt4SGLgrBHSRl60
	ZMHI40CqlalOiJKOeomSz0qRv9n8Zws=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-327-Iw1GF3hNP-2tKEyKBw7L2Q-1; Tue,
 05 Nov 2024 05:53:53 -0500
X-MC-Unique: Iw1GF3hNP-2tKEyKBw7L2Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC3F01956096;
	Tue,  5 Nov 2024 10:53:51 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 432F519560A2;
	Tue,  5 Nov 2024 10:53:44 +0000 (UTC)
Date: Tue, 5 Nov 2024 10:53:41 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 30/60] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
Message-ID: <Zyn5Nbz9XaBhtPoX@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-31-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-31-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Nov 05, 2024 at 01:23:38AM -0500, Xiaoyao Li wrote:
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
>  qapi/run-state.json   | 31 +++++++++++++++++++++--
>  system/runstate.c     | 58 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.c | 24 +++++++++++++++++-
>  3 files changed, 110 insertions(+), 3 deletions(-)
> 
> diff --git a/qapi/run-state.json b/qapi/run-state.json
> index ce95cfa46b73..c5b0b747b30d 100644
> --- a/qapi/run-state.json
> +++ b/qapi/run-state.json
> @@ -501,10 +501,12 @@
>  #
>  # @s390: s390 guest panic information type (Since: 2.12)
>  #
> +# @tdx: tdx guest panic information type (Since: 9.0)
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
> +# Since: 9.0

This is very outdated. Change to 10.0 as the next possible release
it could land it.

> +##
> +{'struct': 'GuestPanicInformationTdx',
> + 'data': {'error-code': 'uint32',
> +          'message': 'str',
> +          '*gpa': 'uint64'}}
> +
>  ##
>  # @MEMORY_FAILURE:
>  #
> diff --git a/system/runstate.c b/system/runstate.c
> index c2c9afa905a6..9bb8162eb28f 100644
> --- a/system/runstate.c
> +++ b/system/runstate.c
> @@ -565,6 +565,52 @@ static void qemu_system_wakeup(void)
>      }
>  }
>  
> +static char *tdx_parse_panic_message(char *message)
> +{
> +    bool printable = false;
> +    char *buf = NULL;
> +    int len = 0, i;
> +
> +    /*
> +     * Although message is defined as a json string, we shouldn't
> +     * unconditionally treat it as is because the guest generated it and
> +     * it's not necessarily trustable.
> +     */
> +    if (message) {
> +        /* The caller guarantees the NUL-terminated string. */
> +        len = strlen(message);
> +
> +        printable = len > 0;
> +        for (i = 0; i < len; i++) {
> +            if (!(0x20 <= message[i] && message[i] <= 0x7e)) {
> +                printable = false;
> +                break;
> +            }
> +        }
> +    }
> +
> +    if (!printable && len) {
> +        /* 3 = length of "%02x " */
> +        buf = g_malloc(len * 3);

....allocating memory

> +        for (i = 0; i < len; i++) {
> +            if (message[i] == '\0') {
> +                break;
> +            } else {
> +                sprintf(buf + 3 * i, "%02x ", message[i]);
> +            }
> +        }
> +        if (i > 0)
> +            /* replace the last ' '(space) to NUL */
> +            buf[i * 3 - 1] = '\0';
> +        else
> +            buf[0] = '\0';
> +
> +        return buf;

....returning alllocated memory

> +    }
> +
> +    return message;

....returning a pointer that came from a struct field

> +}

This is a bad design - we should require the caller to always
free memory, or never free memory - not a mix.

> +
>  void qemu_system_guest_panicked(GuestPanicInformation *info)
>  {
>      qemu_log_mask(LOG_GUEST_ERROR, "Guest crashed");
> @@ -606,7 +652,19 @@ void qemu_system_guest_panicked(GuestPanicInformation *info)
>                            S390CrashReason_str(info->u.s390.reason),
>                            info->u.s390.psw_mask,
>                            info->u.s390.psw_addr);
> +        } else if (info->type == GUEST_PANIC_INFORMATION_TYPE_TDX) {
> +            qemu_log_mask(LOG_GUEST_ERROR,
> +                          "\nTDX guest reports fatal error:"
> +                          " error code: 0x%" PRIx32 " error message:\"%s\"\n",
> +                          info->u.tdx.error_code,
> +                          tdx_parse_panic_message(info->u.tdx.message));

This is a leak in the case where tdx_parse_panic_message() returned
allocated memory.

> +            if (info->u.tdx.gpa != -1ull) {
> +                qemu_log_mask(LOG_GUEST_ERROR, "Additional error information "
> +                              "can be found at gpa page: 0x%" PRIx64 "\n",
> +                              info->u.tdx.gpa);
> +            }
>          }
> +
>          qapi_free_GuestPanicInformation(info);
>      }
>  }

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


