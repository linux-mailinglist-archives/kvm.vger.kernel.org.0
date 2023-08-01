Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD38676B9F2
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 18:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjHAQwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 12:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjHAQwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 12:52:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D442113;
        Tue,  1 Aug 2023 09:51:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cO+HJLfvluxGI98A6bfdtxhx/33N8U8nK0sRwpm08MOII5QK57BpZfaM4EDvrnH0kKPmEmVYi0wAw9eTSEoWZpI8UbaRq0oSbDqQBJjtGVZ4ONbSF4Y2e5yngKVqSltt6Tsux0GUPnd/7+ptRedx5pt5gbhVL9Fdtc59f5M3HAbFLKbbB3odbns2kpXqJEiVGv/EI/FWI5CNTuEOzjH1Xk6wf0MEr2HOraiAIK2S0V0JaMobKzS9pTtzz2aSODRkre4D3fRvz1VL22N0u8kbfOJUmMAbXGardSDnJ3mBrXkF8BFILk87xjT+mVk1mqXuUgjR929a3kvfUT67/gE0xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IC+ShgDtTmnbIV3uQ2IQy3ncZO6FsSB0A3iVaJlRdDQ=;
 b=kKg1yZgckAVLDP9Dx8pFbnFf/1/DykVAsmIYhUxBsZ8pJ2AzeLE8sgWsFCVI5dOGwqJmUb+eYUrdbpbgOsrK64mjTZ/kxmpvMyHtECBHft72SiJFPw+/xg0shMjEtJrZcv9k6SZjhDC8ynSsmUv3d5ZZGBoVk0XxWuW7U+rwprd7IXjjljuxKt/f33gvQ1mmCJKDavT6hybqL+fN+37vtCYlDzEP6fH5nvzYd2n5XtroblGm457I9sWUk66+WBthKuOXgO8awOTHw4dUJptzjnQQ3y5uANBhbAbxIqS2/zJE/c1ySheb7o7iRF++3mgkd3xvyU9Q5lwh9SewLIxxvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IC+ShgDtTmnbIV3uQ2IQy3ncZO6FsSB0A3iVaJlRdDQ=;
 b=SZDaUhMUKJWZMioBNG04S5K/fnC5HrX62NSq6KJlmcpRGxo2ZcCoWVnY+rafTw7sDMWd2xHvr229+7BDIivdmiwByZpQ/9lpxSVmJONB59SVLCHhdyvq8zSbAByORLoI4MllD38EAMvpcirj9oysiifJJDqS4cmXT7Q1qZYINOQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Tue, 1 Aug
 2023 16:51:52 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::1be:2aa7:e47c:e73e]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::1be:2aa7:e47c:e73e%4]) with mapi id 15.20.6631.042; Tue, 1 Aug 2023
 16:51:52 +0000
Date:   Tue, 1 Aug 2023 11:51:46 -0500
From:   John Allen <john.allen@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Subject: Re: [RFC PATCH v2 3/6] KVM: x86: SVM: Pass through shadow stack MSRs
Message-ID: <ZMk4Is12Fs1XlRwU@johallen-workstation>
References: <20230524155339.415820-1-john.allen@amd.com>
 <20230524155339.415820-4-john.allen@amd.com>
 <ZJYzPn7ipYfO0fLZ@google.com>
 <ZMkj/HORmSy685cH@johallen-workstation>
 <ZMk14YiPw9l7ZTXP@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMk14YiPw9l7ZTXP@google.com>
