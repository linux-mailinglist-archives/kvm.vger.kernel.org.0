Return-Path: <kvm+bounces-34763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7629A0598C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 12:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1758F3A1376
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 11:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58141F8922;
	Wed,  8 Jan 2025 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ll4IlHuh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7862A1F542C
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736335258; cv=fail; b=Ns7rRK5J8Lw5bUiUNtPPQuqhr7y/z2vpIEKRQ4shlrXVo+UYjyuwpQr7LOC/+CBRP7b32xZPV9Z8M5JVzY04ulR6+DXWlv0Hy9d9CB8YODXLebiVGPa30EkLJ2rxel9A9iHZpbZ69flWU5bkI8DUOWGJhNMykwV/815M8u8/4Xc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736335258; c=relaxed/simple;
	bh=i9uCXC1+BLqDe0yJTauSwqsJeZpMEyh9Z1onyi4QOFY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ovlESg9r8wKH/EmPHgkMTHTJ14UxsGKXU2LfAAEYJ9nlnPFmnSVR8sZEbykgiYGFbeWs2CU/6PsFCUctPUQs6Y97PveXjXPHHxVbd0PzpmVXrnF3qyUnIpyfQsvwKxbjCeK2dUDgZM5srVPLCtrZTi7NlsOblbXgtL6sAcvGE9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ll4IlHuh; arc=fail smtp.client-ip=40.107.92.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qyPmfGbj9YLjQKg6RR9i5gR5VeO7Hrn+bIo1TupiLWfz8oY2jIVsckznnPE6A+UOX698nwrhSqpafJl0C8qmHCbIYhgUp77+jEr+qb0oEdusxjtjkKnTlj07z2iHVK758gIrwIQYxssT+RG/wwm7frF5zt/8/XEsGibpV7buDrkXozqEj4cGchPRlytQJ/yzbl0RqFx0tvCnXEgCKJRZg18xMMSENNIaq6a/bWsZbdmDjo9JJymrL9zAlegMrDj5+z6j29UkIQog9/vGBMwpmTHDAgLg4moandfaZXSa4Zf0eOOJshY4y1RzuvPB18Ef+sLXn4Sv0lYp5oxhV4k5SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUH9wDwTYXnfVYzswwnwJGvo4cvkK47TXya/U/vXF+k=;
 b=hOunpdsBthO+ejfFThwfQRLRIjB56PI2iddERPvYHJf6I4wD+OoHSJJykRzZka0JKqs5/JubJ+LOfQ90fVr5/WfAowk9GZXAaAJ8ZNmQY15q2RfcqP/MWTHS6PCZW0VMuGSQFTGUnqTHa/6OsC0D1HOUg2O7NYMExFFojoPxzpQl04XbM34pdyVHKktbTjY7jeFpk6vi9QOvuTMCVWBnx08Btkdy6ykTUVxo93QRA3Y+X+8c1ZHGcZQAWvVIKdJ5qCzMXkixEEZplsf2UH+IT8OfRsugJ8xYW4nskKaz6v0RJfw9ydbH0yHyfXkWU7hf47rAy8jim2VXMNSPGRUj1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUH9wDwTYXnfVYzswwnwJGvo4cvkK47TXya/U/vXF+k=;
 b=Ll4IlHuhyyB5exyindsmMG8zSFLQGw0NTZltWDdakyymNbLtsU4tbMIiL+L5b3hpaBdI4WF49AkZvO9kwIjja52VjZs2Em+nUglmbVXn2a2sk3jq5MtSFLK8QRtGc3kKM0qtNRiFvYDcPsxkLmen36rBf+LkPGBLQWAypjja5iw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CY8PR12MB7490.namprd12.prod.outlook.com (2603:10b6:930:91::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Wed, 8 Jan
 2025 11:20:49 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 11:20:48 +0000
Message-ID: <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
Date: Wed, 8 Jan 2025 22:20:35 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TP0P295CA0044.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:4::6)
 To CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CY8PR12MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f3dddb8-83e2-491c-e4f6-08dd2fd680a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OG1za2tFaDYzRXN1Slp2WTh3d25Rd0ZUeDlsVUFTbGpHRDlDMFlBTTVUcmk2?=
 =?utf-8?B?ZlhyV3hqSGNoSXhsYnhQc005ZmgrUjJ5L2ZieUdMSDQ3YmV1NHgxU2tIa1Ar?=
 =?utf-8?B?OU93RjFabHZST3Zja1p5em5yUDV3N3VjS2Y5Q09XUkFOSFI1YlRJeGtpTUhO?=
 =?utf-8?B?MjFTTHlhWURNR0ZSbmlGU1lEc0tlRzFZbS91bmZwdW5ObDAxNzVVdGIxVjdF?=
 =?utf-8?B?c29NdmtWNjVvYVhvcnhiYjFvVlUzNXNTMmRxUy91c29tMGV4NGxJUnhLQzFl?=
 =?utf-8?B?YVZaa0haRzFFN0VUSE5BYTZyTnJheHVmT3U1MFVldnNFQXJ3cjJncnlBK3BH?=
 =?utf-8?B?dUltNjUvZUVJMVJSOUh2bmVvTGR5T0RlVHdVN1Y3M0FPQTJWYThUQjRUY3U5?=
 =?utf-8?B?S2NQS1F2L3Njc1hJVUlaa2RScXMyY0padXBFTnFqaGFrNUF0V25RNDRjMXZM?=
 =?utf-8?B?ZW85NDg5VndMcXMyL29WQjUxVzhTRExJTDhNb2gyNWpMU3JvekpOMHU2dWl2?=
 =?utf-8?B?eDJ1ZUpxbGlCV0VWN0wwT0dMN2ZGY0hrQWRkcEZKT0tZWGg4NGFGYWdzNDFR?=
 =?utf-8?B?cm1EK2ZSSUs4VHFpUEJYcWNrdXNLdHpVZGRMQXU0TkJFN2Yxc3hzQm83ZDhN?=
 =?utf-8?B?UGtZL0tYUm9JQjlmNDN4Nm5Bb2htMDkxakhDSGhVNkFnUVRCVGJwaVRkbkFV?=
 =?utf-8?B?WlRESXhXSStxdU9KNFo2dzc2TnBJRjVXb0FQMlIyQjZ1ZTliNGFMMk9RcWgy?=
 =?utf-8?B?ZDgrclBvaW0xNDJXVzlGdko2YnhtUElSaW0vMHgyUTl6UC8yL0d5Z2FpTlN3?=
 =?utf-8?B?WW9aTllPS2puZDQ5SVZDRDdRdldPd1hyVFVZZndxZ0ZxZ1UyME9zTmlMeGVN?=
 =?utf-8?B?OEVsT2Nxd0ptZS9FdFpRMXV2akh5c0JiMUdOeWFNWkpwR3V3VzNRSFRuZk5n?=
 =?utf-8?B?NGFtYTc0YlVrOTFYV09TelhJZlMwTW9oeXNvT2wvN0JpTDl0S1lZbURFc0VG?=
 =?utf-8?B?NjVRNXVKQ2l3RG1jT3B5N0NtTDZEKzZLeVlBb3hsOFdWSS80SnllMm9xQnYv?=
 =?utf-8?B?RHpPendRcGh6NTlLZkR0MGVMV0VPQTRQVWg2RC9yVjhTeU12NFVKU0lCWmVH?=
 =?utf-8?B?UldDZTZMQ1VlQ1pFZDRvNlBvNUJuZjRHQU9TcEx1UnlCRXBnNkNiNkJmUzdq?=
 =?utf-8?B?YjBXUVk4TEdhekp4ZFcyb0F5OWFSODBFNC91M0NkOFZjdGIwL2tWR0FXVXgr?=
 =?utf-8?B?SmE3eHQvNkVvZCt3cUM3eFRvdExCdGgyS1o2TjdqazgydzdxanRlUXM3a2VI?=
 =?utf-8?B?alFicUgyYnl5VFM0RFZRTGI5eWVGak50MElZTW4rSWNDQmViWEl6NHNhTzdZ?=
 =?utf-8?B?R25qZ2dkd0krcEloaFhOcEtYUm8waitybWhPS2lWMzljL3YyQjY0T1ZWVy9C?=
 =?utf-8?B?ZVVHNWFqNWwxTSt2NG9veDRPYkZSRmZld0x2OFczYWFYV3JwdmhsRDBkZWZJ?=
 =?utf-8?B?amQzRTR0dlAyNjRNUS9HdTZJQithd1BwM3JNa1RFNXk4S0NqWWJwQ0RMZHZn?=
 =?utf-8?B?WHFaek1jMGlwSkxzUDhUWExzbER0WDRhOENJT1Q4ODVYaDFiSFF6VS83TzBt?=
 =?utf-8?B?eW1saW9oYmR1dUFUeUZEZER3TWdETCs4em9LdHA4a2R6RWRvSTFnWExrbHNp?=
 =?utf-8?B?UUZZeE1LL0tnVTYrOUNMVzNldS8weTZtMkpIbk5ySTVrSzhtMS9hQ1BEMFQw?=
 =?utf-8?B?RXc5UTllUXVjb1d1NFRiMU1uSTdYamZsU3IvMWlRUWdkZXZhUUkxUFpMM3Va?=
 =?utf-8?B?V2tmeGFSNmxaN0ptRGsydXl1OWdPMFZiSXJ4RnBiMWNpTzJscVJRWmhvKzdp?=
 =?utf-8?Q?Xj70ig+vArG1i?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmJmUHlOQjlvdHZsUVNsSXRYcFlERHNVSkxPMGw3MDBRcmt6VkZHR2s3TDli?=
 =?utf-8?B?Ym1iQTdnUmVjQWUyWlIzQ2hEREtSM1NLMVkvUmIwVStMYytjMjc2WHlpMXhX?=
 =?utf-8?B?eFNwZi9NcEZTTFRtQU83UWE5WStDalJkV0o4Uk1FWWNwTjN4WmhHNEQyaGZ5?=
 =?utf-8?B?YTFmYy9CVEJsR2JrVmlnUndNejEySkd1d2Y1YjhQTjZ4RkhRY1dYcWdLS0dV?=
 =?utf-8?B?MjN2dHFyVU5XWFBrU2IzMzdDMTVuWFdkREdBaklHZHZGaGcraWJOQnE1SUgx?=
 =?utf-8?B?QmZlQ3gxMkZ4NmhaT2VPbHlqbS9lLzZJZXpYbVkycDZrVFc4czZKK1dRNEw1?=
 =?utf-8?B?b1IwbE1HL01mb096WU91OSs3a3NxUzhtS0t2T2x4dzFrZTNIN0N0Qkh0MGls?=
 =?utf-8?B?MEkvTkVvYUIrcTY4TmFBMkNzN2UrYjF2YVhzRW40RjJaSjFheXlxWEt4akRu?=
 =?utf-8?B?Tkc4SWY4dld3OXZTb0t6R2RrS2FsbW1LenkxcyticXpHQWtGWVJOaGFzc2sz?=
 =?utf-8?B?RUVYM3c4ZkxZdEwxZmlqOXdURUFJdFVLN3VjSlRZempkTXlNS0VTdndJa2VW?=
 =?utf-8?B?Y1BSSUo1aDU3MDdqbGR3L3FPUU1RdFkwOUdOYVZZazJxeHNwMEhXMG1LOWZG?=
 =?utf-8?B?UFN3dkZzT3RvMTNZQzB1NGFjM0JkbnVKWGR0ZlhFZi8xTnhVSGZqZUdhRFF3?=
 =?utf-8?B?dUdkUHBsKzJ5N21pMmhPbVAxWndNNVNYaC9YbmROWVVMS1QrYnZIK0x6Mk92?=
 =?utf-8?B?ZmJ3TUliSFllL3B1MGp4eGYxUjRCNWVHMjd2eVBScXlwWUF5UUc2N1NQNUQv?=
 =?utf-8?B?OEpEYUwzK3hXcE5nelRVQm9zVXZkaDN6U3UyWE82bk9aUnAxZ1I5ZE4xd1Vp?=
 =?utf-8?B?RTljdCtCTCs5d1RLQ25XenFDRXdWblpRUHlQeUE1dXJubnpiRFY2ZmUvR24v?=
 =?utf-8?B?SUc5RkhpWHBiVVFtc3ZaRklBT3pMQWxDdnozWnFqbXlEeFZlRjRWTmZPOTVG?=
 =?utf-8?B?UDhlVGxUQTFvckNLNVB3M0IvZG8vcUhCckYyWFNIeGNKbFBHM2JoRHBCNmIr?=
 =?utf-8?B?MzJwV1JqaGR0T0dFVk5CY2dWdnZNc1ZjWEtiWUxMR29HK09yN3JtUjNJbW5v?=
 =?utf-8?B?L3p4VWJQRjh0STdXbExETFpSRjdrL1k2YlRrUVNmSFQxMmtFNk9UdGN2K251?=
 =?utf-8?B?bDdPalNhSWZ6VlE3Qkc1aVl6V2FOcVkrUG5ySlkyRzhhYW5NZWRlZ3FjMmVK?=
 =?utf-8?B?Mk5KUmFkV3kwcWNzVEl3cmVYenR5RE0xRmVoRE1td0ROVUs0aFNkU1Nzb1Ry?=
 =?utf-8?B?cWtvMUhIbnhUZEpCem11V2VlblVVOFNXOVRGTFNrR1JFNThCSUQvUHdoTm00?=
 =?utf-8?B?dEVDcDEyUFpMMHdIV09YUjc0ZUY3Q2dsSXhlcnMzRlJVVTl6RVAvTWJ1S2Vq?=
 =?utf-8?B?Wm1pdk9NbURBRjJWenJ4bFB2V3cvaVI3Q2hRdmdRSU1kL1N4NmVxRE5EWUhD?=
 =?utf-8?B?V2hvUnpYeHRlMHRIa2t6eFNpWkRBcEkwOThLSloxZWJlZ3BOT1M0bTdha29h?=
 =?utf-8?B?SnVLV1dhZ0dWeVY1dml3b2grZFU1UnRwTEZLNjd6VjErbFRyR1ZWU0lLdWln?=
 =?utf-8?B?Wk5SMEtyTzFabEkrbTk4QnVQMW1NaktqemdDUWFUS0tUS2crK1BVZXBvWVFh?=
 =?utf-8?B?R2l1Z1FLbUlLakIrOFFhY1VNSnhRdENTL2lEeHVYdDU4SGpIYUhRamY0N1Fi?=
 =?utf-8?B?ZXFyNG5aaDVxejZzTExaNUEzYldKNnVnMHF1SXM3WnEyRUpzZFhFOGxXQTNa?=
 =?utf-8?B?ZVg4N1VuYUNDN1lhQUw2YkU0dzNzZmtMdDYzdVF5bmNFQldML3VYaHZjNUNl?=
 =?utf-8?B?czNnQ2dzREx4Ym1CN21JL1BOYkhITjVVN2EyckxldjJLYUM4bmt1RXZzWm9I?=
 =?utf-8?B?USs5eEEvYVh0YkRUSEkwaDJua3dEekE0eHlqdDhobVRJSnoyT2FEQjk5eVlQ?=
 =?utf-8?B?SjZWSGJiOTF3cGI1ZGFtdHhNd0xlN3plK21jMlpVN05lcklteHh6SFptT3ZF?=
 =?utf-8?B?T1VMV3BETmgwK3k4Tk5GOEdqTVpMYmNNZzdRVSt6V1FielJkelc2ZGxySnhN?=
 =?utf-8?Q?s+GBrseS+XuCSPSiyjH5anq+I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3dddb8-83e2-491c-e4f6-08dd2fd680a8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 11:20:48.5998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8zMl2N7X84R/6suhiFuHe/irAFBccqz7GdNP62aJxC0d81JeSMJoljG6SH6NBGpcc/4vIStJzGuCWiepR7GPog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7490



