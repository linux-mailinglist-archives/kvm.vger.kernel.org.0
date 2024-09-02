Return-Path: <kvm+bounces-25658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8A7968196
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 10:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 444D4280EF5
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 08:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D52185B7F;
	Mon,  2 Sep 2024 08:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vG9bPX8n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494EE17A5BD;
	Mon,  2 Sep 2024 08:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725265333; cv=fail; b=LfHI+Fh0mJRr6kA2Dmp2cVGQoO5BQgo4zhqpQiWoayGNhas+blGrSyZ8UnsNIGbKxu27XIHKM4TZmjgwVYu2PK6tL80BMl6izLJYpxLjcUN2Tgl9lozDDGuR59WdFam2dqFDx0C6rdEMcCRa+2OLzJEUiaZ5TH91VSCoPh9ZBe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725265333; c=relaxed/simple;
	bh=KY4BejlnsnkktvEJLnnECduQxbKXi0yKOqJ/BP05u0s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oL6wLAmvbuGX+vzwNIbXYpfCANSpEniW8oN8mWyocTN3WcglHbwmNVjUKt42+pEjFjVYu94v+wxRNYpLwx2HwMJV3/w844uYGXA1KK3VWZKR9huiWYaJDFrmdyGkIX85tdsBkBBKAcCfvwoiY+U3l79Vv1bXoi0C8rCEviBDDKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vG9bPX8n; arc=fail smtp.client-ip=40.107.243.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CEN7B9222AU3xvR48FfYyd4iLhTTyoQCIAMQLSN5W4/PsA0s0dSwlPTUK8KJW15C/8J7jpwwmEdR9bbP7fwkcg0B9pdLOeOcAn0xiT7IdUe6dQMq5VifDXj3G8GGSt7q40F2rqvMzumSeJ7bmGMMVhL6hVdbDsIQpTbQCnagHdgBmp44eTVMoMGiOW7llxQSPWOPY0fsJFZ2BdEbCVck/SZCGJYnCD32/5nBIQbjYhmmuJ5nrl/hiEoYz4F6vLUCnKs/9p6w4wP1TM7KCmte0+WJ27OEW02MxpALMSheDjwrX1EB9xPpPOSrzJx+bH8k389ybWSd8CRc8c4b2/k1QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57oTztkKXQAZ07P0JAlJ9JD54WaTlV7p99BRIjk76HM=;
 b=koPj5pKAWygA3RRkWHhymR5muMaxIlvSwnJhJgvtM6pV+MFbv0TU3W1HHUJhrpYmeN5ro02p+JILdAXSMSOQu5C61oosmDmKVoxDirXriXl338D10d8PUr/NPF7ptkyYifd5durceDDqCxdCbWWqFvCzBRmYaqEyaysb0UaxgIMEHTLLLUhApp/n7fD6IhYto1zOXDssDHwZWLFo3Id26GWvPBP/lnePcfDsIzb7PK+6XnpKM9/7rfSpCBMNAH3WYLA+QwGMaeXJqjIaL+OwN4dTgjsC9HS/heeosne/vVqWLJJd/q2XY9gLcmUVmy0mj2rbpqJERdz+DHLQEk13eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57oTztkKXQAZ07P0JAlJ9JD54WaTlV7p99BRIjk76HM=;
 b=vG9bPX8nQdjfyOtWlswJJf+VYWjNqMFDQnXCDsaDqtm6rpYUh3CiZSk3UTFR0fKBazogwx94N54fKVLDTva3+esRPki19gZEsPlwUosgr+c/GMx4sfDEJ00B0ODdSQqZ80geIODcx9bIR3CDQwH1ZzUZYlwqjRwKzGpGGJlzsD8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CY5PR12MB6382.namprd12.prod.outlook.com (2603:10b6:930:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Mon, 2 Sep
 2024 08:22:10 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 08:22:09 +0000
Message-ID: <028e2952-ad4f-465d-870e-93e1ae6268f6@amd.com>
Date: Mon, 2 Sep 2024 18:22:00 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 20/21] pci: Allow encrypted MMIO mapping via sysfs
Content-Language: en-US
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823223738.GA391927@bhelgaas>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240823223738.GA391927@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0057.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20a::9) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CY5PR12MB6382:EE_
X-MS-Office365-Filtering-Correlation-Id: 7386f07d-2fdb-43b0-dd49-08dccb2856ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZytIZVBpbmt2YVFNZTFKYnBPY25MdGp5Q2lwSHkwSXFRRjVSRExBOE5ualdu?=
 =?utf-8?B?Mk9QaHpPVi96d0ZXU3VZaDFWNE5sZ1k2aWwzTmV3YkVHRERRRnRiZ2kweEFZ?=
 =?utf-8?B?YUI3ZnFSYVlQWnVKMUZCTWhWazYyWExlV0pxMjJXRnZrYWtlL0pOZ2VPLzcz?=
 =?utf-8?B?bmlCOFBJLzc0RWo1NEhWZ1lZa1hkSjNvU3JKcm9lWXZNQkVKMzY4bGc5eFAw?=
 =?utf-8?B?MzYwa0hzL3dGNzFkSE1tdkpVZWFRZWJYemhzS1dydzRNTEltcGhOTGJjK0hz?=
 =?utf-8?B?emlhK0pOc1Roc2EvMURaUFZzK01aL25IdXR0ajl0Q3hCQUNJU1RmT3JraDll?=
 =?utf-8?B?SEVTNHNiQTMrY2lURk5adnZ5dXFtT1VwWFJ2QStKdXBRUW5WbGNsa3FxYzRE?=
 =?utf-8?B?VFJrWlN2c3liNlJtY2dNOVlqbkVYeHY2MkNpZ2c0RklidWE0aEtIazg2N1h2?=
 =?utf-8?B?VVFiSGl5UGVRMzgrZXRMNE4wZHA5dXMrTXZoWVFXK09uMGp1d1RnblpOTVp5?=
 =?utf-8?B?OXg2RGV0WFFIRnZXRFU3cC9XMTYvUWJDWDdmZFM4QTVPWHBNRjhyYzdPNWJp?=
 =?utf-8?B?ZlpvaHBXRGV6VWl3Z0dKTVNjYnE3akpWN1haanMrVkZlYWRXVzBtQWNDWER0?=
 =?utf-8?B?WXJoNWhwaStWcE1HbFIybW1yOHU3WGJMUWJYYmVpZFRFS2xCcENlYkVnbHdT?=
 =?utf-8?B?ZFRZTUw3YnVGZ01LVVNqY3JyQmtqSnFVMVlTNzJxbCtiZTJvbU1Cd2JmTGxO?=
 =?utf-8?B?WmtLODlldWlBbGR3aG1nQ1RyK3IrdWRSY0wySmdNSk9JTHVEYVBIeHRRWkl2?=
 =?utf-8?B?Y052US85ckR2amRPMlY5V2VtQXJvYnJzVHBBMWJYYVg3SlIxSEVCZnRrczJB?=
 =?utf-8?B?dW8zdUM3QjZPaURpRHpabnF0cWhHNVJZdTlSMkcrczgvVWlhbHVtWkpTOGQv?=
 =?utf-8?B?dWN2Nnp1ZExXWEM2eUtJc2xjQVFkYUJYYloyWFpOM2NrbWxIMklTemVlWnI4?=
 =?utf-8?B?UE5uLzNvNzNFbFJJeWFsSVdmQUtBODZCVU0zSzluY0tPR3NNY1QvM3YxZG1w?=
 =?utf-8?B?VFE1MnVTSHpBeWRVRXI4QjFUZDFpWkNlVklNTENEZzZnVktlMStSOFppNG15?=
 =?utf-8?B?clpHTlcza2JVQ2l2d2ZqQlltdTlvNXZuZXBSdkVDMVQ0ZzNFQW5ZUTYySFNx?=
 =?utf-8?B?YU5neGl4bExnUHNqb0VObFNOa0g5TmtiSC8zbExabEFnbGZ6WkppTmJlaDdG?=
 =?utf-8?B?aUVKZVNONzlsSW5uZ3NHekIrRXNaVWdhalo2eCsvQ1Z1bmF3Rm1URFpNcW9V?=
 =?utf-8?B?aCtXYXFsc08weWZldm16QVdUa2dkTGVLZkJDSmgxR2pPVDE3RDBLWHZBRUJC?=
 =?utf-8?B?SzFVVjNycWxUdFd6SFQ0cVdVeXNEZDlDSUdXQ0MyOUxaTFBBRjBaY3ora0l2?=
 =?utf-8?B?bTMrQXNNa1lYWDJLbDZSaVk1SU5ac21tbll3c2owQXlSdTZtaFJhUVBYdXIz?=
 =?utf-8?B?bmRMd3NScmQvYTkzTi9Tam9mVGNHUllZd09YVExjdEkyZVdBY1ExWFRJWTdq?=
 =?utf-8?B?UmZORWVGd2pKVlNqdVVWc3Mrc3doNXkrZlFlNXFOT1JpTW5sV0ZOR3NzdnE5?=
 =?utf-8?B?SVZjc280MmUzck1aaTdBY0ZuSWJjVlFiN2NBcXd4WmQxOGdPS1ErNHNQMVFp?=
 =?utf-8?B?eE8ybjF3aVRFeTNWMlhxbysralg2TG1xRTkxYlkyUkthS0w1cXM5bDhvaVZj?=
 =?utf-8?B?elBxWVlhei9uWE5LL1NhTnBhVmxxTGE3UkQxQkplUHk2bUU0YVBWN29KaXRM?=
 =?utf-8?Q?BM5PlNyDnNFJ2ELPOAK+/UO09ctPcVKEsho1A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWg3MzdSN1lrWTl6cXg0VUE2cWgraVlRS1c3UjJNMnN1c2laSzBoaWdKblcw?=
 =?utf-8?B?VkpSa283NTYrdHc2QkgzenVPaHhRV0hjUmhRQSt5WWlwRVNrbC9rWW10Sk8y?=
 =?utf-8?B?ZithVy9LcXhFeXJRdlhGK1BpU1B5QkZBYU1FSC96ajVuQ09ZNnN5c1FLVWdY?=
 =?utf-8?B?YW5XUkh3YjZGQUwrajhncFFENEI1R1VmcDRsdHBXb0Rvc0VFMGFacGpVWWVE?=
 =?utf-8?B?OXgwMEQzeHRDSHZvRjY2aGdaUk5YZUFqMjIwdCtmRkRxVWdST3JldTBCUWht?=
 =?utf-8?B?RXY0S3Z2eEVqTk0wZU1vdDJISFlQdU9NR1Q3WXJ1V1QxRDBPcGVXTGpEbDJ6?=
 =?utf-8?B?dk5ydk5HbXRsWEZxaUgyNktUQVpYNmNzbjJKVHpNN1VNaDN4R2dnL0F1ckQ3?=
 =?utf-8?B?UXJsNVZ0WWNwNGVnNkVOKzBqRHdxT2xVMEpwdHUveXpBUEJ0ZlVBMy9VUUpT?=
 =?utf-8?B?NjlpdFBsdkE5UFU4UTArOEttd1FZd3NsVWxCSWZTSmtPd0phc0FMaldDQVBS?=
 =?utf-8?B?eWFLRXg4NnpRZ2xJYk5aSmUvbjdSR3BMVGU0dVoxVzRuM1pVRlVMU3VuVGR6?=
 =?utf-8?B?Z2UyZXV1eVUvZGtuUmRZWS9WeUh5eFhrQWdUdGNJYmpUR29hRndhczNuWTg2?=
 =?utf-8?B?eXhOQTZrQlFCS09ZOFEydm9jTkNaZUY2S3hxaUZLZFJxNGlmaVBXUytFcmxs?=
 =?utf-8?B?SkV1NU04N1cxbzczVStGWHEwWVQ4VFFhaFg2NkowQlVhVTJzOEx0SzM0QTYv?=
 =?utf-8?B?Y0FJTEVMK3VMd2p4WUtqcWtnK0VRYk1TL3NsQnRSYVVGckMyRzNRanYwcmVo?=
 =?utf-8?B?RWpTczZMQVB3UGFQdkdGTVJ5clVSMXBUTVNSanVtWjVTLysxaUZkTjFObEI2?=
 =?utf-8?B?Mis0bjkyU3ROeklHWWFSZC9nZ09kTHo5bXg5RjQzSDJoRFNoVGxtQllnekNJ?=
 =?utf-8?B?L2ZWQXNqMVAvUE42RlJRYmx6R2NDekp3UkNXYkkxak9jQW9KdkduWW5hNjZZ?=
 =?utf-8?B?Wkt5VmxrQnA4OXpLbytQZU1SckFtZHdMQWpDcVcxTnByVlplTXVqNWhya0Yx?=
 =?utf-8?B?Y3hYMTZiOEdGR0ZwYW42S2psMDRhSjNYYk1BdzNoVUtmMFdKQ09mMzlJcTNB?=
 =?utf-8?B?dU5JWWw5TG5NWWU0eWowVkFoZERBUm1qdy9DcFhOUS8vY20zU1pvb2hscVNa?=
 =?utf-8?B?NmdOdjV3ZjJzSzIxOC9NMXQxWSsvbU4yZjF3TDFaSm5vcHpCbU5McklpV1JJ?=
 =?utf-8?B?dFc1T01hU3BtRkpvSktTd0pEVlh5WVVqbG5vaUVOYVBwcjJTTWo5WlVzeDJY?=
 =?utf-8?B?TEpPV3dXWkZDVitoVldPTTRyRVZvcjc0bjhiOTh4QjY2bFhZenh0NC9FelZV?=
 =?utf-8?B?V3ArbFUrZmM2MjExQndiT1dLRjhIRTdnRk9WbUZSb1NxUWZlNWxNM1ptZFEz?=
 =?utf-8?B?aXFHTkZMR1c2dUhuRXZETFo4UEhTY2xZdTRxMGp4Uk9mT0tZViszK2NQWkE3?=
 =?utf-8?B?MnBiOXVtV0duVFN5UHF5ZCtnYldKTzhQQ0xHVjJyTGhKVTBlU1dMdHM0QWow?=
 =?utf-8?B?Q2lPbTdNZUN1SnlQc1hmNUlRNW5RdVVUeWdLQ0RiYUMraFQrY21CMnY1VjF0?=
 =?utf-8?B?UDRFTHZrcFM0RHRaN2w3K1dtYjNPbFFoLzFNcFloWTJaQ25jdVBWUzdmQnli?=
 =?utf-8?B?M0JMdVhlaWY0VU8wVkRvWmsybnFrV2ZuSjRmTzU4VUhkVkYrcjJEeENVbXhl?=
 =?utf-8?B?bExnUVdYcU53VlJzdjEwcXNnejQ5d1g1Yk1xN1I1b3Q3UlNSWnZ6dXhTUHhi?=
 =?utf-8?B?bzFnSHNIekk0ZnYvSnNWbFpUWUJQd2praFJLQ3RYWjdBdzlGUFlQZ3FIZnpT?=
 =?utf-8?B?blNlT3ZWa3hMN1gzOEVjZDZjVkllMmFrNklpeUJTWXlGcEs2ZXNyRjhUcDAx?=
 =?utf-8?B?WGJabW0rMGJmT283Sk9DdUZRaUpSenVIVWFhKzBpcFkrUjlYdmRQcWtqc2cz?=
 =?utf-8?B?ck9Ha0grV094SkJUSk1mOXcvK0lScmRzZ2svWlFjRXJDc2JuOUkzbEE1SUYv?=
 =?utf-8?B?aS9PZk5wdE40cVNITWFPcXNPVUNEdjRtK3VuTGdFUmdKbHoxZTlCS2RKZndZ?=
 =?utf-8?Q?CSYbxuM6SLFHga2N4nqYdq9Bx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7386f07d-2fdb-43b0-dd49-08dccb2856ad
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 08:22:09.4803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZa0hyNNVhoK5NdMvxL72JzzW69ne3uF2aho5p0WewMZm7h0ILJ0wFHg/+lbCxC6sxp5sRHHoM4bcx0fBDZb0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6382



