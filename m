Return-Path: <kvm+bounces-25692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A0A96908E
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 02:04:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CF9EBB21F7D
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 00:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B2D846D;
	Tue,  3 Sep 2024 00:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LcvyNfpG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A878801;
	Tue,  3 Sep 2024 00:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725321855; cv=fail; b=p0Dj9TAzwN8WzdngL5ymdP+AeRd3AF95thsMMCntf1+XfrqEq8EhZd1KnutCbSbGOZAc3p43J7AoIgrFLJAHxADRaX2V7u3rx4cS4ZRPZKZD2ZfY0cbBr8IjAxObVtLKSrpdTuQMt3TJjJq2A/ZyV+Al9x3fY7PInELx2nwkXHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725321855; c=relaxed/simple;
	bh=Qnx4MLf4j4jCDQmIBn0bkhNrUkTnyjzGL4j56S9pfuo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gDWuZxi3ED+DIza8sbRDh0kWIPMi9fRtvDS1Du5x6uq8nS0bZEcrgX+PH+ZBVSnN6uLX4kq7gBx+fBFC6tW/JBhpGF6scdiag9c12GRuuFiFXpIi2etXJ+UjxH4aK5qTeHB2EL3rZ3FK2JaKPNsFoc0on9R3ljxsNLpb076LMII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LcvyNfpG; arc=fail smtp.client-ip=40.107.243.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XT4E0ajtJ85HfvwNWumVzKipB0yKpXauawF9mRTC/1IE+YF1AUbJgX9zjMRbhy2nVQYXH8Q3pPFi2NQctwdUGDH5d2KQmEOqM/y/DG/rxgEt7sgK5KY/6+5+EAM4fTH/44CHpOSRN883ml4w/ABl07Vu/ChcRC7oU8dB+kWFBU1PLW1mEUSJ6P7n9pqkkLLNHFzB3S98B1fpjugrY/j9S30N1tJc954PPw1n8h3EgQS7JfD8ZEqmJiAAqhGFtnAoQdbvu/W8urcfOw4hGwSWc1x2ucN2HcUJmNXUAbVtzB+4bm05quhY7MlroTIcLIfRktdiq61EsezrA2OUcfDmyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBl3ODpxoPHxcAVUTBj+UUnG0mnjwiz+0kgwV2+nJC8=;
 b=q2nTklx9biSKhflA46QyjKC1LUdDzFpgnlvPbMWAWJUXxJgFKZnupXtlBdu6f1revVSbDd1JlZJbdpJtCL3WHmCHObiSYSopOCvu49eoWTycUbdNY5dT90Y66XbQEirSxszsLRtSKysoYWdoOzutVpkAjiQw8Uh3GQCkGh6JFme9TAlRHqyZun0uuKuneqOa89ow8btnpBcB6PdCFB5jyhZ0RMfynxlY678Xh885FEK/hzj6z4mPGcCcQXv9pNsjU6Wr1yr8EyplnxzgeS5YGgHea+YZqkMJd2HKT1XB7FDJJYvQ+IZigUGYYEiU3wTsDZ1PFMWo635SlVThyfT5IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBl3ODpxoPHxcAVUTBj+UUnG0mnjwiz+0kgwV2+nJC8=;
 b=LcvyNfpGy743A22s9K5HDxhagFFv6tFDoAAsN3uS3OuUlIMOne6/wj4qNzsZ7FmuDKAvU7Qdv+yqfnIIaxCWLNSQLtF/q165VrPKklaVbg6kh/UiIBQf5r8rC5p81RcUO/RGIMpJ1/h/P4WXuJEU285eB1ZXbPaqp9vqm0L4uoQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ2PR12MB8980.namprd12.prod.outlook.com (2603:10b6:a03:542::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 00:04:10 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 00:04:04 +0000
Message-ID: <619bbd08-b423-4547-9748-6e5b5c0543e5@amd.com>
Date: Tue, 3 Sep 2024 10:03:53 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
 "michael.day@amd.com" <michael.day@amd.com>,
 "david.kaplan@amd.com" <david.kaplan@amd.com>,
 "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
 "david@redhat.com" <david@redhat.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <c4156489-f26b-498c-941d-e077ce777ff4@amd.com>
 <20240830123541.GN3773488@nvidia.com>
 <7abbe790-7d8e-4ef6-a828-51d8b9c84f33@amd.com>
 <20240902235207.GC3773488@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240902235207.GC3773488@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0002.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::7) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ2PR12MB8980:EE_
