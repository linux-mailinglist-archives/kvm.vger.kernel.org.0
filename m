Return-Path: <kvm+bounces-36270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A738AA195DA
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 406B27A4792
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5AE214A65;
	Wed, 22 Jan 2025 15:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sZz3q6vX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0542144D9;
	Wed, 22 Jan 2025 15:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737561202; cv=fail; b=hnEKnO30UIA/wIx3A7fNhTboE4MzfttnJ4vXiFoerGm7vkINPf8rdL1pDk/2eOmwi++wMT883bHO0b36iNDp3UG+Gx4f9rD5hwOe/JUFE/gTT9YK1O/K2pBoiTJ+SXwhsIgUmemebNn7ITs4sVVQHLta1syiLgRkHPbqBiWK5MM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737561202; c=relaxed/simple;
	bh=wev3TkYQUCasyQAZ9fVxAeswNtmhbMmt2s13tQSm4N4=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=N0cVxlBiSehGu2zcqU7GSivjg37rqRAEiq1f7a4YJ8SfyH9qLCiXPbYCSiXzb54genatrHJEr4GhGPu9RsQ+uPbZWXC0Gq0UHHTv7+DqmhayPuyu9GRI6RYZOZRUbw4Z2UM9sfA/qfBCz+PcZg721Q7mq9Epw1DbujFGEk/Yto0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sZz3q6vX; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2ATXaWedW4CMIf/q+CdDwtntSA3DCOVAtzLgSjfsMS4hwr2OXBEWY0nE3YYxh7oSN/nmxgiemAOi8JGjo/Es5P6FCLSyFCuVwnlBUohK0Ab1WIr8u4AS0TzA88bWGFp5BNDggldgNWVKMdkOC35igiHSzGq8llV1Ob0F+ZIsnWToVjedbgnlunt4+8Te4JE6KKdkqgoJgxme48fDqZ53/eivtpZdLMRoU0K8ks/AvGER6ux5zoMNmeiby2nDHBspJHqEdFaexKPQGALslwOWNjiE5Otz/FEQ+xjRU+b9mpXCz2chyou2XzZbssWRefEefLt/HUZuUKkMlgva1DSZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aef1RjpHt6+jiq5ehdu9GDqr1ypzVfw611Chz9ED8js=;
 b=NBYtjkgA/Iw7Jb7BceMytMQKE0vWdr1hH0/OZznB+HQF+PtK4KOvEVx1GW4N0UfXCz2t60uincjqrjTXgBB6notmfKQU+TDLUZnvV1BhD6fYDF71XFC6ItSbKRBUgg/eYkwOnmmbo28oKGTT1EXqD8bR0KHgm3nPLDj1AQtDVImANxWxmUdGFTfou9y7q1/N0WdCbfScxzv0r+UrUXg4Ypi29RsFiF75QX1nPWL7ucgKBmUARWfH9E1HXg2N8cY9ChPtGQIBXuozz9K69StxTc5ID5OfHaHWkC0tu7KXWwtHTNZpP5MKi1oZbjAQe086vpcwIXD8TgbnVgniXn46dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aef1RjpHt6+jiq5ehdu9GDqr1ypzVfw611Chz9ED8js=;
 b=sZz3q6vXbG0Nn28+10zUIOHcDNCVP+gkmXNQ7de37ll1NOIs2Ctl7dVxxL2deBsXDL0VKdmM2mVtdZSeEvcHBjgeFCuwe26cMXf0PkZf6iQbFkD4xNPQvJV6/tJa9kYXICJgSyKNTbN0SipAysHNP1taeRrTorav0xNexWR6l6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW4PR12MB7165.namprd12.prod.outlook.com (2603:10b6:303:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Wed, 22 Jan
 2025 15:53:17 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 15:53:17 +0000
Message-ID: <a65c1d6b-63eb-064f-b947-aa09e5580c05@amd.com>
Date: Wed, 22 Jan 2025 09:53:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, vasant.hegde@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1737505394.git.ashish.kalra@amd.com>
 <2a2c2b55c2b137b777ef5beab8e2a814f0c268a7.1737505394.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/4] crypto: ccp: Add external API interface for PSP
 module initialization
