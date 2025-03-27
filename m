Return-Path: <kvm+bounces-42113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C57B3A72EA9
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 12:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 229193A61AA
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 11:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430B7210F5B;
	Thu, 27 Mar 2025 11:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s1el3Tvh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C72420FA9C;
	Thu, 27 Mar 2025 11:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743074244; cv=fail; b=G5hbhPM4l35s2MRBu0qD/bTODOcmq+jFnNYQBoE2SJqMmilGI74hDP8W5NIK8algQZJdC+5W9HxaYVcJFFzEcNYjkEOQ5f3WJSeiIpy2sZ4CibPg/zYB0CUPEPDFOdxTJxfxIee7y+WAEt/CCr+b0RxuI9llmVo+ENjy98hl2Cc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743074244; c=relaxed/simple;
	bh=sSbsqIpqIiy89tlaUBtuoSj25oBb9S/hGOwzyFZhsy4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xbhl0iizvyoy3+pkAcRWrbP3mOzGlmySYSsPCKvd1E0x1E5h7zOOzOhca4C/ozZ/VSbxSpTGooOlzJB0nCUu9aSJkfzE/MTKYoL3dtYHLdwgu3nU4zez3A1UUCsqensgZA0vCFCuT5gaDx7uRLCTl+dF76NEqecNjxfVVqTAJiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s1el3Tvh; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nejp69KYLzWhsMZ1X3R0zXsdjG74uGh+AZfrAbTJpxPtnVKbsnbHRh82+swdyMtZI09FYfbEZTjTKqn2kLwc1+G1wuGJt5M4KogSAA4eAlbQJSg1ya8ZA3zQAcHGD7df+rbi6NiXBxrYeovRNfIREJfnsqw3UBxoi25CwIGCtrI3QR8ls6ICve4TSNn61N2bCOCuTImO4RRlswUjSyeFYrA789RuyzH7IMJRbbrwsJZ2d2lnnSq5Tf/rwAc2GMbKXILTAvt9nXjiPOsby2vKa/GRgZFlutUZmV/4pvnhDJPiVGws+qwrBBaw9xDOR8vny7uoTCayhHzrYGK/uRz2ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Woc4SkPgMP4N2Y/r197LA1JJ8uW1yaB+hmsVF5xiS08=;
 b=Z1TLthxYjq5adT/b75zQmI5kruYvCaI4zopbtAN4JjeTQskJA0PninLWS/BEdyLCtfsmpQYWGgRaMhmn3WBF84H385am3mthozgIKk8iIEd8XU/Axs5Gq/Ht7BMPIAv5fM7T7YIbuL1X+cZTyy6DV1bQb6GxErn0G56/N1MtVLD9uZzyJ8FwFozCHL3ZwKhwWY60IUMxt9Kj9ZCUsKMEGQkkOxcGUtFkkoZprLEY5JiTEUwZIilh0Y7z5MKmSUYPjUWa9bixqlvjwdZU93GWd+JjS6TFFyMl+gUcPEng3wmt2K17w8rtxWZq8T0D58lrSiZauFPcKBhSCBGOpzmfGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Woc4SkPgMP4N2Y/r197LA1JJ8uW1yaB+hmsVF5xiS08=;
 b=s1el3TvhYZVuLQSSXTfV8YKUDq6+RTAR16L/pbtyUSrUJoiIRSyL1ckW0oVP6/JQ90x2wtWeg3mrj7a/AsJ8RW/W0gz7V1t6l48/o5d2tenXLt/N16doIIX/UtBD+8QH4e5hi94vgyxS+ov7Mpf1aZs6xSOjUQFPpSRwTNezj3k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SA1PR12MB8598.namprd12.prod.outlook.com (2603:10b6:806:253::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 11:17:19 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Thu, 27 Mar 2025
 11:17:19 +0000
Message-ID: <fb4fb08d-1ea5-4888-8cfa-9e605e6dac34@amd.com>
Date: Thu, 27 Mar 2025 16:47:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 05/17] x86/apic: Add update_vector callback for Secure
 AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-6-Neeraj.Upadhyay@amd.com> <87jz8i31dv.ffs@tglx>
 <ecc20053-42ae-43ba-b1b3-748abe9d5b3b@amd.com>
 <e86f71ec-94f7-46be-87fe-79ca26fa91d7@amd.com> <871puizs2p.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <871puizs2p.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::9) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SA1PR12MB8598:EE_
