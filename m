Return-Path: <kvm+bounces-30921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 363779BE567
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:17:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7CA72822B3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A871DDC30;
	Wed,  6 Nov 2024 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pPRslWkQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4813418C00E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 11:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730891822; cv=fail; b=QwFPRX6Ht7895Zn/T1E1UMf92bqmEw0t9U3H0V1BueN8Td9rIzpcWDmwi8lFDAwClCbyuawxou28cFNGBbuVuK5gw0rdf0WhBpSrEqniXnvvA6q+0L/OzoXZFY0v3q9f1EMG2RTHcsNwIfTts0qJhFhy19BA6yuicrq8+BmEefA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730891822; c=relaxed/simple;
	bh=JGwOvF5sV6qSNPZ6qTqlvl5qcuDwxreiXQTeUUjuWRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=k/M6jy8cRQ+NepFtR37/+X+FQoUxKC7LWcaB6hsGhfzgPR/0tBZDUy5KBNmZCERHYWNyOaGqlPy45iCgUrcnzsb+NaX6bjPiaI0EJi06IzsgKZf3fnSY0XaL8iUl259lwPBiHrNALm9I2O3wjRoU6LYyyxL0nOAlUnuzByZw+/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pPRslWkQ; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VH6D7juqkTeiXm0mi6/sI5vhL8t1BfaNPKboVHR8UsWtEvmIZH5Gy5z1YfVKbeR+c9Tf9kmdSfSbKSJW2PDZ4VQw1OyIdw+EXwpymzOIsq2yGoVmLbkhJpSKNY1hYmcTQqbe6XPwxMTds8xQ550lKcv5bTM60T36de4qzKRpDsBws6+l3WygjZYX7QwEYoJhgu1raDtMYk6xFSFxRHhlH8BaKHqCjqd9v9nBHGtHqxY92Lqos9nOgeTXjPCXSdZ7PvqZIgjcqxmpgyCvYVpUKPw5PxerQVOnpZMfCCJqAUq0xXj+5HY2PXmn4rhJgXCnVs/X5IAwCuKryuUuaroY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ky8pnsohj9DIaZakqog1e5OflPG1uBjaGxFvsmr9PE8=;
 b=HN5YkdZad3b8XV9Qng563ChnM4fmV+B3Co6fuhUuhlRRPCfnaWValNzQ/O48Z2szFhhCgg9WMH5jWXNcQ+PZX9IU/eoOCwe0Y/KAkCUqN7iggBm+BkoC9+pVE0kwktzJD8OMnJzsTQcEpmUVliUlRO28pdTwSp0DeFtW6bO2Lu15X/5jc5Z1WxeTOiUh2acXLvdpBim7+uEbz4Uxx4BTTxxh2X7ShcQOHTqKt818E7vpRdRVLf1uzdTz+APX5eGy0NC86pWnBoPCsqnXSPSab+vqlHLlT+XUb09Qn/ksicVdcwq9vR26HhT/Re4YT+0gOVdWcVxWs+oItFU4IYMqgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ky8pnsohj9DIaZakqog1e5OflPG1uBjaGxFvsmr9PE8=;
 b=pPRslWkQEQrIkOJCxgYrcKvA5CxL40UzLxLu4Aw0zDZRW5pb8Hy2btLWpBDfK2tHEPSPVpN8VNctdIUOKokGLm8zDfIC5/ljkB4lNYkv0bfZRrvLXr62PxLHAMw07/kfHXRgLudmxSNucbk/Cy/MU9i1A25RM0Nrlud404jso7afNoHTuYjHTjSMDjfSbn3hchT0NnekhDcnAMJBZffdz2zE/8QtRkAHsIOS6UsZ0Q0Bh3NRmomanwKm/Ngc5HrPFAT0omEDF84BzspsjWfg6DBo8tivNR9Px2deZ82zurJeJsyr7OWLS0SznCXGfn+pHi06j3HxmCafeINUhF5nqg==
