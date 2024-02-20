Return-Path: <kvm+bounces-9217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A31085C181
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 17:34:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D90131F25B98
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39214768E0;
	Tue, 20 Feb 2024 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WzbBY+4l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633E9762E0;
	Tue, 20 Feb 2024 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708446841; cv=fail; b=etDb12Ipnpru/qRTjlw9Rj58k+16fc2CT34ea9ycK2La+Zf4OK/tqRuW675zdnOg6urVEkLDNHZU/CfJalblOgGADkgRb9B6XbNxBlR8oz9Q4PTnbdfRyGxZStBWtzRdaMIibDGjzmNJpcfhxuYT/6Ngogf1vl5WI4club+/+FE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708446841; c=relaxed/simple;
	bh=z39srBkrTDAZNHduh8HIF5Mx9Zj0GsEqgOHGsG7SLLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OEiD+U0XH9DO3DQY1BiEvDOgowkPEPeQ+1v3G1A5NmGDmOR0Q5S6XkEZfZZeQdxOO4wKLoCxyR9MjALpJa+t1zue5lx8Yp13Gpup4U5WWDn25WDUnJaloEJ/8TsYeywsLOgOydLwZcwGFHRJ08mL12TlUxFdBy5CtSdAWcK8HTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WzbBY+4l; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIbdb3gB5gyKiojwNsdNKTmh80dTbScCkOM0qwFIka14Ptrs57Te7o1uS+iXRPwj7dSWl8E+07O/OK65jVR/zraql4rnB6893cchSwExsZsz2Hh4MPNniYwyh/kL58UNXYT/aCkID60wqkPmGp9sqsVG107zN8azba+zLbhS7Sv0w+iAylq3LMTLC3AvKOzRs9lUxDIIlD1xVGE/8/XTpbStBFZ6GEG7CbnsRdzmGWTIuFnJhqH6EOZmLadni0cFLSDgssqLz0VN5LPn4ccQP87nEXkeU8biplLcTFvOWNBDIQXhGHqx8GdXYHiCfRCO8+Q8XELTJpwBOkuqqNX7PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pzm9dQsZZZlGyztBulTM7Jnd4T669WDdnFIQNJbZWrE=;
 b=nHk+RuHKubSNWayrPiipRGdeYaGXXr5hgxlnKUiulUVzafHuiBpezLrDMFY8Z0XrxkUWdx8y08XdJ80cq4AZ9YzQ6pHjS5m6jQdvJ9zGs2tzWIdO5Nn7QaPcRRomiNWsaPRTlLjcQA3QSR7WloAbY9sYW5R18h7Y7Djl94NyPP2lWzgyMcNIuYcVJMM+Lc3e+G7a1y7vtqfBqtnzSws63CdAGBuyy/DUtFnKZU2CC/dlVCBnc6eLWpmlbxjBDgvCe4nEpommjYDARLvLuWJwoKUSD7Y+dI4JZigjYHaxQhcnDLymJq/fxlZWt5YR4FMpViS2ZQpvup+7n4uH0Q7AUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pzm9dQsZZZlGyztBulTM7Jnd4T669WDdnFIQNJbZWrE=;
 b=WzbBY+4lQj6b6sSAMENjVjLo+cCpoJdR6AyiFsWfQB7E3Bfo0x8LVXKIPhRtcjSROnslkK+Ruk0MsKIVz3AoQoxgYHTvKiosQak7Jqre4XDb2O58S5Se3YRUjD0UG2rzdZGIl8n9RuMwJEVp902QzeBG8iAb1xAyxbuFS2pGFZ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DM6PR12MB4185.namprd12.prod.outlook.com (2603:10b6:5:216::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Tue, 20 Feb
 2024 16:33:56 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::319f:fe56:89b9:4638]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::319f:fe56:89b9:4638%5]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 16:33:56 +0000
Date: Tue, 20 Feb 2024 10:33:46 -0600
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: mlevitsk@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	pbonzini@redhat.com, weijiang.yang@intel.com,
	rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com,
	bp@alien8.de
