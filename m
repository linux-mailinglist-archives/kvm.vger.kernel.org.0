Return-Path: <kvm+bounces-31550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9855A9C4CF8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 04:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29DFA1F228B6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 03:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF2120512A;
	Tue, 12 Nov 2024 03:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1jVt8NJD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD6119EEBF;
	Tue, 12 Nov 2024 03:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731380486; cv=fail; b=IU0ciAH2nDG1ftGiYmQLk6yy6uSI8gTcD3NTTq+qGJSYZuEo6yKOVs8FNISPIouRpklgQuTIPmdaq/ZpQ1ogp+ZCaS1KokRaDgtHlF2QhAtXCqPN2Bmvpp2kmK8OY1DOmU+Po+9vnE0dOkEX0PRzFXC7RpghWEMcWh4oSkE/jr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731380486; c=relaxed/simple;
	bh=Gn17Xb2MWEQssWL6wyFVl2+9abRldzecnD8p0WPUNpM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jTcMA2f/nRzkp7x0XOvpmHeN9xqiuQQGcxAx4cTyKLxSmbtNAVU9cBHwFdVCVIcQ1e89RKuelVqqi1UfHJ5RVvZiwcfxCtOgeTOu1aXIclmHd88Q6Lo/WvbXdPQ2bzgtrAxH7Dk722+iLB0U8qN9WHVQZ4HQ6dnbaa7cxdewzQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1jVt8NJD; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ApZM6LXLxldeTRZp3RxjnRvEwdAPqjXZEvIkutO7LfmWxq6hGSj9110dSIU4He3ENLtetWOxr3Niw8b49y5Ikp1nIeTeCtCFZ6+P33Azn/rIUn3FhjhvJRbUj1Cn/2PrHICW6kd+QteK2j8jOBwaXwPyp250hYySMX3Yie/REjy5IvqyiiCr8DSoTz9tVFjg04JboaaylvZltyrZRex+WsPG81IO+yIOPI7jy4NyHTNjLqDDj+8Pq/la8bhqEF5h1hDggI0zvq2pcFCbsm5GJmqxEvvfD95pPC80q6kz6f1ZTrQnYJyT/jPqbNZLGnQyM6Wifv1papRjZ4/nPSARwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKBEAz9CFEE/QBF01D6xqsOo9VgF3nIDHTFzkc8vXJI=;
 b=Dc6SR05LdrVJevbZqmThiy5WE53fWCBeD24J1zAmjSz5pL3n0gBBr6lBSWnWan+jdWF0uD1YV0F0eJicp4lrwrTJ+L5g653Pcnp0El1YOcMvriBf0zrvieAwBrNv7R5ZYPsWBo5sxxzOsrxTZamzSTkd5rRI4NQboAz9l52iTH6HDr+4oilNtDcOXULDIuQAog2RqOjeNodO70w+vFqLEPj6GW8KR7vibDVIruyriG+D3G2tSAiOCUJy+QEj8qaaMSgn6EntRGn1rO6tKjegjebV0xYtgReOWKj8Oah3N5vMdw+mAuFDhATx+lLwDFn+Ggq/dpqZX25wIjBEkg06Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKBEAz9CFEE/QBF01D6xqsOo9VgF3nIDHTFzkc8vXJI=;
 b=1jVt8NJDOWVoXqQDekTzFloc4JT7eGT2xntkcroh6IhIlRxT/Idtvfz9AkkTnc/AcQfomtPSLUh471tPruGo5IYb758E5qYL6zwT/kRpJQxjSkKs9ZxHI04hVCe3oEW4SK+jOU0Y/mc04qEKCCrhQD1ijhK0kJNcDXa25ulK+NU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH7PR12MB7818.namprd12.prod.outlook.com (2603:10b6:510:269::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Tue, 12 Nov
 2024 03:01:21 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 03:01:21 +0000
Message-ID: <b3616456-25ef-49ed-9b4a-65a38a1e50ae@amd.com>
Date: Tue, 12 Nov 2024 08:31:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 04/14] x86/apic: Initialize APIC backing page for Secure
 AVIC
