Return-Path: <kvm+bounces-27679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAFB098A50B
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 15:29:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E2101F237EC
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 13:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2982118FDAB;
	Mon, 30 Sep 2024 13:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="JoRfMGd4"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2ED13D539
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 13:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727702939; cv=none; b=ah4SVmrpdMKMzrbiVOOSfyxm07rr2tI3x/dHDrVkLSuzQof4+hrvcZ+iD6QjS8nHGZhZtEV6wAU00+nRi8tqL/StZT6HNZWVZunOPgKn+MOQl+qGAqgDUkPAEifEjVT27uJc9H18zkh2Ip2qODsTs/WARDZUg+n59z6fwGL/FmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727702939; c=relaxed/simple;
	bh=YDS/3UZwR1ehX6Ocx0NHBBIc9d5xj5WSO8LI/JfTi30=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=HKHjWA33y0Sj2KaDPMwukxqxf5EXyIEwaPTzRAvEGEn6SiOaPsCRysHF5Cg9TztBypoBoYDvm5jGJCYRHZxcDvkZ169X2k/EM4jiRwnO8496GGyicC0U23EQ3ZTOdSFx7q2QTnW4vQqgSRHgfhI7zhLDayl0HvJ/seZCGYeZgss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=JoRfMGd4; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:1105:0:640:3589:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id CD99A60D36;
	Mon, 30 Sep 2024 16:28:39 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b737::1:2c] (unknown [2a02:6b8:b081:b737::1:2c])
	by mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id WSZQ8J1Id0U0-LPaVea0W;
	Mon, 30 Sep 2024 16:28:39 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1727702919;
	bh=+waii4FbayNO7LNajP/96dTGHhFcyMFynIDpkcVFBvg=;
	h=In-Reply-To:Cc:Date:References:To:From:Subject:Message-ID;
	b=JoRfMGd4aPROPyM57tZZgEbu5mfdKA4KSnMElz4iYOSQPOSvA59jhWGflAA4+mzh5
	 V+g/a1pylBFmHjJsH84dFnG00YQvkfNzR1qC/8Mo+5Z6lQqSGgRURcWPm9VsuZzeb9
	 r+6xZiGhBWgkukWBN16hx9zaSdkiLevDtfaE2J0Q=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <f0d0b7f0-e989-4a83-b33e-6e273f4a2b77@yandex-team.ru>
Date: Mon, 30 Sep 2024 16:28:32 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/19] qapi/block-core: Drop temporary 'prefix'
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com, andrew@codeconstruct.com.au,
 andrew@daynix.com, arei.gonglei@huawei.com, berrange@redhat.com,
 berto@igalia.com, borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
 den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
 farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
 idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
 jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com, kwolf@redhat.com,
 leetroy@gmail.com, marcandre.lureau@redhat.com, marcel.apfelbaum@gmail.com,
 michael.roth@amd.com, mst@redhat.com, mtosatti@redhat.com,
 nsg@linux.ibm.com, pasic@linux.ibm.com, pbonzini@redhat.com,
 peter.maydell@linaro.org, peterx@redhat.com, philmd@linaro.org,
 pizhenwei@bytedance.com, pl@dlhnet.de, richard.henderson@linaro.org,
 stefanha@redhat.com, steven_lee@aspeedtech.com, thuth@redhat.com,
 wangyanan55@huawei.com, yuri.benditovich@daynix.com, zhao1.liu@intel.com,
 qemu-block@nongnu.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org,
 kvm@vger.kernel.org, avihaih@nvidia.com
References: <20240904111836.3273842-1-armbru@redhat.com>
 <20240904111836.3273842-4-armbru@redhat.com>
 <a9b78fc7-c2f6-43ea-b3b4-eab5eb3ed0f3@yandex-team.ru>
Content-Language: en-US
In-Reply-To: <a9b78fc7-c2f6-43ea-b3b4-eab5eb3ed0f3@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Yandex-Filter: 1

On 30.09.24 16:23, Vladimir Sementsov-Ogievskiy wrote:
> On 04.09.24 14:18, Markus Armbruster wrote:
>> Recent commit "qapi: Smarter camel_to_upper() to reduce need for
>> 'prefix'" added a temporary 'prefix' to delay changing the generated
>> code.
>>
>> Revert it.  This improves XDbgBlockGraphNodeType's generated
>> enumeration constant prefix from
>> X_DBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_BACKEND to
>> XDBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_BACKEND.
>>
>> Signed-off-by: Markus Armbruster<armbru@redhat.com>
> 
> Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
> 

Oops sorry, I see now that was merged already.

-- 
Best regards,
Vladimir


