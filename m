Return-Path: <kvm+bounces-14937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3732E8A7CFC
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:21:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 490BBB2130F
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 07:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23ECF6BB21;
	Wed, 17 Apr 2024 07:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hROvTbHJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A00F6A346;
	Wed, 17 Apr 2024 07:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713338476; cv=fail; b=P6lUZHRjfRcxjb+hCb02+y4TzjlAWncv4r0s5dUJjSQsoZh9TQqTzF7ysUJGsc0cI51CHJSK/rzAvvNgF34gsLRCs34hWkIGQolI0hElef6lyP/Bb7fsMXS7GkGOyruJykQYYECJBhb+ffjqlCz4bCTpDipzyoTpyRwkFZcHNnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713338476; c=relaxed/simple;
	bh=3SrfRi1BVVohNsX4vz18OAA06+jHXQxkJx6vn1RycXs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d+8Zy/x5miA4bBpFDCSyyDaMhJkyN8/41Q3vQU5NFYqtvxv45g4HRQ04/cJR5cBNpGdm0o+m/74O1pEWKDqBJBd4ae0outcCl3ncuzZkVtdue36OURPueckyWGskxLRzUJFDEyVSyk8zRDE2iQXbmT8KOpVnsNm2gJB28y8je/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hROvTbHJ; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713338474; x=1744874474;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3SrfRi1BVVohNsX4vz18OAA06+jHXQxkJx6vn1RycXs=;
  b=hROvTbHJ8D+Hr2bf82LzrrqZLlj42KIOk7DCZeSdatL5RAqHAwSWuZKZ
   nZiZpJXNNfdeYnp6pp0+o/ccrwCKsZ7oQnO3O7CLxmxeY4Xjhu68JXLma
   SHcN6UtAf6O7Yf9AE6695evUQwmnb3fJr2i7DXbPtiPYfXbI6nXkd6Ucp
   cIjZOxJlZMxdxlSuRZ/O69n3OtzU8/awqSLhsbxdFuEEoAZh5NhoFVWDq
   A0jPohlvWXjI2GqR0E/xE574JhvHnvtawKTbpqLP3tG1+IZ+dyPEjW6lN
   wm1wQOIjpPePeU0rw1c3K0YsDFqrKkn/AFHVqm2I0iwCuC05ByDNdvVie
   g==;
X-CSE-ConnectionGUID: 1stqV6OhRJu8jZlaFUA5bw==
X-CSE-MsgGUID: FyiqOL8dT/+ShgN3BpgQOA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8640733"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="8640733"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 00:21:13 -0700
X-CSE-ConnectionGUID: +v5osR6rTquG6T5+EHa7dQ==
X-CSE-MsgGUID: 2fh5V4jAQVq9xjhXzKsxeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="27322412"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 00:21:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 00:21:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 00:21:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 00:21:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 00:21:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3oQsNqr9liH93jBCAra44BAnj5+MKTm0uD0JgCT7Vto5HtGP1qcmyFy/AHUE+d/HTQ2zB65AkhU3ryu5cN5jwIAqsmjornEmiav/DH9je0tFRO8zPPDg/eHTyiWnmajpsqDthffsrxC5EyPouSdk90crdr4ltP9Bw5ArENrEwm/adoXIqJHAA1xZBIq5GdZRn7Gy9E4GRBRjFaTCHsqgrNrVXzA/WOAYXSpgK7ng9DQLsaQgiTtAV+AN6JI61+bAIp0ZKGUNlqxZvEl7CXYKLBYQNvm3ZRN0qNODw+iy8+Mfx8Nf9PaWHKZMQofBNdBBtEYWLnoJhUUXPRHFmmKrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bp0GZwvqleMby+shf+wRuxBzHiUCIcHdl4YNc/GgJEw=;
 b=nGg8Mf0t4JbJb2klyxlhPM/1bRU4fJlO2rUW2p/R2+3nQpl6hXxfWQs3lLBJSge7lMmwc0HEdKDPl5k03CwxVp4OPcvcUpQ0VWvr0/oal+4ewrNfGgw6hwu9a017Z9Vorw/vjqzFgvPrKAMpzjNPPpqIUv+0hxAjISlzlm0zKMgK0g0Qwg9Eg19p+S+DlZnNxrKbj51MrTJRHdJ7KziifjaHauhAKtOAiTatSSzZPaQjJS3hNpZhJ9kl0vK5bPU9WX+sg7Bcv94J9Qwaqcf9HovEFMqi4kVrUHlmxLbtX/TfhS5168inIDX29jnZKibb6f7wn38JDNDekmoBweP2RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ1PR11MB6252.namprd11.prod.outlook.com (2603:10b6:a03:457::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.27; Wed, 17 Apr
 2024 07:21:05 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 07:21:03 +0000
Date: Wed, 17 Apr 2024 15:20:55 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <isaku.yamahata@gmail.com>,
	<linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>, Federico Parola
	<federico.parola@polito.it>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 06/10] KVM: x86: Implement kvm_arch_vcpu_map_memory()
