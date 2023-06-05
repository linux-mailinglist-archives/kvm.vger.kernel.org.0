Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3E9722749
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbjFENXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbjFENXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:23:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FBCDB
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 06:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685971383; x=1717507383;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=m02gJbBPqEOBXQQwn/VGpB+cO0Dfw9DoV31YmRTPPkw=;
  b=fmTxAC6fxUUH9OqkspXuhO4gBKvKa9lCRfy9+4MSX6GGcgnusQTn6oJc
   mARnZmAUI43/fyCl301JV4RTjtD0FE1vhDXWAXTeieB8xGxvBF2RUiC5O
   YIO2B8ShQm/1H12EHwv1MzFQ5sjBPsK5giM3e8Q1uP2zhv2eRt0f7kt/X
   UsBIWz7NG/ECIEjloWunBwK6OiLu9uKg9oQkKXA/6q29Yu6TnEMlVw9Nz
   IA+YVwgb28EczOM4Mgnh0Qie7We6wdu/Xj+lRFJxtOoe+4taHckTFnMKT
   9g59Ook5ChqDP7jFcRFP8dVX3r2MgQxaTfK022bjrSAy/U5uE9/dr5KEK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442738319"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="442738319"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 06:23:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="711800076"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="711800076"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jun 2023 06:23:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 06:23:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 06:23:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 06:23:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 06:23:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGka8xFVvMSg/xvUkL7cXT/pbgUqBUZurYecCvWFNimiV/MtGKHvbXJVFUmEfNOWw1xqI8abD9oFMDEpKWSx/anDpEG8uDVqQOlnbcMeOjLYdwXis8yIgs1UjEN4RbLoboiSWw7F/RsKlbPTNlTYLSORx0gtwicRColDeq4j6MPZyMkC6HmNbun/U3J49dR+VfdyrYIvikkm0SXrpXRxYB76Y8pzD+1bGSOQH/h/sh3M9aPN8Ywcz5YqVrlOhrdj4zpWDbt7dk2/VsqET7W9ws+5hWPtPeYsOlMaX4NCtYmBhzRl0gTEu3ZVeRjYNkyQDmr6mvly8lh2D/GzAh/utA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPsDJxAjI/PptMy3wSftvzcoh8u/SZCHrVtymTIVvck=;
 b=M21eNZtBM3wZgkNpwR32yx4S0u332YGEBA/r6FuKJ3HdAPuUliefgK+6Q3UEN1WRL+AWVKaYL6d+N6k9y702aDKsOMdkidvSBtDWRahsw6zrPfHml/yW5vEM8eCd+VNc7H7QLU4xD3omU3rhlHi3agzUJajye7EWHs+gDfvFAVm7mp1rLVLmQM/+mfb896rqTaY1exU9RSDK2fxGKvo4EW/LYoufaCFuxO3oI2YOXNDQxL3CSm9YbN/ofErWLW1KY85VykBVnmGaAu39gWmaFUS3q6J7v8s22qO9w4Af6r7cCMt7PF8TIWywXC8a1R1uCIaFIA7IYUgkQUKkbtIJjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH3PR11MB8436.namprd11.prod.outlook.com (2603:10b6:610:173::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 13:22:59 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Mon, 5 Jun 2023
 13:22:59 +0000
Date:   Mon, 5 Jun 2023 21:22:50 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v5 4/4] x86: Add test case for INVVPID with LAM
Message-ID: <ZH3hqvoaQkQ8qK/n@chao-email>
References: <20230530024356.24870-1-binbin.wu@linux.intel.com>
 <20230530024356.24870-5-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230530024356.24870-5-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0133.apcprd02.prod.outlook.com
 (2603:1096:4:188::18) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH3PR11MB8436:EE_
