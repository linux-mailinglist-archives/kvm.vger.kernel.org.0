Return-Path: <kvm+bounces-69659-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id JTdcD8MSfGnKKQIAu9opvQ
	(envelope-from <kvm+bounces-69659-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 03:09:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD4CB6554
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 03:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6FD8A3015A79
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA1F2F99AE;
	Fri, 30 Jan 2026 02:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="oj0iGDIl"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E5D2F99AD;
	Fri, 30 Jan 2026 02:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769738942; cv=none; b=dokp9d9mL8Dj8UzyQK5kik2TtGIh064qYNdUUsKdv2yWwaAbbFL0nwk73rIx39MPplfjxYsBrggUEcmCjRePUYWHT80XsVcV7hM6uDZdW8LILhzdiOfUyvcK0R7oOrL3YKH1v0mWdvehToXnSKjAKKGh9W7Vf9CdjEPAiY8APMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769738942; c=relaxed/simple;
	bh=eNR3dlkM20OXY/NLi2qNejPzh50lP6q5PUsEa5vxR60=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ngn3qGpSJpMF5NvX7v1pIDOyOtp+fu2Qe6rAqrh1RMkxHi7dWD5iS8ISEWRCT2S2hlXsT4yNhd+gl4pyXEKPLMgWafRmESUR8UqNpKOY3wophTiGbqAXrkkq5h63xm1yuZZBly2kF2YVHVETL7Sx8Olm/T5q+lqWmy6WttRGuT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=oj0iGDIl; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=r+NnU37zpY7mRJqgmV0bJ7J9CUYtUAo/e4Pr26bdsD8=;
	b=oj0iGDIlLELfYIGGFq3RSHXXmTvI57nL3myK02SW5mYg74UgmH/qaNRVnJH68KBdE9AxTQZOi
	3EK/+NWCXGs97tmSHtUCR1IkMUqKvVI62Z3Z6p9StvJlyQyqHw2j8+fkhJ16InUhNnbIRb3GNl8
	JuxuPfBAZLj3yta91lXmoMo=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4f2K9169vPz1prLC;
	Fri, 30 Jan 2026 10:05:25 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id BF0CD40569;
	Fri, 30 Jan 2026 10:08:56 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 30 Jan 2026 10:08:56 +0800
Subject: Re: [PATCH v2 0/4] bugfix some issues under abnormal scenarios.
To: Alex Williamson <alex@shazbot.org>
CC: <jgg@nvidia.com>, <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20260122020205.2884497-1-liulongfang@huawei.com>
 <20260129145840.1d49a38e@shazbot.org>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <9ed3d41a-ade1-b5f0-1942-609a14bd55ed@huawei.com>
Date: Fri, 30 Jan 2026 10:08:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260129145840.1d49a38e@shazbot.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[huawei.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69659-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[huawei.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liulongfang@huawei.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,huawei.com:dkim,huawei.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CBD4CB6554
X-Rspamd-Action: no action

On 2026/1/30 5:58, Alex Williamson wrote:
> On Thu, 22 Jan 2026 10:02:01 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> In certain reset scenarios, repeated migration scenarios, and error injection
>> scenarios, it is essential to ensure that the device driver functions properly.
>> Issues arising in these scenarios need to be addressed and fixed
>>
>> Change v1 -> v2
>> 	Fix the reset state handling issue
>>
>> Longfang Liu (3):
>>   hisi_acc_vfio_pci: update status after RAS error
>>   hisi_acc_vfio_pci: resolve duplicate migration states
>>   hisi_acc_vfio_pci: fix the queue parameter anomaly issue
>>
>> Weili Qian (1):
>>   hisi_acc_vfio_pci: fix VF reset timeout issue
>>
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 30 +++++++++++++++++--
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  2 ++
>>  2 files changed, 29 insertions(+), 3 deletions(-)
>>
> 
> Applied to vfio next branch for v6.20/v7.0.  Thanks,
> 
> Alex
> .
> 

Thanks.
Longfang

