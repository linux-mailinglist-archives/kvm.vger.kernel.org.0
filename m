Return-Path: <kvm+bounces-8562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CAC8519F5
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 17:48:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B97451C21D51
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 16:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 898D93D3BF;
	Mon, 12 Feb 2024 16:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DrNhryt3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DCA3B2A4;
	Mon, 12 Feb 2024 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707756501; cv=fail; b=IhEXzYqDXOntkNH3NXjHW0tHoMy55SwrE2ikEKWPLyGaQDdwsLfQTIFK8OlFks6YwLhKHeZ8P4e+JGK5g5o0moe2wx1A+X0BvIQI6E1nqLLGyGRADQlkfvYrvk4kjcav9dtieEbCUIk87/1q5Aacy6bLHaqmhKBvKAem3tYpgBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707756501; c=relaxed/simple;
	bh=3k5k5qee6eWk7LEhWrYbQZGd9WjyTJHdUL9kGVhJafo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBDKkFdbJlROKVuJrfv99Ssf5qU5LjncgoRXqRFJsqBbDgAuygUEcQbUasRExZyeq5cVqHQA43LQGEbSSrkfasNWE85SdG0f3iLZurwOMs06s0cefsd93yRL5IowQ5p06WGTQAXtzN1RBy4r4mx4HaDjwbViNPuLlNJiqMPBV20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DrNhryt3; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHJRIEz9w4JU/01ioo/csFEuM71FACpGPYCbxVlAO+AFOYM1kaq+0t1SQ7RO6b1qLCjKPcbQ6rp+eIibhl7it2nfWlmaqkflkxrIRiUOYjgrBM79NfdBjU/FObD39NBj5usa+/Gm94+pH774wywnLkhPgQJeEqCbzXKlnZUgdPUT0FrA/YfzT8IG7Y5SZdzfJu5dzKB0QrzfpCHhokcjJqh2qzZtCXNDkkhRD+aUhxF22FS0/Kxmn2vfm4cq/Ap2d+i/YkAOSiHhZb0FKNK/AyiZpSc616c84QzYRyhjMaUf+BTa6nm9SgqXpaR/L9QGQRBxSqCM4dTSEK3vjKCNdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbMuACD0lPfGD5S/QtazwiBrPKqspUoJ+tvsxoWNemk=;
 b=f48lPEn3Pgmy5/SwyMkLVc19dAg9uxD2H3CA7X4LdA4U3FEcKb4ahl0MrPvXcJRdX851op074RJp0P6ZoA5vt8IQ42PG6XrT1UYIALZNkP8K13ymb7LXPP+tIBdhfFjzs4ZKqFrZ+TmdBpnaY0lvLCaUkjWpP81yyhBpU+9COE2jdECPemFvRRRaSkMqsVdw4Zbdwg6u0YX2rdgf9fly5/4GdwybicsuZ1mvWMSKDaPNrH0UbfxsYJe9AYCJmSrojJw5HKRhOnKDqeMtd9xsJQ8JFuy1a1ZDCgempMY++WubsZQAjWpmL2ZJ7SEjGydZrZZiF8oibz3JCzHKuArzJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbMuACD0lPfGD5S/QtazwiBrPKqspUoJ+tvsxoWNemk=;
 b=DrNhryt3SiQMZIiViEdy6LKSmFT1udyzL9QY04q9jiHVmSNhq2bOhH/R8dSP3iwdjcO8H+f+urN0e9SGEBMrf1awUYMNgy3F4eF62hH3YPpYOH6HoZmeeS1w/hRwrzu1AiJS6lV0jPiUI8oVJakkHI8jJ6vfyxPu954TqfpkqyA=
Received: from SJ0PR03CA0369.namprd03.prod.outlook.com (2603:10b6:a03:3a1::14)
 by IA1PR12MB6578.namprd12.prod.outlook.com (2603:10b6:208:3a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.10; Mon, 12 Feb
 2024 16:48:16 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::81) by SJ0PR03CA0369.outlook.office365.com
 (2603:10b6:a03:3a1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.38 via Frontend
 Transport; Mon, 12 Feb 2024 16:48:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7249.19 via Frontend Transport; Mon, 12 Feb 2024 16:48:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 12 Feb
 2024 10:48:14 -0600
Date: Mon, 12 Feb 2024 10:42:27 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <vkuznets@redhat.com>, <jmattson@google.com>,
	<luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
	<pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 06/35] KVM: x86/mmu: Pass around full 64-bit error
 code for KVM page faults