In-Reply-To: <2a2c2b55c2b137b777ef5beab8e2a814f0c268a7.1737505394.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW4PR12MB7165:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ec0e64e-09c5-44a2-555f-08dd3afce335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmZZZEY2QlpadHJYcStXU0JaWVc1MnFOWHVmYXhLbmF2UldjZEZwcGlRMkFH?=
 =?utf-8?B?L2cvZE1wV2w2Z1o0YktWQ0VwUS9jak5uTXFNTHFmbys5REVOWUx5NUVHWjBY?=
 =?utf-8?B?dENZNmNlcVZrQ3lwZUNTcWRRR2JSU25aTnl1aXo4Qi9hdHA2WHpjVlpCVDdm?=
 =?utf-8?B?QWFEbC8xaTNVRDNFSUluaWY2RDVqMTZobFU1L2t3V0tuV3N6aXBYaGowYmc4?=
 =?utf-8?B?dDVTaVhJZFhJSU8rT3J4anhUQWk3TzlaTzhuZmZUdUhWTTliRzRoSVFKUXox?=
 =?utf-8?B?blFMV0RTVElHbUZuM1J4K1FnTDczSlc5RUE1Y1QxamlMSnVIYkYya1lHYmdo?=
 =?utf-8?B?bVNrQzUzYW5FTTV0b1pDRjNhU0ZaeUpQZitwWXhucWpES25rRlpib256NFEr?=
 =?utf-8?B?N3duZ2pKU0pGV3FmMWFHR0Myb1Z1aTk5MEcvVUNqeVcxQzBYSzJOcFFETG9H?=
 =?utf-8?B?UHVwTHM5akNHQnY3aTBZdFZIYVZTZnhkS1BuNVhBNDBpU0tISFJjRlFoSWlP?=
 =?utf-8?B?a09WSm9sazBoZlFyblAzRFhqNFhMNHMwdWFXelNtL1Z3K0Noc0dYdUJUbWpG?=
 =?utf-8?B?TVVWM3QwOSt3aGRXUHlQa0ZGSG0vQThjdlZRdWg4eDZ1RnVrcnhBMGJtSDU4?=
 =?utf-8?B?Vnp3L1FZbjV5R1B5clpJcUcrRjlKcXJuaTNKZWJnallacmRXc0ZESTJqVDlp?=
 =?utf-8?B?U3l2R0FtaW9pNXMwdWJidXpCVCt3L0ozS1UrWjcrVkN0UktMN0F0WENaL2JE?=
 =?utf-8?B?eTRaUU1KcWxXVTdMOEFTeVljZ2o2c01hdlpKeGxwNDJmekdNZmJQeE1CVDRS?=
 =?utf-8?B?MnJjT2dZd040T3FqcWhHVGVUaDlBRVpCTkxSUVRKbzY5TExsdzlhSVF0TUZh?=
 =?utf-8?B?TmdGbkxlSXIzYmpadG9xMFZlSUVXUjhqT0ZGbnhMSW84LzB1TjZ0dHFYcnB6?=
 =?utf-8?B?Vm9wcTFSK1ZoMS92Z0E3anVzdUFCWmtQV1FvMDErTXhsNWJvQTRUU1RScjZT?=
 =?utf-8?B?L2cwdWIzOEhzR0o3MXFoNDQzWkFUaWd1T1ZiSlR4eGhvSk12RUdLc1g2RTZE?=
 =?utf-8?B?ZzI5aElsT2RkbjhpZFB3NUg4UEh4YlQxdXBFa3Y4SFRMRk5WVHdreGlqWGg3?=
 =?utf-8?B?L2NqZE1FV25FWGZvTnNjTlZlazdsWGVQbHdsSXpOY0RmZ3plU2hnQStpUUFB?=
 =?utf-8?B?UitiV2s1TDZmS2tNeWJOeEtXQk0rV1JtTnJRbithczJJWlJoTXhuTExjalpt?=
 =?utf-8?B?ZGxqVDRibm02UWhFUEJ6cno5WVhJYlN6U2hnU2xVOU5lYnp0aFR6eVlrQ3Rh?=
 =?utf-8?B?bXZ3blJzejhWM2RVc1pUYW5QQmFScHJiV1dHblVjcmJhbVJLM1Y5VXJHelBt?=
 =?utf-8?B?bWpGeVpPTXJ2UFdYV3QwZGlJcTZxUTlHNHhrd2ZMRmhIU0hqOFN6WXNTSnJM?=
 =?utf-8?B?cVdCbGRYSDR0VnovQTZiekx3eW1pSWJSZWNSa1pVbkZiTy9EQVMxelpWRVpN?=
 =?utf-8?B?b2dkQzArM3JrRW9ZSW1NVEFEdlVTMEY1V1J2SjYxK3A5UTdxN0cvWnVOMkdZ?=
 =?utf-8?B?RStUaG5Ia1F1NEowRVE3NXZ2dXI5U25wNHQ1aVJ6ZDlDYm52clpNOG9XMjAz?=
 =?utf-8?B?L1Exb1JUL3R5S08xZFRGOVF2cHV0ZVdSbDI3cDhlR3QwQW0rd2MvZGIvckpo?=
 =?utf-8?B?SnNCVDNBd3VBam4xS0Z6NE54M2x4YUNISFRTcFliUmZydmlHSlFJc2l0SHZx?=
 =?utf-8?B?L09tMTB1Rk5xV25OK3FQWGJrT0xFSFpaTWdoMWxnelM3YmhLS2dLVXlrTmU4?=
 =?utf-8?B?a0hxQmxuVGVhRm5CaTR4d1BMajkwQVc4eFROQTRzZnBOdWhxRGo4Zk5FcnBB?=
 =?utf-8?B?M2tHUTBGUlFTdUJzcUdNdzdLSXNVTURLcGlDYVNDdWlOWmhSa3crQ1B6WWV5?=
 =?utf-8?Q?lSYS6i0636s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THVTT0s4anVhQ3Y1dE9uVnIzWmFWUkdDeFNlaVFnSGpSUnlmY0xHZ3VZYlJn?=
 =?utf-8?B?blRVL0FsempXbmtEcTBKVUY5cTBYdVRxWW1NbEZwaGcvRzAvVTBnQldRS2s3?=
 =?utf-8?B?N2RjNkdhMUVQWUpqSVpYS090Rm9sUWZkdU9Hc0F2aU1FYy9UM3VwaG1STEdT?=
 =?utf-8?B?VkptTUo0TGozOHJJK2ViaWRkTXpDdGppdVFwOERyRktCUDhoV1lZR3F1a2Q0?=
 =?utf-8?B?a25raTdvSlJwcDRmeEVsb3p5dW9pMFlFTXRtdzIvTmhNaHdVTzVUbXZiQ09E?=
 =?utf-8?B?Y2RvOEFydHo3WDlLRXlIRU91ODN4VjNyNWN6eEtBNWFKUVdiZ1RWbUFNTkUr?=
 =?utf-8?B?ZTVjUnN5NnhHTFMyRjF2WDNsUHFqZmVFbkxpUnJJdzd2UDAzZ2xJR2lJZG9z?=
 =?utf-8?B?WUdwTjltcmNOTk9WcUxWK0o3SnBjUzV0R3lVME44UGh6NURuMDUrc00zSXFK?=
 =?utf-8?B?djM4ZmFIMnBYNFF5Kzl3UGptTld2VkNmdlR6bWxYYUdPUGJuYTN4ZjNLUEhn?=
 =?utf-8?B?cmpoRWI1RkVKL2RqLzBTOGwvazlIbjhBMFRYS0lpYmJvdlNKajZlZm1FM2hw?=
 =?utf-8?B?dzhVVmx1R3ZGN2dsSXFxT3NpN2pucDBiYWJNMVlyZjVGWnBHUUFrYnlzN0t5?=
 =?utf-8?B?c0VvT1o2OXpYUnR4N1NpV0tMblNJQ24xYndESy8zTXltYlZSQkdVdFpRWERP?=
 =?utf-8?B?Sk9SdDlNZ0hzcXM5czJyVGNtV1pESmJoL21HSWE5L0tNWWQ4K2U3dVRkUG5N?=
 =?utf-8?B?cmlYa204eG1Sc3hneWMzVnk3eUdLeDFDa2lxVmptS1EzL0xrVE11eTltRzNV?=
 =?utf-8?B?SkZEL3A1NFJxblBpU3RsR1RPSFhJcXdVV3Q2dzh5WUxrbC9UbWk4ZUdyQ3p3?=
 =?utf-8?B?OUdNSWZBQ3FEdnVIT1NiZ2w1bG5GNmhkaFV4QWh2bnM4WkppeHZUV25rdHhE?=
 =?utf-8?B?RGQxM1F5eEZtMU5zaUdVd0FHSi9sOG9kV1BvM1N4aTB3NThubXg1ZkdxRXFC?=
 =?utf-8?B?RkpVeUZsaGpVMzRSZEYxMUlveXVYMkJjUW5ENTV6NXBJcUFYYTVqMVBNZFVO?=
 =?utf-8?B?UzFaZTlWM0VtZWxpNWdCYVNLUFNlWkRkeUpiNSt4Vy9KVjR6cVArRW55dWNo?=
 =?utf-8?B?MDJUdTBhZk9RdWJQdFg4WkxNck95NVh4Y0ZFWVVzOWZka1JRazhlUTZNMG95?=
 =?utf-8?B?TzlSalgvbzZtVThPSlZhOXRXRDlZMGl4WGFYSmZjWlM1ZTB0RDBnMVRocTBB?=
 =?utf-8?B?Y3BMZzBweS9SeEszVVZzcFk0dDhtWDRvdHdERDBHUTQ4VzdGdVlIQUMwRkQr?=
 =?utf-8?B?QWJhbkNIN3VjSndBdmtWK0VrT3JhUFFQeFRIbXhUV2dWL0l1TVRiRElPTkdK?=
 =?utf-8?B?K3lqSzZ1OWZHbEJ0MG9UdXRIUk9DUW5pZGtwVkpxOVo1RFczSkNsMVFDaG5i?=
 =?utf-8?B?cGh5eXF0N1dCeit0ZFQwdVdHOXpPUUE3YXdiRWRvZy9FL2wram5xQ0JkRita?=
 =?utf-8?B?em53ZUQxTnlBb1BwaG1DamxJdzdTTGRhTzRCTnpZeU56MG40OUVhcHpualUr?=
 =?utf-8?B?TXNRYlBqYkFHNkFxY1hzMkd3WGdGaHRpRzNWZUlyVURDZ1ZqSUdnK2s4UnNE?=
 =?utf-8?B?Qm9NZGlVeTZsZjhvMTNqMjVPZkF0SXJiODByUnltTUxwbzFkRi83TXlIWkpp?=
 =?utf-8?B?eG1TclMxTTFoV1FSUE5YbWtmT3BKQmMzNFlHM2ZBUmZJSTh3OEg2QUZjVjlC?=
 =?utf-8?B?aEk5WmNtcVRHNWtRRDgxd3JNZGlkVmZXWWFnanh1bEFzYWhuaS9GU3BRdzVI?=
 =?utf-8?B?anBFR1FiU0h0eXU2cFpwZHVEa3hSdGFOSmlEQXB3MUFuQUE0NXAxQklnU3Yz?=
 =?utf-8?B?dVduOGdZVnMxV0dRdFR1ejFxcGJzSURWbWVDUVQ3RHR0VUx3NU94VnluKytn?=
 =?utf-8?B?ZVZvTFhSTy9JZ2xJTG1KdWRCNHhaSlMwN1hmeXFsM0svdWg4L0RMVC8yTEFU?=
 =?utf-8?B?Uy9qOEtqUlozQ1AzMlU4ZnpqL1pzUFcyazltTENyb25DMlZONUNjMGcrYkda?=
 =?utf-8?B?SHpWMVlBS2VxNUNDUzFtR1JZV2x5SjNoTkFjZ0M0TnRPU0NmR3dGMzRNaCtR?=
 =?utf-8?Q?sEjLwa9eYLGDEDRo8Jm6kfdAU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec0e64e-09c5-44a2-555f-08dd3afce335
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 15:53:17.6342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eK5IeGaOlRycvtJQKIIaUzXlQ+Q3//CUadfIyr28QY3VMnVHv4PciHTMhcMB4sRTk8HBbt5XB9CQN3nKl1ZGew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7165

On 1/21/25 19:00, Ashish Kalra wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add a new external API interface for PSP module initialization which
> allows PSP SEV driver to be initialized explicitly before proceeding
> with SEV/SNP initialization with KVM if KVM is built-in as the
> dependency between modules is not supported/handled by the initcall
> infrastructure and the dependent PSP module is not implicitly loaded
> before KVM module if KVM module is built-in.

This is big run on sentence. Please start off describing the issue and
why this fixes it.

> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Your SOB should come after Sean's.

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/crypto/ccp/sp-dev.c | 12 ++++++++++++
>  drivers/crypto/ccp/sp-dev.h |  1 +
>  include/linux/psp-sev.h     | 11 +++++++++++
>  3 files changed, 24 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 7eb3e4668286..a0cdc03984cb 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -253,8 +253,12 @@ struct sp_device *sp_get_psp_master_device(void)
>  static int __init sp_mod_init(void)
>  {
>  #ifdef CONFIG_X86
> +	static bool initialized;

This definition is within CONFIG_X86, but...

>  	int ret;
>  
> +	if (initialized)
> +		return 0;
> +
>  	ret = sp_pci_init();
>  	if (ret)
>  		return ret;
> @@ -263,6 +267,7 @@ static int __init sp_mod_init(void)
>  	psp_pci_init();
>  #endif
>  
> +	initialized = true;

Add a blank line.

>  	return 0;
>  #endif
>  
> @@ -279,6 +284,13 @@ static int __init sp_mod_init(void)
>  	return -ENODEV;
>  }
>  
> +#if IS_BUILTIN(CONFIG_KVM_AMD) && IS_ENABLED(CONFIG_KVM_AMD_SEV)
> +int __init sev_module_init(void)
> +{
> +	return sp_mod_init();
> +}
> +#endif
> +
>  static void __exit sp_mod_exit(void)
>  {
>  #ifdef CONFIG_X86
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 6f9d7063257d..3f5f7491bec1 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -148,6 +148,7 @@ int sp_request_psp_irq(struct sp_device *sp, irq_handler_t handler,
>  		       const char *name, void *data);
>  void sp_free_psp_irq(struct sp_device *sp, void *data);
>  struct sp_device *sp_get_psp_master_device(void);
> +int __init sev_module_init(void);

Why is this declared both here and below? Please just have it one place.

>  
>  #ifdef CONFIG_CRYPTO_DEV_SP_CCP
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea8585..1cf197fca93d 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -814,6 +814,15 @@ struct sev_data_snp_commit {
>  
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
> +/**
> + * sev_module_init - perform PSP module initialization
> + *
> + * Returns:
> + * 0 if the PSP module is successfully initialized
> + * -%ENODEV    if the PSP module initialization fails

There are more possible return values in the sp_mod_init() path than
just ENODEV. So maybe just say that it returns a negative value on error
unless you want to chase them all down.

> + */
> +int __init sev_module_init(void);
> +
>  /**
>   * sev_platform_init - perform SEV INIT command
>   *
> @@ -948,6 +957,8 @@ void snp_free_firmware_page(void *addr);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> +static inline int __init sev_module_init(void) { return -ENODEV }

Remove the "__init".

Although I'm not sure this is even needed since it will only be called
by KVM and CONFIG_KVM_AMD_SEV depends on CONFIG_CRYPTO_DEV_SP_PSP. Plus,
the function itself is only defined under a specific config.

Thanks,
Tom

> +
>  static inline int
>  sev_platform_status(struct sev_user_data_status *status, int *error) { return -ENODEV; }
>  

