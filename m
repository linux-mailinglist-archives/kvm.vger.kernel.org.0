Return-Path: <kvm+bounces-29477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9E229AC8A4
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C7702826E0
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6D41A0726;
	Wed, 23 Oct 2024 11:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jZyRWf5S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A796154439
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729681838; cv=fail; b=Hg9FLz6CzZXqgqlLttNz4PGYkJBFRW+6cTTHXduLrc4mnRKt52sBcECIikHEK/pB+uLvKx4DTtzNugjMDRbggikLLQfpMI35srKZ5crBw+J+50uhVPIa8HEwiiszWrAZc+AoEoGe8kjcy6Oivpd+glxdZmQUPYNU9jcFubIEQAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729681838; c=relaxed/simple;
	bh=LuY9+lfwTGUocQms4ldus818N6My+w66RJdngqTCd9w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XqbLBcYEXV0uyh7zxGhV6yGwcqZVCZlhQgDZa+E6NPSZcQuEn8RIJ8eb5Ms3xTLVB0cTPf+7Qo6rmIhbnmrQ9vEnFk/e73N/6I/eTm6jMhlcXLBV+Uu27GjPPVe7OkRLPrLaPD9F3Qe8Db5AYdEyBa45nJDDNHWUh+KChDC3x8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jZyRWf5S; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JH0RaYVgi+J7125NOzxbxnO1JspPvPAXgIg2lVlUzxRNRug5GIEgv/KJ8Keo7XiiAcDUhJdkR1BO5ah+UN4XI3u7H9M3Uvvg44epWmpfvQpEJC3EyIIxeT2BlEJl2gIMeeN4ld1krvnh4w+Eb0K5QZDnAf4qq5jiseEh/oTJf9pRUc7IouLjryIjFjEIlNzLutoX+j9kaz4QaZad9NPcNfzgmfUSrUaZhMALt9o/5R2joGcflJma+3Tq7uZIifRyv3JpZDcEVsPqfQPG03AOBAyETA9L9SChxAZm0l/toiZHJtmwpe7cZE7I/WpQNu0YWNkmmLeKnQiKOer0gnAqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ib1ZXuREW8hf0L2hNIsjp0CxXIgfdsCYaTvAIlrYS8I=;
 b=wMc5xr4Or8iDYZbIEncD/ERV0wCvExSizv/TNVjy7RKo6r1oewt6ERJVZ4etHx/11fasZZGm0MozkGqsQ49lVNMmIHvRhHVon+ond18UqyCGhuq33KgA+CpKnz7HC2XqqB4BC6bfyRAo53u9IV13Qz8v5gHqdijGM3kwrk865AY+DANEIAGZO0R1oJ2/PbPwRvwHNh8ymX0ODNIxn/+PzGgSHkJHSzCNN3Sn2jtBBhrCWX7k1FbJ549oQououiN7HjYy9lV4iEQ1LnF+kPahvcG11s/V13JuIU4P6kTT2CEEDMQLMD2Ab+I0oG66zA1HQqdsxDeIugY1EB139mf18Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ib1ZXuREW8hf0L2hNIsjp0CxXIgfdsCYaTvAIlrYS8I=;
 b=jZyRWf5S72usxAA4zRHOTzrvJZAzRIysKBnfoJgMZM1rJAVITPDgatEkeqR9tnPab3GtPoOEKRabQsBZzYJp8CgT9cSrmSw94xGxz69sHY91ts4RMMY9eIhHlyMjEmAmcrJnTT1THc/7+FM++Y5f6evZ+XB4yHVocvcwTYyczr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH7PR12MB7137.namprd12.prod.outlook.com (2603:10b6:510:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Wed, 23 Oct
 2024 11:10:32 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8069.027; Wed, 23 Oct 2024
 11:10:32 +0000
Message-ID: <e937b08c-4648-4f92-8ef6-16c52ecd19fa@amd.com>
Date: Wed, 23 Oct 2024 16:40:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] iommu: Add a wrapper for remove_dev_pasid
To: Yi Liu <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
 will@kernel.org, alex.williamson@redhat.com, eric.auger@redhat.com,
 nicolinc@nvidia.com, kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
 iommu@lists.linux.dev, zhenzhong.duan@intel.com
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-2-yi.l.liu@intel.com>
 <20241018143924.GH3559746@nvidia.com>
 <9434c0d2-6575-4990-aeab-e4f6bfe4de45@intel.com>
 <20241021123354.GR3559746@nvidia.com>
 <91141a3f-5086-434d-b2f8-10d7ae1ee13c@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <91141a3f-5086-434d-b2f8-10d7ae1ee13c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN1PEPF000067F1.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::2d) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH7PR12MB7137:EE_
