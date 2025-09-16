Return-Path: <kvm+bounces-57734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A81BB59C54
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C37A172DC0
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE5036209C;
	Tue, 16 Sep 2025 15:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s9g1sgQf"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012007.outbound.protection.outlook.com [52.101.43.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666AA237172;
	Tue, 16 Sep 2025 15:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758037304; cv=fail; b=gKVm3BT510/aqmtP0FMiqFa7HF+gE1OMC6qvD4BUHm5LtsHY7dw0wEDb/gB+WL/OFnqUBZjTQjIb8lgkmkJu1iPqm+lTA9LFTATG7Ni0eVptM44AAdYBwwIH+mJPAFbUhYqgC6ZL66nWa+AFZX1FIsiqkcWtei8RY36XIma19n8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758037304; c=relaxed/simple;
	bh=cKgLGnBeZOfQedlEIk+Wy2xvDQR4JpJ3d1h5lONlftg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Fv+YohEgSGpAN6ZoZR+8jHa8ZHpPiWSOxZSFnCUZnjzRHRBx8Tu7sTB5r394KfWfiSLyEtzwG4Y5RlqgyP58G6Ki0fR41APxhvz/xx7zH+PGZiKkDTKiJyx3EsP6vcWRT8Y/IDcsO+ExnfkIjqmXyGwNEXcuQZSH4hXxY9jh5Yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s9g1sgQf; arc=fail smtp.client-ip=52.101.43.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sjKhL0FIMpdxtSaeuQEzZadqCVNS4kVrIQe1Nq3X5rVe+4mi7Z7rLwNdhOgOstugIfmDO/0AllDVtUKiiqkAgI2vohoZbIAHbc0Yuo0U964p0h8uB8bBaRQG/DUR4RiIDMTyR7wuUTz5WGo5cvG5rFfI0nAaEEHiPEc35l7+noP3dovsd1he22bNYXq8rr0wN8CVNJF765aqW8G43rOy3JTEPE3kazgKdihFDKuba8K2xJTG4Yd2+cQ0+MNalQuLCPdo9VLg1wu5caV1ChDV0iRswpPcrdjEPZCGgjPyojd5lFmXNXF5sAX++JjqoHuGXgQN7ZITDlimjPUpd3HvNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzBMDf1b7UpMMPffxmwxb6ZknwEuytSxXMwhCy2BJV8=;
 b=DkYOfsE7JhCKXhaSItKFTz8zb/HkxgyNZlUZRT+G3LE+42mMqL+QDaPFRjuYVI1OoNOy6CWt6aRhURAKrlloFCSEdmAB4L44g+Q1znl3CevrohotkaI9GHl/VEZk30qcMso/dj9gRKZuwJEbBP2A3YoKMhATpTirH+9s9lYmz0fTKt0VL7gsaSaQZfEbgEVX738EQ2+eHYuYg1P5Kvjxc+z+LaPcrrEZJ1uPvQtJici9ALUrjJMyX0KKTZGFHmwdy1xmd39Ui1vfwKjhPDy6tSzjmhtu1azP88qP/qzjuT2nR1/m5YyIEHec4lwXOmcvSHmfKbIIetRHMETd1LJ3vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzBMDf1b7UpMMPffxmwxb6ZknwEuytSxXMwhCy2BJV8=;
 b=s9g1sgQf8mAyLqfBRRMrDru78XXLXlljMOXf6SRGwoSRONgS6ZIS/m9ERWlBK5FaWVZUFR+msYb9TwlThrYQ7z/dCcZeVJ7QUWKbUTldlmreGBvJAlHiJOdjrcBlIeMBzOwu2lBjJ5II1TaH7mdxyjXAC6luUWw6kR3NDivuYKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MW4PR12MB5642.namprd12.prod.outlook.com (2603:10b6:303:187::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 15:41:37 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9094.021; Tue, 16 Sep 2025
 15:41:36 +0000
Message-ID: <3387d2fb-d5a3-46fe-a934-7a05655b34e4@amd.com>
Date: Tue, 16 Sep 2025 10:41:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, nikunj@amd.com,
 davem@davemloft.net, aik@amd.com, ardb@kernel.org, john.allen@amd.com,
 michael.roth@amd.com, Neeraj.Upadhyay@amd.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1757969371.git.ashish.kalra@amd.com>
 <18ddcc5f41fb718820cf6324dc0f1ace2df683aa.1757969371.git.ashish.kalra@amd.com>
 <20250916131221.GCaMliNe3NVmOwzHEN@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20250916131221.GCaMliNe3NVmOwzHEN@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0092.namprd04.prod.outlook.com
 (2603:10b6:805:f2::33) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MW4PR12MB5642:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a4a6895-ff77-454c-631c-08ddf5378539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RENtUVpEVWNGVWJZVDIxaS9WdHo2RVQyVHR6dkRwYXMrbkRraU9YWTViWThk?=
 =?utf-8?B?eTZieEU5Q3Q4cTVuY0ROTVpxZURsOUhZVFpPRHY4VEFCbm1GM0xWSFlGSjRn?=
 =?utf-8?B?dG1hOXNDZWRtYWtiYjVjSXY1WkVaWXRoNngxZldXYjAvN1FBRHVEKzBqWk5x?=
 =?utf-8?B?UkU5bVlqT3pRVEVSYllTUWdIME1vYnJCVy8zajlwYUdTMG03bm1qUGRqVllk?=
 =?utf-8?B?Y2hHdEhnLzl0dHZRcmNKRC9aSlE4VnI3L1Nia0cxbDJwekg2YmplRFM5VXJO?=
 =?utf-8?B?YU1weE8vQkRUTzVvK05HdnBNaStGdThpOXI2bUpoYi9ZaTFNQVF3TzJHS2Jl?=
 =?utf-8?B?N0l0YW40V1pHQWFBS1NXTyswL0R1b2Z0NVJHSExtYS82WUtMS2RGWDlnTHRr?=
 =?utf-8?B?V0Y0aWMrczJNOWpEMit2Q1JEbFFXRjRGdkYvUDlYTkNNMnZwN2tPWkVLVVAx?=
 =?utf-8?B?d3ZnNmN1WWVPakEwcWlibUpUQ01XY0VrS0F2RkdSMjJkOXMrelZDUUJuOENr?=
 =?utf-8?B?UTNhZHEya0NNN2Z0M2ZMTFVpYW5jM3ljcXk2MVNEemlYN2NhcmlYSWhkUFNP?=
 =?utf-8?B?SFdxeVhVMG0yT3pSWnBGclJWNUVETDMwcEZaL2J5ZDF5cmFFU1VuRFlYUERE?=
 =?utf-8?B?K1JDdDNRUkN0dVNDYkpRdW02eCtNU0k5Z2IzVC9uZzlGcVIzRVRCNytqRWZF?=
 =?utf-8?B?V1I3dVJ4ME9keHdiZjlCZ0RoNmh0QUlidGVKV2krdFZMb2dXcVIveTc2dlkv?=
 =?utf-8?B?R1ViSGVuKzY5UkpzWTd6L2VqRzNNaHVXMXBES3dTd0tmNUJnSm5uWHBJVjlO?=
 =?utf-8?B?aDR2YjhJSnRWdForODJNTXJEaUJRUXRjdTdNRTcvVEhzRWg5L2dxOVFaT1Q0?=
 =?utf-8?B?MzhWMzFmQmQ0UGFKRTZ3anlDUnRUcklSaWtINGgwa3lQOFhtQ0w4SUw1a3gz?=
 =?utf-8?B?d1owRGxqM3RGRmhwbzhQZlpkeGcyNit1R2RvWEJ5ZTlSS1psVTQrMzlNUk1n?=
 =?utf-8?B?QWdCUWU1bFVVWFRiYXUvbFZXRjBJRUJkdEJ5UWgwcy81OW9WMENZTFk5RW9N?=
 =?utf-8?B?UTl4djRMSE85bXhzbCtNbVVhV2RLbEdUeDNkMlhDd3FsR1JQQjJCZ1BhRm1O?=
 =?utf-8?B?RlNuUVFjOW83SDhZQngyTU1YUnZNTFkwMzBHcHBUbllZOXg0bTR5Rm5Wb1FO?=
 =?utf-8?B?bmN2YlAzLzl5ODJYQmlOZmtiSjNJcUtyWVZka2UwRUNpbzdCYThSZzF1WDQy?=
 =?utf-8?B?R21iTGY4ODhhdnRPTWlmK0lZTUdMaHU2ZFp4d2kzb042bVNzQ3ROaHZMN2xu?=
 =?utf-8?B?N05jeElndmVGZGNhdXdKRGpPV0U2cFZjbnFXUEVyTjdrSE9scWxWZVk0V0Vn?=
 =?utf-8?B?Z2VGekVneFNxUWlQYmVVOXp0U1grMDVVNVdlUmQ1M0d2TStYMmxiSEkxTnRS?=
 =?utf-8?B?NG1wNEw5YWFhSnMxNnBQd3FvM2Z2S3ZPV0JPSXNXVWNLODlEK1ZtUWlMYWQw?=
 =?utf-8?B?SnZNN2Mxb0tIK29wTGpFWWNEL2VsaHBxdHJGRFRyck1uaWVMeWtFb2dBRFgx?=
 =?utf-8?B?NThNcTdjYmtwK2FNUkJrVGJnL0c1USs0eVpDT0JTbmRtY3dXcHZHaXlVbFM2?=
 =?utf-8?B?dHZlNEw4RXpLL0ZRSXJWZ1JXajF3Ny9xK1RWYVRVS3ZZaDJLbjhFdHh6YUkv?=
 =?utf-8?B?eXpYdzd1a0piekxTT1FRMms4ZW52Vk80T25rdTQ5MjhFZFZrNmEwQVlGZFlE?=
 =?utf-8?B?eVVacXBzMkdNV3pIcUUzZFN3WVBGMWVSTnRpZC9CUVkya0U0RmhQSVpGa1hK?=
 =?utf-8?B?M3JVU1E5d1I5Nm9Id042UGZ5Y0gzOVRMd1BubXpGVS90MWE5UHZROC92a3E3?=
 =?utf-8?B?WGdVREFscm1OV0lqS2Jmd0JWVFJXVkVWblp1NWxmTFJ6TGZxWFB4cSt3R0pq?=
 =?utf-8?Q?BNBqg86+Dqs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emtvbUFOUTcvM3Z5VnR1MzYxdEJZM0ZrUzFGUmpZbVZURTZDQUs4MnRERzJr?=
 =?utf-8?B?TTk5eVZCbXgwa1Fkdlk2RkZKWGpiR2FyZHZLWFBIVVBNSDloM3NLWTE4dUVB?=
 =?utf-8?B?aEpFR0I2aXJ2TGtOM2xtOWR0ZDhHRmk3TUcvWlRDdUlxYjlZTHdDRzkyTnJa?=
 =?utf-8?B?ZUl0TDYxcTRjVzN3dHZFRWk5WWcyNGVnMHlYaHhQOE51R3pZMTl2OGFqM1ZH?=
 =?utf-8?B?UlRQVEVub3FIeFM4VWZUd1NYSUsySGs1V3BHOHFRK0hmaVdWYTZoWXFDK2FL?=
 =?utf-8?B?NXRmWFdaRkFaczY0amV1MjV1T2ZocllEQTU0MjI4a3NmTGErSmxwazNLYlNz?=
 =?utf-8?B?K0x6U2VlbVVNZGhmcXNJYktlSWQ2WjM2L1lxR2p4Rm4wcEtlV2NteXBCQkZy?=
 =?utf-8?B?dEJPVm0vOE9rYVNKQkJHZ1pFSnFwbVNyV2VKa0Rrb25QV2hKYWhXc3RrL0wr?=
 =?utf-8?B?K3p0enJrRnZ6S0hSbkI2UDlEMjBoa3ZZRTV4cUdmbHhkQm1GT2xydDdHR3Ny?=
 =?utf-8?B?cy9kNGQzQmIzOGpDYzlkdEgwTEE2OVVpOHpwbWN4V0ovaG5JOWFlUnJIZHFh?=
 =?utf-8?B?NjEzR1N6R01SZndXK29iWDFtODNxRnBoWHNRTFFCS0xFRU5rYjZwbjZtWE1N?=
 =?utf-8?B?WkJFK0dzeFZOM0gvcTNiU0xqZHNqUDhQMUJ2Q0NtWEJvWDVCeU02TmlhNTd5?=
 =?utf-8?B?dTNtS1IySVRPMGlsUWZVajN4QVF3QjFCcjl6MEVsaEJtTEtzVWxyeXFIV0t6?=
 =?utf-8?B?R3hDWnNKNkE0VmtSMmdvMElGWXpRSWl1QWZ3VGwxVS90QVNwTkVBQUhBcGJ5?=
 =?utf-8?B?SmFYSXN6WDZ0Zytmek1lR29zQUJNRXBoVi9hdWllTjdKcnp4cW5TSFZsbkd5?=
 =?utf-8?B?WitTNTEwNTdIQmFGT2R2VjdRSmFQTFZIVUdiekloTVM2VWlIby9uUUdDVlVu?=
 =?utf-8?B?cHVGb2VBVE1IVk1SZ0RPTDZoZFlBUjZuQm80M3V0N0JtNG9sa2t3ZUJBNy95?=
 =?utf-8?B?Qk54aGdJZ1IweGg0dktNNjdsQm14NzJyd01nbGdHNjYycm8yODNoZ2U0ZFg1?=
 =?utf-8?B?bUY1MlZSTjd6QksxSm16emxuUzJnYkRiQjBZeWZMLzlyT3IvNUxvTE5GaVpN?=
 =?utf-8?B?KzdzU3B2WkxvR045YkE0aFJRT29BMXB6TEtYaU1QOHRNUloxT2RvV2ZPTHZF?=
 =?utf-8?B?WXVraWI1b3lkSHlGWTRCZktIVCs3WWxzTzJPZFBWRE1ZaVJBdnh0bnp3L3U1?=
 =?utf-8?B?Z3RGdFVRM1c4WWZlY0ZObUV3N1ZFdUt2VFZIV3AzZ2pzZGJUa2NKVTZvRTI0?=
 =?utf-8?B?VTdxVytwR1VCL3h2eDJtRG9pOUViTHAvQ2RhOElGMnJ2VnBBVXJ2TFZkUGNZ?=
 =?utf-8?B?T3UwN2F6UnVlWm1uaE9JdGtnRThBTGswbmZJS3U4aTZGZGZ3ZVloS2pTenFB?=
 =?utf-8?B?T3UrcDYzTEFNQlZYRmJGZWxldTA2ektnQUlWMmRQbTFRSlpzekhtWjJzUmJ4?=
 =?utf-8?B?Q291QTF0bGtHT3o2MUFsV2oybG1yZmRnMDFSdURwbFJ2ZkRDMEYwN0NjR3Vr?=
 =?utf-8?B?SHR1Vm95QTM4cmwrWkx2UzJmYWs2c1lKcmlYcVE2RjcxV3BvaHl2aHBQTHFw?=
 =?utf-8?B?QkhmTFpjMUEzY1hZSmw5VnZSSUprNGxpN1h6Smpaa3ZKUEppcHdjZkZOTnNJ?=
 =?utf-8?B?Qmd5Vm05YVlhSnk0aHVRSjBtN08rK2NVZEFjVnR4V2ZyR3JwZ0pvMFkxbElz?=
 =?utf-8?B?UWRZNmJlbXFYamxSWlZ6TlFUY1JOV1ZPOHJSbStpUThNRXNROEVabnFCblVh?=
 =?utf-8?B?R0YvMjNxb0JzTUdYeVpRd2kwaURiV0NPcnhLWjhIREZybFh4OW41TjhjL3h2?=
 =?utf-8?B?b0hPWFRtZzJHZzJVcXlNdm5iSkRudDgyTTA4V25XM3AybkRMOUQ2YzB0MXA0?=
 =?utf-8?B?RVF5NDJwWGNPdWpyVGJWL3hycGlXLzVTQlN4aGF5eVIvUWoydnhtOVg2Q3NC?=
 =?utf-8?B?bjlUdWRBVHBIczI4bXQ2ZXFTZG01R3hLMEdYc2M0aDF2SnpBMkVJT3NyeWV2?=
 =?utf-8?B?a1p0TlJQZjhidVU1SndUNlRxdHQ0dkpzYjVMbzF5a3NmcTRUUkk0WnVnMXVp?=
 =?utf-8?Q?8txpKpl/vL90O5jfp7DwwqdA+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4a6895-ff77-454c-631c-08ddf5378539
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 15:41:36.7035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 14jvdimlIPWhVdeBxqPYGVmzXImAhqtygKXbKfLTVCLS86pg5zrzbL+kubbNAj7MHYYH+YZ5+jw7ewGqBLhH+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5642

On 9/16/2025 8:12 AM, Borislav Petkov wrote:
> On Mon, Sep 15, 2025 at 09:21:58PM +0000, Ashish Kalra wrote:
>> @@ -668,6 +673,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
>>  	return -ENODEV;
>>  }
>>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
>> +static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp) {}
>>  static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
> 
> I basically don't even have to build your patch to see that this can't build.
> See below.
> 
> When your patch touches code behind different CONFIG_ items, you must make
> sure it builds with both settings of each CONFIG_ item.
>

