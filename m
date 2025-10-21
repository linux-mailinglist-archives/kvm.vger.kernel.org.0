Return-Path: <kvm+bounces-60607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B04ABF4AC6
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BFE418A1B27
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 06:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBD425EF81;
	Tue, 21 Oct 2025 05:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="thFjQEx7"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEE9AD24;
	Tue, 21 Oct 2025 05:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761026397; cv=fail; b=dE87gGD1KlQ83cVkF4tFaFipKSfRWydK07i+7mh8bJEu2P5GSgXllcD/TORT8AsopgPQwVu9qOQqvnWnrNkLZ7AcBC4j/kedSf8Nq5c/Q2l8ygZOiqMULEppSoHX21BTCGMxc9yvhnFdYC3F6MvLqjNXUhKA0LQ0hFOgJerQX8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761026397; c=relaxed/simple;
	bh=f/A0uKYGS50bN2SB3b1IQvmBVVzIDKy8WyabcvwJtkQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s/iSyqEpB9bTlxIL6e7XTTNeW+Nf+BWdkeKxI38hcuZOZQOUmNd+2rFqUyZ8OZt+lfSKfutwrSDiiZSG9bby3NMQxUMfzbdvmRLlipyIxi6gMdwwmHMZkhXIGkgCIeMe+Fn0CQYG5kx3nIvKdaQuwP8MaeoFudNbkes2ZMQj+Ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=thFjQEx7; arc=fail smtp.client-ip=52.101.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=njtgDv1s1sp+ZapWoYis5skjIWQ7gecSChLEGv3+0+Nz1QBqtAqLu42kNXqd39bh903QCCDCAX3DNKHZi1QjNmOWBkeMU6fUcsEr9BBTgopTSgu5U28dSumhVBdPPRuzKzXGv+N4zi5vh9zAeAU2jk9duep15Z0jBISCBlv72bEwvYtpdmxeXNnO6AHXpSVBNvVt5pYt3jleJny2RgQqX7W+wjWYJiQ6mgfDlB/4Eb4+mIUfHHFfNPWKNPp2fXHg+Aafkij6U6lUnMDUv7Wmo3WWt02vECsuD10MYT+Gto5DuAWN3ovaKKTG9pyYih3JDuY4ZEuC8SADSwh9Tvu02g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqD+azw9K+7ERU1FvMRulu29BBDkpnp4BPf9nV6bNso=;
 b=d0fs8LPIe0XzNv0qPNTAYqEepHEzPchW9dfN+LB5nwf2Vq9x6buVU5z8XhRjPUXAdnTKPaJb+m9qT7z3G65JLFUYNlk6k8ajKBp1dLvazzwkrMfz2Geng2jYUmBamwr8PjZ+fuD+eHjq38lUgDZq6F28nMcqIeqVf5bhmcCIDuW262pYzNATjGFpOpBYzHqNoTL9+Abb6H558v+QQ+xsUjr9tqLFVM+mYEE13RurxLw3m96n3x1ixleRF0AtmAhmzpvaZ8Id3KmZg4+H4WzpBHjtN+wQKjkn600oUzqBz+V0874trUaZreDm6rBQJv1fCpCnKHTsnqkvXF9x9p94Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqD+azw9K+7ERU1FvMRulu29BBDkpnp4BPf9nV6bNso=;
 b=thFjQEx7rLq1p+XpTXhv9QbGTWvB+NceJ7UHquQuceUmjWSDRZVNk6n43hc+/RRPwWOnq3yBi/U9eIo1c5yAA4v0Lm2nmGG0k+zqMasWXmUtEyMFg89Txe3Cc60GytwdO/m/ESusqiiRD74y+3dx9p9wzMCsA7IW2/WJaBa7gKc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by CH3PR12MB8074.namprd12.prod.outlook.com (2603:10b6:610:12b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 05:59:52 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 05:59:52 +0000
Message-ID: <115440a3-a035-4949-a767-19c0be4b6010@amd.com>
Date: Tue, 21 Oct 2025 11:29:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251016172853.52451-1-seanjc@google.com>
 <176097602114.439246.7705198528866990456.b4-ty@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <176097602114.439246.7705198528866990456.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0168.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::23) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|CH3PR12MB8074:EE_
