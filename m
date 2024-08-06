Return-Path: <kvm+bounces-23371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCD194921B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 15:51:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74E74B29AB0
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 13:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F123B1D47C3;
	Tue,  6 Aug 2024 13:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aCGyFSFs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CA71C233C;
	Tue,  6 Aug 2024 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722952190; cv=fail; b=euDMPygbb/pIXUfMMY8ebrFQVtvxNaZ+CGEYNCuqShZcEe8WuP0FIEgNohNfGJIrsDHa8L9A9Jwtddf0ONfMKcZe9/VG3KVfpRu/O1cOkLgjF9Ss9b69HmAwCLBsQIwv5Cu7ve3X6kaigjLYWwHW7UfO5oArVaiNp0gHvMeB83U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722952190; c=relaxed/simple;
	bh=FtWDtZXFjTRDtmIUa0YzI9r9R1cSzvU7qfnNkpxyb0I=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=XUIJH4CTbpZpfq5IJO748BpoSWjl4RuK+Z9jVeQwirDa5ApmwhOayhF/7pF4uxYIpV8YR5BvwDvWtmbgTFFRa7GhxSj8r7vy6QZzg805hhwvN1O8lPdCOEL9fOunlVgm6SAKpKOPtESHl/m28hnEeChejbbxCG9FGtD60u2NWNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aCGyFSFs; arc=fail smtp.client-ip=40.107.237.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eEisQ59Vrfw9UGuYnS+VTdKSRZldVdL+JvPJJpVtnKCqvxVJWFzG4xLhYYHVoJKouxS8L9XvGkXIYMwihuUwK0nsGurJSu2uWekKkDKHzrd9QSmAAKMbNeGis4+rLJdwIXr6YOQxKBPka8J5UcQJQa4CFN90fIAzdFFDC+wYAGsVZ9/FBYb334XFZ2ocm0oa98o0NdKLfEpfEUSFiuF12vAluLN+HfKhjDQzyl5ii4t3jGwilX85gyuop7CZ5ubUm6/QkPB5KOb11d9GLEwai7Y2IsVEIFK9pmQPSkERUD8/gktVwuk0sHYh0bOnPgxHe3yaITeB+TiQ9i1weVCjEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xM44AXV9r3X+ba7D1nfjgF4S0kxwdb0iNRzoETov9uI=;
 b=zQThl6mkw/GzPSoTeAAVjhC1Y6xWJJ8YGYOuMFH5zPJ87RcxNidfRhOjaY/AHa4d04Q/w73VB/eGJiTGz6RmmgyLt/U+EC2tp37uGJWRkaaHsK9NPalpAYswNNWRAMPzZyxx6m0GzEMvBToFz5ZyvPPKxnzZLBeNu6IIy+vBlQngxTr0mr6tL0i8UITbnfN3UAHJ0ANoCC9Ma4yXmSsx9K5/mKWnbMwqMvJIrFp5T7+XlZUshLt7TmjpXF89JQ2Mo8Hh9pn9cSSyVibOOvmkjA0WygIVLuPD3kgR6VCTyXj1nF01gUjA3Hmzvcysr3JAL4Trjz6tf7PP7lwf9aArzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xM44AXV9r3X+ba7D1nfjgF4S0kxwdb0iNRzoETov9uI=;
 b=aCGyFSFstZ9KRlkbWrgVnfouByVK+qzBRpHIANuI2Ja8Io4E7cPVYZ/nKBQEjaiucvj/FgG9VWoHVfvIsftcqZm4v9WJJKQOI8bA0RJH1CwZumtH1VVdwhmSuPuclzZHnEtYIT4S0g5Me00YUdl1nQyKyRW/WgPyrQ1EJeYnZQI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB7912.namprd12.prod.outlook.com (2603:10b6:806:341::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Tue, 6 Aug
 2024 13:49:44 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 13:49:43 +0000
Message-ID: <878cae8c-4da1-ca80-7215-24cdcb80474a@amd.com>
Date: Tue, 6 Aug 2024 08:49:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com, jmattson@google.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com
References: <20240806125442.1603-1-ravi.bangoria@amd.com>
 <20240806125442.1603-2-ravi.bangoria@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 1/4] x86/split_lock: Move Split and Bus lock code to a
 dedicated file
In-Reply-To: <20240806125442.1603-2-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0051.namprd05.prod.outlook.com
 (2603:10b6:803:41::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB7912:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a66e8f7-be67-4f46-6c4b-08dcb61ea05c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDM4d1owaTRCSEpoMXBpRFBtQkl0V29sbm9neTBTdmpuSmdGdmRBYmc5WW9Q?=
 =?utf-8?B?NHYxWnlpQ25nMEdCOFZDYlFUTnBKM1l3cVNxZ0tlbi9CZytxY0JwYzVFZmcy?=
 =?utf-8?B?d0ZoSi9NbDVHUS9oVm96dUhrL0hSdjU0WkZkQnBTbGVlenVzZDNXNytwelNn?=
 =?utf-8?B?UlhaMnRua3o0aUtEZ29jeW1qaEUrRTVlRjBJYjZrQzNvSjlsYjNMK2trY0xa?=
 =?utf-8?B?eXlORkRFNXFEbzhrR0NudWRZUFhKNVpoRmliV3k0Z3lmaWtQcndtbDErTFlW?=
 =?utf-8?B?cHYzZEhQeG12WlVlMTdEb3hJUWYzazJzd0hPRVpRUzNpWmlzc2ljNG8xSjdY?=
 =?utf-8?B?Sm9sSThoYVd1dDRWTFIzUTdFRVIzMkpuUS8wWWZzbWt1SnZoelFidVpTTk1G?=
 =?utf-8?B?QkMyaFM0OXdoNXNCbHpRWEpkQmJLOTdMYlNmSmxVR2tQMS9tdkh1ZGd6SE9h?=
 =?utf-8?B?TTlyM3gyYWdDTEg0M0NzWnpPcVp6TGdiTjgzQklYdVMwcHVvOGVZSTk5TERU?=
 =?utf-8?B?M2xnK2RqanBUb2R2a04vNTkwTVFCdlZLcG9EUm1KZllYR05tNUxMbkh6Smp3?=
 =?utf-8?B?QUIySU41L0F1MHRnUmdKakl0TE5IVE1XeWJsc2VZYm1qVTdaZHZqYTJuTjFM?=
 =?utf-8?B?emYxRDNqUjJUU0NjZ09ia2Exelo1aXJqUWVzcE9qL3ZnQnM5YWo1NjU1WVdU?=
 =?utf-8?B?T2NWNTBxcUNGZHdKeFdxUmdJVWo0MVIyS25UMjkwTUFTZEpxQ2ZJZ0l6czZW?=
 =?utf-8?B?WUwxemdlZ01ZRmZCbU5wUVRqdXpnWGE5L2F6eDhRdVQzcmNlRDRBSjZmdXo5?=
 =?utf-8?B?Z1lnSHRSZytxQVFzYzcxMjlEcEwzaStoZXE0RGwwR2xYcXQweW00UjIrVWhM?=
 =?utf-8?B?QWRvS3ZDb1VFWEhMb3Nmazl2UUE2akxMU1hhejdHdWZ1enRVNmNBZTBEZjlx?=
 =?utf-8?B?bzBFa1lSaEZzZUswd01HTGJubFNmOXhsbG5ncy8xSzlHT0pRZWVHTE1pNHg4?=
 =?utf-8?B?dlNpMU9QVDJYakV0MnVPbHdFSThXODU3bXo3U1BZVHpuRlNNdFFCVTB3Wkh1?=
 =?utf-8?B?Q2ZtQWNwSXJFYkErdW4zUzN4NlFwditSU3Uwd1JWV0FtYlhOOXRQajJZQzN6?=
 =?utf-8?B?SGhqVE1jRE1JNmJGanh1K1ZENWw3UUVJdDJJMGZJSXB6WEwrcnJwTlVMQ0lH?=
 =?utf-8?B?dXBpVWIxQVBrRXhEazlKTGJQM3JYNHhHaFNwTWRIT3k0ZE8yVVB2bEtFQWoz?=
 =?utf-8?B?VVp6cmpDQlR5UzhKR0RtR3FGMTBwNk1RRWhzZkc0WVNTN3hveHBDSEU0ekVX?=
 =?utf-8?B?WmcvVzFZR2x1WEVtaUZrOVFEeTYwb3lRbzdSUG5NTnFXelhRNGdseGZiY05G?=
 =?utf-8?B?NXlIVGx2NFM4YWx6U0xXeUE5d1ZTV2dIVjhVY3BSL2c2SjBZZjhSaHRUL2hs?=
 =?utf-8?B?cFJ6UzZXNG9LZ0drc1VvY2QxOGlwU2R5UkoxajNncUtabmx1YWFVc3pVVzFF?=
 =?utf-8?B?NG0vRVJERFczUEJIWmxEQ1VlVU5NMFRlcUh1QzRIbDl4dXcwdEpQWWdhVzQr?=
 =?utf-8?B?MFl4b3dSc3NJOU1Ia0pQbHVCbllueEpjdm4zaDJ6YzBIQ2xOUEtUbVJIT0hO?=
 =?utf-8?B?U0VUOUtSU0RlekgyVW80ajNrU05iZmcvUTlOVjRmUm1MaEF3a0VHWTVXUEQx?=
 =?utf-8?B?S1YxaXg4Qyt2eXpsUGRPZ3k5VVJCaCtzZWpjQkt2RW9BYTR3RTVDTHFBNWtu?=
 =?utf-8?B?Q1g2QXdSU2ZxWFF3ZEl6Uk9QV0l6dEsydG9ZdGswSWFTYlpVakIxQTJZTHdk?=
 =?utf-8?B?ZEFCcW94cUx4aVVhVytnQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0h4Um1KUmJWZ215OFk4WHBxM2x4VzdYeE9wSEJrcFBqOU5BNkRVa3pDdURo?=
 =?utf-8?B?Q0Q1dEJ3ZFdRTGFMdXV5ZnhpMG9SeCtSKzljcmJlaTN0V09ON1NxYXVmaFFP?=
 =?utf-8?B?RFMrcDBtSzRKTW9kaTllaVBYNUh2MjZRNzBKYzNMZG5uc3o2RUxHT1NZcTRq?=
 =?utf-8?B?Z0ZIVUE4SmhEZVFJM3Zja1ZvQXY5cG1ldndkV0ZNY2hjQmhvYUpJYkdGVEsv?=
 =?utf-8?B?bUQvTUpQN0ZILy9JRzMwcXJaeGoxNjNKZjM2aUsxeCtINFZDbEkvVHFVdjVQ?=
 =?utf-8?B?dXY3SG15VzE1cEZ5YjdXVmlERDJtYUwxV0xUMXNmOFZlRUFLNlNhRFMzT2R1?=
 =?utf-8?B?Wmc3NzgyRE1xcnoyUVRpVDlFc2FzM1h2K1pXNjJML1dRaFYwTWFiQzZmR0Fs?=
 =?utf-8?B?OXNUTUNKaWZ0b0lWbjJvd3JVTWViUUFRUG96cDBDR1pkYU9lTWZ1M1JEZGNX?=
 =?utf-8?B?UVJnWmcrSGUySGpNNFc2Zmp5SFM4SkRZSlNLN0NBSGQwSWV6eHRDT0xTUmZz?=
 =?utf-8?B?SG54eDlpaXh0RUlRUGppbFg2ZHNmUlRVQy9saUxxVitqSzdBMmN2c0ViOVMv?=
 =?utf-8?B?Q0RyejNMOVY4YndhNDZEYlhhVFJPL2E1MXNaT0JZdXRhc3lNRFEvODlpb0hW?=
 =?utf-8?B?OXhvdmsyVGt5amc5V29rV2hMcUF4QWt2Z2o1T28xWHRxMXd3THhLZnNFR01i?=
 =?utf-8?B?cUJsQTh5Q24wWUExNGRxSW1RcXdxbURabDRianVQYi8xMDh3R3g1Q1hpRzE4?=
 =?utf-8?B?VVkvMHRjRlNkS2JZWHpKR0JSYmU5ZSsyZytXbERkYnRzK056MGNhaE83Sk9q?=
 =?utf-8?B?T2VYRkJJTmVSdlBJYUl2RWU5eVVUZlRRWUFxNDRwM1NaVkQ3YTQ3dGZ5ek9R?=
 =?utf-8?B?UFNjUC9tTy94UzhHVGg4UlR1VERzeGtJUFlieStzbUhFaHdEbnQ1L0hnaVNS?=
 =?utf-8?B?U21oZ1NsUnovWFlnRkRTZkRYM3BEWWcvd1AxOFRuY1lXYlZ4aEpJQTVUTkNV?=
 =?utf-8?B?M1p1RjRaWHhtQWFWamc0Z1NrTUpJNVVVaDd5RE1mRno3MTRKL000aFF6ME0z?=
 =?utf-8?B?Yjl4TGFUdVBJcGI5K0lXSXVuTEI2bmVGTzFhV29GZVVRQW1YSThvL1A0T21s?=
 =?utf-8?B?bERFaS9pa3J2RTE3UHdVNkMwc3IrbzZTd1Q0YkdLNHJmVm9WMmNRbXAzeXBy?=
 =?utf-8?B?VkhJRkZPci9lVVkwdkc1Y2RVRnhHY2YwT2Z1UWhORVpkNXZXOCt6VlpEWnN3?=
 =?utf-8?B?TDNEaC9Gd3FoUHk1NHhzdXRkZWNaMEc2S3Z4OGlYSXpZZkM5Uy9FQkVHcEhH?=
 =?utf-8?B?RC92ekV2bmN3VVVFTjc3SURva2w1cjk1ZGQyb0dnay9KYlAzTlcwM1F6bmF3?=
 =?utf-8?B?ZVhFN01FMVJnMS9takdHdktvZWFacHFDQjRZcEJidjRnejNOQTJpQWlncnJY?=
 =?utf-8?B?MmVWcE5tL1h2SnJod3d0TkNpSnA0S2F6aFZQMVRJYkVVSnFieCs0K1R4d3Nt?=
 =?utf-8?B?Mm9yVEphMGdUMG00UXlwWmgwVzU4NU1mdDRVem50UFVPbTUrZHQyOGtsQS90?=
 =?utf-8?B?dk1lZzZXdkhqTWRzZERpZmdPOE9CSjdYK284b3loQ0JBUmxlekhmZGFrdGly?=
 =?utf-8?B?eENLbUxEVm1lZ0s2SXpDNGE3Z0tKZlFKUFlRR2p5cCs3N0lUMjdUaVk0NzBi?=
 =?utf-8?B?UzlNRkdVVFlFVVhVZmdoUisxbndkaXlRQ0tNTTJTQWk2VUxtSU9INGdZbTVE?=
 =?utf-8?B?V3pkRzBwRStUYWFsZmc4TnZsMFZQWHYzSys2NlR2eE1UQlpLbCszQ1JraDVD?=
 =?utf-8?B?SGxxaGZDZExVQjVNZG9GbXlUdTRRTktEVXovdWNZT0JJbE9uWXpWVGxzUHAz?=
 =?utf-8?B?ZU9Nc3ViVG5mcXpxek1mNlU2aGJyVWtvQnQxN2UxOUMwTlFDQjBNcnhpbVZs?=
 =?utf-8?B?YmVYTmxMdjJ3cTcvVEtPSWFkVTRKNy9yeTRHMVZpV2tHWi81REtwMjZwV1V0?=
 =?utf-8?B?ZXJmbncwMHNzRk52OUs0eEJkK2FqYnFMUEYwS3FZOVExWGFERE1VWjRES29j?=
 =?utf-8?B?MmlhcXR0WkhUeWpYR2lDQktHRUo2RERtZDVnaFovRUdCTWsyUGh2OHVtQkFU?=
 =?utf-8?Q?+S069LCDpfFzslPXkO0dkdMOl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a66e8f7-be67-4f46-6c4b-08dcb61ea05c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 13:49:43.6878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Psz+hG1Z8Lnk3k6PHsMr0/nupj8bfT33DXCBDKTy/ck/MyKqhOaZxtukkpcSS3nOMalSMuIDfCgkQ2DTthqWlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7912

On 8/6/24 07:54, Ravi Bangoria wrote:
> Bus Lock Detect functionality on AMD platforms works identical to Intel.
> Move split_lock and bus_lock specific code from intel.c to a dedicated
> file so that it can be compiled and supported on non-Intel platforms.
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> ---
>  arch/x86/include/asm/cpu.h     |   4 +
>  arch/x86/kernel/cpu/Makefile   |   1 +
>  arch/x86/kernel/cpu/bus_lock.c | 410 +++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/intel.c    | 406 --------------------------------
>  4 files changed, 415 insertions(+), 406 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/bus_lock.c
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index aa30fd8cad7f..051d872d2faf 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -31,6 +31,8 @@ extern void __init sld_setup(struct cpuinfo_x86 *c);
>  extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
>  extern bool handle_guest_split_lock(unsigned long ip);
>  extern void handle_bus_lock(struct pt_regs *regs);
> +void split_lock_init(void);
> +void bus_lock_init(void);
>  u8 get_this_hybrid_cpu_type(void);
>  #else
>  static inline void __init sld_setup(struct cpuinfo_x86 *c) {}
> @@ -45,6 +47,8 @@ static inline bool handle_guest_split_lock(unsigned long ip)
>  }
>  
>  static inline void handle_bus_lock(struct pt_regs *regs) {}
> +static inline void split_lock_init(void) {}
> +static inline void bus_lock_init(void) {}
>  
>  static inline u8 get_this_hybrid_cpu_type(void)
>  {
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index 5857a0f5d514..9f74e0011f01 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -27,6 +27,7 @@ obj-y			+= aperfmperf.o
>  obj-y			+= cpuid-deps.o
>  obj-y			+= umwait.o
>  obj-y 			+= capflags.o powerflags.o
> +obj-y			+= bus_lock.o

Since the whole file is protected by a "#if defined", why not just use
that here and conditionally build it?

You could also create a Kconfig that is set when CPU_SUP_INTEL is
selected and, later when CPU_SUP_AMD is selected, and use that
(CONFIG_X86_BUS_LOCK or such).

Either way:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

>  
>  obj-$(CONFIG_X86_LOCAL_APIC)		+= topology.o
>  

