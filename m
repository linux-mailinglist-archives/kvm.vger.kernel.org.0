Return-Path: <kvm+bounces-8301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 490FC84DB2F
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 09:17:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 776181C21DA9
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 08:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0E06A03A;
	Thu,  8 Feb 2024 08:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kkO/6Chl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A986A6A032
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 08:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707380229; cv=fail; b=NR5n0DBc+QTwIufDLNbbaMIWKLJQpTxcvW2FlosyoPASjBNosVerqHtyrEjEoxiH5O7FWNf69BKxl83KUHtHwHdsrlRuWyZvx5LKp1/+8xziXsU4xgr4WZfpGvXJtG0eC8tFhE/WhWYaAejEoCjerdlnvwZK32Ba8hPd9moYBnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707380229; c=relaxed/simple;
	bh=YeIvdRoFHZ7KW9Kc7FsaM6lEqfddOfgzR5dJ2QrzHFk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=ncj+8qZ80x0um24a8eKq9mEqf2zHwlCorDKY2/nt9prntbmQhGQ7D/1RHBv/KdcjVfp/nsHhdfmFWEFTLA1YEAbsp0yrlLFLQs3fmPxWEVIB6npskDOc8xQvLLjNyj3KAXbsph+9u0C8DzeQVJJ6RVZrP7dFYN5kelycg5nemX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kkO/6Chl; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Na2Xl/Z7+PTI/EJFwDCoSBOks3yPgRAhLEG8ZQcFiSwTYIa3tdxdGbHMxNwz5AWUJ6Iwki2Eir07bbfCuocp7tFRi4onf6TDlwQv8/7nI9b4d/4zgDHGvXoF58THIXOV7kPvWa8dr58MwB2REgLqcJvkNm4D7FuGrMbw1rY8b6jpV4qznc+PBq51uGZL+Y+5J6P6+xgnpRx4+AwTcfwPB4aUxNHDq9vZpMdYinmLpxd2LKxo/wNFvxqCgj0LSCZqmJzhej7PPNU3e1VsQXcEG2EkBFUCA47wfeGnKHa4VQVwLHDwmty19j3GZZS6OESwS69KomV6T59oQ6a94oBkeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jp0d3OxwLVuiqkFeh9nkHl5p6OCFBSCIsTwm7dSq0OI=;
 b=G8acduOGHJiIB3mAFD4JIqGSKIomAcfe//grpGCdkSU0dz7KWGOgtwlrHxwEdvDWs0N4hHcfF02PMWDrrVmkmZIkCJhiQS6cAQ05vlL0hzUEad1EsFOFg3BEcmdbY1+St9aXiL6IVQvDp7007r7BOGluAEizG0yIstPpUZGzICpTX5b288UJqOopnOIrLz+0H3FKpSKQLhP5HjYEccCaquHNUbYBgWCfEzhmhGnmWIm/eVOFdejvd+XyAOeBTrYvtkmy5H0BoTuQLWtDJpTcX5ydd2A02fG9+NlORRyMCjBUO7KtzoDqWaQTrVJ2zTYHT13zVpdQwX5kRwdBudYfNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jp0d3OxwLVuiqkFeh9nkHl5p6OCFBSCIsTwm7dSq0OI=;
 b=kkO/6ChltnkYH1wk2x1SKjawHaCj4Bk1uPh38OaKc57+spDdbUZhmzqKMqXHgP0xvPQXHEnkneCL910p8+ynuuzT09W9T8zNTxblxNP4NIJFiDFwg0lZqfs1GBOPlMl/aiTwgrnZWdXfxL3gTmUAbnZ4brZcxaRmlNUtOpaPz29/0nrak+f1WtLJyyudjWqAUjh/Dcxw+PdUSHXj3r3CDi8oIDE2fqorVHcz4BLzwqDM3xV5jVMUYXLZ10eN3lxfgAy3FK6Q2ulbwC5ME/pWDv0Brhz6JMctGA+T0N+zzCSU0Oeclux9rsWzBInv+QT4MBf1NNew4wZyMBEp+g8qsQ==
