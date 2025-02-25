Return-Path: <kvm+bounces-39119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07400A4437C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 15:50:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA7088632C7
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9297E21ABAF;
	Tue, 25 Feb 2025 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TdQ9qDM7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAB721ABA0;
	Tue, 25 Feb 2025 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740494551; cv=fail; b=p3wECNzBOVNgX+/NZ8MMKbyNVgPx6cppbe4p/ddyqCEz3mNmsMqc0tXG9jmCsDqFxO3mj/XVtHQa/eNvjSTpaPaKP7JzF34hikCOMz1bi2b+/242iFNevCtaIDPXs9uA5BRdqT6X3cHEoQir7ep4g5zuweHN2kM60jvndXblshA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740494551; c=relaxed/simple;
	bh=uIckmQbQfm1BYZhF23J3WTKYidsEAhuwi7r+g6eEO7c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JCszY8VwJpcDKpdcsCK50vVDCRdYOtv/l3Ln0T0x5rse/zvB3k538Z1SwXSJS4f7UNGfITFpHFoVsat1N91LCoD5JI8UGZtWdxpc4JAnHPDy54rH6coXe3McTXWnmC/Mx78DdGXgPu1KwfVbkI90TDtUpMowfW4WWa9VEqdDFNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TdQ9qDM7; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JY0TM1agAg+GoQ7cOYwvOmLKqQYe7lntAJ5tZSH9fjEYZtq6SHMq8XsUR1qXB/7LWaN5Pq2/NwDulI1zrApxKLinvqnnDzPhmvDQ2Ox0dp2NTySmDBwm6SJnUtUn0Ou2X1RB/wtT4+lArGtxJQbu6SpkaXwPKXVMR2NOJ/lOfzsCOxVkibShAKzJ/OQbM4yggmxn7A7TfhQ5I+zuo3QHNUaFCmDadt1knvNwzBnkZYqt1vO6rbz9BnWJ4BINTubii0lQC6/6dkhTetSKaUu/RSYXDdcclrVcAh8F6ISnZWb59mLj1SNP2IGOGzBrDtB9sTrOp2OvfHo2AzsaHpbuJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lmWURcRg12/jxD9CjGju4g2BER2PowlsDJPUMK8gns=;
 b=HK8rUSvyn2BD7alM7vnbrVNzXmWMPz9DAUzKfOGx6UYHghRKNimDXU0HGpvcpW6IpZ8XxEy7/zjt2susGvvxtkPonxLTqEgfh33PX0ngjSimL+jVZdh9YvsreeS8NgqihEl0TgNOFkZWTw/Z6BIxNyvfGNb3f47xF9GCQqDBmjL2caSqvQA7w7Y0Uc+dlD7Eo7jUUcJR9ogzbi6DIBGZm2kH2S4yaKlzVkq491zTWeVs0OTeKa32bH2GJphANnbjCpKckug6dm2LY4YufkltVAlhzKCEjJSDKHObdFrfD100XIAF5ct7BXpv4WUyfzi50KnzomH0G2/g/tIb88HJCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lmWURcRg12/jxD9CjGju4g2BER2PowlsDJPUMK8gns=;
 b=TdQ9qDM7EsBRcKv+yiGUPDcbOpeu3T6OhMJBOXZfb8cImPSg5Pg7BEz4dWQ1B2nPYDg9bwr1cO9OoCnI2dcIjsO8HBSqsdRvTt3CdU6lH5+5NKnW53YXSaKAVQMdSqvFdUKL8L2hOOy0nsG6NsU9OFKvY/4wNrGAJSf3ZvDxvaw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8423.namprd12.prod.outlook.com (2603:10b6:208:3dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Tue, 25 Feb
 2025 14:42:27 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Tue, 25 Feb 2025
 14:42:27 +0000
Message-ID: <76d50c20-6e00-33a4-9170-63ed7d29673b@amd.com>
Date: Tue, 25 Feb 2025 08:42:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 03/10] KVM: SVM: Terminate the VM if a SEV-ES+ guest is
 run with an invalid VMSA
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Naveen N Rao <naveen@kernel.org>,
 Kim Phillips <kim.phillips@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-4-seanjc@google.com>
 <4e762d94-97d4-2822-4935-2f5ab409ab29@amd.com> <Z7z43JVe2C4a7ElJ@google.com>
 <f9050ee1-3f82-7ae0-68b0-eccae6059fde@amd.com> <Z70UsI0kgcZu844d@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Z70UsI0kgcZu844d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0007.namprd21.prod.outlook.com
 (2603:10b6:805:106::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8423:EE_
X-MS-Office365-Filtering-Correlation-Id: c277465e-c7b6-4021-bb01-08dd55aa9fcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGpJWGxYRkcyejRBNXdBZEx1K05LL0NGZVV0S05kejVsdFVpZEhyeFAyVkN1?=
 =?utf-8?B?VTUvSnlsWVlpcCs2c0tkNFM5ZmNCMzhGOGFpN0hsNlhnTnMvc20wL2s3SzRH?=
 =?utf-8?B?QXRWYkthSWZpYzh2SmU1V3MxSFdTdmluQVQ3d2lvaFdvRlN3UkdwOVI3bDhV?=
 =?utf-8?B?ZWg1RmpFbUM5UWdZUnFhVTJqU0RTVEZLWDhES0VXM0pzS1BnOGVzZkQ1d0ty?=
 =?utf-8?B?c0h0S3RsOEU1VW1xWlgvNW9CZDFRSlFaUU5qeTQweTAxS2ZvWndHcEZlNUFv?=
 =?utf-8?B?T0FpZUdlVUZzN3kwZHN5NVhBc3FqRmZkYllLV3QydVZOOVdRdWJ5emlsTWJr?=
 =?utf-8?B?dGJKdFZGVVV0QXppTlhzc1J3Z1FFLzd2eWxOWHVKUzAyNTJMYU8xOWxmNUJa?=
 =?utf-8?B?QjVCemZHc0JDZ3hQOXRBNmxEbFpMOEl0MHlPSkRld0lnTmhjSzlPNWRnNi9T?=
 =?utf-8?B?VEdlSjVSOVFLYnh6QTdrRERHRG1xTFFHK0x0OHhoK05qOUFwN1pBVXhkanMz?=
 =?utf-8?B?N1NMMVhhcGg1dSthWi9mRVRxTzBrVVpuR3NWYmFyV1ZMRGNQUURMUkdnTEFw?=
 =?utf-8?B?b1ZxZnBEVVZqaVZaOW4zbk4vOVBZVk40ZWNaMm1xeU16Rkl0SDV4TGN3cWtP?=
 =?utf-8?B?alJhb1Nld0xEQTRnSWYrQ1JiSW15SFEzVXpMOWNOREZuMWFiaCtBY0dZWHh2?=
 =?utf-8?B?QTlEUWYva0hTcmFwTm4reUNOYUxuclNsMUhKUkNVNGVydHEyVUhDLzg0RUZ3?=
 =?utf-8?B?SnJpeUdDS3JnMTdpSVptWFdWN01STHVFOWZHZzJmbjV0UTNsWS9xN0dqeW1l?=
 =?utf-8?B?VEtYRG5Qc2xPalpsWVI3Ti81aWxFZjVveTF3UHNhNGh1aTk3TU9ISjc5bDlC?=
 =?utf-8?B?aTZ1bU9rQXhxYVpBUW5tcm9FSkI4NjUxVTZnNTZ0NjBUTlg3bXY2ZnFHdDNt?=
 =?utf-8?B?cGM2emUrK3JSbm9SL1dHMUcyanNjczNiT094YW00K0hOMzRuVk1IUHkvSEsr?=
 =?utf-8?B?MldxZ05qbU03TlZ2NTNaYXYzL2lwcjN1VllhMmpaUU5BVElpVFZ0RnhlSkxm?=
 =?utf-8?B?UVpqN3FaTmFpd0U3U1RUR0g3QXA2amtqbEhMS2gzUXdxMmpoUko2ZkFtL1or?=
 =?utf-8?B?cHFONlNYT2xsdk9nRGpDaVN5ZFE5L1FSUDVUbHoyb0UxMlBDeXJYTllFMVZz?=
 =?utf-8?B?WktXSEpGRVA5Y2hhbm8rRHEyemY4aDRlbHZUKzc5bDByWk5VeStMNFlTVGY2?=
 =?utf-8?B?TTRrbnRsTjVGNjBSUjZhZU96alI2cmFpSE5ZRW5lNi9QQWFEWS9hQURLbXpp?=
 =?utf-8?B?LzFYc0hwOXlCNlc5ZGFidUxSSUM0RE1hREt1NjRPSGNIYmxrR29aMHdsaWRF?=
 =?utf-8?B?TzVSZ29jMVRKOGRYL3NJY1lmRnZMS3hicjFPcm9kVVFCdW9oOWhtUFlycEta?=
 =?utf-8?B?MnBONHdYSE9mLy8zeEkzUWFRK2ZNTGRwZXhWaWpjc1VJbXhSb2tYZnJFa2RW?=
 =?utf-8?B?d2Y4bFJ6ZHN0bVRsQU1pRDBTMWR0enk1YzZXaDBvNGhXY1dCQUFKQldKTXE3?=
 =?utf-8?B?QjFHbkVZRVk5RTFqUkJlNUhaa3UyRHQ3bGdId2pTVmRMSW16aG0yY2NuOE1l?=
 =?utf-8?B?MEdISXRVaTlDUnBnUksyZUdSZG9RcWZSSG9oeDROZGtlSEcwZUFNeGk2OEY0?=
 =?utf-8?B?aEQ3c2xncG0zdFFGM0pscGE0NkdwU1laVEYvZkw2NGxGelBTQVZsM0p3TU5H?=
 =?utf-8?B?eHlidzRIUDZoYTZsV2g0MzJVb3ZGcW1CdTlESDRlUFpZWWViV2hnMlNCK250?=
 =?utf-8?B?UlZxNkdmbTBFRDBuMjB3U1NNTktHQmVHRnBHRjNoN2xCWW5TRzJwRHEvYWZN?=
 =?utf-8?Q?L4QWWyRTZCSlj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YS9rSnR2SmNaT2NrNEpoQmh2ZkV2Y1lnRVlhejJUdGh0bHhldlRXTWc0UXNG?=
 =?utf-8?B?cTdCdVVUOWhiT3dCL2QrbUhNYWpLR1hyY0RRWE1hVG85UWVkeFZFU3BRR2cz?=
 =?utf-8?B?dVQrSGU1RHBCbmsyWlZVVVR6SEVObTM5YWdHWFczOTkyellMVlIzWjhULzRp?=
 =?utf-8?B?STBJSUd1MHU3RGZ5OHUvVTVCbVFUUFNPVFRDc1hyK0xTeUxEQWpHRnRkZ0dZ?=
 =?utf-8?B?TjVYSkNXdEFUTi9aakdzbVlmbDJnWmF3cGNjMGRVdkQvTkZtZkxjR0ZKcE16?=
 =?utf-8?B?ZXZCZXc5clg2K2FiMUg4bTZJNEgrVXpHdzAvTE52ZDZSeVF2Q016bDFkSldh?=
 =?utf-8?B?bUNyai9wRHR4emZwdUlUSXNwbzQxRHZYYjlNd0o2RmY5L014WEM1UTFwNjdt?=
 =?utf-8?B?d2pTVHBTNEQ4cHBUS1VQWGhiNTVHSm9ENlhpSkZKL0xGU2lWM1E4ckNWZTRy?=
 =?utf-8?B?YUNLdmlmUW1UTlAyejZOeHdvU25xaXFIUzRkbGdISjBPb1FhVmZ4a2NwT2g3?=
 =?utf-8?B?V28rbGR6Nm91OHQxNFVKVTFNejVYc1RpR1grSzU1RTFYZUJJbTY0UFc3b3Br?=
 =?utf-8?B?eDMyUDlPSHJsRC9FbVdqcTN0bm5QR0xpV1R6NWtXbG9jNnJ3VEVoL3MrMjhw?=
 =?utf-8?B?WmJ4MnUyeHFvTFNwYzNoTlFRNzA4WWVDQi9QMUYrbiswUjRoS1R5UFE4a3N4?=
 =?utf-8?B?TDkxTEJ1TFN1ZVkvZVdsUzZLVUwzektRVWlJS0ZNK0lRSEROWjRDcWMyYVVL?=
 =?utf-8?B?emJmSTJnVnRzSmdiMk1aV1U4dW14UC9HekNMVjh3VFJURXJSK3hQVHJYZCt6?=
 =?utf-8?B?UjBuZUdSQTZPWEVXM3NtZjdUUjlSUHNoZUJJMitnN2RJNmhMRTJDWGtqYmZq?=
 =?utf-8?B?VzZ3TWFpcXlWckIzSTdIY2VCSFU0NnA2dWNWZU40ODZPQ24xNWFLQmZ2OGRG?=
 =?utf-8?B?cFN0YU4zS3BmSGxZLzRFTG14eUFJN0hzV3F0QU5oZTRXWk5kS2NudVVjV0lz?=
 =?utf-8?B?TXZYQWEvTGpsQXYraGF3ZDJyTXN4aGJPUWNoYXlEOWNKdzBidjk5Uktad005?=
 =?utf-8?B?TEdVNUp4aENjT2hoVUhpS3pqZFgyMlBRTURwak9Qa0p3MmlnSnFyQ2VEVzBn?=
 =?utf-8?B?UGVBaXJlNEpVWFQ0cUxqbXJaaWFBbkFwdkd1Q3ZRdGt3YnA4N3J6UkJxYXNz?=
 =?utf-8?B?TVlJWGJWWW1ISTVMZnlZM1dSK0ZVc2ludGNMUGFoNTV2UEM5WVVsVHg1cTRu?=
 =?utf-8?B?aFV5a001QVZvRWxrWm9lakpNTmJCZnpqRTY4emVnWDJScEtTK3pCR2FTTW15?=
 =?utf-8?B?WkxKc0xPVzdTNGthVE1ERkd4RER0SUl4ak51THR4QmtNR1h4SWVudlVuOWhB?=
 =?utf-8?B?NVRRTGIwbjVFcEVTbXhuV0JkbGd0TFoyb1pNSU56RFlyb0xhRXZ0TzltQ1k0?=
 =?utf-8?B?b3AreEc2Yy9BRVJaQmJZQzZsbkJTNVdLOFVlSktnYnJPMENvMXZqVXdEOTJL?=
 =?utf-8?B?cjY2RGxlM1hrRXVlYkVzQmZwQWZnRGJRaVM4SjFKT2h0clRPTjBSREgyQ05G?=
 =?utf-8?B?aE1hR0hhK2FUVHJOb0lWRTNrWGQ0QThjWmVnV2Y1MmNyVExqanZySTVNcWN3?=
 =?utf-8?B?d0pTZXhWUHA0VzZYZ0I2VlpDTGxBU2srZWlGMlh6NlhRT08reUNmU0NWcjJK?=
 =?utf-8?B?cEVZdHI4cWwyTHRmVlQ0OHZqZG9sbUFzUkxqMmFMR0s0NFBwclRCMzAxeGVq?=
 =?utf-8?B?dkk3NVBNWFlKNi83UmxJRE9pa3pqTWJPN0ZVOWE3TjNCUE9ZOHgxNmVHd3FW?=
 =?utf-8?B?b2svWHFqWkdOTGo1dUlNN1RTQVJEMVBiSG5ib3JGNW8wUFZqY1FrZ2ZwUGZZ?=
 =?utf-8?B?VE51WXR0Wm5hMGs0d3BSSUFVdU1ack5aU3dQYU1tOGNlT2tFN3UvMG52TXht?=
 =?utf-8?B?SzVyMFNMQXRjcWxPVUFOTHRhRnlRVitlVUd6WTN3QllIblpscTBJTmtNWjE2?=
 =?utf-8?B?MHhyN3N3Ymk3TWVBeTJIRkl4TEVBMFNMQTUzME1aT3FRM0RxYmQ0SHdRNXdk?=
 =?utf-8?B?c0k2d1hTV3U1QWRnWGduckVzbExkMEc4MERwbTdTLzc2dDE0QStCU2hZN29F?=
 =?utf-8?Q?CreWaMpWGf7e2Rv4lNw90jUyT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c277465e-c7b6-4021-bb01-08dd55aa9fcd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 14:42:27.2260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeVkr///42dvX7khYPnq2Erme1ASa8MOXg8q8oGlfn65sPID4Pj6hwtlMJUxipBsU2JibEsN49NhvzFa6mVq1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8423

On 2/24/25 18:54, Sean Christopherson wrote:
> On Mon, Feb 24, 2025, Tom Lendacky wrote:
>> On 2/24/25 16:55, Sean Christopherson wrote:
>>> On Mon, Feb 24, 2025, Tom Lendacky wrote:
>>>> On 2/18/25 19:26, Sean Christopherson wrote:

> 
> Given that, IIUC, KVM would eventually return KVM_EXIT_FAIL_ENTRY, I like your
> idea of returning meaningful information.  And unless I'm missing something, that
> would obviate any need to terminate the VM, which would address your earlier point
> of whether terminating the VM is truly better than returning than returning a
> familiar error code.
> 
> So this? (completely untested)

This works nicely and qemu terminates quickly with:

KVM: entry failed, hardware error 0xffffffffffffffff

Thanks,
Tom

> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7345cac6f93a..71b340cbe561 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3463,10 +3463,8 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
>          * invalid VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after
>          * an SNP AP Destroy event.
>          */
> -       if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa)) {
> -               kvm_vm_dead(kvm);
> -               return -EIO;
> -       }
> +       if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
> +               return -EINVAL;
>  
>         /* Assign the asid allocated with this SEV guest */
>         svm->asid = asid;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 46e0b65a9fec..f72bcf2e590e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4233,8 +4233,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>         if (force_immediate_exit)
>                 smp_send_reschedule(vcpu->cpu);
>  
> -       if (pre_svm_run(vcpu))
> +       if (pre_svm_run(vcpu)) {
> +               vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> +               vcpu->run->fail_entry.hardware_entry_failure_reason = SVM_EXIT_ERR;
> +               vcpu->run->fail_entry.cpu = vcpu->cpu;
>                 return EXIT_FASTPATH_EXIT_USERSPACE;
> +       }
>  
>         sync_lapic_to_cr8(vcpu);

