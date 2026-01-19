Return-Path: <kvm+bounces-68534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 684B5D3B6DF
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 20:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A171F3099B1E
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 19:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C538F3904E3;
	Mon, 19 Jan 2026 19:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="AwITq2kb"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020134.outbound.protection.outlook.com [52.101.56.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BAE2BDC0B;
	Mon, 19 Jan 2026 19:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.134
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768849630; cv=fail; b=rof/nGexzv66gzMnMULi04DzKACE2mWfBFbHUZ339UhPtqE5nvjzA8URbLyNkx0H3gE5GQAWEou+oSoRDiDIa0Jr2lFlh9Zlo8yvw5SW5yWCtGTKBwyn/82nhFyl8EQJ+zpyrl0d2fHF80WkeueapgJetdB9Z9SRsckgFb4Ud2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768849630; c=relaxed/simple;
	bh=jTe8+dr9Q/H0V1FiPHZ5B3PkoO1tJ2hIdjZBJxmkyM0=;
	h=Message-ID:Date:From:Subject:To:Content-Type:MIME-Version; b=YRgUHT+xSBDZqswbhc3MAqvGL9xpH6N6O3hAndWP9AzmdLn5SSr9DYaCTrhifjLbmoJ060PLv+S/MSIBqBvBIwzbjh6ceNtm9pOBuLYPqxZf14EOvnprRt6jOSxqTwysdoYgYW6izjEXY+XZ9cfWYZRjPIApjFy5sJYixy3Ja4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=AwITq2kb; arc=fail smtp.client-ip=52.101.56.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kEW29rVDHxlf+zEW1C7BcAF7UCeHrcgb29MhrHnHAc/ORZfJH1TKdRSSCzxMX1hTqw2j4BycdiTEOst0U9NRBuIEINV3Enlxpl6I4LvkYO/yCp9bY2K2dtEpv2usk1UuqihKX0XdWJ7SV0sHMjF8n0HvhJS7gLaYcT251+0zDqU1us3I6O7BQy8di5mj/K2WfDOkNb+5mLJ0a2SKv66K5eZDVrIo1cKJNvbLK0pK+Q7RRABYb5yzKeWKWhLV1SRGipPvCrlXIV01eaqDxF/fcW4HFp0y2zGAuEazhJMfQye+fnJ44cX5UOHdz6LcH9BQi1hktW18S4q0NDXVdrIpcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDXAji7g/n84+KIcamihCHis8teL+qg7C0g+GKShucY=;
 b=Z029XzKdIZOJlL571Q/HgDBuZKMnd3Gr7SWTKm8tQHCSMTWx8+e17gKHxuU99QWZWMxDThRnQnDqcCp5TwfjNt8ZioShZrj++LQJmhUhvfeD0IQszF+8nmCAZwRG4h3GushWoJwOCfNlomnwR5003LNz+Ekkno2TlrL3eIdD/xhhaxShD6Yc3MdDMHWY/AqBq2H32HfxuukEXxnBtUhdFyBxowv7sCF2MoQuAKX3BulvWkiETK1rKfgq8gFT/6lGlTIuHUHX2BHGZa6W9+bEBk2CT88s8b71kTVzQZV2f1J1jKjHS5eodUytna5Q/HSlTpRWun545b9p78TjT/nhKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDXAji7g/n84+KIcamihCHis8teL+qg7C0g+GKShucY=;
 b=AwITq2kbqJL/jvAkkRuQ+4GraocR7LnLAx/UAs6ckG3y2zA3J3cZaXu3CqQ4o0OXO+rQCEduPju7+gLiRv8ZUvO/ZDVyYDCcdzREr9PJmwdOmAiSab3wjcBrfBU4whhqjBDMPO7Uygv/L3XBQur3pLtf+s+2fk5Sa+ZKQopOXmw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from CO6PR11MB5619.namprd11.prod.outlook.com (2603:10b6:5:358::12)
 by DS7PR11MB8781.namprd11.prod.outlook.com (2603:10b6:8:256::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 19:07:05 +0000
Received: from CO6PR11MB5619.namprd11.prod.outlook.com
 ([fe80::729c:2dc:b1a5:ff6]) by CO6PR11MB5619.namprd11.prod.outlook.com
 ([fe80::729c:2dc:b1a5:ff6%7]) with mapi id 15.20.9520.006; Mon, 19 Jan 2026
 19:07:04 +0000
Message-ID: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
Date: Mon, 19 Jan 2026 20:06:58 +0100
User-Agent: Mozilla Thunderbird
From: Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH] KVM: SEV: Track SNP launch state and disallow invalid
 userspace interactions
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080201000109070905010207"
X-ClientProxiedBy: AM0P309CA0026.EURP309.PROD.OUTLOOK.COM
 (2603:10a6:20b:28f::7) To CO6PR11MB5619.namprd11.prod.outlook.com
 (2603:10b6:5:358::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5619:EE_|DS7PR11MB8781:EE_
X-MS-Office365-Filtering-Correlation-Id: bd5948dd-8d1b-4bed-cf86-08de578dee6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODJ0UnV5NC9SdXlpZlRSUm4ydTZGK3ZRZUJIbitFZFZYSGgwalN1S1pLTFUz?=
 =?utf-8?B?ODl0NEwydFhpQnVTcm9HYlY2UGpJdGgzajNhaTJvUzNRTnZpSlp4c0lOMTd0?=
 =?utf-8?B?dzFzb0g3MWlxTElHcEFDWVViM2pNRzVFQjVMaVRzbTJuTmhmTlNOc0hLREwx?=
 =?utf-8?B?QjN6MkkycXNpWVVMclJiZndLaVJUalpnd0JCNVAxZWpVNXNZcGpLZXpXYTBZ?=
 =?utf-8?B?S1IrMFcrVEFaUTRxMlJ4QlBnZS9XcTJkTEp0VHZaOUR3SEVWa0NWaG5Kejhk?=
 =?utf-8?B?Nk1mOE9NUG9nRXZBOStteHBKWFhsZEpzRURBZjdIU1Bqb3hVOGYzcWtUNUps?=
 =?utf-8?B?N1AyU25Hd21jWlBWUlU5WUtnZkJyQlNETmIxVTRaWGVRNWgxTzRDTEMwenlT?=
 =?utf-8?B?VldoUC9vdTZxUnRDSnloUGpIRzZZNC9sQzFsSVkwbjhmR2F2NWZHL2FLYlpE?=
 =?utf-8?B?UmJDSXFWTnlab2tJMmkvZEttN2EwRzRHalM1c2V5Z3lWck9NUlNrMDRHWlcr?=
 =?utf-8?B?aE5XdWR6M0RNWUNLWVRDc2FsTk1TZk1UR0xDaEpUUkdYTFZkZ0Y3QWNBdEdW?=
 =?utf-8?B?WjhLWXRRQW85Y1RvSFdSa2dqZVU4Q3Y0d3I5bk1xVVlyanpveG1Fd2lsMTVk?=
 =?utf-8?B?YjcyQlZTWkVEK2tmd2VMdTZrdDhFdG96TGt6L3FqcVRQT3hoaWFEZVpsWlpv?=
 =?utf-8?B?RXVoMnd4cG5yTXZtT3hLc3pVVWdiK1hCcHA5SXU0RFNCY2luOWlBdmZFQlVP?=
 =?utf-8?B?QlBxVWE4a2ROeTJSa1JnSVd5S25SM3NmQTdIWVUwVkFRTTIxUml1d2g4ZDNz?=
 =?utf-8?B?RjlJNXN2ZXh5UVVoQmdOaXJRT2tISVA0cGZuZzdmLzFUMUpXTTMra1FiaW50?=
 =?utf-8?B?cFViaVNhQWxyWW96QkdxbnVCcnNTYzkySnN5SWJ5c3dHdCsrdWRmeHdYNWM1?=
 =?utf-8?B?K0pRaGM0cEdQQTZoYzVuZ1N1WkRLa0JIUGVZbjZ0U0tvYi9yTmVJTlFPa2ZQ?=
 =?utf-8?B?dVF6RFBvNmxROTZBNE91MFJLSHFVY05oQ0g5OFpBRWNrajNqQmgrRncySnZT?=
 =?utf-8?B?Rm1qekxCSCtzZEJjZXFNc3Mvb3RobVVxdER2NUlTNlRCQkZRZUZRWHRnSWhH?=
 =?utf-8?B?NGdrQ2xzaUlHRWdMempyNi8vaVp3OXUvNnlCR2NTSWNOcnFRV1lTSjZSTlN0?=
 =?utf-8?B?R0N5L0JkaDMrOW9GS25vQWFOVHZqQ3Y0amtnYmNRT0JGL0FrdElKWjZ1dHNV?=
 =?utf-8?B?NURaem9QQlo2VzFwL1dpZWd5V0x6ZDgrN0R2YStqMytuQkRZb3pBNEN5WHRl?=
 =?utf-8?B?YVhuWU1vRE5uZ0dCMk9lU2NBdlNKS1ROWU5NbWk3T2tVRDdER1lXVTFsaVNr?=
 =?utf-8?B?YSs0aHVNczdSN1d1elhvYStjWEJEeHpMQ2tESWo1Z2JCdjA4NlJ5VUhiRVRh?=
 =?utf-8?B?WUYvdnNkc0NoTTRyWU5wWjZLZmdPQ0M4UEpSM1d6SlcxNFVKbzdYMi8zSG94?=
 =?utf-8?B?NTloVTRwNFp5TFFFWlZpeTFMalk0akZIZFdLeTlqQzZkaFUrcEIybXZGS1kr?=
 =?utf-8?B?SHdiTmR0OUxJV1V5eHk0N3VxcEtHblZNbklNSnl4WWlqV2g5QWd0bFgvdEcx?=
 =?utf-8?B?Rk1WYWlwbW9DcUJQVzJoSGpwd25BZmdrSXB6ODlwR0hmZys0ZXRZS2EyWlpj?=
 =?utf-8?B?Z0dVY3Jiam5BL3VmbWM5Y0N2Vm8zRTVqbjU3MXhpaWlzenphWlYrVlhTUFlP?=
 =?utf-8?B?eTl0enFaR21xanZWVEdqUExvSHZ3a05rMWg1Y1JTWnV2Qys4OExQR29RcHdz?=
 =?utf-8?B?N0JmMjEzRlNsUnh4K0gwUkpmQ1c5K0toYjYvTTdsWEJTQWFkeGo0eHdoTzhU?=
 =?utf-8?B?T0Fpd0VKby9KbVVIMG5qeHVCM3k4YWVleWp1MXNXbStBZWx1RmJrakxMWU5R?=
 =?utf-8?B?aVNNNXNHMmo2aDVkNXVtTXZYRGpUMDNqL2hDRmt2bmdOUVMyOFpYeldyNzdz?=
 =?utf-8?B?NUFsNUtZakZsZWZiTjkvaXN6Mm1TcHJ1WEZtb1ZGNFF0eGhxcEFIa1pJS0xE?=
 =?utf-8?B?UVRhU3RHYVY3dEdDbXdFQzlKWERCS0c0NXVwMXZhSmdnTFNnUStRTlpQMkV3?=
 =?utf-8?B?dDVrcUlGcWtLbDBJUWxpNkRnVWI0aEkwbk1TNEc2MTJQMFgrbFhuVkQxYVIy?=
 =?utf-8?B?RGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5619.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHZyY1V3Z3BsZUdOUDdibndENXJFRTRSUHZUd3oyWmVWa3REc0szNW5BNjkx?=
 =?utf-8?B?NEduTTVRNXNoS0F6Ykh6eFd4a2xrbEpaakJ1NWlBYjhZdzNadm1XNXBuWnEr?=
 =?utf-8?B?eklDSVRJakNGUjhQN2Y5VXNMbkg5ZCswM2VacnpJQzFwajV2WnpwMFkwZi84?=
 =?utf-8?B?enlqbm9ZS3VZcUMwNk1IY3BKbFdmcWN6OHVHOUxFd3BjRmZwc0dXVmRDL3VZ?=
 =?utf-8?B?OVdmbnNxSTlmdFgrMkVObkc2eTM4VFlNczJDWXhGbzVYa0Fpa255UFBrUTVM?=
 =?utf-8?B?b0sxTjF4SEVtSEFWaGRRTFFMNmRBOWhGRUF2U0wvTFoxYzY3VHpKN1I4OGhX?=
 =?utf-8?B?eEF4Q1J0WVFmVk1aQWNKK1BXOUJ5YkhySndCUmRtRWZMdjVPZzVzcmF4b00r?=
 =?utf-8?B?NlhEZDFJUUQwcnJ2NVpJMURhb0w0UVpDN3o3RmxLQk1PaFlKWFZhaFFQY0dv?=
 =?utf-8?B?ZUc1MFNIS1BHM0ZMN3MyZ3MxOHAvV2lqSWdGNFJuQTdaSHRNTlkwSGVCOUZu?=
 =?utf-8?B?MXpVTDRLTllLa3k4aWlMR25JTE1mQzk2Z09qRVlPcFNxaFBMdDFlOEdVaHRk?=
 =?utf-8?B?aXVZVS9QM2xXWFdXbjM2RDRRTUJ3SUlHa25MQ1cwRGhrNkJ3UTh5dnJIM1BD?=
 =?utf-8?B?dDlFV05UZTZvMU1Jbzd4eG5WZTlLcGdtK3RGVGp0RGRFRkJ6OUZXZTlrWlht?=
 =?utf-8?B?ejR0YWsxZmV4eVdXdy9meVJGTlVwMEZ3ekh1MWtaejNNVHZOSCt1ZjN0NkVr?=
 =?utf-8?B?ZU9jK1NweUVQa1BNVEp5OE1SK3BGRHJWeUNNSFg1NTBKN3RWanFGV0FVMEM2?=
 =?utf-8?B?T3N0VzcvOVdYd2o2WDhWd2hscWptZm1HVXh0L3ViVGhQcXAyT01JWDhoYmNU?=
 =?utf-8?B?OURyc0w1M2t3T1RlQVNxamxIWEc1NTRTWXJZZTRiZUQ1VXFvcUtmcWVCcVhl?=
 =?utf-8?B?VUhHRVBwMVRHYlJ3dWVDNHlRNlZmVTlDVHdKVVFSTG1NT1laeG9BVWN3WDdu?=
 =?utf-8?B?OS84a21qTUJ0MTdjT1JHQVAzRTRvSUt2YmtOK0QwOUtFWEN3Wm5jZjlLdFhk?=
 =?utf-8?B?YXhsNmZTL1k1bXhBV0VxVlN2Q2FGUXJsNTNCTW9QaG90Q0dJTEpiRFFHajgv?=
 =?utf-8?B?VUNqTWg0VS9tN0JWQit4dGZzaXJOc3hSMVEwL21ST0QweVFRUUJLeHZhclZj?=
 =?utf-8?B?Vkpxd25sU0JncHRLWFhRekpRSjBidVY2TFFYM3cyQ255RXJHVk8yVmUyK1V3?=
 =?utf-8?B?RlFiVVJHZDRpS0h1S29tL1p1Smx2UzU3a3hWSFYwWlorZmZnQWQvMVhBV1hz?=
 =?utf-8?B?QUFhcGpWY0ZhUkNrb0puYXF6bTE4OEFwcWlTemRudVhDK0hUa292V2F3MUVH?=
 =?utf-8?B?cCtIZ084WHNFa3U1UWVvMFFZeU54R1Vna1AzSTZwSVpTUTR4SWRZMzQzMnZQ?=
 =?utf-8?B?NkVGQXovcE1HRlhyd3NvUE9lYVo0SmNLSGdTaHBJTXZweEJkakdYcDNINGdU?=
 =?utf-8?B?T2YveU1DSVVvaVBNakVuNVJQWVpvYVBoNlM5SVJZb2g3N3BENVRmMXpEVzlK?=
 =?utf-8?B?aExVTU9sZFNuV29qNW9JRVpPKzlmQ3VONUwrZ1NQR0NyakplclJqeXp4ZlE5?=
 =?utf-8?B?MDNGcnpsbGdxOE0vZGpLSjBUSnhTOHBhb0hIU3pGbkNwN09UZmRSNytOTUx4?=
 =?utf-8?B?Umtja05pZExrUUZIeGlEZG1iWUM5ZTM4UnI0aHZHS3pGLzlIVW14RldrS040?=
 =?utf-8?B?cm9waHFIcXJoMmFQRWVDanpHWDgxTXBSdnUyam9Md2VNOHI2Tk15Y0luWXhr?=
 =?utf-8?B?NXR0WnlDbENZUFBHdEwyKy9NY2hxZWdydmZMTHdyb05SNUUyT09zU3RsNlRB?=
 =?utf-8?B?UzgvZUhpYms1ekprU09sZHYxQllLQ1BXOFBTeGZ6YXRtdUxNT0JGL0luRk1F?=
 =?utf-8?B?aXlWUjRoWU9BdVVTK0xwb0dvcE8xTm02d3IzSnhGbjFPTTI1S1Q2aTdCU255?=
 =?utf-8?B?NStBZitUdC9pam0rWXgwU1B4MXhNbUhJVm9GOWpLZ0FZODRIYWVvOVQ4dmlz?=
 =?utf-8?B?VlpuRE9GOVBPbWNtUmxpZkcyNERIeXlCdS9ydWh0blh4cDdCa0JxWXdYa0JW?=
 =?utf-8?B?Y0R0R3hmM1FtSG1mQ3FIVVRRbnpOYU1VclR5K3h4ZUE5VmZlQndGTHVpaFhh?=
 =?utf-8?B?RUMydGlwdTJsOCszc0hidFZJcW5BVmpXc3E5WkF5VDEzQTVGM3drUlptY1Vi?=
 =?utf-8?B?UTJXSXNRZ0p4T0NWcVlUTzdxMzNoaTJ1VTVTYWJQcFRMbW44TkF6aUlwZncw?=
 =?utf-8?B?ajRUTVhSKzdyRGZveTd4ODVacXFGcWxJSHlqeUsyUXRJVnkyQWdYQT09?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd5948dd-8d1b-4bed-cf86-08de578dee6a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5619.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 19:07:04.7699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/mTQ1uIzuzG/TpXqENosgtICgi+1JWndqvAHnBXPiwjBmfGqIVTJ3eu4r0N4gTOEZkKp8pGDKNq7nyWQDwoIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8781

--------------ms080201000109070905010207
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Calling any of the SNP_LAUNCH_ ioctls after SNP_LAUNCH_FINISH results in =
a
kernel page fault due to RMP violation. Track SNP launch state and exit e=
arly.

vCPUs created after SNP_LAUNCH_FINISH won't have a guest VMSA automatical=
ly
created during SNP_LAUNCH_FINISH by converting the kernel-allocated VMSA.=
 Don't
allocate a VMSA page, so that the vCPU is in a state similar to what it w=
ould
be after SNP AP destroy. This ensures pre_sev_run() prevents the vCPU fro=
m
running even if userspace makes the vCPU runnable.

Signed-off-by: Jethro Beekman <jethro@fortanix.com>
---
 arch/x86/kvm/svm/sev.c | 43 ++++++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..cdaca10b8773 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2205,6 +2205,9 @@ static int snp_launch_start(struct kvm *kvm, struct=
 kvm_sev_cmd *argp)
 	if (!sev_snp_guest(kvm))
 		return -ENOTTY;
=20
+	if (sev->snp_finished)
+		return -EINVAL;
+
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)=
))
 		return -EFAULT;
