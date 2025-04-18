Return-Path: <kvm+bounces-43653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C19A936F0
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 14:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 707F546519B
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2808E275109;
	Fri, 18 Apr 2025 12:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="O+0wbxFv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E02749E7;
	Fri, 18 Apr 2025 12:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744978688; cv=fail; b=mc0LWP4hJtNjOWg7gv8SGc5WzNF9HieFTb0eIvujR1avLU4nQv/i1tjY7ItC1wamFKwBvQo4np2n2pgSMEGwfdlfoxXABBDx5jgDux1Rneju04v2Li0qQ+V7Cibw7oYCRdd4Amj2WwLadjnTmU9jn/8Q15Ra6XagSloxIsyE2lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744978688; c=relaxed/simple;
	bh=q5pASh248jB5TWyuma07OYo5r3xe+Y6ULcWnESvyCUI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r5CyA2fhhAQp8FXdP5prEIer1rS39mzm+37Erm72ypWS/1GqJeYNbcUzwLfnASWsimts6SbW0X0v7bmEzPA95BTy6eshjcajjlBTCCxUhAq3xUMVZgkv/KhGISoxOGen78UxzGZRcdltTGBowz6k++r0FjrRiBbB6B+x2H90eJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=O+0wbxFv; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZW0WuboPIT2GfQhasPvXdZ3DTWKTZ1GvFvZI6ulrapSPAPUdjaZAjQEzQidXCmmnu2Mye7vz3txS3Sv4WheZhQOJUUkO0l7/Y6wQO0iX25dmCbsZpjCDu0OtnJGAwpYLIeG0JvdqO8MpBewHEyrQVD3GnHG0r1HsLsBF+79I1F55bsmZEMlmYmAo5sIjfhQem6y2xm1itax36Gpk6MrUD+hrGM1PyxOIdBjaIN2H1XpSO1ne6ZJQ43CKOWA9Z6dTomRsdA5LzdYCLzEGj4EjtdiimP/vb8olpavO9Ob7l3p/DOwzxL3+lDBDAJn7S33YFNXIkEMAwgb0hTf5tczzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=189r9vV+7EY740mWC6k76GviYTcqG67Gyn4yzUZ+hEM=;
 b=gMfZ17ZXIyCvObzrqhaTzI4imV5UBNDgi1DSEBokfGd3sCtFYI1LyPd1+Tj1uE+Ghdsk/RxsOLFHnVia7hmGRyshNLxh6xypoT2+jmbmGzvgPJbDEy6QWAR5EyNnZqFks9i9kLXwF1A6sdR1ulWNl36ylSbl0ZsCUqvjwqhpGuI+gZ5gxEyj+a3dSIUTNwiWHxxywNd+ZfuO7W8FOlnW94Mi0FYtyb43Dw3kZH4HMgg3pfZNv/szILzIF8Xn9B/jZIxNklF9/HxDAIY3ehdqga2JEC86uTcCmmmHjEh6zUuu6mWOvuBeZ/7FxbhKbmY2li8oDRmpzCnhE6zvg34aEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=189r9vV+7EY740mWC6k76GviYTcqG67Gyn4yzUZ+hEM=;
 b=O+0wbxFvU9wRDydpp5u1jv5Qvz4TVXWuBBn8886NM4sAlpqXT3rKal29tB5KWZGcJpE526UcZQ8oaa/9xSTrqlEYCiRfRKX0TQ9mgIef+T7SRiZhV9/CyZvM/pG/qEYCAUa8cOrDhR/voKG9nyuEE2473x70SgjLW6IPbABUT88=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CH3PR12MB9170.namprd12.prod.outlook.com (2603:10b6:610:199::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Fri, 18 Apr
 2025 12:18:04 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 12:18:03 +0000
Message-ID: <b29b8c22-2fd4-4b5e-b755-9198874157c7@amd.com>
Date: Fri, 18 Apr 2025 17:47:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 64/67] iommu/amd: KVM: SVM: Allow KVM to control need for
 GA log interrupts
