Return-Path: <kvm+bounces-66926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE38CEE78F
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 13:14:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94581301DBAA
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 12:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B1130F550;
	Fri,  2 Jan 2026 12:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Si0Dr9Lp"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7676927A123;
	Fri,  2 Jan 2026 12:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767356051; cv=fail; b=OawhVzljMXnUsW9HWyMNDDMf6xZCO7AoFE0FmQYua1/a6VOPsFSzuzHIufO1SsFhER48QLI3sC5HoJ2F6OakjagMjmc36mOqIn/BAEBkbhRzTiI2BkUk/Z0vGZY7ppbiqfKuwWCaA49AryfzDn6AjpNBKBYHkhdsWmCWbLxKcMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767356051; c=relaxed/simple;
	bh=hEOBqfIEBufsGBIa3dYKqXwHOhCtIYyvn4BN/kDCDn0=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KqBTDaSorBhKXwykQQ6Kv/Fuu/EDx5g/cadTMxdrURAAiqLkVyX+9CGFWLWxz0OUGg0ZkK2yfD4Swez1LUAbUibXM4FT0y4P1Pa+FHD/bDtUTjtaT16zqNkK1+LgPYyIbkdTqVxTfL+Cn8ePyBSPiuX6yxJM1uvuQiWe2fbHNUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Si0Dr9Lp; arc=fail smtp.client-ip=40.107.201.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5GGNyoqC+kuHMI2flbP/evr9uqgKqcTdJmJx5gBvFpGGXTU+gLxvyXdF36Mg9zuJdLXSGiBKJK8K+NmPFOHMhZKXNC0y68C7LbR4sAUHTHxjxlMPp/0Zy5L0hl4Y1pn5De5zp/Kl0iojV2XhowPJWO1DdzGJWIC0fCD7uFVmyFYGQ+hYEUwGXsTm7xoKdkFcNG/V+bjkq3xtZMgqAdZBW90VQFOnrX3KyHpA7ODqIL3eVZ5SJgUNFwd4i5YLmsYacEiBprcAB+dc2+TYWYTgOUO24tkiOQW1KimxOmFFvA0+7xHJndZyROnh8G7Sb5d/trxmtyRSWDMbcaVmlm4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/B1tyI/e5+EhzXBK6s8NoUl4VuEW+WM2Y/wyqJC/7k=;
 b=qMyqNGWzyiTNFCACwBsaQ0YtgD35gY2AIXgj49F4fNpUoutSAW3Z2Twp3adbUfai1hBWpJGNZNmia873BEpgplWIYYsq/qYUAUiXduF5CgwUnVtutkQp50/Xk59RhLj9TXQUkObIfXkm9eMFdIE/L7ZTqOWCOqMcFEnXoviSI91XzMZxWvMrVv73WLmz/ikJnBA/rVM0dxd0HhmhDcYdkgLzxPqT79f5dHyFQqVRJHhlIV782iAnUmThfi/DMBsvH2kzFdX7D8uozm+1VPs5g6QguLM3jK6Sv3KpK/II2C1aGj4b0JZf+g3l3+tKbeIE35Upm4a4FlfBCszZ5d/WwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/B1tyI/e5+EhzXBK6s8NoUl4VuEW+WM2Y/wyqJC/7k=;
 b=Si0Dr9LpUzlNL4gI1A2ySiJvs00ZOxSk8C0Bko4aCgF6cGjvYjiHuksXkV9hfil+wZD/2ig5PSDoo9zplCdAyFnkn279m7/0gMxCRg3/rWJlo6Dij31vMUw7FVRt6f2mP7pApqXbs4zJN2PRgFae+TiqASnUsys4uFk05SYLrdO2gP272rFrzub/t1QtBhgap8wIiAuGctFyY7YPGUAHTXCk/8iN+qAomI/BNIDCVOxy9RmqWUCCAKwW1b9gzgqFZ5d9rWqrgYCuf43kTp6DomFZUzD7NmWNMWZXCKuksUbHuxhjuLrt3Hg1qyPmz8TNT1ARmUixhcaducDm3AoKYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by MN2PR12MB4063.namprd12.prod.outlook.com (2603:10b6:208:1dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 12:14:04 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::7e7c:df25:af76:ab87]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::7e7c:df25:af76:ab87%5]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 12:14:04 +0000
