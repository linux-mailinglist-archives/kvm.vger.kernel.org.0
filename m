Return-Path: <kvm+bounces-41481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38926A68753
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 09:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5DFC7AAE54
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 08:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45A1C25178C;
	Wed, 19 Mar 2025 08:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L74+0geg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2040.outbound.protection.outlook.com [40.107.212.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A16F211484
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 08:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742374559; cv=fail; b=uC9kd4OQeBKcNjdXbGVbaojZQmO0chjA3zRc7vJMZCp32IMda8q+KOkNtQYdTrf5K4ggytnFW2RE3Vg2KfzAidVq9yErung0KgIng1k/0/gMc4FhxYPlg+hgh2QevJDhIVE9zbihZ7X+d3BY+ogGRkLQddDt6+Zt5OKRhFMoIjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742374559; c=relaxed/simple;
	bh=Y/xl+s/YQKsHPau2IVqgiZIyULvwaVl/ttMkOFHCEqk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=inFjIodTuAyt1h9vJRY5OlHzF6NilpFiu/FpmCg/53sVBVlEVA5O5W6+HLp0bsJeSXlQSkrG6POVFsufJFCusKtdsR/ez98QBR+r+AAtuD5P/bR7RSBGYocdDkn8Xmym+jPA6PpSJg6TuovwJfc16G3aDHngZLQ8QaZje28OA08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L74+0geg; arc=fail smtp.client-ip=40.107.212.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AxfoTXD1Wo3SfX6avQ68OvE7ZxBgq3ow5lYp8nvwT+tc7ENIrPSz14YOQKDXJYWPAL5V62dl+9694Zh8cmnF7oZdGDlmh5HU7AY/4io5XlFGXTlSiNT8VlBNUolWJOFeED0yS0SLFmAOp/lSfZqpRYanOT3xBD+YyENO2QHsWJAnuT8K12a7k7F8+Q1MvSgoD4U1l4TwjJNqTPKLDjVN6jkCed16cYcvrq0D3HuDx5kEUY2mITn5Gr5JO8nPGxh07R/yGaWMxe1/b3zcGsITkRfOvNQSguKDgD7yi2bteqOsINB5yz0soI2ZsbKlXD0Lt1GZ6oBUB5+Yh8fRRZHQcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WlZGfHApAiUuPAc3wERGU/iPdgA/Vg+RDbbiCgK/e0U=;
 b=UdqHnOtLDo6gpeHr6G2fOqOLfXQ8UXd4aNYusdZFEtQF0U6o7wBIVgNfJhiiflW8VzKC9wgq0rNV25pmgVrqZvEuZxlXkiv8D6e0MT7PdTXgXS68PaFKls8Xd3+B1LsyANw1mKjG5+M3l0LDWSLorZCbNwxJKHR6SzXNCTKvvWlTXQozulxKGXcnpNGKlDQwG+1KRLv/JCqEbUKx07UZgsKaly40GLCOQAW1iPsUy31xQT8l9tzXdDtP725I3jHFuwKB0rza2HtGZEbUW5r1iNVGxr39x7hB4mPK7myku63Ve78ArzKvfOwjbN2VFoHIr8yIeOXBo2CWzuNbpa0gqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlZGfHApAiUuPAc3wERGU/iPdgA/Vg+RDbbiCgK/e0U=;
 b=L74+0geg1P2L4FdvM6uekqCYKdQlMyzAFPjnwXN1m5/KOoG5sLDw01x98U5ZIOTrfCFGXVn1kb1hYWOlBwWnI9knct1+tAdDzC2wv1GjlKZmXIKUybflXagnUyCE/MzPi8Elei9dCTz+SWNMptub0+xQXBinbbnAyHyqwQPR2WM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB8200.namprd12.prod.outlook.com (2603:10b6:8:f5::16) by
 PH7PR12MB6694.namprd12.prod.outlook.com (2603:10b6:510:1b1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.34; Wed, 19 Mar 2025 08:55:54 +0000
Received: from DS0PR12MB8200.namprd12.prod.outlook.com
 ([fe80::e3c2:e833:6995:bd28]) by DS0PR12MB8200.namprd12.prod.outlook.com
 ([fe80::e3c2:e833:6995:bd28%4]) with mapi id 15.20.8534.031; Wed, 19 Mar 2025
 08:55:54 +0000
Message-ID: <4fd73f58-ac9a-4e24-a2af-98a3cbd6b396@amd.com>
Date: Wed, 19 Mar 2025 09:55:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-5-chenyi.qiang@intel.com>
 <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
 <3907507d-4383-41bc-a3cb-581694f1adfa@intel.com>
 <58ad6709-b229-4223-9956-fa9474bad4a6@redhat.com>
 <5a8b453a-f3b6-4a46-9e1a-af3f0e5842df@amd.com>
 <9c05e977-119c-481b-82a2-76506c537d97@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <9c05e977-119c-481b-82a2-76506c537d97@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0261.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::17) To DS0PR12MB8200.namprd12.prod.outlook.com
 (2603:10b6:8:f5::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB8200:EE_|PH7PR12MB6694:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d579e3-ba46-4738-201c-08dd66c3db42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WCtBaWhBZVVWQk1ZM2NUbUlIYktMQmduRy9adEF5OVZuS3IxVFQzbUtUclVM?=
 =?utf-8?B?NHpnbzczYzczUXQyN3lrUjAyODg3Rm1kdVdzQXdySFhLTEswTjkrQVBRNlIr?=
 =?utf-8?B?a05OM0hKT2p3dkN6QVdDUjg3ckVjczF0Ny9kN0txVWJ3S0FZTGJnSkl4MkE1?=
 =?utf-8?B?akZZVXYxeHl5bmFxSGdYUkVKNzJpeGUrZUJGVnFlUTJPWXpsd3Z4V3Yza2Y2?=
 =?utf-8?B?a2pCNDB2amoxME51L3dPaDhQZHZGWFl5SnkrbWtoZ05QUTV0R3lsc2pSaEg3?=
 =?utf-8?B?OVF2YmVPQXBsSlEvQmdFcWNMRmFoTTM2eDQ2TDhRY2s4VjNwODAxUEY2M21p?=
 =?utf-8?B?UEdEWE5PQXZyMFRLK2ZsOW5TUFY4dmtuL2t0MzhKUEVyQmdmUnpwRWhTK2c4?=
 =?utf-8?B?RlhjRkVmVG9jMmR3SVNlTnZ4MjViR2JZOEZadmVPVjRpQ3dpZGczbXE1VUFH?=
 =?utf-8?B?K1BDSzI1dEZuZGJ3c3Rja3VGM01vb3RUaHhGR0VhQWxGVFFOamFXdk9KOFB1?=
 =?utf-8?B?ZklnNDBYMU9sRUdWYXdPRHorUVB3Mm54RkphNDYrVnZ3alAxUXg3SUZKRUlu?=
 =?utf-8?B?cWhTV0pTUU84YVdYR3ZrQ1FmWXk5ck5xUDVhdC9xRXIyY0VuUXFnc3dxZ3Iy?=
 =?utf-8?B?Z29SSkVGMW5pckoxUDFWRm9KZzVvUXdacUZLeG85dkIrZ284UGZOeldnSjBi?=
 =?utf-8?B?TStISEFodXpON0xtSlZJcnZvWDBmcXZiK3kzYTRwMDU1a3NQaklHZUlON3hn?=
 =?utf-8?B?VE1BZkswNVhhc3A3MUF5S1l5b1NaaUlmb0daOS8raEg4U3M5ejRhVXBtMEho?=
 =?utf-8?B?TTVuSnpUS3RrVmJnSG9CSGVjTzlKZ2VXdlovelprOGhqUXNIS05QWUxJclh5?=
 =?utf-8?B?VlZEREkyYnI3ZmlUNklmWDJXeGorS1U2YVZvWHlQckZ4V1pLVDJBRCt2YklP?=
 =?utf-8?B?ck9ZZDNEcXVZQUhyUHQ0VFdUK3FRTUx1aEpDT1A0YlVabWpBSHBkN3BSZ1RI?=
 =?utf-8?B?ajljL2JENCtmd3JpQTUrTnNVdmIyVisxLzdFVmhZcmI0VWdiMFNQY1Q4Tm5a?=
 =?utf-8?B?NUpac01POTk1YXVWMkQrbUs5dEM1a1JLZjV0TXFwbzFucjh4bXRFNk5mSGNZ?=
 =?utf-8?B?cGZMLzVXdzdQQjNIeWNUQXFaVVlZK3FhRlRBSVB6NU1rTzVrMDh4S0Z0MXlB?=
 =?utf-8?B?QWhtL05FTTJDOVpRK2M5RnU2bStYU1plc1VCMTQwZEs2YXkxWTZ5cGV2MnNF?=
 =?utf-8?B?Z0dqbW9wcWV3OHljSjkxSGVKbDBPbzgwL2JySjQ4RURGV0hZWlpDZHBJa2VI?=
 =?utf-8?B?UWNFOEJUTlU0R3o5Y2Zaa3dPWnZuVUtNazNTUC9vOVFjRXVXcjF6NUlDdHVT?=
 =?utf-8?B?K2M2dStSQ3VHUWltS3dmWnEyQ0QwWVh4V0piVGovM0xCQWN2UlFmQUtEd2pU?=
 =?utf-8?B?enBpNnRaNU1PMVFmYzZUTlRaQVJTcEt6Nlhxa0FybkFHNytmbFR4VldJOUR5?=
 =?utf-8?B?amNlNm5xMEZsNXNDWXNnTjIwTXU2dEpFMVV3YkdKdUpaQzA0Z09qc2prb1Fp?=
 =?utf-8?B?QmttWWZ3R3ppRHNZSXZndHp2cmdhd1VBKy9uK2dZa2kyK1gzTS9JQy9SenBD?=
 =?utf-8?B?anU3cHF5akM3UlVaSDIyYmx6aWZCSWNYQ2RkN0w0dVFYd2FXYVNFNXZuLzNX?=
 =?utf-8?B?NkNiQlkwVVZFejBIeWQybzErdE1aTU9wWXk1T3lNR3lGUkhqc3diVVBnZ2cz?=
 =?utf-8?B?Y2dsNHZrYlRWSGZoOTZYN29MZVRqZ2FBSloyRk05Z0s1L01rNWpQZlpSaldY?=
 =?utf-8?B?YTQ2RExmTllhQlY3ZC84MjVZVGFsb0JlMU42N1NsemtJVzBRUUo1ZUpwSVlz?=
 =?utf-8?Q?ZOHLO3Me3sDFV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8200.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OCs2c04xd1NmQ00zOE1JajU2ck12QndSMjBwQkMzTlZ1d3hUVXk4eVptRy8w?=
 =?utf-8?B?VGkrQStGbnplNkIxbFM5cnhSOFhBTml0OEIrR1RYVTgxR3ExUEMvZW5FVGhp?=
 =?utf-8?B?WXJmVG5uRU5JdDR2WUZ6dUM0QzVkRHhUQVgvSmJJRFRUR1pVcE9lTHhMSkM0?=
 =?utf-8?B?SmdMUjY2SnR6d3VRVHJoSFp0alFVSGhiZGxmYnplY0R1b2pOUkUydDk0bHdQ?=
 =?utf-8?B?OVhmdEdnTXZINXBwb1FRTjRUUFlPeTF5aTA2dllJdzZFclorc25XZkxXekdv?=
 =?utf-8?B?RWgvMHBicjlpbFZoMHhsUDAvZDVzRWNyQ0RmeUxPM0t3WHhLdkJidUN0TlpV?=
 =?utf-8?B?KzR5RzJtYUlJQ0V6ZE1vYmlldjhLWXlRODVBSmFOcXd4Smk4RXQzOVhEVXc4?=
 =?utf-8?B?UnQzYmJLNXR0MHFLZzFvbDdBRE9jcU95bWFkRFpQb1lLWUxxYXZRU3c1VGFv?=
 =?utf-8?B?Q3pEUnN6L0lPMDNKSTFrbUlJQTBnbTBQYUcwN25zTFdVa3NvQm1nK1dvRzJV?=
 =?utf-8?B?YTBOcmZqNFhRMzduRW5za01RZzRpWFU5dzE3RmVRdUt5VmI0aDg4bjZHQlE3?=
 =?utf-8?B?OFVZUFJrUTRTNmc4akZZZFFCbTZuN29uZWtVb3kxaVFmWGtHYVhEU3ZqdExo?=
 =?utf-8?B?WDVnV3hUUWdyQXJvRkl2NnZzQ1lqTnBONWd4V1hZWVBKa2hFWUNMby8yVFR2?=
 =?utf-8?B?bDVwT2N4ZkdoYm5haTJXZHR3Q1F1THFsek11ZWg2dWg0amJCSDZ4K1dTSEVs?=
 =?utf-8?B?V09kbVRFMHVtZkdxR3dlM3VDZ1BKY2Y4UUd6K3VXU1JmUzZpWW1BcVJaZkNH?=
 =?utf-8?B?Y3czaDBZQ2hUZ0ppazdmaWRGcmNaUzhKak5uNTJ5ZGorWEdPSEhxcTYyek5m?=
 =?utf-8?B?YlpaK3IvZlNHVSttQ1V2YkJyd1N6VnZFSU5FZm9TY0MyVFdYTFhBUWZ4enJZ?=
 =?utf-8?B?RzBIZXRORUtTRmVSTHBLdXBuWVJhazh3dHcyeGpMUUUwUnJ6TnV3UUl5RjI5?=
 =?utf-8?B?MitmNmN4R2dXeTVkSlBjRXYvb2pyMW9PQXFEWklwMkhHdFpoTHJJblprYzRI?=
 =?utf-8?B?ZUhnSm1UeUZjNHREeDVDbEpYcmN0Lzcwd1ZpZi9oaysyWUVqb1lQckNjYjl3?=
 =?utf-8?B?S2NzbzJJZndvV3BlaWVYTmEwYy9uZzVTN094cmo5Ym9rZktZTlFlUjlja2pO?=
 =?utf-8?B?UnhZbGh2MkxpV05raTgyVVN2ZHJUSVQyUFJUdkNaQjBCTXVIUENZU0JWbGVF?=
 =?utf-8?B?b2pERHhWeXZtVHF0aXZzcDVIMW5ySFVuK3lIdURNMG9DQ2ExU1lhWmllY0pi?=
 =?utf-8?B?WG5hSWdUbHBidjR3TXE4enZUdEZCZlF1TzBFbERFQS9wTURWaWtqc1VUYVdj?=
 =?utf-8?B?OEt1Y2pBUkZmdFRCSm85TWJVTGIzemdyaU1xWFJlelhjQU5DRlo2M0tMTENW?=
 =?utf-8?B?RTAxM3dIOHZWeGdweFRiLzNmZmc5T1BKUHRaTXNmZXNpQTdxbEpRTGUxd2l1?=
 =?utf-8?B?WUlMdG9OWitJU0lVbjcvU3dEOWdLRnRTeERCcDhaYTRieGdQNnNBMVFKMkxm?=
 =?utf-8?B?eUlEdit5QzRaMzIzZWRRcyttbkJzQTBBRVVPWTh5Qi8xbmxZeDVCdTJZakwy?=
 =?utf-8?B?bm5IMkJJbU1jclQ5NnZwdzIxZElBekNObzVpTUV0WTNGSjd3R1g0eVBmTWVF?=
 =?utf-8?B?QnFzLzQ4UE9WNUNVRE1VODRObkdJUThTaGxGKzQ5a0k5a2x1VEkxWGZQS25o?=
 =?utf-8?B?YTJmdDc1SnN1dmZXTkZ3cG1uQmdZM0d6c3pDcWh5azUyaUdvNDdwbnFES1Ux?=
 =?utf-8?B?Z0FYYnJPaXVoTUphbzBlSHo2SDAyRTIwRVBTMENTczVPdmFldXhkcjZ6T25i?=
 =?utf-8?B?ajdPNTdWNGVsSU8rUWQ5alQvLy8vcXJxRTl0SjRacVRWQjIxdWhwRWJSVkQ1?=
 =?utf-8?B?eXRaQkhpaUlkWnMwWWVKTUhNaTMrQVlYN2Y3NFUwdFVabDJFNDNadnFLRmNN?=
 =?utf-8?B?MkMrVkMvajVMOFc2U1E5OXorVDFOcHVtWkpXaDRMZnZQZVQrS2ZuTW5FSllh?=
 =?utf-8?B?dWdGcElCYmk5UzI5RG1zSTBhY0dZQzh1NlBSZHdMbVBIcUUwcEhDN2R3YmV1?=
 =?utf-8?Q?XE0Kq3aaJQPPk42a/VV4A+Sqk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d579e3-ba46-4738-201c-08dd66c3db42
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB8200.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 08:55:54.2067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4hudG9vpbBW1DFYj2ZKUQ/2dt7rMT0WyjEjMW8DGNyQqrDpbnPjs4Hk63LcEYvn4M2nUniOcr58McpnofkM/Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6694


>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO may
>>>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>>>> operation to perform page conversion between private and shared
>>>>>> memory.
>>>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>>>> device to a confidential VM via shared memory. To address this, it is
>>>>>> crucial to ensure systems like VFIO refresh its IOMMU mappings.
>>>>>>
>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>> adjust
>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>>>> back in the other. Therefore, similar actions are required for page
>>>>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>>>>> facilitate this process.
>>>>>>
>>>>>> Since guest_memfd is not an object, it cannot directly implement the
>>>>>> RamDiscardManager interface. One potential attempt is to implement
>>>>>> it in
>>>>>> HostMemoryBackend. This is not appropriate because guest_memfd is per
>>>>>> RAMBlock. Some RAMBlocks have a memory backend but others do not. In
>>>>>> particular, the ones like virtual BIOS calling
>>>>>> memory_region_init_ram_guest_memfd() do not.
>>>>>>
>>>>>> To manage the RAMBlocks with guest_memfd, define a new object named
>>>>>> MemoryAttributeManager to implement the RamDiscardManager
>>>>>> interface. The
>>>>>
>>>>> Isn't this should be the other way around. 'MemoryAttributeManager'
>>>>> should be an interface and RamDiscardManager a type of it, an
>>>>> implementation?
>>>>
>>>> We want to use 'MemoryAttributeManager' to represent RAMBlock to
>>>> implement the RamDiscardManager interface callbacks because RAMBlock is
>>>> not an object. It includes some metadata of guest_memfd like
>>>> shared_bitmap at the same time.
>>>>
>>>> I can't get it that make 'MemoryAttributeManager' an interface and
>>>> RamDiscardManager a type of it. Can you elaborate it a little bit? I
>>>> think at least we need someone to implement the RamDiscardManager
>>>> interface.
>>>
>>> shared <-> private is translated (abstracted) to "populated <->
>>> discarded", which makes sense. The other way around would be wrong.
>>>
>>> It's going to be interesting once we have more logical states, for
>>> example supporting virtio-mem for confidential VMs.
>>>
>>> Then we'd have "shared+populated, private+populated, shared+discard,
>>> private+discarded". Not sure if this could simply be achieved by
>>> allowing multiple RamDiscardManager that are effectively chained, or
>>> if we'd want a different interface.
>>
>> Exactly! In any case generic manager (parent class) would make more
>> sense that can work on different operations/states implemented in child
>> classes (can be chained as well).
> 
> Ah, we are talking about the generic state management. Sorry for my slow
> reaction.
> 
> So we need to
> 1. Define a generic manager Interface, e.g.
> MemoryStateManager/GenericStateManager.
> 2. Make RamDiscardManager the child of MemoryStateManager which manages
> the state of populated and discarded.
> 3. Define a new child manager Interface PrivateSharedManager which
> manages the state of private and shared.
> 4. Define a new object ConfidentialMemoryAttribute to implement the
> PrivateSharedManager interface.
> (Welcome to rename the above Interface/Object)
> 
> Is my understanding correct?

Yes, in that direction. Where 'RamDiscardManager' & 
'PrivateSharedManager' are both child of 'GenericStateManager'.

Depending on listeners registered, corresponding handlers can be called.

Best regards,
Pankaj

