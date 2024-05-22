Return-Path: <kvm+bounces-17923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1060B8CBB04
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AFC81C217DE
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516B778C79;
	Wed, 22 May 2024 06:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a5S5pP0Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191D178C67;
	Wed, 22 May 2024 06:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716358313; cv=fail; b=oB+lWJkMLQBSME/dbwqmNrpaxfijtAICN3VQPsXIRs3P253t8n2Ma7TiZkdJAtxzkbRkvhwje0q/k+LPUIGvr2Z90i8UdBzlPHtPY1+fX8hX1nOHPI4uNx1RGVKao6ZKC46ov3v8N4r3syc850kgyvVz1wx2w3dl+2AYjxSjJak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716358313; c=relaxed/simple;
	bh=Abz44vHOl1DHz7JEKeWiYpW738PdjJ80V71Q7m+0htM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f3pABTqlhOqlri3EaTKTA5QLwNVRvF+ivXwcc3qKwJmQboY2oxp40pmUgeBQEJFj3ojyP2id1pppDVIlirA7iM8ttS4Fqt3bWKdWFcQA41/N2aaGNZ0aHGqN36Q74pQ+dcof9l9JrKcdQMbJwRu9dVkCbMYAlg9QYoplwm4F3oQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a5S5pP0Y; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLK6Kdya1gjJZZWAuvr3IsYmLfFXLj9ccHAd3CHokji99qYHeTeyumIf9a9pqwzQfpimAi37yy4hL3xRSluQY9cuRqogF1cJuCgd+5vywt+J7yeVWehP96IwNvi6vbn0pNlc5/15u6UqSs8kzm5uwIMapUUDSrM+6BTLKrWN4dDtYKZiQzzFWLhS3IO1CPGwxemRme0eHZbUEsorS2xhfM2voyrwbFilFVW6AIIoW51WUbnCO0Nw3Y1UXWUcXnfDikgWbExBJcJC4qqob80L71GhB8Q3O9IaBq1OG2JwQHJF3ZtIF2lg23nqEmexQQwbFhguJvAo+FN9NLQS41wH2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FW0ZwSjrx17FzzuM4hptid+MOBRTesM4kM2AsE4ad0=;
 b=B+Qgjwk3gzNIdR4ZvAFXSVkBeMEd05wTgizyy3/ARH4kj7k4BkjDuDorct2vvyYExIVaBePcv1Jy/43VnMpMx5tPP9vx+5Sbtd8hxpetVR4oqFP5EZP16bS97af4ToRpWLMWI7Y9V7ysc878Mw//FkNctEjYfkcnbIpGlOdymPdY+LJ5HNbZCp4PuelE651b/GVwVKovRG8PPCubTdGioYr12GVz6yDduV/kELTiSzK45giqHJulIIHTDOl9bpvqdUCebBQgM0cUO9tO1jd5KVsnQ+Il9oagGAuy1CVva/bNQwliPRSCWnva8hnu8sCHNHqD4m4fkaytzlbWLuLpTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FW0ZwSjrx17FzzuM4hptid+MOBRTesM4kM2AsE4ad0=;
 b=a5S5pP0YHdejwgIQaqbb5TEycKbVp5hDPTNjeig48bldeDR/r/9N4T9QVYqmNT6gAKj0SzbR+ymZbEP5Gr5I7u+MsZv4rkkRs6RN3NEEKeJwpWjumCIlngdcfl4C2BGI5U3Tkeh8T70cAS6pmWplXX+p59f06JmnzkPYTxzz9Gk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by CY5PR12MB6177.namprd12.prod.outlook.com (2603:10b6:930:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 06:11:49 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 06:11:49 +0000
Message-ID: <d543ac68-346a-4439-8f29-ceb7aa1b3b50@amd.com>
Date: Wed, 22 May 2024 11:41:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: thomas.lendacky@amd.com, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com, ravi.bangoria@amd.com
References: <20240416050338.517-1-ravi.bangoria@amd.com>
 <ZjQnFO9Pf4OLZdLU@google.com> <9252b68e-2b6a-6173-2e13-20154903097d@amd.com>
 <Zjp8AIorXJ-TEZP0@google.com> <305b84aa-3897-40f4-873b-dc512a2da61f@amd.com>
 <ZkdqW8JGCrUUO3RA@google.com> <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com>
 <Zk0ErRQt3XH7xK6O@google.com>
 <CABgObfaXAERePMQrrpWg8PqM1TOq8TJT65i3WgU0n0-vePDGNg@mail.gmail.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <CABgObfaXAERePMQrrpWg8PqM1TOq8TJT65i3WgU0n0-vePDGNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::10) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|CY5PR12MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d5a532a-0c10-4444-e9af-08dc7a261118
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWJNbkNrYVh5QnZFSjhaZlNkdU9BMGQxczhDOVgwT2cwUFdUdVhJVjhZTTVn?=
 =?utf-8?B?Y0ZEQ0lFWm45eVRST0FNdlZTUkQ0bFlZa3RBdDVxbXFVS3hRcFhQbE5UbklJ?=
 =?utf-8?B?VDhwdHpVa3Arb0FCeDFmN2J3RTJLUWxZdkZQVzJ4Qm0zRTFvU3IwSityczVr?=
 =?utf-8?B?NkVoWlhhdWNTTm5yMVdrMjVoN1diSHVTZTFUT3NUeFk5SVVhcVhlcDVKeGRP?=
 =?utf-8?B?aDNmejNHcnp3Ti9DeUthWFJBUUZhN3R4QjBDdEUrelZTVGZpVkxiSjcrVG1D?=
 =?utf-8?B?eFBPVFNrRXcyRlA1QVNEUG1TTkg2bVpYYXkrbjRRTVJUdyswNGRSUjh3TWx0?=
 =?utf-8?B?VHFSN1p5NUtlZzAvdERZSnpYRjlMY1lyTnZLc2IydnpFTnNXUHI0cUIyVHZW?=
 =?utf-8?B?cVhpUS9hUEE4cG1MNFk4RXlYQk1TWXV1M1JIUCs1SzVtaG1Dc25XeU1uMHQ0?=
 =?utf-8?B?UXgrbDIrZktMWDFaYWdmTW5UNXRKaVFMRkpUbDdMaUk2UnFGVWJHSWZYL0RR?=
 =?utf-8?B?UmlXejNQaWRYRDNSaVZpTXVLQ3kzVVhDT2dpdWV1TGNxbElrVk0zM2xNb2c0?=
 =?utf-8?B?cXZUVURIZUI2RnV6ZmJJWG4rR3VMWmgwRWVTaEVJbGxaWkdHMC9FTUNLWWJQ?=
 =?utf-8?B?TTkycFUyRHFyaGtWYXZXNXZGbTJLb1pZVnBqVnF5THVmR1JrNDhqV1kwZW9x?=
 =?utf-8?B?b0xpWENkdzZrQ09jOE1ib0JhWURNZWtxSDd6RjdmR1dnVFZWMHBmVGg5RXYy?=
 =?utf-8?B?N1ovWE5DTGN1aVBaWDFQWSt3eTdIOXgwSnFsSHFHWGVKbFpTQ3FaS0pCbnEv?=
 =?utf-8?B?eUMxS0JzNkQvdnNKTWxJQ1A2M3EwcUQ0cjcvUlBBMEVub3RndWpMRFFEQU1k?=
 =?utf-8?B?dlVhb0U3MXQ5OStHNFBDTE5yQTFEZjRFOEQ3eHB5dlc5U1hzck5GM0w0RjhZ?=
 =?utf-8?B?bXZLRGVoeVUrbDRETEw4MFBhVGlteFdka2lwTjJWVldPSWxTenlHT2NVd21Q?=
 =?utf-8?B?bWk0Qkp1c2g4NVJTczNWSWRuczZaM0JMeGtHQ0lOWEdyNHBUZHJsUmJ4UFRZ?=
 =?utf-8?B?anNvUUdjM0JTSVI2SjEzMzNINFJXeEJrNWw1UG5XejNDU002dmdyL1JpTXUz?=
 =?utf-8?B?TityNjNiN3BKRDFhOElJUytRdTduOEs3cnVkckZBSzVLTlJla0kyWWRyVXZl?=
 =?utf-8?B?OFViODNEeENrWXMzUFZGKzRKWTdqMGREVHVqVzlJeEJURE0xVGRxRzFLaUVI?=
 =?utf-8?B?Nnh5bFE1WTRmTXJPZzM3akJHVGd2VUdrTkdhc2E1OXBZdXlSMnlHSm9DcmdJ?=
 =?utf-8?B?Zk1sUXRsbHkwU2NtaDFWQ0FNK2F4YkhoWjcvRHdab2VpT1NNM1FEYUFPRjgy?=
 =?utf-8?B?TDN6allXSVA4OE9nOUVhb3V6dmk3YUtuQUR4NlpNVnlrdGJmUm41bllKOWN3?=
 =?utf-8?B?ZkN3ZXpJc2tnVkh6ZGpKWnFCd2JTRDdaVHhzYi81S0psM0VpMHFTY1NNdEtk?=
 =?utf-8?B?RzIrdlh2ZEdTK29tQ3NITkl5YkpuRDJTWnV3V08va1hTNnJ2YU1xWGFTTXFZ?=
 =?utf-8?B?VWx2bExZZ3RsSXBrUVpRQVRuK1VHNUIxY013QVpNVHpjZjBpY2JaSDZMd0VO?=
 =?utf-8?B?aXBTQ1VnV0pNRitPL1ZQWFNuRk1yWmJEWXBVNXRaQUVWc3FQL2o2ZDF4bDVs?=
 =?utf-8?B?ZzNjVmhzVkF1NldxaW5tWUFZVGh2aXhiYythK2M1MjJQZ3NMeFMvVGtnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ykl4ZlIvVisyQjRoSisza3lSUFdjcWlKbng0S2VOYWJpZUwzbE9LUlpUbkRO?=
 =?utf-8?B?WWkvTXFuV2hQRGJ2NG1CdGdCeHdPL3pTMkN1RTZzVlZrSVB2MjYyc2FrMzRk?=
 =?utf-8?B?VUk5TjQ1VnZsZzN1VENFRmhhbmZMbFYwSjRwS3pLSEVDNnZxSGRBUlNLK0R6?=
 =?utf-8?B?ME5JWlFlS28zL2dnRHllRk14akhpa0h5dUdMRFBBZHE1dWp5R3pXRWJRb3NG?=
 =?utf-8?B?bVF6aFdNT3MrdmtRcTlkRmtKMkQ1UU1vQVRrZGJjeU5BSS95T0VMcXpqcXZJ?=
 =?utf-8?B?MGxKQmIwM1VpSFQveGt1OWkwV2pvcGp6d1JoQWkyME53MGN0VWdvQ1prZDlN?=
 =?utf-8?B?eE13b2NSSlFvSjhDNTFXZW1OSFhGSU9kd2EyeW94RVNtQ3g3TjdaeUxZcXZT?=
 =?utf-8?B?R1F1WmE2OU91cys1NWFRam93Wlg3cE5sdC9wei9XVC9aQWhwMGdaVUpqUUtr?=
 =?utf-8?B?amI1UzB2RmFnc05YM2ZSanM4c0hIMllWNEE3Ui9VcW1rcFp0Zjh4OUVCTWcx?=
 =?utf-8?B?RnRVWUZhTHpaQUk4a0hYSHRIZ2piWGlhNC9NVytrWmVwdFdWcjNQUUN4THA0?=
 =?utf-8?B?ZWtPWnM0Ynp3VXNZOTEzNTZmYnpEVVIrbWQyNkVuMkE2YjNpTjVseWlKUGxn?=
 =?utf-8?B?NWx6NVUzdm14VjM4cE8rckNCazZxSWJ5ZUphZ3NZQmlNM0RvS3pnMjNwZVN6?=
 =?utf-8?B?a05PMGZHMW1sdE43cHdsTm9qdTBqWUt0ZkZCSGMwdldLWk1wWlhsOXpQeHpt?=
 =?utf-8?B?T1lzc0hIY1RHSjFPSHVqcjNqNnpvS00xWkNHMVRKbkJGWGJabW5tbithbnhi?=
 =?utf-8?B?bGYyVGgxZlo1clJhOGFtc2tHOWhQV3N4WEFsdUN3K1pjNUhTcmNGK2ZMLzZC?=
 =?utf-8?B?T2lXQzNCcHZEMVl2RDlKcVQ3MnRzT0ZmOWo3dGJkWmMyN2YrRi9Hc3l1czlX?=
 =?utf-8?B?djJNNm9PSlhUUXVqUldxd2hSRUlaRWxxZ01sNUR2T1NJcHlrcnRkc1N3VVY5?=
 =?utf-8?B?b0lMYWFkblZPKzU1d000ZU1nam95bzM0d29ldVFrL2ErakRYSHlCd2Y2TlpD?=
 =?utf-8?B?czE4cGZJbTE4M21JTmM1ZkY5LzZPTFBveU1lYXVJYzZlNVF2Y244bDJvUjV2?=
 =?utf-8?B?S2ZyU1gwaW9TMUFKN0hQQVB1Y0ZzV1BXak10Wm5lRlEyMnFVVTdQMmtHYUNV?=
 =?utf-8?B?bFB4cGx2WVdMeHJ4NnMwTWpCY2wvWlByVnRlOFdBYjM1dFd1M3RnWWJSV1Rr?=
 =?utf-8?B?bVBZbmdaenFlVXcybDBxbnNUajMxb1lWb3hRTk15Ry9aQ2VvZzNGMUJNUUMv?=
 =?utf-8?B?REI2citDVUtWKzJRT3ZBZUtGWS83VXhEbWNqdTZRT0o3cGFGV0NTc1k2Nytn?=
 =?utf-8?B?eHE2eUJWTDc2M3h1MzVJbGR3dkZabHVWQlA4NHE4UWVzUnI5TUNhVjFQZ3ZX?=
 =?utf-8?B?bkYxQkp2dGtJSFJieVI4MUFEbjFvakErcG5naEsrRmthWDFJcHJuWmZFL3F5?=
 =?utf-8?B?Y1NOenJ6M1Vlbko3dnhTaGYwbUt5dDhreFpIQmJhUHNjMnpJUnBmNWJrb2R3?=
 =?utf-8?B?SU9hV1JsVjc4TkFlVFZvVG1mUUJZcmlpZG5pTVU3V2FFNUhWdkoxcm9RRmo4?=
 =?utf-8?B?eEdIRzgzTHh6QUwxMjZLMVFvbWRMRDlIL0dibVQ2cmZDdndpL3B2Lyt5YSto?=
 =?utf-8?B?OUpOVVpXVWFGWjQvaUlMLzB5cDQ1Mm5qaDgyN2RXZ3dqT2kzS1Rqenk3T3Ru?=
 =?utf-8?B?TVJtT3YyQXZjeEI1U3ROU0Fya3dmSEQ0dXBJSmhuYTFzdURoeGNSaHVVTTEz?=
 =?utf-8?B?K0lJSGRkYmpMZDFRQ0paenROVTdtenpQU2FQWVZ1WmFmc1RyS2JBcmpiWEda?=
 =?utf-8?B?WFpJc2tRTlc3anF0TXV4aktPYnBHdGlrYjVPd1o5d21VeWtPZGRqREhUVnND?=
 =?utf-8?B?cWRzL05EdVhIRU9vUjlxRUpjdm1hT1dyUXh5K1JlSk01aHUzdzRZNU9jenA1?=
 =?utf-8?B?ZGJONUxvdW13cFFPOGhxYjQ5VVEwb2hIS1VEd3U2Y0QyKzcwTHZlUUlZVlh6?=
 =?utf-8?B?Z0ZZTnZuSGlISHRDaDQxSkgxVlA2UU5NOHU3blVJOS82Zk5TcVR1ZEJXRTh3?=
 =?utf-8?Q?udIrI4zOt/WYsB9/JmllRljVB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5a532a-0c10-4444-e9af-08dc7a261118
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 06:11:49.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSBuOa7Sp6BJPm3fWwuOtlGylTs+XhZCCALKAh6lOIr1IEOJtXwANHKOudqTMd0EI6xER/e4zYt/BGSAIIUJbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6177

