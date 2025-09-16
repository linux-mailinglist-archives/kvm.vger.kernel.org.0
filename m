Return-Path: <kvm+bounces-57787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0648DB5A343
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 22:37:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8490C462D6C
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 20:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE4AA31BCAA;
	Tue, 16 Sep 2025 20:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OgSFHse0"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013049.outbound.protection.outlook.com [40.107.201.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C22131BCA9;
	Tue, 16 Sep 2025 20:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758054798; cv=fail; b=FTKRntyVbQ8b2ROFYS4EsW0SUmVkk65eVnzEOLb7PJyHPgq35WRPWG6qzqjaMENpHIiBDChCYStH8keGveO/AhR7FxmlVu3/PR40SCxj1LwqfWev0Ghu3RFIFqPOsjDPSrkfZPix1DtPjTLmj1jq3ddjQmcToGP2wtNlE77Ls/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758054798; c=relaxed/simple;
	bh=nc0n5eEq5PJSldQEyHTBUqG42Ge0sZBowWTYFsxN9/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dRTlRHKfadJNpQqsqW+N1pmgiyiW4TpyRTGDzuryAlJwLWcVG9duQL4APuITPz5USTjiPyIqgn4uiMDNm2VCO7Rp9f8BqPXGBQ4ICNL0EIw8zAnwXCVFAOw48nSuOoy9juYpCaQNKtKIwGzh4OY+3zN+B77tJKLHchOOpdooe0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OgSFHse0; arc=fail smtp.client-ip=40.107.201.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rjNZNDVUTdAxA92gcGuUI1EIuGCvurGk+C/+D2FONMOru5roNm8O6hNfjl/ku1bd4LMQG9av77CLbsb4f5SidCvEROD4oQOwNYy6khrblGobW2V4rl0/CxNGcq0J2/HdLHvVOUNH/AHRU0todcSbbUGQDjvdL0pkrTARtS2nC3m7EfKmQrsQ1RrYgYZY0D3ebEnnMTaTqTjDJd47kjMg64dWVnUzk3YA02BbUovL0+K6ASHU3zh3H1x4wzTUGJxm/wDDnOUyKWqoXrfEHuk+6BMDEUzve5fKDehfI0aBHgHZxB71Ep3nNtMhRPfWr+Smql5WXEhF9N3m8+7MXcztrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFvLNwxaOiKgK3+p/gtx0DKXE54PyrRR2tPsij1hR7Q=;
 b=fdxQ6+mnFhCpcSyVGWqF9+ASo9Jjy9b9SWPIMz5rWP8MsU97bTJv8f66EnqRqZS0KYOuR9gg9gci0yEdZpLwthIoBc6dYW+yDanAxkVucqmEIH2DYJnwXg6PahbQMP98MHqpNxEXRsDgkjQUQ3r6rrBWxx09qOEz80iacjLeBAtPOG4BpzoweuarDgUIbEeeU5ZLqZYhExEUFkO7lwWOfcP9+l3BK0DoXdV4pQCWG2JBUL+r+W66XUU7aD1qCP7qI+HkXJCIDpWJTDJz+0MM/aNjPDgnsfW6Dx+folo5dh/8pqAWXYBq8KOww8SFswUrCgUdqqH4BThDG/BTs+EpPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFvLNwxaOiKgK3+p/gtx0DKXE54PyrRR2tPsij1hR7Q=;
 b=OgSFHse0YS5B29sCHxZ2+H9x2syXm4SXSyxFyggD/Wg2vPxApphyO5PabDEoY/dKaLA98zzJp/0SMsQ8ws/qBqDOfs0y2NU1Z5uKTBe0vJ/wuSXzXt4NVLRCCDx2bNb9QjtHru+f+AaVu82NGv6R4SOMPv0VHvkzqwdioz8qy4c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by SA1PR12MB6749.namprd12.prod.outlook.com (2603:10b6:806:255::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 20:33:11 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 20:33:10 +0000
Date: Tue, 16 Sep 2025 15:33:01 -0500
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
Message-ID: <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-30-seanjc@google.com>
 <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
 <aMnAVtWhxQipw9Er@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMnAVtWhxQipw9Er@google.com>
X-ClientProxiedBy: PH8PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:510:2d2::29) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|SA1PR12MB6749:EE_
X-MS-Office365-Filtering-Correlation-Id: bb24b6ca-eba9-4142-ce5d-08ddf5604071
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Shu+k7NSw2495Mwz/4D+Ebc64HMrRMgvPC2XwtUNG2UDZ0IyGekxmIad0Qj2?=
 =?us-ascii?Q?F0sVs7sSvcX2710kObBnG1lyzOHvD0uXTQyqBkP65m/dPQYlXZ9Tg7ZQsykW?=
 =?us-ascii?Q?ts5guU4it6eBYyMS+x2hC57IErcSN1eZ8zA/OzaFTlZiB8V94tQaDlyzu13L?=
 =?us-ascii?Q?hx/z5rP13Eh3Ls98Cl/geo8rMJTjgZyAoPkU5RCe7q3TTGpSwF2I1N0cfRe6?=
 =?us-ascii?Q?N2NSWT6I3K502rkqW0UDbz2PxUUt5IIOrK9Cv729yCxmTSDT20TksReBhEix?=
 =?us-ascii?Q?yi/9899URKqO4WTas/Ilv778TVitk40UXthhJYc1FJm21p74Rz8LzbOJbjYx?=
 =?us-ascii?Q?qhzTrgpCcZAIy3y/zcILj+XewD1O7Yc+JPQ6XXgPARJ/nf8W670LOHytLCos?=
 =?us-ascii?Q?INSw1K5wf0CIa4V4GxLZLdMfyC8XvxoukmNehUz6t35uO8Mc1sK/xsr4y4dW?=
 =?us-ascii?Q?vYR2X3V7s45CdfOaC4PrrKYNPO/rulcRSairww/P7TD2MmCxC8UPY/G+ylln?=
 =?us-ascii?Q?HXQklTFFceIffiD67yAVtF46iTGjnCKcrVqBOYSp6KdI6Q7q55XtLkG8W2Yw?=
 =?us-ascii?Q?yrkz7yRpwiCsh2il11mUaB9baPQM7DvQfkqk+103vsH48cEK6nO8lNGd5WNK?=
 =?us-ascii?Q?7XyKXSL9jp8VBdMwEhIU5O5hizH7jS7nGwlcDehfj0SOIh1jlyh31ffzosKX?=
 =?us-ascii?Q?jQFovRyC2i4xwkeOu3hcpzfzqBbTHbJOmUDP6hWOsX0TfCwxAqN+B/n/k/o0?=
 =?us-ascii?Q?jmjxxirf+0d+cMqf49YCq2bK8tn83ODGS4kLdPjglEAtYn5kDrk+HnlhS7JJ?=
 =?us-ascii?Q?vXxVxr+8PiH51+5KQymVqpFBoM3jSe7fk0VoAMwsFVLvt0f+6xisbtuq55Sb?=
 =?us-ascii?Q?ZFmXIysCxbOdPSrSrRsPXIH5KsIZEhjDMpThzfp14jVO/DRkt8k3FHxTS6K5?=
 =?us-ascii?Q?kcPmv7vVoeAFV/Qiitsb/vzCYBnl6HxM0jBp5EnDaBoHC7MuNANioI0VE1Ny?=
 =?us-ascii?Q?jvNVugZVsHMMN4tQDocSIvD72km3aCCFBYbzLITVwwWW5sJ1/U90MEuC21cd?=
 =?us-ascii?Q?RdWOkyt/+72d0XTnlV2y5eOzxGuuNpuF1FpkvgKEzrhjQ4trKeuMISVVErHR?=
 =?us-ascii?Q?m4VIclw75KAQ6f/TLVMF/IP56LJRfY85MUTy1GaL0AaN3oq1etg0PoWrhV/J?=
 =?us-ascii?Q?uTq36dnnriHTIvlnAfahY7egEyqClkI/EQYPA1rvsXBgFLJhhq/3prpxKGU7?=
 =?us-ascii?Q?UUBawGpFwVh53t/a+ZbJGkjfR3Ma+Yf3VQIRdTtFnw4Y9Zc9f6zfgRxyWXgV?=
 =?us-ascii?Q?4dYiyq7yMBcM4F/D6Xy4GOQeZcMsqUwApEcarjB6jXi/GVht7MTxvfE9ffSS?=
 =?us-ascii?Q?E3StPMtNbzpOmibxxzUlFEPYgtNOKFCVcAwESzYpy11h6w6oe2QjzET31nji?=
 =?us-ascii?Q?k7Koj+zXldw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?53epZjhnFSQkaSoI+FxoKAIGuRz/tsSm1JAvWcnNhHj6u4AEzdDrHOlkvAad?=
 =?us-ascii?Q?282p/oVlygkS9kRjrCeLS3bjMuPH+eSYGd+sOLFZp2s8dRWQRVd0v/Lcs8fq?=
 =?us-ascii?Q?mEmbIhFH0qTxaHMZcwIKfg38uLxp9vTSnxGwNb0tVm+n7wrP9fcLndnQtczW?=
 =?us-ascii?Q?UCIy5evM2yaNXEa9TbcADWGNNZT+aov5niQOS1ic0dAICFusRDPSqlQHb1p7?=
 =?us-ascii?Q?19D06CiSpnjtjLUfpDxmr5b0ftCSnKsfm6p7b4Iz/iObnJe2k74wZc9JJ0QX?=
 =?us-ascii?Q?/YqDx8pqy+47iBUlsbFFRCM85Mm6z8YXvEVw0Ufteu6DZEMUw1ZL7tg/6Znn?=
 =?us-ascii?Q?k8UBcLgkVkD/Jmrcxm8YODJG3jFzx0CelkVvC/tphvVxIDaedjEo1DDfXyL9?=
 =?us-ascii?Q?3b9+4obZoMp6lpjoY2wd/0GwD/uTlXGrqWdnDvsdhYeQxtsKe3YQ+wjginQx?=
 =?us-ascii?Q?/HTAGc8t5QR/lJRJpdlWChR61TQvX9/YcfISCRzervTcKofB1Pjy81aMP+0p?=
 =?us-ascii?Q?Vd5QcuJ+X+bJgs8oy2VpUg3jWp+g0cWjgsfjlMeoRnVxP9/P4uS/OyEtNTMC?=
 =?us-ascii?Q?X6XcAeLRyo0fd4hl7y8MSP2oH/Fsj/uopBdzvsjO1FnfaZOaaEsMez/wIsBy?=
 =?us-ascii?Q?/9CBlBi3998+v9hb6uMTANwBrLeVuo0roqtwAMRo4STrQXf47rcsYz1mXrQg?=
 =?us-ascii?Q?Yz9DfFUaghP+N7PpLosvEDu9lOxK4JV3adUx0IDZfqQcEwR/dCjJIocNjvaO?=
 =?us-ascii?Q?OVReEM3ndHplVK8DyaetWiD2wz7vR3bXV6T840yJbSsvFvhMYgpJuh0zaSM8?=
 =?us-ascii?Q?qk643WqkIUjRk+HU5l3YpWOAJR4UjIGKeXM0Si51KW4CBu7v4+8h4QfvIOPQ?=
 =?us-ascii?Q?sP82OlortkB7p06e/rc8eXk0AKnefkIHVAX8TDx4R/ya1YSuPJFahZV//RlB?=
 =?us-ascii?Q?lu8ii1UEaMLEbhsG2HqhqjtIItBxge3NC+I6Wt/NrpcUclPzMGM54TPXNISd?=
 =?us-ascii?Q?td/H0bPPUbfxXliJVNXrSc4xM0jtO6CwCWlmGlXleQMKvWgLkiYwTs+UTjvk?=
 =?us-ascii?Q?bcQ+B1hXMlY+C2qsrUZ2sv0ysvKTf9hBMXIVmK3Zr8+0oCXm4ABlS7aFwE8H?=
 =?us-ascii?Q?1F7KsllkwBYXdA5y+qAnTo2UgPMs6CtUjnvW+q9MK5Y3hxQ30Qcu4F7rtoaN?=
 =?us-ascii?Q?bmDGRbHSoAcULb/nRGduqNLrdwJv8d0GjmVLjH/WI7NRoYdqdO70ysOtT6nc?=
 =?us-ascii?Q?zb+vcOFM9VYXQXw11SBdgph85m/px78Y0+k7ap45lNMtGK/jqFRSvGfsMJ8J?=
 =?us-ascii?Q?g5+IE894pHCOoaj+MbFfk3i6LX4px+rRqwwW9t8jB5LGepuBkb4Jy1z21DaO?=
 =?us-ascii?Q?gUlkHRScxObyS+266gxACQ1NVp4DGEVPv8Ioynx+/EbCao9aQ5tSptv7oSf0?=
 =?us-ascii?Q?awOA/8Vgc+XQ2GTpH2r+ZmBqkjE44XyLROUsTfedj4DXDA8SDQhORNNi1njk?=
 =?us-ascii?Q?uOk/STO+V1a0Zd4/EKwGzqY2Kp0vos2jJeX86b+OhNzQyvYNzg495AEpsA1d?=
 =?us-ascii?Q?85TMWwsYIJljWQx+HjrU0AWAbRROSqnV0ebE6l3I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb24b6ca-eba9-4142-ce5d-08ddf5604071
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 20:33:10.7228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PW1fA1D5jJiHJrskUfv25StbYLxgv9wIgEAaj3pkcGEA4iXJC2uJ0uPs9cgtlJecKy37xt8Ksbs5EuiDPvYrxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6749

