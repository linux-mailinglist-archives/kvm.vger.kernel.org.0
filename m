Return-Path: <kvm+bounces-72204-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2HXbNej1oWkwxgQAu9opvQ
	(envelope-from <kvm+bounces-72204-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:52:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BED71BD1C4
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C210E3108E8A
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 19:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977CC46AEF6;
	Fri, 27 Feb 2026 19:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="reyJsLbU"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839F7345CC2;
	Fri, 27 Feb 2026 19:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772221693; cv=fail; b=u+OqjuwoSCByeWwaAgUhZyZ5j0m2dHe4fJ+G/8O7bax6okT8PafSPP/SBDdedI9gEB3gCQ8EtH0jBcCSLeSTjwtO2fAWorp6rcGV9WMHgjAWVtvhZ73Jn49XU9BYBs4zY3Yj1GtKAsiRrLPj59WgKbwSDrvGHd8jxxmeuSP704g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772221693; c=relaxed/simple;
	bh=L39gl63XCZm8EuI1yQfC7V+5211opXFUzuBlM6U40rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qFFTcNutIrwfhaT5mvrVYx6anYfT45PFsfppH1YMU4PrIAm0DGqPex2uaNOixdbpgRuQQHmwVLBd1KjmBFKGppiZHohn4tUKMzggA4uVetHHj0UTQhwGvnWBp40n/7PWo7111uVJP9xBZzJse6uEYbl2cWZ7z7cUMTvSOcystNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=reyJsLbU; arc=fail smtp.client-ip=40.93.201.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=utaE0lMJ7uENihgrEkcViHIdBRrb3DyjqxJA7t04HoMubv2jbW4QvRpOy1nxjtIawJS820s4UInJ8Sf0wLusdtsIv2csj2his/qT4I5f6Vj7jSMjTpNQVbftbu7gYfgm+6Hyt6gGcB9mecmuh7FOzFLWE6HLj7puWDuiZ786Z9KGTzeLHJPIJSK7FOiPp3mV6PVb0huuxVE4yzCMYsiaaHBdegq0HLWfkdeYZTulTNVUGHw1uVAd9sZSkQ5RjFylPAWfAm+NgeXNb+6kfIR+At30Bxu2uvfo3Yd7ihgMsQeQfK5bX7ae8neFuSI5GTvPvgCoqLdnkWdeMqCGqpKTow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTnfbstCzX8EZQI9Cab7UKHsIREPVz8UcvE6A4G1pVU=;
 b=D/n4V/TUzHR0dKsmkKLUCAuOLwGfLfEOYgATlVhkpTD4uxnY4znEK+8wsHi27L1OJszFT3PQkkbQC7eS151oJxZpuiq+E7J1g7L6uOqm1tux5RCL3FVSY9Z0+Pi1j4H0sR2aKzqfJcEb8HwoOsIbY/QmeO24Ah/Ey3LnqoyUB/EvgSdJ95WxpQQrB0fzIeb1Z5ccMv5VQ3RjSEP5B25undgpOnL+9tzSkrLAFM5pXfjFmSO6DmOodfuGSI8OefqUYWAVPiVGC/t+gUDl+AkK2C1YGwS3jk5uoHJrPL12/wKfW5Lz75cY2qKybElvhpmXNwEP4wfK39rLUN4H3w0meg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTnfbstCzX8EZQI9Cab7UKHsIREPVz8UcvE6A4G1pVU=;
 b=reyJsLbUVwaOgPKmU3FthhYcAP3MxJ54+cwE3U7LE/EIhnBA35mgIS8pEstkvLPUAQ871ZonZHcLh5yrPSyARO/4fGmDL3nioCA7dQhRVZ/rsIhDEEuVmfgiock/aUjOFBU2HqlvT3xCvQiRW4A3yOXIt1RC8IJjssoJHxv7F0YdGfnOi93idvozyqnD1FZ79u0Q9DoreNrKILGvf62FGdbtWbFqr021g4bC98Mnsi9kLl55zdnCxTQ0L5Esx0kyiP5QRed8JNfQfbyrdza5CBwdirYjXgJwBtUwxSC5Jas7zZEBnTxX+RAmqyzdL0hDzTrIpM0yp/xRjWMpLN2BHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH0PR12MB7791.namprd12.prod.outlook.com (2603:10b6:510:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 19:48:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 19:48:08 +0000
Date: Fri, 27 Feb 2026 15:48:07 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matt Evans <mattev@meta.com>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>, Alex Mastro <amastro@fb.com>,
	Mahmoud Adam <mngyadam@amazon.de>,
	David Matlack <dmatlack@google.com>,
	=?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 3/7] vfio/pci: Support mmap() of a DMABUF
Message-ID: <20260227194807.GL5933@nvidia.com>
References: <20260226202211.929005-1-mattev@meta.com>
 <20260226202211.929005-4-mattev@meta.com>
 <90bd4185-1e87-4393-b9e1-1318a656a7d9@amd.com>
 <20260227125109.GH5933@nvidia.com>
 <c5a8f318-20af-4d80-a279-2393192108c3@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5a8f318-20af-4d80-a279-2393192108c3@meta.com>
X-ClientProxiedBy: BL1P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH0PR12MB7791:EE_
X-MS-Office365-Filtering-Correlation-Id: af37b064-b963-4a50-8bb1-08de76392180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	UvSwDkaWIQ0G2Alais2L9bG+OtWx3BoHtlwnO0wZTh2IQ9Lm+OEJOXWAcSwmr2utlqx4JSfQdgMUQiyhepquti1huwvokVA5EVPN0iL8YRS/Da7Zn2VJR/uuFO9LU6VfIi4tP2+sEbKkTAo2EMBLEZV1ygGo2ksEPYn6nPtPqvft3dwCppOTOWZYhhEj5HBf4Ug+2it3ZaRreNa4Pki8igrTflKWRCnu0my1iUxZ107V/6bEOSyYnU98HfCkVF6NJrFMr6r6IRgOREBTqeM/Byckixk+4DQcM7lP6RWCycY1TwVEdyCXA1AtZhmrE5nOvuJEjBsQxVn7yXK3vutbcgu6FnWl6vlDAnLLNpWGjqSCBRVNl0+DfO09Vf49GOLmuTPr4+Cc1pz/C6gy0OnQJWt11IzWqmPe19mfI/t8S875lz5fbDweuJ/SJO4XuWdBiyGw9Nc8gVjqeGPtT0TQSAAvEgUqtTih3G+9YAhak2o9jIWJ76QgvdtwHIFFz17XDMkzdCaVm8thluLubvkh8cV5kPTksQeisw+Y4AJtVBSrqFsZ6CSTp530gEI5J1r1aNj+73oPH9U7afIfIVJg1JGe7LY4Dt9qGHVSTaZUNyXBLJm2zZcjnvRSTfw+0CR1Zci59QleQbCF76BW3eq1kb/F7BCG6Kq93945dOEO5NEdgrukAqcSacr4QudnLN1NKGGDEhxyXiD11sA3NFwr7xZjZ+TdhyLJi2T2cqT5fnI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVNUa2N1ajRqaC8wZXRYRTRkdUpuSkJoUXFYSWcwT1dMUThaOXhiOFNtSHBJ?=
 =?utf-8?B?cmhVNUJzaFh6MEhVWGRiTWIvWWhCdjBzVXFySjYyYUpWSzRZL0Q1RU1tU0hT?=
 =?utf-8?B?Mkw2RHNmWDlMYnU4RXovRDBLZm1ReHJHSlUzZzkxdWUvUzNGZDgvd2hJVThk?=
 =?utf-8?B?TDVzb295ajVub0RkSEZmWjhZbXF2TFI4WkFlVHNYOEJmU1o5ZlNmSDd5V1Mr?=
 =?utf-8?B?bmk4MGRyUHcrR1hSdW9iU3pZMDBkVzkrYlFhcWxpcXZwVnB0UUtyRlZpUi95?=
 =?utf-8?B?YmwzZXBSZ2srU3p3eUwyOUM1RVNtR1cyV2o2bXNNMDg4aE03TDc2bFUxUU1j?=
 =?utf-8?B?VWZiVEtUZHdUdjVuTnRqeU5Kdi95UWJlMTVGdVpBdVFLdW9QbGQvMTRGQUpi?=
 =?utf-8?B?S0hCbU1Mc2xTOVpaV3VMaytBV21vR0JUa0VOTXJjTUhGdGljVUdnRFlVaUtl?=
 =?utf-8?B?QmlETHRjaHBwNno0ZUpOZzZ3N3c2dUlxWEJyekpJQWs2WElCaXF6Vmk2cGpl?=
 =?utf-8?B?Mi9CclBwN3JCQlVDaEF0OENNbWpOU0ZnYUhzeWZJQ3ZQTm9MRXRJcTZWYUQ1?=
 =?utf-8?B?R3BqTVlHZEhwWUppZjg4Vk1QN3BkUWZmcXVCTUIzbi9TbXVRRnJJOU5aZjBE?=
 =?utf-8?B?NlVlbTFsT1J5d0NFQ29KOUE5cEYzbGJCb0RldmZ3ZnhER0lrYStkTzgxY1Y3?=
 =?utf-8?B?aWJyd2krOEhOMDVCQnVPSjRWRWRrL0txWWVtekNnUTFmNUVzUHVweTNLOGQ2?=
 =?utf-8?B?Sno5R2NJNEZYVGhuYzQ2L2oxS2U1YloxZktiYkVmb1hRRVpjblpjaGdtVmFK?=
 =?utf-8?B?cnRiUlFnRzNyMHR5RVhnYy9oV3pPSjVKYTlVNmxjdHFiU3IyVHlaU1dRcVR0?=
 =?utf-8?B?R3ZKdlI3K3BuZDc0ODZDWkkxWWJTekZJay9lTGpSQ1dzODI5WHJnNjR3UG1D?=
 =?utf-8?B?aVVhV1Y0WE12SHdTa2lSYjl1YnE1bHZXS09DOVZLREdnTmN4dm9peUVPd2NG?=
 =?utf-8?B?Ni9EV3M2dHZ4N2xFdjV2L0RJc3h3TlhUeDJaanFhNUtEeWhPZ0p3N05TRnI2?=
 =?utf-8?B?UTBrNkZKTXl3bGlVQ3JtdFkycTJyM1FNWlJoY2Z5T2drV3BxVTNobkcyZjBR?=
 =?utf-8?B?RkRGblVEVHFIanErRTY4Sm5rTno5L2hSNTQ2NXV5eWR1UThIZEQ4OVZmZ2lP?=
 =?utf-8?B?UStLb1plUit1RzVqRTVlS3hqM0U0aVNYZHgrNnpSdVg3LzFia3psaElLV09x?=
 =?utf-8?B?QVlxdGxMb1gvLzNMUnNIcVNsUEJSZ0hvRDR2eWR0Ty9qVUhWUkFRbUdZbnpn?=
 =?utf-8?B?ZW55am1sT2FBQnRqQnZZNTVCZkJsY3pYNWhvVGd2VkdqU0xqVGNrTTZBSG5k?=
 =?utf-8?B?cU5QaHVDSHMwWks3WEJyRER4MlpaeEZSN2lXc3BzWW1jam9oZUhQRE12SWlm?=
 =?utf-8?B?OEEwWTV0YW9TNXlCTEhkTlo4elgzNStVMHNtS1kvQ2ZvOHh0M1FpODluV1Bh?=
 =?utf-8?B?YkZ3M0kyQklHQkVrbEtuUEI4WTErb2VTYitSaFE5UUdZQU5GYkZBTWQ0YWtF?=
 =?utf-8?B?Snk0U0htUTlTWVdRMUdyL2pTMnRFZ1R4QmtzSlQ5RFkzZSsyNWlFSXkvRVFX?=
 =?utf-8?B?bDVsU2tqNEM3bFgrQWJxNlZBTjlvSmM0dk00ODlLWWFCaDZra0pPMlhIMnIr?=
 =?utf-8?B?dC84V0JzNjNSUWtHNWE4UE1Kd1hQelFwREQ3KzJQRE5Dd2xidEt4VXBwOUd5?=
 =?utf-8?B?eGkzZFp6Q3M5eUQ3Vk4za0tsZ3ZlMmdPMlgxR2dVYk1KeWxXMUppS2ZZRFY5?=
 =?utf-8?B?bkNTcFhZelgzSW5LWEJ5MFlvT2VEczdaclgvUC8yRW5YMC9OWE9HRUd3SlJr?=
 =?utf-8?B?Y0ZRUnhDUFhzeFV0NWtTcXR6NG5oM2NGc09XYVROM2ZQeGk3T2twb0p4TGtZ?=
 =?utf-8?B?NjErRDVqQ0w2ZUZoK01zdVNHaytGVjAvUHE0WmJqQXMwMGVzRC9Ib01KL2Fw?=
 =?utf-8?B?TTZOVW9SallwdzZOUHozb082bHkxWlZ4ODNsZnVDL2Z4U2JldHlOS2FYOWxr?=
 =?utf-8?B?T1dXamNlQmdxS1BxZmRtTG5iblg1OHRzMmlxSXg3SFdTNGkybVp4WWYrb05U?=
 =?utf-8?B?eXNKeEpvRkx2MGlxMzQyc3ZJYXZ5WDI1MURCUWJhZGdKU2p1dXJaOVZXcU1P?=
 =?utf-8?B?d2l3cTQwMHhuYjZ3d2dQekRMbzE2VTl6aWJ6djFnTzB5dmtoTXlqRlQzWS92?=
 =?utf-8?B?RmhPblZRSHBLYnlvWE9ZRzVJN2o0ZzhKMXRhVCthSVRKYnNRbTNuWXZ2MzU0?=
 =?utf-8?B?NzJYak9GWjBKeFBUanJCczlDanJSbkQ4QU9wcElkRUJjVXRzOVUxdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af37b064-b963-4a50-8bb1-08de76392180
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 19:48:08.2867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aEqhnJqwJ0JXd/dQdR6+tPA9Yp/hEjDb/rxkwTO3BkbfxrNiskH8G9KQfAvr4uZC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7791
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72204-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:mid]
X-Rspamd-Queue-Id: 9BED71BD1C4
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 07:42:08PM +0000, Matt Evans wrote:
> Hi Jason + Christian,
> 
> On 27/02/2026 12:51, Jason Gunthorpe wrote:
> > On Fri, Feb 27, 2026 at 11:09:31AM +0100, Christian König wrote:
> > 
> >> When a DMA-buf just represents a linear piece of BAR which is
> >> map-able through the VFIO FD anyway then the right approach is to
> >> just re-direct the mapping to this VFIO FD.
> 
> We think limiting this to one range per DMABUF isn't enough,
> i.e. supporting multiple ranges will be a benefit.
> 
> Bumping vm_pgoff to then reuse vfio_pci_mmap_ops is a really nice
> suggestion for the simplest case, but can't support multiple ranges;
> the .fault() needs to be aware of the non-linear DMABUF layout.

