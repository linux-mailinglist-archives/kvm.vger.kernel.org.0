Return-Path: <kvm+bounces-20906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EDC2926741
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 19:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A13C2832A2
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 17:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328321849EB;
	Wed,  3 Jul 2024 17:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="bUtwtLOZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E302183086
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 17:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720028106; cv=none; b=iz4fG7ycTxZDWJSZu7TQIJFgKkOK3Fi1q0qh49oDfyJk1NBMmEUmB5EeQZfrVZkMshSzn1lZcr4zi08juc+gho8GQEe03331tAcHs54+8Q454SIWBkhklo6F6LY/uPI2orNhHtOonApl0hM8fnK0OxfLUJ/tvSqtsnzwcCJcjWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720028106; c=relaxed/simple;
	bh=l06SvAx10y5w/WW2XMiTPjF51PJgC3s5dbBuT2H9W1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=B8aKNGxuf2iIs8U31AzmbgEjRHwq7zklO31nN6PXLdfIAK2RIPwfzrcLiWqNF/Q4us8RRTIY8+6PqWaFYjiGhZIICRD1Yj71TD4TFzV6KKc09dmvQOr2eQrl9fFnZfX1FzZvIo0e2Ll1TUUmhkjmXdgjGh3V4VkOyfmThppmBFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=bUtwtLOZ; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1720028105; x=1751564105;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=b9HAF+WS9MkSfOWQwYRmuQh0tn+3sT67Es33DhKyTRg=;
  b=bUtwtLOZsnMbs7XPx6/zsTXyui/G1xhE0+EbsRSsZy17vKekQN9Am9mF
   qwiS0TmUOy6+bqrXHYyW0le+91U+cjIU2sfIPlUbYo9ClSyKKsG4XziBe
   r5v8CyJWTDSMuvABG1x9aKQ6w+7OnGleh38Rv7PJ+//YM3tk42ErNOQ6d
   I=;
X-IronPort-AV: E=Sophos;i="6.09,182,1716249600"; 
   d="scan'208";a="643425421"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 17:35:02 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:28952]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.19.28:2525] with esmtp (Farcaster)
 id c1c9f286-5528-40e7-9d33-3101ee09a74d; Wed, 3 Jul 2024 17:35:00 +0000 (UTC)
X-Farcaster-Flow-ID: c1c9f286-5528-40e7-9d33-3101ee09a74d
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 3 Jul 2024 17:35:00 +0000
Received: from [192.168.6.66] (10.106.82.27) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Wed, 3 Jul 2024
 17:34:59 +0000
Message-ID: <923126dd-5f23-4f99-8327-9e8738540efb@amazon.com>
Date: Wed, 3 Jul 2024 18:34:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: David Matlack <dmatlack@google.com>
CC: Sean Christopherson <seanjc@google.com>, Anish Moorthy
	<amoorthy@google.com>, <maz@kernel.org>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <robert.hoo.linux@gmail.com>,
	<jthoughton@google.com>, <axelrasmussen@google.com>, <peterx@redhat.com>,
	<nadav.amit@gmail.com>, <isaku.yamahata@gmail.com>,
	<kconsul@linux.vnet.ibm.com>, Oliver Upton <oliver.upton@linux.dev>,
	<roypat@amazon.co.uk>, <kalyazin@amazon.com>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-7-amoorthy@google.com> <ZeuMEdQTFADDSFkX@google.com>
 <ZeuxaHlZzI4qnnFq@google.com> <Ze6Md/RF8Lbg38Rf@thinky-boi>
 <CALzav=cMrt8jhCKZSJL+76L=PUZLBH7D=Uo-5Cd1vBOoEja0Nw@mail.gmail.com>
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
In-Reply-To: <CALzav=cMrt8jhCKZSJL+76L=PUZLBH7D=Uo-5Cd1vBOoEja0Nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D009EUA002.ant.amazon.com (10.252.50.88) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

Hi David,

On 11/03/2024 16:20, David Matlack wrote:
> On Sun, Mar 10, 2024 at 9:46 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>>>>
>>>>    2. What is your best guess as to when KVM userfault patches will be available,
>>>>       even if only in RFC form?
>>>
>>> We're aiming for the end of April for RFC with KVM/ARM support.
>>
>> Just to make sure everyone is read in on what this entails -- is this
>> the implementation that only worries about vCPUs touching non-present
>> memory, leaving the question of other UAPIs that consume guest memory
>> (e.g. GIC/ITS table save/restore) up for further discussion?
> 
> Yes. The initial version will only support returning to userspace on
> invalid vCPU accesses with KVM_EXIT_MEMORY_FAULT. Non-vCPU accesses to
> invalid pages (e.g. GIC/ITS table save/restore) will trigger an error
> return from __gfn_to_hva_many() (which will cause the corresponding
> ioctl to fail). It will be userspace's responsibility to clear the
> invalid attribute before invoking those ioctls.
> 
> For x86 we may need an blocking kernel-to-userspace notification
> mechanism for code paths in the emulator, but we'd like to investigate
> and discuss if there are any other cleaner alternatives before going
> too far down that route.

I wasn't able to locate any follow-ups on the LKML about this topic.
May I know if you are still working on or planning to work on this?

Thanks,
Nikita

