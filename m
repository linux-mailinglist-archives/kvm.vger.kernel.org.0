Return-Path: <kvm+bounces-38380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D6EA38B56
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 19:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15BB4188D2EA
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 18:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC8922E004;
	Mon, 17 Feb 2025 18:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Gbnt0mI4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9CF18DB39
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739817297; cv=fail; b=iYsvu61DUex/sJt/8qhYtRP8oVFRYChpj39tZmveQiEWV/Qfo9pkKcEEVJ2HGPuobjRNmaY1HSLFY2hVbKNbt5ZGtFVcV8AeOp/GW8MOyRVRuGJUQenb3LsTWgWi6XaGvJA3NUAz7jOzCq/87JIpXIb2fyvL3B9cd+KZpX68gMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739817297; c=relaxed/simple;
	bh=+V+gFWH9+BvYou5jx8y0cf2ctMYbzEoKcuRoexCeO7k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S00TEbkvAZJW0qx+nzCV54iVoMJDzcXTFwalCK5Utl26Q2IwtCIu8GtI5S5PAqPjM64N/fWUayx1uakptUAKDq44e3S0ocEE+1+RAaUu6yKFQBIeIQpvkGHmO+UOYRa4RIXt8KJEHS0NLlp33N5YEAY7QetTZKb7VFAVCEpVuik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Gbnt0mI4; arc=fail smtp.client-ip=40.107.244.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IQc/zuzjmCyY240hmF6KlAUNJ1tituyGv/ZXAbvDSibxjOtxKGwNphkCy/aNltZkTRJnkyF2BgXUxScXqRqkM8kjLQWjtz0V34+8B+kjJ4ONXyJoo8C5WDZlrOcHrfmiH8a8xU978gaA7rEcQ9q+Lb23AzDPXrdiEb57htERKdkgnLmhwRthgZA95Rubi644+fA3cVTvJYURbtfabSB2bQvJb/5na+GrsvZkC//TcPdcXJgKc2/eE3wKs80R4hKUw4WHdlHHzkb43/laV7aX+68buwIMEQRnoRQJUqdjfEufza8MH/ZZd1bS+v3QpF60qx6F0rZhNLLFCqFc1+RnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R79Amu7fOeoz7er8pJMjWNnX7U56ySEI29b1JvK8kSg=;
 b=s7JpR/rpQp4UkXtVys2ZUGGqq1nZaL7mxPz912iep4k2qmgKTUX9CfO/ie10piYr5yOTfiGR763EfzRwRoGqt8Qbsl1KWfXkhnmF81/kHsQt36mYj404m37bD3qD9x0pPs7JiVkyykeomhgGkxp2eJhUpcL7vyy6If4mAo1zXbfDYq+MhrjSuuPlSG/oxSow1c37lxD4unR90TZPnLNDnSEGUDiBGM7pD0ItELKRJIWEleHxuCwdpVKE9OQEreImwjkr15hGIymSN3Sge8QGvgOAuPDyBQcK+YGHDujpX6/MI1Kjfnzc3bIABVm4z6hsvPAbOF9Qypi+w+6aSp8uIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R79Amu7fOeoz7er8pJMjWNnX7U56ySEI29b1JvK8kSg=;
 b=Gbnt0mI4b0SzJQfoXlOhtvWhiHaVqCaBNX4zEPG4+CX79uFvy67ehcdvW+R7xg+qXV89uLV1ycoFOhufbbKQA1hP4CYP1OhrfVcysHRvAY2pHgmln4ie+qKJ82qWN0jNfqZY3qy72V1VPGs/SeD3BiKPzSdjVNy2qloAlKaF+js=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8563.namprd12.prod.outlook.com (2603:10b6:8:165::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Mon, 17 Feb
 2025 18:34:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8445.017; Mon, 17 Feb 2025
 18:34:51 +0000
Message-ID: <fcd943d2-9c6e-1662-6b6e-37e5235fe57f@amd.com>
Date: Mon, 17 Feb 2025 12:34:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 5/5] KVM: SVM: Enable Secure TSC for SNP guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250217102237.16434-1-nikunj@amd.com>
 <20250217102237.16434-6-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250217102237.16434-6-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: 56f7396c-2446-468d-b9ac-08dd4f81c3f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bEg1MmlDS2lFQUt1ZW9iVmtpdGQ3UVNpTFN1U09xbjNIc29xZm1IQ0RnTGVS?=
 =?utf-8?B?Z09LRU9jWUhhQTBuZU5od3hPcnlzK1JOT1dMVG5BS3NnQkxodXdFYlIrRlFD?=
 =?utf-8?B?WWdVeWF1TXpMWlB1WkJLM05pa3hUS29Xck1sZ3gvbTkwVXRGenVWbHNabmd3?=
 =?utf-8?B?V0trSlBwenlRaXk3YVBJVDI2bE5PVFRLTUxJVnF0NjgyZlNjeFloQmtPdko4?=
 =?utf-8?B?d3FoMENTcXQ3ZnlPVTZvNUFkdzE5NUxteXZBTC9ETjBaWTgxTU11TXBFVElF?=
 =?utf-8?B?eVQ3cGppbmUzcjFSbG1iN3p6YkdHK1owbXZrSW01amw0YjJvczd5TTgxS2ZO?=
 =?utf-8?B?ZlF2UXR5YzRRdkt4WkFueG5lSWxMVUZTdzFRV2FFUG9hMEd1SngyNzhGNHVN?=
 =?utf-8?B?b2l6aGszMW9NU3BCWGFIckdPTEdUSmdma2Q2NEVnMTcvWkplYnN3aDNBOGRp?=
 =?utf-8?B?SmN5azRvcHU2LzVhdFFCSnVJVU1QU1dqb2hxRFhGRis4UUpxYVRyOTdHY2xo?=
 =?utf-8?B?dmEzNWluUDVsRjlSSGZaVWFRUm1RTzB0NTY5ZXlnU0lHUUZRdnJPN2pyZVND?=
 =?utf-8?B?U003bkIzWE9RTDdsOEg3bG9yc1lFU3c0eWcwMW1wOGFRMEplS0V0SE50azkv?=
 =?utf-8?B?YXRyeGZUWFR2eURKRXNmbWNtbVNWeklKd2dnbC96YzQyREVkWjR0eVprZEVk?=
 =?utf-8?B?YzhWNWhoY0tuY28wQ09Tc2Y0VzNPNTdXWC9xVlh3eXBOLzZFdEMxQmdYbmpu?=
 =?utf-8?B?YUhkZ0NBT1dhcTNSZzdBVnkrenRTZXBKajBVa1dBSEZOZ2VzWTlJK2pXSGt5?=
 =?utf-8?B?WWxycitIN1BpZ1pvaGdQUmV4YUlCZTFEWHRhQzNlNlRUVGhVT0NoSU5lZ01G?=
 =?utf-8?B?NVBPNnZWbW05TUQ3MVpJQTF6QWp0aDJuSkJRN016SzJQOTdvMytQUVJDT2Ur?=
 =?utf-8?B?Tk12L3cwMUNpQVplNmFtYnlRK2tIMHNnWVc0eVNPdTRFMkFscHpsRDA0NnZB?=
 =?utf-8?B?MzZXSWlCVzRET3BKQ2hTSmpQb21BWlV2dXF0Uk5TOUs5TWU4TWJSdjNhVWlY?=
 =?utf-8?B?d1IvbnRkYmpwRW5WL3JaZys0YVdia094YkxLTzUwWVlRYzY5UTArZjl4Mlh2?=
 =?utf-8?B?M2VKRXlHdiszeXJTMkpzTFZWUERLWTZyb0pXM3praGVNOThtYVpSTS8wOEtr?=
 =?utf-8?B?c3BxYm1KbURwb0VyTHlqdENqdVNVdXNQQ3pKZUpHTU1zVkhkdjc4RFJsVDJw?=
 =?utf-8?B?RlpCM0pDaU9NRXJTUDRDeGZRYjY4cXN5SW1jKzU2RDkrNUxtNVpPTkEyZTlL?=
 =?utf-8?B?QXRJU2J6NHQvTUZjOWxjanIvMDNXa3JmMVRTVitTN3ZIZURLM3lja1dMNjJm?=
 =?utf-8?B?UlNvdVNYalY2ZEJVSmxrenJiK2dPV05WemdTQk1sTnp3aVlwbTdpQWVzN2R0?=
 =?utf-8?B?R0JISHY5aWcwUCtLWEd3ZGRnemJ2SDZNRkliejRjWU4xemhrNnJRYVpGdmRs?=
 =?utf-8?B?M2NvMnhpNXNhSmcxQUEzc2FrQVBneWozcUppZ2pwbjh2Q2xYLzdTdWJIdEda?=
 =?utf-8?B?WWhHVkhDemRJbWs2Mm82SmpQTS9XZ2FJVHZsVE9EbU03KzQxNG1uRm1na1FT?=
 =?utf-8?B?K3BZZ3hwRGpSZDZHQmpoRFRJZkVGaituM1hpVThXcXhlQXFVOHY3RVZKdGVy?=
 =?utf-8?B?TlVmWVIyN2o0S1J2VllQVUJNbnRVbmF0N1ZLL3FVZUhEbmhBZ3Q3TkdKSHUw?=
 =?utf-8?B?eXkyQ3g2MTVZMCtiOXRFV2twakhLNW54R0NSSlp4dG5nUXh5aEhrVkdlaXVV?=
 =?utf-8?B?OHo5U1hOb2Z0OGdZano0cHhkSHJOOTVPTkx4bHhYKzdNQWsybkpodE0zdEho?=
 =?utf-8?Q?0tWQysINjX11G?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEtmUkZTTjU2a3g4L056NGlDaXlybnpMRjZjalp6TmpmdCtxQUZOS3RMazRM?=
 =?utf-8?B?SndYRUV2emc5dDVvNXA4eDVzRlZTTVhxY0R1eTZSdVpsRHFYVndsV09WZEZP?=
 =?utf-8?B?RVliTlJNVTZyc1hwMmR3WDhMdlR1RnkwQWhjYUtrT2Juci9hNHBGcFFmdGtE?=
 =?utf-8?B?MlpJdlQxYkFjMzFXZE4zM0Nuek9sMHMzdXhzMEhlZjZzUFEvNFQrSjQyOUl4?=
 =?utf-8?B?SW1IZ3hmWEFLS2drUlFqak9hVXlnalNQZEsrNTNkcmgyZ1M0VmI2NHM2Y0JW?=
 =?utf-8?B?ZjhNNFlKOGpVa2h0TWZwN3lvb2d1TktuM0hTVng0YmdPZU03UXFDZGNZRG1p?=
 =?utf-8?B?ZXR4UnBwcnA3K094THo4am14SFlMUlBtU1oxakUzRWx5NmxrazgxOS9hT1lt?=
 =?utf-8?B?d2psbGNLMDdFNXFwYkZ2dVErUmxLdXBUbjh5MkdhWklMUTRONUhZZmExbm9Y?=
 =?utf-8?B?WVR5RjdWN3hic2xoaHZYTUgxOUJPOGF0YTVQY0lCTVBERFB4Vnp4NFRvcjNn?=
 =?utf-8?B?UEtGc3VnTm9FRmFzUlZOZ0NrRWlUNHNIam9DK0s3ckx0WldyNXNiQmhJVFVG?=
 =?utf-8?B?cm0wVVM5VGxQSTJrbVRXTXZ2QWpmdmFvR3BSNHB6VEdhamd1Unp4Zy95U2Q0?=
 =?utf-8?B?SGlKSytoZXY2SHhjVy92M0l6UFI3Mk4yMnU4NFRMNnNuOXNBY0NGbUtsSTFi?=
 =?utf-8?B?emxTZlA5V2RIVjZOQkp5ZzZFQS9TNmt4NGMxaXhKUEVDSzZOYkJ5MlBpTTJR?=
 =?utf-8?B?SWZlWU5ZNUdHTGpVZWwxTUJZWmxZc3BYTmZFRnRmTFcxSFBiTnJoNUtubDUw?=
 =?utf-8?B?UldWbkFSWUk3UllsZHdYSENGRGczTmpKNTBhZTF3emd6ZUtZN2gvYWxjcDNG?=
 =?utf-8?B?dkRvU1IzaWpIYzFLU2o5RG0zdE1ua212N1FoRlZZQmxiM0ZTTVRVVzFJV002?=
 =?utf-8?B?b0NIMU0yQ2diVVlDMVA1dVBJeU04b1ZWT3laaGYzb3IrT0VDUFhEcGhTVzZl?=
 =?utf-8?B?TytOVWkwVDJRYWpQUFhlMWI1elpJNjBmR0pwaW9mTFRlb2cweEsyQ0EvRlpF?=
 =?utf-8?B?RTNFb25kZ0VrbE10bStzNURZSEs5TkJTcWRQdjVObUVlTVIrRXA3bDQyZ3Jy?=
 =?utf-8?B?cG1NVnNaak1DajZ2cXNEcjJoN1AydytUZnEyTndpVHVWdExSSGxrN1l4dnl3?=
 =?utf-8?B?aFNHVFdWOEc0VVZGNm9XUlhSZllJSjNSYTBGY21kYVpxNWFpTmxxYTdWcUtk?=
 =?utf-8?B?MDNhY1dZZHpqby9Ma0ozN0xMSUkxZHVHRVgzL1M3QUJRazQwMjdvWGpTak5N?=
 =?utf-8?B?TmZTSnltVm9aWWE4MmRCeDJFUlZNbmFGNTRLbU5ZMW5aRk81Z1FaSVlmNDFJ?=
 =?utf-8?B?NDFlUHFwZ1I5aU15M29wVE4zMWowbWU1SUovS0pxWTZLOWZSOHZKYnRnZ25j?=
 =?utf-8?B?N2pXMExHMHJMNzNyalo2VHl6ZjlJUGY0ZytEeGYvRlA0U3NpalgvQzJQSi9O?=
 =?utf-8?B?d1dQN0V6Sm1sd0Y0eW5qcXBkY1BnN2ZKWG9XR3pNVHZjUnY5Vm80cEtXeExC?=
 =?utf-8?B?aXU3NG0vYTZxR3lUK1hJOTBiSzM1R1BoUjJsRzQ4cHdPQjZYMkZTb3piUmpF?=
 =?utf-8?B?WUxham1ISS9xUHhCNmNVUWt5YVBkdkFjeUNhQy9DZ0MvNjdDcURkNjRMVjhS?=
 =?utf-8?B?R3VjZnhRTnJFUjNseVZEL1VLZGsyWG1CUFBvSUZxMnFMZjl6cW5MMnVZTHNw?=
 =?utf-8?B?c3prU1UzV3V0K3NYVnQxeks4dldFZUx6U09wTGx5b3EwRWkzb3k0TzB5Y05G?=
 =?utf-8?B?ZkhjMldLSTdWUW40R1lOSDFITXF1TGo5WDViVkc0blhLZ3BCMEhlaTc0ZTh6?=
 =?utf-8?B?NWFyY1BsMW51R0JkdmMwWTE5Y2xtZmVDS3BjNTlTY1NrcXVSbGtMWUsvU1dM?=
 =?utf-8?B?cHNzMkZLOW0wTytYZUxTT05VVUV4YkRpTXE5WHBzVHhoaWtEZ29BK2dwZ3BG?=
 =?utf-8?B?YnY2SlUvNUJPSjdFSGFrWE1uSjVzOHRzaEpHM2lsUk9BSjM0ZUdSOWZzSUtr?=
 =?utf-8?B?RURBQ0xlN2FrNEp1OTgzNlVxdnJ5Y2ZUdTFXam5mVDFLOUR2ZzVCUVRFbjFU?=
 =?utf-8?Q?qk2Mq+cCLhde2hJvzppkmgE7X?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f7396c-2446-468d-b9ac-08dd4f81c3f8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 18:34:51.5858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7FVIu5S0F8Uk31NHMASLQwUb7BEdBzlUFolG02A96hM6TgV8QAk23TUKrV27SHqPvMNCImX8tHO/NXXuur80w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8563

