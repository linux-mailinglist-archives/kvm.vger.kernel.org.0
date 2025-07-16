Return-Path: <kvm+bounces-52664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F72EB07F06
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C7943A8B15
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 20:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607CA2D0C7C;
	Wed, 16 Jul 2025 20:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hr61oscl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0BA265621;
	Wed, 16 Jul 2025 20:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752698201; cv=fail; b=jtqj7XzOGzhrJeTu5B1aRW/4AZvCPrHTdnL+3mcb8dJXgnqZCW1jM31X1cq5Juycwf0cL5vj3+CcbROwoDAo8OkFJ0GCsgqaNBp16qGZiCxN4lvnbJWpJRoNf2+EE3l7tq6PGxW8IGV5hs/ETANz2MSDDAv9xIsPLruekLNtk24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752698201; c=relaxed/simple;
	bh=43unX/+l28VMNA74Q9pXj61oUbV7vMoLHVMP2txc2jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OIFLF17/TAnSh1BvhLFpSVL5LWbDhH4eEym+9XNcqJ6bBlRmVFryrTxe4s5cswBmgNbwkqGJfAT7hLRIxfA1/rEbj+1OhAgz0ekPYSmJQ8xlFld5JsoZrdU1HBj17S1f0jGlh61T/KBJY+GHSHEFLTl6bZtSqj3b7+UkfLm4SVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hr61oscl; arc=fail smtp.client-ip=40.107.102.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EB8ZZW0CT8YeyEc9lkjEkIhSsJ05zzsg5cDJ6x77pQwduQVRR034/hw/ApEIrcWWBUj6koBqXgHUeqO2xer+w2X1RyIX7fDymv2DpWv/bset+jOx6Z/SAyInsgA+EEjE3FtRKF3SP6/6dKcKNMkNidd40t9Y0+iOfbWcEPxKhu5a5c9i3DYfuC/z4jI4yyG1ZSkGStJcyptN43ILWwYdXLGU7Rx4Ab30lqpmeNEntPaZh/U7d7bmlHfGAsooPl36uMArAjD4NzpxkVk96AfSYN3DsdvvF9gUGwUJzVvbUrC69vUlIUe57+BOZAIbPfhZN/bG/0at79CoM5cEeJ7HcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZ/JRUTsbbcU1D+4Tcf3a3VulJ43JRsFksq9BiLmg4U=;
 b=dORjjT3j8SD8VWazHqIye8iy96hyvq9vUUjoEsGthPZZyZ6CCOMiwjuddkkdsJfR+so8yU8qv5/MuCrPwSuPufkQwzHAiUh9uFgf2OQnxn1uJWgItBorRTZzIdUlPA+oC6G9TXmy9rtTxDb1KaDU+w0dqYP+q3NaxMFolnWvL9ynEEq4m9x/bQCQoVpU5u9Jt/Th/Y9DsjxWjcekTQw1kK8bcq8Eyc4BR6LMOcLKzxmueQ/0pDS9P3dV6AvNppidg2wc0YgfAScaQaMdZ2gk+GGRD8xfcHKa5FHz/Wx6atpr4auLcmZk3ISwQKIEoTy1AhNdZeiNUr1SmnmRime0lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZ/JRUTsbbcU1D+4Tcf3a3VulJ43JRsFksq9BiLmg4U=;
 b=Hr61oscl5+69BxhfjXjg/4QtQyblKd5oA7u99KLNmLXa2ILUY72Qr5DSYkBCymEESG2nCsKWtX1hvAXQMPQBHRrsCRBum3DenRq3m/qzoVzkJEmWeJXVOz91zFgSD1zptfGOAPW6miMl2qB9KlKb/g1FvITGdn7PWkcwQ6tWork=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BL3PR12MB6476.namprd12.prod.outlook.com (2603:10b6:208:3bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 20:36:30 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%3]) with mapi id 15.20.8880.026; Wed, 16 Jul 2025
 20:36:30 +0000
