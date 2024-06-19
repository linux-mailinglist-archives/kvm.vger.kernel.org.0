Return-Path: <kvm+bounces-19991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E342E90F1D6
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F20471C23E10
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 15:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CB0150984;
	Wed, 19 Jun 2024 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A2W8dr2+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88D585626;
	Wed, 19 Jun 2024 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718809930; cv=fail; b=s4QjFNk2Um/4MSBKxFdEwbFaW8KPlbMhwmLShiaRVgZcCjnS8YU/++60HCQd8AKGQXz6A0mj/4GKC4/CtOIDf+/x/HTq+HCs0pfV6BgYABiWoJpiJNZ2Qkr7d5nFqJtMgNLfpHpU3bGnNfWbGxAbErXvvsrpVpoiSJIxMVcb8KY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718809930; c=relaxed/simple;
	bh=XTk+Vw7b4ykBhCKLP0oQo/oxayBbCShn7MmG9rIVXTc=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=O2AsYw5sejN3H4/Q9LZlQHY7GpOZcnkCqVXjlHeI6sq5mZLX7jSrj0ly+9jS9livGLiCHENyhJWlpLQG0JdiJgrmdhIClAqyO14Vmii5QHq5glEbDIvfqtqBacd2PoYX00NNNHY1ZjVbypoKEuESN7JJctUHVhIZ6xEFQ2n5gyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A2W8dr2+; arc=fail smtp.client-ip=40.107.223.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mfn7sut+iyy6/ka6wpiemZM3ei9orcnxRTwdRfW8yNAmps7x61pvq6Z2quOu10mtHGA3FcJOZSevFkk6c4rMiap0q0+HrhRe2Tg1ehsmS/3ODp2P1XY5GXC9IgsxEiGNxdRKnJ7D4nG75Jmqs2MvFlJRF2poaHhDGlfzyob+I2U2o/kF5sH4Li/iyaU9AvBqYtXL666KeU2w1Lw98XU7QlUO0hEy8rlY+/uFv6AqqZVDTarjzuuXLKIdmJz1ld5XshFRKMSWPSLs409dpJPgbavPIauPWMiVixmnx+1uwIJxeH3BlUZAJKE+rAzZRLacQZjdXeJZCLEqDyjEUdfElg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OV2Aq5DEDJsA3V2OGLSRQDlCRrhrI7+IguR/QlTLZBc=;
 b=Wtcjp4CIdU+XVNTZyLLv8IC5qAAN19BtZ5OllWVnYKGoi15FsVfjptO7XlIPpWlKzJnUB2Fs3Q1Jfhx/GBT2CEAP7AHYHgJWp/XQ197uhMEMBay4LJMg1tycn2Ge4PLsyfj7Yp72iyMU8B8SdRuozUNyxZ51CVx8JIXPsPEzTK60shyT+PALzhbLLDzKv5S+UuudkbTIi37OkzR6Sh0iKdODoUzgYf4ELx5KCFuB17MQs1Tl50JjAJ2yD+cfkYNNpN137y0pl85+zmKCtNj2Vf+6f0WHwdizewAOU27TZSNSxxWeNHZxaeK5sHg0MyEQ3qgoQs4HD1N3xPKSdLUgxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OV2Aq5DEDJsA3V2OGLSRQDlCRrhrI7+IguR/QlTLZBc=;
 b=A2W8dr2+nkAPMktUjHXVvLlrBsc/gtHcNWiSezODjTlXkQICnMiYDJA7VMEi7+9RfsHlZFZ7EuSHRciLq5U9kJ2HAwQU9vdkhn1uy4pc06uLVQAtp4n9vaEvmf/JxzrkcZBGTpTNcW0D1JC5hw+PFnOKm7nXQG3pq5o53T4oJO0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DM4PR12MB6255.namprd12.prod.outlook.com (2603:10b6:8:a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Wed, 19 Jun
 2024 15:12:03 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%6]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 15:12:03 +0000
Message-ID: <24903cd3-f5e1-c770-212b-e46149854792@amd.com>
Date: Wed, 19 Jun 2024 10:12:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-7-nikunj@amd.com>
 <64164798-3055-c745-0bc1-bbecc1dd0421@amd.com>
 <9b8c57e7-a871-6771-dcc0-99847bbbcbc0@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v9 06/24] virt: sev-guest: Simplify VMPCK and sequence
 number assignments