To: Joao Martins <joao.m.martins@oracle.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>, David Matlack <dmatlack@google.com>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-65-seanjc@google.com>
 <9b7ceea3-8c47-4383-ad9c-1a9bbdc9044a@oracle.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <9b7ceea3-8c47-4383-ad9c-1a9bbdc9044a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0058.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:274::10) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CH3PR12MB9170:EE_
X-MS-Office365-Filtering-Correlation-Id: c4395a8c-f411-4bef-e283-08dd7e731153
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y2N5bHVuc1o1OTBaZGZRYnkzaExaV01iNnJQNkZrdzJqSEpGR09XdnNacThh?=
 =?utf-8?B?ZDN5OUkyVjNFaG9XYlV4OGFWbnhPTXY0Y1Vmc0YxelY1QjIvUW1MS2J0UDV4?=
 =?utf-8?B?RU9RRTRIeXB2SUNyV2xoVDdUcDQrb1ZCaGpFU3FsYXQrb090czJQWlNsaEd0?=
 =?utf-8?B?N25saFk3SlhNQmFLV01teEVvaEpON2tzaXNibW9VYXQxbmszTStrb2kvTkpL?=
 =?utf-8?B?L0p1S2VQVlJGT0JyL2h0V0s2Y3ZMZ250Mk4rNlc0OHJsSzJhUVBNREsza3pY?=
 =?utf-8?B?LzlGMzJSOHB2RXMzNGpIdGtXTWd5dVpWQ0tsZWFkWVRjd0ZEWkZzQk1pU2Vs?=
 =?utf-8?B?M1NKQk9yOEtYKzY5d2ZjSlBhWDJHNGFib0NVOWpYR0llVWl3U0hhZEtCeENw?=
 =?utf-8?B?NWlwcnlvZFFmOUk1MVJ4czNUb3FHUE5ZaWZVbG5tVkgzNnl5dEtCNmQ0Wmhk?=
 =?utf-8?B?YUNCMzd6WXE2RW9LZFRSYVluTFlSOVB6VjVyQjRoc25zRWdmcmZ3NGxUd08w?=
 =?utf-8?B?WXhPQytOamhFOU5STTc3dXc2VXIrY2ZhMnFpa2kvRjRoRGpDQUp5TU0vRGcy?=
 =?utf-8?B?enRCSkM4WjM5Q3RObXJoaXEyK2J0NGhxRFhXbHc2d3U0R3Q2ZHR4OW1iTGV3?=
 =?utf-8?B?Z1kxRDRyT2tqTy9aMit2bDJMMWZQK1QwTG9XZEgrV2pVOXl4K2lOYXlMbURt?=
 =?utf-8?B?blUzcnZ5R1hkS1dHdldSbmw0SysxTmdqS0RZM1RKR24wYWdvVkRhL2wwWVhS?=
 =?utf-8?B?TVlZa1JHWlVPSGdCTDhkYlhqd3VrUy8xcjdZYW9qaStqeHJNQU9jOFRjaU9G?=
 =?utf-8?B?M1Y2a045dDZqKzRtTCtqS3RGaE53RDgyQkl1cWxKSitrQ2I3eDRoek00L1hs?=
 =?utf-8?B?RVgvaWxLcGZyK0FTa2xSTHVlVGtDaWFmOUpNaXVRZ2RjUVlFMGZtdDdUSi9G?=
 =?utf-8?B?NzFTREhmSHNlMGlycHhnZXJlclllZ3JXZUhqYWVYSHlGaW1KYVkvZUNKa0RZ?=
 =?utf-8?B?QWRxSnZ6c0RVLzV2TStFNGpkZU02MnhSNFU5RFRhbWI2aDQ4bGRZVUk0RFJz?=
 =?utf-8?B?REhEN3NhRC9SdEZmZWhIZnVvK0k2RmdmSUxIMTAzVEt6bEZyaDlPZGdJM1lK?=
 =?utf-8?B?RXlUYzBuRXd2YU5IODM3eUdSMzlyVlBFaGZ2Ly9uUC9acS9ibW0xMmdFVGdj?=
 =?utf-8?B?UU9WQkxZYlFNMHFvbDZaM2NyLzA4TzdWbzJ4OGxodFhGK1ZCd1B5NzNabUF5?=
 =?utf-8?B?cjVIdUsveXlUTE52Qlk4cXQzQitEMER6Y3cxNW9qOHhCSHE0NlREby9qYUZn?=
 =?utf-8?B?NHg0c3k3MVBkdEhxRTVuS24ydkcvQmZRZUVZcE40MjhpVXlDOUdPMEFXYjgw?=
 =?utf-8?B?NEtGZ1NldXFNU1dDc3J2dzZWZUpoUjlZQVJYZENZTWxQam5OS1dnNkE2bFMx?=
 =?utf-8?B?TXA0aWY3dkt2RlZneklWZkJocUpVNVAza01jK3QxQkVRRitKQjg0WStVaU02?=
 =?utf-8?B?MXFMK01McGhFSFNBUU5UcytBczcxWUs0ckpSTFRIOFN0MFJCTzAwRXNWa0J5?=
 =?utf-8?B?YkFpdjYxQlVaTWRQUFVWRCtnTHU1ZGFzaUdJRUkwTFZHMFROU3BkK1lvUk14?=
 =?utf-8?B?ZUh2TmVTVVVnbUFrZ3lRSHlxOGRLT2ZoVXJreldGOG05UzM4b2ZQaDdVMnNJ?=
 =?utf-8?B?YllJaEZHQ1p0cno2TWR2OFlTL3FXM0tyOVduLzRPTG1XTjR4NzFWanQ5N0VJ?=
 =?utf-8?B?eEQzd1ZaSEsyaVd1SEtSajBXSDBUbjRoSEkxSGhCQnRQM3VsV3djVEowVDlU?=
 =?utf-8?B?MVpxNUpNVlJDWjU4Qnk5TWVOdXYzWUJWT25QRHp5b3FQdG1KVjBycktlb1Bk?=
 =?utf-8?B?Ym9CUWt0bFFaQTV2U0o4SWdoRGVUQ0RNbVJIZTYweXdFQXVVWEd0cHpPSHRY?=
 =?utf-8?Q?7yYdkWdpN30=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDI1KzRvSFpFYW5iaTNNRDRFVGFGVEZVOTNhQ0V3RUM1a1VmVUtSaThIbS9G?=
 =?utf-8?B?SEJ1NklDWldDVWVmRldQam9US2hkMlpXRXh2UmVpbVduSUdFd1FvTnBuUXZu?=
 =?utf-8?B?UGV6cFY2VEhhQmRPU0NYaUp0cEVGTTV6cEhRaUcwOXdzcHpXM3lYTGZ4NTJJ?=
 =?utf-8?B?dUpoWW9hcjhCVE90Y090OHoxTmFLOFBXZEIwS0QrNjdJOXJzak9HNElHNEFl?=
 =?utf-8?B?ZTJtMG42ZTdyL1YyNEVsUEZOYS91cVh6ZTZ1bTBMUzJNQStlRWV4V2VGYjFt?=
 =?utf-8?B?VVdIRVdKd2RkeXhBUEMzQ0F1a2JnL2xLNjExU2gxUUlPVkN0Q1ErRmZPSGMw?=
 =?utf-8?B?SlRVTmxQMVJ4enh3VWFQZVBvR3FvZERDNjh0QXhxQVRxckExcFBNSUc1Wk81?=
 =?utf-8?B?MW1wV29OTlp1Ny9SZjJ5Nm9aVG1tZ05yTTNhNmp6aUFreXJjYUZKMWZtS2xj?=
 =?utf-8?B?bkF5TG9DN3owSTlvc2sxVDBiSGt3UGk4aEZEODBlcWI3cHd0eWYvZWdnZEk2?=
 =?utf-8?B?cm12WmdNRks4YWR6N1FqODlzNFdjSEpmWmdLL2RLWU5JdFRoUHVXZDNNZWlY?=
 =?utf-8?B?SVhweXVJbHVRazNrbTl6YkZHMUhUKzh1RUxETWxsRHZQS0FyanB0MXhPK0FO?=
 =?utf-8?B?MDZFMWF5NSs2NVRnQ0pzOXFvNzExTVpjY1R2Ymx4SnRhbVR3UFZrSlcxWVVH?=
 =?utf-8?B?TWJFYnZrMnRwYlRrVFZqbTlPekpDeDFIdjBrRzNFQ1lhVjNRSm41MHNERUZK?=
 =?utf-8?B?enhldHZLdDI1Y0hHREtvZVhxQS9oVWFwTDZlTEZhb2FMSUJzVkwrTEZnOS9v?=
 =?utf-8?B?bThPZkNMSlpSMzZsbm14MjBWc25EWDloMUg2dGRNWlMxSWx6OURGMTM5b052?=
 =?utf-8?B?eDkyRWVlMklDSWMvaXZsdVZoREE5dVEwckJCNUxINGZPTjlFb094NVB5S1Zz?=
 =?utf-8?B?UC9FZzFKd0lCbm1VNCtaN1pCVHhJUWZBNjhTcE50ZmplTWpxc1pDM3Vvdkds?=
 =?utf-8?B?ejBTdkJyQy85cW9aL0k0c3dNdjdudGxZL1krRVlNZHlmYzgzdWE1ZUZhYkVk?=
 =?utf-8?B?S3p0SXZ5Yi85SHhVaWpCWVZsTzEreVRmUTNUa0d4WkgvZ1ZrRDlybEhzYTdM?=
 =?utf-8?B?RGJUelF4a0U0Y2hhZUh6OVdWU1dqM2I4Yi9nbHh1NGtJMUR0ZnpwWWJPVDdO?=
 =?utf-8?B?cDdwdDZQZ2tVL1U3SENOWXRrZmhlbnU5WFA5KzdIb0hyZDAwUFZvdzZRT0NN?=
 =?utf-8?B?cWttUzhTQzNPNVFyZ1VyMzNzM2xPcXpuR0hwRXkrSlZzQW1tM3p3TlFCSWZT?=
 =?utf-8?B?dDBLUjIydDdQK01NWmJkcld3MlNNTDlHUkVsRVBHVGpnYkZNL3BnK01MbXU4?=
 =?utf-8?B?Y3gwbXZCSDBKU2tDQmJNNlVFT3dLVEJGQ2xOVW05ZlR2NkVrVWZDWnluNHBr?=
 =?utf-8?B?ZTRrWFdiN2drRmZML3pHQ2FYY0VMZllMVW1od1ZVdWgycVBxcGxQVHFBblJJ?=
 =?utf-8?B?ZFEwQjZQNXZDdVNENkdwM2YrdFhHdWFHb1dTOG5SSGNYVGNEeDNWZjY2d2JZ?=
 =?utf-8?B?dnNqYnFrZksxZ1FkWGxPZWRIazVydXB4cEVtck9EZWlNNVRSQkJLMTY1Tkor?=
 =?utf-8?B?RTBoajZwQXdkZlVtL3ozNjBtclllVUMxbUxvTktQekNTWWNCSDVKUjZ3WkNn?=
 =?utf-8?B?dkpOeEZIQk81RkNYc2NmbmZ6OUEyUUppUk9GOGVJSGxobHVwN1BLUVFjU3lL?=
 =?utf-8?B?YzZBaFoyQi9ZdHYwVU5kQnJVZFFtcGlVSURJTnI0S0gxbGwwVGNucm15T0VH?=
 =?utf-8?B?MzlZdmNaOEk3dVYzbGppVzcxZ2cxazgrRjg1Ui8ycE13UWlLekNpMDhYeFpP?=
 =?utf-8?B?ckxGNmJiNTJpdW9ndDBYNVRpK0gvNmc3VHdnY1I4Q0Rab1h6U29VNnhJSFZO?=
 =?utf-8?B?UWVCTjE1TmczYlByNjZGdEVCeEVPWCswMFJFWjlZSnlKbEJJTTNMSks5VWhW?=
 =?utf-8?B?VXBZNlpJNERYVUwvWVhLYml1NHRGcXplN1praEFUN0x2cDZOYVJLSXo0SEdk?=
 =?utf-8?B?M3NjVmd5MFJBL2RaVVZCWVRaMHkzSVA2cU1GSy85ajZsM3pVUkR6dEN0dGFw?=
 =?utf-8?Q?JXQLZ2lJFO62TlLzUGn0YA5b+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4395a8c-f411-4bef-e283-08dd7e731153
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 12:18:03.5874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uc6q9lOdjs7CiyQiHq4XmU/8JyK38kanIA07xCmyqM/7RbdeJSCm1kREA57G76VjEExZDJXjuGQRCtJUfPin/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9170

