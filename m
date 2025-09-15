Return-Path: <kvm+bounces-57519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A1E8B571D0
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D286E3ADE8A
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 07:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821512D7809;
	Mon, 15 Sep 2025 07:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1e4QebJ9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359D32D6629;
	Mon, 15 Sep 2025 07:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757922223; cv=fail; b=isxBq5N3Y/d8ZDtvaf8rlQAOyaRw/C3Dz3jt9lpgO1c6h6pbsC60GzR7wgGzQWfZkOmvXeOgsnUrOuK83AfQrXhvxMh88XP8tmknGLfIdB+3mSkn2GDP/+B7N0iUE/ncHapbtUHxDD0AAgfAvEpxMfuNTOoxdrItMV4dXqJcuIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757922223; c=relaxed/simple;
	bh=1FXKODpunk3Avr5UeDh8ClKagW4c86kXBCJYWNTjtI0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PRvlg7ICAEKZbx2H1KQi5C1rTXD90yibKyJ9sCGIgdtoV7xmuADv8H+rKtuyw4dAnAgSYrUTBmfQN2M/CHR+qklE5nK/uRIYKHzxAPXVQfPrbmpM/INnKHXdQi8XyxP//ZkhuuCW2buJLwP1IUOaG4iyp5JHrtS2mjzYzJ2Mlzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1e4QebJ9; arc=fail smtp.client-ip=40.107.244.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xpY1ye/JzClJULodpWHtIkF6RDW7W24Uko4HZ2Q+cmzmELap2PQYjAhxYgaur0EmPvjeUmMxNdl29uC6UzK4F5Nr1Q3nRQVKRKiCJvmhekhlOExT0dj2oa9ffW0eASH7O4s4gfRB5L6Lx3JMPROTNQJ7+R3dennj7NUzUubfzUf/C1zNWl617iOCJm6X/nZn6ICXmCmo/VQEgKjpUXlRWq8jdFMSXXQvjRmEfpwrgFl0rdlQ3VL5omYCb6RSiGQOP2HrdRpR+BIjtpMI0Edm0iFCZWgsAAwH3XRpTl0NvMJORSfbhc+l5+4ivtc0Cxh1+W1Wee/DYNmeDmvzCbW3QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZuVmDGtDlZRZ55v1rCsonle1UifiYPSdF3sV08fxnM=;
 b=AReNbIh/mmJ/jomfGL8TNWKcavQFwjfg8P+V+d9cpiggD42Sah6SI6ImANGprIa2f1aNPpneEYcQnE6TUJ9S7lTM180ogSV+HC/rGBnedzyUQH4qsnZKUTsfuT2c/oPf5G45EGyQEiAk6H/RUF9+oPlDNDeA3QDmtQS1olbyAqCB0UsoP54PjyBVeUoyaLUKVCgjT7wbJaV1p8vENpKwvK8UKQHQZ2oquUz15O/W9YkeM0+chu1AAJKjvA+B+qEi56AihEnBSy3TgwErUDFSzFEtwjSQ6nPGxXJ2unm160ML8y168e05R3vgFXY7CWZW0ce+dVDqBdOwoBYZSi4B/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZuVmDGtDlZRZ55v1rCsonle1UifiYPSdF3sV08fxnM=;
 b=1e4QebJ9zaqbCgyBN39kpl7ExzJNerIBkHgIPsq3lFecgiQeIEZJjHNNUtMURkT++ooYE4mhpwdJakC40U+LcrmWA182cmDm9l8uT+OxmUlWPCX3qjPNEbHyvLjYUom8qR6FNIvSkGgf2fhVGeg87kZR09H0M6jhfxRefWb08Uw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS5PPFDBFC954F7.namprd12.prod.outlook.com (2603:10b6:f:fc00::664) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 07:43:40 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 07:43:39 +0000
Message-ID: <c6e09d1e-c950-4ba7-8773-2062e0c62068@amd.com>
Date: Mon, 15 Sep 2025 17:43:33 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH] PCI: Add quirk to always map ivshmem as write-back
To: Borislav Petkov <bp@alien8.de>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bjorn Helgaas <bhelgaas@google.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Kai-Heng Feng <kai.heng.feng@canonical.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Santosh Shukla <santosh.shukla@amd.com>,
 "Nikunj A. Dadhania" <nikunj@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20250612082233.3008318-1-aik@amd.com>
 <20250912164957.GCaMRPNf7P60wqBud9@fat_crate.local>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20250912164957.GCaMRPNf7P60wqBud9@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0116.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS5PPFDBFC954F7:EE_
X-MS-Office365-Filtering-Correlation-Id: e01e7f96-f752-4552-16ab-08ddf42b9607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RCs1OXNNRjBpZVAwM1lBdXdmODhxeHU3cW9PczhsTndJUTNubVByc2tUMmRM?=
 =?utf-8?B?RGEydys4czhveDRRQktHQ2loeTRrNisvWmVCcmhZOXUrbkJ2Ui9aQmpzRUdp?=
 =?utf-8?B?T1ZGaGlPUXBwQWFaWTRXend6L0s1ZURaQlpjVm1MNDBoUGt5SU9wNnRsbGp0?=
 =?utf-8?B?RmtUcHZlaE1VWUtaZFplZCtLenNmQzZubDlDZ0JWU1gwTUxHbk54TmJXd1Z1?=
 =?utf-8?B?eS9RSTVseWVKNkhxR3kxeVBtWnBEQU1ERVdaSy81cEhlVFZyUE9sdThzQ3Zo?=
 =?utf-8?B?V1FqbEhEZmdPNHI4Z2pCdUZJbVdaU1ZoVFBjZWRjUVhTbEtmdEo0N3VWNk50?=
 =?utf-8?B?U2VFMG9pTzl3UWt6QThFNXliN3JZN1Z1bHV1akFKanBMbUhQOHFTZVZTSEx4?=
 =?utf-8?B?Y2JiaEZqVXVhcW5rR25DWWxVWUlCWXA2b0x0ZnlFMGZ3QmRUL3FRaGpyYkYy?=
 =?utf-8?B?VDlUaCtkTWttcDlHV0JzaXA3b3FMZThjODdOdUR1UXFScnFMczk2emV2bW51?=
 =?utf-8?B?bkJ4dk5Lbmk3Q1lFcGtFK1FTbUdXbUNOZXdobTZkTzRWU1g3SkFvMkEvckZq?=
 =?utf-8?B?U3FXcmRjTm1aa2VqenhaWlhYbXZ5NUhNYTlZWkF5Rmc3Y3VhL2ZiQzVPdFVX?=
 =?utf-8?B?MFlqek15d1VjdG9tcWhtdTYrbkN0MW1VSlBwbkh0bEtLMmF3amJtTzYvZC9S?=
 =?utf-8?B?YlBqeFhMVWoyTGRwdEFRd3IxcmV5YVBHWCthb0dWTS84clpzU1I1YmQ1VnlF?=
 =?utf-8?B?OXI3V0pNNWZsZXQyaWlpM0c2V0RBKzlyYnJreWo3MGV4OHR6MG5Hc2tKZllM?=
 =?utf-8?B?UFloeUJPZXpkdmJ5MTkybXJkRks3dWdnZm5wY215WGpoM0hoNWtRdWRYUnlQ?=
 =?utf-8?B?b3ZvU2hQSmYrK09FMGdINlorenVqU2dtQ0hVMGFuWnNhVmlicVI2NERKbjFK?=
 =?utf-8?B?M3dXMFdBT3hTUmVZcEdpeTVrZTg1N3lOSjVHOWl4a09wcUwzaU1CZ2JFSTRB?=
 =?utf-8?B?VG5hVmYxUitrQnFZUkZhN2Qxck56Q043WTRncWRvNEIxSlRteXhyVlpwVHpY?=
 =?utf-8?B?Uzk3SlEwb3k1VmVIdC9sazJFQ0l0blJ5T3FERDQ0bHIvYitEZnlXR2taM2J0?=
 =?utf-8?B?UnM2RzFESS9WVXRlZjNIMzZMTndITUphREM5WW4vSzV1TURCMzhibkhkamlI?=
 =?utf-8?B?ckdRTE5Zd0xnQmUydUplRVMwWXF3RGdIMkxNSEZ6TUV2Ykp0a2VwN1NKQjdM?=
 =?utf-8?B?SmlYNlZZc1FQMVBNdHRGY2NVcm1NRGlseklSSkFBR2k2WWZUL2RoV2E1bkho?=
 =?utf-8?B?ZEJiZzI0aWh3a3lQbnpCa29hZVZybW81MHVLMmZ1UHVoL3NuVXd2VWxZUjBF?=
 =?utf-8?B?bm52R256TEpHN3NqRWlHSE5ycWRodnJ5aW4va2hOU0cwNEpOMHUrR1UyMm5q?=
 =?utf-8?B?c2VNSTNkL2VFTWdOOEpxK2N5MlQ5UC92cXJoaUFNN3RQZmtTMFhPRlhxbnRW?=
 =?utf-8?B?YTBlekRTQkxJYkRNNitGaVYxNFR3b2lOYzY4Y1lvZjVIREVSYUlOZUp2M040?=
 =?utf-8?B?YkI3NVZwOHpIQ09oMUxKb2FBWkVXV2s4S0RyWWlnWC9MUlZBVFNNcC85K1R4?=
 =?utf-8?B?MU1UWGZUZ21vSDY1RE0ydHlFeHpQaEdwYnNSS0VJQVZ1YnB2QS9qRWlWcHJD?=
 =?utf-8?B?NEZ2Rnd3eDJMWTZIWFJhUUs2TC9CZ3ZENXFyR0lOcWVnMm5kVnFYMXBGeUNn?=
 =?utf-8?B?VStoSURvUUlPU0l5ZmZxbERvWXJkd3FzZ1JsYlI2akxaK1VSOXFnNW5iZWVU?=
 =?utf-8?B?UWFKaG5jY0l1WTloaWlWVnY4YXZsZGdKMFU3OWltRE16eHVIeEZjTUt0RlhR?=
 =?utf-8?B?STBCZjEvN0RqSjlZRythdHZNaisxSk5YZnEvWVZETVl3VVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2gzNkpuS05iN3grQWNqeWh6QWFkNWNsZThxUUthN2hYN0FvQzVyVXBwREpV?=
 =?utf-8?B?M3plbTkxYkk5ZWU1c3o5U1RRcjc1K3NYQkY5UjNGR3dnSkdicjhVbEw2NUxL?=
 =?utf-8?B?U1hIanlqb2ZNNjNITlFROXh2b3lvRHd0c2JBK3NVbFl0cjdXbHZkMkJBeHJX?=
 =?utf-8?B?WGw0VVlTNXk5S3ZKeWlOWFFjQzVoTzFxSzYxM0JQTkFIN1dOb1FRNURQbkUy?=
 =?utf-8?B?ajFNWUZlbDgyRndMYU4zUmpsb1hHSWl5bVZ6WVhiL0xQWlhlZU5zVTc0WVZF?=
 =?utf-8?B?SUJ6MmVJS09wVmpua0Y0d1Flb25MZ0k0YmJvVy82WTFOeVV6TEhuZjVKcm1r?=
 =?utf-8?B?cUhjLzIwaVdDU0VVMllENUVtUTNaK3BoT2Q5WEFYazhMaWUvcEVQbVMyakZF?=
 =?utf-8?B?ME05RXpha1RJKzVWcXFqbWtkVWZsbzF4UkVKcHB0N0dKcHRYQ2wwZWNhbnFV?=
 =?utf-8?B?MzhBYjhQY2R1akhxOVJTbjhTMlA2K1pFeTBhV1FDTDRWM0dPR01mYWxwT1g3?=
 =?utf-8?B?c2xHU2JEMlZ3U1pGTitVMENGbE9zZHROZ3R1ZUZwNVdHVUMzNEltRUJ1dDNk?=
 =?utf-8?B?Ni9aWndad2ZFV2FhVjBWdE9KdUJUYjJZQnRIVjEzUG1yaURBY1VZRmRCd3M3?=
 =?utf-8?B?c3d1bnM2WFBmOTY2YmRMWk5reFR2VXdtSzFoYzdicVpDbFpmaVFpZnh3RW9B?=
 =?utf-8?B?am9kcDAramxDOTFOa0U4VmszS1BqT25NRDNSMENiR29lNkhGQlAwTUN5cnQz?=
 =?utf-8?B?TGZta0VxQzQxeHYyb1JUdEZJSGl1bHFmNWcrS2VoVlY0ZXBkWHh4TzZaZjd6?=
 =?utf-8?B?TEhxLzJmYjV4NmxMdnd3TVFYeWt5SEZpSkRkdHc5RTNPUFpLcjhaMWhFTXZQ?=
 =?utf-8?B?dWhEbVkzbW1Yb2E5RzVYNWNRZTVJNkpYK212T3pnVzR5L1lyNE9MVmg1RE5a?=
 =?utf-8?B?Qi9CVzZvVzFGRkt2ZmE4VUVvdVRIZEJ1ZGNNTEsvM0ZDYXA3NXVvOUorSVp0?=
 =?utf-8?B?dHgvYk9JQ2lYTVVRVHZEMGNJSGJLYUFTNDc2Um95eTU1UFRha29xRXdic3hv?=
 =?utf-8?B?WllBdVc4TmNDTTZRSWVMZGtVRkNnQzVkWE1SZWMvYnNINktZejhwWi9qWUNp?=
 =?utf-8?B?a2szckNxV3gvRkdQVU45cUlUSWVBZ1RHNk9LQ0wzQnk0dWQwa3ZINFV2elhB?=
 =?utf-8?B?V2pmRkNGSFlXU0lIWGpKblByc3VSaXQxNE9ZVWI5N0lEdWk3OS9oOStuQ2M1?=
 =?utf-8?B?dThZcDYveGIrMGk2eURaYjVUSWZrWVdZSEtyczFsUnJ5Rmh2aW5LbTdDeUha?=
 =?utf-8?B?c3QxSkFabTl6Q2J4QWZsTDVHSXp1d2dOMW5WYU16Wjg5WXkvdmk3bzBRMFBv?=
 =?utf-8?B?ZytKOG50em5NZEcvZ01EVFEwem1BcngxTFh0Qk4rV0N2VmRkQWQyUVlYQ3hC?=
 =?utf-8?B?Ymo4QndZa3dldzYvV2dQV2ZCMXArZWlmWnFoNThZVEN0R0VBMzlrVHVyekhu?=
 =?utf-8?B?NWlBb2lDS1kzdlhrUHNXd1gwMlh1ZHdCbFdQa3NnWlRBTnE1Q0w4V3BkT2Zt?=
 =?utf-8?B?dnczOE5TVFBXRkMrcjZEelZGMFhtdzdxM1ZEWjBrQnVhaHVxL1RvUk8xbytm?=
 =?utf-8?B?NTNqN3BZbWdNL1dCbEN2KzcxekorOEhqV29JUi9aR1hCZTVpWkhjUVhCN2tU?=
 =?utf-8?B?NnNQNG56UURTK1czUVRQcC9wVGZlaldzY2hUZm44TXZkaXl2cmZ3MW42dkVD?=
 =?utf-8?B?K3RMN2J5UU04elNVUkZXOUV3K0RnRVlIUU56QUZ1MHl0dngwSEVxejdRb1hT?=
 =?utf-8?B?aVZJM1hwUmFvOTkydnltaFF4dWVDOGljUklscFZncmo5QXFjYjhES2g4ZkpF?=
 =?utf-8?B?Zk5OcG1UNGVPbFo5b3IydUlvT2pzbW5CTjBadno5OHFGbXYyUzhLaXJSa0tE?=
 =?utf-8?B?RDc1ZThtT2xKOGhXZ3lQcHJYR1RkdHFDZUdsMUtaUGZyTEFRcXZqV2NHS2l3?=
 =?utf-8?B?WTlXYVg3cHNhVURCekdHamxyYjNjVm1qVlpQWnFWWGZyQmVQQUQxN0dzd1JT?=
 =?utf-8?B?MFkxVHVESll4MHBTTjRaYVNkTWlIU2tXU25vRFpTZHFLQTRKTTJ1MUNOSG1X?=
 =?utf-8?Q?Pu4/gNn4C2+gzdqnMlbri29I7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e01e7f96-f752-4552-16ab-08ddf42b9607
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 07:43:39.6403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6P2VjMgxzjZO3H1IXq/v28lbgxQ5BrtRJi6Z9n0t57dvUYhaqBmSKr8BdGTnmruIUSkd9R5FJq6D8D3o3TkuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFDBFC954F7