On 5/22/2024 2:17 AM, Paolo Bonzini wrote:
> On Tue, May 21, 2024 at 10:31 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Mon, May 20, 2024, Ravi Bangoria wrote:
>>> On 17-May-24 8:01 PM, Sean Christopherson wrote:
>>>> On Fri, May 17, 2024, Ravi Bangoria wrote:
>>>>> On 08-May-24 12:37 AM, Sean Christopherson wrote:
>>>>>> So unless I'm missing something, the only reason to ever disable LBRV would be
>>>>>> for performance reasons.  Indeed the original commits more or less says as much:
>>>>>>
>>>>>>   commit 24e09cbf480a72f9c952af4ca77b159503dca44b
>>>>>>   Author:     Joerg Roedel <joerg.roedel@amd.com>
>>>>>>   AuthorDate: Wed Feb 13 18:58:47 2008 +0100
>>>>>>
>>>>>>     KVM: SVM: enable LBR virtualization
>>>>>>
>>>>>>     This patch implements the Last Branch Record Virtualization (LBRV) feature of
>>>>>>     the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
>>>>>>     be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
>>>>>>     there is no increased world switch overhead when the guest doesn't use these
>>>>>>     MSRs.
>>>>>>
>>>>>> but what it _doesn't_ say is what the world switch overhead is when LBRV is
>>>>>> enabled.  If the overhead is small, e.g. 20 cycles?, then I see no reason to
>>>>>> keep the dynamically toggling.
>>>>>>
>>>>>> And if we ditch the dynamic toggling, then this patch is unnecessary to fix the
>>>>>> LBRV issue.  It _is_ necessary to actually let the guest use the LBRs, but that's
>>>>>> a wildly different changelog and justification.
>>>>>
>>>>> The overhead might be less for legacy LBR. But upcoming hw also supports
>>>>> LBR Stack Virtualization[1]. LBR Stack has total 34 MSRs (two control and
>>>>> 16*2 stack). Also, Legacy and Stack LBR virtualization both are controlled
>>>>> through the same VMCB bit. So I think I still need to keep the dynamic
>>>>> toggling for LBR Stack virtualization.
>>>>
>>>> Please get performance number so that we can make an informed decision.  I don't
>>>> want to carry complexity because we _think_ the overhead would be too high.
>>>
>>> LBR Virtualization overhead for guest entry + exit roundtrip is ~450 cycles* on
>>
>> Ouch.  Just to clearify, that's for LBR Stack Virtualization, correct?
> 
> And they are all in the VMSA, triggered by LBR_CTL_ENABLE_MASK, for
> non SEV-ES guests?

Not sure I follow. LBR_CTL_ENABLE_MASK works same for all types of guests.
Just that, it's mandatory for SEV-ES guests and optional for SVM and SEV
guests.

Thanks,
Ravi

