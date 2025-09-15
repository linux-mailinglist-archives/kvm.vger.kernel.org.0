Return-Path: <kvm+bounces-57595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C08FEB5820F
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AAB516F851
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F413C286415;
	Mon, 15 Sep 2025 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vJvqbWvN"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010053.outbound.protection.outlook.com [52.101.85.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BA52641CA;
	Mon, 15 Sep 2025 16:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757953734; cv=fail; b=JlBFVmvUX0HG/DDdgmITu2vxmRtHpAILLrwbYS7IDsGlkS2fIp3sZbBDnTdrT5vFYVEHpQpsYsc4RCLYXi6VdPKjuGiQVXW1JnKLYIbH01bLTLw0OD4v3lkZyG7Hg51F5RbJwUH7VeQxYYh0q48ORCDzlNUk/PA9/5B1x7IaUu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757953734; c=relaxed/simple;
	bh=h8igAGdK0emeaGOADJ9oJ82glLH8d4pmkyMt/1YdIg0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nM1Kceu4/wkZ/DPQl9MqokHxWuZdZqM5t33ep+Da3LLyl1Ch2XrCFytW2j0+x2MCodHuGNs/hv5k0XTKK6H9OlUbR+uQHf7/UDPQLkxGH6Kgn1svb5D+HWhamdL2L1BSxmZFSFB6bBSNYdTaU4gI3zPXFi3LmVenfls1bL2jPCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vJvqbWvN; arc=fail smtp.client-ip=52.101.85.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fL+LEu1UIXXn2SmWHipaY+JJ1gGlu9ya42TEBye7/02EQucg/EBUCe+72xdFY5dC2TEekMWtjb9kt/AZi1T9HvWq6DSZYxfom58QqbvIsVp2Vb/70Ku3jsJ40YPEk9TXjtE17805uro4HRQcU7muOTpC61XFhbzNYv/J80zbHdkftcVskYYgo02mIlqdsDxOguVIjp3W2VspU4qWeZUqgywlU3nElLLC1/uM3fHcz2c8ThAnVaiGAghEVzREm045Mi2bMSaosEpkE1KXrgigBH2DyfvF+prjCPuTuoQNE3KLiNHmCTDt5AQv62d6u7njzJQ/iJR+qjkTDyI8TNjPuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y9jonWfkEX11pqzYGek01qPXZcCQLCvzD24haaj4o3I=;
 b=QLxNi2i0hd3n3Zh2R9LWrFc9TARCQcdJECMyJaoExenuh/U0AHamEP03UvYEgcu2kJ5UhB7o4KBltsh9GdWtbTN3pYSvuS3kbcpuDD2UCwTFfsmd/jz28u2Nge0/99p7s1YX2jSw4ptxISF0LT4kYN4DhdlPwevoqTwgG5yBkj8EHlN88nDHFTDG13g1FOeGlVbtAVYONc02gSR7Y4h7sqNPP4u7HX+zSmUQL2SbxwxHVLEk6grjlT+/LqZ8L+nnL5rZBiOvYcyJzsRffjzXlKctqY2O+Q9dl9CAZw66cqkD+dI29Pj8bqapxkNWY6BDtBP1eFiJBi0cmdzgCzdU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9jonWfkEX11pqzYGek01qPXZcCQLCvzD24haaj4o3I=;
 b=vJvqbWvNPdVs0BFmDQJyGbH8pzwUvtROxGYFG50laY1BzpjefGNSOD+Zm4CpZQncxWY1+2OZHZgtEclMSCYdKmWz3t/Xt6Ox5aOl0tUZNh6T5zm3dH9a38RYUEFAD2YIRWyP03hmU8Ql7wjOFTHTfecZQcQLRBNCkJdoOeepspE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SJ1PR12MB6025.namprd12.prod.outlook.com (2603:10b6:a03:48c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 16:28:49 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bfd5:ffcf:f153:636a]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bfd5:ffcf:f153:636a%5]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 16:28:49 +0000
