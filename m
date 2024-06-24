Return-Path: <kvm+bounces-20402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC01914DE6
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 15:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE3AB1F24365
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 13:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312A213D521;
	Mon, 24 Jun 2024 13:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5gPCyqmw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE8E13A3E0;
	Mon, 24 Jun 2024 13:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719234368; cv=fail; b=bCzStTtLFm4SDWjC/OMJof1cPKuLlkYSqCniKLMpX2d7zD6TUY1Jx3FR9YKbTmjb3iCvLAK4LHu8U6ACHfdmlfWc/Bp+G2QizqcE6S1eD1sKdUsGHcDE3zWwKMXxNIkY5y24PVGQIVDjp1CLP2pM36f7zPb1iyuXi86f0XBUbyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719234368; c=relaxed/simple;
	bh=yq70+FAs940xDB0QmMWuoq5XY4oCS7LDiihURrrk7Rs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VdbCQXHAQNB6mQLC/GK9FXBgXVd5+e3T1MOg9X4QZq6ODlPOuJhLsESIKRhFQuupAtKtEi1VME7gXICSPMkPWxIa2PG2GQ8E8ZkprjLkiBpxgIHu9Xk+QieiUjrxnkXMM9Kkxw6IIygtPb9yMDuQYQ28uW8z0FSqxhiC6z7rVNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5gPCyqmw; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDmh0OxiIqdmrB5tMM0agMQwWP9P2QWgxPFLmHv4DwljEerDMsm1AvMbxt+GnunlQMXYsY8np+UIhjVEASakNHWbc6Zb51m7/F+TQTGwJ3j40E7Vq2TYqtpBETLlEZHHcv69B/7EvooMBCJvCv6kdml5QKD1cp8/SsSDtJFWQrqY7gCUlZI8tfezWgzCiZ8aRtfCUiC6oIMU4Z8EXjtR5/TKTsZMvh2DFc9pGNVAEUuf4eQEnMn9UEnyUz3xrqjhbALXezqQELzxgU4hbvg2cFJ4kDU1nEJZnOuTFE4bS96s9IWBCjdJhagwYgGPlg9vWscka+wkJpozLtDcoHYe/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7b/atPWWuGnuXpc75P09d7FFuYaHLG5U5wIQQpwdBk=;
 b=YP1X3Hdj8QgLwYd+LLQkJfd5mNadUIIu2C/n8ciU6lxGvbDjFFWr+054+IzmUPRFANdeUGR4W/PXP7xXMO4n3/SVmZUFBRHpIE6nn5KHts8UbgV/jmoBDRyeNLoLQv5MGm+435W14MQ8bhLpozSyJU8VgBCtCRcBEoQnfTNMFkTIA7axVODIXuidCakc1d/ZXi6IT3u/di7fxAzikkZla6nBPNh2YuqaQZSEyUehDnswFd6FfCWiwZ96igKNSspftq0uesS9v5Vx26P22RoTbloKyWWnuW4llqx8BoEiz4uq8T99EwzaGs4fdpnUwmZto6GgReJ23CMZ4fncJyRtcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7b/atPWWuGnuXpc75P09d7FFuYaHLG5U5wIQQpwdBk=;
 b=5gPCyqmw+zV5+3yHqid8Q22yTBUROUWU4quTCBwwaVNlonmAkMjsIvxtl0fubkblzdj9yHC9leritR/eQyqw+PUYkl6LX47VbgUWS3K1x8F6FqaJ3CnRsE6y/UkP6+Ky/HdlY4zrSNMfVPJ3ExmSHqS9ikH4NYyUUNSNHNsr3lg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SJ2PR12MB8979.namprd12.prod.outlook.com (2603:10b6:a03:548::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Mon, 24 Jun
 2024 13:06:02 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 13:06:01 +0000
Message-ID: <545135fe-adbb-bf95-5b60-0646a76afaef@amd.com>
Date: Mon, 24 Jun 2024 08:05:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 3/5] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
Content-Language: en-US
To: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>,
 Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, jroedel@suse.de, pgonda@google.com,
 ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com,
 liam.merwick@oracle.com
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-4-michael.roth@amd.com>
 <daee6ab7-7c1e-45e3-81a5-ea989cc1b099@gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <daee6ab7-7c1e-45e3-81a5-ea989cc1b099@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0019.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::13) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SJ2PR12MB8979:EE_
