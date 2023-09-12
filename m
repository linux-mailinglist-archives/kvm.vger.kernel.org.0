Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C1B79C466
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbjILDwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238599AbjILDv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:51:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADB76A61;
        Mon, 11 Sep 2023 19:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694487059; x=1726023059;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tY4JUlg2r2lu1h3nC1/B+Fp0VecmvVPIjnVU/dDc3B8=;
  b=C47ySIIKKkbX77d/muhr7vLRc+63Bub5by4yMMWxHp0p+zJYutToPGmy
   2Tp8ERVrPgXZBitsxeeBrBEWa13Ny6os6MNNDzBw1Hx+YZeUowEm4Byid
   bViluL1IdxwJtIYkdh7u3MoAjYDgF+caUrjw/KvnQgOo5FlVcw403DYEI
   ecXVw/siLTFt6PTjecKba9rfwy9g6PoLxsZHV9Ob3szE0qbQOZ6f/m+TQ
   PO2jscVcEVLCF47qvFgl0yAFOTr2LueXu+E7bXT6JwfPgSIZSBzWOyVut
   oIlID5EElB6/ycRh8HJsioIzTeuNIBI0WxjuS2wtZpV9mPB4NBSJAjL3R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="363294919"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="363294919"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 19:50:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="809049491"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="809049491"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 19:50:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 19:50:55 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 19:50:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 19:50:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 19:50:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agWRwSxRz29sgf0OVrYXNp35fN2gka7mEi9Q4QECVvmZMNZW2aq++jZSebnJ++ghwDtGO0s8LugZyXdI257lQrGp4myRXWk9johB4i/QEyIZpcsp/P+roiulSLF9duC2hV1gTrCoU2AM1AlfBWPwfDo/3cWIytqcVZkFPrgRq4/pc/nw4tljckzEjtl7Yy1yjMnyDatB1a1bso8P5dEVSAnMhSGJgDpm0q//Cf1bmdRWBQY18IIUj1iq3clGdSsRP1UKrCfhmbmwmqSSy/7BIslK/dsO8Xq2YgEgDAZkAPqGloDHfKyJwKCup9h8fDyIpE+nK5Kh8641Wfe7OGIs3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GNYWHjFfRiaaLqkeup9ppmIGXgb0RaxP4iaw8u0+/I=;
 b=L67L3IDJ+j2ntwKXIbl4HA1bvCVCfXiOQHpFhvttaXroXiXSlyEaKRTc50894I+bfODN4GPzP8N18l8bPtsPmxK85RWQEZDgW8VzipjNxEWb98EMOjLSJdZKnZaXvzT6wo2+Q1hATKGrlfTvCeKNfh06acPz4+tSO3z2z5c7n/GYfTBgrIXdwU0xBXf7X3OtDxVoQdwTXlNUjB0uSPZ2ElOdy3HP1FzjmnEQMaKUGpLqffSHUQH9xyQcnQegT5OFDOhFpywn/stufup8H0/T5F2dOihF2lDYCy7gCjhJRG7w+Q3knWiCm30svrmKbGIdRRlLoCHtOqjrTvFugSlJ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB6421.namprd11.prod.outlook.com (2603:10b6:8:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37; Tue, 12 Sep
 2023 02:50:52 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f%7]) with mapi id 15.20.6768.029; Tue, 12 Sep 2023
 02:50:52 +0000
Date:   Tue, 12 Sep 2023 10:50:41 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Manali Shukla <manali.shukla@amd.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>,
        <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>
Subject: Re: [PATCH 07/13] KVM: SVM: Extend VMCB area for virtualized IBS
 registers
Message-ID: <ZP/SAfoc97oS2Dqn@chao-email>
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-8-manali.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904095347.14994-8-manali.shukla@amd.com>
X-ClientProxiedBy: SI1PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::14) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: 99c8dc98-24c4-4f26-3ec2-08dbb33b13d0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Epx+LFs36R3N433KuT3yH3SOoVEVDBmsES3rejqrByZPZBp90vptbYLETEHuRiueWqor9jId+ijj8W6pe/EWa88RCUadXpm9hO8A+hgMOKuW20M4QCx7odTMntlWBcp2AjnMMjLcb5g2R6iRhLHtG9EOY3NNJpSVmW5+OBPmPwYGHeYr0dG5/L8Blqqh1CZ/PpdUe68A9wN0YUYVM1qsrkqnZNnTxNk9BzAGE4D4pSLjbEZsCHc8dNZxufNnyNzU2tG99QkDmLhtT15UVqzdmdmXrJRi7xP0JP3uN0B0E3xI0FXwv1fA3fTuYIrkjFMxKA2T6jZ6Fr5vDAJmWPGIhuB4c3NwOZUlbOykFxB7N0FVcz08RMEqPa5pAJJrQzCT+7eQxMcKfrqs0udZOCYshkSR99ow+tzuTkuAw+Pjmbe9MHLitRRyWrECfbaKO1hUefSyRB9igzzZzT6k/kzuUNpm4HcTuYYzGQD4lFwWEXNic9YP4UxxV89+b/QZKuAs/rcwTy9mMfzlFv2CdnzuSGCLZQYk3fafvfoVaizc/4MDWIXubWdrIrOwdwyqVvlF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(39860400002)(136003)(396003)(366004)(376002)(186009)(1800799009)(451199024)(5660300002)(316002)(66946007)(66476007)(6916009)(66556008)(8936002)(4326008)(44832011)(8676002)(41300700001)(26005)(6506007)(9686003)(6512007)(6486002)(38100700002)(82960400001)(6666004)(33716001)(7416002)(478600001)(83380400001)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qOf/Rh6Dwzwx/WQFfdMpMTbPqUXBqrPT7UQALLfMA1EpSuOMOniei93EneR1?=
 =?us-ascii?Q?4jWJseBQbqVbxmyd7k7fXcCHzsdahp0+Q5oPvz7AsKAtkAG1LVhE1Y/MYMEH?=
 =?us-ascii?Q?OYUsKu5iBvpyMx/czdbs7SCzstWJ+wjv+ZnX7fk3TgiXCawujKUUVAbui5V4?=
 =?us-ascii?Q?v3fnJdy8g4wYwz30y0vPzKh/F27kdvJMiQ5KJNiwEzVU3+o3wuSsE4bDwLeq?=
 =?us-ascii?Q?J2L9UNCqqnJg7GsRWkUqqghf2n1s045E8yypdCFleWIMlMUuB5aak98LvCjD?=
 =?us-ascii?Q?ghqmtHDrLdBkOFU23q75XUx4mClai7AprePssYkgORQ9WzBOcn7gF1uQOcFb?=
 =?us-ascii?Q?AXfaGkNhImzpt3xP9qSIpLvA2BigpLtIyROSKxqJpyuIY+Q8YA+/G6Mf/LYY?=
 =?us-ascii?Q?Kdf6AIosBWu0Cl/zLqSk/Sn346ankZLvhBxsqpAj54RiHxWB9ia1hKrLCkFj?=
 =?us-ascii?Q?UL5twg/dYpeXeRExweuMO8zbQxtViP+neX7BO9+JzT6T8CvxsUizaQAHm2nK?=
 =?us-ascii?Q?QvtZbchhiL4U69eo0sx83dP1yjsph6x0MujjCq+Kok/qe5ZM4xfNYKv/Arcy?=
 =?us-ascii?Q?U9BVIBEowMkW0+zPBJgGiWkVsWN0fHAf8obNpTmCIXwMEajBplmjJIgpY0ic?=
 =?us-ascii?Q?ufVfBDCkaQ1tOwy3U9mNfovvjhle7Go+JSP6xjm1DdP1vCrFnp1L3F4dn181?=
 =?us-ascii?Q?xvUdyMCCXxbd5jZJMftvGEEIPpItbUgum99fp6YEn+H1SRC/zMuMUbSMUtiz?=
 =?us-ascii?Q?9PCIjxC6+V/mJAJZKpyvYuoggu/pCXAXrd3s4DaOKVRWQgSyyceji5yxwGd5?=
 =?us-ascii?Q?B4GzPMHm7fcrNPcbZUwtdFW6N5hv/IyBhTL2Gf13jm0ZjcM7qRHnMUyMr6Fc?=
 =?us-ascii?Q?8pmm4ngQ8bANsA/aeIpxA7NQ06jWKm5yKSQ1lwzPUGq8YCDBBbu6iI1YXa6I?=
 =?us-ascii?Q?dnZIx7mmEwc7B2UMN4AHTD2CRp7UzEVVdkF+ZK+QhdobhD/bHZ55+kVItWY3?=
 =?us-ascii?Q?T2FDwScmhCUnE3kODzZLtu08tC5lDBLbPJ7Pqutq+GAdHI1084ohcHfePX/Z?=
 =?us-ascii?Q?lXFzRBx4KxCjb+Wu2K0HjtCMmavirIuJKOfIlMoBThYVPywR5IDs16hzy6zJ?=
 =?us-ascii?Q?OTOgCao4yP7nVl9RC5YU4Z9yLPQFiRIf/sTw3khUpUJh4+Wy77vSHSYb+kxR?=
 =?us-ascii?Q?vIuu14Tbeb/JPmcZeYXfIYY8CKUAh5lJHjRqqbimRsufWvF/40bXUPmy11CA?=
 =?us-ascii?Q?nbzMVylyFa5tJBIIIjwOm8PGQMgg57OfgQrQN5rv2kN5rE5qQeoLGKs/o2+m?=
 =?us-ascii?Q?HIETP14240YzJ4Kd56v29j1OkGHI2mDHN10w4J2o8UdcRhdFnPSLWQhl6Vj2?=
 =?us-ascii?Q?mvWjWunkNho+u1OuHF3dSGLpbTYxe0+j17KOGn6y9Sr0LqSzHG2drlM8mVru?=
 =?us-ascii?Q?/RmZifQYN0HbydzuV3fferoRsX3zh4GFp+Zcom5iJM+19jyE/qQkVCtaBqEV?=
 =?us-ascii?Q?HVzeLW1RBZog305hcZ0UuhGO2H+sdauzBPKC2KZ+6nJff+jGm+mhhCvA6rw0?=
 =?us-ascii?Q?vIF3PIMSLF9HDA1M+bM1PD9pdSanGoSfB0oHy1Nm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c8dc98-24c4-4f26-3ec2-08dbb33b13d0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 02:50:52.3118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9XeuY8R4VgGuONRPumpp76JL5kcT+j/cS1pu3TnrR1yR4SSPqg3d8uLX8uzMRbjUYLum/xdWMooonN5+D0A9nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6421
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 09:53:41AM +0000, Manali Shukla wrote:
>From: Santosh Shukla <santosh.shukla@amd.com>
>
>VMCB state save is extended to hold guest values of the fetch and op
>IBS registers.
>
>Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>---
> arch/x86/include/asm/svm.h | 16 +++++++++++++++-
> 1 file changed, 15 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>index dee9fa91120b..4096d2f68770 100644
>--- a/arch/x86/include/asm/svm.h
>+++ b/arch/x86/include/asm/svm.h
>@@ -346,6 +346,19 @@ struct vmcb_save_area {
> 	u64 last_excp_to;
> 	u8 reserved_0x298[72];
> 	u64 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
>+	u8 reserved_0x2e8[904];
>+	u8 lbr_stack_from_to[256];
>+	u64 lbr_select;

Shouldn't these lbr fields be added by a separate patch/series?

>+	u64 ibs_fetch_ctl;
>+	u64 ibs_fetch_linear_addr;
>+	u64 ibs_op_ctl;
>+	u64 ibs_op_rip;
>+	u64 ibs_op_data;
>+	u64 ibs_op_data2;
>+	u64 ibs_op_data3;
>+	u64 ibs_dc_linear_addr;
>+	u64 ibs_br_target;
>+	u64 ibs_fetch_extd_ctl;
> } __packed;
> 
> /* Save area definition for SEV-ES and SEV-SNP guests */
>@@ -512,7 +525,7 @@ struct ghcb {
> } __packed;
> 
> 
>-#define EXPECTED_VMCB_SAVE_AREA_SIZE		744
>+#define EXPECTED_VMCB_SAVE_AREA_SIZE		1992
> #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
> #define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
> #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
>@@ -537,6 +550,7 @@ static inline void __unused_size_checks(void)
> 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x180);
> 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x248);
> 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x298);
>+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x2e8);
> 
> 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xc8);
> 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xcc);
>-- 
>2.34.1
>
