Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32CE68BD32
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 13:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjBFMrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 07:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjBFMrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 07:47:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD42811E81
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 04:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675687614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TDRj1e1Of6zXPK6vdEPHmWKOg6uKLmaGGU/8IdkYWus=;
        b=WQxhDeZCsFAsWjLmtlkYd7yGtQ8FCi+ejeRIq7VSHOLHQ5jxsn1xF8wm6Nj7r0r5dme8MR
        hbGBqz80Ru2P4i7N3kWPoLS7+S/fNR6q3n9KkBuNbncJBshxETXY/TH1rEdOGnXJACrzEJ
        6Dq92rYNvRxfl2zqXYQrqZAcvJbnSD4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-22-2QMJoWD-O1C9FeB4HIee7w-1; Mon, 06 Feb 2023 07:46:52 -0500
X-MC-Unique: 2QMJoWD-O1C9FeB4HIee7w-1
Received: by mail-qk1-f197.google.com with SMTP id s7-20020ae9f707000000b007294677a6e8so7759668qkg.17
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 04:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TDRj1e1Of6zXPK6vdEPHmWKOg6uKLmaGGU/8IdkYWus=;
        b=IYaliwdHXLfksKuiAn0hpV8FWJqXCheZp+Oy0MOQHfdFB71dr71yfC4A5m1XVK2NPY
         R9jN6/Yw3Tx8mJBmKOAWYTPcvVv5IzmYIfIxCOB/HQcF1wRatrPe3NNidfa/tc7Jf7T5
         7Y5RbiugLjIrvaauXB1k/Kpb3LvwZotvBoWHs/Jp9WiLNoZaLpcKPvc17e7Ht03jyZDZ
         esJZSs2Ipds6UqW7+tl9pPMKtRGLwaimXlOgNLCp8jV22ni3OFkRLdnH5iABDOCu5MN0
         P+Z1qKDToBjRojG2HkjnX6QQoi0/AhRF+FjExQ+4UAwaeqHsRZYxXD+6xxuGF4VP8ynt
         If0w==
X-Gm-Message-State: AO0yUKVaFsmA8unh1S1KXTraoWllBe/fR/Aoxg94B1VP1NXoSoKtHipW
        4RUtzc6bQu17naK9ASoV5PD2XLg6SC0zAjHHxOknpvwHz5KSTvT/zWCI+STguHgwxZkTWpo1Aoc
        mirMFil5zhbhh
X-Received: by 2002:ac8:5711:0:b0:3b8:6788:bf25 with SMTP id 17-20020ac85711000000b003b86788bf25mr35877080qtw.23.1675687612547;
        Mon, 06 Feb 2023 04:46:52 -0800 (PST)
X-Google-Smtp-Source: AK7set8VN1fCsEVsMrrJk5rcezoBGLzpuilIg4cn536dUV2elOC61RFW7l0os7cDW0myPi1n4kU73Q==
X-Received: by 2002:ac8:5711:0:b0:3b8:6788:bf25 with SMTP id 17-20020ac85711000000b003b86788bf25mr35877052qtw.23.1675687612305;
        Mon, 06 Feb 2023 04:46:52 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s184-20020ae9dec1000000b006fcaa1eab0esm7260423qkf.123.2023.02.06.04.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 04:46:51 -0800 (PST)
Message-ID: <e6732349-efa8-afbf-6c69-498643250bfc@redhat.com>
Date:   Mon, 6 Feb 2023 13:46:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v5 1/3] arm/virt: don't try to spell out the accelerator
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-2-cohuck@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230203134433.31513-2-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Connie,

On 2/3/23 14:44, Cornelia Huck wrote:
> Just use current_accel_name() directly.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  hw/arm/virt.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index ea2413a0bad7..bdc297a4570c 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2123,21 +2123,21 @@ static void machvirt_init(MachineState *machine)
>      if (vms->secure && (kvm_enabled() || hvf_enabled())) {
>          error_report("mach-virt: %s does not support providing "
>                       "Security extensions (TrustZone) to the guest CPU",
> -                     kvm_enabled() ? "KVM" : "HVF");
> +                     current_accel_name());
>          exit(1);
>      }
>  
>      if (vms->virt && (kvm_enabled() || hvf_enabled())) {
>          error_report("mach-virt: %s does not support providing "
>                       "Virtualization extensions to the guest CPU",
> -                     kvm_enabled() ? "KVM" : "HVF");
> +                     current_accel_name());
>          exit(1);
>      }
>  
>      if (vms->mte && (kvm_enabled() || hvf_enabled())) {
>          error_report("mach-virt: %s does not support providing "
>                       "MTE to the guest CPU",
> -                     kvm_enabled() ? "KVM" : "HVF");
> +                     current_accel_name());
>          exit(1);
>      }
>  

