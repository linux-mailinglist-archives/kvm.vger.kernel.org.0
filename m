Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5640876FBE3
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 10:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbjHDIYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 04:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbjHDIYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 04:24:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13E946A0;
        Fri,  4 Aug 2023 01:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691137443; x=1722673443;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yPOOxfOq3aWXp8S5mq1LmpSv2HFKG/NnUb7Kf4kvu+A=;
  b=Tj46W9Fds4DBEqHyiR4AeG6WXZd7TApLFMZqWFbFkckcwMvmyY7UCxL5
   9RTKLxGi4AVXE4YJREcG+1TbriNCxR2DWS5w50fS4znepRj3dHpH+PNcq
   4LgZQZqzSsxzcNtsFrM9DHA0oW2CwOiDHhCytSr+JNmn604VCkYN9TeL7
   cCySKUZYsZPbpElDhSRX0yWMhsQOVVakud7jHWYb9gubaq/PFtfjnaQUw
   EWAI8OhAcWET18PEx6a1DixE4nzyS+uYhRLbcCVRi1rxQIVthL6JyNQHQ
   TS8vjHPnLgbP+nN5jat8xBA/B3whiWAdS+gJkdQ/3wXW5QWL7SOEg3dvN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="355038111"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="355038111"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 01:24:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="799945502"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="799945502"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 04 Aug 2023 01:24:02 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 01:24:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 01:24:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 01:24:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 01:24:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZERiP7qo5jqxKvOdYfBOBnNF1jcvB/xxN6fapUXZqT0OdtiLGgI7850CEhW4Cn5Pbn/hg7di+L6O2HcG1CryAaZBiYwZGlXyq7531+TjyeyBNwXgrj12Jl04lReeryhrT2UYIyrJ3KAKXSJ958Y2/8YQoSnU9rU04b2Nab/1/d5Fgbn679kjvpHS/e0GIfC67VTVY/r7fA2V3es83tEytsWlg2irJ1bG/K+5+bGFRpe9CWWZwkJc90Px+bIqM87+RQemhD6kAeR8J8VytSyv4HS1Q/adMcolxMu91EGoeUuo6cUsCP8gCycqJbYAxwrsFZ/TjPnokMDzYq1w1Z4dMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPOOxfOq3aWXp8S5mq1LmpSv2HFKG/NnUb7Kf4kvu+A=;
 b=V+Q+jxNUjMBpgF8j2L8JnHjxLX4wb6+dKpevZmRjfSxzAnffm8xHGAIzfokYS47oszenZ4TIbwNrQfOfTXfucUK5etHXtyweKaoeoT7MBepx9Q7dKpzbnXaerRrIn4LmopD7kdM2Bu5p3s1Ro23PQZURw6xUlbIF4xyVLb9qQl2c5ZzzMdVJz1qPYHY7NFTtiISVb59tbn0issjQd/jNceOZozhydXOX0KBq5pMJCtegBx5S0Z9e5m0VMCHUPMztUgXab2b1ntqS2d/NGnzxQounnYbujSmAKS9NXXwfbngs4iKVwtqZf78tA1jhDpZ2fWb0x2iOyluqY+hVMS98uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ1PR11MB6225.namprd11.prod.outlook.com (2603:10b6:a03:45c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Fri, 4 Aug
 2023 08:23:59 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 08:23:58 +0000
Date:   Fri, 4 Aug 2023 16:23:47 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 14/19] KVM:VMX: Set host constant supervisor states to
 VMCS fields
