Return-Path: <kvm+bounces-72320-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gFyfOKs0pGnwaQUAu9opvQ
	(envelope-from <kvm+bounces-72320-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 13:44:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC101CFACB
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 13:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1204E3013B55
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 12:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084AB3242B1;
	Sun,  1 Mar 2026 12:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BZe2BWhT"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC24322C77
	for <kvm@vger.kernel.org>; Sun,  1 Mar 2026 12:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772369056; cv=fail; b=q1lgzPmjeU+9R6RqS3uSjCsZzFDFE7SMJ80EwH5qxGGM16kDmPKdicQt/iqAaREDj8sh7yw5lbivjRGAKcr28f/Ulk9ZccEr+Sh67ZAGjzT9jtOjGEUV3WSm4rFKnMdWAGRa6NmExcKmMonkbK4PVEBn3JAv8efcLu4n1qGE5pA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772369056; c=relaxed/simple;
	bh=Xw8U9l0preP2sd+OL7XMIyT1AnEeZnI3SzTjR//UO+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OGLOQ3yJOyqH67R7qXyvLp9YRu0zighCzfJRfCIsUzKjAaQSkBrZALlZqw8BeWkpYDLqcxmrzxW2vg3CJdBeDHsmyXIsKP1oT47TJgIshOcI2DbPVfpXkBVmCkt3ZhQtI8RQOws28QxNXiavimrVGr18yPKboqfNm9UaTo7A9Nw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BZe2BWhT; arc=fail smtp.client-ip=40.93.195.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3pmHt/HYHuV0dDp34tsXSMITRvXtmiWpmOoMstTbUjVJgw929e0VMG3th6vctsmtBCFTHGHZZ9u+FgjLcqhO25Te0rKFeCiuINGvFlyLtNy6g6OqAcR4LBkwuRdOAMQQPcD93EGYMFIVZtT+d3XAqKJ1pGeZ3ByT53Fy5UdObieCUcaZtIK8FxfYdJdjEWMZKgZTEaFM4quffFBpxOmURty7ZkaVYPJrRJB7tU7UCYmbNrmkOmlDwWLLR103zxVk/MEMFcKW/kZChL0sLBGo1n30+qtWLc38ZGMu9DVeFFQGMUjYm0mlI/3I/Z26hLs3qFqHyGP6SlZB0B8ObCrZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxYQtzIaHanEH/spw4wJjrNvsznRJgoz0oWLqjJi6iY=;
 b=GpQqdyIJEmldSl0j8G8+9WaEfGeUFxNkTyMqb9Du9mOqLXes2BsRQ79uOdEe7RAbnJjtXluaZMUv//PEe7XWuC7dXrf4zMM15XByfTT5QAUNswtqymowqZeg4Rp2+UwfGLePAOyEANYUNIt8RXP5asYq86tqkSgb2V/sdukzCjapy/XwsHH9Sfwdz/wO9LyD9O7FBUbLKecF5n9vddcKkaKaYRn2auLLy07wPxgVbIVQdU0pPiNmejXXD5+io7H1vbxy0zsy5YZ2puKU+kImws1B4D4plMSSqFraILUvRQ5o1SINlyOpWb4Z9/QCPlL7V/9jn0K8oxlxAqF905kKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxYQtzIaHanEH/spw4wJjrNvsznRJgoz0oWLqjJi6iY=;
 b=BZe2BWhTJxIci7dmOEfksPG3503jmVd9TG8u6z8+EpCJGmi4VwVeOT+1Hqo/dt/bOK+mJ5fklInYqI2+g2YlRsXU1IUUISSPGJSTD+2UsfSQHwi6hZhXhqW9w3KO54TMZZ2whfTMwLx1zEDkqqLF7vDvDdZD4LBDaBXbhWdiptrxZadhotnum6gWBrRvTBl1o15kmHH+B9g/gT4nWNKfynKNYAkl2RlusAD9/ArRtqhWWMCBdQCHLaHSoiNGtugJR81WprI4sd08JKO6ACJ26htKvSFvqO+ZR7xlNMTXfvnJSggBTWA7Jxq8N7Oo9uP11nSOm36HRo0Dwi46e07+ow==
Received: from BLAPR03CA0048.namprd03.prod.outlook.com (2603:10b6:208:32d::23)
 by BN5PR12MB9537.namprd12.prod.outlook.com (2603:10b6:408:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sun, 1 Mar
 2026 12:44:09 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::47) by BLAPR03CA0048.outlook.office365.com
 (2603:10b6:208:32d::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.18 via Frontend Transport; Sun,
 1 Mar 2026 12:44:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Sun, 1 Mar 2026 12:44:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 1 Mar
 2026 04:43:57 -0800
Received: from [10.221.201.202] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 1 Mar
 2026 04:43:53 -0800
Message-ID: <b16fc66f-bea8-4b42-ae68-8e37a6d09bda@nvidia.com>
Date: Sun, 1 Mar 2026 14:43:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio 0/6] Add support for PRE_COPY initial bytes
 re-initialization
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, Alex Williamson
	<alex@shazbot.org>, Peter Xu <peterx@redhat.com>
CC: <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>,
	<avihaih@nvidia.com>, <liulongfang@huawei.com>, <giovanni.cabiddu@intel.com>,
	<kwankhede@nvidia.com>, <yishaih@nvidia.com>
References: <20260224082019.25772-1-yishaih@nvidia.com>
 <20260227132327.3e627601@shazbot.org>
 <f74867bd-02b0-40d8-98be-c22a4129320a@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <f74867bd-02b0-40d8-98be-c22a4129320a@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|BN5PR12MB9537:EE_
X-MS-Office365-Filtering-Correlation-Id: ebc541f2-7d30-43e1-dc5b-08de77903bf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	1gyHf2IY6bosP1lrKjlpZcTA4fgR9Blcrf3MOUSjBoMLj+WsskQoh4GF2DlVoNIn7OIiuNsMDTrYIexHg2hCB6EnOcuJer3D7cxphg495sT59FmVWjTWQudGLGLuqzezngNXyISWQ9LFuc5HA67Rzn8mFObKD3DtG7uOPXNqMSd8kg6N3BE5ENmGQKO12h2RSpKJqGPEgxivjUBGM9AhMx8tGkiACXOB1n6EuZd7AjLabLEKqsZ+6o1+3a96QbVKQx1atzVyWTZQMr86pr1K59O56Mx8ahEuHg6YYSItj/aDqLF87ZwfZhSoOyoJFHJcAlvR+KlDrBYz7SbhaDKp8c1fPD9paN2vPW4tF3rR+VGO8Wei1Xmn+1tQ4IKF8vbwBJNQCjQLHsmTj6m6EeYAOODJFyJfeQK6EQPosS7WyUPKdh9n18+z5yj8AIUmSW0VwIJWESA0CXgBS9+K2srUg44uQXauYHk9Z+rMDRv/AufLbcpsxuD4qA4/aYIHklRlf5Hg5x4jUWYKgGktRIjiBeqJsM8hEbvzabXXKroTKe40EDh2iQJku0rZvbDW4a4WIX+VvUvlyFdCNGeX/gZwXGTWlTRslrYuixqNE5JM7WxGaK3X+GtGdQ4Rv9OmqwQAZ50fVJwUX2U/lZ0P/XUhXe5cR1DvoG3IUSVa3h5AvGu1ml6gL2kgbgNu3oe6Sa9U37yGuK5RN3DoxML1vRu/Z7dQCRPIVtvXtk780IOkCqV0eqllbNjxdkbJr95RL4WGVrm9KKBQbceNoVPQEzNUdnuE0unQTVKUDwFVBR2+ksMpIqW1oRHFG9lCh9lnzp8V+6ySoY34tCl/Hr24mk0DxQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PhFAbDoL3YWDHwLWv4RQE+mV6gbKdqHslvURO/WmhoRAFHEQXzlR8aVh6IYMdn+V1O8I/TFKRffYZFEyrf2CZ8mP8+mG5q2Z6hkv9zjK13I474b+83LYWVgfuOH5d99jzAT5fwBT/E02EGW5qa/3PdrcZ2lKnH77MmOyinVdE0aJCZk02HuZTZM2C/Wr/wxPsnaoUzvmbMgcgD8EvlUWlkJMzH9wYbAj8SXmSkHxdTs+mtgf20p4DiU6zdhg+JJmgEAQXugiG1Is/UQEKP5O5bUf++x7hDAsNi1+DQR01Y01DCNHsdsoM2sOTT2my353J9t/cCinPidcevlvB/CsuHPi37YlZwHi//vq96VgugVUl85XxDthcK7nRu2DRY+rL+LvzVBa8dSV9OaWZDY14wWLZhrhh5sN6hJ0iWUW9y8IMJeSws1ZMDbjCHZg/i0z
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 12:44:09.6416
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc541f2-7d30-43e1-dc5b-08de77903bf7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9537
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72320-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email,Nvidia.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yishaih@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 7FC101CFACB
X-Rspamd-Action: no action

On 28/02/2026 8:27, Cédric Le Goater wrote:
> Hello,
> 
> On 2/27/26 21:23, Alex Williamson wrote:
>>
>> +Cédric, +Peter, please see what you think of this approach relative to
>> QEMU.  The broken uAPI for flags on the PRECOPY_INFO ioctl is
>> unfortunate, but we need an opt-in for the driver to enable REINIT
>> reporting anyway.  Thanks,
>>
>> Alex
> 
> 
> I took a quick look. The series would be a little cleaner if
> vfio_check_precopy_ioctl() came first

The motivation to introduce that core helper and adapt all the drivers 
to use it, was to centralize the common code and ensures that output 
flags are cleared on entry.

This can be done only after that we have the previous opt-in patch as we 
would like to keep the V1 behavior for compatibility reasons.

> and some parts are little ugly
> (precopy_info_flags_fix). Will take a closer look when back from PTO.
> 

I'm open for any better name, any specific suggestion ?

> Is there a QEMU implementation ?

Yes, please see here [1] the candidate QEMU patches that the kernel 
series was tested with.

[1] https://github.com/avihai1122/qemu/commits/vfio_precopy_info_reinit/

Thanks,
Yishai

> 
> Thanks,
> 
> C.
> 
> 
> 
>>
>> On Tue, 24 Feb 2026 10:20:13 +0200
>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>
>>> This series introduces support for re-initializing the initial_bytes
>>> value during the VFIO PRE_COPY migration phase.
>>>
>>> Background
>>> ==========
>>> As currently defined, initial_bytes is monotonically decreasing and
>>> precedes dirty_bytes when reading from the saving file descriptor.
>>> The transition from initial_bytes to dirty_bytes is unidirectional and
>>> irreversible.
>>>
>>> The initial_bytes are considered critical data that is highly
>>> recommended to be transferred to the target as part of PRE_COPY.
>>> Without this data, the PRE_COPY phase would be ineffective.
>>>
>>> Problem Statement
>>> =================
>>> In some cases, a new chunk of critical data may appear during the
>>> PRE_COPY phase. The current API does not provide a mechanism for the
>>> driver to report an updated initial_bytes value when this occurs.
>>>
>>> Solution
>>> ========
>>> For that, we extend the VFIO_MIG_GET_PRECOPY_INFO ioctl with an output
>>> flag named VFIO_PRECOPY_INFO_REINIT to allow drivers reporting a new
>>> initial_bytes value during the PRE_COPY phase.
>>>
>>> However, Currently, existing VFIO_MIG_GET_PRECOPY_INFO implementations
>>> don't assign info.flags before copy_to_user(), this effectively echoes
>>> userspace-provided flags back as output, preventing the field from being
>>> used to report new reliable data from the drivers.
>>>
>>> Reliable use of the new VFIO_PRECOPY_INFO_REINIT flag requires userspace
>>> to explicitly opt in. For that we introduce a new feature named
>>> VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.
>>>
>>> User should opt-in to the above feature with a SET operation, no data is
>>> required and any supplied data is ignored.
>>>
>>> When the caller opts in:
>>> - We set info.flags to zero, otherwise we keep v1 behaviour as is for
>>>    compatibility reasons.
>>> - The new output flag VFIO_PRECOPY_INFO_REINIT can be used reliably.
>>> - The VFIO_PRECOPY_INFO_REINIT output flag indicates that new initial
>>>    data is present on the stream. The initial_bytes value should be
>>>    re-evaluated relative to the readiness state for transition to
>>>    STOP_COPY.
>>>
>>> The mlx5 VFIO driver is extended to support this case when the
>>> underlying firmware also supports the REINIT migration state.
>>>
>>> As part of this series, a core helper function is introduced to provide
>>> shared functionality for implementing the VFIO_MIG_GET_PRECOPY_INFO
>>> ioctl, and all drivers have been updated to use it.
>>>
>>> Note:
>>> We may need to send the net/mlx5 patch to VFIO as a pull request to
>>> avoid conflicts prior to acceptance.
>>>
>>> Yishai
>>>
>>> Yishai Hadas (6):
>>>    vfio: Define uAPI for re-init initial bytes during the PRE_COPY phase
>>>    vfio: Add support for VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2
>>>    vfio: Adapt drivers to use the core helper vfio_check_precopy_ioctl
>>>    net/mlx5: Add IFC bits for migration state
>>>    vfio/mlx5: consider inflight SAVE during PRE_COPY
>>>    vfio/mlx5: Add REINIT support to VFIO_MIG_GET_PRECOPY_INFO
>>>
>>>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  17 +--
>>>   drivers/vfio/pci/mlx5/cmd.c                   |  25 +++-
>>>   drivers/vfio/pci/mlx5/cmd.h                   |   6 +-
>>>   drivers/vfio/pci/mlx5/main.c                  | 118 +++++++++++-------
>>>   drivers/vfio/pci/qat/main.c                   |  17 +--
>>>   drivers/vfio/pci/vfio_pci_core.c              |   1 +
>>>   drivers/vfio/pci/virtio/migrate.c             |  17 +--
>>>   drivers/vfio/vfio_main.c                      |  20 +++
>>>   include/linux/mlx5/mlx5_ifc.h                 |  16 ++-
>>>   include/linux/vfio.h                          |  40 ++++++
>>>   include/uapi/linux/vfio.h                     |  22 ++++
>>>   samples/vfio-mdev/mtty.c                      |  16 +--
>>>   12 files changed, 217 insertions(+), 98 deletions(-)
>>>
>>
> 


