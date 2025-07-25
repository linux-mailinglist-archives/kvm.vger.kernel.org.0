Return-Path: <kvm+bounces-53469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68EB6B123BF
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 20:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62B975611A1
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 18:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ED3424BCF5;
	Fri, 25 Jul 2025 18:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ha+2krO8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954F6242D8B;
	Fri, 25 Jul 2025 18:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753468102; cv=fail; b=f9su3SOlT5Mnf6z3oPhHS7Q0amJNsUBmEKNnz6/XzAnGv3T1uqqOkrknI/C12g75lh/xNd+zpOBwGu1FKn+98ten5ndA6m/xBT1o/5Rv5LpQAvUYVpEk5lllRDBJ3XOQp/S2+yKAPDTnvoC8W07UV26kMXcfQpQGE221j4eR+Ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753468102; c=relaxed/simple;
	bh=88rDJmF942GD7o7bBIAFGtlB9WPBLajEMnCuq8C11SE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AXTTRtWsbG0TBqqYpUSzPMPEwYPFxm9K1Z5QFRh/b9qT1OqpHI6qtMp6oC4rvTE3PiKkli90gSCxlDwApeFrelzdwXa3FnPYCErDgGss99PLqDmectWVSVw5e06zjPUX5z65HioJVCID4tpma6eOF2IL/c0wSV9wz79WnVC4OJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ha+2krO8; arc=fail smtp.client-ip=40.107.92.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GjEfoxfD3H2wmfbchl6pV4+BXmW4KrWMXNk6N87eAvxyD0lXnSBfhuTx9oGvvgMnAwcpCnv2It+iub9nw/I7ZiRRd7KLzv/BeiUZZPSGUSGsBAOXlolabuoTn1OnGuodstnM2QrNl/WhlOeTkYbNf6+5+DU77ULEwsm1afktrS0Afh/Gr8YVCRTRrYDaVu3/lwNsG6h8r7xWK2uKUVuCc/StMbGFV5Z73m0GVDYd+Qr1rHMUn/smph9VFMz9QgpGeE1IBMO6yHLx++gwm5JHnzRgWu7mmhYLHH+7IpwrSei0i474c1CJigU4FEmmgkuMnDviu1CC9Dz5+6VKme4wHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bcpMXTRCVp67c8H7NB0qek+UF1aw543OoioSwN8wik=;
 b=T2EhUAkrYt0mZTQaS8jsyOd9zcsWmVtmSJQvknYbc4qvQ0YzxYoN1+jXluYPC83Pkj2zyFX+dZaFmf3+Pd/6J1Quy8BcKHGLZr9QmrWuLG2aX8laPiHT0D7TFWflGBGGwUAb0ukUI7Hj38ZLT8j7OG/bJgB1ITAxrXk/E664U3FF1kGJLGv2CN8i5SyTqPo8j70tdq31ZkkMuhgESo+NQf8UZifL1ZgGHhiEYXCBSgAs+jKnI7CM7TRBsJtVyyWea46Q8p6QF82vlo7TdCzfJoZli/u4RyIzg18lrAp6gE8sWpfKcaEYlKBNWSEaVkQRveewepxiiTMJmab4A+0rlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bcpMXTRCVp67c8H7NB0qek+UF1aw543OoioSwN8wik=;
 b=ha+2krO8waP83ewK44XM+8oZLHFEU/X4CA31TtvuR0/j1UKq01d2Hn7JMTVViPdiFHr4rsF6lK3q1BZF83dmMAc/BY7jt5RM5v6R8Qw8bxLTsTRcb5zaLEp/deFy5YX5WJttiYveOWr/CdDQxLs9PiRkzPLaAi0Yxw9AucDtPi8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB8777.namprd12.prod.outlook.com (2603:10b6:510:26b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 18:28:16 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 18:28:16 +0000
Message-ID: <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
Date: Fri, 25 Jul 2025 13:28:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Kim Phillips <kim.phillips@amd.com>, Ashish Kalra <Ashish.Kalra@amd.com>,
 corbet@lwn.net, seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, akpm@linux-foundation.org, rostedt@goodmis.org,
 paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
 <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH0P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB8777:EE_
X-MS-Office365-Filtering-Correlation-Id: 18c5b220-a3a7-47b0-7eb3-08ddcba905bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXRjc01mYVF1N2lpT1VXT2JnZXh5bTRNRmNRbHlqZERiUGZSMDRXditORHJE?=
 =?utf-8?B?OUFhdFZ6YkFxaitJZEhBYnBGQ096VkI4a2ppbzRMTTF4aXR1dWFCNVZUY3pO?=
 =?utf-8?B?M3RpN2dyYzZzY2lqeC9BN3dtRjJGRkRkWGFXQnBqOGQxeUQ5M1B1ZGhSWUFN?=
 =?utf-8?B?Q1p5dzd2bXBETzJ0Y3RVZHQ1eThvd3hsSFpJRUMxWVZxMjk0TGFmaUNiTkZY?=
 =?utf-8?B?dSs1azhyQ1FkaUwxYXFqVlJhSzkvM2cyQ3ljOGp2SnNLb0V6cjRPS3R5N1ox?=
 =?utf-8?B?cjdyeWU2NUVFU0pYa2ZETllxYTZjWGVFNFdxajN3RWtkSFNhSFhSa1Y0dnp3?=
 =?utf-8?B?enlxS0N1VVlxZlhTUjJ1UEhwNlkwbHpqamdLd2NKSEdRa3VjSzhyOFRuUHBi?=
 =?utf-8?B?d1JUSHJpZk00dENsVTRuY3VzWlVtc29YVXE1RGNIb01yQUVWekpIZWJpRS9a?=
 =?utf-8?B?R0Ryc3Jmb1U2dmhFUkR5cnhEeW9tdXZuU2ZNV3orY0VUZDZhSDdnelV3TE14?=
 =?utf-8?B?S1JxemdHSVc5eEZCL0dOWHc5bTlHSkdVY1RWUFFkK2RvaG5CZEtNa2xDQUZ5?=
 =?utf-8?B?MUhpdGtOVGlGcDdwZ3NtdE1pTlRIMHlVZDFDaVkweEsyQkdzd0Z1di9WcXpZ?=
 =?utf-8?B?dEdoYVFVZ2tsU3MyMS80Nmh3Z2VEcHZnM1VYM1Z4anU0V21UdGhBN2RUWVZR?=
 =?utf-8?B?OXc4QTNhRlVqaDVGRVRzOFhQREZUQ3RYaDczR1djcmxDMWZMMFl6TW9QTnFP?=
 =?utf-8?B?cDA5TjMzazFHeUwxMzI5YnlwTmx3VldHTCtBaDZHam9QdkU3MS9tOS9TaTZU?=
 =?utf-8?B?QkJzWi80NkpsY1JYTHpuNGR3Y3dya2J5Q1RoRmlzTjh2Qll0RURubVhrQjQr?=
 =?utf-8?B?MkQycG5DVDN1WklPUlEyWWpHbTFNRmhGVVBybE1xYnhQQVYwUm90cnRDTUdv?=
 =?utf-8?B?NldnMTZ6TlY1T1JQUTdNUTBqUUc4SmIzSzdUbFhzM25BaGNBY0ErbHVPOXAy?=
 =?utf-8?B?MmREVFNJUzJXTDhpMTFBSzRHQmMxRVRhdnVrQWlRWlJud2orc054dUdyd285?=
 =?utf-8?B?REd6NklyMnZKc0FXbk5CcVNWTFBSODVtdHVKS1U1a2NZMmkvNlh5YU5GSjkr?=
 =?utf-8?B?d3hPUWdaVHRHSi8xL01MWGlYTGV6SWZzV0JBRGxTNCtERitMTkszNkI5WWp1?=
 =?utf-8?B?NjNsNlJiMjJ3Qnd6dXhwSE11UWhrZFg0NmZXSmV1WVM0Q1EybWNRYlhDTEZT?=
 =?utf-8?B?U3dzcW5DSHk5N2pNSUdoZk5xdGwxRHhyaEllTWVUd0RZMktIUHZOYjJ6Q1Q0?=
 =?utf-8?B?c1FmM1oxaHh5by9WNnRrc2p6K0V2eUhZUnZ4VGFubVAranJ4T1JOK084UUFa?=
 =?utf-8?B?Z1hpMGp3elFxZ1Vvd0J0ZHlSa2JPdHJ3TU96d01QNUZKRERYSVZRME96WlBp?=
 =?utf-8?B?cWVnWVZ3VmZSZDY1M3Y2cTdaekJYdjQ2dVRtS0l6cHZsd0VPSitKQWNXYUEz?=
 =?utf-8?B?T1ljOTR0MWhIMVlDd25Ma3RETk5JTnlWY0Y3bzcyYUw3MWQxQUlFZVRrTDVE?=
 =?utf-8?B?T3I1MEFvQmE4NzU0UngxT1ExL016STZuTTc4QmxDdkFkNTRSQ0FiYUk3Qi80?=
 =?utf-8?B?czRoclBsblBOWE0vdTlDU1pqTVJIR0dRRDZYcGlsMDRkdHl4dlpldmFWd1B2?=
 =?utf-8?B?eWNicyt3NmJZYjRvU01ydXEvNzRPaHUzRytMQ0xITXFmMjVaa0JxV1Q4SVVX?=
 =?utf-8?B?RUNyNmJKajZRYmt2SE5vU0g0LzE0RWdHamJGS2R5N1NjU01ydXBlMHJIUkE2?=
 =?utf-8?B?R0tjMXpHTkIyckVjTXkwZTJGdElVa2kvbFhsOUU3Z09SR2NLRGwzWlpiUXdB?=
 =?utf-8?B?K0xyYmRmSWNhdUNqb0ljNzByc20yQ1A0UENVeFlxdUc1Z3dnd1dIajFZeEdl?=
 =?utf-8?B?bURnWkdvblAzakRiN1gxTUVIT3piekNsdzdsWDVXU25sTGhmcHM4cDM1TEFJ?=
 =?utf-8?B?UnQ3UkplK1VRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a09odVN3dUdLV1FYMXpRZWt0OER1bzZXTjlSSHM4NlF6QVAzUWZIUCtrTmoz?=
 =?utf-8?B?L2hnMy84bG0rQVg1RUdUYk1lWUd6Z1FDUUFQK1lLTllFT2daR0IwUitrWm8x?=
 =?utf-8?B?dmJoV05GL1B3SmVnTjhwT2NKMUYyQXU4SjgrK1dlaXg2WFYvTGpBNG5Hc3Vr?=
 =?utf-8?B?enFqRVB0QmZPY1J2d3V6QWxweWZzeS9ESUs4UjhPRCtFSDJBNDgwcytIWjhC?=
 =?utf-8?B?WlBTd2VyTFdFWXlmbGVjbzlMOTFoeGVXZWtuWWI2MkJJcW1BTmlpS1F0TFR5?=
 =?utf-8?B?Z3NNWmVaZFBDeGRGbFk3b2dYdmpuSEpwQlZqZ2dPOUhwR0FvWG9DTGpjanJH?=
 =?utf-8?B?bUh1emRQSEJKSUx4S2tLemJaS2swYXNGTjhTdnFaR1E5ak5oSFpqZ0d2K3Fp?=
 =?utf-8?B?a1NlQi8rcE85d2Rnd3crVHY1TVFsR1Bmdng4T1g5ZGRhUXJQS0pIcWE0Y1RJ?=
 =?utf-8?B?eVk4NDNVck8yc0V5ZmN0N1p3K0NPbHdnLzJ2SkpBTG1nRnVDME94QlV4djRR?=
 =?utf-8?B?b1pmSnVTVDlma0tobW94TzRabWVGaERrMGtZM1ZxUDBSTTVVRXZBdUR2ZG9V?=
 =?utf-8?B?U1M4QWNwaWpiM2t0dkZXaXNqNnhyaHhiTmlIblpMODBoUTFxQWdhejFWdm9s?=
 =?utf-8?B?MGUwY2xpK25XWmk1aWdtN3NXWWRuT2NPdmdOMUhsRjViVmgrMjlzVC91c2dW?=
 =?utf-8?B?c1RXejBRaHNTVDVyVWd3dGxLRXU5WHp1ZHlNaSs5OGVRTGxCbGVKNVRITHZZ?=
 =?utf-8?B?cVBiQVlEbFpCaFlmazUvV3BGRmZlYW00M3RkcDM2YkswQkRiZnRTdERiYnpn?=
 =?utf-8?B?YnZVNWxvNzIyTHVVdWJmWVJOVkcwTnVNM1VJbGNBWm8wd2psOW9iREhUdHNV?=
 =?utf-8?B?VThwckFZZ2xlbHA3TkxMWkd3OVB1Mm00Y0Y0eE1tbHowV3JsRWVWVlBYa3Ro?=
 =?utf-8?B?VExZbHQrMExIR3dTS1RJalhyaFlhZ3Q4eU1LaDNzQ0FXemJVWXRYdkRrTnFn?=
 =?utf-8?B?WThEWkpBLzZ1K09rblRwSjE3c21DVHFnNXc0OUVoZ1hXT2l6TjVGWTJDNGVn?=
 =?utf-8?B?bHdMa1g2b2N0MlUrTGVWZTZwZVM3QXYwb2FLM3EzTi9NZUtybmJWTG04VWNM?=
 =?utf-8?B?aldKcGt0eDJYM1pNTjhuZTJVRk10YUw2NEwwZGRPWFczRzlXOEVVNGFOdEZI?=
 =?utf-8?B?OXQweTFJT3pVaHo3YmZoQnFTVStKVGlQcDZ4cU5Jd0RmbjR1TGRqa3k4Mkwv?=
 =?utf-8?B?VmRQaGV1WVhpZ1loeFhpb21IL0VxYlllVWxkeW5OSXV5dk44MDRqMCtuRXJm?=
 =?utf-8?B?bFdCdXlaU2E1bE9EWnEwcElXTDRLajA2cEhXRTNPempSRnE4Qnk5SFdFTFJr?=
 =?utf-8?B?UXd3RS9KSDBxdXE4c0gvdEpuQTc1MnEzRVNzeDBFL2U1QUhRMnNKUXNJbklj?=
 =?utf-8?B?alJzMmRNbVltUGt1TFptOE83ZS9FQVhQRmZDdGU0WHJ4NjBNMEJ5Yzl4b2l6?=
 =?utf-8?B?ekg3a21BQzBCTTFYN3JKODZwNVFsMjNob1MyU1FUYmJYZ0hxZFd6UjZ0UGhu?=
 =?utf-8?B?bmEvNS9Vc0l4SjA5dWZtcERNKzF6TStZY3B6S0xyY1FWTlM4S0MwSitaVTdQ?=
 =?utf-8?B?UmRrRzFtdmRoN0RtYXFZUVpyUzV5a3J3Mkp0L3Axc1JTNHFEaUNCZU95R2lE?=
 =?utf-8?B?Y0pLYm1ocW96akE3cGg5ZVM0T05jV1RxZHhWUEtBeGY5M29FZVhINWpUcWN1?=
 =?utf-8?B?KytnODBhbWNsZFRWTllKK0pnM2E1aEJ5UUxQNHVPNmVEbTNnVTI2a3hnM3By?=
 =?utf-8?B?YTJ2ZEF5OVR5cThmVk8zV2VRTWRLSDlYMDRFbkJLVVBmUDZjU1VycEtGN0Zi?=
 =?utf-8?B?YVpxa3FDK0NUZk9mZWpYdCs3eFl3emVUNy9Va0x5anhsVmdUaC9OZ3FwTWIw?=
 =?utf-8?B?QnJtWFk5dWpSZXJPTWhocFRUTVdpN3RZL050RzlmSVBFQ2JGY2FQaFJpRjNz?=
 =?utf-8?B?eERzaWFtdDdiOUN0czFUNUxreWVrVjBab1BxQVhUR3h3R1V1N05Lcnd3V2g0?=
 =?utf-8?B?UldaT21qY2RVY1RURlUvemlwNnFvVXVwWWV1VzJPMXBHVHlUUDJVTkdkL1lC?=
 =?utf-8?Q?zUtQsI0ojyZJplciG7mEUYWbh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c5b220-a3a7-47b0-7eb3-08ddcba905bf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 18:28:16.5343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5W1hiTVQiJT86YmyOGtteBMvXK6qtd1BovmGFPy6IwtStC6HnjpA6AteZxMX5bCivmXMeV8qTjhfEP9G1XWCuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8777

On 7/25/25 12:58, Kim Phillips wrote:
> Hi Ashish,
> 
> For patches 1 through 6 in this series:
> 
> Reviewed-by: Kim Phillips <kim.phillips@amd.com>
> 
> For this 7/7 patch, consider making the simplification changes I've supplied
> in the diff at the bottom of this email: it cuts the number of lines for
> check_and_enable_sev_snp_ciphertext_hiding() in half.

Not sure that change works completely... see below.

> 
> Thanks,
> 
> Kim
> 
> On 7/21/25 9:14 AM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>

> 
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7ac0f0f25e68..bd0947360e18 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,7 +59,7 @@ static bool sev_es_debug_swap_enabled = true;
>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>  static u64 sev_supported_vmsa_features;
> 
> -static char ciphertext_hiding_asids[16];
> +static char ciphertext_hiding_asids[10];
>  module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
>              sizeof(ciphertext_hiding_asids), 0444);
>  MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for
> SEV-SNP guests and specify the number of ASIDs to use ('max' to utilize
> all available SEV-SNP ASIDs");
> @@ -2970,42 +2970,22 @@ static bool is_sev_snp_initialized(void)
> 
>  static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>  {
> -    unsigned int ciphertext_hiding_asid_nr = 0;
> -
> -    if (!ciphertext_hiding_asids[0])
> -        return false;

If the parameter was never specified
> -
> -    if (!sev_is_snp_ciphertext_hiding_supported()) {
> -        pr_warn("Module parameter ciphertext_hiding_asids specified but
> ciphertext hiding not supported\n");
> -        return false;
> -    }

Removing this block will create an issue below.

> -
> -    if (isdigit(ciphertext_hiding_asids[0])) {
> -        if (kstrtoint(ciphertext_hiding_asids, 10,
> &ciphertext_hiding_asid_nr))
> -            goto invalid_parameter;
> -
> -        /* Do sanity check on user-defined ciphertext_hiding_asids */
> -        if (ciphertext_hiding_asid_nr >= min_sev_asid) {
> -            pr_warn("Module parameter ciphertext_hiding_asids (%u)
> exceeds or equals minimum SEV ASID (%u)\n",
> -                ciphertext_hiding_asid_nr, min_sev_asid);
> -            return false;
> -        }
> -    } else if (!strcmp(ciphertext_hiding_asids, "max")) {
> -        ciphertext_hiding_asid_nr = min_sev_asid - 1;
> +    if (!strcmp(ciphertext_hiding_asids, "max")) {
> +        max_snp_asid = min_sev_asid - 1;
> +        return true;
>      }
> 
> -    if (ciphertext_hiding_asid_nr) {
> -        max_snp_asid = ciphertext_hiding_asid_nr;
> -        min_sev_es_asid = max_snp_asid + 1;
> -        pr_info("SEV-SNP ciphertext hiding enabled\n");
> -
> -        return true;
> +    /* Do sanity check on user-defined ciphertext_hiding_asids */
> +    if (kstrtoint(ciphertext_hiding_asids,
> sizeof(ciphertext_hiding_asids), &max_snp_asid) ||

The second parameter is supposed to be the base, this gets lucky because
you changed the size of the ciphertext_hiding_asids to 10.

> +        max_snp_asid >= min_sev_asid ||
> +        !sev_is_snp_ciphertext_hiding_supported()) {
> +        pr_warn("ciphertext_hiding not supported, or invalid
> ciphertext_hiding_asids \"%s\", or !(0 < %u < minimum SEV ASID %u)\n",
> +            ciphertext_hiding_asids, max_snp_asid, min_sev_asid);
> +        max_snp_asid = min_sev_asid - 1;
> +        return false;
>      }
> 
> -invalid_parameter:
> -    pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> -        ciphertext_hiding_asids);
> -    return false;
> +    return true;
>  }
> 
>  void __init sev_hardware_setup(void)
> @@ -3122,8 +3102,11 @@ void __init sev_hardware_setup(void)
>           * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
>           * the SEV-SNP ASID starting at 1.
>           */
> -        if (check_and_enable_sev_snp_ciphertext_hiding())
> +        if (check_and_enable_sev_snp_ciphertext_hiding()) {
> +            pr_info("SEV-SNP ciphertext hiding enabled\n");
>              init_args.max_snp_asid = max_snp_asid;
> +            min_sev_es_asid = max_snp_asid + 1;

If "max" was specified, but ciphertext hiding isn't enabled, you've now
changed min_sev_es_asid to an incorrect value and will be trying to enable
ciphertext hiding during initialization.

Thanks,
Tom

> +        }
>          if (sev_platform_init(&init_args))
>              sev_supported = sev_es_supported = sev_snp_supported = false;
>          else if (sev_snp_supported)
> 