On 8/1/25 21:56, Chenyi Qiang wrote:
> 
> 
> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>> uncoordinated discard") highlighted, some subsystems like VFIO might
>>> disable ram block discard. However, guest_memfd relies on the discard
>>> operation to perform page conversion between private and shared memory.
>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>> device to a confidential VM via shared memory (unprotected memory
>>> pages). Blocking shared page discard can solve this problem, but it
>>> could cause guests to consume twice the memory with VFIO, which is not
>>> acceptable in some cases. An alternative solution is to convey other
>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>
>>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>>> VFIO mappings in relation to VM page assignment. Effectively page
>>> conversion is similar to hot-removing a page in one mode and adding it
>>> back in the other, so the similar work that needs to happen in response
>>> to virtio-mem changes needs to happen for page conversion events.
>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>
>>> However, guest_memfd is not an object so it cannot directly implement
>>> the RamDiscardManager interface.
>>>
>>> One solution is to implement the interface in HostMemoryBackend. Any
>>
>> This sounds about right.
>>
>>> guest_memfd-backed host memory backend can register itself in the target
>>> MemoryRegion. However, this solution doesn't cover the scenario where a
>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
>>> the virtual BIOS MemoryRegion.
>>
>> What is this virtual BIOS MemoryRegion exactly? What does it look like
>> in "info mtree -f"? Do we really want this memory to be DMAable?
> 
> virtual BIOS shows in a separate region:
> 
>   Root memory region: system
>    0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>    ...
>    00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM

Looks like a normal MR which can be backed by guest_memfd.

>    0000000100000000-000000017fffffff (prio 0, ram): pc.ram
> @0000000080000000 KVM

Anyway if there is no guest_memfd backing it and 
memory_region_has_ram_discard_manager() returns false, then the MR is 
just going to be mapped for VFIO as usual which seems... alright, right?


> We also consider to implement the interface in HostMemoryBackend, but
> maybe implement with guest_memfd region is more general. We don't know
> if any DMAable memory would belong to HostMemoryBackend although at
> present it is.
> 
> If it is more appropriate to implement it with HostMemoryBackend, I can
> change to this way.

Seems cleaner imho.

>>
>>
>>> Thus, choose the second option, i.e. define an object type named
>>> guest_memfd_manager with RamDiscardManager interface. Upon creation of
>>> guest_memfd, a new guest_memfd_manager object can be instantiated and
>>> registered to the managed guest_memfd MemoryRegion to handle the page
>>> conversion events.
>>>
>>> In the context of guest_memfd, the discarded state signifies that the
>>> page is private, while the populated state indicated that the page is
>>> shared. The state of the memory is tracked at the granularity of the
>>> host page size (i.e. block_size), as the minimum conversion size can be
>>> one page per request.
>>>
>>> In addition, VFIO expects the DMA mapping for a specific iova to be
>>> mapped and unmapped with the same granularity. However, the confidential
>>> VMs may do partial conversion, e.g. conversion happens on a small region
>>> within a large region. To prevent such invalid cases and before any
>>> potential optimization comes out, all operations are performed with 4K
>>> granularity.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>>    include/sysemu/guest-memfd-manager.h |  46 +++++
>>>    system/guest-memfd-manager.c         | 250 +++++++++++++++++++++++++++
>>>    system/meson.build                   |   1 +
>>>    3 files changed, 297 insertions(+)
>>>    create mode 100644 include/sysemu/guest-memfd-manager.h
>>>    create mode 100644 system/guest-memfd-manager.c
>>>
>>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>>> guest-memfd-manager.h
>>> new file mode 100644
>>> index 0000000000..ba4a99b614
>>> --- /dev/null
>>> +++ b/include/sysemu/guest-memfd-manager.h
>>> @@ -0,0 +1,46 @@
>>> +/*
>>> + * QEMU guest memfd manager
>>> + *
>>> + * Copyright Intel
>>> + *
>>> + * Author:
>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>> + *
>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>> later.
>>> + * See the COPYING file in the top-level directory
>>> + *
>>> + */
>>> +
>>> +#ifndef SYSEMU_GUEST_MEMFD_MANAGER_H
>>> +#define SYSEMU_GUEST_MEMFD_MANAGER_H
>>> +
>>> +#include "sysemu/hostmem.h"
>>> +
>>> +#define TYPE_GUEST_MEMFD_MANAGER "guest-memfd-manager"
>>> +
>>> +OBJECT_DECLARE_TYPE(GuestMemfdManager, GuestMemfdManagerClass,
>>> GUEST_MEMFD_MANAGER)
>>> +
>>> +struct GuestMemfdManager {
>>> +    Object parent;
>>> +
>>> +    /* Managed memory region. */
>>
>> Do not need this comment. And the period.
> 
> [...]
> 
>>
>>> +    MemoryRegion *mr;
>>> +
>>> +    /*
>>> +     * 1-setting of the bit represents the memory is populated (shared).
>>> +     */
> 
> Will fix it.
> 
>>
>> Could be 1 line comment.
>>
>>> +    int32_t bitmap_size;
>>
>> int or unsigned
>>
>>> +    unsigned long *bitmap;
>>> +
>>> +    /* block size and alignment */
>>> +    uint64_t block_size;
>>
>> unsigned?
>>
>> (u)int(32|64)_t make sense for migrations which is not the case (yet?).
>> Thanks,
> 
> I think these fields would be helpful for future migration support.
> Maybe defining as this way is more straightforward.
 >
>>
>>> +
>>> +    /* listeners to notify on populate/discard activity. */
>>
>> Do not really need this comment either imho.
>>
> 
> I prefer to provide the comment for each field as virtio-mem do. If it
> is not necessary, I would remove those obvious ones.

[bikeshedding on] But the "RamDiscardListener" word says that already, 
why repeating? :) It should add information, not duplicate. Like the 
block_size comment which mentions "alignment" [bikeshedding off]

