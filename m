Return-Path: <kvm+bounces-34670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D75FCA03E0F
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 12:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52C411882DD4
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 11:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3D01E9B26;
	Tue,  7 Jan 2025 11:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wY9lnULc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2075.outbound.protection.outlook.com [40.107.101.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7C41DED74;
	Tue,  7 Jan 2025 11:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736250197; cv=fail; b=O+T5x7CMNomosc2z98CEOQO/TUCjzqkIEcFtEftVU3DrGClX+2NEjr8SzCdfztRaL8DJSXOV3SbWjYQDx1fuz7r8LlutDl74QfjQFDbhUce1brrQh+S/ONgdYCnkgEPhvPram9P7eoe96xAeTlR70dsr36FFupCDcHllVwIYjI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736250197; c=relaxed/simple;
	bh=8Pyh6YetRh6RWl4NKEOGEX9qtpAG0pACsELbshJZlXA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rt/jpUxMq6IqxldU4U9O1D3XrYsRwJdmBCeGqe5lNfNNJ8xVYADUXMBRWnee/9vxYWILmH/x/W1SaLgeSRImrcD7ZDcgRBtOMsQMjLBuL/3nncsqlsCUMEIBNxYJ5Mc2U+J18434ct86Bsz4i7r4qVIsaeNpfDdVlWHHb5TPHu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wY9lnULc; arc=fail smtp.client-ip=40.107.101.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DZdYr0swGVZdKxUq3Dmw40vPbbxBgW6SdYW4nJ5WbsGn3kLcvyFZJm467dPG0moUAz2eIWi4nSc1dn5BWDrWrrfx/PtKCryQmf9JNtD+o9LtG8bfhVNBeGv9dTVICrRg1fn1eMvhAYf3+Vq+03MqYGaZASqEn9cCockIXJBFsIOGXHxnzoXHlS0/aBqQWKvKcj2UdNleMWZSoplwecw+FjhPxZ4Xm5ytI1Lz7i3CaCBvqk+NzCV+ZTySOhQPIZ3Ic3xBjfOv7OAc7hBUHMaoNeo9QFxBsEGjrHMaaxDgAQMSaydMTW+yhK8rFaxxUpPAEKHzENz9AtNBS77nqDTY1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgUoBgSFH/WVYJ1uuA/HTPQJp84kEBL7rlI0W5QfNKo=;
 b=YHJho2CS+v7GEVQ6xj8gUlaiIoJrlbv9yQx4RGGvGhrlrKax54L/rzwlMo9OgQ3VLnfMY3w/S5sLBVsLLCzpUdg6H67k6YrDxu5UpaPYTl/gn6eNm54i7/2iziQaWoQb6E4+KnSvsX1tHV14pofltY3LQggvVtEib0u9LPBI06crXfHALwcR11Qq3STYHd6AhJolT/nHzALCXTXTE/WtvbIbwIw38YLrVSV2m8AoR4Xbpa1JxesnFuWvAMW4BHGRrXyBeaXqA77jwRFpCjevcSqC4Xzl24O2ZgeVaCR3mPiqvkgDz7NchwhwdBXmeavLonG1c8iEaTspOz6tPz+AYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgUoBgSFH/WVYJ1uuA/HTPQJp84kEBL7rlI0W5QfNKo=;
 b=wY9lnULchNYSeMersb9wCQPOSBafn/Re7TQ3WAVLa5eXt0CiSbTIRUlrQcJu8PtZPNNhwLbpE3upKuDPFYEiNmO7o3+8z7NXIJUWYolqoDTH1v5V/8Vg3V0a/uP7x0XxOP9fzrGEYN+ndrn7WhLRZFw50qriHdMtccyTkCiKaFk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB5892.namprd12.prod.outlook.com (2603:10b6:8:68::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.18; Tue, 7 Jan 2025 11:43:12 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 11:43:11 +0000
Message-ID: <465c5636-d535-453b-b1ea-4610a0227715@amd.com>
Date: Tue, 7 Jan 2025 17:13:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
 <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0033.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::8) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB5892:EE_
X-MS-Office365-Filtering-Correlation-Id: fd7b629b-9a58-47fa-ace3-08dd2f1076b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFF3TlVzOG85dXlCeEozZmtWTmh4bmwzN2FxTitUQjY5SGdUajhUbnEzOVBw?=
 =?utf-8?B?QjZjQXlJZm9PRkVBZis2Z0lRTWExWW1USDRGV2lWbnhqWHdXUHlPVUdpZFM0?=
 =?utf-8?B?cXN6ZFk2bG9iVWdpSWNBK0ttL3YyY2xxcWdQMHhoUm9uZ1FIWWJKa1liUE9l?=
 =?utf-8?B?ZE5qOEJDcDY4Q051M2dzOHMrUC96amJuRTZKdEFsVlhqRkU2elF2NFBPS2ZW?=
 =?utf-8?B?UGNqZFl5dGZqT3dvTVNQVUFRQnNVNWJNSDVTK1o4OWVIUUVwMlNLSEZaSDVS?=
 =?utf-8?B?WC9OZk9BRzhneVVETUllYUJ1WHJxZUdnZlUvSHVXeXY5QUdvY0FFdU1Qd1dL?=
 =?utf-8?B?cFpaU2ZmN2dDR2R2YVhDU2pycFgyUDZxTWJSMVQvd2lXLzMxWC9mQ1hPWlBU?=
 =?utf-8?B?TGl6QUg5TDlLdkpGcXJvY2tSemRVRVRJUjRTbEdhZ2VROEtQQXhBK28zb3Iv?=
 =?utf-8?B?SU9mdnI5alBXZ2xScWdLRHhMRG83QlF3aFg0T25GcGpvdlhYQTVrVURrVDdJ?=
 =?utf-8?B?amh1NDA0UXR3dzFtTStBQkplUFF5MnRRZjRBTmYvdHI0a2hrdHpxZU1MbC92?=
 =?utf-8?B?ckg1a040L0VSUWp2citNcnFjbTNEYk9LK1BwSUdySFV1TUFuVGZ1YzVDS1Nt?=
 =?utf-8?B?QWdUK0JYSXVXcXdrNjUvRWI1YjdseVRrdjBhaGFMN3JtdjA5WkJvUFJsYXoy?=
 =?utf-8?B?QXRYeVFqYWpZaWJlWFR5U0tJWEJvN05TVXpSSHo5L2dGaGpIR0ZWL3F5UVNW?=
 =?utf-8?B?eU81bytZYnFZYXRZdnlVSGZTRWx3YkNXc0lxM1dqVlBldDNQOU1vMnRraWtZ?=
 =?utf-8?B?RkN4WFdpWGFqT1FRaWRVMjNrMzZ0TUYzaXo5K0tnaWplUFdPWm1uQnRORy9R?=
 =?utf-8?B?U1QxK1JpRXRBVUEwbGpBOXBScnVOQ1dNMG5Nb0FicWVvY0ZTLzgrK2thSm1J?=
 =?utf-8?B?ekFZZXJRaUJRc2dDS0d6em0randzM0tNY0N4K3RyQmxEQ1pnb2s1MFRHK0R0?=
 =?utf-8?B?dWxtcW1sbEVzdi9YYTRDQ1grSVNMS2ZaQmswRlNST01JM2Q4ZEU2cW9tQy9l?=
 =?utf-8?B?S2NOSW9yWnY2OTVkMUx0QkZFSldPSzVENXUzR1BEc1R0OGlTd3FnRzAzZEc5?=
 =?utf-8?B?TnVTSlMzb2p0cGZsWlorOWJmcy9talNWV3cyK1BzZlNjSkVQODJyc2NXcS9R?=
 =?utf-8?B?dlQ4YzlpY0hvaXJUcXFaaWJMbEtjYmIwMkEyUVJnM3ZYcVVWNU9rYWFMSGw0?=
 =?utf-8?B?cjJndDNTVTRpdmJidHI5QWtzZnFTZHE2QUNxSy96K3BYZHFibEJPMWdFTHk5?=
 =?utf-8?B?UWEzVGNDejdFa0dOblBIRkVHdlN1alA3bWlZbVh6SEZzaENmVDZ6bjJ0Rnl1?=
 =?utf-8?B?dnJhL0h5NVBQdHlPTnlrWEVjZlBqL0JoMURXdjBQVGhGeEpHZFlEUVJVaVFG?=
 =?utf-8?B?dHhSbEFIMUZSeTFyU0RlU2ZSRmdNVGJ1RUlrVFBaTE5RamRCeDNvRjBxMUtT?=
 =?utf-8?B?UlBYcnl6UEY2blFjMTRqNWg5aDZrMWNURlRpcTJZNGlnb1cwNGxBTERmeTJP?=
 =?utf-8?B?KzhCYjlkeWt4Qy9SeVNKTkovcmdWUnF5aGFZeVdwUDE4NVh2ZGxUMEd0ZTc2?=
 =?utf-8?B?eHQxTnQ5UnhFWUQ4c1V2TWFQUlJJZnhlU3p1ZG9ZSVk5QmM3Z1pBVFE2MEFs?=
 =?utf-8?B?dXppczdCSUdkZ05BL0tYdjRXRjc0aFJ6U2M2VTJ0Sk1PamFPR2R1MUdwaTdv?=
 =?utf-8?B?Tmh0M1FvbjNtNHd0UG1qblVydnEwbk50SWhoZEZ1bGlMdDJZTFJIR3VOUTBK?=
 =?utf-8?B?Vi8xaDRLc2lvVXdNSG81ZXVJcEN0OU9iVXFyU1lsUnZkZi9WWkhTMkdIZmpY?=
 =?utf-8?Q?x4H4jc8Pq/Too?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDAxencrMEhhbEFjYnV3L1FOQlVTZ3FaRmhxRDFVSGVTNi9rZDhhdzArT2Mx?=
 =?utf-8?B?elJVRXc3T21uaE8vTzhYdnlxRWVINmpFT0RETTdaREI3NWdIRS9hTWEybzly?=
 =?utf-8?B?R2pCRzE1bE82VDIwYjZrelQ3dThLNXU4QlVQa3BWcWxJcVhKa0NzOHVUMHY2?=
 =?utf-8?B?OWd5cC9iOHBBUUNteXowRWhQZGl6VmZpK3M2T2E3Vml3L215MVorN1BESWtq?=
 =?utf-8?B?RjYwU3orMWR4Mnh3RU5OMlZSbGlTQnhtVDNpVzNSckp4UEtoVmk5WGV0U1ds?=
 =?utf-8?B?WnF0WFJTMktwSmtZa213TkovdXB6elRSdnR0cTRnUmpIUnBKd3h5bTUyRkhv?=
 =?utf-8?B?QUFQS3Q0Vzl0aU9ERmErZURzMXp5eXREMVE1K3RmYkZlU3FTWXlveXlHODJY?=
 =?utf-8?B?MnFvQXA2a1BRdnRZbnNheDljc20xTU9xS2FtWmRjaEszNmRDTmhUWldPdlJx?=
 =?utf-8?B?QVNjdHBNR1NvZmVOQ0oxNkE2NDl5cWFLb2FubVBtQTJpdFM1MXhWQ1Vrb21t?=
 =?utf-8?B?dmNkSHpIdmxxL2FTZDErdGtxNTR2c1Z4T3ExYnhZejJYd3hzZjhWUjV2ZTk5?=
 =?utf-8?B?bWx2SzR6L0RFNXRTT3pZZXdzdmY2dklpTVgwRS82Z1lWVEJPNDJSY0p0SkFp?=
 =?utf-8?B?cmc0cW1DSXUwUmpjeDMvMW1xZDZLM1IzaEhCcXFnMWhrZnJJVDl1a0ZvMEhh?=
 =?utf-8?B?REpUZTZzYjJvNTI0RXB1Nm9YL09GY2MvbFJpbjNrUXpzSHB6YThKWjFIazVl?=
 =?utf-8?B?WkRUMTZHU29hSnFRc1RFZW0zK1BmazlJZkF5a1pPR1pDQmhQS0p2ejVVNWdX?=
 =?utf-8?B?TW9zTHRzMDVUWFBXNkt1UWFwUWZ4ekUyZ21kc1ZBNG8rb05pSzlJYzZpa2Jz?=
 =?utf-8?B?RWV0bGxldjhMbHlVMkl0Qm96T0JhQlpaNCtyOXduY202ZXpTbzUvYjN6UGUr?=
 =?utf-8?B?T0lEWEFqSm9BRnFRQjQ1UUZwSUJQQUp6ejZzVDBrc2x2c1l0aU1jeDJqN1pB?=
 =?utf-8?B?ZlE0aTZtM2xxaXZEVWtuM1I1ZEFUVGNTdlc3cGlDRmVYaGk5VUtqUitDRFRv?=
 =?utf-8?B?V3dPbVVndXZIRm8xbHdjTy9iMEdVVkFtbi9IMk05RkVlLzB1TTRsODlJK1hu?=
 =?utf-8?B?SFM1RFRBcVk4QVBiTDJITTJZYThQMkorcWxwNVViYUdpRE0wek1OVWs5Ylhp?=
 =?utf-8?B?akVveGtKN0p0NkNhUkUrVVliaUljdzJWOUFIM0pXaThJTHkzeWJrYVYybEFa?=
 =?utf-8?B?MytlQ0lMcEFPcm4wTFQ2dndlSkxuTEYwV3ByTHJKZFVOd1JMZWZobkdDcnlC?=
 =?utf-8?B?VHdjQUtTbXM5cXFFelVDNmtFOVBRZGZlK2pucG1SUGhBdy9JRFBFd1NVM1dI?=
 =?utf-8?B?cmNHMk5TekwzbFl0aS9ha1lZK0hZUXZmanp5WU9KVVJjaklkNVoxb2FzZWpu?=
 =?utf-8?B?NDB1cGJrZHBZd0YyRG1GemEwbHNNL0FJMWgzTWNHQlRycEFHSndGSlF1bFRU?=
 =?utf-8?B?ZWVCeGNwd0xNRjdlckh1L0dvNzFmV0hjbkxrMi9Cd0FTbDduNnJPb1I5b2hD?=
 =?utf-8?B?M05RT1Q1U1JDaG5jWnFLd2dDa01DRkEvaElneGplN0szeWYrN1A2Q1VXb2h1?=
 =?utf-8?B?ME11TldPZnE1VnptdEwycW9ienhxLy8zTFIxNUtIM1pLcWw2L0N5SkJlcHJ6?=
 =?utf-8?B?MWhqS2krMWxXNStxV1NpTU41MWl6NlcvN0xjWWtESThOUFYvREhVZmhrOFFY?=
 =?utf-8?B?RExxRXZqUmU5UEZ0WmtLK0hEQWZVRHUyLy92ZDlRSHYzNS9GeHNmSDIybHZQ?=
 =?utf-8?B?TzVWWFltV01xa3hhTmtTblgxMGxUSExMN2VwMzVZQnhzSjk0enB5YjdqOUh0?=
 =?utf-8?B?cmhrVjN4cnF0dCt2NEozbU5kS0F3SXNEU3dwdkVVVS9VYnpWaHNCR0l2b0ZL?=
 =?utf-8?B?WHV5MENnaXRTYVFCVDMzUURpcTJBT2hvenNGQU9PZEdjdHdFMlJqMjBqOE5n?=
 =?utf-8?B?NkU1VjZOcGVHZjJYUlB6b05jM290TFVSN3I2NmdjNmJFeUlpV3ZMWFNCTGVS?=
 =?utf-8?B?M0kvWFdJckl3RFYwR0NZd3IybVpiTUM4RjVQNk82R1NFSVNqMGpaMHRKdjNl?=
 =?utf-8?Q?uZq0kskD5wznLPfrGzO3b7NGk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd7b629b-9a58-47fa-ace3-08dd2f1076b3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 11:43:11.8170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5tpRvfhWcnEVrbbeQjqCZmpXcO6o1xXPhwhwvIzHumkmwxRMNzcnZBGQ9n64mXdCYfZItUHUJDABViXw5EOHNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5892



On 1/7/2025 4:12 PM, Borislav Petkov wrote:
> On Mon, Jan 06, 2025 at 06:16:25PM +0530, Nikunj A Dadhania wrote:
>> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
>> index 0f81f70aca82..715c2c09582f 100644
>> --- a/arch/x86/coco/core.c
>> +++ b/arch/x86/coco/core.c
>> @@ -97,6 +97,10 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
>>  	case CC_ATTR_GUEST_SEV_SNP:
>>  		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
>>  
>> +	case CC_ATTR_GUEST_SNP_SECURE_TSC:
>> +		return (sev_status & MSR_AMD64_SEV_SNP_ENABLED) &&
> 
> This is new here?

Yes, this was suggested by Tom here [1]

>> +			(sev_status & MSR_AMD64_SNP_SECURE_TSC);
>> +
> 

Regards
Nikunj

1. https://lore.kernel.org/all/bad7406d-4a0b-d871-cc02-3ffb9e9185ba@amd.com 