X-MS-Office365-Filtering-Correlation-Id: 44586438-b587-49c7-eefe-08dcf3534f38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGY5ZURWWU5uVVN6Yk15cVdCUnBlNWdRMTAvUnpZSXYySitZeWhtYjFJK2tj?=
 =?utf-8?B?S3lvZGZjc3B2eEMwODB6OUpQVU40czJTRVFwTUhSNUIrd3NOYk5Qb1EvTDZr?=
 =?utf-8?B?WUE0QkxIemltVnVzWEVGK2xGaGVSWmt1OEZCeVE5Z3JpMzV4ZnhIY0NkVGw4?=
 =?utf-8?B?T0VIanVRODI2L3BwMGVHcDFkM1lxb1RwTkNiZWlEVDNrcUZ4UlJCZkpFTFQ5?=
 =?utf-8?B?WXFrQU1VSnNPakFGenBIa1I5a1dZb3JVRVVjK2xJSzhFSGxQYldpdTJUcGc1?=
 =?utf-8?B?OWRQaVNWdE9kNyszTWNSSlpJNGhRb09PbHo1R2ZGd1BSVDNxenNzN295Y0pj?=
 =?utf-8?B?Sm1TZmkxaFd6dmRGb0hUTEZQR3luN2wwTUNMK2hQa3cyUUMrMENud3k3UnF1?=
 =?utf-8?B?L1p2RXEzeFljcmpaZUhEeGM4NXNvbW5TU3RBUkhVSTFRZWprNUpDNGtSZXhI?=
 =?utf-8?B?cmluZVJMWHRNOGRnaGI3V1JNb0VFcFVsYWc0TkNRcFIxUjFuZkVCalYzVk9o?=
 =?utf-8?B?b3l4eTA5NjVrMWhkWEFHajM5Zm8wL0xjQ2JmdGpTaEpZc3Y3U1lUODlna3lN?=
 =?utf-8?B?b2JZRUE1OWVRV3Z4dWpzUHlyS1p0UEM4WEpnOWVkK2VmZzhoT092cDBIVlhH?=
 =?utf-8?B?RlFXTnlROC82ZExpTEJvSUlSUFFQTU1NUzZrT0N6VGUyZG0xQXY2Z29SWHZi?=
 =?utf-8?B?cUtBYjJOQ3ZrZGNUWkdTTVFpZklLZ1Z2UEJwcFdoY0ZrZTNmakNHZS9pQ0ow?=
 =?utf-8?B?M2o5YXlWb0kwM0YvajFDbUhEQ2Z6VFNrU2FKS2ZsK2RLcjVYV0tDR2cvOEQ2?=
 =?utf-8?B?andFNzYrK2V5U0NVWkh3eDRQbkk4bmxSdlk4aWgza1JSZlFLZEgvTHk3dGhm?=
 =?utf-8?B?MDhqOXJZaWNRSHlaSlF4TGNsSkpzTGFJK1RDUFZ1enZLZ0tuNCtsaDN6SkVo?=
 =?utf-8?B?OUlpZzNWQTg0SVgwcXp5Q2RMNWk0a1kyVUhNcjcxS1preXJGMUlHcjlTYU5R?=
 =?utf-8?B?c1drVElTaFV1b0JoVEQweEJ2aVR5d0NqT3pQL1NrZUJ1QTU1Tmh3L2xMZkxx?=
 =?utf-8?B?ZUZsRyt4V3c3bUVhbFk5UnpDVEFDMzNPMHlqRWV5SmtwTnlOWTRwcEJCRkRI?=
 =?utf-8?B?OHhxUTY4K1JobmFPOEZSYkNDQld1NFRJMEJqYVcrWnRIZ0doK3ViN29iTldk?=
 =?utf-8?B?UEg4b0piU3FHYmpvcEZuNTRzVUtMTWk3bHMvNDBXN0E0dXVlMUNmc0R6c3Fh?=
 =?utf-8?B?Sk8rS2xMRm5UU3NhWUQ2TWFXMG9VekhLdTNwWUtyS2ZCaXZJRDAzNmVjYUlm?=
 =?utf-8?B?aTZOTU40KzNucmluYWY4ayt5a1kzcnBzdWdoRnMraHh0TnJvRlFTWDF0eXpU?=
 =?utf-8?B?bFlnaFRKMUZaUHNValg3bkxHSFQ2dXBPYW9XQWRyVzU2Y0RJRTR6K0JRMW96?=
 =?utf-8?B?ZTY5YVZvTWhZRi9hTmRsQ1BQaE95UEl6S041L3ZXZGNxQkpwRUQyWndPUVB2?=
 =?utf-8?B?bURiSFFFNDhGWVZJVXkvWFM1NjIwUWFXdEQ5bHhlZ1hyU3N5QnNPZmRidzVt?=
 =?utf-8?B?U2NTS1l4Qk1yZFJ2elhTM1J5citiV2ppNWQzRnV3aHp0VERkNUx3SHRHb1RV?=
 =?utf-8?B?U3paT0VST3R5QXFmVUdRSlM4RWRDL1ljNzd5ZU1OVmMvRWlZYzEzSU1ua3BU?=
 =?utf-8?B?NjhDdEtROEJVT2djVmZXNTArOS9tN05kN2FLeWlGTlZ3MU9pM0ZSL2xmaU44?=
 =?utf-8?Q?mwZlaVlnnIHTEenu1w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmRrcncxdHd6d0ZkTkRIcnR6V3Y1Q0h3b28vT1ZLUndFaWxBWkVHQTZ0d1gr?=
 =?utf-8?B?dnU2QnkrSU94RHYyVm0rZ2l4UWtMRWw1QStPQThENnhNK0VXOHU0SzY1aXlL?=
 =?utf-8?B?UFJqNG5XWi9PTThERkFnRE9VTXdOTmxTUW5EaTIzV3VLMkM4S05ZTW1SZ3Zz?=
 =?utf-8?B?UDV6aXlNREZNOCtvbEplVE5rTjNjQkxORU9ubWJXdjV3cW1LbkR6VWg5OVlq?=
 =?utf-8?B?OSsyM1BMYWQvcE5tZnRsd1ZuanlLME9TSjJ2OENkQy81cUJ6QVZjaFpoanhF?=
 =?utf-8?B?NEJ5YXdFN01qRGdqWU1kQlZBcVZ4RDJ0czBhRjBDaGUzUUt6akdGOU9iUWsv?=
 =?utf-8?B?TzUraiswc3F3K3Q1cFkzTDhLMFZiQW93TjJYbkpxWEppVTJxd2s5OVpNbFZ5?=
 =?utf-8?B?RXphekRyT285cVpSZjVZUDdZTlkybklqYXM5YWllS3ZxNS9HS0xlc3dCVTUw?=
 =?utf-8?B?UDRFWGVTQjF4VXdxYTI2SDFab2t5bzNuVHYyaHM5NWFxcUdxNi81TUphVUNI?=
 =?utf-8?B?NWFkRFdIMHA2QXdMM3NqMUFubHFWT1N1VVprQlIrSno0a2FVcG9BVmRuQk1j?=
 =?utf-8?B?ZGh3bHJ4WnFYanNuamlyUDNCQmhMNFUzYXhaTTN5NXpqamd2TzhHeDgySUhP?=
 =?utf-8?B?R1pkRVRtUGdWZ0N2NUpZNDFpalU3eGtxTkZ0cTZ3TnRmNnUzOS96bFlKRVZL?=
 =?utf-8?B?RE00bTM0WHlWYjNEejlwaHVHOTh2RjgrWkpyZ0VxSmh0UWp6WEVVdUhJRGlJ?=
 =?utf-8?B?QWx2V1JhSVQ3eStrVDdVRUFublFUU251T1NuSjRiQS9Pc0NjS0lhb1pDSlo0?=
 =?utf-8?B?WGtnMnAzQWh6Z0drNEl0aEFjUk5SeUJYZDVkRUVJWUJRUlczN0FTbUtsNUN3?=
 =?utf-8?B?dDFoaVJTRnFqZHlEMVNJZXdnRzV0b2owSlJnVE9wU1BVT21HSEVFakxMMDJ5?=
 =?utf-8?B?WGV2cWFhTnYxOEhyTGVIN282UEdZT2szaXhJaVNCYUZlQlJ5Sld3VnVnUG1o?=
 =?utf-8?B?VzR6ZTdOOTl1S2ZxY21NaVV4TWZ6bitsZDNndUxRcWk0YS9mM2xBc3oxWWs2?=
 =?utf-8?B?NFRTRGZIWlUyVVZaamNEaEM1cVRjUTRIS3VJcmtCQ3gzSEZFZGdGZHRuN1Y1?=
 =?utf-8?B?ZkNVM1p2QU5OSUl0azhQdG1FNFFTYzJnTExrR0xoUlcyYnRvNlNZejJoL21R?=
 =?utf-8?B?cm5FU0hkV3VVTStTNGRoUjh0c0IvSGtBZlFzMlNaeGF2bHFpTjlsdEwwSzNr?=
 =?utf-8?B?WHNaeC9iVFJFeTA5aHJSUktiMW9hcEx3cDBXS29qK0RocWs1OUkxZ2o5OVdB?=
 =?utf-8?B?OUUwSWRXdHV0clB0UTMxdmRDKzg5UE9STGw1TlF3RmkwalFZODgvMFlreW4w?=
 =?utf-8?B?OU5nSkxKbnZUTzJsaklUR1BmS0xTOEZOV2JVdloxWUh4cTN2SzU0Qmx1MjFh?=
 =?utf-8?B?N25kd2ZyMS9qdE15R3VybCs2WFE3SDA1YzRqTEZzNU9XekdiSTk3NEZYbVZH?=
 =?utf-8?B?TS9INW1hc2FtbDNpTGdsS3U4QjZnRXMvWVBxV2dldEY2RWFCYSttZUVINWtp?=
 =?utf-8?B?aEFDZkxLb3Nkbkd1cDZNbFI5eFg4TjJGWUNwaW5HOEI2eGlCNzZST0J2QmtL?=
 =?utf-8?B?RmlOZE1ONzgwUXZrN3J5VXcvYWIwVS82dnVoUnUyQmhEU21HSVNlejl6TWpL?=
 =?utf-8?B?V05VbVowRzl3cWtPeUU3VzFXZlZxMTFDVys2QldUSmVOUDg4RHFtYk9GazRh?=
 =?utf-8?B?WDFzQ2JXdkM2QURyZVZKdnFNTUtnYU1ibHZjbjFvdXF1M3RrM1dsRzUzVUNK?=
 =?utf-8?B?QUErRVovMFV5Q3BES2dvNWloTXFCbE1rQXFZeXVrTGVra2l0aUwrZTh3cTBE?=
 =?utf-8?B?WUNNQk5PanR6SmZjQlEvOENORmFjZzdpcTZGdW12MUVJdkQ0YzkrZHdqYVMy?=
 =?utf-8?B?ZzFleEtPQVI4N1ZhSG1EUUFBQjVvYzVyZ0VSY294Z1J3WU15TVREV3VyT1RG?=
 =?utf-8?B?aHZyN0NrTXF5cDFtMW5za29Xb05lbjB5dU93Ky9pRjBIRlYzb2wzcGw1bmxB?=
 =?utf-8?B?MXY2cm1vZks3cFF3cHhnZmg0cHo5R1Z6MWg4T2ljbnltQTloSDlQZVpJd1BP?=
 =?utf-8?Q?++Iqse02hUGY3URaVFiAfxPJU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44586438-b587-49c7-eefe-08dcf3534f38
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2024 11:10:32.0295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jT8Ju4GzBLwaNmvgL1HCP2BEQZzvYhzDwEBg1gjZlqCfXV4PskJXBbZIZgImq/mm9XfhXE4NS5xHysAcnUKLiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7137

