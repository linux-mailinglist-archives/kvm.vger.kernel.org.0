Return-Path: <kvm+bounces-34480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5419FF7BE
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 11:02:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B43071882D5F
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 10:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0076719C543;
	Thu,  2 Jan 2025 10:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Db0CHi4M"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7E528E3F;
	Thu,  2 Jan 2025 10:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735812128; cv=fail; b=DShsUJ5F/VHw4QtZpHhurRZ/X2Av0I/vpYo3z0rZb+2y9zA5qqpBZAmg5epSMQbH7ttK6IMj3X2AqpvDfbcfr94g0hO3t3vBqWLGLMzzhuE50CYHX3j/R1+y+r4qGw8qVMGIWd8NHEAzULsD0pFyvNYAQMQPLJPZezJJrPRZ2fg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735812128; c=relaxed/simple;
	bh=AqZS8I6QgixMXpmPMkw0XzSHJoTes8OZhXH7xS6Uxs0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z5/+lD5cQYrexRO25MdIfH47tqjCOCx+64r6qn0sT68W1XIRFW/uVjUx2Ky4e4Us8tlLHG1sxfwPih/NujWdkyIrAeemdKZgV7RaBOI3Jaz/mtZT+sBRYBWACfTJzM9wza6GG+OrChWMxO40iP+Lkx6Swl8vuU6ZhNoDRi8ew/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Db0CHi4M; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQZJ8hAnVPYAdw1pVSOHQjraypGq6Ptl4m2oToB/69JGNDEhUcVq3ceuVOM9ZGHb/3t8FEstssl8VLNti4T1jx3L1zgmJcRqvDvlgPd536u/z10UFKIKxTslnm0LO4fasX8JksSVmISxrIXZMEdZLd5yy3aDPHhjQBAUF9/0ARqv2Lj382GNjNScziRT6Lll4fEoJ1OUn8/VxBVjHBKdLREU0VsgOvy+6I3ZNp3yibY+GWFDUZFD3q52i/Ee/FkPTsgXfNMeDyI5Yoc0OnWEQlDJyu6dqVoWUp7LDW+zfkdiu4aTDCY11/yyhHPn070O6bgGHmLsQI6MQqFBqOJLTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOgp7AzdRGsPSAyw7h8hAJGBbuGqCRtE1IjMLrn1bA4=;
 b=SBdPvXVyLAcuoDB9J7ZbO/dUWg9sP9nhU6C6YVW8PE51GaIXUXoqNB3nAXzvYi+tOSMaiTgssAPPtb8X14X0CyKIWk/9p6RVfvY2OVkcXuDZf59TH49/1pchciItQ4Qxoc8RTR9HfdUxfGyXIpHqwy3qVrRTaA1u1KJliWCoMdlx1Rs3s8EJuk0FeHi6xDVQAs5cOkGLMmv8yMHXEaU2Q1RFv72TTygF7RdQl4VOo+fJwm4/0J1//BKP6gdnH0YuJn/kCG6SQKc3Jo2eBP1UjTbKw5EXiYaxQmaNVUucUd52pSXY6wHkkEalS///eHTUqR5PW91WTP2kZLQn3je84g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOgp7AzdRGsPSAyw7h8hAJGBbuGqCRtE1IjMLrn1bA4=;
 b=Db0CHi4Ms0wbv5LnDF5dGorhz2y5Ve1C8UmknKNqclneAIr7XoD91xkZ/ZE5gA6bCnXLjYlRHxPpzeaeHOZWQgLVu/B8mk5gny+AYVumVuQZKZR9dHO9LW7ljGNunbP+sNMbjIPF8WkXhsLOX5kvLWG/BaYC9OlYi2QwHt8cXVU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM6PR12MB4074.namprd12.prod.outlook.com (2603:10b6:5:218::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.13; Thu, 2 Jan 2025 10:01:59 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 10:01:59 +0000
Message-ID: <cc8acb94-04e7-4ef3-a5a7-12e62a6c0b3d@amd.com>
Date: Thu, 2 Jan 2025 15:31:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Borislav Petkov <bp@alien8.de>
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
 <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
 <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
 <a978259b-355b-4271-ad54-43bb013e5704@amd.com>
 <20250102091722.GCZ3ZZosVREObWSfX_@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250102091722.GCZ3ZZosVREObWSfX_@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0229.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::11) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM6PR12MB4074:EE_
