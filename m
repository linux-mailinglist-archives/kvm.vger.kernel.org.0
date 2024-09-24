Return-Path: <kvm+bounces-27353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 657A1984394
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 12:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87BFA1C2286C
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 10:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF0117BEBD;
	Tue, 24 Sep 2024 10:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DfZWIDio"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7434217B508
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 10:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727173573; cv=none; b=kZAMHb67bBW+BUdCfz/cZLBf2hXXnNLmxCnX5AuaD2Ynryq0PmM3pxZTAYrhygtP8I+fZ2Ai6xdoBpbtuDDSjCYmru/CeuvorX8hJI5uZxmGTVBnAsvu5/E1piGfnVMVXlDAcmDomKS4dTc+4F9xUrTvqLLWSKBFhsGZ7XsPd1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727173573; c=relaxed/simple;
	bh=aIxlxp4j/hmsNTU0P/dn29uqfvibH2qk9+A9qAsJNEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=L511mRNIzvVANsBX4o2KJZFmxKfF43MD1ng1yPn9VrZjLunl22T271XS5NwnJxl8comp32AyTrLGyqJCFslwi1mwKkeBIF72L4EAZXsYal2E9KpfuWOjpBP/WOLamVhQ2SdloD8lE47+frYpA+sFfjmqHnkQvVV5SKf1vl1pKcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DfZWIDio; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240924102607euoutp0234c79f1bbeb5ecee3b30311b34c1bd0f~4JzVn0iiK0814708147euoutp02P
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 10:26:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240924102607euoutp0234c79f1bbeb5ecee3b30311b34c1bd0f~4JzVn0iiK0814708147euoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727173567;
	bh=xoXtx/PB5evdtfJqWlO5XQNvkO4mAhERHUcWqq0DHp8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=DfZWIDioT0rJbnXI2bV2NZeqqJ88NelrnvMdco9fWTUVOTFswuwRt5DD5QnlrYdrD
	 XSNupqIrlOThIMJRBn9nd5rdVN8KaTj3+OyBufl+YDQpSM1zrfi1GKqXqKK+o+REFU
	 onfbT9pQpD0XF7SPTEWjOkETWnNaFYaD0nJTEHDQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240924102607eucas1p140096a46f3f02e8306d0be04780e2444~4JzVYBi6u2327723277eucas1p1Q;
	Tue, 24 Sep 2024 10:26:07 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id FA.B0.09875.FB392F66; Tue, 24
	Sep 2024 11:26:07 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240924102606eucas1p235b4127bc630978853fb1fd89ab32d74~4JzU88nmg0663606636eucas1p2K;
	Tue, 24 Sep 2024 10:26:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240924102606eusmtrp24bf6a761fe20603202506111a94148fa~4JzU8QdjR0677806778eusmtrp2a;
	Tue, 24 Sep 2024 10:26:06 +0000 (GMT)
X-AuditID: cbfec7f4-131ff70000002693-40-66f293bfb144
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id F8.B9.14621.EB392F66; Tue, 24
	Sep 2024 11:26:06 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240924102605eusmtip2d0496f3fb2055bafe35b76e027366737~4JzUKpMZL0231402314eusmtip2r;
	Tue, 24 Sep 2024 10:26:05 +0000 (GMT)
Message-ID: <47f4de34-e83b-47a2-a260-c924d552ad67@samsung.com>
Date: Tue, 24 Sep 2024 12:26:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_blk: implement init_hctx MQ operation
To: Max Gurtovoy <mgurtovoy@nvidia.com>, stefanha@redhat.com,
	virtualization@lists.linux.dev, mst@redhat.com, axboe@kernel.dk
