Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0692DC06A
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 13:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgLPMi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 07:38:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbgLPMi6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 07:38:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608122251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oABMoOhptkaqKsqL4N/pdk2T+GrxPZ3e3Rs5s0jG0lQ=;
        b=Wpij8qNNXtr5NE/KZqWYNRd2QMCs8B0Y8Gr9iUe95wFHLHNsUzJAVF2+6jF8hyJr4R8tkH
        VshUNYSkskGVA4t3NAFv/v0WbXsbkpCVJ2yjq/fqDlcA0PQnMT+oV/oLBvXtL9oVKquxye
        Xx88CaQ+gp2ik7Glq/3zjSna3alXcOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-_kHs0LayO4uj6OSt2HP73A-1; Wed, 16 Dec 2020 07:37:27 -0500
X-MC-Unique: _kHs0LayO4uj6OSt2HP73A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B44E1005504;
        Wed, 16 Dec 2020 12:37:26 +0000 (UTC)
Received: from [10.36.112.243] (ovpn-112-243.ams2.redhat.com [10.36.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 759265D9E8;
        Wed, 16 Dec 2020 12:37:23 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 08/10] arm/arm64: gic: Split check_acked()
 into two functions
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-9-alexandru.elisei@arm.com>
 <0eb98cb0-835c-e257-484e-8210f1279f2c@redhat.com>
 <2b8d774e-9398-e24b-6989-8643f5dd2492@arm.com>
 <b5ccedb2-5f8d-50d5-8caf-776013613d90@redhat.com>
 <a01f61cf-d174-87b7-4db1-32b62a2c3e8a@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <08ba32cf-0a6f-79d9-fb53-a84205cae4b1@redhat.com>
Date:   Wed, 16 Dec 2020 13:37:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a01f61cf-d174-87b7-4db1-32b62a2c3e8a@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 12/16/20 12:40 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 12/15/20 1:58 PM, Auger Eric wrote:
>> Hi Alexandru,
>>
>> On 12/10/20 3:45 PM, Alexandru Elisei wrote:
>>> Hi Eric,
>>>
>>> On 12/3/20 1:39 PM, Auger Eric wrote:
>>>> [..]
>>>>  
>>>>  static void check_spurious(void)
>>>> @@ -300,7 +318,8 @@ static void ipi_test_self(void)
>>>>  	cpumask_clear(&mask);
>>>>  	cpumask_set_cpu(smp_processor_id(), &mask);
>>>>  	gic->ipi.send_self();
>>>> -	check_acked("IPI: self", &mask);
>>>> +	wait_for_interrupts(&mask);
>>>> +	report(check_acked(&mask), "Interrupts received");
>>>>  	report_prefix_pop();
>>>>  }
>>>>  
>>>> @@ -315,7 +334,8 @@ static void ipi_test_smp(void)
>>>>  	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
>>>>  		cpumask_clear_cpu(i, &mask);
>>>>  	gic_ipi_send_mask(IPI_IRQ, &mask);
>>>> -	check_acked("IPI: directed", &mask);
>>>> +	wait_for_interrupts(&mask);
>>>> +	report(check_acked(&mask), "Interrupts received");
>>>> both ipi_test_smp and ipi_test_self are called from the same test so
>>>> better to use different error messages like it was done originally.
>>> I used the same error message because the tests have a different prefix
>>> ("target-list" versus "broadcast"). Do you think there are cases where that's not
>>> enough?
>> I think in "ipi" test,
>> ipi_test -> ipi_send -> ipi_test_self, ipi_test_smp
> 
> I'm afraid I don't understand what you are trying to say. This is the log for the
> gicv3-ipi test:
> 
> $ cat logs/gicv3-ipi.log
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine
> virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device
> virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none
> -serial stdio -kernel arm/gic.flat -smp 6 -machine gic-version=3 -append ipi #
> -initrd /tmp/tmp.trk6aAcaZx
> WARNING: early print support may not work. Found uart at 0x9000000, but early base
> is 0x3f8.
> PASS: gicv3: ipi: self: Interrupts received
> PASS: gicv3: ipi: target-list: Interrupts received
> PASS: gicv3: ipi: broadcast: Interrupts received
> SUMMARY: 3 tests
> 
> The warning is because I forgot to reconfigure the tests with --vmm=qemu.
> 
> Would you mind pointing out what you think is ambiguous?
Hum sorry I did not pay attention to the report_prefix_push() within
ipi_test_self & ipi_test_smp. I had in mind those were only in the main().

Forgive me for the noise

Eric
> 
> Thanks,
> 
> Alex
> 