Received: from MW2PR16CA0061.namprd16.prod.outlook.com (2603:10b6:907:1::38)
 by CH3PR12MB9342.namprd12.prod.outlook.com (2603:10b6:610:1cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Wed, 6 Nov
 2024 11:16:53 +0000
Received: from SJ5PEPF000001CE.namprd05.prod.outlook.com
 (2603:10b6:907:1:cafe::86) by MW2PR16CA0061.outlook.office365.com
 (2603:10b6:907:1::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24 via Frontend
 Transport; Wed, 6 Nov 2024 11:16:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001CE.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Wed, 6 Nov 2024 11:16:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 6 Nov 2024
 03:16:41 -0800
Received: from [172.27.60.49] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 6 Nov 2024
 03:16:37 -0800
Message-ID: <977be8e4-e52c-41bc-8a43-31ae906e6665@nvidia.com>
Date: Wed, 6 Nov 2024 13:16:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 6/7] vfio/virtio: Add PRE_COPY support for live
 migration
To: Alex Williamson <alex.williamson@redhat.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
 <20241104102131.184193-7-yishaih@nvidia.com>
 <20241105161845.734e777e.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20241105161845.734e777e.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CE:EE_|CH3PR12MB9342:EE_
X-MS-Office365-Filtering-Correlation-Id: 15b00d48-6501-412c-9128-08dcfe54844a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0pXRGRWV3FMUUtESWJXY2drWnYrQVBLdkVjTXNjYWMxdDFqM0Uxbnhsd0t4?=
 =?utf-8?B?ZXM4RXB5blY4YmZLVnB0amc1WXpnRno5dUwwNGh4WlZXRXFoUWNJa2Z6Zjgz?=
 =?utf-8?B?RElucDlZd1o1UkMrNFpCNDNQakxqSDZObWptVWdNOFl0R0JGUzBVa1JsM2M4?=
 =?utf-8?B?K3ozRWZZU3hhdjM2Q0JwYmdJMmQzTm9PVHNOaVRwdEp1UkhScm9PcWM5K1A4?=
 =?utf-8?B?TzNXMTdVUUVNdTVJQnM2ZjN6ZjdGNUZyTUpaL1dBR1V6c3QzOUIvTEk0SWZr?=
 =?utf-8?B?UWZIWDhnNDJETzE5MVNTUm9yeU9HYUtLOXdCVU1CZUh6QW1vWjIzY2JRNG9l?=
 =?utf-8?B?M3lZd0ptQkRxNnI4eEdLTTRSbTVjL2Fwb0ZkNVZOemZtV1dvS1ZORlpObVJi?=
 =?utf-8?B?MzBVUy9nT2dYZXRHckFvNmVwa3VzZFlJcEJYMm1nbW9pZEo4SnBsZlpwWUhG?=
 =?utf-8?B?anh6U2tQTjV3b09razh1ZEhtSmhuQjl6Q2hld1BNVUF0c05GK3lXUXpLellP?=
 =?utf-8?B?bVFXTExJb2RnbFpMSSt1ZlNRcWVrV3c5ZGxod1dRVmwxWkdvZnp6bEw5WFpw?=
 =?utf-8?B?WkVOT1RxaUY1REIydERXcDNkVmxWM3JXOG1IUTJpRXF2cldjZTJPSlRMSzg2?=
 =?utf-8?B?Q1ZWM3l1SVFYQm8rNVhFVVVRb21GWW1UWkQwdS85UUV3WFpFZmRxNHRLbFFC?=
 =?utf-8?B?emVOY3h2Z0wxRnpoN2VUZEJsZ1QvU0JwWWFFSU5ZRElJUTFMUW1lU3gvNXhW?=
 =?utf-8?B?aXpkK1pjUG0rVEVrNjJrRGc4dmRCUGpsWDdSbTVBU2M0VkFING9BSE95VXZL?=
 =?utf-8?B?RHBiVVlOVHRLSDJRZVFnaDVJbTN6TS9zUkdUT2x1NDcwNHJsNEowb001UGhp?=
 =?utf-8?B?MjF4NjVLSG9pYkkwa1IwdWN1emMxYmNzbFJJUjhDdU9LT0VHaW9XM3JmaFNK?=
 =?utf-8?B?NVFQS1lhd1oyR2I4U3FqVDlwb0JnRlY4Y3FaTmMrUGJVQ29vRWpHajdwQlds?=
 =?utf-8?B?alQ3YVIrZFdodjdqNlp5S2ZxSkNaNHlBemtISm1ESzh0N3RwaWpHajZBNlVn?=
 =?utf-8?B?UFhMMklLQjJzTmhDcmtTL0F2ZTgrVWtZaVdGYUFOZEw4dkRzTXdwS0FJYzV2?=
 =?utf-8?B?bE5zbE5haDhnYkdCMmRWVTZBRHlkMkNJOWl5bGRUV0V5cE56ci9NWWF3cDI2?=
 =?utf-8?B?Z0M0UTZlQ0ZpZ0tZU2FDNFJGdlhlZ2JCZ0dTV2ZIL1V2elpoNGJ1d0JSN2Ji?=
 =?utf-8?B?eFRyVmphOHI1T2RwUkZ2dlc0NEdwd2EvcDdoZWo0WDB1NkxXUnExZmZhZlVa?=
 =?utf-8?B?Lzd6cVM1NXA2MzBia05rOHRTdVU1TGJaZnpBZGxvUTU3czR1TEM5VGkrcVNU?=
 =?utf-8?B?TjFwbTkyNThXVzJaS010TFdqc3gwSHMxcXBLSG1ZUzNhaXFZaXdWWndDb3JW?=
 =?utf-8?B?Tmc3UkNGc0ZUKzhtS1BhOWt1RkRDY3AzT3FaQTl1NEVySlVvREE2RFVpOW1a?=
 =?utf-8?B?NkJrbm5GRHJTb3lNYXQzWTR0bXZZbUZmU2ZNYTB3QVlUUDJGQ3dYUzNUZHZY?=
 =?utf-8?B?VUNYb2FJUkQ5TWtyZzB4cFRLejVGT1pQMW1IZHZxV3NhZTVyYVB3SnYyUHVa?=
 =?utf-8?B?MjczYkw4Z2Q5VzA5UU1FRmxIeFc4dU9WR2NvemxDaUFqbVltNjFIQzdvZGVz?=
 =?utf-8?B?aytTR0EwM2VmYm1kMTkwbWhiZENsM2x3V3pReUFIMEk1ejRHT3JXMkhuQVpa?=
 =?utf-8?B?WEdJbDZKY05RVTIrdW03dWc2TWU3VUJKT1VQbW52MXdEUnI3RGgyVGphZ1pi?=
 =?utf-8?B?RkVFTFB1K1lINDJQT2ZTMDBBdzRqWmF2SGwrdUZDeE1tMU1aaFYwLzFadDdw?=
 =?utf-8?B?UTJoTWJKaDR5MWZJbENHb1VINXU0Q3QzblNBb0tvVm9hcmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 11:16:52.9642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b00d48-6501-412c-9128-08dcfe54844a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9342

On 06/11/2024 1:18, Alex Williamson wrote:
> On Mon, 4 Nov 2024 12:21:30 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> Add PRE_COPY support for live migration.
>>
>> This functionality may reduce the downtime upon STOP_COPY as of letting
>> the target machine to get some 'initial data' from the source once the
>> machine is still in its RUNNING state and let it prepares itself
>> pre-ahead to get the final STOP_COPY data.
>>
>> As the Virtio specification does not support reading partial or
>> incremental device contexts. This means that during the PRE_COPY state,
>> the vfio-virtio driver reads the full device state.
>>
>> As the device state can be changed and the benefit is highest when the
>> pre copy data closely matches the final data we read it in a rate
>> limiter mode and reporting no data available for some time interval
>> after the previous call.
>>
>> With PRE_COPY enabled, we observed a downtime reduction of approximately
>> 70-75% in various scenarios compared to when PRE_COPY was disabled,
>> while keeping the total migration time nearly the same.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/pci/virtio/common.h  |   4 +
>>   drivers/vfio/pci/virtio/migrate.c | 233 +++++++++++++++++++++++++++++-
>>   2 files changed, 229 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
>> index 3bdfb3ea1174..5704603f0f9d 100644
>> --- a/drivers/vfio/pci/virtio/common.h
>> +++ b/drivers/vfio/pci/virtio/common.h
>> @@ -10,6 +10,8 @@
>>   
>>   enum virtiovf_migf_state {
>>   	VIRTIOVF_MIGF_STATE_ERROR = 1,
>> +	VIRTIOVF_MIGF_STATE_PRECOPY = 2,
>> +	VIRTIOVF_MIGF_STATE_COMPLETE = 3,
>>   };
>>   
>>   enum virtiovf_load_state {
>> @@ -57,6 +59,8 @@ struct virtiovf_migration_file {
>>   	/* synchronize access to the file state */
>>   	struct mutex lock;
>>   	loff_t max_pos;
>> +	u64 pre_copy_initial_bytes;
>> +	struct ratelimit_state pre_copy_rl_state;
>>   	u64 record_size;
>>   	u32 record_tag;
>>   	u8 has_obj_id:1;
>> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
>> index 2a9614c2ef07..cdb252f6fd80 100644
>> --- a/drivers/vfio/pci/virtio/migrate.c
>> +++ b/drivers/vfio/pci/virtio/migrate.c
> ...
>> @@ -379,9 +432,104 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
>>   	return done;
>>   }
>>   
>> +static long virtiovf_precopy_ioctl(struct file *filp, unsigned int cmd,
>> +				   unsigned long arg)
>> +{
>> +	struct virtiovf_migration_file *migf = filp->private_data;
>> +	struct virtiovf_pci_core_device *virtvdev = migf->virtvdev;
>> +	struct vfio_precopy_info info = {};
>> +	loff_t *pos = &filp->f_pos;
>> +	bool end_of_data = false;
>> +	unsigned long minsz;
>> +	u32 ctx_size;
>> +	int ret;
>> +
>> +	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
>> +		return -ENOTTY;
>> +
>> +	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
>> +	if (copy_from_user(&info, (void __user *)arg, minsz))
>> +		return -EFAULT;
>> +
>> +	if (info.argsz < minsz)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&virtvdev->state_mutex);
>> +	if (virtvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY &&
>> +	    virtvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY_P2P) {
>> +		ret = -EINVAL;
>> +		goto err_state_unlock;
>> +	}
>> +
>> +	/*
>> +	 * The virtio specification does not include a PRE_COPY concept.
>> +	 * Since we can expect the data to remain the same for a certain period,
>> +	 * we use a rate limiter mechanism before making a call to the device.
>> +	 */
>> +	if (!__ratelimit(&migf->pre_copy_rl_state)) {
>> +		/* Reporting no data available */
>> +		ret = 0;
>> +		goto done;
> 
> @ret is not used by the done: goto target.  Don't we need to zero dirty
> bytes, or account for initial bytes not being fully read yet?

The 'dirty bytes' are actually zero as we used the below line [1] of 
code above.

[1] struct vfio_precopy_info info = {};

However, I agree, we may better account for the 'initial bytes' which 
potentially might not being fully read yet.
Same can be true for returning the actual 'dirty bytes' that we may have 
from the previous call.

So, in V2 I'll change the logic to initially set:
u32 ctx_size = 0;

Then, will call the device to get its 'ctx_size' only if time has passed 
according to the rate limiter.

Something as of the below.

if (__ratelimit(&migf->pre_copy_rl_state)) {
	ret = virtio_pci_admin_dev_parts_metadata_get(.., &ctx_size);
	if (ret)
		goto err_state_unlock;
}

 From that point the function will proceed with its V1 flow to return 
the actual 'initial bytes' and 'dirty_bytes' while considering the extra 
context size from the device to be 0.

> 
>> +	}
>> +
>> +	ret = virtio_pci_admin_dev_parts_metadata_get(virtvdev->core_device.pdev,
>> +				VIRTIO_RESOURCE_OBJ_DEV_PARTS, migf->obj_id,
>> +				VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE,
>> +				&ctx_size);
>> +	if (ret)
>> +		goto err_state_unlock;
>> +
>> +	mutex_lock(&migf->lock);
>> +	if (migf->state == VIRTIOVF_MIGF_STATE_ERROR) {
>> +		ret = -ENODEV;
>> +		goto err_migf_unlock;
>> +	}
>> +
>> +	if (migf->pre_copy_initial_bytes > *pos) {
>> +		info.initial_bytes = migf->pre_copy_initial_bytes - *pos;
>> +	} else {
>> +		info.dirty_bytes = migf->max_pos - *pos;
>> +		if (!info.dirty_bytes)
>> +			end_of_data = true;
>> +		info.dirty_bytes += ctx_size;
>> +	}
>> +
>> +	if (!end_of_data || !ctx_size) {
>> +		mutex_unlock(&migf->lock);
>> +		goto done;
>> +	}
>> +
>> +	mutex_unlock(&migf->lock);
>> +	/*
>> +	 * We finished transferring the current state and the device has a
>> +	 * dirty state, read a new state.
>> +	 */
>> +	ret = virtiovf_read_device_context_chunk(migf, ctx_size);
>> +	if (ret)
>> +		/*
>> +		 * The machine is running, and context size could be grow, so no reason to mark
>> +		 * the device state as VIRTIOVF_MIGF_STATE_ERROR.
>> +		 */
>> +		goto err_state_unlock;
>> +
>> +done:
>> +	virtiovf_state_mutex_unlock(virtvdev);
>> +	if (copy_to_user((void __user *)arg, &info, minsz))
>> +		return -EFAULT;
>> +	return 0;
>> +
>> +err_migf_unlock:
>> +	mutex_unlock(&migf->lock);
>> +err_state_unlock:
>> +	virtiovf_state_mutex_unlock(virtvdev);
>> +	return ret;
>> +}
>> +
> ...
>> @@ -536,6 +719,17 @@ virtiovf_pci_save_device_data(struct virtiovf_pci_core_device *virtvdev)
>>   	if (ret)
>>   		goto out_clean;
>>   
>> +	if (pre_copy) {
>> +		migf->pre_copy_initial_bytes = migf->max_pos;
>> +		ratelimit_state_init(&migf->pre_copy_rl_state, 1 * HZ, 1);
> 
> A comment describing the choice of this heuristic would be useful for
> future maintenance, even if the comment is "Arbitrarily rate limit
> pre-copy to 1s intervals."  Thanks,

Sure, I believe that we can start with your suggested comment above.

Thanks,
Yishai