X-MS-Office365-Filtering-Correlation-Id: a8b19cda-454f-4488-95e4-08dc944e6567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnpJSUVwU3B3UnRhWmxlVEx2M3l4MWE5OTNpZkloWW94M0ZJNDZUR3VQdVFG?=
 =?utf-8?B?RWZZTGp3aDRqVnZaM2hPalJQb2lOWEwxc0FMYklCcDZjT2p1REtRdVZUT0JR?=
 =?utf-8?B?WXFBd0NoRUsrZVU3K1hPSytsQTg0VUNDQ05ZMnp2S0t5T3NLU2JOMTFzYW04?=
 =?utf-8?B?ODRhcnJiTmJIbGdqc1doNk1Cd1ljeW16dzVEK3NGcjRYaWpld29OUUxmZVRO?=
 =?utf-8?B?SWxhNlhqTTNsOU1EMWQ5eUJlcEFvQVFFVFpMb0F3cXNPcDRYZmdYaDRZeXFW?=
 =?utf-8?B?U25Xc1VHdS9kcEYzRmdYUEx4cVlDdGw5QTFsQlNNOHNSMU9tdGdURDZ5czhP?=
 =?utf-8?B?bEVkT1I4LzFDUEdEV2IwOElzMmhFNzVHa1lRUlR0NzZvczl0TkI5UG1WUVVn?=
 =?utf-8?B?cENjUG5kM1ZUNmJDNStucmJiWmR6KzZ1bWZwcm1EWlpHeWpUdGNGMnJqWXFD?=
 =?utf-8?B?ZUE2Zzg2ZVU4c0FLZmhWM1d2UlNPYjU4OHFTN0VJVCtnb2FXMkRZOVdJK2hn?=
 =?utf-8?B?QW50ank1TFl5cjJORWlKSFl3THVoKzIwWHZoT3U3UVRxUGFhQktVb2VCV3d5?=
 =?utf-8?B?akhEYVE2b0VzcEdqdlRzVzRMSWJCblVtem5wZ1dJdXl3RldiaTVCSXVXbEZM?=
 =?utf-8?B?NEZnVWh5WjAydlJBcHJvZlpWZUhsSlhLZGQzNHFJcjcvOWhkb0FYT0hKUlkr?=
 =?utf-8?B?cXh1dE1zbUhQUWZXTjVnSnRkRWM2R0hTbXAwS1Q2Wm5zNys1WDBIa3BFckhK?=
 =?utf-8?B?ZGgwZUEzNDY3Wm9CVFNnbk5hdDZqaVJSUWxkVzh1S0V1SjNQcGhmUGVCZWQ1?=
 =?utf-8?B?SjR4YTUrN1VvSHZyamFSQ1NjWDVjT0RCN3ErOEppaXpFdkE4RjRXY2g4MUdN?=
 =?utf-8?B?NmZvZ0RjMnQzVXJhTFpwVGNZQm9Xd1FCaUk2Qk5PK3N3cUVZU1Jta1BRMDRp?=
 =?utf-8?B?dDlFUkNVVDFqVk1oWEFULzZ6MFhNNEl0Tlc3UU5mQkRXTzFabWtsNkQvYWZK?=
 =?utf-8?B?OFR6NUg5UzN5eXhlWVEyMlV5L2VTVXNMOVpRSXlZVkJOcDZLOGFwUS96QmtT?=
 =?utf-8?B?OHVZVDlKM3RRQUNRQ0xIUHA5TEFrd1RzVWhUUTI5S3Z2Qytwa2ZVdXlGQUFw?=
 =?utf-8?B?cE9jbXBVb3BZUENmempsZndVODZ1dGN5SWdSblR2YWw1eU1VZmI1cHFCcGFx?=
 =?utf-8?B?SURlOTlmalRBZ0w1WmZmbGxiWkJUeUlXQ2VXaC8yakdCSXpBekxKVEJWc2FS?=
 =?utf-8?B?alAxcldndVRjNEFmc1J1dUduSlN2OGdWWVJZaGprUDM3TVZON3VMdGU1RkZm?=
 =?utf-8?B?WXhNZjc3WEVkVHlNZXZhMWliQ0lYQkRDMDVhOUhZRUFXWDlZSkphRHN0VU5H?=
 =?utf-8?B?YmJmVnpNRVgyVjhJSTFhcjZNVExkSmRGSzYyQ3ZnT2JMVm5vR01US2krWVAz?=
 =?utf-8?B?cDVCSFVCaEFkTGpEMmJlakRaaTRDOWc0S2h3TVhiT2xHSjN6L0FyMnQzWlRF?=
 =?utf-8?B?TjJuR3dqUndWb0ZqcHNjNzlsS2dleUV5ZkZ2dHZHNDBoa1Z5UzYyTHZuNlR2?=
 =?utf-8?B?c1l4bWwrMkdkdDhYeFd4Qll3aEprejIvMWYvUmRYUytBTVdIcEwxeVhFOUFw?=
 =?utf-8?B?MTdYNGNsOG13Q0N3TFdMMm5yUGZjOEJVRmUwV2pRQmwzM3lhcmxyaGh0SkMw?=
 =?utf-8?B?cy8rVkhuNUxnenBLeU1MMkpmZkxacHFRQnorblJmay9YNVRpeGZMSS9JcElB?=
 =?utf-8?Q?VLpIyoDhs81iiDDyMjj90iSVyPsM4Tua2sIZIbh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmtzUGt2ckVVakU3K1VFTWNXeGhpTUtQd21oelBWWnczVTFLY2hXSk9ReU5x?=
 =?utf-8?B?T0xwblcydzZtQk9uRFV3ZlRxNzd0WHJUQW1aazlzU3FEM3lVa0NvdWhlcXdo?=
 =?utf-8?B?MXZRdlQwTlFrVlQra0psNEVkdnRCblVzNGs4TVM5SDZIOFJ3eHdaekF2aGJn?=
 =?utf-8?B?Rm1TTVBpS3gzVjhDY2djZkh1K0cyUytrNlZGYS9GT0RNMXFKb1FjaGQzalR2?=
 =?utf-8?B?MWZHbGxCMXBuNXhsRVUxMmFrbmlEU1k1b0VmV3VWOUhjS0RqUDBPdzU5ZXEz?=
 =?utf-8?B?T0M1eTRpWDhSZjlYOVlZa0JaM0VYcDFiSFBjKzVvUG1NMnNFVXYySXZrYng5?=
 =?utf-8?B?bk9scTgySnVnMm9tYTRmMjJaUzV6VTY0WVo0RnkxN1VFY3BWeG5MT1BEMHRF?=
 =?utf-8?B?eGVDNHl1RFJyc1Q2My8xT2RYN0hWWkczTlVZQjdhVWhVelZuNkNoUmo2ODhy?=
 =?utf-8?B?UzhmMjN3cjdhdDdvUFdWdjRidmpzd2FwZ043dGVXSnRWS3NjUXYwTFIwazRL?=
 =?utf-8?B?OVZCT2x4eVM0bUErcmJuUTZKOWRFcjJDNGYwQm5GT1RRcWJsc3cwTzdSRlpz?=
 =?utf-8?B?R2ZWcnliY3NGa3E2RldBN2I4MHRHWnQyd2V5aG5QYmFwaVRGckpGNVhBRDJx?=
 =?utf-8?B?UmlPNUFIUWtVdGUyekFzdjZGODhEQ0haSDZPZkVjR1NDWjRRdG5TaHNnSHhY?=
 =?utf-8?B?cFlqZzlUN0d6amdrUWlsQWg5NUtiWXhNVVFRTCtZYlBKZktlOCsxSWFwaHc1?=
 =?utf-8?B?ZnJHUUFxVTB1d3J4eHBseXpuWlhHaHB3Y05tNExmSnFGbFdrdUFYMWtmc2NR?=
 =?utf-8?B?TnRxbUQyZzdKYitWT0xnM0dkMUxxNytBZkNFWjAvdUVGMUtkVW8rOEpORTFB?=
 =?utf-8?B?Z3NoMUoyVEpHd09lejdOT052MGhWTGZJY2FTR3M1UFZvTm1rS0dDVVRYL3Jy?=
 =?utf-8?B?REFQRDZkNEcvOWRub0dIQklzS0VwRUJyZ2N2N2xFRUpEOWZZWGVHNlRoSXJi?=
 =?utf-8?B?cE84YysrTFZQUTFmVWFUMHdkdFpHd3MyeUJvN3J3ZHJXSXNzUlhrUXFqY1RD?=
 =?utf-8?B?dW5qRDFtVHNqRmdQK0haZllQVlM4MFVjNUhkaFB3NkNqVzYzV1VidkJsaTBZ?=
 =?utf-8?B?SUx6OERVaVQ1bWhnUjR3OTcxTTNjazJnQjV3Z0I3b1p3dDhSdzd4R2Z1dHVt?=
 =?utf-8?B?b3E1VDM4Zncwd21taGYyOWgvL1o0OU5LOWUweWZCV2ZHbXZZcE1LUjNJMHFI?=
 =?utf-8?B?N1M4TUJPVjhTWmhrNlhhQjZXZUhuTFNIZEFaYTZrWEc0eE83aW9CWVZtdjJ1?=
 =?utf-8?B?eCtJcTEzempRVDdDS1Nta3dCUm5MekFtbkZwLzBXcW9acGhHelJxZmlibXkr?=
 =?utf-8?B?UlJHZ0ZWbmpqMndSRmROcHpkNVhTWVpsUzNWbS9WWnZBK2dPZDQrcy8rTW96?=
 =?utf-8?B?Q2ZKOEUzV1BiUTRnWFJEOGhadjVsWStYQnoxUVNKTnlsMENpQU9sY3gycmtY?=
 =?utf-8?B?b0l2eXAxc3FBSGlGM0xSZ1JLRWlWc1VoQjhZaXNuWmtyUlh2QVJqUGtpSGlU?=
 =?utf-8?B?cUxBYjdldzBFT1NDdlJZUlFWMncyUHJYZlFDTlZmY3NjNDM3MjlZYTErb04x?=
 =?utf-8?B?WWJYendScHRHWmtrM2NTU0lyK0Y0dmE0YkFUeWhKclNsVFVoMVljOWhEQU1W?=
 =?utf-8?B?T1k4akRZNk5EV216aWhrd2JZcDd0MzJHd1pnUG90a292UWNRV0JWdU11NEVs?=
 =?utf-8?B?YjNQMFBvRFJWL2Y0NTJDekIrRFArU3JJV0FpQVJVbFBEc3J5cW5Pc0QrTkVB?=
 =?utf-8?B?TEVUbjllQy9TbEdpZUpQak0yVmkrdFNPc0hLanhnZ2E2QnVWSlJ0NVNHcHF1?=
 =?utf-8?B?VWM0MkczZ0xrZTZudWVlYTRrTnY4RXRMcU9wMDhXcTVzZVJuTGU4VUVRVzA5?=
 =?utf-8?B?ckkwNDNoekpsMEtCcmI2Z0E1QnNCT0dEdUwyTDh0d1BXdFI2Y1JtMDBSR2Z0?=
 =?utf-8?B?dmlsajdkYkRyN3ovWnRPS2dkZ2lDNDAwUFpTR0dHTnRtU2Iwa2hHU0MyeXpt?=
 =?utf-8?B?QUVCZ0Q2NDNQU1lGYVpxT3JyWmljTXBKTy9wKzlXeWIybiszWnZ3amVkaXI0?=
 =?utf-8?Q?jjOUTcSRnC+ko91utmCzvpHyI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b19cda-454f-4488-95e4-08dc944e6567
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2024 13:06:01.0974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G4+lmTO/VPbT2Ocde7Ot/gI5UajmBCbSo+uDoZil1Bd567ZHxBrGD/CU58iq167NVLqBqjZ0Ulx/0yAbMSyAHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8979

