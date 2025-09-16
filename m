Return-Path: <kvm+bounces-57728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E52E1B59865
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A04503AE84C
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 13:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3EF131DDBC;
	Tue, 16 Sep 2025 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jYIBqYRs"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011027.outbound.protection.outlook.com [40.107.208.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81F301463;
	Tue, 16 Sep 2025 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031130; cv=fail; b=eM2mRxuJOLKvJjU41qIxvYmHgsY81zcTVolOy5IM5FRev+PHcb48PYbPsdL/Ls8TIpsZLgRPDmRA9avnmyOthTeB24eC2cBw4EIDMXEAKTwZp8EBjPK/s+m1oF+ndmuc+h7OOtaQbNaKSa2tV8hnhpoOLVik83Kq6vwXVsmPBGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031130; c=relaxed/simple;
	bh=/6sikqTkeasygmuWArVjbojNcd44kxwZ/yrmY5hFxO0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UdKFGNnXmh23K+/FOCGs12rVSMwdRs7mIRs8YnXXwXhv1+zDtyBlZ7239OboXicd4z/XeBCjVCWj5EJngORP22cxHAAmP8+oy7YpFM3AYcHLLeZhlGOCxGkuDuxyTFztvp5aMM6LojXINdRNviZbKN1uBa2wCddl9uIrWYBxh9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jYIBqYRs; arc=fail smtp.client-ip=40.107.208.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NjFaHcQOHAeAsiA1lOO1/tJYN75yaeh9fE/bv1mZcP8R225Xb446PqEcEdAUMFYDhb9ttr9weLnhQUzRY/hfKQfswNfIYHKC1HhgeVjMr2TccTar1KUhX4i9Z1tVvZsgXNKUmtW/kZiV2lHi5KTmRTQ1YFD5hwZjYVYHFUpz3/VpY5qEDa9MjDM7XkduZyFlsxHq8f2f85ablJmTCYwoZZEAPF44EwnCh9qzyUYxpTPwU21FcMNa0xUy1klqcnXGn4CF6q4+IQ8tfHtRZKQhSKvA2qn7ZNWrr+9AbpGWCFUBtwWsBp+rtHL3WMXIavlnSRggTyafEC0Lz/gFlziPmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=De3wf1NTtiwPOwD1LiU+ZpFhMoTL1DwsBdGwtqWgx9Q=;
 b=pBAEV/LJC58VlGvt/nq5xfLr5rgAq4jpCYoZPIjnPHtQrTStk5s9KKWjkk59ibEzo5d3KwaQEGu5ePCCRafRKmH/qTGrTcve7xKKt8/moH97xmo8kp6hfpMn5JYAKLbmk7i1X0JDZnVXx3VkiAiVCu6pNqLTkg8kdQKxoLcw1FjVj3EDDEp44avp2jLUtqMN53I9/FoNy/qKngd59usTOa7ZylEB9Rt/KoqAnTOk+GA9ccA0hPOraQ+sY0ybKPiBWBbACyOCyzV8U64Zz+qryejBHQ2b39mTTGojefBwnwrqFIKoNV0Oymg37H56IX22JdjkhGgdQzkahk6F2QZXaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=De3wf1NTtiwPOwD1LiU+ZpFhMoTL1DwsBdGwtqWgx9Q=;
 b=jYIBqYRsudlrjy9wC6XNa3gqMH+tu/QNvxWm9JyGM4Nmf5kgS38Ji9iaQWfYY7v1z6uFT5gbz6SzZJ+Ewv+kXSsGdxbv+IPAnLuh2yMge/t8AvWEBXcZ2nxdww6tXpGWM5/CmNo1ppxW886U7mSul5JVcg7sC7lQVag4RBS0UCQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB6446.namprd12.prod.outlook.com (2603:10b6:8:be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.22; Tue, 16 Sep 2025 13:58:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 13:58:45 +0000
Message-ID: <45528c22-9fe7-4f7d-97e9-1d58a0415b08@amd.com>
Date: Tue, 16 Sep 2025 08:58:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
To: Borislav Petkov <bp@alien8.de>, Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 herbert@gondor.apana.org.au, nikunj@amd.com, davem@davemloft.net,
 aik@amd.com, ardb@kernel.org, john.allen@amd.com, michael.roth@amd.com,
 Neeraj.Upadhyay@amd.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1757969371.git.ashish.kalra@amd.com>
 <18ddcc5f41fb718820cf6324dc0f1ace2df683aa.1757969371.git.ashish.kalra@amd.com>
 <20250916131221.GCaMliNe3NVmOwzHEN@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20250916131221.GCaMliNe3NVmOwzHEN@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:806:d3::21) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB6446:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a479fb8-ab49-411e-8d1e-08ddf529268f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjVuV0tzVWlkc01pTnFwb0l2QTB4NllQWDVncFBuc1BjYlQ3UHZJakRWVE1z?=
 =?utf-8?B?NHVNWjFJWkRpVFBWelBTRHRxRDhSZW01NU9YRG1GWHMyUGRMSGdHNFk4OW1I?=
 =?utf-8?B?K29JcGorZU1paTdUQnVNdExjaWlHVFNINWcxMmgrOXZwYmVacmMvcGZKQjlG?=
 =?utf-8?B?WkM5KzZlY1BpOE9Lb2hzWTBXSFFhT2YrSnNGKzJGeHd3aTdqYTRZV1o2SEVZ?=
 =?utf-8?B?ZUVjYlVvWDB3V0UxL0lGNitBYmpxWXk3R1M1MER3WlgreE1WU3pwV2g5elBw?=
 =?utf-8?B?UTVtU29OL3F6NG9tYUxYR3Y1TS8zZE44NHp4ZWRjUE4wVW92dWt4L0tQSlFk?=
 =?utf-8?B?b1h4b0FCVUJQM2JOWHFUODllZEcrVk5JclNsRUZKSEVIcm44Y0l4VWM1NW53?=
 =?utf-8?B?OXJTeU84aHpUclRLQVVpS2Y5MExHTm1PZmpHUmRadjhBa2tzWmVRdVBlYVlK?=
 =?utf-8?B?QUFrUHNnNlpJUXI2bUZRdVpYdktqY3N2d0QyT1ZmQWVXazF4Tm1rSFFDY0NS?=
 =?utf-8?B?NHNWVzNCY3RKZVp4a3JjK2JqcEpic0VybVNsSFZIRVVQL0hmd2d2bGRSMDR5?=
 =?utf-8?B?OUxMdDNYZFhVTEdzVzhPbEpxdEh0QkxXNkV6aU9yT1RoUjVzNkxQcm1VZTlw?=
 =?utf-8?B?b1d4dG1lbklyNTdCNzJQNHJoVFc1ckF6UEtYRWpBM3IzOE5ndUhIV1M2aDFo?=
 =?utf-8?B?WFlWS2orK2pUZXl6NmNkeUQzOTJJbVg1OFJEVFRyM3M2dkZsbzFwOWJqU1gr?=
 =?utf-8?B?Qm5GallJU05kQm9nYlExZXpwOHZjZDNiVXg3NGtHUzVNc3F0U20zdzlac01m?=
 =?utf-8?B?a2pjWTFtRElCZ2Y5VDlqRlA1eUxJYWZsYzd6RkdMR01KV3ZmeGRhU010VFp2?=
 =?utf-8?B?bDNvdXpJV0NZdURaVVkwZ01hbjNPSFEvUGkxSTRHcEFoME1aQVdDdjJqcURJ?=
 =?utf-8?B?M2x0eDVhRjM0UUJTRmpvS09CS0g3blRRWS9ITDlaNHpPNDQ2aFM0aFBHOXpw?=
 =?utf-8?B?VEZ5Rk5QT1dJa2Z5ZG85Mm9GelJKYTlrSlMxYzNlM2pCS3pENHhRN2JHQk5u?=
 =?utf-8?B?NlQySElBQkhFb3dXc0hvaVZodnVJMDlub1RSTEM4NmNDODlaM2R6TXlHSFNG?=
 =?utf-8?B?U2M1L1dFanR0WGVxYTl1TXZ5czEyQlphS3J2c2xMN3dQdGlTem9FNXZ2MUNz?=
 =?utf-8?B?VnN5TG1CV0FtV1B0aTdGSk5PRHlMcVVPT21JcGwycGU3S0UyQTg2Z1AyQ0VU?=
 =?utf-8?B?QktXNzJVbWlCZXFYaW5tUlR3RGFpQ3BZWkQ0aURWYWpxQ3lIQitNOTh5cGZT?=
 =?utf-8?B?akZTL0VTOFl6MTU2SXM5RzZCWnhWVGVMbWtWOCtHV3BjOTF5ZFhQZlNjRWlU?=
 =?utf-8?B?d1dLakluTkZqSDEzSTBkVVhsMXlvV25UWUJyajl3VjFFa1JLNGNNdENKN1Ja?=
 =?utf-8?B?eUkxTUpVbVVFa1QyK2I2cEhyazY0SEJWSE15TGcrN0h5b2lFSEJkMHZyZjN6?=
 =?utf-8?B?ZkNWNGhEZi90MXY2ZlB4elhZdFg3SldTKysvM1M4Qk9ock9QQmZEUEg1dUpz?=
 =?utf-8?B?U2F0bmZHMENlbWo1VEJFcnJFbmRuakt5aDRYSkJUQlFWV1VzQ3ZPTzVLTkx6?=
 =?utf-8?B?UklmY3ZteE9iT25TM0wxTEpZUkFoL3JXajZVeTdlVUl0dHlYQkQyOHRqazZy?=
 =?utf-8?B?T3BlWVcrWDZtMmQrajQ0UE5pQTJpS2ErM0RuVnNGUGpJeW1pcHExRGtBb2Ru?=
 =?utf-8?B?S2F0TlR4eG5uUGkvUUg1OW5xdlZKK0NYQXFyWnhWV1UvaFNFMG1mSHJxQ0k2?=
 =?utf-8?B?cmtTNUNETGNxSXp3WC9lYWRROFRJT1NZTWJNSllKM2ZxTVMwUWRyOGU5eUtM?=
 =?utf-8?B?VVl0K0Jnb3lVTEp0MFVJMFFqZktBb0RhU3UrdW5rNFk5dU9FMlNrNDBJcTk2?=
 =?utf-8?Q?dsLJCNfiqNE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elFEUVFrTkVLM1o5NUpIVzRYVEpjZ0Q3eno4dVQ3ZGQrZkdEbHhGUGhpenN1?=
 =?utf-8?B?c25BOUlUdFdwSE0yUXBZOGpoalBFUnczczVManE1QlhwZzlRc1VYZ0pBYkY4?=
 =?utf-8?B?aUpXY2oveVVsaGgzMHlETzUwZ25lWWwycmNnT3NhYnJDOE1qNnoxV2RoSlFF?=
 =?utf-8?B?a005OGh4M2QrQ1YxZHBXL3FXTzZ6OWFCUFdzNTFiRmlKTEhmNzFJYVdZeUtK?=
 =?utf-8?B?M0o0Q0JhNm5vWEN1M1YzRzFZcTdFTk1nTzN5b1MzeWFPUzBUK0c0VXEwRnNQ?=
 =?utf-8?B?SFE0TDlNUU8wWmEwcEROK253M055USszeU9OcUtERnBYME5wZHJqbDJxQWZW?=
 =?utf-8?B?aUFQQldtZ1hPVjE1NVNoSVFQR3ZTUjJZcldjQzVtbTFHUGdJK2F3WkRBNGtG?=
 =?utf-8?B?c0dOQ2dtc2d4S0lhOXpkbUZaNGlZT1ZISmJsbW03MkRZbGcyV0g0TU9XcW1j?=
 =?utf-8?B?MWhxRTcxRjZvay9IZlNZVjI5bWxMZytYVXdwUko4RVU1T0U3Szk4MkV4MGZS?=
 =?utf-8?B?RGN0NVoyUGZNeUZrL0RiNnR6eE50MVZEd2ljcTU4cUlabzVKQjZBMG5iWEhS?=
 =?utf-8?B?L1pTM0JUSFYrNnNDd2dkcndTaHhVTlFLRGVXVHZZczkyR2ZlRXIzZ1VXb0xm?=
 =?utf-8?B?YWd0ckdxRVowUkhPU3NjUHFOQXhyamlCSllBcDVJZWRKVkNQanBKMTZFUWlR?=
 =?utf-8?B?bEJwSjdBZVVMRmN6MU5aM0lHeStLdEJ0VUg4V0gwRjc5SjM3c3ArOVl1TTd0?=
 =?utf-8?B?NTlRNWNBVnkvdHBjU3NDMGtiVlZPVXFDTlpIRWFWNFRvSmUvOXphRWZsYmRL?=
 =?utf-8?B?NitqZjR4NnBuTjNlWnREZWgwbGEzKzJDZERFa3dleDhUWW40MHRGUitCNk44?=
 =?utf-8?B?UGU3N1pROXk4RXdkcHZiZGRsc0p1UTVVaTJqOGVzbm1Eb0xUbldIY3lEaTFF?=
 =?utf-8?B?Wjh2YXRVRE5Gdmd6aUVKZzdVNkhkU1pLTW5MVkdya1ZPR0hSK3JUOFEvZ0N3?=
 =?utf-8?B?UDFBcXcwa0hNNWI0U0xtS3hVeUs1Q3VHcGhYRDVvSGxnU2ZiWGZkVnFkOHYy?=
 =?utf-8?B?Tm9hcnhPUGZWcnVZYU5MZ1piaGhTejI4NEpuYTM2S01yTENGaUJ0SENVU0lB?=
 =?utf-8?B?cGRvT0pFY1ZFaWxmVVR4NDhTMnZnSzdXd3RRYkY4eWc4eElaUHFhc211UnNp?=
 =?utf-8?B?cU9WN3BIczVFc0h1OEFXRGxBeEZHSjRIeFBycGJ4d0VwZU5NeC9vWXpMc0FL?=
 =?utf-8?B?WVAvWGRZbklJamozcFRlak40RkN6bXF6a1dBMGtyaXJpWU0zclNnWkpiNmZK?=
 =?utf-8?B?azdMdXVkdEVWVHE4NU5tRW02bTNFRE40eFhKYjMyMjNCVFovdVpGZ1RYTFA4?=
 =?utf-8?B?OGxTUWt4WmEvUDkyQjV3d0N6Q1lPYTJ3TlhxeWtWTWFMYUFxNGpUUm1zbG05?=
 =?utf-8?B?SU15M0V4RDd0MGs5Q2VRS2hOMUMwYUN1YWNCaTN3UlhwN3UzS2M5d1Jza2t4?=
 =?utf-8?B?Q1IrVlJDSEx2Z1dnbjFPdlE0MU4yeGFYN1RvTFAzYVZJd1hHRG9UMGIzdTNX?=
 =?utf-8?B?NzF2TDJZaDRSYVgrN0NrQkIrZ0lsNlB4ODRmQXoyN2FBdXBnbVNrWFIxVDdG?=
 =?utf-8?B?MTlBc2VCR01lS3NRSjBsZDUxdjNkczFwMUlhRW9mVE85NmdCTzhZOVc3RC9x?=
 =?utf-8?B?RWZnbXB1TE1GSXNZT1NaeHZmcGR3K1ovWGk1dVBUeks1S2M0aVpqbEFNdUU2?=
 =?utf-8?B?RmdoZ25kVllCNEw2SlVBTjRRN2N3YWtDaDhlRUswZzlDT3FIcXc1WFZaMUJo?=
 =?utf-8?B?UlJ0OE9vYmtlekdUMmZUekdQQmU2N21SSzkzOTZUa2hrNkdkTUk0c1RzdFdK?=
 =?utf-8?B?OUYvUFVQZlIvMjkxNE5nTE5qdWlpNnl0MStwMC9kZWN2WFFHZ2E0RCs1ajVp?=
 =?utf-8?B?UWxZTU5OcStMM1JZVC9wd1JkUmNhay9xUzJRRkxxRXRiY2FMRnR4eEtsdGY4?=
 =?utf-8?B?NlVDd2gwd2p1aVpmaE9GU0lpOHVFdTRueUVaQkpCQStEVi93MFpqUHpxNjh1?=
 =?utf-8?B?amN5bEdhWjRsUnR4UEw0S29KRXQ2Y2N1M04vSzRQWHc5V0lieko4RTB1a05z?=
 =?utf-8?Q?Ki13wqUJnCDFD2iFK3yQHHsjq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a479fb8-ab49-411e-8d1e-08ddf529268f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 13:58:44.8996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvJ0+ELZdReFBHSXMsrl+NVfAff9tKJZ4qVLOFWKocaC2SmdRggQowdt3yy//78iIdktVvD4QW//x6ecONa1qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6446

