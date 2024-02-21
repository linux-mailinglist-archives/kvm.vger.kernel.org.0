Return-Path: <kvm+bounces-9331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF1D85E37F
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FC73B22008
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD70582862;
	Wed, 21 Feb 2024 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="shC+rAah"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113C77F7EA;
	Wed, 21 Feb 2024 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708533500; cv=fail; b=EMxaUHTipQn8fj8cdUDAsnnCtRlcw/1iInW6WAZeR9EHznZHvF6Qa8ldfyETnnsBentEbhrB/emQbQqIWFVXKtDBiRMo9wwIWm2+dUoGsfdKDXYAWOI5F2FrElFdJe854kdTEt3McvZxY3N3omBhTXmGq/RI9djUpi9TZwiGiI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708533500; c=relaxed/simple;
	bh=kWb1UyRKHIjKbMvxBSWWE9lQtJA0MEbl8ovcEkX76/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OwqsdzytELKsfgyRHZVDqe0I5Cw8ycjp21j9dL+IJEG/Cq+BJ39xBINWb27tGBWLwxElMs1YQ/jKoKJbzWU8KMcJJGM2oZEB5oB8doaHGXiQ0TuEm9xid2Vc5vHCL7JLkk9cmy/lIqDU+Qr0wC2pACQ3XYChN32b+YbErIpBDHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=shC+rAah; arc=fail smtp.client-ip=40.107.94.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoYiGXhDxoq9KBLD/xfPbjmyrFZBq6PivG8I+v5UpBFBS5hQHulMj1ic6E5vdHkSqrqhSfv/9h4IirDZ5rJE0sFWBXCGn6tWmWuYyp0PsKX3C30bCpxj4wlbdYFfWSgb8iDyY/EEZqQ+dIGBuWr3evm+vsK+6TNdr1m9nVyQrNBJOvBVh9npE1EJ2ZnkT4inb5nm++7mw46XahW3QUJpVllEnvqEdpwX3X4DTDnsS3o6tDNnYPdxChEIIKLLBbc+5e9ZOM8QmpfaqOBVJeylnFwRlo4qJVWffYDolykw+ZfJ14a2uSL+r7anCIyu0gDqNwwRcRogIuQj1GuqHnluQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4N0OxAhtBk7mfKU1E1ysqqMztceX3lFjdINxbZpk1k=;
 b=G1vmOodFp+inwrL0q9Cvq0TMa1ipJ5U1SNh2PcyvS/ftyGj8zQxt5ppgwyIFFxZ0+ZgKdbo2+wsGfo7dsSELT6GUQaMzCqc77MJkU6Vmzvr0qalZQM4+eyjIOcM11AhRd74f6pmcXQOCi/USVoEczaeJffX67Wiv1m4mVI+5/GrWlA+NdPeH2ClXccmbFtv/QnwoiKx/YRTVBTrqyY68HSHsQ4Lqzx+Uj1lPUQthr4ggeOwjh4c0A12r8xnth2m8ZmqOEQJBamb8F6GQrgp0+Byz6qWW6rHwP4lt07tbIMo6GcpafV/49BbS7xIg2XwBAYhxDEwQZimq2w/XbeGdWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4N0OxAhtBk7mfKU1E1ysqqMztceX3lFjdINxbZpk1k=;
 b=shC+rAahVC8oeo2q88Yo07BoiJ493vQ7jO9dtZUjxKuK7qGTIK+z65853bYMr91VS21k4xiuAyQO1Zof8QaY0fSgq813CoSGa99D+Zo2bWZLp1k/xwW1Hsxzn3oX6hvsCF4d5P5qkrqNws3y3goi2DvdX+5ejMNf79XndWxRK3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BY5PR12MB4307.namprd12.prod.outlook.com (2603:10b6:a03:20c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.22; Wed, 21 Feb
 2024 16:38:14 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::319f:fe56:89b9:4638]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::319f:fe56:89b9:4638%5]) with mapi id 15.20.7316.018; Wed, 21 Feb 2024
 16:38:14 +0000
