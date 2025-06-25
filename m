Return-Path: <kvm+bounces-50678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E816AE82B6
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AFB15A3797
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 12:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96860260567;
	Wed, 25 Jun 2025 12:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2/kpZiMs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713F325DAFF;
	Wed, 25 Jun 2025 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750854408; cv=fail; b=J2ppH5LATit39l/mj/i+wjACm7u0N1Tu4dkxDjy0Joj5Y//9wqGtBHycrvtkPAi1kaO/XkJukjdrZcgEIKgyvpxEkRM+c4DQDEEVy1BGdUxQ/Z8GnucCNSNs99/XJDUIit6YlcFfe5pbRCPIjZg+ZgWsfcoVteqtW+UvWo+s9Ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750854408; c=relaxed/simple;
	bh=I9vbeENbKdaMHoAL8VR5mGGQ/ULKC+fulnJ+wwDsykI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tdHPyVbqdB7V8YZYPfrP0kGHUgUGtGsTM+cW2L/Jb0KogdlMswMeOYdOci7bel1mUEpmtODGaovUyOCp032C6LDEGfJ3nab64MkEjyQ1fqg/UTGBjJ5v34Ica4TlRtAkjCoMBDF7DRt/yFNx7YCzFdYFVTttO+WqNZ0d/4mRPq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2/kpZiMs; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aE7hHdzbLS+GxBYEA5mKnOhqiFjfJmkFIEdBR2iCXkM6QNrknQl2+0hgwHRTkkojAh0tMrwOgG8Kp2GUhBeQFy1TaW4AnKjscXlUhMIs33n34rWFQdY1Ztum+j1gWJMOgF7eTpI9j3cFxg+RQLfM/vcEqUS8twGEwuO6RwvWtwTEMGZom5qTGuwNtJgt77V7DUWVwxr8ro7WAvwgNGWPC1asHW+3R3pcOMFZm7u58RrIP5f3KxtSngohq1JzFcxFwMh/EMdVdwsUXlcdDh6NirsCqeSZcA3bifu8aIWsHbsTisL8jJlBOVAvmp5cALF6IV6aT6O3H4LryxqAhcjSwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kEAar1AcZfmQmZBi8p0dGcnCkpwdouqtSwCjOIdKik=;
 b=yVyPvp2yBOD6I+OyoXcp+e+k4XUw+ro8Fj9ZHRsUQAQ6+0fpnRxhpR7ZQhcbD1Q+7fOMaqArN96OEolyw7ej8B36CpybUmQg/q3EaQyUDwgy983+Qeyl9U/It8oc2CuD5w2ReW/4pBibCvjP64FWpMnpNtn310BRxKW2sA1OJE/ou/ZZXWzlgZyx8mnMUF8zGhd8S9mZQsb0SxPHhOQt9x7QbNNAp75KcVvK5go9p3CUW0xLx/6ProNKC8B8M/qBHtMTr1X/swtvzGvUzvem7/ISn8+DNgdYmv9n0EoIfW+Cm+gDgAgMm31t0b+S6Owy/HMSN86QDBiHBgqDaohxiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kEAar1AcZfmQmZBi8p0dGcnCkpwdouqtSwCjOIdKik=;
 b=2/kpZiMs1JXToD+70UO6/IXTpQCVl/SJ5cFOYU3TJEPytgjiOUA/EURoNLf22YZ2b4D29O/AG3G6fw11ZpbfFm0riKHLUnEIPfwKO/7oF8ov8Kwy7SMrmfCFksaJvfByMRthcgTeZ69KbhWeA2yL8M2N6n9BZXbpVlmYrNHOfA0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 12:26:44 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8835.027; Wed, 25 Jun 2025
 12:26:42 +0000
Message-ID: <cbae3475-0c4c-4a71-af8d-67cc8bb7de21@amd.com>
Date: Wed, 25 Jun 2025 14:26:39 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: guest_memfd: Remove redundant kvm_gmem_getattr
 implementation