Message-ID: <Zh94V8ochIXEkO17@chao-email>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <7138a3bc00ea8d3cbe0e59df15f8c22027005b59.1712785629.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7138a3bc00ea8d3cbe0e59df15f8c22027005b59.1712785629.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR01CA0169.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::25) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ1PR11MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: c5523c82-2afa-4219-aab9-08dc5eaef048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrmUZo4kIJuDulZxK5crlrzIh8lTfk8I7PE+7/Ji6F1EW7bAs0WTAr6YrH7qAx03EYoMSg+H/34EisuHoqOiXEhgDWQsvqKae22ypvqCYGw+OnhufwqD1B2zIEtD+NOY2J+mvVCu4fZ/A03RndX7dhi4tuPBBl7X+d6kML8tIFLlntwJbh+Jn2IJeR4L0j3MYbOfVJc4Z+WjaXt3BqBFG3W7Bf9SS0JVIZLBGSTZMAzpK00GkHrMCX7yYmMqpS2Eb0QiUr+i+bw202pIMVwlMZi7rkWlFsAHCAN3IgPnvueK/uKy/+u06ads0pD1I/fJ1rjqN8PoDL2EzdxsL4KearX7rtOZrwLCuNFVOh1PgncOhUkJIkHylrTl13ZRhm/sw85cjIj4lvesjqfws/YM2yrspvwTQd7blZJc4DWTTOYRLpJp1PoB09HZFhGBHEUbGLc47NZKT1uRKBsyrDvlFcMPsVeN2W4SDBJrR5MsX/NRQpHg4LmKvfWZWDt1Ai6a0BWtU5FFd2ucXz7QAZky3CsAec2F9WwlJiI1VStGZmYlkCfdH12Uk9fykTCCO1RPiRfwGL32JNTJjhzuCUgdOPJWgRhRRNTxBFLpoYYin5EBZ/GnQ5sS6p6ggq1DzJWH/C0bLV8BB7Ea1TH5VQfm7B7IsIJn+lCsDYTnWhH9vBI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/7Namb08ywM8l3GLlMuNcYPbBipqBZ6k/We6OhgcTq1EmV3NhIbnN7aCE3NB?=
 =?us-ascii?Q?IAdHa1RoygE654NiYlJ77VwXFcv/P4Q96vOth9b0hVaD7cmnFJmikYAlJBII?=
 =?us-ascii?Q?C1UoClk930N8MjYDR0Aho9ZkNm2ZZyqFlBCXTkCHHKTQ3LDOo3ugQOfua+28?=
 =?us-ascii?Q?Tg4TVvna1cwpqX1Aaz92S9gSw3fkKCYaDaAu5q1Sb9Di8enOUnyIcoiItplw?=
 =?us-ascii?Q?laE6o3qFegP5gecqMxJ56NAOJH9c11wbPkIrIYsYjD7DlLOuFWa0IPDqxLgG?=
 =?us-ascii?Q?SBnKSQ5XiX1zJTN7SnepKmNEowGZLol9zCQM4+Fb5l8dznDoZ5s70FqJb43b?=
 =?us-ascii?Q?klFYzFOR/8mHfrHebCQrTKEylBddJi+b0eoQbPc+bOfH5RK3RkLah7PwDvTo?=
 =?us-ascii?Q?Dya0evNjRn5N7oPluOtLg3bW1uzjnbUg1RxswVn+slBGBO6HWQXbTe637Dak?=
 =?us-ascii?Q?ogAoDYlqk7AfW1Ej3gyKqNUr7eiruq8IzKkT/c1H49cQYf4ITWJPuDwGmhhP?=
 =?us-ascii?Q?Jgq3rJ7NBSYxIveuXd6g1B7j5Ol6B51nCMc024wsKg4AKhgTO+ctHdm8HJ7d?=
 =?us-ascii?Q?v4Jgh8MnGsqJ46pcB9glzJfQ8blBQ9Fu9rdupO0nyo91NOg5Re5Oxx8C9PZ8?=
 =?us-ascii?Q?oDkk2QR/7uosjHhIPQ88QcIhgiUJPqU+/yuFaNStTjtVGn216vNfZUmzRCeo?=
 =?us-ascii?Q?WNIm4KOOAuaoxCp2sVhaskpCdO+XSbL8JW2JTfYElfevb95V85NqiZXv5LXv?=
 =?us-ascii?Q?hK8WZ6K7C/4pM8Fk85TMBaFQQF0vGufXSaTOob3CdE9boK6oRFYiKDxGLMV7?=
 =?us-ascii?Q?tAsyoV4hWeyiuhycRakNVClFAed/4etK5/ldAkNo+exDcw2TaoCPquIyIl37?=
 =?us-ascii?Q?Q5xkBvAze8i8EzFXU/eSukxZQTcRqa+UM9B7+HPEfROBpKXX7ME1/uecFh2G?=
 =?us-ascii?Q?2MS+cKncbyQlSA9yh0Qx34xVai0wGDqt/zAfnSGUBxwucQN9zocxPXuW9KRv?=
 =?us-ascii?Q?N/JCj+tdw/8AAnSWfGuE3D1cjYdT2BuTDP8tVzCNBcniKckZoNlnOK2D4N37?=
 =?us-ascii?Q?D/XVbYVzvTOzsqW/ePHy6huU9pHWTRf0IneMh2r7Q5XOCt8dPsmkdoFANPsF?=
 =?us-ascii?Q?vHfJ+5c0lUieFkTAfsLJ7r7QKB5L6Q1pM4YKLE2n2O2islJnu3S9+H9ly13+?=
 =?us-ascii?Q?uSZX3N1N36MvOZYOHb9rcEApwBg6cfRRhalJiL2vEfz9iXoixf7BbdYxTRNl?=
 =?us-ascii?Q?5VfdTVIDO6UrwhNS4jSkCbNuaUpChMjvmhvNNvsnrAfe7fUIbZvaMWxZOncP?=
 =?us-ascii?Q?kDCLK8F9i5WPcLIVEFGHf4hLR65/nVbr6pbJlPOH1NBX8fbcQSfXb3RPBON/?=
 =?us-ascii?Q?bF8D5bAd9cMae8/n8XiVir+kjh0rxa3+iDSDOQEI5AkZvjtlJ47JkbxL6o8j?=
 =?us-ascii?Q?jbvY7I0EzEa458JIHF9rvqCtO0KHC1nWw0sEEMLjAlLweVhB3ImXZ6MAxree?=
 =?us-ascii?Q?w+yQVCPB3Z6AOVX3QGS1aLuN24xqq4ARd/43SjPGpHHEEvnw2n731vJyipjv?=
 =?us-ascii?Q?gBnfYizHiR/4hAk/X181XOGz6hOdOHCCWBIIO9Oj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c5523c82-2afa-4219-aab9-08dc5eaef048
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 07:21:03.1926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u9oltCk+nf6XykpcJO6LodViVK0ui3TBOT9SHJE8/Gmgwvt5Z8xjwnqB+WR7xn7D2ucyK5p4rDFVw7iJKzp34Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6252
X-OriginatorOrg: intel.com