=20
@@ -2369,7 +2372,7 @@ static int snp_launch_update(struct kvm *kvm, struc=
t kvm_sev_cmd *argp)
 	void __user *src;
 	int ret =3D 0;
=20
-	if (!sev_snp_guest(kvm) || !sev->snp_context)
+	if (!sev_snp_guest(kvm) || !sev->snp_context || sev->snp_finished)
 		return -EINVAL;
=20
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)=
))
@@ -2502,7 +2505,7 @@ static int snp_launch_finish(struct kvm *kvm, struc=
t kvm_sev_cmd *argp)
 	if (!sev_snp_guest(kvm))
 		return -ENOTTY;
=20
-	if (!sev->snp_context)
+	if (!sev->snp_context || sev->snp_finished)
 		return -EINVAL;
=20
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)=
))
@@ -2548,13 +2551,15 @@ static int snp_launch_finish(struct kvm *kvm, str=
uct kvm_sev_cmd *argp)
 	data->gctx_paddr =3D __psp_pa(sev->snp_context);
 	ret =3D sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->erro=
r);
=20
-	/*
-	 * Now that there will be no more SNP_LAUNCH_UPDATE ioctls, private pag=
es
-	 * can be given to the guest simply by marking the RMP entry as private=
=2E
-	 * This can happen on first access and also with KVM_PRE_FAULT_MEMORY.
-	 */
-	if (!ret)
+	if (!ret) {
+		sev->snp_finished =3D true;
+		/*
+		 * Now that there will be no more SNP_LAUNCH_UPDATE ioctls, private pa=
ges
+		 * can be given to the guest simply by marking the RMP entry as privat=
e.
+		 * This can happen on first access and also with KVM_PRE_FAULT_MEMORY.=

+		 */
 		kvm->arch.pre_fault_allowed =3D true;
+	}
=20
 	kfree(id_auth);
