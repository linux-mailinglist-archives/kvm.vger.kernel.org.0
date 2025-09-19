Return-Path: <kvm+bounces-58186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00485B8B1CF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC2D5611FC
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271B031771B;
	Fri, 19 Sep 2025 19:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zXq8WKrW"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011027.outbound.protection.outlook.com [40.107.208.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B6A2BEC27;
	Fri, 19 Sep 2025 19:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758311405; cv=fail; b=LIIwoLnhC3JhG/G91yKntSgWiKJ3DWhD21tkLB3NBASZjcBzn+Xq67/ZLqUkcVb9mMz0+7bt+fo/2GYrG3r7HuArk+kp63Aiv0gWe80NSKTV1g3AoZ7nK1FPNVbX4Eo8dwstQsU7c6j7nLWsQv5HrygxuKAooC792U4XWWZOjcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758311405; c=relaxed/simple;
	bh=1yveXRQJLVw5tLdo1bSfVd+nVkdX9mm6kERAXLGDvqM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g1Qi58fMDiJUru4eQb9voDMrmixJ0St02p3HK30KTglQZZO144ziA8lNJqxrPp0kBi8aPNRYxSRImJRho2z2Sxm3CdsUVWIYiX9ICiSKtE0S7vUxZzE5QsNJHpmQpNU8xOurgk5tnN5yNLI3OFgA+5xaF0q46IHw+ayGyVTGsUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zXq8WKrW; arc=fail smtp.client-ip=40.107.208.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/wCSVPM1Ab3OUkYxn5vZP5LCU7B7iGyUZ+iPEidlUcIE93CccilQBO6B2NhpzmEq8DK9q+/JsZfaKahaF4DGXhVtTOMHzYG54xzuOCFsmwrxRIm5CybBtpOKIkFMywtPN/r+qqwHyWNNcFdQiWPi8BD3ePDFYLj+e4x502iDSkyHAuP7IeL7rsubJfv9LRQ6cjPtrCs2gOhYT1k8Nffhdw3pel3ub/Upax4kw7bY3gNNr+aL0e7jotZjKRR6gTzF/e9hjXr363gQ19ybmz11RgwAgg2ObXZSgtgPRdbSG2Y9JQjwfptXbxJpj/b8QeJJuY6Otp2+j1TQ5ugy+BLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmYZQtOxIvWUpO1a576Yd6fXtdcz27CqWeC1zjJESvU=;
 b=A2iE2tXEUrf/BpnHWUkpLCw0PKwiWq+iaVKP7TO3V/K0fEIbfLdQQIhdpz26dmrN/8yZPY1VsycNqsRVc2jldeqeBrMyiSm4IEbmSTm1ov8W+Ng7m8cm9g6m/nppg5VWQX0FSVj/ALSnpZ6/4bG23PmSZyRAc5s8gwB0/4l2ZN+ruQjOGlCcqtUnm+dsNmZMs/cjZYjpmIBL+zdqfXjoY9DRFd5OXE6WH1y17sGk/8PXmM43STrulBTsg2xAuE7nVPFrqZNuR+/FlY57Ngqc2pDkWYHNZx+A1ZJPrLOUvJqbKXbFcs2Pa6a82CpGBOUKDEkLpRuV11ywewvMk8Fcig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmYZQtOxIvWUpO1a576Yd6fXtdcz27CqWeC1zjJESvU=;
 b=zXq8WKrW5TkOgeryyksps4IsgNVxFU6DlUO1zP7KllEiAJuzJpZA1dW9Uh5fCFLn0hkzeeJ79fwcHwfajcAIHd86EXzPMWaS1XvIFfukpgkkxoXNAH1fltjhNuW1o3zxKZ8UUux31zGELlOtZTP5Uta8/WnFFtm1my16eNPumEQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by LV3PR12MB9185.namprd12.prod.outlook.com
 (2603:10b6:408:199::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 19:49:58 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 19:49:58 +0000
Message-ID: <876f1d86-d83a-4e13-ab82-b61b50d6a3b7@amd.com>
Date: Fri, 19 Sep 2025 14:49:52 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/10] fs/resctrl: Modify rdt_parse_data to pass mode
 and CLOSID
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 pmladek@suse.com, pawan.kumar.gupta@linux.intel.com, rostedt@goodmis.org,
 kees@kernel.org, arnd@arndb.de, fvdl@google.com, seanjc@google.com,
 thomas.lendacky@amd.com, manali.shukla@amd.com, perry.yuan@amd.com,
 sohil.mehta@intel.com, xin@zytor.com, peterz@infradead.org,
 mario.limonciello@amd.com, gautham.shenoy@amd.com, nikunj@amd.com,
 dapeng1.mi@linux.intel.com, ak@linux.intel.com, chang.seok.bae@intel.com,
 ebiggers@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <cover.1756851697.git.babu.moger@amd.com>
 <9200fb7d50964548ef6321214af9967975cd9321.1756851697.git.babu.moger@amd.com>
 <298f769b-b893-4ed8-90b1-d9d9dce25037@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <298f769b-b893-4ed8-90b1-d9d9dce25037@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:805:66::34) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|LV3PR12MB9185:EE_