Hi Joao, Sean,


On 4/9/2025 5:26 PM, Joao Martins wrote:
> On 04/04/2025 20:39, Sean Christopherson wrote:
>> Add plumbing to the AMD IOMMU driver to allow KVM to control whether or
>> not an IRTE is configured to generate GA log interrupts.  KVM only needs a
>> notification if the target vCPU is blocking, so the vCPU can be awakened.
>> If a vCPU is preempted or exits to userspace, KVM clears is_run, but will
>> set the vCPU back to running when userspace does KVM_RUN and/or the vCPU
>> task is scheduled back in, i.e. KVM doesn't need a notification.
>>
>> Unconditionally pass "true" in all KVM paths to isolate the IOMMU changes
>> from the KVM changes insofar as possible.
>>
>> Opportunistically swap the ordering of parameters for amd_iommu_update_ga()
>> so that the match amd_iommu_activate_guest_mode().
> 
> Unfortunately I think this patch and the next one might be riding on the
> assumption that amd_iommu_update_ga() is always cheap :( -- see below.
> 
> I didn't spot anything else flawed in the series though, just this one. I would
> suggest holding off on this and the next one, while progressing with the rest of
> the series.
> 
>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>> index 2e016b98fa1b..27b03e718980 100644
>> --- a/drivers/iommu/amd/iommu.c
>> +++ b/drivers/iommu/amd/iommu.c
>> -static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
>> +static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu,
>> +				  bool ga_log_intr)
>>  {
>>  	if (cpu >= 0) {
>>  		entry->lo.fields_vapic.destination =
>> @@ -3783,12 +3784,14 @@ static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
>>  		entry->hi.fields.destination =
>>  					APICID_TO_IRTE_DEST_HI(cpu);
>>  		entry->lo.fields_vapic.is_run = true;
>> +		entry->lo.fields_vapic.ga_log_intr = false;
>>  	} else {
>>  		entry->lo.fields_vapic.is_run = false;
>> +		entry->lo.fields_vapic.ga_log_intr = ga_log_intr;
>>  	}
>>  }
>>
> 
> isRun, Destination and GATag are not cached. Quoting the update from a few years
> back (page 93 of IOMMU spec dated Feb 2025):
> 
> | When virtual interrupts are enabled by setting MMIO Offset 0018h[GAEn] and
> | IRTE[GuestMode=1], IRTE[IsRun], IRTE[Destination], and if present IRTE[GATag],
> | are not cached by the IOMMU. Modifications to these fields do not require an
> | invalidation of the Interrupt Remapping Table.
> 
> This is the reason we were able to get rid of the IOMMU invalidation in
> amd_iommu_update_ga() ... which sped up vmexit/vmenter flow with iommu avic.
> Besides the lock contention that was observed at the time, we were seeing stalls
> in this path with enough vCPUs IIRC; CCing Alejandro to keep me honest.
> 
> Now this change above is incorrect as is and to make it correct: you will need
> xor with the previous content of the IRTE::ga_log_intr and then if it changes
> then you re-add back an invalidation command via
> iommu_flush_irt_and_complete()). The latter is what I am worried will
> reintroduce these above problem :(
> 
> The invalidation command (which has a completion barrier to serialize
> invalidation execution) takes some time in h/w, and will make all your vcpus
> content on the irq table lock (as is). Even assuming you somehow move the
> invalidation outside the lock, you will content on the iommu lock (for the>
command queue) or best case assuming no locks (which I am not sure it is
> possible) you will need to wait for the command to complete until you can
> progress forward with entering/exiting.
> 
> Unless the GALogIntr bit is somehow also not cached too which wouldn't need the
> invalidation command (which would be good news!). Adding Suravee/Vasant here.

I have checked with HW architects. Its not cached. So we don't need invalidation
after updating GALogIntr field in IRTE.


-Vasant



