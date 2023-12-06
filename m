Return-Path: <kvm+bounces-3698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C592F8072F0
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:47:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3228AB20E3E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 14:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74AF23EA70;
	Wed,  6 Dec 2023 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HIydW5o1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EBA10C4
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 06:46:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rcn8Y4Yafq93mZqWT8qqp9F+MHB9+IVLOdyGUcK/FaADjiy/kvvxlXDgKuAMirMnqlIWGccDPxb6IYqXIJ2yXryroBiT1M3kRO0iUQKH8R4Dpth8kphxGn1UlU9LT5LoQKWA3/ed7KePeRPoTETE89AFzwWo7m+ZKIBeV4GFx6P0jGN+Eu5E2KUpJvEfbnLBIvSJNYwuacyRE2z3P0vAHzFilgGu8h9yAGWNBrMCaJ4Rhnv2kH3u8uxHCaf7bX4HwBjrTD0KOQzfP45v6Xx79OO6J5PaFrsErcSX60diX8WTxP65ytI/7tvOKHL2VxVgkIZSC+68ljWBabySjVqDHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3TgDCQrFFaW9hai/kmxeUSCWih52LF09YCnLdhQ5mE=;
 b=IbnmynhAVxi9plWi4KJjmzWd16w5VjiUKDohVmalPTQiRp4xDRRftwHzIXPt+Zlw0JIuODk8wPVimraKEQeaARGfQwubJvJKoXNL5LAq2EIIHxRQ/eNeFBc3CY9JxBDyRVc9YyylM9qsDfIxXPNhpGzVvZNHXBRd7XYN+HWU/n3qqWG4/Y1/2t+25unNs45MZEfEOQKe4wOYIbGp3JZTipPfUS3fTHSC1wvs8pjDD0FK1czQ0X135jOI6qIb652MnFMZrfdItqcrrorkRfp7QM5VzRytjmHfyw4IpPqF+mAorvSDubeLoUrwnEjvn3Oh0tYy7s9TxYZ8Zi4lWMD8Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3TgDCQrFFaW9hai/kmxeUSCWih52LF09YCnLdhQ5mE=;
 b=HIydW5o17QPW3USe7+5yhBqzblS1/p1GQXKrvyj/kYXi6HEN70x7720am5ipIzKpCzzGI20uaFE25LWeH5KuHEZ7+iett7rdPnkVAoT64tCgiqEhVi74M+/7zPjx6T4ZlJ2rwrMlBkvn1Efrec4mXEU55GzitObPgAi5o6mzXzI=
