Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBF86E740D
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 09:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjDSHdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 03:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSHdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 03:33:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF06219AA
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 00:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681889536;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSDycLHVzXuKr39+BCkKRfFMiS566DCSNh69j6Wm0i0=;
        b=XHTHEiD/N0+XxY7UEzd91F5J0LILp8mxP9noCR74AwSTXpWb4rOZHwKWJeUaqGYe2fiN52
        KIqBODhelybEzCKEYZNwPBxyYO+Zhi4DWv7m6jK+rY7DaC6F9d1pvQu7jVlurxT+Yd/vUS
        Rmm2OXmglAFrfZvY+UIb5kKOgaTOlEw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-h92vXq9nMaihU782yfqavg-1; Wed, 19 Apr 2023 03:32:14 -0400
X-MC-Unique: h92vXq9nMaihU782yfqavg-1
Received: by mail-qt1-f197.google.com with SMTP id l20-20020a05622a051400b003e6d92a606bso17295264qtx.14
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 00:32:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681889534; x=1684481534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pSDycLHVzXuKr39+BCkKRfFMiS566DCSNh69j6Wm0i0=;
        b=RaNOjFclyRefOi96/8D/GmysHMM1Wrj8Rl4DIqFIHiiCfeS7nDOP7MnFdSIcOKPQKH
         KLiDQreJVFn+BB+L/v4kLWxM5bFwvV7gu4J14YIPxVwAeFO58z6imcu3UjaMdpRBOFVm
         oADdxxFg/Si+/LyDZz4t7pjb3RDZ1GjJNFCQ8ikoJUlsW+RL60ou4x2MfrerVgkx8Hiw
         dMB0dT4MVWX8XQgPIOQK6/IJXXVEAozhFXh56GVABu3rFfGnqH3hK7Cd7DhJ/6O3vfr+
         OwN1opp1StmW4/e3E6M8Wc44jpVlsKBnMbji+fVyGAH3J2fLkrMQB7qhUSe4zjR2iVsv
         /hmg==
X-Gm-Message-State: AAQBX9dOBLA7X1kHjKo0dS3lr7VU0yPTmHKU7toON42wRzkMV7Vdx7MC
        d9rgvFx0utctPXEdJi+kVl1GvjT0YaaURgc7EET2jH7xcqnGNxa0XgsgX+0yirPsjrZjjGSKG7M
        Y6LDp8r3bCVEt
X-Received: by 2002:a05:6214:1304:b0:5e8:63ae:a9a9 with SMTP id pn4-20020a056214130400b005e863aea9a9mr32369841qvb.47.1681889534443;
        Wed, 19 Apr 2023 00:32:14 -0700 (PDT)
X-Google-Smtp-Source: AKy350YZhttW1f54/LAe/PCUBrmJGc+p4nngjcWJyYF/6wGLEPvavC5ZLRbgu7loFEgGcGffr2z7kA==
X-Received: by 2002:a05:6214:1304:b0:5e8:63ae:a9a9 with SMTP id pn4-20020a056214130400b005e863aea9a9mr32369817qvb.47.1681889534200;
        Wed, 19 Apr 2023 00:32:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id m3-20020a0cfba3000000b005dd8b93457asm4236030qvp.18.2023.04.19.00.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 00:32:13 -0700 (PDT)
Message-ID: <6d6126af-4974-0655-e817-5c5c472d5a2f@redhat.com>
Date:   Wed, 19 Apr 2023 09:32:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <968a026e-066e-deea-d02f-f64133295ff1@redhat.com>
 <xcd3kt23ffdq5qfziuyp2vgwv7ndkmh3acepbpqqhhrokv755e@wuiltddj2hj2>
 <ZDZwIFtH8V59fE4o@FVFF77S0Q05N>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZDZwIFtH8V59fE4o@FVFF77S0Q05N>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/12/23 10:47, Mark Rutland wrote:
> On Tue, Apr 04, 2023 at 02:47:47PM +0200, Andrew Jones wrote:
>> On Tue, Apr 04, 2023 at 08:23:15AM +0200, Eric Auger wrote:
>>> Hi,
>>>
>>> On 3/15/23 12:07, Eric Auger wrote:
>>>> On some HW (ThunderXv2), some random failures of
>>>> pmu-chain-promotion test can be observed.
>>>>
>>>> pmu-chain-promotion is composed of several subtests
>>>> which run 2 mem_access loops. The initial value of
>>>> the counter is set so that no overflow is expected on
>>>> the first loop run and overflow is expected on the second.
>>>> However it is observed that sometimes we get an overflow
>>>> on the first run. It looks related to some variability of
>>>> the mem_acess count. This variability is observed on all
>>>> HW I have access to, with different span though. On
>>>> ThunderX2 HW it looks the margin that is currently taken
>>>> is too small and we regularly hit failure.
>>>>
>>>> although the first goal of this series is to increase
>>>> the count/margin used in those tests, it also attempts
>>>> to improve the pmu-chain-promotion logs, add some barriers
>>>> in the mem-access loop, clarify the chain counter
>>>> enable/disable sequence.
>>>>
>>>> A new 'pmu-memaccess-reliability' is also introduced to
>>>> detect issues with MEM_ACCESS event variability and make
>>>> the debug easier.
> As a minor nit, 'pmu-mem-access-reliability' would be more consistent with
> 'pmu-mem-access'. The lack of a dash in 'memaccess' tripped me up while I was
> trying to run those two tests.