On Wed, Apr 10, 2024 at 03:07:32PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Wire KVM_MAP_MEMORY ioctl to kvm_mmu_map_tdp_page() to populate guest
>memory.  When KVM_CREATE_VCPU creates vCPU, it initializes the x86
>KVM MMU part by kvm_mmu_create() and kvm_init_mmu().  vCPU is ready to
>invoke the KVM page fault handler.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
>v2:
>- Catch up the change of struct kvm_memory_mapping. (Sean)
>- Removed mapping level check. Push it down into vendor code. (David, Sean)
>- Rename goal_level to level. (Sean)
>- Drop kvm_arch_pre_vcpu_map_memory(), directly call kvm_mmu_reload().
>  (David, Sean)
>- Fixed the update of mapping.
>---
> arch/x86/kvm/x86.c | 30 ++++++++++++++++++++++++++++++
> 1 file changed, 30 insertions(+)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 2d2619d3eee4..2c765de3531e 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -4713,6 +4713,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> 	case KVM_CAP_IRQFD_RESAMPLE:
> 	case KVM_CAP_MEMORY_FAULT_INFO:
>+	case KVM_CAP_MAP_MEMORY:
> 		r = 1;
> 		break;
> 	case KVM_CAP_EXIT_HYPERCALL:
>@@ -5867,6 +5868,35 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
> 	}
> }
> 
>+int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
>+			     struct kvm_memory_mapping *mapping)
>+{
>+	u64 end, error_code = 0;
>+	u8 level = PG_LEVEL_4K;

IIUC, no need to initialize @level here.

>+	int r;
>+
>+	/*
>+	 * Shadow paging uses GVA for kvm page fault.  The first implementation
>+	 * supports GPA only to avoid confusion.
>+	 */
>+	if (!tdp_enabled)
>+		return -EOPNOTSUPP;

This check duplicates the one for vcpu->arch.mmu->page_fault() in patch 5.

>+
>+	/* reload is optimized for repeated call. */
>+	kvm_mmu_reload(vcpu);
>+
>+	r = kvm_tdp_map_page(vcpu, mapping->base_address, error_code, &level);
>+	if (r)
>+		return r;
>+
>+	/* mapping->base_address is not necessarily aligned to level-hugepage. */
>+	end = (mapping->base_address & KVM_HPAGE_MASK(level)) +
>+		KVM_HPAGE_SIZE(level);

maybe
	end = ALIGN(mapping->base_address, KVM_HPAGE_SIZE(level));

>+	mapping->size -= end - mapping->base_address;
>+	mapping->base_address = end;
>+	return r;
>+}
>+
> long kvm_arch_vcpu_ioctl(struct file *filp,
> 			 unsigned int ioctl, unsigned long arg)
> {
>-- 
>2.43.2
>
>

