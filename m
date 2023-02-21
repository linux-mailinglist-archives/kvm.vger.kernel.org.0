Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B9B69DF27
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 12:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbjBULnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 06:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbjBULnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 06:43:08 -0500
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5B127D59;
        Tue, 21 Feb 2023 03:42:41 -0800 (PST)
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 55E29123B26B;
        Tue, 21 Feb 2023 12:42:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1676979756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yiNWgaLBJ1ijIp+MAuTp36zukgy67HOKVlUc0Zj0QLo=;
        b=OEMsaRuW9uHiIM+s4Q4DkWh6Qhf64il6GwoNPSK666mlwKu4tEC5VnJ3/CO5gN0ktdIXkp
        19YZfIckc1AgRB1ZC09RMDxAGUrj4rJR+GYaOTnxkiZKLnu8rBtIbai8htONONgkjqejRo
        6rJOcuNy0Tds4YNHOJeP9D/Cb4Chxdc=
MIME-Version: 1.0
Date:   Tue, 21 Feb 2023 12:42:36 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Usama Arif <usama.arif@bytedance.com>
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
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <d91f96eb-86a1-c794-761d-a96e39076b13@bytedance.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
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
Message-ID: <6e7d75d98266ab68b57bf6db644ecc75@natalenko.name>
X-Sender: oleksandr@natalenko.name
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.02.2023 11:47, Usama Arif wrote:
> On 21/02/2023 10:27, David Woodhouse wrote:
>> 
>> On 21 February 2023 09:49:51 GMT, Oleksandr Natalenko 
>> <oleksandr@natalenko.name> wrote:
>>> On 21.02.2023 10:06, David Woodhouse wrote:
>>>> Why does arch/x86/kernel/acpi/sleep.c::x86_acpi_suspend_lowlevel() 
>>>> set
>>>> 
>>>>      initial_gs = per_cpu_offset(smp_processor_id()) ?
>>>> 
>>>> Would it not be CPU#0 that comes back up, and should it not get
>>>> per_cpu_offset(0) ?
>>> 
>>> Wanna me try `initial_gs = per_cpu_offset(0);` too?
>> 
> 
> I think it might be smp_processor_id() and not 0 incase CPU0 was 
> offline at the point the system was suspended?

Is it even possible for CPU 0 to be offline, at least on x86?

-- 
   Oleksandr Natalenko (post-factum)
