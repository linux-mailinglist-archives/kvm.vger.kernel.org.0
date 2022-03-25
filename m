Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59684E7B3C
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiCYTdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 15:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiCYTdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 15:33:20 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E64D1E1128;
        Fri, 25 Mar 2022 12:25:27 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j18so12124947wrd.6;
        Fri, 25 Mar 2022 12:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Sgbjug1G1pDZEKRwaUL1TQtnWkwNkNtU3IYL1gdFP3w=;
        b=Db2kfa5wv+R/GAy5yAWKd3ZJyWZ//HsIphCEG1Q7xsFw3DOwgACCMqx5rQ/wCZ8P/n
         FU+pqDPCyWVFe1SO55l1OqkO2H7mILfusI0LlqczO6QF0rF+dcG6yYlZWT9YI9iN2xvb
         SrZylMvQ8AUbFU8VR96Ho09orEblh53iE4zIY8WQhhDcek3MxJrA4+WlGlTIgJ2Ox1fo
         24yoso/arzV8rjED72V8UCmkbyr7W5S5+tkH+SutSt7RLoGdbhbyeGCpLh3nxHneaiwE
         DEWYg2L997w7XbinNL1PC8av4ZOXpVWGWwTGKolwEB23+ukFj9OvHe+sMoXs8RNfy7Y/
         28/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Sgbjug1G1pDZEKRwaUL1TQtnWkwNkNtU3IYL1gdFP3w=;
        b=dJLj7qsmlF239rgeZb2SP5If9T2D4KPo5jefpQjkk+iCerOHd1gClyIhlbtOpT66lr
         VIojccLseaMdA0xXpTXxgQ83FzyhzjRaUQgtRwDwY8Xkst9dX3couemWmbbCa7kkGhZQ
         ZbrIeaARsQ8+CYywJPt1lSYsH5Z+9SDe8jlPnNMo8Srdz+1lqiOdvl7es8hnWVwVSaWV
         g8EWwIOcRaFYTiedVOyZZfKMb7voRWSTNxEQh/GSj/dscpFBL5t3Cn+xtHoUD/4YDbJY
         N27x5nwj/QvNzHgIIAVZFKHQV3hGpKaXpsbizLmXiQ0tVnWiA6xb9jAGUvyuTG3sedza
         Ak0g==
X-Gm-Message-State: AOAM532MzbFkHFd7n6+Ri9mUriXxYFfZKg4r/Feh2F0OJKaUl6vXo01l
        oNg/wovzbg8sS+n6RU9e1rqr9J2/B7c=
X-Google-Smtp-Source: ABdhPJxcbxuTUqUJfWLwLUZezMhXUEn9uZCde44uBGEI83pW9cWU8hxCLi2F4ZA8o+fg61a9Y+FAdQ==
X-Received: by 2002:ac2:4e71:0:b0:448:2f38:72ac with SMTP id y17-20020ac24e71000000b004482f3872acmr8810153lfs.594.1648231866812;
        Fri, 25 Mar 2022 11:11:06 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.225.225])
        by smtp.gmail.com with ESMTPSA id d13-20020a19384d000000b0044a20646b2bsm780687lfj.205.2022.03.25.11.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 11:11:06 -0700 (PDT)
Message-ID: <e0e127c8-1515-2ebf-f473-acc38d60a122@gmail.com>
Date:   Fri, 25 Mar 2022 21:11:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH] KVM: x86/mmu: fix general protection fault in
 kvm_mmu_uninit_tdp_mmu
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+717ed82268812a643b28@syzkaller.appspotmail.com
References: <20220325163815.3514-1-paskripkin@gmail.com>
 <53cc074f-350f-5fa8-1ee4-c33921f17cb1@redhat.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <53cc074f-350f-5fa8-1ee4-c33921f17cb1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 3/25/22 19:50, Paolo Bonzini wrote:
> On 3/25/22 17:38, Pavel Skripkin wrote:
>> Syzbot reported GPF in kvm_mmu_uninit_tdp_mmu(), which is caused by
>> passing NULL pointer to flush_workqueue().
>> 
>> tdp_mmu_zap_wq is allocated via alloc_workqueue() which may fail. There
>> is no error hanling and kvm_mmu_uninit_tdp_mmu() return value is simply
>> ignored. Even all kvm_*_init_vm() functions are void, so the easiest
>> solution is to check that tdp_mmu_zap_wq is valid pointer before passing
>> it somewhere.
> 
> Thanks for the analysis, but not scheduling the work item in
> tdp_mmu_schedule_zap_root is broken; you can't just let the roots
> survive (KVM uses its own workqueue because it needs to work item to
> complete has to flush it before kvm_mmu_zap_all_fast returns).
> 

Ah, I see, thanks for explanation.

I thought about propagating an error up to callers, but 
kvm_mmu_uninit_tdp_mmu() returns false with config disabled, so I 
decided to implement easiest fix w/o digging into details

sorry about that


With regards,
Pavel Skripkin
