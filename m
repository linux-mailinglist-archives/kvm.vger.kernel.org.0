Return-Path: <kvm+bounces-48006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A32AAC8393
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:25:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAE9A4A794B
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0951929372F;
	Thu, 29 May 2025 21:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rXmm9niJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8512343BE;
	Thu, 29 May 2025 21:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748553933; cv=fail; b=L7UAgQtRNInZyDozJEE+HLDfGnfZZ7KKa+8JtqOYXmeayjxYp7Y8/L7jRpFV8MgcqRwJLoX8KUGT38YUs8+r2R9oBcSWd9baYhW174iE8XyqF66VXv/2tnPD/PxnqhyzVpqfVjxEAjJVFnAjGL5DiMzteomrbuCDEuqMzt7GFO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748553933; c=relaxed/simple;
	bh=bY2wCt2URBvgS60DtlPaC9j2rFQpJczn1Tk05fXlM88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pHVaT8TQz8dmD1QqPWC68OQGLWx2LKvtpJ07OOYJY96QjG4nm1wToJCvlKkUomIrXNRKqTb01PTv+JLc+SdMJFZf/yBw9ljmfpUfsLMVzLDGWb3VB9REfwHC+hjG082RzxeqKl/zim9m1DDiYK/ExVDzf/rUdfTer7XmIkMnWjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rXmm9niJ; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SZHbwJJSzr7O4jfDtSR2lY12VAEeO5JOfRZnXomPSVP/ID0uOPHmF9SOzkT6phnJDkbq063g5HQVVcnwoSTBkzcsxYzAynm9MZGNdKcHz3kXAWoVN1Tqriq/xHIn0W1NzlAy0PV4AaQTPZoleVCI4uY0VBozghQQQbHbUpp0hdZ7f0ShPU4+T7awyYlhuYTjWo7KXoTUL2JKHN7HnO+oE8qUG2Lon/hbWwOEVE/DkVraW5oFDv1DHgEUQVs0m8KGJiEMEjLX/yJ+KRgQizFAORhpKXbhO5gbwgm4NmKDOwIr2CzBxBdcnwbibn18ZtSgdaEJ0/xR+2o3zRPVnHBT1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JPZS4zIq+8/LH5c17XBNmrdGwx+dpdfTttCxeHHoao=;
 b=TyvgIekZm2mw2n7mOgLCTvDd7m5EUwTyYE4kK4ooYlZYyZaIYgPEYsiORX2uOP5Uj3TmKM9V8clzgOnLbF+eRnHEQ7zFIMSLna/xAcBlTeb/PHHycSQzLpoWg1648amJkO1yQdPtomM6S3cpBRD+sU9JuMp/KL2P2lLdx1ri14lPH8q+19Lh8/v1ujECkyztV9GyWpuaw0GuJacPSsb7EV/fhzIXgD02q5VoCuaJoNA2dbOYP8cIkjOjreyyDrdv+7C7vEJ0R9QHZ/Dn9rpZ6Q+rsS6fYe5REkXaJx32sJjAuaOjsiP7lg++bVoTAa4zQW1uIGgHisTbZf3KjzpaOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JPZS4zIq+8/LH5c17XBNmrdGwx+dpdfTttCxeHHoao=;
 b=rXmm9niJbT/IrrWrAIuj3VXXnsgh0CkphQNQoP9/zMCDtyPFURIUMExaxn46xrbsMHzTSxUbCvB3+r6UKESgjHXDzV6DfCrbSNViJZQDGn2dmWOeLpehaaxptq4FMKsS64F1CwHSB2Cg17RD+4ZGNYyCavSDKY+mLYa2RbOmxV4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by IA1PR12MB7495.namprd12.prod.outlook.com (2603:10b6:208:419::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Thu, 29 May
 2025 21:25:29 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%3]) with mapi id 15.20.8769.025; Thu, 29 May 2025
 21:25:28 +0000
Date: Thu, 29 May 2025 16:25:15 -0500
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
	Stanislav Spassov <stanspas@amazon.de>,
	Oleg Nesterov <oleg@redhat.com>, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v8 3/6] x86/fpu: Initialize guest fpstate and FPU pseudo
 container from guest defaults
Message-ID: <aDjQu1cxLP9DiyuY@AUSJOHALLEN.amd.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <20250522151031.426788-4-chao.gao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522151031.426788-4-chao.gao@intel.com>
X-ClientProxiedBy: MW4PR04CA0179.namprd04.prod.outlook.com
 (2603:10b6:303:85::34) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|IA1PR12MB7495:EE_
X-MS-Office365-Filtering-Correlation-Id: d084b811-ad8a-4d82-22da-08dd9ef7558f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ic7e1cDcAPApRw/I5UG60d/nP1XF54vda0Zf6boZC0O/YrCRa6EoAst5p7LQ?=
 =?us-ascii?Q?MHzkOTLUuI2CwEdiCi7jau8diGyiYFaTN/xsz90VwtMJMm/cxnBFe6nkupdK?=
 =?us-ascii?Q?oz+zqIfOohsYROxPJneX0nrs9x+uxkJWPFQQfVupxt/w+gSH1Gas/763wgLE?=
 =?us-ascii?Q?tVh+KQeGl4lGyAdZ9iXrD7iIyWLAFoZ02hwMS4XfwPZpsNRGSIyLJ7HHyV+q?=
 =?us-ascii?Q?8IwfsJkieSzYeczQ11mPfcds8izo22HKABq8u2myMXTKhORSsUF9GOl45exG?=
 =?us-ascii?Q?+9IDZZgOV1+avRDPyZNFxYvAsPoRWrZ8BM8JydybtXr5/uXODdN3oHlrrout?=
 =?us-ascii?Q?3tweny3D6dhscwxRQifURPX9MN71bpZ4Y7u5TIuEeFlChUgeSex4G/5xP9LM?=
 =?us-ascii?Q?BVcsuwax7vI9let2/foZPjLb1VmqJ8sdWXl+MiuHF3gR3N7aeWprU7fvEQ6K?=
 =?us-ascii?Q?KTuBArP6H2MHqalczufID1UiMKzNcYQebOAb6c2+bVAckDSE2Ghxx3s6EcZh?=
 =?us-ascii?Q?bM4WlO8pAdDmeDx469zmmSlNuXQHrSmpZPPXV+rYK1wmWA6JZidmZQq2D+OE?=
 =?us-ascii?Q?pUHoigR64rPPp8HF3rh51p/5w3tUy/zASiAYnHpiBT9WBfEqRA953FnZNw/y?=
 =?us-ascii?Q?P3Nc58SdO7GRMRHJwQxNmJrOaIBUShPVX1WHo8XDlCGyN2z48aZUF0Rw7KBn?=
 =?us-ascii?Q?UsTqVMw09fWJT4hWgLlJqXsRy8Y4xfBSdGtG3J+WxfZYcEPyorEviLIL1r5D?=
 =?us-ascii?Q?AHWRx+pbrYnbv/POe50lpuH0NPs79dBvhO1M0VMYfjjIONwGle6OoL4rFIuc?=
 =?us-ascii?Q?81Gzg9j2cirt4W6i0kY/YRZ+1qPpbL4x3Hdt8O3GLgIQazD0QsUapo9EOabq?=
 =?us-ascii?Q?D5VUNXc4vOtFxv/hJBbbtnDmfTzkrCTFweYHCix/axSp8o0bUG1LWEcwyZkb?=
 =?us-ascii?Q?GX+nWwXoSN2KVxA2QsRfJo6vYThHYQu0pJv7kmPdyC//TdyASXerEFX5+HkY?=
 =?us-ascii?Q?5clBjtcY0Jffjo5o8cJuQjR0SFmAv6lnHSCwyF9erVcxuWgRa/NzMt8TpD5Z?=
 =?us-ascii?Q?6XjX5oVY5PfJREOqPACZlNaMooXP5O9Bow4a1OIpIgaCdNyFNrKCpK1h1h+z?=
 =?us-ascii?Q?4PmD94iyDOL12HJ/Uf7d4wSFk0wsK0ekn9pniMwYaF8iEt9HkJxz5EKA6Rar?=
 =?us-ascii?Q?H+Y320noSwiasIm5GZvlmvuQDj3m0bcdFkQ2NHCchVNd+K0m3fLN+efyyWgh?=
 =?us-ascii?Q?sa4nc36auWNBRX0bWaL6xCJ7iZSz9YXxq0KjkS7MTJir05vzP6V1WOB9GvLJ?=
 =?us-ascii?Q?iW9J4UxTtrvAY1ooGTvEcCgEcebi0e9leZaLT9X0FLdDyiKqsO96bBA+L08d?=
 =?us-ascii?Q?YpZaecksF5nBnS9d3Qu7AQ2mShQdsv2idNkmEE33eoJKlvKIG0noyXVot6j/?=
 =?us-ascii?Q?RpUnP8kgB84=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jpkZa5PF5wmZP1PUNUxMzgI1woPONlMWJCYrLLbIQG/1eFZTX4wqdjwhipdc?=
 =?us-ascii?Q?s/odrJajr03dExl8wFHc1MButV0YmdX/LZzjM8eqbPAqdIWWNhzb/2H2IrMT?=
 =?us-ascii?Q?/TAmxXBw/TGwGzMriM3cOlNCoPd4NkNFyeTT5wj1WzUQfDKs2pd9h3H7NFoI?=
 =?us-ascii?Q?Fs1eZ6YgCHW5PFSRktcArlvnTiRiIPCIXeHqJfOLuV1Jrk/+KScFjz3pktRd?=
 =?us-ascii?Q?6a8zdjm4guvVP8nmrOe756A5+xg/aadE39c7GqStbbWbwArJBsHDRN24mc6A?=
 =?us-ascii?Q?IIVcVhid6Z/T0bSil7eYWNxr4CovO4xlljG9hhp4sesWBxmZ4uyPOQIHENif?=
 =?us-ascii?Q?SVNjHGTCROhyTPGsFgc7EfOnOx3QEbUqsrWyHvj8OHvtIsYZnHo6xfhoa2Ed?=
 =?us-ascii?Q?nG7Zq8SwVx93a2YhOYwPOUTuRYWo1awX8Yi2ZVrbSRaukcbZe9EuqLRv6Esx?=
 =?us-ascii?Q?FWRZU4c5RhaDJz+35L/tSre11LjjLRmV4qZzPOPNz152Psiwpky2oI5UvhWo?=
 =?us-ascii?Q?XkVbfKD9pnQ/dBLmL1Tst2MRTedTgfhfOeQONdPoJG0VjBujQIFsxzMXGrVF?=
 =?us-ascii?Q?pVPg6ZH0hr56rxEZbMiIItNTU6boM0VIDaK+m9ZvRiXLDlSekcBtz64Ol3IL?=
 =?us-ascii?Q?Iyhy5lFy6ud34Eu+WOCQ+LHNrZwcHeAo5IB/zEDlhotuqnwJBX2A1Yheends?=
 =?us-ascii?Q?O5I2S3AXVbZwXZUdj/8ICJnaMa+DLCDqaTuX6x2JLFzO6LlyjAGglroHWycb?=
 =?us-ascii?Q?9KmwGnVzKxqVmm5o3hEvBaDeh/E+9RLwFuhBvrm5W2sQ0idxhbZVGKxCWl03?=
 =?us-ascii?Q?7+SfVlE58YMcszC8Y0o9qdX8hiAOLHi+cdZKt72gjF0rWGCZ+Flq8WEAti7n?=
 =?us-ascii?Q?pQmJaMtkVigJa0xII19TwHHkTAfjtz1A+a5yYZZHVJta5w40JSsPRZSCMZMM?=
 =?us-ascii?Q?Kp/KtK0TACXsU1XR60OfBxv3a0I/WbXxL1fmIchhU6xypVLcI48zprlpeD7o?=
 =?us-ascii?Q?uPzhtniUHx+WCjJ3KdzGAIzrQ4CTV5YotHVh0B9hVbTBFBTT6xnAfKFdjcrl?=
 =?us-ascii?Q?lfripOl5yfGp4PwgE/u8oYxSXdMsE9hk9tXGqTRGbflb4BqxyWVAOKgCEvmj?=
 =?us-ascii?Q?Zo2TT4lEqmrKsscoQXClUdQ3GmMuw1bQznrTj1EZzuo9pI3Sjb8WDraeeMs3?=
 =?us-ascii?Q?p0hZSTK5Q+G8PeLyZ+ijDc7M1NZnEhiG1etZJO9RDzVtORSCCVdh/3Z0sKeu?=
 =?us-ascii?Q?DeZZhCyiHF2LsewmBRlB75TmB1eTlptMx1opBOYDChpmRSopEuVPPLo+JRWj?=
 =?us-ascii?Q?eV41uq/sFhLA99cpON1RQj+OFiCjgr8wVnh9bDBJFxHGn2P69ao1EXT8hH0D?=
 =?us-ascii?Q?dvwdrq1OyijCOTM7T/t7xNJpmLUXH0VpZsGbhswDjwg4sQrNqEMiOOUBt2mE?=
 =?us-ascii?Q?u07GOunKevF9/BCUz90azZQx6unGEAWTtl6RxrAgwrvrHiPKczpTiN0/VC5U?=
 =?us-ascii?Q?gK3jPnp1G1f7yJR9Y4tQFhYqCaZyawf33hmByPPCMXGBWptoSCAc+30rRBfk?=
 =?us-ascii?Q?iGKOVuZ7emzJjjD5NQAt508i/+ui0V+Vy4SqCvkv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d084b811-ad8a-4d82-22da-08dd9ef7558f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 21:25:28.7532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4oARMYzz1cpv6M2788KuZe3ho4dqdYTlPqpbPUW4TgtBNliRaIplvZ4IwNPTc3Z1OhwpsI8JO594cUIi6O1HTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7495

On Thu, May 22, 2025 at 08:10:06AM -0700, Chao Gao wrote:
> fpu_alloc_guest_fpstate() currently uses host defaults to initialize guest
> fpstate and pseudo containers. Guest defaults were introduced to
> differentiate the features and sizes of host and guest FPUs. Switch to
> using guest defaults instead.
> 
> Adjust __fpstate_reset() to handle different defaults for host and guest
> FPUs. And to distinguish between the types of FPUs, move the initialization
> of indicators (is_guest and is_valloc) before the reset.
> 
> Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: John Allen <john.allen@amd.com>

