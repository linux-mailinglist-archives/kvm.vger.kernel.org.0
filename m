Return-Path: <kvm+bounces-9116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8461585B113
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C4A6282173
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDDAF41C66;
	Tue, 20 Feb 2024 03:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JcIyGNwz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9372E63B;
	Tue, 20 Feb 2024 03:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708398289; cv=fail; b=snaQx3tZY0Hh1Qhoa2wzCLRitWg9pUWn58DF1O+ARwYIBdnLaRti1F4EF9IVV5Og1EOa6uH89hMUa8UMT1oMF+lY3CnDq8YSJMq7Ah0zmplLOFvThMk8NmIYZKUa2UmkkzpZgAQC74DCjaxibZ4+mHg5+mZZ4WnPn2z8Adonw4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708398289; c=relaxed/simple;
	bh=h/kO9D01xeF2iBjxXhIKF5W8/N4tv3b275u0DU/BtEE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CcwWTCbByTNLSfr/fcuVC9FuzTzo7qKmjeJYu/rx2EBUMi//hMRykLQW3wSN1gLf4X4WZeNioRtrMn0xTlT4QodbQHwX9MfhF08rbfoxthD1clxY/rR9xKQ0faSBioQhSkZsqc72A2yGsGDc+BA3AeUBusJH7g/Yb0K9ZZ4+rzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JcIyGNwz; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708398284; x=1739934284;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h/kO9D01xeF2iBjxXhIKF5W8/N4tv3b275u0DU/BtEE=;
  b=JcIyGNwzEhqM1TxzI0G6uJA9u6afubyrfFFp5fsaRv1rR8NwsFdmqCqa
   tECkYz6U83rp0kPqZDCqxAJOlwf1R6IyK5D3lQlVAhKUaHevG9zuA6X5g
   qcWgny7JrUVl4aVUC3JYx5A9VvfTBxdlXckX8xfElKkn+5X5vQn8utLSn
   BE6EJrgRnAa+UfSFTAEMs/XwUAf3l2EQsZpqFwyrKXqwAixliDSah2FGt
   Tr/MDVjgSKopHlbZ3JYU7++bFrPAZw5+Xkp/RGBdX60j7LRGyAd9y504i
   ox7TKBcehHBApHcERsmlyDM1arhdWeXYE2CHg1XnigZXQaohuXlErQn3r
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2350570"
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="2350570"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 19:04:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="9258229"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Feb 2024 19:04:40 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 19 Feb 2024 19:04:39 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 19 Feb 2024 19:04:39 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 19 Feb 2024 19:04:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPPm/Hz03IoLQtCqnlW2ikfoF0jrIriucPQ5ZPiC/5z19n82qtEm/gH9Zap9IwzCIBvDyJ1qEBJ1r7UYWaExa5jaxt02TwvdVbuBFKkchCLep1wALxjIO7slu7A2B2GhPhYr3vHQsUbZLJ4IfwMVDzKRoTxADZPscBkFs35zp/yPN5U7znr7P+R2BOliGOVg/HrGHbOXX5ctdttfCh4h/BmjS3K/o3I1eYWfNaIyZsI7PKYDJeamGTrbEq0iUY5qzkyA026vJXz4ja88DfvttKfjZxzDhlZjIEvmSPbrGRQIJdcVW2c49b+OlYFNfjPg0t4E4QjDlXxtTa4/AjPTEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lso5vk1p3zW+Nd1bI6sFE4GKlqTIOgt3Y3r+zqlLxsg=;
 b=FWzkUbz4Y2k4/++jYVl/wJfp+IAAidyix80pXCjVmI5Z9MZ1tO792Rd7AWcu/z6B9wzHc78qozIOZ+oKAp9L/1CHVj1sPjmVcMGDEKXRMcWmZN4oTaOhPLfojPTebiumF/QqrM8BGpVh7Wf6Ed70NqjjVB4cc8wfQB1sD8dP26Npd30DfNjBa+ioeLP+XZ7fDXimQXsaCl4i8PHtCETMyJRDgV6sfv7wmoJCZFVDRjnzsvP4A5nWX9q/bj5PPcgL7lnPYBxj41jlEuvIG8O/worLsAnQVAe1P7ZCmMuBWNXAlPptaGq5LXic+wPmm/HsAFTyab8vmqVC9JtQvFyuYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB5408.namprd11.prod.outlook.com (2603:10b6:5:397::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Tue, 20 Feb
 2024 03:04:37 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::9846:6ceb:7600:b0ab]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::9846:6ceb:7600:b0ab%7]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 03:04:36 +0000
Date: Tue, 20 Feb 2024 11:04:27 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<john.allen@amd.com>
Subject: Re: [PATCH v10 10/27] KVM: x86: Refine xsave-managed guest
 register/MSR reset handling
