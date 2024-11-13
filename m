Return-Path: <kvm+bounces-31791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B92C69C7B03
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 19:25:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 496BD1F26562
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 18:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCF6202F8E;
	Wed, 13 Nov 2024 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="INuQrpPn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E1C33997
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 18:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731522337; cv=fail; b=g6PWgnZV9dF9FYwkk47UHpBdA8iz19lMtSHEvVjUcwo3ScfORfSzbiwmHYqAdWCPZ+9Od7MTXjlIQB9r/6IpOxCM0yOS0NX2A2jpQaA9bF+N3xLTLM9T3Qw6fpWYQ01uIeyFswusZ4xUsXensiGtmMFTGXvTZ79LiOkBf2BuT9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731522337; c=relaxed/simple;
	bh=bj3GFx6USMN3LnqGrudsQqG3n/ApJA2YKxfpWbcO76o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TIXz8sPmzTLe5zUiEJWZxf2eQxYV1b1dD32iQt3eaXReviuPSykVW3Sp9JbeaSFAJngMdR+HMfy4o2Td+6MMFggO3qCsVZFjCMIZwqQmIHc6f4ZToaMJIV3aipYVDPRt2wCF+rrCU2eTqxvhdbpwcQFqjkkzJ/UY6aaKRysKz0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=INuQrpPn; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hevvBewwXuZqIgm8a+V9OkT2jxHQze5tG5nbNJcvTdXb4c9VZQJM9AbR4PDJ9iCkGUPFlZW6Gx8TKrWqYfLOuFPiTZoxzDhUbZZQTqLsf/PycZANJ6e72Oa8q/omgPT2WoNDsZvPzNMK+CbaRvXd7f8KlMBfo+m+vF1rwMDzjgkuC9KmwQcOR+dyUv3jVhmCbnh/Fn9qD+Nkvt+GMWaj2HymlkdU/USdXuyrtJ9jFcwoLlaoOcYsBT9gqMK0ES9L7tPFRZE1m6+G8xCg1XNFXgvbZ444H9jzbHgPUZaygtUO76kozlF1AI5x3jYxoWHrgzCoj29irSBOajDrBOMfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlV05eHXRX4LU1bvZ9mk4C72wcjMMFQ5aNTuO5rtYOc=;
 b=EPpv4NpZo8HMFmRqYsnZoEjV75xf8dMa3r1NQxgZsBdMMyqKm0JmQF+T2zHA34NaT1qN1u4J3dJFPXbO9nIWjyOxErtQ02pwgwrCcDDzS6RR3y0JLTyHef00ZLDGj2fYnj/p3HWGrFieJx+bTzEqsf/NHQTlpshKIyxNwf5JsDdvYHmE13QEdijTCOj0PPQG9I3pn7aKjgfIqEVlIJu9vUyk9L4nMT+LbFAZH08kQgw5rQNFKbHsQhnFGv+yL+c7tqw/CBJ40QhHUE6Alog8hcxpz5YvRa1n/E8BqDFMFWIyeULP4ArqMOb/2KNyB6LOA7ZS4keoeKZ7+OrPoWe8HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlV05eHXRX4LU1bvZ9mk4C72wcjMMFQ5aNTuO5rtYOc=;
 b=INuQrpPnLZmL8/guryhx88g4U+epIRiD+f1JNYbIJ+D0zjUBW4oaq/bej7oB1zEYHtAssBKb2swjo6CQ9e0lXE1SvOTB8C3O89CUxNdMnQUlm3okoMDijQ2gO4iF8LUWBNl69/n5PCiieT9wiKRXZhBwbFF4REfwDVfDF22L4jg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DS0PR12MB8574.namprd12.prod.outlook.com (2603:10b6:8:166::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 18:25:29 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::2300:2257:1877:4750]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::2300:2257:1877:4750%7]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 18:25:28 +0000
