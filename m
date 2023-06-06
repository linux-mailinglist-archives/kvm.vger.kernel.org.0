Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CED723BF6
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 10:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbjFFIie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 04:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjFFIic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 04:38:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958BEAF;
        Tue,  6 Jun 2023 01:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686040711; x=1717576711;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Uu+24R346wZzyP/X0UqDIFKKct6JPRsQLSQXg3Tutpo=;
  b=duOEP6EcW06WcWo7ZGVGGvbKWoH7GRvkmXmodsOoMOPyX9tqvNo/Sf3D
   eFjF2ZVi3+5Y+GttdzCS3iX2d4dV3Ef/WDRAOoGjNyH4rSxutgmq1Ygi2
   CTcYwpjHqFnS+SK9rpTeRqpJtFH5vapXGTCiosXFrcqB/gW5/bPAf8KuI
   6JC83UNtyamIL3eyn5icuUrqY1c5Zq5TMRxDrkQNzb7b/Cs2SC7TiW/j9
   GZimgwVLXOHJLxGR693K0ESfJSNOp2mrtbBK6E5ACNIrzp3gw3mHXmwSc
   w1dmJhq9YVkQKcvhOhz91n7g39oSd1gxZuvl8CwL2Vtg8Yvga0+Z5nJp1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="422431008"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="422431008"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 01:38:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="659430250"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="659430250"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 06 Jun 2023 01:38:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 01:38:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 01:38:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 01:38:25 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 01:38:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDfxxfBdoxmptK7yzwIuf55eVtsl/zZLAqklyGWg8mAKcF937f4chvcgeCmkOI2DV6h+rdAm9GocwrInT/cQkrEqba/lEarFe/0uR6yJF65CSJ4giTSNZZPlKMZnG6juiKMe0wYLNMjIBlSNyF/FfAaQb+78fBlIkKbDxY4P9cHfj9HsKlAMSODNYFwqm03PXlkW2SE/CmsfcVIKLDM5lv7jMOXTSgIcjlJglFjouNuQFXF0jeQaT0u4J5o/xvTood5Lqw0VHDg7svwnuZAJZgvTriX4fUrpVKsQQCX7XoIJKG36qoN8cmkh63zR90jx6dgMO6H3MUhZakUDCftIJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VeJfbd1BBdFRFFG6P/IPMzHQomnxxn2oAkbMbby1yd4=;
 b=Z4kgnZEJQ6rwtDm8gotnfd2yjeYOh4Uj0iBJIdstEssjE5hOfhCxeAfAMm6s3uU8KU5IUAiJ/s3Cv1XRW+6iC+MEVnZHqkjm+iwm9Oz2fg7FS9xtSAatyxA0WDzQyvRWPknAh/BpWNuxENXtf7XsVe4Qw/azg81vJiAoGclPTKnuubvqzTQhD1Ru1lwqLKNXYjPdMaECFYl/8kCjKp2buHrcUMZ5GdxRdCFZ57eHGIegpG5zeiNvQGBe6/a8YbHiqGw1BIgScsjKBPcYI+OCuK25PwWjIvZ+S7qRiG4CBDDruN12I434Q5qgqd+Ed0LwtjMM9nF7JQv5dvdd0tjf5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MN0PR11MB6229.namprd11.prod.outlook.com (2603:10b6:208:3c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 08:38:22 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 08:38:22 +0000
Date:   Tue, 6 Jun 2023 16:38:11 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v3 08/21] KVM:x86: Init kvm_caps.supported_xss with
 supported feature bits