Date: Wed, 16 Jul 2025 15:36:24 -0500
From: John Allen <john.allen@amd.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
	pbonzini@redhat.com, dave.hansen@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
	weijiang.yang@intel.com, minipli@grsecurity.net, xin@zytor.com,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 00/23] Enable CET Virtualization
Message-ID: <aHgNSC4D2+Kb3Qyv@AUSJOHALLEN.amd.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <88443d81-78ac-45ad-b359-b328b9db5829@intel.com>
 <aGsjtapc5igIjng+@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGsjtapc5igIjng+@intel.com>
X-ClientProxiedBy: SJ0PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::8) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|BL3PR12MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: ac1268a9-29ee-4a51-afb7-08ddc4a871e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mUEvQ5lM3KX+8T9vLFUbZsrYZvHkjVgiiJ2JvMY4gEik2YLQG2CU5yFCBWJf?=
 =?us-ascii?Q?rI9rwxya6WJgq7x2U25aR4LfZnHmURlmf59Y3u9L7dcktX1Abnih4xsB9Htx?=
 =?us-ascii?Q?MScqKmW3IcEBHAyoXI7mY7cS8eC4zY9NUzupdzxn5TiX8LQq6cmrXWirPLJG?=
 =?us-ascii?Q?ItbgBNM+1gBCpL0fuMTyRH5ugtsnbnbFfOqyoFFlNrZnSXe9Z9IzgE75iCk1?=
 =?us-ascii?Q?MWZ+NFXX9v1ipFcTR8pzx0TemNySzZE3Ns2Fh4IGg22arbziDTjqgUXiWrTi?=
 =?us-ascii?Q?QMCOvWVuKjPLaLUvYf5adtCpBEagxonHb2cc51UeE5LKC5OBp1yAkgSk4l45?=
 =?us-ascii?Q?p82vZy8eS0l7Ij9WStZBMM/uRKwydNR5YhuvO9BIQRRiv7CNSIC2Rr5tfuKW?=
 =?us-ascii?Q?JQb8IkmHTBuawdOcaBeLeiI6u/Mp5Xpp/tnUDtnxJqDYCb8NhFecyN33YHib?=
 =?us-ascii?Q?zaIzLNLCskmT2qbEXt4RVc67XSIxlt+UtvFVSWFe6sDrXtG9N6qjCJQR6hOd?=
 =?us-ascii?Q?kHMgpt6kYKhGxIfWCoRI+PqCxfwoNn5jJAMj+HcOdZ41RenaFGjq4gi84l6N?=
 =?us-ascii?Q?KpUszKDmvquJWDQ3E2iV+vrtjp1nwO7GDUbDMDPVA2QymVCiC7GTZPpYe+Zf?=
 =?us-ascii?Q?xmoNVNnPeh3Ka5LIrQzUMrQB0zyIJVc22ifhS/apZ7S5Qh5DGgmR9CiWWutD?=
 =?us-ascii?Q?NGqd4srr5fS1O4K0D3Z/l03AtuxeL7yzrdCaAhMY3htWh8j6u8SCsOudFRJr?=
 =?us-ascii?Q?TyfZSC+BiLlctI/Nc8b8lzsW67o/Ko9QLbgEgmJ56jXoBKktaGVVBjLujhZQ?=
 =?us-ascii?Q?KTjXJeCXRuypbsJXhLrs+akk9/D9usXkVhhLgbZRWvhUEYZyfJevHIJDBkvW?=
 =?us-ascii?Q?Lcn9SW6gBRaIsyHE7t2t2eE0fm4a5TThXfWHuj6a2r1rrbz59jqlUGhTQFNE?=
 =?us-ascii?Q?3Y8NbQNvxBuxXsLOhUIYHevV5rQDCNlplO0aZqbKck5uKomyFQrrmlPhpk7U?=
 =?us-ascii?Q?yWPVOmMPbtH9DY5/+JSzmlOJnie2bwp0qvhkRv7uQ9lVCebw0a1tvedUQkI1?=
 =?us-ascii?Q?8G9Dq/FSNMmjKPvxTSov1zNkBJrwCNgQchbHKgxMOdAT+r5T9IOoqlCsht+e?=
 =?us-ascii?Q?FNl+Cza2uZsnmsH99tSSr2q3Oy9WIuq3o2ctAU2IQwf8LKVV5muYOEYJ6w8p?=
 =?us-ascii?Q?oz/sQlaWjYlrUg7r5Smjj6AP1kbEbgxyNqIXrgzAYwkW9/gOMaHcVwErnsTA?=
 =?us-ascii?Q?H2+QVGo5CEpf5I6aitcCNr99SYyheH5SRAk4RCizjHS+PMJYaY8/Ki628NUo?=
 =?us-ascii?Q?xiUEAqvnGfgQv2/mMJ1ZMmWONmsEImC4WFWPmtBqv481SV3lSqzWTDxHfy6a?=
 =?us-ascii?Q?Kvls9DRey+ZTPzy21VxcdJDtXbmpUACOc8A6dVBx92nJQUvwg+Q10KOJtvvI?=
 =?us-ascii?Q?DX+F5881+Fs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WPjlXbqZZK7jKd5OqS1BeeokAc6/DOe1QUy1mnI7IEabPWcm8Bu3ABWrEWT5?=
 =?us-ascii?Q?Yr8A0TwcMXsSanQg4bB+zKA+pQdd+5RzF+Zz64V93nOi+LMI43LOxE7uuvip?=
 =?us-ascii?Q?9sKaaa5nzzLG+OK4qT+vmduBdpyzCxZy2F6H75/fPGl6aIJKIBE5/XOyJV0B?=
 =?us-ascii?Q?H0g/tzznC2QSsKwDzc33rMA9HZ5SE3uvx/d0Sxrfi49y1xywBEM1la7rttik?=
 =?us-ascii?Q?9udFdF94nHCMyxN2EVu3CsyjbsswwaRuw3jwmDDfxtubNA28kpGkN6Bb4hIt?=
 =?us-ascii?Q?M0lQSMm96leknezI0uNSjhHdZeV+H1X+tkZLDA7dYoj9hfh1eRlFYSvz4TLo?=
 =?us-ascii?Q?ZLuepWYRmGbKNwjkb5PVQUoExow41F1YGq10JpTQXHWq2mhhhH9idJO5HxR3?=
 =?us-ascii?Q?E+e0NuGUDCivIGsxX2n/PWLgI7OiSzfITr8z5oz/0ATFu+ht1Pl3ZYLcpyei?=
 =?us-ascii?Q?4S4E/Gk9dkT2UuP5wA83jZBjzSddQyqkY6+Rs4DxfWw4dJqzpNRjtKweH08i?=
 =?us-ascii?Q?d2k07rM+sWoMnUUXeQZT4azMBAm8scfxV02uX2ZrbnktELyFyI3eFYp+zZr7?=
 =?us-ascii?Q?jQA/0fiSrfvq/kEjtlT2vSI4HdWRrKwvOgI6cZdSURrM4JmGTIgC2/44jk1b?=
 =?us-ascii?Q?vsQtW6XwjX/icAfj4sIy2Cqse7Q4zINxrz5m8ckp+VRvE6QrsqxhsgFLqXR9?=
 =?us-ascii?Q?3GnJFmMZUYO7v+365pP+OKz9snA0yQzwemfr4cbdPjJFEUDreR+RwVg7iKBx?=
 =?us-ascii?Q?9VKebKVVOur5F/7MdkPwAaPOI/RcbEPhblQqupBRtac90Frx2i1Yw7qXVGeH?=
 =?us-ascii?Q?A7YQNpa1Ucg1eR4FdTuHCX7dYOz4ZfsaIa3RKNoSgXp6piAsYbVEul/oeteK?=
 =?us-ascii?Q?CBmiZA1Qt+Dg+wawJ84MhuAHMAXhTQEuNUCNunsxZyD/Tzol7ANDsK33FcOA?=
 =?us-ascii?Q?xxsEYrYItGnt+xUiyGuctbWp6ZRUGQfpO56eZefWeLlgqnQDtbPCxjf++yMh?=
 =?us-ascii?Q?foSSCP0Z79cl910x1DdlhrwiT+04DJ6+mb5ZCYPXmJHTfZGCTkWKuEbNw2gy?=
 =?us-ascii?Q?NbbAJ9nrrtxk+DQ03KY72bYJeIEimzUdm+D9SuH7ZDn3/Ub5bZJn2PNWhf0L?=
 =?us-ascii?Q?Ux6SAO1m5vYaalrMYKFuXLcs7Z9ncdAhNNWin42Ixxgolvkjuepi4/8bZqub?=
 =?us-ascii?Q?tVJlgO/wckVVLkwZbkjmghXQ/3HJDkBHM4bh8btyKFl1cwv4Y9+zTDhMso/6?=
 =?us-ascii?Q?FAHowFP8yCmNBtlOYbdDdscKoFWRqN117rqWXDjY40ZfTk5sMl0qG2XyMhTF?=
 =?us-ascii?Q?Kf6hkuPNX7UYOD8QxOAM1i8zE4wmx9YDa0y+Qf/GI6GDOe1U6GSoHiBlvJQ4?=
 =?us-ascii?Q?Y7faLTEIQYbKiG/d9DrDRW90pWXuzGfHOFGmxooQVv6mY2bQxKClZseps4LT?=
 =?us-ascii?Q?AhhjiSybWJJdFfmotpr13Sx+gFaDktmZDi851DqHpMpucJn5G8aI+RY0zMFg?=
 =?us-ascii?Q?SiwVVWTrqfCx63RUKy9dpILRtAyaSWgvgXfRebOC7lWBimbAqL0o/8PsfNIy?=
 =?us-ascii?Q?w52GmVrVxVjpO5uMSeo3Xirysd9Ryksvd+W0CXDo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1268a9-29ee-4a51-afb7-08ddc4a871e2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 20:36:30.3840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HL5VmQCprnwlG8DjdTWJZCaKqwXGS27WuuFjwJvrRwsvnMZ2v/TNENWXtcG432GeMCND3lXTM9kUbL0ljMhVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6476