On 6/22/24 15:28, Carlos Bilbao wrote:
> Hello folks,

Hey Carlos,

> 
> On 6/21/24 08:40, Michael Roth wrote:
>> Version 2 of GHCB specification added support for the SNP Extended Guest
>> Request Message NAE event. This event serves a nearly identical purpose
>> to the previously-added SNP_GUEST_REQUEST event, but for certain message
>> types it allows the guest to supply a buffer to be used for additional
>> information in some cases.
>>
>> Currently the GHCB spec only defines extended handling of this sort in
>> the case of attestation requests, where the additional buffer is used to
>> supply a table of certificate data corresponding to the attestion
>> report's signing key. Support for this extended handling will require
>> additional KVM APIs to handle coordinating with userspace.
>>
>> Whether or not the hypervisor opts to provide this certificate data is
>> optional. However, support for processing SNP_EXTENDED_GUEST_REQUEST
>> GHCB requests is required by the GHCB 2.0 specification for SNP guests,
>> so for now implement a stub implementation that provides an empty
>> certificate table to the guest if it supplies an additional buffer, but
>> otherwise behaves identically to SNP_GUEST_REQUEST.
>>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 60 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 60 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 7338b987cadd..b5dcf36b50f5 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -3323,6 +3323,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>>  			goto vmgexit_err;
>>  		break;
>>  	case SVM_VMGEXIT_GUEST_REQUEST:
>> +	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>>  		if (!sev_snp_guest(vcpu->kvm))
>>  			goto vmgexit_err;
>>  		break;
>> @@ -4005,6 +4006,62 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
>>  	return ret;
>>  }
>>  
>> +/*
>> + * As per GHCB spec (see "SNP Extended Guest Request"), the certificate table
>> + * is terminated by 24-bytes of zeroes.
>> + */
>> +static const u8 empty_certs_table[24];
> 
> 
> Should this be:
> staticconstu8 empty_certs_table[24] = { 0};