To: Shivank Garg <shivankg@amd.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bharata@amd.com, tabba@google.com, ackerleytng@google.com
References: <20250602172317.10601-1-shivankg@amd.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250602172317.10601-1-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0127.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::11) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SA0PR12MB4480:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a71a29a-9d5a-46ee-f0f1-08ddb3e38ab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SzVqVVJ2dWFLTzdyN0FjTWdOYXFKV3Z3eEI5Rnh3aXEwQVdtR2dqVlVFQmZm?=
 =?utf-8?B?U3lhc2lHQ1ZTc21MSk9HTU5ud05FRk83QlRkYmdZeUJ2RUlDTkl1NVFhakxR?=
 =?utf-8?B?Nkx0VXNjd2RtblNGaDM5RFQ5V0g1eEtudkVTeElYWkhaMCtsV0YwK21jMUdD?=
 =?utf-8?B?aC9RZUE5QzF3VkFOSFN3NCtIL1VET3NFbFE3cmc3UXh0eHRQNFova05vdXlS?=
 =?utf-8?B?aDd4cEtuZmMvTnZsWWczcWljZDc2aW91ZVJLbVFCT0dXYmZxWERXOEtSSWo1?=
 =?utf-8?B?T0g4SVFQYlF0c3R5clpLdnN2KzB4N2MzeEZGMEtGdGFpSUUwbUp4c2tjak1K?=
 =?utf-8?B?ZkRJd2RWeU5GcDVMSTRqVjlMS0dQckJnakVmUmhLTTIrd00zMnhoNE1JQmRr?=
 =?utf-8?B?YXhZS2dRRHp5ZXlCbVZWWlU3VzJqR2VscmozZVRQSWFaQTl5Q2xmeE1rTTRk?=
 =?utf-8?B?OTdMaEx4RlNvNm5rOWZIQ2tHa1EwZ3l6WVlkNjQwcDZpOE14YXViVWpUclN0?=
 =?utf-8?B?VkIvcTl4ME54eHMraWlNODkxWmFRM0o3S3JYSGwyZWJnYXRDcTVhYU9mdkhx?=
 =?utf-8?B?NDljdW9GOGRqbU1hVXRWUHlRSWQ1eVhyMFlqN0pWeVNKMzlZZE9Vc2FDLzBq?=
 =?utf-8?B?VFgwWGl4L09CSHMrR3VybElIQmFMb1VzVkV1VDZjSXlRaXViUTdrODJiQ0Nn?=
 =?utf-8?B?c1dyMWM3MDFiL3paelkyVXltYmVXWkRsSnRLeVNOUEhlN3VybHNwN1M1VWZW?=
 =?utf-8?B?Y3FjdTQxdFAwK2U3ckpZZnhyMzQ3QzROYXpQWU9VbHM0Rlk4ZW9rNUpzdzdY?=
 =?utf-8?B?ZEQzeGVEalMxNWNUZDJKVlZnR2RHRzg3c0FVRnhXSFVnZk5Wa2dHdkNrdlZG?=
 =?utf-8?B?TTcyVnFMS2dKenhvWTUwbGtzSGJvNmNlaDRUVHk0aTVPU084MFdPbFBORWgx?=
 =?utf-8?B?dkV3Q09PSG9RVmVHZzFMWlJrOUY5UjRZUVdWYkVKRW9tRWpWRDFqbDN0NGkx?=
 =?utf-8?B?M01tVTcwTlFXUlRwZVMxT2JweXpFa1lub2xiWldOaloxRk5aaS9xQnpXdC96?=
 =?utf-8?B?SVpTekc0VVZOcnlid21DbWQ4RmN2bkFoQUZqdkY1Mk1sdTZWY0RycytPRHo4?=
 =?utf-8?B?Tmt4djB3Njc3d0Rpa2xVV0RzTjZ3dUJkWXBhRE1zcHUrMDJRQ0pTSDYyMHhi?=
 =?utf-8?B?UzdVNGI1bkJxTGE1bEx5cVlwaWJyanFldktxOUlMME4xSHNMZW1hWHdSNTc1?=
 =?utf-8?B?cVhVeHVSMCtpekZxMW5zZm1FTVBCSHZlMzhMclBCQ2NaMkZ2clpHcFBQZVFG?=
 =?utf-8?B?SGcyZmRNVDZ3MEdGa3dPakpZOEJNNStBNDYyeGZ1L1drcjFFNlp0Slp3MHRv?=
 =?utf-8?B?YlRBNDRaSnlxVUdkeFBNb25mVDdjcFZteVlkMy9HOWZtYVlTUVZxT2UxZTFK?=
 =?utf-8?B?SmZhK3JjQ0lWMmF0Mlh4N3lzb2x3dVArZjJudzRLL0ladW1kcmlmSlIxdTYz?=
 =?utf-8?B?WFpRWG5VYmxpOXU3TXpodmtWLzNvTzd2RjhlS3k0VzhvYjNQenJBczFoYmNu?=
 =?utf-8?B?VnVPZXlDbzc0dTBodTE1MStIS005cWNJVEpUWFg0bjJaWG5rOWl3WFFPY3ZH?=
 =?utf-8?B?V0VsamZxY0RQVHYwT3NrQ29mUHFQYUhoOWhUUVhkOExxQnRTOWlheDdmQU9K?=
 =?utf-8?B?bDVyTStoK0JLVTZ3c3RGcG5mMVZaZ0FIREp3am03ZHlrbDhLZEdmb1FFSURK?=
 =?utf-8?B?amtOczAyUTVUeHJDdHNFWEZ2a0RuS05Rc3VETTAwc2EvM3ZTeDk2MUR1b1d2?=
 =?utf-8?B?b3RDczZZclBPVmc2TGZmT3NWd0dFNGlCN0prTWFCeUlKTjh6WnNWYVhtZ096?=
 =?utf-8?B?MTVqOXp6RmRFWjFNS1NJWjlGNHdSSmJTNy8vY2VMUDl3WHFuM3BMWUNDU1J3?=
 =?utf-8?Q?KlEGwEdTELE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVdDakdVM0x4ZzZHVWNkbENzSEdnYnNCYmpsRkw5SCtJN1JSSzVnRXE0ejhL?=
 =?utf-8?B?N3BXSWtuL2NBaTVCciszQWtBbGZaUUJEd3hqRGU3bHk4ZWNTbFdqMU4waW5h?=
 =?utf-8?B?OVJ2VkU1dkk2VGhubWdKNW83RXhscUJlVE5BQmpwU1BwME4yUXRzU2lVaXZa?=
 =?utf-8?B?NkwwamcvZ2U0NlhDTG5aZ2RLdDR4a0hCK1I0ckhYS1JyUGlsU1F4T3prWnll?=
 =?utf-8?B?Qk9oTG56dzlTbHlxZVZHeHhPNFk5Mi9vcUR1RTVkL0VlZ0J6ZlByeDJHNitt?=
 =?utf-8?B?RWc5bWpwS3dzbnJ1dkFhZGc4b2RWdEF6Z0FBK09INnNMMWtoOEh6U0wzZlAr?=
 =?utf-8?B?MUt2b0VDWWdnQ1I5NThORnFkaTR2Q2JIeFFUZk8zdU15YlpWSnJuNUVvTEVm?=
 =?utf-8?B?ell3QjRaV1Y2QUV3STJYc056WlA5eS90Qzc0dmVibWtIS2ZKRmdBRmJFSlRn?=
 =?utf-8?B?YzVpb3dtUlBMa2NISG1ldkRPcXdCY1JsV05yaXhnRjJrR2lFc2lHMkcwMkVW?=
 =?utf-8?B?dHVjY2ZLbGZLTHdkNDlxV0RpOWdWbmRkUGVkSVJldTB2VXVwWThNWWNlaXNP?=
 =?utf-8?B?cmZrUEM1V2UxdWpqdjRlVENla29JN3dhaEFEMVdCMnkyLzlWREV6QnAzMTd5?=
 =?utf-8?B?aDQ3ZExsai9Xc0grc0piT1Q3THptNVh2bWR0WmE0MFVxcEpZRDEvV1pTNEFT?=
 =?utf-8?B?K1lHejFYNHlWWG8yUHNtcy9VazNGT2laY3luWFNMVGJ5aW1vUXRhSjVyaTFt?=
 =?utf-8?B?MUJENDIvOGlxd2sxS1YzelRHdmtuWHMvZU52ZG55WUljbndSajJ6YW5ya2xy?=
 =?utf-8?B?anUvQTc3Sy84VnVuTW1WZHJSS2pxVjM2VHl6MkhUbG1mNnMwZlpzRCt3S1FC?=
 =?utf-8?B?TFBidEhjS0N4WlA0UVlMUC81eVp3WEpnWlIyd3JOYjFRSndtQVFNbVF0akJn?=
 =?utf-8?B?MTJvaUJVbEFWc2pybmNrc2Y3N3Ava2ZkeUIvakxENFJzSlhtdjRqK2hoSU1Q?=
 =?utf-8?B?OWcvMHUwUmdEdm9oN2Mrb01lVkhpN3dod2tiVEZkWHpuWXFaWWJMZWpNbkFY?=
 =?utf-8?B?dDYvbzRCcUJpd2NNQS82TStpUzBqcG5yM2NTT2R6Z1BsMTlEOGF2WlFmbDZM?=
 =?utf-8?B?cjZxY1Y0bkV1ZkE4cjJxRHdLWEduN3ZDTEFUSWdCc2p1TUhwS3VMRkNLakR2?=
 =?utf-8?B?WmtycDVyM2c4Uk9vWU1TQm16anVkbCtDNFZnQUkwc0hqYkhYOUtLSEJ5aW1Z?=
 =?utf-8?B?SmVvTzFHMGNGdTdFdTZvMk1hV21uOE4xdm5aMGRxTXYvVm9PLzcvM2lGeDlN?=
 =?utf-8?B?ejcwZnFDeVFaZnJFUHVBcWk5K3pGdnNNQlNPbFo1MzJJbmd3emgzeHVvTkdH?=
 =?utf-8?B?bzZuYWQvWGZvbEJJN1JLODBnRnkvVFVWNHk3T0RycDN4bHJjUGRWek13RXpN?=
 =?utf-8?B?bnZQbHc5QUdOclZyZkpsUkt3ZjdwN0dyaEhxYURLUjJFa2FQK0VtMHZGWVor?=
 =?utf-8?B?Mm1teTgxWFMxQWswR01vMGNMR1NJSFlzRlNZMkZROHFNUU80SkxTVFZSRUlo?=
 =?utf-8?B?NU54Zk9Ud2RKeHJHaTAzUWoxMzBRWGl0LzIrN2VBQlZmcmMrMzB2ejF4Vm0z?=
 =?utf-8?B?T3BsVzZSc3MvYWpUcWtmV2JMWWMwSkxZZzlwUldwMkZVUGYrSVZCb2VVSFNY?=
 =?utf-8?B?Snpmbk8yMEJiR0pESktqMHIxUTZEQ2FIOTlWZkxGN082MFNPUWwyYklhNkNW?=
 =?utf-8?B?bDRIanVFNUZrYU1GRGVlTCtPYjFRYVovcS83RXloaFdsSXBDc0lDRSs5elNp?=
 =?utf-8?B?NXBRdE1qNUNUTnVHR05obW4vMXpqVnNLU3hWeVJDK0ordy8vc202U24rS0Rn?=
 =?utf-8?B?Y0VwV0YxaEJ3dHZDMnpSN0wwS0tVN1l2NnRGOUhGTGdYRGp6K3JPRVlzcWtY?=
 =?utf-8?B?aUhUR0VZRXpDb0FIendZSy9reW9YV2dQOHF5SXY1WnBXRFVOODNRbWFUMkt3?=
 =?utf-8?B?SXBzeXQzb0d4KzUyTlFoenZWcFRndTdWMnltNmJON3R6K2ZEbzdiS01oSkFk?=
 =?utf-8?B?bjdtOGxINDQrM1VhTWtsWE9ENHhWTVBXNkdpblJWQUZXZy9TU1FJKzBsQ3ZU?=
 =?utf-8?Q?r8CGoG+6OsgL2bqFzqzKQpdj6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a71a29a-9d5a-46ee-f0f1-08ddb3e38ab3
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 12:26:42.5170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ov+iJ+kM9NhAJW7MsjfOtBU5i5Gff1EDSUBF1SnHARJ4uLVVpoWnCjN7pSwyXQ09Rcq1gW1mcjhKru603Gj6IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480

