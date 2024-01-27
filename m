Return-Path: <kvm+bounces-7281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA8783EE0B
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 16:45:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F9CBB21EC0
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 15:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6524429422;
	Sat, 27 Jan 2024 15:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VM0q+w5H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA8928DD3;
	Sat, 27 Jan 2024 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706370328; cv=fail; b=m5HVZtZdzoFCCGLVXTjFcm3NdKjUScLNEv/9Skng+d4ra4kLXaTA4pvaavBw5EdempdfZ9IJ4lFsKm/mIQcB7PfmRoC6RLfXC4+rVA7O4K0H4Opg9zxxcfnLRTr7xjfXa73a3QOJB9JvzkSpoDnMnPN1op6mKeDXhn4nTIZlSe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706370328; c=relaxed/simple;
	bh=cpJdl/KLyH4nt4a3/9uzX9y+G1ZjU5cLci8ZQSoUlo0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKXwRM6Ws8XJhFztt1eWVKYVNVZOLHAVcZbFwV+51FN3UlYxuL3JAZewsAh7szo+ZGsiVp1G3AyVJ3CheCYZ5nPiIA1S9nWC6tEnux1G4l6QaNMlu9qIIvurvQV8jLmjp6+GZeA2AbPZZVd7NNxzxJRoNiE3lE3a/ParrisYX9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VM0q+w5H; arc=fail smtp.client-ip=40.107.94.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YI7Shyar2bN32WpDzsK313uAHkaQ6IM+JPitk98C1SwpCZPaR6WW+YMPeHokxbbieVqIAua5vY0bC1d42YLVq0mGSesAacISioGlFCjDrdBGY4kiks/0E7T9AoFjQGwxK0OLjn35GY7olcHScZnC423rHe7lSic38fPutJbIUlcq3rK4HXENEQ2cY7qfwcEfIvD1lOymLnmpQQaax7y2L3EeTYx0MMl5SAZcUZZAcNtCOYaaPazZ70U7fc/HtqOhFil+AxBxCUEF7lfiZ3gzTjazg/qYARlp49DJvf/R/791ec8a0+2CVwe68Q2y/kaNVaq0evY1zkFWQFw2h1g3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eIgWZRkoHR8/peI0RlxwsM2rSt1Umjo3Dmebk+MIZtI=;
 b=FRJgvbb6uGaGlI86PHFyyLfhzdxj0vYgt1B93IRYYwzVjNpNFrbcMCoKX2L51leFPkNuduob/aOtCaV/dbw6XNWNvJYkdKOWIA5LvtsF9Lc97fnUwGpZa7bx8mMkyUrCKaRbn9NLKywJc2t5m7SvLHYHlPXGPMKIwTNBjY5OLOkXFBA+0bBXjNaVk8sGisBjISRbrkSJRXO+RXAS98dFHcVo8T0CAOF11x4KVTi963r1DNtDm6QPMTErxTduvBZUlWiNLR/bd/LVsXYDhoC8rHjF70K7UjaOdw1EiMnEJ7Io9k+RdF34LBzx02lKvJvZivhnGpAo1zm0YUFh9Y/2Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eIgWZRkoHR8/peI0RlxwsM2rSt1Umjo3Dmebk+MIZtI=;
 b=VM0q+w5HG9BR0v2QTQxSOWGWMiOegojSJdyPszSKVnSYfYTrgZYsTMSnfnK1QP2l5/IpZQGNsHRHYDGLXDbd/D3vhb/nFZTyKp4zDs6reSsiBXnxiFnnbsxKO3El912vgk0Pwo3dHNDoBlO8NOdfB6HFKk1K/5DTRoRVhZqzLAA=
Received: from BL0PR02CA0107.namprd02.prod.outlook.com (2603:10b6:208:51::48)
 by BY5PR12MB4258.namprd12.prod.outlook.com (2603:10b6:a03:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.31; Sat, 27 Jan
 2024 15:45:21 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:51:cafe::8b) by BL0PR02CA0107.outlook.office365.com
 (2603:10b6:208:51::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.30 via Frontend
 Transport; Sat, 27 Jan 2024 15:45:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7181.14 via Frontend Transport; Sat, 27 Jan 2024 15:45:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 27 Jan
 2024 09:45:19 -0600
Date: Sat, 27 Jan 2024 09:45:06 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v2 11/25] x86/sev: Adjust directmap to avoid inadvertant
 RMP faults
