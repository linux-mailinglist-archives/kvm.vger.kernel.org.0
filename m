Return-Path: <kvm+bounces-43202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 248D7A8732C
	for <lists+kvm@lfdr.de>; Sun, 13 Apr 2025 20:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31A9517138A
	for <lists+kvm@lfdr.de>; Sun, 13 Apr 2025 18:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82EC81EEA59;
	Sun, 13 Apr 2025 18:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="wIbQiLy/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C17847B;
	Sun, 13 Apr 2025 18:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744569492; cv=none; b=AaPsfEaqteppq5Im/MrTLbdfykV5y1TWD3skCyHMsNqjSbk6gao2i6nqcrxuWt5WheL04kbiB1cKtXZyp8kFzo+aT9QlHtIJInAgiYtgZ2qflkqkAUXfQInKwSO+wku4xGVuImfXivpzXYQDFzKVMyf9wvQIOy4EM0LFbWvaY+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744569492; c=relaxed/simple;
	bh=Rhmbn/51EsShe6uS94S1wwlbS0ZaLyoM/GyyzVY1zsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UF2UQOynyoTQw0ALpr/3wXboJZoAnzZmbhJppMe7Y+dI7EEijIhnstlnvKKKCC+pPCxDfSUKsZFu+BflwRzcfK3he6cn1BHFknfwDWCMrI1m2FA/uQZs+WBFqqB2V2Kh6OmymtScactDRjMV4jlzwyd9+JFhg5hU37ZQN/MfGUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=wIbQiLy/; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1744569491; x=1776105491;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=F5c49yfmuNHsN2pLtZJi3IS+5nV8zSu8oBgy/REaRPo=;
  b=wIbQiLy/ZW54Gb2LPmC25aa/rsFLK+vghO73Uc/7Vx/zztACD78FDzb4
   Vh2UB+qYp9nvy+GiHgIv8dfmU6+k65PrIyNSl//DsL7XEFH4e1TNHKHMp
   JqUut1JCuI+7NkPEcNG2x61AzNpZ1zDLrecVFYcsNlJlqnTlvXzy9L46s
   Y=;
X-IronPort-AV: E=Sophos;i="6.15,210,1739836800"; 
   d="scan'208";a="480007860"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 18:38:08 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.7.35:51202]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.49.222:2525] with esmtp (Farcaster)
 id 3c58f807-b01f-4b3a-8a3a-252675e5282b; Sun, 13 Apr 2025 18:38:06 +0000 (UTC)
X-Farcaster-Flow-ID: 3c58f807-b01f-4b3a-8a3a-252675e5282b
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sun, 13 Apr 2025 18:38:04 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Sun, 13 Apr 2025
 18:38:02 +0000
Message-ID: <7eed0c3d-6a78-4724-b204-a3b99764d839@amazon.com>
Date: Sun, 13 Apr 2025 20:38:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/fair: Only increment deadline once on yield
To: Fernand Sieber <sieberf@amazon.com>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Vincent Guittot
	<vincent.guittot@linaro.org>, <linux-kernel@vger.kernel.org>,
	<nh-open-source@amazon.com>, kvm <kvm@vger.kernel.org>
References: <20250401123622.584018-1-sieberf@amazon.com>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20250401123622.584018-1-sieberf@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D044UWB001.ant.amazon.com (10.13.139.171) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)


On 01.04.25 14:36, Fernand Sieber wrote:
> If a task yields, the scheduler may decide to pick it again. The task in
> turn may decide to yield immediately or shortly after, leading to a tight
> loop of yields.
>
> If there's another runnable task as this point, the deadline will be
> increased by the slice at each loop. This can cause the deadline to runaway
> pretty quickly, and subsequent elevated run delays later on as the task
> doesn't get picked again. The reason the scheduler can pick the same task
> again and again despite its deadline increasing is because it may be the
> only eligible task at that point.
>
> Fix this by updating the deadline only to one slice ahead.
>
> Note, we might want to consider iterating on the implementation of yield as
> follow up:
> * the yielding task could be forfeiting its remaining slice by
>    incrementing its vruntime correspondingly
> * in case of yield_to the yielding task could be donating its remaining
>    slice to the target task
>
> Signed-off-by: Fernand Sieber <sieberf@amazon.com>


IMHO it's worth noting that this is not a theoretical issue. We have 
seen this in real life: A KVM virtual machine's vCPU which runs into a 
busy guest spin lock calls kvm_vcpu_yield_to() which eventually ends up 
in the yield_task_fair() function. We have seen such spin locks due to 
guest contention rather than host overcommit, which means we go into a 
loop of vCPU execution and spin loop exit, which results in an 
undesirable increase in the vCPU thread's deadline.

Given this impacts real workloads and is a bug present since the 
introduction of EEVDF, I would say it warrants a

Fixes: 147f3efaa24182 ("sched/fair: Implement an EEVDF-like scheduling 
policy")

tag.


Alex