=20
@@ -3253,6 +3258,9 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
=20
 	svm =3D to_svm(vcpu);
=20
+	if (!svm->sev_es.vmsa)
+		goto skip_vmsa_free;
+
 	/*
 	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
 	 * a guest-owned page. Transition the page to hypervisor state before
@@ -4653,6 +4661,7 @@ void sev_init_vmcb(struct vcpu_svm *svm, bool init_=
event)
=20
 int sev_vcpu_create(struct kvm_vcpu *vcpu)
 {
+	struct kvm_sev_info *sev =3D to_kvm_sev_info(vcpu->kvm);
 	struct vcpu_svm *svm =3D to_svm(vcpu);
 	struct page *vmsa_page;
=20
@@ -4661,15 +4670,17 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
 	if (!sev_es_guest(vcpu->kvm))
 		return 0;
=20
-	/*
-	 * SEV-ES guests require a separate (from the VMCB) VMSA page used to
-	 * contain the encrypted register state of the guest.
-	 */
-	vmsa_page =3D snp_safe_alloc_page();
-	if (!vmsa_page)
-		return -ENOMEM;
+	if (!sev->snp_finished) {
+		/*
+		 * SEV-ES guests require a separate (from the VMCB) VMSA page used to
+		 * contain the encrypted register state of the guest.
+		 */
+		vmsa_page =3D snp_safe_alloc_page();
+		if (!vmsa_page)
+			return -ENOMEM;
=20
-	svm->sev_es.vmsa =3D page_address(vmsa_page);
+		svm->sev_es.vmsa =3D page_address(vmsa_page);
+	}
=20
 	vcpu->arch.guest_tsc_protected =3D snp_is_secure_tsc_enabled(vcpu->kvm)=
