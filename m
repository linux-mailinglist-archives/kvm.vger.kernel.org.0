Return-Path: <kvm+bounces-31452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD179C3D22
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94E45B24B02
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7978218BB87;
	Mon, 11 Nov 2024 11:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1LZ/1Vpd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138FF15687C;
	Mon, 11 Nov 2024 11:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731324202; cv=fail; b=biHTsVxMc9mqCLEC6jPo+DoJzEj5BzfzHvmXCV3CffeVWp0SNxgsJXz6Cd/DnBaOKxLszT78sgA4mAx50LvLelI4Pie/DYojkdC92AUNOTLf0STYkQGgclO/ZaF+85dXwIYszLCRtDXxjQs1OavIfwhC2XQswhx8HOmw1HbIsfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731324202; c=relaxed/simple;
	bh=z9yDhbnOqDbfx+QrVFdHqBy5cxxdk4UoenFkWdVAsY4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lCklPVn/VudI7hIJWtPUwAo5Ox+0FLekYt3uHXm/Yc7iMMb56g+yBWNWv8VDBI0+WONgohIkg9RnD1Q771TE4OOT5cOvppxrsP6kI4y+nzaDk1Nxszy6elLdDkL/odXXQFm5ye+afnlmL8pCvZ0alNesAfnaodlBw4iMYeP+lbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1LZ/1Vpd; arc=fail smtp.client-ip=40.107.94.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fxgaqbR41v3ikP43X4WSfKgPijwBbyNv45FnmvQd4/6p10IfFqvgMGLHdgo84kIno89I9Bwi2LfnXnzIFIbwtimlitxeW5Xu1ui4WJzh3gX3VPH4104TKSTC2aOeLq1SBUf7l16akFMJw/WBfBeKoLb+Y95p0rQnwnz7aOv6NS1QjFcJxI38U++w0Q/d+hE+PDA0U7JUj7btduMEN8fRfRAv8I81MnAu2JlJ70xGj1SMAc73K5wc6nQSe4Pn2N4Cu24STMQ5nfh3I178cXX4IzISiaxix6Vpz3GXzAyoonOkxc7aHU117M2aVsOfJthOZmKGaw28zvFb2cgS4rByiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uh+s3GbVKsaM0srrvjIgZ9csnrJXWwafaXFSbR7BkzQ=;
 b=TPoiSZLfsKIIhrwIoiZzR+ZOYUmVRTCZsaFgzV1aPPJIdfcsuHbAgPNRwNjirDqVKGOr/wfpAHpLo2YKkV0QVzHbw3z9gqLNXKZTDtUGdVW5EkMz9CReiXjIOCp65DzyphvTiqcIFg7l1V4UoJ0y77HDaWUpvH8g1/O4uCwTYeIaq7SN93pr7rmrATb2/vkyD8w+21TdcZEUib3aLSiCj5RoYqqlvEA0FKd6Pd4qhrWPsdVtLOQoTMeMIpaLkdKYa5/HKHprS7lex8zufYycdGnu7yzE9dNvNmFWyuKO4sfV7XjSfcfThh61lY8+91qmgNlHJflkzr1b4FzkjcuWPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uh+s3GbVKsaM0srrvjIgZ9csnrJXWwafaXFSbR7BkzQ=;
 b=1LZ/1VpdO81eO4HEiorFrLRTqmo2z6L2VD5P1VGDX9kigHDqlZuVBwWP/rULdd7uC9oivHAxxJKikgAVfDKawQ7j6C8sLY2i+IApK5BUuiASCl2FmfWDrQrBgszFusacr86xzsHZnZI3wwCps7G0E9fO6AHNOHbccYn8K6UPlYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH0PR12MB8049.namprd12.prod.outlook.com (2603:10b6:510:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 11:23:17 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:23:17 +0000
Message-ID: <df1da11b-6413-8198-1bb0-587212942dbc@amd.com>
Date: Mon, 11 Nov 2024 16:53:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
 <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
 <4115f048-5032-8849-bb92-bdc79fc5a741@amd.com>
 <20241111105152.GBZzHhyL4EkqJ5z84X@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241111105152.GBZzHhyL4EkqJ5z84X@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF0000017B.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::46) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH0PR12MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a9a5b40-23ef-4770-edf6-08dd02433d19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2E1S1FOU2F0NEdLL3pkUk5JdnA0Mk1Nc3p6cVVZUHd2T0ZEdXM4WTJtUDY2?=
 =?utf-8?B?YUF0VXBWUjdveFBnbUJ2a3RUYVlnTzY0c1BpaU5wR2lka3FKT0FlTVpIWlp2?=
 =?utf-8?B?bkp1MDkyaGcyaWpzVmpWSFFDUFR2NVR4QjhhWURicHlacXJHdHhzaDZUUEdY?=
 =?utf-8?B?aEYrY0lDc2luVWNUSDB6NG5lUGlnNXkvYU9iTDdRaE8wRG41YWtNZXFKVXlq?=
 =?utf-8?B?em5FVUViL0tiVjdKeEJCckZkaVhsVGpUa0NEd1p0dDdNQlM0cW5ibUNiRlIx?=
 =?utf-8?B?UDNLckZKd0p4QmpKUHVOcU5DTUJsM1pKUjBsb0JQMFFNbEhYYlpHbUVhdkxa?=
 =?utf-8?B?NXU4VWFFN1lPODZRLytXRTJ6b2ZHT21QZ21NYTlBdGpWNzdkMiszQllvdTUv?=
 =?utf-8?B?bjVFTlVzclpRSUM4RDZjUUNqTWRkU29sbmxXVFdEKzllR05HUDhOR0RMK0xq?=
 =?utf-8?B?MkN3YzAweS9NR3ZFMUU1bUYvUzl5UzZaNkhsTlI3UE5mMmtIbWd1dEwxWit3?=
 =?utf-8?B?RGIwTzVOMndlYUduQTBaN20yZXMzcXJvdGxJbnpGa3ZQVTdpNkRIdHpjSEdI?=
 =?utf-8?B?cjUzM2oxV1g3VFdpN3d0NGRVdjNxYTNQNjg4ODZ6dU5JM1NvN3lxSDd1N2hm?=
 =?utf-8?B?NzU1dlppbzNjb1AyQ1E0VEVpZ2Y4Nm5HWWxNQTliSWs2QlhDWDEySG9WbGdw?=
 =?utf-8?B?UmwydlNJY01DeGJkaFd4WEJHeVlwMUpVSnBxRXY3YXE0L01vZC9TQ1dVWU84?=
 =?utf-8?B?RmRROXRmNHBhVmhxUmgyUmRFQTJqd0xRWGI1dDRpMjlONWtnMHQ3VVREMWc2?=
 =?utf-8?B?em5ZUUFiM0ZFaXI0ZEo5a3cyeDQ1YkRjZHVSc0ExNWUwWXZHOTJwUVJUT2VP?=
 =?utf-8?B?dFpqNWk2K05UZEVYOEM1ZnI5ZWhYa2FBcUQwRmpFVTdyT2JHN1EwMEdHeEoz?=
 =?utf-8?B?MlMrSWVPMTRqU1pmamppeElGRHBaWEdCZVI4d2FKek8yK1dhRStjYm1GUGNP?=
 =?utf-8?B?RXgwN2pqRHVjeVdVWS9yMDR1NGUra0E3eUVXSEpEYTAwZUZIQksvUENTazhz?=
 =?utf-8?B?V0ZueXJLalZ4aDdKNWM5dDkzNnB5cVhiblczRXczTFBFL1BDR0crWkovT3JJ?=
 =?utf-8?B?NlI5YXlJVkc2MFlxL3RrbUZzcFkrTThxVzdQWVQvR0hHK0NjNjFWK25ST2Fj?=
 =?utf-8?B?THIwV3R5U1doRjN2Q0YzS3BjVCtHQzg0NjQ2RkdOamJCV21zK1ViZHUvVnA5?=
 =?utf-8?B?RDB3NEhGQkl2SS9RVnlvc2N0dTZMTlNrb3dFMDA1NXBkT3RqbW11eDZMb0lR?=
 =?utf-8?B?UDlsZFdyR29tSytoejBzZjVJOVhKNjBVWXcvVWd2R0cxSmRoeWpIYnNPM1Nz?=
 =?utf-8?B?eDBuak4rOE5McjR2R29CWXFpQ3huVjV3ZWQ3R1BDSW80Mitkcmk3M0J3VklI?=
 =?utf-8?B?elpqdkJkaTJOcFN1RHdyNHJHTG9iR0w2WTRwMURSNWcrRG9JQWFvK2lpbkR2?=
 =?utf-8?B?V2MwTmU3dzhSWVJNRzBJT0o3OGlJOUtEWHQxdkFETU5HSityOVNpOTBZeFJU?=
 =?utf-8?B?U1dkQnB0OURaMkwxcWRobXRQMGlmMjIxUFVHWjhoNUdqbjIxWFYxUEVVbW5x?=
 =?utf-8?B?cWkwQytVODJLRlhobnFOK0dHSUpLTEtnNFA1aHZ2cWtMTFgzSHFSMEtESWlx?=
 =?utf-8?B?UGxVZlREUXNwRnBhVXdsK21sZ3oreHRHTVRQODBESVRZNSs0SUp6L2Z1TXRD?=
 =?utf-8?Q?CMVNRVpb8eP78/Ab+4kL+zPxX5Bkd4P5PQB7QQm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkJCaENjV0U3OE42Nk1lTkpJb2ZGYk9nK1RTSlpvUEFXMGtqdDIxVnR0WTNE?=
 =?utf-8?B?VGtLQ1drc0tMVWlXK1czRFVxMWU2a3AyVDJydGQvOWZUKzB3T3V2VExhR2hS?=
 =?utf-8?B?ZE5EL25CM05SQXNtMVpRVFdWb1ZyVjdISE5aQmZkUEQ5MDdLaFpNcjlueVRx?=
 =?utf-8?B?OGhzd2Z3c2ZIS2haUVdzRzl2OEc2YWpVSTRnNDUxUmt1c3VManQyeFMzTUxO?=
 =?utf-8?B?TndFbitXZ1BkamNRdndyZTZkKzJ4T0RCMVhrWXdlM0lycWxsSnplRUk4UHhN?=
 =?utf-8?B?eUovV2h6bFdCNUNiOGE1d1I3U2V2eTRHWkRXbUdMZUwyUXZ3Q1laRzhLVURZ?=
 =?utf-8?B?cUEwVVZCVndRRnE3NG0xWjlZdS95QmJWSisvQVM4OFhMUWhlSXB2QmNhWVFh?=
 =?utf-8?B?dUdWSmt5NDVRL215M2RqZmtaVVNEMnd5TWRPSEFORlpsd1dIbDZYVWhRTmEy?=
 =?utf-8?B?SDErQmpZbWsxOHRieEhqbDl5R3ZqNlpRbmg3cy9GQVpHQkZ0VTJ3ai9tL1FZ?=
 =?utf-8?B?TjJJOTl3bEtlR0gwZ1FoWlNEU0hZWEx3VnZoU0ZEN05ucDd4Q0NsWFJQOUg5?=
 =?utf-8?B?ZXE0bFMzNnlTQlBld1dpNlpOVEtlRzNvMUhTdmNCajRJTi9tRVN5M2ltSkxi?=
 =?utf-8?B?NEpsT00zeVhoZ01BZ1BuZFMwMG5TTkhRZ3FZL2tCdzJOOURGa0lpNTJsWGdL?=
 =?utf-8?B?V053NmxvVldYZ2laS2tMblFrdWtDNFRkTkd1Zjh5VVEvOFIvVk5FR2xwUUF4?=
 =?utf-8?B?d3BqTTNRcTdCc2JlUDRYRVBhQjBOUk9FblVBRHVJK1U2MS9NV1dLeFQ3NkNS?=
 =?utf-8?B?b2M4d0Z4ZmNsdWhJc3lTemorU1lTSEtnck1HM1FDRnVHR0dsZ2tmQm1rQUgx?=
 =?utf-8?B?cjVJYll1Yzl6Wkw5WXVhMEtxMnV6VTVRMk83c3ZKcU5NZ0lBeThaa0Q1MStM?=
 =?utf-8?B?NGJOT1l2QnAvV2RRUzNhUlhPblgrOGZ6dXEybDBQVjBzM3FwajBZdklpemIz?=
 =?utf-8?B?dS9ZRTQwNVZKZURBRzNpN3NTS0NIK3VBZVZkd3BzQnp5ZlExTVFtZ2UrcUhZ?=
 =?utf-8?B?WVduR1A4emxuVDFTTGh5K3NGeFI1dGh0Tysrd3Iybk5uZ3hyVnoyKy9ScFc1?=
 =?utf-8?B?TzNTSmxXRFBkakxrOWxwd0p3clBrMWl4M0hnK3dnTkY4NmoxNEl0d0l3SkQv?=
 =?utf-8?B?MlIvS3EvV3hhRWJBTFVMcmFyWkdIR0JmU2g4a3RxZnY5MWR2NmNvWjNMc3FZ?=
 =?utf-8?B?azBiQUNsTzNZMWV4UE40SEx4V2IzRDBxeW5iTG9UR0RtMmZ2U0x0TStRcktq?=
 =?utf-8?B?TDRSZ0E1d1pBSFoyY1E3Z01kNG5ZQ0dDZ0dEdWxuZkY5UHlGcWg0ay81WnU2?=
 =?utf-8?B?cXV2c1ZYVjV0bHEzcEVYNlQyNDJVTGlxMTdrRjMwUnZhL3h3NkFJeGJOTGxW?=
 =?utf-8?B?YXhkdkcrVWhjUDFVQzlZc1ZsdFJnOFVKYXRKa3kweDBMSjhLcUx6STh1cmMy?=
 =?utf-8?B?RnJQalIwQ1lnaUZ3b0U4NFpyVzl4R0dXSjNZSmlOakxSd0h0a3FqK3JoOEpL?=
 =?utf-8?B?S1QrK1Q4SUJZeFZCR05VNzA4N2JMNnRXUmFYekc3YUhyY3ZWYlgrUHlmUGQ5?=
 =?utf-8?B?NENLcDFKL1JJcG9aY01hczRDbWE4M3kyVm43TWpvR0czWlROL3lISldFT1NF?=
 =?utf-8?B?MGt6U0lRcVkzYWZ1VDNVYjhxc1FCVHI0ZFdIMjVmemV6SVdlUlcyUWNOdXdR?=
 =?utf-8?B?aWlJUjBlWnhHaHorRDVrZFhIY0pzTGRNbTgwajJnVzNneTN0WnhJVXdvbTY0?=
 =?utf-8?B?TW5KdlJCaSsxN2wySzhTQTFLWE11WGdCWmpaYmhDbWNDWHR4Y0o4dGxFNnJQ?=
 =?utf-8?B?YlErTVR4Uzd1dWNPQUs0TUxiemVSNmVsV1hXdm84Mml3bjdUTURQcDhHT2Nq?=
 =?utf-8?B?a2QrQzdGeVBTRGZSbGpKYzRiMEVkUXhSVVp1ZVdZSHk2NWYzcEs0RUo1d0oy?=
 =?utf-8?B?NmlJZm43SVRELzd3TzNzNGxRbmRxRFhRcU5UVGx1dXNzbVpVZ2JBS0IrUjVN?=
 =?utf-8?B?NG52anM4REZ0aytjdStKM05yWjNmdUhJRUNwclZPcTNrSGxOdGRhUmxNV3o2?=
 =?utf-8?Q?dHUxmzWCUfZ90IMF1Dyf+TRf0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9a5b40-23ef-4770-edf6-08dd02433d19
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 11:23:17.1357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ir+RkajkRPD0WTs6E5MzqDTrsOQVZbch+eTElLAGXJ1qFqIbQyDXLFeMFiqU8H3313h3XZMPyfmXRmLVbe4Lpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8049



