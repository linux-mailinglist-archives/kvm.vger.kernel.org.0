Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEE66E7B4C
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbjDSNxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjDSNxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:53:14 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EDF11A
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:53:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-2f4214b430aso2093303f8f.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681912392; x=1684504392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OwwLbQrAiSW9O6Kc/2CnyJKU5x+0wsnqhaveMLPMDMU=;
        b=BxxkBG4Y5UaLjrkBQbKhK3M/I6YdTUZRRyZlxnKmTDOt/SeHDMzQsLoWgDHGTIBjt0
         0jihgveTHXYw4aZFi85i7nnKkLXhZSOLJ8KSqcdJQoOxbk576+JREZhL/ARycZoX66cv
         Ht68d6i+r8HpV3uChRtDBYeVz1O9LN1givQNHZWz744sObfX8CppJ+uYul9SALVg2/o0
         03GDJsDgzhZrmfd8ESfdERJX/jZdxe7mgbrZb56yq45jLffM2P8TN4E9vm1XznjRrhzQ
         qgzX+DP7hMqq2xLH725IqBod44e6xGdRLvQfOBY43ubDEAEiHQXltLsWqhe7ZQ8joBdg
         T0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681912392; x=1684504392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwwLbQrAiSW9O6Kc/2CnyJKU5x+0wsnqhaveMLPMDMU=;
        b=WevmRQg4dYr07aOopSQpqyObF8mik2LLbitDSJJCFB1XawEd99pTfLo9paiJKubQ8z
         JrDppDWaIhkbMLyjZLjyeZ6r6U+r7hGUOnfCD3zH1faxyFAqhFEmO3qQjfbFY6reJ6Uo
         QTE31HlFzBMQCbcREo1kb2OUbL4BdWprYvn8/O0NOgweNvGm9+9t0CpfdBTbBZW2jnCl
         BBbRfisqd3X7c2c9DVMu7riRpbVZ9Ex2z4x0IlLWNgFJpbs48qtwXSMtqTB2GsYB9WKi
         L3YNz0ydboaINefeCuF107N3a+eiiwk6upPTHGPExg/MujRC476nMalCorrabxuvjhzh
         a3UQ==
X-Gm-Message-State: AAQBX9fAka/JUbaL8IuKacFdlIO+rxfjWO76TIANJJBqTvQnDhHMJhnl
        GZhBpIBYA5PLMhz+YkfyxufxQA==
X-Google-Smtp-Source: AKy350bFZ3fih4x2h5LmA93QJ2UFg+mASXPUCHe9wXFly1peBEeIwq37VTDi5lJDP3dJsyCJvDr1jg==
X-Received: by 2002:a5d:6110:0:b0:2fe:6b1e:3818 with SMTP id v16-20020a5d6110000000b002fe6b1e3818mr3138131wrt.51.1681912391955;
        Wed, 19 Apr 2023 06:53:11 -0700 (PDT)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id k14-20020a5d66ce000000b002f103ca90cdsm15992195wrw.101.2023.04.19.06.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:53:11 -0700 (PDT)
Date:   Wed, 19 Apr 2023 14:53:13 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: Re: [PATCH kvmtool 1/2] virtio/rng: switch to using /dev/urandom
Message-ID: <20230419135313.GA94027@myrica>
References: <20230413165757.1728800-1-andre.przywara@arm.com>
 <20230413165757.1728800-2-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413165757.1728800-2-andre.przywara@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 05:57:56PM +0100, Andre Przywara wrote:
> At the moment we use /dev/random as the backing device to provide random
> numbers to our virtio-rng implementation. The downside of doing so is
> that it may block indefinitely - or return EAGAIN repeatedly in our case.
> On one headless systbem without ample noise sources (no keyboard, mouse,

system

> or network traffic) I measured 30 seconds to gain one byte of randomness.
> At the moment EDK II insists in waiting for all of the requsted random
> bytes (for its EFI_RNG_PROTOCOL runtime service) to arrive, that held up
> a Linux kernel boot for more than 10 minutes(!).
> 
> According to the Internet(TM), on Linux /dev/urandom provides the same
> quality random numbers as /dev/random, it just does not block when the
> entropy estimation algorithm suggests so. For all practical purposes the
> recommendation is to just use /dev/urandom, QEMU did the switch as well
> in 2019 [1].
> 
> Use /dev/urandom instead of /dev/random when opening the file descriptor
> providing the randomness source for the virtio/rng implementation.
> 
> [1] https://gitlab.com/qemu-project/qemu/-/commit/a2230bd778d8
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
>  virtio/rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virtio/rng.c b/virtio/rng.c
> index 8f85d5ec1..eab8f3ac0 100644
> --- a/virtio/rng.c
> +++ b/virtio/rng.c
> @@ -166,7 +166,7 @@ int virtio_rng__init(struct kvm *kvm)
>  	if (rdev == NULL)
>  		return -ENOMEM;
>  
> -	rdev->fd = open("/dev/random", O_RDONLY | O_NONBLOCK);
> +	rdev->fd = open("/dev/urandom", O_RDONLY | O_NONBLOCK);
>  	if (rdev->fd < 0) {
>  		r = rdev->fd;
>  		goto cleanup;
> -- 
> 2.25.1
> 