In-Reply-To: <9b8c57e7-a871-6771-dcc0-99847bbbcbc0@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::17) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DM4PR12MB6255:EE_
X-MS-Office365-Filtering-Correlation-Id: a2752d77-ace1-4426-537b-08dc90722c9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|7416011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnBMTFltVGhrdDJhN29TSkpUcFd3bUFhUlNTSVI4OHpScy9zSnUwNCs2cWc5?=
 =?utf-8?B?aEhGdEZFZGdrZDB6aXVyYU1KZWlTdTBhRHBjSzFqdWVVVDlnVzFMcnRxYlQ0?=
 =?utf-8?B?MmdHa1RFRWdjd0RzdUxMR1BhQ0hONXRabWFPa3doVFMyMlNmQ011V3VNYUc5?=
 =?utf-8?B?cnFvZlQ0dy9Ua3VySTNXWnBtTitzQS9sT3NmT3RlODdwTkhMTDh1R01qb216?=
 =?utf-8?B?OUNKNVE2SGh2bnkwQ1JsZCtZMWg1WkU4QjhmTUkwK3pzSkk3N3hLOWppajli?=
 =?utf-8?B?dXVINEdoQmV1U0N4dXQ0ZlNJa3krVmc1S2M5U0xvekJZT243L0NIZDVNdlJM?=
 =?utf-8?B?OUY5ZnlHbXRDWWxydm0zc1NreUQzelZMcHpiaFFoT0Q1V09SbUZMWEN0c0Z1?=
 =?utf-8?B?VHJ0ejliUjRzVTg3RVlJR1VscnJLK2RLZExacTBvdEV3cVBwYlhERkdyQmM2?=
 =?utf-8?B?OG1meXRsbElGL0RnbTRoRXNLeFVqeVFZV0h6K3hqSDlYbmhYbUxlTXF3WlQ2?=
 =?utf-8?B?blFGM1FYdnFZWHBkbzNEL0J3NGRSRjI3eW1CM1NJT0I3Tk9nOEhzZnhiUGh4?=
 =?utf-8?B?R3l5K2tZdzdMRGZZUmM0NmNXcVFBd2c2UHdQTDlBRnNNV3ExTi9QUHI0Wm0r?=
 =?utf-8?B?N2hnelF3WCtFUHh5UVhyWVZpcTh0RUdCejFxU251L0lqdTRHcitkVHZzNTJ6?=
 =?utf-8?B?aEkrSmpwVTNHZW1oeU1EZ1NBWUdoMStpWnB5UzlTQi8xdVpYMTN5aHhPNU9U?=
 =?utf-8?B?OXUxYzhTb3Rid3Uya25ULzdHeEJqTUdsMFhBUnhQWS9BVzNZRDhVemNORGNW?=
 =?utf-8?B?VG03cVRWbVp5TmJOd2YySjlxUWJzMGk3Q2RqbzZjMm9yWDcxRmNOb3hJaS8x?=
 =?utf-8?B?WExrTTduUUZtZkl0b25vN2dhYWpMdGVQUXdRSzVpWDZ1QU1RQmUyY1JxTE5P?=
 =?utf-8?B?TE5iYjNUL2Nwa0VlKzFGK1BPZ09BcW9jcWREZ0UxUHlTUFB3SlQzZGs5N3Ev?=
 =?utf-8?B?RmpPc0JyS1k0OVlUbmdTK1JzakEwMFJZK2tVbXg3eUFqQktMNTFiRFVLUnpB?=
 =?utf-8?B?RlcvTnZaUWRLN09hNTFwSEQrZEhwZDhNYXNQemh1bzlrM0d3STZSZXFGV2dl?=
 =?utf-8?B?NHFPMml1RmJ1cjYvWlkvby9LdlFpcWJNR1lUcys5Y1hzNzNXMjQ0azROM3Ny?=
 =?utf-8?B?OEFlYjNLczZKZWlydWlia1RxMW5iQVJ4WElINEs2QlZ3VjlCUVQwMnBXMGtL?=
 =?utf-8?B?STcrempNU0hvV1dacmJyZG83dnR6TTJ3MUdJdjdhMEhNb0tlTXlnSFlCN0k1?=
 =?utf-8?B?TkE5WjFzUXA2N0haZDYxQzgwaWlvYzJWWS9sY25jQ0NxaWgzM2UvNzFRWENL?=
 =?utf-8?B?SjRyVzd4anRzM0N1SXdTT3JPT0ZvdC9LOFNiVitVUmpWNG5LVW0xcUNkYU40?=
 =?utf-8?B?QTNWMHpyb3hDVU4yb2IzMXF1L0c5cVUzTUlSdWFFR2d4ZDU0S1pna2l6RXhB?=
 =?utf-8?B?enJncWJoMWM5M2ZKRVFWQ0k0ampRNjhZdnM1aWE1K2NFMjNadmQ5c0k1elJL?=
 =?utf-8?B?MlNRVTFNMThFV3gwSWFBSXRhdkMxc2QzUzhxcE9neGhKeThGNFN4WVF4SzI2?=
 =?utf-8?B?MmJzdXNuNHNMTk50WTNHL2Y3SHlHZmFYN1BQMy94MkxHbDNpOTdhN1lBS0hw?=
 =?utf-8?B?YXpacHkyOGFIS1IwdytJNEROWjc5MTZlVXRHckt1T3BrS1ZNSWFVK1dub1dx?=
 =?utf-8?Q?WQuwEHkVzOT+x3DvVk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(7416011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0g5d1VXRWhURitCZXZVWllZMVJ5WDhnbjNEK0JYczdMY2txbVlZZDJZS1BG?=
 =?utf-8?B?K1hmNS9CMFBGeThsV3ZQK2lzMk9pdXRWRFFTOW4yZ0d2WHM5RzllZ0s1MXJZ?=
 =?utf-8?B?K0xrYWZEUVBjQjhJMEhXaFFCc1Blb2VnenZxU2NRbWh0M3QzbDVZTVNUdjdv?=
 =?utf-8?B?Q1hzdm5pVklvSVcycUxyU1REUUljVEpiVGliNVN1THE3U3FwTlQ2VS8rR3o5?=
 =?utf-8?B?a0dvZ3o3dTFMNTlCYVU3VDEvNjYyK1NUZGYyR1A3cTJ1QnZCOXlkRGRrbm11?=
 =?utf-8?B?c1Z1M3pxaW9IY1d3bmVzNHNXZ2hUanJuQ21MS1lMdmpJdUVVcTlVeEc0ejVR?=
 =?utf-8?B?UjVETlJldFRCVFZueml0VmhvUW9qU0QxdVZSSFhqcmd2NXJUMGFuc1VCV0I2?=
 =?utf-8?B?YjV4STVNVFVGU1c2MWJmcWpLelR5dG11Q1ZEMU1EcHZ1Q0VndVp5VmpoZ2lh?=
 =?utf-8?B?T2l1TXMyV21TYkM2L0kzRzJLVzdWTkpZbW45RW95UjI2bEhMQklnVkJMeXVO?=
 =?utf-8?B?ZHlIRGlSbVBKaDBUYkQzWnBzajhuZFlSSlBrMnZNVEZNdmJ2WFIrTzhNWHhE?=
 =?utf-8?B?dWVCRVNDUm5MWEVoRkY0YkZOMEZtOGNBamdud3JCNkRxVW1lbVNXOXVqVk9u?=
 =?utf-8?B?emp5emJOS2JOWkUxYWZKWkNreUJGM0c4SExnRjlkK295ZlZVREU0QzZYc1p6?=
 =?utf-8?B?NTRzQkorMFAxVFBvOW9SeFJ1Zi9jblU5SkNid2ZmNzZLUjlOR2RXYkdqdFoz?=
 =?utf-8?B?ajBNeC9vMkdMSldJVlpoZ2xWRCtIZmowZUdrcGZibzBCdzQyQUcwbzhMVEV3?=
 =?utf-8?B?MTA5NUJiQlQxSy9scXRTTm93VzVEQUVnemYvbzk4ejdRUDRmSGFTM3lwbXRH?=
 =?utf-8?B?SWNsdUl3M3plNndpaEFwdXZDRkQzd0krNVRTaVNRcjJWVkkwWmpkL0V4UUFR?=
 =?utf-8?B?cUtndVAyTTR6YzhHNG1CckJxYjNyMTYyVkV3TnM0djNBbUNlWncweXNpTmRF?=
 =?utf-8?B?VEdtNVhCclVXK1l2M1hyTXhHbXVwZldVeGtWbVpDTThXcGkvZ01vSUhtKzU4?=
 =?utf-8?B?bXgzbmt0bXYxTG5ERnUwdE8vdDJkV1AxODFleFMyMFpoZGlKT21HTkNXakNt?=
 =?utf-8?B?czBuYVhSWkV1S3o3dzh3eGtrV0pUMVVsYmxmWWdsMkdCMjlWMExEOTZBdmlP?=
 =?utf-8?B?VUZmZ2N2YWZHbUllVVpKMkdWeThNWHZia1F6YjI5NDZUNS8xa3daNWpISFl4?=
 =?utf-8?B?Yy9uTzlyR1BxRzhsb0U0a3dFaEhGK21UNVYwUi9JWDhYSTZIejdjRVVoYStR?=
 =?utf-8?B?cVhaa0pXT0F6MHFOTW5TNC9qcWJWQS9Sek00dForbnVGMEtMYzE0N3RkRUNP?=
 =?utf-8?B?dVpHYWhTY2hWVUJRa1JpbUttM0ZDWEZuanJGMnpqMkhOY3pGNkhOSmRSOWk3?=
 =?utf-8?B?UmFvbEd1TU84SUJQQ2ZCaWpETlpkaHlna3o5RDdyRnl3eGs2eCtGaHZmYWFD?=
 =?utf-8?B?UWJ6UktHNkRkYXlDeUZKNENZcDZGbDhCS05BR3V6VHlhTlVMbU42Q00rNEJF?=
 =?utf-8?B?WFNlUUJobzAzSDhCdmQydGhTczRIRWNNN3pTbXNPK2JZU2VYcUlwWXJCOWJk?=
 =?utf-8?B?b0pFbDZBUDE4ZWhMaFFodnRzOU9SK2hOelNSSlRNT0wrM2JZUUQzVkFzd2px?=
 =?utf-8?B?RUljS3gwR296L29pMGtKa0xRVHBWZWlGZ0JYMTZoYXZweExYaDdpZVhOczlK?=
 =?utf-8?B?NWJhYmdyMllHK3A4dldBaXYrQ1ZHTTJjUDUzSEtOYUZXWWM0Q0h3Sm11TE51?=
 =?utf-8?B?cVovVGhFd0kwS05GQlpmRkRCOUpzMXl0UFkrZU5LNmp2QVNUc2lrc3EyVE40?=
 =?utf-8?B?MGNpRGx3RWFZMC9ONWRMWWRpTksrcXZqNmlHWmI3RzBGR1ZOWnpqcDlTUlM4?=
 =?utf-8?B?cDhuMmpNL2lkNXlHQ2hxUGp5ampxaFo1eGxEalJXeCtIQnFLY25XUG5PU1Vr?=
 =?utf-8?B?ZUFiNlZoR0g3YkpsbWtxOEtEUjYvNW9DUG03T05tTlJLMmVYZFRCTFpTcWox?=
 =?utf-8?B?MEpQQkg1NU1IU0RmaTIxVFRFOXV2V0lhcWl3cjM3NlA0dzJLVEJEakFVTzFK?=
 =?utf-8?Q?ucAcWrc8aPXzdKTvtG0lAAL/X?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2752d77-ace1-4426-537b-08dc90722c9c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 15:12:03.0404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDcjhKYW3GeBhrpdmFKltRGwR4omRilIb3e7RhJ1bJsX5kwXBZgsRPNzuR2gi6V2mlX2/qPHyR5CORHl0IsuaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6255

On 6/19/24 01:06, Nikunj A. Dadhania wrote:
> On 6/19/2024 2:57 AM, Tom Lendacky wrote:
>> On 5/30/24 23:30, Nikunj A Dadhania wrote:

> 
> I have separated patch 6 and 7 for better code review and modular changes.
> 
> The next patch simplifes this further to:
> 
> static inline u8 *get_vmpck(struct snp_guest_dev *snp_dev)
> {
> 	return snp_dev->secrets->vmpck[snp_dev->vmpck_id];
> }
> 
> static bool assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
> {
> 	if ((vmpck_id + 1) > VMPCK_MAX_NUM)

Ok, this still has the "+ 1" thing (and it should be >=, right?). How about:

	if (!(vmpck_id < VMPCK_MAX_NUM))
		return false;

Just makes it easier to read for me, but if no one else has an issue,
don't worry about it.

Thanks,
Tom

> 		return false;
> 
> 	dev->vmpck_id = vmpck_id;
> 
> 	return true;
> }
> 
> 
> Regards
> Nikunj