X-ClientProxiedBy: YQZPR01CA0100.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::21) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DS0PR12MB6608:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b40152-5d13-4215-feca-08db92af9b48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l8iLj7VjYXQR0pq0iU3k6VJhQ8fh0d2pM7sbUNFvDduqzWC3XTxeJ6PEp/sl7aMBQf59zd002dUdrK7i9Yi9RrkvIVJMOAcHDZO3FoMUbtcEa6gQ2nqTTG2vn3RLmZjC88+ACnrVnt0u1IbUX6tj36koY+RsuchW/xQTeaPmtmICcwYVyJtDECG/1oZ0nmRQ0klxlcdBEnzt71pFeC1kGgM+GbthMj0Cm/xOO7khMil/UuLatZE//tQpbXW7JpQD9Asx8L0Qf00zDcExFkSSyvpZrM0IVxJS966fBMCblwcuFEKJLrwEWOMVXL2nLekT3DEduNlEvcdqQ3mxV/F0O9juxu8yQRbGPYXL/B5QyRbvK/6Ja0EWeLe/UlkGNRL3zukLddbENRJScc7daiTzr4TW1Fb/ylLsVzIzpZ12x/D9/psMylQGocHDrW31VzP8mhxuaW1yuBZpbf1LuMXQQpgSY3t0clUvcOnTLYkxqKl3eV4hWI+QyMQIPMn8VcvUMENy4Q5qoyeIZt9Oe/RzLLLzgU087MZXdVuSf8v7azaVLQbhIIsO70x5YTLBhkla
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199021)(66476007)(86362001)(8936002)(6916009)(316002)(8676002)(5660300002)(4326008)(41300700001)(33716001)(38100700002)(66556008)(66946007)(478600001)(2906002)(6666004)(44832011)(6512007)(9686003)(6486002)(6506007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Zb8iDNmGth7wDfotsI/GKUWpWC9qPAKKLcOTkfTW204S6phd+Nq/LJJyayu?=
 =?us-ascii?Q?rhKIvgmwMiwWMpRd6etvkqEf1pChqbLNKRtHCSWd+gXUEPSSrVG6qVLj612m?=
 =?us-ascii?Q?N590Hjd29hXRJdCdTGNjCotgc62IzqohwqFNuTYhmYrZB2hC1cpJaOQrjK44?=
 =?us-ascii?Q?BxP1BLs7/zpGDjsAntPNOutH3H4jc6j7HzgbWQebqrQLQ786YgsBf8rShf/A?=
 =?us-ascii?Q?lcl+BDNzDskr7o40yQqbt5HZmjAoj4i8h7E5/AgMwOEXvyQeZRRRGqtexZy0?=
 =?us-ascii?Q?yILcIt4qCGoqKjRNJ2iJLWl5Vi5adugWvfA4GbCOzsdl5t4VcpXS7RoPdq3A?=
 =?us-ascii?Q?7MBgsOOszQVbzTWapyeEWUVvmMt/QjElgx8mSgU4gqgFQUKtFZODJY+qQMx7?=
 =?us-ascii?Q?Lbejm6+hNxzx00gK27w6grY9SCm695f87HezTSO8J+TNed7rJHhsTeeGuyq3?=
 =?us-ascii?Q?mVIvebGwJzRbnrK5HJbMZtLcAevDTkaLZSqft3xmIpxo00ulzEi88GCPG8G5?=
 =?us-ascii?Q?tNf1vi/c8mWA2BkGp3vq2wmJp1q4TMYQWGXEP2nyi3Eo6puUm700j7cT2CKD?=
 =?us-ascii?Q?SAjc9dAQsDlVAZoyuPFoBMfHdTqO0SViqi7KAm/uPFPCT0IBh/0cwsvltVeT?=
 =?us-ascii?Q?u2I8KL4EzuwoYWfmUSRyoIh6dNLMxrJVd5ftvob9cKE7N2X/Jjp2um10mZPC?=
 =?us-ascii?Q?7iCufFQG9tHTuKLEa1MCExwW63P+TarnN7VnSqAl4XcRBMAKPz8yr0d/OyS4?=
 =?us-ascii?Q?MGm5dSJj2tVy9nZ2KqGxroIpIMBLSS8td5fVebzhxNVOIctCnrfrY6vSZ86M?=
 =?us-ascii?Q?dc3bPTJM9oHIh5qzf+paTMV4AkBa2B+kvkgkVal95f604CH7uweYqJUe+ekA?=
 =?us-ascii?Q?FfFk+6P8Md1qI74IPHvT7AjfQ6JYqZ4sCeyiw2g9tni6GoYc9uNaJ2oOwjrM?=
 =?us-ascii?Q?nAT8xRqzl+77+vn+EmixABRdXaSM72h4RbCFz1rJMR0yJsUqCzofmRriPZ8y?=
 =?us-ascii?Q?8OIQQg+2RY+SAAtWarMwBah4CQMZ/qDvC/IhbXNxHwDBkSnnUmKm3uASOgoY?=
 =?us-ascii?Q?Ysvm7A/uzBcP6C676lH4qzQxv/yA6T17fU/R+G+Fr4ycMAnFpvzrAd6E8mFK?=
 =?us-ascii?Q?AvV8enqJ8oSivNQHajXagvaht++NC7I6riQvuQxzEaO17wolqs8jKs4j5Krh?=
 =?us-ascii?Q?gcYo5zAw5lyeE0HtNYEme+hhwrapHYNyFtMd16hT6jtnzm6jhDZcS8E/X4mS?=
 =?us-ascii?Q?2Q3x9IHShL1dH9LwDosXXPfm0Q2fY/5+rj8V5TeyFPYeptm1Hq/PFi0IHJdT?=
 =?us-ascii?Q?9ILSIAIGm4XFtyfhvQHe/tvmbZIE95OD0ksKnh1SuE/Y/9QHVOvOtNVjhxJl?=
 =?us-ascii?Q?qM/aQfT6jgnmdV61Bqxo4ug62vZloiosvEcZ+diiEsUCMXXqHQCzzuZgFMKo?=
 =?us-ascii?Q?NLHgfFwxcg3WlN9C8dFj8bHTTGy7a1ywqtifUA2o3rkWObZxcLJ3YvjPkuEs?=
 =?us-ascii?Q?kvWBpSj69azD/Cp3SuUnIHdtwzzXOgzQMnRlEol6vOwj7ZBYL+Xsk0jbpJLK?=
 =?us-ascii?Q?EpsykfOwyO3O7TKke2ucu8ag0uPQ+UOrpWrjWPPk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b40152-5d13-4215-feca-08db92af9b48
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 16:51:52.6842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjWCPR2I0BCs5roDTAwDhUaiyo/mkydJPQ5kGXYtCg1Fh1hrog71+dHgBW9LiCSj/ZuY8+uD0LxdsBYR07Llvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6608
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023 at 09:42:09AM -0700, Sean Christopherson wrote:
> On Tue, Aug 01, 2023, John Allen wrote:
> > On Fri, Jun 23, 2023 at 05:05:18PM -0700, Sean Christopherson wrote:
> > > On Wed, May 24, 2023, John Allen wrote:
> > > > If kvm supports shadow stack, pass through shadow stack MSRs to improve
> > > > guest performance.
> > > > 
> > > > Signed-off-by: John Allen <john.allen@amd.com>
> > > > ---
> > > >  arch/x86/kvm/svm/svm.c | 17 +++++++++++++++++
> > > >  arch/x86/kvm/svm/svm.h |  2 +-
> > > >  2 files changed, 18 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > index 6df486bb1ac4..cdbce20989b8 100644
> > > > --- a/arch/x86/kvm/svm/svm.c
> > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > @@ -136,6 +136,13 @@ static const struct svm_direct_access_msrs {
> > > >  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
> > > >  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
> > > >  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> > > > +	{ .index = MSR_IA32_U_CET,                      .always = false },
> > > > +	{ .index = MSR_IA32_S_CET,                      .always = false },
> > > > +	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
> > > > +	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
> > > > +	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
> > > > +	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
> > > > +	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
> > > >  	{ .index = MSR_INVALID,				.always = false },
> > > >  };
> > > >  
> > > > @@ -1181,6 +1188,16 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > >  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
> > > >  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
> > > >  	}
> > > > +
> > > > +	if (kvm_cet_user_supported() && guest_cpuid_has(vcpu, X86_FEATURE_SHSTK)) {
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_U_CET, 1, 1);
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_S_CET, 1, 1);
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_INT_SSP_TAB, 1, 1);
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL0_SSP, 1, 1);
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL1_SSP, 1, 1);
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL2_SSP, 1, 1);
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL3_SSP, 1, 1);
> > > > +	}
> > > 
> > > This is wrong, KVM needs to set/clear interception based on SHSKT, i.e. it can't
> > > be a one-way street.  Userspace *probably* won't toggle SHSTK in guest CPUID, but
> > > weirder things have happened.
> > 
> > Can you clarify what you mean by that? Do you mean that we need to check
> > both guest_cpuid_has and kvm_cpu_cap_has like the guest_can_use function
> > that is used in Weijiang Yang's series? Or is there something else I'm
> > omitting here?
> 
> When init_vmcb_after_set_cpuid() is called, KVM must not assume that the MSRs are
> currently intercepted, i.e. KVM can't just handle the case where userspace enables
> SHSTK, KVM must also handle the case where userspace disables SHSTK.
> 
> Using guest_can_use() is also a good idea, but it would likely lead to extra work
> on CPUs that don't support CET/SHSTK.  This isn't a fastpath, but toggling
> interception for MSRs that don't exist would be odd.  It's probably better to
> effectively open code guest_can_use(), which the KVM check gating the MSR toggling.
> 
> E.g. something like
> 
> 	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> 		bool shstk_enabled = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> 
> 		set_msr_inteception(vcpu, svm->msrpm, MSR_IA32_BLAH,
> 				    shstk_enabled, shstk_enabled);
> 	}

Thanks for the clarification. I will use the above method in the next
version of the series.