X-MS-Office365-Filtering-Correlation-Id: b16e5b6a-8553-4c60-9e9a-08dd6d20f02d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHJOZnJvY1FReGhyTTBPZEhTWHd0WlZtUHZUSlBKR2p6dENnWlM4Q0JxMEkx?=
 =?utf-8?B?OERmODE5ZkRwQ1F6UjBJYm5uVDJXVXdYTjhGNExIRUJsYzR6VlFBaDg2YUxy?=
 =?utf-8?B?b3BTUThTWTlHdUV4aklob2NVUzhQQkZhUFhQU240SGVFNUhPbWtuaTJqa0FM?=
 =?utf-8?B?eEJZcWxZL3gvMkVXck5XMXkyNUcxWVBEWm15bGdGbFQvZlB6NXlkS0ZHUTEw?=
 =?utf-8?B?ejJBbWVhK2ZHZzk5UWJHaFZzYjR1OXhyRTZpVDRxbGJ3UlZkNFRsc1QvbzlC?=
 =?utf-8?B?RFZZRHk1aU85S3gwSVZYd09ReThuNlA3azhwbDE4dVduWUZXQ0xFTzRaa1Rl?=
 =?utf-8?B?cFdldGMvZUlscGZCUWlOQWJkWnoxWkduLzNKWG9MS214WC9JK0pRNVZBaUZl?=
 =?utf-8?B?VW5ZelJSVFVXSFVVZ0dJRWtaNHpXRGpOc0JiUFBxaVJCblhpS21ibDdnaVQ1?=
 =?utf-8?B?V1RKaFJDT25QV042eUlpd0tZSFRoVHRZWElSaE9rVkRnQm5SOTlxSENLNjRy?=
 =?utf-8?B?SEJjSnhWN3hlRGkxL1VFa1JyQWc1VUs2VlA3dUk2STFTbWgrNG9WSDBpWnhK?=
 =?utf-8?B?R0g1d2ZLUTlPRHpzRys4QWxSd0RJRDkrRjY5dkp4OXg2V2l1ZFBBWHRBWjRk?=
 =?utf-8?B?MEtuVWNkRmVPUTRqVVhNK1hFam4ySHRjMzFqbkU2VktkZGxUeWJjeVF6N0Q5?=
 =?utf-8?B?MUdyb3BMRUdpNURQYWhsWnFhN0hRQ1ZDZ0NQRi93MVM4OExCakVrUml1OHVE?=
 =?utf-8?B?UmNoSFBIZkczbmh3cEhoNmh5YXVWMTNzb2h0WERZdXJnRDRxc0RDZlY4QkxF?=
 =?utf-8?B?VXg0dmowVERTWFdlQWRPa0J2TWh5d2VwbXdvdURod0E0NUp3VDJlSVJxV1du?=
 =?utf-8?B?YUhyMlptekZLNnVpQ2JDZk5Xd2Qxd1I2OXRIc2RNWE1nUHFhL296RUZqSUJQ?=
 =?utf-8?B?UUp0M3BQc1NuM29EWFliMTVVbk9sOGg1MUxxS2ZmQkhYZVF1anRJRVlnYVVO?=
 =?utf-8?B?MkRwZ3dMRW44S0liQVNjZjNzWWhLR0Y2NzQ5UTZPanhrZ0lTVDh2dHNXamV6?=
 =?utf-8?B?b3cxNHZDdE8vTEdvaVN4NlREUVNCYmREVTZHZjd6ZmEzNVpMNFJTZ3l5bE8z?=
 =?utf-8?B?UWtjMVlTaEllNS8vRW12K1QyMzV6ZGxHSUVNNTNEZEFidEd1QU41LzR4bGk4?=
 =?utf-8?B?UEpmakFEWWdYd3BhZmpNRENpbWo4QXR2N1dpcnJMMGF5Rm96RE5UUUpNNDhZ?=
 =?utf-8?B?dlRDVnRxMUljdXU1MUZrZ0dMVlVqbGRKRW1DYm5TRFNHT0I4NldKdTRlWXJm?=
 =?utf-8?B?TFU4YnJSUlhaQnI4R3o0YzZUN1EwUmd1SU9jMVRtVlB2ejBDRnZxbmJPZ002?=
 =?utf-8?B?Y1huZVBOYzJqSnN6NXhldjZ4Sld4VVdRODQvRHhhOE1pT1dQd0hOR3llbVpI?=
 =?utf-8?B?K0owRGplaXZyWkt5MHI0Ukh6bmNSRnhmcUk1OE5abGlTaTdHRThObTFsdUFG?=
 =?utf-8?B?Z1FObGtXSDFSMnk4bjN1RlZKRmNpWDZJdUsweDFBNnZYbm9ieWE4SkljdXlZ?=
 =?utf-8?B?eXVrd25tajhpZThmVXNRSGVYbkJ2QzA2dUF0YTRFOXhzalQ0WUpqSDFRMGM1?=
 =?utf-8?B?SElkcVVMZjFtczhOWlJ4djVBOEJXMC9mSGU2anNOTmNOcVVzS2d0NVRrZkxl?=
 =?utf-8?B?MWZxV3dIM0VUL3RmL001MTZ1bk9PVFVNc0F3c1l3VGRSd0xObjN1RVhHQVZw?=
 =?utf-8?B?N3pBMWhJMTA5MzdsV2dJcTJxcTFsbXFJSFpZbzE5VGFUMlNCMmJqc3ZlcUdj?=
 =?utf-8?B?QW9wclh4UDk4Sm1kQUFnNDRwWjRGNExQZEpDZ1FHR0RxRjI0bEhidWFQaFlX?=
 =?utf-8?B?clkyU21MNXJ5K09rUHU2V2JBSmFNSDhoYXAxODdBUjlhR05UeDM1dHBCb0d6?=
 =?utf-8?Q?YqyWHQXjIOU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWo3VzNLQXQ2YXMzNjR3U1Z4dTBsbHczSXRoYUVDY0c4aE9hZDVFdytnWVI3?=
 =?utf-8?B?RlhwaEVpQVFCY1ZsYXdlV3N6RDNBWTJRRkRwZzQzU1VYMzZtVG44QW83WkJO?=
 =?utf-8?B?M1EwRDJSSzFnMGM5TnBVSU02MzZwVUZsQkVuVFpaZnlvTUxKaTArakZsZzQ3?=
 =?utf-8?B?OXNxY0MrM3dWcmM4dnIxd2I4RGhyYWlOaDhoNFZBNDdIQTZmc0xUdWdMQjkz?=
 =?utf-8?B?ZFBIaVZYQVdRQVcvaVk0MnpUaitneGpxR1dDNCt1TUFxcFY3cHlrNXRGUVRt?=
 =?utf-8?B?SmNlTFhYcmR3Z25LWjREUUJEb0NhalJOTnJsM2VJdmZHUVJra1l0YVNFZUFG?=
 =?utf-8?B?WDVkb0xtcEhhcTdIcEVqRWNWLzZMVVRUS0tKTmxIMkduSFkrTCtRdmpnZWZp?=
 =?utf-8?B?OHAyOFp6SjB6bjhiaEp1RXBrbkdKY0cxanB5R3lGTi9mc21xUHczeEdubVBn?=
 =?utf-8?B?MkhxSWdRdU5qTWwzNFVqbnZGeDNqNVJUZ3VBclhHQVlvTUlnYVNqSWdLcXJp?=
 =?utf-8?B?M1RxUnUreEdoVGhnZ1U5RzBQZ21MT29lTzh5bXk5clBWY1NuaWpyTUZOYmVM?=
 =?utf-8?B?UTI2SWhxVkd0elBCTVdpWHRRUGhYTHg4RWo3eTgvV21mTnM4NWFxNmsrV2hD?=
 =?utf-8?B?cXVUYkVrdjBRV245ZjE1VnZVWXBpblcxRExDM0U2L0xaS0kwTmhCRFRoYWt4?=
 =?utf-8?B?WkR1QUwvMDB3K3dNWHR5MEExMHJzTndGbjNsdzAySXZnK3FzUm9mOTFIMEln?=
 =?utf-8?B?SjRoOVVDYVN5SGVZZm05MitEemlOalR0YmFVejgzOThKVkdydndpYXc4djBB?=
 =?utf-8?B?UDlVOGpjVVlWZ0t0MC9UVFpSc0VMVlRCdXNyWCtlN2FWRkxWQXpySDRwcC9z?=
 =?utf-8?B?WVVrYXJWZTFNV1ozWEtRdlhndFBaTnBTNzVpZWY3T3l4K09BYk5idTBWbXNt?=
 =?utf-8?B?Tk9JVjFIaUMxVXNlaTBCOU5ESktGMy9uNVlJQlcvY3M3NjRCUFpSeGpUSUJm?=
 =?utf-8?B?bm5ua3ZNWkxiQXJEdGZBUlY4NlJoK2RjTDdXd1hTWkxJcTZLYWV5SGkxMHZt?=
 =?utf-8?B?T0c4aitDR1hpMVBJUDh6dTBhK1VicVRJL1ZhTXlyQi9CTUdNS2YrSC94dDNB?=
 =?utf-8?B?bDc0T3d0TVduZW5RQytHSk11UlZUUGNNcFlQdHZkRGJHcDRaQWNYRlUrWmJT?=
 =?utf-8?B?dG9ncjh6WkxHOHgxdVFqQXM1amdSN2dDU05sVDJ4Q0V6b2pYMm1BdkFlNFFM?=
 =?utf-8?B?M2MvNXA0VTVOeFVGU3lSNGdhVnd0ZjN5ZzFVQm8xZUxRRTRCVWY2dmN5b1oy?=
 =?utf-8?B?L0R6Q3NOZmI3R1pjdVVZVjdOTHZFb0tIaHdLSE90S25SRE9iS21PazAvdmpD?=
 =?utf-8?B?K21OanZpNFJZRlMyUVgydlBZcFhXaS9EZDJkVG03VFlqMUpNbmMrdTFnSFlx?=
 =?utf-8?B?R1VqdXVBTklubkxvc2NoOW9qOVZWaUUrdWw0aCtxU29FN2h2YURNTk1vNHor?=
 =?utf-8?B?RG1TTm9PSnhjb0xwS05YN3Q2K1dPQmhkU012Q3VYcVcvYTdrdGVEVGErSEx5?=
 =?utf-8?B?enBMMVVMblZYNWtJR2pQNVExQzZMMk1wMHhDMXV3UkxPV1piQk9jMnNOQlc5?=
 =?utf-8?B?aVpuZFlXVmJJNDFXUmE4MzMyTDI0RmxpcWtwMWJyUkMzdWxueXJwa0NmSE1K?=
 =?utf-8?B?cW1ZbCtUUXBQbHVkcG03WGR1cFBvUG1qQkhCZW9aZk5sWWdvWVp3WjNTYzZH?=
 =?utf-8?B?WHdGZjNFYXExdlBwZU9pNHZLK2xZU3drcTQ1Tk81bWwrVGhTQ3BRUXdJRU9Y?=
 =?utf-8?B?bGJmR3lMQTcxcGQ1SWlabGJuMmdyVTRYZXlJbFp4YXRZOWoyeWI0RWJmTmZX?=
 =?utf-8?B?eFkwT3NEWjY0OGFXSCtvVFluWk5oZkJrS3liOHphSVFwWkVZVlBHb1ovSG5i?=
 =?utf-8?B?UG9KbGl3YmlYazg2aUExVTVUTWdRRXF0aFh0UXpyY2NNVzVKcGpkazQrRTZ2?=
 =?utf-8?B?cnR2Z2lWdWNQQ2hVZXR3ZlNkQm84Q2ptemhVcEJpRXVyajVRODFpOWFYcjdp?=
 =?utf-8?B?anlXOEg5dVBtQmJ2TklWMTNRaGJDUytOWWNFQ0VLYVNscWx4Rzh1MlRWcDFs?=
 =?utf-8?Q?u2S7b2/+WmyKs0xwoY+ejy0IO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b16e5b6a-8553-4c60-9e9a-08dd6d20f02d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 11:17:19.6329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PZjdhM53Mx+5sD3Jxe5FXD5SK5Nqo8q6szpXxHEcc2s7dQuryaRptYlnrexy3bICNZtOd3BDdbpmt585t+ngZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8598



