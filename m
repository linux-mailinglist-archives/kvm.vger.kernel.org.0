Return-Path: <kvm+bounces-25654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1EF968089
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 09:27:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 099F01C218B8
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 07:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3697D176AC8;
	Mon,  2 Sep 2024 07:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hIKY5haa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE4714E2D8;
	Mon,  2 Sep 2024 07:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725262030; cv=fail; b=IhF/teQolJTocCElcBSRxviPcdP3MMvVAWKEc6URQqw3F3d0lThZFXCYstAxvHskKLCujeWCNq7YaEUm9Ai8KmSOWYqg8pmGMPmvcd9SrMg+0C5sNxfsiRnGRxjDgDF0jlDH53vJbSzwcd3yB4iVfpNItuu/LtiumTobG04iacc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725262030; c=relaxed/simple;
	bh=l0bYGOdfNWmIao9DqXMz+0C7VJn7nlmo1Ahpkt8QZks=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=flMvpeY1jfSwysxk8KIlm/gWUN3Qm9gPc379MDt9Hsr3Bv0l4OGAyyJCyG4qYgCy71HD30TcrFtiAsPh9G4RL633WRn7D557E6uTDFCPlGv4/GhRnPC7Hyvq2unfwY7wVPloHLN3K/JQc5K7P+APbDZHXWWyYnb8GqQWBPB1V5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hIKY5haa; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gzJAQSmKRGF05hAtvtEiTyuTenl0kfucPCB3IVP3Czv8+ZgK2dEa1U4GcFkbm/ZVYlvjLlrm4Th2NHb9eSQvar9KaNc0zXVH2QYjIMTjFX67FWI5+AYSyx1CCez9EUkzsPbfueAh6+k3vGHMAYUVkfMCkJVSASEqgnsirLg040VIYT72Zir0KQDnVMTo88Yx/ilDX0W/03EEyvfdCf1TQi3vp/SaHkxusF5V7DEforG73DS36J/DM8Q0H8R6rzn2mym0BUIYHVIiJlbauKKCCQtGhjJvqZPo7fL82tg4BcsDb0jkeRGqnVNrxhrI/X4bF9dFCA0mH0WEyCfSNg1iiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTr7LsoAiTbyBE7/N+M6jyZoCz2Zq8atQDvKPxjlKM0=;
 b=qMrrCQI7BxxJ9vSOcn/sbhYuXvC0glI+hAc6ilIJeSAaxPP4tW4MfdW3pA/uY8VTR5uf4poSS5mCy7F0QxO1tbve1YDY/wl3I3lsb0yM1fI8Wy/v63GqoDD6Pm59EhZq0oTIzCza76UuYjYM+1xgBQf40k3hno9cwwSceoZEKRixrNkhrjMbGMslzZP1Hb5v8uOm3Gk58KeJccKE6j/Qt6owj74sJGfyVH9Xd4ytHA88b0/5CrUFiC++YxeBaThpTD78KWijdiMNG2jotddHQIGRYLah3N8nFSejQiMAuX5Pfthjb0fMU1S+ib8buH4dYeTXtS5ybY11ULRc46XZ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTr7LsoAiTbyBE7/N+M6jyZoCz2Zq8atQDvKPxjlKM0=;
 b=hIKY5haa5grlDTz0k2pB7e2/y/VxT8wG0GeMkHkM2yNyvTg24gBU+jX5Z7jfPdqrsKeCrAFjfUfP9CzHMtQfpw3SCCV4I/NsSF2qCb0syylfUqN+v4O2U5mlcGvyhjwE/xHdDulsfFzfNHUukHqyIdEQAUTmoI2Y5bUr2A/HE64=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Mon, 2 Sep
 2024 07:27:06 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 07:27:06 +0000
