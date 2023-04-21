Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323D86EA59C
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjDUIM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjDUIMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B6176A6
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682064696;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z6wPELACKnG6JlCbvCIIgVZmUi4+M35wxj88XoBRlAo=;
        b=apzE4DjniVK0FkuHAdpdFk7X1ADD8lH1AxhrddWTQQY/zSJebm/CIqUnVSIFx//Pq4yHLC
        GdYPSJKzj1CLhUM9UwUNInL3+sasNJ2eas/ofDpko9Aa6BFGWU43reY7g3L6j3kwZJxr3s
        x+9o4ji7+QdFbeqs0K13fnTNWKX1jYU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-sJj0Etr3OKq2Zlbaohh5Ng-1; Fri, 21 Apr 2023 04:11:35 -0400
X-MC-Unique: sJj0Etr3OKq2Zlbaohh5Ng-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-5ef41c0847cso10522856d6.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 01:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682064695; x=1684656695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z6wPELACKnG6JlCbvCIIgVZmUi4+M35wxj88XoBRlAo=;
        b=OE7eJnOPOLOxlIh/Nx2Tw0amWLhvjoj5Hh81eDIy9grLM/+9lu7iwux4Gj2ag49PCb
         JRRC2SUXO/1yre2gsiLbv7ZXhpyqbCkx/zWUJrL1x97uE2BA71HiO4U7bB6H1pncmXz3
         tl2n00gyZHJoEX81lYOkLO7Xic60bxLd3LOxd+9CjWs/QPu4D1ekt4UtDIvGBwZZU7xe
         jI94dNlx4qvzm6QQo763w25TVkh88oCJWUbtzlz9pbdaFSYR5ZpeikTQQ/uPRkRwvaaN
         T4tiOzfXUhYHX71MK23wAZM0eMqmuQ/p+fFjlB6q34MVm7iPvL3ZJaWSEb1BGxnLFDVW
         Q04g==
X-Gm-Message-State: AAQBX9ei8687yahRSBpHuLMtkPT5nsEnBJLrtOtzKRCJqeu9p2+TFLGq
        tAx3BYg4+f16fh7qDufjTZhdpR+ZQ+BLEvKReUYJxGh/Gnmz5HLgIq1EyP49k5T/P2UYwWrV/VL
        C7W+GyQRxnUAT
X-Received: by 2002:ad4:5dcd:0:b0:5ef:4435:f1cd with SMTP id m13-20020ad45dcd000000b005ef4435f1cdmr5541772qvh.27.1682064694868;
        Fri, 21 Apr 2023 01:11:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z9B2WB0oUkbIsJ96q26l4amtJKgMQSnD1Mk7QR+iNWqmQrKLS2X34LNSjQyvgfUyvQocVSaA==
X-Received: by 2002:ad4:5dcd:0:b0:5ef:4435:f1cd with SMTP id m13-20020ad45dcd000000b005ef4435f1cdmr5541758qvh.27.1682064694550;
        Fri, 21 Apr 2023 01:11:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id j13-20020a0cf50d000000b005eee5c22f30sm995299qvm.139.2023.04.21.01.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 01:11:33 -0700 (PDT)
Message-ID: <3129695d-d587-df0e-60d8-dc9f7805e912@redhat.com>
Date:   Fri, 21 Apr 2023 10:11:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <968a026e-066e-deea-d02f-f64133295ff1@redhat.com>
 <xcd3kt23ffdq5qfziuyp2vgwv7ndkmh3acepbpqqhhrokv755e@wuiltddj2hj2>
 <ZDZwIFtH8V59fE4o@FVFF77S0Q05N>
 <6d6126af-4974-0655-e817-5c5c472d5a2f@redhat.com>
 <ZD-2zYGyAhM6q_9Q@monolith.localdoman>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZD-2zYGyAhM6q_9Q@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,
