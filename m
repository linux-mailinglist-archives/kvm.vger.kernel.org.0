Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD3F678CAA
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 01:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjAXAN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 19:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjAXANz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 19:13:55 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D012E3928F
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 16:13:50 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pK6wd-00FWWh-09; Tue, 24 Jan 2023 01:13:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=hy8GiN7oR1zrZLDXK5pB2M+tlz4dOiv+/O6aK97woPk=; b=o20UtirM2NAVmZiZEEsSn+llFv
        CwmYe0sXNAjuNI+gcju+GLz4oUlEl8opf1T2uQAUru2/QoYjlflWvM2/JgyvYHtdRdAxKEDuoIDQO
        ugD3NAht8+xnfq5vzOoUnQyCyzbilyeEQqzVlbb6enRawT5sT+HKd1PPFGNAs9MYG9z1P332L/ObO
        jtV4tqtomQKhM47fnJYc2vLOF70d7WaFp1NAKPyzQIb8vlvWGQxkf3z3FnQq2+EyKxJDSDn33rz0H
        qAEpsCGkp+OwwIZdVhJAYxF39/I85iC58ZEsC/d5Jh4fpszzbzrpmuD9dciihb/UxkJLThz0vH8Pr
        O3IXMu9Q==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pK6wc-0005pZ-He; Tue, 24 Jan 2023 01:13:46 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pK6wI-0008G3-It; Tue, 24 Jan 2023 01:13:26 +0100
Message-ID: <bb2307fb-298f-c290-a6c9-6861016a6689@rbox.co>
Date:   Tue, 24 Jan 2023 01:13:25 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH] Revert "KVM: mmio: Fix use-after-free Read in
 kvm_vm_ioctl_unregister_coalesced_mmio"
Content-Language: en-GB, pl-PL, en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20230118220003.1239032-1-mhal@rbox.co>
 <Y88S2F2laAvqmj+E@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <Y88S2F2laAvqmj+E@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/23 00:06, Sean Christopherson wrote:
> On Wed, Jan 18, 2023, Michal Luczaj wrote:
>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>> ---
>>  virt/kvm/coalesced_mmio.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
>> index 0be80c213f7f..f08f5e82460b 100644
>> --- a/virt/kvm/coalesced_mmio.c
>> +++ b/virt/kvm/coalesced_mmio.c
>> @@ -186,6 +186,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
>>  		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
>>  			r = kvm_io_bus_unregister_dev(kvm,
>>  				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
>> +			kvm_iodevice_destructor(&dev->dev);
>>  
>>  			/*
>>  			 * On failure, unregister destroys all devices on the
>> @@ -195,7 +196,6 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
>>  			 */
>>  			if (r)
>>  				break;
>> -			kvm_iodevice_destructor(&dev->dev);
> 
> Already posted[1], but didn't get queued because there's alternative solution[2]
> that yields a far cleaner end result, albeit with a larger patch.  I'll follow
> up on Wei's patch to move things along.
> 
> [1] https://lore.kernel.org/all/20221219171924.67989-1-seanjc@google.com
> [2] https://lore.kernel.org/all/20221229123302.4083-1-wei.w.wang@intel.com

I apologise for the noise, I should have searched the archives before posting.

Michal


