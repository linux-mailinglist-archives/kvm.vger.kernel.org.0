Return-Path: <kvm+bounces-25224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E86961C70
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 05:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69AE2B213F1
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 03:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C4A13211A;
	Wed, 28 Aug 2024 03:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jqBKzBVx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2056.outbound.protection.outlook.com [40.107.101.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C688288B1;
	Wed, 28 Aug 2024 03:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724814061; cv=fail; b=oIB+aY0ovoSi7WwG9gJNU6d+G2fq0yP+Mi4g1KYX4gQ9nYbwS6PwnXpYNXmO7Y0p5lrGFvSalK/o9Y4/2DIsJ4QEkAbF5XtgVs0nVtYYxssFU2JU6CGdUah0rmBZF9dfrlTaYjLJPLfhYsnChr/Pj4iLu7G73c4pq0TuVo7yWkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724814061; c=relaxed/simple;
	bh=zA02WME0Zu2lA6gfS/UGAD+sWAMrqmoLzyIDjza4gEo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lhYdM7VG06r30fbWEwESZoYjz+i2+GhR1NHqPdfAGXkFQlMyD4abHQBAQGIHD2h2sd0UMA6RteljyA8y9i0Cmr5eZWVL/7aKfRedrKAnjfyeCY3viKALGvsMozxe6G9AsWmDHUkpaPRg+XccGY+26L6hqzq23Jpdh9z3A4dx4FQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jqBKzBVx; arc=fail smtp.client-ip=40.107.101.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w3lQVDliAJ6O94tQW7jqI+Gh4P4USQu61gDh30Dm/9yQuoHv/F8uHWn4jxI7sFWD+WBQa/sbQFw5nnx8qcxOAPx06xgFpV0iyiqvmFWZsjZK2OIoWQA2FNSAB//X+bNaAVAwx8OI+JeX06h3ALx1MmeV5WhPJGChyYlmIJcZMqFYgK9WhkrcoHKj83514PrkFleKiiT1Vy7nSeahBPnPyXoAD81oNssl3zsiZ71QnDiofSWKlhMXC9Nm3OfRlyu4BdwvqoK5Rz99zx6XjvjGwSYMw/X6pG+FXqexA5Kvv/0yH9uB15dt1SzOQylGJ3RycDzVgtG1Gn4OZXGwETMDzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2nYUjDcOvMtUdtvpKx2Lh7GfAqu17DdjNphl0YUlgc=;
 b=KLCzENjchx1COzNzahAkLG9xmIkYUooKI9knTbgvX8eNjHQI4yc4G9+TV7zrBFEBxXZqX45+RlotMKojiEjX7wjNGMZy7dkYnsk2jhd6YfExG7JViWnJBs1vumB6AdUdrYcWhlUe/TfY9JeHH+dc48ittAB6CtXa/rANjZWm5lD+/anOAETKB4vuoNhm3spd7rwGsOb2raV4K9jgPRNY9pV3eB8VnBw8/l6wl0M8yHDQoGvr2AbcAwwE269z77f9qswAXAh5I5zA6rP3BrEPOFNCIcyX02GnpEKIFVseWW7XceWT+NBlzQtjMfy3iLM2/Ktm02k6bzs0vzsewPvtDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2nYUjDcOvMtUdtvpKx2Lh7GfAqu17DdjNphl0YUlgc=;
 b=jqBKzBVxHaNj3LT+0p8hVq4vcSLNPMPaNz1UboPKgfNs0w+kRz50//VMKita0+gVmJbP3tli3nfRL1ntuJmOnqwl7W4iS2nA2/iHhQum8y1H6oQN1NNtM0X5qfVNhDJTNpaguZwa9MbSvBW3ZnRc6mJylVpr1fOYkkanTcHmFAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH8PR12MB7254.namprd12.prod.outlook.com (2603:10b6:510:225::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Wed, 28 Aug
 2024 03:00:56 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7897.021; Wed, 28 Aug 2024
 03:00:55 +0000
Message-ID: <6e9e4945-8508-4f48-874e-9150fd2e38f3@amd.com>
Date: Wed, 28 Aug 2024 13:00:46 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com> <20240827123242.GM3468552@ziepe.ca>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240827123242.GM3468552@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0053.ausprd01.prod.outlook.com
 (2603:10c6:10:e9::22) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH8PR12MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c03a51-fe2f-4cda-8d80-08dcc70da254
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTVQNGViNjV4RjdoZHJmY0lDckI5NmU2WGIzaWNYZGJnZ0FrN01JKy9LajZw?=
 =?utf-8?B?Skp6T0dWNEpJOUZvclJRcHp2dHRnQzV4TXR6aEJYNmd6RCsrNndLWDBaSEVn?=
 =?utf-8?B?NEFkQWxhbW8xUUI2WDArVVpMUXB2R2xBRFdoSWUwZUd1b3B3cktGdlAyR2dr?=
 =?utf-8?B?U2drSHhEK2t6UDdFR2twYTNCK0daTWhrR0V1TXZubXJSYUlYdXV1MXNNbitR?=
 =?utf-8?B?TmQ1cGpQUVIvVmswdUIvNWppNXIvQzY5Z0VUbFlGSXJDN0o0THFRNmdDcERN?=
 =?utf-8?B?SkdWa0k5UmJ5S2RVdU1ya2twOUdCVjF1dm5Qb1kybEFKOFZlL2V0MUE5NFJM?=
 =?utf-8?B?ZzZPSXBlSFlVTHJrc3Q1VnQvY1NZdXphVVYxc2FDVmJ3V2VWK1MvV1l1bFdK?=
 =?utf-8?B?WHJTSWE0ZjdpTjRXRkJuWWlpZFJiK3Z3STIzM3ArWnE1RkVoVXlyYjhzS0Rv?=
 =?utf-8?B?Y2dBT25yWE9KZ2xMTWhyOE9mNU14TjR2SUpuWFZKaDdCL2QwL0JVUlVxSklu?=
 =?utf-8?B?N3FQU2F0MTBMUEd1QVZwMUxVVGZqamtLYUVQNW02TlpIVWQxUWFQYXNuQnNy?=
 =?utf-8?B?TzY4L0hPMVJGdE9WVEJWZUZQZzY4QTF4bWsvNGVYeFAwZEltMUFUcXA5dlNp?=
 =?utf-8?B?RWdPT1NxcVRjRVVvd3Zqc3ZSWlA3SmV1UnRyRmQxeWpQaitCWVdEMkc4M1NO?=
 =?utf-8?B?d2RIbmhCMDFXVWZBL3BhV2p4aHFLbHR2ck52djIvWU8yVkRSMGhOWXJlUm9N?=
 =?utf-8?B?ZjZsdGVqTTc1MnBNNnRYa1JGbnJaMDN6dU1HZVJTR0RPWWJHMFNLOUFESDM4?=
 =?utf-8?B?VEp4QU9ZSlFRTVdaSUt5dGU2VytDTmhSNFUrVTlEcFhpWnJWZHlqZkdXNWVt?=
 =?utf-8?B?Um1kNDFsOEE4MnY4L3JDY3REQ3BOWmd5ZmlBcDU4bGVmTVRjbHBTTW9WTDRU?=
 =?utf-8?B?Z0J1ZE91bEZVNlZER2hYNm1tL1ltaHJwOFJsTGNqVEl6cG42MnBZQkNUdHUw?=
 =?utf-8?B?aFZKM1pNeGJXU0Z6LzhTRis3OTJSK0xlaEFYajdBSzQyVmFnQUc3cGZYVlJ5?=
 =?utf-8?B?KytXbmNRYTJRelEvTUtab3hOOVF4ckZNYWtZMFNzd3luK0tFa3J4d1Vmb3hk?=
 =?utf-8?B?c1B5S0tXQXl2Mi9vd3hMNjh4SDNaREUwbDZ2MXFVa1I2S0VjY01BOHk1T1BW?=
 =?utf-8?B?Z1cyeHFxUHdLYlNMWmZ2d1JObmJFSmlCcmE3REl6blZTYXFqSEIwWTRtYVE4?=
 =?utf-8?B?akorUFlkOWYwZjk5Vi9rVlc1UWhoalpodXNUUTE0MThXOUNSNWIwbGFIblFZ?=
 =?utf-8?B?ZEx0RXZ0ejlSZzA2M1d3NDlrODJNMVJvVUN4c0lYN2NVTnl0UWJFekNrV3FX?=
 =?utf-8?B?Zytoa0Z5TSt6LzMyYnNRN01VNWZFTno0Kys2UHhZQmdoYVNzdUpiUFFqTmhu?=
 =?utf-8?B?YjAvaDhuNVpiUUxFNWtaaS94WTcwTm41NXZIZTVyVGRkdkxnWk1RTlc3U29n?=
 =?utf-8?B?bHpPNjJ1d1pRY0YrZEVhTnhERFFwZGwwZ0ZWU0I0Ulp1WWhQWmg0U2NISWIx?=
 =?utf-8?B?RGtMRzdzbU5WNzdJMG9hUjdHdFN6S2lUMnRnTmFnNEZmSGhRUUpEQW5Jb1Yx?=
 =?utf-8?B?NEZVWVNpTFlxZmNxVVNaU2lva2dhSUVBWFZ6TXA4ZFV4TzNkUEtaMjM2SStS?=
 =?utf-8?B?UkV1dW1SRnZqaFkyT2dDeUNQakh1ZjR4TnNEbnBqWjhuUUF6cGwzUWVVMmtW?=
 =?utf-8?B?dTZ1UzZaZ1JxdjNaZWpYbXhvbm9DeklsMGJ3c1liVy9qMDIrSTJ4VnRZRlcz?=
 =?utf-8?B?cCtPdnhXbi9LNWlHSmpIUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWhLS0dIcUJzY3NVSVB6Rng5RitDYXhZQUJTc0pLUVdrQ0FqekwzVytzUXBz?=
 =?utf-8?B?T1RIM1JEdTJpT3c0M0czQ3I4RFdHRjBLdUJzanVIeTBTdU8zUHZwVmp3UFhk?=
 =?utf-8?B?alNiYVN3TjVvbWNZaU5rQUZwb3hkZEg1Q1BMMGZUNmpkNHd3SHdCY2s4QmNr?=
 =?utf-8?B?N0cxZGlObklnbnArTm10RUhrdjZRUkFETW82Y3NJaGRTejNlUXZXeWViUEd1?=
 =?utf-8?B?WUk2VTJsMVhHTmRVcm54dHYwL1laMUVYd1UrUU9yelJMMnV6MGVERmxhcFpi?=
 =?utf-8?B?ak01cFcvOS82Ui9RbER3OWFqMFlMcFBnMEpVeHBmaUZWR21pSWd2dGZZczRm?=
 =?utf-8?B?NS9Ub1J4NnBhUXRTZ0s0SWFUNGV5OXhHSjdKQmxBQlkrV3lXamlXMmcraXNP?=
 =?utf-8?B?ZDFRR3o3RVFEMzkvWnR6YWlqWVNqajRTcU8xaXJqOU12dm0yY2JyaTJaZ29l?=
 =?utf-8?B?dUdxcWFrNWJVT0VCTnl1MFRVSTFIdnlDRkx4WnA0Ym9JbWlVZGNCMXBHVEVm?=
 =?utf-8?B?WkxXWHkzRHhVbWdwWjBpSlNMeVQwQ3VvR2MyYS9rOGFnczlPZGxyRXgwZmli?=
 =?utf-8?B?eTJ0ZnMrS1NIeVp2VEYvMkJJdnA0OTNIeHF3eUNkMVNVa1ZKNVdLZFZ6NXc3?=
 =?utf-8?B?Wi9nZGx2VHY1Q0VmQ1FQcElzQ3pNNkhXTnpyS0k5Y09GTEd0YVRRb2JuaTln?=
 =?utf-8?B?aUpIZzNpdHk2Mnl1bFpoaHZyNlVWbyttS1cwT3N1UXhIS3pER1JLTnFtbzJt?=
 =?utf-8?B?MHIwNWV2ai9oWC9haEVtMHV4ZTY1V0s5dExwSFk5SmVySTc0a0JxZWhwVWEr?=
 =?utf-8?B?amNvWEdndGtzUjRCVjVQR0ExYUMxN1R1anZuQStzTmd3OUZYNWI2OEtwMzBm?=
 =?utf-8?B?Q2ltTE5xYWJmRnJySVBYNlJvQ2ozWEhlRk51VDVPNFhVdkN2bi9xRUNnL0pl?=
 =?utf-8?B?SElMc2F2OFpOQTBsalZ5K0Rhbk94dUN2SzlpSmdQMC9zelFQZDdUcEdLUk55?=
 =?utf-8?B?K3RWL0N2aUl4cXNCeksxK0RVa0ZuQjhHMWxkRVA3NzJrYnFiRVd2WEtoWG9V?=
 =?utf-8?B?M3JnVXV2UXBUb3F4bGJlYjJYeE9MY09JUzk1MFhTTGJzZk9DVC9YdTVLRUFU?=
 =?utf-8?B?RU5ZR1cwOXBtbE5HanZXU2xQc044VGpYbVp6TlBxNU5EeGJDNnlIR040Unlw?=
 =?utf-8?B?Sy80UWh5UXNFQnFKWG53L0w4YmdtZTU4bDYvYU9aWmN4cDNQbGJlWEJ4ZjU3?=
 =?utf-8?B?dFFGR3JJbjZJemtxdzhRbVBKVXc0RzVTT203cm9vSVF0bWM2ZDJITWRtZHFn?=
 =?utf-8?B?OW1tZWFsaDFNUmRRazlPbmRqdXFOVmxLdGtkUGJCM05OMmZQRzg0eE1IS3RE?=
 =?utf-8?B?dE5rWVJISUR1TDN5LzRXZ2h2TjZvUy9BcEI5aHJGbVNmSGFHK3lFNDgwWnFz?=
 =?utf-8?B?RllDZTlTWjdoWVpMMmVEeUdwQlQveHRlSmlDeDNxcHFoanNEMVlQeHJlRW5q?=
 =?utf-8?B?dkFaRkljMGJNY3VibC9iSmozUkQ1UEoxcGxXMTNFMmZ2RGRpOFU3aGNINjRN?=
 =?utf-8?B?ZWVCcm0wU2tReW1RbGZrUGRpVXVORmpnNWljN2dkdU1jbm0zbDRVaFBYb243?=
 =?utf-8?B?MG1KK1p2dGtVUmtMWDN4M0dVYTJBcUt1eDBiTEZwTUZQQ1ZPOTVPdVg1aFhx?=
 =?utf-8?B?d2FzZGFJNDRwOEZFMU5za3ZoV3VaSHBlWVlicmFaTHVQNUtSaFNKOFlEWUlG?=
 =?utf-8?B?Q0FvbXVLYWRhN0RhRzk2U2s2K3lFQ0hWa2lBNGdIeDBmc1J6ZWFyRnBhdlMx?=
 =?utf-8?B?L0xwYjUwN0tVaDZ1RG1MMWpud2Y1YVZIZDRSWkwxRDRNUUNGUG5jVXVwUTJp?=
 =?utf-8?B?TXUxWkVlTmJFN2Q3VFkxeW1RcjhRZGo2OVI2L0R6dXpVSGpSMnNJeHgwZUpt?=
 =?utf-8?B?My8weUtIU3IwQTNNVmp3L3JpZXFnc3ZIeXhVNmwzU2FHUHUrTDNva3J4S3h5?=
 =?utf-8?B?ckQxbklOaTdWbHBDcFplRmI0eGI0cHZVa0Myck5qMXdrbmVsTjgyK1VuZ0xB?=
 =?utf-8?B?RDRLQkJqcENBMHpzRnRqRjlEL3pBS2RldVUxSkJLQ2wzM2Zlc0g4MVdScHov?=
 =?utf-8?Q?1Gdx1RsHzNgNnsj2ZY+0zRPT3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c03a51-fe2f-4cda-8d80-08dcc70da254
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 03:00:55.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJ8tFR9bZxaSR24zShHEPKWiJi+rUGkYj6pGXYWS4157Yx0Jh5C3fZjoDshuAIgK3+1J9igHE6V9fVauYaVKfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7254



On 27/8/24 22:32, Jason Gunthorpe wrote:
> On Fri, Aug 23, 2024 at 11:21:21PM +1000, Alexey Kardashevskiy wrote:
>> The module responsibilities are:
>> 1. detect TEE support in a device and create nodes in the device's sysfs
>> entry;
>> 2. allow binding a PCI device to a VM for passing it through in a trusted
>> manner;
> 
> Binding devices to VMs and managing their lifecycle is the purvue of
> VFIO and iommufd, it should not be exposed via weird sysfs calls like
> this. You can't build the right security model without being inside
> the VFIO context.

Is "extend the MAP_DMA uAPI to accept {gmemfd, offset}" enough for the 
VFIO context, or there is more and I am missing it?

> As I said in the other email, it seems like the PSP and the iommu
> driver need to coordinate to ensure the two DTEs are consistent, and
> solve the other sequencing problems you seem to have.

Correct. That DTE/sDTE hack is rather for showing the bare minimum 
needed to get IDE+TDISP going, we will definitely address this better.

> I'm not convinced this should be in some side module - it seems like
> this is possibly more logically integrated as part of the iommu..

There are two things which the module's sysfs interface tries dealing with:

1) device authentication (by the PSP, contrary to Lukas'es host-based 
CMA) and PCIe link encryption (PCIe IDE keys only programmable via the PSP);

