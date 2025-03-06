Return-Path: <kvm+bounces-40271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4FB9A556B5
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 20:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74DEA1894592
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 19:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C02927D788;
	Thu,  6 Mar 2025 19:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XaEizlIA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAA127CB3B;
	Thu,  6 Mar 2025 19:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741289273; cv=fail; b=ITqAtR8hFj6Zy/KR0994A+vSQhTWcIkpZR/TbHzaKkxN9IvdqH+rnDdx8twrlJFz53XeVzcKPnT76ZlvUY59tTnhTJ+XmxJR/U5gyPEVWi1XN0hHR/r97lLld2Y0wHhUOaITsOCUL8XKjpMFasRjXLXYvCNoFr5tf65OqGV+F3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741289273; c=relaxed/simple;
	bh=o/HnVOjv3u+/qpt2AACJJK2VWYIOEMDui+cIFZpGapM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gqlg99aFhOBcj+6+zfEXWsx3vBXeA1P74F5LBVfASVjGIEkW+3r8rZmgve5XTYLOVWrsMQPxYeTy4b/a8YrjKx0kEr5koEWmeqgA/DuAPUwdBiKVAfWommLc02XiJUFPBBvof4W/lqZcym4Hu0fZmRtNuiS5s+TcQPEghYysU34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XaEizlIA; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m4yQN8aBcTshnA25VAc0mcAG0wvJmJcYG1H17v8qr8sX153x7upBuNKCZXW7PFeJAF+zsFc3HvIs6Ow6HYwdJkuiQRfLOFBjBeuKEaT7+7otAWR7rwgn17nJLhJ8V+1Xe7TDiV2++Sot1dspHEPBzFd9wA08onrh+7avsetTsyTDeFDCEwPakr+o3phG6HJv7e/7huK/n3dHYZROBCbWydW1wTx7m5Ybf06/AIprtkLJbsM6dHpPrlWhJIVaV/90PejfBqs4YkC7zZoM5z6gOnbQGmeyIuPejR2kMS69Wi5On0sI/2Sxo8e+1Q+kt/AbpmTU9/TaWsNqELfuTcq23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=10jparFLULkK5ntdMMFSAlVr0JZuLfzIMbwFs6PllKU=;
 b=lKg6j2BrUcfTTuq5+eW0X7BEhLhQzM0h5RIYU5JkYuAv0+y+fA8kAYUpX7on5MUAn/mcHIAaxjFhKnsyTBbl3l0Lu0WbaxgRqYCMc5t5zfq84Rtk0O8GOEwdJELQg+oM/0eydZFEXjHY+A002rUldiaXnSBzDn3FSg7QVz6evIPE+tvcFsm5V6+WCKPJsWIkRMHKHBt0AXfil0v1Ncs2ITh0oZWpEW+Wxtjwhvs3XVoCoqCascyWa8O9gqGQMCBhwXK/sFtX2RPoQQH0WY/Q2UVc9kaao2cUwr6oO7jFBS6kKkET0dYsCjIQW01u1+9mBXgzWznH1AxPmqc3aBe3kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10jparFLULkK5ntdMMFSAlVr0JZuLfzIMbwFs6PllKU=;
 b=XaEizlIAKWWTeLbyZEuuWjYFqW+pB6MZ3C846gWP9EUjVPPprQX3sfSR+INJeeP7V84E3dqnA1xKF4jLaXWC0tzOIAOhxNBaJrC5Ml9+kOlOkW81ndix5BGcV9+WQIT8Uw44bC8GLx5kfqUeEIXnYcanymd9miDo0NxsfxzWl/w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7308.namprd12.prod.outlook.com (2603:10b6:510:20c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Thu, 6 Mar
 2025 19:27:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8511.017; Thu, 6 Mar 2025
 19:27:47 +0000
Message-ID: <977385c2-f885-4c5a-ae79-3dee863900c2@amd.com>
Date: Thu, 6 Mar 2025 13:27:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB
 Field
Content-Language: en-US
To: Kim Phillips <kim.phillips@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 "Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
 Kishon Vijay Abraham I <kvijayab@amd.com>
References: <20250306003806.1048517-1-kim.phillips@amd.com>
 <20250306003806.1048517-3-kim.phillips@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250306003806.1048517-3-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::19) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e572bc-1ef4-4811-5e48-08dd5ce4fa1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RzRabG1YM0s0LythRHRWQVcrZHBvWE10K0YweUZoWkhQaDVtbm9GK1N5d2oz?=
 =?utf-8?B?ZjA2QjkwOVlGV1gycEF3ZGp3ZHhlMzFrNlRNOHd6eEFRTTRhNFplNDlqL2lY?=
 =?utf-8?B?ckFKa2lPc05jT2pVMHB1WHNRZHpNTVE2MW5zOCtMWFdpVWoyanhzcTV1WmpW?=
 =?utf-8?B?TEdDSUh2RVJvVmZwMkVtZTQvZDE4c0xPQmhWTE5TcVI1andzVmwrcGlYQ2dW?=
 =?utf-8?B?cytWcFNGVWZBbDZscWdBSFpKNnkzZUgvQjBGeW9hKzRLTTV4TG1GUzhLTzRZ?=
 =?utf-8?B?M3VWM1JaRzRoR1BVWkJmaXVGdEJQUldsR0NtR0k2Wk9NVllzdk9xUXRiaFNw?=
 =?utf-8?B?WmVHNGNtMnFwRHI1T3Q2OTFuaWp5akJMQWFYVTNDcDNRVjN1K3VmSHRjU05M?=
 =?utf-8?B?WnQ1NXkzK2g3TWdiNENNQXZucEhqTWQ3RE1nYmtVRlFjd3JscG5qcnBreTJB?=
 =?utf-8?B?YVJVQjNOVVhGQ0JMazlFY1RabWk0ZU9PNG5sd0I0ajVWY25zYTdLRWNzR213?=
 =?utf-8?B?Rnh2L0l6YzhqTXcyZktHL3orMktoUHhFMkhIeElUOGdZc0VIK21wS1A4NjlT?=
 =?utf-8?B?RTlrb3NwSUtHWmEwZmN6d3YydUtWMXZaR2dabkNWNlpTbVgyNXJNRUtmMzhO?=
 =?utf-8?B?dXJPVU9FU1dIQ2V1ckVuWDltT0pzcHpEajRIS0lrd3hQVEkrblQ4QTM4TjZH?=
 =?utf-8?B?d3Joci9lUHBneTBIWHJ2RGtzc001M2F4Yzh2SWZtVmdiR2p1WjBmc21rRnBv?=
 =?utf-8?B?VEFrTmxSQ2FVOUpsVG5wVDF5dWN5UHJZSmNicDlrTWFmUkJ1N2RTUzdiTFlU?=
 =?utf-8?B?eXpLNndORnlFdGtLcUF5RFRxRUhBRFdrY3VXVVJ5M0pzYm9wR3dwWUNRZXhR?=
 =?utf-8?B?MHp4N0xYOEhvVGQyVHZXSjgxOWtqYkRqVlh4QkxpZnNTT1VvLzBxcGZhcWNW?=
 =?utf-8?B?b0dmNE5SOUZSUzRtRkNpemR2b1dUN09mM2Fkeit4akZoNjVXVFlFNk44a3JK?=
 =?utf-8?B?VExpT0JzdGdyczhnVDdQZ0ZrVmdiRFBDUi9DWm5NOUhGUitWVXh0QTNYWUVY?=
 =?utf-8?B?VHFBa21tMEV0YWppb0VOS3hiS0hxRkRNcmlvciswc1o0SnpXSlBHUVFhL2I1?=
 =?utf-8?B?bmhOckROOUdzK1JWOWgyVDlOaXptVlNudzF1L1dJU2k5VzRiZVMwelJiNGhl?=
 =?utf-8?B?OVpESjBZSXAwUmc1MGdvbUpGc0g4S0N1L2IxQk4rbGRpaytGTms5QTlqRGNU?=
 =?utf-8?B?aHR5ai9QN3RYKzlLaFV6UG90RG1WRW5Gb2lOVVE3bS9VUytoSmpXMVNXbGhQ?=
 =?utf-8?B?OW5qbWNxcHhuSTJuOUVjMyt2ZnROVjh0TFlkOE9jYXo5a3JaM3o3UTg5V3FO?=
 =?utf-8?B?YXN3WjFyZy9hRzU0d2F6WExTemRsbkRrRW5mVm1nMktWWjJ2aS9hMi9yamhZ?=
 =?utf-8?B?OWU2aU83QW1NaGtBVkh5SVBpWE51Sksrd0tDUzg2NndwSVhuSm9sUmxENTUw?=
 =?utf-8?B?cFN2RTBFQS9NZGpzRVdhNzkzdkxSUTczUkwrWlNDQ1dvbWhQZnU0Wm5XUFhr?=
 =?utf-8?B?Nk5QV25ZK0RVSmNjaUhCN2s4aW1SMGZ4YXVTaE9sOHplWGxHcUZxQXJ3eGVn?=
 =?utf-8?B?ZmFDdTdMTEhkOE5ZeE85L2M3aDlWMlVGOU9aY3lndTMySEkxQ0pFS1hzajB3?=
 =?utf-8?B?TzJrS21YZkFxdWxXTW43a1ZOQlVuV3k2TldVU1VUbmU4NktRNTFLaS9mMGMx?=
 =?utf-8?B?Mm9DSVl5dnIwMmEyd2pmWFo3WkpOREl0L2RZS252K3pQek9aZkhmNkpiNzdw?=
 =?utf-8?B?WlFYeGZCTyt6am1VMUVQZjFZQTVLaVJ3TFg1MjdDeDFJM0RwWWpoT3NMK0JB?=
 =?utf-8?Q?H0u74mC9Ltnp/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFhYR0lGQjFKT2dBY0JFZWtKN05IeCsyNTM3Q2oxbUVxdGsyY2tJMXJMMzFT?=
 =?utf-8?B?amcvM25pTFJZcGFpZ2UyM2RITmNOTU94UExWek1vWFNWMjltcFRTM3lhQzZ6?=
 =?utf-8?B?UlNyRkZ3bWFwUjhTRDBHWWNYMGV1Wk5WVnpFOG1GT0xoa3Y1QmY5Z0hZcnU2?=
 =?utf-8?B?SVNvbSsxRUFRM1FuWG10anROdjV0ak5BUzA2clc3TlBGVVMwekJRUVc0NHZC?=
 =?utf-8?B?K3p1NDRJWWZiT1ZRaGpPY2cvWk5mbVA3RWxGMEh1OEZuZWJaZitVK3VLbUlt?=
 =?utf-8?B?dGZSSXI1bzB6RUkwU0V3V0RQSHRRQzkxaW0wYURYbDlqWVBURDVWQ2xtK0ND?=
 =?utf-8?B?b0NrWUhBaVVEUFBFb1hpZGFlRXNQbUY0UnJ4eDdrYWRGMmgvTyt6d2tnamQz?=
 =?utf-8?B?S3JsUTBwWVBxaWJNQXdCdXI3SUN4Snd1dlo0RzYzQ2hObGZ6SU9NZndQcStt?=
 =?utf-8?B?MDd4QURGYU0zNHJBaEp6WFpvV3lkT24xOWxCSStmOEJ1SDhRZDBJQUNpeEll?=
 =?utf-8?B?S2VVem5iNXZiTk8yUlg0SUVlL01Tb3FSL09GNzBCT1NIWTZ5RXp6LzE1Z2hr?=
 =?utf-8?B?Tng2dXd0R05GeXFEenlaMzZHc01TOXlsSWdNc1dCOWUyUjZDQk0xOEFZUmZJ?=
 =?utf-8?B?WkMxT1poV2YxWFJrek52WGt3ZFpJWGtremFlZU52STI0SmVaT1hzM2xQMEF3?=
 =?utf-8?B?SVpaL0lRcnEwaVRkdWVPamcveG0xbTVNdk1FMUYvU3FFbmI0VC9HOWZQbEJy?=
 =?utf-8?B?bG9NVVlGZUtYN3JLL2xyRGtINCs5T3U2M0NIa3AyUGcxamM0d0p5bmxNUDV2?=
 =?utf-8?B?TUtlYVV0d0hWY1VySUMvSTV2ZllUQ3RmblF0em12QkFRRHNhZzJGM2xPN0VV?=
 =?utf-8?B?cEh4L21QYXc5TWdLK0wzbk1qOWRqTUdtSFdOZ2V2ZENKVFZUMXB2RWQyTmNR?=
 =?utf-8?B?OXhEaUtiL0Q5YnU1S1ByZ2s3YTdvL1dGZks4bDVMaEpoZVlWSTZpcCtmMk9q?=
 =?utf-8?B?WkUrbnpUUThoeDJRR3Fyc0ZBU0p2cUNTZlBWaGRQZkM4ZmJQZ2R0UmFPMC9q?=
 =?utf-8?B?ZFBuUi83dkNhWk5ldENFOWMzQXhCeEZYQ0RsZXZFQm1xV1o5Q0pqcndTQnJF?=
 =?utf-8?B?eVlJVEMyd2lZRVZBRHdtbjNGczVnMkVUNjE5NVFKQ210QlBDTDZZdjU2N3la?=
 =?utf-8?B?OEcxb3BjNmVBTUJwMXJ4RzRkaGRNaXhkTXJVRUt2Q2pYcS93QTlubTdIUFRa?=
 =?utf-8?B?NW0vU2t0dXZNUnI5MVR4N2hjbk9rVzNWWlI1aFNVeExWOE9ubktacWZJdmNh?=
 =?utf-8?B?YS9sSENKVXNKN3BEYTlONVkxcVp1OHRLY2QwVEpPZVprdThid09maFpSakFU?=
 =?utf-8?B?T3RSaUpQdHgxWWFHbTVtUEtUcGRHb1d6R21OM1BPdG1zN2ZwWndLNXc1WkMv?=
 =?utf-8?B?bW9DUjhTVmJMdHk0U3pRTmlaYnFEQlNnanF2ZzF6cUZad1ZvM2szelorbHVT?=
 =?utf-8?B?MUtvTmVpV1YzdlJiLy9oTEpYMUdETk5kcEUwcVZTUFFITmVwemJUSFBPS3BQ?=
 =?utf-8?B?MDhyNGVackZtNUROVzdRNnJvMU0zV1BySGdaSW5nNWhnZ0Y1bG1wTlBKYm9E?=
 =?utf-8?B?VTRweWg1d21TNVBJTVpqTklIZllTc2RqV1UzSjJZL2gzKy8yZUk1ODVyWHp5?=
 =?utf-8?B?UnFkcVFqQVE0SlZkYXhGbnQySjFWeEY5Um0vbHlUT3gxRm9EcnA2TkRJK0dQ?=
 =?utf-8?B?RVd5NDQ2TTZ5SVh1QlZVaWVnazNhcDNma2RJMllKWC85b1hkbVFUMlY0ZzFP?=
 =?utf-8?B?MWEwRytpNW9OM2crTHhrNGtsM2U3TW9RNHppMTRzZmpTVHpId1pPYTlSdVRO?=
 =?utf-8?B?QXpjN01NdGQ1WkdhZU5NTkptL3krTllPMnd1dlNhcFFqOXJpUGZVVHVXZVVu?=
 =?utf-8?B?QkhhbjIxQUswUTFiaWRna0YwMUlWLzNtWFIxUW03SGlWdUg5eFNaOHE0MHhO?=
 =?utf-8?B?WElrR0Vqb2xBT3RrQWxqY0FSWE53aldFbENaOXhuNUYybUVMNDZFbXJVb3VD?=
 =?utf-8?B?M0xSaHdqdUc2djJnQU4yZHVRUjZXZUFUSXp1Y2kvclJFbXFhM0daS2hUYWJW?=
 =?utf-8?Q?iboxBHyfturBQxnBw8epDYO0g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e572bc-1ef4-4811-5e48-08dd5ce4fa1c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 19:27:47.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/p82geOm7XFJgHez5yCmBsXpTzPceLpAY7O78UNmw+Gasb1soT2Rhy83HhCNPEeIKmO8HQq3wZmJ5Z7sp/HUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7308

