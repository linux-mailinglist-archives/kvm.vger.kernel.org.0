Return-Path: <kvm+bounces-29275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B58E9A655B
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 12:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6B501F213DD
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 10:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90EA1F81BA;
	Mon, 21 Oct 2024 10:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mOotRjye"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B791EF08A
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 10:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507814; cv=fail; b=mrUWuw6y2nHdx3Ku2b+NQVgghOlr+SAUeBzBDcx4eWsAKuzrb5P6DkrIXfQQaJbG3af/ISqSAd6fGpps6QP3//2Lm7enxvS59ro4gLEiXAIbdS2ByYxOOYlKqowRnj5RxztPWxLjf7xCv/ySF74nxxzpd+pgXlt5vIPDCDkbW54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507814; c=relaxed/simple;
	bh=0Nr53ZKJOUaOvBo18EaZUVFt7Ka5SZ4G8F3TT7n4mMI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JH+6wXi7c0xOpYrEGBDY+vgv0T0qToVlC0l2h3esWp6opkEuMmDyAA3OZGwFd60r7YkDDRXVyWMpJVHVkTxy83uLOacjwENbrmSbTIVyjxPhz4rr4Y4S4wnCa5sJ1bpYKKRxy5atk7b9rRFBAABWdEBE74nWKrdY/fG9weD+JdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mOotRjye; arc=fail smtp.client-ip=40.107.244.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pyxhf9nNitI678rSMSZB59/sOLLy1arHm6RYS0GSyET77GXWgOAwbz0QLiC9WlLz8DzgkRJPt4aqYQxOAagceFhteD0+pyv7CZ76ZjJGd+jNIKc5/1Mr/FXwv33N/fmbWRPC8q0ZYvrM16T9j0MZClnj4DAXr41UqRgVvYaHP5JNF0qZfR/U6oR6DFMfBF32dSwbfQdMAepUgjfpG/U7+haqK4yc6N5zkhkswfEYvbMAq3NXDQTP5mUGN23uVZDHHkpuZd3UhutrdoXNH7BKAah2nzHKQ2dePu9tEiY6dURxyCosJrPf9nCvd8F95/yHZfKcmkXfW1Sgl71eRTsZsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPw+yn+EelaZSiiNOPLe4IA12I5NyaAoYw0efVhqEuw=;
 b=Hlt+G49W9V5fNLwe/FrZaPK7s1Vj7fj/MBmUEsyq4MRm90V4yVWonNMMtlY/pP9denv5hRlJfErhgk9IoOnVkKp3zyuB14bGwtdVaO6bkWsBamxzBWjWPLJ6sZTIu0ZpDXw6a7EEm00gwS3Bb5JaPh7i9MD7fHEMmWb9AQ35P+LgJqqDDbZiDpOG5qaziirtLD6AjQVXMKdF1G2TKJSZwsmETkjn0YmNkin8h8PQRNCxUguulaTLL32hQLgUC2z/YSg97tWyPZpvrf+R1tGtVSZi+NTlft+4zlcSW/ql6Es4iN8vtmWm2heMnpEtTI6H8h2WJuYptYR53n307vqyMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPw+yn+EelaZSiiNOPLe4IA12I5NyaAoYw0efVhqEuw=;
 b=mOotRjyevZ7yTar3hWrKholwUD/TfcYSYAwQunVxvSWgaw+gftMo2AuH3aPoRsas30ivUIu6sfj5Mw9b67WnuRiTxF+j9W31svHPT/hHJLasJsOU1lWlLmmOhztQ97bFvapPtwfkrAjVu2VtHpBAUlk5GsVCUgq8kpRRRr139ps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ1PR12MB6193.namprd12.prod.outlook.com (2603:10b6:a03:459::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.27; Mon, 21 Oct
 2024 10:50:09 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 10:50:09 +0000
Message-ID: <fac78648-61de-417e-a10e-150e65598f86@amd.com>
Date: Mon, 21 Oct 2024 16:20:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] iommu: Make set_dev_pasid op support domain
 replacement
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, baolu.lu@linux.intel.com, will@kernel.org
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-10-yi.l.liu@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20241018055402.23277-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0230.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::15) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ1PR12MB6193:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e955870-7be1-445d-de89-08dcf1be21ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aExsSUd3RGxrTERROTVjT0IxUWRSRm1MakYybi9pa0pwQWUwMzVJbEk0VFk5?=
 =?utf-8?B?aHBNNXFBaFZuMVMvUjRtZk1NZ3ZDbmNjMjRiQnVZc2c4SG1JTHZtQTF4am9Z?=
 =?utf-8?B?ZldYVVlqYUNTK3pmTG1yOWVWTTN3cjZuaGVYZVNHZE1qUzNuSWRRMEJRVVBk?=
 =?utf-8?B?NkVQZXArNFBtd1ROMjh4aitrVjlFTEs4Q3FwVVpDSVM1dnFKWlRCblBzRnEw?=
 =?utf-8?B?WDkyUm5HRm1na0ZIaW01YjdzZXVRNXRiNW5iNFJXbDdFM2VyYitvbWlaS2Ew?=
 =?utf-8?B?cHJCMkh0LzhnUDBSYmNNaWIxdkZCVm1UWlpGZlNqc3Mza1JYYVhyaVNwVjFQ?=
 =?utf-8?B?dmJSQlIzYjFrVUpWS1k1Wjh3dVJ3TXIrcW4vWTFVVmlEUVMveCt5dWY0LzMw?=
 =?utf-8?B?aHROT3FzVExUR0hZNGJBOXhFSGZzcWxaM1cxVWNqejladGVWOFo2RDlacGtK?=
 =?utf-8?B?REZVOC8vYjRFOFNuaUQ5Z3oyOSt2YVoyTkF5dURyaTR3VDZ3SFZVdmtTRmJi?=
 =?utf-8?B?TWFYK1dmT056VjcraGFYaEdueUhuSU9seko4eU9TSy8vNE1HRzBYZWlnYXE2?=
 =?utf-8?B?Lyt3ektneHdYZVVkOHhmTW5qTklNN1R1eEx4V0ZTOUR0aVdUR2ZxaDhhc1lt?=
 =?utf-8?B?MS9QMFpPUUE4S2d4MkpleG1sQkNLZE1HZlhFTTFQYXNDekhMZGkrYktUNGEy?=
 =?utf-8?B?VlduOFhGVmRzdUFCTWRiUGZnVlUraHpFU0pFZWV2aHAzdjNZRFlzenhxbUlk?=
 =?utf-8?B?d2VDYTFaR1ZuQlMyU3dGZlRBQ05weUZ0THRGMGhzdUFBanhpdUhpbmZPRmkw?=
 =?utf-8?B?K3lkUlJGVlZlWmtvVXVROCtmdi9UMjgvREZrbTQrUFhHMXNONm9MaFBUYmQr?=
 =?utf-8?B?SjlucmpmbWlzV3ZYQmtNZDdSaEtHZzNCY1ZiWnZmYTR2Q0VjUCszRy94dU1u?=
 =?utf-8?B?dGU0MGYvMnFtSU9JQTVFWmlqcnMxWWhlbWtxNVE1UUhrenJwSjFCYUJTUmVt?=
 =?utf-8?B?akl4UzhPbWNCbTR0ZjR6RS9MNzZiSnJWYWVmWEMrWDA5MlgrYXJUeEJndnNM?=
 =?utf-8?B?Q0pUV1ZUMlMzUUhVaTY2SlpjaVljM3A0MDFnNDhqVDl3aXhTL1hCbjdCa2Ru?=
 =?utf-8?B?QXRTSFFlQ3U3bGhKWHR1Z1J6NEJpdzRmdFg3aWdoTFNkR0Q1WnRtd1VlUUlF?=
 =?utf-8?B?NzNjUTR1UFR5YzBKbFlqekc1UVEvWjRNL2pXTTlXS0R6aSsyV3R3RVoraDNL?=
 =?utf-8?B?b01rdjNRTkx6a1c5ZFpaYXJXMGp6azRYOVJCbGV1eVBwV2hEMzJnbXdsN0gy?=
 =?utf-8?B?QXMvZVhaWnM2NW5HQTJrUUNQS1NPd1EwZEtHdEJWNmFxclh1OUNTcUFLNU9i?=
 =?utf-8?B?MjA1OVFjazZJdDlvZ2FYV2lCdnB4NXNxS0g2UzRvYlZKZGNidXpOVzRlSDlJ?=
 =?utf-8?B?NWd0akpROTZkVDdMUzVLTitlT0lBSGV0blN0YUJOUUN1THNLVGQrWVVEa3M2?=
 =?utf-8?B?OHV4cWZRdHRMc2l4R1pnbC9aZitrd1RETG1iNHplSWJNU2lvQmI3QndNT004?=
 =?utf-8?B?Q2ZZZTg0RzdXMVBRam1wZlZVclVUVVk1dHAvZlhXYktIdzlyaE5UMFdNKzVY?=
 =?utf-8?B?ZVdmYkNkTEFPdDZlMFA0MXc5cWdJSU5BaUk4WnZpR0ZHRW5FbHNyU29TSkoz?=
 =?utf-8?B?YW01NEZlT0M4NW9nNmVLcXJ3VE9kU01vTmlSenR5MTZkYnNBS1E2aTFPK3lH?=
 =?utf-8?Q?R2eao0fEa5A4fIjOiKBtHeQLWaU4x71okRV/rU9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGx2NFRLSzlmSzEyMzFYNFk0aE1LOHlrSFNBNC9oZTFkMzhjOWlwaTlhaW9x?=
 =?utf-8?B?QnErRjBVR25KZGxLaU4yQzRBOENWK1FMT3VxYjJ1d2FWRG96bStQSGpZczdH?=
 =?utf-8?B?S3F5OEhzNlAydk9sNnVIWloyQUVwV3VvS3dwalJnQnlnSGp0WjM5OVZhWnp4?=
 =?utf-8?B?TGVOOUJ1UjdIclRMd1pWcjRzTll1cXZQSjhFNEswVENyVU45THdZK24yTDVB?=
 =?utf-8?B?NUc3d0ZrQ0I2SEJ0RUJweEk1S3N6V1cvdnF1cFB1ckY0MGdDdlkvS2FZUFZZ?=
 =?utf-8?B?NGNRQ05zOEJpa2NHNVRTeWhiSHJQeHlUbmJXMWhxTUdGRGkxZmxLcUFHc0hm?=
 =?utf-8?B?anN0ZE83RHYxaC9VY1FQYkk2S29ERit6clZtclluZk5scjlVakR4V0JIMnIy?=
 =?utf-8?B?eFFqM05BOVY2TS9JWUxHU3dTR2tzZUErS3RsQ3NvUERjc0tDYjUzREovTito?=
 =?utf-8?B?WDBRZmZTYkFqR3ZnTFpwUGJHcjJmb2txYmVwZTcvbVF0NE1YM1FoUnp3SXN6?=
 =?utf-8?B?NEgyTDdjVTdWN09ENk00aWN0Sy9iMDllZ1F5eWNKY3pscG9GR0dOYVZvdnpQ?=
 =?utf-8?B?YWlvRjQ5NlR2TiszT3B4cDVMekJlSDZjUW03bWwvWmZZVEdGMC9lRHpXek9H?=
 =?utf-8?B?T1hDSHpWWGk4SE9FajlIaDkyWFdjdTdpRHhNa2YyNXhsYW1UV24zZ3pVZmZl?=
 =?utf-8?B?NEJUSWN6TG5YRkNzcGJFSG9xTmdpWVpRSU9oUnBSRmhLajJZRDE1MGpwVXVL?=
 =?utf-8?B?NkhMQTh5ejFldi95dFFoeTJORGZnRHdWaUY5MFUvcWpIQXF1aFlQckRhQytv?=
 =?utf-8?B?VlhMSURycktna2IzWGpic0dmN2xCWFlsNzkxd0ZMQ1gwdnBqd0wrOGdIM2kr?=
 =?utf-8?B?MUJSUG96eC9WdUEwS0YvV2hEV1ZJM216RzRZc2NRd3EwVFZyaTZ2T3IzM3lS?=
 =?utf-8?B?SldIaUtFcjUvR2NuUFZ1VkFFWVZSRXk3WGltQTFycTdRN0JCNUJNTnkrYnJn?=
 =?utf-8?B?NmQ4NG9HeXBFM3dOajZ0Wi9NQ3p1ZEgyNjBGNHFkOWQ3N1c3SVZWbTJDaDZN?=
 =?utf-8?B?RUs5UkhGTjVjMTFPY0lxNjBOV0ZDMm5mdzZqTXlLYkY1TjJjRzA3RitIRmw1?=
 =?utf-8?B?c1Y2NkR2Q3BYazgxZlFselNSUHJZVUgwT3F0ZkZXNmFac3ZoemNUTm9TKyt2?=
 =?utf-8?B?YnVMNXhjUVJqN3kycmk0OHR5QWpLa1RaakhNUU0yTjRoVG5pdjBmZlV1bko4?=
 =?utf-8?B?WkZ1Vit0OVZYWlhSbGJURFI1SGRNMXhMeHlxOUZkd3kxeDBDRDYxUnZ4U1Zh?=
 =?utf-8?B?YVloUnJZaEI2Vm1NQXdYR1NkS1cyRVc2STN3OXJVR2o3bG1ncnpZMVg1NEg0?=
 =?utf-8?B?UUduMnBYSStlRmwyNUlNNC9OY3p3ZGpPS2M5eDM0YkdPcDduTVdqZERCcjVN?=
 =?utf-8?B?ellBVTR4MGRJa0FNZXlvMVZ4L0lkNGRYSUtkcmJKazlLSUxFdDREaTg3WGF4?=
 =?utf-8?B?ZFZjTlZhVzdVQ3RvRGxxdUtuSWRCa09ha1h5Yy93TTU0YTdITHlESGh2VVlo?=
 =?utf-8?B?dWIvTHFFeUt2b2VvdFVvUDMydWlvNnhFMGVjSU9temE3MDcvd0lwUHk1anNC?=
 =?utf-8?B?clR1RDBLYVN2amZGaURrQTVBZER1ZjhmMzBYY2V2Y0x1MkN5NG9FWndacU5G?=
 =?utf-8?B?elJhVVo3QTJ1eTgzWFZ1aUd5QnduWXc4bzg4WUhGd1pKOEZvbkg5Vnp6OWl5?=
 =?utf-8?B?OHhicVVCYXNwTXMxK29jK1Q4cTNxOXZDaTM1UVZhMWRuV2R5c3hkclY1Kzdl?=
 =?utf-8?B?YnVQRTdtUVNybUw5Z2h4M1BLOE5IcmZQLzV6OGpydDVNa2w5NVQ2akdOalBT?=
 =?utf-8?B?cnhYQmppWEFHQ1BMZXdrWURYdzhSR3U2cWxSWWY1eDRDNWR3MTVZRDIxcU5j?=
 =?utf-8?B?QVFRUHpRVXdIdTlLcE1VY21TMGtpaWtPcm54b1Jnc2x0TVlIOG56c1NzSHRB?=
 =?utf-8?B?b0ZYU2RoeG9HekpPU1k1Z0tLZlhsRXR4VGtkVFFMTDZLR0l6Nm02SzQyd0Uv?=
 =?utf-8?B?UEkwT2NWc2FSdUE5RzV4VVdjREUzY1owYmtXVUViME5sLzRnVTJXRnN1MmJj?=
 =?utf-8?Q?37wxxJFTkmPpSWdX6AxBi4Roc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e955870-7be1-445d-de89-08dcf1be21ae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 10:50:09.4447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9t/CIMvR9fH/2xhzQFWDpvF08RrPuVu5y/nggEIIShlpuhk7kTSbixz4nMfuRN9BQTb4QQPMgWepRcg0VeNKYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6193



On 10/18/2024 11:24 AM, Yi Liu wrote:
> The iommu core is going to support domain replacement for pasid, it needs
> to make the set_dev_pasid op support replacing domain and keep the old
> domain config in the failure case.
> 
> AMD iommu driver does not support domain replacement for pasid yet, so it
> would fail the set_dev_pasid op to keep the old config if the input @old
> is non-NULL.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

 Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