On Tue, Sep 16, 2025 at 12:53:58PM -0700, Sean Christopherson wrote:
> On Tue, Sep 16, 2025, John Allen wrote:
> > On Fri, Sep 12, 2025 at 04:23:07PM -0700, Sean Christopherson wrote:
> > > Synchronize XSS from the GHCB to KVM's internal tracking if the guest
> > > marks XSS as valid on a #VMGEXIT.  Like XCR0, KVM needs an up-to-date copy
> > > of XSS in order to compute the required XSTATE size when emulating
> > > CPUID.0xD.0x1 for the guest.
> > > 
> > > Treat the incoming XSS change as an emulated write, i.e. validatate the
> > > guest-provided value, to avoid letting the guest load garbage into KVM's
> > > tracking.  Simply ignore bad values, as either the guest managed to get an
> > > unsupported value into hardware, or the guest is misbehaving and providing
> > > pure garbage.  In either case, KVM can't fix the broken guest.
> > > 
> > > Note, emulating the change as an MSR write also takes care of side effects,
> > > e.g. marking dynamic CPUID bits as dirty.
> > > 
> > > Suggested-by: John Allen <john.allen@amd.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/svm/sev.c | 3 +++
> > >  arch/x86/kvm/svm/svm.h | 1 +
> > >  2 files changed, 4 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 0cd77a87dd84..0cd32df7b9b6 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -3306,6 +3306,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> > >  	if (kvm_ghcb_xcr0_is_valid(svm))
> > >  		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
> > >  
> > > +	if (kvm_ghcb_xss_is_valid(svm))
> > > +		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
> > > +
> > 
> > It looks like this is the change that caused the selftest regression
> > with sev-es. It's not yet clear to me what the problem is though.
> 
> Do you see any WARNs in the guest kernel log?
> 
> The most obvious potential bug is that KVM is missing a CPUID update, e.g. due
> to dropping an XSS write, consuming stale data, not setting cpuid_dynamic_bits_dirty,
> etc.  But AFAICT, CPUID.0xD.1.EBX (only thing that consumes the current XSS) is
> only used by init_xstate_size(), and I would expect the guest kernel's sanity
> checks in paranoid_xstate_size_valid() to yell if KVM botches CPUID emulation.