Message-ID: <ed2246ca-3ede-918c-d18d-f47cf8758d8c@amd.com>
Date: Wed, 13 Nov 2024 23:55:20 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] i386/kvm: Fix kvm_enable_x2apic link error in non-KVM
 builds
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, mtosatti@redhat.com
Cc: suravee.suthikulpanit@amd.com
References: <20241113144923.41225-1-phil@philjordan.eu>
 <b772f6e7-e506-4f87-98d1-5cbe59402b2b@redhat.com>
From: "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <b772f6e7-e506-4f87-98d1-5cbe59402b2b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::12) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|DS0PR12MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: 49e1d65e-73bc-462c-0fd2-08dd04108cd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVFWVm9NZlF0dTFUeXZKcDNVT0tFSDgrQWFEOE1tNGptU3VOcmZEcDM3TXU5?=
 =?utf-8?B?YU9tVHhIRFJiZWUvWHdlaXJDTWdIRlRRYkJPTXQ1SzVDM3JEOFNUV2laZ3lH?=
 =?utf-8?B?Q3d5cndMQzB0TC9iM09xc1NzWXhFclpleDNVRzZ2ektaUkRzTDFRNDRqUkFM?=
 =?utf-8?B?ZGFta1FxbURCY1E2SUtEOWQ0NEtoaGZiZ0JDeTlaTkdzaFQ4VDZ3S1phTG9n?=
 =?utf-8?B?WUJLOEtMcUREczR3QTRTOHArOXFQSnp1U3hMdEI5a3RUeVUrNjAxUXRCY1ZX?=
 =?utf-8?B?d1lqUHhleENkeVZpNUJBOUR5eURLbkU3c3QrSHBQNGtXajlzblB1WmdXc1Ji?=
 =?utf-8?B?Qmg4aXJDcnBWQXZrOWY2VlFGeERWdE5XaWdvZTNpVVhFY2tUdkhLbmhjVERK?=
 =?utf-8?B?cnd6NkxjSnNtdmxoc0NLbWduVElPZ2VWdFVzSUZjQWpzY2o2TnNyekpiUjRr?=
 =?utf-8?B?SWhtZ1RxUkFVZHpBYU52NmExVEZ0YmxNdHY4S3hWcWVPZEtQR2ZPVU5KVEFK?=
 =?utf-8?B?cGRnUC8rMWpYLzUxT1FRbzRiZWVialBiRG5pTlF3S1BlbUZmWFIreGhnVTdm?=
 =?utf-8?B?RHBTUm1hdndaamd6UjlBY3N6TVlsS25pbDMxaWN1SHdsVlNmVEExZllFR3BI?=
 =?utf-8?B?V0NzN1pJeitPbkNlNFh5VFRVZ1RJUlhIZWR1UEhmZ0M3cThSQVFCakxFNFV3?=
 =?utf-8?B?UWo5V0lqclNDZm94TXVzc0pOWWhTNkVnUVhLK2ZnSWFQTFJEdlBnYmwzZ095?=
 =?utf-8?B?ZFQxc0t2UzdjVHhRMUhHU21YRmoreU1nVnlFSEhxUHJuSVFWaTE0Nmx6UlJm?=
 =?utf-8?B?TzBYVWhJSUlFRFFZalpoUm5tT20xY2dHai8veHBYYzhCamo4TE5YMTJWZEFE?=
 =?utf-8?B?RkNHbE9jM2tkWFROVC9MVm9vNXVSWkE4QWJFUWhvdTNvY200OXVkWk9UbTEr?=
 =?utf-8?B?Z09jWURPdGt4cS82MDJycGdyYmU1emN1TjVXTkErNjR3dU5qWEZXbTcrWE0z?=
 =?utf-8?B?bG92SE1ScW81NHNjeWhQemNydlZQNE1CRTBVa1hhcVdtZXNaVFR0Z0RuVU5q?=
 =?utf-8?B?cEhNcklBQk1RWHcwOG40WnIrcFhyZVZBbGRTUmYybmxTazkvRFFLVDhjSCtt?=
 =?utf-8?B?aFZlbXZJY1FSUDdsMTdRTDdBSWU2dHdRUUpKNVFUZ2gxeHVLVXlBZzBMOTZZ?=
 =?utf-8?B?NXNxaHNSbk03cTR3bnZCcjNYdXlVL2FNYkJreEQxN3BsMk14MUlJMDl2Vk1r?=
 =?utf-8?B?TVlwOFJkYnVmTlc0RGhLRktFQllmMnZzVmpXbFd1OGx5OFUwZm5yTlduZ2Q5?=
 =?utf-8?B?TmpQWkxDWUQ5VERaUjdjZlI4Qm5IWUZHS2paY1FNL09VSGpqMnlPa0xSUU5t?=
 =?utf-8?B?M0RiQ0NRMlMybmJNbGNlR0ZPM1E0MlVZOU50cFlJTytaZWdQcTdsRGFSaUpT?=
 =?utf-8?B?VVdvV3JQcFlFWHNKM2E0Z1V0QWlhUU1xdFRsc0l4Qk1RN2tMVkVRcUQ0Ty92?=
 =?utf-8?B?QTdHMG4vMXE3SVBYazVGVlFjeGUrbG5UdUxmY3Q4NTZyclBSa1VQMmFOMGZk?=
 =?utf-8?B?SVdOZFJoN3NQVUVkTVVpSnIyWDIxdFBXSGxmN3lsUnlVQXh6MVMrb1hxeVA4?=
 =?utf-8?B?Q2ErTDFEY1QyeFlJa3ZuekkwWkcxaWEwcmt3OU1VNmVOdW9mK3lMTTFjemhs?=
 =?utf-8?B?ZVVaQ3lyNGFnNXlXd2FldGdVR1RvbkJVZktIWXUwUmdyZjFCU25Kc3BFaFd3?=
 =?utf-8?Q?PcEnF/xNyOe9L8ZLrC2p9OAKcUa/9Cdq7BGxb8B?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WitMMjlwajFkTjYvQWtVWG5mTDRRTGVrd3k2MkJaaVNVRm5VSEJ4dUdUMUVP?=
 =?utf-8?B?dGRncnBnL0VQRkhBbVVSR3kvWUZxYjN2dFlnS0dhanl5a0gyNVJ0OTFJN1gy?=
 =?utf-8?B?c09zUDFzL1h3WTBVbFV2SWw4Q3UybXhReG1nbFh0bFpKNitUd2ZoK01ESzhX?=
 =?utf-8?B?VVJHMEZPTFl3S3QvQ204TmZmdi9jQVNDcWN3UDRFcENZckVqZlFLU1lFNkJL?=
 =?utf-8?B?bWRqdVg0VEZpQURDNWt6MGg4QTdIaGtJK0FCcFM5WWRiemp6SSthS2FPMFdm?=
 =?utf-8?B?T3FxRDJaaUZRREt1M2hYSFdFY1RZMXNFYXllZTNabjZUejBtVDNSVCtYNFpp?=
 =?utf-8?B?aC9tVXhra1BXdExGbnFSL0tvMFYzcm8yaE02NzVJZHRXMkpnZVhyNUM4Nlk0?=
 =?utf-8?B?cFpKWURtZ3RYRHh6VHJNZm9zL0xlMXZ2WmIvbElONWFvN3hZZW95Q2QrazhP?=
 =?utf-8?B?NVJ5UXNCOVNZQkxVMGlqTkhjNWIzMEpON3VYN21QSFYwdHd3MjlXNTc2T1FT?=
 =?utf-8?B?VFNDbVJzcDhsVEZhQUhiNE9ZY1RVM09CUFNyTVVEK1hNZ0o0TVNVVzgrTWNl?=
 =?utf-8?B?NzNuK01TYk95UlBEanJ6eXgyamM5QnMvNHgxM2w2eDVRSzJrMUNMUURYcXFH?=
 =?utf-8?B?cVlRT2xVVWtoZVg5Vy9nUHNoS0tWK3lQQTc5VnVBL2N4clJ4MldQaHRDVmpl?=
 =?utf-8?B?SFViU3ExSUdLY1VuVXFpKzd6b1pjS3RidzBSVW94MnFsZVlHMSsxVnlBVC9U?=
 =?utf-8?B?VjREZE9zNExuYnhOOUErN1NtNEc2aTZKcWdVTEd4MFRJWWdsMnhHMXhuREg0?=
 =?utf-8?B?Y1QzR2MwZWN3WE5ZYmtZZ053VU84Q0d5d3ZyUmpJRmt2SWNSSzg5TkVLc3Ay?=
 =?utf-8?B?TUY5VHRyOGdjdFBpVGErN1BxOEkvK0lpOHQzOVYzU3l3a3phdFpJMElxcDNm?=
 =?utf-8?B?WUNkK2VuS3lGR2VLczJkWU1lWlBMdm1xaVhDUVVTNnVoQ09XS3doWTJQV3ll?=
 =?utf-8?B?ZDB5TVY4bVk2RGVjTE1LNFlIbVV4TkgrYkRsQjFVV1lpNjRraGR2RGE4d0t1?=
 =?utf-8?B?NjJ6UVhmeXRBNnYrckVYZUdqU1JVaHFtU01qa0YwekpEMkliWk4zQUxyc2FM?=
 =?utf-8?B?VFltZ0J1a3haUXRVTTRtLzd0eXNFQm5IQUhzaXBMYUlwOXZLK01sQTZGeExx?=
 =?utf-8?B?RTNsRk9YVzZyMFNQblVEVi95Q3ZBUTNwMnRSSTl6SURSeEhVUVNjN2VaNHJM?=
 =?utf-8?B?Q01jeWhqUGJCS0g5bnRvbDZGMnMyby9od1BiQy9uazhCdWpLM2NrdTZ0Nmho?=
 =?utf-8?B?Y015QVlCNU4rYnY3V2dPc0FMQ0dWWHE4TTcxZUVhQ1ZCNVFFazAzcWNDTlNZ?=
 =?utf-8?B?T0F2L1VLOW5vd2Zua0NIcTVtaDZxazZGQnRSeWZPaU9IT3FkdTE0WnppUXc1?=
 =?utf-8?B?TStiak1RWTBBVnlSanBOaTc3L1pNTUU0VFhQOVU4T3dpK09GVzNVeUVQQ0pO?=
 =?utf-8?B?eGllNWlMYWIzWFNzNHpNU1J1dkFSMUpScVlIcTI2TFNyVFRIN2lMMmZIVU5i?=
 =?utf-8?B?Nmk4KzR5U05lVGZqd2tKS0kzWnJFK2xiTzdWZFl5LytXc2F0bUtETVprNTZz?=
 =?utf-8?B?bXVFZ3UrSDBBWVoyQ1orOXl1WUJocEhuVzEzdEZOYTFsdkdHN1hnYkl5azVu?=
 =?utf-8?B?Tldwd0NmQXZHdGlWOEdQUVk4K2tKRFBTUFRwTTRjbDlLQ2dNVU9tVExJemxH?=
 =?utf-8?B?MFpiRFRmM1E0dmN2TUorTDRRcGlwTGxKU2NYTDNGcENXRHljL2daVC9WM2l0?=
 =?utf-8?B?M2E5MllOcXgrWUp3REd4Y3dONHJkaldQbURzZGdHSFhLTE9YN2Nzb2JFWis5?=
 =?utf-8?B?M25rMTNoYkt0QU00TytQK25YNmkvN3l3R1N5S0F0aWNaSFVlL3pTemorcnpX?=
 =?utf-8?B?dmxuSldqVkg5dnYzS1h4endmMmRmam9NK0plazZmdnBpVm1wRlgyMktUR0hO?=
 =?utf-8?B?RksxRmxJcnlDQU0zbmRxazFld2NrZlNqN1o5aUlEYis5TnpZcUNuQVhWcklN?=
 =?utf-8?B?ZGhuU3RwdnRFbVhTZ0htdWVXZlowRi90V09lVU1aQzJURXg5WXB2ZDFoTElF?=
 =?utf-8?Q?nXHN/RO3wMEikC9rvDbwZHRdc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49e1d65e-73bc-462c-0fd2-08dd04108cd0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 18:25:28.8692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nqjps2AOr+6ipnZXALCu4RaMGX0pvXxOYMXtljMHnxUW1Xrp7yGkj25h0RaPbV9q6WTwPj19VMHTHLZ+3Bidzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8574



