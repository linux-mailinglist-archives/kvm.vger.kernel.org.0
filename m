Return-Path: <kvm+bounces-280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 006B77DDBE0
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 05:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95102281844
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 04:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317471845;
	Wed,  1 Nov 2023 04:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AhVJsN2x"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853B815AF
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 04:21:51 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF4AB7;
	Tue, 31 Oct 2023 21:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698812506; x=1730348506;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h9x6HcqckduPPqX0A0nJM/81Nj+eFyvUUF5P1CJ0Oyk=;
  b=AhVJsN2xFj1bAaEJqJ8EZb7mOCXVw7ZcdrEdNgEZagREHiOdCZJjKOzs
   TuR9/ylAMHPbj1u0BK5rxvMUdZuuBbEBCV9OEMLFN6BthkP3pCrgUteAH
   ao0PViN4+vbe+b5hOiIFLmfAwo0HF8NnMkRdhuRCEtekit5woYt0a8g88
   qyMOS6OeBJr+TCW0UKCa3XoCFC6PN8RtEwn08AmkJyd0kEDxHslNRjpkY
   8KanzAxUfvIZOQ59jwEcAsOQk34DHK2GVOwlvTeNvI5+m+vjZhzh6EE/p
   Uk+dHaZIOoM88F2qbRMra+qeeK2YkUMM0f5+rrG9zUIZi1Hro3swZhA6F
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="7060405"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="7060405"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 21:21:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="934325835"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="934325835"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 21:21:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 21:21:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 21:21:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 21:21:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 21:21:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTz8BrN31IO7O5blqv93lD0nlVhSaqyDXpNqRmACR2/vk+dmoPWqKK3aIapLItJgSHl/RTZ1C3QlKcSt0GyMHBajBykaac0M2+ZhprayV9Hv6nDEYQCHYQ7s//ubnakQTZUrTJnhdDWq3BRWYcbGfmJ0/ldzv8+02bCopvSIVO+0lsFA9Al5j+LlyoCt4LfP7DU/wbUYjDIl1sm4bBPAVJmiRpu8xZlchF8qidi91DpHNzFLFRFZIRKtLBvGpTX0em2BMRde0XPRhQIvRcX8Pzzo9Hp1sN5VQkqkO7NH3rttmPIUSjTVyIbOvU8wX5PN/4LpdIQB6JBt1v7+hzqwNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmVtWoaOgikjuRx742+DNRKSSyGa9jLC+odBXoVqO8I=;
 b=eOtaNnU0TyvwbOy3BDj6gZNCGIceAZOqzlpLTH50iOpQdc0m9VjMTcgg0pthslw1D89CV0Ialiwjkq8Spfay9QwW9azBWzTjbRNbvLjZsqRxm0XYMFmeYY0R1RY93zwY+OyOB0+b2boUnPudFKUa9RGMcIk0CKjGv1ht/3drpugaRGSWxnt7/QsJhmxPgCjy3az5Ii36FcQeIaN/B87HL2AYsZvCUG9h44qNgys4S1L1d2GnX3Ftb4U9jjrUvtsJlqY7BC+60ZeLfDxlJfNM2D7qdUIYZWhj/exVeXTwsTTlsHdJWxs25SCZwwOJ02u2A17YgWfZS98GMj6ZDBZ3UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CYYPR11MB8306.namprd11.prod.outlook.com (2603:10b6:930:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Wed, 1 Nov
 2023 04:21:42 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::6227:c967:5d1d:2b72]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::6227:c967:5d1d:2b72%5]) with mapi id 15.20.6954.019; Wed, 1 Nov 2023
 04:21:42 +0000
Date: Wed, 1 Nov 2023 12:21:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v6 24/25] KVM: nVMX: Introduce new VMX_BASIC bit for
 event error_code delivery to L1