On 11/11/2024 4:21 PM, Borislav Petkov wrote:
> On Mon, Nov 11, 2024 at 02:16:00PM +0530, Nikunj A. Dadhania wrote:
>> That was the reason I had not implemented "free" counterpart.
> 
> Then let's simplify this too because it is kinda silly right now:

When snp_msg_alloc() is called by the sev-guest driver, secrets will
be reinitialized and buffers will be re-allocated, leaking memory
allocated during snp_get_tsc_info()::snp_msg_alloc(). 

As you suggested, implementing a "free" counterpart will be better.


diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 8ecac0ca419b..12b167fd6475 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -488,14 +488,7 @@ static inline bool snp_is_vmpck_empty(struct snp_msg_desc *mdesc)
 
 int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id);
 struct snp_msg_desc *snp_msg_alloc(void);
-
-static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc)
-{
-	mdesc->vmpck = NULL;
-	mdesc->os_area_msg_seqno = NULL;
-	kfree(mdesc->ctx);
-}
-
+void snp_msg_free(struct snp_msg_desc *mdesc);
 int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 			   struct snp_guest_request_ioctl *rio);
 
@@ -541,7 +534,7 @@ static inline void snp_kexec_begin(void) { }
 static inline bool snp_is_vmpck_empty(struct snp_msg_desc *mdesc) { return false; }
 static inline int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id) { return -1; }
 static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
