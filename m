Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393DD72BE73
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 12:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbjFLKMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 06:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjFLKMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 06:12:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2480E4481
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 02:52:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE63D1FB;
        Mon, 12 Jun 2023 02:52:51 -0700 (PDT)
Received: from [192.168.13.137] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F7973F663;
        Mon, 12 Jun 2023 02:52:04 -0700 (PDT)
Message-ID: <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
Date:   Mon, 12 Jun 2023 10:52:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>,
        Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com,
        ricarkol@google.com, shahuang@redhat.com
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230612-6e1f6fac1759f06309be3342@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/06/2023 08:52, Andrew Jones wrote:
> On Sat, Jun 10, 2023 at 01:32:59AM -0700, Nadav Amit wrote:
>>
>>> On May 30, 2023, at 9:08 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
>>>
>>> Hello,
>>>
>>> This series adds initial support for building arm64 tests as EFI
>>> apps and running them under QEMU. Much like x86_64, we import external
>>> dependencies from gnu-efi and adapt them to work with types and other
>>> assumptions from kvm-unit-tests. In addition, this series adds support
>>> for enumerating parts of the system using ACPI.
>>
>> Just an issue I encountered, which I am not sure is arm64 specific:
>>
>> All the printf’s in efi_main() are before current_thread_info() is
>> initialized (or even memset’d to zero, as done in setup_efi).
>>
>> But printf() calls puts() which checks if mmu_enabled(). And
>> mmu_enabled() uses is_user() and current_thread_info()->cpu, both
>> of which read uninitialized data from current_thread_info().
>>
>> IOW: Any printf in efi_main() can cause a crash.
>>
> 
> Nice catch, Nadav. Nikos, shouldn't we drop the memset() in setup_efi and
> put a zero_range call, similar to the one in arm/cstart64.S which zero's
> the thread-info area, in arm/efi/crt0-efi-aarch64.S?
> 

While I haven't run into any problems with this in this series, I had in 
a previous version and back then the solution was this patch:

993c37be - arm/arm64: Zero BSS and stack at startup

So I agree we should drop the memset and call some macro like zero_range 
in arm/efi/crt0-efi-aarch64.S.

Let me know if you want me to send a patch for this.

Thanks,

Nikos
