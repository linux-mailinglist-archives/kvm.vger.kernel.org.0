Return-Path: <kvm+bounces-16784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A7E8BD9F2
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 05:58:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 270F42836DB
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 03:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30F294E1D3;
	Tue,  7 May 2024 03:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0sUdCv+D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE623FBA2;
	Tue,  7 May 2024 03:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715054296; cv=fail; b=h8fcJ2WB1voa/AT2knaoqxA1KomqTfo55u258htAzWEnBd7QDLUCP4+1go8e1ubtAan3J/PbnctjKnn3PJWO+dmUuTtnmZ9nOm8IjMMadlfjbYbp7rGFY9q368jp5EbZmu6O8ubZhfEDwuDJ5ZOPYjSKOYNsR9/hLzz7rBLdFuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715054296; c=relaxed/simple;
	bh=3xdI4w/XmQDea/5uVGsvzGTmTZxgSa5V28RtQ9dhVAc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nzTc6huUTspeCojddBZYDOE9y89zxegHaXaWnN1yhExntR0oqiSLhk/ohav+jQlF8+2YJcX8NHC21ey5i5Tlk2XOx8fnz5wX4jmwM+zasLcynYupH2h5u7wq9gzGLoDoJ8R2bjXrgPJca8mSqtC3q5yAq3M0eV2IBIaG1isZiEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0sUdCv+D; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kusg3590TB4BCyD19xGphRCwkxW2tQBu8F2CD07GOFrmiTJD4+Fb2lb8hsdrapLcGBseEOK03rqw4SxT3LTJX+H6Z6kT3s1bicTD9YduwJ/U/tvsaIbkcI6mXT8rSN0G4IdZtDN8Cp4ZoEgp2dmxW62kcZa28wQQuKUZWAWr3AgAyFiXWDD6gE4i6l32669/1bDXm5FloMkcaSAiPFRkOhQstXyrsIPLjq+6uTfXte9UEIm2LLcRW+iCW2Mu5+Jk24nCxtSkxHjKfXrrn84GRA7wmat6+hdlscn6RRmy6bQPDRQAhHCpFeIP+qf/C76NJN98qGvEeZffLTzgJpiKjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fc43EM9CsQlYhWIHs9oYl+ihVQ91YrozVmUqq58XAU=;
 b=Fm/eCIu1R9jQDb3J20MHLOOmE4q8mE/svwzd+w5uG9rsDtvg4jvhbRrKtyXamvJeKsRsSUsM/fKk70NA458WT1oMhalvx757r0FM8JJ98xEi3deyYRno8u7VsSYYx/UrbBBA81R2TJZolXYLtPSgb4xqe/dzKYI97x3y+1/Sp0SkV7+oAwqO75EJboDK2STnX/wB0UsDJWCi7wzULiv7JsFh4OmDQ16M9FbuJLKrkSAOlSLQ9KRUYceJnUCWvAhD3nMLo5A1F8eAoJACkgy7qR0D4/MBcLW68XPzbBabP4n0GcSCeVg+dHZhDh3wk4hrGC7A0ihPWCY7wXkWPtG3Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fc43EM9CsQlYhWIHs9oYl+ihVQ91YrozVmUqq58XAU=;
 b=0sUdCv+DjqH8D4B2rTSFpSZsi5ixV4UrB48T551pJlGU8EffmfBZQWo9RiLWULZWoJpXiojRPG1+/fQ1WirgETDb83QT0Cq81t4SSvtrHK8zxxl1y6K1v+0P3Ll5YuU3OqB5rIW9lZjg0k4YJuq9bRymp7kpqZ+WyNFci8z9Q+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by BL3PR12MB6379.namprd12.prod.outlook.com (2603:10b6:208:3b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Tue, 7 May
 2024 03:58:11 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%5]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 03:58:11 +0000
Message-ID: <3685c15f-3485-53b0-7955-7931efaee960@amd.com>
Date: Tue, 7 May 2024 09:27:45 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] x86/bus_lock: Add support for AMD
To: Jim Mattson <jmattson@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, seanjc@google.com, pbonzini@redhat.com,
 thomas.lendacky@amd.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk,
 peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com,
 arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn,
 nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 ananth.narayan@amd.com, sandipan.das@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240429060643.211-1-ravi.bangoria@amd.com>
 <20240429060643.211-3-ravi.bangoria@amd.com>
 <CALMp9eQzbNVJpuxp1orNswnyfKy=aFSPYFRnd3H7fbi0+NfDvw@mail.gmail.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <CALMp9eQzbNVJpuxp1orNswnyfKy=aFSPYFRnd3H7fbi0+NfDvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::9)
 To PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|BL3PR12MB6379:EE_
