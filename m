Return-Path: <kvm+bounces-54921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D90AB2B295
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEFA27B5061
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512C925CC70;
	Mon, 18 Aug 2025 20:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jW1AFieY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DB5225414;
	Mon, 18 Aug 2025 20:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755549565; cv=fail; b=VcrzBUOXxvVz+OBQ0QGyUtTCOOx/w25n3FJ4/+y7F5Chves5SXA5Mt86gb200w9tAyvk2FI4yMS+eVLrYZ3/M2yC0vaQdW/vLume7Wz/0I3ywZNM1kptS9gyVN8t1JOoB7K7l08KhN/LeVfAyPeT+0m6egRDz1VLJp3T3V/2sek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755549565; c=relaxed/simple;
	bh=MprEksL76UmEdeN7SeBcx24l5WFzXzhg85DpuXsayk8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=guGt3feKkOKuecmST7hiEsJHwH/41YW5cTSwvXGeGiaiyNdX+ZgjVdODnAqja2DesHGhDHwes1ZUfNmobqHotnBIPqGYd4N/FakvK01V6PqJp/lQ3OXrTEqjiDYQyjbV57l1PGSipmPqYwaBT5l9UaMPmAbDAhAlLELKkSCBCqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jW1AFieY; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+FHPo3LcqwJsxLV8XKIV1FHXr55JTWAbnSMyo8t9AlhIunGh0vD+VHYpdf5XQIqMv7oore2GFd83woi6Uzz1d6AooFMqFqQssdfPMOOB79ce34EJIXadQL6nUiepWXxeBNyDufj6T7XaTetfjP4D24wJIVPMC9lDP2DEsJXAxihw3dExGSYuErWuqgtU6DmxF8pT1KpHh9W/Rtn953gAEqtSrrytN7vv9zVyB4PGmGMurdrxj2Qb5aLuMecYkBug6rlRJq1SwiMOwgbvkgznXlpusbzHOrCB8HJR/GG7Ve90PGrMChZuYXDjvgRyQltiyLO1W6m9fHKG+8eC0/5+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLsQWvgOJzii8cgKPWRVKhMVAPyNrXEe7KvKvqxSwYg=;
 b=Us9h3zxGMWHuKMvU7zcs7yTeWFEegeq4hRiADMwSbfalUItBxVjWV/efXsBagcCBXFJDkZw7/aZjDnvVz6+tOCWgYZEvSrwrSIs7wgMjvxVztjdrzem4JbkVZWdIR5KwJwkmvirHKcoz78iv8nYpBr9jeK8Xnw2/Ej+ljWtB+MWJbBXNC9iUqF0IQwBI4h2SN7RCGxxMK0X09YnQ/jPqvAtun4sQu2o58mIp9Y2RyOEAd9vONQydcL8M6M19pX+zBdGBB4n2hFl0N5fCRbHKq4/xlv2tHsO96icwzCnz6e+6JuXSIN5DtbIScktm/jYOZK1zVQrQskw8VPLDco4kfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLsQWvgOJzii8cgKPWRVKhMVAPyNrXEe7KvKvqxSwYg=;
 b=jW1AFieY/JXCPIoZbW3t02rJRW9NEbqOoQvuqY6gfdmR+CGICeK5/a9QZNVWsmY7WWmEVo4qOjFYQn6S45zMyyoR7a+eL6uhKVwJ12g7GMPaOyYiD+QNIqD8mgQTolY2KrZa88orrISrxx5eWifQM0s7lUfSFXsybLb/3ic+z3k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ2PR12MB8064.namprd12.prod.outlook.com (2603:10b6:a03:4cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Mon, 18 Aug
 2025 20:39:20 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8989.018; Mon, 18 Aug 2025
 20:39:20 +0000
Message-ID: <c17990ac-30b2-4bdc-b31a-811af6052782@amd.com>
Date: Mon, 18 Aug 2025 15:39:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
To: Kim Phillips <kim.phillips@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Neeraj.Upadhyay@amd.com, aik@amd.com, akpm@linux-foundation.org,
 ardb@kernel.org, arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
 dave.hansen@linux.intel.com, davem@davemloft.net, hpa@zytor.com,
 john.allen@amd.com, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 michael.roth@amd.com, mingo@redhat.com, nikunj@amd.com, paulmck@kernel.org,
 pbonzini@redhat.com, rostedt@goodmis.org, seanjc@google.com,
 tglx@linutronix.de, thomas.lendacky@amd.com, x86@kernel.org
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au>
 <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
 <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0031.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::11) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ2PR12MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: c14f7e59-e5a4-46e7-4af9-08ddde974eab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ak9VM2JXa3k1ckpDdXNpdWNyZ3hNMGV0K2tqeEF1elJUS0JxTVpjU2svL2Nu?=
 =?utf-8?B?RWozUGtJSnIzQThnM0VQV0JpMW1HRHQ0NGV4d01ySmRZTUxneitUQUxpSW5n?=
 =?utf-8?B?WklObjNiWkxHWHREWlBDbW9aUXlWdHVXRzNuUjlHLzlaTzdSNCt6aGlqQ2M0?=
 =?utf-8?B?bFhBYWFSQmQ1TWtrKzA4TllQUTVGZjk0Q3MrZkg2aGtaUkhpTGZPblBXM2t5?=
 =?utf-8?B?a3gyckJDbXc2ZFFwY0xaNDJTOERWUHh1UkEvVHZpVmJrUEhVMEg3OXlzK0hM?=
 =?utf-8?B?U2M5aUhweHI5cmlwcTZ2YmRma3c2azZjRmlHRzRKV0V6RGYvR240aENCaTBH?=
 =?utf-8?B?bVlTWXdaZWxRcmROOEcxWTlIcXZaTDJ2STg3ZENoQk5uUWNGYVpFNTNGK3BQ?=
 =?utf-8?B?NEhXc2h3cjMvSFBDaGRmN1RJVURhU0tDSmU1c0hGYy8vaURPUFVxeEtOckhO?=
 =?utf-8?B?NWp6WnFTM2xlMmFvdUhyOHNhSTgwQjd6bUFKaEVCdGJtRHNiMCtnK2tGaWhS?=
 =?utf-8?B?dG1WNFZodG1UWjJxc1V6NGtOL0s0ZHNaMW5zTU40Q1M5bk5QeW45Tzl6OE9k?=
 =?utf-8?B?K293cjRCeW9aU2RDL2FPSllZOVpkNExuRWlBVENpSlJLZWgyMVJXSUVMYW83?=
 =?utf-8?B?cGVWaVBlUCt2VUd5cFc5VEVncFE2NTlXR001WGdnTkdKcDNnOWQ4Z0h3Rld0?=
 =?utf-8?B?TFc2Mk12cU1RVWN2dFhtSWNiZ2ZRUXRIK3R3NUg2OVliZUc0OGtkODZHQUkw?=
 =?utf-8?B?RitTK2pJbFNQcThieE9pczZpQitwK0NKTlFwV3JRRnhsd3RNMWVyNVlHNCs0?=
 =?utf-8?B?N2pMdHVzZzVpdjBqbDVYZkNHTDJOcWpaVmN2TWpBNEZCVUhyWHNid0dNRkhI?=
 =?utf-8?B?QmFQWVZVNHBhZ0tJbTAyb3VMZ2dNMWZvckFFUlRIaWJEY3BxQXQ2cVczSEFT?=
 =?utf-8?B?SHlUMUdwNVlxY3pONzhSRTFVRUk3aWRKRmY0emlxSk5CM3orY3JlUjl0Yitj?=
 =?utf-8?B?eEpCdjMwTUw5bi9ENlBJTGd5TWdxUE1TRDg2UC81eXdIR1hHVDZXUnFHNW1J?=
 =?utf-8?B?dmpTQUgxMldpaDlxVWoraXNzV25FZWV6UWV4TkNIZkthclM1VjZ2UGNIL3VS?=
 =?utf-8?B?UWdRMXBVRWVQK1IyVnZ3R3h3TkdZNHMxTllQSm84QlhGNWowK0VYdllxTUJL?=
 =?utf-8?B?TFRYWFE4TGVHdndLRmFtQitHMmd6VzZNTjBabXZGdXU1SGh6VVJ4ekNpY3Rq?=
 =?utf-8?B?dWx4RVIyaVloYXF0NTNQRHZSZXNSeVhnd3E0UkNEZzJqQjNkQ1RyUG1ocnAv?=
 =?utf-8?B?KzY2a2NZSkVSellXRHVYM1N5ZjBiRlBVakxmVmJQS2lNRlEwdGxaaWF5RGl2?=
 =?utf-8?B?MUkrT3c3T1dTWGJDOVdDcEpFbldIc081Y0tPaVJpUStaQ1h4Y1RRRzF4ZGVr?=
 =?utf-8?B?V3ZJaXpSOUt2SU1JQ3FubnVsU0NLYkhpaExqdVpvSVBNNElqQklWQWRiVnh4?=
 =?utf-8?B?emRaa09hUlNZQkVJRVlvZUkrUlo0bWE4YnVoQUU0cHQvQ2lYZVE4UVRJdWM3?=
 =?utf-8?B?SnJEUEwxUUlxeXhBcXBWUTdVL2MzeWpzVXNTWHRHaUw5bnBUVy8ra0FvODRU?=
 =?utf-8?B?VlNUTTNreW85RmhlejVBangwaVFQcVAwNUkzN0JUQU43RlB4UFJ5M3RVQkJC?=
 =?utf-8?B?VDNEVFV6cVQzRlQyL3hGV3JISmhVZHp3QTlvVjJub2NPdWUvdGNlRzBUUDZj?=
 =?utf-8?B?U3NrODByT1NTRTZvQVBTZ1p3R2JmWTBJR2Q5Uko3UHloejRrOGQramxKbjVD?=
 =?utf-8?Q?Tlwdsy78xOgpIBp84IXlyyG6qIrqucNDWvDC4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWRzc0tRamVnemxkdGRESDFKeEFIYTFFM241YlJoclhwZE01T010cWs5bWZa?=
 =?utf-8?B?YThTSkpCWWNKUGNJZzBXb2kzNjdsaUZRQUtaT2dDTGV6eUc0SzJiQitDblYw?=
 =?utf-8?B?WG1TdWVnOWQ2OWdWZDhOeTlMNE41Y3ZyMnJzYytGa0Y2bG5lcEt4U0pkcmhL?=
 =?utf-8?B?ZTZYUWdGL21jWFhQYmxRZm5rUDErM3VDQ2xMdlZMM0xDMTQ3WDBhSHJtaHJ0?=
 =?utf-8?B?aHN6QlBiaXJJcnNZUXllaU14VnpsSHZXYXlvaWtKY0c3STNkVWNwUmdIeWJC?=
 =?utf-8?B?ejh6TFJRK2NrVWVmN1Bia1FjZHJkY2FxZzkvU05lSzVMcEs4UVVFZXRMK0N1?=
 =?utf-8?B?UDlYQzRTd0NVekZsVGpTNmZBclpvRklYeWxCWmpvV3o3TWpYVGtWOC9vSjZ0?=
 =?utf-8?B?YWk5SkV6QzlnSEFpQ0tiaUZIRnpDSG1rWWNjV3dLTXNWTGh1Z2wwcDlQcW9E?=
 =?utf-8?B?VktoTUs4KzczdUg2SzBrc2lZdXZGWWpVeHoybXdDODFkMmp1ZFJXd2xIMmxB?=
 =?utf-8?B?cGJESGVwNFFTa1kzTlRYNlFRM2daeHpmYWx5cm1POUdLYjJSVFN3NmpVWDNh?=
 =?utf-8?B?Uk5jVjJmWWNMTjZYeC9DQ2dTdlVSNWI2TEJpZXJtZncyODVHVHJuYk84NklB?=
 =?utf-8?B?bEFCY3VTdno0WVJpM201STlsbmlhc080eFZGVDMxalVWaGt2QXZIT0t6K0lP?=
 =?utf-8?B?N2x4NVZNUTFmdVNTTE5oc09LNjZsQ24yeTBqRUtLRWV2aFQ0MFBqdW5KREw1?=
 =?utf-8?B?N3VpR01SckVPSXpVYzZWaDNzRERNY290WFVLd3VkbFQ3NUlncG5venRyRmZV?=
 =?utf-8?B?VkltaXFWdHNIMEttMG5YbVFYNmtUTW9wUjUvd3ZGcjBVVnhlSkNreCtsOEtN?=
 =?utf-8?B?bzhGc0R4amsrR0ZZSWRzSjV2Z3A2bXNZRXZXS2RQWldFSUVqOGx2Mk02bUYz?=
 =?utf-8?B?TzlkVk1tbjlkQXJ0ZUp2Q09mRlB3YVduS2k4ei9sSUgwKzdDWmlicEdoWnZU?=
 =?utf-8?B?ZHZEeE4yQlNWMm5lTG1GUDV5R2hPZ3Q3UkFPMlAzeE95c0dVWTBDYitIQnE3?=
 =?utf-8?B?OFhRakJBdms2YWRJNzh0aXRFa0hpTStSVlR4UlRqcmpVMEdjQTZKbG12Y2o3?=
 =?utf-8?B?UERRcWJJRVBXZVo1ZllmSVFhZmhSb3lDU0J2U28zcE9NRzR5Tks3U1JFTnJC?=
 =?utf-8?B?M1l0QUJsL2NFb2ZPaTJWK2luYVAxeXppK0ZpYWM5QXFOd2h1ekI5SndRdGpq?=
 =?utf-8?B?dTlCRENabFg0ZEhJejNCaVdpZ0RaeStNUGNhRGQyazRvVnp6SkNGV3dmL245?=
 =?utf-8?B?ODQxNklJTm5YL2dmcjlMN2VrKzNIZG1VWHVET0ovd0kyOHc4amRnekJFdjdV?=
 =?utf-8?B?UFAwOHE1VEhGZzRHcStLT2F1ejFLYU15QmppK2J3dVVrSXNmMlJ4NTlPenA1?=
 =?utf-8?B?RWFMeGdQaE1kZ3JyYmFWRTkza1RtR3FwaThRM2JPSGFUZjVWOGJMMUFGbGMy?=
 =?utf-8?B?R01tNndlZ2pRbEdPbndpWDE2M1VtLy81RmQ2S0FqMTY2TlhPOGN1bjNrdGhW?=
 =?utf-8?B?cnM3b2QvaTI1MFk5WXM3K0ordG85TXcvemJ4UzU1RXlMZ1NpWEhBdjZVaVlX?=
 =?utf-8?B?Y1dPKzhjTFROWTNNMUtqT05tdmVlOXlMNU5ZMERUWGlMQnQwSVgyV0h0bHZz?=
 =?utf-8?B?MUZYOFhEY0tqcFN3c0o0Q2tCQzlBd0pmQ2NCZ0dzKzdTK1JuWmMzemFwUEUw?=
 =?utf-8?B?L0EraDNkSENvaW5KYnpDQnpGbUlpUjBhbld1ejY1cjVQMjh3OE9VaTdCTlNY?=
 =?utf-8?B?MjlXRlErU3RFemVPczJ1REJHTEtsM0E5UlF3WlE5ZUNROUNST3F5NWZERGpy?=
 =?utf-8?B?SWxIZS9jbzBVdzJ1YWl3dGpCQ0FMRVMyU1JFS3JWZ1gwamlKN1JhQjlHVW9H?=
 =?utf-8?B?ZlBrUEo4ZVk4eUNFNGcyUmZWZC9yYXlVMngza0NzNWpJeS9EVkZ1ZVVtSmtt?=
 =?utf-8?B?MlB0cEY2cUdaNU9YeThGNU0zbDI5bmU5WDZWcGk1a2JqYUd4aHUrOENQUVdm?=
 =?utf-8?B?VEM1ZlJhOGViRW5DejFsL1RTRDRUOU81VTA5QkdRamRjcTlEbnVhQy9VTUpV?=
 =?utf-8?Q?Tt9pQUykAHU+q38wjv73OUyqd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c14f7e59-e5a4-46e7-4af9-08ddde974eab
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 20:39:20.0118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gea1QsNyMwA/vwEYdKUf5K9dbYfg+yMiTut6xajCzbIMFu9AEk2616xwYGDRROHSvjHraPOrTfINW+2MvPWAjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8064