Message-ID: <ZdQWu3D3Jku1iAvd@chao-email>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-11-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240219074733.122080-11-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR03CA0125.apcprd03.prod.outlook.com
 (2603:1096:4:91::29) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB5408:EE_
X-MS-Office365-Filtering-Correlation-Id: 07f743db-61f6-476c-fa0b-08dc31c0abba
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RISmSFg0EZIL6wIyJH01x+196sqNLnEr4DP1vL0nT1Wt/hESde/DgOu0XAkkpRrsume0LYwPNxUda+fUbkOjc3sGf21Yzfeji4ocaiRZ0vtRyT3yJG5krdsX9gnYcu0fZcS4OGuBG20GVImcXcMgLTUzG8CBMFDQW2u5MSK0cj7a4WY2cSQrvrpJ6u6lYxP698zy8P3mmoj6GUGgtBC275IIo8JzqVGrdftOZUwtAYMwyZip7bQvEMzrk1UTKl1mwRTpTakD+mtcAe42tQAGIlTVnjikZsupr5vqH0NjAVmGT/bJ42atLuxvkpDBIFrOgIPV5KAmFIfKL/ENkFAvgyUBpM+YgSQbmP2SCXyv6UusBt/5iocmc17oH7IOwXuMwiDKNYSlFNrriB5oKKAd4xYNYgNIJc4PGIDvWd5oovxm3nINHpSROo7vWt+WSjVrRUqsiAyYR5CrZtd8ZCULPVzebxq/OdRPXTvT3MvdQ3tG/lhqIJEI05B4KdT+i/eje2cMx/xBIpuVkaS2ZoT0Y4NZGuKg+qR7sHJtBn8HvAY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GBqF/FsjWZbMWkZPZ8EC8n9jqD8cUs5FzK+Pt+6Jfl8BuQWuq+8kRcCaHACa?=
 =?us-ascii?Q?E15xnzYWCgCLlDTOnOR0et4CgAkW9nONNfLrFtR9gVXLiQK1FIhGGdlQOwkf?=
 =?us-ascii?Q?phox+NvwcOqxJwbHT1WlNEDvTpHDlJzMiFDZegwllPUtNX9/9xlttYlOTqb7?=
 =?us-ascii?Q?UBiEaHRjsRO9+iMW4pGy6pI1gPjqYL7irrGNKFkqgrQUrCjXl4TNl8Hy072l?=
 =?us-ascii?Q?nF5XhbzFan9nmlb/UOSWO8UFcIPVmL+VEZXy2p9W0RUwhJ/TqkSzU04VA11D?=
 =?us-ascii?Q?YYAJqxnHwYqh/m93HWL8DyMqH4x5mmmkinud4zzzu73MgPidejxoAgGKO+Ap?=
 =?us-ascii?Q?ut8ewpfCJzKc2qhGTZ0ziYhAhj54ByldLez4JI86QW+eoEgg0FcpLgrEEI2J?=
 =?us-ascii?Q?ZnoVXX6a8lb4Qnhbfqon4CwI1UdtE0Tjtgp0LdZvc4mi0rclBSNpD1C5cWez?=
 =?us-ascii?Q?uJFtoGYHFSpwiiq82gNE6koNhCVIdZF0cWG25h92dLNDIR3uvwFb5nQVPw5U?=
 =?us-ascii?Q?Pv0MzjGjeRhC2hjJhZvUgCANio+VPeoMyvOSE8KzoJ9SUiEqEAZmTX5g2vrx?=
 =?us-ascii?Q?eudEMUBM0LuIjFKAYyGonTpakqLDbioRMpSKsmVlIamyuKrYvPtiobtvYYYH?=
 =?us-ascii?Q?rvjmB+UyPIn1jG/PaZubo7uyzXa9UTmmak9A8eYmpbX9UGffFaez93GmQYSj?=
 =?us-ascii?Q?jomOWomht6DILpYDdqPfIOXQ/U6u5AmLeQtgq4IQa56KoBz6JGoI9AdzuiqU?=
 =?us-ascii?Q?V7LcVteOydjT+MP3ngtIBByNQflLDUt2BYE22o5XzFqzu5aIQljk/fi3GS82?=
 =?us-ascii?Q?y4LI9PLlnD5GFz0H9fY8MuahZk+zrbYLqQcOe3V3klkRPXzQP4I55g8iOe6W?=
 =?us-ascii?Q?yFqdoU789vkiJLYx203ZVpJDoQO96VtBPaASFQmumXxY2Sd3w/J+dZO4qHtO?=
 =?us-ascii?Q?fDfu1ughf940BhYtu180ZdhAyfQOaYB8FqW5ABCT0V0pKA04S98jNYBbljI6?=
 =?us-ascii?Q?4mZ/yqh3G3xnM8BaPK9Spzvjg1d6xg6T8elBUPsv9AX9/jkrprnILGskoqCG?=
 =?us-ascii?Q?lIItK9sVempTdBtqgnLZsA00jaziz8dCB5VnJueEQbyhx2lhnKuNiaxkuQP2?=
 =?us-ascii?Q?g92trwKBBpxl8QSG/2vkrmnwUCSEvx/m2sDW1fPKd5gfNbHYPjNIAjtqLCNn?=
 =?us-ascii?Q?vFki8Xxp3eGhMjW0p8ZgJyIYR6MiFzjkKV32rqE3+ouL+gvEX1BgPZdUow29?=
 =?us-ascii?Q?XM9ySCLtAKcPao2JqDSBLStLLJm99gtqie8gWShvSk8Cb89dZnsc2swtk0gh?=
 =?us-ascii?Q?HQr5ivZFb/AcAVPUv/HV0gXk80sy8SqeWxZXEeXgxrFm0ms39Ttup40XHL2e?=
 =?us-ascii?Q?vP/LztXHwafxH2YoZ3oCHNERB1QnZ2BHYAgy8+1VVxHETUvf8wezjYYgh9i0?=
 =?us-ascii?Q?+SnSiVsotLWSRGzGfDUFnGMjU6thTzar82EK36v4hPLlkZA2DToukARHO7JO?=
 =?us-ascii?Q?7zz+/XF7Cy8jlWJK5vSex6XRQvRyxFKhisiuuus38buR8VEOFrCUkaUqcRi5?=
 =?us-ascii?Q?wU4KBi0qDEvT0lQauCTuLHkiy9SxeKDUnDbt5Pif?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f743db-61f6-476c-fa0b-08dc31c0abba
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 03:04:36.7743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7WVEpzgj1WTEl7b2USL+D9N9qXBr0gpSxhDmfDswe3i3W0GZZK4Nhngnk9rCKURKkF7FgQlx5QjPmdaNAzhRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5408
X-OriginatorOrg: intel.com