X-MS-Office365-Filtering-Correlation-Id: 46500910-89fb-45ba-1df8-08dccbabebc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWdZOUFiN3l5WmxGZGtXK0ZjL1E0Z0I5UDlvMXFvOFdKVlkrMGdBampwc3Iy?=
 =?utf-8?B?bkpqc0ROenlZZmRENjdnc2VNaDc3RmRwNkpOSk1HQWVtNVBJU1YxYmhzRXJy?=
 =?utf-8?B?cUhJcTNnS1pINHA2djN5aUNLbk9kNHpDeE9KUUhpYU00TTBiZjhCcE4xWDRW?=
 =?utf-8?B?TEswQmJib21rVlhJOHhPMjdOVGM1SGh0Y0xicXE3cVpFTjZjdHhlbzgvdndY?=
 =?utf-8?B?anlUOUN0c0lOQXdXQzdvc0U5Wk9xeUhRci8yd0JOOTJ0Sktha0lpd3lMYjJT?=
 =?utf-8?B?SXR5c3Z2blg0eDU1T28rU290M3AvdnNGRjJ2WWxCVWR2c25KSUJyTmlDQ0tO?=
 =?utf-8?B?U0pDa0NBbU94eDNUNDVFdVhwbmYwK094L3FGRVc1clpuTXZkNXl2ZW9HVEV3?=
 =?utf-8?B?aTVsWXlGbVpNNjgwUXAwNHB2blRPYUR0S3licmdxeWt4N2tuWWFpR01wakRM?=
 =?utf-8?B?N1hXSVhzcG5rMlJleUZMdCt5bGcxU3dQWm5MSjFGUFpIYTVtWkJoelJkd3RT?=
 =?utf-8?B?WDhyODYwNUp2cEhENjNlMW9jN0pwc3JySDJ0dy9ra2JUVzV0bWt4VWI0NHU0?=
 =?utf-8?B?KzhRcmorNFM0UmtIVkZ0aXdrOU5GK0xKSnB1Y1lQZjBia0hkMjVPR3MwVEZz?=
 =?utf-8?B?WTZIZmUxcmdGMGhhekN6RDZWd3BEOE5ub3hQVVhYcVdIR1RQNTlGUzFuSkJi?=
 =?utf-8?B?clFqTTNuMUxtTHVpRm1UNEIrV2tub3hCYkk1blJiK2R4T01QcGN0WXk5M3B4?=
 =?utf-8?B?Uk9RNzJKVmRDS0lCVXlMSUVuTzNqdCtucUJqc0N5TTJjMmFDNW00OWJicURT?=
 =?utf-8?B?VzlZWUVSSXg1TTYxSmNiV1F0ZDdEU1B3Z253OWJTcWZTV2d5MFJ6TVAxY08y?=
 =?utf-8?B?YU9nQ0ZDZFdMM2dMbDJoblFYZDI5ck85WE1CRWVtS2U5VkJNd1N2Ty9jZ2ZL?=
 =?utf-8?B?ek9iZFdIR1FsYVdnUGdJWHl3VHVNV3MrejlaWlpyZXdmWnRCeXJMQ2VFSnVV?=
 =?utf-8?B?WXVMSzlQMGh3eFhRcTg3Kzk1NkhyUy92YXFua2JPRVpVRFo3VVAzamRxZy9w?=
 =?utf-8?B?T3UzSVNUMWNJT3NIMUFxcFhQeEU5MkFiTnVjcThmZGgxKzhOOGlwMGpMZGhT?=
 =?utf-8?B?WGM0K2JXaTB0a2I2QkdrSFlFSWNualB3dmNZU2x6d0ZPbjZyNy9vTWVNajRO?=
 =?utf-8?B?NUUxWnVaaklNODZiQ0hkWUhZNXhaWml1VGJxeldHR0dBekZDaTFEMjM5eVln?=
 =?utf-8?B?RjRnNEhQQ2ZUZ3c3TGpMK2hqSkVMV1N0WjdBQm94RTZOT3V5RGw2aysrRmRa?=
 =?utf-8?B?ZjR3a3lOYWZoRTd1WDJPMnNFSnRDb3k5aGFOMlhaa2ozK2N6SS9NVFlMVzB2?=
 =?utf-8?B?VkxiMzAvRFh4a1p5RkpDeU12Q1NOQzFvYTAwcmhleDFlUkxKVjVkbzlVd2dE?=
 =?utf-8?B?TGp5K3MzUGRJek01M3gvSXVmQ0pNdVU4eWJWeVJlMFp0UEtwQm5vaVRUOENJ?=
 =?utf-8?B?ZVVXVDF2Qmhpdmk2SC9HOWhXNHZNOUtaOHdUd1UyTjRDOXlpNCtXUFh6OEQ2?=
 =?utf-8?B?RWs2VXhSaUo5M3BPa2RrQUlVWDhtMXBnM05xQWh4QVVKN3JmeDY4VHo2TXhF?=
 =?utf-8?B?cHp3dmFBOG1rbWpiWHUrZVUwb0FiRyt4aWlLTjk1ekQ1YXhqdCsrMzc0ZFdx?=
 =?utf-8?B?NlpHVEttYU4rK25KQzlNY3BtKzRvOTFvSmg4aVdYV0JJZGdha092T3BFVlF5?=
 =?utf-8?B?RWNmVzQ2TXE1MHR5cVRRNVdBQlk2ODd4Y3ptNFZRSnI3QkVBYjVERW5pYi9J?=
 =?utf-8?B?Ti8xQThrYjN5M3BsQ3lTdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlR6aVBsbU51Tm9jUmxiVFhoUmI0TEFIUzZRS09ZWHo3V3VPNmxGZU41UFIy?=
 =?utf-8?B?R1lVVk9tT0t6cldyajV3cDlHMHdhRWw4MjBsWGdieElHeFdqSjh5SXBIenN6?=
 =?utf-8?B?aEpVaXAzNURVRGI2VHArUkRxQXZhK25PQ05xVE03OTVsZ0FTVThGM3hMQ3o3?=
 =?utf-8?B?R240dFNxMWppMDdsSlpxbkNVY1p1TEszY0dVSCtLKzZJQjBOUWRiV3Q5d2JT?=
 =?utf-8?B?ZFhwVUNMWVlMbmo4QTA1TElldU1QbTBLSWNiWjNIWVJLRERMSjlpMnp3cVVZ?=
 =?utf-8?B?U21DYXplR1NSL1NSWWIreWNaemkxM3ZkcktmL3RHMUE5WHBWcHkrVWVyUFdw?=
 =?utf-8?B?UU5ManJ0NWJoaEFvTmp1UU9adlYyNHlzcDJqc2V4U2lhTG8xdHlIRU00Y3lP?=
 =?utf-8?B?akdQYjBFaEpsRVF5SjM2T3V0VzE3VDF3MnRIQlVOUnRDa05oaWhranNURjhN?=
 =?utf-8?B?b1ZpWUgrWGR4RXJTUS8zUU11S3puQXFPbTVoeWJSeWlTN1duOVNZRnZIc0Jr?=
 =?utf-8?B?cmp3cTFIVURheFhyVXFpL0E2VnRaTVdOR0FseWlPRTZidFJZQlRZUkF5Z3U5?=
 =?utf-8?B?d2FLN2RsbStrRmplVnNjdFRCZkdrWk1yWHZkUjAzS0YyQm9VZFRQVzJUeVJV?=
 =?utf-8?B?SEhoeXYvS1FzTlFYK2dxQm44bVBmZGhydnFrYW53VWZXbjlrcXprcCtpSnlQ?=
 =?utf-8?B?Y1gzblc2NVByMTNOTENUNXk1R1NjVSt1L2RPbjRWVXVrWTFDcE5BUnlJQzM4?=
 =?utf-8?B?Sm5MQUdJYSsra1NwUkh5ZkpyNkVpamcyb2tWMi9Ba1UzZkFUdzd0cUR1SXVS?=
 =?utf-8?B?dlV5SU03VlBvT043cGI5VjFYelpaUUdVNWFVbHc3NHFIWERtRzJNeHJ3RDdy?=
 =?utf-8?B?UHpQdW5rc244UHMyUFdkdVFlUk1GT1pSK1ArcFJabTFmNWRuTW9rTy9Kd2Fm?=
 =?utf-8?B?ajBhVGV5Qmx5aStJUEZ2K0pKellOVG81alVvMTZtNDNjM3gySkpoTzI4cldS?=
 =?utf-8?B?YjBraHI1ZVBZZU5QMU1kaGtNQkNxRnZ5bjJpRnlSQ1VCMkxPZFZFQkFRYlA2?=
 =?utf-8?B?Wjl2ayttVENXZ05kazJjWm83Vlk5K2FGNkd4VXBqb3dnSVRDRjZWTWVTdU1z?=
 =?utf-8?B?dFJxOHlrMkg5RUl3elVRYWlndTR2OE5YTTVJQ0xERnFhNm1ldGdtWXBlN3NW?=
 =?utf-8?B?OE5ERzg0eENUMldXZ0d6Mm1Sd284NzA2V3Nac0txeEVQQldQbFZPZlBQUjIy?=
 =?utf-8?B?L2pvbXEzNU8rLzVxSVAvb1VwNXRGamwwWGhFZlpLbFFFMG0zZ2hienJsWGU5?=
 =?utf-8?B?WVRaNThMMG9nM0Ywdm9CTGdhNVYxY2dHMk5lZEs5WjBKOTRoR3hUdDc4b3or?=
 =?utf-8?B?emVweDdtUEhRNUVmckZBckpoR1RnMUJBdm1helUvNDdWeXBYL1c5SWM0d2ps?=
 =?utf-8?B?MGQ0bWNvekVoODFkQVZhc0pNbEpJelhzUVR4R0MzTjZmTFJ1ZWsyOThTVERZ?=
 =?utf-8?B?QWgxSlNqRjJ6d2U0MHNMd0hPOGhka1RsRHcxOHhDTmtQT0tud2l1bFp4K29K?=
 =?utf-8?B?YTI4VEVmVjFJYTc5RVZ2VTNwSkJIOTVteDRJWGtpYWhQSE1Tby9KVjNWOUFp?=
 =?utf-8?B?VUYveTFqM1lWVXNWYm93VzhBcTgwakJsWk1uSHMvczc5T1NxdjliR21oU2dX?=
 =?utf-8?B?MkZkS1J0WWVqeno0Q2lpZ3NLTVF4Y3g4UzhsL1BuRWVTL1FSSFU3RVN4dTAv?=
 =?utf-8?B?ZDJUdWp6OVA0OGhycUZPRDMzWGZzOWsraENvelk5UElMUnJVT09WZU5XaHpm?=
 =?utf-8?B?ZlA2dmxYZFRFNDZoZXZlVTRLQXVKVElsbFdORU5lME01NEx2TUNleG8xVGs1?=
 =?utf-8?B?SWpCc0RwMUJYZjFocjdGN2QwTUNBM2JkclpibmludW5KODdTTE1MTFZPSnRq?=
 =?utf-8?B?dUlBTkpxZDNaZnRSQ2Fic1V1UURXeTdKbTVNVFVjczBJanZRb2FtdXRySjFv?=
 =?utf-8?B?MThST3BGbjFSQ0tOUkZGWFFlaGl2LzJCaWxZcnJmdUhRcnViVDA0OU81Z2xG?=
 =?utf-8?B?dG4rTVV3bnRZYStNdUF4WCtNZ09LZzZaQUM5c3Q3cm5pVVM1L1dhTmZWcTIr?=
 =?utf-8?Q?CqcEBgFIWVFKgiRP9DBJOmIaZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46500910-89fb-45ba-1df8-08dccbabebc6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 00:04:03.8503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MDk7RXLb+wJxRi1pJ5HbIijjLf/iUVHJQcuV5Dpdp5L4yd99KKPJg5+xejmxbEiBDEzH+XGqOdQm0gPaRQNAaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8980



