Return-Path: <kvm+bounces-52599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DBEB0717F
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CD093A9B6B
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295A92F0E40;
	Wed, 16 Jul 2025 09:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5CNXROt0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2050.outbound.protection.outlook.com [40.107.96.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2D922127C;
	Wed, 16 Jul 2025 09:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752657652; cv=fail; b=ErGTmNFrsuDCcY/AtM3MEHcv9p/Ye3afn2FX+PE7P8T5MYTtGqmkDv9NII/ODyeQCjEPl59wH4IHp3nV5EMadortvRCtT8H3QKXOLk5jokU2M73p7I3kAfS6+LTZSqhNuwXV3/joO4OCoeA7CzEY3TjxgI4D3tzZi0EA3j/LUF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752657652; c=relaxed/simple;
	bh=63gyR6bSKU0U9E2N3gdYxeD3mtnj0VwSqnm0mVgZSZw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MrlYX5ElDWoY2SnWXUjT2CKkLG1yf4NEYKcHoQXIQUpCtaRgmvajt9aDubKihfDQQ/P5ModmyxeTWSh61KOy7e+FphGpksPdcyC+YEs4LWstuRJZbXAtdS2koJoWh5F3PWKYnvEN1ye8drg1cVp3gSroR/CG0cMfC8acie1WVlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5CNXROt0; arc=fail smtp.client-ip=40.107.96.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ef20rqs8sRdeWOkWkuiAeWIV8JUAayU5N7ZBWK5rDLWmU7MuPAcF7E4A1LL50VdJZ8crP+O9diD3akI5ItGzSDgGbQ+MSDOBbLeMgQ9uWAx3Wf+F5sqrRuFqstfcB9IftJcdBAkNyily3f9i6pnf/XjLi4KAXumyulb9c+LHtww4LdJ5UnfdoamRUHwakBV3haVx4fd22+AYkTr2nXPr3EhleIycCRZpJXlAzGSJVwH8l4udNaam00HMsvWYmfLryuSVDDVKcQwCn5yVhcRwfezUUruhfB77xvrvFKQCbbMF9NO0DjKCuu7/+N2/vteFPlzyFhjeh7Xay//gB0NAFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ui1a+e8lJeS1Cf/M/Ls4ievV3Rk+n/3lF3gKBUN4KOI=;
 b=tkN+IArcfmBeHi/NvESkvJkD1nHqEMrWltbpl9vGvCYDIJM8oWHT3ZyIoazjsfF4eIeoKOm2RrwPGFPj4PPSXOhQrmfB7J6dDFNjtNJqE5fe685yIxReE/9MwQKrnPzIUHIQePgaupZ9OkxikG0Qq6iAPd8QiU3ilJLfeJ+zPGWRuo1fF1KYjWW70LOYvMrFKlW3sx6AeiTcW3QvOtStcbrV6GkH8dM1Z0Jg5nSP/gzE4v/WzJ+NybWIgv/ne0gvIQegLC1ZHxxlNo5IDI6ybrm9F6/FszcTjFTfRK+K5gZrg1p9X8Zel+JIW+eVyASWQ/b61njzjG60ND1d6Ry+ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ui1a+e8lJeS1Cf/M/Ls4ievV3Rk+n/3lF3gKBUN4KOI=;
 b=5CNXROt07xdbcIS/eFT0KpNMoJMyFRlXAxE5/rVynp1sVRC99ib8t6JmxGo2lmcB2gVHc1iXMK2Z/obisEH8GbWwWteDJFSsPZM5bAxMvDj89B7fwXhl4vvwoaW9zsShGdrJZYhpqWa3ivbGYyUbZUUQrWBq324yoNojDheXxQo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 09:20:48 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8922.035; Wed, 16 Jul 2025
 09:20:48 +0000
Message-ID: <d7b3e0d1-4a93-4245-b09a-701bb14553d4@amd.com>
Date: Wed, 16 Jul 2025 14:50:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] crypto: ccp: Skip SNP INIT for kdump boot
To: Ashish Kalra <Ashish.Kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <ef1b21891b8aea8ffab90b521c37ab79d5513a7b.1752605725.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <ef1b21891b8aea8ffab90b521c37ab79d5513a7b.1752605725.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0221.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::17) To IA1PR12MB6043.namprd12.prod.outlook.com
 (2603:10b6:208:3d5::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 684d8996-502f-486e-1654-08ddc44a0c67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkthQXdQaU1ncHBYQkJvUHZTSTdEQ1BpbkV2VFFFMDlxOUM4c3dlUDF5clp1?=
 =?utf-8?B?OEppYU9XMWlFc3V3MnYyN0hMcTAvc0dwSkgwbldYR0huK3E5Q1hFQ2pGUUU2?=
 =?utf-8?B?d1RGUnJNUDBHV2IzTVBBakpTVnJ1MzgydkFRS0FWSU5yL3Q2ZVRCRmhOSDdG?=
 =?utf-8?B?MkhBd1ptSXIyVlJkcVJUR0RVOU9XbXZ5ZmlsdHVFNEdSTExXWmsyYU9WVnNx?=
 =?utf-8?B?YXNJeUlLbCtwVTBFZHRQUTN2RFpDVTA3WXpHTVdMckJydzc4cmlsY3hFaHVl?=
 =?utf-8?B?K0NEQy9HcVJQcHBwbWJmWi9Zd01KZ3FyaG5NTFIzMlkyZEVTaVNyUHdhUnJ4?=
 =?utf-8?B?c0hjT20rL3dHZXByaFJFcG83a3ZWenZpWHdjZ0QyTlZJOWNvMitVZFBOdkhY?=
 =?utf-8?B?aGZYVVdxdEsxNTF4Q2NqTnlkVEhtWWlJVElIZU1EY3BxSXNKWlBpQzZUQWc0?=
 =?utf-8?B?cFFBS2I4cmZNMzZDTTU2U3FtQWJqM1JnbjJLSmYxTGVxTzByQmhoRTI1YmpY?=
 =?utf-8?B?TDJDK0IzQnRUNzBON1J3d0dYcldEYVlsOHd5NHVZK0djVnkwQ1VyaXFaRUVF?=
 =?utf-8?B?QlhBNXpEQy9FdG45ZW1wemJPNm5LTTVFRlpZeDRmY2I1VmluTzFCWWJza3JH?=
 =?utf-8?B?ZW1COE9INzV4QUNscXZLbWFsMFFKM013bU5ES0NDOWdmeVlFS0JTLy9KNnRu?=
 =?utf-8?B?Ylc0bTg0RkJPd0ZyZTNuZnkwU3NUazl1UHg2dGtIbDV1b29nSGZ5cGc1bVhR?=
 =?utf-8?B?bXhTWHhFWEo3L1Y4WEVCeU1zbS9mTTRPSklPSzM2VGFQNEhpK1BZYXJZUzlt?=
 =?utf-8?B?MTFhWnk3NWFMZVRjcnh1VFZuTDhoTmNPK0dFeklRTXBEeXZOaEEwbmxKV1kr?=
 =?utf-8?B?RVozYUZNUnJQRi9nMk0zVmxkUys2YU4yVFJOTFNpK285bktIRmxUeHUrTXNq?=
 =?utf-8?B?dWdEV0w3NTg2cjdlZTdRRmF4djdISE8wLzNvTWY3SGNqMlBablNTbTZ3cHdI?=
 =?utf-8?B?bk54OENuaWZxQ2xtczd6Z1ZFZnBYTzRrR09YM2E5eFQySlp0YUpxUURhZUJ4?=
 =?utf-8?B?emhHbnFGWUFzYXR1SW5QUTF0RXk4c1Vnc1R1L3BKcW4yOU1kSjlLWVdFWWVk?=
 =?utf-8?B?SE9wUE9td1lhS2ZjQWNZWk9kcWpPOUNYSUJ0N2VDbHExQk5yb3g5cFZVYUVF?=
 =?utf-8?B?MlJSeWJTNkU3czBxU0Q0OW04RUdRUVVMRXcya0lsU0pRYS9iMDJ2Y1NpT2hK?=
 =?utf-8?B?YkNZMVhpM1hZSXZVa0pIRVBDMWF5aS9lQUl5UzloKzZodGh4MVVKSFRMcm5z?=
 =?utf-8?B?cXNPRzZ5TkhXeElHKzBQUFN5OVFhU2xTNzNnUWRDdU5JbExab00vN0dnWWxu?=
 =?utf-8?B?SWhheW5yMy9tcy9OZGVFczEveTRxU1ZhOEdoNmtBeDBnYVhsRGQySndOaDRG?=
 =?utf-8?B?TVE5UlhWaGp4cFdyVWZOWHhrSHlzckc3OXFxSUtXMW0ydGFaV3Q0Z1NoUVI0?=
 =?utf-8?B?SmxVN3hiR0xuRnM4UXlZdzIxZDQxZFFqQXZiUkdJbXlqbmJuVllTc2hoK0tR?=
 =?utf-8?B?R3JSaUxiTmlBMEdETEt6aExrV0FVSXJ1WHFSRzFqYmU0VzlDbC9Mb1lLMkhE?=
 =?utf-8?B?ZDdwZW95bkw4Wi9xK29FRjNWTXFKK3ZiMkY0N2tOSnhTeitEbXhYVkdvQXFx?=
 =?utf-8?B?d1k1ZW0wNGpXSXhSMU9SVDRtaldZK2hvd09SSXNnR0tzSmFsa2o5WGJrUkRa?=
 =?utf-8?B?M2NzZjd3WnpIbE5pSHd0S1VVNVNyY2Mvck51U3FGaXpzMnlqdS9QUTFyY2E3?=
 =?utf-8?B?VS8rZXRpWjRNeS81YjVsdkdtZ0djeWU0eGdLaCtQSkh3MkNVNlVDSDlrY1lh?=
 =?utf-8?B?S3dXajlkSGp2MXpZOWhPOGt1NS9VcldSTnFKclFsZkVxOXkxMm5tNFpEL2o1?=
 =?utf-8?Q?XI0e9HLDHUE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dU1sV1pGWTVzbnphZCtJam41TkUzYzBKSnVLUGhML05xRGluOFc1WXpZbmsv?=
 =?utf-8?B?TTlJc3h5WVFuMUJQQWI4S0I2L2ZodXZOS09pR1dXTUthQTZVTXVBOGFMVC9H?=
 =?utf-8?B?TnhzUTAzazJRMFFiRnUxNnEzYjU2UVhwWm9wSWdMVUl6YjZOWWNibGNqR3R6?=
 =?utf-8?B?d3JvSXNHWlJGMURUVno0WWRaaDVyYXFZbHVPcldMbDlKeVRZVmhqNVBmODR2?=
 =?utf-8?B?Zi9oRkk2Z3dFdTVDUGVXaVV3YkFzQUhVdUVLT0Q2QzRNbnhDSnVoUEQ0Vjht?=
 =?utf-8?B?ZFVRYjFBVzlaQ3Zlek9BMjhZelk5dTlTd0VuMkJRdXdLU3Q1VlVHYmZ5TE9T?=
 =?utf-8?B?REpIVU1YR2krRVBYWlJ6NERYM1YzaVJzS0lsaFNWRTkvTDQyWVgraHBudDRX?=
 =?utf-8?B?NFFUcWhsd3dReEE0aGJ1dUZ6TGtkQjlicjJnZTRMdXJhaCt3VFhDUzNmcXY3?=
 =?utf-8?B?VFBHYk94aHNqVE5qK3BtOTdZMU5VWEl6ZFF1VEEreGd2T0xWdXBKdUJCaUdP?=
 =?utf-8?B?S3ZOWE16ZXk4eW5FYUxhMEROS2NFM1ZXaFBaRHczdXVwanhZTDIzb3dZVU1p?=
 =?utf-8?B?N3ZSTjZHbjYyRnh1bmVZazd3UEVONEh3eUdVK1R2aGZudEpBcGZhSzVTaDVw?=
 =?utf-8?B?SWJabEVEN3lhWXNmaTBpSU1ueXI0Uk1PZGJFWW0xM3N0bm5pRkpMWlV4YXA3?=
 =?utf-8?B?TjNrMEt5QXdlSy93em1ZN0s2MFQ3OUJjYW0xbkNFdk85ZklMQTN6VSttODhY?=
 =?utf-8?B?U2VqZWhTbVArWnZkYi9mTU5ObUJhazFGeGVTbVp1MHQ4RWk0SWlhendvdmc1?=
 =?utf-8?B?dnVkWTQ2ZzMzb2JXR0ZlY25RN2RFaldQY1gyekY1K0hIUnZ5WVhTaW5ZVDh4?=
 =?utf-8?B?eVlhZWttWFBNWmFaak0wRWhpTFFoRWJCbzUxck9PaUtISFpXWURzOUZ3dm1U?=
 =?utf-8?B?V0UwT0VvMDd4ckNReG5kaTVSTHZ2VHhuVkV5ZTdXcXpwMzgyMnVZRGhNb0E1?=
 =?utf-8?B?MWVRbTIvMlk5bVJZbDZvSGdDeFBZcWpjSmZHeEhCRGpycTltOVVPeDBWK0VY?=
 =?utf-8?B?bVRhM2k4VWp6Vy84Nk5uMmhoU1hmanBKMEcrRXQ2ajk4ajdTUkl4cTMvK3hT?=
 =?utf-8?B?aWFlQzFsb21CK2lPMHJRUDB6VE1oT2dtTjEvYTNWZkE0aU5TbFh4RnhFSVQ0?=
 =?utf-8?B?dFRBb0dCaEhZcDRNZnhPa0NJUndWcW9UcG9ocm04bmxoUE9uU0Q5TEF4Ym1l?=
 =?utf-8?B?YnR6WUJUaFdlbGZBY0lGN0RrRWpiOTBRd0VLa0t4NXRVaWpjODhFa0NJc1o0?=
 =?utf-8?B?MWdKOTJjWXZoK0RibUM5KzJUam1ncU10RzhsRzJBcXBrNnYvM205eFdVamJV?=
 =?utf-8?B?WEl6a0V0anN3NERqejBwbHB5NjFJK2xsM2RQMjEzTWR3cGhpT0thQWx0WlZu?=
 =?utf-8?B?bWFkR0VIUVE1MkxnWjdCalJVMGZqdW55MTUxdU0ydzJkaEtNdlVaOEMzUllV?=
 =?utf-8?B?R3p3Rzl6SWJJOU9RSW1JM1JvRmJSdXNQTnBEN01zQitDdHJWaENlUG8xMkNa?=
 =?utf-8?B?NmN2U1pLK2V0clRvc2ttVy9VVDlwOWM3MTZ2MEV5ajBjcnpSakhuYlZiWnNO?=
 =?utf-8?B?clMyUjN1b1lXRHNVaUR5MWZ5K0M0YW4vbnh2d1A0bVEwSkNibVN5cGRTR25Q?=
 =?utf-8?B?VVBBSDF2OFJnQjllanMyOHVEN2lrT2NmZHZHanFCZGlJL1VsM1dIYTF0cUpr?=
 =?utf-8?B?WU41VlJXNE45UHdvci9URis5czQxS2ZZMVZKb1pZbG9VekFtT1BVakxhOHkz?=
 =?utf-8?B?RENvMU9UTGhwRlVJOHBIQ2JHaE4yKzJrbFNaMldJWnRTS0g1Nk9acVdQdXZB?=
 =?utf-8?B?MGlYTHZ6ZlcvVTRNRHY2QjUycC9iWUpSeEpqRU9VVys2QnFqVmUrZ0dFTHF3?=
 =?utf-8?B?RzFnM0YrQi9TUEZFTHNkd1hSaVNBTmFHd2JJU2NuYndnZERPdTZISWkrK05x?=
 =?utf-8?B?Q1pOSDV2YjJzc2hWUzF1KzFuNFJMWTBlQ0M5bS93eFFGUHhpc2UvbXdGL2Y0?=
 =?utf-8?B?QkxkMkJVYkMrT0hrRzV6SlhLUGlYZWJ2S21nRDdJQ1NVZWtza0QyZnFubHFG?=
 =?utf-8?Q?g9T8Vf84ek3LL0u1GTbnrOU8x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 684d8996-502f-486e-1654-08ddc44a0c67
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6043.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 09:20:48.2645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxSFYjCecqDP6sfHXoBDYZnVYruJTKoLUdMgc3REcOodAPIB1oMZZiMQLwPWh2Lcw3OGQaSmCgJGnIR+XlQbKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813



On 7/16/2025 12:57 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> If SNP is enabled and initialized in the previous kernel then SNP is
> already initialized for kdump boot and attempting SNP INIT again
> during kdump boot causes SNP INIT failure and eventually leads to
> IOMMU failures.
> 
> Skip SNP INIT if doing kdump boot.

Just double checking, do we need check for snp_rmptable_init()?

-Vasant


