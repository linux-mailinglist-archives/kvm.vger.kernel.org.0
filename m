Return-Path: <kvm+bounces-21644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91777931760
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 17:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B42E91C20D0F
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 15:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BC918F2E2;
	Mon, 15 Jul 2024 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xfsp1Ah6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBEA3A1A0;
	Mon, 15 Jul 2024 15:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721056276; cv=fail; b=EqmxIha3lZ5GVGguUD54YJmlsM10DNYTGhdXr3TJBbWPIl5V/n1Boy1A5jzmg6hfkoPQzNk6UE7lBReG/qzME4b0EbocweAogrwVWbI0tshaytYF2E00r+VxBduKkZBGyAqVxdUjkhbvGVfk5RMzh1udGEbcyg5TogdsRvtDGPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721056276; c=relaxed/simple;
	bh=3xuot5B+stg3KSU1ew0wrIhN6kSMGgMVMFAJ9AZHAIw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l3lKLCclMG7lcGq/EEp6LhzDpyvu40yVBZHktTGSyRySzwPrrqRRBw9kYfOAJMPYOGFPQeIsOqD0WFBZmRChUVvKMiUr+ulqHIpx62G97EGdXuWgZKB+Hiw5f1al2+A2qtSTEQ4VLjlxcb5Th/uevR37TjBqy82IIXNx8w32C0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xfsp1Ah6; arc=fail smtp.client-ip=40.107.94.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WsWL8Lx4ZgBunw4f3VLjIkxATGbrW8oPxap4s4EoIvEG4QEow2uvBeJWdsolH+/1dQIo6RkcgMzYB9qaJq7dj2MXgRJFI8c4wUTEJeJmXEJFv4t3DPKIyCnWumBQWxHej5eRfEnLXc8VElaMGNZ7rcy3K/dDJHt4gsUMqG/DaimvDbmP5USWMcdTqdCZgzCbQXrZJLo35la2FQXQExS7lKo2TIAVpVJad3Yht6QcgztpjdBP1W9L2IBO3AIzTNZiFAhd4layWBum+9jrOrZ48bS029w80T+IJ10bPDEgtneuU3zZHuyZNBIcw63duyfB8HFiO/7Zk+kLRPtak/jpqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLQF1zQJkJtTyaCtshfYwT/DNyNfP8Ra4yMvIwa057E=;
 b=qoqOVpRTn5xAYQ7D68c+rQK3m+NpIoY/5c/o/Q+lVbA8eDSfRkBjVN6CgwUjaFpeFNLd3BeYdq9Wf7eW0FOG9YNqYlY3cyrUefMxmJsrKGxhz9GjrVkZddhbsmX8HC2luVAvI+t2MGMlZ+CB6CfD6PyCytyoeCO/Y4JjZkzMgoK9mMZCdTRo6Du7FVaKueLWsUjvZs1TwrZlE8/njQVDbB0b/T6RBvFB1PBEOh5Mda5CPJdOpfcFq5N/j3Pnl5tb0gDOXrlRSAEInn+tUyyV6k7a8EMA7PJuKG7ef3fPZV8TPIRAFUOYwo/IIGb/AKxymhXtLDDkaV0DWXKAS9LuKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLQF1zQJkJtTyaCtshfYwT/DNyNfP8Ra4yMvIwa057E=;
 b=xfsp1Ah6ND1yFL9rDuKc/BHxkeOKzuBxJ1GOS9EactwsP38NvOcXxnXNuGffz2UI/X60Ig75m6jmoa9VsCQaY8KWo4zMvoI0vdJs9UQ/5atFnFFz5DFnKqc1TmmWyAw73RpC5vl03Bj13rCVBXP9voONyq5AO81O9vERfdPV0kw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MW6PR12MB8960.namprd12.prod.outlook.com (2603:10b6:303:23e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 15:11:12 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 15:11:12 +0000
Message-ID: <7d4531d9-3a61-ecf2-5a43-2cc03f013a62@amd.com>
Date: Mon, 15 Jul 2024 10:11:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 0/4] x86/cpu: Add Bus Lock Detect support for AMD
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com, jmattson@google.com
References: <20240712093943.1288-1-ravi.bangoria@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240712093943.1288-1-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::21) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MW6PR12MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 98d32378-dd40-46ff-9d22-08dca4e05cf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXVtWXQveFpCSlgvM1pxZUxkcnpieWlpcVVINTdLWFFLaW5tSWVDSytRd2F5?=
 =?utf-8?B?di9nWGJ2Y1RYRjZzVjl5eGFBVmk3aFBrV2ZSMXVpOER0dEloTFB3ZEkzRVht?=
 =?utf-8?B?MzRTZGVBL0E2bjJlYXhTYzVvbVJYZ3FYY0RXcDVPVVFiVlVvU0ZSSlBWb204?=
 =?utf-8?B?OFdkZGU4RkliNDVMT2tPVitQbWlxQnpHLzRkV0JiUGVOUk5BK1hCQUQrcGVH?=
 =?utf-8?B?WDRrUDFrVklPSlhyUXNlMzFQVzlmNlhVeEdiQ25LMEFTODBQY0Z3eHZsbE1E?=
 =?utf-8?B?YzNWWUZ6Q01IUkkxKzFXcmJnZVMrKzE2ZFovMTVFVitGbXF6Qnh0NGJWeC9h?=
 =?utf-8?B?dHYxeVNnSUozYVFlS2VsSUtUQWMzempUT05JYmJQemc2bzNoUnhrZ3NqdXlm?=
 =?utf-8?B?RjFMZ1p0YlYyNVZGbXZBNE9oTUJ1S3QwakxmOUdLTGFrem1hSm1LZXh5TGNK?=
 =?utf-8?B?RXRVSVd1UHpRbFhWS0NpUHpnelU5OVlYQk9mdWVFUGtwWlQvZ2F2MlRYaEMw?=
 =?utf-8?B?emlFT2MyNDFpejdORFpCclk1WHZGLzFWY3JJd1owNE0ybmJDU3RSTGpLOVEy?=
 =?utf-8?B?Qm4xUlJxcit1c2Z1NUJWenJIMFNNRWU3bWtPNldNZFlsY1ppLzk1T2pIdTlX?=
 =?utf-8?B?ajJ1b3ZtL1FWRTlCRU80OXFKOVN1NXpqbElZK1lmeW00Nm5EQjlVR1NWbjdt?=
 =?utf-8?B?dHE4ZHVqT0VKaEM3RTdqQlVLL2o2K3U2aTQrUWhtNGI4NWJ5c1VxYWk3OWxX?=
 =?utf-8?B?dEMydFRkOXVraldGL2VHNmM3cTEzVFE3djJKSUllRWRzREdCbWdYQ2p6bTZ5?=
 =?utf-8?B?ak90T05PSkI4VWlSaHdTRlk4Qytqb1o4RHRzWU95ZHkwN0FXSENkZHlQTHFF?=
 =?utf-8?B?WDN1cWU2UjRmVVhSb3RoN0dNV2gyMGNnSTg2YXZ4S2FCOFBJTC9qVDRJOFpG?=
 =?utf-8?B?M2hGSlBTTVEyR3c5ZGh0VHFkMnBBVnZQYTRUbkgrKzdXNW9EckNGNHpVc2kr?=
 =?utf-8?B?SVNuVUVYcS96UXBXemNBWC9KbmdOTGpBY09JN1c0YnVjdmlrbldYVjI2SXhV?=
 =?utf-8?B?d1N5VTVKUC80TXZSMERDS0R2bnppVEdERGFhQjVaWnRWTmFqVlIrV3JjQlB6?=
 =?utf-8?B?UDhEYllmUGljcFFyVGhPOEZQTWhOUmRCa0dudExxL3JtcHBYcnp1QWVHS1gx?=
 =?utf-8?B?K1hMQTR4VFkvbFdMVzl4OTYvT3E4Wld5c3k1YXFQeXphWEVhL3hET1pDVnV2?=
 =?utf-8?B?WnVCUm9TUDg0Z0FCOHZwVERuM0pLSExtbWd1TjQveFZTK210MG1ndXErck1N?=
 =?utf-8?B?SXprMlBYNkxGNnhETWNTaFlHZG53L2xsTWFCQ090bFpSbUZsaWJwMmZXVzcr?=
 =?utf-8?B?K0VSS2FEM3QySVRaekVVV0llOGVWeTMwU0xCeFZPRnVoVXFucUR3NDMwY3R3?=
 =?utf-8?B?alBBNFRBcXBRZWcxZHV0UFFpNEZQMy9waUFuL0lDazRIbjdMTytTd2dkVjhI?=
 =?utf-8?B?RzFlWmtEMTNIMDZMUUVQTnloT1V0N1lTZytGanRWTWFzcTNHZG9FcjlXSUMy?=
 =?utf-8?B?WFlEakNUcWhaK0lmL3FuT3YvU0g2RVVPMWRmd0hCL0l6MHZhT3Zubi90NTZr?=
 =?utf-8?B?WkU3dU5HSHVrbzZ4ZzRlaGM0aStFQVFNcHhjdXI0cjJleW00aEh1c0tUYlA5?=
 =?utf-8?B?eEhLUTRSa0JqZlczLzluQXhvMVA5TUdrZ2xzZVdHMzFJNXlWQ0VMaS9YM2di?=
 =?utf-8?Q?mD9TGISpILHkwbdZt0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TjNrSjBZRzFBNnhSSXNmd2phS0Rsa21kZis3OU51ZGVyejZLcXo2RVRFS0Rk?=
 =?utf-8?B?UDZVYmVpTDR5aE5SeVloSzhnTi9saW9YaEhqYjRFU1hQME8vYVlxa2cxT2VB?=
 =?utf-8?B?V1FQaHdpdFJ4RGg3VmdKZVNmdTV5NDFFOTZYTFVjMUlGZmhlaEthRlMxNHpv?=
 =?utf-8?B?c0pwd0JzemgzTVlhWkNOak5BS2ltVVJ2NHU3dzdQODRrNENvTmJCblY4UHdF?=
 =?utf-8?B?T2dnVDlndlpXZWMwa2xtcjllNDZjYjN6Vm41Q2hUbUUrSDFuZWRnNzFNRitB?=
 =?utf-8?B?cGFpY3pjbjQwM0lmbUVtRGpUVmpZUE1ZYjUwU0UyU1FnYXdCMHVOWXl0Nk51?=
 =?utf-8?B?WE1hYzhBdVZKSzJrZGl5ZThOaHMyNWZNcklGcURrWmhrM3RHNTZtZ0tMUjJp?=
 =?utf-8?B?YU56V3BCdnhuYWJSWVp4VnBwbFVWdk5NS2ovOEF4elptcjVyTk9scW5XYUdM?=
 =?utf-8?B?QlZXZHRtNExjUXNqd3Y0elRNejQxdE1sUWlvTWFGUUpaUElsWWdCazFTbkNt?=
 =?utf-8?B?Y0h6czhweVpxb1JvVHdNS3FmNDB0NVY4a1BDS3RodlNCTUNBVXhJdU1HQ0o4?=
 =?utf-8?B?OWNRbjMxajVaSEJORGFhQjdpYXZCTjhBZWxRS0FJbWV5bkw1bmhjU0ZMVnVL?=
 =?utf-8?B?bnc1YlRSNk5tOEM2SEw2N2lhL0ZWWGh6Nnc3T29lakUzcno2ZExxLzVweXFu?=
 =?utf-8?B?YWRlcTRkWHRzV3RSS0lNd0M2R3M2R3ptczhKTE1sOStXS2F2RUIram1mQzE2?=
 =?utf-8?B?QTVXMWRacnc4cENPczVqSmpkU0p0dGIrTmVHUkZ1UlBuejJmYSs5cTk3eXFL?=
 =?utf-8?B?dzNMYVdZSGhLc2ZKaURVMCsxazl3S3dLTnJVOGNOY1VjbXQ1dXY4MnVvaHM1?=
 =?utf-8?B?TkZPZEJDL2ZyWUpkYnBhWUprdkdjbWpKZXBxa0MxU0lZeWpuYXRyd2M3SjdB?=
 =?utf-8?B?bkQraG1hK3R3dXpRVU01cjMzWGFuckJvNWpld2FqSE9HTnBUMlZnTWRXeFlL?=
 =?utf-8?B?UGc0Z3haVzZwcWFSVTNVRFpYSS9SYW9BcTlqWnk3d3NnazNqUmlNeFE4QStv?=
 =?utf-8?B?eWdEQy9BaGI5RUE4cllYNDZTU0MxNWUyREp2UUNEc3orZXptZ2pwM2QydWFO?=
 =?utf-8?B?enJTc2lmT2NLVW11dUM1ejl2VGEzRit5OFJZZFBFaXRMYzgwRG5hbE5HL0tz?=
 =?utf-8?B?VHNJQnZXWFozTSt5ODBkUFFEeG1LUWFGMVUrVDlOT2JFR0V0MXRQR3VQNERP?=
 =?utf-8?B?YUhEWWN0clczY2NXQzRTc2VMSXhMS21aaXkvbkQ1T092eERmZE5VK1duU0V6?=
 =?utf-8?B?RU5ZdVlnTE14MWliODZwNUc1ZjVhVGFGT01EaDlkc0ZZclZlS29nWk5SK1g0?=
 =?utf-8?B?YUdjcU16VU1pa1drK3pjZlJ3WlBTVll2QjB6bktwUVQ1TjEzNkVqRldmQU9t?=
 =?utf-8?B?OHN3eWI0dEdSYXpBazNXTnVPdG4wa3hRYkdHQkE0TjRWZUd6NW9mbjcvY2xx?=
 =?utf-8?B?ajlHTHp4T2d0MXN4aEJGUHRqVjV0K1NVZnMySlB4TThpdWRvYWZRTzBJWUJ3?=
 =?utf-8?B?and1K3ZNZ2toTUVwSCtjb016QzNvZ292bHhRNHVsdEVLS2EzSURNS0U0MExG?=
 =?utf-8?B?WHlvMkxISHhST201clRpdnJxVDFFdnVkeWxGVUxpNVJMNUlLSkV3Zi93T3dV?=
 =?utf-8?B?OS9PejhqNjhTL1R1SERnaDJMc2NrR2dyTkVGMnBQNkpjVkFIUmthN2ZYd0sv?=
 =?utf-8?B?L3A0eUMzenFpVnNrRXU2RlZhVUF2Y2hOUGFmc1Bwd1BZZVZmVUppd0lTT0U0?=
 =?utf-8?B?d1FwUDE4clJVVi9uS3U3dzJIeVZnejdmWVIzK0kvWDFKWThFSDlkM1pjYnpV?=
 =?utf-8?B?eXRkdW1BSDRUK0tBc3psc0dTR3FpWU1BUW1yY0IzRUIvVXhpNUhIYWtUOHZj?=
 =?utf-8?B?K2FIVENySGthWjJsZU1tQWVwWG9NV1B2d2IvTnA4RSttajNQT3dPS0NSSGpJ?=
 =?utf-8?B?ZTFYNWd5N05OeVUzL3NMZnFEd1Q3UldTQ0JKa25SR25RaGNaYnBhSE5DUjhS?=
 =?utf-8?B?S2NmYXRSNEFRSGxCZnFKa0JxVWdyajIwcmxzVGp5V0JjVVkzRUNqSGkxTm9z?=
 =?utf-8?Q?xbRCRSacY/y+9R8a1/4asOjtX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d32378-dd40-46ff-9d22-08dca4e05cf4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 15:11:12.1727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z0pSq6RkLYhS20352hDftteQTIjFbuvcGC0IqCC/vPB/Yb1i1IEdNe9Hkn7jonbfuBOxu7B/i3Gvy6DRUSDD2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8960

On 7/12/24 04:39, Ravi Bangoria wrote:
> Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap

Saying "Upcoming AMD uarch" is ok in the cover letter, but in a commit
message it doesn't mean a lot when viewed a few years from now. I would
just word it as, depending on the context, something like "AMD
processors that support Bus Lock Detect ..." or "AMD processors support
Bus Lock Detect ...".

Since it looks like a v2 will be needed to address the kernel test robot
issues, maybe re-work your commit messages.

Thanks,
Tom

> in AMD docs). Add support for the same in Linux. Bus Lock Detect is
> enumerated with cpuid CPUID Fn0000_0007_ECX_x0 bit [24 / BUSLOCKTRAP].
> It can be enabled through MSR_IA32_DEBUGCTLMSR. When enabled, hardware
> clears DR6[11] and raises a #DB exception on occurrence of Bus Lock if
> CPL > 0. More detail about the feature can be found in AMD APM[1].
> 
> Patches are prepared on tip/master (a6fffa92da54).
> 
> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>      2023, Vol 2, 13.1.3.6 Bus Lock Trap
>      https://bugzilla.kernel.org/attachment.cgi?id=304653
> 
> v1: https://lore.kernel.org/r/20240429060643.211-1-ravi.bangoria@amd.com
> v1->v2:
> - Call bus_lock_init() from common.c. Although common.c is shared across
>   all X86_VENDOR_*, bus_lock_init() internally checks for
>   X86_FEATURE_BUS_LOCK_DETECT, hence it's safe to call it from common.c.
> - s/split-bus-lock.c/bus_lock.c/ for a new filename.
> - Add a KVM patch to disable Bus Lock Trap unconditionally when SVM
>   support is missing.
> 
> Note:
> A Qemu fix is also require to handle corner case where a hardware
> instruction or data breakpoint is created by Qemu remote debugger (gdb)
> on the same instruction which also causes a Bus Lock. I'll post a Qemu
> patch separately.
> 
> Ravi Bangoria (4):
>   x86/split_lock: Move Split and Bus lock code to a dedicated file
>   x86/bus_lock: Add support for AMD
>   KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support is
>     missing
>   KVM: SVM: Add Bus Lock Detect support
> 
>  arch/x86/include/asm/cpu.h     |   4 +
>  arch/x86/kernel/cpu/Makefile   |   1 +
>  arch/x86/kernel/cpu/bus_lock.c | 406 ++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/common.c   |   2 +
>  arch/x86/kernel/cpu/intel.c    | 407 ---------------------------------
>  arch/x86/kvm/svm/nested.c      |   3 +-
>  arch/x86/kvm/svm/svm.c         |  16 +-
>  7 files changed, 430 insertions(+), 409 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/bus_lock.c
> 

