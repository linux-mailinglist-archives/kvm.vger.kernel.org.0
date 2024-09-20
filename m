Return-Path: <kvm+bounces-27205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD8D097D30C
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 10:54:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D1401F2344D
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 08:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA32134CF5;
	Fri, 20 Sep 2024 08:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0723BQL+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6D22AE77;
	Fri, 20 Sep 2024 08:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726822465; cv=fail; b=OcvoGghBYHSjDwEbeFAfno4mYp3x543dIt553ewK7ryBlVWpV03dhh0ujpGfSDUNJhigkzDoEEgr+/xuWCN6RyxT1cSLVDLFUQQdua4AGRAz3q7vhaUtwsbtu+WEuvgVAWrIwq2ObtKDf6c/PQjjXRzwLGD0UwVhdm5yHu5EB74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726822465; c=relaxed/simple;
	bh=Dm5oCSLhGnliZPd/kd4wRudXQm4u9W+3RDHlkw/PSJc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sjRY1odW8EnXLF6WJpttiJ+PM+IiiRXP2ROKClAbxz2RMgahBwUtJiq561bosNH7MjqDK/jVPt7SDTtjFw28dA0qSnMePkvr6Z/tCr5fE95aAuDs19hSxL5DPlkm1+2xWC8hL7hIZ9wgOw99kJEdyu6I/I4WMaZQkHG9qvqj7LY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0723BQL+; arc=fail smtp.client-ip=40.107.92.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jo0rjjlntPv4QprYg71wLNNV7HTbnWWHBqx3RbuRn9KZLhWfRYsk5wSRWReCH1QdopbyYmwcyCUjZGlB+fIoV6Hc+RY6SSWiEsPM7z5kr//kD8lwLx0urr4dQzBwJOdVTctztHyjiG3yMNNbOsyXOtT35g3Cx079G+Eqs1RHSPv7tGrDW6qDstfHEGcVtjvEpDvivl8PTJt6y0p0GwmDzVtE/hW4fyXXI+rlmmSLMM43e9hGaRTztahVwgo2gBrYeVrDIleUk9RXh2bnXO/53p95sUq9VjQP4nEzwb69vQwcCIvojRml86g+2ADJ6DZTrucO3QwzeEGgGGYe2wiGMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=69E9lEYd7EWHyOuZ7im6NWZPAYOKXsr0n/eER0lo28I=;
 b=VCoUmOJfzx5j9vKh6MFMJLhUm4RnSGQJoOAT1mS3n95miX7dEEzZ58OgADcwnejliSbzbX8qw+VBhS/gErmwW+TZga5ljAdhGiNoebYzuRizTWQsMI4u11fiQOAYbci9aqTI2ibmZHjAxW6nDOIhdf+4KjqykZfeOI+nMgo2SgK/Z+go04wL5ZPfafbDiBeQYpXqA6Nz4nuB73BBQAKwc7A3TRlK7SchgY239tDOi9ySsB5Yi7AOWeXqv1ruFisA7afUwOzs9xeU3OEZyFSWY/XptTO5aFKlKF2D+skvMs8GSI6BNIjsnQHGyRPcThJLM9MkTxz5H1UkDaWXmskFcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69E9lEYd7EWHyOuZ7im6NWZPAYOKXsr0n/eER0lo28I=;
 b=0723BQL+m7A6wT+JhURr85Qln0V+k4M4vvDI/dQInp4U7M/LCIJy3FFzFyRNgItUzLbiiISP11zBBPU27WrLORUxeLblXOI2OGvdxjTcjnP3yHXnCDadajR/G4ejEAFl8BLYcKemJljZKvCuHNAWc1ULirY004ia/ybVfb6GrRs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SA1PR12MB6679.namprd12.prod.outlook.com (2603:10b6:806:252::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.16; Fri, 20 Sep
 2024 08:54:19 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.7982.016; Fri, 20 Sep 2024
 08:54:19 +0000
Message-ID: <4cc88621-d548-d3a1-d667-13586b7bfea8@amd.com>
Date: Fri, 20 Sep 2024 14:24:10 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-20-nikunj@amd.com> <ZuR2t1QrBpPc1Sz2@google.com>
 <9a218564-b011-4222-187d-cba9e9268e93@amd.com> <ZurCbP7MesWXQbqZ@google.com>
 <2870c470-06c8-aa9c-0257-3f9652a4ccd8@amd.com> <Zu0iiMoLJprb4nUP@google.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Zu0iiMoLJprb4nUP@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0172.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::16) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SA1PR12MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: 69404169-216b-47ef-2dfd-08dcd951d02b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWQvN0ZocWUvTXFOVzM0Nm9aWWFDc0ROS2xMbytGNDdlNGVNSkNyYVByclRX?=
 =?utf-8?B?ZElvbUxBbzZWSkl1cE1tZHQ5czBWYnVxT09xZ3NFd1BXQzB3MlNxSU1DRmNL?=
 =?utf-8?B?R0NmT0Q0WUtieFBZSWpmM3pSUFlFZmRQYm14bTFWTk1EeDhKZFhjemJqdXpo?=
 =?utf-8?B?b3NkTStPN1hTbVIxNHJZaFg5aDlxWUFPUUtmM0swTVA1YnhTRVRvVko0eC91?=
 =?utf-8?B?U29GbFdVa01YVkhxVU1PczU0bmFsQ3o5eXljSTFNUHY3U3o5ekkzOUxuM0JS?=
 =?utf-8?B?em1XT2g0R1lsbXRIU3dVaVRtYzY2bkZMYXRYSzVOcWVETjNSRS9mdWtLTC9n?=
 =?utf-8?B?Z3BJOTJmdkpTMTBPcFE1WjM0QU9ZRnFSYUE1K0RSeVRpVDNZcStXWjZNZXJF?=
 =?utf-8?B?U1d4WXZTWEFUQVRXQXdtYTFhZFBXU1dPUkhZbVhRaE0wY0lmR1ZEQjR3bko0?=
 =?utf-8?B?NzB4VVYxaG1POStOL2h6akVydnRMME93dzNqMWFReGw1K3QwUTh1cmJMR3BW?=
 =?utf-8?B?OFNsakZTelZ3enBvQXZVNWFDeTBVUlpKbUUyZHI4Vzc5bkVRZXE1S0tUdEdD?=
 =?utf-8?B?Ykc3YVdwdVczVDNZbDROWlBFY2tNODBFU2psY0hqK3BXbHpTNExBM3ZWdFk2?=
 =?utf-8?B?d1AyV0lZT1ZZMHI1UHBCVWljZlNnVFl4Uk9FTlJnRW5mNVpMV0RXVDNQNFk5?=
 =?utf-8?B?cmtqaGttak5pZld0bFhDUkFVa3VpbVlkQ2YvL0VQeTZSNjM0OGFRWld5V3Ir?=
 =?utf-8?B?QStQNnBhNkhQSDBERW1HSnBqb3F2ZkJEbE9mSFdoT3NsUWVwR2RiamF1S0Jn?=
 =?utf-8?B?eXhxL3Bra0xjZjZPK1VSSnpFMnpJR2ZDcWRydnVCWUFNWDcwREJMLzhLa2R1?=
 =?utf-8?B?akpaYVlxUVRWYnpwdUNsRUd0UUZJSHJuRk5uVHFIci91eFhlZ3NqUVB4aUJa?=
 =?utf-8?B?WlpWZkVqbFNtV3RGNm9naU9ySjBnMTlLWGF2RVJJaHB5MHZZeVNaZjFhZDdN?=
 =?utf-8?B?UG9hcjRWRWsyazBpQUJpSkMwYlcyUzdXcUpTa1h3WEZqTmlydEkvbTJDRHo0?=
 =?utf-8?B?clRmdnFVRm1nV3FjSWNOeDJtY3JUY1dtK3JEQWVyYjk0NmU1YVUyQ1NRM0w0?=
 =?utf-8?B?ZGYyeTBHcUUvQUZPOFNPVE5RQzIzaFlpV2J5ejBzT0NMQjJINzdxd2hxWGhn?=
 =?utf-8?B?S3JmVHVTL3hzWmlUR0pHd1pURHhuQy9hNXFiazk5NnQ4U0cvZm5PZGxRbTA5?=
 =?utf-8?B?cG5zNEpaQnpORWlSQzZZejhYYTkyc2d5WUsreHUwaU1hS2lpWWxZOXlQT0pZ?=
 =?utf-8?B?a0RQbXpSNFNWM3gvOFBWR1c2WkV2WjhXVk01NDJrU0d2bjFWVHJxZTZlR0ht?=
 =?utf-8?B?ME0welhYeXRycFBaL1pyaHk5N0NubWZQOXd4bTBZN3dKNE04dVN0eEg3SWcy?=
 =?utf-8?B?WFV6UHA1VmpMTUd2WmhFSE8vbmJZbGYxQUhwcEp3MGhvQmZUaHFBY2lpWExq?=
 =?utf-8?B?cUpOMUdGSk9pS1c1aGZEb0piV1RRTDNId2I5SVROOFVtMzhGb0lJYmtOOCtK?=
 =?utf-8?B?VjZvVnpGNzMyOUdYWlV6MXRWZFcySW12ZExpeVRZb0R2V2svVUZSbSs4SFZn?=
 =?utf-8?B?SnJ0MVhpL2JwRWNCRkZiWUF3dENuRFJyQ0dLa1J4VVVGbDd6WWsvRlJVbTZE?=
 =?utf-8?B?ODJ3MkhsM1Z4cU8rRWt2ZEpnWEhkY1J0V2IzOGF2ajhySzJ3VTZZYXpSSVVr?=
 =?utf-8?B?eXBndS85WGNoa2xYNDJUdTJ2ZW9CeWFwMzNxanpNdnRiN282cHNkNFd5TXda?=
 =?utf-8?B?SU9qYTl0OGpZOWJRdkJqUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1N3U1pxT2hrdkozaGxTV3RPYmRCenMvZnhNeEJhb2w3Qy9TdHpLZDc3N2sv?=
 =?utf-8?B?VWZnOUx5dHJGczIxc1RFYTh2VzUyd2Zsa1EzT0hrcnpLaERUaC9kWm1DZ3ZH?=
 =?utf-8?B?b0pNcGYrYW5EMElWVGRlZndpWWZRV3VwYjgwVFZ3eEZSTHp6bTh4Z1ltKzBt?=
 =?utf-8?B?TENodVBtMTBrajZUK25qNHRrZXZpTGZOeDhoTVh4TXJBcytneVpKQlRyQVlS?=
 =?utf-8?B?bDMvWFh4UkYrTStxSTNoTnczWEdYb3hzV2lHU3I0NDJvRUViNzNGQWZ1bjZ2?=
 =?utf-8?B?dEJLUnh4WGp4VzlqVFZHMm5pVEpKRDNKWWc4QWloa3k0QS9ObHo3dTlsNGtT?=
 =?utf-8?B?YStNUTE1eU9nZy95cys4MTlTZVNtb0ZWODVQTkc3YkVuQkdJSXd0OXJPQ09M?=
 =?utf-8?B?NFRRVnVXOGZaTWQwNGhaMFpaVUcvUnQ2a2E4WTFOank5cElRWkZDZGJGekNV?=
 =?utf-8?B?c2hlQnc0eUc5Mzl2WjlWMTVrV1Uyai9QQkczODhKc1VoRUpkTW90MG53UHdR?=
 =?utf-8?B?Yy9Mb2NtUkRURzBhL0RmS2hMRXQvTGNybENFU2N4OXFNcUVWNUpTaVhoeGhs?=
 =?utf-8?B?MW1oTEhMREhyOHh5YkFWWE01L2lLMHEyQlRIT1FXeEpST1BDbzJTbjJyT0sy?=
 =?utf-8?B?b0duVEFDbmVJMHdJaDZ2bVdUajlFYWJtckEwYUJoc3RJcE1id0dWWU1Yb1JR?=
 =?utf-8?B?ems4ZVRBY3hOd2gvQkVhN2ppMFNZaW1rVDE1WGlBN0ZRZDJNbG14d01ORHZJ?=
 =?utf-8?B?NjZiRFVySEo5cmtlTFZNbzd1SHdKYzhIV05hUzZZaWl5VHMxb1F1UDJpOXJr?=
 =?utf-8?B?bVBhRDIrclNZTmcvekNyYVp5ZUdsTU4zUlJtWHN0TU5PcFExSVpSR1ROUGxS?=
 =?utf-8?B?NEVib2hQUDlScnBJeXRVYjRVK0pmVktqL3VXKzVRU2JTZzdXdTg5cm9pNkRq?=
 =?utf-8?B?amhjZk11OWZiN3crRnVqd3ZRQ3ByUDF1anRGZldQRjZ6K3lOOGVtdVZ4TjZw?=
 =?utf-8?B?ZTdndVNCUnVYTjNCbTdvTHY4dDl5KzZLZXR0b1NwOTYrNU5idUl5VEJQZjNE?=
 =?utf-8?B?bnBWc2RPOW1SOFRhNnp1N0RCUzdPZ045MnpWd0VEZzlXLzFtRmh4U0pTcGUw?=
 =?utf-8?B?c3pBbG8zblVicVZKZ2s5M1dEOC9KVWhLa21vMmJrd3ZrRXRVOEtxdytYL2RG?=
 =?utf-8?B?cDBtb3VwVE0rbktTb3NmSUFIaHEvRllUNHYzaDB5ZHQ1YlFLcVJhTnFQR25p?=
 =?utf-8?B?a2ZTMmduL1lDeXpwT0lxenlhUElEVHBvMnRhTmRuMS8xY0daMk5zOW1vQUZ2?=
 =?utf-8?B?UmFjaUV4S1NqdFhBWVhHRUNFR21YbkZORVp3NFBUQmVrdHNtRE04dFpNSjFU?=
 =?utf-8?B?bWhGOGlzOTlvZGNuUHpqWUJ0SlBnT1h6SjhlSnpxaTMrN1BoaGloazV4WWZW?=
 =?utf-8?B?NU9YczUxb0VObFBQUTVuOFo0RXlMOXlYYTZUVkFIYXlXejJkZzUvUW0zSWpw?=
 =?utf-8?B?eWx1OWRTNlliYVRzdVVyUTd3M2x6aHM4Z2poZXRlNlRvLzVFNWVnT044TjJq?=
 =?utf-8?B?OTVNbjh3VmxwdmNNMk4vY3o2WEwybm9ZUm05VVpxdkpzOVViN0Q3NVAwbyt3?=
 =?utf-8?B?VjRwa05UMXJ2MHZKbDZCYWFYSnZvMGhLdXNwYW9QQXkvUXhPcThoTU1OWUlm?=
 =?utf-8?B?Z2M5N2hCajltNDdqSi9pUzdwaWtsbEFScTJ6WEhPejhqTHlrQ0FnZ2VtL0RT?=
 =?utf-8?B?N2xBYnRDTnF6WTV4amNUZXFhdVA5bmZjdjQxbWVXMi9MZ3BTOWNuVFdkVTNk?=
 =?utf-8?B?eU9DRE92SElFL2JSMTdYZDFUOW0reGpNcU5pcjJzd2ZYRzNNZ2h3NUZBOWN5?=
 =?utf-8?B?bXJZdjczbXFGQ3Rwa2YwNGxEOG5rS2xvZlp3a1ZqTzczVStUSy9FVGVQbTVI?=
 =?utf-8?B?ejlhVEVHRDl0NmtNZnhtTEQreWtYN1NXelAzZUh3dlRlZGpXNnRRTDlFbnVG?=
 =?utf-8?B?bkNpamRwNW9EVUsrb2FYU25TRDdIRVNiRWpCMXovMkV3Tmw5bnFFSSt4aHB3?=
 =?utf-8?B?enFJdjhIV0JHRmk5UkdSNFNHdzd1RmtMUnNzZmwxN1JMN1B2bkpLM0lWSWtU?=
 =?utf-8?Q?rhFQarcDKwKcuyQQL9LtszUpr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69404169-216b-47ef-2dfd-08dcd951d02b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 08:54:19.1816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4gVLWsvmnaIyQFicjaZA73NmRCaQ8XxKt1ADkG9rQlzbNPr2MdOq4U9+LfkLZ4dCbGzWIaS5uQMRXF/IzjW7SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6679

On 9/20/2024 12:51 PM, Sean Christopherson wrote:
> On Fri, Sep 20, 2024, Nikunj A. Dadhania wrote:
>> On 9/18/2024 5:37 PM, Sean Christopherson wrote:
>>> On Mon, Sep 16, 2024, Nikunj A. Dadhania wrote:
>>>> On 9/13/2024 11:00 PM, Sean Christopherson wrote:
>>>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>>>> Tested-by: Peter Gonda <pgonda@google.com>
>>>>>> ---
>>>>>>  arch/x86/kernel/kvmclock.c | 2 +-
>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>>>>>> index 5b2c15214a6b..3d03b4c937b9 100644
>>>>>> --- a/arch/x86/kernel/kvmclock.c
>>>>>> +++ b/arch/x86/kernel/kvmclock.c
>>>>>> @@ -289,7 +289,7 @@ void __init kvmclock_init(void)
>>>>>>  {
>>>>>>  	u8 flags;
>>>>>>  
>>>>>> -	if (!kvm_para_available() || !kvmclock)
>>>>>> +	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>>>>>
>>>>> I would much prefer we solve the kvmclock vs. TSC fight in a generic way.  Unless
>>>>> I've missed something, the fact that the TSC is more trusted in the SNP/TDX world
>>>>> is simply what's forcing the issue, but it's not actually the reason why Linux
>>>>> should prefer the TSC over kvmclock.  The underlying reason is that platforms that
>>>>> support SNP/TDX are guaranteed to have a stable, always running TSC, i.e. that the
>>>>> TSC is a superior timesource purely from a functionality perspective.  That it's
>>>>> more secure is icing on the cake.
>>>>
>>>> Are you suggesting that whenever the guest is either SNP or TDX, kvmclock
>>>> should be disabled assuming that timesource is stable and always running?
>>>
>>> No, I'm saying that the guest should prefer the raw TSC over kvmclock if the TSC
>>> is stable, irrespective of SNP or TDX.  This is effectively already done for the
>>> timekeeping base (see commit 7539b174aef4 ("x86: kvmguest: use TSC clocksource if
>>> invariant TSC is exposed")), but the scheduler still uses kvmclock thanks to the
>>> kvm_sched_clock_init() code.
>>
>> The kvm-clock and tsc-early both are having the rating of 299. As they are of
>> same rating, kvm-clock is being picked up first.
>>
>> Is it fine to drop the clock rating of kvmclock to 298 ? With this tsc-early will
>> be picked up instead.
> 
> IMO, it's ugly, but that's a problem with the rating system inasmuch as anything.
>
> But the kernel will still be using kvmclock for the scheduler clock, which is
> undesirable.

Agree, kvm_sched_clock_init() is still being called. The above hunk was to use
tsc-early/tsc as the clocksource and not kvm-clock.

Regards,
Nikunj

