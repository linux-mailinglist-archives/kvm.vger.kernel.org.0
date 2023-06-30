Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF39A743657
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 10:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjF3ICJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 04:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjF3ICD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 04:02:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F232D50;
        Fri, 30 Jun 2023 01:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688112121; x=1719648121;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HlTX/MtC1l+ZTj8592qQV6k6Y2kx35mFHFxrAM6NGck=;
  b=Vll7tChWDtAN9dUg0x+xQzck61EoALSIaxoGGZNqU+/jWyR9jmFUQqIs
   TxdXUJiFv2yxLmijrCnJtGYJr2rqhfJjUn9V+ueIlCffQs/ixTIgq3+Mu
   0zo0pti53NyqaL5eoQF3/NfNXDosbi60rp4AJ0qxFPPfas1wUYiwuqMqJ
   Mr3Iyq4rGz8S+b7eHwe3Y1wGok6faFL55u64pefc06m08by/Ee1Cdy6rw
   St4mZCawXcSikhoS8hXxH1qqK/VMZrRyeBg4pwAghfzFRQ1DKYE1SWCVu
   EG+qnA01fdfvIzTA7yncYt4dctyrBfqHUXRA/n2ytdVoVW2Lt7DQ+EZRr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="426029724"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="426029724"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 01:01:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="807679422"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="807679422"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Jun 2023 01:01:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 01:01:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 01:01:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 01:01:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 01:01:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdO9L0ZjRURA3xPYGD1qbZM3e2bHitte9bvPCFWWKj2ZzoH9hM5YnUmh6Sv0w3dH06dUcRniFL65p9yeAl6pf3hEq4AU4mfsdufmCMDPUMX63HpFHK+u8i/OrByQIPTEcGBDZOSXedDPl1QXc1FU78IFodHvjy/FU/X9t7DbDGDvLER58z4nJJtuQ28zhDv9+kenfAz/0mCcDXTjBOvNgNP10haYF3ZLhJq3QurJevMyJ+1q4sCXMr8M6DElo/uAUBPiUCW5mSc7cN6t6X6Hj/JIlsSDpxyiwaV/Afm1kgMVispik6uKpxq3Uh1O2yL9yBWmk5TyH8oLeElc8Duh2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CX3a9onLoWqCDAjb9f6wKXoH9rMfOdypO72VbHmKgX4=;
 b=K7dHKNDPo5TRNCi3oIOWFRBcvmc6Gk6wlby89ggDf+JVzIr+ce9dbUmNq4tk4Jw8hMUi2PnLTDUqn3904QHGqKXaRmsNG//m/I0g9lMrV3UZ3etCPaCnxtU7wpCu9bY+CZ2uYtCkyEvBceQwHR5S9LrGK5mDV06cwXaKvaciaqFAys3y5VDpBdFH/AYxNuTZbBwehBuD2a+7X4zSyX7WlgP1Af4wBt+zdoKmvubh+O9+VW9F6g2pEVDU6DyQ/Mls2kd/SQ8ITHADjg2v+a1saCiE4boKeDLnHGt1CDDhgZH5QyEhNj8XIxcqfotEx/yn17JAkXFfgNoNG57im7bX+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA3PR11MB7436.namprd11.prod.outlook.com (2603:10b6:806:307::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 30 Jun
 2023 08:01:49 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6544.019; Fri, 30 Jun 2023
 08:01:49 +0000
