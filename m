Return-Path: <kvm+bounces-69840-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8GmuGlSVgGnL/gIAu9opvQ
	(envelope-from <kvm+bounces-69840-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 13:15:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F48CC416
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 13:15:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A9E943030EE8
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 12:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7663659E7;
	Mon,  2 Feb 2026 12:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="jrVNgBCG"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010018.outbound.protection.outlook.com [52.101.46.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BCD1AA7BF;
	Mon,  2 Feb 2026 12:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770034363; cv=fail; b=JHORJM0clLvLQtQ5PKz8qsnoNYH3XT4ziRIewACYxGMaPV2rFOfLfHXga+6yz6yL8Fq1Bds6iJQ5kQtkOg6cF3r2iR1gxODZNcc+Cx+eW47qaIhKLJczWwCJA5lt3ipaRJQAr/GAb2OpEv8EowEd8zE2MAx0AuLudibNOMP4n2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770034363; c=relaxed/simple;
	bh=SbwzAqZcMEW0niUhQdOdFX+lHEGbMtAeLvsMnYNdaJM=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AfwJfrj7veFgBAVAKZFOBrRLxRWcSO2VaExg8vbgD44vRccD5Sg/2tt2b7KWLGSvAb8uxU/3PoNjlf7efp4YC4oQu8/4p8Mpa6AbLU/KPVTYXCmoFyymkkJWmmEF0j4UKBWSR8fNPnhgnlVWo+F6nf0x68tWR2g5XGowzoskPBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=jrVNgBCG; arc=fail smtp.client-ip=52.101.46.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lhal1vAdbceplBcbXx0qpremQ7zc4O0nnCfxv5Y9yRx1ByLy79RFNkKEot+UY7o21BF+4nyHDzAzMq1yN0eyhndHo8CnUvv7FQClBT5mKa/WPku1M8Ihn0EfS6V1peKxTiaTyeK7aeUQz6NRLCPOWEkdEAmljZLSqIRICY9aoilCr92rS+ylo0fW7k0A8rXWlECn5TWaVMvzeDa6NKJ/JLJPiW+/tyvfINe7yQOrOAybcCVyC3dKPsOWhLakpYvvIVyc6q6DNgz4UzXszDKXCinHGclH9kNXXJInoCpV1E6jIaFbIktL+xEfhNBXkEbgZ/UwEF5Op8hSavUWs6/X2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SbwzAqZcMEW0niUhQdOdFX+lHEGbMtAeLvsMnYNdaJM=;
 b=da+p/5veqKXhrQiolK+DTYlnx27v7vI4RaIuGUUVICqdE/UkzgN1kqXj3MEx9Rl+JE6J5pTy+vyxRv3e+IwgVlCAI6KMVHBkU3bNn7TDJaUaLlDuqzoTm6wyyM4cLN8f7fbXLCn6eABOPlMYBY/v4SoqmtKde9aFTaSuUSGuqguCUJ8dobq0B8iPIEusODQKBxw8apSFNwCwau5rNz/Xg3JT0awMbYik5usyxcW61A438WKpzbgS8WdhxQ0QVO/P/EwcGXKXN8U2DGIAFUrY5csUtE7Bkj5T0GChWHWeCKLSPFlBPYBE5P6xJ277nlkuR0YR+7VP4rEGhlGoDQoVQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbwzAqZcMEW0niUhQdOdFX+lHEGbMtAeLvsMnYNdaJM=;
 b=jrVNgBCG5n4yS+NO8ZTsslYQD21/e1XO7dzWFRwy/BNs8B3BvPB7d4UzxWnv4/FD0CUcdOsM6u4UuKyI3OUsvOk6+YHwbh8wqqpwoIjsyu6zov5v5ky50zUbI0QExO5PbAwEhCxfz+RiAECLuZc76QMe0NTwLGYbQ7RIB1Xgkno=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by DS2PR03MB8418.namprd03.prod.outlook.com (2603:10b6:8:32c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 12:12:40 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 12:12:40 +0000
Message-ID: <7469ab46-94c9-48c8-b6e7-b500550768a9@citrix.com>
Date: Mon, 2 Feb 2026 12:12:32 +0000
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Ingo Molnar <mingo@elte.hu>,
 linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, jailhouse-dev@googlegroups.com,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
 Rahul Bukte <rahul.bukte@sony.com>, Daniel Palmer <daniel.palmer@sony.com>,
 Tim Bird <tim.bird@sony.com>
Subject: Re: [PATCH 2/3] x86/defconfig: add CONFIG_IRQ_REMAP
To: Jan Kiszka <jan.kiszka@siemens.com>,
 Shashank Balaji <shashank.mahadasyam@sony.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Suresh Siddha <suresh.b.siddha@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-2-71c8f488a88b@sony.com>
 <a7d93306-42e5-4617-91df-23f7dd35aa1c@citrix.com>
 <f875676e-c878-4d3e-9eae-1f74f24cdedd@siemens.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <f875676e-c878-4d3e-9eae-1f74f24cdedd@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0292.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::18) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|DS2PR03MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d7229a-38da-4c35-8ac0-08de62545c54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|10070799003|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDJxOTM2d2hvUjFYT0J4R1g1d3ppbFJsZkNMQ2xuZEY5T25kYnlaZFphNUkz?=
 =?utf-8?B?YmVjTE1JbWJ0N1hhT1QvOUpSTTVUUElvYkNkeHV3UWdOMVM2U25LKytIclhJ?=
 =?utf-8?B?L3pIVGVTK3Fyd1NySkVtbHlnOFd4YnNuVlVCRTB0akxYUCtXVG5laWYxbENZ?=
 =?utf-8?B?M1pzcjkyUU9ES0dEZlkyempMem53Qit6T0E5NEN0NXBxdW5kOHI2cUIxdVY5?=
 =?utf-8?B?MFpGeXN2S0hzUXJ0MFQzRGVVNFYwdzk3QTNwTkFLeTZ5YWlqYmc1MmVmTFpJ?=
 =?utf-8?B?L29IdFFGOS9GTnhEU2g1aDY2VVo2Vll3MmwwL1hvZUp1dCtucHBkWVg3aVdJ?=
 =?utf-8?B?S0RKWTRLd0EyWjdhL1hsNVk2dzFiMWRQekhBZGVvT2I5Sy95a2l5TXNHWFBT?=
 =?utf-8?B?U2JlMksxTXVhZjNYeXlBTW5XYXFaWGpBZGsxZ29iZ3o2MEh3Y0ZvOG56dTZx?=
 =?utf-8?B?WG1XaDVUL1BPQ0xxWGppcE1hMWRVUzJMN3dFdElpT0FKWkRDYVJDRHBBalF5?=
 =?utf-8?B?Y3kzSXE5RjUzbXluZE1hY1FsVDZxR0JjL0xXbFZnbWF2b3VEd0VRSitkb0hj?=
 =?utf-8?B?UFByN1g5MTFZcTZZeFk0UFRrdWltRnNWSktxWTFic081aXJwUytrWEZOaW1Q?=
 =?utf-8?B?U2NadWg4dnIreVFBRTFGRGFyNHh1ajJsdHdneUxPL1VqcCtiZHh0UnFaLzZX?=
 =?utf-8?B?QkN6YXNsSHJqQmhUWVBCMWlJSVZNck1rbEZMbFBvOW5HOWIraHVOWHNlNWxV?=
 =?utf-8?B?SmN1YjU3NXhSc2kyME1QRisrV3UvYWU3Q2pNb3d1ZHp6MWljcmZ6R0lMQXJm?=
 =?utf-8?B?WlNONHBPMzc2R0o1YjR6U25VMzlkbW5qbnFNWWt4NXZVUFRUTnZBSVdrZWE5?=
 =?utf-8?B?OE5sSVVGK3JZM090ZEtDdHN0Z0p1aW1jSzc3eWh0VHFZYTlVNFdSTkxmdElX?=
 =?utf-8?B?QTZLVDNzcEZ5MWVsV3VkYmJsR1ZmaWk0ZkJmNGxhV052c3ZrZDUrbDI1eDV2?=
 =?utf-8?B?c3cvVm83d2YyTUR5MjRobWY1TGYyRUowYVZ2a0YvRHFuenZQaStRMlFOTVpR?=
 =?utf-8?B?MHIyRXJ5dm13N1lEVUIyZS9sUkFoSlN4ZXZUcXprVlJocjhLM2Nob0QzajRy?=
 =?utf-8?B?QmVRdklEZUFyeGtITWNib1MrSVlKWlVFSmhzZlRWTTFGNU1tKzUxTkJYMnF4?=
 =?utf-8?B?a2Z4YjJxRjk3NnlUU1BuSnRhRDVTUHl2Z1k5REV6S3pEMFQ2Mm9aVmlJc1Np?=
 =?utf-8?B?V28zOC95WDRHTWFWd0VJRGdtSlVJcll1V1UrMVM0TEx4ZlRQTklKQ29zUFov?=
 =?utf-8?B?ajhUY2hiL1NQWHFnc2tIQ3dmbUx0NG5jMDhGc2ZielFmck5YeURtY1NTSHRi?=
 =?utf-8?B?WS9VY2daaFloQk9rT0xqUUhpV3JCMEp4SG1LdS9DVis2WnhRL2kvdVJpcUZv?=
 =?utf-8?B?S0JLbmYweWFrM21zM21LRldobzg0NklaVE92aUluVlZtNEhvZGljY0c1MUhP?=
 =?utf-8?B?dFJrTlVIdTZRVmR3Z29IWTUyTFRBQlJjU2RZUDk2SElFSTNEbUVHVkJvYXdo?=
 =?utf-8?B?Qmg2dkdOOCtjcHR3K1dpMS9tTTJYWExQSXR1Z1JVa2xORHU4b0RNcjFWNU1y?=
 =?utf-8?B?Q29tUEk0dUhUUVN3YnlNbkVpOWo5QWMxNm96N3VPanphZGkzbndJeTkrOHNU?=
 =?utf-8?B?SUw3NjVSSWFKeENtSXVxc0xFaFQwSnM3TG9Yc0dMUE9sd1JNVGZmZTc3NUIy?=
 =?utf-8?B?T0Exc0NTMWdGdHBmYmk2UFFMQUhMeVROckZrN3VxOHpXV0FDRXJic1lZRTBz?=
 =?utf-8?B?bGI4M3B6U1N2V29HZHE5UzRiN2RUVEJwdHhhdnU0Z3ZYaDNDNE41Mk8yK0ZS?=
 =?utf-8?B?T0VNYlBaTVlFOGtFN3Bremc4Y2pvalZzaEZGZlFUNDJqdjFCU0FqMTllZ1hQ?=
 =?utf-8?B?bFllTVUyVndjMjQxWWRUeGtSUzlCTTVCZ0ZmZEhkNWNQNjVsak8vak9KbVg5?=
 =?utf-8?B?enJ3eU42UmtNUGxTWmdoK3h4aVplaWgwV1hSV01oR1d1TzBXWDFONVhLendm?=
 =?utf-8?B?OW9iR3VDUEhrNWpiWld0NG9BYjBZT1Y5Ly9FeUpPQ2tySW0rUVdybTNZZE9h?=
 =?utf-8?B?OGFsWFJwc3l0eTFQTlBQeTR5TUhTVlpPd3cxdU9xMVcrZVBaZWgyd0cralhp?=
 =?utf-8?B?YWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(10070799003)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFdyNnByQ0tPejVWQ0RUWjhNQUJXQ01BbXVlTzdvRDFqUWhXZjRwRGhIT213?=
 =?utf-8?B?ZHYza1o4WC9OYkZqYThpZE41aWlqWThsem9pUGZpaVQwZXBMNUlDODlJeUdF?=
 =?utf-8?B?aUQvb1FrbXNSWlR5NnIrV01ud0t4cUxvN2tNREdsWEt0MjB0Q2o2cjNOQXRK?=
 =?utf-8?B?MDZDSXNubUtBSE0rUVFGTDlZS29HV0ROR1pWQmRDU2lBalh6bDM0MUZud2E0?=
 =?utf-8?B?OHpDOTQrZk5xWWg4cWw2NWp3cGt6dkJQYmtVeGlKalU0ZVVHUnRyNk9rYkJW?=
 =?utf-8?B?MEtjdXZEeW5kaVVVRDVzaStWQW1oMTZxdCtnR3VnMTZjYXRDdDFTMlVnR0th?=
 =?utf-8?B?YldEc3J0bFRCNms0Q0Y5M2pJLzFLbE1xWFBRZWFQNms2eEwvdXJzSHN4a1pM?=
 =?utf-8?B?M3doSG5Rd0hsQlRVUk1SaVY4ZTRWZmtqTDhRTXZXaDVDRWovaTdQa1lQcmI3?=
 =?utf-8?B?L2lzOFlGNkZMcWU5ZENSYUtGNVEyZklJVnhLS1QxSTVEMGhRNlprMnR5UkxQ?=
 =?utf-8?B?VTEwQ25ZcWNFa0UwRDJBMGNFR01EOVFzTnNrTTZpSlFMSkx4WXZIUVFBeHEy?=
 =?utf-8?B?ejA3TERQUm1PM1JhcW50L2U4YUppRkZRWW55cnc1Z3VqYlA4Rk11L1dEZlNL?=
 =?utf-8?B?eXpOR05Fcm16TUZ4Y2RtRGxLVERIcmh5MjhWeE1JS0JTMERvMFZCeWlrMFIr?=
 =?utf-8?B?VThhMnFaOUdrT0Evbk9PRXI5VEJ1ZmpQYVZSa3V3R3pGR1hRMmhiNW50blhL?=
 =?utf-8?B?VGNTa29uNTMvNElZSGVEbnFQcnNEMEg2YTY3azhkdndXSGFUVHlZSVNRa0F2?=
 =?utf-8?B?K0U5TnJPbTJwNVZEZW1iam5Mb1A1d21RYnVBc2VRcHhIcmhTTUZEZDhiZVhk?=
 =?utf-8?B?aHJXdmVPYXBHcTY4K2gwMjBLWVFESzZmc3JlVXludnZEZ2ZkUTRuVWJLaEJx?=
 =?utf-8?B?L0JMUUJWVDgxWnZLTWREWWo1bkZEajkzYzFSSWRGWm1oSDV6SmkrbklPWGZQ?=
 =?utf-8?B?THRncW8zS3NVc2Y3THNYUG1oakVCQTJlZ1pPVHFXbVJYWkFleWhVT3JRdGNz?=
 =?utf-8?B?bi93aytuK1Z4RVFnK2N6dWUzN0dmTEVPMGVmY2NZaTJTbFByMk1YZXVQNVBZ?=
 =?utf-8?B?U2VwZUk3SEs3TUtYNGlmOEQyNUxiTXdtVTNCNkZ1UDdiaTAwWlZtWE9HUW5i?=
 =?utf-8?B?azM3U044MWVIdmpMR2wzUGx5THU4R1B4M1ZJNWFvSlJ5VlljUFh4Q3pMMUFT?=
 =?utf-8?B?SmNnMllIa29vcExiRWp3U21maHFHRk4rSnMzQzlCZ0xkTTlIK09JZ240amF4?=
 =?utf-8?B?WmZxUm44SUZNRzdOY3dHdnhZd1ZsUmtDU2xlOTZCUkU4NnhYUXJOWGh1eUxK?=
 =?utf-8?B?M0UxSHNEMW9vOHJXekQ5VHEwbUtnWUtwUFdqcEZRNi9FRGFNNm5FTGFwZVcv?=
 =?utf-8?B?Q0preUtleTlXcGRxT1RiN0RjaFpOOUdHT1ZaV0ltejg3c0FQRWhZRHNGbTEx?=
 =?utf-8?B?NnF4VFdyeUNBWEsxVjM3NFViMGZXdjRMSDF1V2RjcFlQS2RUL0ZYbWRUejVM?=
 =?utf-8?B?cERYcDlOSGxOL0RhZlQ1bnVIQm1sNmV2WWJvVEROUzNCZlM3OFM0K0VKeHRj?=
 =?utf-8?B?Nk9QZ1pxZnhRd3hmSjRXeUY3RkE4WkZRdlkrcVNQalVPWnNuV1dMTlF5a0Fv?=
 =?utf-8?B?Qk9SNjBoVHlBQ0NXNG13dXQ4WGFDc0JHVjhiODZqVUcxZTVrTW8yTEtRUTZW?=
 =?utf-8?B?WmtLZnEvWVAwQWhVckdLSzRyeXQxRGw1ZUtCeTBxKzNFSWNUSWt3NDA0TktL?=
 =?utf-8?B?VkhGT3FDcWdzbkk1eW5oRE9ZSUJ3NTJ0ejRMQ0xZRUR2OElFZ0VyRkhuYmY3?=
 =?utf-8?B?T0s2Q01wTFFrSHZtb2ROaWNXbWx0UkJ6aS9na0ZWUnVpK1R3TGo1R3UrUERa?=
 =?utf-8?B?dzZNMkdpV0dJTTR1Q0RQUmFmWXc0a0lMOEduZnhGLzZ6clA3TjFFT0VKUmFm?=
 =?utf-8?B?MWVGbnl2ZzhnU1BKdFdZWmhocmxJaDY1eU1MYlVWNStObDR3T1BMdXBqSEZj?=
 =?utf-8?B?cXVKTXFidEpGVDBPWkpnQWdiL2M4Z3F4ck5PaS92THY5UkdBbm9zNWw0SzY1?=
 =?utf-8?B?c1VMeUxvTHZYMkhleGVvcWUzU1BDamNJK0UyaVZsK2Z6cGo2dkF5dk9xem1s?=
 =?utf-8?B?Qk1qeEF0WkNLTnQ2T1pieUFWN1JHNW1nUElhSmd6WDRKWCs3WnZYVjZhL1ZZ?=
 =?utf-8?B?T1VjMEcram95WkRUb1I4WmUrMnlxNGtoUU05VGFhcmpaQnhrQUJPeGl2TTcz?=
 =?utf-8?B?SkFjV1RKUHIySmc1c2R4MGlzUEp5dS83ZnFrTDZrU3hSZnAzSkxCOGg5eUow?=
 =?utf-8?Q?ZdEdPsrHOx41+oNpoTWC73FxtlgeMVPyvgFWDVdFuBzhu?=
X-MS-Exchange-AntiSpam-MessageData-1: K7flI5RRMmq3hoZEiJ3gHzYqaGTHOLbWkMg=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d7229a-38da-4c35-8ac0-08de62545c54
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 12:12:40.0748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1lBWzRAqOTedI1K8Sw6wcGRNo92umWswHkdsCNfnlmz6H8cILtEnNTxGD0KuT/l6FgIc6gQYciuINnzCNE72y1jT3p3eUC7LKPCwBmQ6zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR03MB8418
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69840-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[citrix.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[citrix.com:mid,citrix.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E5F48CC416
X-Rspamd-Action: no action

On 02/02/2026 11:54 am, Jan Kiszka wrote:
> On 02.02.26 12:35, Andrew Cooper wrote:
>> On 02/02/2026 9:51 am, Shashank Balaji wrote:
>>> Interrupt remapping is an architectural dependency of x2apic, which is already
>>> enabled in the defconfig.
>> There is no such dependency.  VMs for example commonly have x2APIC and
>> no IOMMU, and even native system with fewer than 254 CPUs does not need
>> interrupt remapping for IO-APIC interrupts to function correctly.
>>
> It is theoretically possible with less than 254 CPUs, and that is why
> virtualization uses it, but the Intel SDM clearly states:
>
> "Routing of device interrupts to local APIC units operating in x2APIC
> mode requires use of the interrupt-remapping architecture specified in
> the Intel® Virtualization Technology for Directed I/O (Revision 1.3
> and/or later versions)."

This statement is misleading and has been argued over before.  It's
missing the key word "all".

What IR gets you in this case is the ability to target CPU 255 and higher.

The OS-side access mechanism (xAPIC MMIO vs x2APIC MSRs) has no baring
on how external interrupts are handled in the fabric.

There are plenty of good reasons to have Interrupt Remapping enabled
when available, but it is not a hard requirement architecturally.

~Andrew