On 3/5/25 18:38, Kim Phillips wrote:
> AMD EPYC 5th generation processors have introduced a feature that allows
> the hypervisor to control the SEV_FEATURES that are set for, or by, a
> guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
> that SEV-ES and SEV-SNP guests cannot enable features that the
> hypervisor does not want to be enabled.
> 
> Always enable ALLOWED_SEV_FEATURES.  A VMRUN will fail if any
> non-reserved bits are 1 in SEV_FEATURES but are 0 in
> ALLOWED_SEV_FEATURES.
> 
> Some SEV_FEATURES - currently PmcVirtualization and SecureAvic
> (see Appendix B, Table B-4) - require an opt-in via ALLOWED_SEV_FEATURES,
> i.e. are off-by-default, whereas all other features are effectively
> on-by-default, but still honor ALLOWED_SEV_FEATURES.
> 
> [1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
>     Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
>     https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  7 ++++++-
>  arch/x86/kvm/svm/sev.c     | 13 +++++++++++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9b7fa99ae951..b382fd251e5b 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -159,7 +159,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u64 avic_physical_id;	/* Offset 0xf8 */
>  	u8 reserved_7[8];
>  	u64 vmsa_pa;		/* Used for an SEV-ES guest */
> -	u8 reserved_8[720];
> +	u8 reserved_8[40];
> +	u64 allowed_sev_features;	/* Offset 0x138 */
> +	u64 guest_sev_features;		/* Offset 0x140 */
> +	u8 reserved_9[664];
>  	/*
>  	 * Offset 0x3e0, 32 bytes reserved
>  	 * for use by hypervisor/software.
> @@ -291,6 +294,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
>  
> +#define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
> +
>  struct vmcb_seg {
>  	u16 selector;
>  	u16 attrib;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee2788..7f6cb950edcf 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -793,6 +793,14 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static u64 allowed_sev_features(struct kvm_sev_info *sev)
> +{
> +	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
> +		return sev->vmsa_features | VMCB_ALLOWED_SEV_FEATURES_VALID;
> +
> +	return 0;
> +}
> +
>  static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> @@ -891,6 +899,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  				    int *error)
>  {
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_launch_update_vmsa vmsa;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int ret;
> @@ -900,6 +909,8 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  	}
>  
> +	svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);

I think you can move this to sev_es_init_vmcb() and have it just in that
one place instead of each launch update routine.

Thanks,
Tom

> +
>  	/* Perform some pre-encryption checks against the VMSA */
>  	ret = sev_es_sync_vmsa(svm);
>  	if (ret)
> @@ -2426,6 +2437,8 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		struct vcpu_svm *svm = to_svm(vcpu);
>  		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
>  
> +		svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
> +
>  		ret = sev_es_sync_vmsa(svm);
>  		if (ret)
>  			return ret;

