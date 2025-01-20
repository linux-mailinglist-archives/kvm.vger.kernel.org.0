Return-Path: <kvm+bounces-36064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD7FA17342
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 20:48:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5FCE1694B1
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 19:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CF11EF0B4;
	Mon, 20 Jan 2025 19:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZcG5mpDq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2046.outbound.protection.outlook.com [40.107.102.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F46137E;
	Mon, 20 Jan 2025 19:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737402489; cv=fail; b=lEh3HSS+akHH8L7YQ+Om5jLl4VTiVba8qMQx9Qt3aVTnQDDLW0R4QTStt1BVk3aGeG8N9+v55/FiGHqs5qbJ0CMXggfF6Y0mn4jTYF1EdlFOIdtuu6Wp9L+E+oyV26535f3wGiGT/bT7ZsqL/BpdgLZV+mFUb7pOB4KlH40yGFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737402489; c=relaxed/simple;
	bh=Qa7BWCw6Hc+fmEzFVSLgavpYHL+zdgvN2wNxZkQKMW4=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XXFGn+xY94Vgj8Lowu7OsVL7eXaqyEXYj8vlUW1UJdm96+41bNMRyjs13gxuaNHg0rGWle0LwJ32ahW4Z+pwomRlL+JOiw3SH2gsvVOb7ZixuYFcvVsP2Vba+1R8NsuJey35LALJVVx7tTcILxHH0P0FMdedfmevnVtqHVvZZyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZcG5mpDq; arc=fail smtp.client-ip=40.107.102.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFC1DBCdDbAqcWBRRvL617Q/tSEqhE4KKnpZZ7ghvE4KqjDrCZghcGQBvgvzwrSGxAnLofOyeRfhf/zZ3YRjmAqO900ldl09kw2okm5SS2bsVnKxlXUf4kibAbO0Pf1O2UFXCwoJEYszQj7p9ybBNSjpEi4vV4UDfZzIbN79uFfUNYXDbrnYWRy/ULpLKjAJzG1PQQbNYzm1c4tT550kIHJHLESV/sLKoHgyS4D2dKcBIcAUIz+V0/038WWaavZnbPsHh2wccqoFsMp5UmPYfvtPJq8ckNhNDwbOe06AhaDRi6S6LhiM1qySZTqGX4uwfqpobjxrkK+vDfghPgHiUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCUsmlfg75ySx1VtsPTA3Eop2BRzV2g+9H8JlAbTKRo=;
 b=ruWNVWxKrSdKo0j1YNCrT9sUDnfYqass/jdSS13V7oy8ppU2ND4ZEW8jzXkBVJ20rrWJosSV89jRMigfBwOrqUrzw+gbtPpuEMn617y8V9fj0akNob55pzyeJbK/Mfux/KOYLylRJZQWlLdIOJh8N06AbGDi0uAcZhNhClENcc6oCNtZhNtvpWv34r5NrvrtbpIlWJA3kKJcTiLIO2ZhEdWJo5IVnagknY0BrJ4XF8BjFy9Ui6eWmgmPtERefoD/Eydg0l4ad6Fanu8MgnOgp8sELU1sULim9HzKqI8vSBPI9tPPEX3raUl5NnCzi7fPIP7ik7n6BP8ipZOSx2a+Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCUsmlfg75ySx1VtsPTA3Eop2BRzV2g+9H8JlAbTKRo=;
 b=ZcG5mpDq9aSrny77wHZONE9dQeQYR93hKbODnc/hc3laCxtdA8iDDiq5OnLuGQnd04F7Bv/Wfnz1h7PBHoZWuCbFkwhuSgjnLx4cqlEclmakyIhgKl3pSuT1cUD3/tumuMM+xA1qnpd/ScjxRRMDtwwoaseLKDhtELgKt+aa6evGMaRpTSL0uszlRXNKdFIadAvDwaLmFsaUXuBThXdfSgU2dOfC7Shmr19tv2fCTS7AruFA3Jl8qzp5xaU88rrjb356tk1TjvMdSTkufLAuj73RpFM/UYNJ0MkJ1dTzVUT+ixD3LMIK/lRfdXbCSvt2lfI0H6z7DQFku4VItCOfYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB8474.namprd12.prod.outlook.com (2603:10b6:8:181::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 19:48:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Mon, 20 Jan 2025
 19:48:05 +0000
Date: Mon, 20 Jan 2025 15:48:04 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <20250120194804.GT5556@nvidia.com>
References: <Z4F2X7Fu-5lprLrk@phenom.ffwll.local>
 <20250110203838.GL5556@nvidia.com>
 <Z4Z4NKqVG2Vbv98Q@phenom.ffwll.local>
 <20250114173103.GE5556@nvidia.com>
 <Z4d4AaLGrhRa5KLJ@phenom.ffwll.local>
 <420bd2ea-d87c-4f01-883e-a7a5cf1635fe@amd.com>
 <Z4psR1qoNQUQf3Q2@phenom.ffwll.local>
 <c10ae58f-280c-4131-802f-d7f62595d013@amd.com>
 <20250120175901.GP5556@nvidia.com>
 <Z46a7y02ONFZrS8Y@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z46a7y02ONFZrS8Y@phenom.ffwll.local>
X-ClientProxiedBy: BL1PR13CA0197.namprd13.prod.outlook.com
 (2603:10b6:208:2be::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB8474:EE_
X-MS-Office365-Filtering-Correlation-Id: 9680b7ba-0e77-4835-9444-08dd398b5b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?STVyQWk5TFRLRWthUS9iOHNWTmN2bVhTdk1rVmxZbkthczJPRnowZzlVYW1l?=
 =?utf-8?B?NGdQNnpabktWYlFpTWVQUDhhNW1pcU8yemtxcVFYK2ZIRjdma3hYUnI0dkw5?=
 =?utf-8?B?ck40eW5Wb0JZamFtdEJnMysya3JqaUFXelg1SGUxSzZaMVJONFZFd3VQZWdN?=
 =?utf-8?B?MVg4RjN2cUN0Smh2akRXRTRuWXhoTSthZVJpLzlUaTV4QzQwNTFlZUdhckFl?=
 =?utf-8?B?a2hiRlcyL21pZVhEb0hTSUU2bjFwd0tPQlRITXpTNW9OSmNrcFJBR1pZaUw1?=
 =?utf-8?B?R05RNVJMQTNROG9nakxTcmx4bDdEM0ozclJldXNTTThZSDdER0VvdzVXYWRQ?=
 =?utf-8?B?Y0VrMmFER20raXNvQ3hyQzkzOGFsNzRwOWNXNElPS3RBYk4vWEl3aDN0bXRM?=
 =?utf-8?B?OFVKN1VKR1pzTzV2YWQ2MHAxeEdwTHlkUGxlRXVVTTdjY1k3SS9ROFNLa1dN?=
 =?utf-8?B?cHBCclQyUzdHS2tobllYUjVLM0dGMmVta25jd25QYWJ3cFpHdGtmZHJUTW9s?=
 =?utf-8?B?cDZKaFFZYmdkL0hJSjgwdk1uSjJ6ZmovZTJ4elRSZ2hUcDk5bE00eFhncHo5?=
 =?utf-8?B?Z244Zkk1QnF6eENnaVhMSG5FYjM4NlJwT2xTdml6MVBndVp3TUI1Z3dudStY?=
 =?utf-8?B?dW9CYWNUNVZJbXNabkYwNTFNdHBnMDJzT2orZVFLQ1lOY0I0bFAzMDl0ODhS?=
 =?utf-8?B?NGpDYnVSQ1Y2dW1DNHBHMnpTWjJhRlJ4R3ZHWktJKy9WdzdqLzhSaE1uZUNR?=
 =?utf-8?B?NEYyeGdnWVN1dGF3bGw1V09JODZ6cUQyS0lOZ0pJV21uMlY1czdIdEdjRVZr?=
 =?utf-8?B?TUswU3pkUGtFVEZJWmRpUzVvL2FPZ2taQ0QvdkcyZHpHSUhtN1J4NE4yL3ll?=
 =?utf-8?B?c3psS0NIT3krRlRqaWw0RUlZSktjcFZORTRPS1dTQ3IrKzRlRkFMbTZUaHlm?=
 =?utf-8?B?aEk0UVcweFVNZmVMMjNMa1RHS0NwakV5eTVqSmVndWxUS1F0NVJxN0tuWngy?=
 =?utf-8?B?WUtGckIvWTlkWU5xaFRHNFJXbDlZKy9pek5IYzR1blJSRnRiOGNUd1l1T0wx?=
 =?utf-8?B?cmNwM1NFVlRjUzNpMVppREhOOFlVNDM2dWhxNHBNbmFPM1V3Q3greFJJeStj?=
 =?utf-8?B?ZkZkVW55UG1vY2RpYWJZT2tmdWJxZzJvTlNxSEx3Z25FYmxWcGYrdytyYVJz?=
 =?utf-8?B?dTdBQVp2MXVJNDZBSEYwTjZoZnptUE1Ta2VaZnQ5d2JveDZYSkpDSVR5ZnVU?=
 =?utf-8?B?cHVHdWZXU25yMDNRVFpKZXBmc2hwN1d5Z2FGNXprOG9IdjdlKzQ4YmxUaml0?=
 =?utf-8?B?aFk0dEx0QzhtME5rbGJydy9odlB1NE9aeERpdkgyQXRmYzh6TnBsT3JyVG1u?=
 =?utf-8?B?U2R4SU56ckx5Z0JMdURQcEVTcXBkcjg4cllDZFBFWnVqa0VwUkNPZ1BPcktt?=
 =?utf-8?B?TkpUWEdxWTNXcDAvTVI1ZWhkaWd2c2VxM1NKNEJwMkcrak5nd0ptY1lMTG1u?=
 =?utf-8?B?NmVWM1BoZFhaeFFIVVBEVFRFK2oyMDI4QUNtOE5uY2VTUFJFU1UxaGdhL2Zs?=
 =?utf-8?B?YUhUWm1paXUzY1Y0VjhQVkRhZVEyY2ZZclpaOVhsbUs2WjhLMmh2aFIvaTFj?=
 =?utf-8?B?Z0FwbnMrMng1TVp2L29MdDQyb2g4QjdXdXp4TzFPcnpsNE1KMmV4eDBCNDBX?=
 =?utf-8?B?VnpFblNqQk1tdEEweHdSYnoxMmJTeWNpblVLT2M3U3IzWXlCbUxOUmQzdmZp?=
 =?utf-8?B?MjRuNHdCMVpwaWpKWU1BVTBXMDZZRkZadnFRWFdnaGxQQjVYWE1NZGZsbFp6?=
 =?utf-8?B?RjRhVHhQWThmTWswYnNNUm44Smwrb3hsUk9GZlBmbExJVU5JL2F3d09WMVU2?=
 =?utf-8?B?U25udnVhZU9LN1BFd0tlODZIK1JIejdmcGt3OUlzUTE0Q1JiNUUzbUxjMjNR?=
 =?utf-8?Q?aDJu7ur44KU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aW1HZ2lSSSs4UTZIV1l2Y3I5a2hTUUZ3enBKWkkzQmhNb09TdEpsbTNqcmZY?=
 =?utf-8?B?ZktGeHdLdEJBUXlnSlhGTGxJMWM2TWZpSm14L1VOWStiTVU1RVQvc0dvQVBy?=
 =?utf-8?B?b25FS0Q0d1JUOWJOSE56RkVya3ZVZ2xqNmJEbXR6MFlBWWhqN0gvZzNMbENo?=
 =?utf-8?B?eHJTSW04ZUVnU1FxNkNFVVJXek9LSjlpQ3g1a2tsdFhrU3lWcE81dElvdlYz?=
 =?utf-8?B?VTk3UmplTFZ5ZE5GS0p5ZmZNeHkvNDUvTFhxOXZpTzhjcFVxeFFReTZDMWhH?=
 =?utf-8?B?WjVZRmhVL0ZvaTBmUFhWYUlTaGczaytkUSttazE0NTRqclVkRXdUSmJHYTJa?=
 =?utf-8?B?cUZ6bjV4YXRuWkVFeTB1SkhQVG9pNG9obkgrU2tzazF2YzJlZnh0elVLQUtC?=
 =?utf-8?B?WTdJL3E4TzQ3dml2REpROXp3Mm93TUl1Q3VqNDVCdnQ3a2hIQzYvSFZaeHhy?=
 =?utf-8?B?cVVyOEUyOEVadGI4M05VbUpvZ2xmMUJnK1IxSS9TbWhjcm9ESWFGZlVBK09i?=
 =?utf-8?B?SkExUXBUK2lIa2ZjS0xtWTViYnI5aldORlJiSUdMTk1uTzZOaERBNjZmam04?=
 =?utf-8?B?eC8rY1hyaXZXd0ZyRklzWllxK3hRVFJJSkZlOHc3T0F2TkdOdk1wM3VPT0tP?=
 =?utf-8?B?RHB3YTBZb0NGUDJKVTl6V3hGNDNTS1BLcStuajA0VzFjZURCLzNEWUMyd0NG?=
 =?utf-8?B?WTdZaGhSdThrUVBSY3N1L0NRdi90REFnczJ0Zk1KcmQzWkNTYXNOdmRkSGZU?=
 =?utf-8?B?MnpINTljYXpvck9Wd3JHYzh0d3h1eW13V1pQdG0yRXRsSGNUUFJBT05OaGVR?=
 =?utf-8?B?WGYyS3VtUWJQZUdoSFFOU2FuQlZ4dDNZa1Z1bnFYZ2VLUDY0b1BsQ3A3YmNs?=
 =?utf-8?B?VVpSV2h6aDJXbExtWm13TWJXcVhFYTdnWHIzSFhsekwwY1dXeXpNZ1JpbDdw?=
 =?utf-8?B?dDd0UXFDQTFQUWRRTDF0bXJLcTV2OWp5RXlzT3hSbWhRUXV2ZW51djdPVVh2?=
 =?utf-8?B?RXFnNUsyK1NReWxCdEhYYzc4TVF3U1RCTmI2anFlSFQ1b3JBVFhZK3RLd0FE?=
 =?utf-8?B?bW1yM2hDSTU3ZW1hdjg4Q0RMQjJSUGtBZmpCRnFHaXZTYTN5dlVWdTlpeHM4?=
 =?utf-8?B?NDhTWkxRL01ud1dSenp3QzNUVFFTWlJ1YWRmNEsybEJsK2Jnak1qNGxlOFFq?=
 =?utf-8?B?QkliZjdwc0VEVHFRQzBrNE9MSERRbnl0WTFPMzFFaUc3OVR3Qnc0U09oaVdE?=
 =?utf-8?B?eWhhVlpGWTA2cTV5WXI0OS9HZFJtWmdkMEJvak02empKYzMyc1FwK0tDU0Zu?=
 =?utf-8?B?VHRQYUNJbnBRNUdDVlo2UmpYU1hWeEl2cnFZQTg4QXZTeGMxLzdPTldQcjhs?=
 =?utf-8?B?MC9zK05RaXQxMjhyQkQvMGNRUHJ0UDNGRlRSejNQTEtvMW1DQjlnSEhJTlRs?=
 =?utf-8?B?YlNTVlBrUUE5aTRuQ1N1NDlkQXNVb1czZzVVd2kzU3JwTUhsOEtTQXprK0Yy?=
 =?utf-8?B?T3dYclVZblVBOVhvMVA2TEhsd2EyTlQ3Sk9NWnQ1MlUwbUZNdS9pM2c4VVR4?=
 =?utf-8?B?dEt3ODd6MzVUN1IvbXZSQkpmNG51SmxUOWk3aVJhNUtidTRNM3FScVcvTFlr?=
 =?utf-8?B?Z21BdnFBelZ5UG5EL1czeXRLWE5vOGZXaEtaRzNUenowVDZaZ2hNWlZLRXQ4?=
 =?utf-8?B?SDJrUzJidmwrTUswb1RoQmpsYytya3ZsbG10cDlIRnN4SDN0Yldtc1N3amdG?=
 =?utf-8?B?cU8zVkNMM3h0dHRnREV1eVRkRzBLQ3NLUlFrNWpncHFDUHRTVk1mSm5UMXNW?=
 =?utf-8?B?aXNsdHpsY2dLVU9aMmYvLzIxenNaSyt5WHJKbVpZeWRoWjlUQzBVSnVrN1ZY?=
 =?utf-8?B?YStWVUpCWUpNTjVmMkNaaWdZM0NITjdibDRqOGFSajd2UGxSNGJzMW9Md2g0?=
 =?utf-8?B?U0lMNUFNVDJ3eCtTZ0JBRDVYOHVKOGxoOTJTc0p1alFubC9yZDFDTHZPRm1q?=
 =?utf-8?B?RU9OTGdualEyMTdGWW1DMUN0SWc3bER2MW5SWTVBRlVnNlFPTlhpSDF2eWxI?=
 =?utf-8?B?azhBNTUxZzNsbktzYzdNSTcvcm0ya0VxRjJlNENUTVF0dFl3MVY4VGtFeEFE?=
 =?utf-8?Q?k/nItN32+MNPFogNx18g3+NyI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9680b7ba-0e77-4835-9444-08dd398b5b69
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 19:48:05.5270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omYVv/RNBn2YVDfLB/XrEhloVczZn/4anXdvqB/8NIYgK7B4DOMrgTpCaej5jooy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8474

On Mon, Jan 20, 2025 at 07:50:23PM +0100, Simona Vetter wrote:
> On Mon, Jan 20, 2025 at 01:59:01PM -0400, Jason Gunthorpe wrote:
> > On Mon, Jan 20, 2025 at 01:14:12PM +0100, Christian König wrote:
> > What is going wrong with your email? You replied to Simona, but
> > Simona Vetter <simona.vetter@ffwll.ch> is dropped from the To/CC
> > list??? I added the address back, but seems like a weird thing to
> > happen.
> 
> Might also be funny mailing list stuff, depending how you get these. I
> read mails over lore and pretty much ignore cc (unless it's not also on
> any list, since those tend to be security issues) because I get cc'ed on
> way too much stuff for that to be a useful signal.

Oh I see, you are sending a Mail-followup-to header that excludes your
address, so you don't get any emails at all.. My mutt is dropping you
as well.

> Yeah I'm not worried about cpu mmap locking semantics. drm/ttm is a pretty
> clear example that you can implement dma-buf mmap with the rules we have,
> except the unmap_mapping_range might need a bit fudging with a separate
> address_space.

From my perspective the mmap thing is a bit of a side/DRM-only thing
as nothing I'm interested in wants to mmap dmabuf into a VMA.

However, I think if you have locking rules that can fit into a VMA
fault path and link move_notify to unmap_mapping_range() then you've
got a pretty usuable API.

> For cpu mmaps I'm more worried about the arch bits in the pte, stuff like
> caching mode or encrypted memory bits and things like that. There's
> vma->vm_pgprot, but it's a mess. But maybe this all is an incentive to
> clean up that mess a bit.

I'm convinced we need meta-data along with pfns, there is too much
stuff that needs more information than just the address. Cachability,
CC encryption, exporting device, etc. This is a topic to partially
cross when we talk about how to fully remove struct page requirements
from the new DMA API.

I'm hoping we can get to something where we describe not just how the
pfns should be DMA mapped, but also can describe how they should be
CPU mapped. For instance that this PFN space is always mapped
uncachable, in CPU and in IOMMU.

We also have current bugs in the iommu/vfio side where we are fudging
CC stuff, like assuming CPU memory is encrypted (not always true) and
that MMIO is non-encrypted (not always true)

> I thought iommuv2 (or whatever linux calls these) has full fault support
> and could support current move semantics. But yeah for iommu without
> fault support we need some kind of pin or a newly formalized revoke model.

No, this is HW dependent, including PCI device, and I'm aware of no HW
that fully implements this in a way that could be useful to implement
arbitary move semantics for VFIO..

Jason