Cc: kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <17b866cb-c892-4ebd-bfb9-c97b3b95d67f@nvidia.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsWy7djPc7r7J39KM/h/jdVi9d1+Nos5Uwst
	9t7Sttg6/zOTxf9fr1gtHlyaxG7xetJ/Vouj21eyOnB4XD5b6vFi80xGj97md2we7/ddZfP4
	vEkugDWKyyYlNSezLLVI3y6BK+PC6wXMBf8kKvqmJDcwzhXpYuTkkBAwkdix5yFTFyMXh5DA
	CkaJU3+msIMkhAS+MEq8O6gGkfjMKHHy5iNGmI41H6ZDdSxnlOhYsosZwvnIKDH/0Asgh4OD
	V8BOYuNDYRCTRUBV4vzcWJBeXgFBiZMzn7CA2KIC8hL3b80AWyYs4CIxZX0TWFxEoF6ie+8R
	MJtZwFXiQ28nG4QtLnHryXwmEJtNwFCi620XG8h4TqBNn3eJQJTISzRvnQ12jYTAHQ6JtU0L
	2SFudpE4crCZGcIWlnh1fAtUXEbi/875TBAN7YwSC37fh3ImMEo0PL8F9bG1xJ1zv8C2MQto
	SqzfpQ8RdpRoaVnADhKWEOCTuPFWEOIIPolJ26YzQ4R5JTrahCCq1SRmHV8Ht/bghUvMExiV
	ZiGFyiwkX85C8s4shL0LGFlWMYqnlhbnpqcWG+WllusVJ+YWl+al6yXn525iBCag0/+Of9nB
	uPzVR71DjEwcjIcYJTiYlUR4J938mCbEm5JYWZValB9fVJqTWnyIUZqDRUmcVzVFPlVIID2x
	JDU7NbUgtQgmy8TBKdXAtKwz4uvL+ZfYf0r9/7b+ZkTsj4gmgRqt3EUr3D0Otv7UzjUWNr91
	/EHOu8TuiabSBw+enKTcbNX/qfbwtlnngsKlL0vn7tb45Wdgqx6x7aETj9GDf29ZmtOYw+Uu
	XXN1klU++nRvsG1tiHTdt9Ijm764PF/DPfXWPyFLfinrH9qTn2U9Sbtn0GcuGaQqZi+U4Lao
	djNL0p85RrZaolcscnY7u1m7r5zLryrbsGz3jC3LPYOPnGXiOMulFyH9OqmILV9m3aqDyr/S
	Fd56Pjw+v8HZ5d8HQZlNHAnms2592Bd2z0k41q/z4ru3R6dYfd3w9WHa5PDWq4/cmp99en4s
	5IFPh/us6Rx31DV+r9jUrcRSnJFoqMVcVJwIAHZ0l0mvAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xe7r7Jn9KM3jQoGax+m4/m8WcqYUW
	e29pW2yd/5nJ4v+vV6wWDy5NYrd4Pek/q8XR7StZHTg8Lp8t9XixeSajR2/zOzaP9/uusnl8
	3iQXwBqlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eg
	l3Hh9QLmgn8SFX1TkhsY54p0MXJySAiYSKz5MJ2pi5GLQ0hgKaPEt0cHmCASMhInpzWwQtjC
	En+udbFBFL1nlFh1dyVQgoODV8BOYuNDYRCTRUBV4vzcWJByXgFBiZMzn7CA2KIC8hL3b81g
	B7GFBVwkpqxvAouLCNRLNO/oAIszC7hKfOjthBp/n0niws5eNoiEuMStJ/PB7mETMJToegty
	AwcHJ9Daz7tEIErMJLq2djFC2PISzVtnM09gFJqF5IxZSCbNQtIyC0nLAkaWVYwiqaXFuem5
	xYZ6xYm5xaV56XrJ+bmbGIExt+3Yz807GOe9+qh3iJGJg/EQowQHs5II76SbH9OEeFMSK6tS
	i/Lji0pzUosPMZoCg2Iis5Rocj4w6vNK4g3NDEwNTcwsDUwtzYyVxHndLp9PExJITyxJzU5N
	LUgtgulj4uCUamCakOh4UX3bxBtBN+LyBacl8YpsznPMPrCiMDNmAcedsNLiy7tfNXt4r18g
	9Egq+0Dh7qx5cy+2R0Xd7N3/9VhD0aMj4nMVJWdxsr6zXF44+bHs8QjGu88sTxf8PrU6jOlj
	5JzY4xsmTNhawvatcmZv5+l3+j+lP4m+yc5bsXFV+gGRaNUbD+dHTN76/1D/wdV3lOw/ZXb+
	LTCXWr/i/ERbm6srUsXTKjj3Zj81YdxSf1F4x/6Niy9FnKro0GJjVTY6qpJ6Uvlhsvs3m/SV
	twKfX5z+NGVXffpO4ynVmfF9VxbdCi1hlSj48/dfx3z70nmft93wlur+Ycv+csdcluMy/OEL
	2O0OXZ/yJ1Q2oCpOTImlOCPRUIu5qDgRAFdE+95CAwAA
