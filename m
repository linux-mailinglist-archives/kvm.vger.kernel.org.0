Return-Path: <kvm+bounces-26839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B339197868A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F8BA1F2382C
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5887823C3;
	Fri, 13 Sep 2024 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NLOIEfAA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F454F20E;
	Fri, 13 Sep 2024 17:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726247978; cv=fail; b=oGdZAIp2LL+xkEef/iJZiUMqH0r3RloZGuOuSKIgqxC4xKytDWDi4qESKNJvxwQX49hZzf/DrB/uBpVki10JVmaW/F5bvtqhbtXNDo++1zarJOCyzE5fB6oPOhcSD5SMUIGiMMyMT8Lx5NFILrgFK2Ay2fg1KVpkVfAyZ+icbL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726247978; c=relaxed/simple;
	bh=KB5XGSb4frM66Xo8C4ofaBOaCPdpbkCkO3Obl/mWZ90=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LKR2r4d5V/9KpqKl98k9XLoFkXsizBpb/IEa+5Sq5WxTG4jsf/59uerc0c8VHJ9CbR2G+5Ndh32XxH1hivqDDeQHZQVaIezZsVvZZ69IVAyQjLc/YOG9seiBVKQyiPKD4mf9d/ft+ax30F/TtDfZSNLGTDeIZUCPb6upomF3krI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NLOIEfAA; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B801flB7/NqCofZ9ADx/RcoOTCmAZAc8GqdQBed3VZcSu1f/+8si6vpcO4phK9Qvt538B1VlDnougd0swqBEIt0P00kJeF2bpP2iFbkgjtoHZvM3+5T8zLTfZqf0qQfl7lge12IhMIP2JhJtcvyaANvUONVe1smMh4UcxX0JLBY60eVcPtAwpndR47Yyyfu6iDErtiQsINBzK6LO67d0Zr4c5QulM5+2jms+UmoAw/p0Stn5eEVNEajufJ36FHc9E7bNOBs+h4oETAOH+vvppPfK3qUmdXetVSD4/0yZEe871goV8378wq7mm9hvKGy4nuldiqtjOn+Nsyd4KgQbqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cm9MB+0ndmAJiAfqN1lS7PLnuQ1kduxafCizackNcGg=;
 b=fTQ7Mm9BQXs6sY+5j/Aa2j9SPRYNEV8WrgLS3kd+nL4U2A/CFTmP6uiR1EtKqw39ZGDkk610TJfbCnP452VPiGwp/j9UjAUvjKsCA2dPdYDjqBQLubAkZqdURnhipzX1zsErv27SZOzZztqTKWrhJ5EACd2TO2fcPz0dGfesiF2J2qmhlWykgDW62NAwGuOQ+1YtZTVdf5XhrM+e2k0rpolv6XGFxm+iRC6TAGTcalISgr5yY7HXHEw04H3Nhq4hdPWU4YIxlDjjUNS3sh0SDj/V5OWqjVUkiRDBT28NlNrcrFTmM/OAOvf+iZce0hfxw1S2exNsDV1+GzfNyyYBbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cm9MB+0ndmAJiAfqN1lS7PLnuQ1kduxafCizackNcGg=;
 b=NLOIEfAA4JvKwZAttoJPmIBtRLTFKd+7/u09CZ7V5GrAn+g630x7fNdffAehCdvuDEQEUojNHeZ4Sv5pycIdUoOghxcVUX20UwqAVouiI1dry3B7s+YADk6klgoAZFWHZyG5M2z2qFKvJ5s+BkZ/kfHEuoTbyvNgC27QE7Ecs9Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4115.namprd12.prod.outlook.com (2603:10b6:a03:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.21; Fri, 13 Sep
 2024 17:19:34 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 17:19:34 +0000
Message-ID: <d6be5402-5e24-0e9e-88fe-3c30fd4551d5@amd.com>
Date: Fri, 13 Sep 2024 12:19:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-20-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-20-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0169.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4115:EE_
X-MS-Office365-Filtering-Correlation-Id: 33c1d0b4-4c35-46e1-a488-08dcd4183cef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S25YbzJnY2dqdHBQeEROazdRR2xYZEtUU2VXczhlRU0zQ2ttNHR0Zk04Vmx2?=
 =?utf-8?B?aDRPTnJBNzR5VnluVDJxN2VobHp1QThQNGNhYXJmODlkbmdzMWgzVFRTbjhq?=
 =?utf-8?B?V3FXMGJOV1U1cUorN3Y4MWZnWENUZHhEeUVjQ2pZM0p1L3V3cDBrLytnTGRO?=
 =?utf-8?B?czAwbis5NXIvb1lJNjArS293VkpCc3EyZ2VNRFZ2eEQ3NHpPZVFjMDBxeDhG?=
 =?utf-8?B?UXJyd0JaWElNQXY5VmJBMVNpaHZxa0lMeUZiU0FkVlYvNnhMd25HZ0RBTk9W?=
 =?utf-8?B?WWN5RHhQN3Jzd1A0Qk5yQyt1NUhoYzhXc1BJQW43NFNOWkU1YnRYZUpLczJv?=
 =?utf-8?B?TXBPa1czL2E5ZjB1QjJxdUlRWXhVU0Vaa25jSEZZRzlvaDh2MDZSeFhrRm1y?=
 =?utf-8?B?MW1wZFk0M090N0R4dit1UWVha3BmUW8yNTFHT3BXeis1V0hTZnJLV0JqUkFm?=
 =?utf-8?B?QjRQSEIrODZManByUk1PQUM2U2NSMFRMRlJnUTJsQmlVak4wU1FnemhCeXRG?=
 =?utf-8?B?MkRFZi90MEgyRE1HSTB5aVhBdlp4YUk1clNjN29mVFUzckxFYnNudWFtMmpJ?=
 =?utf-8?B?U052ODV6a0pWZmd2Q2NoRVlmTXdhUFpmN1E0VzNpWU1KdkZsaWF6VVhqclpq?=
 =?utf-8?B?Q0xkeS9LaVZyNEMxR0U5L0hDZWhVZVpnTW1OQjNNY3hsTVdMNlZ6dTR4NTFX?=
 =?utf-8?B?TlpiQmhEZzQraEptdHlNU2NaWGJIV05kc1RzUHNBL1pjREt0ZVAvL3ZvNmFZ?=
 =?utf-8?B?T1BxM0Nydzl4WVkyQVNvWm9QWDVCY0lpUmZYMFoxU3VOM2QxQ2lpajcyU3Vo?=
 =?utf-8?B?eDdIbHZ0ODNUajVFczNOeDUvWU5sU1pzelN1KzVnZDgxc3YzK0ZIMURSRXl0?=
 =?utf-8?B?OEhiSFg1bUtMWk9NRGFMTS9TNzFZZmlFbEJRem0yeXRBendIZklVdEZiZVdC?=
 =?utf-8?B?QU1qbVU1QklML2Jxd29EcGJzWjZRZE9CY3J0Qjh6MS9YM1htK3E3K2dsbEpI?=
 =?utf-8?B?MnF2TWVVRGxJZ3ZtOUt3R0h6QnVldjhXaTA4cEtESm0zM1IwR1o3L1pOWDNT?=
 =?utf-8?B?ZEFYeS9BT1VkK2drQ0dBb1hNVkhYMVJjQzgxOUpieHRtRytwaVEvZFowQ0lm?=
 =?utf-8?B?aitRUmVEMW9OQ25adWpoRkdPbDc2N2h1dnlqQVdJVXdDMnhnRytjcGdxdXdq?=
 =?utf-8?B?MXlZKzBzeHdHa3UrM0xjSW5rbURXUU5wZWI1RFFqeDBIcnNNb3l2eXY2RmVC?=
 =?utf-8?B?cHVSRzlWTWt1U0M4Rkp5MVE3eEVMOGhiUmJGcW1QVzJTamY2NFBCZXl3dzAr?=
 =?utf-8?B?L3NXTTRSQWQvOHplKzJseTJjRHRqSGFkR1VlSzRML1VreUNiTm00dUZGbkJl?=
 =?utf-8?B?RUNwUnhJYkZIdDA0WmROMjZGM1JwK2JkL0lkK3JqRnlIR3VKTVNrWUZNVFJs?=
 =?utf-8?B?b0h2d3I4STFnMm1TeUxQZWFpb3pucmFnSm8vQUQzVFV0eHNENXdCVklsSUtF?=
 =?utf-8?B?YTl1TElVUFh4UzdaS0s3V3RmM3dtMkpNUzJYSTNwRkZTd0RjTFFEMmNld1Bq?=
 =?utf-8?B?cjFOL21yUWJqYVlYOTZpY0wwbHVWcXdCK3dkZllITFZqYXNOQXdKRzZGOXlQ?=
 =?utf-8?B?QWZuMmh5WFlyZzFQWWZ4TXNrdWFMMnZNNUJQVGdZYzFpSVVvNGdXVlQrOFFi?=
 =?utf-8?B?S3FDdlBpSlNJSFkwVUtidWpieUNqczRTd1Z0bEx3YzlUeGFWdk5aSS9HY1pI?=
 =?utf-8?B?YjV2N24vNUY0enJOb3BjUXUrVUMrc3BKRUhpTFg4cTN1VEp3ZFdnZGVsTXpY?=
 =?utf-8?B?K0V5L2dXV0IwUDd4cmdCUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVNpRm5MNFlnOHNIaExCZzl2WHA1REFGN2U3LzhwMHVMdHcvSXlHNENrc2kw?=
 =?utf-8?B?L3FnQWE3NS9MejhPVXRvb2ZlZEM1ejhNUysxb1BNTmJTRXFiNVFMMzdYemdC?=
 =?utf-8?B?aVZDVjJrUzVCVHlKZnRHVlJWSnhZRnF1d0lCeiszd1dmYktIM2hxdWgzWUlk?=
 =?utf-8?B?cUVld2RaUU9tUSs3dVNZWUhRSkdaTXRvYXpvV3pXNWR6Tng0dHBaS2xGenFQ?=
 =?utf-8?B?dk1sZ2xLYTVPTjlDbW9BWmdtNzhTQTd1T1ljdi81SFdWd08rQ0ZrUERveS9C?=
 =?utf-8?B?L1FjdnNDUm5vcFo3NzlJbFBOWXlkY2FlaVpmdE8reDFyWlRnRFJtb2d1RUJH?=
 =?utf-8?B?WnptNlZwUjhoMmdJdXlneW9OSllCZ3doalBPeVZrdVNEdU1DOExleVo4NDZ4?=
 =?utf-8?B?YjV6N0lZWVR2dkVGTFZYc0JJcXhoWFgvbXBsM1FZQzdpSEJBUkl5RkxUNUVR?=
 =?utf-8?B?N0RRMDhGelgvVFZPeGtMQU5KcDQ0a1lNcElqak8zaHpEdGVYMW9Va2VsNHo1?=
 =?utf-8?B?WWZ1cXhFMXB5eGM0cjRibDQweXRCZ1Q2WHNkUXoxQS9FN1dBMkplTSt0d1ow?=
 =?utf-8?B?ZVlSV1R0VE5sVjZYRDc0TDVMZU1hM1NrY29PUzg2NlE0N2dJQkNRbnlTOTZY?=
 =?utf-8?B?d2ZqVjJSZ1YweTk5MHlOVVVwT2gyQUtNQmpYV1R2NG1wRGdMbWs3bFRkbUd4?=
 =?utf-8?B?cWFkQnJtNlFuanBJSFo2Z0JhdEZaeVR2MUgzSmExWm9KYm9iYW9mWUN5d2RU?=
 =?utf-8?B?Y3E2YlZuUE5jM0tpZGd5dHhMZFMxa3FZWWlEbXJKUGdSS1o2Uy9ZRmhURWIx?=
 =?utf-8?B?aFdJeEdVVmJWTEZFNHg1VHRrRVdUUG1uUWNjWHFzRlNIcjFEdVZIc1YzckY0?=
 =?utf-8?B?em9oQ2pNbW1GblUvdEErSDBCUHpxQzhOYlNRdCtDenlNSUZMcjhkcFlXYnFE?=
 =?utf-8?B?Z241L0FCUlh3UmZxN0tRRjVSZFBJUEpUTE4rWXkxYldWWW9Ja2RSWk5OR3oy?=
 =?utf-8?B?Vzhwd2ppZXAvTmVxbzFRTFZ3Y2lWc2g3RWxLclJxSkZjT2kwNFJjd25GQ3ky?=
 =?utf-8?B?VHFKRE9OeTZScTRVaURMRGVHY25BRkd4MjdqUUE4dUEyZ1NCTitrQUVFWGdS?=
 =?utf-8?B?S2kvNUQvUC9Xc20xKzFlK0huUnN5SVhza1dPOEN2Uyt6L0o3M2hhQjFWbjll?=
 =?utf-8?B?ZUlSZXVIbTR5d3djclNlbS94KzhEbjFhRGJUNURTNzA2TExYQ1pDYkozTWww?=
 =?utf-8?B?LzRJd0syQTdKMHc5S3NZQjNMaVYxazlJc2t0cHY1V0ZIcTZGMHhwcXNsQzdX?=
 =?utf-8?B?cHlEa0hoMVZDSkJoeFFMNzFxYURDcWZQMGsvUGRDSWtmQytpOG1NUkIrY0Zu?=
 =?utf-8?B?Lzd1VzNlUTZINE1UTzZXWHVUQXpzUGtQaDA2TGNJKzB1TXFpVmtkWXExUWlN?=
 =?utf-8?B?SkNVT3dmRkFCK1psOVVGU28zWGVOUWYrb3E5NGN1WnJScG4xRG1YMkJzTXBn?=
 =?utf-8?B?SWRMMUJmcVRvUGl3dTFGbWlOcGVnYzkrVGYrSlAxei8wSXRpRXZTZFFPVDVG?=
 =?utf-8?B?V3BLYi9aUDJXTG1aOG5FNk5BU0ZSNVJpdWN6VVRyaHR2M1dOaFlJY0gxRmpn?=
 =?utf-8?B?UVc0Uks2eGFEK1cwbWdndEV5dHpobG8vVnltYjFJa3hDaVpMYzdPakZCT1BR?=
 =?utf-8?B?TTZqamE4QlBZd1Z5ZkZNUjRjd1I2TTJtNU1kaTh1VUMxV3R5MzlHcnk5SitU?=
 =?utf-8?B?N2J2TzFsZWFGcGdrQWtSMy9mMWx4bUt0YWVUbGhDQW5LY1JCK3F4a05QWDZr?=
 =?utf-8?B?RGM1UzJHVFRqRXZQSGZKSzdreU9mTGVsSWMxZWVDeTdMcGR6LzBJeXJ4NXV1?=
 =?utf-8?B?S28xYlUzOStDVnlsRlVIWFg5enh6VnRGWTNFUll2eFZUbk9Tbzd2aEgrZ0R0?=
 =?utf-8?B?ZVZlYVJpUEFtRW8vTGpzalI3M01QU2RkV3oxUkJvM0QwMGdMT29pdlN2ZHpt?=
 =?utf-8?B?SGRXQ2cwWldpdkhJR1VGMHRCSHZ4M253d3FEcUUweFNoRmZGc2N2em9kMHJt?=
 =?utf-8?B?Q0JITXhCckhvQmRxaDQ5dy9kWTUrYUJVczF3ZXdkZjRIQStlRURyTEo3Q2po?=
 =?utf-8?Q?k9Ifqk+ew+hd/fra9Iao7wdTG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c1d0b4-4c35-46e1-a488-08dcd4183cef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 17:19:34.7556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfgsOJIDWthHPdzFJGGB/mp+NA9VmikezPiaqyGb8ngeNxfYJ/V9HUeVz6Pv6xUo7ocOPxIINbsDuDtyKzRTUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4115

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> For AMD SNP guests with SecureTSC enabled, kvm-clock is being picked up
> momentarily instead of selecting more stable TSC clocksource.
> 
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000001] kvm-clock: using sched offset of 1799357702246960 cycles
> [    0.001493] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
> [    0.006289] tsc: Detected 1996.249 MHz processor
> [    0.305123] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
> [    1.045759] clocksource: Switched to clocksource kvm-clock
> [    1.141326] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
> [    1.144634] clocksource: Switched to clocksource tsc
> 
> When Secure TSC is enabled, skip using the kvmclock. The guest kernel will
> fallback and use Secure TSC based clocksource.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kernel/kvmclock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5b2c15214a6b..3d03b4c937b9 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -289,7 +289,7 @@ void __init kvmclock_init(void)
>  {
>  	u8 flags;
>  
> -	if (!kvm_para_available() || !kvmclock)
> +	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>  		return;
>  
>  	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {

