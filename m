Return-Path: <kvm+bounces-34741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F09A05253
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 05:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E173C167B0E
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 04:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18897198A11;
	Wed,  8 Jan 2025 04:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N/xMMpIb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A74155327
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 04:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736311697; cv=fail; b=kIsS8lFj7h7tgvKjA8XSpQ7SvqC83xbfF1W69iHhI68Ov0o/G6bwqr5e15jZYsgXV+3qKFSHknsneQb0X2XVQDE+pCKLjSle3OYLhaFSJKWqGtJIWIgH0rtEzsMajJCAKBzQ7qIiZv47w6NXRK700vlxdC7otle+3NXCL+Oe0c4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736311697; c=relaxed/simple;
	bh=PvkF7gSGGUHV5KqZ+1cntih6JoBQuEtqLoqGGgOqXpQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DpfCpsv1jiJIMCLszo6t7RbxKP2qA/q+Ooccg5W27+ZmFKQuLfFLyk8wcxaoWSwEz+MvZyeAWyFVCk79BhumGbE7AHOm0rkxBu8GDf5UclY7ZA419qDddDeuPQ82s3LdM4cJbwpNxBfvPMR1/WiBUqDpLml0EpOy+rpteQ9KXwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N/xMMpIb; arc=fail smtp.client-ip=40.107.223.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sqvaTD2VcBSvr9JJwzsUB1/qmhPvbkI1uYpayyYKRoohLDPMaPzO7mNHKJZj0gthr8UlRX0CIuuikBStQCCyNW5uIDRyhIV0hnymRfMkMwz/rRn/KJ+CBYFEOzRgr7yO0gzH3d+iZcBfDOFlLybjdKPhfENunONDl7eEDdH4wUhO9nqibmmnPoIxgkIWwod/LOCln9JHughLhEHRjA5n46IAQPldPNQ0vH60BSNgfska4dvaBdLQthUGDYYLq8mj3DlE102KJDU4mXkZSQcvDaJxR/Lx+Ld35nLnVOJVNGbmLjLBEoRak+Zlg5jCYGqV8BbGU0f8wbDHa9RUFnTKdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8imcE66aYJgNdjOxoo0JgTmHtb+rKbWgh94m+ih1W4I=;
 b=DxzA4AfntrnSMcFqfebd0STxrJV1kT8F/1MVoZGxR+pzZk0sBEGHqWt9MA1sbVYgCrkdiDIQPbK/yQPhoEJ4bUbrEKCih9mI6njT+Dj/gnV4TekC1rqx75BQT37mpoGxJI2uOeP6e7CwIIqAKtekFNbWS3yR7tcl35gGYZ7Nxih/7MRcg38KGKWUtdChyAdzkui2aKbPsiPOKxtbpxthAhh4ah5Kut0T+AmJ/eEFJEkzKklXpj+hQnJEZzywZdbJUYt4yZkEOaimWumI5XT46xg2LP1P30FC2XwzhFcpSjWwX2eq0F+YYQ75YqYvFv90QGQajrtFrG17xl2Lt3yXvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8imcE66aYJgNdjOxoo0JgTmHtb+rKbWgh94m+ih1W4I=;
 b=N/xMMpIb7x88WpZ9GeEtheBL/SSjtBET37HKHvjg7BSBocnvQjn2oP80ecGrQHqKVpQrx/fVkzb837yk0uOiXFnv40Q7relM2zTLi/kafdzKLjFS2bKgMlfj6Z0QpzibFouUdfyx7bZERFc9IR2ccZmS+rW9alRwChqsbzK9Fr0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB9247.namprd12.prod.outlook.com (2603:10b6:806:3af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Wed, 8 Jan
 2025 04:48:08 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 04:48:08 +0000
Message-ID: <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
Date: Wed, 8 Jan 2025 15:48:04 +1100
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
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20241213070852.106092-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0009.ausprd01.prod.outlook.com
 (2603:10c6:220:1e3::13) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB9247:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dfbd89a-1f8a-4078-bbfe-08dd2f9fa593
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWhHUDIzZWY3UHFVUVdzbkZsYlBqeDRiOGtROEJLdXFwMTYzN3pQWHFtNkZj?=
 =?utf-8?B?dndCUkxWc2FtMEowdHJ5Wng4dkFqTk9ZOXB5aXhPS2p0VmlMUjYxSThZVTBB?=
 =?utf-8?B?QWVTUFFVbWZXZHNubFp1VFpKRU9kcFJpMU5IM280WFdaZTVORzNkWlRaVDJY?=
 =?utf-8?B?V1pYbGVuQTFseng5c3E4V3hDR2Zlb1BMMDBzNnBobmtKUXU0NHF6TEJkS2pL?=
 =?utf-8?B?YWg1VnBMQWlFVVY2ek9GcVIzdlE4aDNlRnJXb2VueWxYSWVDd0MvWUh3TTYz?=
 =?utf-8?B?K0hQbHJ4UVBhdDRIUDQzZzdxODRSRHQxSWt1WTArc1ZOY01jQmdaUFE2T2J2?=
 =?utf-8?B?Um95U0FzcTJDUFFpRFZEdG1CMGlkQUU3OWZnRjR1ZzJNSzFRemtUZTRKaXlo?=
 =?utf-8?B?SU9TSlFvMVVzTWdaSlZaYU1tRU9xN1hXbXNMamJZUE9aeHN6ZlBwQjgxcDd5?=
 =?utf-8?B?VEt4RE5NREExa0g5bEJCNFR2eENZOVRReUdxL004YW1oZG1kNEphLzFqa0NC?=
 =?utf-8?B?ODE1d3liL0tyOTA2dStlUXQvekF0OUJ5Sm05aEJVVXI4VW52Z2RqTm5pR2Nh?=
 =?utf-8?B?alJmeXVXSks1amlMYXBzOVhLY1dQbklDQVBPRThnM3hpdTlvbXpSdHk4Qlg3?=
 =?utf-8?B?TzROSzA2RzVsTGE3SEFyRnBDVHBjSFBKT01xeklGM0JycTVMZUVoUFV2Tnpz?=
 =?utf-8?B?bHFHV3pqVnVqUEYzQ2swSVpqTTJoOXVUNW5KWWtoTXBHVU9nbEJTakh4ZFNC?=
 =?utf-8?B?L1JPU1NlSkZRU1EyMC9aaU1YMzhqTTAxSXVMTmpLelhtRlhqQzN3NTdaRFVs?=
 =?utf-8?B?YjR6Q0p1VXgvRnd0OUwyVlN3T3Zwclh0QlVvd2RxM05iVUkrR3Zyd3QrWTVN?=
 =?utf-8?B?SkpXNC9ZLzBzdHBYSGczNVA0elFERC9Kd3hLaEZnMkhwYm81YnI2ejZDdmJD?=
 =?utf-8?B?Nlk2YmphT1RMTlBpWHJiWGV3cStyN3hyWjdQUFpncW10TlVQcG9FUHlyaEx0?=
 =?utf-8?B?RUFuQVRDcUZtTnhmVCtMeDFRbzN1ejgwUmt3MnJTK0VreURmM0NUTVhhQWI4?=
 =?utf-8?B?WTdBOEZKci9oazBjYTNyVFdERVFxRmJoOWkxaVZ3N3pxR1E3TUk4MlB2RC81?=
 =?utf-8?B?Q2pMTGNRcnd1S0ZOdzFlK2JtcWtldzRSM3J5Yjl4LzVhd3p3VU53UjE0dlpZ?=
 =?utf-8?B?YitqdTNTQlF5YUYwSzJmUkI0QlRaMHZVRHZ5b1ozNFRVb29VZm00SGNMOUo5?=
 =?utf-8?B?R3VmNzNWbUVmdmI4T28zenJna1JuNGpYQlZZa2diWEh6S3FZb3dlTmtJVjJQ?=
 =?utf-8?B?SGM0Z245TjFmd3FyN3dGanBCRUJ5L0ZTdlFCL20xWkwvaDBsZEVxY01tMmNT?=
 =?utf-8?B?MDlJTzBSMFI0TzZlMVVVODBOZXd4TVZXMDkyc01sY1RxdzZqbHVyODVTUTk5?=
 =?utf-8?B?U0UwZkQ0QUpEc0FKd283ZTFpNGZXdHJVeG9HT21KWUxmU1Z0bVM5WFFIMmph?=
 =?utf-8?B?MUp2eDBaS3dic1ZrblFwQnFyN04rL1dibWkyRXlXWFJmWnJGd25qdWUxdHRT?=
 =?utf-8?B?Y3JCVjZlWmdzZFZScTNuSG9BMVdnSEZRaFFpMTM5cGRXM2p5am9TYUNsQ0Yv?=
 =?utf-8?B?N0ppNXIxUkxDTG5vWmY1bjBQRnBRRTQyVmtZNDlYWUxQdHlmOTJFbzVucXo5?=
 =?utf-8?B?VEdKMlgrSzZSQmJDWHhEalhlT0hCWVpEVnFFR0RpUGFZejFjMWlxWi9mTmMw?=
 =?utf-8?B?R3Q5dnIxRUI5N0o2aXhYNnZPWFpHZUJRZUF3SUpoNnc2NGQ4V2hodFJOV1dT?=
 =?utf-8?B?QjFnMGRwT0k0SjVrZWhtOHJJOFl0Tm4rWGl5MzR2YWFwSWRMbUVtN3I0VklL?=
 =?utf-8?Q?JCIS/NRjSlfLT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEwxdGNhcVlGWGZxRkxVYUZzd3F1cnk2bTBtTitjcEJ5VlpWTjNibEo5bDVl?=
 =?utf-8?B?cVpoRDJOM3VlVndzaG5JVHJoYkZVcTZ6YmNWdUYySjZVU09tcGdYNHRDWXpz?=
 =?utf-8?B?alUrWGNjQVR3Y2R6OGFVQXpjWGZ3dVM1M0V0MnV5UThoS2lZSmFUYUwzS2Zz?=
 =?utf-8?B?ZjVJbWdtV2l2aHJYM2NmeHZUVk5OdllkWE44WTJxdDNreFIrMzN5d1ZybWV3?=
 =?utf-8?B?TDAxTjM1bC9YUTVqcEpod2hVQ1l5UWgvWXZUQ3dZZWxXZFM5WDcrNnpWU0Vm?=
 =?utf-8?B?Q1FyRzZVS2VrbEE0YnF4WElqNnFXV3dGdlVhelEzc29aOXhoQ1RaakFuVTNY?=
 =?utf-8?B?SEFuWjBQVmFFSUljWGNNWVBsL21TK3ZxOG9GdklhMjZybEh1Nlo5OVhxdzRY?=
 =?utf-8?B?N1NEL2xBRU1US2dPTkM2QWNYRTFUdzBUb3BmQjQzQ0N6QlowTkJKNGQ0eiti?=
 =?utf-8?B?b1dWazBtNm81K2djMmhVQnlWT1pIYkE4NnNSQUZZTmlHbEFpcXVXb21oNnBt?=
 =?utf-8?B?Qkkrd1IxYnV3VVBXNmQvaDY2aFd0TlFFOVpiLzhIb2oyNWFCZjk2Snl4TUN0?=
 =?utf-8?B?c0ZMTEtnZks5UUdzNEIxaFdvVlRtb3IxeGgyWEZlNUdXb2tLSDROSWVDaVZ5?=
 =?utf-8?B?OXdKL2ZFdGd0cm9ycGhKcFI1VFFMTHVoOXpaQnR2SEoyQmdaajlTQXpDS2ht?=
 =?utf-8?B?VC9qZm0yb3c0SzE2N21lTVlURXllUzVkNFk4Q3RsM3QwaUxDNlNKRE5wUURU?=
 =?utf-8?B?R0d0anBSMEVSV09SRy8rVVp1MkdHN2Q3bE9nOGF3cWRDNnB0LzlIWFpVeEVU?=
 =?utf-8?B?WWhQNkpZdVhGNEtCUE9lWkc3dmZmRStnS3p5MXFjS25oako1cml1MzBZWk1J?=
 =?utf-8?B?TXBMWlF4RTZhYkhmUnF1dGxCVGRSUWxleFFSK3hhak91Y1N3cDBvSUxBLzFF?=
 =?utf-8?B?OEpOZ0U0bXNnQ2daMmhkSFdoOW5nY2Z4YVdsMnlINnJjcndmMTBIeGZFUTRv?=
 =?utf-8?B?U3NrZ043VUlvSEFWM1BaazRrQzdOMjdqY2hXYWJzZWZLYm1CTDlyS1V1RkJF?=
 =?utf-8?B?bStJUVI3bllIWC9rOEFYOWt2UUFRZGk5NStoRSt3Z3FVM2J4aXRWMmtkV2xa?=
 =?utf-8?B?bmhZREZUMURjMEpNWk1iN3I1aFNJTkQ2elpSQ216akpkRUpoZC96NnVhU1Zq?=
 =?utf-8?B?elZkWXFxK0dDMW5OTjZTYWVzZDhXaUlZQ29vejJQSDUybkZ6MXJmUzNuT2dB?=
 =?utf-8?B?TFQ5UlIraHFmZHg3bkRlemU5VkRFNlgrczhUWHMxb240UlBkYldFazN6VlpM?=
 =?utf-8?B?NElXcnFhdFQvVll3NkdWanpMMFlRdGZwSVAzaFJvNGc5QTFudEdsYmkwbEVC?=
 =?utf-8?B?bmJCTlR5R0ZCQXFNc3k3YUNMbVQ3T3pybVJuMVBqNnQ5cGxPVzc2TEw3cTZx?=
 =?utf-8?B?YllnYzdFZjFjSmFOSE1SMDRxWkN3bXVZR2ZXV08rUlVROUNEZGM2UXBjN3VJ?=
 =?utf-8?B?RzNCc0VzMEgxNTRnbEduRHhEWEZSdnRmUElBZXo0V2JmalFzNnFHU2hTcE5E?=
 =?utf-8?B?UVZmNXlwWmRPMkN0VStZK0pKY0hqZEZ3dkFtS0twTnFVSVlBRlU5cUZOZVlZ?=
 =?utf-8?B?bTNUMzdLZE9rMmZTcVNTa253cXEvelFZV2xSSkdmR1lvZFJOWEJjblExNHNH?=
 =?utf-8?B?UDV6SHFFL0tZcTE0RzJFSzg5VTRnOG4yN3A1RmVhb3VvLzRzRWJXTzNiMGdu?=
 =?utf-8?B?UG5vZ2V1NW82VjJZTlpJQ1l5TUxNRGFnTzlxaDVFQ1Z1bnYyaEljQVVnbC8x?=
 =?utf-8?B?dm42ekhIdEdiL1NZb0NKN0M0OHVsNytEazRGSk1zMlc5V1FUL3Q3TkZpQmRv?=
 =?utf-8?B?RmpyS1cwc2lxZXViMjQvVERHenlUZnRuN2VUdzJwVi96dkRnR00xN3NJRW1F?=
 =?utf-8?B?TU13cm5MbXljRXF3NU1mUGhFMFdCYUc1TiszWDFvOFNIeVkzSTZ1TnRNZUFK?=
 =?utf-8?B?dTJIekJ4elhQaUExNHcrNmJESDkwL2VseEo0T3VnR0Y5cjJxbGYrTVQyVXBE?=
 =?utf-8?B?a2w1QmJYMkg0OW44VzJHdDYwK09TaW9ZZDF3UHVmMUxUMTRsSy90aDRsU3h1?=
 =?utf-8?Q?5iY/QksjV733aburw+xcHT14m?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dfbd89a-1f8a-4078-bbfe-08dd2f9fa593
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 04:48:08.3808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDZcJGJH/YGR5drnR3R6gAQEBLT/EOzJ8eQP105oJHZZL/A+/4/0AIB6KUuD+Tvs+pYgjjTxqre/T9uOCxGElg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9247

On 13/12/24 18:08, Chenyi Qiang wrote:
> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
> uncoordinated discard") highlighted, some subsystems like VFIO might
> disable ram block discard. However, guest_memfd relies on the discard
> operation to perform page conversion between private and shared memory.
> This can lead to stale IOMMU mapping issue when assigning a hardware
> device to a confidential VM via shared memory (unprotected memory
> pages). Blocking shared page discard can solve this problem, but it
> could cause guests to consume twice the memory with VFIO, which is not
> acceptable in some cases. An alternative solution is to convey other
> systems like VFIO to refresh its outdated IOMMU mappings.
> 
> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
> VFIO mappings in relation to VM page assignment. Effectively page
> conversion is similar to hot-removing a page in one mode and adding it
> back in the other, so the similar work that needs to happen in response
> to virtio-mem changes needs to happen for page conversion events.
> Introduce the RamDiscardManager to guest_memfd to achieve it.
> 
> However, guest_memfd is not an object so it cannot directly implement
> the RamDiscardManager interface.
> 
> One solution is to implement the interface in HostMemoryBackend. Any

This sounds about right.

> guest_memfd-backed host memory backend can register itself in the target
> MemoryRegion. However, this solution doesn't cover the scenario where a
> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
> the virtual BIOS MemoryRegion.

What is this virtual BIOS MemoryRegion exactly? What does it look like 
in "info mtree -f"? Do we really want this memory to be DMAable?


> Thus, choose the second option, i.e. define an object type named
> guest_memfd_manager with RamDiscardManager interface. Upon creation of
> guest_memfd, a new guest_memfd_manager object can be instantiated and
> registered to the managed guest_memfd MemoryRegion to handle the page
> conversion events.
> 
> In the context of guest_memfd, the discarded state signifies that the
> page is private, while the populated state indicated that the page is
> shared. The state of the memory is tracked at the granularity of the
> host page size (i.e. block_size), as the minimum conversion size can be
> one page per request.
> 
> In addition, VFIO expects the DMA mapping for a specific iova to be
> mapped and unmapped with the same granularity. However, the confidential
> VMs may do partial conversion, e.g. conversion happens on a small region
> within a large region. To prevent such invalid cases and before any
> potential optimization comes out, all operations are performed with 4K
> granularity.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   include/sysemu/guest-memfd-manager.h |  46 +++++
>   system/guest-memfd-manager.c         | 250 +++++++++++++++++++++++++++
>   system/meson.build                   |   1 +
>   3 files changed, 297 insertions(+)
>   create mode 100644 include/sysemu/guest-memfd-manager.h
>   create mode 100644 system/guest-memfd-manager.c
> 
> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/guest-memfd-manager.h
> new file mode 100644
> index 0000000000..ba4a99b614
> --- /dev/null
> +++ b/include/sysemu/guest-memfd-manager.h
> @@ -0,0 +1,46 @@
> +/*
> + * QEMU guest memfd manager
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#ifndef SYSEMU_GUEST_MEMFD_MANAGER_H
> +#define SYSEMU_GUEST_MEMFD_MANAGER_H
> +
> +#include "sysemu/hostmem.h"
> +
> +#define TYPE_GUEST_MEMFD_MANAGER "guest-memfd-manager"
> +
> +OBJECT_DECLARE_TYPE(GuestMemfdManager, GuestMemfdManagerClass, GUEST_MEMFD_MANAGER)
> +
> +struct GuestMemfdManager {
> +    Object parent;
> +
> +    /* Managed memory region. */

Do not need this comment. And the period.

> +    MemoryRegion *mr;
> +
> +    /*
> +     * 1-setting of the bit represents the memory is populated (shared).
> +     */

Could be 1 line comment.

> +    int32_t bitmap_size;

int or unsigned

> +    unsigned long *bitmap;
> +
> +    /* block size and alignment */
> +    uint64_t block_size;

unsigned?

(u)int(32|64)_t make sense for migrations which is not the case (yet?). 
Thanks,

> +
> +    /* listeners to notify on populate/discard activity. */

Do not really need this comment either imho.

> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
> +};
> +
> +struct GuestMemfdManagerClass {
> +    ObjectClass parent_class;
> +};
> +
> +#endif
> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
> new file mode 100644
> index 0000000000..d7e105fead
> --- /dev/null
> +++ b/system/guest-memfd-manager.c
> @@ -0,0 +1,250 @@
> +/*
> + * QEMU guest memfd manager
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "sysemu/guest-memfd-manager.h"
> +
> +OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(GuestMemfdManager,
> +                                          guest_memfd_manager,
> +                                          GUEST_MEMFD_MANAGER,
> +                                          OBJECT,
> +                                          { TYPE_RAM_DISCARD_MANAGER },
> +                                          { })
> +
> +static bool guest_memfd_rdm_is_populated(const RamDiscardManager *rdm,
> +                                         const MemoryRegionSection *section)
> +{
> +    const GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
> +    uint64_t first_bit = section->offset_within_region / gmm->block_size;
> +    uint64_t last_bit = first_bit + int128_get64(section->size) / gmm->block_size - 1;
> +    unsigned long first_discard_bit;
> +
> +    first_discard_bit = find_next_zero_bit(gmm->bitmap, last_bit + 1, first_bit);
> +    return first_discard_bit > last_bit;
> +}
> +
> +typedef int (*guest_memfd_section_cb)(MemoryRegionSection *s, void *arg);
> +
> +static int guest_memfd_notify_populate_cb(MemoryRegionSection *section, void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    return rdl->notify_populate(rdl, section);
> +}
> +
> +static int guest_memfd_notify_discard_cb(MemoryRegionSection *section, void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    rdl->notify_discard(rdl, section);
> +
> +    return 0;
> +}
> +
> +static int guest_memfd_for_each_populated_section(const GuestMemfdManager *gmm,
> +                                                  MemoryRegionSection *section,
> +                                                  void *arg,
> +                                                  guest_memfd_section_cb cb)
> +{
> +    unsigned long first_one_bit, last_one_bit;
> +    uint64_t offset, size;
> +    int ret = 0;
> +
> +    first_one_bit = section->offset_within_region / gmm->block_size;
> +    first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size, first_one_bit);
> +
> +    while (first_one_bit < gmm->bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_one_bit * gmm->block_size;
> +        last_one_bit = find_next_zero_bit(gmm->bitmap, gmm->bitmap_size,
> +                                          first_one_bit + 1) - 1;
> +        size = (last_one_bit - first_one_bit + 1) * gmm->block_size;

This tries calling cb() on bigger chunks even though we say from the 
beginning that only page size is supported?

May be simplify this for now and extend if/when VFIO learns to split 
mappings,  or  just drop it when we get in-place page state convertion 
(which will make this all irrelevant)?


> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            break;
> +        }
> +
> +        first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
> +                                      last_one_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static int guest_memfd_for_each_discarded_section(const GuestMemfdManager *gmm,
> +                                                  MemoryRegionSection *section,
> +                                                  void *arg,
> +                                                  guest_memfd_section_cb cb)
> +{
> +    unsigned long first_zero_bit, last_zero_bit;
> +    uint64_t offset, size;
> +    int ret = 0;
> +
> +    first_zero_bit = section->offset_within_region / gmm->block_size;
> +    first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm->bitmap_size,
> +                                        first_zero_bit);
> +
> +    while (first_zero_bit < gmm->bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_zero_bit * gmm->block_size;
> +        last_zero_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
> +                                      first_zero_bit + 1) - 1;
> +        size = (last_zero_bit - first_zero_bit + 1) * gmm->block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            break;
> +        }
> +
> +        first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm->bitmap_size,
> +                                            last_zero_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static uint64_t guest_memfd_rdm_get_min_granularity(const RamDiscardManager *rdm,
> +                                                    const MemoryRegion *mr)
> +{
> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
> +
> +    g_assert(mr == gmm->mr);
> +    return gmm->block_size;
> +}
> +
> +static void guest_memfd_rdm_register_listener(RamDiscardManager *rdm,
> +                                              RamDiscardListener *rdl,
> +                                              MemoryRegionSection *section)
> +{
> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
> +    int ret;
> +
> +    g_assert(section->mr == gmm->mr);
> +    rdl->section = memory_region_section_new_copy(section);
> +
> +    QLIST_INSERT_HEAD(&gmm->rdl_list, rdl, next);
> +
> +    ret = guest_memfd_for_each_populated_section(gmm, section, rdl,
> +                                                 guest_memfd_notify_populate_cb);
> +    if (ret) {
> +        error_report("%s: Failed to register RAM discard listener: %s", __func__,
> +                     strerror(-ret));
> +    }
> +}
> +
> +static void guest_memfd_rdm_unregister_listener(RamDiscardManager *rdm,
> +                                                RamDiscardListener *rdl)
> +{
> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
> +    int ret;
> +
> +    g_assert(rdl->section);
> +    g_assert(rdl->section->mr == gmm->mr);
> +
> +    ret = guest_memfd_for_each_populated_section(gmm, rdl->section, rdl,
> +                                                 guest_memfd_notify_discard_cb);
> +    if (ret) {
> +        error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
> +                     strerror(-ret));
> +    }
> +
> +    memory_region_section_free_copy(rdl->section);
> +    rdl->section = NULL;
> +    QLIST_REMOVE(rdl, next);
> +
> +}
> +
> +typedef struct GuestMemfdReplayData {
> +    void *fn;

s/void */ReplayRamPopulate/

> +    void *opaque;
> +} GuestMemfdReplayData;
> +
> +static int guest_memfd_rdm_replay_populated_cb(MemoryRegionSection *section, void *arg)
> +{
> +    struct GuestMemfdReplayData *data = arg;

Drop "struct" here and below.

> +    ReplayRamPopulate replay_fn = data->fn;
> +
> +    return replay_fn(section, data->opaque);
> +}
> +
> +static int guest_memfd_rdm_replay_populated(const RamDiscardManager *rdm,
> +                                            MemoryRegionSection *section,
> +                                            ReplayRamPopulate replay_fn,
> +                                            void *opaque)
> +{
> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == gmm->mr);
> +    return guest_memfd_for_each_populated_section(gmm, section, &data,
> +                                                  guest_memfd_rdm_replay_populated_cb);
> +}
> +
> +static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection *section, void *arg)
> +{
> +    struct GuestMemfdReplayData *data = arg;
> +    ReplayRamDiscard replay_fn = data->fn;
> +
> +    replay_fn(section, data->opaque);


guest_memfd_rdm_replay_populated_cb() checks for errors though.

> +
> +    return 0;
> +}
> +
> +static void guest_memfd_rdm_replay_discarded(const RamDiscardManager *rdm,
> +                                             MemoryRegionSection *section,
> +                                             ReplayRamDiscard replay_fn,
> +                                             void *opaque)
> +{
> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == gmm->mr);
> +    guest_memfd_for_each_discarded_section(gmm, section, &data,
> +                                           guest_memfd_rdm_replay_discarded_cb);
> +}
> +
> +static void guest_memfd_manager_init(Object *obj)
> +{
> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
> +
> +    QLIST_INIT(&gmm->rdl_list);
> +}
> +
> +static void guest_memfd_manager_finalize(Object *obj)
> +{
> +    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);


bitmap is not allocated though. And 5/7 removes this anyway. Thanks,


> +}
> +
> +static void guest_memfd_manager_class_init(ObjectClass *oc, void *data)
> +{
> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
> +
> +    rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
> +    rdmc->register_listener = guest_memfd_rdm_register_listener;
> +    rdmc->unregister_listener = guest_memfd_rdm_unregister_listener;
> +    rdmc->is_populated = guest_memfd_rdm_is_populated;
> +    rdmc->replay_populated = guest_memfd_rdm_replay_populated;
> +    rdmc->replay_discarded = guest_memfd_rdm_replay_discarded;
> +}
> diff --git a/system/meson.build b/system/meson.build
> index 4952f4b2c7..ed4e1137bd 100644
> --- a/system/meson.build
> +++ b/system/meson.build
> @@ -15,6 +15,7 @@ system_ss.add(files(
>     'dirtylimit.c',
>     'dma-helpers.c',
>     'globals.c',
> +  'guest-memfd-manager.c',
>     'memory_mapping.c',
>     'qdev-monitor.c',
>     'qtest.c',

-- 
Alexey


