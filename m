Return-Path: <kvm+bounces-27678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BCE98A533
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 15:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 102D6B2B6C4
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 13:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF2318FDDB;
	Mon, 30 Sep 2024 13:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="QxbEMqGV"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1C413D539
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727702736; cv=none; b=cJZA1PEGcOsZIbTNS06xMphGPuJuhh9dYFfeUAA7+EOhII/0iGZJh2mVXh1Gm567gsAxCpjbhKXsuXGsagVq3/kyOKrpSTjQkW3L9DL7/OZ7Vtu/Fh1rtXBjDip8MImQEutFTrgv3AfXXSzJ5JY+0wtkE15xegtrys9g8eoKYrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727702736; c=relaxed/simple;
	bh=y0c418EUhb7b8sm05e2BAZCHjk3sHA/Kk0rMCxCZBNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KERk5BbODsbmBsw2kmYYlHkjjouUgqWs2S/RECwratb0gn8Ptqkdyb7sGOc+1EgCGt3sv1CCAKoCAyASunzqARw2RgaL+VqrdyaD6+9hINiJeDxYwS8qg0lg7Llabz1plqpV041U5MCf0+J9rvKSVP3fimc7hBeL8MJU4QcipOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=QxbEMqGV; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:b1cb:0:640:2a1e:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 1C18860A20;
	Mon, 30 Sep 2024 16:23:21 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b737::1:2c] (unknown [2a02:6b8:b081:b737::1:2c])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ENZBJX1IWa60-boQthCi9;
	Mon, 30 Sep 2024 16:23:20 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1727702600;
	bh=y49D8L+xH7T7+8zYU2ZZJmAVprThYbfty07i+lBtO/k=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=QxbEMqGVu8CuTWz4MfL9JkKLKCGswjxb53UW0bOfOfSAplZXd1LMFQK3g9fkB4V73
	 XPLmGicBR90EcEKipsOcXI1Xl4FN5GqrkQim93JHTw4s9ojR4LTNVOCL6JsM5Dz2M7
	 Z/C5Fvqi4bQ1O1xTMKVN4O8Pk4YnU7y3wBFv32Gc=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <a9b78fc7-c2f6-43ea-b3b4-eab5eb3ed0f3@yandex-team.ru>
Date: Mon, 30 Sep 2024 16:23:14 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/19] qapi/block-core: Drop temporary 'prefix'
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
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <20240904111836.3273842-4-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Yandex-Filter: 1

On 04.09.24 14:18, Markus Armbruster wrote:
> Recent commit "qapi: Smarter camel_to_upper() to reduce need for
> 'prefix'" added a temporary 'prefix' to delay changing the generated
> code.
> 
> Revert it.  This improves XDbgBlockGraphNodeType's generated
> enumeration constant prefix from
> X_DBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_BACKEND to
> XDBG_BLOCK_GRAPH_NODE_TYPE_BLOCK_BACKEND.
> 
> Signed-off-by: Markus Armbruster<armbru@redhat.com>

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>

-- 
Best regards,
Vladimir