On 24/8/24 08:37, Bjorn Helgaas wrote:
> On Fri, Aug 23, 2024 at 11:21:34PM +1000, Alexey Kardashevskiy wrote:
>> Add another resource#d_enc to allow mapping MMIO as
>> an encrypted/private region.
>>
>> Unlike resourceN_wc, the node is added always as ability to
>> map MMIO as private depends on negotiation with the TSM which
>> happens quite late.
> 
> Capitalize subject prefix.
> 
> Wrap to fill 75 columns.
> 
>> +++ b/include/linux/pci.h
>> @@ -2085,7 +2085,7 @@ pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
>>    */
>>   int pci_mmap_resource_range(struct pci_dev *dev, int bar,
>>   			    struct vm_area_struct *vma,
>> -			    enum pci_mmap_state mmap_state, int write_combine);
>> +			    enum pci_mmap_state mmap_state, int write_combine, int enc);
> 
> This interface is only used in drivers/pci and look like it should be
> moved to drivers/pci/pci.h.
> 
>> @@ -46,6 +46,15 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
>>   
>>   	vma->vm_ops = &pci_phys_vm_ops;
>>   
>> +	/*
>> +	 * Calling remap_pfn_range() directly as io_remap_pfn_range()
>> +	 * enforces shared mapping.
> 
> s/Calling/Call/
> 
> Needs some additional context about why io_remap_pfn_range() can't be
> used here.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8f6ae5d077a9bdaf5cbf2ac960a5d1a04b47482 
added this.

"IO devices do not understand encryption, so this memory must always be 
decrypted" it says.

But devices do understand encryption so forcing decryption is not 
wanted. What additional context is missing here, that "shared" means 
"non-encrypted"? Thanks,



> 
>> +	 */
>> +	if (enc)
>> +		return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>> +				       vma->vm_end - vma->vm_start,
>> +				       vma->vm_page_prot);
>> +
>>   	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>>   				  vma->vm_end - vma->vm_start,
>>   				  vma->vm_page_prot);

-- 
Alexey


