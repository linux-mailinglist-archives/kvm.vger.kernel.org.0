Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FC576B88C
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbjHAP0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjHAPZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:25:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B551FC3;
        Tue,  1 Aug 2023 08:25:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxRpt4BcETLmMy6Mq3dpzIJcR66aHuncXUkuSzIayUgUNC3u5i07kmasV0TB/rnT9axu1fcAiPQ0g/eUYIwB2mOiTRJJSAWF156gFQ++1bECy54g6zz3budTOhQx3XkG3nqvRaaG9msXMn9C4LuzBLCEeyP+C3lzCAHg63eBiA/c8hGnZhVBACUeulPupAwix21W9A6+8xkjG9pURgCuI0BTBFqGl42wslxG9kDBV26+2guCk2oJ/1lJhvZtRKohpoz8ySxHu0PVl1Ht1aKFjLGbEuEdQwaMb5ZccN5h0rkPL94HzEMPPa2w9oFHBg/HLpzULkL53YLrpRUMv1jERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/ecqjCb8p0UwVeLJ+JdqBi9k3dAx2GubD/HhIKswfI=;
 b=nUy9J74xCS5nGYPalrdaHBmrh/Cy+eqOenFb1Oq0YGsUwHVdhqyk7qGV8ikgMasajzkkeQq0mR6qJtfWYH8QDnJH/doOdA10fCKINTIjXFo+xtPViRhau8aic1z7lbY6lK2xRM7pOsIovKKsY07N0Lpn8XFX8+PN7tBkEKSh0gm44Y9JbWdM30zDTz4B+8JHgaA3n6D4jK2FyUuBahwvPsgFdom74ehkHpfvwHf4I2uu9IRaIN4WH6i0Mf2UQYyea4uC74u1cHP58XAYcmWwzrgyzRAV6bGikJrZPy8mSBRW+yQyxaWwHFdmsbYC+GBfmLfxPEvMlvhnOycIkNvqbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/ecqjCb8p0UwVeLJ+JdqBi9k3dAx2GubD/HhIKswfI=;
 b=MV94mVhO4OkNKQnKZZg1R9N2dKyyZeNNr6RQ1tcQE8qULNW9kHCBBrLAB5wES7v+9piwDqSzIIInf6uq1Ql9UWLpBgV4kIVOJsIy4ohy4rK4qHJcmPsefu0ZouSK5gW2/e661cnujd408sytWQ56RD/LQnltJloB12OFb0hujek=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by CH0PR12MB5089.namprd12.prod.outlook.com (2603:10b6:610:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Tue, 1 Aug
 2023 15:25:54 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::1be:2aa7:e47c:e73e]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::1be:2aa7:e47c:e73e%4]) with mapi id 15.20.6631.042; Tue, 1 Aug 2023
 15:25:54 +0000
Date:   Tue, 1 Aug 2023 10:25:48 -0500
From:   John Allen <john.allen@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Subject: Re: [RFC PATCH v2 3/6] KVM: x86: SVM: Pass through shadow stack MSRs
Message-ID: <ZMkj/HORmSy685cH@johallen-workstation>
References: <20230524155339.415820-1-john.allen@amd.com>
 <20230524155339.415820-4-john.allen@amd.com>
 <ZJYzPn7ipYfO0fLZ@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJYzPn7ipYfO0fLZ@google.com>
