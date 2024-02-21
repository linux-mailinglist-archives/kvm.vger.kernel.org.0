Return-Path: <kvm+bounces-9253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE5E85CF6F
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 06:11:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C58EAB220CC
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 05:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310BB39AC9;
	Wed, 21 Feb 2024 05:11:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C49339AEA;
	Wed, 21 Feb 2024 05:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708492270; cv=none; b=aOra4cCuLyL1+Qzn2klzvGDSgX2dKd6YF2LQ1OOaf2fhvtXi36Xiv/iQ/FhzEFRhCz6cgDsJTh6/l2nbLOlVBnspO2Eff+YJh2jjlylZlC9kcXTnDLB2ixvDb+LnPyHRlIxhuAJBW1Q7nV5ODzWRhsADSehgTvZJ6cLs71+GbRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708492270; c=relaxed/simple;
	bh=C8vIAvgGnmc3tyaLFs7slFsNmar/kQJlvJ3tLWIOELA=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ssmqIG+xG4L9EPQJ+GBXgGc0WURc2iv6Pmuz6xGh6KpivmS9KPEk5Em0p+bE5F2lgnPWk+nTNvUn3iXGPD6f+zeE4UtSdrLnetvR6fyycqUmMNB385FM4EKtK2k0YE5iUCDev0qHfu3iaGzhd2P4nlrW34Fv+M+uxCCIDSoyMFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Tfknz6g6Xz2Bd0f;
	Wed, 21 Feb 2024 13:08:55 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 9233C18005F;
	Wed, 21 Feb 2024 13:11:04 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 21 Feb 2024 13:11:03 +0800
Subject: Re: [PATCH v3 01/10] KVM: arm64: vgic: Store LPIs in an xarray
To: Oliver Upton <oliver.upton@linux.dev>
CC: Zenghui Yu <zenghui.yu@linux.dev>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	<linux-kernel@vger.kernel.org>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
 <20240216184153.2714504-2-oliver.upton@linux.dev>
 <f6a4587c-1db1-d477-5e6c-93dd603a11ec@linux.dev> <ZdTeScN3XCgtRDJ9@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8c3e4679-08e7-c2bd-2fa4-c6851d080208@huawei.com>
Date: Wed, 21 Feb 2024 13:11:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZdTeScN3XCgtRDJ9@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/2/21 1:15, Oliver Upton wrote:
> Hi Zenghui,
> 
> On Wed, Feb 21, 2024 at 12:30:24AM +0800, Zenghui Yu wrote:
>> On 2024/2/17 02:41, Oliver Upton wrote:
>>> Using a linked-list for LPIs is less than ideal as it of course requires
>>> iterative searches to find a particular entry. An xarray is a better
>>> data structure for this use case, as it provides faster searches and can
>>> still handle a potentially sparse range of INTID allocations.
>>>
>>> Start by storing LPIs in an xarray, punting usage of the xarray to a
>>> subsequent change.
>>>
>>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>>
>> [..]
>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
>>> index db2a95762b1b..c126014f8395 100644
>>> --- a/arch/arm64/kvm/vgic/vgic.c
>>> +++ b/arch/arm64/kvm/vgic/vgic.c
>>> @@ -131,6 +131,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
>>>  		return;
>>>  	list_del(&irq->lpi_list);
>>> +	xa_erase(&dist->lpi_xa, irq->intid);
>>
>> We can get here *after* grabbing the vgic_cpu->ap_list_lock (e.g.,
>> vgic_flush_pending_lpis()/vgic_put_irq()).  And as according to vGIC's
>> "Locking order", we should disable interrupts before taking the xa_lock
>> in xa_erase() and we would otherwise see bad things like deadlock..
> 
> Nice catch!
> 
> Yeah, the general intention was to disable interrupts outside of the
> xa_lock, however:
> 
>> It's not a problem before patch #10, where we drop the lpi_list_lock and
>> start taking the xa_lock with interrupts enabled.  Consider switching to
>> use xa_erase_irq() instead?
> 
> I don't think this change is safe until #10, as the implied xa_unlock_irq()
> would re-enable interrupts before the lpi_list_lock is dropped. Or do I
> have wires crossed?

No, you're right.  My intention was to fix it in patch #10.  And as
you've both pointed out, using xa_erase_irq() can hardly be the correct
fix.  My mistake :-( .

Thanks,
Zenghui

