Return-Path: <kvm+bounces-13271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59ACB89394B
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 11:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02BCE2815B5
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 09:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF7A10961;
	Mon,  1 Apr 2024 09:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d34HkjT+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9ABDDCD;
	Mon,  1 Apr 2024 09:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711962857; cv=fail; b=JeOml6LtRLH1TFKP2V/W/lFQK8yZX2SxHmYhS1NiUIh7ntWYIiCbBMHeHtIKTXUuXCQKY90OWLkme7OgS4iz6efT5EKjmq66lc/99mUc8qOULcxhh71jpxhpBbnOXzCv3z1MS9+Qt2jcRG6ciZmilAP1u10ZhrYEnP5GYEFUsFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711962857; c=relaxed/simple;
	bh=2udzXw6nnmNsTcKPHJtQg3VtWxBz/QQZCnjtNL19iNI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XvLQZAoiKsG6DcWIcwrQ0bhoE5BZCe94YmvN7cXdL28VIp23uLgRPWCweiyxYwV78EqPnHSeP/VTKNFttbyeYTPKsyj65qX76rwNuFRkW4wfvFeEUONlgbffBwkkn/x6HPiQ6aHGkMUnZrk4l5cOKLcCOveenIu2pIU9e0go7ZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d34HkjT+; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711962856; x=1743498856;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2udzXw6nnmNsTcKPHJtQg3VtWxBz/QQZCnjtNL19iNI=;
  b=d34HkjT+o8d5j6DE8LJZXqrd4nCmfxG5qca1TF0uP9XrsDWUepDwRukb
   kqVqqGD8kueCAs5nQe6KfMOVHG9TWkAhqXVjlYkgcBbb80b0+jYT9KRSy
   ZuEJ5zUWXlLXaLVtY+mb6Wl/iCculC6vhEuc6okN/1Jbzpyu9bCxmFEd5
   xu2CGm98rYrdRTq7LtPmxasEZ6S0LxMJ9xfKQCZ+sntYEnlf3wqS86vLS
   jMa5zsF7orlwS3bGtsw3v7r2IyoV5H/02hXOwHeU2nuUS8H2kEb54223k
   dbT9cM0u45mboEpAYJJhHkjGXxQF3E618IOY0pcy3gJrWHdkOvPOikk1D
   A==;
X-CSE-ConnectionGUID: VZQ7T1psSZmXLOc68zckMg==
X-CSE-MsgGUID: +X1j2BGwQU2Vyt8c/jfvgg==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="24534581"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="24534581"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 02:14:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="22399068"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2024 02:14:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 02:14:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 1 Apr 2024 02:14:14 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 1 Apr 2024 02:14:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sed9Ot6E/F2dJhRpzy0kOO5k4Z2s7CvS/lsS+cgBLK0EGRZqAeC4DzzX9QgS0OtY2qsvHWFGarKfzk5mllTQIHsmo7AgLVq1ejwPPXEfYOlAn6xM3mkIlJ+E+N84e85x284OqKvoozukGLCbZk0TvQX3CNDMUt5PZf4knY5j8wFdBNQqrhDUkTzekskG3LN9sAtpCjmCetJiPGcDNjQUXPK6TS+iD9zFAGj7sOpoNJon9l/B1UlyxVMaxi4K1n2GIjXVwNn6h86hFA60r+IhiPYooHtr2rhnHs0TkckRnti5qqHW14pZ/NjC54EhUxfLINIknHEQosfH9cyDfdMIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=meSVaoU8CLqwXgGFwm8Q4Krzua+SDbXQYuWolKJ0Roo=;
 b=MNV+qf3QUR6F1Lezmm3vPhjA6kIynYXXsHHqP8ISh9YGnKccqFK9HIhX8GjWCRc7WqaA27hH2GIQUTUQ8zQ7/49VKzCZ3GzLS8vu2RGI7GIfxebF89TRysDhKV89aPRdzmJHZwCRATXqwnmtTglm9pljDigBXXV0brJM+sGGmxg1pSs7mYjDtkur06EZSZdgUapWvhbwls1K6/6dPi2LY0JeaY/5msd8agjJQfemCfZdPgdg/EmRwV2e1Su3ZeWytp0WJReWd0CUCaTMN92YO4xguU9yS8nvgYDtrETXzKpWQ0Pe007SvkBUBxUpWEr6E/FffMd3nk8cTU+6PTcfOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5140.namprd11.prod.outlook.com (2603:10b6:303:9e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Mon, 1 Apr
 2024 09:14:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Mon, 1 Apr 2024
 09:14:12 +0000
Date: Mon, 1 Apr 2024 17:14:02 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 103/130] KVM: TDX: Handle EXIT_REASON_OTHER_SMI with
 MSMI