Statics are always initialized to zero, so not necessary.

Thanks,
Tom

> Besides that,
> Reviewed-by: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
> 
> 
>> +
>> +static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
>> +{
>> +	struct kvm *kvm = svm->vcpu.kvm;
>> +	u8 msg_type;
>> +
>> +	if (!sev_snp_guest(kvm) || !PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
>> +		return -EINVAL;
>> +
>> +	if (kvm_read_guest(kvm, req_gpa + offsetof(struct snp_guest_msg_hdr, msg_type),
>> +			   &msg_type, 1))
>> +		goto abort_request;
>> +
>> +	/*
>> +	 * As per GHCB spec, requests of type MSG_REPORT_REQ also allow for
>> +	 * additional certificate data to be provided alongside the attestation
>> +	 * report via the guest-provided data pages indicated by RAX/RBX. The
>> +	 * certificate data is optional and requires additional KVM enablement
>> +	 * to provide an interface for userspace to provide it, but KVM still
>> +	 * needs to be able to handle extended guest requests either way. So
>> +	 * provide a stub implementation that will always return an empty
>> +	 * certificate table in the guest-provided data pages.
>> +	 */
>> +	if (msg_type == SNP_MSG_REPORT_REQ) {
>> +		struct kvm_vcpu *vcpu = &svm->vcpu;
>> +		u64 data_npages;
>> +		gpa_t data_gpa;
>> +
>> +		if (!kvm_ghcb_rax_is_valid(svm) || !kvm_ghcb_rbx_is_valid(svm))
>> +			goto abort_request;
>> +
>> +		data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>> +		data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>> +
>> +		if (!PAGE_ALIGNED(data_gpa))
>> +			goto abort_request;
>> +
>> +		if (data_npages &&
>> +		    kvm_write_guest(kvm, data_gpa, empty_certs_table,
>> +				    sizeof(empty_certs_table)))
>> +			goto abort_request;
>> +	}
>> +
>> +	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
>> +
>> +abort_request:
>> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
>> +				SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_GENERIC, 0));
>> +	return 1; /* resume guest */
>> +}
>> +
>>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>>  {
>>  	struct vmcb_control_area *control = &svm->vmcb->control;
>> @@ -4282,6 +4339,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>>  	case SVM_VMGEXIT_GUEST_REQUEST:
>>  		ret = snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
>>  		break;
>> +	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>> +		ret = snp_handle_ext_guest_req(svm, control->exit_info_1, control->exit_info_2);
>> +		break;
>>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>  		vcpu_unimpl(vcpu,
>>  			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
> 
> 
> Thanks,
> Carlos
> 

