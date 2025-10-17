Return-Path: <kvm+bounces-60291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EF362BE7E65
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4316C544807
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 09:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F2E2DC77F;
	Fri, 17 Oct 2025 09:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P51/kV0V"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012011.outbound.protection.outlook.com [52.101.48.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416972DAFAC;
	Fri, 17 Oct 2025 09:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760694797; cv=fail; b=Khw8i88FJaiNoMxawXkqHnJMTQ+eTRVYuhhw5UfHArPCsgx2AiOAY9G6ttZHRtjczGyjz5RH4gvpSH6Zw4Xl64SDfkZzYdwoRX1vG5SgQ5sObsKGEjaZYUEQvx1xVPcYPbDzFEKFQCDcwmyBppvO6drhQrpZ1A7Tu+zdgyvAKZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760694797; c=relaxed/simple;
	bh=owYYBhUivigteU4b3W07m3mIuQsrpumdVhoz5SOiixY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DRvkT7xJHugirY7Z3RRF12x0aAWTevPCJM71pqb+TM+R5nlLz3wOb7a4bh9yffflJP5IDi18m9Fa9N+5pbdJx5HIG/mYCtXHlXak9LjUeV20IYGpD4HVDyePrdDm/HBnGEh2nwJkkF+yeFmCdxaFdZwuoGCN1arEBA2JA3BUMlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P51/kV0V; arc=fail smtp.client-ip=52.101.48.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBiUe1493ezXirufinrZK3MTwApFbbywbNQmc5yMcYuGYPU6D1UTNvF/WKMz5PXUsMr9HJZgabyP2nAarUZ0PPx8TiX/FZ5ZFvJccqqgLqCen4eIZFxUVFp0m+sBOLChwvVPmtJ+xWCLpa/9Ta8Khaa6Dv9wVmdYUbBS/YKPsRMCbYpCzeJT1RIyqRynREvfwPGkl4mi/QSDI9FPMBBLkVwKLriW8fCryyCx536DlBstVKWMox2nQz0WatctgzvZlMU88CKRe2y6bxknwEWP767dAaAa9AarBoOj0XQIzu3UcGxr9I4QHEFlsC3dnfKCX1+l8GqgAh5948nQQHFttQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VVPA5qy6xtcoc5qVY64E0bbqO1+MbEh0AMa+KzRWaAg=;
 b=Jn9ms8nWnLDxqvbbQTsbnD0k/gWfPLn3nZ7cWvc7OttSGOi0IyhQOyQej4CUr6vh6x4cPMy8zTYf7gty1cl6vMPX9mrBfYIXnMcWK5MduyTj0J8ncUvrEMaBXQdtyiAMFtu3N+NQJdCNj4nsS1tuW0AdlJsSoPu4KuJKLO3ZAb/0jlzi5h+fO+J1+JMJR6K+wQgPuONLN4TO3Mrse5JlYVfe4KkGtRXQq2vZqMugz9U69T0wZTGaTEdUMztSfSiAAaBmrYZ9sEoG8suwBODeP0JS7CRLkvbS7nHSxt/rRX+9Jt/vRux3Rcw1844nbMr2vqlM/rRN+oUd7Vbe6YxAZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVPA5qy6xtcoc5qVY64E0bbqO1+MbEh0AMa+KzRWaAg=;
 b=P51/kV0VCxprXcpINh+7xUTgZi3zTNDBIMDc5FkvWqX5PYjBeJ+De7Kmc2/ZV7SLLYYs1RN4RuQ1ZlArj4K2KxkpIdrstTq8h4l513LYkTvObssO/EP7QA+YDui0xAqoSlN4sWQDN98hIRiH3ykYwF+MgVtU4OtLyNFW765XvwE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by DS5PPF6BCF148B6.namprd12.prod.outlook.com (2603:10b6:f:fc00::652) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 09:53:13 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:53:13 +0000