Date:   Fri, 30 Jun 2023 16:01:38 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/12] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
Message-ID: <ZJ6L4oWE9refbXnX@chao-email>
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230217231022.816138-2-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0026.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::16) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA3PR11MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 887bc5e0-0a52-4f52-954e-08db79404189
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXuhSBoj8a7Bfz0bfKxoUaqubLWVPRz55W87S5df0MD6KdHzUR2LcFIpDu3ah4mAnS1e/GPHEMMe/8c13c0GwXwiPLtUOYZfLJNMOkEE4qdiO1VRYHfXKusa9HLFmkroA4TSlaLchcH74Wi2fTQNYeAMZB47ugbQ0Mw6TIiBj1bySrssoe6US7VLga85VPjOB1h2UIdIZJ3CiEwJGAhPyOmGkcYU0gFgx9JXFJngfnfxo7Dk8S34kLCwpTRb8S7YTTlyoY1MXT9dV9NxHChEIfFZN4930GG1MdXY06xMaze3HoT6I/UHnPsQSkl5/OJBq1q49y9TL0fs+/U7jOfsEaCMPPDuBTKhwN3G9SzP9j7fPsrrLohugZUyVuLjzBT/8ytI7m7+Jna2iscjGHPLG89cgls4cLcinwi1Y2JSK83FR+FXrxrN1KdtXaEQk/u9rjN77H47Uu9r8aCIS3JKSil/gj3DFjlVNl5cWB72dSd70Hrr1lSdMjCz98o59tehqEvCH22wPPljuaH04s34D3IKx2vEM2LDUnicTwpYHK37G5ozZ+amt/13VXzy/Qxg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199021)(82960400001)(38100700002)(33716001)(86362001)(66946007)(6486002)(8676002)(41300700001)(478600001)(8936002)(6506007)(5660300002)(44832011)(6512007)(9686003)(26005)(186003)(2906002)(54906003)(4326008)(6666004)(66476007)(66556008)(316002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L1Km8ysilYeLLcPwb2tveU0Wkb7R6qHRcfXGYfITWmUhLvYtRylPuYS29Uwe?=
 =?us-ascii?Q?7M6e42/MqlKU+9fQfEFtQJ9ZkaC3ElMGMUsUehMqgbpfYHw2zFauY3f2GHb1?=
 =?us-ascii?Q?kI9ZnpH41gDZW2FeIgzfnCNU2Zalcb6gYWY6hitbE+GMnL/n7ZVIXCS0TyIQ?=
 =?us-ascii?Q?aoIfNZh6ZK/qgpJFCNiyvH1uiBlhXmfd1EAo68zS96AjvL7ja6+OYzNFzVnI?=
 =?us-ascii?Q?73Eo5HN9G+uezAuTxfNO3C1BfvH8woCIxsbutO55hAlmoGHn0v6IWqY82EFP?=
 =?us-ascii?Q?4SDKK8bTozqTwZhD/CWxBsFWuPOpVbU90lxA5JDPrxtdhQeNhdQRAwjRX6hM?=
 =?us-ascii?Q?7KBLo/t+1gd04Fa2AqXEmlUkoz7oS+Z3qNZiDQHmrRm/j0k6blu70vQ0tMcg?=
 =?us-ascii?Q?Or36SYpuFxXwoTvO1V1GmlRvGskBpKh43AqLkTLXLx1Yc+TBJN2+59p0jYCe?=
 =?us-ascii?Q?50A8sX1375im2Fynj3ZJsQj2b8P6iH25lwqBT0J9rFx+90jMEtDujsbmHFug?=
 =?us-ascii?Q?+KP1tMrNufKY2fCylN5Q4X4bEbzrrmu6VX0JYjWG/xOR/hAgWxZHs9H2ct+k?=
 =?us-ascii?Q?6rkaZgcVX9BMS7WGjv6lf0xzZxilP0xcscyiUYbjO5+M15BwHjBFkgtHxYnt?=
 =?us-ascii?Q?amPEckwg72r/e+fYhgJV47bENG0LIn2c/+nJ9ixow8wnSsY7HiOM2CUO0Soo?=
 =?us-ascii?Q?7373ExaU2uDY8gWPQoVABmaEIGzCU4HbWcBwpEdIyf9qrbzHOCIMkh82wkbF?=
 =?us-ascii?Q?b/7D1To6kgvQqTyHbx+DJ+kf54cITd2noU0oiul5z1OTb3yrImmkm44StuK5?=
 =?us-ascii?Q?7bm+jRIfVUy8zOmEomFX95RJpnKcg7RTtL3dhTcSXftMa6e/dKdm20Tv1fL8?=
 =?us-ascii?Q?xt6oKEgIC0Md7WpihVhFeyhOoZOeWPzxqIUBA/NlRK66rNoMLEdJn9JnRe3o?=
 =?us-ascii?Q?1GCeLHMn+D8StYmseMlIpN12jr1lNICFOS+DH9xmkBb7xS2ZyBN9IIAYbeKy?=
 =?us-ascii?Q?8JJhFTjQm2wUQ12cxCPagVscXhsEUj8Gzk4FyRKwobS5BnIQq9n5kbhU00VX?=
 =?us-ascii?Q?A7/xT+sAl1FvxTWbpniG7W9tdEQ0iI3a1MQU02HxHRsYnO7q0HwSxkXvtOyY?=
 =?us-ascii?Q?He03aljj8GN3Bd0U3tT9H6pArfm1d05BnwnG5ag6FGgYuf9HjkjU08eaITkY?=
 =?us-ascii?Q?CSMDcPIn40rhqo5EYMH0gt2B6wYiV1nD3A9Z4+jK/oUSh7BrveUoC9z8Qqei?=
 =?us-ascii?Q?ZNiheImKxPOp2PV15Yliyx/EJm/Eo4TuVACLFdlAol0xaaqkW3/kWR96ENWe?=
 =?us-ascii?Q?pzmD5xI9wmN18dM3wLgQFY3PEeysk0/HqSmRQ5/8akCBp9VFZmAjHHdW8nSt?=
 =?us-ascii?Q?Q1vDyp+sv/BZ3LlUZPFHox280tZbwij5QKN5Wd1G+cBdBrayURCqrsh88uGg?=
 =?us-ascii?Q?Phtqcvl2qmdZATZe4d2uRzNZv/yNpHmmRSa9s+05Ta+qrPxOidkrDTbFFAXm?=
 =?us-ascii?Q?VyxVbiwy5Fo7cr/Sb1HNQ/QotZeXTi4JM9m4N+5s4zH1SGmlPUpRzjVm4OGS?=
 =?us-ascii?Q?rOxGIH1lxGuz+kNVGOwBF2E4JWm13fIB//YRRNLB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 887bc5e0-0a52-4f52-954e-08db79404189
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 08:01:48.8903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pt8cDo1YJ0Y7HJjNjREnSTy+xgoSZgaOrthkU+orpyvmlmaWQGqTSXeDXKL15QIlTri03qSHyGVXd9JC/FUP+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7436
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

On Fri, Feb 17, 2023 at 03:10:11PM -0800, Sean Christopherson wrote:
>+static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
>+						     unsigned int x86_feature)
>+{
>+	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES >
>+		     sizeof(vcpu->arch.governed_features.enabled) * BITS_PER_BYTE);
>+
>+	vcpu->arch.governed_features.enabled |= kvm_governed_feature_bit(x86_feature);
>+}
>+
>+static __always_inline void kvm_governed_feature_check_and_set(struct kvm_vcpu *vcpu,
>+							       unsigned int x86_feature)
>+{
>+	if (guest_cpuid_has(vcpu, x86_feature))

Most callers in this series are conditional on either boot_cpu_has() or some
local variables. Can we convert them to kvm_cpu_cap_has() and incorporate them
within this function? i.e.,

	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))


The benefits of doing so are
1. callers needn't repeat

	if (kvm_cpu_cap_has(x86_feature))
		kvm_governed_feature_check_and_set(x86_feature)

2. this fits the idea better that guests can use a governed feature only if host
   supports it _and_ QEMU exposes it to the guest.

>+		kvm_governed_feature_set(vcpu, x86_feature);
>+}
>+
