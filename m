Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72C6F42C9
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 13:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbjEBL17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 07:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbjEBL1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 07:27:53 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF8F61B3
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 04:27:22 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f1958d3a53so36061635e9.0
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 04:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683026836; x=1685618836;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NsayxzKy/RyIeoLNcn+o6YxMBMjitP1LJXdDm+9c9zw=;
        b=IfF/O6zC0uKOOhaxZevx28cGQ0t5F3nb6tfELvDEuAv4Ho+uJW/SKpo8GRT5kp2ipU
         xjEYoo6oe+XYSY9fjo7ZGztVtu1sAhXQttJHeDubVmCXEdx/U9Fvf5o0+yCXCsVBE0Bl
         YZpTpYVIivQUBbB4viIJQ3/1oxMa3PJ6k+pTVMrKjjmCUf3DbHcPI3HcbIOTKg72A9RG
         vqh50Tu2Ei/T/Ipa3d2VzCxXZ1TPsYmnMuTvhdkl6a1O6QbAADNkNVharORgEnmSMrga
         5rSn4VaykotpVQRotHcG03hXyVEIy2SoGKG+bWeDIlrkzM266PxkQ8osacdc60fzTyep
         EE+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683026836; x=1685618836;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NsayxzKy/RyIeoLNcn+o6YxMBMjitP1LJXdDm+9c9zw=;
        b=hw83Lc/I6p+94ueDtYGfXsHHEmTfH2LJcNcVGNBt++oSSMEt7Uk2iftcjT48Y++P+e
         1RxWk02gseP7xj4Kov72VU9fsjpNXdbWcTKMokY5Qbrq2zhSOFKF2/+7PmGCCv+EGlzm
         LSOvV3wctJ7lyKjGR//GwRdDm0oVe5Zd0s2Q3fKWpQ9UCRRik5X1swvcvvClsujbpZMB
         AUi4NmvtovPRVuUcJByDsUcN5ddnMjOZw8zTaOAa4Ggm7OoJ9P2RVWZSGJpCeTZevnvD
         yJaDZ1cBhCUb0f+K8Istbt4Gaqe1xF+QdpRX6OWoFjSAauZvD7pMlfIcMuOMkZwKEf/z
         pkjA==
X-Gm-Message-State: AC+VfDwtO/kJdT/zupyUkvEXHkRoQUXfUQ0zY74NhZNoyHEtgX8yBBjm
        j929xPTAlfi8G+4u10vMHJCS1A==
X-Google-Smtp-Source: ACHHUZ7or5DBLdeIYckUdS/BPaSulrcDTUNlqpkHUvD1wvclCb/16UHB4oXbJqxmoGkAqXINNge4uQ==
X-Received: by 2002:a7b:c7d4:0:b0:3f1:6fb3:ffcc with SMTP id z20-20020a7bc7d4000000b003f16fb3ffccmr12628005wmk.22.1683026835891;
        Tue, 02 May 2023 04:27:15 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:ad29:f02c:48a2:269c? ([2a02:c7c:74db:8d00:ad29:f02c:48a2:269c])
        by smtp.gmail.com with ESMTPSA id n17-20020a5d4c51000000b002d6f285c0a2sm30741205wrt.42.2023.05.02.04.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 04:27:15 -0700 (PDT)
Message-ID: <7d71b26f-3c5d-1588-6cb2-f6043b03b0bf@linaro.org>
Date:   Tue, 2 May 2023 12:27:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v2 5/9] target/loongarch: Implement kvm_arch_init
 function
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        philmd@linaro.org, peter.maydell@linaro.org
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
 <20230427072645.3368102-6-zhaotianrui@loongson.cn>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230427072645.3368102-6-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/23 08:26, Tianrui Zhao wrote:
> Implement the kvm_arch_init of loongarch, in the function, the
> KVM_CAP_MP_STATE cap is checked by kvm ioctl.
> 
> Signed-off-by: Tianrui Zhao<zhaotianrui@loongson.cn>
> ---
>   target/loongarch/kvm.c | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