Received: from SA1P222CA0072.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::28)
 by IA1PR12MB6578.namprd12.prod.outlook.com (2603:10b6:208:3a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.10; Thu, 8 Feb
 2024 08:17:03 +0000
Received: from SN1PEPF0002636E.namprd02.prod.outlook.com
 (2603:10b6:806:2c1:cafe::35) by SA1P222CA0072.outlook.office365.com
 (2603:10b6:806:2c1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.38 via Frontend
 Transport; Thu, 8 Feb 2024 08:17:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636E.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Thu, 8 Feb 2024 08:17:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 8 Feb 2024
 00:16:56 -0800
Received: from [172.27.60.2] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 8 Feb
 2024 00:16:52 -0800
Message-ID: <244923bb-7732-4a9b-b5da-6a778ba4dd60@nvidia.com>
Date: Thu, 8 Feb 2024 10:16:49 +0200
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
From: Yishai Hadas <yishaih@nvidia.com>
To: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
 <BN9PR11MB527688453C0D5D4789ADDF968C462@BN9PR11MB5276.namprd11.prod.outlook.com>
 <1175d7ed-45f3-42d0-a3cb-90ef2df40dbb@nvidia.com>
In-Reply-To: <1175d7ed-45f3-42d0-a3cb-90ef2df40dbb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636E:EE_|IA1PR12MB6578:EE_
X-MS-Office365-Filtering-Correlation-Id: 73797b4d-a6f8-4df2-6749-08dc287e5504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cu6tHpliswSOGNjGupq5mQLuy0oL/8kFZ1rkHfrF9UQndALini6wlnTLXSenuVVJn7edaFmOXPVaLDfDtkyzKeB8MP/LxqNz1x88qKMlg5Oy+/MU1/lA/bm7udCWioP+hGT492IAz+VBhufNfeMynTGwmwXd+MFQbwwDOSLcZ21mSAIFl1C/UFrIRsIb6CvR7c0vNW7SXxjlIvwpjDWJta3Rur81sw4LB2vhAFOlOgU2M2WtpaMeNvo1w5UWRNhzeHImHx0fui+R+a9Nk6zRYGLc4VAT16D7xeGBI+3fH27AsWBj9T/LuGp2O8LWr7JPXmMFfjDursB3EtnRd0jSCxc52zPU0Zpg6vvCxB3HhK0VIcw758kdTI9QZz9D7a8z4hKzUH2Pdk07cjoerQxD5EJHaMAlVtxBjGMc/UeI52HMRgiogfg+RrCqwN71IpPULxoKKzw0kjDy2frfcDFAe9O6/wxzUnPpJR/Q/S/rrrcas73cDFxsCHw0GED5GmCxQf518wPXHbYgpv3Hx4ZQmZC82sEVvZd0ijHk3IFmVIyCpWvrhCWF7nLOF7q/qVYvUUUacir8szTZ3WYbUXycGLuSEAzGBu//TdCebUrz7PJ9oBkyxymPn/dGCyvvApK/xJU3W1XprqpOcmLATEVUzw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(376002)(136003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(82310400011)(46966006)(40470700004)(36840700001)(83380400001)(356005)(86362001)(7636003)(31696002)(82740400003)(966005)(478600001)(6636002)(316002)(6666004)(16576012)(54906003)(2616005)(110136005)(70206006)(70586007)(26005)(16526019)(336012)(426003)(53546011)(36756003)(41300700001)(2906002)(8936002)(4326008)(8676002)(5660300002)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 08:17:03.5547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73797b4d-a6f8-4df2-6749-08dc287e5504
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6578

On 06/02/2024 10:06, Yishai Hadas wrote:
> On 06/02/2024 9:35, Tian, Kevin wrote:
>>> From: Yishai Hadas <yishaih@nvidia.com>
>>> Sent: Monday, February 5, 2024 8:48 PM
>>>
>>> This series improves the mlx5 driver to better handle some error cases
>>> as of below.
>>>
>>> The first two patches let the driver recognize whether the firmware
>>> moved the tracker object to an error state. In that case, the driver
>>> will skip/block any usage of that object.
>>>
>>> The next two patches (#3, #4), improve the driver to better include the
>>> proper firmware syndrome in dmesg upon a failure in some firmware
>>> commands.
>>>
>>> The last patch follows the device specification to let the firmware know
>>> upon leaving PRE_COPY back to RUNNING. (e.g. error in the target,
>>> migration cancellation, etc.).
>>>
>>> This will let the firmware clean its internal resources that were turned
>>> on upon PRE_COPY.
>>>
>>> Note:
>>> As the first patch should go to net/mlx5, we may need to send it as a
>>> pull request format to vfio before acceptance of the series, to avoid
>>> conflicts.
>>>
>>> Changes from V0: https://lore.kernel.org/kvm/20240130170227.153464-1-
>>> yishaih@nvidia.com/
>>> Patch #2:
>>> - Rename to use 'object changed' in some places to make it clearer.
>>> - Enhance the commit log to better clarify the usage/use case.
>>>
>>> The above was suggested by Tian, Kevin <kevin.tian@intel.com>.
>>>
>>
>> this series looks good to me except a small remark on patch2:
> 
> We should be fine there, see my answer on V0.
> 
>>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 
> Thanks Kevin, for your reviewed-by.
> 
> Yishai
> 

Alex

Are we OK here to continue with a PR for the first patch ?

It seems that we should be fine here.

Thanks,
Yishai