Message-ID: <Zgp62iK3HQEvcDyQ@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a96a33c01b547f6e89ecf40224c80afa59c6aa4.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4a96a33c01b547f6e89ecf40224c80afa59c6aa4.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SGAP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::18)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5140:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/yRZ9jLwjlz0u4uqGjs8gAHZxZrKxKN9ilQ3Kdz8O1wiGInj1vBDr0QsyiU0AcECxnSe0w4/FMSlKhg4WsvVlYNB7NKNu7swsHk/5VcB9A5Xw1TGZTKnQ32ZM536xljfF/qrBQMIqZSUNshNF6D/4WJQGnqwXzkArKeJLxOqVouwWWEVKUGnjpoWIqmwJVwQouwhzCkdXKV96w5vEwQy/Nrqxkyj2iQMKYXYqpQD8QiQZUuRGKiLWbrtVDddMXFx8RIUqUo3lvLhGciI7awvzcJNYmRUHOkhi0C3Z+BRwqMef8J2+hvd7CBZEELp6E2Kq6wkYDlQhG4ztftGJyjtiLbfBeIHlsgNMG4c/HysdLLHFv7EmN/c6gZZz2axEdIlq/HrkvrtSlz5tHbA2TyUoR3YjIl4Z6gtoCpcgo6a0PbHeYi+Z39+EoyW1OuO4Y3CQBuHYvG5t0IKxgdBR52d7JaWqhIPaBsLz/9fVTmZMp8mITtmEP3TnmssLgb1533nbKGN/sD7SHU53Uhm4/i0RBolw7oxqfHDXvWe1npUg7/AyfNxMnp+TU+vyXV4e+M0T9OwzW0BlobaFhdvDHtxBmejC0ZS1ugCcB+tSDLI2RfmGezgUlEAnJ3raX75yrTgj1oW2gtxmNTw3bAXPe4i9x47apEYzu1MDwUYEc8ndQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ujAg4lTmf9AB7bxOqmZ1E66gIzJj/73/xICBO9GU27ZU63lgoGrfPuiLAq51?=
 =?us-ascii?Q?P8bEEJbx1aXMy22OLARtzlEm7d2Qa6rHjcfoXC7K+caak2g/DaQ4FQf/UtxT?=
 =?us-ascii?Q?XGCGOxtD+WYNKNoFPN+q6crxiFFD57Tk0A4BJT0Mx6BZwKXlKMIpEZPLd+h5?=
 =?us-ascii?Q?5mwUKf3GqWKjEw3DS0/Vvlqw7we9GVYORrM5Eo2sSB3Z+VHV3rU8g6lYsS1U?=
 =?us-ascii?Q?DInfuYipWoVRJWREqh8eoX9hpD7+t94Jz4Q6+3rc6udq4+T4OLhZP/2cugQz?=
 =?us-ascii?Q?800GToD1F/NqhGVF0elSwO8E9erYDRT9QJkAV1m/H0Gg6TOa9ZBvtkQMSc9S?=
 =?us-ascii?Q?BcZnR5b8CldFpFj9BR5V+DYrO/AqxzpiFTb1Qea2rueu//QMwnyFKyFHTZUA?=
 =?us-ascii?Q?ngmK2/wVyLY2SzYMhbpifYCvUOKOmvYyIkQ69OSN7NxNFYAN72xB7XxcKxsq?=
 =?us-ascii?Q?51ijziiQoLKkfG/aBB6Tybwxq18Wq72KGbWXIYWbvDhvDUL1jmspG/sr+zmy?=
 =?us-ascii?Q?Ng1AtA8WuM7gmbUyqsBkPE08JaYo5/0Q5dwAeF5vTNcY6fssJOK23j2IoVXF?=
 =?us-ascii?Q?WXuHaFDfjHvX5cR8YnK8zKUNnY/kjNc+/VG1mK6C+OXgxCWwSasj02+R8rDf?=
 =?us-ascii?Q?ABI1/s7Q27YLlqx7ho1uVHu5yi32B9XGAw+IpRDr6eMcT4Po4Om/JEZdHHen?=
 =?us-ascii?Q?NWz2r1Hlj5Lyv7IHIsNWONKAhefXmmRH1NdE9NKgSjl3g9YTw7UufTq1BBWv?=
 =?us-ascii?Q?GtxgTWOC2hmhT0PRRan8jT8cJ0OemEzvUKjtdiv1jMw/DqXTNaQY0qKu+NR3?=
 =?us-ascii?Q?YkQFskTNims8Dnk6PVHzbeTfo15tb4veAQKuvZlgM/PwyHuamYfE3mNNeNHF?=
 =?us-ascii?Q?f2tj3SLkWGEvQ7r8hrm4/pEPJOojULtyJdrjBNq+s5A+Uqd32Mm2L8YvDA0s?=
 =?us-ascii?Q?QCkkbMjnE7b6O1pYWfZAaQNJynSG3LqPyh+c6vkKOFR34hvPCAx2wyKFOPJR?=
 =?us-ascii?Q?J79WajSDUJX/tdnqI6xZGJQmJcTIYuh6z4gsmTN4YSeu3QXEASGGgGzzhcKF?=
 =?us-ascii?Q?zfsePCaKhr+AbcRd1SasvpfLGXhLQ/duUEfYkZXftcr2PV7l37BRSTYMYsS7?=
 =?us-ascii?Q?fJJgTIQQt/s9tfsEXe0KfiqTVO9eEx6+3F7U9hykj6TsNBRR/MwkPnyokBLT?=
 =?us-ascii?Q?aysgc5+Jx1iL+gP8xoldwU3gXJvBmkdjVh1fQgG0sEEp15SRid6lMmzJoEQp?=
 =?us-ascii?Q?kuYB7Jd+cbcrniaYGvRGq5eTqSmhtAfkYeQBjMnM+Lpp0a8Tgi2R5EuZbky7?=
 =?us-ascii?Q?l9JYNaQ/+WP2YRy83wlP5dGmZ3k2xybZF9rbYMiZuxBuC2dpYWg4pVlc51u9?=
 =?us-ascii?Q?613omIqsoSN4yvpHLcQj2Q5X8VD1rqedOOp3RMeGOAEyjfM3/Ug2O/z0rUFC?=
 =?us-ascii?Q?U9JlMB1nHN+1/M5n/Gd9KFFk4RuG2RHpcNmDFbLf3cKs59vS/IjG7HAVbxYt?=
 =?us-ascii?Q?irJvUB7GZw1F/zwYRozTfVNofLFJuA++YBvNwFGPJnvjYiOXqtqWsjxzvNGI?=
 =?us-ascii?Q?NXGtwvfGVQWAHzwwBoXczVHnWtLHYeLMgJDer0uV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2257274-788b-456e-f932-08dc522c1816
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2024 09:14:11.9517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HaQdeHcYTFVdp/ERhyY33fHWnbUBebhOZPP+5VKRv7G98iHb5N0gt6p/ltKwNWA6VSnPZJMGexjHCpkJzzNo9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5140
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:45AM -0800, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>When BIOS eMCA MCE-SMI morphing is enabled, the #MC is morphed to MSMI
>(Machine Check System Management Interrupt).  Then the SMI causes TD exit
>with the read reason of EXIT_REASON_OTHER_SMI with MSMI bit set in the exit
>qualification to KVM instead of EXIT_REASON_EXCEPTION_NMI with MC
>exception.
>
>Handle EXIT_REASON_OTHER_SMI with MSMI bit set in the exit qualification as
>MCE(Machine Check Exception) happened during TD guest running.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
> arch/x86/kvm/vmx/tdx.c      | 40 ++++++++++++++++++++++++++++++++++---
> arch/x86/kvm/vmx/tdx_arch.h |  2 ++
> 2 files changed, 39 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index bdd74682b474..117c2315f087 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -916,6 +916,30 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> 						     tdexit_intr_info(vcpu));
> 	else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
> 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
>+	else if (unlikely(tdx->exit_reason.non_recoverable ||
>+		 tdx->exit_reason.error)) {

why not just:
	else if (tdx->exit_reason.basic == EXIT_REASON_OTHER_SMI) {


i.e., does EXIT_REASON_OTHER_SMI imply exit_reason.non_recoverable or
exit_reason.error?

>+		/*
>+		 * The only reason it gets EXIT_REASON_OTHER_SMI is there is an
>+		 * #MSMI(Machine Check System Management Interrupt) with
>+		 * exit_qualification bit 0 set in TD guest.
>+		 * The #MSMI is delivered right after SEAMCALL returns,
>+		 * and an #MC is delivered to host kernel after SMI handler
>+		 * returns.
>+		 *
>+		 * The #MC right after SEAMCALL is fixed up and skipped in #MC

Looks fixing up and skipping #MC on the first instruction after TD-exit is
missing in v19?

>+		 * handler because it's an #MC happens in TD guest we cannot
>+		 * handle it with host's context.
>+		 *
>+		 * Call KVM's machine check handler explicitly here.
>+		 */
>+		if (tdx->exit_reason.basic == EXIT_REASON_OTHER_SMI) {
>+			unsigned long exit_qual;
>+
>+			exit_qual = tdexit_exit_qual(vcpu);
>+			if (exit_qual & TD_EXIT_OTHER_SMI_IS_MSMI)

>+				kvm_machine_check();
>+		}
>+	}
> }
> 
> static int tdx_handle_exception(struct kvm_vcpu *vcpu)
>@@ -1381,6 +1405,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> 			      exit_reason.full, exit_reason.basic,
> 			      to_kvm_tdx(vcpu->kvm)->hkid,
> 			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
>+
>+		/*
>+		 * tdx_handle_exit_irqoff() handled EXIT_REASON_OTHER_SMI.  It
>+		 * must be handled before enabling preemption because it's #MC.
>+		 */