Date: Wed, 21 Feb 2024 10:38:05 -0600
From: John Allen <john.allen@amd.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	weijiang.yang@intel.com, rick.p.edgecombe@intel.com,
	seanjc@google.com, x86@kernel.org, thomas.lendacky@amd.com,
	bp@alien8.de
Subject: Re: [PATCH 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
Message-ID: <ZdYm7R6OmjhTvrXr@AUS-L1-JOHALLEN.amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-7-john.allen@amd.com>
 <5e413e05de559971cdc2d1a9281a8a271590f62b.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e413e05de559971cdc2d1a9281a8a271590f62b.camel@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::31) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|BY5PR12MB4307:EE_
X-MS-Office365-Filtering-Correlation-Id: 21314928-efe4-4650-93d2-08dc32fb7f91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/JA6+8ihK5pjeKc5CtjfK7W552d8dIwDlsxMCnEcPn3UirTkly0AnpUwpF/e7gicE+DMFLuZEdA/Ma2fiFLjjWY9NzqLm/1u2NyYmvioofiYVb1I+Tot+vtl/KFNodbf4qCtBJEPpOIUVXJfAc3H5lmHdHjKvc9oT5dFJ65CR7g+NxlmqCWhEoHLRcF0ePatEg6YFNRDLcu+jTQQK70KECKMcpDPLOfYXy8+gVKTmlqffXIlRCmXQsV8Vn0wvbOwNQeyu3wcE/bIKjJxeI2nTLLaVFdY2AcE3ymXa2J5uUEjkJ0O90PEiMCFTyPO7VZRQXGcGZ0nwJf6OHCgrVjZbSEr+gNhrDE5oRDWx8QZvehh644UiLg6angcTYrs4ojwnyQIj2Sl3TOhPT40wCPX8TefWxsYdvoer6MjYwJkXlJCsKMklZalo4sVya5a153sR83dxBf9i0/4SIBaCamG+KPmM96w/k9FC/yv1PEQdoRV6wYQiDIlgbWSub5XOf1dPF7ndgjNkbT720ewUrNfka36ApxcnO9YxvGYvCjz810=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FzspC02tOzBHNIze1VCTpiCRYt5XpyncmbnqMa3jJorkdukxklAF37qS3SkP?=
 =?us-ascii?Q?I/ptXRWf6nP97zPWgNBtN+mvn5yw538ldDS2DbbhsCHhYCt2yySPRjo8ToTh?=
 =?us-ascii?Q?6A0WU0YSvSmgEkRietc1C+Aq7+O56jYx2TROmJETQnSbJvkoZXsj32D97dSp?=
 =?us-ascii?Q?3fdg7ihtDVYbemzz66JUdd/aADVd6GmjFmkeWnMc5KKNy00j7xjQSBFq7rRh?=
 =?us-ascii?Q?BLckUB8ZKowr0IN8mnh+xNCKBRY8e8gWytqULJAprwDh8KwyEg25ZBwz/LFE?=
 =?us-ascii?Q?0fVC9g/QWrG9eic+kWEy3IGFL18tV4731FNp9CA9Ccp9NueifeIRBk9J9wHH?=
 =?us-ascii?Q?3DBjsvfGr1DXFAEzzkHw0CFQb2d/RGIjLmT3YS/SzjdKUpStZyC/sb2MDaL8?=
 =?us-ascii?Q?lMv2CvCMaliPMavvQW4+YK+x6PegoY8oqHU4yhrVXUVpiW2a0+8kvVaEoDej?=
 =?us-ascii?Q?bPFqyDETgU02DI1N7H9GPZF7Dk0uag62DbMBtc1kU53AhlH6IMW7OHtoFiSq?=
 =?us-ascii?Q?K1SZBY7RDnoYvM1KSqWs3QzNsHj4rJhcL80LMibByBTtyGoDwOx4YBlDhD52?=
 =?us-ascii?Q?kJFnnnhktbE+e8iQC0K2YQ7oLo4DD3NVDHJXbKkr2fHUylFO6OU2wlMeVV8G?=
 =?us-ascii?Q?wVYliYtwgPoZz14cLZHeEZ+J8oe/R2WdEQHHqS3MDoXItJtdDkef1l8VGhZ1?=
 =?us-ascii?Q?craDZ/Hd70yD2rQQjm6pJYRSu6MCYxzxXrPwAusKaU8JLX3yVNgs85XRjM4U?=
 =?us-ascii?Q?Q8XqsKWklxpDTI1E/rzzwe3BHPcqAZ3Pq0nA73/E+5rWx58i92YDcPZ8ebde?=
 =?us-ascii?Q?fYeFzdeMlMX9OvAA5gvhmjmS4AM2peUew6BVJe2CsJDyS35aNyZr+mx5Ck9n?=
 =?us-ascii?Q?ECvr77TITyZ6ZnLx31wySuUmausVtn29JxiK1wxcRkfXtprldRk0DP7kgaUS?=
 =?us-ascii?Q?sCXmrWzb31lsD6j29DJeI6fIUbZPVr7h7S+aRR5/RAEE5QV1/isNICPgf4fc?=
 =?us-ascii?Q?tfdmv7R8CVW7WkZWiLvS5gQaaD98/NfZpsL9djWaV8LdjQwxZHdA8i2n5t88?=
 =?us-ascii?Q?KIuTmorEBJ2ycjL+Upt6g3lOY/zUcragsPJC1z4augX0PHoM+QcgA5aCaMCy?=
 =?us-ascii?Q?Vbh7Tnvi4yMRsAfCnwEoPiqZqawwbZf+xnB70Gp2a635YY/SzP/BnN/Ihyz6?=
 =?us-ascii?Q?F1jnD1WZQ27JtLgu/E4Q/+WePsgjXAakZcDu1cah7t5tJSvKlyOSIWhEzjhI?=
 =?us-ascii?Q?o1GTBvttvgyIY+F1Ue+1m3t22fKPmk/yRxfxI409/lQ5hFpr7DoxEFz2aQGp?=
 =?us-ascii?Q?IWF93O8mFfE2df2pBjvWga3Vy3r3HO44yGUF2V4o9MONtHOxGXhDXzwVPOqu?=
 =?us-ascii?Q?RtPh5bh5VgWM/2M4OOBrSXPAmZgp29bGXpZ6stP4PEEUOZz6NmaA5nvmMI98?=
 =?us-ascii?Q?9IPhY2EIcz2hGbVUjR+eZDXZzV/udklxJx0s94xPmrNsPqlwA+uE93B1phmJ?=
 =?us-ascii?Q?x0XQKx/J+Ow1qN/cD2F2XUvIME3xyw5FyFe4WmqF03bGT3puU0tBeu2p87CL?=
 =?us-ascii?Q?RSsFXwQpjNhJhkTxarb4iLWxg0tu5bpunJhSTFkj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21314928-efe4-4650-93d2-08dc32fb7f91
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 16:38:14.0229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /YrUxUlCrN/CP+lrkY6btbZIiu0nOOw+zVMGRRz8Bfv1sAZkkMigHqc52OPClLo+gqXxeOVrAUNes096MBhSSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4307