X-MS-Office365-Filtering-Correlation-Id: e613077c-736f-4168-e0c8-08db65c7fb01
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drs0gHe/GUawOS4Dbpop9OXw9LenuJkkqbekIyaX+sXZt6WaoYKp2uHI4oyRfsWYm8nn9MhGVu1FV7NjXHSJWMnf60clA2I22XJYZzEPcim4T8SAGBjkvVYcL/nDCmhy4jC+ZpDVoZM44ZUFruSnA/ELUdKRlADUhRbaxby/VL9rTML0yPrztbR4k4t3kHEOmzQbVFYCCB7Xl4daF3Ngisd9mtuGYbBnGIcBL/f1ebZw92ket+npb57bSjiA+rCExI4pHzRQ3fgtDvWUQc2Eu7J5tom7m0q4UP59i29pNoDJJagCSdUHHkkLZ90YrRVDuy0CtKuRCyhsh9ERzQChSRmSCIqCK5ieXOPOmwUt0NcRtQwj7nupG7o4X9OWr/0D4+pe97lUqW4ZQAaMTCwQ4kVv/1ZPJXsX8lESpH5mzFR3YIZVQBI/yrWAQAUR0n2NSTsIXCiZEdwgqZhHS+Fj1g69qAL7iH5cnqFFOFCb/NuSZs8rWqvLMC0dHBcxncAMSgOo2g+k+WX8pDsYjDqebcHxRMgazY5g3lCQUULR1OLjhA2fBwl6Of9lB27/qsBI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(478600001)(5660300002)(8936002)(8676002)(44832011)(2906002)(86362001)(33716001)(4326008)(6916009)(66476007)(66556008)(66946007)(316002)(82960400001)(38100700002)(41300700001)(9686003)(6512007)(6506007)(26005)(186003)(83380400001)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?te7sstqJbG/igQTIjNoCyOVsdKUdJ2A6hrGOFtfLKFKbCUgucEA193PYxuMP?=
 =?us-ascii?Q?Twnh+WXf2/QtVKu4yHz+/V96gBdNnhVeIfjdoqo93Xlk+IP2TZKa2Iw28OfN?=
 =?us-ascii?Q?cQNCWEf+2p5ukO9jqdpbesj27xZfLR3/Rd2oHU5LMYJbb7MuABQMJk7ct2lB?=
 =?us-ascii?Q?J0QmHDBjgzcm/PwsJSmJ7MzHjiTCA+P7Z2akoPEWEq8oocxXpbr80vj2GU6K?=
 =?us-ascii?Q?8lHXsDNNmiNTxEDff3OdUF4BiDYvl48FfhYOqoYKrQNGqwV4VYlCC6HhE+oW?=
 =?us-ascii?Q?WiuW8ZVGr52Dg3Tpug8UhXpuooLYVK0MVv07xElp8euG/2vJPpD36S8q9YLp?=
 =?us-ascii?Q?6a7+o3w3bn3WQGnRT0Lbpjpw8IuGn83dr17Ls9drwZaSJd3qdJqQc85h0oiS?=
 =?us-ascii?Q?bSRyUhBf+xMCySj1mgIVkRn7tHFVMEitOHGN4AZ57b6tue8ZJcm1RTr5t22p?=
 =?us-ascii?Q?nAPnDIqLUo3AM5D4SPHxSubged7fdtjt++7/ei5binLtCuNMS6XEfuysqGEy?=
 =?us-ascii?Q?CaIvmEDdcvjeNkLScpbft4A+V1v6fH7iE8hkipLE77qYt+i5sZWxfvbe2IET?=
 =?us-ascii?Q?/BMq2b32uyM5HjIaEnj+8ZIeOIviqjU2ut7xcFRbdfQKyTDLTDK7VWzxwu8i?=
 =?us-ascii?Q?yMtjOKoaim/NbaYgNPhs/FipW58hO2w7fgOli40uD0XIUMj5/1ZaMm4JxCdT?=
 =?us-ascii?Q?90D4Z1HCLQA/o4UoMglQwNBL196SoN09J+9Oygqf22kIwixlnRCzIJwSjm1X?=
 =?us-ascii?Q?2EKdzGYdBTf/Clz9iKSKWKtqbOs1MOscMazfUbE2SYBXKwq0OsHTuFI4NnBE?=
 =?us-ascii?Q?MMRjNlgDuOQy5PaJMxeAQniHq0cPw3HhlHzxvfXtqB4qtOGesxA0MevuALIh?=
 =?us-ascii?Q?PHVF3EMGLbzGk20Duvvw4p41/wjmjk/fPxjFGUisA8KNnggMBLHaNDZ/686R?=
 =?us-ascii?Q?KCErw4Y/hYTkLh2o+ak3dJxFhmDItVQUUjcWVYjcv2v4yAweo5JRaKUvmpea?=
 =?us-ascii?Q?u1zrb56nOooMgLS1OH/6r51hO+HBxBEnEmqiGtm6VxzkhXKZrXQ3Lzha5GJ2?=
 =?us-ascii?Q?8A1mZkbVUeXcsnDXNyq8YWWCfPo7mS0IZIKvCGKZb37ZMA6cnCCb2WWc7vtx?=
 =?us-ascii?Q?5n+wTgif2p2af17MzCel5SkyGum0IPchfnOU/IljF+aSUuduTtjpQZHNkAPg?=
 =?us-ascii?Q?D6Cws038VfhmChM9ADzRATMHQ+wOQHRco5+qRtgmnqVYdIeiFScm2UHNoYjH?=
 =?us-ascii?Q?9CmFtgSWkjePx9o2KABOvZy4Owqu3EaagEMHHTL/4h8sNg+pRR/FXZiOHtGm?=
 =?us-ascii?Q?JQkBh+VjdNMThZptfoRzSzzfsc/OSFhGl9NIl1lqOrqQozdy6hakWlc/zDzj?=
 =?us-ascii?Q?Law9vk5rCB2Bufd+7kXFWZDeyLFnTHMdvua3VP+V4uHgXTLiD4fNgZKfTfgZ?=
 =?us-ascii?Q?x6MPDyvLB0ezBa7At70tjMdctSqabQnqk3cwkVEajXwo0BB6Jkrw92lZOy9X?=
 =?us-ascii?Q?9tSf7nDAHgtJVBLNpXEmg8QB2jIN/+ZPekTIOWno7/rsGhe+8rG7zxcNhflT?=
 =?us-ascii?Q?1F8v8oWMhRw01WZdJ/dmwrxloKU48Iwto+7P05pD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e613077c-736f-4168-e0c8-08db65c7fb01
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 13:22:58.9841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZbUAxLE6N1rmIttVYWc4PzNfpvZflUfcwWEF7iKJGuKAQk4FTxkgETCzqivGrhn0/T1k/jaGWqLec2ZxYMOykQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8436
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023 at 10:43:56AM +0800, Binbin Wu wrote:
>LAM applies to the linear address of INVVPID operand, however,
>it doesn't apply to the linear address in the INVVPID descriptor.
>
>The added cases use tagged operand or tagged target invalidation
>address to make sure the behaviors are expected when LAM is on.
>
>Also, INVVPID case using tagged operand can be used as the common
>test cases for VMX instruction VMExits.
>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>---
> x86/vmx_tests.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
> 1 file changed, 45 insertions(+), 1 deletion(-)
>
>diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>index 217befe..3f3f203 100644
>--- a/x86/vmx_tests.c
>+++ b/x86/vmx_tests.c
>@@ -3225,6 +3225,48 @@ static void invvpid_test_not_in_vmx_operation(void)
> 	TEST_ASSERT(!vmx_on());
> }
> 
>+/* LAM applies to the target address inside the descriptor of invvpid */

