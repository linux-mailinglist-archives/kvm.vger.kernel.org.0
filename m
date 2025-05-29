Return-Path: <kvm+bounces-48007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50DC8AC8394
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F18B64A6B10
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC966293721;
	Thu, 29 May 2025 21:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1BwmI7//"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A378617C211;
	Thu, 29 May 2025 21:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748553989; cv=fail; b=RuW3+/UmqL4lnxoHHqZWKO1LUtqo/aCC2VZuyD4fYcR/JTd8CJSaspRHGQnVT9pOePWIho21Jp6ZleKxDIwUIz/5U00TXo6FuZ2wToOwyVWkWm7tvn+CnBdR1nTK4LA2EVakK7v6NE4Oz8xqYusRjXPdgGzc0ryBEcUYIALGrFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748553989; c=relaxed/simple;
	bh=qAZ3mR5tm2Cp5k87Qke9JPXVt18MZf52Pj+D9Irbrxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Vmfd/4VTC/9KpI1JjEys2LlvGzipvbats/kI89gUorje2yOJ4tfXv1BV+raaOz+SnBuDdnwNjyUEQxCQbkPukx3JbjDWxez9uV8mcxHh0PZYLaFuC5hnW7uoRzBGW6IG73BwS0lxu4AovR9sBCFwDHftL7ewIpwz7w35Pije/go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1BwmI7//; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cDDwon7girt3jiVoo0YBPaNr0tBa6rmD6Nnj86WXsJx3QWS33LG28uIuH6pJaP7mdPA3ucoVSYsd59q3Ooe+VTmFiNJCa/feERehbQHX4bssGpq+/DlTPbDVPJ5dJaXHvy76mV7VyNjzl2Euh1+y03bU7kX6O1/EIcu3exotIMDmSfQTYrtFSPVFcKI25AGy3xj9KZcsIIoC6GsAxJxVE2lQUgJ7tdn2NHaYtDoLvP3FDkoSsy3iUgXklqEH/arRtSvxHJF4R+LY4+bwFW6YujW9rZ/DIodCr5ZxfDC9Fzsj8sqE2qZdQUqfSGcY8ECXS5szpDcIGAxNNGhHgiGtAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2EGwkIOT6RdRu6Ca8ca/Qir0xP7Yjj2uhxrnSrthEEM=;
 b=BVbz5DNTk0OsillQ16HVfWceQJ/h87f8KRQQzCGN81Ml5t//IpoC2g8MOgCT3EtueRt5vNxdw17l+W/MOAe6R9RcPBNDb6CBUk4gfZXksy0f6Y89FXPDNRorloV8cQpx0ULiZwKQs4nIhG44qxNtptAiCQ8AZB8opNYCM38qrZoz/5N53Uq3Vh/5DyUXQfUvjVuyfxNqLRtGwG1vBAgyRD/WoEqPb82TXw95gO8aL/jFzNgtFa0/XV/jSdYKo/cpv2fnuqfj3y7xeJNoIWZ3MGjMctTs4KG496fHCTfO+MM8K6ijJNvtIi+D49T1PlVy45iQGetnK+svipRv53MH+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EGwkIOT6RdRu6Ca8ca/Qir0xP7Yjj2uhxrnSrthEEM=;
 b=1BwmI7//8sCduf4q2MiEU/fbBQZ/e5FSQQTqsx8G/QqXfUHZJfNetObOErGb0dTt42A8IhVmEYaf9ZxHT0KhH/8TOhLNlcqM61fVq1tLTlPwTwfhOvHUGyI+GyGblT80ihjKXSvJk5WpsMVq2YGaB0SzzVl/NyDp/qQ2BfAPC9g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BL3PR12MB6593.namprd12.prod.outlook.com (2603:10b6:208:38c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Thu, 29 May
 2025 21:26:23 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%3]) with mapi id 15.20.8769.025; Thu, 29 May 2025
 21:26:23 +0000
Date: Thu, 29 May 2025 16:26:17 -0500
From: John Allen <john.allen@amd.com>
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	tglx@linutronix.de, dave.hansen@intel.com, seanjc@google.com,
	pbonzini@redhat.com, peterz@infradead.org,
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, bp@alien8.de,
	chang.seok.bae@intel.com, xin3.li@intel.com,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 4/6] x86/fpu: Remove xfd argument from
 __fpstate_reset()
