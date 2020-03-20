Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E8618C9D9
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 10:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCTJOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 05:14:53 -0400
Received: from foss.arm.com ([217.140.110.172]:46286 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgCTJOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 05:14:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F326830E;
        Fri, 20 Mar 2020 02:14:50 -0700 (PDT)
Received: from [192.168.0.106] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB82B3F305;
        Fri, 20 Mar 2020 02:14:49 -0700 (PDT)
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
To:     Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <20200318215847.GC8477@willie-the-truck>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1a9578a8-8907-94f6-0f8f-ad8ff08b5028@arm.com>
Date:   Fri, 20 Mar 2020 09:15:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200318215847.GC8477@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On 3/18/20 9:58 PM, Will Deacon wrote:

> On Fri, Feb 21, 2020 at 04:55:32PM +0000, Andre Przywara wrote:
>> From: Raphael Gault <raphael.gault@arm.com>
>>
>> The EDK II UEFI firmware implementation requires some storage for the EFI
>> variables, which is typically some flash storage.
>> Since this is already supported on the EDK II side, we add a CFI flash
>> emulation to kvmtool.
>> This is backed by a file, specified via the --flash or -F command line
>> option. Any flash writes done by the guest will immediately be reflected
>> into this file (kvmtool mmap's the file).
>> The flash will be limited to the nearest power-of-2 size, so only the
>> first 2 MB of a 3 MB file will be used.
>>
>> This implements a CFI flash using the "Intel/Sharp extended command
>> set", as specified in:
>> - JEDEC JESD68.01
>> - JEDEC JEP137B
>> - Intel Application Note 646
>> Some gaps in those specs have been filled by looking at real devices and
>> other implementations (QEMU, Linux kernel driver).
>>
>> At the moment this relies on DT to advertise the base address of the
>> flash memory (mapped into the MMIO address space) and is only enabled
>> for ARM/ARM64. The emulation itself is architecture agnostic, though.
>>
>> This is one missing piece toward a working UEFI boot with kvmtool on
>> ARM guests, the other is to provide writable PCI BARs, which is WIP.
>>
>> Signed-off-by: Raphael Gault <raphael.gault@arm.com>
>> [Andre: rewriting and fixing]
>> Signed-off-by: Andre Przywra <andre.przywara@arm.com>
>> ---
>> Hi,
>>
>> an update fixing Alexandru's review comments (many thanks for those!)
>> The biggest change code-wise is the split of the MMIO handler into three
>> different functions. Another significant change is the rounding *down* of
>> the present flash file size to the nearest power-of-two, to match flash
>> hardware chips and Linux' expectations.
> Alexandru -- are you happy with this now?

I really appreciate taking the time to look at it, but at the moment I'm busy
testing v3 of the reassignable BARs and PCIE support [1]. I'll try to send the
patches as soon as possible, then I'll review this patch.

[1] https://www.spinics.net/lists/kvm/msg204878.html

Thanks,
Alex
>
> Will