On 9/16/25 08:12, Borislav Petkov wrote:
> On Mon, Sep 15, 2025 at 09:21:58PM +0000, Ashish Kalra wrote:
>> @@ -668,6 +673,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
>>  	return -ENODEV;
>>  }
>>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
>> +static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp) {}
>>  static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
> 
> I basically don't even have to build your patch to see that this can't build.
> See below.

Did the patch merge correctly? I can't see how it would fail since both
the original and new definitions are in separate parts of the #ifdef... It
should have failed even before given the way it was changed.

Maybe I'm missing something.

Thanks,
Tom

> 
> When your patch touches code behind different CONFIG_ items, you must make
> sure it builds with both settings of each CONFIG_ item.
> 
> In file included from arch/x86/boot/startup/gdt_idt.c:9:
> ./arch/x86/include/asm/sev.h:679:20: error: redefinition of ‘snp_leak_pages’
>   679 | static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>       |                    ^~~~~~~~~~~~~~
> ./arch/x86/include/asm/sev.h:673:20: note: previous definition of ‘snp_leak_pages’ with type ‘void(u64,  unsigned int)’ {aka ‘void(long long unsigned int,  unsigned int)’}
>   673 | static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>       |                    ^~~~~~~~~~~~~~
> make[4]: *** [scripts/Makefile.build:287: arch/x86/boot/startup/gdt_idt.o] Error 1
> make[3]: *** [scripts/Makefile.build:556: arch/x86/boot/startup] Error 2
> make[2]: *** [scripts/Makefile.build:556: arch/x86] Error 2
> make[2]: *** Waiting for unfinished jobs....
> In file included from drivers/iommu/amd/init.c:32:
> ./arch/x86/include/asm/sev.h:679:20: error: redefinition of ‘snp_leak_pages’
>   679 | static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>       |                    ^~~~~~~~~~~~~~
> ./arch/x86/include/asm/sev.h:673:20: note: previous definition of ‘snp_leak_pages’ with type ‘void(u64,  unsigned int)’ {aka ‘void(long long unsigned int,  unsigned int)’}
>   673 | static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>       |                    ^~~~~~~~~~~~~~
> make[5]: *** [scripts/Makefile.build:287: drivers/iommu/amd/init.o] Error 1
> make[4]: *** [scripts/Makefile.build:556: drivers/iommu/amd] Error 2
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [scripts/Makefile.build:556: drivers/iommu] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [scripts/Makefile.build:556: drivers] Error 2
> make[1]: *** [/mnt/kernel/kernel/linux/Makefile:2011: .] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
> 


