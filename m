Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABFC76B865
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbjHAPTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjHAPTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:19:38 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C95F116;
        Tue,  1 Aug 2023 08:19:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKGu1bzCMgA7RHDt0/HlITuKuzniad9wifov+H1kej8Jyx8Dkdv4YiQ9hUar4Fwz5wVF++AdHdO7bJnYgoLFpE2l5cIX+0qDLJZeQ9dR5Y7zpd0HnQOQLklOeCf/DfapABIlhLaefZ3oECy8fE5YSonSgJBFiM9l3sJE5oQ5OEOCTWdAuwKeeYa3yTeg2NzUGZMdSQncm7BT6JIlJCZd42I8PMwIbJyI0HyfCeOt4rwP5auI1Q60J2KFrd7TzlBL4SY6Aa4jydzji5ZXGo9gfGuUwwZLhKIGUV3nbnNwe1yvuALBmSQzBMdhdeMdixjKTIGLTvN/Cf3Pd7xKxLaTaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDtZqHpdLbYNvlJIgo+PVsAHqUQQtVqk7o3qc7Xs43k=;
 b=nCIdNFMGw5vnB04fbuM5vfDNseiF9+e0HrkPOmsEkjmx4tD/iw6Gr/qQuGINMoB3bkLjkQ8Bppo9cGNiYf/0gkmXLvzAb+0YP+mrUjMh3P/2i1U0sNvnd31ywuDA9PrkKZiwQOYgWlnXKBtlbUV+q2LEXnSZ3POTFA+y/jvR4sIiYXGRjxqqtaCR0VD6Et7LYgakrRWWJlysk77Cr1+lYe06CvwtJTXl9aDNnwFxKaHjy5W7bIfNc3Ko1BR+NzOlw7Ztidso5XDNlJxwd3UY6539ouAFmuhNKwvzawkjPRMl/y1X5FohA5A47nZ/j35hNguvXUrN3xrvisWuhSbf4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDtZqHpdLbYNvlJIgo+PVsAHqUQQtVqk7o3qc7Xs43k=;
 b=H+J1FCLKCXX3NzARB3VbqIb4Mut6JJp6v7qQD1pSr3SEUL3ielvKTXPfhkckUa7AEQG7CGSVYZpVkrVsT9bJ/DAMPNhHtRIkEjf+B58tLlGCLptI7mTyG9tSHMzE6cZelXVwxeJ0lMwnwboxGsS7peVoZ4a4JVcc5Qlsaiat8xA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by MW4PR12MB7335.namprd12.prod.outlook.com (2603:10b6:303:22b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.39; Tue, 1 Aug
 2023 15:19:34 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::1be:2aa7:e47c:e73e]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::1be:2aa7:e47c:e73e%4]) with mapi id 15.20.6631.042; Tue, 1 Aug 2023
 15:19:34 +0000
Date:   Tue, 1 Aug 2023 10:19:23 -0500
From:   John Allen <john.allen@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Subject: Re: [RFC PATCH v2 4/6] KVM: SVM: Save shadow stack host state on
 VMRUN
Message-ID: <ZMkie3B7obtTTpLu@johallen-workstation>
References: <20230524155339.415820-1-john.allen@amd.com>
 <20230524155339.415820-5-john.allen@amd.com>
 <ZJYKksVIORhPtD6T@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJYKksVIORhPtD6T@google.com>