Message-ID: <20240127154506.v3wdio25zs6i2lc3@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-12-michael.roth@amd.com>
 <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
 <20240126170415.f7r4nvsrzgpzcrzv@amd.com>
 <20240126184340.GEZbP9XA13X91-eybA@fat_crate.local>
 <20240126235420.mu644waj2eyoxqx6@amd.com>
 <20240127114207.GBZbTsDyC3hFq8pQ3D@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240127114207.GBZbTsDyC3hFq8pQ3D@fat_crate.local>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|BY5PR12MB4258:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b8c8e4-a730-4017-64e4-08dc1f4ef7a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T0uix9xMryNqjhgdI4rJ7He12MGm+7IlakDuSdpDu04OLYaLmBJSVIYMknC5gGl0IqHyOy6o5pkfwUb2Z/g4oivTZZOlLFlOOE3EPRxp0x3/VSPdZGzcvTxH8Qtj6u7giYSMwn7l2qwyHuzCjGHD3XZ7eJNBOU9yVgUk36MwlaBJd23LK4dJUGCbq8AKMTgxqSXfHxrbcC0edKlbO7hv6MZxD+InyVstTluWmvL0AK3vA0JHPeActObYayg00muhuqUIhcaIXvA9NRnvtEk5QKlVRIUYioc72ZYMtlzazdqdBGC6azfTFg4Axx1G7JBXSEmWI1RYCBl8RG5hnHHunI/TaGojHRmv3do0i6NHpPw4n66G0ug3zSnHkeKC5+spG5haSv7RtKqBMVkmLnyi410VSllcH1BSDDz6PEtGdA+4RLlaVy5Vud9NSuxTr0lrT9GiIAQznciz4lybk8kgbzAiZy1UtkhkKcuGfstg2HzmHqsh5FbOUez7Yhu6JFqg2sfXionKPaLXZCDxdDe2fecD75PRQRQpT97RsjIT3mR7ekskObliTc5DLWtx0o2umI2Vqp5v5tM65GbeTfdmumfPVP8Dyn+edGWVABBX8sQYlVVQgWf4tOkCN8MrQOS+t1FCfRSjowTL9ifes8/+9xqG8tNaKkmwq29Wx3sjdJ50zN3/X0QF/7L9KEa7fza+Yh5FjIt+R141kx9a0SAL5bL6BFQO3UgyFoUbNVYql91Ucsn6bPMinxepCkfjXwl1fbayeP/uhvz7JakBMjvH3w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(346002)(39850400004)(230922051799003)(451199024)(82310400011)(186009)(1800799012)(64100799003)(36840700001)(46966006)(40470700004)(36860700001)(83380400001)(36756003)(47076005)(54906003)(6916009)(316002)(70586007)(70206006)(8936002)(8676002)(86362001)(966005)(478600001)(6666004)(4326008)(26005)(16526019)(2906002)(1076003)(336012)(426003)(44832011)(7416002)(7406005)(2616005)(5660300002)(41300700001)(356005)(40480700001)(40460700003)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 15:45:20.2061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b8c8e4-a730-4017-64e4-08dc1f4ef7a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4258

On Sat, Jan 27, 2024 at 12:42:07PM +0100, Borislav Petkov wrote:
> On Fri, Jan 26, 2024 at 05:54:20PM -0600, Michael Roth wrote:
> > Is something like this close to what you're thinking? I've re-tested with
> > SNP guests and it seems to work as expected.
> > 
> > diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> > index 846e9e53dff0..c09497487c08 100644
> > --- a/arch/x86/virt/svm/sev.c
> > +++ b/arch/x86/virt/svm/sev.c
> > @@ -421,7 +421,12 @@ static int adjust_direct_map(u64 pfn, int rmp_level)
> >         if (WARN_ON_ONCE(rmp_level > PG_LEVEL_2M))
> >                 return -EINVAL;
> > 
> > -       if (WARN_ON_ONCE(rmp_level == PG_LEVEL_2M && !IS_ALIGNED(pfn, PTRS_PER_PMD)))
> > +       if (!pfn_valid(pfn))
> 
> _text at VA 0xffffffff81000000 is also a valid pfn so no, this is not
> enough.

directmap maps all physical memory accessible by kernel, including text
pages, so those are valid PFNs as far as this function is concerned. We
can't generally guard against the caller passing in any random PFN that
might also be mapped into additional address ranges, similarly to how
we can't guard against something doing a write to some random PFN
__va(0x1234) and scribbling over memory that it doesn't own, or just
unmapping the entire directmap range and blowing up the kernel.

The expectation is that the caller is aware of what PFNs it is passing in,
whether those PFNs have additional mappings, and if those mappings are of
concern, implement the necessary handlers if new use-cases are ever
introducted, like the adjust_kernel_text_mapping() example I mentioned
earlier. 

> 
> Either this function should not have "direct map" in the name as it
> converts *any* valid pfn not just the direct map ones or it should check
> whether the pfn belongs to the direct map range.

This function only splits mappings in the 0xffff888000000000 directmap
range. It would be inaccurate to name it in such a way that suggests
that it does anything else. If a use-case ever arises for splitting
_text mappings at 0xffffffff81000000, or any other ranges, those too
would best served by dedicated helpers adjust_kernel_text_mapping()
that *actually* modify mappings for those virtual ranges, and implement
bounds-checking appropriate for those physical/virtual ranges. The
directmap range maps all kernel-accessible physical memory, so it's
appropriate that our bounds-checking for the purpose of
adjust_direct_map() is all kernel-accessible physical memory. If that
includes PFNs mapped to other virtual ranges as well, the caller needs
to consider that and implement additional helpers as necessary, but
they'd likely *still* need to call adjust_direct_map() to adjust the
directmap range in addition to those other ranges, so even if were
possible to do so reliably, we shouldn't try to selectively reject any
PFN ranges beyond what mm.rst suggests is valid for 0xffff888000000000.

-Mike

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