X-MS-Office365-Filtering-Correlation-Id: 81ccabbe-1b56-4d1a-2a5f-08de10670d20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cENJMldXUTYrT3pocjlVc2xrNG5iZjRENFNKdWkzU0o2MVN3aStvNFdiSUpv?=
 =?utf-8?B?dVFNKzkwZTkveWdvamsyTThDWE1uTEV6cG1OYyt4VGQ4ejNoaGtFYWRuR1BB?=
 =?utf-8?B?QkxPMWNmYWdUM3BnLy9TVi9mUWF0bWgxcVJzM0JsRlNmTkgzdi9qbjYvckRP?=
 =?utf-8?B?QVFXR2tvUW9OUVVvYVdFRW9kSjI4WXZEUys5U1gzbVR2RTdSanpIMzNTYkdK?=
 =?utf-8?B?MTNqNWV6ZmxMaklMTmtmQk53U0dTbWp1blNoUkhiOFBmNXJHMmYydFBpT2dl?=
 =?utf-8?B?eWFBeGgreUFhTjZNQ0xpL2w2SVBXTTVSblFqanRnL1NWci94TjNGMDBSN3Zy?=
 =?utf-8?B?WkV3TmtPMXBNOC9sTE1Bb1o5bk5GZlp2a3FGSWUyNVhZdUtNdjFYbFZnUENO?=
 =?utf-8?B?YlZmVHVGeEVaOWFHL1grT1Jlb0xIaUdHem9pTnE1Rm1DNzZWMVhSa2wvd1RH?=
 =?utf-8?B?L1NHbFRkdHJtam9SQWh1Y29pWXdQVkJnTlJQdGVVcjV5djlGZktTZGZha1B1?=
 =?utf-8?B?dGppamtoUXRLWkpZNno2QkY3a21LYk9jK2R3SUZpaUpyMWZUZzUyWlp4ZHNo?=
 =?utf-8?B?akVBaDJ3ckxqZ3c0ci9GVTdKQUVhaGcvRkJzMlNVd2xMWFRwTEhnWDNFd3RY?=
 =?utf-8?B?RVZ5TExKRks1TXE3bFRuL2VPZFIySGw0TDdIZ1Q3UC9yRWd1djJzK3VzSU1D?=
 =?utf-8?B?WDRjWkJXT3E0ZzBBbU9HQVRrSlFTeEtvZ2NYS29Hak9pSWN2eEV0eHU0TFV5?=
 =?utf-8?B?K3praklYKy9YMGpsNXBVTEhYSkNCQit5NDc4U2tZRndnVTR3Q3JNdGhMVkhz?=
 =?utf-8?B?R25rd0pyNXoySVZwWG1hem03UEVCVVZiN0h3WklidFhzR1l3Uzd5eG14OGtE?=
 =?utf-8?B?WU1WUGh6NGk5MG54RzEvODVqUEFYR3g0NHFvNzIrZlVOMmMva0JhV1NpcmRR?=
 =?utf-8?B?VzVZa2MraTJUN2o1ekRJREFhdi9Ub09LcWhoNlpiRjZudlprd2xOYUN4SlZM?=
 =?utf-8?B?MFg4eXpzSmcxeTNrRlc5MHM0SU01bFc2SmdyWkp0c1d5T1NsZEFrQVFxRC9i?=
 =?utf-8?B?d0hRMVpRUDBiQ2t0THJoUHhDTVBkeWNMYlg1VHBxWnBRQlJYWFRkNmJ6ZVJD?=
 =?utf-8?B?UUZ4ajMzZnIzNDNDWnpOMzVOWjZ1UFVYVSsvVWtNdFFKSEpGaHB1UnFReGtr?=
 =?utf-8?B?YnF2UnZiYUhuZWtabjRhVy94K0tEczlNK1NQY2ZaNVpxMzRpUzN0U2dwRUp3?=
 =?utf-8?B?Z1NxWWZpYytDNnA5TkhVK293VWdqVHdXSUd5clQvQTZxR2FYejVDb1Q2Ry96?=
 =?utf-8?B?TmtWbU5ZTVorQTEwOHV5ajdUM25HL3NjM2E1SDZUOWJpbFNJTUU2NzlSMG9Q?=
 =?utf-8?B?N3NaMWRkLzh3TmlxR2ZPcEpRWVBTYWVzekF4R3k4RFdmWjlWN1AyZEwvazFL?=
 =?utf-8?B?K3JwUjZMNHV3QURTcnhBM2hLWXJjdVRIMFM3eE9rNGtrNEpEZVplRWMybU1C?=
 =?utf-8?B?NVJNVjBpYzh4ZHRLTDF2YklFUGU3VkRNM1ZNd0wvU3ZSQVAzSUQxdEI1NUZP?=
 =?utf-8?B?djFzck9wZUJBRExURzVHYjBUalpZZUtUekU5a1BlQlJGa0hEenRZWm05Q2NW?=
 =?utf-8?B?SUxic21CZ3pjMWdCaHpPVlpVczlxcFJKcW01VjdyTVE4NmloUU9VL1RUWTJC?=
 =?utf-8?B?dm0yU0F4UHYxNXA2dWxNZ01tZUJOSGE2UmViUHRJV0tTSmdQMERyOFFJYjR6?=
 =?utf-8?B?NTk1cmp0OUJiMEU4eVRJWWp3dHA2K004ZktXT1dZVkRuTlZzK1Z4RlNOVzNC?=
 =?utf-8?B?T1NjV1MvZnJhYjNneVBLOERsTEhaZVpJNjVvVzVQdjhOWUQ4Uklzd2d2WEUy?=
 =?utf-8?B?QXpTVGR2Uzh3UjBiUGtQZ200bmZZeE5IZ2JiMThsMHVJZ1hZaE1GNDgwZ2k4?=
 =?utf-8?B?aTYzcENNcWVFd2ZDckJ5YkM3eG1UNE5DalE5MTFQN2NBZjVxbnRmalRjWjR3?=
 =?utf-8?B?M282S0QxZ2VnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wi9YV21iZVdYeldKRitraWZVU0pCVE5la2RTdDM1b3hubFNMdHF3NENYVWRT?=
 =?utf-8?B?RmM1MXAvS0ZLZ2F5ZEt3dmpmeGdNbFN4TXRSY0pUMTVkQVpjV29yYmJHdDNo?=
 =?utf-8?B?L25WRW4yYlFvdXBtbFhvaHJBeTRLek85WEdldllES0YxR2gyQTB0U1JLcHcw?=
 =?utf-8?B?THlKSmgwdjQ3ODBacm5pRS9zLzhITUhzdzZTYzRZOXc4RldSSlZNWVdyaXFD?=
 =?utf-8?B?RzF3WTlzWTFLSXJrWW13S3l0azBHem5OUGZTeE15amlmcFpLcjNBSmtNNHpE?=
 =?utf-8?B?d2Nmai9OUFpRRTVHL05SaWl6K2tkTFZEMXdoZFNoNUllNWtGTFJHQWlRQlY2?=
 =?utf-8?B?Tk5EWkdhNFExT1c4Y1g4aERIYTdscVF4bzFtSUpQNTVkY0pOcWtWUXFBZEtt?=
 =?utf-8?B?YU14aUx4c29GVTBSN0JXQ1VURW41aDJmVU1iN29NQjg2MnpSMFl6N0IyK3cv?=
 =?utf-8?B?VVlVb2w2TVpLSVEzQllGd0JEK2dkbWRoMXE5YkVzUmlBcFZCMTA1SnNLUVla?=
 =?utf-8?B?cG4zczIwejR6enp0Yko3ODZuakhYSjUxSzhYOUxrODlLM3JtSjFoRTlyWDZz?=
 =?utf-8?B?SmQxbFFEN1EwVWNtZWFvbmlNMkQ4b0wvZ3NCM3F6Vm9NbjFabmZTQy9lYy9l?=
 =?utf-8?B?U1ZWR3l1ZGVhNXJ3VXBTaTAvMnhYS1I4OU0wdzJ2SjhQeEl3bm9NcVdSYmhw?=
 =?utf-8?B?OWRMUzVqTFg4Nm4yZ0M3dDUyV2grakpPR2E3TWR6Uk9LRGt4R0JEdU12TVBV?=
 =?utf-8?B?ZjRnLzljSFN2OStUQUFvUmFIckwyTGZVb09hWERMWWk4K2M4cWlrbnNnVEFz?=
 =?utf-8?B?L2ZEYjl0QkhUL0kyYjJ2QytmVWdOenZYQmxZTHZqNVJoanBUVkR6RmVKbFFT?=
 =?utf-8?B?T0w4TmJmdkE2VkFleDB3UFZibVlVM1NGWko5Z0JYcnVGTGdGNzAvMTEvWW0z?=
 =?utf-8?B?WGhjOTVpcXNRaVNid2FEUm9aSXFzMHlPMFpjUGpmVDIzaWFiMFVpcVZqU1lq?=
 =?utf-8?B?ZTUxZXlLTDNmOWhnYUpHNnp0T3J5NHhUT0V0N0J1Wm9ZeVIxbVc1MmtZT3VR?=
 =?utf-8?B?MXViQVViWWVTSmhtWDJJbkFmNEsyMFhmM3NxcmRGQnQwWHVqcUpja2NKR09x?=
 =?utf-8?B?VzNpODlzZVBrZlY2emphMTVhb2Rac3h4S1kyQjEvMlFXV2ZHQkc1NWZRa1R1?=
 =?utf-8?B?RFNpK3RPY2hEL3ZtbVIyMW54UmN3QXpsUnlVZGJrNlU2bHBTc1FnaDVybi90?=
 =?utf-8?B?cFVvMEs0ZzhobW4vRnFFRjBLSGE4dTlId0QzeDIwaTFqWEszd2ErMEJrbmxm?=
 =?utf-8?B?YUo2aTVhcW5MVUNYMHpNemN3Q2lPbFBiZ3VLeEorb2pnY2REbDFEdnI5dEg1?=
 =?utf-8?B?UEV3NU5SUHdSc3N2OUUvWnMyUm9POFN5dDAycm9UbjNMTGE5U3hZKzdSaU4v?=
 =?utf-8?B?UVhlNmIzVHp2cklQdXg5VjZTbWduaUI1cjNPcU5OSlZvemwxbDFzM0UremVq?=
 =?utf-8?B?UEpad2JCMW5selltSUpaSjNaMWwveEZnSHR3Y3EvZU5iaHoyNDdqV01SaG5N?=
 =?utf-8?B?WEdrQzREUE1Mbm15RlRPNTRrUndUVGVXMzZMS0RJbUJQWlVCTTJLV283S2Qy?=
 =?utf-8?B?VnJYUHNsdTdvMng1WUJxRC9NTVc1dDVhQnU3cUl0MTRndjhNbERYcnVzOUkz?=
 =?utf-8?B?NlN6c1RKbzMyUUlvZ041d1dRR21RUXAvVGhLZ0ZUYjJnQkxrVjhRbUdxTXFw?=
 =?utf-8?B?NnE3bUpvWkVCTklJTC9xR00wRWxaeXNGK2NudWN4aE1MU1hFb1RwOVBzWkRF?=
 =?utf-8?B?ZzNRYlZxRjZOMWUzcmJRNkVGNTFaZVkwK0V3bFowc1NHSDV3RkZ4UzlMMGNT?=
 =?utf-8?B?Ky9oYWM2SG16bTk4b0x0NHJ1L3dqaUU5eHpPUFFwbElSL1M4S3JUb1hwaEFx?=
 =?utf-8?B?NExvNU9Ma0dnb0FMVFdRdmhqYjR4bUFLb21KeHZxY2dSb2JpSXg3eXRNNFVn?=
 =?utf-8?B?U1UrR0svZ1EwSVErYWdzZ2NNd3p5b1VzbDgvSzFpZFhVUFhzdG1KQkQwYmhZ?=
 =?utf-8?B?WGVVRUpWL1ZqN0cybHkwQXhXQ1ZTYUY0ZG1UR1B5SlZVd3RDa0xBVnpZVWdm?=
 =?utf-8?Q?pCu3Q97SR3R0capYRHCKM9qU6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ccabbe-1b56-4d1a-2a5f-08de10670d20
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 05:59:52.3151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJU8zywRcybvEmioM7dexWcw4AWrHouFdO99B3dLL1+fMKDcyN/rHg+dBnIAn2joj8koFPNMw4fHIAVjoFYhcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8074



On 10/20/2025 10:03 PM, Sean Christopherson wrote:
> On Thu, 16 Oct 2025 10:28:41 -0700, Sean Christopherson wrote:
>> Miguel, you got pulled in due to a one-line change to add a new iterator
>> macros in .clang-format.
>>
>> Shivank's series to add support for NUMA-aware memory placement in
>> guest_memfd.  Based on kvm-x86/next.
>>
>> Note, Ackerley pointed out that we should probably have testing for the
>> cpuset_do_page_mem_spread() behavior.  I 100% agree, but I'm also a-ok
>> merging without those tests.
>>
>> [...]
> 
> Applied to kvm-x86 gmem, sans the .clang-format change.  Thanks!
> 
> [01/12] KVM: guest_memfd: Rename "struct kvm_gmem" to "struct gmem_file"
>         https://github.com/kvm-x86/linux/commit/497b1dfbcacf
> [02/12] KVM: guest_memfd: Add macro to iterate over gmem_files for a mapping/inode
>         https://github.com/kvm-x86/linux/commit/392dd9d9488a
> [03/12] KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes
>         https://github.com/kvm-x86/linux/commit/a63ca4236e67
> [04/12] KVM: guest_memfd: Add slab-allocated inode cache
>         https://github.com/kvm-x86/linux/commit/f609e89ae893
> [05/12] KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
>         https://github.com/kvm-x86/linux/commit/ed1ffa810bd6
> [06/12] KVM: selftests: Define wrappers for common syscalls to assert success
>         https://github.com/kvm-x86/linux/commit/3223560c93eb
> [07/12] KVM: selftests: Report stacktraces SIGBUS, SIGSEGV, SIGILL, and SIGFPE by default
>         https://github.com/kvm-x86/linux/commit/29dc539d74ab
> [08/12] KVM: selftests: Add additional equivalents to libnuma APIs in KVM's numaif.h
>         https://github.com/kvm-x86/linux/commit/2189d78269c5
> [09/12] KVM: selftests: Use proper uAPI headers to pick up mempolicy.h definitions
>         https://github.com/kvm-x86/linux/commit/fe7baebb99de
> [10/12] KVM: selftests: Add helpers to probe for NUMA support, and multi-node systems
>         https://github.com/kvm-x86/linux/commit/e698e89b3ed1
> [11/12] KVM: selftests: Add guest_memfd tests for mmap and NUMA policy support
>         https://github.com/kvm-x86/linux/commit/38ccc50ac037
> [12/12] KVM: guest_memfd: Add gmem_inode.flags field instead of using i_private
>         https://github.com/kvm-x86/linux/commit/e66438bb81c4
> 
> --
> https://github.com/kvm-x86/linux/tree/next

Hi Sean,

Thank you for handling all the changes in v12-v13. I appreciate you taking this on,
especially the refactoring, improving selftests and code clarity.

Thanks to everyone who provided support, reviews, and suggestions throughout the series.

Best regards,
Shivank

