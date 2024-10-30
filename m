Return-Path: <kvm+bounces-30012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D46449B625D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 12:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9296A282D51
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 11:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A1CE1E767D;
	Wed, 30 Oct 2024 11:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IA1X8aUu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3DF1E6338;
	Wed, 30 Oct 2024 11:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730289330; cv=fail; b=K2fUTGDQsKchQJJDOfvSLo0WiKYlCiCjHB5r3MfLnGHzqAxanrVg0UdvaoUZooF/EloIWK6U+fU47uVAIfzm4PLRM6XWZUwi4An2Zh7ESk2HxRb3FJB+/GhyQgN0qST4hqQNm4a5/uvTnWze5iNohkBZbPXVwDOfERw0a/zears=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730289330; c=relaxed/simple;
	bh=x0FbMS0OmVzEydkLOjbV5rM2/FLq2ZDLZJsQ7zr+LN4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ATVARBL8HGuWvOqa8fbyPQ5/Z+zLI3whKDmISArVR9dexzNwcUNXWQ4yNxVNHClAbAy6zIf1cr1tVyQwBp5n/CTTVCk/Ho1lsRfwjPKrkHrqcGQ1uRwhlhtf0DgBwnoc2bQWsGgoxubZWmVnAnz2mFTe4lXS5nXvYrrDkC95JqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IA1X8aUu; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Txw6EL2ePnf4ZV1tsxwMQHAK3kp+afx3GWqh550sKxSlDgZaJaL04mptPZyoU29KDVvwpTQB6p1IviWZEyQjZ5cj0q+uN7AG1jtIDsrtBlbd0ehrpLqTrSIQdlv0R+P3bhk/dpFbLh4vdmms819hQ3dZxUq3D4OMyQfHtytyQ2tN365SdLIUYsKIa34mDKq0Nqbm54b9zj8/nh3a7QuReX+EObleIpmRJaMCHAVTg2uboVBw2NB6u5DM+oV3tKMAUUyL9gDv9ShH6Vau+Mu5dR7VstZgkKT/L3oaQ5LrCD6ir5V5LsFySXotiC+258m5pCCgUgGsJofxJYu3faJ8ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0V2OgtNb9Hu0zgfFh/kmaBeuJdAUucxJx0zOq/TJmw=;
 b=sDuhSjfeuZiWLGuHSyPSy+krdVUh9OQsngoAG/eX0/oEj95Yj4M3pWx7m5OGQ9UY2lo+NbcQdjHUzrLYgGwIEoGhmuAasR69UZoRpgo9kDK4l1KoP2dkBPVAV3BSLC7SJPh5dnSIn39V+DmU0g78IOzWfRxN7Vuux5sEPOjSmhzmmLg53yfCWGj1VKU/z/QG0ErG5R2AiCzOPl5XSP1xPdRxTt369FMu2JOvKLeATcc4dp88GVfTu+8SAgw7qGIsEdquboniSpiYxkEvmm6WPOtu+MrCShfLkCZe7eA5NQUdLW5k6j3fDh5KVlyM/NpeDcPa5AapoojzmU0bDEGtkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0V2OgtNb9Hu0zgfFh/kmaBeuJdAUucxJx0zOq/TJmw=;
 b=IA1X8aUuJUrn/3m1mE/xURfEBC3QgxnZULOzYMT+5yO3u8DNsJIP1KUlfORD5QiS2opNiIfkHl1n0xkm6Yuk5GIY3b4EsMlzaMqcViEAR+2FmAhc3y5JmXjcF+/d5hNRSGiCQK7lp13ysYiqrlg8YuxkV7K8PVLFAAvwM6d+0nw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN0PR12MB5786.namprd12.prod.outlook.com (2603:10b6:208:375::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Wed, 30 Oct
 2024 11:55:22 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 11:55:22 +0000
Message-ID: <16a13edd-0061-019e-f8bf-e816022a40c2@amd.com>
Date: Wed, 30 Oct 2024 17:25:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
To: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241028053431.3439593-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0012.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:23d::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN0PR12MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: 96785cf9-41e7-4e83-e435-08dcf8d9bbb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VW1qYmtFVlphamNDVUkvd1JZK21TVWhQNUM3cThMWVhDRk9HSkxYZE0rY3pZ?=
 =?utf-8?B?cUF4SmhRMjE5QVdHSWkrTkdZaWR1YjNXU1MvZDlPMC9JKzhhSmJ2SkFxM3M5?=
 =?utf-8?B?ZnVQQXhqdUltUTdObC92VkptdUpESHVreDQ0Q21vTk8rZ3ZBMGk0eWNMQU1S?=
 =?utf-8?B?Nit2ZitRcWlGd01LM0tqREVKMWtZenlaV1hoenQrcDF6Q0JIY0hobVppU2o1?=
 =?utf-8?B?ZTl2YnRNbGRYUEdLWFg4N2szV0dLdUxNOUxXamFjQlNFWi8xVEpNQkdQRWo5?=
 =?utf-8?B?WmlLR01Layt5Yk55SldjQTVHUXVHaXF3UlpBUFd6cHZTSldrcmFQT0VDaURJ?=
 =?utf-8?B?c1JjYWFrY0tpTUFTT0ZFQy9CWWVZbGVGY1A0bkQ2dkt1cGx4WExGazZaQlZq?=
 =?utf-8?B?YkpWMTRSNUhYb1pHelVXR2xNL3c0L1NCQmxGSE51cG03RHg1dkhuQjVIUk5V?=
 =?utf-8?B?UndsU3cweXdQeC9MMFdzSlY1ZFhPZ1JCUXphSzFiL082WTVlZTB5bmZkaEF3?=
 =?utf-8?B?Njd0UGJFMmxkUmFySHZha2xkWHBYclcwT0l3N2dFdTNHcUtqMHJmMytjUEF6?=
 =?utf-8?B?d1VXU0hGRDVQcEo5ZCtDeHlYSHg2K0Y0Qk5UQ1FteUFwcjRIWDYzaWRmMHNP?=
 =?utf-8?B?RFA1STRiM3c3YmwvQjN1TGErTGFRSnJacWVNdzhMUEJiY1J4UzlCa0ZBVEZj?=
 =?utf-8?B?bVM2Ynl1SDMwVXQ3cXU0R3NTTlVnWkZ5T3ZZVEVYczhFNVNuek1DOGhHVmFj?=
 =?utf-8?B?dUhUMGNuTmQwZDBEY2Nyd00xYkNWeVdtK0RJcVRxakxGR3YwWUIxc054bDh5?=
 =?utf-8?B?UVQzWVFGMkhMMDY3enV1YnBsaUhnbndIKys1MkxTY3FhakUwTVFvL3l2RE01?=
 =?utf-8?B?WHZLeEpVR0pONkpVVm9wVjNrbkYvZTF5OEt6QVF4MmRWSHZldDJzbGY4Z3NZ?=
 =?utf-8?B?WjVrTkszK2trVTVTODcrZGxiZEFVSTlVWm55Vk4rV29iYWVLaTdkc2c4TUNP?=
 =?utf-8?B?eU1VRVM5Q3BReWpvcDhxcmU2R29wUzNTS2d3VzBvanM1YXpzclQyUUM2SVdU?=
 =?utf-8?B?akpxdlJJVHNGK3lQYklhYTd3V1ZOOVRucFVOck11R3ZNZzlBUzNoZE1vVG9a?=
 =?utf-8?B?Vm0rRGdPTy8vdUdjdDlTSjVoTVVMS2lod0hqYkZKZk5jVEI5Vk1GNk1qNU9Z?=
 =?utf-8?B?WkxmZmZHcWQzS3IzWXZPMVNIRGhxejEzdG80eGVIVjdBYTNGRGhMS2NTVnFn?=
 =?utf-8?B?TUM2MGttTUJNTkJkUEJ4SWM2djQzQjZtQWNDcitWcGE5UWFzRlZiNnFhQnRW?=
 =?utf-8?B?WXZTMHBObldZazdkd1V2UXl3YXJOMlFyN1ZkYzFWcVVnSnB3b1FNT3J0Nk94?=
 =?utf-8?B?NGMydzhhTHh5L0pZVXlNYlJ4MHU1UysxYytaa05kb3p3MWMwYUtqN01ueHhm?=
 =?utf-8?B?V1I0SEI0Z1pSZWhYemNqVlRXTnF2WmtyZVNRMHFpaFQ3NVhmaFhiVUtuZzF2?=
 =?utf-8?B?L09VOTh2bkkzSS9ERDJNMHBXcTJLWkVlMUx5VmVxM2xmbUtzVTMzaTZWYm16?=
 =?utf-8?B?OFdmTXl1Qm9mWW83OTR4dklkbVBVbXhxZno4M2Jka0dPZiswNGFDT082WTdr?=
 =?utf-8?B?OVBkSGo5WXZaaTRiVTViWEpHMUxkdTc0ZjljK0UzaW50UFA0aC9Td29TUy9S?=
 =?utf-8?B?ZFFYSVVtWHZuV3lQL3FwSzhNVG1vTWZuemxkMUcrZXFPUjB4eGJVRVhyZUFa?=
 =?utf-8?Q?Y4NDmYGH8ZKnSrGIf7DoIMGjH3UnUBWu2rRUKJ6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkdkYkcxbVFoaVd3dk0rN09JL0hMdldqQnArUnJRbGIzQytwU0p0a3daNlVm?=
 =?utf-8?B?c00yazlvUjBGZzZ5SFBtOS9tc2tRR2NYWWYzczUzS3N6QitnQUlpcnNYOXB3?=
 =?utf-8?B?QjhWTUdUN3pxZm95T0ZHTVhXT1J1eHY0R2draTE2T3Q0by8vbEdFbE51WDBC?=
 =?utf-8?B?UEsxcGxMK1RJMjRUSEpaQlVpRUN2dGhTd3FMbDcraTY1N3dDRTUxWDhKV2ZT?=
 =?utf-8?B?VXJxOHhRSk1uOFhkaUN5dGFsaVNKdGtPcE94OXUwY0hRTEVpMmlMc3JHdGFZ?=
 =?utf-8?B?YWxodW9mV2ZHNlBNVEhZWTRGUjZJRm1sT3hMU1VuNExoOVZwNWhzTXVPT2x1?=
 =?utf-8?B?bjd0c1d2VEVZKzNWNEZEWGV0bHV4L0UrM01DK0YyL1pKWjVBN1pheUVZclhT?=
 =?utf-8?B?STAxMUpvTHQ4WlF3ZTA5RkdDN05lc05pVUFPeDcreDE3azkyYkQ0a1ZUSWtm?=
 =?utf-8?B?M1RTZ1lsRWpUMlRlR1RZUnNsV0Vhd3JwNDg0SG9FdE93dlNnVEV2VS9zYzcw?=
 =?utf-8?B?QXVOS3B5dFVoWVd3R2p6OXppMGlkQVFjdDZEQi82NHcvMnI4WFcwejBIbGhM?=
 =?utf-8?B?YVpxWVAycnIvdStMNWZWd3lxRHFBQjFyWFpWRlVCOVB3Wk5KNGZFazlqOWw4?=
 =?utf-8?B?bFp1NURyblcyV2VkYUY4QlMvWHdkaEU5azgzUVJoTm5Wc3RmTzZJOHZhMHRr?=
 =?utf-8?B?NVA3VTFKS3p5Q2tvckQvQ1RpK1EvcUZ6d0dtMTR5V09jMm9nZUsvdTlWeHlS?=
 =?utf-8?B?N2NycXVxV3hUNWJCZm5KditCSmJUcm9DZHFYdG1DREV6Z2JGL2ZoV0k0blRw?=
 =?utf-8?B?RDVrRTIvYmZUY1NwWUUwNTFYZFZhTlVDMExsWlU2VnNkVjU1WFJLVTlsQ2Nr?=
 =?utf-8?B?MDRXRW5id1I4OGMwWlN4SGNRR2llS1UreG1nSzdUQ2ZFMjV0YUZQemRJeVVi?=
 =?utf-8?B?dXRjNmhCZm10OWxyZEp4REMvYmtZNUQrdGNseGk3a0F4blNhckV6ZlBhMXAz?=
 =?utf-8?B?VVU2SUVCbkpvcitWTTB6Nkw2N2hWQTNNOEQwaEN2dzY5My95UWpFbXFGMUtC?=
 =?utf-8?B?R3JpTVI0dGZIOUYwN1orbktkOHJUNTlwbUFXQ3NnWHZTT3FJVmJla2w4YjJQ?=
 =?utf-8?B?S0JQellzLzZyODRTUzE0MWxPdlZGa1J5KzNjcTkySnRlK21LOEVSMk80S2c4?=
 =?utf-8?B?SDhMQ1JmaUhKT3RTS3I3VHpFK0F6SmM1VXZRK0dtV2ZxQ1kwbTBFVC9lSjk2?=
 =?utf-8?B?YnQyTW1qQnFnWlR0RHBSWVFaVk55a2tobGc4ZmJuZ3hZYUlTZVBiV2MzVnhl?=
 =?utf-8?B?SVdSQ25ibTJjOGR6cUZvZk5pRHFxNHM3UGp0enJScEx2M1hlam5MU05ZSU1o?=
 =?utf-8?B?cE1xN0xGUVJ0WW9PVVpaUDc0b0ZrVWdJVXloMTZmS29hQWtPVzNSbFErVEJK?=
 =?utf-8?B?U0FHUG1IcWYrL2dMSzZ2cjFMNUY2eUZhVk9IVEUxOVNHVE5IVFo5SW1KNmp0?=
 =?utf-8?B?WVNVMjJnMk5EczdyaTRaNFRpTlpsUE1ZaG1pa202NlJuczc5OWU1RGRSTWZp?=
 =?utf-8?B?eXpyTFlQQmxiaVI0azBxTVAxREMyTmpieW1FVFBvUDh1SG9wdWUxZWliUWN6?=
 =?utf-8?B?cjNTUEFhb2lYZFVSdTN2cmlrcG5ZMzN1blRmOW1BSCt1TllYWEJ4b0NoS1Zm?=
 =?utf-8?B?Qi9GYVNXWk1TMmt4Vzh0ZDdxZ0RqWVVNQUY5QVQ3bXRyeE5jeWNEQmdKVXdK?=
 =?utf-8?B?TmVNdGxnV3VUdzFqWFZoZHdvTWc4VzhENVpXcEE2bG85VEVMVEcrWHd4dTgy?=
 =?utf-8?B?LzQ4bkJtOGFGYzNvbHZKaG9ScS90QmNEV2lCdmFhUFZad3lVSW1VVjREdTNI?=
 =?utf-8?B?eVlhMlI5SUVGdE12aWNWZlZLVEZpZjBVcnlkTXplWXBJR1RFaUxleWZEVXU5?=
 =?utf-8?B?SGdjRlNsbkQ2dE52N0hMd2k0NUgvZGdrZStpdkFBVHlXWnNtUk5CYkpySkt3?=
 =?utf-8?B?c0Y5RysrQXRSYm5LSGF5S04zSEZEUHZFaUE5YSsyeXMyYUJvWkFKVlZyNVZM?=
 =?utf-8?B?QUlTYko2MjJpcm9PVm1TQjNDRjJibnVMVmtkcDZjQ2dIOVNKc2hpcFZhWEdo?=
 =?utf-8?Q?VY7MwjNQ+fJO0SarKRKaeByHr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96785cf9-41e7-4e83-e435-08dcf8d9bbb2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 11:55:22.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YK2J8wJl3imJUM1YoJ9rsGoyH5wpSUgCaOLkBqGbbOL7ncbVBBI7v4G32klHsL90F8bKhMEwJKWUJ6rRWJkpBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5786



On 10/28/2024 11:04 AM, Nikunj A Dadhania wrote:
> @@ -497,6 +516,27 @@ static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc)
>  int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>  			   struct snp_guest_request_ioctl *rio);
>  
> +static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code,
> +				       struct snp_guest_request_ioctl *rio, u8 type,
> +				       void *req_buf, size_t req_sz, void *resp_buf,
> +				       u32 resp_sz)
> +{
> +	struct snp_guest_req req = {
> +		.msg_version	= rio->msg_version,
> +		.msg_type	= type,
> +		.vmpck_id	= mdesc->vmpck_id,
> +		.req_buf	= req_buf,
> +		.req_sz		= req_sz,
> +		.resp_buf	= resp_buf,
> +		.resp_sz	= resp_sz,
> +		.exit_code	= exit_code,
> +	};
> +
> +	return snp_send_guest_request(mdesc, &req, rio);
> +}

I realized that the above is not required anymore. I will remove in my next version.

> @@ -538,6 +578,12 @@ static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
>  static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc) { }
>  static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>  					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
> +static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code,
> +				       struct snp_guest_request_ioctl *rio, u8 type,
> +				       void *req_buf, size_t req_sz, void *resp_buf,
> +				       u32 resp_sz) { return -ENODEV; }
> +

Ditto.

Regards
Nikunj

