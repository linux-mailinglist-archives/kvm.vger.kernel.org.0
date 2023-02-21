Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7CF69DF5F
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 12:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbjBULzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 06:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjBULzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 06:55:37 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15D025B8E
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 03:54:52 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t15so4237466wrz.7
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 03:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8lzq9naJ5Gwo2WGrWv0NYN2BRYvpnbF1Pf8MG1ViESI=;
        b=1vfskNEeBw11/q2YRjmKPk9C/aSwz5XfH6BYxqXucGqTi4LHziHOgmd0nJ9Dk4Anbr
         VBr5j9XrjyJMeMJwlYhgeUXkA6MdK1+6FQX+Y+ebvbU+Dj/SW9QfoPeZYuZxuFwzxjqs
         4LWrdfFIHxqUYv7H2wOq6RAQrCLCWWowh0m5UwgoRXHAXjL9p8nJVr/gRTesH7Saz7Yy
         mv6sG6L9jcerch+b8Gj7j+6nFABtDFOAaXXiOA+0Yh9wWhgYAIC043KkH1hjlQdJAY8e
         WNXsUFD/pW4PoK+rVdIFJyB4ouNed3pJb5P4dy+KaxWxhaqWYjPIR47rNG/LR30Ot8Nv
         pFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8lzq9naJ5Gwo2WGrWv0NYN2BRYvpnbF1Pf8MG1ViESI=;
        b=PJZJV171kZ696P4b/QKU942UlygDRnpMGd5K+062RktxTFvnMeS4K6vRCmWRaqtCDL
         W8u1jsuFuKJJKXUaZojNkdtB+ytRyHYNtZOWPzR5hshi1pnxs45feCx8FZhDzHPAgkTE
         3f56umcey3ABZVYfukEZWeKe0VFs1M5y0tCbfJta8f21AMj0OiE/RswqgSxNMIG1e0Ul
         IluLdh688+46E23j8tqWB+5RhdbjG0N8GHu4fwJt0+hQ0HFJERzZbGmMtcaf3kusq655
         wq2AVh8AY7THJ8+nBuiRrPc/SpZp8SZclE3XK8TYlh4oq+HddnvI/tkTAdNVlEIKhMUP
         N6/A==
X-Gm-Message-State: AO0yUKWNg/b+W59VxFBI6BE6TUcikq8qhyW2gyN4MbQa8h9Rh9mMsJN0
        5G8BuMXqbLXbMY9dENAT8WA74A==
X-Google-Smtp-Source: AK7set9w+obqnpH8kQtyt0L04B6t2sN1mCYhzDOdSVFbeQypoWXmVKBW+GEhamKB9CPiWpe2+7NXYQ==
X-Received: by 2002:a5d:6f0c:0:b0:2c5:55c3:d18d with SMTP id ay12-20020a5d6f0c000000b002c555c3d18dmr2588566wrb.9.1676980491294;
        Tue, 21 Feb 2023 03:54:51 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:8498:f303:14d8:47b5? ([2a02:6b6a:b566:0:8498:f303:14d8:47b5])
        by smtp.gmail.com with ESMTPSA id n13-20020a5d4c4d000000b002c55de1c72bsm8090429wrt.62.2023.02.21.03.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 03:54:50 -0800 (PST)
Message-ID: <049adfae-f4a0-349e-323a-52299969ef99@bytedance.com>
Date:   Tue, 21 Feb 2023 11:54:50 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
 <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
 <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
 <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
 <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org>
 <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
 <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
 <d91f96eb-86a1-c794-761d-a96e39076b13@bytedance.com>
 <6e7d75d98266ab68b57bf6db644ecc75@natalenko.name>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <6e7d75d98266ab68b57bf6db644ecc75@natalenko.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/02/2023 11:42, Oleksandr Natalenko wrote:
> On 21.02.2023 11:47, Usama Arif wrote:
>> On 21/02/2023 10:27, David Woodhouse wrote:
>>>
>>> On 21 February 2023 09:49:51 GMT, Oleksandr Natalenko 
>>> <oleksandr@natalenko.name> wrote:
>>>> On 21.02.2023 10:06, David Woodhouse wrote:
>>>>> Why does arch/x86/kernel/acpi/sleep.c::x86_acpi_suspend_lowlevel() set
>>>>>
>>>>>      initial_gs = per_cpu_offset(smp_processor_id()) ?
>>>>>
>>>>> Would it not be CPU#0 that comes back up, and should it not get
>>>>> per_cpu_offset(0) ?
>>>>
>>>> Wanna me try `initial_gs = per_cpu_offset(0);` too?
>>>
>>
>> I think it might be smp_processor_id() and not 0 incase CPU0 was 
>> offline at the point the system was suspended?
> 
> Is it even possible for CPU 0 to be offline, at least on x86?
> 

It is possible on x86 (using BOOTPARAM_HOTPLUG_CPU0), but I just read 
the Kconfig option and it says:

"resume from hibernate or suspend always starts from CPU0.
So hibernate and suspend are prevented if CPU0 is offline."

so I guess switching to 0 should be ok.