X-ClientProxiedBy: YQBPR0101CA0186.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::29) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|MW4PR12MB7335:EE_
X-MS-Office365-Filtering-Correlation-Id: 42ab3158-2f15-425e-5d11-08db92a2b5fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZB4evB0XSUn3Ynei5NLF3Xf7bexvNogo3NMWPQCyVZ4i2DxiqSq0ORhENCsnvFYFaKjZiIIHlXg3slf2+R+bM8J0Q6hEvG/gkIwPmUNG1d56wCGAt2yGEjU73l4S/asWmkJugOzeWe40MPEoHbj//esaTA1yMMmxRVeUDYB2WcRiXvkJVqWBXVJGBugoY+Quupjp4YaYzdi7vMJ2JuNBKFjBKeub1voOwYhlA2NJ/GURWZG8wmcjDPaAJCCtI5pigEOyF0QQjgjS9LjgffNOHMQAqcDIEHGzZBgW80tlHuYZFGBUZKIDM8lymxNedMoD9PZiV25KoU9tvc/dYSFoYeEUgjHfIoxliPkMfTSjnfwOpCjkXQP1wHyWINnbESP9kGZmC5RKQMSPH/O3BGKam3C+rxXUVhKR3OXjZ7QnWMo/O8py13v2raoDemOv/d3I7gWbaaV2QDFENlUWO2tixh+bwbthiqx2iOy9wtY5GH5C897+SDFhmwwHFXlJTaN4VaJfF9kK2ZNcIXz/IjCvkzYl7ePMbLPLBAZl2HOAWn1xBBjGZt4wdIpptdN+k1j6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(44832011)(9686003)(6512007)(6486002)(26005)(6506007)(83380400001)(186003)(66946007)(66556008)(33716001)(41300700001)(86362001)(38100700002)(66476007)(5660300002)(6916009)(4326008)(8676002)(8936002)(316002)(2906002)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i32/Dihzi/BP0KhLYx43zXW6bD2t/zozwUlBSh5/gS2NVuhQNIi1R9YTy9Sj?=
 =?us-ascii?Q?Imz/BiewqrkHypv4tqUjdqbRuFHotl8WZMh53BN9+WtHVCSvBTbUetz+Yupx?=
 =?us-ascii?Q?vI6w7im1dyVxIz2vYs3bUjDpZzUhn5nmNChZ5wlN6c5zYsGHLZDRk+63wORb?=
 =?us-ascii?Q?JNANBkcMlCIEdnOJIZPaOiBTRI5TSlBOqzTiumdfG00YNK7yR6x92rhftTgx?=
 =?us-ascii?Q?Vdbz4Vh5jGL+u2GYc5wHAwyIzsBl4iGzA1uceub/CRwnCSYI5wIEu24c/Low?=
 =?us-ascii?Q?DDV+MfOaGN688YL5s/4lQtaj4PZMtMwbFeJRFY+EKoLgbkpkIF0MnOMEF6b4?=
 =?us-ascii?Q?17sAuFShagka6FM6I8zTchBifVfRstKhO3qCoxHZ3aHnVA6+pYijICqzwzsF?=
 =?us-ascii?Q?//c92bRv+t/lyVJXJm/ryGY+15FJzxhcE2FMmz+bXSMUgmikemNWG3jqrRtr?=
 =?us-ascii?Q?Wykw41HcjXXcrwU30y3RBwMei39MLSjP7Qi999pX8AH3M+QFg/CqySD2E3pu?=
 =?us-ascii?Q?wv7plNjCDl/MBMA13zgM2HiYPwTK+bIi1kw5DNPpTJavkzZNF50HnfviEDvy?=
 =?us-ascii?Q?mqeElB2ZP6shQZKrvqi1MMyJibiyjXHMFnrYnEQQ1nG8KxhGpJ6BOnMevEoi?=
 =?us-ascii?Q?hPQxSTl1BRUhp7UrIijT8QCfZyTuQB00roh9ebSu2Ah+6cEtXpsCmH7xlTA9?=
 =?us-ascii?Q?6P14f0kCNQ7FGG5/dYKqicIcSmf6mttgPaHmo7PNSYMC+65ZD2VCTPlp08e0?=
 =?us-ascii?Q?2zNW9SvIuxli6Gy3+HipgE9NgHKaXDZseaGAMYDAzbtWaCXHfgQVkuCJZeOt?=
 =?us-ascii?Q?a4+2v5i4wemsRYuCUS04GWFqZTdz3zQ1Q0c5GWa29+/DGjChuNDssc4qcstV?=
 =?us-ascii?Q?3HDtewNTS5Za8jR3b4pQtInCXIXq1uAuqNH0I9MxG9hLcFdjsW1w5quTrsT6?=
 =?us-ascii?Q?vLfOkYEp3qrdLSi/+hB74H4l7TaMf0I/f4fu1DG7wFjJ+UKQVjFh7RN+knJ7?=
 =?us-ascii?Q?PpJt2P2cwX68mHbNGoG3qlndUkluU+yFOFY4GQr6GFIX3Ce9Tj1NyoaCi7hm?=
 =?us-ascii?Q?AM226+AiF5cCv2WwpV+4ZTuorXwvsYzRGJMrQj3ADkGELUE/qM0rRXs6SnmX?=
 =?us-ascii?Q?URQiYASYFkDjm5SSrhAwMJd2rOg/9oH8f+Dld2EO595TwW6N6MtaVwP2ZuwL?=
 =?us-ascii?Q?W+1z2IqRLXbns3Hm1GpMihRyTpORDYfM9HHZePb0HZ+Eh1K9Yd27aXRbRoff?=
 =?us-ascii?Q?A77/dBTYN45HQy8LizjJMfFQ2ldP5dtYP6fwKvFKW/u9FU2Yyer1aca8zYKa?=
 =?us-ascii?Q?L7OCcT0g1K8degmz7RC6vSAXn0U8RnHGGHDXY4cku12iQZhYOrcs3XdCtZzE?=
 =?us-ascii?Q?SPM7XJjO29QTlfpC5Jxy8qC16R2JZAG99pNqnyoczCxssd6B+Ek8dIYAPiyr?=
 =?us-ascii?Q?VOkrEaBc423bVn+TDsA7dyjMDWy1gcSxg0Y2hDyd72WP5nNursEDfjM7V6bP?=
 =?us-ascii?Q?ypb519s17NL537q8ukaY+r+l30E3eCGTA3AYFYnh9EGVJnERnMCwlF4XOeOo?=
 =?us-ascii?Q?E4hSZBMwpyZRRy2vz2/DCrGwb23EJ5ocsHptOy6P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ab3158-2f15-425e-5d11-08db92a2b5fc
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 15:19:34.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y1xy+yXsu/Xu9VVe4tzGbeOBQOp0NRgsGel/I3oWhmpB/PYTNq7xGM2KMnk+YKm31vLym4rJWBusAXdmV+f2Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7335
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

