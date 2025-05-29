Return-Path: <kvm+bounces-48002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8D66AC837A
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F35E8A20632
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC1A829372F;
	Thu, 29 May 2025 21:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fGtMCj9S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E411292094;
	Thu, 29 May 2025 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748553271; cv=fail; b=TM0x4vC5yaR77S8xRQBzDSAdG8azCXHwaSqGXkJAo9n4nZGb9d55N3Ka8KJXqzcL8hevjTjND6fI9zk9WVhtQkebO3lxLfWwi6FwKpRz4w6bEyXj23QFhIdtzgHHhbDbyF/hRh24qUHI1jdjzSxUm7Ja0P6bnKHDrAdXVywLT1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748553271; c=relaxed/simple;
	bh=pumEXtSLbxYBXCjLNrq2LHbFCGPt+JFSXRiUzYzbAnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dymi9bXClqJe9W9glVnyWKaO53Xe4dfNfawpS06rr3/3rLuJNBGAGwptDYgYUrRsa14e5Ydp3xenT1EVrjfKYl6tGykrELxBhDqoZQ2WxY5TMMLdsipGAvzReQx7Q7j+XBEyL5Kqzqicw2kVCxcPnyOpwZWUxkb/0yTpakMaOAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fGtMCj9S; arc=fail smtp.client-ip=40.107.237.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gG3/qDBDJnEEuixGFtg1VRF+fiY95xj346gOhUN9xjeGhnQGmHE+biwoRc7JQmOcSSGJ/Gvd81GRdPCzT21r+IttrKhP6v1qKudSi/ASEou3+OH/gJF0LPL5LsdDSFq1jyIlC8iYlND+FMbdZPIV13jA0fNLaGVyZ1iGL6/tJUN68BbxlD3pc/T+D9F7A7lp6cIvBiuEUTdUBs6RrPG9g05/wZDad6TAV0C86/9yi/1UTe70LFd+/OxOWe4h4DGtn4XlSZ/iAeiqFID8uakCG3Y3JHGd3jphLQvfv6FSsdTZa05or51JodROT9g9c6pbGFwt+1zA90qbrvHI8GXnzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/v/BDQlbdAZaJ6YimsCccxJ7v+Ts7+9G2CNvj4pkG0=;
 b=G1aNVycMz0uhTet368JXHyRuzp/wpc18fJ02a1QZKxbeTKa2XalMqRjt8aQg/hs66ERSQlaoHlXabRFTwDuE4/JRvJv3Z87cKWMvhh0KmlpYTNxA7q16sXpIkd90AlMKFr8wNA789kHMRshI+KFircBEVf/Cm/0wbslu/+FxurKJ70rihsPetJFDxKI7ebTEah+hnIoo+sKUOQXN8Xs/kPi6YDl3LVdRhn25S9m+uO4dciZHWFizW2IyHVoi/N8aFgV5x9zyn6UFqG+H3N2e+a224Gzr4t4YvWuiUGlnpf0AU8MtTWv+RgX23jYyOcKRZ3eDeKn1YAE6tADSV9Mzkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/v/BDQlbdAZaJ6YimsCccxJ7v+Ts7+9G2CNvj4pkG0=;
 b=fGtMCj9SLFQYH/QndDFpeHGY1TNM5xNj0ynfC573rcHvojM80kwL6eKfu0nbWRR4G8q4MQf/MzzY5oodOH9d391AVMyOEVfFhVPPBU+e5vygu/MQL1S2dfPitDDKgsvZarCa8JmRFuI0EQndkS2irYKDkBJUjML7iwYiiwS8CG0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BN7PPF7C0ACC722.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Thu, 29 May
 2025 21:14:27 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%3]) with mapi id 15.20.8769.025; Thu, 29 May 2025
 21:14:27 +0000
Date: Thu, 29 May 2025 16:14:15 -0500
From: John Allen <john.allen@amd.com>
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	tglx@linutronix.de, dave.hansen@intel.com, seanjc@google.com,
	pbonzini@redhat.com, peterz@infradead.org,
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, bp@alien8.de,
	chang.seok.bae@intel.com, xin3.li@intel.com,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Eric Biggers <ebiggers@google.com>, Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v8 2/6] x86/fpu: Initialize guest FPU permissions from
 guest defaults
