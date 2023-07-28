Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328C2766797
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbjG1IrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbjG1Iqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:46:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9118749E3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690533899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Uyr4WvjeGH9eJSbsKayrvL+sdZXLZ/oyLrPRG3lsFU=;
        b=eCUw0BUROiu1z3UIUnBgBAnXjLw9pKNkY5iIVrmbCUxyFf0f0CVJMTYc2emkTqefj60mOs
        oF9LlUZ8t7nYgKoo9FRxpoLOsLj0OJNqU8myFRrqkEa44U9ECAeny7rmSXSWigReU8cHEK
        q5+KhlPjDUbk8Gq0XiuMZhASQZlBy2s=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-MzYJfQdiNsaH7acYhs-8Xw-1; Fri, 28 Jul 2023 04:44:57 -0400
X-MC-Unique: MzYJfQdiNsaH7acYhs-8Xw-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-66d8b0f8a1aso257900b3a.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:44:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690533896; x=1691138696;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Uyr4WvjeGH9eJSbsKayrvL+sdZXLZ/oyLrPRG3lsFU=;
        b=O0YOaZrz11GPTuJhSDrLCjy87SkDF4WgBFiHg2DP69SsRaBtS53ecRAPEZjCjK8DyN
         ZnxSdG55cOViN+C37QS9eyzRAloo0gyXHAIX68MXr38fqrum1CyjxuI42gkmlWlaVFNG
         eirHCZD9nzFkRaGONiJmynl4A3stvVXH7JLnmwX0juFobtrQuRi0P3pxQIrMYIo902r7
         zftdN4UaLtMktsvRJn+IQ/Y9MJK2sNmUlBwuxG4E3Rtky3433ZdMQjl3KQU+yUICA6MZ
         ECaLHNx0N4tXOcLnIAchBl13F8QNDVkk0eU1Zuve3IOCv6Da5h5eFJCsVrKgihYTniSO
         H2vw==
X-Gm-Message-State: ABy/qLbn6YQiIK2rYF4UkjRETR7+BkKr3SWqPzlGmaMmCzvtN/PlalF1
        2O53zQqYe4BIDg9m1pIj+FebE4D2cdyeUY4ShHoU8uLLobMVz/bUJpXLEGHk1t5Ndojm8cfLIap
        qkNupbYfyGaMNxqN2/ut7JBI=
X-Received: by 2002:a05:6a00:4a11:b0:67f:7403:1fe8 with SMTP id do17-20020a056a004a1100b0067f74031fe8mr1703192pfb.3.1690533896259;
        Fri, 28 Jul 2023 01:44:56 -0700 (PDT)
X-Google-Smtp-Source: APBJJlE6o4l+zuI/EnLalfA6wNdz5sM4luC1jiCucE/Q8s8BSEenqEo9hetzJrblyhRgflRyxxMsfA==
X-Received: by 2002:a05:6a00:4a11:b0:67f:7403:1fe8 with SMTP id do17-20020a056a004a1100b0067f74031fe8mr1703182pfb.3.1690533895959;
        Fri, 28 Jul 2023 01:44:55 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9-20020aa78689000000b0064fa2fdfa9esm2709966pfo.81.2023.07.28.01.44.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jul 2023 01:44:55 -0700 (PDT)
Message-ID: <c7469514-145b-2a90-9352-6d83c254afcc@redhat.com>
Date:   Fri, 28 Jul 2023 16:44:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH 0/3] migration: fixes and multiple
 migration
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>
References: <20230725033937.277156-1-npiggin@gmail.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230725033937.277156-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nicholas,

With the patch3 arch-run: Support multiple migrations.

The run_test.sh will fail on the migration test on arm64 platform. But 
the patch1 and patch2 looks good, only apply these two patches the 
migration test works good.

I haven't had time to investigate it. But first let you know that.

Thanks,
Shaoqin

On 7/25/23 11:39, Nicholas Piggin wrote:
> Spent too long looking at bash code after posting previous RFC, but
> got it into shape.
> 
> The first 2 seem to be real bugs you can trigger by making a test
> case fail. Third IMO is pretty solid now but no users yet so I can
> keep it around and resubmit with a user some time later.
> 
> Thanks,
> Nick
> 
> Nicholas Piggin (3):
>    migration: Fix test harness hang on fifo
>    migration: Fix test harness hang if source does not reach migration
>      point
>    arch-run: Support multiple migrations
> 
>   lib/migrate.c         |  8 +++---
>   lib/migrate.h         |  1 +
>   scripts/arch-run.bash | 65 ++++++++++++++++++++++++++++++++++++-------
>   3 files changed, 60 insertions(+), 14 deletions(-)
> 

-- 
Shaoqin