X-ClientProxiedBy: YQZPR01CA0043.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::21) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|CH0PR12MB5089:EE_
X-MS-Office365-Filtering-Correlation-Id: 757f69f1-da45-41a1-a9ab-08db92a398d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ql0dw93OkPeYa+R0KcmjP8aY7k9/rKm/wLBAbP6JXLMlT16yIKgArh++xowpVxfZKT4kFdC7exM1xdb5bf5MSlo8FzykfhzEpRFQBVJylu4CfD6gAc5gLwWbhYkxBipXoOUXaFKSb/lHMC4bL+J1t0ThYX8TcIBvG0w7N+tHqHzJIIbWz66pWZ8ixXsiMsjwZnUhnJJZ/j+PnWl7jblVirci18g5UQD4rwrcZap2UwY8QW5cxCfY/mbhA17ikf7W6Itj0JMk5bPrkWkttgoL1qDOWhsEhM+i84qo46CPLm/lVldG30or5SSsU/STQWnn0Ct6h61OOlHCLiE38iYs3iTrGDsDGmhEgM+50zh5rYuNndaY4jTcl1A6gK7z6A9VfVsYlX6MiVApf0tdzwS2Bt9ue3oda01SE9YUUCGaptF+SKPv2fex1/gO++58A41s1xqH1+peEpNSKcCUWTCQhMxrz47VRq/NMJc5g8JlUO54bVSprwP0R+uqAzwiIn9kTMJKs+Adb3HrGt64SOpBqqENNUh5dDbkhUoMyFGH35Q4lBFYolAO8lasnSU7bmOJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199021)(38100700002)(6506007)(5660300002)(4326008)(6916009)(66946007)(66556008)(66476007)(6512007)(9686003)(478600001)(33716001)(2906002)(8936002)(8676002)(6486002)(41300700001)(186003)(316002)(86362001)(6666004)(26005)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XHa9zATdNGpR6bcHR3KhLZIL7JltXXEjEHfjmFr7Wrf2YuI37zUG84JIb8H+?=
 =?us-ascii?Q?AF2S6ThpzR47wjb5yaq8ha2AzEGu1ezL86WNKKyX5guvVZP5q+rTMc00GHMU?=
 =?us-ascii?Q?Oqob2WqqgkiSNPmjQo322V1LiKa8WcSiGnz+0g50xDw1MyibdikNfbJtJwx8?=
 =?us-ascii?Q?ubQG72M6umJXANArrQqoEcpCRKK+HU6aO6yH/puXUg8MoyLJ7Eidbqtyxc6Y?=
 =?us-ascii?Q?0+bjijtuLUZA5WaaGMOXkOd6pv7hM7Yn/sPTp+Tt87czlvyLHPaqbM9wJN4l?=
 =?us-ascii?Q?uhNxb7SWTNeIzXknu08an9IoOIS2QhXTWfxv5fAMMq/N4Pe3ZBAwbXHY5t4o?=
 =?us-ascii?Q?yWKeN/ty/vpR5UbvlDDtN42mdJasNEQ0MFZWKoilJz/1i6ZGAFqagdUJzbKx?=
 =?us-ascii?Q?F9qmBmrNXR15ChKTitLb7OhnYD0+hfRHinEMKZlfFtOXkVaFy6KmE3hMIL9K?=
 =?us-ascii?Q?oQHSD/8stcRcV+S6HAmsK8OKYLnQMHXf7/dqSe0czVrwugKXIu8XQKUrZoPE?=
 =?us-ascii?Q?wpT/t6FGkjBF6cMGqZHsyc10ym23i/iUabwfOWT+ErOcBdXsb8bK+a1I5PhC?=
 =?us-ascii?Q?tyhaBJHLcZEfWYTyLdh0Z68fNjBAv65sq/jK0LrKcYfJXYrth+qjCzqn2UPT?=
 =?us-ascii?Q?QgiwIWOyPBeji1y+62lP0FmATzlxKwFefUV2wUP1dBtg1a9HJD/DdVGHdoih?=
 =?us-ascii?Q?4qiRHbT3ok4l0t6CUDg+H0z7RkVjetzniIJGbyHwnhrD5je0Cxa8SXoSvM05?=
 =?us-ascii?Q?EJdtVQe6DGkTRcfX5yhgW1IP9zA2/XxCGr1iaJocBb7L21WG9PtQk1Sg0xNG?=
 =?us-ascii?Q?3N6sL2aP+bHs0MwbbdRJLniGVU5qd4OwSedCX20a0K0DgOLCXnlonrtM3FRa?=
 =?us-ascii?Q?oWEVRmT86sjm7rfQikOuzowxmNzqXKbV6EUee/GfpdA/Fn+ShDz86cLxr+hc?=
 =?us-ascii?Q?9DY+J3iLvv8IOdAfatxt3ix8+JD0j5D6ak1csVRpu45pMrlV/ytwMFoEG+zS?=
 =?us-ascii?Q?ryycf0E42qPojNRzRINt51GBusSxshZ/Ibd+qV4eAiW/SklORcPAVh8jq4n3?=
 =?us-ascii?Q?QYV/G0uIchQ2jFIOdjzOX6FeQ44fbbZBQdxaypP8utzuP49w3WHbnN7e5ajt?=
 =?us-ascii?Q?2QEy0bgntaLWvXA0mWpv20Dy/RsSc4P21ZWLsHOHCAuhPMRqAKyGBRSR6KNx?=
 =?us-ascii?Q?VzpyHjiEN2mnk2iz0SPiBLYkMQPiL15FerUYepRfO27W7cqQ4VNX+rTnNLMT?=
 =?us-ascii?Q?OFcbiu3Z8N1JPIjA25+5zz+bFROPn/ukim9nIZjUroUVLwqImyxndfY5o/Xz?=
 =?us-ascii?Q?nmutBUH215TZtcGJY0fzdH7spkasIa4X/rGODlbtWob/Vtgmg62XX8TJJoLT?=
 =?us-ascii?Q?gNoE/lcQvAWMpuDxnMvHEN/gGiFdl46z51PxtOoRPTLikllXRU165CncaiDW?=
 =?us-ascii?Q?M0EFgDErTv1CfdycecBcXRTrYi/1dEBpqFPq7HOX00sKZ6WtLrtwUVOPkwlg?=
 =?us-ascii?Q?v2FArJJX6rGKDGGzvEabgU3NnSRXzkFVOhVz06gaGJEGOs20cGkTYUMEElP9?=
 =?us-ascii?Q?y+cAnTsQnvuVCaGQmyYKHlV1et3V3mDHMOo9AUCo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 757f69f1-da45-41a1-a9ab-08db92a398d2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 15:25:54.5766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5Sq8f4ZMVF7CiMmGq8qun4mcb3dgkH3+O12paMFKm5JBaB0aCEvCUlPfABW3O2AzcFwxugLy2KbSe+9Jb5N0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5089
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

