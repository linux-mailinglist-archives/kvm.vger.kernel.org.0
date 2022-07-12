Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6165727BB
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 22:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiGLUvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 16:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiGLUvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 16:51:04 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17CC6252B6
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 13:51:04 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 495B7165C;
        Tue, 12 Jul 2022 13:51:04 -0700 (PDT)
Received: from [192.168.5.23] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3DF03F70D;
        Tue, 12 Jul 2022 13:51:02 -0700 (PDT)
Message-ID: <7e3810f6-5fc9-3a29-71c7-1610b8300c1e@arm.com>
Date:   Tue, 12 Jul 2022 21:50:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v3 25/27] arm64: Add support for efi in
 Makefile
Content-Language: en-GB
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, drjones@redhat.com,
        pbonzini@redhat.com, jade.alglave@arm.com, ricarkol@google.com
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-26-nikos.nikoleris@arm.com>
 <Ys15pk9rhYr3BS7i@monolith.localdoman>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <Ys15pk9rhYr3BS7i@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 12/07/2022 14:39, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Jun 30, 2022 at 11:03:22AM +0100, Nikos Nikoleris wrote:
>> Users can now build kvm-unit-tests as efi apps by supplying an extra
>> argument when invoking configure:
>>
>> $> ./configure --enable-efi
>>
>> This patch is based on an earlier version by
>> Andrew Jones <drjones@redhat.com>
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> Reviewed-by: Ricardo Koller <ricarkol@google.com>
>> ---
>>   configure           | 15 ++++++++++++---
>>   arm/Makefile.arm    |  6 ++++++
>>   arm/Makefile.arm64  | 18 ++++++++++++++----
>>   arm/Makefile.common | 45 ++++++++++++++++++++++++++++++++++-----------
>>   4 files changed, 66 insertions(+), 18 deletions(-)
>>
>> diff --git a/configure b/configure
>> index 5b7daac..2ff9881 100755
>> --- a/configure
>> +++ b/configure
> [..]
>> @@ -218,6 +223,10 @@ else
>>           echo "arm64 doesn't support page size of $page_size"
>>           usage
>>       fi
>> +    if [ "$efi" = 'y' ] && [ "$page_size" != "4096" ]; then
>> +        echo "efi must use 4K pages"
>> +        exit 1
> 
> Why this restriction?
> 
> The Makefile compiles kvm-unit-tests to run as an UEFI app, it doesn't
> compile UEFI itself. As far as I can tell, UEFI is designed to run payloads
> with larger page size (it would be pretty silly to not be able to boot a
> kernel built for 16k or 64k pages with UEFI).
> 
> Is there some limitation that I'm missing?
> 

Technically, we could allow 16k or 64k granules. But to do that we would 
have to handle cases where the memory map we get from EFI cannot be 
remapped with the new granules. For example, a region might be 12kB and 
mapping it with 16k or 64k granules without moving it is impossible.

Thanks,

Nikos

> Thanks,
> Alex