I have done the builds with both CONFIG_KVM_AMD_SEV and !CONFIG_KVM_AMD_SEV and the builds are done
without any errors.

And i don't understand how can snp_leak_pages() have this redefinition, as one of them is under
#ifdef CONFIG_KVM_AMD_SEV and the other one is the #else part of it.

Thanks,
Ashish
 
> In file included from arch/x86/boot/startup/gdt_idt.c:9:
> ./arch/x86/include/asm/sev.h:679:20: error: redefinition of ‘snp_leak_pages’
>   679 | static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>       |                    ^~~~~~~~~~~~~~
> ./arch/x86/include/asm/sev.h:673:20: note: previous definition of ‘snp_leak_pages’ with type ‘void(u64,  unsigned int)’ {aka ‘void(long long unsigned int,  unsigned int)’}
>   673 | static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>       |                    ^~~~~~~~~~~~~~
> make[4]: *** [scripts/Makefile.build:287: arch/x86/boot/startup/gdt_idt.o] Error 1
> make[3]: *** [scripts/Makefile.build:556: arch/x86/boot/startup] Error 2
> make[2]: *** [scripts/Makefile.build:556: arch/x86] Error 2
> make[2]: *** Waiting for unfinished jobs....
> In file included from drivers/iommu/amd/init.c:32:
> ./arch/x86/include/asm/sev.h:679:20: error: redefinition of ‘snp_leak_pages’
>   679 | static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>       |                    ^~~~~~~~~~~~~~
> ./arch/x86/include/asm/sev.h:673:20: note: previous definition of ‘snp_leak_pages’ with type ‘void(u64,  unsigned int)’ {aka ‘void(long long unsigned int,  unsigned int)’}
>   673 | static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>       |                    ^~~~~~~~~~~~~~
> make[5]: *** [scripts/Makefile.build:287: drivers/iommu/amd/init.o] Error 1
> make[4]: *** [scripts/Makefile.build:556: drivers/iommu/amd] Error 2
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [scripts/Makefile.build:556: drivers/iommu] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [scripts/Makefile.build:556: drivers] Error 2
> make[1]: *** [/mnt/kernel/kernel/linux/Makefile:2011: .] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
> 

