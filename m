Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F9146E59C
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 10:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbhLIJeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 04:34:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhLIJeC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 04:34:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639042228;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ohMMr64pOhCaoPHIEFugXtRc5AxXM4D9pqoha4DgWi4=;
        b=W5JEzBNu/Y3cl6mDqEx0JSb4FokHVO8hjZ2ohRJDFhGpcLNg6+ULW7TjZ8VSzeOu9S0y+9
        Yc4E2AfA1tVuBqadDjlj7reWwhycGHzo1woT6PCNxVXLSQKedzjZigZt4OeN4eJm9nbzKO
        GZSi5VaEstgIvp0hB2OvBhV/DjZKSV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-419-zkiA09HyM5qWQomZM5pTQA-1; Thu, 09 Dec 2021 04:30:27 -0500
X-MC-Unique: zkiA09HyM5qWQomZM5pTQA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6434910168C3;
        Thu,  9 Dec 2021 09:30:26 +0000 (UTC)
Received: from redhat.com (unknown [10.39.194.55])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDCBA1001F4D;
        Thu,  9 Dec 2021 09:30:06 +0000 (UTC)
Date:   Thu, 9 Dec 2021 09:30:03 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Tyler Fanelli <tfanelli@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        armbru@redhat.com, pbonzini@redhat.com, eblake@redhat.com
Subject: Re: [PATCH] sev: check which processor the ASK/ARK chain should match
Message-ID: <YbHMm9DHCoygmDma@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20211116213858.363583-1-tfanelli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211116213858.363583-1-tfanelli@redhat.com>
User-Agent: Mutt/2.1.3 (2021-09-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 04:38:59PM -0500, Tyler Fanelli wrote:
> The AMD ASK/ARK certificate chain differs between AMD SEV
> processor generations. SEV capabilities should provide
> which ASK/ARK certificate should be used based on the host
> processor.
> 
> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> ---
>  qapi/misc-target.json | 28 ++++++++++++++++++++++++++--
>  target/i386/sev.c     | 17 ++++++++++++++---
>  2 files changed, 40 insertions(+), 5 deletions(-)

> 
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index 5aa2b95b7d..c64aa3ff57 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -166,6 +166,24 @@
>  { 'command': 'query-sev-launch-measure', 'returns': 'SevLaunchMeasureInfo',
>    'if': 'TARGET_I386' }
>  
> +##
> +# @SevAskArkCertName:
> +#
> +# This enum describes which ASK/ARK certificate should be
> +# used based on the generation of an AMD Secure Encrypted
> +# Virtualization processor.
> +#
> +# @naples: AMD Naples processor (SEV 1st generation)
> +#
> +# @rome: AMD Rome processor (SEV 2nd generation)
> +#
> +# @milan: AMD Milan processor (SEV 3rd generation)
> +#
> +# Since: 7.0

I've found that many (all?)   Naples machines expose 'sev_es' in
their CPU flags, which is contrary to my understanding that SEV-ES
was only introduced in Zen2 / Rome. IOW, CPU flags don't seem to
provide a viable alternative to identify the generations, so this
info reported here is useful.


> @@ -534,9 +535,19 @@ static SevCapability *sev_get_capabilities(Error **errp)
>      cap->pdh = g_base64_encode(pdh_data, pdh_len);
>      cap->cert_chain = g_base64_encode(cert_chain_data, cert_chain_len);
>  
> -    host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
> +    host_cpuid(0x8000001F, 0, &eax, &ebx, NULL, NULL);
>      cap->cbitpos = ebx & 0x3f;
>  
> +    es = eax & 0x8;
> +    snp = eax & 0x10;
> +    if (!es && !snp) {
> +	cap->ask_ark_cert_name = SEV_ASK_ARK_CERT_NAME_NAPLES;
> +    } else if (es && !snp) {
> +	cap->ask_ark_cert_name = SEV_ASK_ARK_CERT_NAME_ROME;
> +    } else {
> +	cap->ask_ark_cert_name = SEV_ASK_ARK_CERT_NAME_MILAN;
> +    }

Ident appears off here - seems to have accidentally used tabs instead
of spaces. Since that's a trivial fix, feel free to add

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>

when reposting.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

