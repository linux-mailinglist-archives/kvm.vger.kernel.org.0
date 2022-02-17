Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138534BA575
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 17:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242934AbiBQQKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 11:10:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242804AbiBQQKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 11:10:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E722429C12D
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645114228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KCilBuq9NLr3A/KqmUevjyQMMZifNiNCO4lvtgHn2dk=;
        b=UrJYVIbZdWTdIiDxbaHYzpAO27xvtIXnJz6BlXMjRN9w/COoKxUY0b2RKbLsOTz/GeCgJv
        PakEaHTM6BucKByxMHiU4In6FobTRf9z0POWTC1D5WCWV8XeXk/Lxa7at5YdU0DO+aGcAc
        a7Z2EdjDoZ2TB8n56XKp8xSMQxVyK2U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-ki07fGfUOnaf1xJDxzQl1g-1; Thu, 17 Feb 2022 11:10:26 -0500
X-MC-Unique: ki07fGfUOnaf1xJDxzQl1g-1
Received: by mail-wm1-f72.google.com with SMTP id c7-20020a1c3507000000b0034a0dfc86aaso4450882wma.6
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:10:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KCilBuq9NLr3A/KqmUevjyQMMZifNiNCO4lvtgHn2dk=;
        b=G/CHbtrDjj9zg1DYWIzPVyFYj1B3bB3MpgU3MPKrCg7gAXH7JEO59Dtq3dY9Whs8vD
         xOidykvRlfL7iuLVU4ZeBgHhyT0vys64IzJljFcUnINdGOeMlJiveRI3ChqrYRkFnX/7
         CoEXUxMqwMcohPxlLvrRtogPYmvhXMfiBzf3ipaUMyUJWk1zO3URJVpeozThRcSSjrSi
         5nzbW1AJkx2yZoL19uRRCBpVUISC9syvinF2SEmYwDYylfciwXoBSBgtJJChqNvL3ytT
         UzNDqBu7fX7ZZYtU5vsGNs0dKT9/qsil4mFPjoRpbNVc3yXyVkejZmAlIbIfJPM+Mjpl
         qfOw==
X-Gm-Message-State: AOAM531eAV4VqBLIAWSHWJDKj8CmJOs7gcJq180JMdyumvRSfrKqB8M7
        N03XLCtPt/CqQzQA4xNqRF+6uU9V9O8mkga7b6ND4Vl61PeTg2MiA7czV0fGHzbghlzOG8Qf2EB
        T2oDqg+2sYska
X-Received: by 2002:adf:912e:0:b0:1e3:d88:bb46 with SMTP id j43-20020adf912e000000b001e30d88bb46mr2830359wrj.27.1645114225674;
        Thu, 17 Feb 2022 08:10:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbQN5AdES0GxnQJugmFvBObJzZ+H0Qui96yhuMVknj224TdFRUkCkuk52o2dsoZehckyo38g==
X-Received: by 2002:adf:912e:0:b0:1e3:d88:bb46 with SMTP id j43-20020adf912e000000b001e30d88bb46mr2830344wrj.27.1645114225478;
        Thu, 17 Feb 2022 08:10:25 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id l11sm29837357wry.77.2022.02.17.08.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 08:10:24 -0800 (PST)
Date:   Thu, 17 Feb 2022 17:10:22 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, thuth@redhat.com, jade.alglave@arm.com
Subject: Re: [kvm-unit-tests PATCH] configure: arm: Fixes to build and run
 tests on Apple Silicon
Message-ID: <20220217161022.krzj2g37natxrj6x@gator>
References: <20220217102806.28749-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217102806.28749-1-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022 at 10:28:06AM +0000, Nikos Nikoleris wrote:
> On MacOS:
> 
> $> uname -m
> 
> returns:
> 
> arm64
> 
> To unify how we handle the achitecture detection across different
> systems, sed it to aarch64 which is what's typically reported on

Was "sed" a typo or a new verb for "sedding" stuff :-)

> Linux.
> 
> In addition, when HVF is the acceleration method on aarch64, make sure
> we select the right processor when invoking qemu.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  arm/run   | 3 +++
>  configure | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/run b/arm/run
> index 2153bd3..0629b69 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -27,6 +27,9 @@ if [ "$ACCEL" = "kvm" ]; then
>  	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
>  		M+=',gic-version=host'
>  	fi
> +fi
> +
> +if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
>  	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
>  		processor="host"
>  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> diff --git a/configure b/configure
> index 2d9c3e0..ff840c1 100755
> --- a/configure
> +++ b/configure
> @@ -14,7 +14,7 @@ objcopy=objcopy
>  objdump=objdump
>  ar=ar
>  addr2line=addr2line
> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> +arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>  host=$arch
>  cross_prefix=
>  endian=""
> -- 
> 2.32.0 (Apple Git-132)
>

So, with this, we've got kvm-unit-tests running on HVF now?

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew

