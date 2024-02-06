Return-Path: <kvm+bounces-8086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 865C984AFA0
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8C181F236DF
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD84E12B176;
	Tue,  6 Feb 2024 08:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZMZFT9nn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1794712C807
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 08:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707206791; cv=fail; b=g2lBXXdJY2SEpL7eI2574lCkGGxWwBqbz9CY8QqskY0dAk62mHCYoqxox0pBHh+xuc/lUwwBCTF3eYQluCLYZ+4Y4AsLp7ZIE39JrD1A7PKqfJyT40l7cnHUVqRetjA3kwv5CZHBXEFKVDvXPoS96iNAJfknCjYy7r/jF02oYnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707206791; c=relaxed/simple;
	bh=SnoUG5uHM320Q00n7vNw8JLkWqYAKHkYnVfcZD/zj2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HQvbhy68zGVCb5Jv/P2CrUzXFXnq1+MRAbOhYQq2rOMST3waKX/jD02n0xT7VNFIUiOCkUYyadMyPp9He7egL8SPTCwQytGt+H/bRwhKO6hFZ5hmjLbR4P+uMmN6rSkAEdO4gLjpuUBQqkocUVFO5TP/CFB1jwmtJA+C7mj1z+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZMZFT9nn; arc=fail smtp.client-ip=40.107.223.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUikaKbzJK1BuuoQX+ka3Ph/Uk4CLEvjE2tBkigK8WBLqJu2Sj9jTqpzrCjW8PevAdxxeXjc8yozRFPlBLnS0Cp6V1Qb0z5CkzKx5JamhvlMEoPyBfIt4se6PwU3G7hLTA2Y5KPtJAShloPsQsS+0jaCcZceUtjajs0w0PDad6U+ZldfzGT1+2WEsaLD4qPunG6Ghqo20u/UmQGVa+p1/GlDxAC3FxS3qfG+sp+6TXmqIPRYyhS6+1Ze/l88pCnBNUfld9Qcx6NobhPkOSXDGKO+UdWEUdmfzc5sj1e0uVcOyoKNMlMVx59XfRdEfIrR2kr6nVtfDAadx5HhON/XsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0sMEcCVwqjAya2aEIkBi2LaULPT4jiZRz/rxLaNTxE=;
 b=Le3lrCDKFgYWnfu7zTgf07HQMXCApnuzmlL8BJJkuhMQk9+YbQJdZCBOjI4PIiVcJz5KvwhEMNTGU+GUQfRAKL6MH5oEDx3hOBLp3CJ6seSodvpuRtNeJKesqd+yA56kX5oRDmLvhaaCSGA7suaSEJC4B/HMso+UttBJEqnGW+pY+S0i0jqims0i/YxrolMyc9r8D2ptM688mxBODQ026f1LNVPz5DbqRxoAY1gbMQ0rR4xASbrS6CjEiKdjIw5V8X+6YoPxBFnfZHy3mfv8HgPxdc4OktO4sKXIJvbxMcyMCnl2ba1yewFHZygvQ8kODqc5I65tKayhIwE2odOZ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0sMEcCVwqjAya2aEIkBi2LaULPT4jiZRz/rxLaNTxE=;
 b=ZMZFT9nnVCw2Z3JbZQnBCWAHtVm/14iFwJlndxtjTj9WJGFOpq0hskP9DdybPbn9WBo/7qJ6ym+lQVYS2DxJyHL0hSuy5h8nk7M/gnX2KxLhUfjgEpoVb8Uf5qw8Vb6J4OvXspMe6yMzBvhfGhN1wdmlaDVb+55Ca8qSCSDKSzCb2lkgtG6z35g6OCfcpa+fuhHFyFGmaKQXmb3cgQsxnl1AfGuedsj1wBdcRIDZkuL8bX4OL577ea/J6gd3UM1MA/DxWdk6BgZNKC//+NWVVpM8VHYZry7WecDju0ZY3a6evfrLV1fH5lRTxX67/3JWNnmsk8bUIHypkdy/FCb8IA==
Received: from CH2PR07CA0043.namprd07.prod.outlook.com (2603:10b6:610:5b::17)
 by PH7PR12MB7140.namprd12.prod.outlook.com (2603:10b6:510:200::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14; Tue, 6 Feb
 2024 08:06:27 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::4d) by CH2PR07CA0043.outlook.office365.com
 (2603:10b6:610:5b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36 via Frontend
 Transport; Tue, 6 Feb 2024 08:06:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Tue, 6 Feb 2024 08:06:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 6 Feb 2024
 00:06:15 -0800
Received: from [172.27.58.121] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 6 Feb
 2024 00:06:12 -0800
Message-ID: <1175d7ed-45f3-42d0-a3cb-90ef2df40dbb@nvidia.com>
Date: Tue, 6 Feb 2024 10:06:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 0/5] Improve mlx5 driver to better handle some
 error cases
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
 <BN9PR11MB527688453C0D5D4789ADDF968C462@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB527688453C0D5D4789ADDF968C462@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|PH7PR12MB7140:EE_
X-MS-Office365-Filtering-Correlation-Id: 695f819f-5db0-453c-cdb0-08dc26ea8478
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	54wsJgWsGD/i0eUyC6ZjePESfVkimthZ9SBIou3JR3UaNl/kZWNrBE/IwSe+BM2g8fY7mNe5s7Nzd7uvX0Nc9ei/fSbh2xhbu0pNrcQzlz4iP7TPWVR5kzIqr94VdVuO83pXWRJPYTzjecynNVDX7k0t/X0HystPXPXEdN9NsL4fBiwzzpPjI1C5WvBCCf18fcm+GQ94XImmATGzBSvuzoGVbjZ0V6MuTSqBx8DJsm9YzHzfIbv6DoeXdZKRbzTKaj3fZBxf/dE0tkmRyXGTmV2vd9OQIN21qd0dxRa9oepnijMFX/9B2LYicj3B90NcGkGSVXBUiwb3AOtMJ2wXeuvsmD6s12afY+UDMEguchCZxWb8zDiGOD4iDiC1ac6nnaaVn8SmZdnVXnb8IAyRewHc1+WJhLRxBz2Vd1MBVuywBMO89V+Pmm0iXF96S+pkRZtoL2YoPIG0imv/gSYRmhySLD/6nSLk7ttpwfvMK0YF2fIfn8whqNl+mY4m5WsA2U8lxAnSz52pnbU3+zgYaNhMCzkvmbAzu7C2R3IiE/eHzsfeZL+ocVnucQnwew8wqjuhNWoTiZbihr6Qeeu9vP0as2UCdV7vHkP0qEGpBGJ01nSlFychtpRLNPoVMiluuJy8pmaIxwwPPDtQIdC724369W6UBK6HkZS2AETQPWdOrWgRzPmemHd/zRIfHLpiNHs4vmUbF9oAYnyudTQpf9jU3Musmx2iolFC20+TbZ6HN0sDLaMxlz+/fj2N+ck+6UWxtLvP6gAKw4tWduev8pweV4kjYmaxEtDi7/4w/wPcx/coyMX8O538ReyzNLid
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(82310400011)(1800799012)(451199024)(64100799003)(186009)(36840700001)(40470700004)(46966006)(2616005)(70586007)(966005)(2906002)(8676002)(16576012)(4326008)(110136005)(8936002)(31696002)(5660300002)(86362001)(70206006)(82740400003)(54906003)(316002)(36756003)(36860700001)(47076005)(7636003)(356005)(6636002)(478600001)(53546011)(83380400001)(426003)(107886003)(336012)(41300700001)(16526019)(26005)(40480700001)(31686004)(40460700003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 08:06:26.4917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 695f819f-5db0-453c-cdb0-08dc26ea8478
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7140

On 06/02/2024 9:35, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Monday, February 5, 2024 8:48 PM
>>
>> This series improves the mlx5 driver to better handle some error cases
>> as of below.
>>
>> The first two patches let the driver recognize whether the firmware
>> moved the tracker object to an error state. In that case, the driver
>> will skip/block any usage of that object.
>>
>> The next two patches (#3, #4), improve the driver to better include the
>> proper firmware syndrome in dmesg upon a failure in some firmware
>> commands.
>>
>> The last patch follows the device specification to let the firmware know
>> upon leaving PRE_COPY back to RUNNING. (e.g. error in the target,
>> migration cancellation, etc.).
>>
>> This will let the firmware clean its internal resources that were turned
>> on upon PRE_COPY.
>>
>> Note:
>> As the first patch should go to net/mlx5, we may need to send it as a
>> pull request format to vfio before acceptance of the series, to avoid
>> conflicts.
>>
>> Changes from V0: https://lore.kernel.org/kvm/20240130170227.153464-1-
>> yishaih@nvidia.com/
>> Patch #2:
>> - Rename to use 'object changed' in some places to make it clearer.
>> - Enhance the commit log to better clarify the usage/use case.
>>
>> The above was suggested by Tian, Kevin <kevin.tian@intel.com>.
>>
> 
> this series looks good to me except a small remark on patch2:

We should be fine there, see my answer on V0.

> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks Kevin, for your reviewed-by.

Yishai