On 4/19/23 11:39, Alexandru Elisei wrote:
> Hi,
>
> On Wed, Apr 19, 2023 at 09:32:10AM +0200, Eric Auger wrote:
>> Hi,
>>
>> On 4/12/23 10:47, Mark Rutland wrote:
>>> On Tue, Apr 04, 2023 at 02:47:47PM +0200, Andrew Jones wrote:
>>>> On Tue, Apr 04, 2023 at 08:23:15AM +0200, Eric Auger wrote:
>>>>> Hi,
>>>>>
>>>>> On 3/15/23 12:07, Eric Auger wrote:
>>>>>> On some HW (ThunderXv2), some random failures of
>>>>>> pmu-chain-promotion test can be observed.
>>>>>>
>>>>>> pmu-chain-promotion is composed of several subtests
>>>>>> which run 2 mem_access loops. The initial value of
>>>>>> the counter is set so that no overflow is expected on
>>>>>> the first loop run and overflow is expected on the second.
>>>>>> However it is observed that sometimes we get an overflow
>>>>>> on the first run. It looks related to some variability of
>>>>>> the mem_acess count. This variability is observed on all
>>>>>> HW I have access to, with different span though. On
>>>>>> ThunderX2 HW it looks the margin that is currently taken
>>>>>> is too small and we regularly hit failure.
>>>>>>
>>>>>> although the first goal of this series is to increase
>>>>>> the count/margin used in those tests, it also attempts
>>>>>> to improve the pmu-chain-promotion logs, add some barriers
>>>>>> in the mem-access loop, clarify the chain counter
>>>>>> enable/disable sequence.
>>>>>>
>>>>>> A new 'pmu-memaccess-reliability' is also introduced to
>>>>>> detect issues with MEM_ACCESS event variability and make
>>>>>> the debug easier.
>>> As a minor nit, 'pmu-mem-access-reliability' would be more consistent with
>>> 'pmu-mem-access'. The lack of a dash in 'memaccess' tripped me up while I was
>>> trying to run those two tests.
>> I can easily respin with that renaming. thanks for the feedback. Waiting
>> a little bit more if somebody has any other comment.
> Started reviewing the series last week, something came up and I had to stop
> after the first patch (very nice improvement, by the way). I will finish
> the review by the end of this week.

OK no problem. Thanks for your time.