Received: from BL0PR02CA0023.namprd02.prod.outlook.com (2603:10b6:207:3c::36)
 by DS7PR12MB5718.namprd12.prod.outlook.com (2603:10b6:8:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 14:46:42 +0000
Received: from BL6PEPF0001AB77.namprd02.prod.outlook.com
 (2603:10b6:207:3c:cafe::76) by BL0PR02CA0023.outlook.office365.com
 (2603:10b6:207:3c::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 14:46:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB77.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 14:46:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 6 Dec
 2023 08:46:22 -0600
Date: Wed, 6 Dec 2023 08:46:05 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, Marcelo Tosatti <mtosatti@redhat.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Akihiko Odaki
	<akihiko.odaki@daynix.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
Message-ID: <20231206144605.mwphsaggqumiqh3k@amd.com>
References: <20231205222816.1152720-1-michael.roth@amd.com>
 <CABgObfb0YmHuw6v9AGK6FpsYA1F3eV2=4RKaxkmVrp97QCDM3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfb0YmHuw6v9AGK6FpsYA1F3eV2=4RKaxkmVrp97QCDM3A@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB77:EE_|DS7PR12MB5718:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a6edda3-3dcb-40a1-ea34-08dbf66a294e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qQv7J/R+3HUl2yP5Z7V0dWlAA1GVHjxTs+hyLml5Oe9B0nZOp+3Ok5csmhCrFZqdgOUySWfOUAW0ZA/utDB/qPGEyg6ll44kiPuENFkdGM8+kudf5xElkpPXqKXz4PXXV8EAqSQ19FcLTIFyKAsN/ftsaybz8VqnLXRH4kupsMuSNX1h6UICPISKSFKtMbsycT+f9UtOm88xyvKz4QeYYdCxnrxX/dSEuN2xsItkhcMsuhL+f6Qp+saMALCvMdCzGGs00ON2bfr7n1KEfOQM52Nrw1Ig0hyczbk4eVPEMYGNPz65Ym2qFSRlo552z+jJc0lkPfJr2H7L8xsK1vxXAR92Z1ksQFU/e+kO4ajYLemsxQ86MGICE7sCTec025eb/kzkmLo50X4av7U684Ohk0rVzxSIrMCZ7cVtEEpLSWEv6Xd0VkNblBMubIOWQLmNO4WPZ2uhGBMMPD8M/yIh9b3uZfGiiFh70U0loeoQ1fguiIKW+/EVSqOEi8a7fbanaD6gSApVTTckxbRWM+k8fT/TswqqD+VKwq+cgtzPP+rxWFe42eWdttahce1aXEKOaIbzedU0Z9bFj4YBjDicmlks+c/mBtDNZ8Z3nU5+xGKRANGDzRCF6oeboQq9wQ/YWBHWpRkvDMoiUFuWCz+tsrkWbqB33oEg5nEYkX9/fNUObNbSYw4NWLBGTewLWyWd9UnpVzWzNxtO2igFK6Ie2HyzuU/n8/SbEC28meBAUxCepWof2kTR4I/j3tYyPlkS4g+4/pEcrst6MDDdnjbFCQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(186009)(451199024)(64100799003)(82310400011)(1800799012)(46966006)(40470700004)(36840700001)(40480700001)(40460700003)(36860700001)(81166007)(47076005)(356005)(2906002)(5660300002)(82740400003)(83380400001)(16526019)(53546011)(336012)(426003)(6666004)(1076003)(26005)(2616005)(478600001)(70206006)(70586007)(54906003)(36756003)(41300700001)(4326008)(8676002)(44832011)(6916009)(8936002)(316002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 14:46:42.2592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a6edda3-3dcb-40a1-ea34-08dbf66a294e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB77.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5718

On Wed, Dec 06, 2023 at 02:41:13PM +0100, Paolo Bonzini wrote:
> On Tue, Dec 5, 2023 at 11:28 PM Michael Roth <michael.roth@amd.com> wrote:
> > @@ -3637,12 +3638,18 @@ static int kvm_get_sregs(X86CPU *cpu)
> >      env->gdt.limit = sregs.gdt.limit;
> >      env->gdt.base = sregs.gdt.base;
> >
> > +    cr0_old = env->cr[0];
> >      env->cr[0] = sregs.cr0;
> >      env->cr[2] = sregs.cr2;
> >      env->cr[3] = sregs.cr3;
> >      env->cr[4] = sregs.cr4;
> >
> >      env->efer = sregs.efer;
> > +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> > +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> > +            env->efer |= MSR_EFER_LMA;
> > +        }
> > +    }
> 
> There is no need to check cr0_old or sev_es_enabled(); EFER.LMA is
> simply EFER.LME && CR0.PG.

Yah, I originally had it like that, but svm_set_cr0() in the kernel only
sets it in vcpu->arch.efer it when setting CR0.PG, so I thought it might
be safer to be more selective and mirror that handling on the QEMU side
so we can leave as much of any other sanity checks on kernel/QEMU side
intact as possible. E.g., if some other bug in the kernel ends up
unsetting EFER.LMA while paging is still enabled, we'd still notice that
when passing it back in via KVM_SET_SREGS*.

But agree it's simpler to just always set it based on CR0.PG and EFER.LMA
and can send a v3 if that's preferred.

> 
> Alternatively, sev_es_enabled() could be an assertion, that is:
> 
>     if ((env->efer & MSR_EFER_LME) && (env->cr[0] & CR0_PG_MASK) &&
>        !(env->efer & MSR_EFER_LMA)) {
>         /* Workaround for... */
>         assert(sev_es_enabled());
>         env->efer |= MSR_EFER_LMA;
>     }
> 
> What do you think?

I'm a little apprehensive about this approach for similar reasons as
above. The current patch is guaranteed to only affect SEV-ES, whereas
this approach could trigger assertions for other edge-cases we aren't
aware of that could further impact the release. For instance, "in
theory", QEMU or KVM might have some handling where EFER.LMA is set
somewhere after (or outside of) KVM_GET_SREGS, but now with this
proposed change QEMU would become more restrictive and generate an
assert for those cases.

I don't think that's actually the case, but in the off-chance that such
a case exists there could be more fall-out such as further delays, or
the need for a stable fix. But no strong opinion there either if that
ends up being the preferred approach, just trying to consider the
pros/cons.

Thanks,

Mike

> 
> Thanks,
> 
> Paolo
> 
> >      /* changes to apic base and cr8/tpr are read back via kvm_arch_post_run */
> >      x86_update_hflags(env);
> > @@ -3654,6 +3661,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
> >  {
> >      CPUX86State *env = &cpu->env;
> >      struct kvm_sregs2 sregs;
> > +    target_ulong cr0_old;
> >      int i, ret;
> >
> >      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
> > @@ -3676,12 +3684,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
> >      env->gdt.limit = sregs.gdt.limit;
> >      env->gdt.base = sregs.gdt.base;
> >
> > +    cr0_old = env->cr[0];
> >      env->cr[0] = sregs.cr0;
> >      env->cr[2] = sregs.cr2;
> >      env->cr[3] = sregs.cr3;
> >      env->cr[4] = sregs.cr4;
> >
> >      env->efer = sregs.efer;
> > +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> > +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> > +            env->efer |= MSR_EFER_LMA;
> > +        }
> > +    }
> >
> >      env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
> >
> > --
> > 2.25.1
> >
> 

