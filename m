Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5B946FE85
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhLJKPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 05:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhLJKPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:15:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876A5C061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 02:11:27 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g14so27562576edb.8
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 02:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=l3qeEo+jWGYFV13NH3oOdulqHhDAMY2J0DO65Q819/8=;
        b=V84DNfMxZXBdpMkjS7DzgFDawHK00I0C+0iEewswkQ0JiNxPpciixx1vbYlDmTYs9s
         MqUOfXByP6cmtYHbyVuSa3Y0r9lTmxeSTBn3+nXXnHLP7drxQ4zkAF6dnXtya0H/oS2K
         iO2lAjSGQ5gza9CJlZEMuVgwohjUyTzW+JvEAo+YdVPL3HrdbWE21MX3wgyGwEE4omhg
         dmJzMlYDHXCjkGgMVa4611xpLiKzZBxocL13G1RkYxmX1/8IG8TqZ05yzzTcwV6GkS2T
         Sk9BTrkDVvZL4mswmYeEBFjTDLP/nMu6UHYMK4w4FMcMHNd+wveoFDqFM3py8N75HyME
         txvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=l3qeEo+jWGYFV13NH3oOdulqHhDAMY2J0DO65Q819/8=;
        b=aenXjL5YT2Y0qJgMB3ZtUyFLMNTZjsfCvTxipkyHv2ScYCIjVK+4O4P3M74dNYdGT5
         w2mZNPKdJsbDVNDaBXohh4xMDMdFPGcRAdSanRptg5kTD9W66i8cDjV0AovX9QWCJd1r
         q0hA84qIO19H/xhEgei+5R9CgBqZSFzAoy4UILBKtaHUfHeACfFD9n//Rk68yeCQI1cb
         jJaeOKGt2YMYGLJ82wrGhvUGjtZ+1ZM65n1NQXCB/0WwxMpfS18g+PC+ZHi/hLkkUbKf
         MyUjbl9UCf8YHwQhttdBSGLJ0AKX3WmkQDDgQCCQoQ4lY3ob/qXOuTNQkMMjInfPpa1r
         GoWQ==
X-Gm-Message-State: AOAM5319CbvEA8vuyVjvNfVSrmnQgomF8GNWWT1t8B3hc54pUxGt4B2z
        JKdfZRQPq+MFm+W49IR/5GPZaKx8TIY=
X-Google-Smtp-Source: ABdhPJzdgCERPEsFn+0ltSoWI8Y11Ak6TqpEH8ksNhEUWGG4fYeeF0xqE5idxUN1Na+O6b+2YsqE3w==
X-Received: by 2002:a17:906:1599:: with SMTP id k25mr22566954ejd.298.1639131086120;
        Fri, 10 Dec 2021 02:11:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::973? ([2001:b07:6468:f312::973])
        by smtp.googlemail.com with ESMTPSA id jg32sm1336819ejc.43.2021.12.10.02.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 02:11:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <02a0ad69-4129-6e6c-06af-fc9c9e3047e1@redhat.com>
Date:   Fri, 10 Dec 2021 11:11:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v1 12/12] target/riscv: Support virtual time context
 synchronization
Content-Language: en-US
To:     Richard Henderson <richard.henderson@linaro.org>,
        Yifei Jiang <jiangyifei@huawei.com>, qemu-devel@nongnu.org,
        qemu-riscv@nongnu.org
Cc:     bin.meng@windriver.com, Mingwang Li <limingwang@huawei.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, anup.patel@wdc.com,
        wanbo13@huawei.com, Alistair.Francis@wdc.com,
        kvm-riscv@lists.infradead.org, wanghaibin.wang@huawei.com,
        fanliang@huawei.com, palmer@dabbelt.com, wu.wubin@huawei.com
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-13-jiangyifei@huawei.com>
 <d9c9196a-692c-cbcf-339b-8e84ecde7cee@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d9c9196a-692c-cbcf-339b-8e84ecde7cee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 23:34, Richard Henderson wrote:
> On 11/20/21 8:46 AM, Yifei Jiang wrote:
>>   const VMStateDescription vmstate_riscv_cpu = {
>>       .name = "cpu",
>>       .version_id = 3,
>>       .minimum_version_id = 3,
>> +    .post_load = cpu_post_load,
>>       .fields = (VMStateField[]) {
>>           VMSTATE_UINTTL_ARRAY(env.gpr, RISCVCPU, 32),
>>           VMSTATE_UINT64_ARRAY(env.fpr, RISCVCPU, 32),
>> @@ -211,6 +221,10 @@ const VMStateDescription vmstate_riscv_cpu = {
>>           VMSTATE_UINT64(env.mtohost, RISCVCPU),
>>           VMSTATE_UINT64(env.timecmp, RISCVCPU),
>> +        VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
>> +        VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
>> +        VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
>> +
>>           VMSTATE_END_OF_LIST()
>>       },
> 
> Can't alter VMStateDescription.fields without bumping version.
> 
> If this is really kvm-only state, consider placing it into a 
> subsection.  But I worry about kvm-only state because ideally we'd be 
> able to migrate between tcg and kvm (if only for debugging).

Where is this state stored for TCG?

Paolo