X-CMS-MailID: 20240924102606eucas1p235b4127bc630978853fb1fd89ab32d74
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
	<CGME20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a@eucas1p1.samsung.com>
	<fb28ea61-4e94-498e-9caa-c8b7786d437a@samsung.com>
	<b2408b1b-67e7-4935-83b4-1a2850e07374@nvidia.com>
	<5e051c18-bd96-4543-abeb-4ed245f16f9e@samsung.com>
	<17b866cb-c892-4ebd-bfb9-c97b3b95d67f@nvidia.com>

Hi Max,

On 23.09.2024 00:47, Max Gurtovoy wrote:
>
> On 17/09/2024 17:09, Marek Szyprowski wrote:
>> On 17.09.2024 00:06, Max Gurtovoy wrote:
>>> On 12/09/2024 9:46, Marek Szyprowski wrote:
>>>> Dear All,
>>>>
>>>> On 08.08.2024 00:41, Max Gurtovoy wrote:
>>>>> Set the driver data of the hardware context (hctx) to point 
>>>>> directly to
>>>>> the virtio block queue. This cleanup improves code readability and
>>>>> reduces the number of dereferences in the fast path.
>>>>>
>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>> ---
>>>>>     drivers/block/virtio_blk.c | 42
>>>>> ++++++++++++++++++++------------------
>>>>>     1 file changed, 22 insertions(+), 20 deletions(-)
>>>> This patch landed in recent linux-next as commit 8d04556131c1
>>>> ("virtio_blk: implement init_hctx MQ operation"). In my tests I found
>>>> that it introduces a regression in system suspend/resume operation. 
>>>> From
>>>> time to time system crashes during suspend/resume cycle. Reverting 
>>>> this
>>>> patch on top of next-20240911 fixes this problem.
>>> Could you please provide a detailed explanation of the system
>>> suspend/resume operation and the specific testing methodology employed?
>> In my tests I just call the 'rtcwake -s10 -mmem' command many times in a
>> loop. I use standard Debian image under QEMU/ARM64. Nothing really 
>> special.
>
> I run this test on my bare metal x86 server in a loop with fio in the 
> background.
>
> The test passed.


Maybe QEMU is a bit slower and exposes some kind of race caused by this 
change.


>
> Can you please re-test with the linux/master branch with applying this 
> patch on top ?


This issue is fully reproducible with vanilla v6.11 and v6.10 from Linus 
and $subject patch applied on top of it.


I've even checked it with x86_64 QEMU and first random Debian 
preinstalled image I've found.


Here is a detailed setup if You like to check it by yourself (tested on 
Ubuntu 22.04 LTS x86_64 host):


1. download x86_64 preinstalled Debian image:

# wget 
https://dietpi.com/downloads/images/DietPi_NativePC-BIOS-x86_64-Bookworm.img.xz
# xz -d DietPi_NativePC-BIOS-x86_64-Bookworm.img.xz


2. build kernel:

# make x86_64_defconfig
# make -j12


3. run QEMU:

# sudo qemu-system-x86_64 -enable-kvm     \
     -kernel PATH_TO_YOUR_KERNEL_DIR/arch/x86/boot/bzImage \
     -append "console=ttyS0 root=/dev/vda1 rootwait noapic tsc=unstable 
init=/bin/sh" \
     -smp 2 -m 2048     \
     -drive 
file=DietPi_NativePC-BIOS-x86_64-Bookworm.img,format=raw,if=virtio  \
     -netdev user,id=net0 -device virtio-net,netdev=net0        \
     -serial mon:stdio -nographic


4. let it boot, then type (copy&paste line by line) in the init shell:

# mount proc /proc -t proc
# mount sys /sys -t sysfs
# n=10; for i in `seq 1 $n`; do echo Test $i of $n; rtcwake -s10 -mmem; 
date; echo Test $i done; done


5. Use 'Ctrl-a' then 'x' to exit QEMU console.


 > ...


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