I can easily respin with that renaming. thanks for the feedback. Waiting
a little bit more if somebody has any other comment.

Eric
>
>>>> Obviously one can wonder if this variability is something normal
>>>> and does not hide any other bug. I hope this series will raise
>>>> additional discussions about this.
>>>>
>>>> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v1
>>> Gentle ping.
>> I'd be happy to take this, but I was hoping to see some r-b's and/or t-b's
>> from some of the others.
> I gave this a spin on my ThunderX2, and it seems to fix the intermittent
> failures I was seeing.
>
> FWIW:
>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
>
> Before (on commit 4ba7058c61e8922f9c8397cfa1095fac325f809b):
>
> Test results below.
>
> | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL= useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
> | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-chain-promotion # -initrd /tmp/tmp.nl1i6S0EIY
> | INFO: PMU version: 0x4
> | INFO: PMU implementer/ID code: 0(" ")/0
> | INFO: Implements 6 event counters
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: chain counter not counting if even counter is disabled
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: odd counter did not increment on overflow if disabled
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x7
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 has value 0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: overflow counter 0x1
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x4
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x1b
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: should have triggered an overflow on #0
> | FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 shouldn't have incremented
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: counter #0 = 0xffffffdc, counter #1 = 0x0 overflow=0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x4
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x1b
> | FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: CHAIN counter was incremented and overflow
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 = 0x0, overflow=0x1
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x4
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x1b
> | FAIL: pmu: pmu-chain-promotion: 32-bit overflows: 32b->64b: CHAIN counter incremented and overflow
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 = 0x0, overflow=0x1
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: counter #0=0xfffffff3, counter #1=0x0
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: overflow is expected on counter 0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: counter #0=0xa, counter #1=0xf9 overflow=0x1
> | SUMMARY: 7 tests, 3 unexpected failures
>
> After:
>
> | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL=kvm useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
> | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-chain-promotion # -initrd /tmp/tmp.pahLyg1F3s
> | INFO: PMU version: 0x4
> | INFO: PMU implementer/ID code: 0(" ")/0
> | INFO: Implements 6 event counters
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest1: post #1=0x0 #0=0x0 overflow=0x0
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest1: chain counter not counting if even counter is disabled
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest2: post #1=0x0 #0=0xf3 overflow=0x1
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest2: odd counter did not increment on overflow if disabled
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: init #1=0x0 #0=0xfffffea1 overflow=0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: After 1st loop #1=0x0 #0=0xffffffa0 overflow=0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: After 2d loop #1=0x0 #0=0xc0 overflow=0x1
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: should have triggered an overflow on #0
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: CHAIN counter #1 shouldn't have incremented
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: init #1=0x0 #0=0xfffffea1 overflow=0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: After 1st loop #1=0x0 #0=0xffffffb7 overflow=0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: After 2d loop #1=0x1 #0=0xbc overflow=0x1
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: CHAIN counter enabled: CHAIN counter was incremented and overflow
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: init #1=0x0 #0=0xfffffea1 overflow=0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: After 1st loop #1=0x22c #0=0xffffff9f overflow=0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: After 2d loop #1=0x1 #0=0x9d overflow=0x1
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: 32b->64b: CHAIN counter incremented and overflow
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: init #1=0x0 #0=0xfffffea1 overflow=0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: After 1st loop #1=0x0 #0=0xffffff9f overflow=0x0
> | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: After 2d loop #1=0x1f9 #0=0x9c overflow=0x1
> | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: overflow is expected on counter 0
> | SUMMARY: 7 tests
>
> As a bonus, the mem-access and memaccess-reliability results:
>
> | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL=kvm useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-mem-access'     
> | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-mem-access # -initrd /tmp/tmp.84AeEp8Tiw
> | INFO: PMU version: 0x4
> | INFO: PMU implementer/ID code: 0(" ")/0
> | INFO: Implements 6 event counters
> | INFO: pmu: pmu-mem-access: 32-bit overflows: counter #0 is 0x15 (MEM_ACCESS)
> | INFO: pmu: pmu-mem-access: 32-bit overflows: counter #1 is 0x15 (MEM_ACCESS)
> | PASS: pmu: pmu-mem-access: 32-bit overflows: Ran 20 mem accesses
> | PASS: pmu: pmu-mem-access: 32-bit overflows: Ran 20 mem accesses with expected overflows on both counters
> | INFO: pmu: pmu-mem-access: 32-bit overflows: cnt#0=0x8 cnt#1=0x8 overflow=0x3
> | SKIP: pmu: pmu-mem-access: 64-bit overflows: Skip test as 64 overflows need FEAT_PMUv3p5
> | SUMMARY: 3 tests, 1 skipped
> | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL=kvm useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-memaccess-reliability'
> | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-memaccess-reliability # -initrd /tmp/tmp.ZToqwencZR
> | INFO: PMU version: 0x4
> | INFO: PMU implementer/ID code: 0(" ")/0
> | INFO: Implements 6 event counters
> | INFO: pmu: pmu-memaccess-reliability: 32-bit overflows: overflow=0 min=251 max=283 COUNT=250 MARGIN=100
> | PASS: pmu: pmu-memaccess-reliability: 32-bit overflows: memaccess is reliable
> | SKIP: pmu: pmu-memaccess-reliability: 64-bit overflows: Skip test as 64 overflows need FEAT_PMUv3p5
> | SUMMARY: 2 tests, 1 skipped
>
> Thanks,
> Mark.
>