X-MS-Office365-Filtering-Correlation-Id: ffcc83a0-93e1-441b-86a3-08dc6e49e999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VlhpYWpoNkJiSTVEbjdOeUJyaVg2ajN1cVovVWZrcmhaRnlqdnNaWVRMWmha?=
 =?utf-8?B?VG5QMGtuUXdHWlByajh2YmVRNitKaU4xMVhzZXJQSGliV3VwQUxvd01zR2VB?=
 =?utf-8?B?R1hwRzlGYUlpWU5qRUZvN0NjWjdDbVlUYmZDc0dlZ3lmSkF4TjJGWXFFSHo5?=
 =?utf-8?B?MGZTWmdwSElVMEh6bWdLV0RWTnJ1RElvN3ViT05Dc3c4YklCQUV6NzVxd2Ra?=
 =?utf-8?B?M0VUdDVEWTF0NndCZ1k1REtXZnhDbERWZlcvUWJQTS9TSlVtbzB6cUFHRFJ4?=
 =?utf-8?B?YW9JdGN3SVQ3YzA4Ykhnd3FvVUZWV2tTaXpBZ3FEdEdKa3lVZE5zVUYzb0VZ?=
 =?utf-8?B?VlRyTFAwWVhjemRxZXBUcDdXL3h3ZjRxVWdyeWgrNWRsRWZCK2I5eHdudTFZ?=
 =?utf-8?B?eUlka0VrRDlVRGxBRWxlbncrRktyK2VLUmYxWU5NVDNkNnV3RW9WeVNMbEgr?=
 =?utf-8?B?TTZEdWp0b2NLeEF0RnluVktnQm1GK3NVc3NnQ1RJRGY0TlZ1UHR2NjJWR2F1?=
 =?utf-8?B?Rzc4VlU1MjU1QmhUdWprN2d6cElSaDlFdmtWRHk5RHgxdW1tK1luMEx5RXBy?=
 =?utf-8?B?NmU4dTkxanVDWUNGNzErRm81VjlDSlVPbWJ3ZjFmWWtOdDFZVjNrMzl6clNx?=
 =?utf-8?B?bnUrSUJkeUtzZmRvR1dkWVVrS1FiQnRsOXVyT0cyL3RDblF1eGNuVDFYTlBu?=
 =?utf-8?B?ZzZ4SDRXaXZNa05XTjlBTHNOTDk1R0c3RFpZNjJPdnc4SENQUXdTdk5zUHdr?=
 =?utf-8?B?L0VlMEw4NHk1YXNjWGYxd1VpY0VGcXhndDJmeE0zbloyREQveDZNNjNhSmVT?=
 =?utf-8?B?TUt3YUZmRStER3ptZEQ1dGhqdU8zRkZwNXRoMHBXdnZLaHppdndDVGtQYTFK?=
 =?utf-8?B?UWtGcE1ONm8rT0Z5Q2MrT2VjYk1tUENpdXQxeE5Uc1R4d3ZqMExudHo3UWVh?=
 =?utf-8?B?UlFSM21CNkd6dFJEemY1UW9vd2kyTjlycjVGUGUybjF6aURJcjM4Q092RHIx?=
 =?utf-8?B?bFRyR0UvZkY0N1I3bVdZQzFXODJuUGN3dXJtNkdrUGhwQk9KNjJHNk5uVURZ?=
 =?utf-8?B?aVNGeVhpa2Fyb1g0VDk2dnBBV0VIbmRWaFFhREZlODFLOGVaUXdrSWdZOWk0?=
 =?utf-8?B?ZzZKcHFqbWlKdEY3M1FPb3hIUXZ3bHpvV085V2V0VWRWTm11aDExOWNXbDhk?=
 =?utf-8?B?cFZseW1mQnFJQTRKU3ZROXlZMGNMRzlzUzQramIvNG9PK1FUaHNhY1dlVm5O?=
 =?utf-8?B?NEdYSHNlY3A5SWNubmQ2N2RxKzdMY3oyamRsdVgwRWtnRDJ5RDZ6TEs4Uld6?=
 =?utf-8?B?cDJHbngrNHhjenFsRWJreVVoLytGTXNaalg1UTM1L2p1K2taQ3ZvR0dvQW1V?=
 =?utf-8?B?UHFmc3BzKzYySWoreHphaE8vSmNnUlFvQjJmSWl5aWJSbE1KWXJ5ckxZS3JW?=
 =?utf-8?B?dUNZUkJFaVRKeWZHeDU2anpYaExtMlQ1NnhHUW1tWlU3eHNudVdzQUN2NXk4?=
 =?utf-8?B?NUJuSDRlUldYMDQzVm9hc3RCb3pSOW5BTFFCZWN0S2tpVVdVc1Bid0RTVG5V?=
 =?utf-8?B?b2hIRmdBMDhyVDBKVVFIQ2Erc0E5Mi90YUFVQ2wrRGFXcWNJc1JhWkdOUy9U?=
 =?utf-8?Q?VptsQh91Y22xrG77zJ3kQFnwegCJjptePDYayM3EHIW8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amp0cDNCY1E3OHF3ZUhZSUNHMTdURlp0c0pqYndOWFh1U24zMzlSaFY1SExT?=
 =?utf-8?B?L1VldlRTVzdHdkE5cUlCTmZIZUpScytCc29vKzdzSkFmaks3S1VSUHFlcWlN?=
 =?utf-8?B?cXplblFSMFR4a0lzYTNTR09DUFhJLzdIZXB2SE9tSW9qZE42U1dYZG5hOEtG?=
 =?utf-8?B?RDBlTHUzVlo0M1Bna1oxWmVOSTlPT29lalJlNmd6Y25sbUFvbjFOVy9WbzZt?=
 =?utf-8?B?ZjJUcVJucTYwSFJVNGllNm11a3l1Z1E3ZDI0THNxcHAvOVBIMThLM1pBSnBa?=
 =?utf-8?B?L3RLV1UyOXZhNWdabUV1ZG9vQ0lmN0liQXFwR3VHaFlRc2NFbitwNzMvRjJU?=
 =?utf-8?B?RFk4VmFTU3dsUk12R0ZMdkxKQWhlWDlyYTVUMlNZTkgwNGZqYnMxZHNhTnBp?=
 =?utf-8?B?Rkt2dkYzVXpSallPV3VXNEVMQ1VwRllHRWRjNHVQNXVJTDM2Zk5zc2UwYW1u?=
 =?utf-8?B?MTJqZTBmRmo3NFRCSEZZT3E3RWRGcmFvVDJBdlZGZSs4UmZzem9kZHQ4a0Jy?=
 =?utf-8?B?aDlXYmg2dStUNVJ2Ry8zQjc0SDVzcUJGQUJKN1Q3VnhPL1cremljMEpXYTVz?=
 =?utf-8?B?ZllwWTFFNTZLR09kSHFyQkV3allHckVpbW1YVHFzK1VKdjYzSWdKbkU1dkVB?=
 =?utf-8?B?dXVJbERNM252YTRxNjJYWEpCMHdxOHlHS04xSFhaa21YeEY0SW1GS2Y0alpo?=
 =?utf-8?B?am53WEdZeW1IblU2ZUh4azA1S2MybHFwZitnZ3JUZlY3MXlxT1hHQnY3dUIr?=
 =?utf-8?B?ckE0aVFpZHFuWUpBUE1sL052RmhxVGhaRzdzTVpweURNV3owNTFaQmlKODFq?=
 =?utf-8?B?bjN3MjVxMUlscW14alowc2ZxTGxYR1NuaFBkZzRZWEtsWmgrYnZ2eEQ3NU5y?=
 =?utf-8?B?SGtrLzFPNDNaZG9pZ0NCZ1VEcHNMci9DTEZRUm1wRW5Yd282bm40V21xRUZF?=
 =?utf-8?B?TGlZNjE4bk9WY0lsWDNieGlvYURDZFlDMEgrZkJOZG9iS2RkSVdvR2RWcVox?=
 =?utf-8?B?emdYbVphU3JCRURQbXpJNjlSd2tLZmh3RzVZMWlwMHJhUzAwak56azZmZGlq?=
 =?utf-8?B?R3pHdkVQN2Y1TmVHSWRaZ3oyTENWeWtEZnJsbzF0UURMbHl2NDBOSmY0cnI3?=
 =?utf-8?B?dmJDM1V1VDhOVmdwcjlSUVgxdHd1M3h2dTgxdjBtK0NlZU42VHpYVTNLNmgx?=
 =?utf-8?B?WUlCK25GMzFIY2JNVlppaUMxQlZKR3JFNGM3YVJCWnFMbml4ZE16ZGJLSjc5?=
 =?utf-8?B?TEI5ZXVCNVZ3bEpqRmQvbTVwWFlKbE5lQldEL0ZVaFBFMHhpT1BTYnVsaEky?=
 =?utf-8?B?a2hVallCdy93SThEenVwdjJzaTdQVUhETTN2QWJrclNIOXB3a3g5ODQvdlBZ?=
 =?utf-8?B?VVM0bzREZTdMVEdNTHNBeG1UaWlldmJqUTZHNk9ZT3BQNGl4UDB3dDhhT0FG?=
 =?utf-8?B?NXdlOHNvYzY2S2ZkUUxZdDRFS2czaXFRckg0eWdIaHNYU0VMWjhRNU13S0lX?=
 =?utf-8?B?M2NIdDZhaDFuMVo0d0ZTZTVaeSs5dUQwMWdUdUlnQWlNZnZOb0txc2owSUVw?=
 =?utf-8?B?N2FXOFdRK2hPSFA0RmJwUWk1ZXBaekxtREZlYVNyQkFvWk4rV3R5VjUwcENQ?=
 =?utf-8?B?alRrQnFxWmpXa0lFOVRwWTVVLzlwSUs3MlpYR3p6K3hoUWR5aGhoMVlXNGRH?=
 =?utf-8?B?QmpVTXUzTmdnWTVmOGZVZGY3QVhzWFZLVjVxLzk0WkdiaG5Fd0tBYXc1Q0Ft?=
 =?utf-8?B?Z3h4MVdCQm84UU1SUHRvYjRnRXBrYy9PVS9EYXFBS3J6Z05xSm1wT2ZBaHQ1?=
 =?utf-8?B?bGhBRVJvaFk2eHJwQ2pWVjIyNzUwWWZzSytnazlpSXRjdHBhUkx3STllbFd3?=
 =?utf-8?B?Z1hGZEZPVytWbnRZV0lyYjhrVmEvdlV2VmRLWmlSZmJla3NmWlVERWVjNEo3?=
 =?utf-8?B?VkVIOHNyZmxCMUtuSjZZZWdkaU9jQUY0Yy9JVHg5aTFjcUgwU0UxZ2M1NUln?=
 =?utf-8?B?OUdMeGdwd0FqVGJJVEdZaXJQakd2cFlDU0hUN0lBRHl5Y2R6aFJJRnE2b3U3?=
 =?utf-8?B?cFMyQkQrVUNEdjRrSVhhK0sycXJUdC9oRStoakMzdDdqbHBKVjNHc0J5SUVW?=
 =?utf-8?Q?UV+lpifLtztrS191pVOc8niT8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffcc83a0-93e1-441b-86a3-08dc6e49e999
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 03:58:11.2732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6FvmLO/6VeZ5MsvREgr30Crw0eJf+NmqKnOnk29QthNfUUmmh3I2EG3zkBvyGyMbs2TBaSYRKm0uhxom9ZzjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6379

On 06-May-24 9:54 PM, Jim Mattson wrote:
> On Sun, Apr 28, 2024 at 11:08 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>
>> Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
>> in AMD docs). Add support for the same in Linux. Bus Lock Detect is
>> enumerated with cpuid CPUID Fn0000_0007_ECX_x0 bit [24 / BUSLOCKTRAP].
>> It can be enabled through MSR_IA32_DEBUGCTLMSR. When enabled, hardware
>> clears DR6[11] and raises a #DB exception on occurrence of Bus Lock if
>> CPL > 0. More detail about the feature can be found in AMD APM[1].
>>
>> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>>      2023, Vol 2, 13.1.3.6 Bus Lock Trap
>>      https://bugzilla.kernel.org/attachment.cgi?id=304653
> 
> Is there any chance of getting something similar to Intel's "VMM
> bus-lock detection," which causes a trap-style VM-exit on a bus lock
> event?

You are probably asking about "Bus Lock Threshold". Please see
"15.14.5 Bus Lock Threshold" in the same doc. fwiw, Bus Lock Threshold
is of fault style.

Thanks,
Ravi

