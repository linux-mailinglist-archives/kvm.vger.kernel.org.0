Return-Path: <kvm+bounces-52284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1147B03B28
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAAAD172184
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E247A246760;
	Mon, 14 Jul 2025 09:42:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F269A2459DC;
	Mon, 14 Jul 2025 09:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752486136; cv=none; b=jqW7e/y0bXdT6L5nbrYa3BCyRKCQ/jXgP++wzHW5jpTt552wtmNb6sMqVJQbgy/27ozVsP2iqwEjkwVNDzK12k3+FYZNIwCIbDx0pGGi8gwdwmh28pt6z1t76L6q335RVtrhRb0l1HspkXuGd04a84mOanP2eoUJcKmVYaO8LFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752486136; c=relaxed/simple;
	bh=NtkYmkh+MWKkc3tiz4++RahH7N+j3NrwtINdVItqgGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jrPYGH+Q+WFJ+3X8gJNhe+JxtTGPJ/T0jCjrM+gNbxVLrA+SbWhdUj+GMw+6RfU8gg0ZTvLJlPLuwL9Nn1tHnhZP5ncOl4SniQ9ql/ZlbE268vF106HUiTWDlpu4jvwFteDkHsSP7PijRsuo9IMAEdkGe2iwABCS3mkY68Bh7hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bgcnS34D0z2YPrJ;
	Mon, 14 Jul 2025 17:43:08 +0800 (CST)
Received: from kwepemo200008.china.huawei.com (unknown [7.202.195.61])
	by mail.maildlp.com (Postfix) with ESMTPS id C6F441400FD;
	Mon, 14 Jul 2025 17:42:09 +0800 (CST)
Received: from [10.67.110.83] (10.67.110.83) by kwepemo200008.china.huawei.com
 (7.202.195.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 14 Jul
 2025 17:42:09 +0800
Message-ID: <10baccb6-f00e-4911-a3ec-8d28aec67b13@huawei.com>
Date: Mon, 14 Jul 2025 17:42:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5.10] vhost-scsi: protect vq->log_used with vq->mutex
To: Greg KH <gregkh@linuxfoundation.org>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <pbonzini@redhat.com>,
	<stefanha@redhat.com>, <virtualization@lists.linux-foundation.org>,
	<kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20250702082945.4164475-1-zhengxinyu6@huawei.com>
 <2025071002-festive-outcast-7edd@gregkh>
From: "zhengxinyu (E)" <zhengxinyu6@huawei.com>
In-Reply-To: <2025071002-festive-outcast-7edd@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemo200008.china.huawei.com (7.202.195.61)



On 7/10/2025 9:41 PM, Greg KH wrote:
> On Wed, Jul 02, 2025 at 08:29:45AM +0000, Xinyu Zheng wrote:
>> From: Dongli Zhang <dongli.zhang@oracle.com>
>>
>> [ Upstream commit f591cf9fce724e5075cc67488c43c6e39e8cbe27 ]
>>
>> The vhost-scsi completion path may access vq->log_base when vq->log_used is
>> already set to false.
>>
>>      vhost-thread                       QEMU-thread
>>
>> vhost_scsi_complete_cmd_work()
>> -> vhost_add_used()
>>     -> vhost_add_used_n()
>>        if (unlikely(vq->log_used))
>>                                        QEMU disables vq->log_used
>>                                        via VHOST_SET_VRING_ADDR.
>>                                        mutex_lock(&vq->mutex);
>>                                        vq->log_used = false now!
>>                                        mutex_unlock(&vq->mutex);
>>
>> 				      QEMU gfree(vq->log_base)
>>          log_used()
>>          -> log_write(vq->log_base)
>>
>> Assuming the VMM is QEMU. The vq->log_base is from QEMU userpace and can be
>> reclaimed via gfree(). As a result, this causes invalid memory writes to
>> QEMU userspace.
>>
>> The control queue path has the same issue.
>>
>> CVE-2025-38074
> 
> This is not needed.
> 
>> Cc: stable@vger.kernel.org#5.10.x
> 
> What about 5.15.y and 6.1.y?  We can't take a patch just for 5.10 as
> that would cause regressions, right?
> 
> Please provide all relevant backports and I will be glad to queue them
> up then.  I'll drop this from my queue for now, thanks.
> 
> greg k-h

Sorry for forgetting the 5.15.y and 6.1.y patches. I will resend it as 
soon as possible. Thanks for pointing out my patch format error.

Xinyu Zheng


