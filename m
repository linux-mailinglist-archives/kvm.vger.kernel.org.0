Return-Path: <kvm+bounces-12559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3505889F2B
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D6EC2C74D9
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 12:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464EA13CAA2;
	Mon, 25 Mar 2024 07:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nIVwsZoO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (unknown [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E321869F8;
	Mon, 25 Mar 2024 03:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711338199; cv=fail; b=lFIe0YuVH0sYZ+sVZlw0l6CmlmRdCC5OF5cQpfSrlTdEowTKV5BPfVBksppKP6qY1hUca22yNsKsXmMoR2PxYgZr21ssJGaLFteI6Az7HeBGk2rF1Or0k/AIiCRR9uMX7ZxY1iMEG3J5kUc9tbTkVKpJNiNl5ZzA3dCMoifjUv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711338199; c=relaxed/simple;
	bh=KD+1rhmtJ8CbjWCoAulOhc3OKGlNiPR6REZvKYP+F8w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UIsY/QWbLLWAtYTx7Nr7uQq4t4NlgKo12xobgWesC2aKXdxsdjoYyf48JxKbDIbBIZuefvlg79M9SrhAVxiiSKn4Wu5m8iDXoOufdv/ZnaFJSnotL3yRQqsWmylj4aXLCXP83m2E3xABicsyWjArRAU+DpnnMhT3Nrq9L6vIEwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nIVwsZoO; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711338197; x=1742874197;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KD+1rhmtJ8CbjWCoAulOhc3OKGlNiPR6REZvKYP+F8w=;
  b=nIVwsZoOvHVB9tinzH3tFZoYIfIs2gLRsel8b4pREBrpqREJSpoSvH9H
   szBFZNssthLMMGA7J5e5IYpECHLG4vbpQifV7Hf1zLvCMF8TN2/F2Zlfp
   JGoDTsnZa5XozsD91s4n1Npww6fR8YcU8ck+FvEVNkD27qMaEHxWSV3Yb
   xa0y4tYfNfoZjTcJ8dJVQPHMxYc767HBVKPsfsQeFNCeYQjcqd6sgqUnH
   Otf/msM4DinLkb8bAU0qDcD2YOHespUuPpI/c+PqCIMprTKM3/tG/fhsg
   oL9MT8iJxpGbz/ONKV9CSF8U0j8hPGwUqhw1D7JqWAwgUm8I6bxoIVMdr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="6178067"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="6178067"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2024 20:43:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="19956288"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Mar 2024 20:43:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 24 Mar 2024 20:43:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 24 Mar 2024 20:43:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 24 Mar 2024 20:43:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 24 Mar 2024 20:43:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkYFiddGNSUb2Lcpyt37qO5IwEg7cpET2pMgy/qXdbPRhs4YaWhoVMbgiiOoVRZ1s/TqqRKQrnOnGE8fzUao4G4c7EtwTjIsFl8kEY8Vn6CZASb67uhFOMLX0BtG4SZrj5o6yeRWnxx4LqX1vQG/NMHF4lHG3TwdBxKnUTieoUgkPh+v+bTPhuoncWNwM0cuoAjtHQhJFfM16+2E6KO41ZJZbo+qqvnusykD4OyKaRUMATMb0yDQpI2cphhnKdBedu5LB8xcD6f832ob0FwmLwNlfiA/Szpt7yXRQ+GID1GzvB4pMwOIBAC3rNIDjsCVZDcHUsqAaZwLBZotYY6cSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7eVopWnZop7J2ipHqvkeP5BTxyWAlrJMYCvixfd/Bg=;
 b=knVI6oS30FaQF97jcGDuWUv9UfmS2kCHF0RG+NjkS3OPVB1YTKA4quaIj9tq4n8+x0DxcIHSRKNq1MjjnCvEscut9Q/0uPB6LLCVcGp9g2d5YX989/3QL2ZzOdtfX3hYzw6CxcJDQF92qAuGKYEMR9nEwiYgpCMpSqJ8NgBFZkeMO1UlT9LhvhvhFzQ+lw9bOO/xY7esn+Uhc5yelPJRYoQ8kPuC7BqA5OxUpOz0UXlwagQLpJmfnK0fvPVBtzypM71O2jAfpqec4ZFNIv14Yj5XpptHN6YG8v9Wl4Jw8HS+deUrRlXPXRD3V9HLDyQ1j3GeW7iFkIlHAJmg86Y1tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 03:43:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 03:43:12 +0000
Date: Mon, 25 Mar 2024 11:43:02 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, <kvm@vger.kernel.org>,
	<rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kevin Tian
	<kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, Yiwei Zhang
	<zzyiwei@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <ZgDyxpaf+HgQzYDp@chao-email>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240309010929.1403984-6-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB4952:EE_
X-MS-Office365-Filtering-Correlation-Id: 8887c484-a786-44bd-8e81-08dc4c7db20d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c+otK+3ouOH9Avqee83nntXnwBSk3ALYH/TXfleGuXA8/oVMOPi4156iXsoY9qYJGYsjE2euozeElsL4b06fnBvuTe/ZfZiPITISVR9PTGUCXdPASMiyQ8rblDSp/esQL3c80Q8BaYj/HsH/bC2DRK5wJWMy0Dx2vsxIS5J1/TJ+uFGtuYsYgkWPB8NQhGYvT13ZdDLpi2uSBTefwoR9OKzhrS1/q3RR/54TgYp7vX5+2gaFBkP7UvVDOYzW62t/4ErjZrv+cqIg3Uu8mmvqaPtz4rSukZJLf829YgDIq8HXjkSm2CngWXyeLxxlfihPdoe4xZOCCDAeXNLH0YxJ/+eS3232dPqXQamb7sU2K3EFqUByzkkiTwX43nwG15jMIXzBMp2OtHhOGHzWlYjFuuNYUecK2p2efqoHQAw8DarwETdp3pjzJdcNAUa0lhXw5lveCG/RZfHZALRG1BsR/z/IuxJmFd4mKVR0UZ2DlYEBpLhk2eAWGNAPq57Zu4Bj5woLyZgqE1X/PFE8FCmmjUxYwFDba7abFFeFgwNskw9TB88OCFw6T/ohDOhi7ioO0O7Fgk77lOUqCKh98Jnv36LB8zgOsgnDiWp7IQ/d+3TB8RCCDF8IuAkEyopS8aTYuY7nAFR3t0L9JCPhL559leswt0vAiFxl9GU6OavVFQ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gz0u3SZD2Rlu8Wxa89MQDGdxS+wRXkddxMvli4Q7QTG6rY9SAhFiwObNvaJ0?=
 =?us-ascii?Q?rcKjS1GEVU8VxxtNiGfpch5AmlP4Jz57Lbeh3MQq4qgGDhzi4UHxQAkUcQTC?=
 =?us-ascii?Q?HxhfNuWc8uvcGm+p/5ZSyf8sSDEh/JWB5OfpmfuNfUwaBpuUYss3N6qHqxB1?=
 =?us-ascii?Q?gL7353uuhS0Zj4Z8zOQ7ly7+nYu0hnd4oAvHbxK55x1HN0iVfhGMIARulNQp?=
 =?us-ascii?Q?0Lpwk3s1fG2TE0839zZhedFqvQRICuL7sHVUZawXmuaPLyfFITv3d1hglxLZ?=
 =?us-ascii?Q?WMMEerlhOEQcERRA2lPKE8bAkDEQ4ZdnKde/Ktp4S2i3tQkhXMsLTEYI4Fw/?=
 =?us-ascii?Q?4Sh/vHu9l3ra2OAJH09Fga4t23lkesOa6Gn0RL1J2XWXDnVnj7SOvuAKRshH?=
 =?us-ascii?Q?yPbFFAW6P0+lRSKCj7Y+8pbm3Qi19H0zxZAC7mxRZKD1Nexb8j/ZRFYdWqWB?=
 =?us-ascii?Q?LroviPbcLZaV1MiSABDxR51IatK2EiacMRPkUWeCPMK5u8tEZHF4h+YeugEg?=
 =?us-ascii?Q?90NTnpBDyjvd1yfEeS3NKD0oW1lnKZ81npdBYyV7612pN5hISlSgvZ+s8Jqx?=
 =?us-ascii?Q?ycwdsovBoGi/0fHtXra+6fw9C9sPuZ8TjA7NFomnst5Nbd1gLIb+O7qbSMOA?=
 =?us-ascii?Q?Q1KyFijk8s+2QF+ohzpPYA6OxEAKANLdc+ehws7WJypIk/5gfHrS+K/OXo4Q?=
 =?us-ascii?Q?4uTxtAnnngMhM6UQu1+kkPvPEI3BLnhKmg7m/M6cmgLerh8WXCB9oktnHkIK?=
 =?us-ascii?Q?HcAnwH41BavTye3pFy5tsBIySLui2l/XE1za1C/omkGyG6W+C3+W5Duv4+9+?=
 =?us-ascii?Q?UE6wZW4AO779z39goXfmwBTtEXz4FFJFBnhpZaMzebaRd45c/vDZcFmMtoSh?=
 =?us-ascii?Q?03iZMvgzDWneX9795o8LRlBtKBTqeiF0P+q1BZA1qsaI4Nk2QVu2iu6PaJPr?=
 =?us-ascii?Q?VJTGKRCrzaWB1ymWoim8999nX7SDODXxoRFq2xxlYKmUk6RbtKHDVZ6F8l8s?=
 =?us-ascii?Q?RPzE3tBK8jM8gawbZjeikdenB4rQLk3PnmeR3bnpOwVJ9OOC2AmWc4H8Z2Z8?=
 =?us-ascii?Q?ofn7HN5/X1EFygdwfFrZh2eR0zIkVqGyKeHo9TkbtNtW8XZnjWuKePV6BHhJ?=
 =?us-ascii?Q?LLq4q7KGUwCA7bpmOKgCp6kP5CioEKDebmnY/PH4wTfHmr0kbTvvekzyVu/k?=
 =?us-ascii?Q?tEd0751BTpXD2xUU2GF/Qb+rMt/J0cu+/c01ZqoDClpp5Pu3ItRWAnGKQ5ml?=
 =?us-ascii?Q?V3N1bEuLtR4CytEw+ZbjHBzdJiq6VcphCjD318KXo2K/o+zoQB24IVcAL100?=
 =?us-ascii?Q?wgM9VfdmldqYO1uhEWCD2MVJwpPVbveJYRmaFanxtzYSBdF6aFdzJa6EJTvj?=
 =?us-ascii?Q?oONEkjrcdsGVZww9uTTyhd0OMkCwqOuEn/cmNid0g5lMr05OlKXUB2D7dD6g?=
 =?us-ascii?Q?C78sCcGUJDNUAe4VuijHZqkrpHINQt1oMFRs/YCCIMSv9MWBSdsMkZ9AuGsU?=
 =?us-ascii?Q?K6avV5beeBzKnqyJdFdoajMFfZ1wDlOjpPtObTl9/LEQ28v1e24neVq+touJ?=
 =?us-ascii?Q?GCgwAOVPDgUEs9Tqp+EcSFozsLQ0XSnbYfuxPapC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8887c484-a786-44bd-8e81-08dc4c7db20d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 03:43:12.5904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wPtm/QKXjXiuaXaSmnulV/9A1qMOO6Lu3WKohjc4xpd9zPnh6SixIjWj9FzcjxjeUGQaY1bSI2xqDvDJn+SqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4952
X-OriginatorOrg: intel.com

On Fri, Mar 08, 2024 at 05:09:29PM -0800, Sean Christopherson wrote:
>Unconditionally honor guest PAT on CPUs that support self-snoop, as
>Intel has confirmed that CPUs that support self-snoop always snoop caches
>and store buffers.  I.e. CPUs with self-snoop maintain cache coherency
>even in the presence of aliased memtypes, thus there is no need to trust
>the guest behaves and only honor PAT as a last resort, as KVM does today.
>
>Honoring guest PAT is desirable for use cases where the guest has access
>to non-coherent DMA _without_ bouncing through VFIO, e.g. when a virtual
>(mediated, for all intents and purposes) GPU is exposed to the guest, along
>with buffers that are consumed directly by the physical GPU, i.e. which
>can't be proxied by the host to ensure writes from the guest are performed
>with the correct memory type for the GPU.
>
>Cc: Yiwei Zhang <zzyiwei@google.com>
>Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
>Suggested-by: Kevin Tian <kevin.tian@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> arch/x86/kvm/mmu/mmu.c |  8 +++++---
> arch/x86/kvm/vmx/vmx.c | 10 ++++++----
> 2 files changed, 11 insertions(+), 7 deletions(-)
>
>diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>index 403cd8f914cd..7fa514830628 100644
>--- a/arch/x86/kvm/mmu/mmu.c
>+++ b/arch/x86/kvm/mmu/mmu.c
>@@ -4622,14 +4622,16 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
> bool kvm_mmu_may_ignore_guest_pat(void)
> {
> 	/*
>-	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
>+	 * When EPT is enabled (shadow_memtype_mask is non-zero), the CPU does
>+	 * not support self-snoop (or is affected by an erratum), and the VM
> 	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
> 	 * honor the memtype from the guest's PAT so that guest accesses to
> 	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
> 	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
>-	 * KVM _always_ ignores guest PAT (when EPT is enabled).
>+	 * KVM _always_ ignores or honors guest PAT, i.e. doesn't toggle SPTE
>+	 * bits in response to non-coherent device (un)registration.
> 	 */
>-	return shadow_memtype_mask;
>+	return !static_cpu_has(X86_FEATURE_SELFSNOOP) && shadow_memtype_mask;
> }
> 
> int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 17a8e4fdf9c4..5dc4c24ae203 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -7605,11 +7605,13 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> 
> 	/*
> 	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
>-	 * device attached.  Letting the guest control memory types on Intel
>-	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
>-	 * the guest to behave only as a last resort.
>+	 * device attached and the CPU doesn't support self-snoop.  Letting the
>+	 * guest control memory types on Intel CPUs without self-snoop may
>+	 * result in unexpected behavior, and so KVM's (historical) ABI is to
>+	 * trust the guest to behave only as a last resort.
> 	 */
>-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
>+	if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
>+	    !kvm_arch_has_noncoherent_dma(vcpu->kvm))
> 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;

W/ this change, guests w/o pass-thru devices can also access UC memory. Locking
UC memory leads to bus lock. So, guests w/o pass-thru devices can potentially
launch DOS attacks on other CPUs on host. isn't it a problem?