Message-ID: <ZMy1k+5qDTDULWW/@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-15-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230803042732.88515-15-weijiang.yang@intel.com>
X-ClientProxiedBy: SGXP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::28)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ1PR11MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: fafa1dd9-489b-44a4-a86b-08db94c426c0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: usSgqZ/EkA3maOLXl/lBcpodX9b3DMLh2kXMJRfZQdEVK4wclMFzSSHJkYzlQIR4pNV03wsYUQgL0BWYNIV5P7JDDEBXl6qu5MKj2RruxYhKRVIkpTggTiUE3CHqv/skCB08p5swIxGyBwARqjtR3tAQthaXDakDugzNVX4SSKQrzY6WYlnR71K734T7cWWdOk4XSI3vxb+dbNp7Cj2tuAEpaU5w4e23gfUbYR5/lYfDLWol8gLHepmGGfsQ0aLGmMmGx64Y4X1wsA1j2JjnoVNP/huthZ/VJp9PJDssCzLKxReA8NO74ioOeSee+G5b4yZkLoOoa3YjUU5hK9QfkhguIaE9Krj/iionlIjXyzLF7Q7hVV9P5NFD0023bXNGFQNvx6MDahsu6ImECe3kuE9uyxflCMVdGvz+89KUexc3Q/oVZWfVM6kwcB29Ae6yGzVaLmZJFm4kk4cH4+R6/t2Frtgt/Tjps5k0AfVsFjECPbu68bxzgzWxz/zNAw+h+qy5Gju6u+T75T0oH+u6kmnG/R/5ULeDxRK4tXvMS+HATLYcCZKVAiia3D9mtKJ3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(366004)(376002)(39860400002)(346002)(1800799003)(186006)(451199021)(2906002)(83380400001)(44832011)(86362001)(33716001)(82960400001)(38100700002)(41300700001)(6666004)(6486002)(6512007)(9686003)(316002)(66476007)(6636002)(4326008)(66946007)(66556008)(26005)(6506007)(5660300002)(478600001)(6862004)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PWG2Gh0Fe45KZ3men2ZRW7Pp/mAqJh5eHmHEWPHRyLS0sB1j7C5x6Ot0B3yu?=
 =?us-ascii?Q?mwikTU7QG0F7Bmzr0U542re/u9gO7nAdyDdFWG+0m+lOw+Weu8AKTnSjpcTz?=
 =?us-ascii?Q?+SrXCjkMmEyQHjuWLyaeJW2qkGuxHItvzlPzg6NS2y/OEesxERr1mWmZtpyr?=
 =?us-ascii?Q?kkGvnuxd8wBOrakznrtAS8P/ij9ElX3s5ng2nFJy0bepzR2E5mTZs3ZUCWFU?=
 =?us-ascii?Q?+1Zt3/HOIXT2JWCCxANoxkDV12z+xdy0ObkhTkXxfpUC08z4NyJ8qnjmKNWB?=
 =?us-ascii?Q?4I4cxIRHqtdhlZ6Lfwk9C4EpvAClWXzCXvq5jFb01II9mXMkB5KJ7o23Pbbe?=
 =?us-ascii?Q?frAKMNVKxA2XU8NwlpnT7ESzB4wdSHWD/TCMBRktoG5pxrq6AoJr63w8U++z?=
 =?us-ascii?Q?8B+Wye4HXENirq0kbVhQIjglTlKIwD1cscJTIz9+5H+J9xMHIaOO4tPbQyq7?=
 =?us-ascii?Q?vOHKCFgG8VMxp+V7vbZ2DJ/kENdM6pS6n9JWY+U53Qhxe/yDdwniOwZQ0vQQ?=
 =?us-ascii?Q?z3dpqK0RfhPyIAY6TDbXvcNTOAp5dnuXaqQ/bnuIepZqNJZgWGqx+eZlMJtL?=
 =?us-ascii?Q?czTg4BgTbMvC2Pwt4IeW+uCVPpuW53dQQct+2Yvav3q1Z7RjhILAjnSo4/Bj?=
 =?us-ascii?Q?oP/5+FsXgJRo1IqrFjgjHDK3SKOx4ux4G9iHivkvCap3RRcDiEz4U5H0VWFg?=
 =?us-ascii?Q?ZpZywxiGR3+SuqH561vx5cNGqlhbioHEM3H1HVtqBc16pZr1oAUsmzVg88Es?=
 =?us-ascii?Q?tD+kwOPblBpmUWPJBbk5st8y4VmU+jZ5WPtJFJUIPK2VbaG6PJsTMMqANSqv?=
 =?us-ascii?Q?VumlHNXo2DJQ8UYAti9YFmP0dTxqFgJEY3Sr8UqA42WNR4LjLzkZu5z1Iwii?=
 =?us-ascii?Q?n0JvsluLMnNJZmFfMZ1ZVYY2ZEhtzAKzIVOXsIeBwP26SBqRIb83b0n4T9+U?=
 =?us-ascii?Q?JbI/dDGbLykCQg785O8JmFrWPfWuxgRvmzNK5BH0u5erQTd5hYslwbHXwQ9J?=
 =?us-ascii?Q?xLPKI/Nm7/Fx7AKTz2GVIlRP3HOZWBw8AyzaQQ1LamVmHSvd2GBcYdCDv5Q+?=
 =?us-ascii?Q?LtEJVBzfBsiGGe2WKhjBrWhfJsOp9Piq8CjCebvmYT1umUDec69TtFsF9Iql?=
 =?us-ascii?Q?L3bEDkrdhqUnJZ5wJH5vzufxnLkQ7HXb5brkBjA5D8w/u9SHVGyaQl0HpLn4?=
 =?us-ascii?Q?KjxsUUP0QBkPyS8ZJcF4XMPSALkE+rbJsrKysY0ZKQkw2NJ2sBUSXC1/E0bV?=
 =?us-ascii?Q?Q7eciLchg+6nCCxrDhUC+f+v/H6OlMOm8ysFwvK/2uTmK3nGfCSw0TsHNfde?=
 =?us-ascii?Q?6ocmC48ivqVKKm9PQXTxiNxxZ8taY+YsJc/dAThDguzBha2Y5fEtiNykf+X1?=
 =?us-ascii?Q?Mj9V3PtdX1mO1tfdqt/TcKbEZCRtFRh9xoac5wsOVc8FKvFrcGX93r2AhuhT?=
 =?us-ascii?Q?cTJeWmUKceA11o4ZUdm2nu65XnSw8orN56e+AbrDKUA3Ct2ML0/+k9aagjH0?=
 =?us-ascii?Q?RcaFcV8Q2yD2VmMeVrnX8B4iLc0dvxyLXyYISBYmRWXvH0FJzRH5UcaW5ULZ?=
 =?us-ascii?Q?o6AmGzeBa2AFa26+5H2TluNMGMqFJl4CXDE+rE+c?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fafa1dd9-489b-44a4-a86b-08db94c426c0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 08:23:58.8975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VqoBGoMBMd2lLISHlGQnIfa4p7Iwl29vvolztmTUrexEjXaWsNbhJPGw4N72/SIO5yn+OyFNj3NABfQXX3QuqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6225
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 12:27:27AM -0400, Yang Weijiang wrote:
>Set constant values to HOST_{S_CET,SSP,INTR_SSP_TABLE} VMCS
>fields explicitly. Kernel IBT is supported and the setting in
>MSR_IA32_S_CET is static after post-boot(except is BIOS call
>case but vCPU thread never across it.), i.e. KVM doesn't need
>to refresh HOST_S_CET field before every VM-Enter/VM-Exit
>sequence.
>
>Host supervisor shadow stack is not enabled now and SSP is not
>accessible to kernel mode, thus it's safe to set host IA32_INT_
>SSP_TAB/SSP VMCS fields to 0s. When shadow stack is enabled for
>CPL3, SSP is reloaded from IA32_PL3_SSP before it exits to userspace.
>Check SDM Vol 2A/B Chapter 3/4 for SYSCALL/SYSRET/SYSENTER SYSEXIT/
>RDSSP/CALL etc.
>
>Prevent KVM module loading and if host supervisor shadow stack
>SHSTK_EN is set in MSR_IA32_S_CET as KVM cannot co-exit with it
>correctly.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>