Message-ID: <cb260cc4-3afd-41b0-bb98-296ef4f7c85f@amd.com>
Date: Fri, 17 Oct 2025 15:23:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 07/12] KVM: selftests: Report stacktraces SIGBUS,
 SIGSEGV, SIGILL, and SIGFPE by default
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251016172853.52451-1-seanjc@google.com>
 <20251016172853.52451-8-seanjc@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251016172853.52451-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0164.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1cf::13) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|DS5PPF6BCF148B6:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c866aac-32a3-427a-95b6-08de0d62fcf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDZtTm5UNEpYSTMrbUYrQ0w1OEQ0SGRwKy96WW1icWJwcE0zaHhpc3R0UjRU?=
 =?utf-8?B?VW9qUHFNZkFwYmFIbitva0tLNytNcVA0VmNnSGFwSUZFSXI5aWFabUlCbkRn?=
 =?utf-8?B?eW9Oc29VN2EwMGdYZXd6dWZndVo1MGd2b2JOc1dxdXVCTkdrMWM1bGZSa1V6?=
 =?utf-8?B?OXRyQlExZXFNVFBJYklTc0cxVnIrVkhoSUFTaVNhcTI5Yk5YVFdMcit6QTh4?=
 =?utf-8?B?UnMzQjlTTG1tUmtUeEVRSG56OEFQUmtsUkxBQ2M2OHlhek1FMHpFZ3Q2eXly?=
 =?utf-8?B?TW8zVE1FSWQyTXhFM09nRXV0Q2hxQUk1TGN1czQ5cVlzRmg0Y0MxdEFWRUhx?=
 =?utf-8?B?U2laRy9TOHNoLzM0aU5rcGRFdnAwVldoeVlPNXVkTmpxSGpvbExGRG03OVJq?=
 =?utf-8?B?TVBDZDR3cWUzc3VEbnlxMlg0QlIzSDBjZGhKNjNISGJ1emNoeFl6MEx3Y2Vp?=
 =?utf-8?B?cUYyVk1uQ2YrT2ZhZ1JxR3o2VUg5NFd6MktyY0UySU9jSFpyeTlWcS9kY2Ro?=
 =?utf-8?B?bXRtQ0JXSm8yWTcyYkZLdkNKNXMvMmtOOHprZXp5Ny9SMGlqbGNLdEwrZ3Zk?=
 =?utf-8?B?OHhFY09ReVVDbjZoWnl3d3Y5bFZ1bFZGaDJIWmZrZDEwTnFCcWYrU1dTK1pF?=
 =?utf-8?B?bFl4MnIxOGpHclgyTmtZaDAvei9PVkR6WWdTZFpSUWhja0VqU1UwNmdvRHIv?=
 =?utf-8?B?aXloRlN1dVRYNGNxQVZab0Ziemg2N0lBV2QrNU5Jb1B0ZzF6QVF6SmpkL0pK?=
 =?utf-8?B?cEFXSlpqVHhxc0dJWTRDTWJNSGZPekE2bmFlVVh5OWhGYk1VZ0Rrd0xTWlVl?=
 =?utf-8?B?WDRzOWorUSs2ak9aTC9TUjVyUjB0SDlIdzBzNmxDNmRHaFUxS2hsOFhKYU1H?=
 =?utf-8?B?OVVqMlExc0VYNFZRR1Z6dHBzelQxZTRUWHd4RjZkL0xld21EbVhXMnVmdjVL?=
 =?utf-8?B?RDEyYjN5VzdvazMxenZGQ0RjMVQrYkpNaU5SQlVicnpHcWxraG8vODFxb3ZZ?=
 =?utf-8?B?NnVNZ0JObFpLU2FMREVwYzdOcGVTT2xURENPTzNJZ0VVeXNwKzJoNExkRHp1?=
 =?utf-8?B?WUhSWVN4a2p1MjR4T1RvZWZUM3hWREJhWFRsVC9UUnp1ODZnb0N2RGRFRUpK?=
 =?utf-8?B?S0V1NnArM1VRQlNwTGhMcnRINEg5K2RJT1NrSU82UTNZZW85dWdqMGlTVlNR?=
 =?utf-8?B?eVhMb2ZTd3loQTFrbEJFUjBqMjJrKy85dDBsMDUvVzhjSHU3MmVGWFlrUXQ1?=
 =?utf-8?B?VndmaS9Md09hT21lTS9UOG5rL2dVejBXZVZTbm5qMUhEd2wyN3pkOGRJQWx6?=
 =?utf-8?B?MnhzM09ta096ek5vQWhtbHB0R3R2YXpwRHF3Wmpnc2tLL0pvUnFaZUxSUkd2?=
 =?utf-8?B?S3FWQ1dlY3FGYm5nZkpZVjFjTFNSYnhsbUt1YmNTSUR0SE5WTG1nb2lxbjhI?=
 =?utf-8?B?anZGclBsT0FPSHduWndZU0hSelZ5L1lQbWc0Ynd6T25sWnYyWnRWL0x5eHkr?=
 =?utf-8?B?blA3TkZ4MVducFBGdVhtV1R4NEhXalFQT3YySHFpWHV6MGlxellTenVzWS9r?=
 =?utf-8?B?Mm9tR2w3MDBWdjd0V1VjYm83dHg4aEFmQ3RhMzBvRk4wbGpYdFhrZW0za1h2?=
 =?utf-8?B?WWJoNWxycjk5N0JDVndvNHhlRm5NOG5Vc1U2b2JFaHlrZGNRODJFK2xkcDV6?=
 =?utf-8?B?K0oyS1oyY0FSMDdSUUdjNDhhOFJZVm5jN3A5U3VYNXBCWkhzZUlNUTNZaGVl?=
 =?utf-8?B?OGd3ZnlOc3FJT1hic0FtREI2THI1UmJMbUJKNFRnTFBjMzA4ZFA4YnlqNHov?=
 =?utf-8?B?bEFEUEZnVndkdGhCRU5CMU5zbzFWallKaGNXY2NEUUZmQ1RSWGdvNVNxaDRH?=
 =?utf-8?B?L0RROGIwY0xMYzNtVTF0TGdlejNPWVdQTVVUcm1sRndlcVhxUjRkTFB6S0xO?=
 =?utf-8?Q?rTWUQz2msQHb5ZRb9Ku9uAKnBPa9p7RC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHNpQXVjc3hWYjluaGZVZzZaUXhRdVgzNm5mU05CZmpHSUhrR2dOZUtCNWJV?=
 =?utf-8?B?aTVyUkxVYTJIWGlTL29uL0VnY2Y4V0gvTmJ6TWRGQ25DRGpjUU53Q04xSXhM?=
 =?utf-8?B?eERyd0FYc3ZjRWtCYVgvUHZUKzJyMW95ekw2Z05hdjg5WEJwa1JlSVVQdnVT?=
 =?utf-8?B?WkRia3lFQ1R4VkpEeVFRcjdmbmUxZlFMZUFYZklyTGhQd1EwSlFUZVFEUm1S?=
 =?utf-8?B?Y3NOTXNCdmVha2dmbFRXNGxTNXl5NWFiWlg3T1JMZjMvcjVMY3M3WStwb2pC?=
 =?utf-8?B?MEtJQzBXVFlyZ0ZSM0J2SjcxdEhwYWRPVXQ3cE8zMVoyWmdqaGRHZWJLTG1H?=
 =?utf-8?B?R2l5cjFwKzRJU1FqWjNBbTBkU2FManQzVEI5YVZ1THR2ODZWOWN1ODhkM0NT?=
 =?utf-8?B?STFaUC9td2hPYUJCZ245dmJib3lzcVB5RzYzUytYdFg3bXdDSjg0MnM2NjhG?=
 =?utf-8?B?T3VLY1p3aTA3bHl4MW1sOGtHQ09YNUdMc2dHMDF4NkhpRWZzMTA0V2xiSzBl?=
 =?utf-8?B?MWhKZFZGS2tjMUZlcUFKYzZaSjRHNHhCd2hLTWRXTk5HRkRRNTBvd2FDTElp?=
 =?utf-8?B?WEtGSWtTOGhmRGliejQyci8zSlQrQXowcDB6M29pVWZPSENGakQxS0hYNHBM?=
 =?utf-8?B?ak1oenVDb2xzQVVVa0d1bmJXOVR6ekkzVHIvV3JvWkxzOHNZTUJQVHNGT25n?=
 =?utf-8?B?M2pCaTRBUjVSV1BCajJEeDB5VFdBT0J3YWlvSm4wc0hYekNnR1puK0Z4eHhw?=
 =?utf-8?B?eG4xamQ1V28wQytYYXV5N25MWDA3T3RlTkR4MW1hc2l4cVdTSFg2b05MK1BL?=
 =?utf-8?B?MVFtb3V6dU8vd1o2VU1rOStZU1pmVzhQWmZ1ZkFJQllZZXVuK3ZEaGVhSVlV?=
 =?utf-8?B?cXZMYVBEc05LRnlxQWxNZ0JIcHRiTHRaT2QwTzhBUWxWa3RrTm1ERjY3dDli?=
 =?utf-8?B?VEVxdi8yZEhvZnpxTWUxSnQ5UXpEQXd5SUpaQkRTY3ExTmRESk1oZEUwM1RF?=
 =?utf-8?B?YjVQREhjY3RueHJHeDhQMkxKRFBUZExjOTZnOE9EVXloMVN1SFYxUW1qQXRS?=
 =?utf-8?B?YkkvUXhwNlEwaDNzb21Xdkh4WUE2b3packRFaVhpL2MxdUZ0RjN4aGhKbnc0?=
 =?utf-8?B?a0R5Zm1NYXE1aXFzSXNuZUw3UVdWY1docGxkVXRaRFpqL1ZJRWpCdm1Td1Rl?=
 =?utf-8?B?Y0tTcWRCckZQMGdtVGtmZ0RXeVgvenBWbyt2eVEreEJSQmsvTko4ZUV5aVNz?=
 =?utf-8?B?VGZwVStYM0lEMlVtVmlvSkozS0FVcXIxbC9SUUg1ZDd2Zk9OR3FmVFZuVXcw?=
 =?utf-8?B?cE9QbEhpbzY4cENqWTVoZGx4VC9nSjFranlWTVNtQWZXK0N2dFpFR290NzRZ?=
 =?utf-8?B?VU1xSmZneGtoQndtS1FwUmExUnR1bGVITXZNWXY0NFUxbmFBUWY1M0toazRJ?=
 =?utf-8?B?TklRQnBQRndEOFVpMVA1bU9mVlpJNDdZMmZHM1V2NStyaEZnV3hqNlVMeitl?=
 =?utf-8?B?Unh4KzU1QWZYa0l4TllqRjBJK0EvM2VjSXR3VW1wRCswUE42WWJSVFJ4ckk3?=
 =?utf-8?B?bDQ3VWpLcU5JNnp4OHY0OFRMMlJDeHpMeWxJZG4ySC9GaG9RMVdYVFdnUG1I?=
 =?utf-8?B?cmI4Yk8wa3ZoUVAvZW5lblB1K2VCZVAzdTRBeGVXRldHYzZYbnM1bWtPdVEr?=
 =?utf-8?B?TmltRHR3dXRNRzZUOFdPR1lZQUF5UjN2YndGZGpPR3d2Znc0cE92OW5aaktO?=
 =?utf-8?B?THhuaEtidTVqeGwyWUpZeU8rVURJMWJqUUh6LzRLTlVaelo3THlvT2NGelFK?=
 =?utf-8?B?OUMrKzVEa2gyVStaenZtOCthbVphWEJmazV0R1FyQk9hMlliUHRiQXZBUFlt?=
 =?utf-8?B?YkF5YzJLV0xrMGpNZXdWdFQ2MkdjRUJoRGRUaGNCL0t1MlJvcEh0b0ZQWXdH?=
 =?utf-8?B?eFVMMW12b3JPZkFjVXNhbTVUWmVZZGFXbVBMcDFsUG85RFdsODQxaDIzczhY?=
 =?utf-8?B?R1ptSDJQSzhMU0liVGpPc2NVVnBjTkw2S3MvZEd5MnBBNjhJekdGVk1wQ0VC?=
 =?utf-8?B?NjhKRVJuT05ycFJhTExxM056Vksvc0RhTUxFZ1prNGhwdHdwUUFVTEp2MXRW?=
 =?utf-8?Q?dDzn8+G/1ZCn9O7ExhOtFXoox?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c866aac-32a3-427a-95b6-08de0d62fcf8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:53:13.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1PSpczYCzld9H1p5C5PD6HnqO8cmPqW319f3xc8SoBbQlZWbovJ43b4humWZX+jK5h4u5xrqvhNzBm1u+4phA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF6BCF148B6



