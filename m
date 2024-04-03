Return-Path: <kvm+bounces-13414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE4A8962AD
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 04:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62930287A13
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 02:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668C21BC26;
	Wed,  3 Apr 2024 02:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fyhD5C/7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7961B815;
	Wed,  3 Apr 2024 02:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712112652; cv=fail; b=Hhe4AgP71sdDGsGjMdJwhoxz5R9/WJwMSJACEH91RAc8c8K9aiDFT7UUbgtFONMOgHxSqDne/ynvG/ZF+gq8Ctk7Xm4gor57uQQ1S3fdb/rITqbXNFCxzJH394NOOgo3krKyp9RugH2pl4u5pSuyyayuj/qExdHHx36RdX2USxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712112652; c=relaxed/simple;
	bh=Sm8Nj6fobNepdZM36q7wTIOHHgTWC2Slgpv4dAeP/pY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DxPGZ2+3gpwFrUHvOw8AYA22uonLJ9vyi/Jc7IV4RypOO/8LVy3Y12R+wKctuwYe/vvhtwaGjwVw/XkYtj2+LbW+8W6737rgLlanc23QJlp+LJ4fq4BfSVUxBPE2Wd0vogeJb45+GMUrSe4zBuw06YDDAHa5vCnA+6+w3gchalE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fyhD5C/7; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712112651; x=1743648651;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Sm8Nj6fobNepdZM36q7wTIOHHgTWC2Slgpv4dAeP/pY=;
  b=fyhD5C/75R0KJfDkeR/1h8YvJsQROCWVS+SSXDKRzOc/a6jnfZOhxJ44
   0ZU2VPnjLa21HDJzN1tm+iFqrE1qB/mWPAW052eUA/I4+2BTe3S9S3Uby
   DdupCfuayDaMWgg/gxvLrkR1xEyaMuFYvcNMCLABsbFVz17NDbrfbD2PS
   sVQkMbOAl4EHHO8beABYf3PX5Gb1aVizLPpzYUuVLMQ3JysLdiWgQO3uD
   Pwab/mK+8uGuzbsDyznbxJ/dWxImxk3MHdeScv6dn7bWRD+P/W6dVr8lh
   D+9nhfMtwccxxFiYhPZtPqy4uHlyFviCzSThJiWy7yyNGNU8BUyZw8Rm2
   A==;
X-CSE-ConnectionGUID: yUpoelP1TveS/+U4Ky8aEw==
X-CSE-MsgGUID: mhC/+bKJTVCI4tT4/ZkXmw==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="7511259"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="7511259"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 19:50:50 -0700
X-CSE-ConnectionGUID: Mt5j/2bnTYeTp5QA2/Fr7g==
X-CSE-MsgGUID: 9AyN5J73T12v1oP2Rx9Kjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="22979520"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Apr 2024 19:50:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 19:50:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 2 Apr 2024 19:50:49 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Apr 2024 19:50:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVIA4qP7qovwyfmiRNP4zCSGHZH52hmlOOL2A80H4iqI3su36jvK8PveDSemyrucuvKhqkZaby8joAi8aMYFZjHpO2ihMUZoyeUwg5gSCV+FUmgAI/uNho4/bgk9SKTBcaCx+5RTLCQgPXUr6mG8YhxMGPVrWL4tPhDMIg+sCN8LrC9Uh5K8S4WKtOGE1ja+KXCXMRixw5vBKORGTsYQA9uDZZpeMB3+pKeLTpnRRIWoXbe2FuUAd/xK+2vb2xfrnywbcBvey2gbm5vBxfl1W4wdFu1fZqwtzrtvkSwbPWvduwTej6eIQTZ/pUYFuHcYSYKHiUw/V3TZNA1s+3rYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aqGR0+p9ZeAQojXkEePVPJp1TFInB4VKk8te8To6ntw=;
 b=ZY80zmnJFlZ8nYVlYV4bboENAPkqIT0Z5R0bMtCl5nthOvjWLi4eGK/I6L2Fbc4xeXnVwUdG5vPRTo9voBEfid1nEW/+ke7QNohZGpLbpf5y5WdzmiOIIveInNudpS8Ie6QB7bxY3E1fgCGo8R7CHAtk5rGhLtPOwMEW+e+T6vBxL5iBRTUk0X0SRs1lE4Rv4Hsb6CjlwJ8DAqpFQuG3YhyVGI5Fg6BIDrja56ZWtEWZuqAAN8/uRX+uqh3pVtxEzMuQcqTNBtkgyN13g4MiHJAd2/t/HA1YhfxxNZmpWTIa2bFr0A7ro9lyQ1/cXMJY6mpF7+Hd9SX/jepUwS4JdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5142.namprd11.prod.outlook.com (2603:10b6:510:39::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 3 Apr
 2024 02:50:06 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 02:50:06 +0000
Date: Wed, 3 Apr 2024 10:49:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 106/130] KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
Message-ID: <ZgzD1FPZV4A45m/e@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fbb0844fc6505f8fb1e9a783615b299a5a5bb3.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b9fbb0844fc6505f8fb1e9a783615b299a5a5bb3.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SGXP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::29)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5142:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hDk/cu3zr/r3IfjIEQj0PjgOHrk/sL0X2FyNRFyPWr1Mf72orAOSzOMfGUjynAYB26l5dMRA1AfVZLCmX+hidnx8TdDgE16K1AbjCcUyi/06sMIxqf6rCj9cKTnQ3owLo5daNRFgUiXrhHgEneox85EAjPYgP0DlAq1fK7mu9c5QnXa4qib3awuN2sGD7CrDSCXU65jvq32CmKxwMaCCF692wQ8ntOc+T6/+pT2Mx7HrVq7bdELZwgT58Qg7ig9MzvgfY2d9ehP7olYKVRH6oajpYLJpfEyhXHhgSlisX+ltpUGgy3cMAgTpWim+kM8mpGfp7JW7WbFpBP9Tecuku3hwYdfWQle1/urdaHNEKkJIb+utNvzEiyYpDzvZSnxkNE4t0tlGGdg/bOoGmjb08BKen1JWOGzg0Uj18FXvwNf9M3VPICRVZudHoDCy9FRNJavr6a1VENzKvn+XV09nEI3Q9Tc1VbqezC9usuyVOANuDNIphDV/xfeZNCAig3VjwTdd6fyh6K98gUdO6DIllS7U48b6dXjrkWoPuFDEV0/DZGbaUaFnuG4r9DgVAwsaVTb3Nn6msYevaw3f/84+yZ+iQK7p7CPIrsli2MScM98XwpBvuskjXbNPq56ODZpgC05xhZPAktqZIYp/Dg2g/+09fncVU0rEBXicxoavNPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ski7kFSPm7QVNF+EMQtLtuOfYpEO9Z5jue2MOwYxE256pWIxm2PaSsyGijk2?=
 =?us-ascii?Q?P+qGt8eGrWKKR9MXrZe9KQZEDmyeB5i3VDt6LSFlhkmtCTvfWL4VMsC98WxV?=
 =?us-ascii?Q?akkxrUuyPo1MC7EJP203i/vFEGoC/c7YgODSYkpuUYPc0yQz07tkjHMtONKo?=
 =?us-ascii?Q?X4z3b58y96iS1iXsPdnYfjp9t1DNRCOe40xMmqc/H0LeqVtqbKkVFi4O+ymw?=
 =?us-ascii?Q?fOBaVtlcjXTKJsy/gYX7K/41bnA95A/5/t6n3KNA3UprYz3ktgTd1N8Sw1gJ?=
 =?us-ascii?Q?x7j32+q9o2pSrExVEBD0Hvcod5LwkwxzvuKCnxfsUiDu/ZEcX8ij235CZIVU?=
 =?us-ascii?Q?mtRvrARsaBem6FaUrM1kheMtxUN1HBJZfip9QdUjqQdrx3E//O8sohWZrFon?=
 =?us-ascii?Q?Z2ZyhLWaxsPnInU6jos/ENy8nhh/1bHKLoAHFxujql/G3EClZhMF3BieuO4A?=
 =?us-ascii?Q?sN3nrAmReCQC+0aT/G3S7WotZlo+KZ6axDuKvvF+og82a0sOwxD3ITPDwlkV?=
 =?us-ascii?Q?E+ajzbTzSNkQguMfVB/pGuwW9Y+Z4XMgrHy9ks2aoBmD+GapI+OsrRkN4MJ0?=
 =?us-ascii?Q?FykgsAgg1j1N9oqC1iImlPV6Iquevvje1tImVCTy60PZrKQfc5wfDm9n+dK7?=
 =?us-ascii?Q?NSmT2nKhARYqiT/eAlVnZGgi+Yo+aQetPEhd9/EEzJB7gCLPBJSe1jO3TnA7?=
 =?us-ascii?Q?1o25BCcOH/vSXG02WgaewzWIb/gpxZEJIVIyXnvDfxlHNKIP0TpcncFHuHWa?=
 =?us-ascii?Q?DLxWWoqQ56Z44npsoyAH0SQOEZP6DUhdGeTf9daVntykby09opGxD+qoQHxm?=
 =?us-ascii?Q?0d4scZ34rB4SRgZzkgN/rFD2j3szOcbo8P4atIJfdx0nEtbB8euQMEygFqZZ?=
 =?us-ascii?Q?mI63dvVwsgeIy8fpYg75VH6gRmBAx3oLpF10L1xcCTB3TCvBdRyeVTBpInoI?=
 =?us-ascii?Q?ask5UCe44HguAUTTp/Iv6JiKlVfOr4O5/2ZT1PnRljpFJHNRRBhvsMvyD4hX?=
 =?us-ascii?Q?J4XggsR16VLV8BGE0JbpVDHfn/UogVE2JLkNPXddCrUr0LyeaAufkDExnYGO?=
 =?us-ascii?Q?tgcusqmj5xFDw0Bnav5kRAK+GIwbDNd79s/bK0VWDMQBCWmu70Eyk3oZFuvo?=
 =?us-ascii?Q?ukwf9MHAQqHKt8rXehElGknD4luSYHKjmyLFe86Alp1NskZOzfjv5h0d5BDP?=
 =?us-ascii?Q?gCApPGAWuo27RCD2neJfBjO8dDMfck+RovJMgDI8TYKwM8r+GoKFRe/xMasX?=
 =?us-ascii?Q?RwaRu7T+z5t+TuXwNuqRzLAeOLA5L299f75SNCFicfSDBzx7Mn60xz9JYoZp?=
 =?us-ascii?Q?hcTf+8ChBMvh97d3DTlvNKeXtpN8OPKETwMhrc7R2+Jm0Rh9KNoRdjItwabJ?=
 =?us-ascii?Q?Yss3KkWOrOMNE+B1YoKk20frzXUfodJksemMirYY0ElCpRogNyevu/guzlvf?=
 =?us-ascii?Q?9bsVcXEJR10MdMzniDcCcmptKeziOmD4kKRkWwPcbN1ozdAbt8GqK/QmWFtO?=
 =?us-ascii?Q?tvxsLmpij1uvOA5escGAj+8LslmOgRYsdVCkSx8tTJeB0HI4YMc+Pla9fEAJ?=
 =?us-ascii?Q?4YzSsRQRECK4mXobov4KSAUFoi7gPhnHFtVbCt48?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0396396-b6e0-41a0-906c-08dc5388c499
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 02:50:06.0319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZ+setJ8ImzGm+FPjgE+3OYx1Uck8jjGEjm8BeWli568k9d93LMFYZqQxAIn6+xw6/oxDrZvHxw3RaWhUFL7lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5142
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:48AM -0800, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Some of TDG.VP.VMCALL require device model, for example, qemu, to handle
>them on behalf of kvm kernel module. TDVMCALL_REPORT_FATAL_ERROR,
>TDVMCALL_MAP_GPA, TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT, and
>TDVMCALL_GET_QUOTE requires user space VMM handling.
>
>Introduce new kvm exit, KVM_EXIT_TDX, and functions to setup it. Device
>model should update R10 if necessary as return value.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
>v14 -> v15:
>- updated struct kvm_tdx_exit with union
>- export constants for reg bitmask
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
> arch/x86/kvm/vmx/tdx.c   | 83 ++++++++++++++++++++++++++++++++++++-
> include/uapi/linux/kvm.h | 89 ++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 170 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index c8eb47591105..72dbe2ff9062 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -1038,6 +1038,78 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
> 	return 1;
> }
> 
>+static int tdx_complete_vp_vmcall(struct kvm_vcpu *vcpu)
>+{
>+	struct kvm_tdx_vmcall *tdx_vmcall = &vcpu->run->tdx.u.vmcall;
>+	__u64 reg_mask = kvm_rcx_read(vcpu);
>+
>+#define COPY_REG(MASK, REG)							\
>+	do {									\
>+		if (reg_mask & TDX_VMCALL_REG_MASK_ ## MASK)			\
>+			kvm_## REG ## _write(vcpu, tdx_vmcall->out_ ## REG);	\
>+	} while (0)

Why XMMs are not copied?

Looks you assume the guest won't use XMMs for TDVMCALL. But I think the ABI
(KVM_EXIT_TDX) should be general, i.e., can support all kinds of (future)
TDVMCALLs.

>+
>+
>+	COPY_REG(R10, r10);
>+	COPY_REG(R11, r11);
>+	COPY_REG(R12, r12);
>+	COPY_REG(R13, r13);
>+	COPY_REG(R14, r14);
>+	COPY_REG(R15, r15);
>+	COPY_REG(RBX, rbx);
>+	COPY_REG(RDI, rdi);
>+	COPY_REG(RSI, rsi);
>+	COPY_REG(R8, r8);
>+	COPY_REG(R9, r9);
>+	COPY_REG(RDX, rdx);
>+
>+#undef COPY_REG
>+
>+	return 1;
>+}