>>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>>> +};
>>> +
>>> +struct GuestMemfdManagerClass {
>>> +    ObjectClass parent_class;
>>> +};
>>> +
>>> +#endif
> 
> [...]
> 
>             void *arg,
>>> +
>>> guest_memfd_section_cb cb)
>>> +{
>>> +    unsigned long first_one_bit, last_one_bit;
>>> +    uint64_t offset, size;
>>> +    int ret = 0;
>>> +
>>> +    first_one_bit = section->offset_within_region / gmm->block_size;
>>> +    first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>>> first_one_bit);
>>> +
>>> +    while (first_one_bit < gmm->bitmap_size) {
>>> +        MemoryRegionSection tmp = *section;
>>> +
>>> +        offset = first_one_bit * gmm->block_size;
>>> +        last_one_bit = find_next_zero_bit(gmm->bitmap, gmm->bitmap_size,
>>> +                                          first_one_bit + 1) - 1;
>>> +        size = (last_one_bit - first_one_bit + 1) * gmm->block_size;
>>
>> This tries calling cb() on bigger chunks even though we say from the
>> beginning that only page size is supported?
>>
>> May be simplify this for now and extend if/when VFIO learns to split
>> mappings,  or  just drop it when we get in-place page state convertion
>> (which will make this all irrelevant)?
> 
> The cb() will call with big chunks but actually it do the split with the
> granularity of block_size in the cb(). See the
> vfio_ram_discard_notify_populate(), which do the DMA_MAP with
> granularity size.


Right, and this all happens inside QEMU - first the code finds bigger 
chunks and then it splits them anyway to call the VFIO driver. Seems 
pointless to bother about bigger chunks here.

> 
>>
>>
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            break;
>>> +        }
>>> +
>>> +        ret = cb(&tmp, arg);
>>> +        if (ret) {
>>> +            break;
>>> +        }
>>> +
>>> +        first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>>> +                                      last_one_bit + 2);
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int guest_memfd_for_each_discarded_section(const
>>> GuestMemfdManager *gmm,
>>> +                                                  MemoryRegionSection
>>> *section,
>>> +                                                  void *arg,
>>> +
>>> guest_memfd_section_cb cb)
>>> +{
>>> +    unsigned long first_zero_bit, last_zero_bit;
>>> +    uint64_t offset, size;
>>> +    int ret = 0;
>>> +
>>> +    first_zero_bit = section->offset_within_region / gmm->block_size;
>>> +    first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm->bitmap_size,
>>> +                                        first_zero_bit);
>>> +
>>> +    while (first_zero_bit < gmm->bitmap_size) {
>>> +        MemoryRegionSection tmp = *section;
>>> +
>>> +        offset = first_zero_bit * gmm->block_size;
>>> +        last_zero_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>>> +                                      first_zero_bit + 1) - 1;
>>> +        size = (last_zero_bit - first_zero_bit + 1) * gmm->block_size;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            break;
>>> +        }
>>> +
>>> +        ret = cb(&tmp, arg);
>>> +        if (ret) {
>>> +            break;
>>> +        }
>>> +
>>> +        first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm-
>>>> bitmap_size,
>>> +                                            last_zero_bit + 2);
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static uint64_t guest_memfd_rdm_get_min_granularity(const
>>> RamDiscardManager *rdm,
>>> +                                                    const
>>> MemoryRegion *mr)
>>> +{
>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>> +
>>> +    g_assert(mr == gmm->mr);
>>> +    return gmm->block_size;
>>> +}
>>> +
>>> +static void guest_memfd_rdm_register_listener(RamDiscardManager *rdm,
>>> +                                              RamDiscardListener *rdl,
>>> +                                              MemoryRegionSection
>>> *section)
>>> +{
>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>> +    int ret;
>>> +
>>> +    g_assert(section->mr == gmm->mr);
>>> +    rdl->section = memory_region_section_new_copy(section);
>>> +
>>> +    QLIST_INSERT_HEAD(&gmm->rdl_list, rdl, next);
>>> +
>>> +    ret = guest_memfd_for_each_populated_section(gmm, section, rdl,
>>> +
>>> guest_memfd_notify_populate_cb);
>>> +    if (ret) {
>>> +        error_report("%s: Failed to register RAM discard listener:
>>> %s", __func__,
>>> +                     strerror(-ret));
>>> +    }
>>> +}
>>> +
>>> +static void guest_memfd_rdm_unregister_listener(RamDiscardManager *rdm,
>>> +                                                RamDiscardListener *rdl)
>>> +{
>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>> +    int ret;
>>> +
>>> +    g_assert(rdl->section);
>>> +    g_assert(rdl->section->mr == gmm->mr);
>>> +
>>> +    ret = guest_memfd_for_each_populated_section(gmm, rdl->section, rdl,
>>> +
>>> guest_memfd_notify_discard_cb);
>>> +    if (ret) {
>>> +        error_report("%s: Failed to unregister RAM discard listener:
>>> %s", __func__,
>>> +                     strerror(-ret));
>>> +    }
>>> +
>>> +    memory_region_section_free_copy(rdl->section);
>>> +    rdl->section = NULL;
>>> +    QLIST_REMOVE(rdl, next);
>>> +
>>> +}
>>> +
>>> +typedef struct GuestMemfdReplayData {
>>> +    void *fn;
>>
>> s/void */ReplayRamPopulate/
> 
> [...]
> 
>>
>>> +    void *opaque;
>>> +} GuestMemfdReplayData;
>>> +
>>> +static int guest_memfd_rdm_replay_populated_cb(MemoryRegionSection
>>> *section, void *arg)
>>> +{
>>> +    struct GuestMemfdReplayData *data = arg;
>>
>> Drop "struct" here and below.
> 
> Fixed. Thanks!
> 
>>
>>> +    ReplayRamPopulate replay_fn = data->fn;
>>> +
>>> +    return replay_fn(section, data->opaque);
>>> +}
>>> +
>>> +static int guest_memfd_rdm_replay_populated(const RamDiscardManager
>>> *rdm,
>>> +                                            MemoryRegionSection
>>> *section,
>>> +                                            ReplayRamPopulate replay_fn,
>>> +                                            void *opaque)
>>> +{
>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>> opaque };
>>> +
>>> +    g_assert(section->mr == gmm->mr);
>>> +    return guest_memfd_for_each_populated_section(gmm, section, &data,
>>> +
>>> guest_memfd_rdm_replay_populated_cb);
>>> +}
>>> +
>>> +static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection
>>> *section, void *arg)
>>> +{
>>> +    struct GuestMemfdReplayData *data = arg;
>>> +    ReplayRamDiscard replay_fn = data->fn;
>>> +
>>> +    replay_fn(section, data->opaque);
>>
>>
>> guest_memfd_rdm_replay_populated_cb() checks for errors though.
> 
> It follows current definiton of ReplayRamDiscard() and
> ReplayRamPopulate() where replay_discard() doesn't return errors and
> replay_populate() returns errors.

A trace would be appropriate imho. Thanks,

>>
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static void guest_memfd_rdm_replay_discarded(const RamDiscardManager
>>> *rdm,
>>> +                                             MemoryRegionSection
>>> *section,
>>> +                                             ReplayRamDiscard replay_fn,
>>> +                                             void *opaque)
>>> +{
>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>> opaque };
>>> +
>>> +    g_assert(section->mr == gmm->mr);
>>> +    guest_memfd_for_each_discarded_section(gmm, section, &data,
>>> +
>>> guest_memfd_rdm_replay_discarded_cb);
>>> +}
>>> +
>>> +static void guest_memfd_manager_init(Object *obj)
>>> +{
>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>> +
>>> +    QLIST_INIT(&gmm->rdl_list);
>>> +}
>>> +
>>> +static void guest_memfd_manager_finalize(Object *obj)
>>> +{
>>> +    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>
>>
>> bitmap is not allocated though. And 5/7 removes this anyway. Thanks,
> 
> Will remove it. Thanks.
> 
>>
>>
>>> +}
>>> +
>>> +static void guest_memfd_manager_class_init(ObjectClass *oc, void *data)
>>> +{
>>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>> +
>>> +    rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
>>> +    rdmc->register_listener = guest_memfd_rdm_register_listener;
>>> +    rdmc->unregister_listener = guest_memfd_rdm_unregister_listener;
>>> +    rdmc->is_populated = guest_memfd_rdm_is_populated;
>>> +    rdmc->replay_populated = guest_memfd_rdm_replay_populated;
>>> +    rdmc->replay_discarded = guest_memfd_rdm_replay_discarded;
>>> +}
>>> diff --git a/system/meson.build b/system/meson.build
>>> index 4952f4b2c7..ed4e1137bd 100644
>>> --- a/system/meson.build
>>> +++ b/system/meson.build
>>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>>      'dirtylimit.c',
>>>      'dma-helpers.c',
>>>      'globals.c',
>>> +  'guest-memfd-manager.c',
>>>      'memory_mapping.c',
>>>      'qdev-monitor.c',
>>>      'qtest.c',
>>
> 

-- 
Alexey