Message-ID: <ZUHSTEGpdWGjL93M@chao-email>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-25-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230914063325.85503-25-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CYYPR11MB8306:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a3f8eeb-3dbb-4211-b259-08dbda920c7c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dxgayWQP8f0/p9GrXWpqpzqwU/NokD09/cUJAjvcww4Jy2DArChW9xao0hvDU15nuarrxoqJsPl26hXWDBzj7i94ziMZN7pJaF30hfFCqhpqRQxBGNUBGzFlh0YXtLGkdInjuIncuo41No5D5p5llf/dL7V98tNxi/p3zqlxYHxP+5e8d+bPH1mUqd9sJkD3W8P7vzfUxzcZxmunONWcKTvSlRwKZV6wjBafbf9VkyGrBH/PEbaoQrxE0D3aOzoJi0kN0c99LaiygFeqYpgeUE5w1e58i+EnFbDzfym6mBIbeHbxzz7gnvO/W7Za80LStB12YjEBcofh0ZqDWK2pQrg/pw8zaZu+CeoaE2bGEUL1wqJAmLpsm9AnDiYSQANU6nzRL0+RWVh2/y4sg1LxSltZJxUHTaVrOmSX54HOOmQfz9NkWwoJUrrLYcfGpBpRccCfRc0r3jxZ47j9/T5drnAg+K8aYyypyNBI5zTXaDsmyffdoctNvnYYDEmcdaGzPUbIIycz4ymVakfu3giuFKmqi6fvvfj8YcUt/08kaICdOvyMSULi2gCoTu45pMXn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(86362001)(33716001)(82960400001)(6512007)(9686003)(478600001)(6486002)(41300700001)(8676002)(6862004)(4326008)(8936002)(44832011)(6666004)(83380400001)(2906002)(26005)(6506007)(5660300002)(66946007)(6636002)(316002)(66556008)(66476007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RsKzhYdTjfL+PgU4ExVanZmE7EaXVAxbYuR+yJ0YRgZdYYdsWLtBKW4TF+gZ?=
 =?us-ascii?Q?qLL/58UF9J0W+be/RtMsMRsW5jk7GCvzuM+6XUwi95YKWyb2Ph7qJILZ368O?=
 =?us-ascii?Q?lC3wZggkFTEkyvGG4TEDH89wFhbwfi+mCf0nhvALs7f3RAYVb2NDdGjo5OAo?=
 =?us-ascii?Q?WBxFiHVKHVF0uWXQCE5Z99pAJnVq1mUtrAohoXHY/reQ0UckfrUmNir06fi1?=
 =?us-ascii?Q?4qY/ZddftnNvfcjE4KUC9LeWxd+2AXIDvvuZ0Guf5hTaVKYAhRykExMy7Qvg?=
 =?us-ascii?Q?zFQmibNkx3a8c2Ln//LFaOJVvTKvJPbDO5JCr2Fepy/JI+Ukznbyk8mBPkE8?=
 =?us-ascii?Q?9hmIDMO7J714X5jI3NG+nJPYf7NdviAgdTa1ce4xqnk5rbc6PdpHin3xLEkB?=
 =?us-ascii?Q?fXyI2Bpa8vBt75NEPnMy7i4pnDPyEsG4rQ+OFikvX2UudJO61REq3TiJQDz7?=
 =?us-ascii?Q?RtB/fhoTkbVS5rcSslAbKm+/8wMp4tJ6yfgPpSmYWYCW+P8Nx6Tydax5LR5I?=
 =?us-ascii?Q?W4TCXt+BePjK2U43Lb9TVbvI3C7bN3B4Tv5FqJnEUB541TNacn7zY9lH8m81?=
 =?us-ascii?Q?uNU7scer1EX69jptLFikwZUhHii1YNUE99titz84GjNRFoGOtB3hJzHEew/S?=
 =?us-ascii?Q?+1LJghHyrhz56uc61O60sK3zODlYd1ChDmJ5BSuC8eg/D88/NmpNZjOdnNc5?=
 =?us-ascii?Q?DME//PX3lRf9vP6g4QPU02RWT1TCrqeCl7ORS42kWQQnvuB7nWEiFdYCEMwJ?=
 =?us-ascii?Q?kyckhD3cdd+VzsnTjB19DwgGaiaJnfId+dHkeHfH99kH3fNs2VMmGs5W77da?=
 =?us-ascii?Q?Eye1BvDETX0tFJiGD+ug/QN9OlHeJ6+ZglR1n5+D6kbiKdl6UTURA+DIdW9Y?=
 =?us-ascii?Q?P0h4AETIu2cQJ87aPDZaimRThWI8R6CeCq3bHmvQ1f0bjZ5CmnBOsCNXy8QM?=
 =?us-ascii?Q?w4dUBfd2SigHvOoFKon1CXLkm7G0BUSnPU7oXvZeD+gTJ+nurFwJndYJcp9A?=
 =?us-ascii?Q?o0MI5g6RsydQ+oKwksLWRwKcbK/ckHM5NVMGLCybFZx9b/QsJdWM0n/NWwB7?=
 =?us-ascii?Q?cio2CdqKs00AcGoRsKYD4daAKgoqX2GUz45a/tKfoa8oDkug7DGYbTsMygM2?=
 =?us-ascii?Q?Jb2NvcwGtYwcvlZDrwa/yTt+VGzo4si5djfm5EEs9d7tQjILv6uRkL4ATeWi?=
 =?us-ascii?Q?9actmHAw713xpL+V87xCwPK+1SJ0J/MchK2rC4MYQrGiYmZSdAIghHFhwgh3?=
 =?us-ascii?Q?4L6CHqiddCkFfTAO+67KwggXT5WpyIU9nAfbo1NC7Ppvdjyg3VCo5e2pisJ5?=
 =?us-ascii?Q?1P2gIgbXCm5c+aTUFjLl53p9Xed2doNs4Ul0gMLlyi47PlwBdH9dLtN3igsn?=
 =?us-ascii?Q?PXifZ5Z9aU5xH7eKfB6WpVKiyM7TASR2nkEEnLNTYZcgUOUmSdcXIV7Fjij8?=
 =?us-ascii?Q?YCSCotWiVrpDY4+chJTxAkbSCY+gZ0TjADSACNW/6z5Yeci2VfRE+cZTid9h?=
 =?us-ascii?Q?M0d7S3Em3e4+0r9wbcZyV7C/LOfAZ279T9RuI4r3RwHYtFdiShm9vb82RKgO?=
 =?us-ascii?Q?2tF6QN28btLZTgpwoG+uZhJCbfd6KD6j6CVgDagC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3f8eeb-3dbb-4211-b259-08dbda920c7c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2023 04:21:41.3945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HXzk5TwGusN1IDJALCesZ9B8NbSTyeH1eWI0RZPFWFC4jfqko+rqxlIRiD/+2LDpfUxPLq1vowK4gifrJXRIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8306
X-OriginatorOrg: intel.com

On Thu, Sep 14, 2023 at 02:33:24AM -0400, Yang Weijiang wrote:
>Per SDM description(Vol.3D, Appendix A.1):
>"If bit 56 is read as 1, software can use VM entry to deliver a hardware
>exception with or without an error code, regardless of vector"
>
>Modify has_error_code check before inject events to nested guest. Only
>enforce the check when guest is in real mode, the exception is not hard
>exception and the platform doesn't enumerate bit56 in VMX_BASIC, in all
>other case ignore the check to make the logic consistent with SDM.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++--------
> arch/x86/kvm/vmx/nested.h |  5 +++++
> 2 files changed, 19 insertions(+), 8 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index c5ec0ef51ff7..78a3be394d00 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -1205,9 +1205,9 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
> {
> 	const u64 feature_and_reserved =
> 		/* feature (except bit 48; see below) */
>-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
>+		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) | BIT_ULL(56) |
> 		/* reserved */
>-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
>+		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 57);
> 	u64 vmx_basic = vmcs_config.nested.basic;
> 
> 	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
>@@ -2846,12 +2846,16 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
> 		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
> 			return -EINVAL;
> 
>-		/* VM-entry interruption-info field: deliver error code */
>-		should_have_error_code =
>-			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
>-			x86_exception_has_error_code(vector);
>-		if (CC(has_error_code != should_have_error_code))
>-			return -EINVAL;
>+		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION ||
>+		    !nested_cpu_has_no_hw_errcode_cc(vcpu)) {
>+			/* VM-entry interruption-info field: deliver error code */
>+			should_have_error_code =
>+				intr_type == INTR_TYPE_HARD_EXCEPTION &&
>+				prot_mode &&
>+				x86_exception_has_error_code(vector);
>+			if (CC(has_error_code != should_have_error_code))
>+				return -EINVAL;
>+		}

prot_mode and intr_type are used twice, making the code a little hard to read.

how about:
		/*
		 * Cannot deliver error code in real mode or if the
		 * interruption type is not hardware exception. For other
		 * cases, do the consistency check only if the vCPU doesn't
		 * enumerate VMX_BASIC_NO_HW_ERROR_CODE_CC.
		 */
		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION) {
			if (CC(has_error_code))
				return -EINVAL;
		} else if (!nested_cpu_has_no_hw_errcode_cc(vcpu)) {
			if (CC(has_error_code != x86_exception_has_error_code(vector)))
				return -EINVAL;
		}

and drop should_have_error_code.