X-MS-Office365-Filtering-Correlation-Id: 03cfe5cd-bd51-4c40-4aee-08ddf7b5b6bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V04yVDZnQUJJVTZTTWwxYytRejc2YWt3R1BtRDduVnRFV2ovVi9tNkxGdkVL?=
 =?utf-8?B?T0xVLzAwN3RuazRLVHVRNDNOSElKMkFuSytWeVovSE5TZGhLSys5QzBsaUhh?=
 =?utf-8?B?c0phb2xYVVJNMTNhLzhWQUY0aVF3dVNkR011cnFYQWdJK2xXbjl4SmJWdDJz?=
 =?utf-8?B?Mkc4eFQwQjNzNlhxWkdSeEhwVTRlVUQwd0loemE4WUFMSk9kTlNrTTZUVGll?=
 =?utf-8?B?VkNqQjNtd1ZRcGx6bHJRVmI1c2lWdUVSblJBNDkxVVg3cUs4SGJ1bmRKdUty?=
 =?utf-8?B?N1BxWHlHWDIrSG9RcW95TTNTOGxZcGRTcVN0Rkp6TEhQUDFIWjdNK0ZKajhr?=
 =?utf-8?B?S1gyWjlZcGxrNmxBOG9weTBremFpbk5HdzEybzVtR1VQcDJ6NjR2Q3dSMVAw?=
 =?utf-8?B?WWFtQlpveVVCVHRlNVNQQUo2cnlFMEt0dmtiNnlEM0hjWk4yWStDYWtqYm5H?=
 =?utf-8?B?c2djVE1aZEZmT3hpNGMybG9OdGI4Q1FZdWUwZzhadDE2a3BLKzdWcHpKZXo0?=
 =?utf-8?B?RVkzdWpuRkVHMDUyV05KTnJYcUFvaERhTktRSkNZYWFnbnNvOUNheW9JVnRQ?=
 =?utf-8?B?QlUrWUxFcEs5NFFOcEFocitkR1BhSjBZbENjeEpra2twUCtPd0pxS0x5c0pm?=
 =?utf-8?B?d1ZCbHhxTGtZTnppWFhodVROcVZieGpDRkpJeG10Wm9kL1N3c1BxUXpOTjFo?=
 =?utf-8?B?RnVrSkZ5VU1jQXJEK09aMlpERk1lMjBRcnprbitzUlMwY3VXL1YvcWpoRWFz?=
 =?utf-8?B?ZksydERMWVY0RDEra1IwZkF4OGo2UCtJN3o0aTlzMHpOSnhvWWl5QXAybmJy?=
 =?utf-8?B?dis2SXo1UGc0cEJ5b0svTFdFNlhIM2tweG1HOWNsc3NBdmpGT25rMStJRmZ0?=
 =?utf-8?B?TTNaVXhqaVF5QzFWTHJCZ05JSWNOSG8vMFBkem5XS0l0UzdjNjdqeW1GYnZC?=
 =?utf-8?B?V3RwV0I5aXYwR3NUQjc4N3JpWUhBY1Y5TkhSYkpQYUNzVENMQXVDOUMxcHVh?=
 =?utf-8?B?ZDNFYzBDUmIyZERUVERsa2xBcUNGMjdNMytrV04wOFA0MFJyMUVEb3plYWUw?=
 =?utf-8?B?N3dGZFZwUUs1dVRCTGhZYkZTVHFKKzdrVERrb0NBNlcrL2NMODl2b2NhR2ll?=
 =?utf-8?B?UEgrQzNyd2hpYnpvTWUvT1NHSk1Cb2lrS0NNUXM0aUt1NFdiYTllSGhTaVpG?=
 =?utf-8?B?bXFxUm1iQTg4YTBsellwc3g5K3Z5dmJCTElMSHcwUktkbjBtVUk0Y2FVcnBj?=
 =?utf-8?B?eFdSam5CODRra2YwTzJOZWp6SFh5ZUlYenlxTjJ4eU5YY29MWEJMekVCWWtq?=
 =?utf-8?B?RDlheTNQUHhNbmxaK0syRnoyQnJWdkEvRE8wenBaMDJER0dkVjRtczV2eUZG?=
 =?utf-8?B?Zmo0azZydG0yaStUa1NMUStGcEh4VzZOU2xnTUFVWXRTdHBMdzZZQjEvWUlm?=
 =?utf-8?B?clhvMVNGK1dXMm5ZeVB0RWVWaDQ2N1FQSDNySk8zQ3VFeVI5TzJoV1JOYjZx?=
 =?utf-8?B?dlB0dVZMcGhRSHI3RlJpMlluNXJZM053VDNTQ2xHcitwWkZocVdkR1BRTVRH?=
 =?utf-8?B?OFdNTEpBdmpOdjFjd2lWelJXLzdQc3ovakwrdzZjTlFRaW9qZGlmNXdiR2ZF?=
 =?utf-8?B?dmZ3OGZoWS9xemcwZG1CckhoS0t1YkszRDhHWmdsU3ROYTBlcjJSZnNhRi80?=
 =?utf-8?B?Nm5weWtEWE5pVFFaSGxUMHdweDJZbWZOK3g0dzlTR1dLWDNqay8rWTF0MGg3?=
 =?utf-8?B?alJqQzdYREhhOGlFZTZISkRlK3duSnlFdG4vTXZ3cHY1R0p5WTZuUVBnVjRD?=
 =?utf-8?B?ZXhGMzVqNStOZGdYQ3hjUlhHclRtMDdYUHhxUzkvbEJsVXNUR3RnVGl4UWUx?=
 =?utf-8?B?NTZTenBKQ0lxU2NlNElsMzR6TUMrNjNZY0pZcjUvTWg1bGFhVU9FejVDUUJT?=
 =?utf-8?B?RWNKajBNdkhMc0ZpQ0toWXRjTS9XTUo3amVvWDZaRjAxNHc5RTAyT3JpZWtt?=
 =?utf-8?B?ZnFCKytoSW9RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1BoM1loaWtOK0t4R04wSTFRcm94c1c4UkVaczB4NFRaeWFiSlc5LzEwSHB5?=
 =?utf-8?B?SnVMaEZrY2VMenZSd1Q2K2N3T0doRmhldjd4c0xQMGh2Z3BnWHhKSHRmVCtR?=
 =?utf-8?B?OW5mTTNiKytMU2hnTHAxbWZvd3FRalZsZEVkZ2d6OUN5ZmM1RitVOUFLVEFR?=
 =?utf-8?B?WXNjcXBxaUVDM0pPVDZqWUM5U0ZLLzRqUFdMdFRiMEdXbXp3VkRNUjVtcGRp?=
 =?utf-8?B?TmtJTU5BSWZUYSthMmd2bi9ZRW1lVlJ6aEdZeUVhdzVEdVNrQklNZ0d1UXVj?=
 =?utf-8?B?Y3RlV1FFODlrOWdZMnBGRWUxcnhUZWRrY201WHBvT2lCVk1zRVFvR0hQVTBr?=
 =?utf-8?B?ZGdaQmVidFp4dFZSbnZMMjZCakVYZXRzRS9HRVdLR251ZHFmb3d3M3pJZmdj?=
 =?utf-8?B?RkYzUWNmdUY3ck9pODdCY1krWEwvZmR4VkxGWWVra3lKbWtwbnhMd2p4a1BG?=
 =?utf-8?B?em1DaVRUQjJuWm8xOWY5d0hmb2k3ZkhmK1Jkd0hxdHV4a28yUmhxblpUcnlP?=
 =?utf-8?B?QXg5cGFRSUlCdklsdkdHUGxjY1ppMUlKNlhJQ3prcXlNUGdnZ3BJc2swVHox?=
 =?utf-8?B?SjBOdnRTYXVtcGlhclY4dVpIQVNrWlJVWHVxY1hzMVA2TkEvY0ZTTUN0UDM4?=
 =?utf-8?B?WFdORzZrNUlKUWduUHRNZkpXSVMyS0NSTjRNNkFFOWwraTd3UkwxMlIrZ0hL?=
 =?utf-8?B?Rm5LSWh3VDdnMm84L2xZWTkvK1l5N3BnK0RYc2ZlbzhNZm9uZTVtWHNEMitF?=
 =?utf-8?B?bStxaGo0Q0FRM2E5VUFsYzdzY0tENkVYSU5hSDh6YnJUWVFYTTBpdHNMRGk1?=
 =?utf-8?B?TTJ3RE1NRVJvK1g3T3NBbDJ5M1BncDRrMGRSQ3Vucy9uYlRISUNZaHZ3elZZ?=
 =?utf-8?B?U2dNS01DdmJSZDFUWU1td1h3cDZXc2lCR3BETXh4c1NFVWFsUWtJeXp1cWhQ?=
 =?utf-8?B?SWtyUVlhcitsbmh4Q3BibHRkSm54T1pJVWZXZ0JyMm5LWG05TEZtOUZiNHNI?=
 =?utf-8?B?SU5DRTZ4ZE4vY0FWUkQwMEJsRTQxaUd5RXQvMHBLVEh1TWhBVXZRTzEwWjBm?=
 =?utf-8?B?UngwOE0rMHF4YzBYeGl2S3RuOHUvMWhnb1UxM01lT1dva2gvdS9rWlAwUzlW?=
 =?utf-8?B?M3pBSUdpMi9BZWtVL2lBWTRpdlRoZ2U4VUg2SmxQcmpmSTdwcHU4YWFzMXNJ?=
 =?utf-8?B?eTFjamV1WU1IZTF5TDJNSXJzUGl6b0tHeWQ2dkdiTHBSQUhRYVZBY1dOL0JR?=
 =?utf-8?B?YmxLVXpxWkppdWdwbkVPYUNvdnZTempMTmExbkFKeG1WVytvWldKUGpaUXJW?=
 =?utf-8?B?VXprZGFkNXN0RlZ2WVhGZ1R2OUhkdjViL1IwNThLVFJadVduRmV2cXVJdUdo?=
 =?utf-8?B?N1ZueUdrVWtZZFBWb3dDenQzS2o4dE5XaGRxTnFmc0x3dEJ1KzlPNFlmbTFk?=
 =?utf-8?B?eWgxSTkvS2c1UmJ4ZjZCbnBYVkZrY1FuUSt1eU1ubkErWjNkUjhTWlRxSEtw?=
 =?utf-8?B?S1Y5cGVJNTc3N0pPeDB4TGtGU0x6UytlQzErU3B6NmM3dkNZenhkdGV2dWQ2?=
 =?utf-8?B?M1UyUENnd2gxOG42QnVUZjJDNng3NXFOZHZGazlQMEhoZ1JhVFVwN05CQU9q?=
 =?utf-8?B?bTRSbWo0Q2xkRU8rczgvZWVnQXhhOVQ4NGYrVUIrMUZNeTZRRDI2QzdUNlRl?=
 =?utf-8?B?a2NkWmlIbmZFak5PZXRTbitoVzhnTXFOZ0txR3E5ck9MNHB3a3NkRFFRTTVW?=
 =?utf-8?B?ZEpRUWVvRXl4R2JNWHVRUmxFWGtpeTJvSEQvclhiTVRBN0t1bWx4RGdZU3I1?=
 =?utf-8?B?aU03ejhrU2dGWFVCOGxKRDNjSXlObkozQVhlSWtqQ2huQ3dZSEROT3l5bWFN?=
 =?utf-8?B?bmRlb094TTdiU1B6L0szaEhJUHlFeTcva0Z4R3Rualg3SDZPYnFnRGxJVWNm?=
 =?utf-8?B?d0dYSnp2VFZsWE83RUUxaXVsT3VQQkUvZUlLc0czZlZ6MTZNaHhmeDVBeXh3?=
 =?utf-8?B?M2EvanpKcEovMjBpSW1DbzZ4KzlIbFZnZmc2eWNDRFFoK3l5dDVaNjBJazFB?=
 =?utf-8?B?aGRtSXMwT1hNbG0vWTZvcjcvME1pRS9iTmowZEt0WEZJcEczNG9tL2dVTFlY?=
 =?utf-8?Q?z9c4Rjq5+eP4nAzziLZRgX4CW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03cfe5cd-bd51-4c40-4aee-08ddf7b5b6bb
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:49:58.5090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: faAkwqjom/qf7owvTTHTjj9Hv5B0gnq0+Sqkzunq7RMIhAztseku3tIrgT/l0yUM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9185

Hi Reinette,

On 9/18/2025 12:44 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> nit:
> Subject: fs/resctrl: Modify struct rdt_parse_data to pass mode and CLOSID

sure.

> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> parse_cbm() require resource group mode and CLOSID to validate the Capacity
>> Bit Mask (CBM). It is passed via struct rdtgroup in struct rdt_parse_data.
>>
>> The io_alloc feature also uses CBMs to indicate which portions of cache are
>> allocated for I/O traffic. The CBMs are provided by user space and need to
>> be validated the same as CBMs provided for general (CPU) cache allocation.
>> parse_cbm() cannot be used as-is since io_alloc does not have rdtgroup
>> context.
>>
>> Pass the resource group mode and CLOSID directly to parse_cbm() via struct
>> rdt_parse_data, instead of through the rdtgroup struct, to facilitate
>> calling parse_cbm() to verify the CBM of the io_alloc feature.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> 
> With Subject change:
> 
> | Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> 

Thanks
Babu



