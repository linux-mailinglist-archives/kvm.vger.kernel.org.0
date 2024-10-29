Return-Path: <kvm+bounces-29923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 746799B4165
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 04:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2927B215BA
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 03:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEFB200103;
	Tue, 29 Oct 2024 03:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OYDsz1uu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EEB282FB;
	Tue, 29 Oct 2024 03:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730174208; cv=fail; b=Rl98+i8XkNQclqFB5oXK2rpm7HScvqHHgCUhebkub4M+juXYYc4icKM8UKyQWrx6Hml5EEBz0ujQNX/Wlm0ACtkAvCRENgNlm5wg2gw6Qbj67Kgvwadw18lO7neu/oDV47pGPQMi8dAsGPgDe+Z+YsS45NKD1gIkzDPKCiKBhzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730174208; c=relaxed/simple;
	bh=F8Vr6Ktm+ZX+bikzvI46EDyjN2C70bA5iUytX1M6HUk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JU2w4f9w0y6oEMAm8GVFaBJOfXt9M4bf5rPj4/Ob1ST+yfwGK3DdbikfnQ6lQcIoGrrQrS3EAZdr4HK2YW5Vxr0HOSvu7ltS5PofVa4lZg80hm0yRhUX+gcUiMdW/dU4vA7H4gwdRoj/z/+L27mmFi1O4DtvH2tw79H0WdJN9Ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OYDsz1uu; arc=fail smtp.client-ip=40.107.244.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BfChYX0AGU1XNLCmbG+5MAuJ8KSaoWxPmJL8Rr/b9nhNPVxL7aRfszhFLugj+QnO/bpqPQQjCTOy3sfIIBZ6gcSuJeKcvn934D6IRtfpnpPznYS2D+GuqMJufRpyz+5jXVMr+IpnC/OtXlwQUOvy/raTz22rJ4VH2+QN5Ojy90eBwy5ZUirFJViSUbTduC2msZ2bmrJGL8GEAuy49gfvQsXmVtFnUxd1/TkK2Kb8I/K4jZEeRYGy9r/cl9+CFsPKHmTeaw6Rs+P68zLT1QAAv9zPgSdMsQRXNf2os3fTd95xIDrB8WpHWsw1d9pFBalnDceHn9ZxEJnhwRr4XaF/3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dqvv60JqAI0Fz7XPX5GEC22AGogFfqiIlPRkopycZco=;
 b=gJtLZ5OPv9/yvJWCRyk7JEJjHlJ5rLGzBtJVvVwqVexjmDU8fLSYaZ1RPgsYHJmqvndnlxXNKwQMnPLSklO0B5moYWxlRfQ6r0uX6guy1aNF3GjlO66Z5F5vQ5+Fs+k2s1VCCxMvYqoIon/Da4D+jaAovCap9DNm9J3QKm0ReyYywwJ123AE8d3CrcgUey9tEOkrpm0Y7HWzi36dSaVXim+7l7dEgij0oOwoIxTs6VrCR6VyMwK1jmtDDt0G2TYT6sAphjZtOrDapsXFIa4cZLkmIbLS0JXsWVU187BSgFBCgrgdxt4iD6Jb5C+hvYbz5O4b++d6pInTP7MwuCfB1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dqvv60JqAI0Fz7XPX5GEC22AGogFfqiIlPRkopycZco=;
 b=OYDsz1uuPupwh3tRPgS0eMUaP9vJDcanLh6Uweoyi2ULKx9llk8KHANDW8/RQaEcP9b5AaXDLO3w4j/DyOk480Cy9Gb2iUQ9rb3xqiD1KFXM8WlD+x/NHjUlqIljqtUDzLSa46EjkNYE53kcFpoZ1ocdAci3q8goAGNje+x0/4Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN0PR12MB5715.namprd12.prod.outlook.com (2603:10b6:208:372::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Tue, 29 Oct
 2024 03:56:41 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 03:56:41 +0000
Message-ID: <ebfae76b-1a4d-175a-e0ab-91319164e461@amd.com>
Date: Tue, 29 Oct 2024 09:26:32 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-10-nikunj@amd.com>
 <b015fb9c-4595-49a9-afde-ef01a45e15d1@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <b015fb9c-4595-49a9-afde-ef01a45e15d1@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::26) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN0PR12MB5715:EE_