This isn't correct. LAM doesn't apply to that address. Right?

>+static void invvpid_test_lam(void)
>+{
>+	void *vaddr;
>+	struct invvpid_operand *operand;
>+	u64 lam_mask = LAM48_MASK;
>+	bool fault;
>+
>+	if (!this_cpu_has(X86_FEATURE_LAM)) {
>+		report_skip("LAM is not supported, skip INVVPID with LAM");
>+		return;
>+	}
>+	write_cr4_safe(read_cr4() | X86_CR4_LAM_SUP);

why write_cr4_safe()?

This should succeed if LAM is supported. So it is better to use
write_cr4() because write_cr4() has an assertion which can catch
unexpected exceptions.

>+
>+	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
>+		lam_mask = LAM57_MASK;
>+
>+	vaddr = alloc_vpage();
>+	install_page(current_page_table(), virt_to_phys(alloc_page()), vaddr);
>+	/*
>+	 * Since the stack memory address in KUT doesn't follow kernel address
>+	 * space partition rule, reuse the memory address for descriptor and
>+	 * the target address in the descriptor of invvpid.
>+	 */
>+	operand = (struct invvpid_operand *)vaddr;
>+	operand->vpid = 0xffff;
>+	operand->gla = (u64)vaddr;
>+	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
>+								 lam_mask);
>+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>+	report(!fault, "INVVPID (LAM on): tagged operand");
>+
>+	/*
>+	 * LAM doesn't apply to the address inside the descriptor, expected
>+	 * failure and VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID set in
>+	 * VMX_INST_ERROR.
>+	 */
Maybe

	/*
	 * Verify that LAM doesn't apply to the address inside the descriptor
	 * even when LAM is enabled. i.e., the address in the descriptor should
	 * be canonical.
	 */
>+	try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);

shouldn't we use a kernel address here? e.g., vaddr. otherwise, we
cannot tell if there is an error in KVM's emulation because in this
test, LAM is enabled only for kernel address while INVVPID_ADDR is a
userspace address.

>+
>+	write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);

ditto.

With all above fixed:

Reviewed-by: Chao Gao <chao.gao@intel.com>


>+}
>+
> /*
>  * This does not test real-address mode, virtual-8086 mode, protected mode,
>  * or CPL > 0.
>@@ -3274,8 +3316,10 @@ static void invvpid_test(void)
> 	/*
> 	 * The gla operand is only validated for single-address INVVPID.
> 	 */
>-	if (types & (1u << INVVPID_ADDR))
>+	if (types & (1u << INVVPID_ADDR)) {
> 		try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);
>+		invvpid_test_lam();
>+	}
> 
> 	invvpid_test_gp();
> 	invvpid_test_ss();
>-- 
>2.25.1
>