Subject: Re: [PATCH 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
Message-ID: <ZdTUap7xy8tu15QY@AUS-L1-JOHALLEN.amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-7-john.allen@amd.com>
 <5e413e05de559971cdc2d1a9281a8a271590f62b.camel@redhat.com>
 <ZUQvNIE9iU5TqJfw@google.com>
 <c077e005c64aa82c7eaf4252f322c4ca29a2d0af.camel@redhat.com>
 <Zc5MRqmspThUoB+n@AUS-L1-JOHALLEN.amd.com>
 <ZdTRVNt5GWXEKL8h@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdTRVNt5GWXEKL8h@google.com>
X-ClientProxiedBy: PH8PR07CA0031.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::11) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DM6PR12MB4185:EE_
X-MS-Office365-Filtering-Correlation-Id: e5c83641-5f2d-4fde-caae-08dc3231bb54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SEYgyXnmlXJVqICeDt6v1LS9Ogrqq4jPX42IIfzta58blymJ+lxeKPLG1zLMC1UWS0PcqBGjY7MY8ZzWbarauZHUTCx1L7/RNc6bN2uXsZMelBNQN8b4HkLAB9X2E3kGIQrG4gLCpl1QFdHsZV1btWmZVEORVpbLIBLWHcZRNi81k1ZF/F6cNhG5dsEJv9ei6UJ3PaETchM7TEQAwVOAonxYTwBQ9YYRttH3R4i+HcddtQefFewDW+xut5A9WlY9uY+K65u/BZN3KOJ0brz1G1cnE60+cwtilbviC6BTV88NOv9hMm+Kk68QHGgId1txAlyAyg8/nDcUiKfrVpPswXAZ5Kf9NzqJsUptYhEoeWdDDreelREr2zdVTUDo/OIgmLUJ/f4AGXEUQ52owlv4oG0n8Sh4QjYTbFuEEuTYPdJezloe+1RVDZsBT4GPrN4mx8biQpaJtOiaCQ1grW9G6vBNbUgblqbdCZwjDmD6Kbc3Ss3j+cwr0qBV7AUAtTrm729QUbqJ/qlymHtrD1JXs0jUns9M5euqhO6lBFKWdoo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PxSdARwT3TKExkt4O/MVTLXMmaSbwSHFsqbbLNmO8pNb1RP6vp38+3BRvL5o?=
 =?us-ascii?Q?G0jscx4TkhHgkhZ8n8apHgE9YNkJ6w0RkIQmZhHZJas1yX9jsf+gMsIcuLpl?=
 =?us-ascii?Q?6Dk4VPAZUC4z+uHgLlVofBbU+wuau8+lZGsCSpjINDJRdS8OmQO8Rr3Zr1Xi?=
 =?us-ascii?Q?KSXIonkmEMyIAtvX73xQWd45K65obUrZIo4mmfQKM7X3o986Qi91VtCTHEBy?=
 =?us-ascii?Q?RoR1AI38yQwV1q99DBJo9f0rr3YEX5opOmphHVmHGt5kbDc239wtM6uVnteW?=
 =?us-ascii?Q?F1qzRl/lIiCUHOtsz8bl+o2LCAZAHf53TlFeKDJlZr+FpjSQ82W8zvklqtMp?=
 =?us-ascii?Q?IBCm8mbJA4uNx270+9s950jSOK4t4WHgdt7VD8mo/o7Sqv6Mq7QIf3yTHEw+?=
 =?us-ascii?Q?wXouCEf3HCLoIUSxH2XAO4oBeMDsflzqpeUks4TvQ+WcaG+dFFpc2zSUh9AK?=
 =?us-ascii?Q?rtqkZLWpGjmVPkGiPxCTsaW3n1bE+NtkbWKBx1f5QsA6g4RR0iKaB39GpA33?=
 =?us-ascii?Q?HblvElgbzolCiRuaS9+no0tMpMnTSNOXna/A7yv2laxME4AMF9UC24lC+dSD?=
 =?us-ascii?Q?cc255F/wqHRuJpvV1yui5RXWk/KqKINp+GakPago+xnzLIEZsqEAa+Qf4hGi?=
 =?us-ascii?Q?pl8uRZloG6Z1dxb7+llL1/88dhkmjzgu/4muX7a7i4ofLSFCs0ClmNXZ0+os?=
 =?us-ascii?Q?EUrncX4WaxqWw2VciQ+xtR+V/CcLpTnpke7DHPE/TZ8xwELAZabqCL9O/WwE?=
 =?us-ascii?Q?fuutumDhapPyPyLSPhiagVkccQutGS1TbofWI4y9ttTWLFzKT5i49poBx9fA?=
 =?us-ascii?Q?Krzq+qH74Snp/qd4VFGLXiMPFStMKoJPMp5VZlf/RjxvrvrD87Gw6uWEtkEp?=
 =?us-ascii?Q?K71qPSN1+ws8Gyb/668a5jysZSvxnlojKjZ+xBnPogCa0D8pN0d2GZ8+yDsv?=
 =?us-ascii?Q?fhPVfwYDr0QOsW8jMFwBqnXUB/ZPisvHLuYjZnGiJuVKTMNZPqX1Gm6fpsGE?=
 =?us-ascii?Q?wzTBIKY8yOm13OLVqlkMqxC0dryjaTILzr/T9Qr5PAs5yj75mbIGZEaifF43?=
 =?us-ascii?Q?+fbIpAkofuCJL5pQynqlDkxNJQeVGdGiNlpLwUyolCVCsZxLBHj1lEA8k+3x?=
 =?us-ascii?Q?qO+aeDWKLzObtR95FTFpG2S/gN0KkBF/zyF2WS3W2HTrt7PrE4GuR/6UF0Es?=
 =?us-ascii?Q?RPxcXZ62e11MbyTD6eIblGCTbTY6C6YNpyUY+i32st8Zkz/K6yAwxLdAU8zk?=
 =?us-ascii?Q?7g483LujWh6SD3wuLtYmxyWseq2ZaeqCg/rIN+84fzjp9STTsUd+Vtri1WvH?=
 =?us-ascii?Q?b3+68G5DUC5soKXyFmkjTtdbjdwpbCWCVxTc0Ewem5bCN5KVEfcyt3RwjNWD?=
 =?us-ascii?Q?wfLvmZofII2xT4jCwF+gUghd72bdTwtMUjo8FCgHrTE6/54l6jgsh9QX2Bhs?=
 =?us-ascii?Q?6YRgxswVBsrAUlp/gotZui6WPvqULaFAveRAofIdPpb6jEr+u5dzClkyqVXm?=
 =?us-ascii?Q?5PpfGES0F/YPvW5ItFYFfvKEOL7HO+T0YxwpU5mENd6OnBBEmeLqxMZzN9Zi?=
 =?us-ascii?Q?gSm1+PrHEANKxSnV4/cPGrbUkzom0s4uvoJTS6ma?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c83641-5f2d-4fde-caae-08dc3231bb54
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 16:33:56.0324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNxDmPc+WbibZeBG1ADBeKMEkazF57WlsSP+Bl+pAEnLKhKaCk36QrcTxtzl9sdtlsx93HTBPbhuckb25WHEgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4185

