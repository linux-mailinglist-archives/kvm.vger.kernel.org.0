Return-Path: <kvm+bounces-32935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E379E26E1
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 17:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5B461692E9
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 16:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43A41F890D;
	Tue,  3 Dec 2024 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l265FCtu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2053.outbound.protection.outlook.com [40.107.100.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A231362
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 16:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242522; cv=fail; b=aPdM1nROlr9lG2ODUfAZBw/hNWOfwtuAalIKOBwSrNYF8CbKU1Jnq4mkTgxKd5Ug1a3nk7t4EcxGhQup8gUCNvrkzdzHXLqpvR/zvDVFgBUnHJHXeqlKJ3W0PJ9oRArmY5nMsy5HwuTBCKnQf4JWWsyfBFVTaLDGpeVmel3LkcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242522; c=relaxed/simple;
	bh=g5c2GaR2LQCaULf4++arwqm8OiWIg7NrvS4XBJmkB40=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IiPcD0c9nsc8NWtFnYjoimMLtNMTVOd56d7w0aVTCRkK3FEcQ68JSxfwlk2emk4ysrJEn48uKQZ1Ooh4LvK9x1EMU5zOsFO9zdovO4HC3jRUc88VbrB0W8k2Gietq8ZzjZiqWqxfPc1/9Mt4/bV6jfd9vFlrHpOHiIzQ8UzmaF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l265FCtu; arc=fail smtp.client-ip=40.107.100.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pi5gLuJrrh390h0APx0pW7VadI7uYQPqQtn0RS3D0LU2HbNShdOFAmLAbeOMJ7nE4jow/pItuS0LKDpt56u2NV7hZWUl6fDYSUF7cOp015yLM6lBM36gC44wYUnRDODrP8JDGVCHQi5IijKgEhLyZ7Gt0xxUb0E+siFK7k36r9CQKPC9d9PrXCC0rc0ciaTComlM6dgbYKXrFJPG/InHlcGuGaxD0Eou/zqoHVnHNvP4I04REGZ85dzzYy2bVyS1s9hoHn7CdyOO/XmuyAp/QqCWumWRkbI0w2M5f7ExyCx04NrBVaQ5P7TOUWf5Iegq+kowt9nScCl6K5eeHByP2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxhHFExAF0p1b5Hb2hfyKCRyS1Mn9ymBGzWlj5fVXuA=;
 b=Fs0CH9B25Qs2uAJeCHj4XGN812+Am2YuW5k7DQDsIieN96k2EuPKMJRomXiR2pBx1Hs6YS/wP+CfzN/jz9/od9D1E5Z8aTCG4/tdBG5FIqkJGuSAuNdwyWsMeFjC2rvRAny3Q2VCFfM1yP7fLGQnjD6k1O5LHWKQnmziHNQ+us509XNQ1eRtY1b2cD7adSm3c9g81MJm9YR+YIZzxsmQ9Fp1OKMvjnULFVcut6PiedwsQqZS4FROtUHc8DvVLiCHOttjmGlOHuaPThpBdBxCdY8rOLVaKN4jdsf9LMAmr0s4UAs9KduQOHHLEGGmImzOq7oLBdghcpBXLOmU9jyS8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxhHFExAF0p1b5Hb2hfyKCRyS1Mn9ymBGzWlj5fVXuA=;
 b=l265FCtuimeYqn54JHUD8af4h1EgUvk89TzeKzbY2KFvVl2dnx+SQ2c0af0B8FeLAKi7Tc75JHZRJPdD64Qa2WyADZJrVZ2HIrj3vrEmsGkgrNeNnu0qDIyZIzN16le+PxN0PjGBtzP2jl36g0vljWQUP0m67bkKW4A6YshKrPijtQqJtd9qlLJRRCEgr5a66ArEBo+qPFDdxXTJv6gQuCxRjzUspmiZkTwkgFx5uyClEw/bSbDs6h57q3jJrNvx6ATO5j7OgrqNOoBImIUD9m4pGGVGLl9SzRcmFWl+zg1cgJ0gqyQDvi5vOhcmBPEqXhHg+YlgAaSXQdTGQizlvA==
Received: from DS0PR17CA0003.namprd17.prod.outlook.com (2603:10b6:8:191::17)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 16:15:09 +0000
Received: from DS1PEPF00017096.namprd05.prod.outlook.com
 (2603:10b6:8:191:cafe::c3) by DS0PR17CA0003.outlook.office365.com
 (2603:10b6:8:191::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 16:15:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017096.mail.protection.outlook.com (10.167.18.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 16:15:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Dec 2024
 08:14:50 -0800
Received: from [172.27.48.97] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Dec 2024
 08:14:47 -0800
Message-ID: <48068205-1fd9-4e5d-bb45-b13043d9f198@nvidia.com>
Date: Tue, 3 Dec 2024 18:14:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/mlx5: Align the page tracking max message size with
 the device capability
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <maorg@nvidia.com>, <galshalom@nvidia.com>
References: <20241125113249.155127-1-yishaih@nvidia.com>
 <c69d6fc7-ab18-48f5-9e23-e0f947f8840e@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <c69d6fc7-ab18-48f5-9e23-e0f947f8840e@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017096:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ac99e05-f753-417c-cceb-08dd13b5a741
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1drckpyNkpqOWhYekFTQ0E0UXd4QW8rb2pWZ0p4NGdEaU53N2ZEeitHNFgr?=
 =?utf-8?B?N3BVN0NIaUdONTM5VWdLaVJReEJ0cUQxQURUbHN6WCt0VjBha1MwNW5WVExn?=
 =?utf-8?B?TUtrZ1lXVnMzNmxYRHV4NmkyNkdHcys0QXBidWRWdDNnRWJ3TlRuZm4xNjlC?=
 =?utf-8?B?WVhidmFrcURqSHY5dkg3NTY3TWp1aFNuOEpNT2hPcHo3UGdWaHFjem5iQStD?=
 =?utf-8?B?VmJWc3EwZERRdHkvcjA4cy9lWXVuY0s5dnNjYlk5eDh4YWwxVThRQzdmTlNy?=
 =?utf-8?B?Rkl4Vi80WlRhS1BYa3VMbUxDOGRmOUNKVy9MbXp2SXFMT1IwblFDY1RhQU5w?=
 =?utf-8?B?RW9KVEZhMHAzR3VhQndTc2NQK2V6bDJVL0lXVEl2dS9qSkhGVWhxWDNiTUxC?=
 =?utf-8?B?SzdqVTBNbXZIMHdrcjVqV2o2TmNIWXorOS9MUVJwejhTczNhNjY0ZEc0Wkt6?=
 =?utf-8?B?L3pWSzBpaHVrNmYxdWdEcmdob0dPaVZMZlN1VENYQThzL3Nza2F0blhyRXZM?=
 =?utf-8?B?SlF6RUFTKzlOMk0wZ2hna0ZWY3Y5c2gyV1VQTUlHbUs3OUlXTTV2Q3Y1Q0VD?=
 =?utf-8?B?TmZPV2VSVVI5bTJXRzdHZVk0L2tCeFVxZDZuM3pzb25ER05MeFFqSTJKK09E?=
 =?utf-8?B?bGd6Z3RWWW93NHNQUnhKck1QWjNIdkFBZVRpS09kTlNSKzdiaHdSWFduclRT?=
 =?utf-8?B?QjNyNDZubjRDMUJVRTU4NHlmVk9BenJTNkRFRzBORzRRMWMwOS9acW9qQm1i?=
 =?utf-8?B?dVNGajZ0czhUczV5R2ZLU1FlczJoZnpQTlAzTklGblhhSGxVdUluMnlYZU1X?=
 =?utf-8?B?Qmw5clBJVXlJcnVCVmovSWZ6aldvQWNFcXdBNnRETi8vWE1ldlEva0puUith?=
 =?utf-8?B?RTVqSmhEZy9kcnEvQmtySkEyNEdIa2YzZi85eHFhMDNQTS80TzBveVNmNDlz?=
 =?utf-8?B?VDZSMFpISWhkU3Erd0pqaFlsMlFienhBQU5IeEttSkZwcGJMeG9CK1ROWjB4?=
 =?utf-8?B?TGdORnV3aHMrZE12Z3d5ajFaZG42UzdTRGM5dlpPbk95MzhzVDMvakF3aGRG?=
 =?utf-8?B?d2hiTzFtMFZ2SWVydExFanVwQ3d5eWNLbHphMm9kVFkrL0V6bHNOS1lnb3ZX?=
 =?utf-8?B?aFJnc1k1cEljYnRmZ25qcjRLNlJUU3M1M3pPWE1wcDBLejkxUW1MaGtHZEhv?=
 =?utf-8?B?ekR5bkNyT2xkUHVqRGlDU25xVHI1RjlyMGtuTDE4cGxiSUVRZW55ZlVHaU5U?=
 =?utf-8?B?Z1hWNWphVXlDZTIrNWp5bmxpVU1ncUVkRkZTalRoQmwwbHd5b0lTOFlubU9a?=
 =?utf-8?B?U1ExU0k5R3JkbmdXMUNDblN0dnFyWmh3dk95OXpycmJXTmRZczh2Mnp1T0ww?=
 =?utf-8?B?c2xZODRscWg0WVM5b2YzWExuNFE4ZGlpVm44dkc3SFhKOWFiVHpHYmdRUG9o?=
 =?utf-8?B?NVNUMkRWN0w1RUhyaXRYOUtDUXowclVWOVVVdU44elRYc3NHK1FsdlI3Smox?=
 =?utf-8?B?ZmtwZTM1L0NjNUplc3ZOdzN4c0tyN1ZpN2VNRjZRbEpLNXVxcWFsZ1dSSHlK?=
 =?utf-8?B?MkVCV1lwb0owV2llNlRGWHlFakVBcGJ6WlRjRCtLRDd5TlJzQjhWd3JQQU83?=
 =?utf-8?B?b1FQb25rRm9NVVpQWHhtTVlPT0xVQ1hudncya0hacjFWU0krZWlVUWtLSnJs?=
 =?utf-8?B?TitJR3E0UWhxWHAvcDRSNjJTQmVIVjBTMFAzWmgxeHl0RlROVlludkVrWks5?=
 =?utf-8?B?RUZwVFY3eFEzcVN6SE13YjlDai9WR2FNeGw1bjBsQXMyS3dGbGtNVnUrTnBD?=
 =?utf-8?B?TnB6ZjdrU1RxT25ZZDlUaXZXbWIzSVpwTVRIUlNzMjNCMkpldG5DZDFveUUy?=
 =?utf-8?B?dlJJTkYzN0hUYWxaSHdKZXl4STR3eWYvTWpCY0dPYnozcDNqUmY2L3ZvS2Nj?=
 =?utf-8?Q?GXq42SRlBGplvQycPStj0GsYJdVkro/i?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 16:15:07.0094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac99e05-f753-417c-cceb-08dd13b5a741
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017096.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

On 03/12/2024 17:07, Cédric Le Goater wrote:
> Hello Yishai,
> 
> On 11/25/24 12:32, Yishai Hadas wrote:
>> Align the page tracking maximum message size with the device's
>> capability instead of relying on PAGE_SIZE.
>>
>> This adjustment resolves a mismatch on systems where PAGE_SIZE is 64K,
>> but the firmware only supports a maximum message size of 4K.
>>
>> Now that we rely on the device's capability for max_message_size, we
>> must account for potential future increases in its value.
>>
>> Key considerations include:
>> - Supporting message sizes that exceed a single system page (e.g., an 8K
>>    message on a 4K system).
>> - Ensuring the RQ size is adjusted to accommodate at least 4
>>    WQEs/messages, in line with the device specification.
> 
> Perhaps theses changes deserve two separate patches ?

I had considered that as well at some point.

However, once we transitioned to use the firmware maximum message size 
capability, the code needed to be prepared for any future change to that 
value. Failing to do so, could result in a broken patch.

Since this is a Fixes patch, I believe it’s better to provide a single 
functional patch rather than splitting it into two.

> 
>>
>> The above has been addressed as part of the patch.
>>
>> Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty 
>> tracking")
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/pci/mlx5/cmd.c | 47 +++++++++++++++++++++++++++----------
>>   1 file changed, 35 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index 7527e277c898..a61d303d9b6a 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -1517,7 +1517,8 @@ int mlx5vf_start_page_tracker(struct vfio_device 
>> *vdev,
>>       struct mlx5_vhca_qp *host_qp;
>>       struct mlx5_vhca_qp *fw_qp;
>>       struct mlx5_core_dev *mdev;
>> -    u32 max_msg_size = PAGE_SIZE;
>> +    u32 log_max_msg_size;
>> +    u32 max_msg_size;
>>       u64 rq_size = SZ_2M;
>>       u32 max_recv_wr;
>>       int err;
>> @@ -1534,6 +1535,12 @@ int mlx5vf_start_page_tracker(struct 
>> vfio_device *vdev,
>>       }
>>       mdev = mvdev->mdev;
>> +    log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, 
>> pg_track_log_max_msg_size);
>> +    max_msg_size = (1ULL << log_max_msg_size);
>> +    /* The RQ must hold at least 4 WQEs/messages for successful QP 
>> creation */
>> +    if (rq_size < 4 * max_msg_size)
>> +        rq_size = 4 * max_msg_size;
>> +
>>       memset(tracker, 0, sizeof(*tracker));
>>       tracker->uar = mlx5_get_uars_page(mdev);
>>       if (IS_ERR(tracker->uar)) {
>> @@ -1623,25 +1630,41 @@ set_report_output(u32 size, int index, struct 
>> mlx5_vhca_qp *qp,
>>   {
>>       u32 entry_size = MLX5_ST_SZ_BYTES(page_track_report_entry);
>>       u32 nent = size / entry_size;
>> +    u32 nent_in_page;
>> +    u32 nent_to_set;
>>       struct page *page;
>> +    void *page_start;
> 
> A variable name of 'kaddr' would reflect better that this is a mapping.

OK, I'll rename as part of V1.

> 
>> +    u32 page_offset;
>> +    u32 page_index;
>> +    u32 buf_offset;
> 
> I would move these declarations below under the 'do {} while' loop

We could consider moving most of the variables inside the do { } while 
block. However, since the majority of the function's body is already 
within the do { } while, it seems reasonable and cleaner to declare all 
the variables together at the start of the function.

> A part from that, it looks good.

Thanks for your review.

> 
> I haven't seen any issues on x86 and I have asked QE to test with
> a 64k kernel on ARM

Could you please update once the test is completed successfully on the 
64K system ?

After that, I'll send out V1 and include the tested-by clause with the 
name you'll provide.

Thanks,
Yishai

> 
> Thanks,
> C.
> 
> 
>>       u64 addr;
>>       u64 *buf;
>>       int i;
>> -    if (WARN_ON(index >= qp->recv_buf.npages ||
>> +    buf_offset = index * qp->max_msg_size;
>> +    if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
>>               (nent > qp->max_msg_size / entry_size)))
>>           return;
>> -    page = qp->recv_buf.page_list[index];
>> -    buf = kmap_local_page(page);
>> -    for (i = 0; i < nent; i++) {
>> -        addr = MLX5_GET(page_track_report_entry, buf + i,
>> -                dirty_address_low);
>> -        addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
>> -                      dirty_address_high) << 32;
>> -        iova_bitmap_set(dirty, addr, qp->tracked_page_size);
>> -    }
>> -    kunmap_local(buf);
>> +    do {
>> +        page_index = buf_offset / PAGE_SIZE;
>> +        page_offset = buf_offset % PAGE_SIZE;
>> +        nent_in_page = (PAGE_SIZE - page_offset) / entry_size;
>> +        page = qp->recv_buf.page_list[page_index];
>> +        page_start = kmap_local_page(page);
>> +        buf = page_start + page_offset;
>> +        nent_to_set = min(nent, nent_in_page);
>> +        for (i = 0; i < nent_to_set; i++) {
>> +            addr = MLX5_GET(page_track_report_entry, buf + i,
>> +                    dirty_address_low);
>> +            addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
>> +                          dirty_address_high) << 32;
>> +            iova_bitmap_set(dirty, addr, qp->tracked_page_size);
>> +        }
>> +        kunmap_local(page_start);
>> +        buf_offset += (nent_to_set * entry_size);
>> +        nent -= nent_to_set;
>> +    } while (nent);
>>   }
>>   static void
> 


