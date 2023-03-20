Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA786C11FE
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 13:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjCTMgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 08:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjCTMgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:36:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA22E19F38
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 05:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679315801; x=1710851801;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=e96NHOyRdVYHKcyTGMFbQknXKLokWQTbxOKyKcTR7tU=;
  b=LXt67uUEy66Owkx/oEAyiGcPWe56id6MJSgyNrBjkV/j8L8/jTDro8mZ
   BdAhVaHeKZOIclci5ZNCB3kZ1o2FvRtG0+dp3ooRE0Lond5YlzN/CYLR6
   xwRjGTU2qAHX3q5tCse3+rY/pRSMGoImmphbAjY6ozb6uj7Qs60kXCQgL
   6hxMxd2X3FwyGScssVodaevTgyLdVcK/bG2u05sMT9v9COyykZbeIQ3fI
   GzhtKVwlXV2J2KN7g271wVX4TRmEI7guk58fhiL7Tipr2NyAC2U46kk1g
   sDwLnPWLaRx0j38O6XMq8HTZ6u4YREZdivTwq0yLVQpw1fQb63dnH5X71
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="401222318"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="401222318"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:36:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="711344467"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="711344467"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2023 05:36:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 05:36:35 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 05:36:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 05:36:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 05:36:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Es9rqj0q0z/XxzBnN5WkgOtOV2CFRhiMsYYKjRUJ3PmE4/3vApvxJa66abod8BAdXN6ocvr/LtF11sNyvZiMcu7rBoKejlqEaH0NAcxilf9tb433+l78jqlI0q2OFmqFgLkX8EVXVJtwS+QMv9rF7hJY3wM9Thcr50nMCqSZtUfXRW9MHuD0ZHYvugos1CxQ7eY+MIcePBQos5mVC7d8p0lnUw5BfL+Gi7PBAfntHHQLafPZZxIDmMX+vlv3YwQLvtV6agTSLdv2f4jLSEzrwlL/dWGASFPMuvn219wEf89Y/VM8xGJ/Z3hE2MZJQ9KUlf/7fBjHmPaqivY39Vk1zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKxqovlYoSQjxJV4plWr5ELLMXUfEWSrIG5NGdxNh0k=;
 b=iR8BJKoljzhGD+zxLbeo2JCAGAbG94aT99R48ndZZuE/WnOwKrMisxlXZvPPUlAebHKA0XdStI+5QdvHweDVdc+uoTlDraTXo1HTle9Kcve+IEDvhB4ky8rRkI7gREniGO448Fz8Q/tMVJoxoBZvfqImwp4WDLDryZzXOLbFmO1yVZdKsS9i7/C0g2ElYCO56HEhbmoYoBMH9txeDgoP0W+9mXHT841gLERL5baN3s/QlJV+SPi1ecZ21NoGkKWeAusXC3FLsXGkuOALSMmX6b3X4Qu1AzYS7oQ4avV+Pz5IauA4THtX88xwIJrBm2FA9XMtqgGJTKMDGa+JlXXa3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CO6PR11MB5588.namprd11.prod.outlook.com (2603:10b6:303:13c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 12:36:32 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%9]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 12:36:32 +0000
Date:   Mon, 20 Mar 2023 20:36:59 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Message-ID: <ZBhTa6QSGDp2ZkGU@gao-cwp>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319084927.29607-3-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0089.apcprd02.prod.outlook.com
 (2603:1096:4:90::29) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CO6PR11MB5588:EE_
