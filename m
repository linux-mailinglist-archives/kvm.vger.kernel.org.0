Return-Path: <kvm+bounces-21307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F75992D1DC
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 14:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9001FB2792A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 12:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005FA1922F9;
	Wed, 10 Jul 2024 12:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hiZzYnEC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAE219005E
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 12:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720615507; cv=fail; b=LlbEe7mQ0EWHfE30SJqbJhnn+7EdpNlQf89+esSPIbA0AZNwy+VpG0JXYKhlZY85HOghAfzo5RD2EILjXTxD3jQ8+9i0MBQf2Sd/rCzmQidx/MmTWeB9+sTjsZuohVJqkl5g4+gYeyXS1Qr+q9f+FhRfNDO+QGS9f2/6nlw9sqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720615507; c=relaxed/simple;
	bh=6qf9MNtaG2yOMl9gcgWkb5OLPNyXz62/SJh7TiAd/tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iENgBTbJMEOaZF4e4gg6rEOOeEKV9vX/dRBWSxbUT5g4A+m4pfS+veneokIHMCG5XGvbFA06jXlV5PyaEAMUjN04VZcwW1v8xIJxDt3ajvyxnPa8ijkygVFkmmGgU6t+V1Pxoq/pDuZayKNSqPNCLbwPZa8d+pjlpJxPtz5k4fc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hiZzYnEC; arc=fail smtp.client-ip=40.107.236.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8xckscXXYz4HhRW4SQ24ivHUTyHoNh2J5XLGZ96fbBVSpRNR3tOk8EY68vu+GPvVMNZglWFuKEFgLXFUT5QiYXY6XJxg7bZiTumg/bjg1njAiTHI2dg27XhI8hkTUi9ER3WhuNwd4vBfPsGajp18jxnM3juppH+V/uOqyVP2Q35cLOkP9lfT5Kn/AclSoQ9m/2QSJ46R55ik+K3vj2xbdgf4JEqUuwnwuWe/Qnrel4wuiFg4TStzZhwMOdSEEY+YFFin40k3PaGDkBq9ZUbAEWNcw0Dl7iVW/0KL4fHjsFtlKQaPgofcN+/4JBOq2KwWARMCwVNXKtfZwkJU4389A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqUr5XlWVmfESMgDoKeixGf44ca2U+x/WuV63ube/dc=;
 b=GywwXkDI+CQsMoVBn+elkln0lz5RQHhbAug71SoMHF5kqNTk5/bwZ70vSCauh8vC+u+o87iMZQgq3W9lxK1NkyiNL/Aeit3F8byQL22ICTZ0AXZRIS7B8+FDAAkTPKYtFaML6ivthvGHrgDXz+SIt4cPpzY5XuROyxaqqmkrcrBxG47BBCWng+wixcdpZH/ef0JPBBNyvbw29grQRGCxRttTN/b4/6sWsu2apH55+meMj0h6QLbkAO2q3Hyvs0mwqcjJRQzyzB4eImxhKnGCCKXy792UKPdEfVEHW0G5TqYMbhUrbFJ8njbDtgmU7EcAfhLaLdm7HrIUcEn0Yq5zsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqUr5XlWVmfESMgDoKeixGf44ca2U+x/WuV63ube/dc=;
 b=hiZzYnECHvOOy4XEQpBkYbhLOscgYbntrtHXf9p0vNK8AmYqIMSaqiDNBf1eSPG+qh0r0YURl8uenyxbnWIas8lahfpyygcma9GpnOMedEQV8w9pEwu4Frejnhw5qM62AzPuXnjT6Q5EqL3WQWFzas+3RQpHXD4wxiofy1opg0rJNLjE55zssDUNR4FkJ0OWUFQIfavZ1Y3UKADpiGTBtrQe30w8jYflP3sUnTS5DvahujyL8Gm8dBLDIxzJiezsrPOlyIEBPglkqWu/GpjI47aAJM5af3nc8G+hOKnbfPQmsbEmxymHCn1zOcWB9NCO2GvMtTZm5FM0YasEId4SAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB7711.namprd12.prod.outlook.com (2603:10b6:208:421::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Wed, 10 Jul
 2024 12:45:01 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 12:45:01 +0000
Date: Wed, 10 Jul 2024 09:44:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, kvm@vger.kernel.org,
	=?utf-8?Q?=C5=BDilvinas_=C5=BDaltiena?= <zaltys@natrix.lt>,
	Beld Zhang <beldzhang@gmail.com>
Subject: Re: [PATCH] vfio/pci: Init the count variable in collecting
 hot-reset devices
Message-ID: <20240710124459.GP107163@nvidia.com>
References: <20240710004150.319105-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240710004150.319105-1-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:208:2d::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB7711:EE_
X-MS-Office365-Filtering-Correlation-Id: 91130b5f-2145-4dd4-69f3-08dca0de1d2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WFVqSXNlY0ZWV2JVdDZFdndJeXBXdk5xUmtSQUlZVW9jWkF6bG1TZFFCYWwx?=
 =?utf-8?B?M3M1V09kd0lteUhtVmhjd0k2TG5TZjFzcTIwZ20yVVZCa2dZYngrSit0SUhW?=
 =?utf-8?B?YTZnU2RsdVplalpRd1p0OFVyc0MrT1M2bkxCRWlMeUdSYmVuMlY3K1Y4YTht?=
 =?utf-8?B?KzQ4VkhMVy9lWFJ4RkpQd2hqWEN6VUFVbzhINnJJRk9NUUh6MnoySDZVMG11?=
 =?utf-8?B?ejhtVGFFbGpvZCtzNWhmaVlKWERvQjBINlFtY0svOTQzVzAvMmtLU1owZHhr?=
 =?utf-8?B?VjZlKzg4WktkTlo0L3FueHd2WUMwUFRyNGRXRFpZbGhlbjZac0NxdDMvNTd4?=
 =?utf-8?B?TXhCTS95UnBvSGlaUjBDVDl5NkRKZHpvcFFLMEY2eWh1aW95eExrSVVDM2dR?=
 =?utf-8?B?em9NcWtkeVoyZVdPOExLN1ZDSGUzZlN5SkRRZGIycXFWY0pXcjl0M1lUR040?=
 =?utf-8?B?ajk3WW55QURRdTJJTnZJUjBzdlo2RjhYQ3BHOFM1eDdWOURZc2wvZTF0Z0x3?=
 =?utf-8?B?aTNCNW9rWUJYUzR4MjBqc0cxVU5ZQUFERUdGV25ZOXQrTjF6bDRsL21ITFZH?=
 =?utf-8?B?SHNBd2QybTdCcmk5OUJ5UW9yVFZCRGlxbmtRdWhNUkhYRXVQN0RQVGdFUXdo?=
 =?utf-8?B?cG1XdXRqZU1LZE9OZC82WTkvSC9mUFM2aFlrbjB4Nlh6YUpQN1lmUW01T2pm?=
 =?utf-8?B?WnVYM1VyRlZsZTMrS2dDQnBoK2pqbHRDcGNYTEtQMXJ5bmFFemRvMVB6WGdS?=
 =?utf-8?B?MENuU0c0OGcxSGhFVUcwMGVQVVhJclpQTUF2aWNHUVVZZSs3Y3VtcmNBZjVV?=
 =?utf-8?B?WWpuRnc3a0FtU0tWTlFCem5kZWMrMldrd0N5M1o4SXRicytuSmIvY2NUV2ho?=
 =?utf-8?B?eUV4dEpjelRrTE1OL3U0bTNtQ0hYeE5lTVFKMjU0OUg0VFZQK2RsUGFFaDNM?=
 =?utf-8?B?R0ZBajNROEFqcmVIU1F0dFNaaTdrVXNpQkNlbWlQeU1oTGFUR0NyQTRjQi9o?=
 =?utf-8?B?Tnc2dk9CWmFQWUF3U1hUa1JNaE84eURtT1RMTXcydmRjenpVNGw4Sk14cGQv?=
 =?utf-8?B?eUxRWGhiUEhLNDVhWC9pWXpzd0RmVFZRYm5ReC9ZVDlUY1V6MzRuNjZqdmVB?=
 =?utf-8?B?Q29sNjQ0OFNvM3kyOUwvNlFTUHBvSkRocjBNV0FaSlJnRTBQZXRvbmdWem1i?=
 =?utf-8?B?c3A0dTFMcVBzVnljQ2l3ZEY1ajhoY2Y5TWZoMkZ4N1YzZWhjVXFMQkZsOG41?=
 =?utf-8?B?dXFISURJdFh5ZlRHQmxhL0RTN2pwZ3ZLdkxKNDVGVVZENlZXYThaY2dETU1n?=
 =?utf-8?B?bTZ5blZjYWdGSlo0eXZObXpNUnNYLzRzQ2FnQXJDWUw4MU0xUGxramh6c1BD?=
 =?utf-8?B?YmxqT05scGw0d0E3cWlBSDlYUkVVdjdEZFVrL0FjT0x3M2MwMTA5c240SWVM?=
 =?utf-8?B?dDVGWkZQTDRzZnQ5SThyMXpDMnFsS1BiaTBZSUlCWktRVUpCcnROa1B0Z3RG?=
 =?utf-8?B?bURETjk4Y0tPbjQvY0ZEb3lkalJVKzYrVG5oTWFINFp1Z29ZQkpJaC9DRW5X?=
 =?utf-8?B?N2lUK2wrQTJ4V0RtSUcrYWcrc3FLdSsxczdmeXRHbnVTdHYwUGthdVBoeW9a?=
 =?utf-8?B?bWpYS1RZNWV3dXVudDJxNlZGU3JpQko3UFdYeTVaeDR6bUsxdHN1NDVQRWxt?=
 =?utf-8?B?UHllOS9tNGZ4dUJYN2FSVnFDUTN0cEFQa0Z4R0huTXFzNFNjbmU3enAwY0Vu?=
 =?utf-8?B?YXkyeXB2Q3hyY2JodTJOK2hEUVYzZXlDQnpNU3drZTZ5Q25DWEhVVU4wUm12?=
 =?utf-8?B?YWZrV2ZndjN1dzA1MHlDZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTZGV1ZNK2xXSUhBeWlaRlcvdUNuVFBkRjhFaGhYSDV6WXovWk5zZHNwQ0w1?=
 =?utf-8?B?ek1ldU8wMG96Y2dzSWVOaDlxVEpWWVk2VjF1dnRhWWl5azhCL0N4ZW1PZXdK?=
 =?utf-8?B?OVJ5ajZqcnpaSWd5U0VNQkZHN2x6TVk1ZWV5RUhKcDQzRnVLS0NWdVp4Um9n?=
 =?utf-8?B?Mkc4a3NwVGdvQWZQOHc0RWkvcHMxS0RURGNXQitFSWpFYW1zNXpNTWVVbVU3?=
 =?utf-8?B?bHVZWE55LzBpM2JlT05GeTBqdXc0M2MzNC9iMG0vUEgxOVV2dUUzR2NvM3Zy?=
 =?utf-8?B?Q3J6aDJJTWtCT3lCWjdzdnNoSVpoaVN6WVUrdTk1OWRvNzlERGxBVmlmT1JG?=
 =?utf-8?B?Vis1dEdKSkhKNzMrcGRWNzR4d2QvOGd4ZWVtbjBWdUtnbTNTMnVRRkR0YzhH?=
 =?utf-8?B?S0llUC9BV1dGY1YyM3RsK3lhQjl6QVQxaHY0VFl2L3IxcFU4V3Nxc3Y5K0Nz?=
 =?utf-8?B?Vm1YYytRc2tpOWFSaGVDR3hZemtFcjNuMEgwWmtTMWZsQ0RhbExmQ1I4SlZs?=
 =?utf-8?B?bnVNWUJsRmlteG5pNlpTZmdOQVNXMlMxQk9FRTl4S3dLWjN4R3BPaTBoSGww?=
 =?utf-8?B?dkxpbGlGY3YwZGhoU3JGWDVHcHVHSVpjcVJjYUhZRCs3cSsrR1FhUjdmTzZ4?=
 =?utf-8?B?SXZhQnZFM2NxQTkrTWxLa0UzZ1pERjBnZ1FFSytCaVpPcVBhZ1dEZWNZZStz?=
 =?utf-8?B?b2E4SmVySGNQOTRxd1Zobk5iWURqZytBRFZzdTR2RHlJNU9tbEt4SDdTeVRE?=
 =?utf-8?B?Y2xWZXhkMU81VmZob3N4alA4WVh6bkFhbmdFOEt2V0UxTEp3QzNKMnV4cm4w?=
 =?utf-8?B?ZkZvZkIrbmVzelJETXZ1czE4eU9JcWc0NUlsb0F0ZFU4dEp1Y3I4bUl6dGZp?=
 =?utf-8?B?ZUZneXJ5clEyeFExYmJ0WG5mUnYwUGxienQvL3JEMm95alBab29LeUhJMFBW?=
 =?utf-8?B?OVY4VCtNczQ4YXdVWHNIWStLeExJKzB6Z0kxSE42KzE4aTZ3Tmx4VHhtN001?=
 =?utf-8?B?a21KdnVlS0F5bkluYXArLzMrRWFNa3MzREhYQ2hERXZndjR4dlc5UkFRbmhR?=
 =?utf-8?B?eWR3UGFVY2tBQ0hQMHFqNHNKRTVhT01zL3RINzUyQ2ZqRGpFc3hGYjByS0NH?=
 =?utf-8?B?aE5jeklxam10T2l1WWZjTXo1WTMrN2NwbUNjaXIrSEMyeGpBcmF1T0lZM0xU?=
 =?utf-8?B?OFN1MGJMWkVHNjlHMDJtNjhKMG0rNmdYVzVmekFtd0Q3bm02c0srcWZPQjZ5?=
 =?utf-8?B?TFBFTnp4cmk1d0srZ0JrOEhpWmdLcDgxbi9zdjVydGJqdHV1bXUzQzI3ZGNm?=
 =?utf-8?B?RWtjb2VER2Uxdzkyd3RWbENkcnlhQ3crdWdWcVkrNkdSYUdhZUNzN0pIWE8r?=
 =?utf-8?B?d0paNTVqZnZqbUlwLzNIYXRXK1R4MUhLMEQzcjRIKy9SdWdIZjgvRU9NNWZm?=
 =?utf-8?B?K2ViUXNiM2dLSGgySHlOaEpuL0tzTTFxTHdYV2dnNnR5Q01IZDFuY3FqTExw?=
 =?utf-8?B?b2orUlp6aHJMNHBJay9hc3BUYjJLVE8xZXR2cEtYejRRdlNhQ1hjWTJYZEMz?=
 =?utf-8?B?amJQUmtaVGNJZUJDNHFjaC9nSHVqZjdVSmxjS3YxcFpoZHFwbjNGTzBaTFNn?=
 =?utf-8?B?OCtzQWFTWVVoMWdpelk0SFduc1pYVlY1eEZIOTFqenZmcVJlZW1YMWd2TUJV?=
 =?utf-8?B?aXY5M2RubDNCL0R0b0ZRL3Q3b01QdG5oU0tjUXZzbU1nSnQ2Ynd5STQrbFZ1?=
 =?utf-8?B?dkVENlV3OGxrd1hrZHl6MjBqMnJ2RTdVYjBwcUxieXhkMU54QjZ4UUtFYk0v?=
 =?utf-8?B?eUpRTGw5TytoKzEyRU9xV0V0SUJjRVluNHlHaCtobENMdSswWDR2RHJXZlV6?=
 =?utf-8?B?UC83Z2xjdFFNS1Mzd3c0ZnJJVFQ4VVIzUi9UUU51dDFCbnk0ZlVoY2NFcGJJ?=
 =?utf-8?B?UTRyTHFQZDRPcDVULzRweCtsdzNDZndhMVF1MVpaK3lRcVVrT2krUFRjSnJ0?=
 =?utf-8?B?RVBtYVFVZUNGQTZIOXR2bnJhYlJmZCs3Q2tRRlJQVnpZa2NpWnFIL1Awc0p4?=
 =?utf-8?B?TE1iNjFxaElzUkZoVmhFRyt2dmhUK1RyQ1pHUFQ4dFlscDJ3MnZNZElOR0g1?=
 =?utf-8?Q?EDQPOcEtdU+hYZ12za7dr71qW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91130b5f-2145-4dd4-69f3-08dca0de1d2a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 12:45:01.3434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLItYLpD0nFykGEAg8I3ppXb+/T8GFwyff4RSwpyrZiehBaMaka9uIgy1Ypk2DjH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7711

On Tue, Jul 09, 2024 at 05:41:50PM -0700, Yi Liu wrote:
> The count variable is used without initialization, it results in mistakes
> in the device counting and crashes the userspace if the get hot reset info
> path is triggered.
> 
> Fixes: f6944d4a0b87 ("vfio/pci: Collect hot-reset devices to local buffer")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=219010
> Reported-by: Žilvinas Žaltiena <zaltys@natrix.lt>
> Cc: Beld Zhang <beldzhang@gmail.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

