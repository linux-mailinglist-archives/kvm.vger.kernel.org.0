Return-Path: <kvm+bounces-18423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D37E8D4D68
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 16:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFA101C23150
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 14:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE5D186E42;
	Thu, 30 May 2024 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JyfIwIjy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84030186E3F;
	Thu, 30 May 2024 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717077827; cv=fail; b=DMxoF/WQ1SvhxKHt85U2fsxQD1YTwCxVgp2byg0vwl1i/w3CJKrAlzVNv3kgyrhXH91E5gpafHeWrVHTExYHHfdxDWym0v+xKMav3JdZT4A97tT6BPHItKUY5jYZzBIzuI1nNB3gRrOAIqYpVXmiyrfVNM+diTGeaQYH8Hu6R1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717077827; c=relaxed/simple;
	bh=ixfMpoSBLuLaKRnzApr92OSM1SmJxmJzBtuyK5RTjRU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C3sQut7+ZknuRXLauhxNQOfuhSp8ofwPUo7edbGP4vc+gDi6/KKrbZK9WNfS5Cz3MBELRkYlAvXLJjR+/4vCLZD9nuCT5Q7yt/ldFYZRuFB1d1LJLJZHYkvlGDaDTGed8cRvpveHFlj9plvBvt+gNofxDX7JtIJHxxy/t66aMPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JyfIwIjy; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crn7xbhoxLr2GLZohjduf3UizlrscK+K9r3WFhCoRSyHjP1b9uKigek0djCOEYRmnpXEIEGHRx6NN5Udg1yjQZ5Rz+EduifwppQSvv6VaXxUpt78fOrX2ow3jyzJsJxOWWDKAikvbjSJ8ToS3yIoEQOY6ClApT9XPIxLAz+fSymRfuWCkm3rkbiWSycHoFDJW7SWIuYVePafdbg4Ub5NVZyidQFi6Cf7aW6r3sEJOnvfB2P0f2e3nnd8gOoNKL1D1nTlknfcXc6A7LHEhE2cuYnYyPYIwm/ciLSovudU0j+S/qvbTly+FM005O4cQmF2OiYyc4MrueNGKbxt9EeA3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Siuty7IenZFmXYxlbrEl6bCBBSjUqgXbMoEtXM2tgYg=;
 b=R+FZhUgk2OSdG/piB44BQjYHebnkW9ylzKbsEN3QXXJq9hONLtuNblSGQw4XnYq9/rgR29YtobpgflXAYPakjkUKJfICmi47/mbqdWG6Ee2MXlXmXLgXqc7MjS7F1HH3PIdTU8gMfRyX0PgYs7X1/xkaduKbXJQG0Hgj6qrgB2SqRmFScNSuvPbhskZPdtjWthY9Oz/VFyGdT9JJLzATYTJXCmTCF5JO++VqExP38VggaZ3/m7oBTEvDt5espkvT2D33p7XxaReIsacrk0KdSUGPwDyiIBxnAOWo72SHV3rETK051r23/c9q/FrWW9vRMaxBos8i0atGizgNWMBGCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Siuty7IenZFmXYxlbrEl6bCBBSjUqgXbMoEtXM2tgYg=;
 b=JyfIwIjydBbJVj6es8PzQA6vJxl6XcffaTxi5rNO9Lkh/zlDQ9fGTR9nuK09S6/gQU1orYn8ji8NrHerEEVbhc3RscDKc7lWiqU77Zstt74FZU55Ue6iFkS0DoFkuZS4pxA77NmEaWWyKWLnsUY8ZHsfSiJcs4TXm15Vtj0UuMM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CH3PR12MB9124.namprd12.prod.outlook.com (2603:10b6:610:1a7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Thu, 30 May
 2024 14:03:42 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 14:03:40 +0000
Message-ID: <562819b0-2c8a-1344-6090-01f8cdca107e@amd.com>
Date: Thu, 30 May 2024 09:03:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 3/3] KVM: SEV-ES: Fix LBRV code
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, nikunj.dadhania@amd.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, pankaj.gupta@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com
References: <20240523121828.808-1-ravi.bangoria@amd.com>
 <20240523121828.808-4-ravi.bangoria@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240523121828.808-4-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0056.namprd02.prod.outlook.com
 (2603:10b6:5:177::33) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CH3PR12MB9124:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f503711-d415-4798-9418-08dc80b14e82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVFvMW5PTTUwYUxjcFhnemR2cDVDM20rUHF6ODdzeGI4V3RxS09Pa2c1b0R4?=
 =?utf-8?B?dTFLU0FWcWRLa0xtQzJUT21UcmJjUS94K2FSMDFBRzFRZGoyZFBFRWR6eEUr?=
 =?utf-8?B?dDFZcXZWWXg2RHpMRzd2bit4TWRIekZRVmYwMk5CdkdVWjRoeVIwczh5aDFN?=
 =?utf-8?B?SG1CSEZQblhudSs1djNiSk9iVVBiUVVhM3VGd21VU2xNTlQzK0RWQ21lZjBj?=
 =?utf-8?B?Y0ZUc3h0VU5GOUVQSEZHNUd3K1ZJZ2NFUE5nbFhHd2U2RDBUWjQ5R1VQTG9B?=
 =?utf-8?B?TWlSM0pnMDQ5MUN1cVJ2MzNNVlNmTTZiOHUwSENOeWJWMnVLdDJSWXNrajk2?=
 =?utf-8?B?R2NkSXAvekhyOENlV3lHcWxtOGtLRUJGcGlpQmdvczJhNGFzdWl1S252ZlU5?=
 =?utf-8?B?OVQ4NlF0ZEhENER2WjNiYk1kRHdQU2R4bjhad1RxaWNGYXkxQjFDRXhtOVBI?=
 =?utf-8?B?SDBSRHdoSUs2d29qOU1OQitlYVhRaWIyc3J4R2lJUDdEb1VVTlpCYzRuREZG?=
 =?utf-8?B?NWhvVXR5V0NoNFpUM3k5bTkwNVkzR0d1cDVjdnppZE1pYVltMHhDL2NpeTQ3?=
 =?utf-8?B?cDNXRFZXRXg1cGJVOUFzQnRPZjg3NjdUYzR6b2FMMHJabkNGTUJlN0pzMS93?=
 =?utf-8?B?WG9MRzNNbjh1ZlozdmU1a1dPTENOOEtIZ3M1d0krT1VCcVp3eXpiMHAvTkg2?=
 =?utf-8?B?VUVsdXZ5WDl3ams2K2h0U2hzOGY0bTd3Z2Q4VDZBVHdVbnFuVzdZWWV6ZVow?=
 =?utf-8?B?bEtvR1ZPS0NtbFZ5bWRhYTIxb1NDT2hoaS9xalp4ZVZxbnAxbzJRVHU3aUhQ?=
 =?utf-8?B?S1FjYVMrNUNlWkxsdGZMelBGWURJajNPYlJYOU9IODJJVzZlV2Q1YzBHZTZE?=
 =?utf-8?B?L2ZZcnJxeFlNakxPanFVVVJhNHM4Vk9KV3ZZaFVTZzdYZmFGVDh6QjgvMlYw?=
 =?utf-8?B?d2Zxc2E5SXRCcVhFVTdlSG83cDhBMlA2K1FpZWpnTE9CdlJGYTJsakhJaUF1?=
 =?utf-8?B?b09oOU81b3g2dlIwVWRHWHNFWEhLQWFORWI4dXhWdW5VNnZNSkdIZXFyaEx2?=
 =?utf-8?B?NTVxa0NXcjlySGtiZjcyRXN0bGh0alF3WSswK0hvR1BSb0ZwS0hYNGxLblRt?=
 =?utf-8?B?UktqRTh3aGowSnYyWUZ4Z2RlbWQzTjc3RkJwbnRUK3dnc2k1cVpZYSswZlNv?=
 =?utf-8?B?ZFVUemo2RDFGWnUrS08rcnphQStOR1h2TXlkei9WQld0L3VZTUVRYXY0bW9j?=
 =?utf-8?B?cC94ZGRzenlyb2NxVk1zWXBhZFlhdy9IYmdweE1pUUptYVhSL3MxRE5aamxy?=
 =?utf-8?B?blU2cjEvbVJkRzFCb2lwckZtaUxRN0RIVUVuODVMN0l3b2NBRDFteHBDSSt0?=
 =?utf-8?B?K3NSeFdKc1hOTkthQ3BXMndrUys1dU53Z1lzOXFiWjRhUW5wSVI5ZUYwdG5R?=
 =?utf-8?B?aFdHa29qRjh3ZktCRW1GWXhNc3E3S2VadGxSSlpLNkJaZ242aFhEbnJ0VHpW?=
 =?utf-8?B?dExOQURWOVkyek1jeUV0Mk0xMTZITVVnbE92a2hFVVI0RC9oUzZ0ZklmUWQ2?=
 =?utf-8?B?K1VVS2h0Q0FmMkNPdnMyOUl4TWZwVm1VRGdwR1VxSE1zQzdvM3Z4V2VRdXRy?=
 =?utf-8?Q?pTiMTjqYWkTi5D2YuZZTGpFE+DgSPyYrSA9x8QRSYiHI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEJRVi9PcDg4UWprVG5XRGcrUElIK2xVWlc0UEpCTzh0bzJxUTJIQVZVdW1L?=
 =?utf-8?B?c2pBanhRRzc0R21mNWszemhiTk5KQVFnczdLS3JDSFBHdVBheU9ubHVSc3lz?=
 =?utf-8?B?dHVXNFVMNlQ4MmpEY01xM096d0hEQ2NpQzFMTmFEOForUlpLOG9CdTA5bVdy?=
 =?utf-8?B?aEhsK3hTS0hFbGE4MlU3VXBYNGhNRHlrbEdlTEJoWGtwQzl1aUlRaEdrRmxI?=
 =?utf-8?B?V2dlckxQTWpwMnlsKzB1VkdPc0lNVlYwQXRtVUJOUUpiQXZmc094N0RidWdL?=
 =?utf-8?B?NVVHVFZoNGcwUUJOa25XSG5sOUhlbFJPbGhZSmtqSHFwTzErblY0enZyUThZ?=
 =?utf-8?B?YTI1a3JoNWMzRloyai85NlVCZ0xzT24yU1phdmgvY0NYVkY2WjVSL1BBd1Ja?=
 =?utf-8?B?dXZObEx0N2lxcW1GZ0ErUXNmS1dxWHVpK0xoYUdicldRRVpWU3RRZVh0anlT?=
 =?utf-8?B?L3RkOHZMcll6UFZRUFhhRS9BTGg2bmNnOW9IdFRYVjhtaVBMV3ZRbHMwZzJs?=
 =?utf-8?B?REVjY3pjZ1ZHWEdvQVZxSXlsR1VKQXVMcEZYS01WUUhqTDlwcDdoQVdxTUtQ?=
 =?utf-8?B?c3diYlBQSUpUeDIyOXY2WlpjOGVMdGc0ZjloamgzeGtJVFJQeG00eURZZ1Y2?=
 =?utf-8?B?RnhQMURwWHdORjFqT0tXV0EzTy9FR3RKYmI4YjBoUFdMZ1YwN2l2b0diM3pt?=
 =?utf-8?B?ZThNZjlKTk5kdWRtNWlZTnFEMFRrOXAyODJLWE5qOW5mdkFmQXB1d3UvNGdV?=
 =?utf-8?B?QjRObnByTnk5SUlsRlhxV21qQjFaWWd5cFRPbXYwMDBhV2I5emF5R1N5ckJK?=
 =?utf-8?B?WWZOb1RBb1doeUl2WmtFU003YjRiL2FXV2hPK0toUXJxQysrL0dDQWt4VXBl?=
 =?utf-8?B?NXVCNW5kZEJBZTdPMTBSbit4QTR6VlYwK1JwTk9wZVZHRlZYYzZnUFArZitj?=
 =?utf-8?B?RjlteXl0SGZUbW9nWTNVNjNQdGVvTFVpZmZxZDJhT0hOd29IaDFnZzdHZEJS?=
 =?utf-8?B?UHlUTUJvK3o0aWxNN3cvaTdWREphU1NXK2h5emwwWU9GR2FzNGRxbjkyRlhH?=
 =?utf-8?B?THkwMm5VMExKMDBPQ1piWFB0UkZYTmJkSUpOeitSdkxLYkpHSk0wS1FKQ2Jw?=
 =?utf-8?B?bmlHaitLbnNxd1FKUDcrU3A0REZCY2cyZk5yRTNDSERNTXVHd3RBSWkrcncv?=
 =?utf-8?B?UlhaSW1mVE8wd0pxVEt5MjQ4alJETndzS25XYnVYaEMwL1ZDTG1FSStsRWw4?=
 =?utf-8?B?Q2xwSmdBSzc0Z2Y4V3RWWlBWRnFzV2FpK0s1cUZBZnlXV29zWVhNcmFiMy9H?=
 =?utf-8?B?OEtrb3dTZ0hqNTZxZC9rK296QVJZbmk2YVlQR1k4Q1M1YVdOR25KTmZYSWNG?=
 =?utf-8?B?a0M0VUhCc3MyQk1lemFYaWMvREhlWStQYXUydk9CZ1lNNmg3cHF6VDFycFJ2?=
 =?utf-8?B?YWoycVM0MlhMaWVCQnVNZWprK09aYlJTb2NzdWlDdVZodm0rNFBselFhdWlW?=
 =?utf-8?B?SjhYendRK2RZUkh3eXZ4VTB3WlJuazhkaE5lSzFYbHdKcUx2N1ZGTmxjcThl?=
 =?utf-8?B?Z09pckgxTXpZSHZLN0hISjFUU25tL0daUFZQcUdBTS9FakxJQ0I2cTdTOTZC?=
 =?utf-8?B?eVE5QXZYRG1vT2FqWksyQkxOd1ZiazAyakY4VXRVU3BFUWx3Zzc4UVQrTTFW?=
 =?utf-8?B?b2NMMm1BbnlHQzVpWHJxK0NwRnpsNjhqbVRQOGxHY0pPZHNncDJ3bkVxbGVv?=
 =?utf-8?B?eStjZVYxQXpIR0hUaTNlQ1R2Sk5aNWhSbDNGMmpxanBGWXNOTHdRS1U0VWhN?=
 =?utf-8?B?MkdnZjAvaVYybkwyN1Z5ek9kQ1pxMFBtd0R3ZEQvU2dmeW12dU9wclkvWUd0?=
 =?utf-8?B?ejhrT29GcTRROXJlK1hONnNFejY5QjlZcjRRNXFXbHAxOE83OWp1TjFMMHpq?=
 =?utf-8?B?Q3phZHFaOHBUdkt0ZUNSdWgwWndma2xhUWR2K0pTTzBzMVkwNzA0VWxBNjdQ?=
 =?utf-8?B?bmZsSURDVXR3R3pXSm9mdUxEdUgvdnB0dlpHNFpmZWhQR1NURlZEY3FIek04?=
 =?utf-8?B?b0pjeUFZR01SblhXWlhDdGJFb3pqaUJrSEo2ek55SjFtU0Fycll4dFBYazhw?=
 =?utf-8?Q?g33KCzOsI81HW/VHs38bEM+Fu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f503711-d415-4798-9418-08dc80b14e82
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 14:03:40.1090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNPyu6yva6gcrNxqwl2DwhM3inIIaktTTRFXcjglXPHS508H73850KFpVt85mWZ2915SYlL/p+8Gl26K0o1/yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9124