On Thu, Nov 02, 2023 at 08:10:58PM +0200, Maxim Levitsky wrote:
> On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> > When a guest issues a cpuid instruction for Fn0000000D_x0B
> > (CetUserOffset), KVM will intercept and need to access the guest
> > MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
> > included in the GHCB to be visible to the hypervisor.
> > 
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> >  arch/x86/include/asm/svm.h |  1 +
> >  arch/x86/kvm/svm/sev.c     | 12 ++++++++++--
> >  arch/x86/kvm/svm/svm.c     |  1 +
> >  arch/x86/kvm/svm/svm.h     |  3 ++-
> >  4 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > index 568d97084e44..5afc9e03379d 100644
> > --- a/arch/x86/include/asm/svm.h
> > +++ b/arch/x86/include/asm/svm.h
> > @@ -678,5 +678,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
> >  DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
> >  DEFINE_GHCB_ACCESSORS(sw_scratch)
> >  DEFINE_GHCB_ACCESSORS(xcr0)
> > +DEFINE_GHCB_ACCESSORS(xss)
> 
> I don't see anywhere in the patch adding xss to ghcb_save_area.
> What kernel version/commit these patches are based on?

Looks like it first got added to the vmcb save area here:
861377730aa9db4cbaa0f3bd3f4d295c152732c4

