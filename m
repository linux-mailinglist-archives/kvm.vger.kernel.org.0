Return-Path: <kvm+bounces-9288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A237585D1A9
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56DE7286881
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD50C3B198;
	Wed, 21 Feb 2024 07:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IsbFOYbv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D613AC19
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708501552; cv=fail; b=ZRg3sKXFcvecn5fxZdk9u4FcypsMPL30LBqrCX3+wvBxot6X5v1sFCPsAgkGqpmCIPbKtcuZq1N3rk8aaoxS4jvKzjXGrCxHpUwARDQ2U17+u/nAMKoIHGqVeNntxYxMtkd+U2bf7gUlpPyEfWC+U5sEjfcT98YXB8yjRZw+0u4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708501552; c=relaxed/simple;
	bh=gNlIHILczyJybKAHowaSIriTw1PiyA8yj6HWFit8IMk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=XwDwaMqZgdN5m6UYN1ZY+dvMirE6ANzbLX8KgUaeseU9WzPl4CBVZPU1NvrfKz6i13CAmpgmo5HE4D3QUqIe0OpySqiBVjFrZSrcfa8XfDyTR5eeiDPvx98yxWfZjdircSd66HN9zH5WUfFxzp1csSZ5eCkbT772XsTAn0iUt7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IsbFOYbv; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTJfi65vCmAxQzcL6nsRbQkglqx/tuNLdx8sGkzMZm+IV0hcPZvFkfu4fhSOaFoX1Nogvhadx/FofFlMUdIAGBSW3PVUmpKYRxFO5DFyE4H8DDyvAKn24b0kTTAjElceADy39zu++tLL41M/q8e8KefrVowlBsqw53CZDmDoVh/qOOxs0Gs8yu/hhjhJ4MlbBdd/l01Slh97z8HeWzIuSQKwLbZe0cczzh2TvAqvS03JE/xDIkoKKRYoU+MqMQIqs5Id11o3zJC3RkIys3YAhEGlCrftddIt9qaoS5YZAYFTKH2VR2pLJ1aUsIgvwQgc3gQTvzdw/UquoLZfda8Ezw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDtEYTO3X5JD8+OUNYjFYGUY268hcGIAZz7JqRQrnEQ=;
 b=Lm4LI6eKtsmBnkvuRUG9J2d3V1HNl+KTnll5uspD01JKso2uwZEfc6PnpPMrp+2co5IhPS5kD4zh5EwfxMb0+qTQXL2MriEsyatyjsvg+FXrsdcGKQ49qp3KABXit3EgJYzlOVZGHtehzbV2KNZ33CjFuBTXZFGU6qfr+C2XgijP1Z3DnTFC9G7hntImsrykdX/MsOZf+6pJuFvDe4TVLQDnVkK7sdwkx+ZrF/FW9Z5tNcRMyIvwoFqON8ub1ljDWimViFtyqFFv2vYGnUwXuVHUq7cEYCqqNESyqtsTfe7mPc8qdXuTDV+EXQ8o4ecaFdXF7+HnLsfY+M7+wY1nWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDtEYTO3X5JD8+OUNYjFYGUY268hcGIAZz7JqRQrnEQ=;
 b=IsbFOYbv9KjV/rtkV7GTWAiLtZEK3TAed9hd9NYzrV0bfFFCBZm5MMExB4sZ/a6eOBb2gVEswncjy92S6tCKDd5jIkc5L3itFSsPUSFYNauezjxA9/cZyWqtBk9h+cjSxNCGBbpog80t3assE0ifVE5Rs2HerWfG3T5+5wBUSPV74GDFMo9NlH9lKMP/OD3vYWISbuiYVj2U7vrsCQty2fBWTgymPX8wdB9YLx4BJYF/4LYMKcjpEJeduxWnMQ7g0fbavdNwHsAVhR/cQT25qNCDtssZ6Bi0rC8tJXjFAAWIyr0LVc0d3GyfKQO8mBJKi1yc7wMkMM3KA4aezODqeQ==
