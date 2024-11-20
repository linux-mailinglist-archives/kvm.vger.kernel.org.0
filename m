Return-Path: <kvm+bounces-32198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFB269D4150
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CC1A1F22976
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59DDE1AB6F8;
	Wed, 20 Nov 2024 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="si/5NTgs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5688146593;
	Wed, 20 Nov 2024 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732124500; cv=none; b=MrVNvWh1nr155BZcO7tNyaW2bbrdr38CeVSlAuGGkRcKsTZsoDAmx0Ap7o0OimaZB+A2VibKkLJj7YVKN5S21kQyjfQGaDU7Wc8BuYC7E6J6Yg7a5co1FLmekjSITuSE2ZSphLN3diGWBUCAgGbKWFkb2P8Eu2j0UVRzSGhSurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732124500; c=relaxed/simple;
	bh=77l5BUdA3wUh+Ds92rI4XZsS4TQVkqTZf3ifB+JsiZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JSH+UBx8ijlsYDb6y7YMUBDJ0+Iu8PxWrROZrYiy8jJm0o1mRI53kRBUQAmGt1bQ8m+GcqMLFM+0Agm1xSc2AwT9IKe5EFaRu5gLp263Uves7IqXrwdLKdK1x0HteUdAefzK8LeiisinCEwUFJYg9+Ml5CmQqiMUl2hhmSDErpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=si/5NTgs; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732124499; x=1763660499;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=dMxU76y/coq4MPw428ZOn69UQJ/3wc1UFFgfd5jLDwU=;
  b=si/5NTgs7XV7aY21yqdGmgLYq4FVJuQNyE81zKwp2/1F/SvamY2cLBhg
   pcR6qJn7M2797HxaGMHikbFvEyMQlcfj7uWuSnaiHJT/NVF4XuncIIwfc
   qWx6sXtW5wNb2P/Uc+desJJq8PRfgYal10aHU2kR/VAm/6rR1n1g63vnp
   k=;
X-IronPort-AV: E=Sophos;i="6.12,170,1728950400"; 
   d="scan'208";a="675210391"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 17:41:36 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:29938]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.84:2525] with esmtp (Farcaster)
 id afdc4bc4-bba2-498f-afae-82f05c096ff1; Wed, 20 Nov 2024 17:41:34 +0000 (UTC)
X-Farcaster-Flow-ID: afdc4bc4-bba2-498f-afae-82f05c096ff1
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 20 Nov 2024 17:41:34 +0000
Received: from [192.168.4.239] (10.106.82.23) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Wed, 20 Nov 2024
 17:41:33 +0000
Message-ID: <acdfa273-5da0-48dd-b506-e1064eea2726@amazon.com>
Date: Wed, 20 Nov 2024 17:41:31 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 0/4] KVM: ioctl for populating guest_memfd
To: Paolo Bonzini <pbonzini@redhat.com>, <corbet@lwn.net>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <brijesh.singh@amd.com>, <michael.roth@amd.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>
References: <20241024095429.54052-1-kalyazin@amazon.com>
 <86811253-a310-4474-8d0a-dad453630a2d@redhat.com>
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
In-Reply-To: <86811253-a310-4474-8d0a-dad453630a2d@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D005EUA002.ant.amazon.com (10.252.50.11) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 20/11/2024 13:55, Paolo Bonzini wrote:
>> Patch 4 allows to call the ioctl from a separate (non-VMM) process.  It
>> has been prohibited by [3], but I have not been able to locate the exact
>> justification for the requirement.
> 
> The justification is that the "struct kvm" has a long-lived tie to a
> host process's address space.
> 
> Invoking ioctls like KVM_SET_USER_MEMORY_REGION and KVM_RUN from
> different processes would make things very messy, because it is not
> clear which mm you are working with: the MMU notifier is registered for
> kvm->mm, but some functions such as get_user_pages do not take an mm for
> example and always operate on current->mm.

That's fair, thanks for the explanation.

> In your case, it should be enough to add a ioctl on the guestmemfd
> instead?

That's right. That would be sufficient indeed.  Is that something that 
could be considered?  Would that be some non-KVM API, with guest_memfd 
moving to an mm library?

 > But the real question is, what are you using
 > KVM_X86_SW_PROTECTED_VM for?

The concrete use case is VM restoration from a snapshot in Firecracker 
[1].  In the current setup, the VMM registers a UFFD against the guest 
memory and sends the UFFD handle to an external process that knows how 
to obtain the snapshotted memory.  We would like to preserve the 
semantics, but also remove the guest memory from the direct map [2]. 
Mimicing this with guest_memfd would be sending some form of a 
guest_memfd handle to that process that would be using it to populate 
guest_memfd.

[1]: 
https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/handling-page-faults-on-snapshot-resume.md#userfaultfd
[2]: 
https://lore.kernel.org/kvm/20241030134912.515725-1-roypat@amazon.co.uk/T/

> Paolo

