Return-Path: <kvm+bounces-17117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FCB38C10D1
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 16:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 809EC1C21752
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 14:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC5215DBBB;
	Thu,  9 May 2024 14:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TeiGo26r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F3012E1F6
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 14:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715263529; cv=fail; b=iQb2jTuHjdPUFOju2v7xCCvLJcRcntwaLIVEn6UGcNNYkvFQ7crwmVFayvJ8iimsF12YJWi70/l2BI8Lkr1lZR4CZ6wkDuk68ymko/Y6i4/UBNwywabGGMy/Vm/Yc1zRkZn8QqHOeohDLwVzEpKFVqvfpcbitxOfMg8l3N2HmkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715263529; c=relaxed/simple;
	bh=KEiV522bbxzcu7Hfi5zgcPC6/Gs8KH/qIlonYChjzzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=J8aC/hhPbr7Sxe0v7nbN5hf6cJMXIe+sog3AcS+EGsdIok5mFdgBeNg7iHedpfO3vso4VTvn+rtzSfB7nCMtDEXP8CtP0919DNshxR+RYk8a2CpX3xrYtf1/nuXpcrHMrFPzE0HGnwQBE1UtpLi7QWWpvo+Fv5CVw4sgD2HVR9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TeiGo26r; arc=fail smtp.client-ip=40.107.93.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DA7eTofJW3JcWTi/sM6rlH4ADMlqDX6mMcdUAa6gUUQ8sz3otSU21ePi+zbduI04/1N8MFTvTqNaktyP4Ovzmm6n9dJjpNje15mRMRyrBFe9SYE2C0iJR+HQDPwXosHmU1M/6sDxJwXzDmSpvi8IgDp5y/92lJjWHGtklwHfBFDXmmomNPPeuxyhRFuVnpZ7qPUsOWIDfBzlhDQUdVvPGTZ6jjvP6Y7RWmHpD4AChWfWLQbxS7XwhHwmkIIkGqvrdjNXwzIlJvbyCKh+DLD1FDItSELVu7fyiPugj3LzfvwFKDQbFJyULc03KnHpwJFKsIvqJtHYqy/mQER1f3NzGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=girc/h9tV5+WYIC9nL1dAL8UJhfI22IERLdKjhve9kk=;
 b=kDvjCtrrH+TARfhaNq3aH9QSLLOpm+iKIr3d07fnWjblvqqFnPJLay7K2Ehg+PvoBogHf+BC4+FLL44vewca1+2J1G/pDzm+QDrL1xS16nLRXkHzBSN3xsCsbkJRSn/Ne0LwNANu6VYxH/0Yi5ocqHtRG6oZit3Ggcj3/YwashdNnmG4CiUqHQ2zZ0bYzISgv7nWgj1LAI0a46zJqLl+0s/Dshg8oDLq6uEdzRqAKp3qcSYzezLJg+ve5/FSWUkZx73tB8gSb5mcoRQgyU/TLDDjkrJ+n4r3Az7BGhx07D3FWuIQKWvKtzG4RmTJk/6k9CxRCdyYv+Uj37szLo6j9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linaro.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=girc/h9tV5+WYIC9nL1dAL8UJhfI22IERLdKjhve9kk=;
 b=TeiGo26rMYzJ5GMQ6oHQni5d01z7n9I5GNkfC0eoweH241FIG7L/XwuEMr4jtW5jb1M25WBrPfiDhqfMNGcX5guia0waq8DeLLT0UK443ab0X6VZwNhr1ugoE61prM86YoOZV253ZADLKXR4lXIZbABiQnOa1ISBbB8NC38zX+4ZxdEnS8Ant88vHj2mgfnorUp9M48gK1IbgpSLbx4mD/C+M4hVqflfGS4Q/3YMu9ruVKYFBM6dBr7nZoV+28rVO7C986tLX+uGkztOzsyGCSykajSTui02FxQIlM6ss/BOy9hJWLJ4igBtNuWmNdQzPLH87yi0speGuKrJppDvRg==
Received: from BN0PR04CA0148.namprd04.prod.outlook.com (2603:10b6:408:ed::33)
 by PH7PR12MB6468.namprd12.prod.outlook.com (2603:10b6:510:1f4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Thu, 9 May
 2024 14:05:18 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:ed:cafe::a7) by BN0PR04CA0148.outlook.office365.com
 (2603:10b6:408:ed::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46 via Frontend
 Transport; Thu, 9 May 2024 14:05:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.18 via Frontend Transport; Thu, 9 May 2024 14:05:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 9 May 2024
 07:04:46 -0700
Received: from [172.27.21.166] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 9 May 2024
 07:04:45 -0700
Message-ID: <cff7ba09-2437-45f5-93ee-e5d941e550f7@nvidia.com>
Date: Thu, 9 May 2024 17:04:43 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] vfio/mlx5: Let firmware knows upon leaving PRE_COPY
 back to RUNNING
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: <kvm@vger.kernel.org>
References: <3412835f-4927-4c9a-830d-4029fa0dc7e0@moroto.mountain>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <3412835f-4927-4c9a-830d-4029fa0dc7e0@moroto.mountain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|PH7PR12MB6468:EE_
X-MS-Office365-Filtering-Correlation-Id: c04fd7be-8038-4109-ea3d-08dc70310eb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|36860700004|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXdKYWdrYnFNOTB5QjgxRHFGUzREMU83RzU1SkZMSUFjS1lQMUJyUjhLczNW?=
 =?utf-8?B?eU50TmtXcmtnVHl4bFBnamI4UFRkbnVmNVdRbWVIUkc5L0E4RC9VMUZ2Mm9s?=
 =?utf-8?B?RS9mZ0cwOHBWbWFIUWg5QUtsUzd0ZXNTenJUOUlNeTdFaGdVNEVnV0xFdU5L?=
 =?utf-8?B?NXdUZUtENUcxV3dPdkJ6UVhhY1hMUHppcHpMTGI4c0pndXlJdGdLUDh1ZDZJ?=
 =?utf-8?B?dGVNZWc5MXFEVnJubnpYUk56UnFmNjVTK3k5Uk9sVjBRUjhzSnkyQm5YYzFB?=
 =?utf-8?B?dy9hUTF0TjVYNkhnbDlldWxEY256SWlZSFlJK0x1cFZIS0tIWmpHNTZrL0dO?=
 =?utf-8?B?N0s1ZjNWSHEyajRmRGxHbGhmTTlzRGdHRW5FbFVPUEtiTHJPeHNLVkh4Z0hU?=
 =?utf-8?B?U0V0K1BPc2RianB0UExvRWlma1A1S1B0WXhic3BsUERnMUx5OWY3dDl0YVhy?=
 =?utf-8?B?c1dFNFhvczdTQU1BaUY1bnQ4MUVpUGM3UEc3WEVhdnVIRTlLME1YQmF2bzha?=
 =?utf-8?B?czBqQmphZDlOZ1BUZGx6SEdEOVI0MWVoOFFFODZhU21WN1BDczZKZ0lPYTc1?=
 =?utf-8?B?K1FESXBxUkFQaUlyOXZqQVZEUkNsbEtITWx1TFdVRExTNzFHOFhKK2dWSm5K?=
 =?utf-8?B?cGU3RzArWHdxSTJlbm1CMVZ1UDJVZGRNYUwvU0FscnVyd2l2eHlZQjZqOStl?=
 =?utf-8?B?d2hDdjduT2FJWEpQWHZhNUE1RkF3Und4d3dzMjYrSmhtY2xLckxwMzN6cWRD?=
 =?utf-8?B?RXBJR2FPNDhjQndaSnV1L0J1My9rZTFmVnYxQUd6UkJkcm1zVUlEZWlVSkQr?=
 =?utf-8?B?Ry83aTB3WWtsNm5KZXRiQ3dISzRzODE2YjRLeG8vV1J1dDRUZXVFSTZrcWdV?=
 =?utf-8?B?M1E5V1VGaTREUmtBRDRRVTZXYXhNNUFDK0c5MEZzOFZWTmJDdE9zNkVyVDdP?=
 =?utf-8?B?Wm4wWU44NVp0SXI2ck9GSEhGTjNZNUUrUHdZbjV6S0ZwdGNGYXRibndjeHFS?=
 =?utf-8?B?UE5Kc3JuREwycFFQcS84R1ppTit4cHBSNVN2REdUMy8vTHkrR1hlQnZSVnRz?=
 =?utf-8?B?SStHVml4NWJvNnFSU1lEUTFJQVRXRnBFWnNKWnRMTzJ0cTFWQ2k0dGhIdSs1?=
 =?utf-8?B?Zk11QUUzSm12RXFWYWlydXBKWFdZeTh4aC8vNWEzaXFqR05qR0FkNVovWlVR?=
 =?utf-8?B?UFdLcW1NOVdzTlZkaWtDdy9Ra0FUS0xPLzVvRzFRdkdqTjliNzFoTFRlRnk2?=
 =?utf-8?B?Qnk1L3F0WitwcWpiMGMxYXhlblk4VFhSNWd3VE5CSDd5L1pCYU9DU1dtTUZZ?=
 =?utf-8?B?alB6YzNSNWFRc0JPRElmUnpTdWZkVTBGU0RVdjl6SVAvSC9WT1hzUi9jb2JM?=
 =?utf-8?B?RklQYXZLbnpKa2FRcUlUUHoxYzRHT1RzbXdJQStZM0ZJUnV2bXh2dk1qSnl0?=
 =?utf-8?B?WEVDZXZkSWNBRXB5Y1k3OEhkcllqTW9JUmNyeDZzWStUaEF2a0V4ZjVpMVJC?=
 =?utf-8?B?eHlEM3RCU3VLUFNJd2Y0NFY0b2JGRnhneWpXSHJmMUVGQ3VWMEg2YkJzNjNr?=
 =?utf-8?B?c0MrenFhUlJEQW5iaXRYYUxyeUJCTkp0UVBUSjUyUWdxaFU2QTlZV1MzSDds?=
 =?utf-8?B?WmlsazNoNURQN3NpZ3JoQWYzd21PWnFUWUZyQy80MVYwbzBnbFFZUEV3RVBV?=
 =?utf-8?B?UTgyeDdaRjhscVBUVGFWT1R3K21qWE90WWxNR0dOOHNiVVgrMEd5cFRPbnpW?=
 =?utf-8?B?dkFJaU5UUlFGUDViWWVzNGwyNENtRlJPc09hUlhrbGcrQmhKNXZDeUdTNHhU?=
 =?utf-8?B?N2N3UmtHVGkxdXdSS0ZETjdQNE92K2N2MXRwbHA5ZHBEcTl1czc1UWlTWWUz?=
 =?utf-8?Q?07xCoAj62pAi/?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 14:05:18.0378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c04fd7be-8038-4109-ea3d-08dc70310eb7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6468

On 09/05/2024 16:36, Dan Carpenter wrote:
> Hello Yishai Hadas,
> 
> Commit 6de042240b0f ("vfio/mlx5: Let firmware knows upon leaving
> PRE_COPY back to RUNNING") from Feb 5, 2024 (linux-next), leads to
> the following Smatch static checker warning:
> 
> 	drivers/vfio/pci/mlx5/main.c:1164 mlx5vf_pci_step_device_state_locked()
> 	error: uninitialized symbol 'state'.
> 
> drivers/vfio/pci/mlx5/main.c
>      1142         if ((cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
>      1143             (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
>      1144              new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
>      1145                 struct mlx5_vf_migration_file *migf = mvdev->saving_migf;
>      1146                 struct mlx5_vhca_data_buffer *buf;
>      1147                 enum mlx5_vf_migf_state state;
>                                                   ^^^^^
>      1148                 size_t size;
>      1149
>      1150                 ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &size, NULL,
>      1151                                         MLX5VF_QUERY_INC | MLX5VF_QUERY_CLEANUP);
>      1152                 if (ret)
>      1153                         return ERR_PTR(ret);
>      1154                 buf = mlx5vf_get_data_buffer(migf, size, DMA_FROM_DEVICE);
>      1155                 if (IS_ERR(buf))
>      1156                         return ERR_CAST(buf);
>      1157                 /* pre_copy cleanup */
>      1158                 ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, false, false);
>      1159                 if (ret) {
>      1160                         mlx5vf_put_data_buffer(buf);
>      1161                         return ERR_PTR(ret);
>      1162                 }
>      1163                 mlx5vf_disable_fds(mvdev, &state);
>                                                     ^^^^^^
> state is only set some of the time. 

The 'state' will *always* be set in the above flow.

As we are in the source side of the migration we have a valid 
saving_migf (see line 1145 above), as we pass in a non NULL pointer for 
the state, it will be always filled inside.

  We not just make mlx5vf_disable_fds()
> return an error code?

mlx5vf_disable_fd() is a cleanup function that can't fail.

It just holds/sets the state of the migf following the completion of the 
asynchronous SAVE command that was issued in line 1158.

So, it's a false alarm.

Thanks,
Yishai

> 
> --> 1164                 return (state != MLX5_MIGF_STATE_ERROR) ? NULL : ERR_PTR(-EIO);
>                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Uninitialized.
> 
>      1165         }
> 
> regards,
> dan carpenter