On 11/13/2024 11:41 PM, Paolo Bonzini wrote:
> On 11/13/24 15:49, Phil Dennis-Jordan wrote:
>> It appears that existing call sites for the kvm_enable_x2apic()
>> function rely on the compiler eliding the calls during optimisation
>> when building with KVM disabled, or on platforms other than Linux,
>> where that function is declared but not defined.
>>
>> This fragile reliance recently broke down when commit b12cb38 added
>> a new call site which apparently failed to be optimised away when
>> building QEMU on macOS with clang, resulting in a link error.
>>
>> This change moves the function declaration into the existing
>> #if CONFIG_KVM
>> block in the same header file, while the corresponding
>> #else
>> block now #defines the symbol as 0, same as for various other
>> KVM-specific query functions.
>>
>> Signed-off-by: Phil Dennis-Jordan <phil@philjordan.eu>
> 
> Nevermind, this actually rung a bell and seems to be the same as
> this commit from last year:
> 
> commit c04cfb4596ad5032a9869a8f77fe9114ca8af9e0
> Author: Daniel Hoffman <dhoff749@gmail.com>
> Date:   Sun Nov 19 12:31:16 2023 -0800
> 
>     hw/i386: fix short-circuit logic with non-optimizing builds
>         `kvm_enabled()` is compiled down to `0` and short-circuit logic is
>     used to remove references to undefined symbols at the compile stage.
>     Some build configurations with some compilers don't attempt to
>     simplify this logic down in some cases (the pattern appears to be
>     that the literal false must be the first term) and this was causing
>     some builds to emit references to undefined symbols.
>         An example of such a configuration is clang 16.0.6 with the following
>     configure: ./configure --enable-debug --without-default-features
>     --target-list=x86_64-softmmu --enable-tcg-interpreter
>         Signed-off-by: Daniel Hoffman <dhoff749@gmail.com>
>     Message-Id: <20231119203116.3027230-1-dhoff749@gmail.com>
>     Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> So, this should work:
> 
> diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
> index 13af7211e11..af0f4da1f69 100644
> --- a/hw/i386/amd_iommu.c
> +++ b/hw/i386/amd_iommu.c
> @@ -1657,9 +1657,11 @@ static void amdvi_sysbus_realize(DeviceState *dev, Error **errp)
>          error_report("AMD IOMMU with x2APIC confguration requires xtsup=on");
>          exit(EXIT_FAILURE);
>      }
> -    if (s->xtsup && kvm_irqchip_is_split() && !kvm_enable_x2apic()) {
> -        error_report("AMD IOMMU xtsup=on requires support on the KVM side");
> -        exit(EXIT_FAILURE);
> +    if (s->xtsup) {
> +        if (kvm_irqchip_is_split() && !kvm_enable_x2apic()) {
> +            error_report("AMD IOMMU xtsup=on requires support on the KVM side");
> +            exit(EXIT_FAILURE);
> +        }
>      }
>  
>      pci_setup_iommu(bus, &amdvi_iommu_ops, s);
> 
> 
> It's admittedly a bit brittle, but it's already done in the neighboring
> hw/i386/intel_iommu.c so I guess it's okay.
> 

Same proposed at https://lore.kernel.org/qemu-devel/cebca38a-5896-e2a5-8a68-5edad5dc9d8c@amd.com/
and I think Phil confirmed that it works.

Thanks,
Santosh

> Paolo
> 