On 5/23/24 07:18, Ravi Bangoria wrote:
> As documented in APM[1], LBR Virtualization must be enabled for SEV-ES
> guests. Although KVM currently enforces LBRV for SEV-ES guests, there
> are multiple issues with it:
> 
> o MSR_IA32_DEBUGCTLMSR is still intercepted. Since MSR_IA32_DEBUGCTLMSR
>    interception is used to dynamically toggle LBRV for performance reasons,
>    this can be fatal for SEV-ES guests. For ex SEV-ES guest on Zen3:
> 
>    [guest ~]# wrmsr 0x1d9 0x4
>    KVM: entry failed, hardware error 0xffffffff
>    EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
> 
>    Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.
>    No additional save/restore logic is required since MSR_IA32_DEBUGCTLMSR
>    is of swap type A.
> 
> o KVM will disable LBRV if userspace sets MSR_IA32_DEBUGCTLMSR before the
>    VMSA is encrypted. Fix this by moving LBRV enablement code post VMSA
>    encryption.
> 
> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>       2023, Vol 2, 15.35.2 Enabling SEV-ES.
>       https://bugzilla.kernel.org/attachment.cgi?id=304653
> 
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>

Should this have a Fixes: tag, too?

Thanks,
Tom

> ---
>   arch/x86/kvm/svm/sev.c | 13 ++++++++-----
>   arch/x86/kvm/svm/svm.c |  8 +++++++-
>   arch/x86/kvm/svm/svm.h |  3 ++-
>   3 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1a2bde579727..3f0c3dbce0c5 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -851,6 +851,14 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>   	 */
>   	fpstate_set_confidential(&vcpu->arch.guest_fpu);
>   	vcpu->arch.guest_state_protected = true;
> +
> +	/*
> +	 * SEV-ES guest mandates LBR Virtualization to be _always_ ON. Enable it
> +	 * only after setting guest_state_protected because KVM_SET_MSRS allows
> +	 * dynamic toggling of LBRV (for performance reason) on write access to
> +	 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
> +	 */
> +	svm_enable_lbrv(vcpu);
>   	return 0;
>   }
>   
> @@ -4279,7 +4287,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
>   
>   	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
> -	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
>   
>   	/*
>   	 * An SEV-ES guest requires a VMSA area that is a separate from the
> @@ -4331,10 +4338,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   	/* Clear intercepts on selected MSRs */
>   	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
> -	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
> -	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
> -	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
> -	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
>   }
>   
>   void sev_init_vmcb(struct vcpu_svm *svm)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dcb5eb00a4f5..011e8e6c5c53 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -99,6 +99,7 @@ static const struct svm_direct_access_msrs {
>   	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
>   	{ .index = MSR_IA32_PRED_CMD,			.always = false },
>   	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
> +	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
>   	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
>   	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
>   	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
> @@ -990,7 +991,7 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
>   	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
>   }
>   
> -static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
> +void svm_enable_lbrv(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> @@ -1000,6 +1001,9 @@ static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
>   
> +	if (sev_es_guest(vcpu->kvm))
> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
> +
>   	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
>   	if (is_guest_mode(vcpu))
>   		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
> @@ -1009,6 +1013,8 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> +	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
> +
>   	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
>   	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 2d7fd09c08c9..c483d7149420 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -30,7 +30,7 @@
>   #define	IOPM_SIZE PAGE_SIZE * 3
>   #define	MSRPM_SIZE PAGE_SIZE * 2
>   
> -#define MAX_DIRECT_ACCESS_MSRS	47
> +#define MAX_DIRECT_ACCESS_MSRS	48
>   #define MSRPM_OFFSETS	32
>   extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>   extern bool npt_enabled;
> @@ -582,6 +582,7 @@ u32 *svm_vcpu_alloc_msrpm(void);
>   void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
>   void svm_vcpu_free_msrpm(u32 *msrpm);
>   void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
> +void svm_enable_lbrv(struct kvm_vcpu *vcpu);
>   void svm_update_lbrv(struct kvm_vcpu *vcpu);
>   
>   int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);