Received: from BL0PR02CA0068.namprd02.prod.outlook.com (2603:10b6:207:3d::45)
 by DM6PR12MB4338.namprd12.prod.outlook.com (2603:10b6:5:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.22; Wed, 21 Feb
 2024 07:45:48 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:207:3d:cafe::55) by BL0PR02CA0068.outlook.office365.com
 (2603:10b6:207:3d::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.40 via Frontend
 Transport; Wed, 21 Feb 2024 07:45:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Wed, 21 Feb 2024 07:45:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 20 Feb
 2024 23:45:23 -0800
Received: from [172.27.50.144] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 20 Feb
 2024 23:45:21 -0800
Message-ID: <bdb66db6-cd41-4d0d-bc69-33390953f385@nvidia.com>
Date: Wed, 21 Feb 2024 09:45:14 +0200
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
 <244923bb-7732-4a9b-b5da-6a778ba4dd60@nvidia.com>
In-Reply-To: <244923bb-7732-4a9b-b5da-6a778ba4dd60@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|DM6PR12MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: d47cf613-8946-486f-65e3-08dc32b11ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	h5ch28rz6+K1nvw0P78PQyGI50CrQl48MSaDp3Uyx5wrQdZEWn4SzoqMIXERvbSQx2Wmnp+AqrnrZyqiM74kUbNu2HaWG6rIdTdUkbQimqrSHraA/w+L00OKj11d9HNuav90xP8GqSIV31hCcondJRt4kCX4yY1KBi9F9J3fw4OIS6wZcLNdptmnBAzDdVKQKcaKYlpSEWGcDk1NUkHq+lo9QFb6bnhjm0cj1Aaeva+cPB3Z5+3ISBDvTNnx8zyxuvNFn861PSbA/4d8M8Pgzh6LyoNWij//Jg6ExWqq3TEbmWHGoI897Jyq7m4g8bVVytpwpWSUZeFinZfkFQaCtVN4LWl2UKsdkuwvpQ1N6pA3jPymoYOmqCP49bM5nLLq91vR6zTAWGrGwsaoIo6cT7nwPh+e8/NCvGCdeKYSG10Rr8S3GTAZRBk369DsNzR34bWzRa1a6Do7jN2674sf/wE9pwY98tiO2hBj0I8sksVbfkZGqzprglzAnm4qjqbP39xSsl8AxtAYhSNUr60K8LWazLuT8cGcnyLl2VRtkJdqxu8nnSn8TqozVuu/RhZodM8GyIj3u5wKirbkDvRJYDtb9UYhd7cISDiJtpU7wvfZEO8y5fWEPDTrbuXSGn7gS0i04GWnGJnblklp8AVbGQ4PN0H1+AgpedJ4kgNii9/a/H4X/5TlAtAHVUSm0w7LOPlZcqyQTupeIrk8NsT4qg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(46966006)(40470700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 07:45:48.0733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d47cf613-8946-486f-65e3-08dc32b11ea2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4338

On 08/02/2024 10:16, Yishai Hadas wrote:
> On 06/02/2024 10:06, Yishai Hadas wrote:
>> On 06/02/2024 9:35, Tian, Kevin wrote:
>>>> From: Yishai Hadas <yishaih@nvidia.com>
>>>> Sent: Monday, February 5, 2024 8:48 PM
>>>>
>>>> This series improves the mlx5 driver to better handle some error cases
>>>> as of below.
>>>>
>>>> The first two patches let the driver recognize whether the firmware
>>>> moved the tracker object to an error state. In that case, the driver
>>>> will skip/block any usage of that object.
>>>>
>>>> The next two patches (#3, #4), improve the driver to better include the
>>>> proper firmware syndrome in dmesg upon a failure in some firmware
>>>> commands.
>>>>
>>>> The last patch follows the device specification to let the firmware 
>>>> know
>>>> upon leaving PRE_COPY back to RUNNING. (e.g. error in the target,
>>>> migration cancellation, etc.).
>>>>
>>>> This will let the firmware clean its internal resources that were 
>>>> turned
>>>> on upon PRE_COPY.
>>>>
>>>> Note:
>>>> As the first patch should go to net/mlx5, we may need to send it as a
>>>> pull request format to vfio before acceptance of the series, to avoid
>>>> conflicts.
>>>>
>>>> Changes from V0: https://lore.kernel.org/kvm/20240130170227.153464-1-
>>>> yishaih@nvidia.com/
>>>> Patch #2:
>>>> - Rename to use 'object changed' in some places to make it clearer.
>>>> - Enhance the commit log to better clarify the usage/use case.
>>>>
>>>> The above was suggested by Tian, Kevin <kevin.tian@intel.com>.
>>>>
>>>
>>> this series looks good to me except a small remark on patch2:
>>
>> We should be fine there, see my answer on V0.
>>
>>>
>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>
>> Thanks Kevin, for your reviewed-by.
>>
>> Yishai
>>
> 
> Alex
> 
> Are we OK here to continue with a PR for the first patch ?
> 
> It seems that we should be fine here.
> 
> Thanks,
> Yishai
> 

Hi Alex,
Any update here ?

Thanks,
Yishai

