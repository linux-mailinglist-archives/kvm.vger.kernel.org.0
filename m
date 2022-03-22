Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3965A4E44ED
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiCVRYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbiCVRYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:24:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CB9175628
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r2t4WcUjTvJPZ4sNYR9JpWBmhFW0NZyq4C3NRSxwXgw=;
        b=fJuu5O+Wv0++C0zRJyXm859RBp07lrG8DINh3X+8odkwnjiM9fT8fOvScg004JajmabY1N
        /hOLre7s6nMJ5VEuB01AzlPdAz7Lc0BcwDqYbZjQQ7Q5z+33/D1+rfwdSdLqwWU82CwH1N
        9U2pfHWOXBck0FtQOuPslPOKlfl6oxA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-Sv7Nofa9O5GeM_qs2NF-sA-1; Tue, 22 Mar 2022 13:22:30 -0400
X-MC-Unique: Sv7Nofa9O5GeM_qs2NF-sA-1
Received: by mail-wr1-f70.google.com with SMTP id a17-20020a5d6cb1000000b00203f85a2ed9so2006823wra.7
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r2t4WcUjTvJPZ4sNYR9JpWBmhFW0NZyq4C3NRSxwXgw=;
        b=s9EYKt/DRnODTxVJd5XQbOjHbJ7Ae059Ua0MdnBQ3WzfsgfNs8TgKIEsV71nsbgRd9
         Cn/7tBX7fesftI3SodMpMFpF+CDsV4o+ILhneD/GBg3uvHfPSxo7XUXkwSe3pBhFoEDM
         YVV7jAO69xiXYnaOvG/GWk1b6dDWIppzLR1kiknr8C4VCA9WLOOPg4dZ+GcnrOM6OySI
         rrhOX6afD4vomzhwu4jSm145GjTBGiLgYfZXBy/wbob8qzMDbNVR9+yvZUZ3x8uLkmzZ
         j5KMMJdsDyAAQErpd5dNMLRzbfE3bOiWbhtkRKSK9+/u1Q7meTIKA0PjtnnyqW96VM10
         SXyA==
X-Gm-Message-State: AOAM533iVWUJjQXX4KPrV4Gj2zptdthxCPN7CfCta36+jp5oAhvLwaVN
        45utaEWqRSKHFAFoyTHnSYX/UpRQq8XjBblf4Wmf8k1AhGl3isY6UoHPsVT7Dpe+wqH/TMURrce
        qwoGD/dXSdwQd
X-Received: by 2002:a05:6000:1d1:b0:203:f283:73a7 with SMTP id t17-20020a05600001d100b00203f28373a7mr19985474wrx.383.1647969748758;
        Tue, 22 Mar 2022 10:22:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykvKE/iPKe/k7sXH4WjY8ppWKBlQgMkFsNFTB6pdLCmBaAHy6C/hR/83fffmd6LXqDQMHoQQ==
X-Received: by 2002:a05:6000:1d1:b0:203:f283:73a7 with SMTP id t17-20020a05600001d100b00203f28373a7mr19985453wrx.383.1647969748453;
        Tue, 22 Mar 2022 10:22:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m185-20020a1ca3c2000000b0038c836a5c13sm2225928wme.20.2022.03.22.10.22.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 10:22:27 -0700 (PDT)
Message-ID: <59cef642-ccd0-ba99-ec88-4a1cee7f53ed@redhat.com>
Date:   Tue, 22 Mar 2022 18:22:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH] Allow to compile without -Werror
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20220322171504.941686-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220322171504.941686-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/22 18:15, Thomas Huth wrote:
> Newer compiler versions sometimes introduce new warnings - and compiling
> with -Werror will fail there, of course. Thus users of the kvm-unit-tests
> like the buildroot project have to disable the "-Werror" in the Makefile
> with an additional patch, which is cumbersome.
> Thus let's add a switch to the configure script that allows to explicitly
> turn the -Werror switch on or off. And enable it only by default for
> developer builds (i.e. in checked-out git repositories) ... and for
> tarball releases, it's nicer if it is disabled by default, so that the
> end users do not have to worry about this.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   See also the patch from the buildroot project:
>   https://git.busybox.net/buildroot/tree/package/kvm-unit-tests/0001-Makefile-remove-Werror-to-avoid-build-failures.patch
> 
>   Makefile  |  2 +-
>   configure | 16 ++++++++++++++++
>   2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 24686dd..6ed5dea 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -62,7 +62,7 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
>   
>   COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
>   COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> -COMMON_CFLAGS += -Wignored-qualifiers -Werror -Wno-missing-braces
> +COMMON_CFLAGS += -Wignored-qualifiers -Wno-missing-braces $(CONFIG_WERROR)
>   
>   frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
>   fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
> diff --git a/configure b/configure
> index c4fb4a2..86c3095 100755
> --- a/configure
> +++ b/configure
> @@ -31,6 +31,13 @@ page_size=
>   earlycon=
>   efi=
>   
> +# Enable -Werror by default for git repositories only (i.e. developer builds)
> +if [ -e "$srcdir"/.git ]; then
> +    werror=-Werror
> +else
> +    werror=
> +fi
> +
>   usage() {
>       cat <<-EOF
>   	Usage: $0 [options]
> @@ -75,6 +82,8 @@ usage() {
>   	                           Specify a PL011 compatible UART at address ADDR. Supported
>   	                           register stride is 32 bit only.
>   	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
> +	    --[enable|disable]-werror
> +	                           Select whether to compile with the -Werror compiler flag
>   EOF
>       exit 1
>   }
> @@ -148,6 +157,12 @@ while [[ "$1" = -* ]]; do
>   	--disable-efi)
>   	    efi=n
>   	    ;;
> +	--enable-werror)
> +	    werror=-Werror
> +	    ;;
> +	--disable-werror)
> +	    werror=
> +	    ;;
>   	--help)
>   	    usage
>   	    ;;
> @@ -371,6 +386,7 @@ WA_DIVIDE=$wa_divide
>   GENPROTIMG=${GENPROTIMG-genprotimg}
>   HOST_KEY_DOCUMENT=$host_key_document
>   CONFIG_EFI=$efi
> +CONFIG_WERROR=$werror
>   GEN_SE_HEADER=$gen_se_header
>   EOF
>   if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo

