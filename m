Return-Path: <kvm+bounces-33979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2189F509E
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 17:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E144D1891AD0
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617AB1FD78F;
	Tue, 17 Dec 2024 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SdrIEnrZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B409A1FCCE1;
	Tue, 17 Dec 2024 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734451411; cv=fail; b=DGLSrL170BryXS827LM9BOXbSGcOf2OcsHYKHTpiF8NrZcPeJDwj7r5GdCFYVaFGUcfCW8AYmMctUA554Jr8ok3rmL7wp01CB0YbxXa0nKIDp+amkWVEnzsG6gZnHNG5xM0Ttr6gHP0gUtQvARTan1ywQycJxSQE6wnEVppnsuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734451411; c=relaxed/simple;
	bh=q2sqQ/k2NwyZCY9lysd1AT2lFv0H+wo0BeeQYbMyZ9o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b9jAvhxLZKpLBafGWI3dcCfQl/ykTSV8/RBvdLHGlSPJLmIvW4h/q4+xhS7OfXZRaFA/doYJ2j0X44xjlZPJ1t4t6kHodHo7UnMZVr6e1W9ViqotCUdnIWew9ARlTeBColuTNvTHoht/TmengA71kUDOL7J8hIgbQwodM9RHBg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SdrIEnrZ; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RacwwFPF81Iq7GnLvWalfOV5luD1kIJSjfVxeolvf+bb1gQ7OP3X9TDOhUoVISqD0dwhR4pcwW+yOVAnJysFQ0RQAG27x/IbrOgOL8subTH3TVc/Brs8grh1wX1IhvBGRd/ZdEuSKQ+mBQAytU5q7HW1VGZrD9pnlBhk6Nw6v2L5xq5Kj9sKTxhY3p/iE/wm9WWjU6sEjLp2d1wr8PiQtmE4gpuUYHGntJktPdEijCtRjHvxsS5Wa1eo4HjB+6LStWHWWZ5LG1JRjtLh1uaQ4qee/oX3rdkNzhL5Idz66NozQhn24J6cj9G0gOBwYyk6MemuhV0Fj5TImIWNfOtHHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bxcVbWLogqZHOSYXvkvRlHhrflWiJZoH5UiQprz3eo=;
 b=E3RqmNFGHTNbo+BYWCw3Cr9VBHTAhlwGLkqWkwoe5HLgYtNOpLcHJtK6WIbypCUZoRqmMT0ims+ipljjl4it20QoDW5DkTIwCsHe34QAjp5Ck4WqU4nmvekZsahqzJpKdNi+gg9D2ZG4Nr1nO66ARX8nsHdQUjohjsHIwbV5JCr7mkXCKiF+AQhF44u0Q5ks75VYHw/lPcRiSVYTtJBM+nkYAP3oceX/s+6O2IJ65jSs8N+AazT1wdSjgTq3y4QQffqkM56/5I8BpdSZaTLDiyW4RBoyDpEcPuexlggI1hkTej96YnrLiFzP3LF1ndzs3UH67KXTAQmSVe0ZqqHE7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bxcVbWLogqZHOSYXvkvRlHhrflWiJZoH5UiQprz3eo=;
 b=SdrIEnrZtgxC5Lb1n30WEh/NZy6mB9E+qLmtuwkBj64nlyrHSeiWTf9pWSwzwAx00Ok2Dzro0LLpFT9aLqyaAFgxA1xfPFWCq9JiFevk1tae126oOBZbyYaq1noUlLR8OMuIBwHCE00VaUFE1P0oBgm0tP6H9yxZLJEeinQPnoM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by SA3PR12MB7858.namprd12.prod.outlook.com (2603:10b6:806:306::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 16:03:26 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2%6]) with mapi id 15.20.8272.005; Tue, 17 Dec 2024
 16:03:26 +0000
Message-ID: <bbda7d0d-48c0-4c05-a107-85a30b5c2987@amd.com>
Date: Tue, 17 Dec 2024 10:03:24 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SVM: Convert plain error code numbers to defines
To: Sean Christopherson <seanjc@google.com>, Melody Wang <huibo.wang@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
 Dhaval Giani <dhaval.giani@amd.com>,
 "Paluri, PavanKumar (Pavan Kumar)" <pavankumar.paluri@amd.com>
References: <20241206221257.7167-1-huibo.wang@amd.com>
 <20241206221257.7167-2-huibo.wang@amd.com> <Z2DIrxpwg1dUdm3y@google.com>
Content-Language: en-US
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <Z2DIrxpwg1dUdm3y@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:806:d3::13) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|SA3PR12MB7858:EE_
X-MS-Office365-Filtering-Correlation-Id: f8608b78-79aa-4d03-2e26-08dd1eb45744
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2VQTEUxVE54a2x3RFhZZzBoalJabmdpTm5qTzlYeWQyY0dtL1lXYmgyWUdr?=
 =?utf-8?B?Mzhic29kTUoyY1hIdlNKMFdNcTZMWTlTaUlybU1mQjZsVGdwcUhlY2E4WDlS?=
 =?utf-8?B?cWpFNHFBR1kvNUtnZTZqYzhoaFo1Z0JmRVVRcDIxZ25kM0dkUnNrNUdOdnhO?=
 =?utf-8?B?dG1TT1Uyajg1TmllVjZMZXVySzRsTHBXUUdNMlJZaURxcTIxWTlkcEdlR1h5?=
 =?utf-8?B?TlJuQzY5TVFpTkw1b0NiSmt5b1lmUU9IQy9neGV1eDNkYXZCTndTamRlOE5w?=
 =?utf-8?B?STlZeDhaNVJrYjdHeDBQaTdVUmZxMnR6cERhTVRSQmxKN2xtOTNjeVpWdzE1?=
 =?utf-8?B?dFZOLzNBSVRoK1JzZlJlcDZsOEFmczhSWU0wZm80SnFONmd4TkUwZy8reU5t?=
 =?utf-8?B?L0NGMk92UUloYzZaZi9PQXhzK3c5WXdqZ2J5SGllc3B2Sm9CN0hEOE0rbXlZ?=
 =?utf-8?B?MHZwRWM5ZWdHQmtxY003RVluTGlOYWtZZHVMd1Fvb09sSjVKUFZwbExjNzFr?=
 =?utf-8?B?RjIvV1ltbjZWOW5MTEd4ZTFudXE0NE16ZWtiQkxUUWpqSU8vWTNFZ1dlNFpi?=
 =?utf-8?B?S0hGTjhvU2JDYmI3YnYzeXhEWGx2eTY5S2h1d1kvUkV5VDdld0M5MVRidHJv?=
 =?utf-8?B?N1EvSGZuV3ZtY3FEcVRXQWRzbE40d1Fvc0pGZjFzNys2ZkdUcUVKYncyc1VQ?=
 =?utf-8?B?bnN0SGNkWGNSbEZqcTFTV0hBZVpqcjZIWXJTaXpEcjh1UXhOazlvV1hhaE9M?=
 =?utf-8?B?YzM4dzUyWVI2L0plWEFjTFk0cWljSTh2bGphek9pUVYwTXBYd2Jld0V6STU5?=
 =?utf-8?B?SG9KOC9LbUlQNGo0TmFocXlxb3Zqd0xsbk1ETzk5VVlOV0hDbHRCZFBUZURz?=
 =?utf-8?B?b2p3N0RuaFlpYXZBRWJjbUxLR2QvZE1LRXZXQmNZQjNPWDd0cmd3VHRNRnlO?=
 =?utf-8?B?Q0F6cFlWbHdWUVJBR1pRSk5IKzBRVkg5ZXpjaEdkbEsxaGpTeTdTbXROU2dC?=
 =?utf-8?B?TWptM1hQVTZaTlYzcldxYk9kS1hJOWtqY3RIZ0VjallYdWVzM3ZLSnY2Qmc5?=
 =?utf-8?B?Tk9SM2dzbzJMWGV1alY1MlQ0TnBWMGlEQmJxM3ZYdDU1dENlOEhNVGE3WU5P?=
 =?utf-8?B?cnhCZWxlRkk1Qy9pSnZ2dVg3cmxHSndBeVovTVh6VGMrM3RhZktjL2hlL2d5?=
 =?utf-8?B?OGJ1Q3grVVI1LytsNlBZWFI2YXRqR1RUMU01SUpnaGV3TTFMRGE0RmtxZDRC?=
 =?utf-8?B?OWpHTFdFaHNWMFRySFg3NGFyU3FkZGZpeUM5NG54dWF4VkxHNkY1cmxnZWNP?=
 =?utf-8?B?c2pHanpabTdYenQyU1R5azRoRGlMSWpQMnU1akpqM3JoM0EySm1YMitUUVRp?=
 =?utf-8?B?WDV5VVZ0QnprTm1VVUJpVTl1S3pZSUJralJ2REc4VTVPUFNNS2RMeWtRb2Qr?=
 =?utf-8?B?bkFvU05ndUprZHFDclB5dlgycFo4aFBnMUpPQTM3eE0wSFV0YUo0Q00yUGVv?=
 =?utf-8?B?d29wdmFDZUljMW8xeEE1aUUwTE1uVVBmUFZFUmQwRCtMUXJhTkQ4L0JiZDlv?=
 =?utf-8?B?RnE3UktzQmUvekx2bUlDMGExblpERllQTDEwWENNZ0l1UUF2SWphbHpnSFpr?=
 =?utf-8?B?RmNDMERTbTd3MnZSTHByVzVBWHVSSnEyVEtTVVpLYnB3blFEZDRvM1BIYndM?=
 =?utf-8?B?cUl6NFk0enNVRjZ3ZnR6aTY0RGZNQVV6ZFhWcHVPNnFySGpSb1ZrWDQ0d0ND?=
 =?utf-8?B?M3FWYWZzdXZDM2xYYTZvOUg2REFqYmE0OFNoTmQzb21YVFhxM1lWK3hyMTZN?=
 =?utf-8?B?RDJtYWxiWW1TZE1iajlKWGVqT3FLOFM5aEg4ejBVWEtEZTdGOVk4ZzdTNzdt?=
 =?utf-8?Q?XRhM9SBVzUIwO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUg4RGJadUVrMHJVeHU3OUN0MDVBUjdxZVZzWWRZbHJhU3h1M0R4SmhLako2?=
 =?utf-8?B?MXZkRjFpaS9zTlVudXJFNU05OWxJa0o1UXdzQU9jTlJxRVJsejd6YzJKUXdH?=
 =?utf-8?B?bmhxSnppTVQ5VW5wNmptUWZpRFhVKzdsTktlbFFMcHhhMG9lTy85WHBMdXVs?=
 =?utf-8?B?VWdqUkVBY082RDlRSk04VW5nQkwzd3V1WC9VQi9TTFRZVzFnKzlmbzkremIw?=
 =?utf-8?B?R3dlcXVTaXRFdGhIbEI5YU1hRTk1VFpaS0Q4VFl2bCtaQ05rUTZLZ1FacDMw?=
 =?utf-8?B?eWhJMG85OVFNTHRkRHBxODhsU0VVaElxTHgxMittUGR4NERaL2dQQkpxYllE?=
 =?utf-8?B?Vml4c1NRcnBJWkZnNWtZSUlKeWhCSS9HOENkR1daTnJ0WXRwZzBwTnNaUHc1?=
 =?utf-8?B?R2RheDY5NVRWYWp2NTVTSDF3Zk52MHlqOUluM3Z2TjdKdTBMQTRGV1FBRzJQ?=
 =?utf-8?B?bGsrZTR1MnhCRGJ3aUI3NFNOQ3Z5RWZQemtkQ3FZUWZtcTRPM0ZqVWxqdkJp?=
 =?utf-8?B?a2FTSUdQVlhWUFRDbnN1M1hjUDUwdXJMR1FBYjBLMVEyMTFTY1VYRXFXcXpT?=
 =?utf-8?B?NGpXdmpORVV2dk5BcER2dnpQRzBrYTZlak40WG5mQ1VSOWQvUmF5QUorb1Rr?=
 =?utf-8?B?U2xHemgyMmNoaHdZNnA0YXJ6Nkw1MXhTUDdqS2tYRlduZkt2Z3orRmdjU283?=
 =?utf-8?B?c2pualdHd1NkdVJpTjNWVG0yVE5tYWw4M0Y5ellLdUsxREdTYmpjTXdiQWZ2?=
 =?utf-8?B?SmVVdG9VVlRSVDRHV3JQRXRLaklvdjAwYW1GT3FRS21IbHBpNlMrWGVyRkJT?=
 =?utf-8?B?by9rbnpKUVo4M2RMM2RKSkdid2pndGNZb0srTDJKTlZGbHlnS3lDTTJOUUQ1?=
 =?utf-8?B?Y1pKc0F0M3U3YndtK3VTclluK2JZdGp5UFNpa0dsemdHYUdweEd3K1JHQVJO?=
 =?utf-8?B?a0N0Rk0yY3JXckFES1lRcnk1T2UwUWd2amlFUkRMSXZZa1dNdTQvMUJyRmph?=
 =?utf-8?B?M3lmZys5aVZ6QjJPamxyOC84RTBqTUZoU0YxVUM4d2I0eGhONk1nTHVFM05Q?=
 =?utf-8?B?eFR0cG9QM3BaOHJOWGxDQVkxYVkrOWQ2dW16Vm9OV1FIYkRpQW9CWVJOc3NQ?=
 =?utf-8?B?cVE5ZnVaMGRkeWJid3VucU5mdFVaSnM5eml4MUlDZUhpTWJxWmhPYzJtcmpT?=
 =?utf-8?B?WVFiVGtxd1ZvM240Ly96dDF1QWg3M3VNZkw4QlJnTGNnTWswaUdnOWdaeEpH?=
 =?utf-8?B?enVvZVQzUjcxeE1ia244QTg5MWlOc3JOck9FK3pLOHlWVlNFYzUzQWRhL2dF?=
 =?utf-8?B?L3hjSm5yOElMYXRQeG40bnFIa3RhREd4Y2JJdFhHbjJXV3hxNGs5NmFEMVlY?=
 =?utf-8?B?QnhFWEo1VVg4M29JNTZSM05XRC9ZQ0lHLy9iOFQ3c0kvUlFCM0FuVjh4bnIv?=
 =?utf-8?B?TFZFRWxYYVViZWVoa21UVjV0NjNSVXlpcWFzRjE4Uk1ZbmlxM05yWi9uaVhZ?=
 =?utf-8?B?cWhkR3VSRUNpYklkSTdrcnBadlhqVkVhNk5XVTJ1UUVXcGw5U2tTb1BqVnQ3?=
 =?utf-8?B?cmhmV3kxd09kT2ZIN2xuc1MzL25rOFRacHNoU1orc2JUc0lOVmNDL2cxR24y?=
 =?utf-8?B?WUxqVk9rYXlaa2pJVlZwMTNYQ3BrQlhhS29SY0JTL1BIbzV3TnBsT1QvcE1O?=
 =?utf-8?B?SDQxdlVuZWowcWh6TEtYQXV5djZSY3dPUlV6alRpODVQbmp0MkpZanViWXJR?=
 =?utf-8?B?VTFYL3RrVU5wWWhQWWdtcU1oRk12ZmRVUjdwbndIdDMzVTRiSnNVRDM2bm50?=
 =?utf-8?B?WHFkNHJ3d3NjTmNlNWtiOXZVRmhZK2ZSalQrR3N3MzVheHE0VndxT1hnaWNK?=
 =?utf-8?B?RXJiRXFFLzZEZlJMUTJySlN0V0RHWFMrYkFKR3VzWDhWcm9PcUFTZVJUVzRC?=
 =?utf-8?B?Wm1WTXRvZ0FLeVFXaVprVjd2OTZIQlFXUVJBQ2tSajJMck9mOUIwU0JGNUNF?=
 =?utf-8?B?MVJVRnhXSksyREtROUFQSjgyNi9USnk2ZTBqM05JblZ6bkcwK0h0VUp0ZTlT?=
 =?utf-8?B?SWJZU1FIZmEwZFdRMjlhOTdxZE9ualFZSHduRlRyK2J3eVpQN0NsMEpXYTlx?=
 =?utf-8?Q?Npk/rxPXZxLfTHspt8sGuyEmx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8608b78-79aa-4d03-2e26-08dd1eb45744
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 16:03:26.5258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9l+BapXAT3C2890cbllYJnYJTkDNd72KN9idi1Z0eWZUPiM/MfC2lz7fJIDr4apt6p8Pe2r2n9bW5DsdlODzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7858

Hi Sean,

On 12/16/2024 6:41 PM, Sean Christopherson wrote:
> On Fri, Dec 06, 2024, Melody Wang wrote:
>> Convert VMGEXIT SW_EXITINFO1 codes from plain numbers to proper defines.
>>
>> No functionality changed.
>>
>> Signed-off-by: Melody Wang <huibo.wang@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Reviewed-by: Pavan Kumar Paluri <papaluri@amd.com>
>> ---
>>  arch/x86/include/asm/sev-common.h |  8 ++++++++
>>  arch/x86/kvm/svm/sev.c            | 12 ++++++------
>>  arch/x86/kvm/svm/svm.c            |  2 +-
>>  3 files changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index 98726c2b04f8..01d4744e880a 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -209,6 +209,14 @@ struct snp_psc_desc {
>>  
>>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>>  
>> +/*
>> + * Error codes of the GHCB SW_EXITINFO1 related to GHCB input that can be
>> + * communicated back to the guest
>> + */
>> +#define GHCB_HV_RESP_SUCCESS		0
> 
> Somewhat of a nit, but I don't think "SUCCESS" is appropriate due to the bizarre
> return codes for Page State Change (PSC) requests.  For unknown reasons (really,
> why!?!?), PSC requests apparently always get back '0', but then put a bunch of
> errors into SW_EXITINFO2, including cases that are clearly not "success".
> 
> FWIW, "no action" isn't much better, because it too directly conflicts with
> the documentation for PSC:
> 
>   The page state change request was interrupted, retry the request.
>                                                  ^^^^^^^^^^^^^^^^^
> I'm all for having svm_vmgexit_success(), but I think the macro needs to be
> NO_ACTION (even though it too is flawed), because I strongly suspect that patch 2
> deliberately avoided SUCCESS in snp_handle_guest_req() and snp_complete_psc()
> specifically because you knew SUCCESS would be misleading.
> 
>> +#define GHCB_HV_RESP_ISSUE_EXCEPTION	1
>> +#define GHCB_HV_RESP_MALFORMED_INPUT	2
> 
> Where is '2' actually documented?  I looked all over the GHCB and the only ones
> I can find are '0' and '1'.
> 
>   0x0000
>     o No action requested by the hypervisor.
>   0x0001
>     o The hypervisor has requested an exception be issued
> 

GHCB spec (Pub# 56421, Rev:2.03), section 4.1 Invoking VMGEXIT documents
0x0002 as well.

0x0002
 o The hypervisor encountered malformed input for the VMGEXIT.

Thanks,
Pavan

> And again, somewhat of a nit, but PSC ruins all the fun once more, because it
> quite clearly has multiple "malformed input" responses.  So if PSC can get rejected
> with "bad input", why on earth would it not use GHCB_HV_RESP_MALFORMED_INPUT?
> 
>   o SW_EXITINFO2[31:0] == 0x00000001
>     The page_state_change_header structure is not valid
> 
>   o SW_EXITINFO2[31:0] == 0x00000002
>     The page_state_change_entry structure, identified by
>     page_state_change_header.cur_entry, is not valid.


