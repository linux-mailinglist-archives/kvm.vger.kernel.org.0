Return-Path: <kvm+bounces-57247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE614B52135
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 21:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98B771799DC
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534722D9499;
	Wed, 10 Sep 2025 19:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YNhFpfhb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2058.outbound.protection.outlook.com [40.107.102.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01632D6E51;
	Wed, 10 Sep 2025 19:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757533023; cv=fail; b=jMPvtjTgadmwOZEDuNgmrOltWiiK/DBrFttu4JlTPjk/OEu95atDIVtgISKadurJuLSpNuGSNYes13J+tmgz1ZnpLPqhVvKCifQt5EreIEQZ2kEC6kNNqARJm4KV4Jzl0MuDqfn3/Dd6YEn9TnWY2GizX9MlTOGUFxhk9F+d1Pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757533023; c=relaxed/simple;
	bh=DFBUNDUiHgg25D+QaJePgCwGvqHyyt3eBgHWKo7b3No=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=cQ09cUPx3uPvU8+KNXROVR15BJ2j8KSzcMOC9eKoXX+A+hXgaKD35SUEktV0J/34CsAVVgnuo9WyWrNIxuqeNxUxOIO7ahrBtWVDDjxxBjK6c5Y5tJ8s+RBIvcROQ4aN0oT7I32tgL7oWPvm6zhuNZffRDbdEq2f632/OCL37ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YNhFpfhb; arc=fail smtp.client-ip=40.107.102.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w8DvV0d3j+9ekfUhHje8g2fs+lHZam00OWRN0M8OuFHWfL5zcfg4q+vZssvLcfa8neTI4zvsVlTGuGd2ZfamATGZUmnJuTIDkNE1sKuaLD7GNoW0V5lSIrK25VK1bk/SYcg48h84DMY2BmWEDg/spQvJyR6uaS4Z+lcrARef/4mMyWMSUnddDDJClbt5I+W6R/zks4Nd2cQVxZbFmG38ds+4YPhvPENwnQQq0VWbhy8TVcGp3JL207RP6kewZRUNnMh3H0rr4I5nAO+DYWTw4a1KpBQhF8A+2W+vpgMbkTApPWPtZF3AD2rzgPFm8/PJ0bvTIkTj8A6Xbe+UHm81hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzjOao09JRXXjlUa/dau/LpLfAYA23Nd8fftod6kYRo=;
 b=SBk8hWstnTlG8+kFd/rtyTnF0Baq9oaY0ZulJxWyPmccOBL1vCVSjmuoYAk8zDzZ53p6LAFnZW9ZJ6igVlMfBwhacnr7uP/DPQM4Bicmgl17+h8FzGPIP7FQe/jzxy+Wm3B+jQZUvcDZ/Mhb19CW3yshntnX5HhU6UJ5JBMrHIYb2lRUrQVDRbIZQk4dtwN1w2ogL9XSXg/1ip1Uib9EZh0RloQPSKVFlV2tHMl2hIeu6zAgDeJNJToN5dCp0qDbxlyCYY/LfiOXOhQIbbvtdGuTrEyrkIvlX+kUGsrvuUKH1Dh5TazIHTciZ9QkNHHrCcQFAt22ng7XOoBQb3HE+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzjOao09JRXXjlUa/dau/LpLfAYA23Nd8fftod6kYRo=;
 b=YNhFpfhbEr8vhYrI47JytXHgJ3eanCcEsqNxfoV9IWRn8u8ciyrRdYl5HsA2/UZd3zgHSX8NU60jof0tA7eW1OzzryV+q3EosV5Z6QV05JQz9unD9ZLD/wML74TfxeH/mhG0RMmnCYgmom/IRAFcsOvnIgPHLDD36QZ1R2BmKy0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB9023.namprd12.prod.outlook.com (2603:10b6:610:17b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 19:36:57 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 19:36:56 +0000
Message-ID: <90e75fb2-7c29-dfef-7cc9-adb5d8566eb5@amd.com>
Date: Wed, 10 Sep 2025 14:36:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
References: <cover.1755897933.git.thomas.lendacky@amd.com>
 <ad3dfe758bdd63256a32d9c626b8fbcb2390f26e.1755897933.git.thomas.lendacky@amd.com>
 <aMHPT4AbJrGRNv05@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH 1/4] KVM: SEV: Publish supported SEV-SNP policy bits
In-Reply-To: <aMHPT4AbJrGRNv05@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0103.namprd12.prod.outlook.com
 (2603:10b6:802:21::38) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB9023:EE_
X-MS-Office365-Filtering-Correlation-Id: ff725e26-f520-49b4-c07f-08ddf0a1671d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlo4RXpXWFZhQkNCL0loSGNNL3lSY0tnRkJSVjBudU5OWWIvemJrWFcvZ3ZZ?=
 =?utf-8?B?YWtaVlREVTlKa2tvckJKb2RwckxnekJHVmEwMEFqZll0akE3VjU5ZXZlUmZB?=
 =?utf-8?B?NTRqWENzTFUxTVFuVlN5WVNRUGZWbHhiTFBWY3FRSmRTVUE0QnNGRFVDaHA1?=
 =?utf-8?B?Ri9yVHhSaFYrYUc4QlNGS29Cek4ySHNTM1FDWlVoZmszQU5tcGlIUGZsU1BI?=
 =?utf-8?B?MXE5RGtVMlhvdXUrbUsxRTgzdHFjaVFtbzZmVjNOcmM0R053clZKeldzVWJl?=
 =?utf-8?B?Q3V3VjRYOGxGK0FnbzNXdUgycGYzV0RzRkZ0Q2h4M053cUo4TWxrT01EK0V2?=
 =?utf-8?B?dDNqWDc5QThlY0IzRGJJTHYxZ0l0VTZSNVBVQWQweWozektZSGlxQmVCSmdy?=
 =?utf-8?B?c0haaklrUDBiR2lWMjFZc2RaUkRPMU5aVnJKK0g4UXpNeFdURm9pZWxlZVUw?=
 =?utf-8?B?UDVMYkxLblFiZ05WZkxraXgzTWhzV3lnQ1JUMEtqcEt1NGNMUWZQUzRnQkNC?=
 =?utf-8?B?cDBYeVI3VExKSGprUUZ3WjRnTXNjaWhmbjh0NEZadEkraWZyQ1g4NHFxWlBp?=
 =?utf-8?B?c0ZiQWloaEZmSjN5bm9QVks4bnN5eTNUV3RWc1pzMExxTnN3cDFjR1ZvUGdl?=
 =?utf-8?B?S0JXYVRCakpsbHI3R0QrRUdSd1JuUWtZSW9MR2VIZUdES2hkSml0T0RFSDFq?=
 =?utf-8?B?SHViQk4ybEVUYlBCZXBuY0VUVHhPN0lxZDc2eVZPZjVBOGVMU0lQbC9GdWw2?=
 =?utf-8?B?SCtiazJDS0tRSVZtd1NtVGQ5My9NYjlWL1Zwc3ZMc2xkZStEVFc2R29UM3M1?=
 =?utf-8?B?RTIzdElsSXVrcUROS2Jrekx0VnpuQ3VwUTFyNVJFdWdwd3oyZ2cxNk56SkZI?=
 =?utf-8?B?ZE5DMU1lQmJKTjZ5d2RBdXoxb1VPU0sxQ0lGdTNIaFNOb1o3Q09kRjA5ZkFy?=
 =?utf-8?B?Q1VCVFVCOWxkVGc0NklNc1lRY1h4eVRNVkt2YTZ6dUxvQkFJR3cxbzc0MFYx?=
 =?utf-8?B?K05DdXZ3Uy9jNDB3M0pEVTJkbDI4bWxuSHJzdW4zVWNSNTY4OTB2UFBNekVJ?=
 =?utf-8?B?b2NRRGsyaUk1SEg5a2x2QmNCOFRHTG5OQmRkYlp4YTRGN0MveHRrbXJ3VEJm?=
 =?utf-8?B?T05hb0h6YVBnZFhvQmxPYlpIdXVQQVh2Y2F2ODFvTW9EeFgzS2tnSWI3MjB1?=
 =?utf-8?B?RXVNdWg4T2VZbmpqaHNNYzhBdHRsbGdDb1BqbkRsY21HOFBycGlDWlVDOEZH?=
 =?utf-8?B?ejkwdXZjNWY3SUJ0T0ZNNGpxbktBdWRMRTduMlI3WjZ2cnZMNmVIaDZUNjdB?=
 =?utf-8?B?U3lQUUN0ZGdlT1VBa25GSW4zYW04RVl4KzMxaGF4N0IrRmpjUWhBLzJ2NTh0?=
 =?utf-8?B?UjBXeWZ1Y0k0ais3Q0p4VnFHV1NHVDV0c3duUmdRMmtrdVRreFFVbDIrYjFO?=
 =?utf-8?B?VkowMVBUS1dTb3p0NmN0YysxcjZtWms0ZVpTS3JyaEw0S0JVOEZPcnlWR2ho?=
 =?utf-8?B?S2FsQ3NBZGJxZVUza3I1UXdDTVUvRzByQ1NjdzlIelpFMTNGalhKdktaSE5U?=
 =?utf-8?B?VmE0YXRpWHlFa3ZjeFpvaDBONUZwWUhDMkErT3VPQ3k4bnFiNFdVNzZONlJE?=
 =?utf-8?B?NEo1M1pEUjJBYzVGMXZ5czJKMWxldkQyRXVIZlJ5OGVlSkRpeTJ0eGpPdDMx?=
 =?utf-8?B?ank2Nk5RSStnY3Q0d3ZVT1REN0dPMEk2V0F6MnZWenBESWVwQ1kxc1NuL0Zt?=
 =?utf-8?B?MWhSeGJ4UnZsaVVXOUtZSDIvRkplOFd0ZmNzRmd0S1ZYYXBTck4yYW5jc29N?=
 =?utf-8?B?VFd2b2FQeDdLckFlamNPNTR0WHhnc2NkUnhFcnZ2NjNUdjlZVDdXL0lVVFAy?=
 =?utf-8?B?bWwrRExtTVlBM21xUzdwWWtUeHNaRjNuZlBYVE1pQzl5YjdJNEgzOW5pU2pD?=
 =?utf-8?Q?1Dt0KyEePtU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEdta0xoNGlJWXdVMDlGNHRZcnBzQzI3cjV3VzVKUGI0ZFZlWW16UGsvcXdj?=
 =?utf-8?B?TXowazNDL0VzTUxLUUFydUZURitKWVRZYjlsNDlqVEovcDduMlRYK0VKS3RR?=
 =?utf-8?B?UjdPbXZzNlFvMGMxUnE2VHI5VzJsUnRnYnJubUcwb2Uyc1FzL1UyMjlCZnNZ?=
 =?utf-8?B?b2FSMmNDd1lJRXY2SysrWEdHTFozT2ExQzAzbzJFdVVVZis1Wi8zalJaYUR5?=
 =?utf-8?B?QzN0Q3RKaDZmMlIwbnVzRTBCRklVS0tjNWpuOGVZOEE3V3V4T0xhVFkxdzlJ?=
 =?utf-8?B?eXQyS0drSE52QndGL3poS1Y4RlBMK29jWVlVRmJmR3RmVUNNeWRISzA1RkF4?=
 =?utf-8?B?Z3N3MGZ2N2xxRlNaU203Wld4TFJlVW9uVDd3dTc0b0tZckpLSXcydUJqWm5F?=
 =?utf-8?B?NDVoOHpobExPMjMvZksrT00wMjduL2hTeUdvKzdFWE1zTlJRZDVvOW1XY1I4?=
 =?utf-8?B?OXZpMGd5WkRnYmJueHVWSVJyakR0S2U2VEUzMTVXVmppMHNpNVhDVnlicW45?=
 =?utf-8?B?b3hEYW4zd2x4VTI0NG5FMWtMVzhsS1ExTHl5eEl0dFp2Q3d3UDU2WnNmWmd1?=
 =?utf-8?B?WEFVeUQ0WVZuMklHMW1pa3dRYkF4Y0FESTR5QXF1TkZ4bnV6MlNIYnFnbHJD?=
 =?utf-8?B?bVpQM2FCaXRkZ0daVFJHL3pCMjR1MnBzeG5tbldsaWR3YnZWRVMzT2QyeW5u?=
 =?utf-8?B?NzR1TXQwR3BCOWRUNTd5dzNBdnNHSFVQbzg4RWZ6UEdSdk90L1JZTkZUKzky?=
 =?utf-8?B?cjRUSDF4anphSnBNTmd6blpxZWRsNWQ5SXVIdzZvYWR0ajBSQWs0WXYwK2tD?=
 =?utf-8?B?c25ERjhLVHNGMURaREhQbG81c05MeWJkWGJVNEZmN25qbzdGWG1NUjBJMzZN?=
 =?utf-8?B?UkYzdGRQMnRZSXFKM0I3MTNoUnBDM2N5MzIwYXdDRVVaYWJ4Vjg4TnlDSlZ4?=
 =?utf-8?B?b3ZsUDRWTXMzOEVkcnNyQ0pDR3VFRy9zMSs5eFMrNmFoTWxZZmprbGZhWG84?=
 =?utf-8?B?eDNMWVl1ZTkrRXg1MDN2dGFScXAyOTlUZU1qdG5XcGd3ZUIwTXhwR0JJOWJO?=
 =?utf-8?B?d2kzdDNmRUlyVnE4aitqb3RlUmF0Q0l2TkhNQ3RDZEtZS0JjbnF1S21XVFpK?=
 =?utf-8?B?TFRab3VuSGYvV0owVEEwU3Z6WUhpVkxyV05vM0VCSFp0Ri9zV3BkbVNucUk5?=
 =?utf-8?B?b0hEMzF1aGNYZStJQ3hISG1FenpOOVNCbDBPdTAwcGo2eDY2cEorOG9HcEY5?=
 =?utf-8?B?WmxpNmhLQ1pqMlZzOEREZkdvREFtWitRSHFtZmVmaHM5Yjl1MlR2L29kMFRB?=
 =?utf-8?B?dThLbDY5VVFzNkhDWWxhT093aXA5K3JvYnJjY09tdlkxdDBBVi9YRkN3NW1L?=
 =?utf-8?B?Mmdja1psZkg1cFVwbVpQYVZicVFXSjR0MHNkWmN2K3g1YVR1bUwzWFA2dEVv?=
 =?utf-8?B?cXZBdnhlY0xIMzV6ZzBDdjI1UlVvaWNiMjU5NEZVT21qQTBaVmF3UldVWENX?=
 =?utf-8?B?UCtBUTlPUThicXVZTE4rNGZRc0NFYmtzVXU3VHZjdFR1TWIxWXk0a0FpbUFw?=
 =?utf-8?B?NTRwYTU1WmhQd2ZwVDBtR2twN1UxNmptL2UrdmhuazBha0EwTldtUlVyWXZy?=
 =?utf-8?B?MklucDVkK04vOU1iMkxDNTFkMFdrR3g0SHJuYWs5a3BCdjBzT3JRbW5jVkt2?=
 =?utf-8?B?V0ZWc2NLS2M1QWhkVVNTaURITDVoVXNTZmgyaGxTb1c5eWpndTErZW5UZDg4?=
 =?utf-8?B?eC9pLzNCQ1UxVXpORE5JNzd3NGZaZWZHSGVGY0NsKzJSMkwwQnkxMUd2cElV?=
 =?utf-8?B?Nks5eTdkQ2VSTEltYXpSRHFYdHU2TFpvdVhISU9YOTlUWkNWeENTS1ZwMHEy?=
 =?utf-8?B?RmtuVkIzVGFTMk1ZVWlEQUx3dVlmMHpvNHl1Qi8xZ0hWd2d1TXVMbmhjUWYx?=
 =?utf-8?B?cTNmTVZ1S21XNDR6d1I5ZTl1S3ExZ0wvMjJwQnFVNCtvVjI5WUQvVldSRFlL?=
 =?utf-8?B?RVJKL3BHSkpsZHJBNWNHQStSQzBRc0tIR0plVk1KbXNXQVVlcEtuN0tNVE1w?=
 =?utf-8?B?WEcvVS9IL05JNllmVU4yVEk5RjJjSTl3dW96YTBSck45VW5uS2Uyc3lVbkNF?=
 =?utf-8?Q?k99qWkVYm6THamZb8BGnej37N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff725e26-f520-49b4-c07f-08ddf0a1671d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 19:36:56.9052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tL5MK99uV7M60TZ4iCI5DOVwDqgfw/s8gxWhwDo0qm3fyWUQQGf8kRJcKQcQndDQQDLk64E1FFEFsCNPM1XH6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9023

On 9/10/25 14:19, Sean Christopherson wrote:
> On Fri, Aug 22, 2025, Tom Lendacky wrote:
>> Define the set of policy bits that KVM currently knows as not requiring
>> any implementation support within KVM. Provide this value to userspace
>> via the KVM_GET_DEVICE_ATTR ioctl.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/include/uapi/asm/kvm.h |  1 +
>>  arch/x86/kvm/svm/sev.c          | 11 ++++++++++-
>>  2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 0f15d683817d..90e9c4551fa6 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -468,6 +468,7 @@ struct kvm_sync_regs {
>>  /* vendor-specific groups and attributes for system fd */
>>  #define KVM_X86_GRP_SEV			1
>>  #  define KVM_X86_SEV_VMSA_FEATURES	0
>> +#  define KVM_X86_SNP_POLICY_BITS	1
>>  
>>  struct kvm_vmx_nested_state_data {
>>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 2fbdebf79fbb..7e6ce092628a 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -78,6 +78,8 @@ static u64 sev_supported_vmsa_features;
>>  					 SNP_POLICY_MASK_DEBUG		| \
>>  					 SNP_POLICY_MASK_SINGLE_SOCKET)
>>  
>> +static u64 snp_supported_policy_bits;
> 
> This can be __ro_after_init.  Hmm, off topic, but I bet we can give most of the

In the current form, I agree. If/when we support dynamic SEV firmware
updates, we may want to re-evaluate the supported policy bits since
newer SEV firmware could have made new bits available.

Maybe instead we move the call to get the current SEV firmware supported
bits and ANDing of the KVM supported bits into sev_dev_get_attr() and
snp_launch_start()? The downside is it is possible that the supported
policy bits could change between the two calls by the VMM.

Thanks,
Tom

> variables confifugred by sev_hardware_setup() the same treatment.  And really
> off topic, I have a patch somewhere to convert a bunch of KVM variables from
> __read_mostly to __ro_after_init...