To: "Melody (Huibo) Wang" <huibo.wang@amd.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-5-Neeraj.Upadhyay@amd.com>
 <e14060e6-ecd7-4933-b53e-e810d747c335@amd.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <e14060e6-ecd7-4933-b53e-e810d747c335@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0014.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::19) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH7PR12MB7818:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c280599-a973-4eae-1db7-08dd02c64968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VURYdHlmTXA0S0dzSWNCcURSRzFyWUdmcytWelhZcUhsdVUzam1DWkdnR1hD?=
 =?utf-8?B?TGhEclJSazVHUDc0bkM2NnJ6S0hTTWR5NkFyNVVybnRqOS90R2RmNzkvU00r?=
 =?utf-8?B?WmwwZ1IxOHJjZmVrRFBESk5RaHFHRGNsZEZrWDByMFluZUEzUUxSU0p1Ykpx?=
 =?utf-8?B?ZjgxZ0paaWM2TGtZc1dMNS9TQUExbFhLZ3BLanByYktlTEhGWjM4cmdlN3Mv?=
 =?utf-8?B?MEsyc2ZBZENSelBmK3ZYWkN1QlhseUd6NmhjWEF6NXpjMDludjR0c1BCcFRB?=
 =?utf-8?B?OFR2WVlEaUxOa0JZZzBSdUhTWnJQbFg4Skl3K3lTVi8vTWs5dUNVbmdqMWg3?=
 =?utf-8?B?b0VrVXVNQnA5bURiUjI5UTR2d2V3UVJLcFEyWk5NZzBxSitRR2dMa0JCVUZC?=
 =?utf-8?B?SS9RU2VDRklUT3lLZ1BiNVMvY3N5dkxvMnJ0T1BwOWxEN3U1VEhuZytod0dY?=
 =?utf-8?B?N01Ra05OZ2ExdDVhUDlYRXBBY2NwbVFYZ3VRejBEcDVTTTRpWDdrZWZGQmtZ?=
 =?utf-8?B?Rmc1VFdDenJIRW8za2VtQW93VzN2VzdNTS84c1N0ZWNVb0h0cktkbEYrR3Y0?=
 =?utf-8?B?U3NsT0xPcFk1d080Ymp1QzFDYVhSOXQ5LzAyWGRINCt3Z2F2QXlrTjI3d3Iy?=
 =?utf-8?B?QWVPaCszYWsvakNKZ1lCeXhQNHZaUnRKUm1ORkdBTmpGSWc1L2FJWU03dGZX?=
 =?utf-8?B?bjB3b1NhbkVSYmJHbnQ4d2pCQVgyamQrUTdrZmgwYndBSWN6K256VzRuU3E2?=
 =?utf-8?B?c0tsbm1iR3JxakdSNG5RbEY0c0x1V1FhYVZ5NktObmtHN3pKSFhPdXZJY1Ux?=
 =?utf-8?B?REVUSlg5UkFjYS83bkQzdkw1RVJyUTI4UmZPMHRoWjZXbXZpZHNlcmZQZ3A0?=
 =?utf-8?B?ZEh2c2U4VHA0a3Qrd3RlZG5PQ2RZNmZSSTkxRUY3ZE1FMGpzbzV5QklsVUNW?=
 =?utf-8?B?Z3pQL1N6N0RVWWhEaXZhdXJRWGhnOWpXY0x0cGhSNkpMVmZVaDBxWVh4dm5p?=
 =?utf-8?B?TWdFSWh1RWJDTHF3YUh6NzBUK21OM3FySlN2V1o5b2V0c3I3Yk9VQ1dYMTlV?=
 =?utf-8?B?ZVhCWTUreStueWJkbEdnelFaL1g3dFc4UGpLSTQrTDBtdFRhSHVHd1FBVjhm?=
 =?utf-8?B?djBXM205WmtvNzk3enNQQjBXYmZ6MFZGbXdZMHF0TCt6eDRkdEtHUVR0Q2Rv?=
 =?utf-8?B?dzB2d1JkY3Jpb0Q5Z3FsMjNuSitqVWpLUnZEbXFiNUkwcE5MNW1mNzlhLzdF?=
 =?utf-8?B?NzJYdlBlMCtTY3pTcVgrN0NLN0NWVi85NStXMG9aRGRjaXVEK1FwWTZLVnh5?=
 =?utf-8?B?VWtPa2xTWWRjbFM2ZlNrZDA0RXhsZFFybmhMU1F2azZMZ2hpUlA4TlhZdjBF?=
 =?utf-8?B?VmF2d1oxNDV3b3BYUStmem1OQll3TDZYQ1I3UHlLdGZnbjcrb25UZmQydDJn?=
 =?utf-8?B?SjUyMFdZNW94a0RFd3BMbW84MGo1K1lDbHBZeWhHU3lXb3FFbmEvaUNBQ09W?=
 =?utf-8?B?aTEyNEg2dmV6Z3BCRU83d2FscTV2NXE4TnJmR0FVc1NDM2lpZHd0K2dqdDJy?=
 =?utf-8?B?eTVrN1U5L2tGL0prKzdqLzB4WXdEUDdkWTJ6d0xJbi80ZEU2ZFNsZ0J5WlZa?=
 =?utf-8?B?ZkJNRjBObW9wOXFKWFdXTGdFNExmNmVLMGtLT2FFYU9lc2puMEE1UEZQcS92?=
 =?utf-8?B?WmpwbCt3clMxWms2RDdZVzlQTDhmSHhRSW1wYnpZcVkwNEZLVlYzVGl6WDV4?=
 =?utf-8?Q?u4y7ZDhDNh4I8X9tY0sMTHO+/S50wcwkejhstgQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUF2N2l5WnVsSWhJNjdJanh6RWhtOTZJMWVwYWNld2RpdW9nVGc5UVFuMWZD?=
 =?utf-8?B?NEUveWJTK3JRUFBQSzc2U2ZKcWIzTU9UVUcyMVk2T24wWDBXcjZtd2NiZS9N?=
 =?utf-8?B?b1FZVGJQT05YMFF6MEU5dXhMbDR6WkJheStGZitLc3FhSnd5OERVMUM3SElZ?=
 =?utf-8?B?dms4RnVMa1AwUHdqNUF6TDhrdVFOR1IwZ2IxUjRXUmZYM1h0cXdPZ1dVRW03?=
 =?utf-8?B?Sm1hOGQzT09CM1RGUFlMR203Zm1FMHdZZHNRV01KOEVnTkI0dXpkdE15dHpW?=
 =?utf-8?B?S2szcENKVStQdGI0RmFJcXJVSnAzN0VmRHg5bWsxODkrYnBUTStLSThCeGw4?=
 =?utf-8?B?YVNYM3Z0cnlGVjJwM0Z2TldmNzFtY3gvSG84eHYzWkpqd3QxQ01RdXVEQVFq?=
 =?utf-8?B?SE82Ky9EcStydERBNnp1aENQU0ZVYlFvcEdhektaYmFoYzV5eXJzM2o1Ry9P?=
 =?utf-8?B?ZnBwY1g2YThwdG5MTnErZ1NpdmtsRnRobWV3YjNhMytDYlQvay91dDNFZk04?=
 =?utf-8?B?eG44YWV2dlVlT0IwQ3hyY3dQSFBXeEt0V2c5THprclI1WUtGTzRwd2xaOE5U?=
 =?utf-8?B?NGtSSkdaQ0RFTGxiQXZIOUJzeDUyTWFZdFNhUnE1bnE3NnV5NW1DNUp0ZFJh?=
 =?utf-8?B?YklKb3diMXJ4ZmtMcUVhZG5yeVdRYWFqaklyNlBsMG9KMTZ6OE15RTR3VC9z?=
 =?utf-8?B?TG1CbXRaZXM5cFBaTXE2UE1SU2YxaXhKTjlLQUVlbGMwZFRycnRJaDVLK1dy?=
 =?utf-8?B?WW9tajBHVDJzREM3Qk5DOHlPSWZDVnRUSVlPM2pIZGFwd2N6L3VJelBnWStT?=
 =?utf-8?B?bFh6Y3pRSDRXbjRQeW03QjNYRDV1ei9zcno0Z3hQSlhDOTUrMStlT1dBaitt?=
 =?utf-8?B?SnFZcG9OSWY1VDBITkpMRXdVTTgwRk9WZ0NQN29jZU02c2pYNVlkQXplSWhx?=
 =?utf-8?B?NEp0RkpIaW9sTHVLaVJhcktmSGxXOURGL3hzb0N4dTViTWJiVmtuc2NSMTNZ?=
 =?utf-8?B?YmszNHdqRVFQREMxUHpmQm91S3JkOWVWMnAvUExIRzM4eXROU3g4V3FiSDNJ?=
 =?utf-8?B?WG5td0VmUWNteWp5NEVLaDB5VVcyZWhSNTdNbmFLbWZieWtkRHo5MlI5Qjg4?=
 =?utf-8?B?eE1JVnRyb0xpRlhxTW1MdGZGbVlUSHRwZFN5RUV0ZFhyVzVieFI3MXMwMnBh?=
 =?utf-8?B?S3FqNlk5aFQyZTNQQWVQSWJxRE9MRC9pcEVOVGtUTitaOXUwa1NSZEk5U0xl?=
 =?utf-8?B?Y1VqbHMrdEo4VFgrZEFma2NMbFZMMkgrNGFyQXpUUEV3aGlHKzVVYXVCU3M0?=
 =?utf-8?B?MlVxZWVac1lwQmJmWlZiZ3k3NVdHbFcybUowWWlVc2dYQU9Ed0h5MHhwYTRi?=
 =?utf-8?B?VktKYVc2cTMwYUFYODZTVm14UGJDL3grVklYbGkwUThkMnhMc2h6MHhhQlJh?=
 =?utf-8?B?QnpjVXZpRW84N2ZKZ1VYZlEzdzJEV0sxTUQ0ekdnNTl1YnltSFRxRDVUemJm?=
 =?utf-8?B?NWxIWVdSOWxVU2NSNGhyckF3STM0ZUFHS3BCcEdNNTRUbEw0NjNSK2psRnhr?=
 =?utf-8?B?QWxDN2tHZS81Vks0UmJTMnNRL0dVRnB0alQ1WDNzQXFqTDRnNHlhMnVSdTN3?=
 =?utf-8?B?WXU5a3JhRkZUY1EzVzEyTk1jai9qaTRqQXo1aXk1Skw5c1Y3aUVIR1k4b3o2?=
 =?utf-8?B?YVlDVDE0aDQzT3NLcXN6OVRrSlZpYjNxWEV5SVBSUXRjdHNmRk0xN1NqWndU?=
 =?utf-8?B?R2cva21qRExIYm84c0R2UHBWbUk3bmJVN1BUUTUwVy80dityU3N3TFRqZG9a?=
 =?utf-8?B?VjVyVC95WG5DMHptYmJyZlJzak85bm50czFDU2UzZlo1enRKYkR0ZVZ5aDVY?=
 =?utf-8?B?TGZsMDdpNVNOVnI1SjNtZzVVMlR2ZXEwNDJDMkFTdW9zQ2tsTzJ5alByWm5l?=
 =?utf-8?B?VHd3ako2QWZucHhkTktVdVgwNnQ1OXdtNyt4QXpMZjB4VC93YW8xVXN1QU1q?=
 =?utf-8?B?T3ZDb1BRUFM2aVhqdjdZc2I0NDFndDN1NkdHNjh2bWxJM2R2OTJEVExQc0di?=
 =?utf-8?B?eG1EMmd2bzcxRUJ0TkdOdFdCaHFhQ0ZJK0JvNm5FcS9JQkJSVzFLV1NOcDlR?=
 =?utf-8?Q?E7kpLyMnnah3XoaPrLAGPUQ/M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c280599-a973-4eae-1db7-08dd02c64968
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 03:01:21.6300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K+WXUpxsPJD6GbD0qaj694xvoVloNjoe869KJzNwLAS59j4MxtCWOtaPz/A03LRHKyJWMyLUHyhmYT8gBE5Vwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7818



On 11/12/2024 4:13 AM, Melody (Huibo) Wang wrote:
> Hi Neeraj,
> 
> On 9/13/2024 4:36 AM, Neeraj Upadhyay wrote:
> 
>> +static void init_backing_page(void *backing_page)
>> +{
>> +	u32 val;
>> +	int i;
>> +
>> +	val = read_msr_from_hv(APIC_LVR);
>> +	set_reg(backing_page, APIC_LVR, val);
>> +
> 
> When you read the register from hypervisor, there is certain value defined in APM Table 16-2. APIC Registers, says APIC_LVR has value 80??0010h out of reset.
> > More specifically, Bit 31 is set which means the presence of extended APIC registers, and Bit 4 is set which is part of version number: "The local APIC implementation is identified with a value=1Xh (20h-FFh are
> reserved)".
> 
> I think you should verify those values instead of just reading from the hypervisor. Also, I think you probably should verify all of registers you read from the hypervisor before you use them in the guest. In other words, sanitize the inputs from the hypervisor. 
> 

Ok, I will add this verification of hv read data (wherever applicable) as incremental patches.


- Neeraj

> Thanks,
> Melody