Message-ID: <9d5a3f27-7aae-49b7-b3d6-5d1879306bb4@amd.com>
Date: Mon, 2 Sep 2024 17:26:56 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Content-Language: en-US
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org
Cc: iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com> <yq5abk16wnuc.fsf@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <yq5abk16wnuc.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0078.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::20) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM4PR12MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: 9137cc52-8192-43d5-765d-08dccb20a55f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TG41YnJLTTFubzB4MTgrNUxXV210RGhiNUFlNFBEdmFiallXQ1E4Tm02N0dJ?=
 =?utf-8?B?aUlVWmVrcW9FeVg5bEwwaEhaTGV0dXdKbzRCTmxFaC9tdERQV0hGQ0FaQ1Zl?=
 =?utf-8?B?VklKSnNkMFgrLzR1R1VsbDlTall5ZWVOZ1o4ZU9ZS3hTN1JmeUhvRm5GVmxG?=
 =?utf-8?B?T3dDWklaZ1QvQ0hQTVJWaWVLM2pQbWh3TS9XWDl4eU5ZYUlvWDA4OFFEcysr?=
 =?utf-8?B?U0RPblZvSXBDd3hVZFQvSDZMUU1xTkVaZUdtWm9jdXE3K2sxT0p0Zk9mckdN?=
 =?utf-8?B?bzJRR1dxVDVkTzhPb3lZNXNUczlvblU5UmJRV3Bra2s0YXgyNnFFZWppcm8y?=
 =?utf-8?B?ZTJHQzExRGlCVXk5dko0aVZ3aHRybldwUlk2dEJZUU9UVHVDcit1SW5Xa09s?=
 =?utf-8?B?YURLSHJXR1ZiR2Iram41b3RqamRKL1RHWWxjU0RYeUkxdW5PSDIwd0w0VEJB?=
 =?utf-8?B?cWxKcG1IaG1ERjJvbzlvVDRwRnJhbWZZZlJiZGlpRDBZWW1OTFJyV0dvQVhu?=
 =?utf-8?B?c3pkNkVXclpqeThWYThkR01Dbm03U3dweVRkRnczWFRlRmkyU1QzbFRvQmgr?=
 =?utf-8?B?bmQ5VHBzRG5qNnVWNWNpN2VuaGlyZWZtL21DMlJjUm54UmFNU21HVDZ4WmJC?=
 =?utf-8?B?dmtoeHNqYWN0dVVSWVNIYmsxa1ZMSVBqcTFYUExXRlNJY3h4QysyQ2lYQ1Ri?=
 =?utf-8?B?djlteXR4N2FvMlFINjVzVDVReWg5S3ExMm1UbkdYalVqNTJ4TktQbzEvaTI2?=
 =?utf-8?B?KzBvWkNZVlBNbEJnRnY0RkJwUk1UbkJIbEpUckZYRU1BdWRJK3NGV3liL09U?=
 =?utf-8?B?T2JlK29PVG5STDNoRHp1ZVh4WnY3K0QvNy9kWEVpSHcxRlhjL2wrakJsZ21F?=
 =?utf-8?B?MThzWE4wdWxTSUkvV1ZNdDFjbkFGOWNmY3p1QWlQNzRRQlp5NjNHT0Uzd1lt?=
 =?utf-8?B?NzZqeVE1NTh1VkZKdWxHcGtCNlp1a2dlbmVYVzh0RU52bXhESGltcWdwL001?=
 =?utf-8?B?bmlmTzkrVzBxUlhud0VIdmdVbGEzb0Y5M2RGaFlLOHExallhT0xqYkdTcmVV?=
 =?utf-8?B?N0NUNmJGRHpLY3dLeDVCNndyT0hrekhsNjl5c0NaaTNJUWthQU5hQ3h2OExo?=
 =?utf-8?B?SXNicnIzMElaL1JKZTFFRlJzMUZ0WmQreVcxYUxPemxTTWdLL0NtOVlqQTRG?=
 =?utf-8?B?OHVvTlhJVHYydW1LME9wNDV2cWZpU1RmV1FsRDRGOUZFTGl3STl5RVV5MTVF?=
 =?utf-8?B?M2pyUFZyZVVac2lONXZic2lSM3NCMlZlMjd6WEh3QXBRM1J2eVBsUVdUakZ3?=
 =?utf-8?B?Rk9nWlNTbHdrQlgxOE9RYkJYc1VXOGJBUC9MTy9hSkgvYzJzbUdUd2FYZGlT?=
 =?utf-8?B?eUNPc0Ura24rZmVIWjhxZHU4MjF0ZnZ5bks0K0FneGxza3dXYmpSaHFxM25i?=
 =?utf-8?B?NFdvL3liUUxZR1QwOTViSHltUnRXZUw3MkJjMVd0L0krbjh1ZVpGaTFTSWR0?=
 =?utf-8?B?VklMWEFPbVN5V2s0c0lHOHE1UCtOV3VFVS84blI1Q3lmb0dOclZnYjVYdEhy?=
 =?utf-8?B?bU9VOVFBemhLRUVaNnhyWlZzRElvWlJucnJ4c2MvOHlLL01NWmtieGkxVWRN?=
 =?utf-8?B?Y3gvQ0hyMGpUQmZ5eDZzdnAzZittOHlNSXI0TCtzUkFKK1VjeG5SdTVxWUZr?=
 =?utf-8?B?MHVBcHRXR1RWKzRoOFlyYXZwUnl4MFd4U0NhMWEwV2UzWHJHZ2N4eFpKK293?=
 =?utf-8?B?azd0T1hPV2pCMFo5OHFFd2VuOFVrSXVxUlNjVXgxQUFwVUdvTTRiU0N0TTM0?=
 =?utf-8?B?YXh4WlBGNzBiRHJwNCt5UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ME04SnhyNS96SDlxZ0NQZE5GbFczaklYSG4rZjZHU2VoYnhqTjRPczloMlpK?=
 =?utf-8?B?YzhSN3c4VDV2d084RStZWEdnTlRzaFBwdUt0WjJZVmRoaEVuMjBEVCt0bmUy?=
 =?utf-8?B?Z1BCVm5mcUxmVzlUbE5UVCtXN2o4KzBBdWRlR0FJNC9tUXc1R3RoNnlhUE40?=
 =?utf-8?B?QXIrdmJXeGJmcFA0VmsvNzI4a0Juc2lDNlZsM3MwN3NqSlZ3dUNJdWVhMHpw?=
 =?utf-8?B?T0hGaEE1QXlkK3dkejVzK0Z5ZXhSWG1DN25YSzJtd29CNzRrYVVMWU0vRGRV?=
 =?utf-8?B?WnZFQUdBWjl1SnQyKzNJWWgwbkFTSXNkUGtKcVlrYkgzTGRHWnJIa2NkN3pZ?=
 =?utf-8?B?ajBIQzI0WU5vcFM1eUVaeW55TmlCbThrR2QrczZ4aFNmeUZvV0QrWHgzc3lZ?=
 =?utf-8?B?dkx3ZlBDTkxJZ3k4Z2V4TEkycEtxOUh2V3U3OGxZcnZDZ3NOa2Fsb3N2L2o4?=
 =?utf-8?B?a0IrNUJJNHJlcTdpUmQ5RTUrSFRXNTJiVUhUdHIzME9TMlplWlNHVFR5SEFp?=
 =?utf-8?B?N21RUGtudXY2KzNLOTN3RWVZaEhPTnNSOXc0SUtSREpOZmZNMWhrekEwc2Jk?=
 =?utf-8?B?VmhCUTB4dE4xY0ZFMDNQRUh4Z3A1UG5nMDNPYWEzTHNXR2xGbk8wNE5jdExm?=
 =?utf-8?B?T0VKbGtyS0hYMnVzOUsxbWJkVU4rMkVJc09jY0U1c2U0QkRNL1hRK1ljTFcx?=
 =?utf-8?B?RFdrL1lzcEpXNWZOSS8wVGpWdlRiZ3J4Q0d3M1hVU1pTYzdSMVFUWXpsTG55?=
 =?utf-8?B?SnBYbWErbXJ5SnBJOFVVWmJUdWsyR2VpdWFmdmRDSm0yTlQ3Y21uYzRMODQ1?=
 =?utf-8?B?ZXlrcXF4RXJSVGEwcFdLd2xRS3BweklxREdVN01VZWhpcnpLMEF1TWNkT0p2?=
 =?utf-8?B?ZFRjL0t5dVU3NGkybGdwMFhNOFlZQkNWRWpBd1FnNFA5WEh1TTJSc3orVkhs?=
 =?utf-8?B?Q01BMmdsalBFVXdkT2V5bk02Mngyd2dUT1dZV2dEenowdGNGbmJwbzZIS1JT?=
 =?utf-8?B?YXdRMlpJclpCUnhxSm1DcDFwUi9WdlUwRTJYbldNRnJ6eDdkT2FOYlhaRVhj?=
 =?utf-8?B?L0djSGtpQndDYUVNckJ6OXA3WXFVZlN0UmFtMExzN29MWC9NSFBGamtkZndC?=
 =?utf-8?B?QUZ0bFJ2aG1ZUGZjVGtVSm5kRVZac2NjOHIwYUtPTlVnN1BPcUhZOVM5UVBI?=
 =?utf-8?B?bEdPTjk2K01xdzBIWDJTaldsS3ZzWHRXU2VFVUJYRGZMVklTNjhYRkl6ajg0?=
 =?utf-8?B?QkJzY3VXOCtONWZJdjg5czVhRTI3L1FKeWpoS2VvQkIyU1F1ZmJ0VWZUOFlQ?=
 =?utf-8?B?SC9ZS0U2clpuZHVld2dnMHlUeDV1czB3U1dZQU9SOVNQSjBhaitpMGJqUXAx?=
 =?utf-8?B?Y0RmMGE2UGVhRFhSWUJ0V0M5VWc3N0Z2TkxMbnVOU3c0dDM0Yk8zd0NQbktT?=
 =?utf-8?B?SmsyYlF6b2FFN0xIaTVoMFZ2SjV3MjBmekVabHAydTZsaGtJUDNCSHZaMHV4?=
 =?utf-8?B?UTFnVUJxTGl3QXc4QlNCV3oybnB3VGpnVkUxTkJkd2RPNDRqQjFCa1dGa3hF?=
 =?utf-8?B?YS9nbUxucEJRSlgrQlorK2piV2RDTENkak5vWjhDRDVTZko5V01JZ0FoZE56?=
 =?utf-8?B?RGc4dC9rTnVKT25wTGszRmtqM1FsTEJlczhvdFJPU0xaay9pU2wwejlRS1pN?=
 =?utf-8?B?Um9qZXZMS3d1WWhJUGFPUnFZVHZnTnlhVmd0bDhNWVNPTkwyRnJ2MDAwOXpv?=
 =?utf-8?B?eGF5UDRlLy9nMlVtcTlheWJIeVlBbFV4a2dCVVo3aDhJb05xRGlndVV3R3Az?=
 =?utf-8?B?ZjhmdGhRck00QzhFd0gvTmxTd2ZNTVJBeFQvb0R3TGdlVUNBcW5haklEOWQr?=
 =?utf-8?B?SkZBVDJub1FRYjFtN21KMmxlYzFjenJJWlBMd2pCZTBVdHpxZ3FuU2hZUTZ6?=
 =?utf-8?B?Y3lCN2NnSDNXZDFZSFNtc1JqeUhxSUtSdXd2ekxOREhQSktTSDdHSlpCdVhR?=
 =?utf-8?B?M2I0aTJjbGtaWUV1bXJ6Vm9tdy9hdDBIQSsyOEVvOTNBUFdrclhLOEphbkpY?=
 =?utf-8?B?Rm1XaGN3eUp3Z1Z3Zml4Y2JvRHBvZndVZ29QSUJTNjZOSnpET3Q5ZEpKSWRY?=
 =?utf-8?Q?QaP7TOKBhNqa+08QnbUBMGgOc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9137cc52-8192-43d5-765d-08dccb20a55f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 07:27:06.1242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZIQ9pFhMYDXTLjdvLKutHvrp6Mn9FxTyAugF5I81HVcf3NTGRSVrzVr9EEiHHu+DPFCDxKIo5/isiBuRs+2hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6280



On 2/9/24 16:50, Aneesh Kumar K.V wrote:
> 
> ...
> 
>> +static int tsm_dev_connect(struct tsm_dev *tdev, void *private_data, unsigned int val)
>> +{
>> +	int ret;
>> +
>> +	if (WARN_ON(!tsm.ops->dev_connect))
>> +		return -EPERM;
>> +
>> +	tdev->ide_pre = val == 2;
>> +	if (tdev->ide_pre)
>> +		tsm_set_sel_ide(tdev);
>> +
>> +	mutex_lock(&tdev->spdm_mutex);
>> +	while (1) {
>> +		ret = tsm.ops->dev_connect(tdev, tsm.private_data);
>> +		if (ret <= 0)
>> +			break;
>> +
>> +		ret = spdm_forward(&tdev->spdm, ret);
>> +		if (ret < 0)
>> +			break;
>> +	}
>> +	mutex_unlock(&tdev->spdm_mutex);
>> +
>> +	if (!tdev->ide_pre)
>> +		ret = tsm_set_sel_ide(tdev);
>> +
>> +	tdev->connected = (ret == 0);
>> +
>> +	return ret;
>> +}
>> +
> 
> I was expecting the DEV_CONNECT to happen in tsm_dev_init in
> tsm_alloc_device(). Can you describe how the sysfs file is going to be
> used? I didn't find details regarding that in the cover letter
> workflow section.

Until I figure out the cooperation with the host-based CMA from Lukas, I 
do not automatically enable IDE. Instead, the operator needs to enable 
IDE manually:

sudo bash -c 'echo 2 > /sys/bus/pci/devices/0000:e1:00.0/tsm_dev_connect'

where e1:00.0 is physical function 0 of the device; or "echo 0" to 
disable the IDE encryption. Why "2" is different from "1" - this is a 
leftover from debugging. Thanks,


> 
> -aneesh

-- 
Alexey


