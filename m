Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E064BA35D
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiBQOoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:44:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242017AbiBQOo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:44:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C9D420D343
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645109049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5AOSZZQwsMAv3mqXU3sTGoNdYgPHCwU2yhN0Q1Wj6mo=;
        b=F891a5MAAmLmQGtRIegv1dJq1jOUn9Oltpa24I1ETdzt/lTvHHYnKPDc6QXIjZ3xSCw5VD
        BUta1cpYlq2qrbNPwKbJRnh69/lRsDf759Y//swQ1osK1lAsH7tneYAvSM8yZpsEdMo9Nu
        mW1wLdyfdHpuTks+8P9YS3GSkvSfU4A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-xjbzobfAMiqQZ0g8nQNO0A-1; Thu, 17 Feb 2022 09:44:06 -0500
X-MC-Unique: xjbzobfAMiqQZ0g8nQNO0A-1
Received: by mail-ej1-f71.google.com with SMTP id kw5-20020a170907770500b006ba314a753eso1593183ejc.21
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:44:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5AOSZZQwsMAv3mqXU3sTGoNdYgPHCwU2yhN0Q1Wj6mo=;
        b=CmyyW62g63PyCfcKcHjsUhPVsoBA9J1NQSLTvoA/Qg12a96Lah3K8Whctbg+OKOwf4
         K2ZEzLIW9er4Q6thI324dZydTCkA2m3z00KkJfACxc1acmuZDZTZ3M7M1ZWJ+oA+htf4
         xJAG3fmGR5jBzWLtlYeBocVB+NH1opn/8ou72ttxAXqb27bA6O6+kbyKh/MFBmb8lpJT
         2YcIk6OzbRXalfY3GGTrSF1eWjjiK6pzMXgnd5P6J/ZmaWG36Xs/BZgwlvUHwFtncwTS
         /vSIfY62D4gyK0+uSzDv1dUiyt537YAj42P5AlLEvH2ks2pTeKcHTq4CsEMTYNqakyyW
         +R+g==
X-Gm-Message-State: AOAM530SzSIqaRu1z6YxYfr4B3JPrvvANFi2TxHnnvWvy1cIDg8zeJt+
        k2jb4YtpSVW1/stx6zImFKaQYBlhWCnswH9chMPRN/0ytAhBDTqKLEUqyT9JDopMrnpbOF8fUnt
        btmwCVaTm0KXr
X-Received: by 2002:a17:906:e244:b0:6cd:24e3:ab8b with SMTP id gq4-20020a170906e24400b006cd24e3ab8bmr2509838ejb.633.1645109045125;
        Thu, 17 Feb 2022 06:44:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzkXZ6FVMVz3IA89TXOB2qtSPbmhOXQ7dKmyG1xOA/FqXMwa63W7Abyi7SFi6gpfpOWrgoHQ==
X-Received: by 2002:a17:906:e244:b0:6cd:24e3:ab8b with SMTP id gq4-20020a170906e24400b006cd24e3ab8bmr2509827ejb.633.1645109044940;
        Thu, 17 Feb 2022 06:44:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z6sm1261759ejd.96.2022.02.17.06.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 06:44:04 -0800 (PST)
Message-ID: <4be28ff3-55e2-dedf-5654-b0c36779fffe@redhat.com>
Date:   Thu, 17 Feb 2022 15:44:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests GIT PULL 0/9] s390x: smp lib improvements and
 more
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com
References: <20220217143504.232688-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220217143504.232688-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/22 15:34, Claudio Imbrenda wrote:
> Hi Paolo,
> 
> please merge the following changes:
> * SMP lib improvements to increase correctness of SMP tests
> * fix some tests so that each test has a unique output line
> * add a few function to detect the hypervisor
> * rename some macros to bring them in line with the kernel
> 
> MERGE:
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/25
> 
> PIPELINE:
> https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/473371669
> 
> PULL:
> https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-20220217
> 
> Christian Borntraeger (1):
>    s390x/cpumodel: give each test a unique output line
> 
> Claudio Imbrenda (6):
>    s390x: firq: fix running in PV
>    lib: s390x: smp: guarantee that boot CPU has index 0
>    lib: s390x: smp: refactor smp functions to accept indexes
>    s390x: smp: use CPU indexes instead of addresses
>    s390x: firq: use CPU indexes instead of addresses
>    s390x: skrf: use CPU indexes instead of addresses
> 
> Janosch Frank (1):
>    s390x: uv: Fix UVC cmd prepare reset name
> 
> Pierre Morel (1):
>    s390x: stsi: Define vm_is_kvm to be used in different tests
> 
>   lib/s390x/asm/uv.h  |   4 +-
>   lib/s390x/smp.h     |  20 +++--
>   lib/s390x/stsi.h    |  32 ++++++++
>   lib/s390x/vm.h      |   2 +
>   lib/s390x/smp.c     | 173 +++++++++++++++++++++++++++-----------------
>   lib/s390x/vm.c      |  51 ++++++++++++-
>   s390x/cpumodel.c    |   5 +-
>   s390x/firq.c        |  26 ++-----
>   s390x/skrf.c        |   2 +-
>   s390x/smp.c         |  22 +++---
>   s390x/stsi.c        |  23 +-----
>   s390x/uv-guest.c    |   2 +-
>   s390x/uv-host.c     |   2 +-
>   s390x/unittests.cfg |  18 ++++-
>   14 files changed, 243 insertions(+), 139 deletions(-)
>   create mode 100644 lib/s390x/stsi.h
> 

Merged, thanks.

Paolo