On 13/9/25 02:49, Borislav Petkov wrote:
> On Thu, Jun 12, 2025 at 06:22:33PM +1000, Alexey Kardashevskiy wrote:
>> QEMU Inter-VM Shared Memory (ivshmem) is designed to share a memory
>> region between guest and host. The host creates a file, passes it to QEMU
>> which it presents to the guest via PCI BAR#2. The guest userspace
>> can map /sys/bus/pci/devices/0000:01:02.3/resource2(_wc) to use the region
>> without having the guest driver for the device at all.
>>
>> The problem with this, since it is a PCI resource, the PCI sysfs
>> reasonably enforces:
> 
> Ok, so I read it up until now and can't continue because all I hear is a big
> honking HACK alarm here!

It is :)

> Shared memory which is presented to a guest via PCI BAR?!?
> 
> Can it get any more ugly than this?
> 
> I hope I'm missing an important aspect here...

yeah, sadly, there is one - people are actually using it, for, like, a decade, and not exactly keen on changing those user space tools :) Hence "RFC".


>> diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
>> index 8da3347a95c4..8495bee08fae 100644
>> --- a/drivers/pci/mmap.c
>> +++ b/drivers/pci/mmap.c
>> @@ -35,6 +35,7 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
>>   	if (write_combine)
>>   		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
>>   	else
>> +	else if (!(pci_resource_flags(pdev, bar) & IORESOURCE_CACHEABLE))
> 	^^^^^^
> 
> This can't build.

Why? Compiles and works just fine.


-- 
Alexey