Yes, actually that looks to be the case:

[    0.463504] ------------[ cut here ]------------
[    0.464443] XSAVE consistency problem: size 880 != kernel_size 840
[    0.465445] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/fpu/xstate.c:638 paranoid_xstate_size_valid+0x101/0x140
[    0.466443] Modules linked in:
[    0.467445] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.17.0-rc3-shstk-v15+ #6 PREEMPT(voluntary)
[    0.468443] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
[    0.469444] RIP: 0010:paranoid_xstate_size_valid+0x101/0x140
[    0.470443] Code: 89 44 24 04 e8 00 fa ff ff 8b 44 24 04 eb c2 89 da 89 c6 48 c7 c7 80 f4 bc 9e 89 44 24 04 c6 05 9d a3 a4 ff 01 e8 3f fa fb fd <0f> 0b 8b 44 24 04 eb ce 80 3d 8a a3 a4 ff 00 74 09 e8 c9 f9 ff ff
[    0.471443] RSP: 0000:ffffffff9ee03e80 EFLAGS: 00010286
[    0.472443] RAX: 0000000000000000 RBX: 0000000000000348 RCX: c0000000fffeffff
[    0.473443] RDX: 0000000000000000 RSI: 00000000fffeffff RDI: ffffffff9fd83c00
[    0.474443] RBP: 000000000000000c R08: 0000000000000000 R09: 0000000000000003
[    0.475443] R10: ffffffff9ee03d20 R11: ffff8c04fff8ffe8 R12: 0000000000000001
[    0.476443] R13: ffffffffffffffff R14: 0000000000000001 R15: 000000007c135000
[    0.477443] FS:  0000000000000000(0000) GS:ffff8c051c118000(0000) knlGS:0000000000000000
[    0.478443] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.479443] CR2: ffff8c03f4c01000 CR3: 0008000f73822001 CR4: 0000000000f70ef0
[    0.480445] PKRU: 55555554
[    0.480967] Call Trace:
[    0.481446]  <TASK>
[    0.481856]  init_xstate_size+0xa8/0x160
[    0.482444]  fpu__init_system_xstate+0x1c4/0x500
[    0.483444]  fpu__init_system+0x93/0xc0
[    0.484443]  arch_cpu_finalize_init+0xd2/0x160
[    0.485290]  start_kernel+0x330/0x470
[    0.485444]  x86_64_start_reservations+0x14/0x30
[    0.486443]  x86_64_start_kernel+0xd0/0xe0
[    0.487443]  common_startup_64+0x13e/0x141
[    0.488444]  </TASK>
[    0.488879] ---[ end trace 0000000000000000 ]--

> 
> Another possibility is that unconditionally setting cpuid_dynamic_bits_dirty
> was masking a pre-existing (or just different) bug, and that "fixing" that flaw
> by eliding cpuid_dynamic_bits_dirty when "vcpu->arch.ia32_xss == data" exposed
> the bug.