Message-ID: <20240212164227.e3647svomtqfld6l@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
 <20231230172351.574091-7-michael.roth@amd.com>
 <ZcKb6VGbNZHlQkzg@google.com>
 <CABgObfbMuU5axeCYykXitrKGgV5Zw-BB843--Gp4t_rLe2=gPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbMuU5axeCYykXitrKGgV5Zw-BB843--Gp4t_rLe2=gPw@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|IA1PR12MB6578:EE_
X-MS-Office365-Filtering-Correlation-Id: 539bbb21-d96c-49a9-37a4-08dc2bea68c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4Fk5yvYvVP0prrbHP8jhVTIL7n0M9nEIqP55WWP3quTRoCpHpjnJq/BYVbw5IdNLljDHrBzUiRIHQJnUPVTPhw0ewNGLZb8w3CYt5WFTAxmnz1AX4+DFkR+67oqWrQrowu2aO4IbY3+vUIqw32xxTK3Uy4/crs+3Ys7ScPMs0lSvLiKQsaRx2Fesfd9BMF7GqLIdWmS+t90SIzVjkD27LjLcOjESuhl+QqF3L1O5BwiZoYXVDpCZ/qPUavXp/S4gC307ClD+o2/4bFQYS4tha8Ry4xdSgixbz4lk99RWSzY5412TGj4Uw3E3InL4LC5LbdEh3yb81cJdZV7k04r1nohbWQfuEILqJUMmq85MwfA2qMZ9WX60QrsY/MTMHedSd2pzeHH7bu4fw9gxLX8uFVI+kmTSKgMJdP97QgBIzCDOwcaX7ZOj6QeAR/rm3vtAntHKxhHte17hrwBxLd3HxybhfuPYoocqa0lgj+IdicDiVuhrn6oUD9iLyQgZYt7eWqvljMqFQRCgIfFpPO750VB0Dhh33s67E4l97DVQsFcI8PXJju6Y1TJXKXFuncfz/b59Nh/z6pthBkywqWFL+w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(346002)(376002)(230922051799003)(82310400011)(186009)(1800799012)(451199024)(64100799003)(36840700001)(40470700004)(46966006)(8936002)(2906002)(7416002)(5660300002)(8676002)(7406005)(4326008)(41300700001)(44832011)(356005)(81166007)(83380400001)(86362001)(36756003)(336012)(26005)(54906003)(16526019)(426003)(2616005)(82740400003)(316002)(478600001)(70586007)(6916009)(966005)(1076003)(6666004)(70206006)(53546011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2024 16:48:15.7989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 539bbb21-d96c-49a9-37a4-08dc2bea68c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6578

On Mon, Feb 12, 2024 at 11:00:27AM +0100, Paolo Bonzini wrote:
> On Tue, Feb 6, 2024 at 9:52 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Sat, Dec 30, 2023, Michael Roth wrote:
> > > In some cases the full 64-bit error code for the KVM page fault will be
> > > needed to determine things like whether or not a fault was for a private
> > > or shared guest page, so update related code to accept the full 64-bit
> > > value so it can be plumbed all the way through to where it is needed.
> > >
> > > The accessors of fault->error_code are changed as follows:
> > >
> > > - FNAME(page_fault): change to explicitly use lower_32_bits() since that
> > >                      is no longer done in kvm_mmu_page_fault()
> > > - kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK,
> > >                         PFERR_NESTED_GUEST_PAGE
> > > - mmutrace: changed u32 -> u64
> > >
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Link: https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#mbd0b20c9a2cf50319d5d2a27b63f73c772112076
> > > [mdr: drop references/changes to code not in current gmem tree, update
> > >       commit message]
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> >
> > I assume Isaku is the original author?  If so, that's missing from this patch.
> 
> The root of this patch seem to be in a reply to "KVM: x86: Add
> 'fault_is_private' x86 op"
> (https://patchew.org/linux/20230220183847.59159-1-michael.roth@amd.com/20230220183847.59159-2-michael.roth@amd.com/),
> so yes.

Yes this is Isaku's patch, I think the authorship got mangled during a rebase.
I'll make sure to get that fixed up.

-Mike

> 
> Paolo
> 

