Return-Path: <kvm+bounces-43603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F22CDA92ED6
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 02:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F7168E517D
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 00:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBCF41760;
	Fri, 18 Apr 2025 00:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Be0xiziE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2065.outbound.protection.outlook.com [40.107.212.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D5B2A1BB
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 00:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744936404; cv=fail; b=N+iuxQWXL7YhnBzTZqZvVeepNYYhhol9LeT/JN6mYqrrH21cEzELQR22P5qAqSQjVnEeB/07OPyNoTg+WrZvoM1okd0rOFCbMWhQdhDyCV0+k8lst6YsjWJeYtz34qIMGmLkV3/CMA8DlJySON6Xcr9DMAmqcHGiryxvvP3n5Ss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744936404; c=relaxed/simple;
	bh=mxRJalmsnZPm87LOr6xnsO5n9fWtTJaN9OFBfKiRS9c=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W+LqjzYYIrJsTbGoVFS90Ikz1h08cdq8zAyQCfvK5qq1RUgQpLrXhgzw9Y/7B9nfvbsT2Vc6FBRvhid9ZxYI+TiU+xpKMi/+AJG14YImuBy1jiPDh4pp1A5O+KPTHvWPHBaVinDzNu7I5zRDr1j1bYVxH9LsAZVUEt3313ssHes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Be0xiziE; arc=fail smtp.client-ip=40.107.212.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=owvEiwzfqA/qLwpO5+iYS+s9dbd3U7B2D5uWy9U73jmgsQ+lZQ8OL061kmCX2ngVK7h/jyMAuq9VtfQzqHTUCWNXTdf3FwBqgxBvkxsPxBuRe0XriUjohVEoGCpWmT1REgrW64BuvF642G3YejxQnwXShrwznyHK1oh8n9FvTbCOo225xOtk9GXA7WTjJwBolc2JctJVEupqvh7GqnpMHhAeCJwePlK1OmSl1lU9pwj7FfVRTKuocpMcqlx/h13X2A7Vra6Va696k0goeJy/ogs1hSCrL29c9RHT75i92AnGnBgMihKCAF2jD7WULUTFkMnn8IdwbZCsa08ll0huBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAiwRrKT9MncXzFNr2H7kmyzht9lGwYqTZZ/9Dyg7L8=;
 b=OGmfzG1wZ9kKcOiuXA9ghHlQqBEE6fdSeTMfGtZFeLU8gSqJymV6qBuBL20UMHNZgAWuTTOPEvsqDrGU9XtNU3wKLjz8tpsIB+Y6ZK5H6gJeMG3ExQJEvNF87gePDglYtzLfQc6XjPqtlbyETMXRuRl5jXsOzCS/zIhBev3i39TtSCzmj7LO1uJDIWbHG7j2nHXS4M0rbpQ7Sip0FmMJaTgKL5bK/ZpyeLAtcTjkHcpRNQkCrRYZXzlp3ElOZzvj77giUFRGRU5UwDLoba8zpy/uaojeOZA3da7zsx43Pq+Jb7/0gq4Le0xoiQXaOqDzw4llBS109/yeFV1RiqEuxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAiwRrKT9MncXzFNr2H7kmyzht9lGwYqTZZ/9Dyg7L8=;
 b=Be0xiziEt1GVM/sc0SzQGWlKDd5W/8r3ziJr1UKhWcT5tKcVJw80aRfnR5SH2CDsR6xIGYCQswunI7Kcs1el0BTLFw9dsmJJCmopJlT0bqPBM06Qronit2W3zSj+tf1TwwMFWHiPR8UReLPhrinJwE8tXpNRLxAWzj2q9iFa3pU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by SA1PR12MB7197.namprd12.prod.outlook.com (2603:10b6:806:2bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.21; Fri, 18 Apr
 2025 00:33:18 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%7]) with mapi id 15.20.8655.022; Fri, 18 Apr 2025
 00:33:17 +0000
Message-ID: <ffda853c-7ce0-43ff-a611-b35aa9ae8343@amd.com>
Date: Thu, 17 Apr 2025 19:33:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] target/i386: Update EPYC CPU models for Cache
 property, RAS, SVM feature and add EPYC-Turin CPU model