Then EXIT_REASON_OTHER_SMI is handled, why still go to unhandled_exit?

> 		goto unhandled_exit;
> 	}
> 
>@@ -1419,9 +1448,14 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> 		return tdx_handle_ept_misconfig(vcpu);
> 	case EXIT_REASON_OTHER_SMI:
> 		/*
>-		 * If reach here, it's not a Machine Check System Management
>-		 * Interrupt(MSMI).  #SMI is delivered and handled right after
>-		 * SEAMRET, nothing needs to be done in KVM.
>+		 * Unlike VMX, all the SMI in SEAM non-root mode (i.e. when
>+		 * TD guest vcpu is running) will cause TD exit to TDX module,
>+		 * then SEAMRET to KVM. Once it exits to KVM, SMI is delivered
>+		 * and handled right away.
>+		 *
>+		 * - If it's an Machine Check System Management Interrupt
>+		 *   (MSMI), it's handled above due to non_recoverable bit set.
>+		 * - If it's not an MSMI, don't need to do anything here.

This corrects a comment added in patch 100. Maybe we can just merge patch 100 into 
this one?

> 		 */
> 		return 1;
> 	default:
>diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
>index efc3c61c14ab..87ef22e9cd49 100644
>--- a/arch/x86/kvm/vmx/tdx_arch.h
>+++ b/arch/x86/kvm/vmx/tdx_arch.h
>@@ -42,6 +42,8 @@
> #define TDH_VP_WR			43
> #define TDH_SYS_LP_SHUTDOWN		44
> 
>+#define TD_EXIT_OTHER_SMI_IS_MSMI	BIT(1)
>+
> /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
> #define TDX_NON_ARCH			BIT_ULL(63)
> #define TDX_CLASS_SHIFT			56
>-- 
>2.25.1
>
>