Hi Yi,


On 10/22/2024 6:21 PM, Yi Liu wrote:
> On 2024/10/21 20:33, Jason Gunthorpe wrote:
>> On Mon, Oct 21, 2024 at 05:35:38PM +0800, Yi Liu wrote:
>>> On 2024/10/18 22:39, Jason Gunthorpe wrote:
>>>> On Thu, Oct 17, 2024 at 10:58:22PM -0700, Yi Liu wrote:
>>>>> The iommu drivers are on the way to drop the remove_dev_pasid op by
>>>>> extending the blocked_domain to support PASID. However, this cannot be
>>>>> done in one shot. So far, the Intel iommu and the ARM SMMUv3 driver have
>>>>> supported it, while the AMD iommu driver has not yet. During this
>>>>> transition, the IOMMU core needs to support both ways to destroy the
>>>>> attachment of device/PASID and domain.
>>>>
>>>> Let's just fix AMD?
>>>
>>> cool.
>>
>> You could probably do better on this and fixup
>> amd_iommu_remove_dev_pasid() to have the right signature directly,
>> like the other drivers did
> 
> It might make sense to move the amd_iommu_remove_dev_pasid() to the
> drivers/iommu/amd/iommu.c and make it to be the blocked_domain_set_dev_pasid().

I wanted to keep all PASID code in pasid.c. I'd say for now lets keep it in
pasid.c only.