Message-ID: <aDjOJ4tQAmHwBiXg@AUSJOHALLEN.amd.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <20250522151031.426788-3-chao.gao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522151031.426788-3-chao.gao@intel.com>
X-ClientProxiedBy: PH8PR21CA0014.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::28) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|BN7PPF7C0ACC722:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a392328-8989-4075-85b2-08dd9ef5cb45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PDTJgaIDN9i796rBMAChL/hmqrmucXz9PfV76Io3gGjNnAQeDrP+0A/ROUQ3?=
 =?us-ascii?Q?T0GtxP5d0ztpXmQxYpD6mPtbZeMjyJ0piuLzkS3H4jp/kPhS+rUsu8r07ytk?=
 =?us-ascii?Q?Y4pFCZXfoBz1hdbfcbhtIs3F5p6toqk+3Y7S6Qv6Yxq0etdX7VhJcBS/GVMf?=
 =?us-ascii?Q?HEyXH5+0inPXeqhDsGnfBa65iUqXIjRMW8d+lFGRxQ/n3SFJJhnbQkGfhSZI?=
 =?us-ascii?Q?W/RJE4eJOXhLyHFgwzqY4oMNn0s7D3ulZV/5WB8CdvIwGW3cXMOqVhRSAQrd?=
 =?us-ascii?Q?IIhRMKFqAxBOJ6+zyFS6e9nPoHgLQdKouYyZdJjKXW+unimxl+WSyIA5Jo/J?=
 =?us-ascii?Q?DNVFWe27IMcf6bkgnwGZL1AeXRFFp1S6FUcHq8elM7NOwxnoeC7Nf/ynfYb7?=
 =?us-ascii?Q?DczQmkIHv9Q5zNyc0/CcowFpGOTF1pDorETLn8JJ18wrYIoaa55cTBNIwCaX?=
 =?us-ascii?Q?WLXqG8XDnwcHcoQga3Grr9x091fmv6rGaRaSBT1DQA1/dCDQpdOxYLHNw4TG?=
 =?us-ascii?Q?CicSCsLVyjldHCSnMQRX71jpoPfjpv+Qpp3GzuFgpgipxqD+6P3b0U7IZVPX?=
 =?us-ascii?Q?Cr1GNTbm/U7qqGeLeP9w8ZALZboyQZZspT/N83T2f3YeNuf1IDldSdrlRCLo?=
 =?us-ascii?Q?9+roFqrDmPbdFXUidcaoaFR8QgBae+Bn28NwJ3c0aFMniXQFOecY4Xab1aUG?=
 =?us-ascii?Q?EFBJA02I0TsppSDCcpLoNGGXB3NWgiZuVpyD197glfKnuQ+ogn0KKrkTnnF/?=
 =?us-ascii?Q?njuOycXNrwPb71kXm6rSzkGaobsXHRpHNruyivyVnCe2NWqWSx3OdJF+Phkb?=
 =?us-ascii?Q?6tCTVZ/2Wp04h8f7M+3/gR7m7vPOwmX4/uInXL/AyFFqkmYwUJpbd4enxd4U?=
 =?us-ascii?Q?T+5OixcrDWqCWQYcVNaLghj/XkMfMEk2vBBQ/QKpjwAYfAuy5dNvaDYHNCFk?=
 =?us-ascii?Q?+OJLnBxW3VUKkN/khrfparHdTGz/Pgtt4lma13bFDlxZKwBbdiNocmbkGwhM?=
 =?us-ascii?Q?adF98djRRec8Flz9y1hNycUgpGtD6Fq2kmZDUz8Kce2kd+e39/8XVYKgzV0B?=
 =?us-ascii?Q?GCN/pNm2Kw4VcMh35jkS2T4/eTHXwrkz5XjThxxFWPx/XHLb/UKHUiF9Pslr?=
 =?us-ascii?Q?0UNasPmt87l8tdizN2H/422pGHvM5gZ30YvkpfwL1gRunGnNLhyfrHKGqe4Q?=
 =?us-ascii?Q?e8pAyPq7Hoa+D208+k6s353/f6KqqaJ5zUaSTRyyU+sNLTEhaYX3pjfJ59iZ?=
 =?us-ascii?Q?VHoWMraNL1NDitn/vILdvZcrJ2kuIoed1u4uw7YKZxeH/RMAJQDDHeW+4oxa?=
 =?us-ascii?Q?pfVtAzarvue24pgp34Y4l8LbOpS9dVSf74C/4EhdUJBnYbQAXdmeTnTK0Owf?=
 =?us-ascii?Q?yZq8PXtaWUf2cJfTJgEgDJA9SeOyjL5AtbRP5Jqg8h/nAZKG9Z/AE0P2Yzx6?=
 =?us-ascii?Q?gNv/vr7yAhg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bM+3X607lnC+OnpDUF0F2N1fwi8JdcNNpFi3yvk/gqxxCJ5j0+4vJO6buBow?=
 =?us-ascii?Q?8snplzFzEUE9utWHUP7svaB7B7iGJR79ncnRm3jClBBO0Qq0zRnL4Gy3ZUKS?=
 =?us-ascii?Q?neDPBEAnxPGRCPy+ust00GukO6iTYZyedBYJoy2DQD7OqKU7tmAk4cCqKP+X?=
 =?us-ascii?Q?gmEgWUv+1DZ51AHdFU9bBt5w/TXq2GOgm/J1nf1eDh0CeY6bmjwap/iW+nPd?=
 =?us-ascii?Q?3nX8vwjGJASqSy1yIbb0xM61fz08Frr43pi6JLDGtUINPKkNj4mghAJQQQpP?=
 =?us-ascii?Q?sEc0L6RbLLndVNhEuP2KuOYzeexb27Dvcy4XeHp8bN+YvA9hOGrDpmLn3sY9?=
 =?us-ascii?Q?aSvAvz2h8MbzX5GuQCquwh7I4etVD/HgYIMpN5YbWuK92NBZYy2BjV9/zDyS?=
 =?us-ascii?Q?oW+a+OvL3O7/cjEQ3mcHhu3C6n/cagidXcCP1kZ87gGA2IoiQSzCgKa/RdC7?=
 =?us-ascii?Q?hTOL1x+LK4iKJEN+bePqePTEXHLhQs2p+REDWvCLWcAa/NTuiuKFG9D52mGK?=
 =?us-ascii?Q?jKod8hY+OuA20d3+R7Xj8UagaB+JChOfGJO0FgrxW4W5RawJne+MHNGt+5AN?=
 =?us-ascii?Q?1yK7wn8yAE/leIU2dMwm7iwX7dcRabNAo6vNPPRiIoLn2b+WuWaTz+CA4oab?=
 =?us-ascii?Q?0R7IIJ0WIVoLHK/588Z8jSitsAI439iIylH7mxZhx9V7YBYecb+DXdgm6upN?=
 =?us-ascii?Q?2aBrOrNuXvhOFWyutULYpsVtrTLfsM4MdTE7pqg9UncinjPnxiyzZs3awe8+?=
 =?us-ascii?Q?uCG0hF6Y765gzu+ELLyhRk+6KHkOxhESBLGxpuOJ73QmalU94L4woG24ip/y?=
 =?us-ascii?Q?V5c9Uxm3SiJdOHfzaTfALH5ZX7ID/O7xVx8yMuFO82HGH7X6//D3KK/ATLDk?=
 =?us-ascii?Q?oiMlqbmhRPC7wAAUiloBx6+13osD9m4MWRFgeP8UbXa1CTNFSBaNttor/D9e?=
 =?us-ascii?Q?aH/j4lnEvlcOf8JZ/j501en82sZEsTvWP98yXcKezqLNrZmmL262J4xhy/pm?=
 =?us-ascii?Q?YWtk51u5G82zJ/2vZz7h54XRSlRu5ojMR9k74/FkMPhosgZdvr9baLZKAN9h?=
 =?us-ascii?Q?p/MO/AEbTg2mcCgQ/0xqY8RbmBzZL/vi/C3V5jo//kvsj6u+H8k748I842g+?=
 =?us-ascii?Q?WI0XEPZCHRQRxEtt/ZlBZlDWDDFG2yU7Vse9ZCmbsYtiZfM+z3/9qiL/8ZKn?=
 =?us-ascii?Q?vJieyqUzd1faZhHipFvJlsLmZbIZlbw2wvGVNWa7FrbRJTz221ZBMZN1RZct?=
 =?us-ascii?Q?Z72CUL+mgLCWdGpVya3pz38IwFA6Xk9dvh7XkVZqpAYPWnRXK9hAbhB7sUxj?=
 =?us-ascii?Q?NcC5trt2mKKAYd5uzp8QSflMvoxQGLyh4lPaIkRVGxbdvkuUlfZ28tTySLRx?=
 =?us-ascii?Q?4G+hzG+II8l/4DH0rzi6dEMshJ87UwHYesYAE/lFZViACVcCRqHdqmOJbPi+?=
 =?us-ascii?Q?QuJuTtsdWfK8PZGwkaXsyBpObXEtXsNxwW0bqsEQ4IzBXn7lFYa4onh7Tn1J?=
 =?us-ascii?Q?gsFGQ5LIh5zXhFKBSeaXY05wzz9pPAh8K/q5w3wbm/RjnM0yOBzMJQr6IYD6?=
 =?us-ascii?Q?1PjxF7ku9Dhrckzb72R1X2Cw4wIs7Nn5HzRTqcoQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a392328-8989-4075-85b2-08dd9ef5cb45
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 21:14:27.2287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3T5GHI3ephFBfnrM4TroP7lOTGBhcQ21AyBKz5N3SIhYCNHmQYgyd4wKa6h5q1fU9SJwLg2afNjp/1ttXA7mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF7C0ACC722

On Thu, May 22, 2025 at 08:10:05AM -0700, Chao Gao wrote:
> Currently, fpu->guest_perm is copied from fpu->perm, which is derived from
> fpu_kernel_cfg.default_features.
> 
> Guest defaults were introduced to differentiate the features and sizes of
> host and guest FPUs. Copying guest FPU permissions from the host will lead
> to inconsistencies between the guest default features and permissions.
> 
> Initialize guest FPU permissions from guest defaults instead of host
> defaults. This ensures that any changes to guest default features are
> automatically reflected in guest permissions, which in turn guarantees
> that fpstate_realloc() allocates a correctly sized XSAVE buffer for guest
> FPUs.
> 
> Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: John Allen <john.allen@amd.com>