Message-ID: <3fa838af-4eec-441c-8739-020990d1826d@nvidia.com>
Date: Fri, 2 Jan 2026 13:14:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] vdpa/mlx5: update MAC address handling in
 mlx5_vdpa_set_attr()
To: Cindy Lu <lulu@redhat.com>, mst@redhat.com, jasowang@redhat.com,
 virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, netdev@vger.kernel.org
References: <20251229071614.779621-1-lulu@redhat.com>
 <20251229071614.779621-3-lulu@redhat.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20251229071614.779621-3-lulu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::19) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|MN2PR12MB4063:EE_
X-MS-Office365-Filtering-Correlation-Id: 105ad3e2-2bab-49ec-2ef2-08de49f86bfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dndWdllmTVJjUHdVZThwN2NlWFVwUlcrbmM0L2FveFFPOVhKd1ZkQndQbmlt?=
 =?utf-8?B?dm5GNFROeWZNQ0Z1TzdmTmFpK2IxcGRSQTBUekNOenFnVHdBM24xdkxKeGlt?=
 =?utf-8?B?eG8zazZRdnFnNi83dm5CeFcyb2xhQlJOR2c5YWk3TGQ2RklKRGtmejZTaGp0?=
 =?utf-8?B?OG4wK2lOVEhTeUpZUDN2b0xoUHoweE14djhPVms1SytIQUplWENQdVJwczBq?=
 =?utf-8?B?MkV3YTZBQXJFZ1M2bnFJNll0Z3RhWXd0N0h5VGNLLzB0ckxnZlVnUk9NdHhN?=
 =?utf-8?B?NFo4dEx5ZnVITU5QdVNoNXBGS3FyTHlQYk0zRUlLcnhtTWRMdWtRNUVUemo4?=
 =?utf-8?B?VWFMZHFaeWh4eWl4TmEyRXkzbkNIajJrQm9UbWVpNHVjVkFNODI5VzI5SFIw?=
 =?utf-8?B?aFNyRFZESFNIZGMvaFRNc0RVTkxhbjFWeTFkNXFsNEVOam8rT1Z3bU5mQ3Fy?=
 =?utf-8?B?R2VtMEN1cG9IUDJPUnozeXR6YWNWTjRodkg4cG93WTVHM0o4K2ZDVnhuWC9k?=
 =?utf-8?B?bFJlb2hFdjIzL3B5LzZMOUNGVWxMbUdrT3ZrUHEzeTQwMUNBM21MY2piT3JC?=
 =?utf-8?B?OWFoeVVEeDV3V0lIcXZrQzNJSHVseUQvQUZpcDlSTkptVERQV0tYbFA1MnVJ?=
 =?utf-8?B?R2JmTExFVmpTcXBUaERzZjAwVXl1ZFI4aDhET0VaRWlQeUtiVThPc29jSGZG?=
 =?utf-8?B?Tzh0bE42WjhiK0c2WkdtZ2ZDMUpjNlBqTlNyTVo3STZUUzNKcG9ESGRoM3Yr?=
 =?utf-8?B?aVhsSkFjS3dabEpYOFR2UzM5MGJHMERRSGNvWU5Ka3VHTnZLQy9MUFErYkZ4?=
 =?utf-8?B?cjh2VmJ0YkhGSGoxMDgvMzh5eVhWOVM5c05KWFlRd0FDaThSNG02RmtoKzR3?=
 =?utf-8?B?Nlordm8rcHo3Zko1RXZnV3FTNGhESVdQWWJ3aTNua3ZRUFdJRU9FRmNhZ3Vt?=
 =?utf-8?B?RWUzY0trMEprS3RXWmxJcm1ScThvem00dVN1Nk1vQUxYV2FqTHU2cXU1YUlw?=
 =?utf-8?B?eGkyTENHY2NiSVFtQm4xdDdNbkVhZDFyeXZPUXgyRUtDNGtqN2JBbDhDV0g3?=
 =?utf-8?B?aVJkTmhlMitoQWpNdlFvT3NYR25xc1FPNmVsK2tjNXNIdnRpY1VEQ0R2ME5C?=
 =?utf-8?B?UXZkenE4YUZNUWw4aXd4R0hHS0hSTlROTUptT1ZNdjNMckxMSjhoWVdyTHRt?=
 =?utf-8?B?WmJYUWR3MVhzY1MvNEdYMDNYcnZXY3hLclRlV3NQZHpLUXdzcnEwaFBDSU5x?=
 =?utf-8?B?cnZkWW14OHM3Q1pGb1VpaGJQZis4bC9jdHl5L3d5Z3NCbTdIc29VbzdQOVJS?=
 =?utf-8?B?Sy90ZW1uZ1J5SkV1RnpIOXN0NkhFQjJsdFpKYnJWNjZjS3ZoZmRQM0lncDQ0?=
 =?utf-8?B?WlNVSFVnQ0p4d3RuLzd3RmFPN0JhTVFaeWpzWmwvblZ3eGMwVVhuYld1dkRU?=
 =?utf-8?B?RlIwU1FKbkhoSURFdytFL0dxRDFISHZGZ1ZpalpES1cvSmNsdHlOOGJhNms5?=
 =?utf-8?B?bVhCYm9mcTh1UStFR0hZSmYxRGlFSVpvSE1kRytzNlQzSnNudGpFeUsvdmRN?=
 =?utf-8?B?Z2owKysxNFIzYVJRanM3TTI3LzQ4RWcwY0RWSG44QmRtR01yYk13Q1pFYWZt?=
 =?utf-8?B?WlQrQVVwVnNuNThUblAyUGcwcEZURzdhZFJCVUg5Y0xrcUo3cCtoeXFWT0hR?=
 =?utf-8?B?Q0Y4NDVRQU1nM0Z4WE5GdkQzeWNBSUx2UWR4eHdncEl5T1RjK1RBMGlIa0VL?=
 =?utf-8?B?RXZWeG14ZFhaa1pUeFdyOGgxakNHUG5xMDhYa0lsVXpXZDJnbHFnRktqZDJt?=
 =?utf-8?B?dEQ4KytpNldKZ2NUVU5Jczk4UlRPMXh0ZmNKakNuVzVZdndDRFVuWHl3em43?=
 =?utf-8?B?bnBjYk1NVW95VzA4b0ZVaVBza3NYSXhYUWJSWVZKSHZHaGJHTjYyckszbUMv?=
 =?utf-8?Q?wCEnECFHVq6BRoTOMNhyHj7qDrcK5hEE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2I1Z2dNc1UyMExGOXJGRzAxR0JZSFYrNW52UFNkUnRpR0xxeXRmUXJ5OVJt?=
 =?utf-8?B?cmJodlcwSkE3bFl4dU1Zc2loTFRIZ1NXcVUxbGFvVWN0OFVMeUdVY3dETVh4?=
 =?utf-8?B?ZmdjcWJ4ZzI2Q1lyVzl0L0d4blM2YkVQYmhqMHBwREtrTDVDMElQSGRiTHJB?=
 =?utf-8?B?MXozblBzbEI1ckRPU1c1ajQ0anpVeDR6TjVKZk9MMGdmSVVtUm5nUDA4cmM4?=
 =?utf-8?B?YTRjSVVaNVhGVHI5UTUzcG52dEY2T2NpU3lGaWtTQVgyYW1WcHdGdCtab1g0?=
 =?utf-8?B?MDBUUlhJdFFham10dndhWGhTV1k3ODd3NWlsc2lDNW11SE1RUytzc29JWjlS?=
 =?utf-8?B?MkxQTHZZZjk2TmZtbmZrT0ZiK2oyYjBQcDJselpEeVNKSlphKzc0RVNNSHZQ?=
 =?utf-8?B?VjFYU1prVjBwNkkvRjRiblJlK20yMGhPRmxIS3FiZVFZd2tWSE8xRlFlNHZL?=
 =?utf-8?B?elhxL0JUaW1GVzJuUWgxSmVTVENmR2NlazRKVjJPN21KQ1BTdkFOcTMzelFL?=
 =?utf-8?B?Y2VLcjRoa0dzOHprYzBpVDI0T2hjb0J0bEtCNDl1M1FYNC8vK21NSGg4NzFX?=
 =?utf-8?B?QStvVXIvb3BydU9LQVp4U0VJaFc4ZnBrQmFISHFyOHJsQysrNE9sUTUrNjkz?=
 =?utf-8?B?eFBDYkJMY2dQeHBSSkU1THdNUGI0bFYySEFyclRueTlybVlrSU5WYnYvbjll?=
 =?utf-8?B?dE9CMmttbk5BVWQzQ2lkOG1nT0pma1p5SGJvdlQ1c2I5c29EMmpXU3Yyb2xv?=
 =?utf-8?B?OWNZSUdJdmRYeUJTZWp1alduSVlIRjZQbENCeTk2MlEzQ3EydDRNVVNoU0U0?=
 =?utf-8?B?WGdkVnhFaTIyK2hyQ1NLcjJaRmFmTWZTcmlLU3lZTVhyK1NXVk9GU1RPWC9m?=
 =?utf-8?B?d3cxdnNXSk5MQXpKdlRJQk52cWpKbHRzN3RZMmRFT2ZNV3pybGUyd3VvUDBC?=
 =?utf-8?B?bW10Y1c3eDhCSGd2V1cvNGo3T2pqcXZxclV4V1BINUMrWXdwa1U5ZXBNUnk4?=
 =?utf-8?B?ai9Lc01LQzE1SEQyZzBwZE5sbUEyaU1IQXYvTCt2Rm9CSW11MXJzOW5iYnBa?=
 =?utf-8?B?SktFK3RpL0dnTmZpc092Q3h1SlE1OUtvS3pGWDF4MzhRNlFseDNQWkI2QzB4?=
 =?utf-8?B?dWE0QkY5eE8yQ3d5L0U5UW5KTzhiMHQwN2JzMWtpRU1MUnpMeGFSUmNsV29q?=
 =?utf-8?B?U3VqOFZROEwzZklZdkJGaTBLdGQzb2pKUmlJOXloRkFYaDMrSTdOSEVTUlVr?=
 =?utf-8?B?d2Y5U3g1UHVRL1VDaDFtNzVYNW0ycmQ2ck0za1pCNzdLZnJOUmpqaFdTbUFE?=
 =?utf-8?B?SktKVis0ZjRCZUVyZ0R6cUZzSUJJbGhlK2NiREdqNStWcmdjRWRFclVKdXBh?=
 =?utf-8?B?bm9MZUEyMnhEdGtScFpubk5oRjNvcDZWNElkRFdSYXY4WlBJUmt2TUdib3RS?=
 =?utf-8?B?dWlEbW5vS3I4Mk5jSnlmWXk0M0g4dXA0WWJ4VDZmZEhPd0VVM2h5ZmFIaTFB?=
 =?utf-8?B?UXFaRDZzc2s5dEpTOUdsZnNCb2Q1NGpuV3Nldk11Y3ZlamY1NmgyTkduRCtl?=
 =?utf-8?B?Vk0rc3o1WHYxcjdQQnZEN0RQNWdzSkRqb1hlOWFVbi9MWmgwNDRmTHRlS3Nw?=
 =?utf-8?B?Rmk5cEE0bVkreDRVRzVqQWZUWFdlOUpmQ0NOb293YXVDMVpmWWpDY0xjay9h?=
 =?utf-8?B?aW1mWnk3Sk1jSkltTXNBb3hrcWtTU3lIWTlwZzFtTVZJNXUrQmIrMGw1N1lu?=
 =?utf-8?B?UDBQbG1KSy9GV2tCL1QwdE1qdXVhZlVuVXBMTUtVeW56a2YzUlp1SVVEVCtP?=
 =?utf-8?B?WlRIaHdjZ1RZMFZYV1Z1cTJzZi9hQWc2ZmZMdnRaVkRyN2gxWnNaMlptU0gz?=
 =?utf-8?B?KzhZdndZOEdrb3pISE9hZDBBeFc4WkJoaTByVkZ2ZVVzS2FPWGozNURSN0lm?=
 =?utf-8?B?aWNZblhJOWQ1OXJvdWM3ZHR5SW83TC8vb0dUckdTMk9MMEdZL0NzSEVheE1R?=
 =?utf-8?B?NzB1Ynh1c0VDdFpwK3pkRTJqc1JIcDltWE9TeFE0U2RNcG41SEJUL2pBeHlG?=
 =?utf-8?B?NFViZjdaYTMrOUh6VHp5WDhyaUdCZmwzb0VRRTJNQ2hiVDlVRkpZdjZMTERw?=
 =?utf-8?B?bG50S2g3djNJb2RMM0ZiZXJmV0tsZHEwYXBERXk1WWJsc3FhN3JHZExMNzZa?=
 =?utf-8?B?a0EvTzlhWVNDcVdaMG1nVVR2VXBBQTlrVm9icjl0S1l6MjU2QjVUUHpsTnE0?=
 =?utf-8?B?UEVES09KOFk2cURjemxFZGlUT3BHK2poRkZDaFdVL3lzdU1MMGFBckU0Wkc5?=
 =?utf-8?B?TklKRXEvcXNGU0dKSGYzQVhmNnA5aDB1d2NNVWtGbmwxcXp3cC9DZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 105ad3e2-2bab-49ec-2ef2-08de49f86bfd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 12:14:04.7889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4FxX8cxUtsc3IEnOUDFaE6VjCxw8wymicrEX5mXZGXMh6aomrkx5Xqybuy+GspS+50tfcLf0lETKMJxClXCz2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4063



