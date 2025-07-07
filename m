Return-Path: <kvm+bounces-51668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DC8AFB4B1
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 15:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C5121AA22E2
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 13:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADD329994B;
	Mon,  7 Jul 2025 13:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SCDRPekq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7624819D8A8
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 13:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751895283; cv=fail; b=Z2TasZTswLGOIqq4d52XrFGMlInRlsEFW7wQB8wIVGNPA8S7K5EPypcEZ4KNlHMjuInc0L3SwP5QNbuT1ZWBN19VhQygKpvseOakzwmeLMaiHbvb9mFf8cKTXa6qhS1UR+vmX8N38fQaHYhOs8Fnd+dTmb3a6anKmXG1cCsOj74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751895283; c=relaxed/simple;
	bh=5snS0zOGk+087YYXmy3dHrWs2sMNis03s0FwQr2AR8M=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=bWAS0oTaMLLabhveyLgpwGFIK567PVvN4xwnvOrfE07jNxAfVizxlwMJpN4Vp9pFNsLJbTRgDIKUU4zXuo2HWnOBmCbpWfLO8OMyzIjJeIJxKAqZJwb6BB0Q62e9LWimyZwABGRo2gBw3Qoprwd8BSUxprrlrXMPl1lsgP8O180=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SCDRPekq; arc=fail smtp.client-ip=40.107.223.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NUAAPqf2Zf1HIOLHh9vGb5uBvstfSMQfORsMSOBUGc+mrKv/VZHCwhCt7Rr4a/45Xqi1Vs9sfhm58GVsaG+MdJUtxEen1iem4lc6vWWIdp7G4q88OcTBL27M0Hc116vx6vGdWKrnAPUYOnntV3SBHU50S+Udhhe6b9p/CC67H3fQi3aGGAIh3NtPXfgbHrgec47XZY1Wx1A5ftXOcK+0RTSX0oNjSJ15V4ITBuRFwLP1qbHxTYcxCrH4qESTIw1NMbko9xBZjbI3WedogOx+AuK4gXE7mQ5OpDFnsN3jEKNqUe7WNwzqC26s9RMFG5jYGBD5Jvz1j1FXZNp+jqffSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9EKybKI8YbidOuwwoKzuziXUFtvcxWqTfP0h7SKzA1M=;
 b=oqhHV21fE40SpuZ3e0xLcdGHXS1RZekFDBbIpl8MzY/oGdlFMycDy+v0D6MsUB1KeZ4rczu1p/7Sk8K6IhuLErpw73XjrofTwgWCtzYFBUUNHtamAP1ImVD6vflBj93u+DUUTyCu+PRvRl0+QKc0n9Ci5VJ+rBHdVPrCXF6Mr5KVmal59mWjKxy0ogPu9gLqMu8Wtw4QSStUVMnDoGrJQ28NbO/piK+sP6SmvOpT1ArFZv2YIdvaH+z0R81Ab6MeSOkrEp3gOBcQ8KrUWCpApi6g98wHLcU4PBKsog+AbQ/o3+7n0QZe1drOXtf79gXSo0HvYwXe1Wz/OpQPT2Ro+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EKybKI8YbidOuwwoKzuziXUFtvcxWqTfP0h7SKzA1M=;
 b=SCDRPekqckT7UIsIvs2NbyST78BKqIFNDoPabjnZ34BrRTkT0YZVntC0WaXb64LgyQu29yKSLIc3cS3I0ScFCNxZ4WVQOJwBiVWAk39MVyC8k9fyLl6kb11JkSbbqeHjsZ7if2deUUJe3s8BCZMShXaHKVRiH6kV80vVxNFxpXI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB7077.namprd12.prod.outlook.com (2603:10b6:510:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 7 Jul
 2025 13:34:39 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 13:34:38 +0000
Message-ID: <f7fc6934-3b9e-762a-d9c2-d37d5e7d76df@amd.com>
Date: Mon, 7 Jul 2025 08:34:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com,
 vaishali.thakkar@suse.com, kai.huang@intel.com
References: <20250707101029.927906-1-nikunj@amd.com>
 <20250707101029.927906-3-nikunj@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
In-Reply-To: <20250707101029.927906-3-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB7077:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a9f3e1-fb0d-4708-4eed-08ddbd5b052d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zi8wMEVDSDlFNVMveS9iZE96aVhCQnEvMEpuZkxDMEluRzZuWldYMU53YlV4?=
 =?utf-8?B?Nmh3Nm1FaS9iQmxZTVhkQmxmOHE5WXVlczNCRElOZmZGbjJVSGpXTHJvdnY2?=
 =?utf-8?B?eU10dEg3US9HT0JFcWR4WkQ1WkZQcEtRdVQzeDNTK01GMmlHV1dmUjQwSm1p?=
 =?utf-8?B?dkUxaU81RkNiRDE5ZkJDWWRLeEN6eEEyMU82UG9BVUdoRTZRWTBQTkNOa0tz?=
 =?utf-8?B?NEkwamQrc3pWYlNySG9YalM0bzZYOUdIZlhWRHFZUVlOTHlrVUVCTnp0eDl0?=
 =?utf-8?B?a1FRZHYwNkhBemxST25Ka1hsQm5odmRaL3c1b0tCeUFGTkZCWmw4ZUdyZlpt?=
 =?utf-8?B?bW5rNnMyajZNYmxIK2hnZFN2eFlmdWRSNDRJblNLb3JPaW9Ja2l4QXFnT2E4?=
 =?utf-8?B?bzFoeExDd2ZrenRGNVV6TU1WNldGQld3SXp1eGRkOXRxWjgrSTNreU1rQWky?=
 =?utf-8?B?bVZtRjNnTkViMEJVYUR3UStYWUtUdmx4MnN2N1VVS0hmS2FYZ1VtNnpPRGlu?=
 =?utf-8?B?QStnKzR1VkV3SDAweUxMbzJZU0dheXF5ZUREcm5STk1uUTRHMHJNVCswTUlz?=
 =?utf-8?B?SHAySWJpT21wVGdNVm95ZVI0M1E5RWVtV0g4eHUwanpPOGZlbzI5cUxTOVNK?=
 =?utf-8?B?TGZuTkYycnhadDNLTGdtUEttKzVqUVpybFI4OGM5aEdmM3k2eG9iYlUvN2xX?=
 =?utf-8?B?U0hlZG5EWmtvN3pEWGh3d296aTNrVC81K1NRTXJMZWNaYUVXZGRJbXY3d1Zl?=
 =?utf-8?B?b0lDdEZXL0o0QlpySkRmeW9LL3FKamYvM2hqaXFEdlVqVmozcUJEUUFaSWFh?=
 =?utf-8?B?L294UEVOQkFFQzZ0OTA5NjZ5dHNOdkhzbThrQ0tVRVRXRmp6R3dzWDEwUSt3?=
 =?utf-8?B?NDVSeHBJeEFiTUFOeUxEbDdIYVF6bm5hU0F3T25ZclJqdXRIWUJJSkxwNTZK?=
 =?utf-8?B?VExqWXBnODA4SXlVbGFqVFV6UEozcVNBR2Q1WFh5cE8xWTFlU0h5alZvVEp5?=
 =?utf-8?B?UFFzN1Vmek8zZW9YTXVpZlhSakNYVGkvZXIwbjBwRmswVW1FNmsza3Ezdm9v?=
 =?utf-8?B?MGljQmJJaXVQUkdaS29XYm9IWjlna2E3MGJZbEx0a2NzZXBzUHVHbm94endw?=
 =?utf-8?B?OFlSWjBXQzlqUVR0OFBKaTVNRGZlR0RQZDRiYllmVzU5VDlQUXRDZFdPWWJr?=
 =?utf-8?B?TlFNdnZ4QUVQZEU4VlJNQlFEdnBQbWJZb2VOYXUwc3Q3NFA2blZmNWhjOEFj?=
 =?utf-8?B?QzgyZ2M3RDY2Z3FMd2NRczc4U1hrOGdJbHdmbm92RDdQRVc0TXJ2MGE0SUJD?=
 =?utf-8?B?Zi9YTTY2NndoTWNzdDhrdXg4WkFvMWVUelJWeVUrU1lVZjVWNnJqRjlQcmpR?=
 =?utf-8?B?UFNQcVU5aHJhMGxjNkRra2cyaXZnS1d5Q1dsV2RieWhTaUlnMGJpT2t0MWdN?=
 =?utf-8?B?clJTbldqTm1ZNjlZNGFHL0JzOUVmd0dhVWordkZuU3RiRUJURm5peG9XVDFX?=
 =?utf-8?B?anJ2em8yTG9yc2h0WFI1WENXb2ZTcFkvR3l3ci96WENPczNoUWQ2NGdPcjBG?=
 =?utf-8?B?WFFiVk1wWFp5czFyNXJzZUppcTIyTWsrZFU3VlVaZkZLcHZwZ3NTZ2c1aEFH?=
 =?utf-8?B?Z3ZLVCtkN0QwUHNnSFliUUFXR2JjWGtoTnVjTmtYSTNvYUJ4d3M5NXYrYlN4?=
 =?utf-8?B?WDhuVDlDOEk5aDYxaVloUUYrYUw0NVBoa3J6NTdBUVQ5d2JrbFAzOUMzQ3pn?=
 =?utf-8?B?QjdkYWJnaVlSN0o3dFJOWWNQdFdwRUF2MVMzdTlCb01KcStGU05ydlM1dUhq?=
 =?utf-8?B?c29sQWdkWTNHQmRhaEI3b05ZWHVaTGdMeVZySldnY0dLOTFESHVndUpyNkF3?=
 =?utf-8?B?T3NZbWdISkN3QTRXTUhvcDJnMnE2NTBOK1o0c05WZi9BNUhFK1JFUi9FME1H?=
 =?utf-8?Q?XQtG1CrAUqU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3JGVGJ0NW1INWdqMGlzamFMdXdpcnZTUFFDQjZhd2pmRXlqRDNJOGZoQ25q?=
 =?utf-8?B?UC9DaFBMayt3cVZVSWxtMTBadXBuNVN6emxReGo4N0llN21WTXhYMmVSNUVD?=
 =?utf-8?B?U0pGWkp3ZmtCdjRaVGc3RnMyaVJqbUU1TXdIYjl1NlNJaVBjY1dpbWdFZGw4?=
 =?utf-8?B?M0VWUG5CSFBiOHRwc0VEbE9TVlRSYkt3cTRFdDFtU0NKNFBLTWpta1FXQWEv?=
 =?utf-8?B?WVc2UVdMMkZGMVUzUElnS2xYSE9PUDBicE5QbGkwbHRaV2xIbGoybCtvTnVX?=
 =?utf-8?B?THU4eHpkaWZjcy9DODR1WFlEaERkaUVQUnd4N1I4ME1qUm9jS2ZGdmRQcHJK?=
 =?utf-8?B?dUx1MFZtZTVpejFGWnd3UlkxZEdmT01XZ3k2aFVnUG0zb21RK2NBemdVNFJY?=
 =?utf-8?B?MG51eE1QYTM3Zlo0VVlXYmJMR1k2c3RuUThiNTBTcWE2NmpWLzlSRGR1RjJ1?=
 =?utf-8?B?K1pOS3JReTdRZzJrNEVqSGVkd284UWZWcG1MaDlDWVRWY2RMWUZEOGtpKzVa?=
 =?utf-8?B?TUlsR1pNVGFndEZ4Z2tCSU5MUGRuMk1OVUoyY2wvNzlaeVd6dG13WWNZN0k1?=
 =?utf-8?B?RWFkc0Y0MDNmMGM4Z293OWk0TnR6VU9TN3BuT1AwS3YwZzhaekttbit5M2Zy?=
 =?utf-8?B?UThmN1o0d2dFdXJubG8yT0l2STFyY05OVk55Vms2V1h2SHNneGlxMEJDblRV?=
 =?utf-8?B?TTloZkVFcktlam5GK0RVaHUvWVhoNW9BbEJ2ZDhSaVA0bU1IU3NEQlgxQlBa?=
 =?utf-8?B?b2MyYlFONFF6Z3VSaEtQSGkxYzMwa0VDUHR1Z1BhNEJrWTFrYUNsaXFoTFZl?=
 =?utf-8?B?OWoyczUwTTQ5NDR0Q0hPb1Iybm5MM3UzWExsKzBMaW5KbEdyY3h4YUcwZGx6?=
 =?utf-8?B?cDV6Y2gyU1E2MmV3QXFHcnpMdEtiZEtyZW1ZcWNGN3FFVXFQWm9uSVVFb0R4?=
 =?utf-8?B?QmRQdWFIdHhDcDEwR01lV0JHSXhPZW4ydDJsWXgxdkxQL2JVSTZqZ0oyV0ZJ?=
 =?utf-8?B?S0YzNEhOZkJIczRiRzkwTVk2aVVPQTkwWU01eHNkdlV4dEJXeHRoaVhwT1ow?=
 =?utf-8?B?VzdYeUhnY1RQeE1ZZm9mVnBiWUIvQTF1YmpzVGRLYnpyWC9DYldwOGZXUlFW?=
 =?utf-8?B?N0h5OW1yTlpIakhpWms2Mzg5azJNd1VURWJkOGtIRjNWYlUvWFAyRHRUazlZ?=
 =?utf-8?B?ZjdVVFQrcXgvd3VCbVdIVVRFUFR5aEVPZ21ZdTdzWDExZkFIRkpaTExYRWox?=
 =?utf-8?B?MnkvaG55Y3d6ZFlQRUVWU3JvRGFlVVpNOXB1Y3ZsR2FvTm5ZUng1RzJic3FU?=
 =?utf-8?B?cXZLLzZPV0d6RmthZUY2NXJoN3B0TTBqU0RJZ0hkWjB4VlJORDFXV0kyMkNT?=
 =?utf-8?B?ME9uOUYzd3k3TVlXa1AvcjRtNUZnTElCR1hsS0ZWbkdpWW5lb2F0TzJkdWQy?=
 =?utf-8?B?YytCOWJ1WnpCRytsSW1ydXRzTjFIRTJSOXFHdnRBMW8xSG5QYUNmVFFNYXVU?=
 =?utf-8?B?UmZtbTV6cmFSQStpOUNGdWpzWm9wcWVObE5vMGEyU2pYd2U2MVRlRGF4TUZl?=
 =?utf-8?B?VHFnN0NXM2RtVlpJTWRRWXF4S0RLRWpSdzhjT3czOWlORy8wYkFCcTB4WlNy?=
 =?utf-8?B?R1owYW9DbVhldU1FdUc1d2xhYUpiQjJSQmZXdG9uamZUU05YcGJ5bndESmRK?=
 =?utf-8?B?cFlSWmYwS0phQ0FUNVlyVlkzSFp6ekpvOUJ6Nk1ZMzRha1I2alJVY1RlSEho?=
 =?utf-8?B?TEo0ZG1SSTVqZ3ZXalBKVFEyUHE3TXp2TXFuR0s3WVd4NEZHcE9yVmx0Vjg2?=
 =?utf-8?B?TWRnT1NMd3MxV3ZHU0k2OHdybVRyNDFRaUdUVDk4bmYxbFZUMERpRG9OSGp0?=
 =?utf-8?B?N0ZRQVRrdzd4YjlEWWNGTUIzL1QxOVovWGlwUkFFSDlENC8zTkNzMFdIYVdx?=
 =?utf-8?B?UmtkaGFBYWpiUWJHa2U5OXQyeFc4M0Zrd2xydThEK1dIdFFZbThyVXNYeExp?=
 =?utf-8?B?TDI0NndiWG5CVkRPNlZlRUZqb1ZqNmNUditFdGpKZmxDaUgzZHV5bUlacHln?=
 =?utf-8?B?Mmc4QUd5Y1hFc0RmVi9SenJXQUlkcnJKZ2J5L2QyL1FsYnBNbTRhTDRUNFJF?=
 =?utf-8?Q?bgwWIJnpyiSGg8yVdRl/PZiOV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a9f3e1-fb0d-4708-4eed-08ddbd5b052d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 13:34:38.5283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2GY7KCvoA1EJcGC7FXlNBkz8bDUT91qxsdRYb5BCPVGRxYxuJoxCNNWCppcinD8uPIMV5BBlDvwc3Avdq8/aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7077

On 7/7/25 05:10, Nikunj A Dadhania wrote:
> Add support for Secure TSC, allowing userspace to configure the Secure TSC
> feature for SNP guests. Use the SNP specification's desired TSC frequency
> parameter during the SNP_LAUNCH_START command to set the mean TSC
> frequency in KHz for Secure TSC enabled guests.
> 
> Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is
> passed to SNP guests in the SNP_LAUNCH_START command.  The default value
> is the host TSC frequency.  The userspace can optionally change the TSC
> frequency via the KVM_SET_TSC_KHZ ioctl before calling the
> SNP_LAUNCH_START ioctl.
> 
> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
> guests. Disable interception of this MSR when Secure TSC is enabled. Note
> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
> hypervisor context.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> ---
> 
> I have incorporated changes from Sean to prevent the setting of SecureTSC
> for non-SNP guests. I have added his 'Co-developed-by' acknowledgment, but
> I have not yet included his 'Signed-off-by'. I will leave that for him to
> add.
> ---
>  arch/x86/include/asm/svm.h |  1 +
>  arch/x86/kvm/svm/sev.c     | 34 +++++++++++++++++++++++++++++++---
>  2 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index ffc27f676243..17f6c3fedeee 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -299,6 +299,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>  #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
> +#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
>  
>  #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index fde328ed3f78..5ac4841f925d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -146,6 +146,14 @@ static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
>  	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
>  }
>  
> +static bool snp_secure_tsc_enabled(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +
> +	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
> +		!WARN_ON_ONCE(!sev_snp_guest(kvm));
> +}
> +
>  /* Must be called with the sev_bitmap_lock held */
>  static bool __sev_recycle_asids(unsigned int min_asid, unsigned int max_asid)
>  {
> @@ -405,6 +413,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>  	struct sev_platform_init_args init_args = {0};
>  	bool es_active = vm_type != KVM_X86_SEV_VM;
> +	bool snp_active = vm_type == KVM_X86_SNP_VM;
>  	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
>  	int ret;
>  
> @@ -414,6 +423,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	if (data->flags)
>  		return -EINVAL;
>  
> +	if (!snp_active)
> +		valid_vmsa_features &= ~SVM_SEV_FEAT_SECURE_TSC;
> +
>  	if (data->vmsa_features & ~valid_vmsa_features)
>  		return -EINVAL;
>  
> @@ -436,7 +448,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	if (sev->es_active && !sev->ghcb_version)
>  		sev->ghcb_version = GHCB_VERSION_DEFAULT;
>  
> -	if (vm_type == KVM_X86_SNP_VM)
> +	if (snp_active)
>  		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
>  
>  	ret = sev_asid_new(sev);
> @@ -449,7 +461,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  		goto e_free;
>  
>  	/* This needs to happen after SEV/SNP firmware initialization. */
> -	if (vm_type == KVM_X86_SNP_VM) {
> +	if (snp_active) {
>  		ret = snp_guest_req_init(kvm);
>  		if (ret)
>  			goto e_free;
> @@ -2146,6 +2158,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
> +
> +	if (snp_secure_tsc_enabled(kvm)) {
> +		if (!kvm->arch.default_tsc_khz)
> +			return -EINVAL;
> +
> +		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
> +	}
> +
>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>  	if (rc) {
> @@ -2386,7 +2406,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  			return ret;
>  		}
>  
> -		svm->vcpu.arch.guest_state_protected = true;
> +		vcpu->arch.guest_state_protected = true;
> +		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
> +
>  		/*
>  		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
>  		 * be _always_ ON. Enable it only after setting
> @@ -3036,6 +3058,9 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
>  }
>  
>  void sev_hardware_unsetup(void)
> @@ -4487,6 +4512,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  
>  	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
>  	svm_clr_intercept(svm, INTERCEPT_XSETBV);
> +
> +	if (snp_secure_tsc_enabled(svm->vcpu.kvm))
> +		svm_disable_intercept_for_msr(&svm->vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_RW);
>  }
>  
>  void sev_init_vmcb(struct vcpu_svm *svm)

