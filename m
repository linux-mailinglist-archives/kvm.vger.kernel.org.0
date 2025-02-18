Return-Path: <kvm+bounces-38477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BD506A3A7E1
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 536F67A135D
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 19:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834381E834D;
	Tue, 18 Feb 2025 19:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pMQkxeI4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA92B1B3937;
	Tue, 18 Feb 2025 19:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739907802; cv=fail; b=XWP5gLQDiGZWHemjFbXAi7YIsH9vg718D3sDwKPHPlbEnci6aryFS1xxYeL1Jmv2m22Owp8gEbY2jlNe8yj90rbLXqPfbM6EbuErLyOjFUFzf8Gt9q8aQuD0ze/6C10pM0KF48eyzqoZhPoReQNuigvOqQ7CTJaW+rtnKxAaWPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739907802; c=relaxed/simple;
	bh=npkRLcd32Tp/1UEtClkBEf7isUXxnwjgCTroOYTwE0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SPIjc8SAyTlT7jp0XoPPRwfd+mCz1hbLyr9Yz0E7olaXnDw6goIqiV418RL/5F28jGJyxeJcjUKyvx86e38LLSupYg2/cBuY0Sdz0DfhjHeJsx5zAvkmcWjIZu/OHiIq0gl6JVwxj6jZkguKSmQvdJepK0AdaOONb3dDiKxreT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pMQkxeI4; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=prkIN0DKb3fS0uAOQDhC+BZgpaw/4A2ML2bqY0v2kmlKWbWCcVVmZBXDHYv+0f99Tdkh1Yk2Iyud3H9APVVVhEosIYXRB+mXt1xwqklo6tXeXqHtOhV8oCqItZAuVd7XRCeV90Z/z6kgvkoI/mL0pDf+vH8d8gT0kWxnQozUfwnzodwPqTns68qEBnesYYLzZJeTGJJrhyLlvc61nNNcfKr+1TSn8aL8LTz4TWQkn40M0eJhVgc6MPnrRVQ7eD9+hvEbxgj/us7X4vBv9tbB4khJAqO8IyzqqxUbyYsiL+4MsDCeGFoFDpnW0/kiG7ezBMnGtpkX8M2PZTX/lvQoNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfwLymLwvUcEicgD7bWfClVhfv9DRQtOXk8ul/y5JcY=;
 b=D407wikYbI6tZGQ3AAOkS7FtlDEtQ3nZmSSo2pDt6pfV4e+QKIwPgL1pZKyLk41XG7L3eM2k/qDndkk7OA+QSt3a5+c7bO8233npYssSUUFUnP6vsElG2krpvtzpidNHiCbEYUMy64TmsPhM4tPAxoJpSL5WvARhU/qmkGDCqGPbdgTkHsB4/aL5071dW1AK29uPFc72cQkqV58Z6Dw9Yw0Mk3PjGpr2nPsDRc+C2D7O6NTseW2NyVFmuTRpPItKork9r3ICc7JVNRTtAaBX0zqhgjCy+kKnvAcm1Kc4oc4kyjbvR7+v+anJ9P4yu1mzWh9vAr1nijO/yy6D151cEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfwLymLwvUcEicgD7bWfClVhfv9DRQtOXk8ul/y5JcY=;
 b=pMQkxeI4B2kREobvm9SRJW52c+/yrSV/kTcDQzAF2qi9zPel0W6c635ClrghCWturoSLaaCuVFXPi0jxS7+Tkbt+X9m3pkx+493B7Jbd/RJ/e8EwVRvstb6QCqO5OgZXuBflZl2kVlkwUMQovyg9VT89mtE3zSSywTWzm5QoTiyoQobZVa0oknF96cJnpXupjpkyjIxXTbQKreRClR1RZhv5VX0i85YrsBz6wDApIHzYpJDklNyoMkdy8J4uzqORUEUwf1i8f5EwNj8CtANxVC+5M3l/zng5lDz9xTFJE9lXisNmMUQz4zuOnOIimH0pdSb3hNLo03FQuXQboGb8rQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19)
 by MN2PR12MB4271.namprd12.prod.outlook.com (2603:10b6:208:1d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Tue, 18 Feb
 2025 19:43:15 +0000
Received: from IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c]) by IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c%4]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 19:43:15 +0000
Date: Tue, 18 Feb 2025 19:43:09 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, 
	Jason Wang <jasowang@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, stable@vger.kernel.org
