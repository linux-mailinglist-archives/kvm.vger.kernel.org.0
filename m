Return-Path: <kvm+bounces-28365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 016AB997D89
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7020F1F22C91
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 06:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F3F1A3BAD;
	Thu, 10 Oct 2024 06:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Mwy5iGCa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EC63D6B;
	Thu, 10 Oct 2024 06:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728542696; cv=fail; b=Jcd3BlkHLSCcSm6lrwf7xy5OWFn/sMeweGJSbYPGHNJiVO/S0dCwVNWy/g94NK86bXRxuroPILgS2ZqVreDKVObadR6qf8fs5o84QcsTxC5EELxW4pPYwe5VQS0gE3NBCTwrny3PzIH++YQmZbyrN/UO5OqK2Yha7gVBlzApFyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728542696; c=relaxed/simple;
	bh=lwP9kK2IXiYv2ArS5xDGPr1q4ZDEDv16DGxsEgAOLR4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aA43GAKzx68M8YY7YqpjRHjWdw5VBIU5IL1errCp4SCzlK9ZSclWb6qM0QadXYulVc3G6GUKpJuhgpi54tGsIrEV9gjI9zvFj3RR6REF0e0E57TFU+QfHAD7ZGfAwnHbtpta69hz7YT0vwv3UA7NDAr+JQvPLVDphEOXzHjmWsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Mwy5iGCa; arc=fail smtp.client-ip=40.107.244.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N062fER0Uofm6QbQCDo7EtrJQmiMXLElFjH9uFm6Fq5K8B9YXwo2yvx5/qmTAlO8WtJ8TFNK39KeMp6jmgowWQrxf3C6ic6VwqNoTuwN/LlSa6RigZoxr7BXAjDelu0LpfcDCyxLOzl+yBIuzT685cG9qJOeb4wCx2wuKnHT0sbC37tz8NxsRHHy40ObpJVXnXc8UP0snZsP7rngqgBKMgE/q2T8zeNwb0F0A3VeO87E+2ahnD2zmzHenN+oeLHu7y6w6ccrtXEUUzB421LoOS7K6gWQNH/PBGWXgPVX2nCWZ1Od4PAesALZxEvMe6Kbk/TRLin5H/Int9alYETnzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMlzB1NEVGhXIgQCqD9wHDS9hkx+CI6Gbf4vbtmTLdA=;
 b=e8TgAesRPNyHgMeacqA3MY6dxlohvd9iGXABiqmFMS/PFT2G8j8t2CWwTkKZVh0y7aXoGbd9b9R3ZB0itCuR8WEzQfq8vSiWGd5BhsjlLcxo1scCe2IM/G8+Iso6x8ESEZYp945SpydCr5pRsmiRd7RwnIAyAFrBfoTa6y0BR4Sw4nKZLPhQ9z1SM88WwWxbzga5vRSb42VRXkjQNeq1cI8DCZZwcrT7LsfrHlmhRunFVrqQiHh2egLdzjmPqGC9Zb5OZjTKjtLO0NPWuwvu7ip/XClLEC67Z4nhVx0RXzkMe7bDrtVj1Npi/Nv8i5J17jB+rZypxYksf2UtBfyeXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMlzB1NEVGhXIgQCqD9wHDS9hkx+CI6Gbf4vbtmTLdA=;
 b=Mwy5iGCahgPS0MdxLSqdXgoHeVLeNxwRvnYvWJcNkHOCU+6l9F8TBMjRw84QQ1bAIruENzL0tYPwzfDWytHFezMcLkXRQ6ysgfO+JVdRxPVq2pM11tRu3VyA0FHhXaPgHElJ1ftAPozXRZkk1e3c3y4JdrMzkQXqLoGp/ukSfRs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW3PR12MB4457.namprd12.prod.outlook.com (2603:10b6:303:2e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.27; Thu, 10 Oct 2024 06:44:52 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8026.020; Thu, 10 Oct 2024
 06:44:52 +0000
Message-ID: <cada1d5c-b9ad-fae4-191a-a2e7a1a4ca52@amd.com>
Date: Thu, 10 Oct 2024 12:14:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v12 15/19] tsc: Upgrade TSC clocksource rating
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-16-nikunj@amd.com> <ZwasXk_jZAtO6W1G@google.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ZwasXk_jZAtO6W1G@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0044.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW3PR12MB4457:EE_
X-MS-Office365-Filtering-Correlation-Id: 63b3dded-6b55-4762-710e-08dce8f70b06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anlwKzdXZjZoWUorLzM0RG5Lb0ZOTDZ3SVlsNXgzbDdDM293T2VOVVJQeFhE?=
 =?utf-8?B?N2hxT2NlUWhjeXh2azVkZHFYQ0lyM2kydnhPUWxOWkFJTXNhSEJFTlNxSGl5?=
 =?utf-8?B?dkVwK2pmeFR3RTJFbG1CRXh3dUVpSDBkL3ZqNXpZSFFZSG9yZSt2Qk95aFBk?=
 =?utf-8?B?ZHVKbDdJMWpzYmk1TGVOZU1EMVZ0Y0xrc2ROTXg4VTdhZHNMdkUzWjVVWWhE?=
 =?utf-8?B?QUMrNUdSOTBPOEtyRDlFbGp0bEFEczFCcEVNL0pBR0t4cG1LeWtESkdKUzYv?=
 =?utf-8?B?b2ZDMTZCQXN3NmdXZFRrUmYxV2xwRVF3NVhUKzRaaDNpRlp0Y2lKa3JVUyti?=
 =?utf-8?B?MmlISFlTTWhsTTc2T1pKUVdDQ0d6TE1nMkNnaERuRk5mRzJaVkZoamdpZmFZ?=
 =?utf-8?B?SXM5L3c1L0pvcmlsUzVRSlZxNzdwN1Q5NWxpTURETmRPb2M5WW5vOHczNk5S?=
 =?utf-8?B?QjRQM1cvUHMyZTVhWTdqSTJuZzBISmMvUUNEdWc2SVZIeDlQQmNBa3pGMXlr?=
 =?utf-8?B?ejIyM1JxblJpQVRYRm9mSkdJWWFtYkduY1M5YkJyOVQwRVFFYXIxZFJZSjQ0?=
 =?utf-8?B?QXBjUGxBa0dyZGlEYXNsVUpRSnhhclltTzc2RHFoTXpXaXU3dFZSNVJSd1BK?=
 =?utf-8?B?SUdnZVBySXpBK1dNM2tGYzZhcWV6aW4xR3V1QmJpNENJUjJMTWE0S3BCTjFF?=
 =?utf-8?B?cklIVThsYzV2NUtZQkh2TG53UThEQVdCOVR1MUxod3pjTWc2aWtoMk5OVitB?=
 =?utf-8?B?eCtzdjhTYXNUZVByUmZNWk85N0hZWjlONVRnRGE2RnJDbjBFdDJtb256MXZa?=
 =?utf-8?B?bjZpb3hLSDc3UEpMNmFBalpWMXRSeG5LOWFZZEhJZEUxQWxXNUZhbllrL1N2?=
 =?utf-8?B?YlVGRDB3RmxsWld5SitMNzR6b0RYYlMxeVhucWJydTJoSmVib2o0OXVKRE9T?=
 =?utf-8?B?T21LSFFCbFNZVmQ3OCtvZDZnWWVsRzJGaGd2WGliVy9wNmZwYkdKVWQxV1Bw?=
 =?utf-8?B?eGJxSnJGSHdjdDRMbFV6VjlyY2IrMHFkWHFwOWEycUhWL3psUnI1eWYxZjY3?=
 =?utf-8?B?TjQvNzcyUklOYXE5UjRSMW16b1I1c2VKWG5Oak5ta2Y1TmE2RjZSOHFCK2Fa?=
 =?utf-8?B?MjNhS3AzM1JEWXNhcXJldWhKY09FQWFtWGZmbnQ5UjZ2Nm12dkgydXQwU2FG?=
 =?utf-8?B?YWFmak9zUVlGWTNqWno2UWdiZTBBVjFod0xxeVc1a1dSQXBaSVZFSzA1T2F1?=
 =?utf-8?B?QUc3ZWptK2JWOWYwbHRENy9qNXZXZGk2UW9FTmNkRFdOTHdJNW1aNjRYWFFz?=
 =?utf-8?B?SXpXVjFRR0pjV2t6TmVEdFd5S0wycTI3Y3RtcFVHRjFIdGdqeGRXYWRtdDNS?=
 =?utf-8?B?aTRwMEdpY09ydWhaY1lnUytDYlgxSEFjMFVBT0ZrUFY4OVNZOFlJdGhGby80?=
 =?utf-8?B?WUpMNDlIMFoxeXRVaEkrb0d4SlBUOGVudWxCK3Rja2pEMlZhZldycGFZOWFw?=
 =?utf-8?B?RVBWckNaSWM4emJ4Ump1N2JXMmtMRWNianB5ZjNFVjZJSld6NVNlWDZBbHky?=
 =?utf-8?B?VDcxMHFpNFUxM1hraVNNU1c2RUw1cXBYZWZBUEdBSXc0UkUwWkpGQS8vTklQ?=
 =?utf-8?B?NVN3eEI1SURCeVdxam8rbXcwRFdhSzBGNFFDcWQxbkxRUTQyN2lYc2NRMGQ3?=
 =?utf-8?B?OHBLRlJzTVRLbUJyYWpEQUpUTVJsWkJqeEtrbzZPd0w0SzRUV2pNckpBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzNNdEFSd3hqMmFZc2VXSHRmSlBwTDFWUnEvTW5sOUwxMnN0SER1STlWZmlW?=
 =?utf-8?B?TFJjSUc1ejB1bnk3bEFraFE5emNkcVZQaFFNbkN3VUFiNDJPYmxzaTRXRURG?=
 =?utf-8?B?OElnNG5oOWk1cjFIc0ZjMVk1T2c5ZThDSjdEL2tkdHdIRGNhS0NyYW1iZFVt?=
 =?utf-8?B?cU41TVludXdBRjlqQ1JrTG9ldmx6UDVySEFzSlVQWHQ5SHh2b25odXBLbUtm?=
 =?utf-8?B?Q0JHYU5OT1hMYzloK1Y3a3VRZjk3Y3FTelExUVlOVmc3NzFialRSZjVISEcw?=
 =?utf-8?B?aitEdXBoMWhnVG9wcTUrQUN3RUpycndzSDFhTGc0dFZNQnNuUk8wZXZIblRW?=
 =?utf-8?B?TGhlais1T09pa25UWVNTU0F4RzByeERoVGNDUlZTSkJHTW40UDJWU1pDdk42?=
 =?utf-8?B?MEJveXJrNThSTlZMaGlvRDZhTi9NMjlyNEQ5STZXL1hMcVNHekM5TlNrRFZj?=
 =?utf-8?B?REw2RVkyeDU3VnNpajJYcm9lVzNBandUcjJxdlJ4N0U5R3JZQS94Y0VRNzJM?=
 =?utf-8?B?aGhvZnhGRnpxbnhLUS9adXNLWTRyQ3hsVUJDTFgwbE0rNlR3dU9mdHpndmJw?=
 =?utf-8?B?Q3drVEFnWDNVN25oTytZNUplbVlGY0Rqd1hiR0QrMzkyT2h6NGRtSHpxNFpl?=
 =?utf-8?B?VWpoSE94M0xyWUNRTnViOFYvR0dEZFE2TjdrWlMvQmpyVmlTOXVySlVIdVBu?=
 =?utf-8?B?UDE2Q2dZcnlybjAzZEk5ZXdYUWJKeUJCYTFhZWE4M0ZKa01rbVpJUlBhYVcy?=
 =?utf-8?B?dEsvd01ubEVQdDJreFhRMjZoRzF1dWhoYVRZbUdEeVlCaDIzSDJFQjZQdE8z?=
 =?utf-8?B?WHc1cXAyT2ZZWG90V2pMVEhrMEQzSlBrRHl1V2dkTjhLc0JmZEVCR0ZTWndX?=
 =?utf-8?B?VlFtcXBQbVNhZnIwRGkyWElQTkk4TWh0eG5CNG15WE1UK1V3U21DYjgyR3VI?=
 =?utf-8?B?dmpOcFpEUXA2U0FLVE5idnV5VTFhRDF5aERDR0MySDFSK3RMS05STytFV2xx?=
 =?utf-8?B?WUxneWJKVmlkK2xtSmxIOXBlRWVyNXBhSjYzUWVwWXNCcjNYMktFT0dSRVR4?=
 =?utf-8?B?empWVHhyeC9rKzRobzNqZjQ5U3hZZnJseUlSTHhnQncxeUY5b3pGYWttQ0o5?=
 =?utf-8?B?dEFTWlV5QVhkTUFrSmpEVEJSY0cyZ05XL213OUhRakhYVG4rQlJwMyttZnZM?=
 =?utf-8?B?dkgwdFhhNXZEdktObmlNTDJ4QXNocldSUW9BV1JJRzNldExBckJmbzVycEgw?=
 =?utf-8?B?M0Y1WXIwNFQrc2dIcDFlODBuMFFFUnB0bTZ5cnZya3VwdEtmcWI3eTU3cXk0?=
 =?utf-8?B?MGxnYkQvMTJkWEpXdnRaUytNUy9PcFJYcVlSUUU3M3BzSG95SldRa092ZTN1?=
 =?utf-8?B?K252R2R5S0dMZXJIRTEwdERwSzhNTVJsK2xwRWZ4aWpXTVhJY0p6UitDcGs2?=
 =?utf-8?B?azMyVmRMVm9HY2RaeGpEc1luVFo2V1oxVFgzMEEzY0ZUOEYwSmVEaVdHVnZo?=
 =?utf-8?B?TWhPT3prNU8rMG1ENStOZnF4VzFaQ01RZlJBN3JUWVVCaWV1SFVaOFY2SHBV?=
 =?utf-8?B?OVMyYW9jcEJkWVRpTkhUTXJNR09jcDFFR2hnRUZKejU1eGtHbmFiM3Jtbnd3?=
 =?utf-8?B?a0xqelpoZllRblo0Yi9kVFlxM1dlMEFXT21HMVlINC9PUFg2ZkttcnpDazB1?=
 =?utf-8?B?WlBkc2hFTEYvZlJOdC9vMVNUSUxXcHhTcVIvdU5PbGV4bldMbk5rTzVYMEpF?=
 =?utf-8?B?cVptMWl0RWFHT0s3clJiV2NyODY1Q2lla3Nqai9oZXJYblNTWFF4VGtmNFlS?=
 =?utf-8?B?ODN4aHBXcStRVkVMUHZwV1lsMGdyMXBTS0hocENyNE5ub0s5R1FSY2pqdnZp?=
 =?utf-8?B?TEhsT2pOREV6OWcwa3hKQXZuNkRYUFRiNCtMa2pnNjF3NWNtR3VNdG9NSUNM?=
 =?utf-8?B?RGNEK01meVh3eUlXamVSM0Z1Vm1aaDUvT1lnMHJzWVU0ZUE4L2FwUUtsb0xG?=
 =?utf-8?B?a0R4dWpYUUozSkFsUC81N1c0UlZtUFpTbEhpOVZLbW5XQXI3RC9YSkZQc2wr?=
 =?utf-8?B?emY2ck93Y3pnUTA3SUhqaDRBTFVWSHJzak5BTyt0MzZDWUhPUUlPQ1hIVTVz?=
 =?utf-8?Q?PZQe2V0Ju2Sq8DDNaECbhdOe+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b3dded-6b55-4762-710e-08dce8f70b06
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 06:44:52.2535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5fGRwMtWQJtQM7PUDyu6rF2QbiAmVHIGGitpBzuNbXvi4Z8MxfhZiV2gjs6EIUm7cpAzZiUaDvCrQ+baIKWDHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4457



