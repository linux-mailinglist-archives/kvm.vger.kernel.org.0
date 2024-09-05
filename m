Return-Path: <kvm+bounces-25921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BF8196CE28
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 06:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C9E928A668
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 04:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002431547E2;
	Thu,  5 Sep 2024 04:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z0pz2LCj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8061914F125;
	Thu,  5 Sep 2024 04:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725510961; cv=fail; b=PCfcDVSc/0BuzlRz78ckDSTdc9CPYQfHQKxxKSzb22A4lXWaU3NrLum5aMKTstnMb+7akK528pdsjnGoJuOAVb4m9UM3cZ52rbQCSWk12JmaQ5jTBdeQqSpWrFXtNX434X9zeo9OcVkn+JyxiJEGTD9D53KuJsdGji0JAbTq884=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725510961; c=relaxed/simple;
	bh=T+U4dsbWKvc+BAGRouW6y6mJfJBMBICiKIdc0x99CW0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gqRVoNdJv+9cekjBu/Szw1T2MaKcnCyZU6kkGs1EnkZDSlr6JWbgvaGdt8qsqzQt+kdK36sK7vI/noVSP+FrFUDSY2nHXKQOYmWcG/5U1xxti4yJiD7VAuv7lBbXjLD81cQFjHzdTwqdlGl2yWEuVKWqCm5Kvq9YSBS56+UXVTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z0pz2LCj; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IF5NrinqanEmnYLEFZTmqJXRLLSLd0XINQtw6lX4GREdpHyhMWS9XOqXd+nrNjerw+Nn5olsAzbUONPanIun0nHmBj5+b4W5t/llbAdYkx/kC2is2AbU6qQDf0BXFlp39EqSDk1gO4rvidnHsBtK9NqN5GUs2PcnN9bETSpfwtWBrTJEyyO+BYefLO2TzyxDFIu8tMRFfqSnBVZGzx0n4x0pnb4SRhgHZoS16ZC06Mo4dU82gA9BPdl07SQ26bgh90/vlNvF3V+wua8m3lHTlSeHF5bmPwk0ctqY+l6Nj8+C1XcjVSg53XkeoPjGFZ+6xr2+PWzzovg1cWzHkzhlYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJ8aVFkgf3ouk9O8bQBgR7FbYJ3NRkUNE/ngGThzVWM=;
 b=dNbcDZ8H97t9fqFBcHKOEXqWSaM4Lgrv+0BehD/0Es0s9pOjFJ24x5LhXmW+ZD9PVYQezpvXgr9SWKVF0fQtq+EzHnd6+9Wz+PBiz7qGOH89gc94UFuI+1kfS6cDC9oAQL3HoqYKar9rPcN5RqySEp5iJTMuNWCZhU6d3vmQPQRyi1PzMJJ17E7xmQUEQSpCXcIrPjyxaUJE9vNtYStlvWr0p1N0phgcmG7TGKw1K/uaJyic//AC1F5/F1lcf/wrTqCrSXlAUZVwD1aDmr38Q6fz0P8ch/L5X6rQGkP6AiF7bjjXdafbBLGG4whQQTuTzkDJKIAZAUGNgkdBbwB7lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ8aVFkgf3ouk9O8bQBgR7FbYJ3NRkUNE/ngGThzVWM=;
 b=Z0pz2LCjy17/8kmVWaEjEd98y6sg0um9xsITBgPLBqsBm45k56zmNB9GzqQmolu9Qu2FzNPxUbcIhlHbWnU09jWpI2T5KCUfosPV7Flo2WDQg6PW7tLcGHxQx0mIIozPpjQUVkqfHmRUovVsgZQM588DKd9FBzLYkl8rzEnkIFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by MN0PR12MB5713.namprd12.prod.outlook.com (2603:10b6:208:370::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Thu, 5 Sep
 2024 04:35:56 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%6]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 04:35:56 +0000
Message-ID: <f0d9e9af-1017-953d-3243-facb2ee687b8@amd.com>
Date: Thu, 5 Sep 2024 10:05:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 08/20] virt: sev-guest: Consolidate SNP guest
 messaging parameters to a struct
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-9-nikunj@amd.com>
 <20240904143158.GCZthvXgYmvl0VNZVz@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240904143158.GCZthvXgYmvl0VNZVz@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::7) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|MN0PR12MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: e018a44c-04a4-4834-6e9e-08dccd643b7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUU5SEViZVpOUm5HcnFWa1JoRDFnZXhZME1vWVNGUmJSK3Q0UHdlYys0QVJO?=
 =?utf-8?B?RThsdkdIbEQ1YXlGVUlXUkswSDhKU0J1bXk5KzlGS3ptSGF5UEkyTXN5RUN0?=
 =?utf-8?B?dXZBRTUvOU9kZXpOZVNqR0JUZUV5Q1JwZDZZZk44d3hTMFlkbnRqcDdVbVA1?=
 =?utf-8?B?M0orYmtFaHc4aWorU1dtSFY2QW5yN004K0cwM29wUkEwUzhkM0xpVkJGWkFZ?=
 =?utf-8?B?SmNaRFMzSndkOTYrdFF5YURzbHRTY1FVWG9nUUZmMkhKTWZEbTh0ODBQQ2ZL?=
 =?utf-8?B?Nmd2dnRuZS9HZ3lNTldBbnFPZTc3aHEzVHZxODBhUEpCZGJzWGkvSmVXdnlX?=
 =?utf-8?B?c2laeXlFZ0VsVTI0ZUpyeW56bG13MStkeUZpd2dhT2ZEUktuaHVyVUM2ZUtK?=
 =?utf-8?B?bGZ2RzVpdzZGN1p3ZFhJT05kLzhFM1BaeWhrZUZqUkhnaEc2VUhSM3NORzln?=
 =?utf-8?B?NFR3aVhqTnhWSTdRdnpEOTdNWFlpUUZZVXZrWDhocTJkNTJ5a1hkM3hMcXRo?=
 =?utf-8?B?YmowbWNWSzdnNG5TMzEyR2dlR3VHK3RIZTdJNWJkbmtzSnp4L2xId0JFUG0v?=
 =?utf-8?B?czBBWGxtbkgvKzBEZi84ZTZqQ0tGdHFTR1JTeEdaYkpPMXIweWNrbnBmRito?=
 =?utf-8?B?TmQzVEJoaGVHcjMrL2l4UzlyRzhQaVBhSFBxQSszT2w0RDNBL2hvM0o3RTUz?=
 =?utf-8?B?MEZtVHRoNG9HOEgySjVSRU4vc2xlMFU0L3JFaERTN2xZUTV3QnpiU0wyY3lm?=
 =?utf-8?B?SUM3bGFYMEthNXVYeDlMTW1QVS9Rc0hCWDNSaHF0V29McTFpSi9jQ3BydXl3?=
 =?utf-8?B?dHBDbElhS2dIZkNvdVlDYjgxdkxXRTlLQUIxdGlISlAzYmpYL3M0Vy9EMTF5?=
 =?utf-8?B?TW9wNkxjdGFvbVVtRmI5Y0pzcURjaEZOeHZ1cGdYSDQxejRaTEFPQk5WcWV5?=
 =?utf-8?B?ZFpBTkZmVmlaOU1OaWRPRnJ6cEUyV21iN0tvTTBIakpoSjl2VEtQUUFWeDdl?=
 =?utf-8?B?K2lXTUlFbzNjeWpURlMrMVFIbUIvQXhxQ0ZRb2JHZDV3U1liWk5MMkdYNHpS?=
 =?utf-8?B?aERYb1ZqQm1YQm5acDArNm5zRTA1SGJsaXFPeGlQendEMGdIODQ4aDJKM05V?=
 =?utf-8?B?ZTZscWhqS2NmTGF2Unp2T2hrRnpzS244cUFibkVQZ3FVcmdwTjVEbUNYc2lM?=
 =?utf-8?B?amVBSHo5ak5Cbmw2MFBKOWlqMnRHUG5WaUpYYWFDYnRxS0wvMFR4Z0dpNnBl?=
 =?utf-8?B?YXluL2dWREFaWWpjRWV1cmFnS2JjaHk0N3ArbkROSXNCOXp5b2JqVmVubEZj?=
 =?utf-8?B?QTRuZS9Ya2o1OHlrYk1lRzgvRjFjaUdsSXIyZUpqMUNVWVdFVnhGMHdyMFVI?=
 =?utf-8?B?TTZOa0U3ZDR1Nkx4OERoUEJCWkhvR1RpWlI1STUvcW9LSUFYQmZmOUwwYnpB?=
 =?utf-8?B?VFp1blA0NEx6bkpuWVNlY3Q2d28zbnBYSVVxRGQ0NkZDZmV2SGNoTnIzK1lB?=
 =?utf-8?B?ZFQ5UzhkL0grL2tPVkl2c2MyNEt0dWQxZ0dhWkVSanBSY1dnLzRRZFZ5cHI4?=
 =?utf-8?B?ckxGNm55K1hsOVYxRkk0WTVoNkt5QmdKL3VUcGx1aUtZSTZtaHFnbDdGWGFP?=
 =?utf-8?B?K1RRSERqSjliZUY5ZkIrVTdibUhNdEx6WWFxNGxqMFQ4NTB4VXdud1ZZU3ow?=
 =?utf-8?B?NWJKalZTRHBibDB1Y1prUlMxL3hsbzZqSW5KTXRuMm8vZU9hV2t5NmRlY1Ex?=
 =?utf-8?B?OHNOTDVjTloxS0xhY3lZMHd3bElmZUJPdERNSGM2OUQrWUVXSDVkTUdiVVRU?=
 =?utf-8?B?eExYdVdpSzltcXNJQmZ6Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVBVQWJCLzliUmsrWjJlems1a0Y5RlVnQ3U3eERLcmFNckdFbDFaenB1NFNw?=
 =?utf-8?B?Y2ZCTVlOVTZEYTBmVzBUamJlRFJ1dC83USsrWnlydXNiUlRweFdWdjFRSm1v?=
 =?utf-8?B?TWhEem10RVpiWGJ2UktxMmpLbmVJSlpsaU85b2tpR1g1UjdvQ29PQjJrU0Vi?=
 =?utf-8?B?ZldIdjhXbGppcUQ0NWRIVlVyZktkZHpDcUhNK1k3eHRWS29lZ0NVTlZwMHhh?=
 =?utf-8?B?bENhNWhrVDY5Q0VHN29RK3d5M2U1NzFQZjE5eDJGUlprYWwrUzNwcmRTRlJH?=
 =?utf-8?B?R2FJTnFLM3pjSzM5aUgwYWwrU3ZlMXp3ejYyMjlRTGxRZDV3ckYwMmd5Q09Q?=
 =?utf-8?B?NVhmckVudXpoSGlMV0pmS2FDRWI0cXNjRE5jdThleUYxNFJva2twL2poVStw?=
 =?utf-8?B?T1R2dFI5NmU3dXhCWVJpbnZ0bFp4UmxGNGlrWnVCU2N0bUlhQk9QZEUrNHlC?=
 =?utf-8?B?M20vcVpyM09OQTQ1UzlWMXNjclRWTFpoWkxSYWxkd3c3YXNmQnhwc0xWQjUy?=
 =?utf-8?B?WG9SVGxOejN2eGQ4b3pGSlR4WFExYmVRRkpiNTdnZXdjWHYxL3VBNnUxaXU2?=
 =?utf-8?B?S1ExMDh5NWJoUVA1V2V4ZlVPbnczcDZzbVNlKzArRmNYOEt0VHVxZUg4VnF2?=
 =?utf-8?B?ODd0azFMTldOWmw4ZHFpclM1aVNEU1BJYnNXbVdvYjRWdllkclgzVDRnWXYz?=
 =?utf-8?B?N29YUGV2TDhWN0RPTXhTdTUwZlF3eGw3dmdSQzJMTGZLY2piQlZzRzg2Z1VQ?=
 =?utf-8?B?UHl0Y1dHM3ZhNDhPU2tNZitsQnVoeDJoUUxWODlxcXZkS3dhWnhSRm8wV1A5?=
 =?utf-8?B?b05LU1lubldsTE1tSjNsbnRXbEZMTlRUaEN6Q3FwL3FWRHAyQ1hUeFVoRGZl?=
 =?utf-8?B?UnA3SDVmZ1RvTi8xb0tYQTFvd3ovbzJNVm9id2cyN04rN2FETkJ1cCt5SkN6?=
 =?utf-8?B?dk1TK21YNVBUZllxNzlLQ0dtN21ZcWppNDAxd0V6cFIrK1R3ek1ibDlCNmdn?=
 =?utf-8?B?cU5nUEZaN3B5N05WelU3bGs0MVJXdEFpb2phMW44L2ordEp0dDdFMW1Rb2kw?=
 =?utf-8?B?NjUwMnlYR2RnSUN5SGRPUDlza2VrekpNSGdmRU5xSTFtMnVIMmp3cHNvWmlq?=
 =?utf-8?B?dzlaK1QyVlgrQm4yZm5ncGRjSTdvamR4ZzNZZ0JHT3hkclY3YkljYlM3QW1B?=
 =?utf-8?B?bXE4M2xZcHYxNFhtY0h0cDA4TXlYOWdZbnc4cjRFRVp4Vkk5ckZNSzVNMmZT?=
 =?utf-8?B?ZFRUUVY4S1FpeHNxV1VVZUZZOXdvcjN0dG95c3Z0eU85RGo3eVNMdTBBMVhr?=
 =?utf-8?B?WHJCU2Fmc01oMXZGSTd3UXZPSXJzdWp6NjhLWCsrNHdYdVpJQTB6T2lUSk4r?=
 =?utf-8?B?bU5uU3BLUnVQWHZURXFsb3B3RXY5ZXZRclZKazRGcDJmM2hHUnRyaUg4UVdn?=
 =?utf-8?B?Zjg5ZWNuVXNRekhKZzVZWEtLY1IrNFNVZmNYVzJqMHVBQUhNckI4eXdyWHlT?=
 =?utf-8?B?WmRLSWxkYTd1RktkNUtlSXI0eFRFNDZ1WkhjeWl5OUtnQ3dYcFgzMzY4WXVI?=
 =?utf-8?B?VkNwa296elluSUR4UWZocEJqelg3UWRCQzBFRXF1Z1QwQkRMK0dpejVHZFFa?=
 =?utf-8?B?VnF0ZFZoN3grVVNCMzM4OGs5NG1KS285Q1c0SXZYcGNRSE95czg2UGVMWXBB?=
 =?utf-8?B?elgwOFludUp3VmhlaHJJTE9aZ2oybmxmemRkdTVvdlFGWSt3TTlhUms5bC9N?=
 =?utf-8?B?SHZLUitRRDVrMU9YTkNrNVFhUHFEL0lGczBQWFc3VnBlczVkYTVVUUh0eHNa?=
 =?utf-8?B?L25NNi9obFFVRjFqZkpLQUdtNkQ3QjRTS2ZsdmI3UHhKQjRMUVRhUzdKb2FE?=
 =?utf-8?B?OGR5dUlnUGlyWTFlT2ZubHE2T1NGUDRyZzI5RTBkK1BZekRJbHptb1YwdEQ5?=
 =?utf-8?B?SW1nZmZuTHorQ0tqc3ZWOXRBUnA4Wm8vZGEva0xzWlRWR1NqYmVRYnNMNWI5?=
 =?utf-8?B?aFM4Z2k1SWljWGNrTU8rV1QrSnROeFlLd0MydEhoeW5kYVJMNHpDQ3ZjZXpW?=
 =?utf-8?B?RFpkaTRRNDFiYnBzbEhuc1hQMjViZ3FxNzZQM1ZDNzNzMVc1OWVyOXRJS0E3?=
 =?utf-8?Q?KFH7A2UbK6Mzaxpn09mp6Ye5B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e018a44c-04a4-4834-6e9e-08dccd643b7e
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 04:35:56.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2LEM0NeOI98SgdncJKmFxlgWt+v3xXr6gTpP87BiWSFkJTv+SXLCqem2TiqGZhLDXqwmrFi3y+EwNWu7co+oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5713



On 9/4/2024 8:01 PM, Borislav Petkov wrote:
> On Wed, Jul 31, 2024 at 08:37:59PM +0530, Nikunj A Dadhania wrote:
>> +static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>> +				struct snp_guest_request_ioctl *rio, u8 type,
>> +				void *req_buf, size_t req_sz, void *resp_buf,
>> +				u32 resp_sz)
>> +{
>> +	struct snp_guest_req req = {
>> +		.msg_version	= rio->msg_version,
>> +		.msg_type	= type,
>> +		.vmpck_id	= vmpck_id,
>> +		.req_buf	= req_buf,
>> +		.req_sz		= req_sz,
>> +		.resp_buf	= resp_buf,
>> +		.resp_sz	= resp_sz,
>> +		.exit_code	= exit_code,
>> +	};
>> +
>> +	return snp_send_guest_request(snp_dev, &req, rio);
>> +}
> 
> Right, except you don't need that silly routine copying stuff around either
> but simply do the right thing at each call site from the get-go.
> 
> using the following coding pattern:
> 
> 	struct snp_guest_req req = { };
> 
> 	/* assign all members required for the respective call: */
> 	req.<member> = ...;
> 	...
> 
> 	err = snp_send_guest_request(snp_dev, &req, rio);
> 	if (err)
> 		...

Sure, will update all the call sites.

Regards
Nikunj