Message-ID: <85aa036a-7b67-483e-81d3-8809abcb4a33@amd.com>
Date: Mon, 15 Sep 2025 09:28:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] vfio/pds: replace bitmap_free with vfree
To: Zilin Guan <zilin@seu.edu.cn>, jgg@ziepe.ca
Cc: yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, brett.creeley@amd.com, alex.williamson@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn
References: <20250913153154.1028835-1-zilin@seu.edu.cn>
Content-Language: en-US
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20250913153154.1028835-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:510:2da::27) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SJ1PR12MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: 3812658f-c907-43f4-526c-08ddf474f336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d3ZNOTFiU0VSempOQ1V3YlkrNnZ5QU9tSkhtUGNhZWY4ckRHSmZ3dGpHNSt3?=
 =?utf-8?B?Qk5VbjVjdDdpZFZINHlma2RYczRjM2hXa0gvTU5SMm85MkJYVTBRMU4rejhH?=
 =?utf-8?B?ejVBTXlPWXk5RnhSaWRDYnZnZGh1eEVVZ3hQbVhLeTN6eXNuM3crbDg5RTBm?=
 =?utf-8?B?ZE9LTkRIR0FpODAyWkJFZWVmVCs1UVRkcjd1aTQvOTA5eWhoQmU3NDBGODN4?=
 =?utf-8?B?aHlpR0hpRGwzV0dBb1V3ZklYZ3FNaEdzVjE5dVVmZ1hrZUMvUFdLbEZOeUxj?=
 =?utf-8?B?aFZEUk1EcE9PbWE1bW82WTV2NkV4eW9XUzV2MzVYTWpqV1NudzZsZVNLZGhH?=
 =?utf-8?B?QXEzcUtWWkluMTV5ZHVaY0RVMXZtdjJnYkNvNFJ4M09ud0YraXl1ZUJFbEU1?=
 =?utf-8?B?Yk9LWE9xTkZ0WTJpRS9RY1dVSDFza28xOUtSSmJlU21NU0RmTHVqakZTaE9H?=
 =?utf-8?B?TDJFbEdaY2lGWTNzWE1HalI5TzJhb2FhWG1pTHp3dEl2aEd4cnlVTnVVM3RL?=
 =?utf-8?B?R2IwTzhsdnEzakpYZldaQWFENCtzUFFWazNRT3RNZkZ4Sk4raGtETXFGb1l2?=
 =?utf-8?B?WEJ1NGpuTVlpZzdRRncvZjVqSWhhRjdSL1ptejZrcFhnZUNORjRlTmlpWGNa?=
 =?utf-8?B?NmltbTFlcHlXY2NObFVNYjR5djNXVzl3cHhrNXh5TGJtQVVGQ29ONFliUEto?=
 =?utf-8?B?a2x2bmJwYmw1SnpTNU5sQVByY3poT1lyb3VzbFdwRmV0dzRVVmR2VXkybEg0?=
 =?utf-8?B?OXN3RTN3UVBLdlpoeVFuOHdmRmtJVG1qNTFNNXUrbzVnbGpYNnBRWUJKbk15?=
 =?utf-8?B?OSt3Ykdaa3RiNDJ4MHJQVElza2NER2hDcXBpZkNwMnVYTjhHeW5vckErWTFr?=
 =?utf-8?B?ZE1zVnl3aldSNWhZUkR3eFIwMkJQNUxnRit5R1hkWW9Gek1vVThVRFFydXQx?=
 =?utf-8?B?aDdkMVNHMFFNeEh2MUFTUm1xOGpNWDl3RExyUDRYalpLcVRxcFJZVUphZDMy?=
 =?utf-8?B?dklWbjVqTkYzVUExVlRVeDJ3cHdCb1I2SEVNTzBTelFKbzNTdnNkeE1WcWtC?=
 =?utf-8?B?RWpENmdjaWZLVkl6NEZsZVJkNUxNdWN0QWJyazUzR0FhazF5NWNUQmVKZ0FX?=
 =?utf-8?B?VnZlQkltYnZMWS9VL0czcXNhcDRNWW9WQUkzSyt1blBBb2JMSVFYemxPMDJO?=
 =?utf-8?B?bCtpZHY5bTJnajNvYjlWV1psOVl5UlpnRWh2anh6ZWV5NnRDb3ZNejlvdWdr?=
 =?utf-8?B?OHI2cm5lZHNlRjMzQVhEWGwrL2Fvb2VQblkveGJwZ3Y0U2k2ajl1enNGakR3?=
 =?utf-8?B?WTBEVlRxc1F5RThKSzNGMlgzQXRJRnRTaTFsdWVHRWxMV3g1NWo1TjlKQ0dG?=
 =?utf-8?B?bTNodzdBU0VEV3kxYXNMUzA1OW1mcmNneURjTlhBQmVwelFIcm1TU21BOFlX?=
 =?utf-8?B?bFh5MTFkbzFtRTk2VEtDbWxyc3dkU0NrNXNoWjdOcXlTMFhKRUNSUjFuV2p3?=
 =?utf-8?B?ZWNiLzJpbU95Qkx5WHgyblJiWmhwWnlhZzV1czdWcWVrRzBqaURUcFNQekUw?=
 =?utf-8?B?NU51bTQ5V0x2SE9mMGRvYklKTmlzeTl3TzhEaUlGS1pnT254Y3ljcjN0N3pm?=
 =?utf-8?B?a2xiWUlDYU1CeThRQzFjZ3c3ZWxHdDVFcHI4cnE1ZXhPYlpCUnl0ZXJQS0Y3?=
 =?utf-8?B?RVpZWG9sdE52UVFlcml5K0dpenllVVhHdmRSUWJCQTg5cG5uQjVKR0ZOdjAx?=
 =?utf-8?B?cU1YNTh6VFJ6SWhJRE5GNTQ1MEdXd0xvZCt0NG56SW5VNkNhUFpUb2owSnA1?=
 =?utf-8?B?d00xbHJJWFpGQlNnTXUzWHlxaGxydTFPa0pXMG8zSHB2bmNRWlRRSGZXTHdW?=
 =?utf-8?B?WkoyNnJ1c3NmQ01TZWJENStZMFpOWis4TGM4bmR4aEpwS21YSVBoYkpFbFZN?=
 =?utf-8?Q?H7DHxs9efn8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTFyenEvYi9LUHJQRko3a2R3RWJ3OXRNb045Snl1Tmt5WFlyUjY4ekJ0cVdk?=
 =?utf-8?B?akZvSm9md0lRUGI5ZEoyTWJNQ3dMOEZka1pHbktjNVhIRHhCdmRMQVhDSllK?=
 =?utf-8?B?ZHlnT2pySkZPV1poQnRHRzV6T3FDZnFlSHVVVEhtT25qNmhoc3hQRTBDTFZh?=
 =?utf-8?B?N3NVOW5vbWJHc0lqNnJGRVVxTkNwWUs3RTg2eUlBdUJ6SDdYdjZHSUxEQXZW?=
 =?utf-8?B?UFd3Mk1Yc25TU01MUVZLaEx1a0djYTBIMnAzL0pOUXNodUxMc0Q3QW9sV2JQ?=
 =?utf-8?B?QlJianA1cEh1ajFaTnJ5SFV1azZJZVdyeDZHU2xwa25CWGloUzl2RHRta2g0?=
 =?utf-8?B?V3duTHhaT2RhM29EU3VMKzJhUC9LU0RGTnc2dnJmelJZL0Nwa3UwTVhkYi92?=
 =?utf-8?B?Q2NyODZyRGcxZFg2VGtNZ2gyMjNoaHRldy9JdHU0VmU2MVFNdnNMdDVwMXA0?=
 =?utf-8?B?a1hjRTN3cFI1Nmp2MW5oZmZ0cEtiYnlRS01TQndQR3hyR3lzVGhDYkZNcXJw?=
 =?utf-8?B?MXhNRzVZRStoZWJNMHJ6Sk5BZDhVMTFvZ0xQTG1ybVpUa1REcWRrd3dydWh4?=
 =?utf-8?B?VTZoZm1uaFJSbnNUQzRiSVdURVFETW8yN1JrZm5xN04wd3NQYy80QkRIbDFE?=
 =?utf-8?B?U1FjaWt2a3c0SndHOVFZNElIejNsUERLWkpxT0hVS1JhYnA5bWRTN1lxZHpF?=
 =?utf-8?B?aXRYNXplN0Q3ZFlTcVdwODNUWFd5QkMwZmFoS3Q4V05zUXZsS3Z0VUpXeUVS?=
 =?utf-8?B?TmswMUhQRFF1NnlmUkVYTHN4czZlbWtPcHdtRURXdkZXQ1NiUXFUYXZodm12?=
 =?utf-8?B?RmVtTUVxRDUyYnUxb05CVUt0c3JCRkVCM3Rqb1lrcWpyTk9pUU0veWpoUU5G?=
 =?utf-8?B?RVRWMVAxa0xDcmVlMThMeWp1STI4SkNvaTJHSit3SHRrQUlJN21ZWDgzS2NB?=
 =?utf-8?B?NXR6WnVlTDFaMm91SGZSTFpmLzhVUWZOWWp4bE1kRGQ4REltek8wYkk0ZHRV?=
 =?utf-8?B?bUVVMFNrQWtMR0E4dWJ3TlhGQWxubk5vSTA1MDJvUTVjYVlmLzcxcTNNMG5i?=
 =?utf-8?B?Z3dWbExqTHd0TWtlbkRITm5hV0VZNjkvYTJ5U1NpYUtNa0V1KzBjYkhKQzh5?=
 =?utf-8?B?bEljYm5qVkRXdXhCYXBGL1hheWhUZ1FDS25UdnZUQ3NRYTJDeHYvNkNzYVBR?=
 =?utf-8?B?SFVzVTRsVlAvd0kyZWVKNWRrMEFNZVlEbTE5NHF3cDNDTEs5MEd1c3pRWG4v?=
 =?utf-8?B?SkVrVERwU1FGY2xRK1I3RVdwRGhoak5hbTU3OHlibXFjbGxyYzBrTWloYVpC?=
 =?utf-8?B?U1BSY3NoSE9WN0RvUkdyejdDay8wdDdJdnJTV0FVMUVRRis2OUV5anFyTzRQ?=
 =?utf-8?B?N3pVRXJtUVcyZVB6bWFaY1lyaUp1bE0rMnJ0Q3BDV3EybWhiRnl2QzN3TGVG?=
 =?utf-8?B?d2I3eVhMTzE2U2N4c0ZFNVlqQ1V5eGtLak9uOFhzRkdIVktvdktRQ05pRjVZ?=
 =?utf-8?B?RmNZUXp0TUNDYjNKajA2K21VdHU2Z05nZU40U3R1cUlHcGJ1dGluSXZNSEla?=
 =?utf-8?B?cTduMFlZbVI0K0xzQ0pTbDRpbktQWGVXVnB1N1Z0b3lUZVl2b3ZPUkF5aWxX?=
 =?utf-8?B?dVJwam9NUmw5ZGM4a2orSFdnL0Q2RnNzOXA4MkdXK2Qwc3ZsQXpaemhnUFBk?=
 =?utf-8?B?K3R4M3I5MDBlUmpLMzcvL0Q2b0xVMU95R1MzY1pGaEdFdEZXUlpNdnM0L3Ft?=
 =?utf-8?B?M0F2d1FwT2psd1gzK1pVbFZJZzBUSE5WQmVlMk1EdTM5ekUvT0dZZmcrTExo?=
 =?utf-8?B?Uktyc3QvMWdHVUMyN1NNRTExd2RxMG93OWVjcG1ZUWR1YnpQQXJmbjQyNGg2?=
 =?utf-8?B?NjNLNE8rYW5sRXZyM3doZnExMTR5ZHh6Ny9jbnR4dldBQnFiNTZLOEI3dmM4?=
 =?utf-8?B?UUxEaUNDODRpQ0MxVEs1MUZycjFMd0t3WjAyQkNFUFlTOHVjWms1eGJLL0lq?=
 =?utf-8?B?QnROdDlzaDloKzRtOTI3cWc3cXA4UjlBUVBudHVNM1F5Zjc0dHdDWHZkbG5j?=
 =?utf-8?B?SllCUk9LOUxRU2d6QTVSdldPQXMzR0FxL1E2N1ZoVlF0SGhUVDJMVnE5MlFF?=
 =?utf-8?Q?c74LvC8zqZ5FGRfnyrSOWoCPh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3812658f-c907-43f4-526c-08ddf474f336
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 16:28:49.5835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O3zuCS3Fketpo5x15AUY43NPDqzFFGBZpB+Dg5454+Y7K1+yf55CffKUs3ku1L3ZE29up6PEE5GHFxkU9I37ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6025



