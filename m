Return-Path: <kvm+bounces-32419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B28D9D84C9
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:49:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EB3528A445
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A7D19D886;
	Mon, 25 Nov 2024 11:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="NNmzjnNl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3899199EA8;
	Mon, 25 Nov 2024 11:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535209; cv=none; b=Faa2CycDtHw6r9/Zvy5h0u2wur/4aMJ/9CG2+2ymOflrJ90Ug4+k4uSaDEOOPLlvbBOrueuWbmA8GJTSgTGZHTfhtJsR/CRb5FUnQi9k7xjw6XJs8jlaTORZZcGeaE1mEKiuhjQ05PihS/gNjAm4Aw0wt3jYUbsLO9Rk+nxqL0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535209; c=relaxed/simple;
	bh=FHKaVj40hVdUie0T9IjlT4qkPmKzDnnfQy/AYHnP1aU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GGvKDhAJHaW4M4IEow67q+zegbkMKvZO0/U8Oprrsm33mYihXkYj1bm34Li+yzTRipFRvNAlfnAqjogl4PQYWYigCd7ADZ3F2E/Ffi1RHqwNhyCmL70Lq+GFH0W8Khi9Op0Xh+f4aGC8tOVwHNukWCawgPt/CZ6rKEUPkIJB5W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=NNmzjnNl; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732535208; x=1764071208;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=0p7Ckz6iXzDpwC1O2xBQwIygdPDI7wUUkWYzZKFW0BE=;
  b=NNmzjnNlZlnD+gJWf51Uu2am4QYnK4kfAJ67MiV2xgsCNZtTMsJ32x/b
   COuUuJeXiu0phSVrjAZx6UEgIp1jj4PG94baPwCTYEJxs/q2+e+uANonb
   ws+OeUufxK6jkA28Wq35yhca/PeJe26YKO7X9DO5SiMZksGgFyY7CawR8
   4=;
X-IronPort-AV: E=Sophos;i="6.12,182,1728950400"; 
   d="scan'208";a="698062018"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 11:46:44 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:63339]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.206:2525] with esmtp (Farcaster)
 id 40ec0b3e-9f12-4258-be54-cdb388d9fb84; Mon, 25 Nov 2024 11:46:43 +0000 (UTC)
X-Farcaster-Flow-ID: 40ec0b3e-9f12-4258-be54-cdb388d9fb84
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 25 Nov 2024 11:46:41 +0000
Received: from [192.168.8.103] (10.106.83.30) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Mon, 25 Nov 2024
 11:46:40 +0000
Message-ID: <a8d78402-6f8d-4ebf-ae8b-1a8f03d33647@amazon.com>
Date: Mon, 25 Nov 2024 11:46:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH 1/4] KVM: guest_memfd: add generic post_populate callback
To: <michael.day@amd.com>, <pbonzini@redhat.com>, <corbet@lwn.net>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <brijesh.singh@amd.com>, <michael.roth@amd.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>
References: <20241024095429.54052-1-kalyazin@amazon.com>
 <20241024095429.54052-2-kalyazin@amazon.com>
 <589ccb59-ae79-49db-8017-f6d28d7f6982@amd.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJj5ki9BQkDwmcAAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOR1wD/UTcn4GbLC39QIwJuWXW0DeLoikxFBYkbhYyZ5CbtrtAA/2/rnR/zKZmyXqJ6
 ULlSE8eWA3ywAIOH8jIETF2fCaUCzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmPmSL0FCQPCZwACGwwACgkQr5LKIKmaZPNCxAEAxwnrmyqSC63nf6hoCFCfJYQapghC
 abLV0+PWemntlwEA/RYx8qCWD6zOEn4eYhQAucEwtg6h1PBbeGK94khVMooF
In-Reply-To: <589ccb59-ae79-49db-8017-f6d28d7f6982@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D005EUA002.ant.amazon.com (10.252.50.11) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

On 22/11/2024 18:40, Mike Day wrote:
> On 10/24/24 04:54, Nikita Kalyazin wrote:
>> This adds a generic implementation of the `post_populate` callback for
>> the `kvm_gmem_populate`.  The only thing it does is populates the pages
>> with data provided by userspace if the user pointer is not NULL,
>> otherwise it clears the pages.
>> This is supposed to be used by KVM_X86_SW_PROTECTED_VM VMs.
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   virt/kvm/guest_memfd.c | 21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 8f079a61a56d..954312fac462 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -620,6 +620,27 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct 
>> kvm_memory_slot *slot,
>>   EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>>
>>   #ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> 
> KVM_AMD_SEV can select KVM_GENERIC_PRIVATE_MEM, so to guarantee this is 
> only for
> software protection it might be good to use:
> 
> #if defined CONFIG_KVM_GENERIC_PRIVATE_MEM && !defined CONFIG_KVM_AMD_SEV
> 
> That could end up too verbose so there should probably be some more 
> concise mechanism
> to guarantee this generic callback isn't used for a hardware-protected 
> guest.

Thanks, will make a note for myself for the next iteration.

> 
> Mike