On 3/27/2025 3:57 PM, Thomas Gleixner wrote:
> On Tue, Mar 25 2025 at 17:40, Neeraj Upadhyay wrote:
>> On 3/21/2025 9:05 PM, Neeraj Upadhyay wrote:
>> diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
>> index 736f62812f5c..fef6faffeed1 100644
>> --- a/arch/x86/kernel/apic/vector.c
>> +++ b/arch/x86/kernel/apic/vector.c
>> @@ -139,6 +139,46 @@ static void apic_update_irq_cfg(struct irq_data *irqd, unsigned int vector,
>>                             apicd->hw_irq_cfg.dest_apicid);
>>  }
>>
>> +static inline void apic_drv_update_vector(unsigned int cpu, unsigned int vector, bool set)
>> +{
>> +       if (apic->update_vector)
>> +               apic->update_vector(cpu, vector, set);
>> +}
>> +
>> +static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
>> +{
>> +       int vector;
>> +
>> +       vector = irq_matrix_alloc(vector_matrix, dest, resvd, cpu);
>> +
>> +       if (vector < 0)
>> +               return vector;
>> +
>> +       apic_drv_update_vector(*cpu, vector, true);
>> +
>> +       return vector;
>> +}
> 
> static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
> {
> 	int vector = irq_matrix_alloc(vector_matrix, dest, resvd, cpu);
> 
> 	if (vector > 0)
> 		apic_drv_update_vector(*cpu, vector, true);
>         return vector;
> }
> 
> Perhaps?
> 