X-MS-Office365-Filtering-Correlation-Id: ca52786a-f050-4167-cb52-08dd2b147f0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVFFTXpqSHJsRThSb0EzdEFKRVBJM1dRRm9TRlRWMkVXU0JubDdJcnVVblN5?=
 =?utf-8?B?blVka3Fhc1ViekxTVks0dVdyWjNNOW1vTTY5ek1USlN4Y1lQa2czSWUyNzht?=
 =?utf-8?B?bmFPV1hidGlETTN2RGZ4REhXWWhwUTkvS05leUVWa09BbjlZUUFyaUd0aGdw?=
 =?utf-8?B?ODBoNmIwdHdHVlNmb082aGxFVHN5a1h1ckJ1OXdyclZQc1krSUlhL1lacGVt?=
 =?utf-8?B?T0hvK3pxYTJCUmZvR0dhVVFpcjJiWXJxcWJWTG52NTRsbXdMOU5PU2xJdk5F?=
 =?utf-8?B?UWNQNHhUbDlkbUoyZEJvUlkwQ0JtdDM1YnFhS3FSaWhYTkRVWWxFWnRlb2hQ?=
 =?utf-8?B?azhURXdNazZGVXNyc3RWay9nMUlnVkZJb1haT2JxQWJEUExOVWtGcW9PRzFw?=
 =?utf-8?B?cHlVTm5TK0FsUHVPeTdHUzgxcGRyY0VOTEh4NitBc3ptSWpDRG8wdFhGdWZN?=
 =?utf-8?B?bnlOK0dNcGZhc21zbG5rTEVjUWJPTDJRVE1OaXRETEVGcjZ1ODE1eWxZN3g1?=
 =?utf-8?B?WXZJeVNLWWpIVHgzNGpZQjFCbERYdHRtM0ZFZE5uL1QyTTRBK1daNm13YTZM?=
 =?utf-8?B?ZjNjZkdBMHZ6WEwxUkthUXRiYVpFK1dpeWJNcXc0RTFsRTRTV3NuclpYUHNr?=
 =?utf-8?B?R2F1NXY2OWt5QjNZWWNrd1B3MzdSZyttSGozdGpPdWVaWXl6UXZ0RkQ1eEF3?=
 =?utf-8?B?aEJ0UkVicDBCUUFGVFMwc0FsRGdiU1hYdDZabzU4MFMwQ2xITmpJMjhYUFp4?=
 =?utf-8?B?ak00WERGZTVDWGtaUngyeGZvMHMvRk9WaW1OdlZabGE1OGdtcGVZK2ZkOXYr?=
 =?utf-8?B?RHNFdEZzMUs2T2RqRmZMQm1uTHZqMFRCd0U3NFEyVG80cjRLOWtpM2NESDJl?=
 =?utf-8?B?c240UTBqdU82Yy9GQllYSXdyWDRNTjNCQnZ5OUtLWS8ySFIyVG1IS2Q3UG9p?=
 =?utf-8?B?bG9IM3VuQ1RkanZuRi9neVRWa21yNlh3T0thSHBEVWYxMHhqUmZiMWNYajdO?=
 =?utf-8?B?TEJwazVqaGZCUXpwWDczaG5aZFhlSGdTOUpTNjh5ZzlqNGVWUUt0ZE52NFhR?=
 =?utf-8?B?bXRydm92aVRJcTQrTFBrRFZSeGY1Vytac0NTOTJid0R4MHBQVTlZNWRyNDhG?=
 =?utf-8?B?OGpaNXdjRk90ajRaM1ZQc2oyT2ZxTlRtUEdiQXYzdGw4QjNPZGNQRldjN3Vl?=
 =?utf-8?B?RkhDd1ZkWXlkUWZjWVNpMS9rZDNaVWtxSXlRcGZWeEtya2EyQU9KZCt3MjQ2?=
 =?utf-8?B?VFhZeTB6NGVJdWJVRXV2QityUnpaWCtmcHNzamxBMjdtTW0yaHZXTnp5c3VK?=
 =?utf-8?B?YXc0RysrNkl2ZFBodEcrRnFvbDduSTlDK3FrZzFMbElPclhuVGhxUHVuUkZZ?=
 =?utf-8?B?eW9iUVJuZ29DVmw2YUtEVEpWeGtaa1BMc2lzMDhpdjJSRHlvZ3ZoYnpRSnRw?=
 =?utf-8?B?eXk1UEVhZXRaZXViSXdFaUlTdGZubCtuZElibWFCayt0VjI0bGNpOUloYS8w?=
 =?utf-8?B?Wnk2S0hZU1l0b1p0dVFUOTQzcm11UHJpc2VubjBWWlYxM1JubXE3aWIrdmpP?=
 =?utf-8?B?VXJhTzd3b3V4S3FUaXg4SlIvRzlpa1B1Q0VYZDZNVS8rWlU3d1doNFNlaCt2?=
 =?utf-8?B?Umt1U2RIM1I2NW55OG1OZVc1U0o4SXZmTW9haXJ4UnYvbzZlMzhKV3M0eVRt?=
 =?utf-8?B?TzFsdFNUSCtjVjY3MmpHaW9ia1JxZlByOUJIZkkvc2tybS9aTTRBVFpzMmcr?=
 =?utf-8?B?RHMycjExeEJlY2E1d2tHTUNSRXdvZDFUZE1rNzJOQ2dORGszQzFqbTNDRitC?=
 =?utf-8?B?NDBieWljczRYb2hjYVM2c01ZOURLeURqY3BHVVY2ZXd2ay83V280VUs3UHhF?=
 =?utf-8?Q?9JDH1BnkfEBru?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWtUUVhOSkxyOHdEdTFvQ1FZaDNpVzYyRDFiU0syZGlTOTVPNlBjSGhNbXc2?=
 =?utf-8?B?bTJJaXdITGg5RytHbHNGZ0kzYVhMdXBmZjNnczNjT3laS3ZlYmhrS25QRnU1?=
 =?utf-8?B?cFNtV0FSb2RlWHNzKys5RE5CL1hCTU5BMFZVYjM1SFg4MEp2bFFsSFI5Y1g5?=
 =?utf-8?B?dmdrOGtNNmkweSs2RTFTRFl2Wml2OVUvckljYlNsa2Z4RDFScUVYUmtqZmFs?=
 =?utf-8?B?aWVMR0VnVXA5dC84cERFeGx1UDNQRk5BMloybEt5VFVRdUVrMHVvWCtjOC9n?=
 =?utf-8?B?dGY5dGdjTllyYUEybS91VGRrV0VTNFNaWU55LzY4NStwbk1QVWM1Wm1Wc1lI?=
 =?utf-8?B?SEZxeEdzdFgrZEQ4ODJpODc1VjQ2YmI0ZE1HQ1JaT3hlVk1iVmRCellMM0Fu?=
 =?utf-8?B?cXB2dU5COVQwcTU3Y2t0N2pxU24weEVxdWZlb0NQb1dFNUhndFhXZFVwMjNT?=
 =?utf-8?B?Y29RR1hNZE1CQVNUdXlqOVU4TlQzOTlFR3pmMzgvZU5TMXlKakp0REppYU9E?=
 =?utf-8?B?SmVMYTRQZnJ6eDQvQ3I1UURhWFQ5YlROczBONzJFNmF2WnJxKzBhR2JhVTNL?=
 =?utf-8?B?L1pRa05qcmFlV3I1RWd6dWgvYXh1dE9JQlJObjhuaGpNRVY1NzhMQzcvZzR3?=
 =?utf-8?B?TG1pSzhGYm9IUmVQS1R5VWdoTm5DRjE3dlp1NU1HNTFmVEs2T1FvYnI3dWI2?=
 =?utf-8?B?SW93OHFJajNnZ1FpRkVrdDR2S3Evdm9FSVF6aVdqbkRKUjJuTWtYVjZLc3cx?=
 =?utf-8?B?Z1Z4VHNucUpkaFBNMlZkUHlLRHYwdG9tRkZUNVcwZk5HUzQ0TkRsUGVCZ1ZM?=
 =?utf-8?B?cFJSY1A4bDdZWlhuQmwzaEpwRGR5bGdMV3VtWG9YaDlsZXZoQkhKRGl6eUhz?=
 =?utf-8?B?cjlqVTdCOS9QS3ZiVzZUZzRFUUFmRmYvakpncFYydUE4Sm1tTnRwbWxRdkhk?=
 =?utf-8?B?ZnVOSUYvZHl1TGpwV2grY1VPUkdwOEhaZ0dmMUJLQUttQm1kUWU5YnJoSXRi?=
 =?utf-8?B?TWtOWHh4WTRDUmwzai9YMFo0R2FnUlVQcjVncjl0b2xNK2V3SVNSN1dMVHNY?=
 =?utf-8?B?V04yMXZyODMzNE9MYzExNE8wTm83NmExRHRPWUtmVVBvM0N4Ky9FcmtsNlVn?=
 =?utf-8?B?RmdIVFJTRnFEcDN2YWE0eHdydFg2ajNzSDJvcldHNlFDbWFTUTlOeTZsVFdq?=
 =?utf-8?B?a2pRWnhvNW5tellUNFd4VThlQlhBd3puRldycmpVRVdQTGN5VHIwaSsyNy9N?=
 =?utf-8?B?akNjNE80dFRKbGgrSXIyVHU5aGoyVGRobkpJY0c0bHZ6cy9QNjg4KzY4dWhL?=
 =?utf-8?B?Ymw3NXduK0JxeXV2NWNTWi9ZYndyM0hwbmFIUGN2SEtEMjFER1RqOHFzNlJt?=
 =?utf-8?B?NzhEcS9RUER2QlNGVUZhNTNabERlY3lQajlHUmJzbVMrYXdDSHplYWJhWEFD?=
 =?utf-8?B?c0F6WGgzNWJmYjRCTXc4U0UvOU5iMUs3ZjNDSVFnaHFWZ0d2UzBNQ1N2eWVI?=
 =?utf-8?B?WTduamtKZ3Z4NjBHZFNmWitDTHcrenlQaExuOTYvejhnWlNMdnluUE4wcnlK?=
 =?utf-8?B?M296Z2ZiNlJoUWViZWJwejVWRWtnOVROZGNmdzZwUDVUd0NSNXNzVUVmR2hR?=
 =?utf-8?B?Q3J5Z0I1K3pyWHlQSEZxSUIyUzd6NjgzdHdlL3pDbHlLc21Ybncvek9NS2Vq?=
 =?utf-8?B?Qzk2TWliTVA2RW53N1RyZ2pQMmlNNEJXWEJ2SXBhelhYMDh1VG9HSEhSK25K?=
 =?utf-8?B?VDRsVWNiTmo5RHR4eTNWcmRhTmNnYjhIQnlUWDdHNVpCZXpXMzM1S0MrdHpv?=
 =?utf-8?B?aFUwc3RLN2NHR01XdE5zSEV2UVU3b3c4ZE1OMVpSbFVNa0ZmUnJ5SDg3aDBM?=
 =?utf-8?B?aEZoYStBTktXYUJabjcyWTl0aTcwN2pqQzRmTUtIMW8vaEJNTzZrV0FQRTlB?=
 =?utf-8?B?b0VBZ3NFeFphN1VRbjg4a2RlUXZ3SDAvMUlsUzlCc1NkT2h6K0FTdGVyeGZw?=
 =?utf-8?B?cFBycVVjc3dOejhhaHpBVUtnQjQ4a1g5K3FSV1d6dkpNd2h2OHY5bWJScmw2?=
 =?utf-8?B?c2hJM3VoN3VsNzJNVjNZRHJTYVFFQjJNWURvR2k5bEF0dGx1VVFjdUthaEdy?=
 =?utf-8?Q?30RSzHWRjT7COwQ2Gf6DOOXXx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca52786a-f050-4167-cb52-08dd2b147f0b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 10:01:59.1168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sxuhMV/oV9gpHUBfaAb6z41PWF3DHVdWpdnbgDARkYi5KFylVSZlQKnr0cNfgaI24t+p7Puui+BcmCMOBTxf8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4074



On 1/2/2025 2:47 PM, Borislav Petkov wrote:
> On Thu, Jan 02, 2025 at 10:40:05AM +0530, Nikunj A. Dadhania wrote:
>> Again: As kvm-clock has over-ridden both the callbacks, SecureTSC needs to
>> override them with its own.
> 
> Again?
> 
> Where do you state this fact?
> 
> Because I don't see it in the commit message:
> 
> "Calibrating the TSC frequency using the kvmclock is not correct for
> SecureTSC enabled guests. Use the platform provided TSC frequency via the
> GUEST_TSC_FREQ MSR (C001_0134h)."
> 
> Yes, you had this in your reply but that's not good enough.

Sure, how about the below:

For SecureTSC enabled guests, TSC frequency should be obtained from the platform 
provided GUEST_TSC_FREQ MSR (C001_0134h). As paravirt clock(kvm-clock) has over-ridden 
x86_platform.calibrate_cpu() and x86_platform.calibrate_tsc() callbacks, 
SecureTSC needs to override them with its own callbacks.


Regards
Nikunj


