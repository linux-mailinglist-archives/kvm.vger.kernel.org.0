Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E2B557E26
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 16:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiFWOtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 10:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiFWOtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 10:49:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A8F445044
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655995758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SI8xutk3gmYbsLJ8Tc+MzdPXoHGzso0b1vVVkRwkUCc=;
        b=JtOft56H30DonPit/jkRtLEbFd+kwh8GZrHOFnp8kDC4ojR0256eJ83+mOm3+2nxzg3a5X
        BaR6Qo5T5B1c6KNZXWAIiZBV5INLTIupC6ok89BzKX1DwPj+i2+QPiC7hSUVb+yPJQwV+9
        gNhH0YJlOVFMyh0+XFxsRII0yr9ccJc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-BiuPjFu5Na6iRnGhdFY-qQ-1; Thu, 23 Jun 2022 10:49:17 -0400
X-MC-Unique: BiuPjFu5Na6iRnGhdFY-qQ-1
Received: by mail-wm1-f70.google.com with SMTP id r11-20020a1c440b000000b003a02a3f0beeso1532404wma.3
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SI8xutk3gmYbsLJ8Tc+MzdPXoHGzso0b1vVVkRwkUCc=;
        b=pS/DOEncGTFfet7gdOkJusrGatyIhN31aacYG+Bf9oUOm/ubtqJVJOi3Ppp0rm0gmg
         7BhCdJB8shCPLGIP9PTBc1n3xbUmvNyrqCtmbFInXzScvTMVtlBRVLFQhxMCg+sVaugP
         AYE6T59Sond3REq0JGusIohBuVbr1FUNRKM/9ricGYlKZLKYUNPRXC7qb0GOjVSwK5U6
         bfmOxU7H3XkT92VMrkTfe2C9C4JysZ9uV26vzyql/ki1u8tHVgdDH58yxkfw4YrgCNW0
         dRKtB08zHI8aZj27qGCmh79o44odvXD19r4IYC8jQOjivRsevz8UQLipCb+P31ZYONku
         N/cg==
X-Gm-Message-State: AJIora8tC7mWoH7i5oGctCOZmtrmVIBnkJaMTN/haawX4aN7/nNI3Npl
        +3ZuB0Q2d9fUTU+CB4wJ0BuYZ2V0tWfLzShHxzB6bIpd8z/74DHwdJlnv5jct8aem91K+0Cqt4c
        DUtn0PnXLw9tD
X-Received: by 2002:a05:600c:4ca7:b0:3a0:3905:d441 with SMTP id g39-20020a05600c4ca700b003a03905d441mr686402wmp.159.1655995756146;
        Thu, 23 Jun 2022 07:49:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v5x2JBwpH2zWRtWlZ5BKlih8mFWla4BTPBzgW9aHA88MSCt6TQqeHfutSJYLBstiVinYS4UA==
X-Received: by 2002:a05:600c:4ca7:b0:3a0:3905:d441 with SMTP id g39-20020a05600c4ca700b003a03905d441mr686374wmp.159.1655995755954;
        Thu, 23 Jun 2022 07:49:15 -0700 (PDT)
Received: from [192.168.8.104] (tmo-098-39.customers.d1-online.com. [80.187.98.39])
        by smtp.gmail.com with ESMTPSA id c2-20020a1c3502000000b0039c5328ad92sm3499945wma.41.2022.06.23.07.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 07:49:15 -0700 (PDT)
Message-ID: <95b9536a-12f4-2dee-918f-c673b3d296aa@redhat.com>
Date:   Thu, 23 Jun 2022 16:49:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: Change drew's email address
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org,
        andre.przywara@arm.com, nikos.nikoleris@arm.com,
        ricarkol@google.com, seanjc@google.com, maz@kernel.org,
        peter.maydell@linaro.org
References: <20220623131017.670589-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220623131017.670589-1-drjones@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/2022 15.10, Andrew Jones wrote:
> As a side effect of leaving Red Hat I won't be able to use my Red Hat
> email address anymore. I'm also changing the name of my gitlab group.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   MAINTAINERS | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bab08e740332..5e4c7bd70786 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -55,7 +55,7 @@ Maintainers
>   -----------
>   M: Paolo Bonzini <pbonzini@redhat.com>
>   M: Thomas Huth <thuth@redhat.com>
> -M: Andrew Jones <drjones@redhat.com>
> +M: Andrew Jones <andrew.jones@linux.dev>
>   S: Supported
>   L: kvm@vger.kernel.org
>   T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
> @@ -64,14 +64,14 @@ Architecture Specific Code:
>   ---------------------------
>   
>   ARM
> -M: Andrew Jones <drjones@redhat.com>
> +M: Andrew Jones <andrew.jones@linux.dev>
>   S: Supported
>   L: kvm@vger.kernel.org
>   L: kvmarm@lists.cs.columbia.edu
>   F: arm/
>   F: lib/arm/
>   F: lib/arm64/
> -T: https://gitlab.com/rhdrjones/kvm-unit-tests.git
> +T: https://gitlab.com/drew-jones/kvm-unit-tests.git
>   
>   POWERPC
>   M: Laurent Vivier <lvivier@redhat.com>

Acked-by: Thomas Huth <thuth@redhat.com>