On 6/2/2025 7:23 PM, Shivank Garg wrote:
> Remove the redundant kvm_gmem_getattr() implementation that simply calls
> generic_fillattr() without any special handling. The VFS layer
> (vfs_getattr_nosec()) will call generic_fillattr() by default when no
> custom getattr operation is provided in the inode_operations structure.
> 
> This is a cleanup with no functional change.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   virt/kvm/guest_memfd.c | 11 -----------
>   1 file changed, 11 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b2aa6bf24d3a..7d85cc33c0bb 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -382,23 +382,12 @@ static const struct address_space_operations kvm_gmem_aops = {
>   #endif
>   };
>   
> -static int kvm_gmem_getattr(struct mnt_idmap *idmap, const struct path *path,
> -			    struct kstat *stat, u32 request_mask,
> -			    unsigned int query_flags)
> -{
> -	struct inode *inode = path->dentry->d_inode;
> -
> -	generic_fillattr(idmap, request_mask, inode, stat);
> -	return 0;
> -}
> -
>   static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>   			    struct iattr *attr)
>   {
>   	return -EINVAL;
>   }
>   static const struct inode_operations kvm_gmem_iops = {
> -	.getattr	= kvm_gmem_getattr,
>   	.setattr	= kvm_gmem_setattr,
>   };
>   


