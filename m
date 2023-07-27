Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731A7764A38
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 10:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjG0IHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 04:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbjG0IHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 04:07:10 -0400
Received: from mgamail.intel.com (unknown [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF4B30FE;
        Thu, 27 Jul 2023 01:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690445041; x=1721981041;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=B9t+GiJiXHZAobjyBO9plDWdykr1KhrnNLkEy76VKV8=;
  b=hEFebK49iaKRdRyB0UpkYF0b+HtlgaKza5hEmUTfbz5Gh+cjY2sYOAvK
   V6g3li8n+Zb/FUrmsSpCeKbccqgSk/X6jpaH1e01MelZvHIrfdc02zp/I
   h6k9FB7IsmMGHEFa3L78va4r7oJevvZtOVb7ZHVACgAbCgey8T2zfkLsO
   efvdFhNpO5osSZ1RI1rJQS9Cm8ArRpi80RrqOF+LlpB1DMH45e/ZuQaP6
   /GBTi5goZ3iaBZRRw+xuDfu39TdrutGmydnEVt4BF0rLeETEwbR9E5X6x
   zhaIh4Y12JUhbVNvE2bbjpgbABNhr74TrXLVUvtm9roSdFAydxCn5haEh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399180617"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="399180617"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 01:03:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="850768108"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="850768108"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 27 Jul 2023 01:03:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 01:03:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 01:03:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 01:03:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 01:03:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNXL73zI0QpOnmRUvTvrv/I/UpiOsxv+6UEV/7YfUtq85Rb4APCmiQtTxZ10wsHMjnW3ptdHuTQ4Jl5M0PxjVXHqXCKvXzRVx/amigA63Np7lO5wJCRWhWoNPpqldRuMM5Q2WoDNJ+GY4B193+9ObR+dwxFvBpBsEB4XiBg4UxgH8R6lnPbWTY0TiLDUz2Hops+STAw6x7T+75z+aCbdx6Ohu021AU/Sg45eI0DHeHHNwfr+PD8oLAzieT2EGgLDPcW6Mt692MG4X4dvLOenYZhIi0E0RXimx7hBY9LhIRTMGs//M43V08UzZ2u8NYzmxlCn3tsXvfC4vMJgzFheMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsVVBq3F72rxbXJOUIGc9XxHpauxfM3gDoh65kGFXLs=;
 b=ZFq1x9gVHbJFnwBS875Vjd8yBBZUEnEZouLVG6p8fgj+KdTU1pMPnoVzQp47skVPrUcwXzlNKKhqOhld8fiQRu3Vg60Yb1Irk23IDIR24H8bVsgn+ZHsyNDAsQpIkQuE5H0dWuGKP7FxxFb7XGNgHaItdRhatb+d0zL3HSVu7/AYt5J2kSSc8c3Uuf98vuMiC6Up7sm6PobhEPrPeeAuzdutYSWQS89Kisumn/xIncVqanv3rSO/O1cIX4jYfHkxDxzUiSvl571lmVzNhqSrj8RihR4MxneKKgEU3IrbITcjUsB67WlW/P7seL9VtPGVO+PShKM6CVtLTguM7dqi+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM4PR11MB7327.namprd11.prod.outlook.com (2603:10b6:8:105::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 08:03:33 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 08:03:32 +0000
Date:   Thu, 27 Jul 2023 16:03:21 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 18/20] KVM:x86: Enable guest CET supervisor xstate bit
 support
Message-ID: <ZMIkyaPk7Af2elam@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-19-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-19-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR06CA0014.apcprd06.prod.outlook.com
 (2603:1096:4:186::11) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM4PR11MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: db9f87c4-59a5-4224-0cb8-08db8e77f88b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n2c5t6D+BExfjNa/iBMPtaJJ3ej0vWcxrXCBkQey7NaGmcRouOyOi6ELKfarzdcqZeMLhD48AUiGdGz0Ey/JkfGEnpliQL1Pyc22tRylG0rEKQbsLrmWN5nSADbzZE2F8R6A9a0dbcptsTdK1o0q1HiOoX5hmjjYRo7kp5sF12XioXFGpfBrJn4R5+PpE13mel5jkun8mFIeQxO7wqKZmYRBZhWxwmSRGISNdbMInG8YW5s9qGuvdPPuqzbjS223eTh731XVXSw/E8IK1NT/baEwwEZS5WvanuVV/xnC3vf39cIUtemKEJWaLygPk32HCL/GNElx5J+aDi5o/Zo5PC0rBtjugTszv5RfeW/F0Md/3sKNpogJfThpmzaRChtdUIa25RwwtLR0zWcAhA/MpzcuwbFUrbAy+wQXKEBWEspXxvzYJlLESIdfIW4Hy1TiXfeYuRg8/x+n6xVAB3CrcK79w+Itu06AbFpNjx9aBEJMHnKcGWx0uj4VVKkC4hoeSCIrvo/L5bQPVRilAG5SXBSNofE9CUf7G6P0ijZk2HK/LN707z5Oz9xEjTO6PvcD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199021)(6506007)(26005)(478600001)(82960400001)(186003)(6666004)(6486002)(66556008)(6636002)(66476007)(4326008)(6512007)(9686003)(38100700002)(66946007)(4744005)(5660300002)(44832011)(33716001)(41300700001)(316002)(2906002)(6862004)(8676002)(8936002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fIzXwwt5o5BHqJUHKpH98F77UnkhJQEqBx71Pp1VsIKRCjqLHTs8yzReX6qy?=
 =?us-ascii?Q?HhEtXtBM5wyKDTpvf5PN2NDGYpbKbkniAeLhzirjeacEgS7mBwQOYCid6QzQ?=
 =?us-ascii?Q?pMTxJYO4LDqByloRjFekcCqpRTLzeQW1zeRUBqWdWvTfjT2WkTPmWT7aERKm?=
 =?us-ascii?Q?CTcYSt9sjodrjr1sIdCXm++FU1uHT59LaoIGSgDOwjfITjSFHicL/DwWtN0I?=
 =?us-ascii?Q?7wqcgjDwDhN/ExKrwgMjmOpgBT3Ke1exr3qQaIXlTs2bJ2qAN+cakCLT8ibq?=
 =?us-ascii?Q?Mzk7VPn9qSOQwSPCxenlFsNkfDZ/6pjfNC4trBS5BGdeVwIUylLQWIATwDvM?=
 =?us-ascii?Q?22tLMp1iY+qrRo7JcZUq4ODrfc1AhZT8wDOYIt5qZtD31POfbavH/KOLfjPA?=
 =?us-ascii?Q?q1f3HCiVDgzkphWQ1q3nTaVNrldyElX/cDDFANLSMuxvkCtT75uvw1feyWzj?=
 =?us-ascii?Q?iO5RWUYtYGuiTVfoqNpYqZ3Rc9hUG1WykldIzyosazsjdIXbvXCTgbK2PXWy?=
 =?us-ascii?Q?Yc7aHE7OFklae2HHQi355EYaZ9C49ItwuS1KqgYekET+Yoha5PIq+A5hMsnJ?=
 =?us-ascii?Q?rwQeKuhUT7N5Vn4le6aZUvKcUbew1AnDnDwE+KIkdye0HCIxO8IbiezpyWUK?=
 =?us-ascii?Q?YsTuwQlXpoyTONw7U0m1xXrwFFiO6ICIQjHCRXbVnAIbSCV6kH4e0jhzM5wR?=
 =?us-ascii?Q?8toBOSd1LloGOIOvC9fTYpK2Z24haXUHL8dwX7V3fLrpmjQhxGVvCgtLwx3P?=
 =?us-ascii?Q?vpMQseP/H7+NWyu3kBN3QdjDzCfi0eUE2Cp+oh3EU1/NIke7jHuYLfL2zLcy?=
 =?us-ascii?Q?xRy+TCRQF4wF9fQLMLiegFPYFEF+foh4jxIG6JgYqfF2nMGDuWuEIaM6/9g1?=
 =?us-ascii?Q?mQHeoNmUNhrSwlxComUKtpvBtkC/B6RI+tPdD18y9zTIU1dvOyXv0lX3dCpz?=
 =?us-ascii?Q?Pe0oMPElngA7+Mq6f5v+Cp3jR3jVzDAiqwwYV0Lop4IZFeo/tMlEKQqNRUHZ?=
 =?us-ascii?Q?BNGomuI9TKBF4ftRh1bY2RSj6/OT5zQXUUByHrfwo0FDS9xbrFgfcj3cMNVx?=
 =?us-ascii?Q?tjg4XsrDdqAmPlbyuk0ZT8ytzfqy153pSqsFZgsJ43ycpEYMBc4SlPN8tE8R?=
 =?us-ascii?Q?ylPT3by9ecuu/9Kd5GvvHE9fI50iSxW5+vKezDcOymLceQoWOdsMc6Cq76lM?=
 =?us-ascii?Q?8R/4Y4wvkgGmlbHKpOqV4mP25e9kK5uawx5DZ7+Caj5imZEaKlP9qEW41I4F?=
 =?us-ascii?Q?0woSzlD5FlhTFiyUTLhs3l50dJsUGJPNXMo3WSWTIh4BFNM+1UMhHVP7nveh?=
 =?us-ascii?Q?+xXzsiWceocNCgdWuVEg+XWl7sMr/JRQeWaL6x1fcctVKHv7aIkCE8lEfv0l?=
 =?us-ascii?Q?7qR5tpdl73m9d9+KYjO2qSj9ihyaHKwdMH2WbQgig9IMwWslMlpnMiKkNhk0?=
 =?us-ascii?Q?1DrkcJxXPiL0IXOz9NcLX/qcIQh/+ENC4DEG6piIR/N5Eg8iT91SuN5VVZY2?=
 =?us-ascii?Q?1XJhoqX4Z+nlCmXYCv0bv6WcO+DZSE/pxO+ZRCKTn8pVQymq0bJPYgzwm/yL?=
 =?us-ascii?Q?LBZHIerJiyfakSXRkxAlAZvh7yN6Yc3nbYcHyzRI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db9f87c4-59a5-4224-0cb8-08db8e77f88b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 08:03:32.6047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvCQNtgbW2BQIRePrHxoDukXgOnfeTKptqyiuvWJ8t0AmRP6ofiFgyBO/zzHiedoNPi6zVlR5aPW2Z8lc5j0vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7327
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 11:03:50PM -0400, Yang Weijiang wrote:
> 
> u64 __read_mostly host_efer;
> EXPORT_SYMBOL_GPL(host_efer);
>@@ -9638,6 +9639,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> 	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
> 		rdmsrl(MSR_IA32_XSS, host_xss);
> 		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;

>+		kvm_caps.supported_xss |= XFEATURE_MASK_CET_KERNEL;

Hardware may not support S_CET state management via XSAVES. we need to
consult CPUID.0xD.1[bit12].