Subject: Re: [PATCH vhost] vdpa/mlx5: Fix oversized null mkey longer than
 32bit
Message-ID: <ow7bhl3dfvllmgbasaemdmkcbj3odxkxslvra2kyrb6uev4n3e@sylpfadz7cpu>
References: <20250217194443.145601-1-dtatulea@nvidia.com>
 <CAJaqyWcXcW9U7a1bMAngG-eEjw6t5T3XPUdn_hai5OWWTQW85Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWcXcW9U7a1bMAngG-eEjw6t5T3XPUdn_hai5OWWTQW85Q@mail.gmail.com>
X-ClientProxiedBy: FR4P281CA0412.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::20) To IA1PR12MB9031.namprd12.prod.outlook.com
 (2603:10b6:208:3f9::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB9031:EE_|MN2PR12MB4271:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca55c4a-3be6-4703-6f54-08dd50547c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTZSc0dLOERkZnlvSktHQmIvTFo0UFVKWU50cVVpRzI5TjB1S01icTNiRkNP?=
 =?utf-8?B?bUdUa3QvS2h5UmZ2cXI3bE9lSVd0dnlWV2pralVTOGI0ZTZLTmFob1NEVndv?=
 =?utf-8?B?MjdUdDQyeWN0YUJ2Y3I1anlrV1JUNEVqdENIWWdRZ1J6SEkrQ1FKMkdjSWVR?=
 =?utf-8?B?NnVmQW9MUVRPWCtLalRRdkN0TkxFSGVZZmpBS2VReFFyOXBnenN2SWZSL1ov?=
 =?utf-8?B?ay96L1F6WU9BaGM1a1V6N1grbXA1a2R5bWtTVDBISlF1cHZqVUI0V3p4d3hw?=
 =?utf-8?B?VjlvRHF4WEpFS0kxcEhPcmpNWDlwYUhBcGRPSm55MCtsYllqWWhHUUxTbUUz?=
 =?utf-8?B?Tzh4YWYrVGNYZ3JJa280VmYwL3VjNkROcHBnZVZHa0JQQlhva0FBa0ZKRDk3?=
 =?utf-8?B?OHZOd0dONUkweEdhd25yT0pJMTA1MkN2UThzbmJqU2pHRi93SXNWYTUya0hh?=
 =?utf-8?B?NU5EY3V5dXFTdEh2S1VyQ21ySUxEbnBsR3hNTS9DZFJsZUMveW5YcFBkbGZi?=
 =?utf-8?B?b0U4K2dCRUpRd2R3Y3AzNnV2NERWcHZqMW1Rc1o1SHR5NDk0SXNQM04wRHdo?=
 =?utf-8?B?SDdLVUorVnF2YnowT0RiNG4yVzFUekRzOHN5NHlvbTNyUDZVK1ZCbWNOL3o2?=
 =?utf-8?B?V3ZMQTQ1NGp0MnBDSC9MaFludGo5dXF2d0dJQnFSSStqQXNzUmxGd0dGN3gv?=
 =?utf-8?B?M2pOdms5YTJHZEZYdFJySjlMaGMva0pUQ3Ryc05xQVhhRkJ5QWZqMFN6OVor?=
 =?utf-8?B?c2ZZZnZEYmNOd2kyZDJGL254R3BWTkpTcm13UEdsMHdBWW9PTmtxWXUxbUlN?=
 =?utf-8?B?Ly9UMW1tL2FNUWk0S1ZzSm9EbVNteVN4QXd1MEFJRGwwdlZHRUwwQUJXSHlz?=
 =?utf-8?B?Z1V6YnVUbUFIQitIWTlVZmRXTzdaa1p0L09ESEowdU42RVNsR2tVUUVkZ20y?=
 =?utf-8?B?RDhCVW02YVI1ME5hZ2NzZ2hldUxtalZ2TEFMUlNvcGNUUi9oNkx0T0pDaUJo?=
 =?utf-8?B?SDcyWU1NbEMvdENwV2FKQXZSTXZ5b3FBTWVsSEdkL0U2RXVGd3BmaUNKcWhT?=
 =?utf-8?B?U3IrNUxIK3FFeFNBWmR1R1BmbXRVNzFaZExiWEhLQjVFVHZsdFdPU1dQakNO?=
 =?utf-8?B?VUtoNnFWRTJLQWlydVpIano3WG1QTDJ3cEhvVW0rU1NjeDhzdlhHRjB3SExZ?=
 =?utf-8?B?RVF1WU5qanlEMmVtWFp1UjVGdDZweFNuL054OWw3bGp6T00vRHE4N1QvU0RW?=
 =?utf-8?B?cHk1YzZ6SXBnbnhud2JiSlBkSFBIbWhTUmJ5aVJVeExMYlZVZlJpYU1HOG8w?=
 =?utf-8?B?NlNaKzdDdWdZV2xqOUZIckRYclNJN2xoTDJqc0VMTk5oazZZNS95Uk9HV01E?=
 =?utf-8?B?T2xxejl5aS9kN3JQN0N2VE5NWnhiUm5RMTkwRStjVnZ4TUVRUkkxSzM3UGVG?=
 =?utf-8?B?MG9CcFo3Z0w3S21BT1VkMFZZb2R0M0xVd3VVaUJVZnBiSUI1ZVE0OFJhWlVO?=
 =?utf-8?B?OUhyOHRVUWpsU1plQVVhMUlwK3FrelVBRWQrNjFZY0ROdFVuMTZ5NXcrWWYr?=
 =?utf-8?B?WXNBZGtCbm13TjA4dkVnb3ozaENrLzJuK01oMXRsQi9QaWMvSml4eVltUm1C?=
 =?utf-8?B?QlN6cWRHVTI2eVRENWwvRlZLL2FCRW9YZmszTzJtYnlQRlVSTnl3UGdzRFh0?=
 =?utf-8?B?KytGMllCNC9NMk5FYmJDRUs4S0dzV0ZCRElKSGRPOHFzOXBtL3RTTWVLQzVC?=
 =?utf-8?B?eDEzd0FuaHd0ZmhxQVI2cGdkN2drQTlRQ0xqd0J2UXMvUWhEYm1HcFhqZzJN?=
 =?utf-8?B?N1BNVmx1MlRINGw5djArQkFSRTJBa2pvSDBzQXlpWVRZZ3o5UEN6K0lRdkd3?=
 =?utf-8?Q?cs2Dd/P1KwoVM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB9031.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDFxUDRmR3crNkt5YTFLeURSVkVxVklMSjJDS0VaU1M1dmV4SzNVeG5xcndQ?=
 =?utf-8?B?WkN4Y2JGaVVUNlNVQ0MxSG9ZN0JBL1JzN1ZyYmJ0U0o2TEtjQlRlcFRIMUdR?=
 =?utf-8?B?RERwNmxPc01DWlNZNFArN2UyOFhKOE5IVlcxU09oeVUyTFpxZHpzdUtYb3Rm?=
 =?utf-8?B?VzNJVGtxdjM4SU0zcmhVY0l6d0ZUNTVzZ3FXUW5lWGVKTUhydFNOVmp1ZVRF?=
 =?utf-8?B?MzhYMUxkYmN4UVB5a1JwcXZEYXlHTE5KMzB4alFWR3Fvd09sU0thREwzVXc0?=
 =?utf-8?B?QkozaTVpM3gxTVhtaVhETEdSTFQ5Yy8rb2t0ZmZNV05TWDVTUUFiMExjR0dB?=
 =?utf-8?B?Q01ISit2bHJqWGZtWWI3K25UMmRqbitaS0Z5Y0pOa0NyeklZS3NSUHcxZmlV?=
 =?utf-8?B?TGFLcy85WjZsRnVCekNRZ3ZQK3Y4NHkrMEJ0Y0E5b1RraTZLL1cwWW1ZeG14?=
 =?utf-8?B?dUFzODdQTkowQ2p6dkFtWnNrOGtGMk83elFSdSt4MHMvakVUUTZ4MlZqU1VM?=
 =?utf-8?B?eWFjWHM1UFd2b09aNHpURlJuQ1FKeUFKWVZWMHNxMDBGN0VBbURWWUdLOXZR?=
 =?utf-8?B?SzJKL3lselgyd3VnZENqb2hTbzNaV1dkZ21pMlc4WmVPMGw1M3RIRjFqZVBO?=
 =?utf-8?B?NG1CbFNEMDl4SjRkWjdpOElPbGdkWFJoME9IYkVuUmVpcFRUekx0YnZMM0s2?=
 =?utf-8?B?VW9FTEo3WXhQclkySzVjR2p3aHhqSXZpSEwwQytoV0k5ZUw2aEl6QjNZd3Bm?=
 =?utf-8?B?bDJxQjg0MmY4Y2YwaUMxV3oweDQyVE5neGhhc2w3bFUxWTZrZnZ2ZWZwRkpG?=
 =?utf-8?B?L3R1bDdpc0NpMEtGOVdwMWlSSjBvRVJ1QnFBRXpsVkkwZTJBU3ZxUGpFaG15?=
 =?utf-8?B?ZmFScHdNd0lXUytIRFhHbnIwbjhyLzdkRkxhQU9XdEw4N1ZQSURRSUx6cjUx?=
 =?utf-8?B?NjB2cm5NWnA5TlordC9mRDN3a1Fyd1R6czRlUmxwSCtzd1l4R3lwUFpLLzVp?=
 =?utf-8?B?TFU2VjFxTGFuWHFQT0Z5VnZ5Y2RQelRKSlVuN3ZxU1N2RWw1RGtTMXVSWlVV?=
 =?utf-8?B?K09XUStZQldnSHV1L1IyakJSbllkZEpHbGtISWMyUFZIU1lEMENTT0NRNHU3?=
 =?utf-8?B?ZWtPUXZGVklXUk9wampMUHV6NCtNZWQ1TC9sY0tYcDdjZU1SalJuWnl1K0NU?=
 =?utf-8?B?RWM4eGJHenFJaEkxV21Db1RablJuUnNHR3IwOHZYRHNzdXNNTUpQb216Q3pr?=
 =?utf-8?B?V0g2UC83ZldTUHlnT0FXeEtzaHh2ZXJiL1p3V2djR2oxZnVOazJIQUxMY0sr?=
 =?utf-8?B?d1Q3WWRuYmtZN1VvRXVCKy9JcHBKWjRTMi9MbVdCS0VBTEFXYUdNOVlWS0hh?=
 =?utf-8?B?YklNWkgxYzYvVkVzdUNFcTFKcjZEaFNJY0ZkblF6Ymd4a3lTS0FqUHRQWjhv?=
 =?utf-8?B?dlpDRDJYM25zeTYwUWV4YUFIRDhndVRidVg0bzRyYWpxTGlmcWRrUnI5ZG8r?=
 =?utf-8?B?Z0dMd3Q2MjY2eEtwanBETWNoN25hTTcrTjd0UTZhYkowU3VHWHdwWkRFMkpZ?=
 =?utf-8?B?bGFMNy8zUEdOMFlDNXJJT2FHN2NpbFBjVEVtZkZnemRENmJzZFl6TDlZK3hZ?=
 =?utf-8?B?S09YN2MwZXd6YlhFNVFsSFByWGQrQXBydmRQRTBPRWdOYXdOZkNKcFF5Nmwz?=
 =?utf-8?B?cXRQbkxLNWZCRjBkUDlNVytjRm1BOFA1Mkttd29lZGFIaUMwcWtSYngxcG43?=
 =?utf-8?B?ZDRTZHpWQWF6c0hPZDk2MGc2bGRJcDkxbkNkd3lTby8rSHhyWTQ0MlV5N2pq?=
 =?utf-8?B?SnFHeDZwQ1ZjY2VDZThVWVl2NlQ4bk5tbG8zRTdTczB4U2R0dXVCK1B6Zzl1?=
 =?utf-8?B?amtRNmMrcmdzTUJnTmx2N3BIVXlqTkxMYlFBR1V0WEhwUEU2Q0NvNC81cC9t?=
 =?utf-8?B?SDM5KzZCR1dyVis4MFVlREFHaEVsMzd5ZUk2TVY3WWNTZGo3empoWFVqQ3ZY?=
 =?utf-8?B?VHZqUDlqY1RiaFNVWWFiZkNOS2hIWk5jbmFYTnpiaDZCZ3lNMUxOYTIydHNv?=
 =?utf-8?B?SmJqMldDS3dwVjJLajVQZHB5VldZbVFwbU14dkZ3YTFnQ04zQ2Z1TXpKNzlU?=
 =?utf-8?Q?I9AL1mPRthTR68h+pQKmYA7Bu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca55c4a-3be6-4703-6f54-08dd50547c8e
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB9031.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 19:43:15.6639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1bsyfqOSIKxvAGMQGwbv2RqTO8W/FsUKzxLSigRPO9GPxcXHmbqc8Dm4rymYQrGPQNbtgKpmV22H/TJ9qF5ZSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4271

On 02/18, Eugenio Perez Martin wrote:
> On Mon, Feb 17, 2025 at 8:45 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
> >
> > From: Si-Wei Liu <si-wei.liu@oracle.com>
> >
> > create_user_mr() has correct code to count the number of null keys
> > used to fill in a hole for the memory map. However, fill_indir()
> > does not follow the same to cap the range up to the 1GB limit
> > correspondinly.
> 
> s/correspondinly/correspondingly/g
>
Will fix in v2.

> Sounds to me the logic can be merged in a helper?
>
Not sure if possible in a useful way: the logic in create_user_mr() is
different.

Also: this patch is kept small for stable tre.

> Either way,
> 
> Acked-by: Eugenio Pérez <eperezma@redhat.com>
> 
Thanks!

> 
> > Fill in more null keys for the gaps in between,
> > so that null keys are correctly populated.
> >
> > Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > ---
> >  drivers/vdpa/mlx5/core/mr.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> > index 8455f08f5d40..61424342c096 100644
> > --- a/drivers/vdpa/mlx5/core/mr.c
> > +++ b/drivers/vdpa/mlx5/core/mr.c
> > @@ -190,9 +190,12 @@ static void fill_indir(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mkey, v
> >                         klm->bcount = cpu_to_be32(klm_bcount(dmr->end - dmr->start));
> >                         preve = dmr->end;
> >                 } else {
> > +                       u64 bcount = min_t(u64, dmr->start - preve, MAX_KLM_SIZE);
> > +
> >                         klm->key = cpu_to_be32(mvdev->res.null_mkey);
> > -                       klm->bcount = cpu_to_be32(klm_bcount(dmr->start - preve));
> > -                       preve = dmr->start;
> > +                       klm->bcount = cpu_to_be32(klm_bcount(bcount));
> > +                       preve += bcount;
> > +
> >                         goto again;
> >                 }
> >         }
> > --
> > 2.43.0
> >
> 

