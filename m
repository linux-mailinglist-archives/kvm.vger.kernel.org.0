Return-Path: <kvm+bounces-33437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 054EF9EB744
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 18:00:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81103166059
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 16:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1FB2343B2;
	Tue, 10 Dec 2024 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vTOsdwrK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888DB1AA7A3;
	Tue, 10 Dec 2024 16:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733849982; cv=fail; b=NArDTj9TuyOkLC8mOkPxlizZ+WiakOq+mH/r/iXYji3SID8kaIvV37r6SK7iNGfIWAA6Mv1Qg/Hg+CpM7SbPBukyZEZC05HLryMHun0rxFCVP2BqrOVsvJ189MIekYTW8pxtgHKMr32Xt7QUgVIbRBSN0xnJiSpVL831KhJTckc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733849982; c=relaxed/simple;
	bh=ZFCtgVZ0Itu0aqx/0CS6Ch+MTPliYvU4BzimfK4pldc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dj8MLshbhJ0jt9HGNe2G7fH47ygwKGzs4qr4J/2dZkaP+VMHaLzMeoMW6dzfXwkeMb8U1+N0jEPx3oCJ5oxUrHj601Z+I1Mb8UY4syy/pZYuIuPHe80GQMCUl/IvcSV8YpDf+7/KkKGv5UK6wWyNiESJSlKLSNEt8RjyBJH0s/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vTOsdwrK; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MrDiSyIjw7PUE1Rne4O26fDO3qF9mddXJ+864pgRGuW7/1Mx8H9Na1bEVI04UmNJzab4VVPnaR+oKpQb7JlE6btMTc8ybzbV4QmT8HwkmtA0cbSrAuyg5YwJUrDrL9EhT2hSpkxYoGKu+gmTnC4WOG1uqeyMeWKs9HCv7HxF8xsaTI1KczMZb/oMAsAVK2lpagOJfNS8X0N2ddqaSxPQtZt4rFCJaM6UBBlBRLUg1V18YlYN/mJn368w1Htd3vV9mlCljRB2tUudAbMSbwlIDmO4+6iDB00EsvwkLjtpxMq6uMKqjvr2dqN/hp82mmWcf+KKh0hcf7gueVpzH53GqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDltzD3qHDPJZdnb55j0orM/pQ1XN9Lh6cZORgBa4+k=;
 b=QsKLwOLTJnTtRPLKAluQwZseN+v9deilBkGlsZMR0atbRAQD2LIF6pRtz8fW1cG8D4CQu8/g2WtLr5GGZdJee/v2oR0jVWyCanOoldMIKhA8bV4YQI+2eQXqsaSGevWWQ3TqXVjqXREYO5uoesjeud5QAF65WnGYsgBf9zzwxVQEsVLOPlNvOclJWhNIPgDMC94o/45wuYIfnfEFcuY9qHQ1ROPdEVm/AV7PfqSzEBZ7aBlyWgh+l+3CeNweXbhwi+iqQFsxQwzI/mV/1utL9g9DA3VUpV3g/AXwgsMynHcOcx1YZc7m2g7ctseYS5ooioV6v1EMGJJWUKtFt54e7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDltzD3qHDPJZdnb55j0orM/pQ1XN9Lh6cZORgBa4+k=;
 b=vTOsdwrKKiziuMcnoybKXUwda7eRZ4VKspdG9FyWllrN4/Jb6J1+0lzwDmu+vxQL9E3YDoDoe0tOZByn5yMF0Z4mkkN2l/g5OY/nsE311j+1F99Hw51Yt4/ousEW8Rg4qZDDpXbwCTXSQVZEI+whJUIUCOPrSEqJRZ6h5Vn70oA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA1PR12MB6457.namprd12.prod.outlook.com (2603:10b6:208:3ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Tue, 10 Dec
 2024 16:59:37 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 16:59:37 +0000
Message-ID: <fc87c6a2-749c-4ff4-ab5d-395d313632e5@amd.com>
Date: Tue, 10 Dec 2024 22:29:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
To: Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
 <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
 <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
 <15e82ca3-9166-cdb4-7d66-e1c6600919d7@amd.com>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <15e82ca3-9166-cdb4-7d66-e1c6600919d7@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2P287CA0003.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA1PR12MB6457:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b385ee0-51b8-4563-b0bd-08dd193c076b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T2NqWVlyWTNxMWdRbjlVTkI4MnE3bVZhMm5jR3hMcUF1cXRKamtlZ05YWWsx?=
 =?utf-8?B?d2RtV1p3dGZqOThaUnFpcVBtZ0UxbG03Qi9EblZRWUt2SFN6RnpXbVo2NzMv?=
 =?utf-8?B?ZThtTThScTBySlhjU3gxZ3UyMUdPYmVybGk2a0JFVjVzZ3AyQWpUOUxTdUxK?=
 =?utf-8?B?SlhLWWIwYXFQcEVHNUZ1eTZMZE8rNTV3QXN5MnFJcGdMOWx1c2xQUTEyWk1D?=
 =?utf-8?B?ZkJNNUNRNm1CU1NUaW02WEQ1MUhtZ3dha0FGcGVXSkdmMjJlWnJoNkNBVzdk?=
 =?utf-8?B?ejBxOGtHQmI5TlZXN3R5djNhSVVBWjBKanRSalo1a3hKVDl3dE1tNG9OZGwv?=
 =?utf-8?B?dGJaUlMxN2gyOHBZdFZqeXNnUTVzWDFiN1Qwd0VMdVovTmorWVYzeG9zdlZX?=
 =?utf-8?B?VS9hQXh6b0R5NFZ2SXg2cWpzVnROcWh1eHY5TFBlcE1hRDN2SnEyTWZadmV2?=
 =?utf-8?B?ZldqQk1zNmNlbHdBUXJDZ2k5SStnK04zVGpZQ25wSTJwM1pReEhpQmpTRnB1?=
 =?utf-8?B?THNIclhQdnBpeU8vQVJvYnJUdmZic2tNcGdoeGxtcG03bGZ6KzFHUEVzKy81?=
 =?utf-8?B?YXVONGI0OGlsY0laSXVaVlN0bEYvaThQbmdWallmU2lWODkvUG9jMk9zWWor?=
 =?utf-8?B?VXh1eStnbnRKMzQ3c3RjcEMzMlpBOWhZSHFxT2lkYVpoSU83cEx1QVlrOEdT?=
 =?utf-8?B?S2RhakgvcmFmTTZSWlRkeXdpKzZjNVRCaFJleG54djA2Y0taeXo1NG5ZcDRp?=
 =?utf-8?B?SzdRS2J4ZkpZNG1NbWJGZlRYSVhEZHpCZ0hmVzFRTHIyREZPeEg4UUU4WGFh?=
 =?utf-8?B?eFJIcGV5TS94Z1lIQWozZmE5a041ZnF5R0ZjdTE4ZlJzY2dDMUFxS2xyVUx3?=
 =?utf-8?B?czliaENhU242STFFZDhrTWhyWmRYWVFsdnhibnk1M3JEMm9zbTBmVGRrNGZh?=
 =?utf-8?B?OUYyTVpNWk5VTXQrK0FMbXMvN0JLemI2UDJOL2NTZ1NtTmUrZlJvQ0Z0S2pO?=
 =?utf-8?B?QnVNSWNsdDR1RU94d1ZacGFha0toOWJqTFZObTB2ZERWS25yUnJnb2ZGZ3h5?=
 =?utf-8?B?aVlSNGpFOHZNOFN1Z2hqU1pSZm5DN05od0hGZVh3ZHY4K1hua3poR25hRWlH?=
 =?utf-8?B?cERCRHFyWTBpblJMejEwaHU5T20zR1BlYVlGZWNMWXZHK0VxY1dsbWtTMk94?=
 =?utf-8?B?YU9ieXB6clVyZU9yNGdvUVRXcXZVZk55QUZFeDF5b21Oa05EZ0ZFelBVc3RG?=
 =?utf-8?B?SHIzTnFhSlB3UlFmdEE0cEJ5Yk1rR1BsamdWdTVzbXNmbGNaUk45dW5kVUox?=
 =?utf-8?B?MlhQZWxBRVQzTXhZZFJDZDBFTmxSakY1bGE0L2ZCRXlKdDRJRm42SnNiN05H?=
 =?utf-8?B?MVBIaHNtV2dyV2ZOM2RFL3UrdUExazVxTksyM2lWczVraVB6Z2tPUENHTm1W?=
 =?utf-8?B?NFRDRVlTKzc1ZDVaTzRNZ1ZKUjFvYkRjMmFaVVIySkdIaDJEeW8xcUxtRGRY?=
 =?utf-8?B?NHJ0UzFVcWorK3VSMDkvQktGQ08vUnlXc2lCTXFSV1l4czI0MzZidlB1S3Rv?=
 =?utf-8?B?Nk1jYWpDMkZCVnZaT1hUZWhMU2lYM0VRaVBoL2U0Z3ljUWtXc1Fsa1RCYVFp?=
 =?utf-8?B?MXkvVzE5N0tHc2NRM2d3ejBxaytITVhBc0daNXBzVm1ZRXNVLy8wZFpNUzFW?=
 =?utf-8?B?eDZUN1diK04zaE1wSVN1VWljUVhKQ1ZUUmw1bHBVTlZoU0lxR1N6VzIxM1gy?=
 =?utf-8?B?cDE3UjExMWhPM3Nlam1GU05XeEFRZTV1WW92Ni85UWhKUGU5RFVvR3lVSEtq?=
 =?utf-8?B?UFlKT0JtSTkxMVVOb1hiQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkVTWXR1SC9rTFQ3K3dwelhYREhaZGx4ZDI2c0VsRnN1OXExM1NHZW1NQ29J?=
 =?utf-8?B?NTg4UjE2UU1JYjA2UlFpVU53QXhpczQ3dGhNdlJ5RDN6RVl1UWpIVDNYS0ZK?=
 =?utf-8?B?NWdJbEt1cEV4eFZYSjhVUmdKMEM4TnM0TG9LY2lFN2o5a0hHS2RQY1YwRFNO?=
 =?utf-8?B?Q2ZRWVZZRk9lL1FMVW1LWUVzb2R1eGd5VUFrUi9LTk1jN3VEczIwKzUzejMz?=
 =?utf-8?B?czlrU2dCWnZoZDI1ZmhhWUdML3FQdHMvT3ByVVoxWjc4V1djTVlzN1l5bXJO?=
 =?utf-8?B?SUkxc3VMU2UzTW1JVFgyTU9mY2cvbHJueEs1Nkt5RlNlb3kvN2lPSHFNOEZa?=
 =?utf-8?B?VFkrZGZ5b21wKzlEdmNBeStpK3BvQTR1NTF0emhaNjBFUTY4bGRCRlR6cHRW?=
 =?utf-8?B?YmE3U1pROHhlbzBHNnJIL0xSMGdZbTZpVUkweXpEQTNwaDhZNHlGbURMNUJI?=
 =?utf-8?B?SkxMOW5mWnYxaVlDcWdsSFpIZ0R0ZW5Zc1BDTzZDa0MveGtreFZiNk1aMFdB?=
 =?utf-8?B?TXJVVHZQS041ZVFzaGhCVjErMUJadjViRmk1TjEvT3kvT3FkV0p0M0JMYThR?=
 =?utf-8?B?c1FNTk9hcGhZb0FYRE5EemZTcUhva0Z3THFOU0J3TTY4bDRGNldncXRnRGJO?=
 =?utf-8?B?My9NalpGTHJMT1ZtY2VpWWRQK3lVVExhZGlmY2ZxWXJoQjVPcngzTDdTajVN?=
 =?utf-8?B?NlArTGJhamticmx1aEVzUlJNc09ZNDdlUUhWaGZicktOaEZMeUsvcWNTZmo4?=
 =?utf-8?B?d2RkWkFPYVdrYnowTnBGMXZEVmdONWFGNG9GN3VkYWdqQWRuTyt0RnJrYmN2?=
 =?utf-8?B?eTR0ckMvUytxMndHcGlXdzdXdlJvOGxOQXpkSVY4bWRiVlVYMERmWG5ENDho?=
 =?utf-8?B?YVJXWTlOanhhaXJFcU5ESkxTWGZLRE5XYXRZL1lVUjVvaDdkVFBDdW9talVt?=
 =?utf-8?B?bzhsQ1RYL0VWK1IybjhSVDRRU2V0cTh5eGJXMVNSWmxnRzBQZVYrQW1zUHpr?=
 =?utf-8?B?ZlI0M1dUOXY2ZU5saHVWNy9kZ0hncndPMnVVWlltN25CVVM3SnBUUGovcjJh?=
 =?utf-8?B?L1JnY240cXh5MmJYSGMyUlhlR29qaUZmc3FlT01JU2paQ0o2SWt6c1pjS0NJ?=
 =?utf-8?B?dkp0Q3I5WE9aS0tqZlNXTnQ2NVRYTWp3aW11dmtGSGlCVUVpTC9sVklEUVYv?=
 =?utf-8?B?OTM2a2dHT1VONTU1OTlwYTJuY1N5bEk1L3FVMHQrcllPSXBaME5sUk1nMHow?=
 =?utf-8?B?RloyYitRUGg5QUNKZ1NBdlN5QkRaR3JPMFhxN1hHY2g5L3dHU254MklxS1l3?=
 =?utf-8?B?WU5ZT1FVVFY4NTZDUGEwazZ4NVhZWFZ5N1VNL29PT2RvcFYzaFllbExjak1h?=
 =?utf-8?B?Q2dZSU8zN3cyc1ZNY0tzTCtrV3V4bHhLL01FWHlrcDc3TnJBZ0hFdFRCMndh?=
 =?utf-8?B?ZU5SZzBsVks3dnBHemE2WFdUY01WQXdyazRYUjNoN3pUTm5CSHpkQVJMK1Nv?=
 =?utf-8?B?TjI2QXBQSkZvSUliQ05GQnNHdjYwNVozcVlOdkJnZGxRMDh1Y1FrNm1Eb1lm?=
 =?utf-8?B?TEFaSHFwM21zZDlZZ2R2aUpwZHBPTnF5WTBCMXhlNWp4SGZEZmtsdEYyREhR?=
 =?utf-8?B?U0FTNkJhSE9KSjdZVENJZE9ocVhsTjVRVUhHZzdSODRZbEZweXFhc25ESkJq?=
 =?utf-8?B?SzYza0lFWWhFYXYzUnR2V0c1M0JYWGhZZ2xmcUthenVkYTYxSzhOaDROU1ZO?=
 =?utf-8?B?SG1nU2JRZVloM1NKeTl2QWhlb1NsSXcwK2dzY0NrbUhNNkJITVNBS1VGWUgw?=
 =?utf-8?B?ODNicS9XVXBEazFsOW9URm5QTnFma09YMHk4UUZrTTVVSGUrYUNxbG1pUUlh?=
 =?utf-8?B?OU4vdGNzTjA4enFHZzlzL0FVbTZVVUg0N2RWelkvYTIvTE1vamRFMUdqUGZX?=
 =?utf-8?B?cFBON1BXSzFmT0NPK09rdVhsQUgzTlVNQ1F3UXdQZWJmd1VzUngzMHBqeHRF?=
 =?utf-8?B?Z1UrbWlXb3g4dG05SjdjRVFSSWxEL2VMOEZ6TEl4Y3preDlJTFhTSWJDd2RD?=
 =?utf-8?B?SmR0Y0QzaVdpN3lobDhsTXZRbWNxUVdwVHJuMGJoOVV3SHF3cWZGMXc0eS9j?=
 =?utf-8?Q?OxWdVeFc2KX8WFO5fCCqd1+6A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b385ee0-51b8-4563-b0bd-08dd193c076b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 16:59:37.3307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYS7Xy2LuHuzX8WPIyCGEqByJRnjK4BRg1YctoJ2p9E3nv2y5eCyUepP+fd+hR9l7SL//rIktzOVFecw2yer3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6457

On 12/10/2024 7:59 PM, Tom Lendacky wrote:
> On 12/9/24 23:02, Nikunj A. Dadhania wrote:
>> On 12/9/2024 9:27 PM, Borislav Petkov wrote:
>>> On Tue, Dec 03, 2024 at 02:30:36PM +0530, Nikunj A Dadhania wrote:
>>> +
>>> +	if (write) {
>>> +		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
>>> +		return ES_UNSUPPORTED;
>>
>> Sure, we can add a WARN_ONCE().
> 
> You'll want to test this... IIRC, I'm not sure if a WARN_ONCE() will be
> properly printed when issued within the #VC handler (since it will
> generate a nested #VC).

Right, a write to TSC MSR generates the following splat:

[   17.450076] ------------[ cut here ]------------
[   17.450077] TSC MSR writes are verboten!
[   17.450079] WARNING: CPU: 0 PID: 617 at arch/x86/coco/sev/core.c:1456 vc_handle_exitcode.part.0+0xe54/0x1110
[   17.450090] CPU: 0 UID: 0 PID: 617 Comm: wrmsr Tainted: G S                 6.13.0-rc1-00093-g5e3143d631a9-dirty #121


Regards,
Nikunj