On 9/13/2025 8:31 AM, Zilin Guan wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> host_seq_bmp is allocated with vzalloc but is currently freed with
> bitmap_free, which uses kfree internally. This mismach prevents the
> resource from being released properly and may result in memory leaks
> or other issues.
> 
> Fix this by freeing host_seq_bmp with vfree to match the vzalloc
> allocation.
> 
> Fixes: f232836a9152 ("vfio/pds: Add support for dirty page tracking")
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
> 
> Changes in v2:
> - Fix the incorrect description in the commit log.
> - Add "Fixes" tag accordingly.
> 
>   drivers/vfio/pci/pds/dirty.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
> index c51f5e4c3dd6..481992142f79 100644
> --- a/drivers/vfio/pci/pds/dirty.c
> +++ b/drivers/vfio/pci/pds/dirty.c
> @@ -82,7 +82,7 @@ static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_region *region,
> 
>          host_ack_bmp = vzalloc(bytes);
>          if (!host_ack_bmp) {
> -               bitmap_free(host_seq_bmp);
> +               vfree(host_seq_bmp);

Thanks for fixing this. I must have missed this from when the bitmap was 
reworked.

Reviewed-by: Brett Creeley <brett.creeley@amd.com>

>                  return -ENOMEM;
>          }
> 
> --
> 2.34.1
> 