On 10/9/2024 9:46 PM, Sean Christopherson wrote:
> On Wed, Oct 09, 2024, Nikunj A Dadhania wrote:
>> In virtualized environments running on modern CPUs, the underlying
>> platforms guarantees to have a stable, always running TSC, i.e. that the
>> TSC is a superior timesource as compared to other clock sources (such as
>> kvmclock, HPET, ACPI timer, APIC, etc.).
>>
>> Upgrade the rating of the early and regular clock source to prefer TSC over
>> other clock sources when TSC is invariant, non-stop and stable.
>>
>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/kernel/tsc.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>> index c83f1091bb4f..8150f2104474 100644
>> --- a/arch/x86/kernel/tsc.c
>> +++ b/arch/x86/kernel/tsc.c
>> @@ -1264,6 +1264,21 @@ static void __init check_system_tsc_reliable(void)
>>  		tsc_disable_clocksource_watchdog();
>>  }
>>  
>> +static void __init upgrade_clock_rating(struct clocksource *tsc_early,
>> +					struct clocksource *tsc)
>> +{
>> +	/*
>> +	 * Upgrade the clock rating for TSC early and regular clocksource when
>> +	 * the underlying platform provides non-stop, invaraint and stable TSC.
>> +	 */
>> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
>> +	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
>> +	    !tsc_unstable) {
> 
> Somewhat of a side topic, should KVM (as a hypervisor) be enumerating something
> to guests to inform them that the TSC is reliable, i.e. that X86_FEATURE_TSC_RELIABLE
> can be forced?  

Xen does something similar by advertising TSC related information as part of 
a CPUID leaf (Leaf 4 (0x40000x03))

> Or, should KVM (as the guest) infer X86_FEATURE_TSC_RELIABLE if
> INVARIANT_TSC is advertised by KVM (the hyperivosor)?

I am not sure about this though.
 
> Also, why on earth is 0x8000_0007.EDX manually scattered via x86_power?

Are you referring to CPU capabilty settings in early_init_amd() dependent
on x86_power?

> 
>> +		tsc_early->rating = 499;
>> +		tsc->rating = 500;
>> +	}
>> +}

Regards
Nikunj

