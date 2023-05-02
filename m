Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E7F6F421C
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 12:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbjEBK6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 06:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbjEBK6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 06:58:50 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ECD3C19
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 03:58:49 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f09b4a1584so22800095e9.2
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 03:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683025128; x=1685617128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oQOiTj4AsjumRpvb+Q6fw6xwgPGolMz8lN1nlISv9jY=;
        b=XgQgRN6/fG9lEr6dkPvTDU/asHfQYhnqV8zSeoej+OSUOdu/HjQUyyYYqnZNF0XKFX
         H/x158pwVU8YWFzwsnwT/WQtWETGNl6cUvLm2eGwJHdQVQrSKoilncMfYOfFfHjKtP40
         wJsY/7gwhYA8ZgzhvaxwnyaCPQk2Lwj4bTJpb4HzpIe5tpJZOHpKexM8pytQqLbM3I5d
         AkvcqUctT5yse8+pqBYlzg1k4JUOvpzHGJVBOenPbPD0tn4n9fcij+a4DyMIonGQobNm
         7Pz3q96KmwUcPwBRe1xKtMX75Oz19hl6BRnTnGn5kdQok/g3PGy6vdZcXmNHuhTFrU8d
         YuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683025128; x=1685617128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oQOiTj4AsjumRpvb+Q6fw6xwgPGolMz8lN1nlISv9jY=;
        b=TOa+KK9SeXy5Gd6cfOCjC5ol35V7W+9JiwxBg/8Ba8yeLL4onUiCypnKC+Bu/NlHpF
         U53CTsui3QV4q7gizUs4X8yeUsUf+9D4DXW3fSaf7AmiOLn/cv78BbrhnoC4e+xrsJy3
         OXp1Xvx07r7gI7/b8/lmT/SXylTHMCKv/dw8WWu0BObAQOZd6Gw5kDWYaIFgHqGZd+zv
         WUP6yLjtOletBZjZZdmXRt6BLgqMH0/anrnoTiU5I1lGZ84MhuI2KRcmbhpK9EhATq3L
         ulU4BgkKu4jofHkLsfk8Eenz9UgiE1ZktQzcKGFcTv8EbkfMU5mVGwSOgYjMOHco3iIP
         UTSg==
X-Gm-Message-State: AC+VfDwAPUGyMvhujhA2G60rHWkU6Sfosa7Xz1iDYWhcvNXRWTi5KBDy
        JZuE7vRQMkDnwJ1t3KflhdSs0Q==
X-Google-Smtp-Source: ACHHUZ5OiceVNSrZNvgeyEaXoQ0+yhHlMAD2dijJzQCyVae4ROuTp18GBAB/W2IWzMNHip47MIlWbg==
X-Received: by 2002:a1c:4b12:0:b0:3f0:b1c9:25d4 with SMTP id y18-20020a1c4b12000000b003f0b1c925d4mr11392673wma.21.1683025128203;
        Tue, 02 May 2023 03:58:48 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:ad29:f02c:48a2:269c? ([2a02:c7c:74db:8d00:ad29:f02c:48a2:269c])
        by smtp.gmail.com with ESMTPSA id iv18-20020a05600c549200b003f17b91c3adsm39218710wmb.28.2023.05.02.03.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 03:58:47 -0700 (PDT)
Message-ID: <2c70f6a6-9e13-3412-8e65-43675fda4d95@linaro.org>
Date:   Tue, 2 May 2023 11:58:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 1/1] arm/kvm: add support for MTE
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>, quintela@redhat.com
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>, Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>
References: <20230428095533.21747-1-cohuck@redhat.com>
 <20230428095533.21747-2-cohuck@redhat.com> <87sfcj99rn.fsf@secure.mitica>
 <64915da6-4276-1603-1454-9350a44561d8@linaro.org> <871qjzcdgi.fsf@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <871qjzcdgi.fsf@redhat.com>
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

On 5/2/23 10:03, Cornelia Huck wrote:
> Has anyone been able to access a real system with MTE? (All the systems
> where I had hoped that MTE would be available didn't have MTE in the end
> so far, so I'd be interested to hear if anybody else already got to play
> with one.) Honestly, I don't want to even try to test migration if I only
> have access to MTE on the FVP...

Well there's always MTE on QEMU with TCG.  :-)

But I agree that while it's better than FVP, it's still slow, and difficult to test 
anything at scale.  I have no objection to getting non-migratable MTE on KVM in before 
attempting to solve migration.


r~

