Return-Path: <kvm+bounces-32284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4209D5236
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AF851F22E05
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 17:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3861C303A;
	Thu, 21 Nov 2024 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="oxE8joED"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CED36CDAF;
	Thu, 21 Nov 2024 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732211964; cv=none; b=S8VeNOmsK14ITfCtUB6xDNfu5AMezOwt+FPyln3A4ohE/Is8hlbc/S6zgBWdQyogJShZ1UJJC818K39T06ffPW1OzXa3B0y/AuAVEuR6e/yZGDE4mVLEMcR44L4J4neH1684phoJHR7uHJRCJ6qBNWD+MqaDqRgdJryYpuLMgJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732211964; c=relaxed/simple;
	bh=zeFYhMICWHfr3eAXY+whaVGKw3m24BGN4aGc9t95zps=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FBQgLl160iRl4s4Qee5ypl3AlSxi7HDA46u2xNfl2RyJb/RBhqZ5whssV5wBnnFMVBSmIQ7bEQ9LmuuPo5wYkXb81uMBPF7ukBRGlRcrbQwqaH3nJl5LbB3R4HGMdJEY0riFDt212A+YQgy+axUkjJhRxC9lnk8eHpFSJPJYE60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=oxE8joED; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732211963; x=1763747963;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=Q6L+gDMY6SSVxys36wX+g9uo/y0GD3cJbqHoxBuTNeE=;
  b=oxE8joEDG58fGVYPIaBBZM7OJ9QEWi6GgX5y9fne1F/swwcf23mWE7JH
   WGuDa82vwV2mony3XScpfAal7MQy1HYxb8VMR8kb6WdyF6yTPstZYEuHz
   Cyaou0RW7loZubYCifYCDg3e1iSftVIbkgfHboCaiX9gkQFytjKb6QUHr
   E=;
X-IronPort-AV: E=Sophos;i="6.12,173,1728950400"; 
   d="scan'208";a="149683278"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 17:59:20 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:60036]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.207:2525] with esmtp (Farcaster)
 id c63636fb-6fa6-4115-94d2-2afc1b700741; Thu, 21 Nov 2024 17:59:19 +0000 (UTC)
X-Farcaster-Flow-ID: c63636fb-6fa6-4115-94d2-2afc1b700741
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 21 Nov 2024 17:59:18 +0000
Received: from [192.168.3.109] (10.106.83.32) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Thu, 21 Nov 2024
 17:59:17 +0000
Message-ID: <b6d32f47-9594-41b1-8024-a92cad07004e@amazon.com>
Date: Thu, 21 Nov 2024 17:59:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH] KVM: x86: async_pf: check earlier if can deliver async pf
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <david@redhat.com>,
	<peterx@redhat.com>, <oleg@redhat.com>, <vkuznets@redhat.com>,
	<gshan@redhat.com>, <graf@amazon.de>, <jgowans@amazon.com>,
	<roypat@amazon.co.uk>, <derekmn@amazon.com>, <nsaenz@amazon.es>,
	<xmarcalx@amazon.com>
References: <20241118130403.23184-1-kalyazin@amazon.com>
 <ZzyRcQmxA3SiEHXT@google.com>
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
In-Reply-To: <ZzyRcQmxA3SiEHXT@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D010EUA002.ant.amazon.com (10.252.50.108) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 19/11/2024 13:24, Sean Christopherson wrote:
>> This patch avoids the overhead above in case of kernel-originated faults
> 
> Please avoid "This patch".

Ack, thanks.

>> by moving the `kvm_can_deliver_async_pf` check from
>> `kvm_arch_async_page_not_present` to `__kvm_faultin_pfn`.
>>
>> Note that the existing check `kvm_can_do_async_pf` already calls
>> `kvm_can_deliver_async_pf` internally, however it only does that if the
>> `kvm_hlt_in_guest` check is true, ie userspace requested KVM not to exit
>> on guest halts via `KVM_CAP_X86_DISABLE_EXITS`.  In that case the code
>> proceeds with the async fault processing with the following
>> justification in 1dfdb45ec510ba27e366878f97484e9c9e728902 ("KVM: x86:
>> clean up conditions for asynchronous page fault handling"):
>>
>> "Even when asynchronous page fault is disabled, KVM does not want to pause
>> the host if a guest triggers a page fault; instead it will put it into
>> an artificial HLT state that allows running other host processes while
>> allowing interrupt delivery into the guest."
> 
> None of this justifies breaking host-side, non-paravirt async page faults.  If a
> vCPU hits a missing page, KVM can schedule out the vCPU and let something else
> run on the pCPU, or enter idle and let the SMT sibling get more cycles, or maybe
> even enter a low enough sleep state to let other cores turbo a wee bit.
> 
> I have no objection to disabling host async page faults, e.g. it's probably a net
> negative for 1:1 vCPU:pCPU pinned setups, but such disabling needs an opt-in from
> userspace.

That's a good point, I didn't think about it.  The async work would 
still need to execute somewhere in that case (or sleep in GUP until the 
page is available).  If processing the fault synchronously, the vCPU 
thread can also sleep in the same way freeing the pCPU for something 
else, so the amount of work to be done looks equivalent (please correct 
me otherwise).  What's the net gain of moving that to an async work in 
the host async fault case?  "while allowing interrupt delivery into the 
guest." -- is this the main advantage?