> 
> 
> diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
> index b11b014fa82d..55ac1ad10fb3 100644
> --- a/drivers/iommu/amd/amd_iommu.h
> +++ b/drivers/iommu/amd/amd_iommu.h
> @@ -54,8 +54,8 @@ void amd_iommu_domain_free(struct iommu_domain *dom);
>  int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
>                  struct device *dev, ioasid_t pasid,
>                  struct iommu_domain *old);
> -void amd_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
> -                struct iommu_domain *domain);
> +void remove_pdom_dev_pasid(struct protection_domain *pdom,
> +               struct device *dev, ioasid_t pasid);
> 
>  /* SVA/PASID */
>  bool amd_iommu_pasid_supported(void);
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 8364cd6fa47d..f807c4956a75 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2437,6 +2437,30 @@ static int blocked_domain_attach_device(struct
> iommu_domain *domain,
>      return 0;
>  }
> 

May be we should add comment here or at least explain it in patch description.
Otherwise it may create confusion. Something like below


Remove PASID from old domain and device GCR3 table. No need to attach PASID to
blocked domain as clearing PASID from GCR3 table will make sure all DMAs for
that PASID is blocked.





> +static int blocked_domain_set_dev_pasid(struct iommu_domain *domain,
> +                    struct device *dev, ioasid_t pasid,
> +                    struct iommu_domain *old)
> +{
> +    struct protection_domain *pdom = to_pdomain(old);
> +    unsigned long flags;
> +
> +    if (old->type != IOMMU_DOMAIN_SVA)
> +        return -EINVAL;
> +
> +    if (!is_pasid_valid(dev_iommu_priv_get(dev), pasid))
> +        return 0;
> +
> +    pdom = to_pdomain(domain);

This is redundant as you already set pdom to old domain.

> +
> +    spin_lock_irqsave(&pdom->lock, flags);
> +
> +    /* Remove PASID from dev_data_list */
> +    remove_pdom_dev_pasid(pdom, dev, pasid);
> +
> +    spin_unlock_irqrestore(&pdom->lock, flags);
> +    return 0;
> +}
> +
>  static struct iommu_domain blocked_domain = {
>      .type = IOMMU_DOMAIN_BLOCKED,
>      .ops = &(const struct iommu_domain_ops) {
> diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
> index 8c73a30c2800..c43c7286c872 100644
> --- a/drivers/iommu/amd/pasid.c
> +++ b/drivers/iommu/amd/pasid.c
> @@ -39,8 +39,8 @@ static void remove_dev_pasid(struct pdom_dev_data *pdom_dev_data)
>  }
> 
>  /* Clear PASID from device GCR3 table and remove pdom_dev_data from list */
> -static void remove_pdom_dev_pasid(struct protection_domain *pdom,
> -                  struct device *dev, ioasid_t pasid)
> +void remove_pdom_dev_pasid(struct protection_domain *pdom,
> +               struct device *dev, ioasid_t pasid)
>  {
>      struct pdom_dev_data *pdom_dev_data;
>      struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
> @@ -145,25 +145,6 @@ int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
>      return ret;
>  }
> 
> -void amd_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
> -                struct iommu_domain *domain)
> -{
> -    struct protection_domain *sva_pdom;
> -    unsigned long flags;
> -
> -    if (!is_pasid_valid(dev_iommu_priv_get(dev), pasid))
> -        return;
> -
> -    sva_pdom = to_pdomain(domain);
> -
> -    spin_lock_irqsave(&sva_pdom->lock, flags);
> -
> -    /* Remove PASID from dev_data_list */
> -    remove_pdom_dev_pasid(sva_pdom, dev, pasid);
> -
> -    spin_unlock_irqrestore(&sva_pdom->lock, flags);
> -}
> -
>  static void iommu_sva_domain_free(struct iommu_domain *domain)
>  {
>      struct protection_domain *sva_pdom = to_pdomain(domain);
> 
> 