On 10/16/2025 10:58 PM, Sean Christopherson wrote:
> Register handlers for signals for all selftests that are likely happen due
> to test (or kernel) bugs, and explicitly fail tests on unexpected signals
> so that users get a stack trace, i.e. don't have to go spelunking to do
> basic triage.
> 
> Register the handlers as early as possible, to catch as many unexpected
> signals as possible, and also so that the common code doesn't clobber a
> handler that's installed by test (or arch) code.
> 
> Tested-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 8b60b767224b..0c3a6a40d1a9 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2290,11 +2290,35 @@ __weak void kvm_selftest_arch_init(void)
>  {
>  }
>  
> +static void report_unexpected_signal(int signum)
> +{
> +#define KVM_CASE_SIGNUM(sig)					\
> +	case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
> +
> +	switch (signum) {
> +	KVM_CASE_SIGNUM(SIGBUS);
> +	KVM_CASE_SIGNUM(SIGSEGV);
> +	KVM_CASE_SIGNUM(SIGILL);
> +	KVM_CASE_SIGNUM(SIGFPE);
> +	default:
> +		TEST_FAIL("Unexpected signal %d\n", signum);
> +	}
> +}
> +
>  void __attribute((constructor)) kvm_selftest_init(void)
>  {
> +	struct sigaction sig_sa = {
> +		.sa_handler = report_unexpected_signal,
> +	};
> +
>  	/* Tell stdout not to buffer its content. */
>  	setbuf(stdout, NULL);
>  
> +	sigaction(SIGBUS, &sig_sa, NULL);
> +	sigaction(SIGSEGV, &sig_sa, NULL);
> +	sigaction(SIGILL, &sig_sa, NULL);
> +	sigaction(SIGFPE, &sig_sa, NULL);
> +
>  	guest_random_seed = last_guest_seed = random();
>  	pr_info("Random seed: 0x%x\n", guest_random_seed);
>  

Reviewed-by: Shivank Garg <shivankg@amd.com>
Tested-by: Shivank Garg <shivankg@amd.com>