X-MS-Office365-Filtering-Correlation-Id: 25afb5a4-9e1f-4d0d-7dad-08dcf7cdb240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THhNdDBmZ2tFdUtPdWNlNkxqVHcrTW5ua0NJbGN0K0hQRndMLytaY0ozN2V2?=
 =?utf-8?B?Z25rMytQWk95SEhoOGdSL214NlJZR1pIYnc1YnhzVm0vWGdVUUlVNXU2QkZm?=
 =?utf-8?B?RnFtb3EwL2N1eFpOaFN0eHNSZjI1TTd4d09DTDllQWVIZnFlRm9RdVJVT2g3?=
 =?utf-8?B?ajQvWnZRcG5NQ21pSzNkdEtqV0didW5sWGdQaVpIZGZIMmNFcTJwTlBGQ1hn?=
 =?utf-8?B?MWkvUUhJWTBCZGxVd1pUSmcrMVMzSTNNNVlCNDNJd2NGSGhuOGFHUjVMcTZV?=
 =?utf-8?B?ZHAxbjFwejJUdXpFQzkwNWlTZWo3WWdoNVo2aDE3ZUJsdkpnUkZTWXJ1WmtY?=
 =?utf-8?B?b2d2SnJqcU1pamdtSXBHOEtxSk4zR25Tak4xWGVqZ0pyMHhlcktUWFB6RUJR?=
 =?utf-8?B?R0lpOVlsVmVFV01iWGxDenQ1ZUFKZ2pkL1Y5aXgxM29UL2hYaCs5ODJGb09N?=
 =?utf-8?B?Si9Rcm5mSDU4bjhYY3FaOXA3andtZkFNRzQxV25KNGY2Q2VMTjh0b3hEZXRh?=
 =?utf-8?B?VFB1cVZGczlQd2dvV2tNbWlsUEpWMXdqVnpTTWx0SFlPNHRxeVFweXR0L2dq?=
 =?utf-8?B?OG1QNUNzZTFkSkwraU1NTVNaaE9ySzRMZ0JvRGZtb3ZhSG1sc0FXek0rTmdz?=
 =?utf-8?B?Nk1DdFo0Mmx6Q0dSTG1TT3A0elFwR3drRVh5Z1FyeFc1TE45QVFMWXllUnd0?=
 =?utf-8?B?bmhOWVJrcTZtdkhPYTJKd2hSQVZHcjhnK2twaDZBZWtQM2g3ZFBPRGhVYmli?=
 =?utf-8?B?WWhSWlpqNk5kSE43TGtTVElCRTcvc0FQSkFCMWNCd1dDcENKK2ZrM3BHei9U?=
 =?utf-8?B?OHh6WWVDeFJURFJKaWVzaUFLSXhtNXh6NzArdDQ5c2llK1JNMjdlczJuckor?=
 =?utf-8?B?V05oOEpWY1BDSGpLYmdrUWovUkN0c3ZQRHl4ZE03VlY5UFZ1TGNEcEVvN1pu?=
 =?utf-8?B?R3d0WnF6Y0Q1U0YwaHhLdEdITTZGQk96YU1xSitJS1NEWStkeDk4cDdOZHFP?=
 =?utf-8?B?UmpKbkRORG96WlVVR3Vmams3Ym1xK2c4bXZ5c1hsOEJmeElYaFVrVm1lSThi?=
 =?utf-8?B?N1IwcmtXeVhMK1hJYVlEcGlFVjcvNzl4QklteDFWV1QvSTl5bDhLVHJ1dUhW?=
 =?utf-8?B?RFpEQXdTenBVWjVJNThpVFVFdEYzRGhhb2tPOU5LVHBMejBGSVljQUIrOTk0?=
 =?utf-8?B?QWJpdlEzc2VHNGFoQlo1YWp1T3hXNDRoa3MrSm5RODZIV1dXOGV1Zk1TNnN0?=
 =?utf-8?B?dnBTeHpDQWo1dlAwcTRxQ0QweDc2cEdLaG96dXptZVRuQ1IyT0ZtOWpSUGhF?=
 =?utf-8?B?eDg3dVQ3MEE1ekxRMktuUGFnUTVVK3Y3WlZiWGNrdXVNbStJZk1MU1ZvVHZm?=
 =?utf-8?B?aGc0YzNDSDRxdTQ3N0xBK3oyY1JHc280d1dwQTBSbVppbE1VS3BnU2ppZlFp?=
 =?utf-8?B?ZEN0K2F1R25MTXlINm81RndGWUNFRk5VZDVjUVRFOUVRaFBKWGYvVWhDcUJp?=
 =?utf-8?B?R3FrWnFFTHFwM0d6M1E5YmRwV3BTTjBaYUxLRTJXMzI2VU0yYzhpaUxLWC85?=
 =?utf-8?B?WGprWG91ODhzajRENXdVbnBUUVpCTTdsbytIcm1qa3dCWjNyeDVlZW5RU2Zy?=
 =?utf-8?B?YmsxbzE3QmJraFZMaCtpdDJqU1ZyK1pSVG93Q0ZvaHRmaWZDUThZa3FzczFj?=
 =?utf-8?B?ck9tUnRleExEU3hYMHg5eUxkM0NmZjBzSHF3VXNTSys0R1Q4blA2YktaQ1BV?=
 =?utf-8?Q?AmgWlUd0T8IMR5YJk6RGIOi5SH5k5vNwihWz4D7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U29RSXRvYVRwcWVDMkpzWWJMNXI1U2JKUFQzZnlaeFJnb1o0YkxQdmRZSVhP?=
 =?utf-8?B?ZDdzK3kvcUtwMStPMTU1RlFQSDV5SmxOdG12aHV0cy9Rc25LNVBITXRkRTRE?=
 =?utf-8?B?ejNNb3NlbEc1dUQvc1poS1IyNG9uYnRTUXFLQndMVlRlUFJMQW4wWnhmWDFk?=
 =?utf-8?B?KzFCVjlzR0N5NEJYUHdkY2pYeVY1VHova2Mrdis0L0VrNno3Sjdyc2xnSGtL?=
 =?utf-8?B?MXRIRzl6SEZUQ0h4T2lvZjlBZ3lVWUNXUWJwemVwbkZ6Nk9JNkhOcU9qc2Fn?=
 =?utf-8?B?TXlPTnVUMkZqNmxxZGZJaUhRZDdsM2wvcnpmTnJNVTZhVUJBSVRqZk9yYzk5?=
 =?utf-8?B?K0EwWGRQZ3JlR1BVN1VYVEFLeDAweWJCc0dRSDUrTUtib0kxUEY3emR2RitK?=
 =?utf-8?B?bzlnSXhVU2VHS2RISXN0akIwNVArbFBWcUV6c0gxVWV1Vi9wMkZReklLMlht?=
 =?utf-8?B?ZklHVzE5VFM2MzNDbUpzNnNOUVE1NDlTb1FyVDZtY3FPLzhqV0t2VkFXNE12?=
 =?utf-8?B?dm9lUWZNNGtqZTdBbVc5Rm9IZkdCSFN4MFM3L1RaM0l2MXhrRklsNlZoTVJG?=
 =?utf-8?B?SklPa01OZzdlWXNrRi9uR01PbSsxN29QZVc3dEJUYS9JN2FYemF2eWFyQ1ll?=
 =?utf-8?B?OHZtcFNDR0dOTG5UY04rcUVLY05tZi9FbXRINnRBakltcjc2V1g2VG93Q050?=
 =?utf-8?B?Q3Zib3BRRTdQNEIxTWVNdWdiQkRsVHZodmZZQnZUajNsdmEzcVNneHo5RkdI?=
 =?utf-8?B?MG1CeUs1VVYrRVNHS2gvMGdKSGtsdlllUEdLMHU5VkVSb0MwR2NFYllhemtO?=
 =?utf-8?B?aWFIZzk2RzkrbXZwTWdybENLZVkzMCt3SjVud25xYTY4V3lsSS85bzV3ZVAx?=
 =?utf-8?B?dVEySjV4YjlnSzZrZElnTStVWFVSWHRSM3lMWGlnL3FDek5DdFkzNmZGYTFa?=
 =?utf-8?B?OWgzWEtPckV0MjdlS0pTcjVmaWhtWXZiZlVzRHlNL3pROTI3OXpzek5FS3g1?=
 =?utf-8?B?dzFLVy8yamFzZnpGcHZ2VGxzZHJ0eFF3ZEhEMGYxa2JzSVJwY2ZnUTFEWk9T?=
 =?utf-8?B?N3EybmkvbVFqUTRkNGJOTWpsc3RkRW5NTnJtSXNIRElrc2dydnBuS0FwaG5w?=
 =?utf-8?B?d1dEUHdVOG40UnJmUjdnNHJsdVIvUkFIVjZldytVNTlhb0V4NkZGVktncit3?=
 =?utf-8?B?eU4wUVZYaWQ2L1AxMmlONGNhZGlaSnJWWEVDVjJaN0F4N2E2eUliMjNJY1RQ?=
 =?utf-8?B?S2lROWdQN202RkJBdXc4UFd2RFJhbkYxNDZ4b01ubWZWWWdMcVhCemQ4NzNY?=
 =?utf-8?B?emxsSlkyK2hCRlFpNG4reGdaeDV2ZXFCRWlCT3QycHdpUnhua3R6cWdTTXMy?=
 =?utf-8?B?blhueEtJc0JHRzlldXVsRjFyK1Q3SHNGaGkzbDlUYkxOTkhEWGwvWUs1MkY5?=
 =?utf-8?B?ZElxNXZMZWhmMzhkaDIxLzk1TVUxb01IY0xDemMvUjVTcEU5WWRzd3pvWHJG?=
 =?utf-8?B?dVptRVBCM2MxdHdMYXlOVEtwK1ZxMXZ3eGVWbnF2M29oK3N4Zm9MY01zQmdX?=
 =?utf-8?B?ejlGN1prVnNJelZ6MDEyRVFNTzJXOEhJNXByRjhHMlB1dk5YQ3VIT2REd1hw?=
 =?utf-8?B?M2l3U3NhZnYxM3k3enMwTGhEY3lmWk9BUkdOQ0VLYUFQQlR6YlhDVjlxNUFs?=
 =?utf-8?B?RnJUek4xRlRsN3oyUFJKekJ4WlMrMXRxV29CY1hBTVQ1N0s3NHMxTmRTNmxy?=
 =?utf-8?B?NFY5b1dqeGtpN0Y4dUNJNTBZb2pQOXg2dzhaYWlBaU0xaTIzSUN3NDlXVk1Q?=
 =?utf-8?B?VVJFYUJWTVpHMVAyUEt0MnNIZ1ZKTStYand2ODlyTzVQdXNPU25ORGtCUzJS?=
 =?utf-8?B?RTVtZjlPM1BDOFpTQkJKem9zZHROcnhPOCt2aFRSQ1ovM3ZiTy9ISVFVUy9l?=
 =?utf-8?B?ZmpKWXdIN2ZOa0ZSTGhoN1RGZmZrcnF0ci9qbWRhcEpmM3pSRUNveTU3VlRP?=
 =?utf-8?B?em9OSzlqekNLYVd5ZWxkVGNBdXdXZWlLaEs3YmJFQkI5LzRXTWpRZWkwVk1t?=
 =?utf-8?B?Q0IvMmIyNnQ3WUFRYndxSzJoYzhnUlkyUDJoeHJETTRPSDM3cDcwTEgzRGNa?=
 =?utf-8?Q?haZnpznyREQrUsuMWJ//suEYq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25afb5a4-9e1f-4d0d-7dad-08dcf7cdb240
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 03:56:41.4111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0uZWA/BoH6X+HukRNFHfkLEzsuLNPrMOZQvMMjP++KPo3sCszZ2t5H4f17MUcHVygQxclQ+uW82lS0QoXmxPRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5715