It was included in the ghcb save area when it was created it looks
like:
a4690359eaec985a1351786da887df1ba92440a0

Unless I'm misunderstanding the ask. Is there somewhere else this needs
to be added?

Thanks,
John

> 
> >  
> >  #endif
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index bb4b18baa6f7..94ab7203525f 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2445,8 +2445,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> >  
> >  	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
> >  
> > -	if (kvm_ghcb_xcr0_is_valid(svm)) {
> > -		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> > +	if (kvm_ghcb_xcr0_is_valid(svm) || kvm_ghcb_xss_is_valid(svm)) {
> > +		if (kvm_ghcb_xcr0_is_valid(svm))
> > +			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> > +
> > +		if (kvm_ghcb_xss_is_valid(svm))
> > +			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
> > +
> >  		kvm_update_cpuid_runtime(vcpu);
> >  	}
> >  
> > @@ -3032,6 +3037,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
> >  		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
> >  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> >  	}
> > +
> > +	if (kvm_caps.supported_xss)
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
> 
> This is not just a virtualization hole. This allows the guest to set MSR_IA32_XSS
> to whatever value it wants, and thus it might allow XSAVES to access some host msrs
> that guest must not be able to access.
> 
> AMD might not yet have such msrs, but on Intel side I do see various components
> like 'HDC State', 'HWP state' and such.
> 
> I understand that this is needed so that #VC handler could read this msr, and trying
> to read it will cause another #VC which is probably not allowed (I don't know this detail of SEV-ES)
> 
> I guess #VC handler should instead use a kernel cached value of this msr instead, or at least
> KVM should only allow reads and not writes to it.
> 
> In addition to that, if we decide to open the read access to the IA32_XSS from the guest,
> this IMHO should be done in a separate patch.
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> >  }
> >  
> >  void sev_init_vmcb(struct vcpu_svm *svm)
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 984e89d7a734..ee7c7d0a09ab 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -146,6 +146,7 @@ static const struct svm_direct_access_msrs {
> >  	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
> >  	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
> >  	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
> > +	{ .index = MSR_IA32_XSS,                        .always = false },
> >  	{ .index = MSR_INVALID,				.always = false },
> >  };
> >  
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index bdc39003b955..2011456d2e9f 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -30,7 +30,7 @@
> >  #define	IOPM_SIZE PAGE_SIZE * 3
> >  #define	MSRPM_SIZE PAGE_SIZE * 2
> >  
> > -#define MAX_DIRECT_ACCESS_MSRS	53
> > +#define MAX_DIRECT_ACCESS_MSRS	54
> >  #define MSRPM_OFFSETS	32
> >  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> >  extern bool npt_enabled;
> > @@ -720,5 +720,6 @@ DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
> >  DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
> >  DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
> >  DEFINE_KVM_GHCB_ACCESSORS(xcr0)
> > +DEFINE_KVM_GHCB_ACCESSORS(xss)
> >  
> >  #endif
> 
> 
> 
> 