Message-ID: <aDjQ+dPeBsp7epmx@AUSJOHALLEN.amd.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <20250522151031.426788-5-chao.gao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522151031.426788-5-chao.gao@intel.com>
X-ClientProxiedBy: BY5PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::37) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|BL3PR12MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: 955e2373-a6a2-462d-b5b5-08dd9ef775ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WY2QX+SiJH2MmYN/RDqtyfolEEK/T0ZLHSJFlz5aO0JLP5R56xZd+3ZbWglT?=
 =?us-ascii?Q?PombDChhc4770vtOy5IaR9vpckUaX0Xh4R2sR1Jc6xlExN5O2CDSqfK9DIYu?=
 =?us-ascii?Q?3XEZI0K2RXGrVTsD+jBsbZhNJU36QV0BPoYRUZKmB9xBTH1y+6Jwt64Ez2/V?=
 =?us-ascii?Q?PtzePwCWEsod0M7jWVyelQmjgQvbXobuYD6GvL6XmaIytT9SOYU44oINyiG9?=
 =?us-ascii?Q?6a5X3O8snqyvQbu6w9pG9G3trvzuu1YlGWmtS9RFrIu3Z8c1g1ao9XR0PO5A?=
 =?us-ascii?Q?UDWIqyf5OM1l2ku2VIxxHwJjp5lA8fxtPi10RsZCKYomm9BIIWJKKBcj8BsO?=
 =?us-ascii?Q?3+c2zSpdC7iDozD2F6VLMd5qsE+GN4IYmlFuIJLKtAwebL43tXdJG5TqqV5K?=
 =?us-ascii?Q?CY1qg2M2Ibg2bakzha/9vhIuwQVJkXvxfmGtRk4t9izD5SndHietKGPwzJOw?=
 =?us-ascii?Q?YP6Xz1WwfVLWvDCVTmLxaQdonouhJWrHFNeI3ufpyMzbf3jZl2rFAUiGpaNm?=
 =?us-ascii?Q?eJYs+LqT1HPEh7SLE/gnFbOZ/w5C68gg5/iHKxlx+OGy35ZTCN4lYrzEZcwH?=
 =?us-ascii?Q?qLA0Mey0zWL35IjYzJG866MM2ZjIDeXhqnZVXB6hOym+kaz1+6u8hsplvWq0?=
 =?us-ascii?Q?LDTp37q2ariGLzvSpN+q6CY/txojgFeIUUXt/1BCKyY/CgC1AGp6CNC21HC2?=
 =?us-ascii?Q?zvqX3h1C43naQQLvNMRXJiUuYwn6+CEmp4CjlGgS5jNu84r2QrGZQ1sZz0IS?=
 =?us-ascii?Q?zdH7ziuthrmqMEwgoECi5uyt2OVy/EaIJP1D3ylRlmIBD9YO9Cv2WEYUvuOt?=
 =?us-ascii?Q?+851j9sQCIv5ZPceril0ayN2g4gYSdKKxV04M/RaAMI0NdCISb6PeC0HdrkI?=
 =?us-ascii?Q?nS4JUGRWtv1mJ0k6rfE6xPlHNi34zn2i7AsgR+mbBnVDXh1wmv248aFBqZ+P?=
 =?us-ascii?Q?IX9ibZZyx7Hm7mA7MbEpPmZcMi2j2yvU0FyPWqDJpoj9bxjHYPW2KubTY40I?=
 =?us-ascii?Q?yAnYNur+uEgMM6Yk9jVL0BuUeCKSYyegBkPNOOJztfJCxLIU0wIbBr1r/TXx?=
 =?us-ascii?Q?59qC+AbzaXuvJ9M3kgCMFOJG0cB/EuMYcOBkeGTeAkQVmfmiLPuLZ1omrkyh?=
 =?us-ascii?Q?7mvHdCrlGyCiKrFxyxt8IgURnh2ht+wcJMBob/oSGJYmAJaalxjE7DM9jMYZ?=
 =?us-ascii?Q?wN82G8KjXkLFhe+4CGE5a6twVYDUT7QdwV5UDUgqzSDXn9w5bzYuXgaofF74?=
 =?us-ascii?Q?Sj/A9s/h5SRXwFsp4qC3U4UF4PVIFPQY6MK4koEXma9OGt8SlQ72t0H4Evmg?=
 =?us-ascii?Q?KT/jlLx/it/P/BKzTYrwgLXrHw9oDmuQaIcbrDlT1gL5nvTDgxoOIH6l7uFW?=
 =?us-ascii?Q?mS8vW3AWLRh6Ms50zMDaz8Wx8A/rfo8rondGBjEBeQ4wPZ/J1s06tlINbb/D?=
 =?us-ascii?Q?FBMlHYElTg8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X55Gp0vlOqIRON8xQe8gWeaPon2lIQdUb/nf97lJFFrlz/S3jzgj+h7+I/g9?=
 =?us-ascii?Q?IG8Wb/fiWoU6f8NYM8YbEn2jfqUmGp4eDX1bd0f3r8W1/QcSHG+FJLe8LP2R?=
 =?us-ascii?Q?dGM4pZZpbS19SaoSx03F9nCBremHwHOlFu+XxdF4UuGep8RJT8+knHBgCodJ?=
 =?us-ascii?Q?Z4MAtPjGoClL1rapxzlnugMrXfNHGHBHbYjHk7GbDSpTBsOoTl8s27k4yRbg?=
 =?us-ascii?Q?6nAfjM1w58U6t+FcLMPX+iYZXsqgDnXEsZvfw0UAMZakS01h66nrFvWb563D?=
 =?us-ascii?Q?365Hm/iSNu2YBPADlDFfOxd48hozw8o7j2ubt6XqZgcvefCciybE6ivvZFCL?=
 =?us-ascii?Q?6VyPCdOhVaiE78w7WgIIQZCkuGET16o2g/4iymmnNFX8bVgHnC+rwyoE7q/h?=
 =?us-ascii?Q?EzCemGhKDH1yh4/FOB1OAaSkSufp9pCxZVKmPA3tVtbgH2ov40LiWji3g9VX?=
 =?us-ascii?Q?Je9lQkhcvqc9+zsrqJpSpdp4WgQFqQBFxlLOsUIJaCl3/rzHDeoX6G2WpDDA?=
 =?us-ascii?Q?r8mL7Y8lcdThlOmI0kDTW43WyTMIk0I8qGFDAvw4ChNDn+eNu7kCVhVCyDAR?=
 =?us-ascii?Q?bMd8aJhJMcsUVuGqFbCpnByb0oIoD69ee+kPGlgLM3xMb9wAl3LsqlrEpPpy?=
 =?us-ascii?Q?q7v5N0h/PmQ8TfACvuAANDkCOuLGh2+yO+V/PllFGDENYaRPgcVn8NqEySlq?=
 =?us-ascii?Q?6S03SouYjyxKhbYMQMnbjuNjHcB9fTv5RIdivOs2v7UBcVMCkI2E/kP3XCPg?=
 =?us-ascii?Q?kOSaQ2fPBvLx6bKSB7a/dAPsniPo8Kwxw44ZxvbImX4swBqJkxmkxH36ybTK?=
 =?us-ascii?Q?z9sdRWQTr1s/64ol1zgrU9azIUR1/hlMP4IvJWhgVRapR29AL67wmiDQxDHi?=
 =?us-ascii?Q?BC7xgiTYSb9jVPoNp5HSOnZkv1KbofPhcU2OrFeRw6+upfdSaJCFRgAqzmUK?=
 =?us-ascii?Q?6r8kFbfMvQV4JG2D2VcmbMoIgMHgIRqW7wFgV3NoT0H6wmy6Cqyp03Z0BJzF?=
 =?us-ascii?Q?16/NCpM6GhXzQedk0PeQqdkukJgiLu5hAuZ8i/Arq8U+e12mLWyXdbQL+4ay?=
 =?us-ascii?Q?sVEXCga2JYQOnnchIXpWzzu6J8GM3muXjkGROaL+ztUHD7lqmb/Kamj1LOQr?=
 =?us-ascii?Q?s9LT9V3NQ/bxuLzc+bjIkse+O5U8JfvVDYOYrGZU9FJEgjg9ehSRvKiyS1gB?=
 =?us-ascii?Q?s4x7ytqRPn65NxtaLz7yNMyfRpz4SM+aFkLM/ubSE9VFUEH9lG1jwIP+G+IM?=
 =?us-ascii?Q?XhC9OvWdhOO+a4vZBO1ts5yqKFqyrqFK70MPWKryPAqC4kgLSSNrK9zvD8kD?=
 =?us-ascii?Q?5cnXW4LUHZKHvnB/TXupF7aT4uk0BVgEeTW8vlccchoRk2zswueVk4Q+wlUf?=
 =?us-ascii?Q?cMMmiMowry46vNWx7WLTwjqmAffFsTZTxFktAonW1pq+I4V0cK+Rd4ZzwveD?=
 =?us-ascii?Q?Eg9NGEO8c6/q8Xfpnz+gx6VoA8o6Ik+OWTr5ubx7AMWfZCTx/1gu8brbvPIh?=
 =?us-ascii?Q?zhHvMAEG+wIQCEcDZxczZja9cJTZwLfnfGL+0tAhZM17ZC4Fphmi2eKkpOuu?=
 =?us-ascii?Q?jN9xzRm0V7siRdh9jlXsBYufN7t7ZPnBHsqVX+WH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 955e2373-a6a2-462d-b5b5-08dd9ef775ed
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 21:26:23.0814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWNuWsrg0mqerDVuS604iDUfLvKH7rrU3X8AuVC0y8ltarQasGx8wxtp7P+956PHdeKwjqCpgzeLRTSKYa8Pwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6593

On Thu, May 22, 2025 at 08:10:07AM -0700, Chao Gao wrote:
> The initial values for fpstate::xfd differ between guest and host fpstates.
> Currently, the initial values are passed as an argument to
> __fpstate_reset(). But, __fpstate_reset() already assigns different default
> features and sizes based on the type of fpstates (i.e., guest or host). So,
> handle fpstate::xfd in a similar way to highlight the differences in the
> initial xfd value between guest and host fpstates
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: John Allen <john.allen@amd.com>