;
=20
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 01be93a53d07..59c328c13b2a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -96,6 +96,7 @@ struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
 	bool need_init;		/* waiting for SEV_INIT2 */
+	bool snp_finished;	/* SNP guest measurement has been finalized */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
--=20
2.43.0


--------------ms080201000109070905010207
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ZmljYXRpb24gQXV0aG9yaXR5IFJTQTAeFw0xOTAzMjYxNzQxMDZaFw0zNDAzMjIxNzQxMDZa
MH4xCzAJBgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjERMA8G
A1UECgwIU1NMIENvcnAxOjA4BgNVBAMMMVNTTC5jb20gQ2xpZW50IENlcnRpZmljYXRlIElu
dGVybWVkaWF0ZSBDQSBSU0EgUjIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDm
Q+3UxwVE9dAx75DUrLZwgASWLLr/ID8bbGCfpcrSHIRsrR4ut5n49JGViu5DYE6addkpajbi
MA2Jaw1Ap4RncDjZ+0fzSWbqGKEE+vNPVLoKy7OVIrxf/9HzGUT6YaELSNrGTR0cYNcR+W5b
E3JTxTMQiLMAwBbMXH4qKXQUT+oyIXD11CIMUtM8ECoo2o7qdpw1zaZWwVvhXy9mkAaRgrkw
2NpddZUVbJKF/spsJa3lNVdSi3wcJpDDQAl6jxtBF/3ctkY1OjBQz32yRlArFymsPc+we9ff
HAgvfqbHVfXvgWG8urVith8/6MjmojHMCKqFoJueLbtTPoN8QhvVh49uoRYYAUUH0HOAYCOz
GBGrdJvMIYZqQsX90XlU7Qxp1En7vMkQswkQTvGmBPWrK/EwSAJc15BZm+i8QBxPqVKFORfL
ETLEC4ZrwomtW/oPxBP8zXPvQ0K1dQzAkw+JXxKv/KiwDryFFhU5xMMB3yKxO5NRYXlnqW9n
wfhdBTJScthzAtGO9KZQ2GPmq0NMVMuXe1XdCOmnPxOptKkMldBItkaYgrkTzqP1nzIAhVfU
4sNnHIxKPftwrZ9VMSc5Wkz88bOtAJyz3KQRY0qcAtR4LaeRkiZaEmprQA8EOpdJxtv03pBZ
taUnnTY6DsEwGQ0+P2mmB5IHB74SknyNswIDAQABo4IBaTCCAWUwEgYDVR0TAQH/BAgwBgEB
/wIBADAfBgNVHSMEGDAWgBTdBAkHovV6fVJTEpKV7jiAJQ2mWTCBgwYIKwYBBQUHAQEEdzB1
MFEGCCsGAQUFBzAChkVodHRwOi8vd3d3LnNzbC5jb20vcmVwb3NpdG9yeS9TU0xjb21Sb290
Q2VydGlmaWNhdGlvbkF1dGhvcml0eVJTQS5jcnQwIAYIKwYBBQUHMAGGFGh0dHA6Ly9vY3Nw
cy5zc2wuY29tMBEGA1UdIAQKMAgwBgYEVR0gADApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYB
BQUHAwQGCisGAQQBgjcKAwwwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybHMuc3NsLmNv
bS9zc2wuY29tLXJzYS1Sb290Q0EuY3JsMB0GA1UdDgQWBBRmj6a8t5Msnfm6SeVP3OqQUBFq
nTAOBgNVHQ8BAf8EBAMCAYYwDQYJKoZIhvcNAQELBQADggIBAMJr11ncGIPKbaZxuuU2P1TG
yXF+gy+xH2TBNWNliJVL613nH1J7L2WcJQzqXYl77rKTzGeQexnKeYZ13MFwuE80vISif/gw
K569WLoyCvNVvGEZ2bZ+JL5K49mVhrv1gqO+MgMvc8iEENl1xoWRpJGD4EClk8t4u7NUCgBv
hYORiyzHCZcILHcEMvfEwmmFshMN6TqcAJdRjFT0Ru0hJcs5d7EFdM9dCa5ckXWrKK49cSNq
4qOaxqpG99EfDw6U2c70YcJ1/IhC1wL6z8qlGvhYQ0vJvqGJqW/DdeuWcMmrB+qZL9WbORQ1
nvlNggB6smEk0pXXYBr8HYjxT67XwtBBmkBXFpa7G6y4P0BO3kxWGBfvRBJHfyaiwREgVWa3
6V/WjXtPmV8VHcv04Rqgk64E4OlSUxgi9k9VC6kivTXJN+Gg2uJJBQdf+ptVhJqkkrtB0gAB
F+kQP0xsagKkrS3NVrVKo6peWMx0h7l52bGqT8ucu4Qe200KQi2xp/r8jpP60EE9U4M8D1gr
H3Kh9OxVOL4wykdoC/yGJNLKIl0BfsCVWB/GeSq5hxe/84K51OEJqpjDnOMrkRevfVzqGBFF
Aeg7Kg7uSysVR05wR+ltp3ytaIbjGJtKad8raIbM1qiNFErG7YB7v4baI3BP1s/rTDtPLoto
tahwHP7IqOHOMYIFVDCCBVACAQEwgZIwfjELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFz
MRAwDgYDVQQHDAdIb3VzdG9uMREwDwYDVQQKDAhTU0wgQ29ycDE6MDgGA1UEAwwxU1NMLmNv
bSBDbGllbnQgQ2VydGlmaWNhdGUgSW50ZXJtZWRpYXRlIENBIFJTQSBSMgIQNfphqrZnvSlG
TcM/9wjbxjANBglghkgBZQMEAgEFAKCCAxIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMjYwMTE5MTkwNjU4WjAvBgkqhkiG9w0BCQQxIgQgdpq6Emu745F2
yoTBLbK9wV5OCuGdSDEjhM9yw8j6QJ4wgaMGCSsGAQQBgjcQBDGBlTCBkjB+MQswCQYDVQQG
EwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoMCFNTTCBD
b3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1lZGlhdGUg
Q0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIGlBgsqhkiG9w0BCRACCzGBlaCBkjB+MQsw
CQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoM
CFNTTCBDb3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1l
ZGlhdGUgQ0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIIBVwYJKoZIhvcNAQkPMYIBSDCC
AUQwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBggqhkiG9w0DAgIB
BTANBggqhkiG9w0DAgIBBTAHBgUrDgMCBzANBggqhkiG9w0DAgIBBTAHBgUrDgMCGjALBglg
hkgBZQMEAgEwCwYJYIZIAWUDBAICMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgQwCwYJYIZI
AWUDBAIHMAsGCWCGSAFlAwQCCDALBglghkgBZQMEAgkwCwYJYIZIAWUDBAIKMAsGCSqGSIb3
DQEBATALBgkrgQUQhkg/AAIwCAYGK4EEAQsAMAgGBiuBBAELATAIBgYrgQQBCwIwCAYGK4EE
AQsDMAsGCSuBBRCGSD8AAzAIBgYrgQQBDgAwCAYGK4EEAQ4BMAgGBiuBBAEOAjAIBgYrgQQB
DgMwDQYJKoZIhvcNAQEBBQAEggGAeNsiXqHCpii1cQ2WxgPAli+USTcfu/4EhoJWb1aapddh
CdRxuwxSUDFXifjhphbKfv1Eu6y1AVYj2d8hEdOEp2k5GUOOdzoihtxr/P2+yeaeJOvILS14
yPh3fAL8N3bD0gG0lVEOnuNiCUtTkwmQlAOzU4pK0/HQEWjLYxxE9zTDW4tk5w32XxVC7aLY
wuT91BixaIOY0uonN0NHJQe1cg8PZj1aQTar0M1y3AYw0jyP1zVRcgqDfS9C8uyvdJFFpzok
0MKp+WzEmawNhxWFEucfLc09xJCHYZAuZjASmfWQ11RW2+f9I7SEVyHTeVq868MYFQVAdw2J
ld3QVvMhRy7RLEH2RdjJ7U5LkvzTrK63K6c15Fa7q0ate1qPTsxcE9LMtQuht8FeROHdp2ez
XxzpDaA1DINgR35aJ6HS8BJaINGD9MPXgqnylqNwGZ3V2+HzVVSI7qV7ueJ4aKCk60DAr6tH
Hntt07nFbM2lqivfbVvCF7uWO1hOVRq1auw5AAAAAAAA

--------------ms080201000109070905010207--