2) VFIO + Coco VM.

The first part does not touch VFIO or IOMMU, and the sysfs interface 
provides API mostly for 1).

The proposed sysfs interface does not do VFIO or IOMMUFD binding though 
as it is weird indeed, even for test/bringup purposes, the only somewhat 
useful sysfs bit here is the interface report (a PCI/TDISP thing, comes 
from a device).

Besides sysfs, the module provides common "verbs" to be defined by the 
platform (which is right now a reduced set of the AMD PSP operations but 
the hope is it can be generalized); and the module also does PCIe DOE 
bouncing (which is also not uncommon). Part of this exercise is trying 
to find some common ground (if it is possible), hence routing everything 
via this module.


>> +static ssize_t tsm_dev_connect_store(struct device *dev, struct device_attribute *attr,
>> +				     const char *buf, size_t count)
>> +{
>> +	struct tsm_dev *tdev = tsm_dev_get(dev);
>> +	unsigned long val;
>> +	ssize_t ret = -EIO;
>> +
>> +	if (kstrtoul(buf, 0, &val) < 0)
>> +		ret = -EINVAL;
>> +	else if (val && !tdev->connected)
>> +		ret = tsm_dev_connect(tdev, tsm.private_data, val);
>> +	else if (!val && tdev->connected)
>> +		ret = tsm_dev_reclaim(tdev, tsm.private_data);
>> +
>> +	if (!ret)
>> +		ret = count;
>> +
>> +	tsm_dev_put(tdev);
>> +
>> +	return ret;
>> +}
>> +
>> +static ssize_t tsm_dev_connect_show(struct device *dev, struct device_attribute *attr, char *buf)
>> +{
>> +	struct tsm_dev *tdev = tsm_dev_get(dev);
>> +	ssize_t ret = sysfs_emit(buf, "%u\n", tdev->connected);
>> +
>> +	tsm_dev_put(tdev);
>> +	return ret;
>> +}
>> +
>> +static DEVICE_ATTR_RW(tsm_dev_connect);
> 
> Please do a much better job explaining the uAPIS you are trying to
> build in all the commit messages and how you expect them to be used.

True and sorry about that, will do better...

> Picking this stuff out of a 6k loc series is a bit tricky

Thanks for the comments!

> 
> Jason

-- 
Alexey