From: "Moger, Babu" <bmoger@amd.com>
To: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com
Cc: zhao1.liu@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 davydov-max@yandex-team.ru
References: <cover.1740766026.git.babu.moger@amd.com>
 <58341c9c-d618-40d3-92ac-ee5a7f1e3255@amd.com>
Content-Language: en-US
In-Reply-To: <58341c9c-d618-40d3-92ac-ee5a7f1e3255@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:610:59::29) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|SA1PR12MB7197:EE_
X-MS-Office365-Filtering-Correlation-Id: bbaee3e9-2811-42ed-0dfb-08dd7e109cf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0FIT090SlpGb25vUUZXTWF5M2FySms2blBpQk5zK2JBaDR2d3grRVJDWXZZ?=
 =?utf-8?B?WkN6NGljVlBoV0I3TTR4ZzJML2RZU3VONmhRV2dUZ21ZQkFueVpvczBwdjJ3?=
 =?utf-8?B?M2l5amNXV1I5K3ZGYlR2ZlFNYStpMmloVjF6bHRzTm15WURodUYxOVovNVBO?=
 =?utf-8?B?YkV4VVBoQkZqU0o4NjNYRjdxRzVCTlR6ZjIyN1VaVjRpeW1qcHc0NEhqVFU2?=
 =?utf-8?B?NVB0Mk93cVBtbmZVRXR0WUhUbFdsdnNOL0RncEI2VGtGKzJnZkpGT2hZOVg4?=
 =?utf-8?B?UGNiU3lGRW5SWC90QWxPS01rSDMvVzB4bUpMMGh2YlJLdjVOUzR3NGtTSWlv?=
 =?utf-8?B?eEg1OUdWRnhhbUkzUE45c1ZOZ1kydnNiaDNiZ2Y2NGVMQnUrQ1ZyRkR2SXdE?=
 =?utf-8?B?bjlHY1R3bjdJQlVycW5lWnUydFdWOFlSL1p6ZC9ET2tHS25wL2VreThFSkx5?=
 =?utf-8?B?WjRDVzRWWEV3a2RXSTVNcUwwamZ6UC9RYlB6dlhCNEFGdktwNDVHbUJNRUsz?=
 =?utf-8?B?a2NDUmFuUGZvRFNPRGdPRTRUVWg3S0krQmFIK0xQTHlWdE56U2ZFQ2RJbHNy?=
 =?utf-8?B?U0dvTlJxMXJYZWVsU24yK2FpTlNGVHhCNStUcjlRVlg5Z0t6ZkVOeno1MXho?=
 =?utf-8?B?TlJKL0hYVWhSZEh2NmtPR3RYdDBaNDVyemJwdnU3VzhReUk0bkdaYWgrUjdU?=
 =?utf-8?B?RVFZanU2TE1LdlFBQ2hsb0JuOS9OZy8zNG8rOUsxOXh5NkRHSk5xcGFnS1hE?=
 =?utf-8?B?eUVKTmozbnBIck9CM1RsMTNScUlYVzZjeklQTDdxU2cwa3B1ZncyVng2SmdE?=
 =?utf-8?B?cHNab0tBTnFmb0dvNEVKZndnMHlXZVJhOGw0RWxIUU1Jd2dIbFQ1NHEvV291?=
 =?utf-8?B?L3AwZmVhdUFySkN0WlFRZXIzdC9xbDd0WEF3SEJsSzdPT1FFLytvZmVDOXpL?=
 =?utf-8?B?QlV0VTczUUhKYmpwOU9LRXNBS3RBM1Q0SWZwSkNRcmdDSC9zTmZXYnZmTkxz?=
 =?utf-8?B?VFRrMWFid1NsdWhWbTc1ZnM2Z3YyY1hUa1M0Y2dqK2o0TkRiQmU3STFQeUZj?=
 =?utf-8?B?UTVMdkl4aW5pSzFQSHJWOFBmWDNJbW9vVzkrck1zQkk3dStoTjY0OUdqYUoz?=
 =?utf-8?B?eFIraG5kYm9zc2FneDRmMklMbnZmb2tTanpCbzNrNHEydkxTOEQ1QTBPU3BM?=
 =?utf-8?B?Vko0OGxqOGNLUWJ4VmhhZmJEclN2d04xdEpXaUYvcXdzdkgxOEVqU2tTeEdo?=
 =?utf-8?B?WDFhVG11NXI4dEZvU1pYSmRrR1dGK1F0VXNzNjlZZ21MOGhkTG5GR1dvSGVV?=
 =?utf-8?B?WDdJNW9ERmk2R1lnbzd2YmJHbnM2aHNRdmdGTlA0MWN5OVNYTjFYY1B6b28w?=
 =?utf-8?B?WXF2VlN4WURZRXpkQjFmSlJHUUVxV1lBSkZ6YWw0SnB1TlM1MitvUjJBeTZT?=
 =?utf-8?B?bTN1dDlpMzg4c0t6alFobTlOSFUyS2hSYmVIVEEvbVRmYjY3dm43b0grOGk2?=
 =?utf-8?B?ajhlcldaY3RaZkF2ZzJCT1VRcHc2WUpQd05Yd1BycGt6TFdBTDEzWVROYzJT?=
 =?utf-8?B?bWxEYm8rcXg2bjBGblYzbUNqeG9YREZiME5qMHoxUU1XNlcxb3I4eHdhb2Vn?=
 =?utf-8?B?R2lkbC84eStoT09DOStrdUllLzczYTJBM2V0ZVdITkhDcWlkUGdtTXU0WkJt?=
 =?utf-8?B?bm80ak8xeTZtRGFBa0taNlFmTEROM1VKUFRYL3hvZEFnbTd4VnNNNkxVZ0F3?=
 =?utf-8?B?eWtLdGNnV25zMEJCYTh2dWVVdGoyeUtFV3F6WTlaREJTcTMzZzhNV1dBQnNj?=
 =?utf-8?B?Rk5UbHZPTVdBQlk0RHNzRVVoT0FhQm5obkkrRUxCUFNqbXE4ZEN6S2U3cWNN?=
 =?utf-8?Q?Bib9v9OBpikYd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1IydjdPclZ0OGgxZlhkOEplcEJxMmhvSm9lUjR3UG1kWTd4QWNaNXNMWmxG?=
 =?utf-8?B?V3pKanRRRUp5djBSa3NBZU5EZGFEYjU2S2grWDFUaldlVUd3ZjdUMi9KQ2Jr?=
 =?utf-8?B?VER4amFYWDUyVDdXamhuZ2UreHhXRXJtTkUxTzN5SThxSGFsQmdOVVB1di9T?=
 =?utf-8?B?UWdYU05XQm1Wa3gvUEwvZFAxUlNyWmdueUd1bnAyV053Nzdja1N0ejN3c2dD?=
 =?utf-8?B?NXB0MEJ6dnhmNm1PK3BLREprVWw5all2ZWlXaW5Ma0gxWjZJUUQ4U003Mjlr?=
 =?utf-8?B?WERmemVUeUJzTFNHRFVITmpjYkJ6Wk1CNlpXUWFkZldKZGJ3QnRMUVVnT1Vq?=
 =?utf-8?B?S0F5aHowVHJsamlSMDdEYWxxQ2Z5MmJzbnFod0RsSlYrV1A4ZC9TVnFlb09E?=
 =?utf-8?B?a2tLaUNBM0paRk5lNzlOaWNYL1N0M3RaMjdDZ2RDV2FneTZmd3VLZVR4alJn?=
 =?utf-8?B?YStxSFJTZEFjL294SS9YSUJ0Q0lGR003aCttQk9KN01DRUhsN3l2MHJacGxu?=
 =?utf-8?B?allJdXU3c1RrRWxaQW9ScHVtei85OVlDKzIzb2NOU1d2T0orcDlpb2JPaXZC?=
 =?utf-8?B?N0UzVUZGUmdqaUUvTzVLVklDdzhKazdUMXhiRWQyaHg4d3lwSTE0TmE4TklQ?=
 =?utf-8?B?elRtR0Q1ZW5PY2lzNWxjZnUxd2JGeHJ5Q3UwdDR4bDlGOWFnUkxLcmtnanpQ?=
 =?utf-8?B?WW03QVFtK3VyTW1KMzhvUWZUZG80TElaZi9HbitKM0lHTUNxaXBtRDRZdGF4?=
 =?utf-8?B?c29iRjJheW9TN3B3TlZtSTMrN2d6VTFDMnI0U3VkK2ljN3F4OS9IaFFoLy9Q?=
 =?utf-8?B?S3BZandGbTJIekE5M2Jpb0hMWW1OWG41VE1JaDQwT3RoS0Y2R1IwRUtQU0lV?=
 =?utf-8?B?cUZlUUFXSWVtSVA4S0I4RHg5d1BzcmdUTkxYbVJNNFpSTkJqdkxQbTA1NGho?=
 =?utf-8?B?dnNKa1pqbU5qREh5dXRLUEtLYi9OdkZ1N1FKZzZvZkx4RnRobWh0cE9PNjEy?=
 =?utf-8?B?VTlONUQ2SDh3OEwva0RjN29yWHFNOWlrL2lKdmNXY0pVMm9GdmEwZ25QYXZL?=
 =?utf-8?B?SGdnNEhMVUkxUWYrV0RXQnNtYkRpaTF4d0ZHc0dGaGkydWtsVnFzdVFDa2h5?=
 =?utf-8?B?Z1VZYXJDb0s0UG1ZeURtK2ptTEhBZms3WWI5YkdGNXIrelJqYVdBL3dVaS9m?=
 =?utf-8?B?Nkh6ZFo4NktTaWxQaWlkN1NWWk5NS052aE5TL3VsRDFnYVZoeGpoZjF2VG9U?=
 =?utf-8?B?U1NwcU1ldUhmYnFxZmpqRFppVUp5c3N4azZmRzRMSDQ2V1ZxV2NFczFxUXdM?=
 =?utf-8?B?bzFFZGFhcU9rb1VKSTIrSkJLL3Ayei9ybkJyN3RtZkh5ZG1rVE1lV1BTQzFV?=
 =?utf-8?B?ZDNNNTQ2R1VUU0ppT3RtZGxTQVd3aGp1QzNibHFheFRTMVRwTzJmb1hoamtN?=
 =?utf-8?B?bjR0QytidzJaRVMzT3c4RkZrdUJMRnROcm50RmhsSnFkMVovU1FyWlRvdHlx?=
 =?utf-8?B?WnV1ay9VYzNNdVNOMERvZkZ0MFZwVVZDenRrYXR1UmNtK0tjQnJDVEFST24w?=
 =?utf-8?B?RHozTzdrMTY3N3F3VjBFK1hFcHZiU3cydnoxOG42ZVhsUXBEZmxudW95VG1U?=
 =?utf-8?B?K2pwaGwybkRCb0hXSkl1SjVhekdTaytZb0YzS2dWdDdwdGJZTTB1dnF1Q01V?=
 =?utf-8?B?alUrMTZ6bXUxa2VzQm5qbHluQXVBNUdwTWFZSnRwb01WSkRTN0QyYldmY1V6?=
 =?utf-8?B?SktCWHZLbFpMVzFhdFI5dC9JZzJWNUZ6TkpaQXJMUThreThDK0FNeDRDOWUz?=
 =?utf-8?B?cWJoemt3QW9SMHpuTmFocUQ4elQ2N09Nd0lXWG5waHJXVWxLcStGU1VFUzJV?=
 =?utf-8?B?Q25qRHUyVHdFY3BtM1ZzUVM3R2Nlb0RVZEJIUnhHdVJCOHQzNk1mdmVZczNj?=
 =?utf-8?B?YXBxSFdBYUFNaWthRUVoL0ptcjFyTytBemwycDZIWTVXUTB0NGtCdHBiRkE3?=
 =?utf-8?B?SUhnR2k3aFdudmZEMnY2U3QreHFjOVc3YWd0eUZPWmlGM3NQSlh1cU84YWpo?=
 =?utf-8?B?bERYcENiT2UzeXloTXZHYzl0UkFzL0xTVFprcFRVN2tNZ1VnTEhpaW1KNlJJ?=
 =?utf-8?Q?HpaVIomoj2ec09wtpAC2/2RAf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbaee3e9-2811-42ed-0dfb-08dd7e109cf9
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 00:33:17.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w9QfPzJni8mvS/F0Ivn2W6meqkpu7uD6gRGXTnQqF/ktTAy05InFcc6EU+smN+wZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7197

Hi Paolo,

On 3/7/2025 4:47 PM, Moger, Babu wrote:
> Hi Paolo,
> 
> Can you please pull these series if you don't have any concerns.
> 
> Thanks
> Babu
> 
> On 2/28/2025 12:07 PM, Babu Moger wrote:
>>
>> Following changes are implemented in this series.
>>
>> 1. Fixed the cache(L2,L3) property details in all the EPYC models.
>> 2. Add RAS feature bits (SUCCOR, McaOverflowRecov) on all EPYC models
>> 3. Add missing SVM feature bits required for nested guests on all EPYC 
>> models
>> 4. Add the missing feature bit fs-gs-base-ns(WRMSR to {FS,GS,KERNEL_G} 
>> S_BASE is
>>     non-serializing). This bit is added in EPYC-Genoa and EPYC-Turin 
>> models.
>> 5. Add RAS, SVM, fs-gs-base-ns and perfmon-v2 on EPYC-Genoa and EPYC- 
>> Turin models.
>> 6. Add support for EPYC-Turin.
>>     (Add all the above feature bits and few additional bits movdiri, 
>> movdir64b,
>>      avx512-vp2intersect, avx-vnni, sbpb, ibpb-brtype, srso-user- 
>> kernel-no).
>>
>> Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical- 
>> docs/programmer-references/57238.zip
>> Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/ 
>> speculative-return-stack-overflow-whitepaper.pdf
>> ---
>> v6: Initialized the boolean feature bits to true where applicable.
>>      Added Reviewed-by tag from Zhao.
>>
>> v5: Add EPYC-Turin CPU model
>>      Dropped ERAPS and RAPSIZE bits from EPYC-Turin models as kernel 
>> support for
>>      these bits are not done yet. Users can still use the options 
>> +eraps,+rapsize
>>      to test these featers.
>>      Add Reviewed-by tag from Maksim for the patches already reviewed.
>>
>> v4: Some of the patches in v3 are already merged. Posting the rest of 
>> the patches.
>>      Dropped EPYC-Turin model for now. Will post them later.
>>      Added SVM feature bit as discussed in
>>      https://lore.kernel.org/kvm/b4b7abae-669a-4a86-81d3- 
>> d1f677a82929@redhat.com/
>>      Fixed the cache property details as discussed in
>>      https://lore.kernel.org/kvm/20230504205313.225073-8- 
>> babu.moger@amd.com/
>>      Thanks to Maksim and Paolo for their feedback.
>>
>> v3: Added SBPB, IBPB_BRTYPE, SRSO_USER_KERNEL_NO, ERAPS and RAPSIZE bits
>>      to EPYC-Turin.
>>      Added new patch(1) to fix a minor typo.
>>
>> v2: Fixed couple of typos.
>>      Added Reviewed-by tag from Zhao.
>>      Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of 
>> https://repo.or.cz/qemu/kevin into staging")
>>
>> Previous revisions:
>> v5: https://lore.kernel.org/kvm/cover.1738869208.git.babu.moger@amd.com/
>> v4: https://lore.kernel.org/kvm/cover.1731616198.git.babu.moger@amd.com/
>> v3: https://lore.kernel.org/kvm/cover.1729807947.git.babu.moger@amd.com/
>> v2: https://lore.kernel.org/kvm/cover.1723068946.git.babu.moger@amd.com/
>> v1: https://lore.kernel.org/qemu-devel/ 
>> cover.1718218999.git.babu.moger@amd.com/
>>
>> Babu Moger (6):
>>    target/i386: Update EPYC CPU model for Cache property, RAS, SVM
>>      feature bits
>>    target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM
>>      feature bits
>>    target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM
>>      feature bits
>>    target/i386: Add feature that indicates WRMSR to BASE reg is
>>      non-serializing
>>    target/i386: Update EPYC-Genoa for Cache property, perfmon-v2, RAS and
>>      SVM feature bits
>>    target/i386: Add support for EPYC-Turin model
>>
>>   target/i386/cpu.c | 437 +++++++++++++++++++++++++++++++++++++++++++++-
>>   target/i386/cpu.h |   2 +
>>   2 files changed, 438 insertions(+), 1 deletion(-)
>>
> 

Gently ping again. We are waiting for these patches to be picked up in 
the next merge cycle. Let me know if you have any concerns.

Thanks
Babu


