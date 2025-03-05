Return-Path: <kvm+bounces-40113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B12DA4F431
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3A1418896B9
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6998B155751;
	Wed,  5 Mar 2025 01:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pf6znWzu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C64146A6F;
	Wed,  5 Mar 2025 01:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741139916; cv=fail; b=VR9E85Fn+NNqpn8oOBgpPgQVVJsAnM4UXxFQDvwI/mj18hbaQK9TlsWUPO9pOz7KSZqysXNFnSgC0Vj2P9dRaY53Apkh1Q5w3185gbD/QOb5oE9avU6Re3G4AAcTqmaRlD1e2aTwIe1h26zoEgLX7VUCGjgOK/IPybf0aqO7RCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741139916; c=relaxed/simple;
	bh=s/n9+oD1z+HLxMbvIpELH717JeVWUBcIk/Veg1x3PHk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PFF5inw6pBNR9gAkTX8HhBuKShv5m2AYKUemHmmuQTmEfBNi6CsG6TlYwz21cHWPgoVPan2XUjSVDvwk3B0+J+qQoCNDPXeIWoow238HNe2fayWrFDalOws/LNIKJeb8VcXNZGzKgxxsLizwDQybhdN9R1FZQGYmrKXT7FLy198=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pf6znWzu; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCzmOXrx8lDiBc6v4zPVtOu0QQied+ttxNmzHVQC/YBx4RN3x7TQfDuo4fA4uwUdmQxfeLrxrhDhNFVEp8/s+KeHAqGGp7TNBXJ7i0ISIK2yhCL+g5bBeLRN3x+B5Q9sgyQxGsWBWjob0YaBag0EAWIvfiDMJQpPgep+ME425b/Ot6YLgQofBRIwH3OD3hbwaKxVbXJvZAGLbBBZh+YJNfWIMA5YfqUW7owGGWhCF4uHQ9Da80KiPJnI87Lfb2aYMxHb7FCNBeTpOyKaTHxREjBnDBdWLskPqxEi84M1mb8stIGgshsQ4mVVpfqeFp0j4MLlquaabirr2RLCE9nOUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CEQmh9ssTJ/wSyYzeAqXx0sdN6lNRmxLbEIFIrSkdk=;
 b=yn7aBx6E1bzCctIbNZqWpVYgVXilmpr9mCCXFgSscrjJM7orS/T2S40D02/thzf4Djbf4l9i2Zg4/AunXCrS5TlArHSQLGnJKZNhd7TmuPeMNKeonH1bbCOz3E+tJgWdzeZl/5z5ignJP5wnLhuA6Mpfsm1rV389G1cotIJKjoal9uyLSjGF2GiZyspa0FzxNQ5fuoWIEaK3bdKsLZzdkdvkKA4YRkDSsE1UYoD0TVdpc2SKudR/JCh+Wqwe8WHXGzTOgJquw/dUMd+d+q1OX2qzRV+aY5BP4NV5yTArZ0Vnb5L41iF3Ge8xb6/wJ7EUc8mAP77yy4R1qBDvUxOIfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CEQmh9ssTJ/wSyYzeAqXx0sdN6lNRmxLbEIFIrSkdk=;
 b=Pf6znWzuUwRy4NwkXrf+dyCIqnrhKHctaynBh1FFLWaopmEdyO44of2irIKzk3j0S7ypzXUO84CQ10jMZFEZ0pIr9iGRtp41wMAZNW67mX79sMX/1b15xGsl6Zuw5vfkiuNRPInivbXoe+8hhOHrYvv84UGjHzn5aujEYEDJzrA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by CY8PR12MB8363.namprd12.prod.outlook.com (2603:10b6:930:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Wed, 5 Mar
 2025 01:58:31 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%2]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 01:58:31 +0000
Message-ID: <a0feef4a-1e12-445c-8a17-0f2ecc4d7c85@amd.com>
Date: Tue, 4 Mar 2025 19:58:28 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
 <Z8IBHuSc3apsxePN@google.com> <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
 <Z8I5cwDFFQZ-_wqI@google.com> <8dc83535-a594-4447-a112-22b25aea26f9@amd.com>
 <Z8YV64JanLqzo-DS@google.com> <217bc786-4c81-4a7a-9c66-71f971c2e8fd@amd.com>
 <Z8d3lDKfN1ffZbt5@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z8d3lDKfN1ffZbt5@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0138.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::27) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|CY8PR12MB8363:EE_
X-MS-Office365-Filtering-Correlation-Id: b1401fab-2011-4dca-695e-08dd5b893aa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDNGVzBQYXFVa1dWUU1nT2crQzdPVGp6aVRqVkRhdDV2UTFCSXJmWlQwdFdO?=
 =?utf-8?B?OC8yOE5wb0o1YlFxbVM4RVpDalpNMzVBNm5ZcDlpMFhlbWw5K0d3cytta3pm?=
 =?utf-8?B?dktvTHArOER6cW95SVh4djFMNUxEMHRNdllJV05HZTJlWHc3Nk5mWWVaVm1r?=
 =?utf-8?B?bFJxa1diakhPVGFvNzZQOEQ0L1pWenVVTnU0ZnM2cFlVWk9nUzhGUGdObU95?=
 =?utf-8?B?eDBvSUo5V2ZPRnVabDVuMlZYZEI5U0Rib0tYQUFDL0xNcC9Ld3crWmYrR1Fi?=
 =?utf-8?B?dWhvcUhpZHpzbURlKzlycW5TaW9xUzQrS1pjZFNpREp1ZmduZzhmM0RtTS9U?=
 =?utf-8?B?OGxCeVl5RnlIUkpWdm5uYTRPV1B4WEYyamMvTEVOOEhFRHdTOWt0S1Y1ZlpT?=
 =?utf-8?B?V0IwUTBZUitnTVhQN0kwREZzbHI3NElQRlEzYmMzZFQyNzNlcm5MdXpXRzNv?=
 =?utf-8?B?NTlSMmZQUzZMWU9iQnlJdy9sbEg1VldqMVQwTm42NVBEQVRlTXd6bFJvSlk1?=
 =?utf-8?B?Vy9XTENpbzZLcDJ3U0p6Vi82OU96STZSUzlxOURoQXo0T29GVkpIVWxWTkc0?=
 =?utf-8?B?a1pNOGJDK2cxeXZJK0RyS1pDMEdCTERzMlJ6OTc3S3ROY1NjUHNCay9tajFT?=
 =?utf-8?B?N3NtSEVhQXpXMUk0b282a240cTZjWkY0TG04d0t6Nmp4RFl2QnNKWU11akdC?=
 =?utf-8?B?YzBsUnZRbXAxbmxpWGNZelVTb3Njell3ckxKKzV1WUhEQm5BUlNjR2VsZys3?=
 =?utf-8?B?akRvcVArRTBCMVFSK1F4VytZV0h4UDFJa3RGNWpSZ2k4azR1anJ2Kyt2eUpE?=
 =?utf-8?B?enVZREQ1YjFjZHZJZnZlbUZmczdldndzT2thdzNNVDFBcnNZbEdGdCtLbk5S?=
 =?utf-8?B?WlJ6ckEzNHgzaDltdGR5WFNXbW9ncEEzK2kvR2VMWnJ5TlJYK3RtMVFsZW5k?=
 =?utf-8?B?d2RralFkNVdpL3FOcDVtZTRlQXZmTi9IcXJjOVZqU3dlZS9DeHBqUzlUaXVk?=
 =?utf-8?B?dk1TeTBvR0VGdFN6RTBlQWhka2RBRjljS0wxM2xKWTR0QkpQd0VsQjVrYTc3?=
 =?utf-8?B?MGQ0dlRxRHVZUklVQW1EOUdKemlJZW9mZGgxMlRSWVNYT3JEUzU0VlRhcHFF?=
 =?utf-8?B?aTlPOWhWeFI0dnBJSHhJZXdHNjBpMnYvUHFSellXM3o1NHJPZGxMb29ZQ2Nm?=
 =?utf-8?B?Q2xqVzV4cHJtc3cxRjIzZVcycjNRcXIyempDQ3IrejNIb0hqMFg3djJ1S2pJ?=
 =?utf-8?B?SW5seXRYOG9aOEtrVG9icmJlUFBaUG1mencvakVzdVo4Zkh4ck5QKzNFVmxj?=
 =?utf-8?B?T2h1TlRqR2hCaXdmWXJmUERtbk02OC9Ob3hTay9LaGVTOXIvSGJ5cE56V0NR?=
 =?utf-8?B?NWZYSklxVG8wQ1NBQndmWkRDbXBCY0dacllKZm5nbkwvYW0wU29DWmRXQlFs?=
 =?utf-8?B?RlgwNzFxN25ubWFnNll3bXFyc3F4bSt2aDlycXVyKytJMVJ5b3NwMnM4Q2JD?=
 =?utf-8?B?eVZFMnhxNS9PRDcyTVY5c1c1UDFrRHlVN3JuOFcyMFZrSFhkWVViTExHWjhV?=
 =?utf-8?B?VVdkVllPNmFTRUpERWZBank1cmhva0g3MCt2eTdDYVRDQXdHbUNIS1I4c1F2?=
 =?utf-8?B?cEdLZDVvMy8yOEdRWTV4ZU5oV2pqT1l2UVNoaGNTcmNaVlE4K1R5dndoYVhn?=
 =?utf-8?B?SHpqeXJOdGNLY09uYzNHc0h0SThBeGV0eVRlQkdJZlVibDQrQ1puMGgySnJR?=
 =?utf-8?B?bE1zSVphajkyL0doTWlnN0VhMk1EdTIvRkZvQ3VueUFQNExMNEgwcmRxMGNs?=
 =?utf-8?B?azA0dHdhaDRpbThLYnpWK25wQzFhU0VaU242SXZJdFRDSzFlTDdWWllUNHAw?=
 =?utf-8?Q?CPPELKDRsr2Md?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUl5NEtiOVd6enhCelhINm9wQjdnT1JzVWZFdVJ0WUtBNXRTT1VqNFNwOFhV?=
 =?utf-8?B?Um13VllSaWkzRC9sNHdqaTdwdVdPRXorellVWkJIMXhHd0FlYlpwcG5vMDRy?=
 =?utf-8?B?cHlJeVdSa1hRanJBeU5nc29ZYmVBeTBIV3paWDJiaVNhOE91SWVzV3QwVnRG?=
 =?utf-8?B?QkliVFUxVmRHV3VtT1JvZitGbGxueXJjRHNPMDJXZjVEcU9OYzdkNG5iNUxV?=
 =?utf-8?B?QVRZUG9IdVVHMUtZMzdzK2RDTGtnL0l5dGFpRHFZeHhvMGtaN0VleDd3WnRy?=
 =?utf-8?B?NlRHNnBBNTVmQjQ5ZnZmMFl5YnlMLzZITjRJYmpOekswVDBmdTZQRTkrZVhq?=
 =?utf-8?B?U1h0R2YwSFo1VmsxM0tDcHJMck9lV0FYSlBGeWE0L1lXeXZUM1l1Q3lGVnFh?=
 =?utf-8?B?NWJZak9vaU9jWENqb0RCcDhDREt0L21jT3RXQTAwS3JjNFc4ZEJ5K1h4VzFP?=
 =?utf-8?B?SWE2WnBuSk1Ic2U4UHVORGpyWE1BWHNkcVM5ZjVZQmVXUTNCRFRScjM2S0FP?=
 =?utf-8?B?VGJuWmIrdnFKTEUrd05qQVVaMmI4VDZYL0ZDbGh5V2tJcHdvRlNFOFc1M25N?=
 =?utf-8?B?N2kwNXJkSmNVenNXSnY4N0t3M1I5NnlpOHoyWWxYeGdnWEFRM1Bwb242ZmRu?=
 =?utf-8?B?a2w5L3VVa1IweS9paXNXcitEbUlVRHBsV3BmdnNNc3FqZTBKZXVUVitFSlV6?=
 =?utf-8?B?eDBtMFlHNFM4dFZibnBjbzZ1M2JCbWZ0TS9talhSQ29sQkpXdVcyUTYyR1V1?=
 =?utf-8?B?WFFLQ3F6YUg1K1I1bi9SS0RIN1pveDExMWtCTjlmdFJiMXd4eHZMV2d3VEhE?=
 =?utf-8?B?QTljUjF5WGVqdVdTSWZrWGtuc0llc2JyU2lXVVdHUjFDV3RPZEtsNjA5MmFU?=
 =?utf-8?B?SGJjTkNMbWtqZS9jckE1UVg0OUNBK2ZtL2pQM3UyaUhKUlFMa1RaQ3NiUFA3?=
 =?utf-8?B?Z1dYUDZnM20rZkltM2RqWlhhTzNTTng2dnhyZ1FOQ0tzUGVocE1YTGd0UVZ4?=
 =?utf-8?B?OG9vUjk5eDFieFR1M1JCdSt1M3BlVEpJcGhmbWdLMU40cG9PcEF1OU5KVjgv?=
 =?utf-8?B?aDF4c2xVSmpXKzQ1TnNkMlFhbzB1V0QvaFBacVhZTGszYUZTQ0haVnJHSXV2?=
 =?utf-8?B?bmVQeEloaDc2S3UxUlZQTDJKODFMbkowdm9ReDF2NG0wSnd0WUpadU5TVnlQ?=
 =?utf-8?B?akczU0hTMWJJR0ZYekxIdXFLM0lmd2J6bzRUaS9PZDVrV3J4R0cxQTJOcUt6?=
 =?utf-8?B?cC9SVDR3dUpsSmZ0TS9HcnZmNFJzNFNPck1TaHNiUXBtS3dHelZyNVgwb2oy?=
 =?utf-8?B?NkJpbGRaK29qOUlaRnNoOWVmRWJmaDhWdCtSYjhObzBLTkZoTGhRZndJeWtU?=
 =?utf-8?B?c0pnZm5NRHpMRWZPd1RkdlhNMkQ5dUNPRWZyaEhISGtkdG44NEVZOFNZUGtM?=
 =?utf-8?B?YmUyQ3J2VjZOMThaTFBpdTEyWG1KNU40Z1pzaGJqRlpvdE84SGE3YnljZDMx?=
 =?utf-8?B?dXovM3ZqMFNreXRsRWZxcVpFRE10NHFoc0VOak9PdGorcWwzbFhQbE5OMSs4?=
 =?utf-8?B?QURNSG05QzBnR1JqWjlBZ0FQQytkVVpBREpocjB2VDlGYmFwY3ZLUnhkNVNa?=
 =?utf-8?B?bmhrb3Z2dkpTT2NqUzJ1YXRjVjY5QkZVMHNwRkIwc3pacEZaYWRJRzVOamhP?=
 =?utf-8?B?MzNjLzlYdzFROGNERmhKbi9HejZtdjNhV0dhdFBGWUZBTnhISSsySnRuUmlS?=
 =?utf-8?B?YUNuVVRiK2NDS25RQmw0cW4xTlZkNzl6a3Q5b2NIcnc3NzR3cVR1aXdiYkh3?=
 =?utf-8?B?dElXaXk5VnpjZ1NkZW90S090R3d2NzNQaE5CalF1cTV0NVFYWXRsT2srMStw?=
 =?utf-8?B?T3JUcmQ4K1lFaVpvSlgwT1pCMG8wY3BMNDBMd0xZbDRtUmg4RUpheFFCTDcr?=
 =?utf-8?B?TlR1ZEptUStkQW0zTlN3dXdGUk9CT3pod2xsSFBVb3NpcXB0cVlkNVNYd010?=
 =?utf-8?B?bFdpY0tYeTlsR21EQjNLYzBBRGdBYzZOQkZPa2ZlcHNlVE5WTEJYSXhVckRl?=
 =?utf-8?B?R05jeW1kS1lTRVY3RHhaeFh5MGY3eVVTWnB2ZXVkRzRJbG9OMzJsYmtyeTlV?=
 =?utf-8?Q?1E79TtetohdLLbHPxc8ybqTvC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1401fab-2011-4dca-695e-08dd5b893aa5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 01:58:31.1151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uiuwh3MyEvGDNTx7PYOvVAdaOL+gtYHZ8cp0BkW9WrH0wdGPTpnpvfVVqG6Dcr9WMgUM2NAZGBU0KBFD5Q7HIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8363


On 3/4/2025 3:58 PM, Sean Christopherson wrote:
> On Mon, Mar 03, 2025, Ashish Kalra wrote:
>> On 3/3/2025 2:49 PM, Sean Christopherson wrote:
>>> On Mon, Mar 03, 2025, Ashish Kalra wrote:
>>>> On 2/28/2025 4:32 PM, Sean Christopherson wrote:
>>>>> On Fri, Feb 28, 2025, Ashish Kalra wrote:
>>>>>> And the other consideration is that runtime setup of especially SEV-ES VMs will not
>>>>>> work if/when first SEV-ES VM is launched, if SEV INIT has not been issued at 
>>>>>> KVM setup time.
>>>>>>
>>>>>> This is because qemu has a check for SEV INIT to have been done (via SEV platform
>>>>>> status command) prior to launching SEV-ES VMs via KVM_SEV_INIT2 ioctl. 
>>>>>>
>>>>>> So effectively, __sev_guest_init() does not get invoked in case of launching 
>>>>>> SEV_ES VMs, if sev_platform_init() has not been done to issue SEV INIT in 
>>>>>> sev_hardware_setup().
>>>>>>
>>>>>> In other words the deferred initialization only works for SEV VMs and not SEV-ES VMs.
>>>>>
>>>>> In that case, I vote to kill off deferred initialization entirely, and commit to
>>>>> enabling all of SEV+ when KVM loads (which we should have done from day one).
>>>>> Assuming we can do that in a way that's compatible with the /dev/sev ioctls.
>>>>
>>>> Yes, that's what seems to be the right approach to enabling all SEV+ when KVM loads. 
>>>>
>>>> For SEV firmware hotloading we will do implicit SEV Shutdown prior to DLFW_EX
>>>> and SEV (re)INIT after that to ensure that SEV is in UNINIT state before
>>>> DLFW_EX.
>>>>
>>>> We still probably want to keep the deferred initialization for SEV in 
>>>> __sev_guest_init() by calling sev_platform_init() to support the SEV INIT_EX
>>>> case.
>>>
>>> Refresh me, how does INIT_EX fit into all of this?  I.e. why does it need special
>>> casing?
>>
>> For SEV INIT_EX, we need the filesystem to be up and running as the user-supplied
>> SEV related persistent data is read from a regular file and provided to the
>> INIT_EX command.
>>
>> Now, with the modified SEV/SNP init flow, when SEV/SNP initialization is 
>> performed during KVM module load, then as i believe the filesystem will be
>> mounted before KVM module loads, so SEV INIT_EX can be supported without
>> any issues.
>>
>> Therefore, we don't need deferred initialization support for SEV INIT_EX
>> in case of KVM being loaded as a module.
>>
>> But if KVM module is built-in, then filesystem will not be mounted when 
>> SEV/SNP initialization is done during KVM initialization and in that case
>> SEV INIT_EX cannot be supported. 
>>
>> Therefore to support SEV INIT_EX when KVM module is built-in, the following
>> will need to be done:
>>
>> - Boot kernel with psp_init_on_probe=false command line.
>> - This ensures that during KVM initialization, only SNP INIT is done.
>> - Later at runtime, when filesystem has already been mounted, 
>> SEV VM launch will trigger deferred SEV (INIT_EX) initialization
>> (via the __sev_guest_init() -> sev_platform_init() code path).
>>
>> NOTE: psp_init_on_probe module parameter and deferred SEV initialization
>> during SEV VM launch (__sev_guest_init()->sev_platform_init()) was added
>> specifically to support SEV INIT_EX case.
> 
> Ugh.  That's quite the unworkable mess.  sev_hardware_setup() can't determine
> if SEV/SEV-ES is fully supported without initializing the platform, but userspace
> needs KVM to do initialization so that SEV platform status reads out correctly.
> 
> Aha!
> 
> Isn't that a Google problem?  And one that resolves itself if initialization is
> done on kvm-amd.ko load?

Yes, SEV INIT_EX is mainly used/required by Google.

> 
> A system/kernel _could_ be configured to use a path during initcalls, with the
> approproate initramfs magic.  So there's no hard requirement that makes init_ex_path
> incompatible with CRYPTO_DEV_CCP_DD=y or CONFIG_KVM_AMD=y.  Google's environment
> simply doesn't jump through those hoops.
> 
> But Google _does_ build kvm-amd.ko as a module.
> 
> So rather than carry a bunch of hard-to-follow code (and potentially impossible
> constraints), always do initialization at kvm-amd.ko load, and require the platform
> owner to ensure init_ex_path can be resolved when sev_hardware_setup() runs, i.e.
> when kvm-amd.ko is loaded or its initcall runs.

So you are proposing that we drop all deferred initialization support for SEV, i.e,
we drop the psp_init_on_probe module parameter for CCP driver, remove the probe
field from sev_platform_init_args and correspondingly drop any support to skip/defer
SEV INIT in _sev_platform_init_locked() and then also drop all existing support in
KVM for SEV deferred initialization, i.e, remove the call to sev_platform_init()
from __sev_guest_init().

Thanks,
Ashish

