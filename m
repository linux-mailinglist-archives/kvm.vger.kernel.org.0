Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6572DB78D
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgLPABC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgLOXYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:24:20 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8656AC0611BB
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:23:40 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id q205so12549811oig.13
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sQqMKuQ7CHnUfOJ+ZBis3l7U0odZUHPj0hUrZtu2A7k=;
        b=dfTyLtaKB9N+IA8BtIFl4WXa4ErO9RHXvN4u5rpRzbPUYGdtyoKqBOFY53CPTAaycn
         KV4mAnQt4BHdUprC9OwtbROx0dBnp0rRR+zsf2TllcromJtx5w7+u/VMtQFNjsX9Bkjq
         jhvnK/J9REr8F4+C4OZnig0yeFQGkPZykFsYoQO1pfL3QzQGfz4aBAwGv0V2aOTMzpHt
         xctZvmJZ3wI25fkA0YhWd8BmAnnPNfd+2EkLwPRy9tGoZWK6jOseVfQZHN2Hnhje0Tp+
         8sQE8QNHJZOuMXGR3oFkRynM5CKvIku0UtvuOGw8kn9HT600utkivkjmScuV3Si/P+iR
         86RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sQqMKuQ7CHnUfOJ+ZBis3l7U0odZUHPj0hUrZtu2A7k=;
        b=ORPRvDydyu1CGCnq049DZ53MPxVxFpkcynMKaxjWjNMnCgPu2/LJ6EKniem42o9Ky+
         YqADG0RredoLXCmg/6DUd15BeR//8KAHG05/b++zHMvwj0OJfW+X+NorIkG+wwvYeWha
         iC60hGVbAoXgK54iRoVDS+L1hU6SosgfChU98w81ISQ1PRlHG8oFgiErA5LIcIU0SvYB
         l2F7+z1KTC6Oe+kcnctEJWs3KOUmZ4NmkdfZum8wWk6NgT1PJNP3orGkBoUFzxHprMuG
         clwnMOkDZZnMVGF2ts10A5HJDSp/n1ewGmpYZNEAecZLcv5JcMn9m+J4RmlhetrU+8w3
         yIeg==
X-Gm-Message-State: AOAM532QCRQ/RVlkq3IJR9lawwrHzC8PZ01AVBlejtENiGGcTH5pGDF3
        5WZFeHabs/ZJWeGImPWeTB7LoA==
X-Google-Smtp-Source: ABdhPJwE3csrCfXnCBlIB+XnBAFMswLppNI7jP4IWvWjAwKE/pfqzW97nn0HFeW3T5XEKNcYi7xcOQ==
X-Received: by 2002:aca:6103:: with SMTP id v3mr648232oib.64.1608074620013;
        Tue, 15 Dec 2020 15:23:40 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id v17sm52883oou.41.2020.12.15.15.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:23:39 -0800 (PST)
Subject: Re: [PATCH v2 01/24] target/mips/translate: Extract
 decode_opc_legacy() from decode_opc()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-2-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <60c6202a-06d6-81ca-0c41-a023bebf4110@linaro.org>
Date:   Tue, 15 Dec 2020 17:23:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-2-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
> As we will slowly move to decodetree generated decoders,
> extract the legacy decoding from decode_opc(), so new
> decoders are added in decode_opc() while old code is
> removed from decode_opc_legacy().
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.c | 45 ++++++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 19 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