On Mon, Jul 07, 2025 at 09:32:37AM +0800, Chao Gao wrote:
> On Mon, Jul 07, 2025 at 12:51:14AM +0800, Xiaoyao Li wrote:
> >Hi Chao,
> >
> >On 7/4/2025 4:49 PM, Chao Gao wrote:
> >> Tests:
> >> ======================
> >> This series passed basic CET user shadow stack test and kernel IBT test in L1
> >> and L2 guest.
> >> The patch series_has_ impact to existing vmx test cases in KVM-unit-tests,the
> >> failures have been fixed here[1].
> >> One new selftest app[2] is introduced for testing CET MSRs accessibilities.
> >> 
> >> Note, this series hasn't been tested on AMD platform yet.
> >> 
> >> To run user SHSTK test and kernel IBT test in guest, an CET capable platform
> >> is required, e.g., Sapphire Rapids server, and follow below steps to build
> >> the binaries:
> >> 
> >> 1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.
> >> 
> >> 2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
> >> and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
> >> (>= 8.5.0).
> >> 
> >> 3. Apply CET QEMU patches[3] before build mainline QEMU.
> >
> >You forgot to provide the links of [1][2][3].
> 
> Oops, thanks for catching this.
> 
> Here are the links:
> 
> [1]: KVM-unit-tests fixup:
> https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
> [2]: Selftest for CET MSRs:
> https://lore.kernel.org/all/20230914064201.85605-1-weijiang.yang@intel.com/
> [3]: QEMU patch:
> https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
> 
> Please note that [1] has already been merged. And [3] is an older version of
> CET for QEMU; I plan to post a new version for QEMU after the KVM series is
> merged.

Do you happen to have a branch with the in-progress qemu patches you are
testing with? I'm working on testing on AMD and I'm having issues
getting this old version of the series to work properly.

Thanks,
John


