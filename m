Return-Path: <kvm+bounces-51196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B326AEFC27
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85944163465
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD80C27935C;
	Tue,  1 Jul 2025 14:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eQYls+zQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F173C2749CF;
	Tue,  1 Jul 2025 14:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751379569; cv=fail; b=SYSkNWE07dsSuASXYlVWjqhZt375+pjbK11+KHSC4qk9sDhzA0L7ZglMii9KPf9DU1GLY9KdqACwnt75mjQ7tkGeSrgpT74/t76ZXLZjcurICWGbvSdvg/NJRXotAhhCGPKK7go+1qOy/qQQKHHRlgaXN0liytTU+cFSRyhxyp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751379569; c=relaxed/simple;
	bh=jPkHAikpuBwOQp9uXq7ZL+ds9POV+Pqlz3+X9BxH9eY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Bl8jjXNzi5UCUtBo9gTk5Rgqj83hCqsQjetan4ppcxRcel4KntAUk4nn8SuIkheXalrX+71iQpwULAAQmF7lqmtJoOdn0PYkmZd8KBaiOE6EvkegMHdBfOA9hokfFQ4Z4TLs9bOXhmKHHZMLvZFwXomLXOUM8p5iT0LS/4+4+VM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eQYls+zQ; arc=fail smtp.client-ip=40.107.223.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ciwIGT+kSolvh64fNoi6iH9zjGwOGhAnZ9/er9z3rE8GGyc7RsWvUGibdkVUpApLh1ugP0WL666qELy4g0EYzjT7Ci6Er6Prqg5wcbz7wo4nNE3rMDMipftNuOW9/xVxVr5GfbpiV3164yK2/a5Q5uAw+MKmpvQIzGiOb6oVLZLkYdILasxS9Ss7wMQk1i5hzyCJpvhW5cscbkqx676CinvzpNLXw9rY2RUwrI3oSzYoX656BSW52zf3QT/GugHzm19DIeI6lGjrRy/qvPb74Y2I5lRDPshEpI+/m6JPv5np+nUCr01w/d38jFKQ17HITHrxBZMWMmkNf0Osscx3kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8Dqds69o4RrHpC2fzTvb9BnIWSEdoDfBSWl0YQXmoQ=;
 b=gsL9lMA8O6okt+shDi7C/jujzBVcpxlMrRaZDEFfrRRFZi+3QojTJ2zYAWQ3EabJSgvgZHPHXsd4pDK4G3RXwlkX1AYuX3mx3SyhOFQztWaptKHtDxZdoTdFnjYxTlusSwMROl7WiS26OFZ8yfC0pkrKwQxnAb5DOzxUkTkSnErIki6ugYoV3SGv+diaWfitlQfaTaDIMSmlnKx0hiA90TOYupRepfMHz7ad30f9Hqm/a4c6pr7g6C++HfauMvT44mtSoh20yBj9xpp7Rh5eaBtDIZti4tLKoTgkllITCODcHZoiaJfASjWnF94JU1oTLcB+KbKzhfLqkeSnXpnj+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8Dqds69o4RrHpC2fzTvb9BnIWSEdoDfBSWl0YQXmoQ=;
 b=eQYls+zQT2AT71QIy4mAo+fy1O8gsDf9AEi0iWOxav/pTBoyIwhKAyvaJ9MzLpAWnZIVdHmbHdibHLIAaw1K0VxIajdSb7XJj/CDSSpb49SyosrQYuyp8AhKjzjgvo7fDkERHHRJRCO75JjojiBhD/tJIf8xb6haDnZUGuydz6QgZzMnfQnwgHJmNh3+HqLA9BAnLyBDelwWVkDHsBK9AMaBdak7dUW0ZQngkhOCzSzk4n3s4e1MptH7AA6MBA9nsMKaBKGCcapNM8Ss1Kxm3KiUxyaR7RIDrWg0UhqPAhU2xk3YOXxRnQ81FJ5ABJVvI404Ltl0838dNsdqOC/muA==
Received: from BN9PR03CA0154.namprd03.prod.outlook.com (2603:10b6:408:f4::9)
 by CYYPR12MB8892.namprd12.prod.outlook.com (2603:10b6:930:be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.22; Tue, 1 Jul
 2025 14:19:24 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:408:f4:cafe::94) by BN9PR03CA0154.outlook.office365.com
 (2603:10b6:408:f4::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.19 via Frontend Transport; Tue,
 1 Jul 2025 14:19:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Tue, 1 Jul 2025 14:19:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 1 Jul 2025
 07:19:01 -0700
Received: from [172.27.19.153] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 1 Jul
 2025 07:18:58 -0700
Message-ID: <b68e4945-92cb-44f0-a364-2fe52520683a@nvidia.com>
Date: Tue, 1 Jul 2025 17:18:55 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/mlx5: fix possible overflow in tracking max
To: Alex Williamson <alex.williamson@redhat.com>, Artem Sadovnikov
	<a.sadovnikov@ispras.ru>
CC: <kvm@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
References: <20250629095843.13349-1-a.sadovnikov@ispras.ru>
 <20250630112831.2207fa2e.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20250630112831.2207fa2e.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|CYYPR12MB8892:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dba2c3c-58c4-4514-6260-08ddb8aa476c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVpsMFRhTVZxa1V2UCt1aVFBQUpWaStnanRLWHAxeWNKUEdSV1JGZWJHMXJH?=
 =?utf-8?B?UkhyaHB6a1RodWYyNytORnZuQ2ZaUXBacGZ2dW4yY2Y5cmZPVHdQenhHV0pY?=
 =?utf-8?B?d3lVd3hZcXJnbXk4RzBLdys4cUZLZDhMZDNUbHF4RVVPRUFRckk2a3AraDFL?=
 =?utf-8?B?c25ITm9xMTdweXg5M3FrblZKYXM2RTdVeVp4MVhPaEZMMFB5RmdXV21KRlRG?=
 =?utf-8?B?UmFhRkt2b2JzU3MxTzQxeWlSNVdpRFRDRS9tdHJudUlEbit4UEJyS1g1S0tZ?=
 =?utf-8?B?TkJyS1RGdm55RlE4L2NLamtVWlR1K0hEc0Y4eVB0bS9Rd2tHckZ5d3pra0tP?=
 =?utf-8?B?OXVscXFreHNCSlFRVCtNVHJVczBETXdzMCtmdHdqR0luOVFKVDBqbytleTNt?=
 =?utf-8?B?QjBsSDZRYzVSRHhvUnVtbEp1Z1FNMUlFN3hSZzhGcFZjaVl0T1UvMkU0aVho?=
 =?utf-8?B?U1J3cHhURnZnVndvMEhLRFNhSXdleHB1NmtoUWx3OEgwcHpOVmlobkxiUWli?=
 =?utf-8?B?aEhrbGZidVlGMDRpdmxMVDB0U3RNMlo0cms5ZkRXNitZNHgvUU9Fbng5Tlho?=
 =?utf-8?B?Qm5OWGhyTzFtR0dqaHV4cm1vUjRvKzRYb05RWTJscWFGOEJlY3VqYmRqY3Np?=
 =?utf-8?B?OEV6RkhWT2k5a0lidWs1YUpLQzZPZGJtZXFveGhRRzdkQlRuQjYvRFVTRG1U?=
 =?utf-8?B?WmJucmxHc2JoTCtUNldqTXo3K3JBV1BLTGZUOW9pU3JlZExiN21WMWpiYklt?=
 =?utf-8?B?VkpoWkNtdEd4c1NpSFlUUEM1ZGhSdWc4V3FDVkNhYW9QQnNaVHVUR1ArM2pP?=
 =?utf-8?B?NXVRdDhuTDdsK0ZicHN2TjFpWjA1MUhPMFBBT21IVWJxdEJSa3lnOWVwWUpI?=
 =?utf-8?B?WW12aTlZZkpWbmdnN0Q1UUJHZDdSbXJwZ0Y4V1Y2ckZlNXM2SWJjdm9pNnZY?=
 =?utf-8?B?K0RhZ3Nkd1MrdGlxelI1aGtXY004ZUNyaHBMY2JVelBSeHJmMm8rWXFJQVBF?=
 =?utf-8?B?QkFkanJGTmRISks3c0FJMWhzMzV6Rk9qNWRRSDgydkJ4N3VPT1JtdVZVeHlX?=
 =?utf-8?B?Mmw5OWF4MlVtSEwweEt2d1NUNjJKL04rU3p3eFpWZno0QURvK3ZCYXBuMUQ0?=
 =?utf-8?B?dmVKenM3ZGZLVStkQVhMSzJoVzNvOXV6UnRHZVQ0RXVtR0c0bllKajFKeEdl?=
 =?utf-8?B?cU9ScFdhMVBGWEd2d0FKbk1hVEMvc01EcS8vY05sbFQyYk9WOFpyTWV5MEZQ?=
 =?utf-8?B?VDMvNHdyeDR1UitzNUVSY3NYYVlyVXdUZGJnK2pNWmRIL3lCVHVCdHlCZ1dY?=
 =?utf-8?B?QjZjcVYyQnJtNE9sNEVsVWFrUmJjcEJQYjMyN0VCTlFRRTVwQXJ5bHU1TUFX?=
 =?utf-8?B?UGN2amUybE9aL0hNaHdzVGhLU01PMTREcm50SkhOMXZOUU1ETG9nTW5TMEhF?=
 =?utf-8?B?MzQ1YXpNa2ZYQU9CMnYrSGR3cXhNRWF5S1plSm5LSVJkVnp3aHQ4NXhoV1M5?=
 =?utf-8?B?ei9talVWNTNQV3VWSjNEaDRIRHNveGhoV3gvK0FjWEpPd3VvVDJkaFZiRTZN?=
 =?utf-8?B?QlhqUU1sWFJFQVNHcExxazdxTmFLNVZqNXVSamNpc3hGOGUyQ25Yd05PRVo3?=
 =?utf-8?B?eEVFRjl5K1MycVZENG83WGRlNDVoUTZaQjlRMkhLRHFFU0d1RS9YR081NzJK?=
 =?utf-8?B?eXZzNFB0NERJNnJPd05wVjBkTTdqR0NEMU81SUhzWGFFeDhId2VUK1BUdzFX?=
 =?utf-8?B?d3R5UEJYR3o0N0tlbElJTHF4ZnBPWWMzN1JvSXhjcXgvT2RiZENHVDVNV3VY?=
 =?utf-8?B?UlVUakp6OExXWW91UFdrMXRrWEEzMFNoL1JnVFdia2xyaXJ4L3owMHJYQTdF?=
 =?utf-8?B?cFF1dm5mdkx0bjJKa0NHL2dzQ3Q0ci9WcG9iaXpxY09hRFBkVkNrcDF2bEgx?=
 =?utf-8?B?WXNMRkVpTXc5bDNCYXVlUXJlQ3VWMkErZDM3OW5HWG4wa0t3Zm9zVjZ1eTNx?=
 =?utf-8?B?ZGtDSFM0bC80cGprRmNWU1RWL016QUFCa0JKMVNoazQxY1kxdE9SaU16T1Jq?=
 =?utf-8?Q?6MCLeS?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 14:19:23.6820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dba2c3c-58c4-4514-6260-08ddb8aa476c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8892

On 30/06/2025 20:28, Alex Williamson wrote:
> On Sun, 29 Jun 2025 09:58:43 +0000
> Artem Sadovnikov <a.sadovnikov@ispras.ru> wrote:
> 
>> MLX cap pg_track_log_max_msg_size consists of 5 bits, value of which is
>> used as power of 2 for max_msg_size. This can lead to multiplication
>> overflow between max_msg_size (u32) and integer constant, and afterwards
>> incorrect value is being written to rq_size.
>>
>> Fix this issue by extending max_msg_size up to u64 so multiplication will
>> be extended to u64.
> 
> Personally I'd go with changing the multiplier to 4ULL rather than
> changing the storage size here, but let's wait for Yishai and Jason.
> Thanks,
> 
> Alex
> 

Yes, let's go with Alex's suggestion.

max_msg_size based on the CAP, can't be larger than u32.

Yishai

>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>
>> Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
>> ---
>>   drivers/vfio/pci/mlx5/cmd.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index 5b919a0b2524..0bdaf1d23a78 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -1503,7 +1503,7 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
>>   	struct mlx5_vhca_qp *fw_qp;
>>   	struct mlx5_core_dev *mdev;
>>   	u32 log_max_msg_size;
>> -	u32 max_msg_size;
>> +	u64 max_msg_size;
>>   	u64 rq_size = SZ_2M;
>>   	u32 max_recv_wr;
>>   	int err;
> 