On Sun, Feb 18, 2024 at 11:47:16PM -0800, Yang Weijiang wrote:
>Tweak the code a bit to facilitate resetting more xstate components in
>the future, e.g., CET's xstate-managed MSRs.
>

>No functional change intended.

Strictly speaking, there is a functional change. in the previous logic, if
either of BNDCSR or BNDREGS state is not supported (kvm_mpx_supported() will
return false), KVM won't reset either of them. Since this gets changed, I vote
to drop 'No functional change ..'

>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/x86.c | 30 +++++++++++++++++++++++++++---
> 1 file changed, 27 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 10847e1cc413..5a9c07751c0e 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -12217,11 +12217,27 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> 		static_branch_dec(&kvm_has_noapic_vcpu);
> }
> 
>+#define XSTATE_NEED_RESET_MASK	(XFEATURE_MASK_BNDREGS | \
>+				 XFEATURE_MASK_BNDCSR)
>+
>+static bool kvm_vcpu_has_xstate(unsigned long xfeature)

kvm_vcpu_has_xstate is a misnomer because it doesn't take a vCPU.

>+{
>+	switch (xfeature) {
>+	case XFEATURE_MASK_BNDREGS:
>+	case XFEATURE_MASK_BNDCSR:
>+		return kvm_cpu_cap_has(X86_FEATURE_MPX);
>+	default:
>+		return false;
>+	}
>+}
>+
> void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> {
> 	struct kvm_cpuid_entry2 *cpuid_0x1;
> 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
>+	DECLARE_BITMAP(reset_mask, 64);
> 	unsigned long new_cr0;
>+	unsigned int i;
> 
> 	/*
> 	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
>@@ -12274,7 +12290,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 	kvm_async_pf_hash_reset(vcpu);
> 	vcpu->arch.apf.halted = false;
> 
>-	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
>+	bitmap_from_u64(reset_mask, (kvm_caps.supported_xcr0 |
>+				     kvm_caps.supported_xss) &
>+				    XSTATE_NEED_RESET_MASK);
>+
>+	if (vcpu->arch.guest_fpu.fpstate &&
>+	    !bitmap_empty(reset_mask, XFEATURE_MAX)) {
> 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
> 
> 		/*
>@@ -12284,8 +12305,11 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 		if (init_event)
> 			kvm_put_guest_fpu(vcpu);
> 
>-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
>-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
>+		for_each_set_bit(i, reset_mask, XFEATURE_MAX) {
>+			if (!kvm_vcpu_has_xstate(i))
>+				continue;

The kvm_vcpu_has_xstate() check is superfluous because @i is derived from
kvm_caps.supported_xcr0/xss, which already guarantees that all unsupported
xfeatures are filtered out.

I recommend dropping this check. w/ this change,

Reviewed-by: Chao Gao <chao.gao@intel.com>

>+			fpstate_clear_xstate_component(fpstate, i);
>+		}
> 
> 		if (init_event)
> 			kvm_load_guest_fpu(vcpu);
>-- 
>2.43.0
>