On 10/29/2024 8:32 AM, Xiaoyao Li wrote:
> On 10/28/2024 1:34 PM, Nikunj A Dadhania wrote:
>> Calibrating the TSC frequency using the kvmclock is not correct for
>> SecureTSC enabled guests. Use the platform provided TSC frequency via the
>> GUEST_TSC_FREQ MSR (C001_0134h).
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   arch/x86/include/asm/sev.h |  2 ++
>>   arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>>   arch/x86/kernel/tsc.c      |  5 +++++
>>   3 files changed, 23 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index d27c4e0f9f57..9ee63ddd0d90 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -536,6 +536,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>   }
>>     void __init snp_secure_tsc_prepare(void);
>> +void __init snp_secure_tsc_init(void);
>>     #else    /* !CONFIG_AMD_MEM_ENCRYPT */
>>   @@ -584,6 +585,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>                          u32 resp_sz) { return -ENODEV; }
>>     static inline void __init snp_secure_tsc_prepare(void) { }
>> +static inline void __init snp_secure_tsc_init(void) { }
>>     #endif    /* CONFIG_AMD_MEM_ENCRYPT */
>>   diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index 140759fafe0c..0be9496b8dea 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -3064,3 +3064,19 @@ void __init snp_secure_tsc_prepare(void)
>>         pr_debug("SecureTSC enabled");
>>   }
>> +
>> +static unsigned long securetsc_get_tsc_khz(void)
>> +{
>> +    unsigned long long tsc_freq_mhz;
>> +
>> +    setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>> +    rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
>> +
>> +    return (unsigned long)(tsc_freq_mhz * 1000);
>> +}
>> +
>> +void __init snp_secure_tsc_init(void)
>> +{
>> +    x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
>> +    x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
>> +}
>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>> index dfe6847fd99e..730cbbd4554e 100644
>> --- a/arch/x86/kernel/tsc.c
>> +++ b/arch/x86/kernel/tsc.c
>> @@ -30,6 +30,7 @@
>>   #include <asm/i8259.h>
>>   #include <asm/topology.h>
>>   #include <asm/uv/uv.h>
>> +#include <asm/sev.h>
>>     unsigned int __read_mostly cpu_khz;    /* TSC clocks / usec, not used here */
>>   EXPORT_SYMBOL(cpu_khz);
>> @@ -1514,6 +1515,10 @@ void __init tsc_early_init(void)
>>       /* Don't change UV TSC multi-chassis synchronization */
>>       if (is_early_uv_system())
>>           return;
>> +
>> +    if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
>> +        snp_secure_tsc_init();
> 
> IMHO, it isn't the good place to call snp_secure_tsc_init() to update the callbacks here.
> 
> It's better to be called in some snp init functions.

As part of setup_arch(), init_hypervisor_platform() gets called and all the PV clocks 
are registered and initialized as part of init_platform callback. Once the hypervisor 
platform is initialized, tsc_early_init() is called. SEV SNP guest can be running on
any hypervisor, so the call back needs to be updated either in tsc_early_init() or
init_hypervisor_platform(), as the change is TSC related, I have updated it here.

> 
>>       if (!determine_cpu_tsc_frequencies(true))
>>           return;
>>       tsc_enable_sched_clock();
> 

Regards,
Nikunj

