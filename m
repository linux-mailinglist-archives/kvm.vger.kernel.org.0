Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AA96B51AF
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 21:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjCJUTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 15:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjCJUTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 15:19:13 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C454ECE;
        Fri, 10 Mar 2023 12:18:39 -0800 (PST)
Received: from [10.46.7.190] (i689701D4.versanet.de [104.151.1.212])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 649C861CC457B;
        Fri, 10 Mar 2023 21:18:13 +0100 (CET)
Message-ID: <18ec6bf2-c19a-5fcf-3d6b-4106e2372af1@molgen.mpg.de>
Date:   Fri, 10 Mar 2023 21:18:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v14 00/12] Parallel CPU bringup for x86_64
To:     Tor Vic <torvic9@mailbox.org>
Cc:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        tglx@linutronix.de, kim.phillips@amd.com, brgerst@gmail.com,
        piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20230308171328.1562857-1-usama.arif@bytedance.com>
 <16d9f738-18fd-a929-e711-f2a1e757e33f@mailbox.org>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <16d9f738-18fd-a929-e711-f2a1e757e33f@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Tor,


Am 10.03.23 um 20:20 schrieb Tor Vic:
> On 08.03.23 17:13, Usama Arif wrote:
>> The main code change over v13 is to enable parallel bringup for SEV-ES 
>> guests.

[…]

>>   .../admin-guide/kernel-parameters.txt         |   3 +
>>   arch/x86/include/asm/cpu.h                    |   1 +
>>   arch/x86/include/asm/processor.h              |   6 +-
>>   arch/x86/include/asm/realmode.h               |   4 +-
>>   arch/x86/include/asm/sev-common.h             |   3 +
>>   arch/x86/include/asm/sev.h                    |   5 +
>>   arch/x86/include/asm/smp.h                    |  18 +-
>>   arch/x86/include/asm/topology.h               |   2 -
>>   arch/x86/kernel/acpi/sleep.c                  |  30 +-
>>   arch/x86/kernel/apic/apic.c                   |   2 +-
>>   arch/x86/kernel/apic/x2apic_cluster.c         | 126 +++---
>>   arch/x86/kernel/asm-offsets.c                 |   1 +
>>   arch/x86/kernel/cpu/common.c                  |   6 +-
>>   arch/x86/kernel/cpu/topology.c                |   2 +-
>>   arch/x86/kernel/head_64.S                     | 162 ++++++--
>>   arch/x86/kernel/smpboot.c                     | 366 +++++++++++++-----
>>   arch/x86/realmode/init.c                      |   3 +
>>   arch/x86/realmode/rm/trampoline_64.S          |  27 +-
>>   arch/x86/xen/smp_pv.c                         |   4 +-
>>   arch/x86/xen/xen-head.S                       |   2 +-
>>   include/linux/cpuhotplug.h                    |   2 +
>>   include/linux/smpboot.h                       |   7 +
>>   kernel/cpu.c                                  |  31 +-
>>   kernel/smpboot.h                              |   2 -
>>   24 files changed, 614 insertions(+), 201 deletions(-)
>>
> 
> On Linux 6.2, Zen2 and Skylake, no issues or boot problems:
> 
> Tested-by: Tor Vic <torvic9@mailbox.org>

Thank you for testing this. It’d be great if you shared the exact timing 
numbers too. (Just to be sure, did you also test ACPI S3 suspend/resume?)


Kind regards,

Paul