Message-ID: <ZH7wc4NX66HNqMl9@chao-email>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-9-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230511040857.6094-9-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR01CA0026.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::16) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MN0PR11MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: eddd8bfb-ce77-489a-e36b-08db666962e9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /5bXWK89ehL2uCzfEt58mZTDPWZS6UvYmE9ktetGrSPWITyB8Qmkf7nvVSTtgPAi3UqLHpGdg8SMPY6yW1Ihr2znVfuk3d6IPU/LASEdZETOZA3sdm+Z9ol/ii0LGxpP++a50jUeVFR1jQs2N/HzqF3bJbE5P9v6hdhg/2NiL/a5zT4GVKK6xadCsETXTmS2EnV54vpLhcQGdEUysVY1HPbGwbXcH/eq1ttKguNcQmtAqRImVLKviaRRZB13FV2bacn9fWxVvojw9cdsuIWXZ2MecHNPzjD9jNQeOPdC/bOWy/CaxDr5Sl30I2h/W4RRh93mMMZXZ/xvS9wUalv0LAPA4iPGahYaul5bawvx830ymC/+M72RG7I64D3O4HwQy2HqVrg6OWhegWGqWd54qzv4e3h71iuupX3epxGEJoBXZdnHhk1zpYJwL3hktjNb2fUiWcGG81caAaZpYSmZlyPaeCYNSE+xjGVyxaiRfvD9v9Z3Zd7Scz7kbSYbMZtMyHSKURjQWMbx5o7LVLyoqObcSTVc1IYxbwMpQLfMA3dPQoS8QyZVcaXHymKw+2Uj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199021)(6486002)(6666004)(82960400001)(2906002)(66476007)(66946007)(66556008)(6862004)(44832011)(38100700002)(8936002)(5660300002)(86362001)(8676002)(41300700001)(4326008)(6636002)(316002)(478600001)(26005)(9686003)(6512007)(6506007)(186003)(33716001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r1XxZ/3KVcg0L4YrcUOZmCj2tvxtR0rtGhmIwlVPNbq5YCBDeIg56TonJFTT?=
 =?us-ascii?Q?BNPDm087QRyPb//8aclfTxfutOSt0jksRb9RbmiAazCc9Vqau8FuJ6FfkAJw?=
 =?us-ascii?Q?KCz1iuM2rKPkYENdFN9K5YNzwAutTtp9FR8hL21iKJN5tQh3HZrqZQ/qQ6Tv?=
 =?us-ascii?Q?627JVqq+tdxl6z3Hxbcy0W6V3t3QsUN9qFdYBLoN+iCgU+hPziQ4Y9C3ir00?=
 =?us-ascii?Q?3YUWyaQEcPB0UKY6dxVaQW2OWEgXPujKUZ1EirGbCYDQFuQbQCRFOp9uk2+9?=
 =?us-ascii?Q?UaL2P3vCQWCRCuTv7RXj2S8Og0SJpE8U8i0H30j7U2CK1V5LRdkmOhgly/ce?=
 =?us-ascii?Q?LwMndtBSvSLF4wmoFgQ1jVJ0aAx7qyhN/uoCsZj4KMe+oE7tXQC9aHXAttBL?=
 =?us-ascii?Q?bgdkJkG3yYC2YPG+RTqfznb5mNBVKGp+LVUzNWLfW6Hy8IBMX+eh/juC5jmZ?=
 =?us-ascii?Q?kMQxDBF35/c9YFrPXUzm6pRXIw8aQbJC8udN08jasAuX/9eHxifxWmMZhjvk?=
 =?us-ascii?Q?tGRZ/JDMW/DYBS/VvpsRekbEd4OchsX+oEsQmPvozccIc4VI4sC8WYy+QTbm?=
 =?us-ascii?Q?7RgqIMQZYpNBtp40oVkkcfuaeNdWiZdlzfbJKtsGN9AlFke8tH7X71TDk3w9?=
 =?us-ascii?Q?mIk41m7pRLgJ25CpusuQ7KPFiGz8/GU+qHLp1IQbM6NS9yqOM28RJnfAaoSw?=
 =?us-ascii?Q?/pF+eLewK8O8UiupZsejsGw/j0Ng3bYo9gBabfSMJOcyC1Gl3f4APIJlpzRF?=
 =?us-ascii?Q?7zeDl2iALlHjZmvGCNbkcvJEdQPbabVPeLufvk3ZNmL+6KyNz+oy4RU4Tjog?=
 =?us-ascii?Q?4N9//QQQoU6tOM7GSu1klLSxV0jwy9/AAx67oAYGNFXgkNYCp5xdPxjPUw7W?=
 =?us-ascii?Q?FMBmhQRfM3PgSNYXPlk/rDB7VoZFRYSi760aqTllp8oG2USNN0ntGq1/iR58?=
 =?us-ascii?Q?ge6cBjPObVnTdzIaQo8tfAtK9rwA2yVYVpmdovqTVpqk4QfoLItaKAGBVUKz?=
 =?us-ascii?Q?QPMFOEJTOcOoWURx+jR0uD7KcDhQTWPO9bAFOYqQ8ac0I73uHirs36eoXiWC?=
 =?us-ascii?Q?x4llwaifsFAA2HQ98kTD2yXEMVXJJk3nCYT3VOiiGqcrXDEQTcehsK3QCT5Z?=
 =?us-ascii?Q?7qRloSLYtjXZCjObNO+r7C8xOcYBRWl7KsojQJ4rA0EsIQIQK18JEqzqM1S6?=
 =?us-ascii?Q?LEOUkvQUYzju/EEawsi9YwWmIi0V9gSWeaffepTZtNYp7YfLddf4FSdF6NiY?=
 =?us-ascii?Q?GQDqtmRfgNoBL9nJsSstSf3vyXrehZGv4CcONYdo9qb7zE0YUDior8hsuzWd?=
 =?us-ascii?Q?YtLKBreJlr5ifq0zwloq0krybC1zM+FT0jK9jcv7yTSFR/28ImUbwMxBTuEE?=
 =?us-ascii?Q?wBfCehue+SfyxkAFvCqO/HRpoYEdqwhSJc7St73CoblnMOX6R2yeaTSKgcVl?=
 =?us-ascii?Q?V09ANCLfewLDScabQNecxscN8QdsXXJ8j6OGij49TOfkWHdu6R6SdmNckf+g?=
 =?us-ascii?Q?HOCD3aTx9nZRpW1Ql2huBKvc72g89EzuNDIaXEGZbGcMGxsdcMYIjl1vkRQT?=
 =?us-ascii?Q?OUPPABF/pzXUNOmQCwaLPZSihq9peCnKXk4HM7my?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eddd8bfb-ce77-489a-e36b-08db666962e9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:38:22.1607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+wPUgoDpaE5V3SWg3LdefsgsRsZQu3MAa9jJahSCncMt2rECqXFh2X+1jud7EmLBM0i2Gjb144CjGUVl9bVIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6229
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 12:08:44AM -0400, Yang Weijiang wrote:
>Initialize kvm_caps.supported_xss with host XSS msr value AND XSS mask.
>KVM_SUPPORTED_XSS holds all potential supported feature bits,

>the result
>represents all KVM supported feature bits which is used for swapping guest
>and host FPU contents.

do you mean kvm_caps.supported_xss by "the result"? I don't see how
fpu_swap_kvm_fpstate() uses kvm_caps.supported_xss.

>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/vmx/vmx.c | 1 -
> arch/x86/kvm/x86.c     | 6 +++++-
> 2 files changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 44fb619803b8..c872a5aafa50 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -7806,7 +7806,6 @@ static __init void vmx_set_cpu_caps(void)
> 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
> 
> 	/* CPUID 0xD.1 */
>-	kvm_caps.supported_xss = 0;

AMD has the same statement. Do you need to remove that one?

> 	if (!cpu_has_vmx_xsaves())
> 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
> 
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index ab3360a10933..d2975ca96ac5 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -223,6 +223,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
> 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
> 
>+#define KVM_SUPPORTED_XSS     0
>+
> u64 __read_mostly host_efer;
> EXPORT_SYMBOL_GPL(host_efer);
> 
>@@ -9472,8 +9474,10 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> 
> 	rdmsrl_safe(MSR_EFER, &host_efer);
> 
>-	if (boot_cpu_has(X86_FEATURE_XSAVES))
>+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
> 		rdmsrl(MSR_IA32_XSS, host_xss);
>+		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
>+	}
> 
> 	kvm_init_pmu_capability(ops->pmu_ops);
> 
>-- 
>2.27.0
>