-static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc) { }
+static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
 static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index d40d4528c1eb..25fb8e79eb9b 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -96,8 +96,6 @@ static u64 sev_hv_features __ro_after_init;
 /* Secrets page physical address from the CC blob */
 static u64 secrets_pa __ro_after_init;
 
-static struct snp_msg_desc *snp_mdesc;
-
 /* Secure TSC values read using TSC_INFO SNP Guest request */
 static u64 snp_tsc_scale __ro_after_init;
 static u64 snp_tsc_offset __ro_after_init;
@@ -2818,9 +2816,6 @@ struct snp_msg_desc *snp_msg_alloc(void)
 
 	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
 
-	if (snp_mdesc)
-		return snp_mdesc;
-
 	mdesc = kzalloc(sizeof(struct snp_msg_desc), GFP_KERNEL);
 	if (!mdesc)
 		return ERR_PTR(-ENOMEM);
@@ -2848,8 +2843,6 @@ struct snp_msg_desc *snp_msg_alloc(void)
 	mdesc->input.resp_gpa = __pa(mdesc->response);
 	mdesc->input.data_gpa = __pa(mdesc->certs_data);
 
-	snp_mdesc = mdesc;
-
 	return mdesc;
 
 e_free_response:
@@ -2858,11 +2851,29 @@ struct snp_msg_desc *snp_msg_alloc(void)
 	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
 e_unmap:
 	iounmap((__force void __iomem *)mdesc->secrets);
