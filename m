Return-Path: <kvm+bounces-7004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4F883C04D
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 12:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09A3F1F21694
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 11:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E5C57301;
	Thu, 25 Jan 2024 10:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gaaLsVnq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798AB23764;
	Thu, 25 Jan 2024 10:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706180277; cv=fail; b=fMIarZgGiJVYVHZEpYBOIc4PNEwziSzcIZxTxNvgZrM/fFPeRrhxym6USH5a93PsRCsCuQrrXY2Ks14b9eNBtRKsUNcFyvvwpAF1YwBrHLNnonMOcVAfkn7fmiy4xnpRX6CdYuNBXggyZyVC7Gcz3ms8imKVwkFr+vZZamaqJwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706180277; c=relaxed/simple;
	bh=cnnqbVaVzuEr3e/L5lmFMLfBPelDj3KJHuN/a4Jkfh4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ogFxpzidUlF4g1prgxC2dR4IS60myo1Z5iou4uLVgTEywcncI9kRLYjCfGrE5O6+ICqYes+Pv5A/sSFyQswNs/PfG33O/DJrqI8cGtkzmp8IlwewewGGQ7Kqe6guFz/BVRKrrLW0y5asgC7fFzeqMlN5sdsk4Nia98pmcW1QDeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gaaLsVnq; arc=fail smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706180275; x=1737716275;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cnnqbVaVzuEr3e/L5lmFMLfBPelDj3KJHuN/a4Jkfh4=;
  b=gaaLsVnq44ihjWFT/ndqj1xOQyCwahCZ1IBV/BvlaFaeVWy/hDyohVee
   51xRBZ2aii4DC7bTV3izlxr2XT96dc14PIvv8SJ1Ivy1FinaDFl05UXQ2
   SfKOmcAS1ELrrJKiKYnCmMcvqnMn5uKB6lb0rZfxF07viUjXEl68ifCLr
   h26TjZcbLErvdC6MKVv6SXtIUUlOX9qG6YZ8wDxnn2TOFrHwRm0ecVdU3
   F6TKRLw06FG2eL7sXiUKBghqmy9W9c1FHgS2eUGLSFpr/+jv/BQa8xRkm
   YASZfaUovMdvwwPLUHwRp/RzqMqgz7Zw69GIIm1lXHyK1yiZK4F6tHyBR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400984773"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="400984773"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 02:57:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="909961275"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="909961275"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 02:57:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 02:57:54 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 02:57:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 02:57:53 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 02:57:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0VrmJMZp8AGBY7nK6+fuFwOYSw41UB6G7cJFj3MDIeMpJYpfbTUkdy7FFLhVd9GJb+fbEJQT8BEVan7E3RNqjqmDsM4S4nQL/+kU1pvFuI0PsOsIgf9/6C/ojUez8wAvyh60Aca2liONKEdFSsEBBwoOx4rpKsvJb5wNsmuI+AnZd0lEVPHy1N1N8/29ktrMKqJ6dAeNnH2QN6zWcjQfzhVTIFG55KUDJ+8VOcp4b1d5q+yQQMArVY0gzGsRIH7iv7paJjeUU14AkTb1b/2iOrN3XPeoAb1WZ8PqZ3WhlrkfOLrDX9ufm10z87Q5C05n68i0VImELfLR0rhoO9aJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yD70qJsR2xf202d7eZ3Qeb5VbswBdxD6FcNY6swB2oQ=;
 b=a+I1tKsoyX8YQQkbc5q2ec9WiySLV2jgj5znBrfru+XOBmkXwsyIRSwS9EYg31+R4Z+QWclrivMlYy1iQwRe6xzn3ZucJoEtbEgLMZez5YBcW9tCixXZJMvo35KbsER0xit/Y28CEiPmVd9h+Oly3CFk3tRZBTzTgvg35iOEsyev/KOIAtDBLq37APJVRqtLVRpU9WDkY+Hh4bEMGg439C7PCVmbEXW8ZhZREwo1ngpW/JOFc1KpdnMcWsIU7I2foaTrvGNxR3SEarF338rUzRwHhe7iosBifwbQhL+FYFck3IACB8oPRxOjGCn6M+GtAjbkeWw/9iM67NVxkAzVkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7917.namprd11.prod.outlook.com (2603:10b6:208:3fe::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 10:57:51 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7202.034; Thu, 25 Jan 2024
 10:57:51 +0000
Date: Thu, 25 Jan 2024 18:57:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>,
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v9 13/27] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Message-ID: <ZbI+pexl9Th0KiiU@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-14-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-14-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::7)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7917:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dec3e59-7168-4ce9-6f7d-08dc1d94797d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WsjUvfU1i0YpP7fxg/y0Bh1VZzhbGa3eYSqk/FjqBScsx67Ek2NrJOKP+Yb/mOJe7ny4ddLs25XpB3+yQ5ou8rvRWdRDfbcfSpGrXw3anGgmZ35hqBRtX70Y6gVUYMQO2GuIC8hEPk/MJSeidzH5ZGF5eZZSET71gSmHuQVz6TOdIAVCYB9ewEo1A33eKTF0z2UNkkhcO0Q7e7ETeWANZYqQ9TLl2sfhpEywrHq/hADUH/dvgzvE3NKq4/CLIflAM/dfhla+IWu+P+WkjEiBFNybKQp/e/A/SyeujyXKGzjSxHd3a8RDWNnBtZq04U4n7czwpKBk6b2xcO/qa1LtIuLPzCKIUAk3A3E0jQIEV9qttJpa+OKbkhhYIMDlrfmJvCbkf26u7D0rw8pCvwHaVJP0zMoSvKn9Y4jmicEkF8qZks4EXcqOJIUGF5nhe0HzpOmACl9IZCnTtKXLSSB1Vr6ENjIIwaNj4pGJJ8uljNtfdld6wUUv8VHOeErPuS7SXm9t+u9VuSYcJK3pr8c/+g4FJTvq+2yZxpv37FxFJ+f9vkVTuEKCmCDWaNzidv5pj57+JGM/MTtEDTy2f7Om0MQqerhGLJ4mGrfVBhAJTPw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(396003)(39860400002)(346002)(136003)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(6636002)(26005)(41300700001)(38100700002)(82960400001)(478600001)(6506007)(6486002)(86362001)(33716001)(4326008)(6862004)(8676002)(6666004)(316002)(66946007)(7416002)(66476007)(66556008)(8936002)(5660300002)(83380400001)(44832011)(2906002)(6512007)(9686003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q+x0+wdSjMB8ZMijXNrsClL2bDcEfwseicuvM48q5SCngfmrDtxlHcsOrKHO?=
 =?us-ascii?Q?QkSmyD3dEqiFYaJrVSsOrQvxcWPNhiAtEoMaGCumSr5oS1KiMMQ3zMN+4hsT?=
 =?us-ascii?Q?9zeQoKEOeR8158K5BH4t3yN3p6HW7xnEeUuqxlvJVwIh+HL2BQu717Y1sIXI?=
 =?us-ascii?Q?1l9Tk62QMHzVai7qzJX3u//bqbKRP3U3y2BCyqGENHCS94xW5Y1TSwaZO/N/?=
 =?us-ascii?Q?tyIOCoq4AkJU+Wtl+dpGcSbbzJK3Z6toi/SPRANlL7CmYB+1JEHT4J4kOtD6?=
 =?us-ascii?Q?68HJ8JkntI9a1L2ckKL1fB2wwHGOe8p0qjFU+cRmw+wjnKjUR8oe0N6Ij3gp?=
 =?us-ascii?Q?tjGvps/PdZG2e1FfXUhyJDd/aHTGZTmeOF5SlFXGT2s7Uf7f/xbYlFr8f4yy?=
 =?us-ascii?Q?gedeLMzKoSKTZ1OQEoOwEA1q5w5NRmu9ZBRRBF119A/lRBSpQT1GXpJkdduv?=
 =?us-ascii?Q?UwOkIR2xMTK0akvq4p9msUv35zHVcb2JmsDe67/ZnG3XnJs7exwYCvsA3nP2?=
 =?us-ascii?Q?F1PS4a0WrnWmiTPXJChUjw6Li1u6ZRfRNbnNyjy7y9BJ/gycQK5b3/cW2YX+?=
 =?us-ascii?Q?SF60BEC2g8thQXElCn90loS68/BYUnfItAMw0BXcytKMWYMaLA4nz/gZYpTB?=
 =?us-ascii?Q?9t9rLw66ksMDQndfrRijRC0pD9hlXUrFpnqnhG++kSJLh2NLVQC8Knj9nSGG?=
 =?us-ascii?Q?LuRpf4iDANiBaeuUfCCjf+MO5rTeAXZ3kP+ci8OFdf9Nvj6nnMfAFbdhqXSG?=
 =?us-ascii?Q?G2DJ5YhomEJQRF7dwDgI8+Yg++eNp/e0v+QUoy+aWFEP2OxnzVElZsBde9vO?=
 =?us-ascii?Q?MHH4S7cNIuwVhzRFaG7pAlZqHbIx810KCwvJrPjau5R1e7SfEHqD0J+rQ7B/?=
 =?us-ascii?Q?OZ5IRXLDhlWhTn7228ravsPBA/Jx6IT6ulwT8QJ2gB7Vg4cTrfaOAYEmnPb9?=
 =?us-ascii?Q?GZ9Al7yz9HhxaKCby2J79XBHUZ6Z0E081J6wHbEjg7Q6t0n9FnNrj4VBibHt?=
 =?us-ascii?Q?ylbptsBrVcNhaxJuLhzAx6blw4WTcSpwkufwBqfAcDv1GjSfnA+PfXeEsYS1?=
 =?us-ascii?Q?jAmXCc4wzB6TaVDZSjRIdlg7phNRvMjVyWBVSJsH/8oH3XHC0XxqBfI5BbhI?=
 =?us-ascii?Q?nuzCvmjczcRNfKOtnn1kgRBppX8lpXS972SMFQglPhsrq2c7KeQxoohQs5OX?=
 =?us-ascii?Q?1SfPPCHq+rnJw/+7wWKgs/Hpt3dsSsBOGc1mca7+sDEugggE5kZ0+8l6bZNf?=
 =?us-ascii?Q?OyAdqDW4ZCUHuPvajso1/FLh/v/MtdiQ9Lt8bhDkHE3ZAP5je1KQxgHdX3wt?=
 =?us-ascii?Q?3JzjE7/fd7rcut6wQ/gqX0DpSsyhIXCij8YpAjaoyDiuTw0VFf9HP1CpEP0R?=
 =?us-ascii?Q?yE+XGcKT1bOS5aoNgD4BQVLu+MqkHifGOt+FgJWVq8Q+LHRN5waCYpk46ay6?=
 =?us-ascii?Q?zldDt75Vk5i4FU9Sl4iJH1H8nfx/pQx1qXdoVdm2y7nT2OC+CmPu1UdBwKTP?=
 =?us-ascii?Q?GiT631XUOEg2UDBGA+LkVVKUuAMBJOv4EIRf5ibP5De4ZXMnZL7eW3j7coQj?=
 =?us-ascii?Q?7VPJWhD1ludDjBAbNvRi3Ww9icfP0lUfS3AnQSzd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dec3e59-7168-4ce9-6f7d-08dc1d94797d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 10:57:51.4073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDmfRnKSmCB6DG0EY5x5S/Of81fUd/JITZnCc0IlcJvNMn3pIzOo2A0Dp+uGcNPfPqHDj1P2Q4nnX9COXdGYeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7917
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:46PM -0800, Yang Weijiang wrote:
>Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
>due to XSS MSR modification.
>CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
>xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
>before allocate sufficient xsave buffer.
>
>Note, KVM does not yet support any XSS based features, i.e. supported_xss
>is guaranteed to be zero at this time.
>
>Opportunistically modify XSS write access logic as:
>If XSAVES is not enabled in the guest CPUID, forbid setting IA32_XSS msr
>to anything but 0, even if the write is host initiated.

any reason to allow host to write 0? looks we are not doing this for many
other MSRs.

>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>---
> arch/x86/include/asm/kvm_host.h |  3 ++-
> arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
> arch/x86/kvm/x86.c              | 16 ++++++++++++----
> 3 files changed, 28 insertions(+), 6 deletions(-)
>
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 40dd796ea085..6efaaaa15945 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -772,7 +772,6 @@ struct kvm_vcpu_arch {
> 	bool at_instruction_boundary;
> 	bool tpr_access_reporting;
> 	bool xfd_no_write_intercept;
>-	u64 ia32_xss;
> 	u64 microcode_version;
> 	u64 arch_capabilities;
> 	u64 perf_capabilities;
>@@ -828,6 +827,8 @@ struct kvm_vcpu_arch {
> 
> 	u64 xcr0;
> 	u64 guest_supported_xcr0;
>+	u64 guest_supported_xss;
>+	u64 ia32_xss;
> 
> 	struct kvm_pio_request pio;
> 	void *pio_data;
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index acc360c76318..3ab133530573 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -275,7 +275,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
> 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
> 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>+		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
>+						 vcpu->arch.ia32_xss, true);
> 
> 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
> 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>@@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
> 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
> }
> 
>+static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
>+{
>+	struct kvm_cpuid_entry2 *best;
>+
>+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
>+	if (!best)
>+		return 0;
>+
>+	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
>+}
>+
> static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
> {
> #ifdef CONFIG_KVM_HYPERV
>@@ -362,6 +374,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 	}
> 
> 	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
>+	vcpu->arch.guest_supported_xss = vcpu_get_supported_xss(vcpu);
> 
> 	kvm_update_pv_runtime(vcpu);
> 
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index b3a39886e418..7b7a15aab3aa 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -3924,20 +3924,28 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 			vcpu->arch.ia32_tsc_adjust_msr += adj;
> 		}
> 		break;
>-	case MSR_IA32_XSS:
>-		if (!msr_info->host_initiated &&
>-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>+	case MSR_IA32_XSS: {

unnecessary bracket.

>+		/*
>+		 * If KVM reported support of XSS MSR, even guest CPUID doesn't

IIUC, below code doesn't check if KVM reported support of XSS MSR. so, the comment
doesn't match what the code does.

>+		 * support XSAVES, still allow userspace to set default value(0)
>+		 * to this MSR.
>+		 */
>+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
>+		    !(msr_info->host_initiated && data == 0))
> 			return 1;
> 		/*
> 		 * KVM supports exposing PT to the guest, but does not support
> 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
> 		 * XSAVES/XRSTORS to save/restore PT MSRs.
> 		 */
>-		if (data & ~kvm_caps.supported_xss)
>+		if (data & ~vcpu->arch.guest_supported_xss)
> 			return 1;
>+		if (vcpu->arch.ia32_xss == data)
>+			break;
> 		vcpu->arch.ia32_xss = data;
> 		kvm_update_cpuid_runtime(vcpu);
> 		break;
>+	}
> 	case MSR_SMI_COUNT:
> 		if (!msr_info->host_initiated)
> 			return 1;
>-- 
>2.39.3
>