X-MS-Office365-Filtering-Correlation-Id: f73ec6b4-7e54-4fe7-871e-08db293fbc84
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YsRJp8SBj5UMTNgKmwn922qWH94K7NbAlk2PU4np0434pO7Xgy0gw9wwfF41rGg59KagfCzo9rp1xa0590SPuZgpxqos/7v/2jWxdMCA7/UD0R3RRrXuqj4oYYbPJewMYbtfSPyMpXTPE034XHgeB2xCAjL4CNPn9AgyJSdZhKEN4Gf8f/Xm6yjq1vOLGP1MZGAxK8y+p3B9xLCjpaIhsV2LxBfLIklUJ9jB6Oz/zA/YwrVRcHIAWUPwwupkEsW6oFb4Y0XhGPLJ4xqN6Z5ZBgPh4AIJoHZhkceCxw9+zXnmMm8rIM7L1mlH/lSGSZj+8tSzk5Dem4U8pB6k99nkfOAvZMjmActeSdn0HIlMmWt7X317d2NlwNIqvvCfHJ2QGN2soHJsCxTxsWT+eSiT5d4Cs5Ts5U2sqaSXp5Xs2cZz7nTjKNVX3r6ZB2mB0msccRNndG1GgibUlM3KRz8Ttb7GMXRsTZ9T8P6NbVof6DuVhO94GsFOi57dZdUcuirQ01O9ar+C/gj6RwY3Vcg4V1SE75hVckKYilUQIp4cJW8oOoqspo9W8avAfFU34+56g3d1pjJMP91pQJsnafXaBrVxbBILxqeG9gZAO4dihDdUqV1kjen60uCDIX2Y59X3WDlMl1NCgZqBlodlU8XIDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199018)(6666004)(82960400001)(6486002)(6506007)(186003)(9686003)(6512007)(26005)(33716001)(38100700002)(478600001)(2906002)(86362001)(83380400001)(8676002)(316002)(44832011)(66476007)(8936002)(4326008)(41300700001)(6916009)(5660300002)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pe8LbF6TjUra+gknmucRab6iI6+AGUHANXoW+hLdU7lWd0rrebc82bgfGtux?=
 =?us-ascii?Q?msdriyYvkOTD8wC/EuL0j1+RqqbXUwgTJgq3eEQXMRlY0Lemw/ZvK/NBOP+C?=
 =?us-ascii?Q?+KshAwZ+7AYGf00Fb/VykVLp1AEcOraPmZ/7Y7lck+9eDLfs9l45FmF5bu6e?=
 =?us-ascii?Q?v9T2u+pTfn57Cbm3JLORCTivFFzxbhX/elIap6/FFeXgKUB71ILCUOwGFvy4?=
 =?us-ascii?Q?cKoFc0nyBCHOEyA89l52JRSvvK9JgzYhTm9bs0bc8SO/WiStRCg9Ife0X5lQ?=
 =?us-ascii?Q?E9U8OsYUutPFKGPOKccg2xTe+7OIzSlcSg6fOzU6pWs8JGpjoHfFE4DPi2sq?=
 =?us-ascii?Q?99KP++Vl4JyVZ2bCA9AwBNgMGBtmlF8ickcB5HYoFrzyprC0EQ6BbDBstLBD?=
 =?us-ascii?Q?6hhyUO1O4alY4/YQ9t2Pa1MGetzOL1+YPcMND5prdAssgwKEniW3DisgFor3?=
 =?us-ascii?Q?OyvRNCd43bBNbVylOOVGwGAWGitEoKZ1ZTHyhcVHJeG3zBpY5kvaxK5EyYbH?=
 =?us-ascii?Q?rkamKpbYvDqJoi4Z9e18uaHP58SQKVh8/L/a0VgBnjMTooOjEYT2dZYrSaip?=
 =?us-ascii?Q?4XW6Ye60P7m6OGP+99A0xorVT02lWyPybaDTUrMaygaOWSbLas18csWRTo44?=
 =?us-ascii?Q?km5/pqOVdtjNmVKE/hCzWULbi14uLzmvKYAFRZqzD9LWI3SJX2yMcVCGn2b9?=
 =?us-ascii?Q?xy4AVgl6nV56McG+vspjtiiXTcPpbLXQdtWyCJip/WwKsdxe45RO1sAj8WHY?=
 =?us-ascii?Q?F/TS9G99s50nMwSv+wzz3tH0x1dAQ5SDC/5/v9Oos1D0/zz7C9X81jKBlAX/?=
 =?us-ascii?Q?lLzAVXpnSXATQ115iK3e6exAhhxvXPQO6aV4SP8Lvsi0Ooyh/PxSIIjAc074?=
 =?us-ascii?Q?lMhAswEbsdABLBPWEigAMeidAn6I2ODh1zGi6cvilH5gnu7OklBIp4YeEjDM?=
 =?us-ascii?Q?Tvk+SNU/wt1yMWV8gfTKOml6jtiK8aplPf63yejgwP9ls6R2gLtN1MdYj0xp?=
 =?us-ascii?Q?t3lNZ2Q/fvCndYDfmjD7V118GqDD9ICTS2BWNhkP+MUZqlfvJngzzqVpRCyb?=
 =?us-ascii?Q?KE2iGdp6fBMsvZ6pwt5lui5drwAiHF9HvcpN5zeWH5jMljmpUj4hbOkOV1Cj?=
 =?us-ascii?Q?O5pRfGarygDKY76h4TtNF0fZeYwsJGzS7fj/qEJU3bA3w3rIDulaPZCcBwGu?=
 =?us-ascii?Q?snssmX2gwzwNTEE8RJXFtjalXhUfsx0GHm/3sNNGtw71of9FQAh1xan15Q/D?=
 =?us-ascii?Q?Hw9RxYq4uq0hSY5kcW+/q2vvTinL7lyorRUqkN8mzEV6eApT+rRsxrM1TU0f?=
 =?us-ascii?Q?j7VgFRAV5xF49eICueTxyV+anu0RN2Z5PlEbf4OCX0PlpXcu3n8piHsfKDPi?=
 =?us-ascii?Q?hpp177E/Tc7W7UwXBfsNGlgqJr3D59GhTtCiWYxOdG+4g66WaFTV7b3rfJrG?=
 =?us-ascii?Q?UOHbd5l+K+m+MwkgGizVz1iQEufBkov9yT5UBYCFV1lsp2AdFHkBcF9/SOJf?=
 =?us-ascii?Q?VrtDOMFvTQZkQwRzqEDW2eV5H6JJdCNFCxc7K+JF/tQguMrtt1SRP/ZfY/rD?=
 =?us-ascii?Q?hJ78zR5FU1XijPzwLCcAhboNfa3rycD3bU/4j93T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f73ec6b4-7e54-4fe7-871e-08db293fbc84
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 12:36:32.6786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sKutjldZ/ne7k3rqHcyVsCqQgq9Sf2maDVlF1TwOUIHBpWbsBr6k+MsVprYePFf2UoLv7CWt0nDESBFIiM9Tww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5588
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 19, 2023 at 04:49:22PM +0800, Binbin Wu wrote:
>get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mode()
>to check 64-bit mode. Should use is_64_bit_mode() instead.
>
>Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS exceptions")
>Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")