On 3/9/24 09:52, Jason Gunthorpe wrote:
> On Mon, Sep 02, 2024 at 11:09:49AM +1000, Alexey Kardashevskiy wrote:
>> On 30/8/24 22:35, Jason Gunthorpe wrote:
>>> On Fri, Aug 30, 2024 at 01:47:40PM +1000, Alexey Kardashevskiy wrote:
>>>>>>> Yes, we want a DMA MAP from memfd sort of API in general. So it should
>>>>>>> go directly to guest memfd with no kvm entanglement.
>>>>>>
>>>>>> A uAPI like ioctl(MAP_DMA, gmemfd, offset, iova) still means userspace
>>>>>> takes control of the IOMMU mapping in the unsecure world.
>>>>>
>>>>> Yes, such is how it seems to work.
>>>>>
>>>>> It doesn't actually have much control, it has to build a mapping that
>>>>> matches the RMP table exactly but still has to build it..
>>>>
>>>> Sorry, I am missing the point here. IOMMU maps bus addresses (IOVAs) to host
>>>> physical, if we skip IOMMU, then how RMP (maps host pfns to guest pfns) will
>>>> help to map IOVA (in fact, guest pfn) to host pfn? Thanks,
>>>
>>> It is the explanation for why this is safe.
>>>
>>> For CC the translation of IOVA to physical must not be controlled by
>>> the hypervisor, for security. This can result in translation based
>>> attacks.
>>>
>>> AMD is weird because it puts the IOMMU page table in untrusted
>>> hypervisor memory, everyone else seems to put it in the trusted
>>> world's memory.
>>>
>>> This works for AMD because they have two copies of this translation,
>>> in two different formats, one in the RMP which is in trusted memory
>>> and one in the IO page table which is not trusted. Yes you can't use
>>> the RMP to do an IOVA lookup, but it does encode exactly the same
>>> information.
>>
>> It is exactly the same because today VFIO does 1:1 IOVA->guest mapping on
>> x86 (and some/most other architectures) but it is not for when guests get
>> hardware-assisted vIOMMU support.
> 
> Yes, you are forced into a nesting IOMMU architecture with CC guests.

Up to two I/O page tables and the RMP table allow both 1:1 and vIOMMU, 
what am I forced into, and by what? Thanks,


> 
> Jason

-- 
Alexey


