Return-Path: <kvm+bounces-22156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 181C993AFD0
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 12:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C66082846D5
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 10:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD36C15539D;
	Wed, 24 Jul 2024 10:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="s8bgX1K0"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F5814375C;
	Wed, 24 Jul 2024 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721816744; cv=none; b=B2soGzEsVPzYf7NPqcFl1T0VYMNw+/u5OazKdGHGgCW9GWxP1hfJzxjGBKwWKaHlsERYtwy3nQjum61eRz+NeEB3eTt++njSeAyTnJrGA4isP6I2eM3kZlz5HSSsCcsaAHHqPJKJJMzbQkTTeF2VFqWVwirqKYBu+rFURLQhzUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721816744; c=relaxed/simple;
	bh=IVjBVdWJcrqSz10WzYP3ysEDJe39sb453y3B4S/OD/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QZ2GaBGwH208FbqZJxKpHxg7xGHwq2wBjRPHTgL6hAqpX/Ptatt1Nkffd8mfCCGc1kaa/b41ut3B6n6AncCwJ8BdEE6WrFXSOkvjPkGkKW8ub+j1XDdTAxa9qppe0HKLpANXrrTuioLQP+I2Zia1ZffHJ4jt5CKJKqxGdpkYNTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=s8bgX1K0; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:25b4:0:640:ef96:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id B406C60FE3;
	Wed, 24 Jul 2024 13:23:48 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b642::1:29] (unknown [2a02:6b8:b081:b642::1:29])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id lNMY9V1iCqM0-C8C8MaGq;
	Wed, 24 Jul 2024 13:23:47 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1721816627;
	bh=uLe2eSdIXUPHH+Ti8xQ5MBEVFgfu1ifI92FSUfg2UF8=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=s8bgX1K0A18G0fytEtLiX6wqJxTc8HxUX4WcqKbNMVsHwWw01VTiit/vkhrbGORb3
	 SqBnXDc1fxVPCRuqLigoEuPoqPs4uFM5tm3CQiZf2hxYG9o2XShIY5BRMzBUfTHNWC
	 wsYg+N+nVbS5jB0HFptt952+9erbgGRaRfhIUQpQ=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <ea0d1256-1236-4102-80fd-e0c05503c2fd@yandex-team.ru>
Date: Wed, 24 Jul 2024 13:23:47 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm_host: bump KVM_MAX_IRQ_ROUTE to 128k
To: Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, yc-core@yandex-team.ru,
 Sean Christopherson <seanjc@google.com>
References: <20240321082442.195631-1-d-tatianin@yandex-team.ru>
 <20240618142846.4138b349@imammedo.users.ipa.redhat.com>
Content-Language: en-US
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <20240618142846.4138b349@imammedo.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/24 3:28 PM, Igor Mammedov wrote:

> On Thu, 21 Mar 2024 11:24:42 +0300
> Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:
>
>> We would like to be able to create large VMs (up to 224 vCPUs atm) with
>> up to 128 virtio-net cards, where each card needs a TX+RX queue per vCPU
>> for optimal performance (as well as config & control interrupts per
>> card). Adding in extra virtio-blk controllers with a queue per vCPU (up
>> to 192 disks) yields a total of about ~100k IRQ routes, rounded up to
>> 128k for extra headroom and flexibility.
>>
>> The current limit of 4096 was set in 2018 and is too low for modern
>> demands. It also seems to be there for no good reason as routes are
>> allocated lazily by the kernel anyway (depending on the largest GSI
>> requested by the VM).
>>
>> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> LGTM
>
> Acked-by: Igor Mammedov <imammedo@redhat.com>

Thank you!

I want to ping everyone once again to take a look at this, I think this 
patch is quite trivial and unlocks larger VMs for free, would really 
appreciate a review from anyone interested!

>> ---
>>   include/linux/kvm_host.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 48f31dcd318a..10a141add2a8 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -2093,7 +2093,7 @@ static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
>>   
>>   #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
>>   
>> -#define KVM_MAX_IRQ_ROUTES 4096 /* might need extension/rework in the future */
>> +#define KVM_MAX_IRQ_ROUTES 131072 /* might need extension/rework in the future */
>>   
>>   bool kvm_arch_can_set_irq_routing(struct kvm *kvm);
>>   int kvm_set_irq_routing(struct kvm *kvm,