It is better to split this patch into two: one for nested and one for
SGX.

It is possible that there is a kernel release which has just one of
above two flawed commits, then this fix patch cannot be applied cleanly
to the release.

>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>---
> arch/x86/kvm/vmx/nested.c | 2 +-
> arch/x86/kvm/vmx/sgx.c    | 4 ++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index 557b9c468734..0f84cc05f57c 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -4959,7 +4959,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
> 
> 	/* Checks for #GP/#SS exceptions. */
> 	exn = false;
>-	if (is_long_mode(vcpu)) {
>+	if (is_64_bit_mode(vcpu)) {
> 		/*
> 		 * The virtual/linear address is never truncated in 64-bit
> 		 * mode, e.g. a 32-bit address size can yield a 64-bit virtual
>diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
>index aa53c98034bf..0574030b071f 100644
>--- a/arch/x86/kvm/vmx/sgx.c
>+++ b/arch/x86/kvm/vmx/sgx.c
>@@ -29,14 +29,14 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
> 
> 	/* Skip vmcs.GUEST_DS retrieval for 64-bit mode to avoid VMREADs. */
> 	*gva = offset;
>-	if (!is_long_mode(vcpu)) {
>+	if (!is_64_bit_mode(vcpu)) {
> 		vmx_get_segment(vcpu, &s, VCPU_SREG_DS);
> 		*gva += s.base;
> 	}
> 
> 	if (!IS_ALIGNED(*gva, alignment)) {
> 		fault = true;
>-	} else if (likely(is_long_mode(vcpu))) {
>+	} else if (likely(is_64_bit_mode(vcpu))) {
> 		fault = is_noncanonical_address(*gva, vcpu);
> 	} else {
> 		*gva &= 0xffffffff;
>-- 
>2.25.1
>
