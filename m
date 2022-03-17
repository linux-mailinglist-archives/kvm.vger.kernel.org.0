Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12524DCCB3
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 18:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbiCQRqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 13:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiCQRq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 13:46:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F31C0BD7E4
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 10:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647539112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2jSZntopo5lj3lX97AHm+Bt3POGDsH+Rw9wQ2NJBUtQ=;
        b=aR+dRsi2GVNS+dVSdjY/fFYG0R7ey+2VMGIclYSkVUSWPEoLPu9wTTzPVAbhaLo5mSijKJ
        4mVavy8lTJI3lbGIbpgR5wy79/p3QCuJw8+jld4OnpDcj/opWhx1cukwwmfJTOZlDcCftC
        BwCn9+eky40unW3QeK5e2odDYe/OR8g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-QmBcoxd8M5CO-TVQeH7Qcw-1; Thu, 17 Mar 2022 13:45:10 -0400
X-MC-Unique: QmBcoxd8M5CO-TVQeH7Qcw-1
Received: by mail-ed1-f70.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so3546302edb.2
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 10:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2jSZntopo5lj3lX97AHm+Bt3POGDsH+Rw9wQ2NJBUtQ=;
        b=TB8/2rwvA9EsQriMb9Ba260eU8O2gGEwuy3/n3Wf/UkZXS3bXGrxM0EbWFSPq8o+Wq
         uy77ilcC9DSQucJuFhtGvFG8OiaAL3BttAaqj/MbjCrqFZHluIadaXPxyAfDu54hw/7c
         xdjb0mVG8dqAgC1sZHL46Za2feKERvSbUbHGoRB8yKNu0YXjZFfTmU6p1PRhlfJN5WbB
         U1uDfpNK53Fr8bjirtp4nsShPhUg2khVOG0lNvQlXSLflVJQiARBMkmHlGGFBwH4H+p7
         GeTl+McZcoQ4P7rY6+ltOoGdBfopZ7C6ZTP6Oz7dyLAJh77dOq/KkJGghPfhLbFH9skd
         VddA==
X-Gm-Message-State: AOAM532L2TsYocTiGq9OAt3fqn3gLpDwgQLsvAmZYS6sgN4p2V7Oze42
        UY/N1rLilXx3A+eYB6IT1jVfyjXRg3etImbg4ZQgSQwXozo/iB99thZjCkamFcWBsfMrTNGRpJA
        cZAtaWhnkGT6T
X-Received: by 2002:a17:907:3f86:b0:6db:b745:f761 with SMTP id hr6-20020a1709073f8600b006dbb745f761mr5351773ejc.610.1647539109574;
        Thu, 17 Mar 2022 10:45:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw07m+uKi8TwSUle9H2N2prBjnYvm79oDP4Lqt9N6Gdp5ucxXVDZSzZrzPZTYFL8YPxAdRODw==
X-Received: by 2002:a17:907:3f86:b0:6db:b745:f761 with SMTP id hr6-20020a1709073f8600b006dbb745f761mr5351757ejc.610.1647539109354;
        Thu, 17 Mar 2022 10:45:09 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id w14-20020a170906d20e00b006cee22553f7sm2715187ejz.213.2022.03.17.10.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 10:45:09 -0700 (PDT)
Date:   Thu, 17 Mar 2022 18:45:07 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] arm/run: Use TCG with qemu-system-arm on
 arm64 systems
Message-ID: <20220317174507.jt2rattmtetddvsq@gator>
References: <20220317165601.356466-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317165601.356466-1-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 04:56:01PM +0000, Alexandru Elisei wrote:
> From: Andrew Jones <drjones@redhat.com>
> 
> If the user sets QEMU=qemu-system-arm on arm64 systems, the tests can only
> be run by using the TCG accelerator. In this case use TCG instead of KVM.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> [ Alex E: Added commit message ]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/run | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index 28a0b4ad2729..128489125dcb 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -10,16 +10,24 @@ if [ -z "$KUT_STANDALONE" ]; then
>  fi
>  processor="$PROCESSOR"
>  
> -ACCEL=$(get_qemu_accelerator) ||
> +accel=$(get_qemu_accelerator) ||
>  	exit $?
>  
> -if [ "$ACCEL" = "kvm" ]; then
> +if [ "$accel" = "kvm" ]; then
>  	QEMU_ARCH=$HOST
>  fi
>  
>  qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> +if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> +   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> +   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> +	accel=tcg
> +fi
> +
> +ACCEL=$accel
> +
>  if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
>  	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
>  	exit 2
> -- 
> 2.35.1
>

Ha, OK, I guess you posting this is a strong vote in favor of this
behavior. I've queued it

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 

