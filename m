Return-Path: <kvm+bounces-57797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 129F3B80415
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 16:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 552F2189F4FF
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 22:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A106A2E9EA0;
	Tue, 16 Sep 2025 22:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aPa74LU8"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011023.outbound.protection.outlook.com [52.101.62.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DBC635;
	Tue, 16 Sep 2025 22:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758063347; cv=fail; b=DUZ96p41X9bjKISIG+5moVi+cNYHMZ0GimtO695+bBbLBro2MrrzsWDMo/n4IcPYATv8vWIqC7xKi/8UisQDCWoqDWhTnqGUuY/ynu8+vgs/sBBkSTPPiPchxltMhw52r7sr3sawCV7RUzsNO9rKNEwqAgGEEnC96Qjicyzp/7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758063347; c=relaxed/simple;
	bh=CrPbSQ4Aai+664y9os+H2lfRWxertzY2Gq/H6r6Zsak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N/GBjuQs5dkrzwxH9lFcMhdtLvuO2ymugS5EEAD8gwGT9U7u1+soFZQ+sVeHKY3BIpQ3ZC5sWs0EjOIDKJxTrHoVFkyJLIAqRKGzUof1L7qzBHHc+US4ORFl20DQxloQSRHT2BYybKnbB4aXUJJ1TeuE9okF3qFaCRJjsKx015c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aPa74LU8; arc=fail smtp.client-ip=52.101.62.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oT8M0pEoLBwDTZFqdRw4DRryZcSciRkrdMSOCkN1wtCpyM/HYZkjOHI4na1yP25vj6VXE6VyirafI+EXIH0WFKmS7AnmEdYw6WKEw6NKzjdvo1616AW2/oy4LEXxprl5hlr2O8W/VzeqNIb9BR5x4X9O2QIA25oOQPBBaegffFn9uQinD+FudV0VOxaodyTllLNLU5yNbemvhhLciLF1nv6Aj6YSvO2weHoUAUmhzq6qvoKaoDxqUM8s5dIDLuN1sN+FGlf/NHeSxzeoShAKhABiyzBvVUPmG3wW8eOiWORGrEVVv3/aypf5IC3OK5pqMGwjq/SR7I5zgUFvfG03cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yP2LFJ2Q/ULuB2eNAfEkO2Ke6JXAyzLDt25S4HJdmtM=;
 b=eNGbwHA/gWkicyFkCQs3mBkncJmtmHf4PqXGZdRQJoFORo17DPYBFIhGM+yTuHcKJCm61MkD07K1YuzyklULEsm+Y1ZBzMdCCK5c69ELITypmmq3z0FF+2KWuuCf99pVu79HqqFgAW/I0h70VtwUiuxF0W6VgHO5RGL8cqIaw/JgAOhy2EiOeRgypNG8qWbPdSIar0p5Mi2PA+s3AAe/aJAaq289j+a/hscBX+1rzldhirlsxRxTJcLjsZofqMCKstAVHkGCyTIgG1/daDjp5SX6Mmq+83OQSuXvujpYIydHe1hb69fZxniLGQ2ov4SStlVdRAij3VWxkKD4RAJFvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yP2LFJ2Q/ULuB2eNAfEkO2Ke6JXAyzLDt25S4HJdmtM=;
 b=aPa74LU8Y3SR3GIaxTN3AAVq8Atgb61tFCtK3qytW+GKiw7jf/hNJeQpDDtjzJubU0Pz7ennnlz3O/jmUvGsCP+jcZshPsUQ85G3b5stW0VfdYThf1o9MwRo9AM0UCxF49ViI5RKgXQtrlwc8VN6yDDUuTKmF/v6/zzbI0TkXKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DM4PR12MB7527.namprd12.prod.outlook.com (2603:10b6:8:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 22:55:44 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 22:55:44 +0000
Date: Tue, 16 Sep 2025 17:55:33 -0500
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Message-ID: <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-30-seanjc@google.com>
 <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
 <aMnAVtWhxQipw9Er@google.com>
 <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
 <aMnY7NqhhnMYqu7m@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMnY7NqhhnMYqu7m@google.com>
X-ClientProxiedBy: BY3PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:217::16) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DM4PR12MB7527:EE_
X-MS-Office365-Filtering-Correlation-Id: 6da311cf-e1b3-4e2d-45e2-08ddf5742ab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nrWphvatk8YOAdDx3IwEFCV+vVDAqR/tZ+jB0eYHJfYRkPcjgX2EXkn2J6eE?=
 =?us-ascii?Q?dAMlMAHk1NxrU0aSrvoZubq092gWyD8TRqT49tTZ0Edm2HSvR9g/lemvtdpT?=
 =?us-ascii?Q?jl30bNpdLa9VoPTKF+Nk3FHlOdOQpkK9KRi+4ERirQK9cdFd8S0e80kn07o4?=
 =?us-ascii?Q?XbhNAfCZ5aIp96r7+oP4FqmkyCztGWkRn3FeeROKfKVQjOG1XvWwucs0NGY6?=
 =?us-ascii?Q?gKKfLHUaEy0wFwRkEqq6DNWT/EZCrvqgC7cV3WB3eZNxsMV08lP2Pt3A0Q+T?=
 =?us-ascii?Q?YGLxbGXX4F0vsUe0+1XOQpMrulQmXYgrNE4SVJriAQiIDPV1Pw09CkUl0W4t?=
 =?us-ascii?Q?wo5I69HMGDasdzfNoqlhHUQgM7s/J9lfFqBy1su5OYDsJuWzWfNceytW2dc6?=
 =?us-ascii?Q?NjtNdtyIk+4TfDJgZFj24Q6PkODRBgoGbe56v++k+b3TkBoT5VesLSZbkhHK?=
 =?us-ascii?Q?btrKy4W8JTrGLzRKA4w4X866WTU3w+k1JXFPUxsA87BE9wkbQAq8YaUYlfnG?=
 =?us-ascii?Q?flYT6OO6AKmOBEJmEsUAE/i6PLD3U5h6kHuf27U/LWF4QcCdZLAfwoir1WFp?=
 =?us-ascii?Q?44sVFFUmkH51S1HpUS0VcRtk06UbSMjVH4+iHssl7z0QRdMSW/cPYryE55Im?=
 =?us-ascii?Q?SUYwgXfkiWZ27h4YdZxjOw1XDkKHriS/607AxN4fFBDuIRjKS9c0rFeGwGgv?=
 =?us-ascii?Q?QiN9d4kuaSq//DVjTa178IcTYq5Y7okB3Sw6dvtIeYgtw/0AgEQgaH9XBGY8?=
 =?us-ascii?Q?42ZggjhrR4slhLaROYhr6AcnD/FFZU2qXIpvPsxY5qwtOPTNhsWVbKGaMCqs?=
 =?us-ascii?Q?xiP630R39THCJCRSXeYYEs7DaZHw43fvsi9JRGRi6KejODvsAqpB4cHYMwA9?=
 =?us-ascii?Q?8mqKqUyIyz2XzPpbpn7JfZXK9MeyJgSl5LaSLrf17Uok12dJWG9qc1XgGnVv?=
 =?us-ascii?Q?CgEVyeFfCUjXidC5ZinVzP5ed3pTXyyKrDksqsw6vP2Oie30TFqTB6ssXDJb?=
 =?us-ascii?Q?nb75ObuFF6AzebSuSd1iklNljUtqi31o8dE1x+cfz8jHKcDbhdDHaqMlH+4z?=
 =?us-ascii?Q?ljvfN2tSHDEtRsD2SYixQorok68sl5sGJ0mWLz4Ubk0+7Pl/jfE4XCyQzN6i?=
 =?us-ascii?Q?u9HrHiz1tQqF1jJrV6DbzXp35bFLxSUIedhmDpqxYa1nMv58+rb3pXaeonOS?=
 =?us-ascii?Q?pNlGi9o1qwhLN3uQrIIwY27+pnNRqoPUGm0gW44ZmQul5lXtqFD1kNxQlKRy?=
 =?us-ascii?Q?bKAySi14CjG4PqDhzGKwC7hifiOWPr9mfi6hQO8WXX9fxrfl6g0GvYAUGBC3?=
 =?us-ascii?Q?dGCZxFYg8pPXlmO+iUH+8XFmHHPBGbMaiQWNGAU8LysFk7o1IITNygPzy8KS?=
 =?us-ascii?Q?1LwHBJ561wN8IUfX7tiXM4/t/DmhD48SJaFaBnqbNQZk3Ilgqo8cgG958C9f?=
 =?us-ascii?Q?jt/6/WwUcTc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?apB7ri8AUygPOHEXoO+qcExp+lYUQlEqpBhAgpEJbvJwTwQBk6tQUvrmH+cV?=
 =?us-ascii?Q?PuQoT45a3eFcx5QetUdelh0Fjs0J+ABuf9cFaxt7cTPLzebKXbAV6GLkJo57?=
 =?us-ascii?Q?cZ4Jr4MRKBN+2yxIScxtv7BW/I9FJpSVDgtULqHE/P4l/8FOPkeSxzF6ie4T?=
 =?us-ascii?Q?9cZabG5c9qjr1stZ9bC9c7sWl7w9INx2e642XlSP4XhgG3Q58vY7N77nCEYW?=
 =?us-ascii?Q?evEI0l41ECs/jV89803Tachsnpj1oVDp4oaxS2nzyPlCqDgwoRcRgwz8Et37?=
 =?us-ascii?Q?YvfN93j0yOYtuS2I0IygAnPQPQozETCQng+BalB8taxTnHU5XwhtTFvDrDTX?=
 =?us-ascii?Q?5HYrloH4AtDZx9yJU/qEFNsW6ivhP6axexPIS1PelvruyhCyD/yr1PB5ODV/?=
 =?us-ascii?Q?pithql8kn9tMJU2ibEUckbuV5ywJH6TdGA4dH2sWDiKoxnsUEqUnYgRCgmUE?=
 =?us-ascii?Q?u+RxFBu9i7VK+TNxuHh/xmlYk8KLZpFvCFwQDma31OMHxHjoIeJBsqqwM97U?=
 =?us-ascii?Q?3k0B3iPLLcsdYgd9N+wffVOWllbdxHoksO/yK84gZ2q7HxLXaasiLLWGa/nX?=
 =?us-ascii?Q?/Oqe23EMev4kPY9qmkhqRKzCAqRpbPQkci1rdJkAO4nl4LdDM5xLzc/c229/?=
 =?us-ascii?Q?GW53eJbw2Wz5y9E2a/OpOcIvXz/kTT8KL7p4xYj94pGNq0xacPUKGNDTPpuw?=
 =?us-ascii?Q?Or1HgOUa4Ro90MXpn8TrWsOvFqBPPF4632IjJcjHDF3OvBSpKCAA6K7I+uPF?=
 =?us-ascii?Q?7gyv/PCw+TLAN4kHG/xfZJo/w9PqIeDgiOkyzNi6st3yTZmZA1K/WhNUpp1W?=
 =?us-ascii?Q?4gJ0Vodat5TX30oplGt9oxVnl4d/24liRHOmkHhGGfqASY4pUuxH0UuUxkvi?=
 =?us-ascii?Q?CBOEU/Q3bjtyLYZ2pmkqy9l7iLHAmEHktWiuY+kg/6n3BqYuCqT7nWnud/Kb?=
 =?us-ascii?Q?I2g/JIYeXqSVtHpeSSFe2AURBka8LOExxNNoWCMIat+HdwMd4tahe/C4Z87P?=
 =?us-ascii?Q?CSnG4FVwxSFPtS522SjbzlmJ5Hu6vY7BT4Ngd/xrfIBVBEwTV7l1Qhg9VbkZ?=
 =?us-ascii?Q?x7YHRYgq/aTjQQAppGY4l20ObUtkZUH+XTM/Rda0Rk87BNmWRQAimwXxz8n/?=
 =?us-ascii?Q?3/gCuA39SBwtzc2/rUtZG+4ve6HlVy3MM4OmmGb3TFsJvo0sKWfwJsiJEg+N?=
 =?us-ascii?Q?EJ13xrcSX4TjiEW833HP3gW5Lx+5nH88VcLNGqiv+T/8gFGCjOPD3VU65b4a?=
 =?us-ascii?Q?O3z11Xz95qkyQrWD2o0RfbIFuIG1iqbkpLF0UXUg9EeiDnfHyezYWN2lDKY0?=
 =?us-ascii?Q?i3jaQTX4xzbIL2kkVkyQp9s/6qH58gsumzK1qFktmFx+vPpYEWBRcjgJB6+j?=
 =?us-ascii?Q?6q4zRJTa8sXHFKatFLYp8k/Ys2xocRFl3CvUfC2MZ4MUkc7bMVLIxa6KMspW?=
 =?us-ascii?Q?is5ZvxqgoDmNIJKtu14NFkAQbPbNC6Jui9V85Pv0LiHDIUC2a3OvUUrfmRE/?=
 =?us-ascii?Q?YpRDZ5+RcxIPsN0GqnTsnDaYSMSARQ1CZE4qwxCFvnjCntg58mx3bY+yLVSu?=
 =?us-ascii?Q?ED1T8zBksI6csnNUq+w5zPorT/ySvpnJBFXHcEv3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da311cf-e1b3-4e2d-45e2-08ddf5742ab7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 22:55:44.0115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drpZxapSKQ98gUv64qxOq1lCxtGnrNWpLE0op1Ghhoq/SUYEfxxlpeOoZ12vPPYacTCjzuX2LsCwMLfdXJzJCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7527

