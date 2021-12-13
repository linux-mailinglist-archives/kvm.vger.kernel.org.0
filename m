Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F52C473050
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 16:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240074AbhLMPTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 10:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhLMPTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 10:19:47 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EA0C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 07:19:46 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so14870117pju.3
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 07:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wRQAdwlSSg+bW7hgiu0nEjyCka8fgmrwoXgoQdwAwg8=;
        b=Ma7t3l5fQrrhWhCF88CDY8aSKMwrsIT2PFUDhbJrSkkF75g91uGWjG9Zxe9VMgfttm
         w7lnEVeTmbF4fmyDP5ZlWJVaqWqxuo9jPJ9Q2nU1DKOciN0Idmsd0knN2G6acDyhucn4
         X5lhVsRs1HdLbXH21xDUBMMpQsC3gJ02ef0uha/mcucMYtkTOE7ZsHey0SNQhhltEBpZ
         khxTQHEh7RaLEGpObxPH9eHAHllyrcsZ6Jk5KDjN4BVCfIHDAs71B7ZliiLlzhsSZ3VB
         IvuQ96b3ScOQQYi6YqzYgN2826dx7xvq5x0ZsV+YU84vou0Zi602RlrsF5DCsZ1GV1d/
         IyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wRQAdwlSSg+bW7hgiu0nEjyCka8fgmrwoXgoQdwAwg8=;
        b=DuDWn8lELGw2J4hbb0P4iLPto8v34oMMLBbCSTQlXFKAjpXvtIyVUO5UT78G8e055c
         LrOBdUkkic4jLmnZBJJCubE/9xJfETm22WzTwPrf/M/4dpOmguV0TzFKBoRnhpGLFTxa
         9XXRwW4FA6s/jDoriuBczt55ic9/5Tcw9rez6yWytixEnOqH9mXXC0Av1iC3PRI+50Fd
         MWErq8tSut1DdRmy9gk0izhqw7DF6t4EBHWTvRyk8Jb/oXwqVNNThS0GPYvTNNHggheu
         mK89XBM+wMbofVzVbKXSTalbixGKnZSSv2t+7ES0Lx4IIY6aJIPmw9FpAEgpZ0dXLdgc
         9b+g==
X-Gm-Message-State: AOAM532lH9i5jVkquKLppjmC5cz6ctxHDaZR1trWlJGp7GI1N+V3BJ5E
        g5otOGmUqp2F4mk6iT3eYF6yBQ==
X-Google-Smtp-Source: ABdhPJwbaG79dJScJWvcC0ogdKFfMMGqBdfnrx/CE72uqmWs8soTZH0BMziycvnXeMZf8h+kNZjtKg==
X-Received: by 2002:a17:902:7284:b0:142:728b:46a6 with SMTP id d4-20020a170902728400b00142728b46a6mr96313949pll.45.1639408786350;
        Mon, 13 Dec 2021 07:19:46 -0800 (PST)
Received: from [192.168.1.11] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
        by smtp.gmail.com with ESMTPSA id e29sm10643082pge.17.2021.12.13.07.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 07:19:45 -0800 (PST)
Subject: Re: [PATCH v2 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
To:     Anup Patel <anup@brainfault.org>,
        Yifei Jiang <jiangyifei@huawei.com>
Cc:     Bin Meng <bin.meng@windriver.com>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        Mingwang Li <limingwang@huawei.com>,
        KVM General <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Anup Patel <anup.patel@wdc.com>,
        QEMU Developers <qemu-devel@nongnu.org>, wanbo13@huawei.com,
        Palmer Dabbelt <palmer@dabbelt.com>,
        kvm-riscv@lists.infradead.org, wanghaibin.wang@huawei.com,
        Alistair Francis <Alistair.Francis@wdc.com>,
        fanliang@huawei.com, "Wubin (H)" <wu.wubin@huawei.com>
References: <20211210100732.1080-1-jiangyifei@huawei.com>
 <20211210100732.1080-11-jiangyifei@huawei.com>
 <CAAhSdy11yd+f6OZZxjX9mWxkVH4AC7Kz5Vp+RPUz6cCam9GvNQ@mail.gmail.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <dec3147b-24bc-7e48-680b-a7423b0640f9@linaro.org>
Date:   Mon, 13 Dec 2021 07:19:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy11yd+f6OZZxjX9mWxkVH4AC7Kz5Vp+RPUz6cCam9GvNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/21 9:05 PM, Anup Patel wrote:
>> +    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, state), &reg);
>> +    if (ret) {
>> +        abort();
>> +    }
>> +    env->kvm_timer_state = reg;
> 
> Please read the timer frequency here.

Yep.

>> +
>> +    env->kvm_timer_dirty = true;
>> +}
>> +
>> +static void kvm_riscv_put_regs_timer(CPUState *cs)
>> +{
>> +    int ret;
>> +    uint64_t reg;
>> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
>> +
>> +    if (!env->kvm_timer_dirty) {
>> +        return;
>> +    }
> 
> Over here, we should get the timer frequency and abort() with an
> error message if it does not match env->kvm_timer_frequency
> 
> For now, migration will not work between Hosts with different
> timer frequency.

You shouldn't have to do this every "put", only on migration, at which point you can 
actually signal a migration error rather than aborting directly.


r~