On Tue, Feb 20, 2024 at 08:20:36AM -0800, Sean Christopherson wrote:
> On Thu, Feb 15, 2024, John Allen wrote:
> > On Tue, Nov 07, 2023 at 08:20:52PM +0200, Maxim Levitsky wrote:
> > > On Thu, 2023-11-02 at 16:22 -0700, Sean Christopherson wrote:
> > > > On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> > > > > On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> > > > > > @@ -3032,6 +3037,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
> > > > > >  		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
> > > > > >  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> > > > > >  	}
> > > > > > +
> > > > > > +	if (kvm_caps.supported_xss)
> > > > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
> > > > > 
> > > > > This is not just a virtualization hole. This allows the guest to set MSR_IA32_XSS
> > > > > to whatever value it wants, and thus it might allow XSAVES to access some host msrs
> > > > > that guest must not be able to access.
> > > > > 
> > > > > AMD might not yet have such msrs, but on Intel side I do see various components
> > > > > like 'HDC State', 'HWP state' and such.
> > > > 
> > > > The approach AMD has taken with SEV-ES+ is to have ucode context switch everything
> > > > that the guest can access.  So, in theory, if/when AMD adds more XCR0/XSS-based
> > > > features, that state will also be context switched.
> > > > 
> > > > Don't get me wrong, I hate this with a passion, but it's not *quite* fatally unsafe,
> > > > just horrific.
> > > > 
> > > > > I understand that this is needed so that #VC handler could read this msr, and
> > > > > trying to read it will cause another #VC which is probably not allowed (I
> > > > > don't know this detail of SEV-ES)
> > > > > 
> > > > > I guess #VC handler should instead use a kernel cached value of this msr
> > > > > instead, or at least KVM should only allow reads and not writes to it.
> > > > 
> > > > Nope, doesn't work.  In addition to automatically context switching state, SEV-ES
> > > > also encrypts the guest state, i.e. KVM *can't* correctly virtualize XSS (or XCR0)
> > > > for the guest, because KVM *can't* load the guest's desired value into hardware.
> > > > 
> > > > The guest can do #VMGEXIT (a.k.a. VMMCALL) all it wants to request a certain XSS
> > > > or XCR0, and there's not a damn thing KVM can do to service the request.
> > > > 
> > > 
> > > Ah, I understand now. Everything makes sense, and yes, this is really ugly.
> > 
> > Hi Maxim and Sean,
> > 
> > It looks as though there are some broad changes that will need to happen
> > over the long term WRT to SEV-ES/SEV-SNP. In the short term, how would
> > you suggest I proceed with the SVM shstk series? Can we omit the SEV-ES
> > changes for now with an additional patch that disallows guest shstk when
> > SEV-ES is enabled? Subsequently, when we have a proper solution for the
> > concerns discussed here, we could submit another series for SEV-ES
> > support.
> 
> The SEV-ES mess was already addressed by commit a26b7cd22546 ("KVM: SEV: Do not
> intercept accesses to MSR_IA32_XSS for SEV-ES guests").  Or is there more that's
> needed for shadow stacks?

Ah, yes, you are right. That patch should address the controversial
change discussed above at least. Patch 5/9 and 7/9 of this series also
address different SEV-ES issues and will still need to included.

Thanks,
John