Sounds good.

>> After checking more on this, set_bit(vector, ) cannot be used directly  here, as
>> 32-bit registers are not consecutive. Each register is aligned at 16 byte
>> boundary.
> 
> Fair enough.
> 
>> So, I changed it to below:
>>
>> --- a/arch/x86/kernel/apic/x2apic_savic.c
>> +++ b/arch/x86/kernel/apic/x2apic_savic.c
>> @@ -19,6 +19,26 @@
>>
>>  /* APIC_EILVTn(3) is the last defined APIC register. */
>>  #define NR_APIC_REGS   (APIC_EILVTn(4) >> 2)
>> +/*
>> + * APIC registers such as APIC_IRR, APIC_ISR, ... are mapped as
>> + * 32-bit registers and are aligned at 16-byte boundary. For
>> + * example, APIC_IRR registers mapping looks like below:
>> + *
>> + * #Offset    #bits         Description
>> + *  0x200      31:0         vectors 0-31
>> + *  0x210      31:0         vectors 32-63
>> + *  ...
>> + *  0x270      31:0         vectors 224-255
>> + *
>> + * VEC_BIT_POS gives the bit position of a vector in the APIC
>> + * reg containing its state.
>> + */
>> +#define VEC_BIT_POS(v) ((v) & (32 - 1))
>> +/*
>> + * VEC_REG_OFF gives the relative (from the start offset of that APIC
>> + * register) offset of the APIC register containing state for a vector.
>> + */
>> +#define VEC_REG_OFF(v) (((v) >> 5) << 4)
>>
>>  struct apic_page {
>>         union {
>> @@ -185,6 +205,35 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
>>         __send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
>>  }
>>
>> +static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
>> +{
>> +       struct apic_page *ap = per_cpu_ptr(apic_backing_page, cpu);
>> +       unsigned long *sirr;
>> +       int vec_bit;
>> +       int reg_off;
>> +
>> +       /*
>> +        * ALLOWED_IRR registers are mapped in the apic_page at below byte
>> +        * offsets. Each register is a 32-bit register aligned at 16-byte
>> +        * boundary.
>> +        *
>> +        * #Offset                    #bits     Description
>> +        * SAVIC_ALLOWED_IRR_OFFSET   31:0      Guest allowed vectors 0-31
>> +        * "" + 0x10                  31:0      Guest allowed vectors 32-63
>> +        * ...
>> +        * "" + 0x70                  31:0      Guest allowed vectors 224-255
>> +        *
>> +        */
>> +       reg_off = SAVIC_ALLOWED_IRR_OFFSET + VEC_REG_OFF(vector);
>> +       sirr = (unsigned long *) &ap->regs[reg_off >> 2];
>> +       vec_bit = VEC_BIT_POS(vector);
>> +
>> +       if (set)
>> +               set_bit(vec_bit, sirr);
>> +       else
>> +               clear_bit(vec_bit, sirr);
>> +}
> 
> If you need 20 lines of horrific comments to explain incomprehensible
> macros and code, then something is fundamentally wrong. Then you want to
> sit back and think about whether this can't be expressed in simple and
> obvious ways. Let's look at the math.
> 

Hmm, indeed. I will keep this in mind, thanks!

> The relevant registers are starting at regs[SAVIC_ALLOWED_IRR]. Due to
> the 16-byte alignment the vector number obviously cannot be used for
> linear bitmap addressing.
> 
> But the resulting bit number can be trivially calculated with:
> 
>    bit = vector + 32 * (vector / 32);
> 

Somehow, this math is not working for me. I will think more on how this
works. From what I understand, bit number is:

bit = vector % 32 +  (vector / 32) * 16 * 8

So, for example, vector number 32, bit number need to be 128.
With you formula, it comes as 64.




- Neeraj

> which can be converted to:
> 
>    bit = vector + (vector & ~0x1f);
> 
> That conversion should be done by any reasonable compiler.
> 
> Ergo the whole thing can be condensed to:
> 
> static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
> {
> 	struct apic_page *ap = per_cpu_ptr(apic_backing_page, cpu);
> 	unsigned long *sirr = (unsigned long *) &ap->regs[SAVIC_ALLOWED_IRR];
> 
>         /*
>          * The registers are 32-bit wide and 16-byte aligned.
>          * Compensate for the resulting bit number spacing.
>          */
>         unsigned int bit = vector + 32 * (vector / 32);
> 
> 	if (set)
> 		set_bit(vec_bit, sirr);
> 	else
> 		clear_bit(vec_bit, sirr);
> }
> 
> Two comment lines plus one line of trivial math makes this
> comprehensible and obvious. No?
> 
> If you need that adjustment for other places as well, then you can
> provide a trivial and documented inline function for it.
> 
> Thanks,
> 
>         tglx