Eric
>
> Thanks,
> Alex
>
>> Eric
>>>>>> Obviously one can wonder if this variability is something normal
>>>>>> and does not hide any other bug. I hope this series will raise
>>>>>> additional discussions about this.
>>>>>>
>>>>>> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v1
>>>>> Gentle ping.
>>>> I'd be happy to take this, but I was hoping to see some r-b's and/or t-b's
>>>> from some of the others.
>>> I gave this a spin on my ThunderX2, and it seems to fix the intermittent
>>> failures I was seeing.
>>>
>>> FWIW:
>>>
>>> Tested-by: Mark Rutland <mark.rutland@arm.com>
>>>
>>> Before (on commit 4ba7058c61e8922f9c8397cfa1095fac325f809b):
>>>
>>> Test results below.
>>>
>>> | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL= useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
>>> | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-chain-promotion # -initrd /tmp/tmp.nl1i6S0EIY
>>> | INFO: PMU version: 0x4
>>> | INFO: PMU implementer/ID code: 0(" ")/0
>>> | INFO: Implements 6 event counters
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: chain counter not counting if even counter is disabled
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: odd counter did not increment on overflow if disabled
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x7
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 has value 0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: overflow counter 0x1
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x4
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x1b
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: should have triggered an overflow on #0
>>> | FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 shouldn't have incremented
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: counter #0 = 0xffffffdc, counter #1 = 0x0 overflow=0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x4
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x1b
>>> | FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: CHAIN counter was incremented and overflow
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 = 0x0, overflow=0x1
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x4
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x1b
>>> | FAIL: pmu: pmu-chain-promotion: 32-bit overflows: 32b->64b: CHAIN counter incremented and overflow
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 = 0x0, overflow=0x1
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: counter #0=0xfffffff3, counter #1=0x0
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: overflow is expected on counter 0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: counter #0=0xa, counter #1=0xf9 overflow=0x1
>>> | SUMMARY: 7 tests, 3 unexpected failures
>>>
>>> After:
>>>
>>> | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL=kvm useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
>>> | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-chain-promotion # -initrd /tmp/tmp.pahLyg1F3s
>>> | INFO: PMU version: 0x4
>>> | INFO: PMU implementer/ID code: 0(" ")/0
>>> | INFO: Implements 6 event counters
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest1: post #1=0x0 #0=0x0 overflow=0x0
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest1: chain counter not counting if even counter is disabled
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest2: post #1=0x0 #0=0xf3 overflow=0x1
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest2: odd counter did not increment on overflow if disabled
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: init #1=0x0 #0=0xfffffea1 overflow=0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: After 1st loop #1=0x0 #0=0xffffffa0 overflow=0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: After 2d loop #1=0x0 #0=0xc0 overflow=0x1
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: should have triggered an overflow on #0
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: CHAIN counter #1 shouldn't have incremented
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: init #1=0x0 #0=0xfffffea1 overflow=0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: After 1st loop #1=0x0 #0=0xffffffb7 overflow=0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: After 2d loop #1=0x1 #0=0xbc overflow=0x1
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: CHAIN counter enabled: CHAIN counter was incremented and overflow
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: init #1=0x0 #0=0xfffffea1 overflow=0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: After 1st loop #1=0x22c #0=0xffffff9f overflow=0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: After 2d loop #1=0x1 #0=0x9d overflow=0x1
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: 32b->64b: CHAIN counter incremented and overflow
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: init #1=0x0 #0=0xfffffea1 overflow=0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: After 1st loop #1=0x0 #0=0xffffff9f overflow=0x0
>>> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: After 2d loop #1=0x1f9 #0=0x9c overflow=0x1
>>> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: overflow is expected on counter 0
>>> | SUMMARY: 7 tests
>>>
>>> As a bonus, the mem-access and memaccess-reliability results:
>>>
>>> | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL=kvm useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-mem-access'     
>>> | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-mem-access # -initrd /tmp/tmp.84AeEp8Tiw
>>> | INFO: PMU version: 0x4
>>> | INFO: PMU implementer/ID code: 0(" ")/0
>>> | INFO: Implements 6 event counters
>>> | INFO: pmu: pmu-mem-access: 32-bit overflows: counter #0 is 0x15 (MEM_ACCESS)
>>> | INFO: pmu: pmu-mem-access: 32-bit overflows: counter #1 is 0x15 (MEM_ACCESS)
>>> | PASS: pmu: pmu-mem-access: 32-bit overflows: Ran 20 mem accesses
>>> | PASS: pmu: pmu-mem-access: 32-bit overflows: Ran 20 mem accesses with expected overflows on both counters
>>> | INFO: pmu: pmu-mem-access: 32-bit overflows: cnt#0=0x8 cnt#1=0x8 overflow=0x3
>>> | SKIP: pmu: pmu-mem-access: 64-bit overflows: Skip test as 64 overflows need FEAT_PMUv3p5
>>> | SUMMARY: 3 tests, 1 skipped
>>> | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL=kvm useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-memaccess-reliability'
>>> | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-memaccess-reliability # -initrd /tmp/tmp.ZToqwencZR
>>> | INFO: PMU version: 0x4
>>> | INFO: PMU implementer/ID code: 0(" ")/0
>>> | INFO: Implements 6 event counters
>>> | INFO: pmu: pmu-memaccess-reliability: 32-bit overflows: overflow=0 min=251 max=283 COUNT=250 MARGIN=100
>>> | PASS: pmu: pmu-memaccess-reliability: 32-bit overflows: memaccess is reliable
>>> | SKIP: pmu: pmu-memaccess-reliability: 64-bit overflows: Skip test as 64 overflows need FEAT_PMUv3p5
>>> | SUMMARY: 2 tests, 1 skipped
>>>
>>> Thanks,
>>> Mark.
>>>