On Fri, Jun 23, 2023 at 05:05:18PM -0700, Sean Christopherson wrote:
> On Wed, May 24, 2023, John Allen wrote:
> > If kvm supports shadow stack, pass through shadow stack MSRs to improve
> > guest performance.
> > 
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 17 +++++++++++++++++
> >  arch/x86/kvm/svm/svm.h |  2 +-
> >  2 files changed, 18 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 6df486bb1ac4..cdbce20989b8 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -136,6 +136,13 @@ static const struct svm_direct_access_msrs {
> >  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
> >  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
> >  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> > +	{ .index = MSR_IA32_U_CET,                      .always = false },
> > +	{ .index = MSR_IA32_S_CET,                      .always = false },
> > +	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
> > +	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
> > +	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
> > +	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
> > +	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
> >  	{ .index = MSR_INVALID,				.always = false },
> >  };
> >  
> > @@ -1181,6 +1188,16 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
> >  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
> >  	}
> > +
> > +	if (kvm_cet_user_supported() && guest_cpuid_has(vcpu, X86_FEATURE_SHSTK)) {
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_U_CET, 1, 1);
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_S_CET, 1, 1);
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_INT_SSP_TAB, 1, 1);
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL0_SSP, 1, 1);
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL1_SSP, 1, 1);
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL2_SSP, 1, 1);
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL3_SSP, 1, 1);
> > +	}
> 
> This is wrong, KVM needs to set/clear interception based on SHSKT, i.e. it can't
> be a one-way street.  Userspace *probably* won't toggle SHSTK in guest CPUID, but
> weirder things have happened.

Can you clarify what you mean by that? Do you mean that we need to check
both guest_cpuid_has and kvm_cpu_cap_has like the guest_can_use function
that is used in Weijiang Yang's series? Or is there something else I'm
omitting here?

static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
                                          unsigned int feature)
{
        return kvm_cpu_cap_has(feature) && guest_cpuid_has(vcpu, feature);
}

