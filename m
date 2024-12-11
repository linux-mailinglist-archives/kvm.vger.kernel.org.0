Return-Path: <kvm+bounces-33528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CBD9EDA4F
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:43:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46DE41653E7
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E5C1F0E59;
	Wed, 11 Dec 2024 22:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C+q1eYaa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE241DD0F6;
	Wed, 11 Dec 2024 22:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957003; cv=fail; b=r+y94oRt/9zwnDSautjDYiSqnpufTBxR+7zazpkDnzHd3mZ6xBM/bDa0etBiMafeYJHEnxHkaZqDFpbTPODunJiciL6D7qigt8sBrDshs4CXqdJxLyX4OB7f6jSc1CIaqJBA2C5HK3VSLFRgRVVKS+zQeNQz275WZsVhR7EVa/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957003; c=relaxed/simple;
	bh=EQO58CQBTZ9cmdb6Wy+3pPlgJmvpNoZP+bV5If4rMoo=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=AuJbfXU/Bg8dhfucIgduVoCdZ0u6R3jGPyQz6n7XE5nsatMBLvhzoJ+kDpVFpQ2kqOBbJpLNN7kFDHrlYUI0cr/KNI8M9emSwwI+dVTZuMCDxe1JAH+aw8gmLdqjBMbu6Ux/MkChr6zrfYQc4srzI4RuTkCg5pLiS/2qP8ngg7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C+q1eYaa; arc=fail smtp.client-ip=40.107.220.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xz2co7lPuE0TyTWu3sNXvO2l4djVkhgL9wxcYQ8FoVYHS8ixiSLvYbBbJFqTV0cMXECHhivo3TaV5yiXTGO757tfD6OPJbCQBG4RD81FkcKoqr3aYOWZy7JBk+ygUYcAULKcK4kJpcarD9CCaBafzCrk1GUAwd0ncKgL+oOUB4ns/B07dWxRozIFyZ37FDK7Zl760b5lgtkRNE5PDa4NRnhQVluihsYXm0wHUVtHB0VgtP020SC24UTyVb8Ad8F2r5h/54jWwdSbPc7eqB8brw/EKiBlq+kHvICdSzZZwvLgvBStmR6lkh6lo97rXABN/v4tqRQXo3HjmOjtQy1ryw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwRF9Fs8FuRPAiKAGvQI5n2m6CWLkmx0ZWEsQ3CpEtc=;
 b=uIxuuAURBJKjH4NwhK+ULj7Y32OieNvJQDF/Y8t+tZnh8V16uSQObG2oVC285aEGmt/+yDenDsucexcReEHXlGzBQHfDODX+TTfBEX6MvodBmZ5v0fNKwu1b1TG8mXVdp6TJRQsuvbPPsl1UbDFDhhl0dGhADLHpsGlkHszXhCKsw6NnZrnFDcXRkCVHepelDRxu7/uZUY+DtEQzP78TDUPL0lRW6Hl2P72puZz3rPRJKHWLLX9QwBorf3i1k+MApTMGti+gWwu2ptbf6A9EmjDj/Ng4rem3e2qNUZgUXWFOyCjsfxJaS/KZQ7emX9IwsBaSftZvucsUQLwAKtAydw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwRF9Fs8FuRPAiKAGvQI5n2m6CWLkmx0ZWEsQ3CpEtc=;
 b=C+q1eYaameMVbRM34yZQ26H9XEyCDKq2ZWPz+0UKjpLE/RFBCRdK2erI2hcJBmJt+uQfmfvACI3GX13syOe5AgDtK0RBrAEvsUJtfNnPvd0vm097AC8Ne7pXkLzw52W+tDTLbfai3d68yIR6g/wQvibne+h/EjrPILGRy/RpUrE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB7247.namprd12.prod.outlook.com (2603:10b6:806:2bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Wed, 11 Dec
 2024 22:43:17 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 22:43:17 +0000
Message-ID: <c3920b80-d288-6eca-3373-34e272a490de@amd.com>
Date: Wed, 11 Dec 2024 16:43:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
 <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
 <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
 <15e82ca3-9166-cdb4-7d66-e1c6600919d7@amd.com>
 <20241211190023.GGZ1nhR7YQWGysKeEW@fat_crate.local>
 <984f8f36-8492-9278-81b3-f87b9b193597@amd.com>
 <20241211222257.GKZ1oQwZcSXSMXPvoY@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
In-Reply-To: <20241211222257.GKZ1oQwZcSXSMXPvoY@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:806:21::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB7247:EE_
X-MS-Office365-Filtering-Correlation-Id: aec25154-92fb-4280-3beb-08dd1a353480
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjU3TVN1L2RRZ1A4VmJwYkIycGN2a2R0MHR6cXhrUnN1YXFNNlR4L0ppQzVs?=
 =?utf-8?B?LzloTHd0c09PZDFJS20waDFxTEJtZGNRVFZkdU1MRmRhUUx4K2c3VVhGV05Z?=
 =?utf-8?B?WXRibXZBaWpQbE9PcWVuS2YwWDR1SDFGNDdCbTgrNVIyZlBLZ2xnV2xtOXNt?=
 =?utf-8?B?eEN6VnYvYm9KT3ZQSTlYTmZGQ1p6U1FaUElJVTBKMmh6YVVWSTNlYW9Rb1ZB?=
 =?utf-8?B?aDVnUjVVSXdmNmY1SVZaOFc4NWZGby80SXZWc2hET3Y1dGF5ZzgzY1JlVEdP?=
 =?utf-8?B?c00rbEYxU0h3Yk8wWDVwS1MySUxnVE1rUjgxd0NJNHVseTRDMVF2SkYvb2Jk?=
 =?utf-8?B?MnFycjcyTXlqU3psTllLVWZZaTRuUVJVbkMzMHVtZStwZm1qY1lCM3Q4a0Fs?=
 =?utf-8?B?NXYxSGt0a2Mxc2U3UFNERWZMbHc5aTh0R082S1J4QktRVm1vUHhFWVpjWU44?=
 =?utf-8?B?VktjcFNHYnFwOFNqeE92RFFkQmprb2N5aXFNSzFtUE1TRm10QzJwWUpITVBs?=
 =?utf-8?B?QlFZdnU5NHlnTTNSYVhKa1lXMUZsMVZaalBMQ2hmdXVzRndMb3NJLzgrT0p4?=
 =?utf-8?B?cHZmZWZ4NlhXZC9vY2JQeWZjTzN6RENPWEhRZjU4TlhZOUhnZjBDeG5iQS9y?=
 =?utf-8?B?eUVHWWs3YjhwdVdDWURhR1ZWSDlZNTl5UXhaRXo2MlA3bFhmR1YxUHgrZEww?=
 =?utf-8?B?T1ZzTHlEdGxid1FLZGVyYmZsN2JSdEptZWRNK20yblVYQmhWQzVGQVlUSlpu?=
 =?utf-8?B?QkpMZHZ5YlIxVkJhUzhFWHlBeTdNWXJ3aWpGWXNrVzc2TlhRZjZEc0FzSDFk?=
 =?utf-8?B?NXZCdExwZlVIRjhpTThQZWtKQnYzYWF2cStSRXFSYW4zcmZaNXg2QmRZYm9Q?=
 =?utf-8?B?YXFQb1lwNmlnWlpHV1o0M1V2OHN4Yi84NEFtNEZWTXc5ZExRVndhUTRDSEp3?=
 =?utf-8?B?ZTMwRDI4WEZiSk1USFZrQnh3cXdUWDFlR3lQTzI3U2NoaUZNNmZqU084WEtJ?=
 =?utf-8?B?QWYrcVdTd2dUdDMvL0lFSDAvbC9CTmp6Vm81R2w1OXdpRUtpcXRkSG9kTUsw?=
 =?utf-8?B?TW1lYjB4RTVQZVc5SCt6VndONWwwaGxRdWdzUkp2M3JqeVFDWVRqb284cmkz?=
 =?utf-8?B?V0FPSDVLdnBpUlNsQ1hHUXhlZ3RxNDZxUGpWc2ZhZU0vaEM2U0h5SS9xeEhC?=
 =?utf-8?B?Y29wR1JMMWlKdjIxZk9xdXByaUludTRLR1kvdjNtL29iZEVEbEV0OVBlbkdp?=
 =?utf-8?B?aFN3TmZ0djZSOWgwMkw5NzNONUQ2TDBqMFg2cmw3cE1rSEFudkRFN0JVQ3Rz?=
 =?utf-8?B?cmdpdUZsblVNblZ4RTlkM1hpR0tkMUZRQytib21qWlVIZWV0Z3V5MHY1aUcz?=
 =?utf-8?B?VVFlbEtaUkFnckh2L0FtVFNaVGUzaEJXeDhpY0IrMjB6ZlBvQU41aUo4eDlS?=
 =?utf-8?B?T1RidHdCUXhwN2orM2x1ZXY5b3N2alpYZDdRMjlmNmw4RlBOd3NZV2ZteGls?=
 =?utf-8?B?QU8vTkpHSmJqYmFSNzBJUTkyRWlEZlFCTWJWekpPY2xzTnFUTU1jTVhMcFlX?=
 =?utf-8?B?MG9kTjNKN0d6ZW1jZ0preEt4bnRNdmpWZFBtOTBrc0tTS0JoNU1nK3dPeXkr?=
 =?utf-8?B?aHpWRHNBd2d0c3F6YVJwaFR6OC9IUW5Zd1BZNzdCOUVCYm9TYm9JVjE4RVpS?=
 =?utf-8?B?dldacWVzTE90KzExeVNhN0MvbGNyNElYN2EzYjI5alBGL1NCQWMxaVUyYmtZ?=
 =?utf-8?B?UHhqZUF0KytUcmlpbEhuS3h1YUJlbG1VVUYwek05bHRxSTgvb284dEV4dXVY?=
 =?utf-8?B?QXkyaUxSK0pySnpyNTl4Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVJYS2pRbHBrWHNETkpEakxETE41bE1HUTBkNWYrNEttbFFTUG10Sk1nWUJD?=
 =?utf-8?B?cGxIbk1qOFZZeTZYVmZnZWJXMTF2SUJYZ0pMSll4bzl0SHg5SDdGT0VmUzc3?=
 =?utf-8?B?Nm5Mc1NsU01OQ09oenRFbUJYR0xKbjdwYzh6RGdKTXcwRThoY0VRVGJpc2pk?=
 =?utf-8?B?eFlRRkdLS2pnNEVSeWY5WnloaElRbWcrUzV0cTJDZnlHd1pBNkppVk9Xa0o3?=
 =?utf-8?B?bytMTDZLTlZRZE5aelRPUGg3eDZVWUpvU2IwL2Fvc3lLSzlyZlZlc2pUeWZy?=
 =?utf-8?B?UVdEWEM5THpaUEU5SmV1Q1ZuV1RIL1IyVDZCdUd4NDE4SlpnUlkyWGNidnhv?=
 =?utf-8?B?UVRaZlMwVW9qT1R6NUhUS1FCQVA5Smc2ZVFJSVlRcVVWZk5Qd3NWeE4vZk5s?=
 =?utf-8?B?emVxckNpVlplVTJDcXhaREI2aXdDNjRHOXlYVzhWQ3dGelJxSklSbjZ1NVBl?=
 =?utf-8?B?MVNOVDZINHAwTWgzZ05CbXhyTUVURk9FT1F1QmVmK2thdWcwd1kwNzBSNFh2?=
 =?utf-8?B?bm14VGVYSTRGU3gycG8waGFtbFdwMHVtTForaGpLVzVIZVNybC9tMjluYzRj?=
 =?utf-8?B?UmlZS3BZWGFvYUFhUDZrN3luYUc4eXdVc0dmU3FONmdrc1lWN3lxUWMxbEZ4?=
 =?utf-8?B?U3Fwcmd6Qm9KNVgzKys0NjcwUHB5VkhjdVU1TEhTVlNYY1IwT3JuekhEM0VW?=
 =?utf-8?B?K0NZNWZJTGhyRHFqakZzRkRnUmhpbjhZeTFrVmFTenVZTlIrc1F2ZEtsdkRJ?=
 =?utf-8?B?VlV5RTNnejgybGxWUnl1QzNZc2pxNitOZy82WjZnK3doeUJkSWM3SzNlSXhs?=
 =?utf-8?B?ZnJmazRxZzZKenI0enRjOHJaZGVyWk5Xem1MT1VYV0NMTjJ6VEtFdjZBZG80?=
 =?utf-8?B?T2lwcVkxUnNzMWl3bmVFU3VpRllob3VtVW9GQTZhb0ZZWVBtcDVwVDNNZzVv?=
 =?utf-8?B?T1dxTGw0YzY0c25vV0FhSHR6MnhjSTQ4V09IZkxSOXpScWxwUDBPVU1rdVBJ?=
 =?utf-8?B?WXg1cmpzUEd6L3k4dzBNYUhIQ2ZmVEpmVEJSZGFpbGtoUkVodUp1Z25sZ1Jo?=
 =?utf-8?B?R1BXQ2NRdG9SV1FhUDhQeTRkV1VTWlg5cWF3ZWNLaWs2Q01qZjBFOVRhdTZ2?=
 =?utf-8?B?MWFya2RzVHFiNzQrV3gvcUx2Rm9jYnlUaEV5MkIvdjJSWjNqRVpIalp5eEhR?=
 =?utf-8?B?WUticEtjQ3o2TVRSb3cwWmFWUkZRTWZQSUw0L1hla1dWbGJIbEgvM2Q2Q1pY?=
 =?utf-8?B?N3RVcXBGM2NzZnNyajRnVzZKNjkxc2pQd0I2NEpYdFFTRS8ydFhpN3hHaWhN?=
 =?utf-8?B?YzdoajB6NnM3UVhOOEJDV2ZQZzV3NlpVNUJNT3V6dm11aVVWRk53cW5rbCtl?=
 =?utf-8?B?bUJKVkkzREFiNnEwZ0srMEZCbFZDMDVUY1dZUHdXMi9tVFlQNzVqbGpjdlVi?=
 =?utf-8?B?cHBYdG9LcUtUY2hsejdFT3pTSFRaNTRzNWRzc3BKdCs0TlBHckhlODZLVG93?=
 =?utf-8?B?Mk9wT2pHU0ZpWVIvS3orMEVHV29rVW5FU2s4clovRmNVUTlIMGhIVXM5Nk1H?=
 =?utf-8?B?ejhleGcwcXNGZUY0azl5YVIyWVRJbDB0RmlHeHh5VXJqd1NIV2t1dWtYWVhY?=
 =?utf-8?B?UzdIeWRDV1RBQ1VzWlMwYnJ0TEtDQ2dabkFLbjI3VStybkd5MzJDaUFQdkt0?=
 =?utf-8?B?RklQdDU1Z1BLc0c5d0FRWFloK0xQN0lhQ2hSVTFEaWxZdjV1N1h1SVFVN0NM?=
 =?utf-8?B?UzNKMThoQUtCMGVXbjhqa3VvQ0JqMytpKzc0MGttYk93ZlpDa1BzdFJTTlM0?=
 =?utf-8?B?c0pCbFB1a2pRaU01aEdaRk9rWjR2b3lWUkl4U2pJcE1iNkdZZVhsVklNTmtm?=
 =?utf-8?B?MjJ1aUM2VWRKdmpmcVJ6TUxaTzAzNnVCRk1nM1QwYWIrRVprRlA2clRGNHRV?=
 =?utf-8?B?clFBTUZIZTY2andVY0loMnUvR0Q3MzFnRnl6TDJ4RXRncXpwT3dYZHJqeC9Z?=
 =?utf-8?B?Rkt2REtScDIwb0VWMjFZZjMycjJ2dDlXdS93M0ZRcWttdk9WZGtIUnZta3N5?=
 =?utf-8?B?VW5QYUM0VWE5U2U3S3YvY1hiVENNUTYrYVJ5dWk2UDNNQWpuaVR5RTE1WXNQ?=
 =?utf-8?Q?qCmP4jlBbdGPv9pivfXAfic+z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aec25154-92fb-4280-3beb-08dd1a353480
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 22:43:17.4786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qxpTrw6Uio8Kwn3mPcYz+zSogvMe56TMS26lLiJ7rVwmlR+EBJZV7IrFGU9eaGNGIox61wkz+9Ge1vG3ZafqZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7247

On 12/11/24 16:22, Borislav Petkov wrote:
> On Wed, Dec 11, 2024 at 04:01:31PM -0600, Tom Lendacky wrote:
>> It could be any reason... maybe the hypervisor wants to know when this
>> MSR used in order to tell the guest owner to update their code. Writing
>> to or reading from that MSR is not that common, so I would think we want
>> to keep the same behavior that has been in effect.
> 
> Ah, I thought you're gonna say something along the lines of, yeah, we must use
> the HV GHCB protocol because of <raisins> and there's no other way this could
> work.
> 
>> But if we do want to make this change, maybe do it separate from the
>> Secure TSC series since it alters the behavior of SEV-ES guests and
>> SEV-SNP guests without Secure TSC.
> 
> Already suggested so - this should be a separate patch.
> 
> It would be interesting to see if it brings any improvement by avoiding the HV
> call... especially since RDTSC is used a *lot* and prominently at that in
> sched_clock, for example.

I doubt you would notice anything since it doesn't look like Linux ever
reads from or writes to MSR_IA32_TSC, preferring to just use RDTSC or
RDTSCP which aren't usually intercepted at all and so never goes out to
the HV.

Thanks,
Tom

> 