+	kfree(mdesc);
 
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(snp_msg_alloc);
 
+void snp_msg_free(struct snp_msg_desc *mdesc)
+{
+	if (!mdesc)
+		return;
+
+	mdesc->vmpck = NULL;
+	mdesc->os_area_msg_seqno = NULL;
+	kfree(mdesc->ctx);
+
+	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
+	iounmap((__force void __iomem *)mdesc->secrets);
+
+	kfree(mdesc);
+}
+EXPORT_SYMBOL_GPL(snp_msg_free);
+
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
@@ -3179,8 +3190,10 @@ static int __init snp_get_tsc_info(void)
 		return rc;
 
 	tsc_req = kzalloc(sizeof(struct snp_tsc_info_req), GFP_KERNEL);
-	if (!tsc_req)
-		return -ENOMEM;
+	if (!tsc_req) {
+		rc = -ENOMEM;
+		goto e_free_mdesc;
+	}
 
 	memset(&req, 0, sizeof(req));
 	memset(&rio, 0, sizeof(rio));
@@ -3197,7 +3210,7 @@ static int __init snp_get_tsc_info(void)
 
 	rc = snp_send_guest_request(mdesc, &req, &rio);
 	if (rc)
-		goto err_req;
+		goto e_request;
 
 	memcpy(&tsc_resp, buf, sizeof(tsc_resp));
 	pr_debug("%s: response status %x scale %llx offset %llx factor %x\n",
@@ -3212,11 +3225,14 @@ static int __init snp_get_tsc_info(void)
 		rc = -EIO;
 	}
 
-err_req:
+e_request:
 	/* The response buffer contains the sensitive data, explicitly clear it. */
 	memzero_explicit(buf, sizeof(buf));
 	memzero_explicit(&tsc_resp, sizeof(tsc_resp));
 
+e_free_mdesc:
+	snp_msg_free(mdesc);
+
 	return rc;
 }
 
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index d64efc489686..084ea9499e75 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -647,7 +647,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	return 0;
 
 e_msg_init:
-	snp_msg_cleanup(mdesc);
+	snp_msg_free(mdesc);
 
 	return ret;
 }
@@ -656,7 +656,7 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
 {
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
-	snp_msg_cleanup(snp_dev->msg_desc);
+	snp_msg_free(snp_dev->msg_desc);
 	misc_deregister(&snp_dev->misc);
 }
 