On Fri, Jun 23, 2023 at 02:11:46PM -0700, Sean Christopherson wrote:
> On Wed, May 24, 2023, John Allen wrote:
> > When running as an SEV-ES guest, the PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP,
> > and U_CET fields in the VMCB save area are type B, meaning the host
> > state is automatically loaded on a VMEXIT, but is not saved on a VMRUN.
> > The other shadow stack MSRs, S_CET, SSP, and ISST_ADDR are type A,
> > meaning they are loaded on VMEXIT and saved on VMRUN. Manually save the
> > type B host MSR values before VMRUN.
> > 
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index c25aeb550cd9..03dd68bddd51 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3028,6 +3028,19 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> >  
> >  	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
> >  	hostsa->xss = host_xss;
> > +
> > +	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
> > +		/*
> > +		 * MSR_IA32_U_CET, MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP,
> > +		 * MSR_IA32_PL2_SSP, and MSR_IA32_PL3_SSP are restored on
> > +		 * VMEXIT, save the current host values.
> > +		 */
> > +		rdmsrl(MSR_IA32_U_CET, hostsa->u_cet);
> > +		rdmsrl(MSR_IA32_PL0_SSP, hostsa->vmpl0_ssp);
> > +		rdmsrl(MSR_IA32_PL1_SSP, hostsa->vmpl1_ssp);
> > +		rdmsrl(MSR_IA32_PL2_SSP, hostsa->vmpl2_ssp);
> > +		rdmsrl(MSR_IA32_PL3_SSP, hostsa->vmpl3_ssp);
> 
> Heh, can you send a patch to fix the names for the PLx_SSP fields?  They should
> be ->plN_ssp, not ->vmplN_ssp.

Yes, I will include a patch to address this in the next version of the
series.

> 
> As for the values themselves, the kernel doesn't support Supervisor Shadow Stacks
> (SSS), so PL0-2_SSP are guaranteed to be zero.  And if/when SSS support is added,
> I doubt the kernel will ever use PL1_SSP or PL2_SSP, so those can probably be
> ignored entirely, and PL0_SSP might be constant per task?  In other words, I don't
> see any reason to try and track the host values for support that doesn't exist,
> just do what VMX does for BNDCFGS and yell if the MSRs are non-zero.  Though for
> SSS it probably makes sense for KVM to refuse to load (KVM continues on for BNDCFGS
> because it's a pretty safe assumption that the kernel won't regain MPX supported).
> 
> E.g. in rough pseudocode
> 
> 	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
> 		rdmsrl(MSR_IA32_PLx_SSP, host_plx_ssp);
> 
> 		if (WARN_ON_ONCE(host_pl0_ssp || host_pl1_ssp || host_pl2_ssp))
> 			return -EIO;
> 	}

The function in question returns void and wouldn't be able to return a
failure code to callers. We would have to rework this path in order to
fail in this way. Is it sufficient to just WARN_ON_ONCE here or is there
some other way we can cause KVM to fail to load here?

