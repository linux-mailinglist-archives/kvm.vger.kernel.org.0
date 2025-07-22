Return-Path: <kvm+bounces-53118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D97B0D8CD
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:03:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 044B27A5B0B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 12:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9F42E3B0F;
	Tue, 22 Jul 2025 12:02:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AAA238D5A;
	Tue, 22 Jul 2025 12:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753185773; cv=none; b=hg4l/LhBCojWQWFNRkUB0jgxzvK77LzQXWpjU7u+qf9HnWqckNfTSP3V62VZCjFCBgxYBKgYVmClLH1njarbfwjGCuVCig21mEkdMONFMYHH79zrxHPtYVuKq/RuwTL8jvXO4V8p5PBnHbfonC9YwVTb5B1Ip+5A7//RQ/w70Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753185773; c=relaxed/simple;
	bh=tS+oyFiKULziXi6kE9tTCrN/rFgvZ1uqe7kGi9KMqQ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BNCLUBClu+4TQPhpM2VAiINZADVSuPl9AXweT0V+XdhFLvDfbyTFoj7xtxugo2c9ZmVn1BihAEsosI/wxmIiBImVQBO8nKbNBAt/23tbEl9cPlgTNZmH6tlPd/kJ62P8BgIVyj6yiiId6Dlnac1KHY5iDviqVUPBZUJoWUoZ8E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bmbRn5c4Rz1R8gj;
	Tue, 22 Jul 2025 20:00:05 +0800 (CST)
Received: from dggpemf100009.china.huawei.com (unknown [7.185.36.128])
	by mail.maildlp.com (Postfix) with ESMTPS id D970E140118;
	Tue, 22 Jul 2025 20:02:45 +0800 (CST)
Received: from huawei.com (10.67.175.29) by dggpemf100009.china.huawei.com
 (7.185.36.128) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 22 Jul
 2025 20:02:45 +0800
From: Wang Tao <wangtao554@huawei.com>
To: <graf@amazon.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
	<nh-open-source@amazon.com>, <peterz@infradead.org>, <sieberf@amazon.com>,
	<vincent.guittot@linaro.org>, <tanghui20@huawei.com>
Subject: [PATCH] Re: [PATCH] sched/fair: Only increment deadline once on yield
Date: Tue, 22 Jul 2025 11:46:54 +0000
Message-ID: <20250722114654.2620626-1-wangtao554@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <7eed0c3d-6a78-4724-b204-a3b99764d839@amazon.com>
References: <7eed0c3d-6a78-4724-b204-a3b99764d839@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100009.china.huawei.com (7.185.36.128)

>> On 01/04/25 18:06, Fernand Sieber wrote:
>> If a task yields, the scheduler may decide to pick it again. The task in
>> turn may decide to yield immediately or shortly after, leading to a tight
>> loop of yields.
>>
>> If there's another runnable task as this point, the deadline will be
>> increased by the slice at each loop. This can cause the deadline to runaway
>> pretty quickly, and subsequent elevated run delays later on as the task
>> doesn't get picked again. The reason the scheduler can pick the same task
>> again and again despite its deadline increasing is because it may be the
>> only eligible task at that point.
>>
>> Fix this by updating the deadline only to one slice ahead.
>>
>> Note, we might want to consider iterating on the implementation of yield as
>> follow up:
>> * the yielding task could be forfeiting its remaining slice by
>>    incrementing its vruntime correspondingly
>> * in case of yield_to the yielding task could be donating its remaining
>>    slice to the target task
>>
>> Signed-off-by: Fernand Sieber <sieberf@amazon.com>


>IMHO it's worth noting that this is not a theoretical issue. We have 
>seen this in real life: A KVM virtual machine's vCPU which runs into a 
>busy guest spin lock calls kvm_vcpu_yield_to() which eventually ends up 
>in the yield_task_fair() function. We have seen such spin locks due to 
>guest contention rather than host overcommit, which means we go into a 
>loop of vCPU execution and spin loop exit, which results in an 
>undesirable increase in the vCPU thread's deadline.

>Given this impacts real workloads and is a bug present since the 
>introduction of EEVDF, I would say it warrants a

>Fixes: 147f3efaa24182 ("sched/fair: Implement an EEVDF-like scheduling 
>policy")

>tag.


>Alex

Actually, as Alex described, we encountered the same issue in this 
testing scenario: starting qemu, binding cores to the cpuset group, 
setting cpuset.cpus=1-3 for stress testing in qemu, 
running taskset -c 1-3 ./stress-ng -c 20, and then encountering an error where qemu freezes, 
reporting a soft lockup issue in qemu. After applying this patch, the problem was resolved.
Do we have plans to merge this patch into the mainline?