On 8/18/2025 2:38 PM, Kim Phillips wrote:
> On 8/18/25 2:16 PM, Kalra, Ashish wrote:
>> On 8/16/2025 3:39 AM, Herbert Xu wrote:
>>> On Mon, Aug 11, 2025 at 08:30:25PM +0000, Ashish Kalra wrote:
>>>> Hi Herbert, can you please merge patches 1-5.
>>>>
>>>> Paolo/Sean/Herbert, i don't know how do you want handle cross-tree merging
>>>> for patches 6 & 7.
>>> These patches will be at the base of the cryptodev tree for 6.17
>>> so it could be pulled into another tree without any risks.
>>>
>>> Cheers,
>> Thanks Herbert for pulling in patches 1-5.
>>
>> Paolo, can you please merge patches 6 and 7 into the KVM tree.
> Hi Ashish,
> 
> I have pending comments on patch 7:
> 
> https://lore.kernel.org/kvm/e32a48dc-a8f7-4770-9e2f-1f3721872a63@amd.com/
> 
> If still not welcome, can you say why you think:
> 
> 1. The ciphertext_hiding_asid_nr variable is necessary

I prefer safe coding, and i don't want to update max_snp_asid, until i am sure there are no sanity 
check failures and that's why i prefer using a *temp* variable and then updating max_snp_asid when i
am sure all sanity checks have been done.

Otherwise, in your case you are updating max_snp_asid and then rolling it back in case of sanity check
failures, i don't like that. 

> 
> 2. The isdigit(ciphertext_hiding_asids[0])) check is needed when it's immediately followed by kstrtoint which effectively makes the open-coded isdigit check  redundant?

isdigit() is a MACRO compared to kstrtoint() call, it is more optimal to do an inline check and avoid
calling kstrtoint() if the parameter is not a number.

> 
> 3. Why the 'invalid_parameter:' label referenced by only one goto statement can't be folded and removed.

This is for understandable code flow :

1). Check module parameter is set by user.
2). Check ciphertext_hiding_feature enabled.
3). Check if parameter is numeric.
    Sanity checks on numeric parameter
    If checks fail goto invalid_parameter
4). Check if parameter is the string "max".
5). Set max_snp_asid and min_sev_es_asid. 
6). Fall-through to invalid parameter.
invalid_parameter: 

This is overall a more understandable code flow.

Again, this is just a module parameter checking function and not something which will affect runtime performance by eliminating a single temporary variable or jump label.

Thanks,
Ashish

> 
> Thanks,
> 
> Kim