Sigh, yes that's right we have the non-linear thing, and if you need
that to work it can't use the existing code.

> > I actually would like to go the other way and have VFIO always have a
> > DMABUF under the VMA's it mmaps because that will make it easy to
> > finish the type1 emulation which requires finding dmabufs for the
> > VMAs.

This is a still better idea since it avoid duplicating the VMA flow
into two parts..

> Putting aside the above point of needing a new .fault() able to find a
> PFN for >1 range for a mo, how would the test of the revoked flag work
> w.r.t. synchronisation and protecting against a racing revoke?  It's not
> safe to take memory_lock, test revoked, unlock, then hand over to the
> existing vfio_pci_mmap_*fault() -- which re-takes the lock.  I'm not
> quite seeing how we could reuse the existing vfio_pci_mmap_*fault(),
> TBH.  I did briefly consider refactoring that existing .fault() code,
> but that makes both paths uglier.

More reasons to do the above..

> > Possibly for this use case you can keep that and do a global unmap and
> > rely on fault to restore the mmaps that were not revoked.
> 
> Hm, that'd be functional, but we should consider huge BARs with a lot of
> PTEs (even huge ones); zapping all BARs might noticeably disturb other
> clients.  But see my query below please, if we could zap just the
> resource being reclaimed that would be preferable.

Hurm. Otherwise you have to create a bunch of address spaces and
juggle them.

> >> Otherwise functions like vfio_pci_zap_bars() doesn't work correctly 
> >> any more and that usually creates a huge bunch of problems.
> 
> I'd reasoned it was OK for the DMABUF to have its own unique address
> space -- even though IIUC that means an unmap_mapping_range() by
> vfio_pci_core_device won't affect a DMABUF's mappings -- because
> anything that needs to zap a BAR _also_ must already plan to notify
> DMABUF importers via vfio_pci_dma_buf_move().  And then,
> vfio_pci_dma_buf_move() will zap the mappings.

That might be correct, but if then it is yet another reason to do the
first point and remove the shared address_space fully.

Basically one mmap flow that always uses dma-buf and always uses a
per-dma-buf address space with a per-FD revoke and so on and so forth.

This way there is still one of everything, we just pay a bit of cost
to automatically create a dmabuf file * in the existing path.

> Are there paths that _don't_ always pair vfio_pci_zap_bars() with a
> vfio_pci_dma_buf_move()?

There should not be.

Jason