On Tue, Sep 16, 2025 at 02:38:52PM -0700, Sean Christopherson wrote:
> On Tue, Sep 16, 2025, John Allen wrote:
> > On Tue, Sep 16, 2025 at 12:53:58PM -0700, Sean Christopherson wrote:
> > > On Tue, Sep 16, 2025, John Allen wrote:
> > > > On Fri, Sep 12, 2025 at 04:23:07PM -0700, Sean Christopherson wrote:
> > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > index 0cd77a87dd84..0cd32df7b9b6 100644
> > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > @@ -3306,6 +3306,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> > > > >  	if (kvm_ghcb_xcr0_is_valid(svm))
> > > > >  		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
> > > > >  
> > > > > +	if (kvm_ghcb_xss_is_valid(svm))
> > > > > +		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
> > > > > +
> > > > 
> > > > It looks like this is the change that caused the selftest regression
> > > > with sev-es. It's not yet clear to me what the problem is though.
> > > 
> > > Do you see any WARNs in the guest kernel log?
> > > 
> > > The most obvious potential bug is that KVM is missing a CPUID update, e.g. due
> > > to dropping an XSS write, consuming stale data, not setting cpuid_dynamic_bits_dirty,
> > > etc.  But AFAICT, CPUID.0xD.1.EBX (only thing that consumes the current XSS) is
> > > only used by init_xstate_size(), and I would expect the guest kernel's sanity
> > > checks in paranoid_xstate_size_valid() to yell if KVM botches CPUID emulation.
> > 
> > Yes, actually that looks to be the case:
> > 
> > [    0.463504] ------------[ cut here ]------------
> > [    0.464443] XSAVE consistency problem: size 880 != kernel_size 840
> > [    0.465445] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/fpu/xstate.c:638 paranoid_xstate_size_valid+0x101/0x140
> 
> Can you run with the below printk tracing in the host (and optionally tracing in
> the guest for its updates)?  Compile tested only.

Interesting, I see "Guest CPUID doesn't have XSAVES" times the number of
cpus followed by "XSS already set to val = 0, eliding updates" times the
number of cpus. This is with host tracing only. I can try with guest
tracing too in the morning.

Thanks,
John