On 2/17/25 04:22, Nikunj A Dadhania wrote:
> From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> 
> Add support for Secure TSC, allowing userspace to configure the Secure TSC
> feature for SNP guests. Use the SNP specification's desired TSC frequency
> parameter during the SNP_LAUNCH_START command to set the mean TSC
> frequency in KHz for Secure TSC enabled guests. If the frequency is not
> specified by the VMM, default to tsc_khz.
> 
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  3 ++-
>  arch/x86/kvm/svm/sev.c          | 20 ++++++++++++++++++++
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 9e75da97bce0..87ed9f77314d 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -836,7 +836,8 @@ struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
>  	__u16 flags;
> -	__u8 pad0[6];
> +	__u8 pad0[2];
> +	__u32 desired_tsc_khz;
>  	__u64 pad1[4];
>  };
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7875bb14a2b1..0b2112360844 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2207,6 +2207,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
> +
> +	if (snp_secure_tsc_enabled(kvm)) {
> +		u32 user_tsc_khz = params.desired_tsc_khz;
> +
> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
> +		if (!user_tsc_khz)
> +			user_tsc_khz = tsc_khz;
> +
> +		start.desired_tsc_khz = user_tsc_khz;
> +
> +		/* Set the arch default TSC for the VM*/
> +		kvm->arch.default_tsc_khz = user_tsc_khz;
> +	}
> +
>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>  	if (rc) {
> @@ -2929,6 +2943,9 @@ void __init sev_set_cpu_caps(void)
>  	if (sev_snp_enabled) {
>  		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
>  		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
> +
> +		if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +			kvm_cpu_cap_set(X86_FEATURE_SNP_SECURE_TSC);

kvm_cpu_cap_check_and_set()

Thanks,
Tom

>  	}
>  }
>  
> @@ -3061,6 +3078,9 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
>  }
>  
>  void sev_hardware_unsetup(void)

