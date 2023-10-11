Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873617C45CF
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 02:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344228AbjJKAD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 20:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjJKAD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 20:03:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A128F
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 17:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696982559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wbEkRtqvEkJnBkKWslIkyHNkNJTQaP9y02JA7x1NPWU=;
        b=D6tYo0q6YGcCvuCGZpa8iaXpUjdD8VvrPU4tZjgt2uxBzvXO2DJWDOFQbLkx8m1pEe44sv
        C4BVeBf7UEOVenXfQrzUF1Vx6djnjVzgNUSUfMTRrw1yWZKVH28VjjVpvQ+NeUjJV28IF+
        4id2dnH5AjxBNvIvYtH1V1j7yKP5ICM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-73Qfw45DOd2Aqbk54NWDog-1; Tue, 10 Oct 2023 20:02:22 -0400
X-MC-Unique: 73Qfw45DOd2Aqbk54NWDog-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-690bcc80694so5297382b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 17:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696982542; x=1697587342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wbEkRtqvEkJnBkKWslIkyHNkNJTQaP9y02JA7x1NPWU=;
        b=gGoCsqW50OJnfNgHenTS78/4dSqwyTHzp7bIq4UWxVDgPxv4eJhjWiyGWsqmdLslnp
         x6Vu5bcBbUX4b1N2yzRF0E4CflB/56FLhXzdgqy51oUiVbaY0jJrUO7pnX9E5cuhlMBr
         Ek8iyMwaOBWoWKUqbAdRfWZnp10yQ3eUVaSgYMxkRI6eZ0AenAZMsYYZ4EVWF4AcR9Tw
         vgvCHEYTGaPC8Ha7W7QxXEjMvnb9Mf+VL0zJuAVOy7fpuKmUBmhwW+wfuoDGW0HnK40r
         ZQEoBAaHg0nc6a5Pdm8aKYbQz4wFghl3akW+SAjLMbfEIwYOmMBc0GvqWlAmj0mul1eP
         2NfQ==
X-Gm-Message-State: AOJu0YxrlvMw0Nofp93LshVkPhmci8PoKyZ7cL3AJ4srVzxhsJlUtE0X
        SZ8hh/Plm31TCtGN18+ihZj16t94Ti6MRus9FZr66x4pbnL5Tct0VWJf81EcPsax7VITvGCIyO7
        ZKdMyd0hsZtN/
X-Received: by 2002:a05:6a00:1a0c:b0:68e:2478:d6c9 with SMTP id g12-20020a056a001a0c00b0068e2478d6c9mr17909423pfv.2.1696982541524;
        Tue, 10 Oct 2023 17:02:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWhd6XUYIsaQzAZtnZe+ysZHmeM5/iQ/juGbct7YlefUAElw+vf/DSFUZdO4ZklBLPZMC6RQ==
X-Received: by 2002:a05:6a00:1a0c:b0:68e:2478:d6c9 with SMTP id g12-20020a056a001a0c00b0068e2478d6c9mr17909398pfv.2.1696982541203;
        Tue, 10 Oct 2023 17:02:21 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:b890:3e54:96bb:2a15? ([2001:8003:e5b0:9f00:b890:3e54:96bb:2a15])
        by smtp.gmail.com with ESMTPSA id d25-20020aa78699000000b0068790c41ca2sm8781183pfo.27.2023.10.10.17.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Oct 2023 17:02:20 -0700 (PDT)
Message-ID: <94951adc-4770-7bba-15c4-f63a5d566d56@redhat.com>
Date:   Wed, 11 Oct 2023 10:02:16 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 3/3] arm/kvm: convert to read_sys_reg64
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20231010142453.224369-1-cohuck@redhat.com>
 <20231010142453.224369-4-cohuck@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231010142453.224369-4-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/23 00:24, Cornelia Huck wrote:
> We can use read_sys_reg64 to get the SVE_VLS register instead of
> calling GET_ONE_REG directly.
> 
> Suggested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   target/arm/kvm64.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 558c0b88dd69..d40c89a84752 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -500,10 +500,6 @@ uint32_t kvm_arm_sve_get_vls(CPUState *cs)
>               .target = -1,
>               .features[0] = (1 << KVM_ARM_VCPU_SVE),
>           };
> -        struct kvm_one_reg reg = {
> -            .id = KVM_REG_ARM64_SVE_VLS,
> -            .addr = (uint64_t)&vls[0],
> -        };
>           int fdarray[3], ret;
>   
>           probed = true;
> @@ -512,7 +508,7 @@ uint32_t kvm_arm_sve_get_vls(CPUState *cs)
>               error_report("failed to create scratch VCPU with SVE enabled");
>               abort();
>           }
> -        ret = ioctl(fdarray[2], KVM_GET_ONE_REG, &reg);
> +        ret = read_sys_reg64(fdarray[2], &vls[0], KVM_REG_ARM64_SVE_VLS);
>           kvm_arm_destroy_scratch_host_vcpu(fdarray);
>           if (ret) {
>               error_report("failed to get KVM_REG_ARM64_SVE_VLS: %s",