On 29.12.25 08:16, Cindy Lu wrote:
> Improve MAC address handling in mlx5_vdpa_set_attr() to ensure that
> old MAC entries are properly removed from the MPFS table before
> adding a new one. The new MAC address is then added to both the MPFS
> and VLAN tables.
> 
> This change fixes an issue where the updated MAC address would not
> take effect until QEMU was rebooted.
> 
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index c87e6395b060..a75788ace401 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -4055,7 +4055,6 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
>  static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev,
>  			      const struct vdpa_dev_set_config *add_config)
>  {
> -	struct virtio_net_config *config;
>  	struct mlx5_core_dev *pfmdev;
>  	struct mlx5_vdpa_dev *mvdev;
>  	struct mlx5_vdpa_net *ndev;
> @@ -4065,7 +4064,6 @@ static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
>  	mvdev = to_mvdev(dev);
>  	ndev = to_mlx5_vdpa_ndev(mvdev);
>  	mdev = mvdev->mdev;
> -	config = &ndev->config;
>  
>  	down_write(&ndev->reslock);
>  
> @@ -4078,9 +4076,7 @@ static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
>  			goto out;
>  		}
>  		pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
> -		err = mlx5_mpfs_add_mac(pfmdev, config->mac);
> -		if (!err)
> -			ether_addr_copy(config->mac, add_config->net.mac);
> +		err = mlx5_vdpa_change_new_mac(ndev, pfmdev, (u8 *)add_config->net.mac);
>  	}
>  
>  out:

Thanks for your patch. It looks much better like this.

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos

