Return-Path: <kvm+bounces-17149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8111E8C1C7D
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 04:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E946BB21A69
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 02:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B884514884F;
	Fri, 10 May 2024 02:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S0MEwlUd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F4B3308A;
	Fri, 10 May 2024 02:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715308694; cv=fail; b=Y/eobW0oUnkJfWpvB8IEcXfyCm/rbdpHvg+SN5X/gajkLi5gxZ/cV7kq+qHnx0Eq45WfHGQ3gfcP7uoxtQXXlVcVntztCctotN4PB8YgCvKvJKg3M2gi5OhzItK+iZPDBFRRUdEwUtskDa3WVIwp20l2s/qHZNQ/MAGjYwatRo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715308694; c=relaxed/simple;
	bh=COu4cexGctVZQhIP5AT+3HWvpDt8DyoY6VhXzF+C8zE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jqb4OoDvxKSFrRpclVmanvcRopkfpRZRexhijZLg9YWk+fQt/y//GYGPIJ0U0fjq3b9m98++8m6dy/eUcNy8Ky+b4mJoSjU0UdEEjMB/0JuRfOpVVfxGoyqk0WCS/4sO4EopjnlEwupTjeQDhAjcg4h3yPGxlz11v2DnI+ey2nY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S0MEwlUd; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hE5AlNywuydnY/pRuzEP7I9QWdqdFIOU7XaeNRUr8ADJnpUA8XiWmPovxSIZHUmkAvgACbRsQOHwoI8r2+8bxnLEMGZ5f4qP+hlSW6rh6pweXSQFeVfE/++8VbqZ9FiUzImnjQBBwUJveb59+vJ91guvk8QkMJ0hajHSpISDyUK0nX3pLGf7kiBV9GHksKiWlxV2HyJUCQky/8zaVlRS1P5xFt3j2lgdXoqDEiJvDRi8Yx4Tmj22TjrqwiVjFrzhObOPz+S1fAu4paW0OLZc4JU/RpmOS7rU8Fum5lskjvW8NX90CekwUDizAw0V1aL4UjHvrw2Z6kHgmFU2z0PQsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJpVRyHJEfwRquQ3de8/+WeEtiWAv4C3PVlpV3TbKqk=;
 b=iWIKVbjiBZBirdg8uT8WjCHDJmldeIK4rbiTeNHGKsK7Okj6OevRoMgf09Yj1Ffb0kIBI7EylzAyE7rtxXspKkOxKhg26cZ4YeTLMvEKczFedkEzhCIp1J4IxwBZVZE0KdDzxKnwyNAp7dyO0aCk37RkEYgpXMq6Zl9vLVczYdom0tshVPeYKfvlIkIfmAiStpJETP0tAU1W8emXKU4IXbBBg714BUU8BWYoAQx32fWdmXMzvBwcNtfpk6VjXZ4r77obP56F9iuCtPCnDs9YvZRa1NBr/QCrY5HpPe5oGHYHDvT4M8145B/sQTUAs21W8P8aYt8x4cX3WH6YUFvhag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJpVRyHJEfwRquQ3de8/+WeEtiWAv4C3PVlpV3TbKqk=;
 b=S0MEwlUdxvh8MCKMhuFEHB03q3PN4FU0zYFXIwNCbaj2Iq+NLW9sYzF3gmK8b6TmMTSRlzSfsn2rRD+Ldm4w6QSuIqq5dkV+VDZ0PZnXtFGZ/5NIY62+ExGTOqyvW66yF0M4fiC6qT5m4ncodhYtQWajFB4LGhXs0wjOhdQ/7Fc=
Received: from BL0PR02CA0136.namprd02.prod.outlook.com (2603:10b6:208:35::41)
 by MN0PR12MB6365.namprd12.prod.outlook.com (2603:10b6:208:3c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 02:38:05 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:208:35:cafe::84) by BL0PR02CA0136.outlook.office365.com
 (2603:10b6:208:35::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48 via Frontend
 Transport; Fri, 10 May 2024 02:38:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 02:38:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 9 May
 2024 21:38:03 -0500
Date: Thu, 9 May 2024 21:34:54 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: Re: [PATCH v15 00/20] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <20240510023454.63dwkx3pcbrplv74@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <CABgObfbvAU-hGzO59x1ucjOGqx0Yor0HovQBNBR2sysngmk4=Q@mail.gmail.com>
 <20240507181424.agek6zqdv6mu2eq5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240507181424.agek6zqdv6mu2eq5@amd.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|MN0PR12MB6365:EE_
X-MS-Office365-Filtering-Correlation-Id: 5983e30e-4a48-41b0-408f-08dc709a3891
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|7416005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXF2MjdiS0VsUXA5T3FEc3FxMTAzTGR5cmFMOThVUjBxYkhqTC9EYnY4aFZS?=
 =?utf-8?B?R0w2bjJsWi9VZU5vNU9NWHJRMXZuUDlFTWhOUS8wQmxpSWZ6MkE4K1JMVFM5?=
 =?utf-8?B?RHdzZklzZE4xSmNqM2lGc3pmUytJUUZ4akw2eVZsWEtwYmowK0tVazZ3UmVj?=
 =?utf-8?B?MFllZ0x1MkY5NE9DeFNDV2VzaHlsdnh4YmNDYzNrcnQyWWJVelhBWWJLemkr?=
 =?utf-8?B?VitSUEtrSjBLdWxML1B4NlJQa3ZaODBCUzJLYjYrWjNBVFc4eUE0aExVOFpL?=
 =?utf-8?B?bFp6czYwdkFyOFNGR2VFSWoxTUFpN3FZcVB1YzNDRDNiR1ZqZi9jWE80RWxP?=
 =?utf-8?B?d29tems0SGg1MHJLMU5tb2RENDVUM2REZ1NhSWFTMmVoUk1nSjBlU2ZxR3ZM?=
 =?utf-8?B?VWNMWWRtMEFXbUV4Tm1FMEcwWUhOUkdWUEZMUVVFYlpVMm51STNPb3NMeHJv?=
 =?utf-8?B?a0dpVWJnVE5ZRTAxOWxES2xZaGo5TjRZc2xpTjMvU3lncEpwbVdJVmMwUWk3?=
 =?utf-8?B?a3haTyt3TjBWam5oRE9qS0dWWVcvSDZHRkFsQlB2aUZ0ZDhTWCtTdWNjdmQ1?=
 =?utf-8?B?QXg2VGNHcFdpVHpZOXNURlluYUdvaGNrNzVOUUNsb3VzVEdteUliT1dBbjZZ?=
 =?utf-8?B?N1Uxek9md2cwZXFjdlh5V0tSem8xQmluTDlkRGxKZWpQSGl1UE92THBPVTli?=
 =?utf-8?B?VTB5aXY1bEdhbDF2cTQvSEpNSW83ZXJuVW9wOE1SZE4zaHBUTkZUM3ZKRWRH?=
 =?utf-8?B?bWp6UndyU0hMcURyM0ZZc0sxYzRQaitlaVdlVFdLMXZjM0Q0d3NkTklBNUI5?=
 =?utf-8?B?Y3RLV2tQR0ZacHdJeWpRRE51Q2dBV0NIanB2VlBieGtjekREMUYrTG51cUgw?=
 =?utf-8?B?c2oyeTdCTStaV25lYlJyd1Q5cE5sVDJlb1hWRC9NUjQ1YzdBRm1iTVlGNWhm?=
 =?utf-8?B?c0FYZWM0N0N5ZGtYcFMzVVFiZ1g3VHdZVHlHTEEwaDA0S1lDVGRxVDhvZXBI?=
 =?utf-8?B?STlwL20xdzZOS1RjMDdMakRRWGxVQm9kdUhVWjJIaHJtdndJcnZEK05tWXpq?=
 =?utf-8?B?TWZhSTZNU3RZYWc3V2VoRTZOVVRYVHRkQ1dQRlN5SVVDdmtjNWdXcnNUeElh?=
 =?utf-8?B?eFlLSGxwME44V1ZaWkVLdXhwM2daOHhiNWNBMmMyUHhWUTdOa1U3VC8ra2Mx?=
 =?utf-8?B?VEtZakV1V3E3V3ZWYmNLOHJkbXcrVnBlMUkvQTBQczJPNHZQcDhkSUdVVloz?=
 =?utf-8?B?dUNPVDllT0NaYTJKV3YxUDJubDk2ZDczSkt4alQycXJ0TmphcVgzaThIMGFz?=
 =?utf-8?B?SDRXa3Z2dStOcDlDWDdWTDdLQlNTRThJRU1JcjhGUVc2N2JidVhhTkxLU0lM?=
 =?utf-8?B?N1lHUDdPSnFOdzZzVS83aytlRTdnbE5QT1duRFhtR3BFTG52Q0FXQnhKeTFF?=
 =?utf-8?B?TkNUWGdIUE5kVUtPVGNHZkhZWkpqZzY4QXB2OXRFUllTZ1RQbzZzY1pndUVO?=
 =?utf-8?B?d0pXSlM4L1hkeVllQVZoS3QyRjFCNWdIODU4aHduOUFZWm8xZnB2TloydXJ1?=
 =?utf-8?B?RVhHaTVjY2RhNkVjcWNuY0V0bVNISU5ZZ3VGRVAzL2RwQTZRbnRibDhpRVRO?=
 =?utf-8?B?ZTNtL0FPODBqbmJoQVZvYWNkMGlSKzA3MzhuWExiTGRZS25NdnlWRjM1Wnl2?=
 =?utf-8?B?bnZmQzUwcE1ZMnUvbUtCdWZYR2hOMG15NU1teXhjMmxtczFRY1dmOFArUHJ3?=
 =?utf-8?B?UDJsMytnanZtREFwREVsTXZsM0NDcVI0K0NIWklrMVZCNjFtTjV6RXZHWi8w?=
 =?utf-8?B?U0JUZFJWemlqWEtEWU8rQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 02:38:05.5616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5983e30e-4a48-41b0-408f-08dc709a3891
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6365

On Tue, May 07, 2024 at 01:14:24PM -0500, Michael Roth wrote:
> On Tue, May 07, 2024 at 08:04:50PM +0200, Paolo Bonzini wrote:
> > On Wed, May 1, 2024 at 11:03 AM Michael Roth <michael.roth@amd.com> wrote:
> > >
> > > This patchset is also available at:
> > >
> > >   https://github.com/amdese/linux/commits/snp-host-v15
> > >
> > > and is based on top of the series:
> > >
> > >   "Add SEV-ES hypervisor support for GHCB protocol version 2"
> > >   https://lore.kernel.org/kvm/20240501071048.2208265-1-michael.roth@amd.com/
> > >   https://github.com/amdese/linux/commits/sev-init2-ghcb-v1
> > >
> > > which in turn is based on commit 20cc50a0410f (just before v14 SNP patches):
> > >
> > >   https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue
> > 
> > I have mostly reviewed this, with the exception of the
> > snp_begin/complete_psc parts.
> 
> Thanks Paolo. We actually recently uncovered some issues with
> snp_begin/complete_psc using some internal kvm-unit-tests that exercise
> some edge cases, so I would hold off on reviewing that. Will send a
> fix-up patch today after a bit more testing.

In the process if adding some additional units tests we ran uncovered a
couple of other issues in addition to the fixups for PSC:

  [PATCH 21/20] KVM: MMU: Disable fast path for private memslots

    addresses an issue with fast_page_fault() handling that can lead to
    KVM_EXIT_MEMORY_FAULT cases being treated as spurious #NPFs which
    results in the guest spinning forever. This seems like it could be
    generally needed for both SNP/TDX, and would likely replace the need
    for this patch from the TDX series:
    
      KVM: x86/mmu: Disallow fast page fault on private GPA
      https://lore.kernel.org/lkml/91c797997b57056224571e22362321a23947172f.1705965635.git.isaku.yamahata@intel.com/

    This is a standalone patch and not really a fixup for anything

  [PATCH 22/20] KVM: SEV: Fix return code interpretation for RMP nested page faults

    addresses an issue where the return code of kvm_mmu_page_fault() was
    being misinterpreted, leading to sev_handle_rmp_fault() being called
    unecessarily in some cases. Interestingly, because
    sev_handle_rmp_fault() results in zapping sPTEs after PSMASH'ing them,
    this bug was hiding the issue addressed in the above PATCH 21 by
    forcing the fast path to get skipped. This can be squashed into:

      KVM: SEV: Add support to handle RMP nested page faults

  [PATCH 23/20] KVM: SEV: Fix PSC handling for SMASH/UNSMASH and partial update ops 

    fixes up the GHCB PSC handling code to address a number of situations
    that aren't triggered by normal SNP guests, but are allowed by the
    GHCB spec and could become issues with future/other guest
    implementations. This can be squashed into:

      KVM: SEV: Add support to handle Page State Change VMGEXIT

I've sent them all as a response to this series, but have them available
here applied on top of the your current kvm/queue (commit 15889fca49df):

  https://github.com/mdroth/linux/commits/snp-host-v15c2-unsquashed
  (the patch at the top can be ignored, it's only for testing 2MB gmem
   backing pages)

I've also put together a branch with the patches already squashed in
(except for "KVM: MMU: Disable fast path for private memslots" which is
a standalone patch that is likely applicable to both TDX and SNP, so
I've simply moved it to the beginning of the SNP series)

  https://github.com/mdroth/linux/commits/snp-host-v15c2

Sorry for the late fixes. Let me know if you want me to submit any of
these by some other means.

-Mike


> 
> 
> -Mike
> 
> > 
> > Paolo
> > 
> > 
> > > Patch Layout
> > > ------------
> > >
> > > 01-02: These patches revert+replace the existing .gmem_validate_fault hook
> > >        with a similar .private_max_mapping_level as suggested by Sean[1]
> > >
> > > 03-04: These patches add some basic infrastructure and introduces a new
> > >        KVM_X86_SNP_VM vm_type to handle differences verses the existing
> > >        KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
> > >
> > > 05-07: These implement the KVM API to handle the creation of a
> > >        cryptographic launch context, encrypt/measure the initial image
> > >        into guest memory, and finalize it before launching it.
> > >
> > > 08-12: These implement handling for various guest-generated events such
> > >        as page state changes, onlining of additional vCPUs, etc.
> > >
> > > 13-16: These implement the gmem/mmu hooks needed to prepare gmem-allocated
> > >        pages before mapping them into guest private memory ranges as
> > >        well as cleaning them up prior to returning them to the host for
> > >        use as normal memory. Because this supplants certain activities
> > >        like issued WBINVDs during KVM MMU invalidations, there's also
> > >        a patch to avoid duplicating that work to avoid unecessary
> > >        overhead.
> > >
> > > 17:    With all the core support in place, the patch adds a kvm_amd module
> > >        parameter to enable SNP support.
> > >
> > > 18-20: These patches all deal with the servicing of guest requests to handle
> > >        things like attestation, as well as some related host-management
> > >        interfaces.
> > >
> > > [1] https://lore.kernel.org/kvm/ZimnngU7hn7sKoSc@google.com/#t
> > >
> > >
> > > Testing
> > > -------
> > >
> > > For testing this via QEMU, use the following tree:
> > >
> > >   https://github.com/amdese/qemu/commits/snp-v4-wip3c
> > >
> > > A patched OVMF is also needed due to upstream KVM no longer supporting MMIO
> > > ranges that are mapped as private. It is recommended you build the AmdSevX64
> > > variant as it provides the kernel-hashing support present in this series:
> > >
> > >   https://github.com/amdese/ovmf/commits/apic-mmio-fix1d
> > >
> > > A basic command-line invocation for SNP would be:
> > >
> > >  qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
> > >   -machine q35,confidential-guest-support=sev0,memory-backend=ram1
> > >   -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
> > >   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=
> > >   -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd
> > >
> > > With kernel-hashing and certificate data supplied:
> > >
> > >  qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
> > >   -machine q35,confidential-guest-support=sev0,memory-backend=ram1
> > >   -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
> > >   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,certs-path=/home/mroth/cert.blob,kernel-hashes=on
> > >   -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd
> > >   -kernel /boot/vmlinuz-$ver
> > >   -initrd /boot/initrd.img-$ver
> > >   -append "root=UUID=d72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=ttyS0,115200n8"
> > >
> > > With standard X64 OVMF package with separate image for persistent NVRAM:
> > >
> > >  qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
> > >   -machine q35,confidential-guest-support=sev0,memory-backend=ram1
> > >   -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
> > >   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=
> > >   -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d.fd
> > >   -drive if=pflash,format=raw,unit=0,file=OVMF_VARS-upstream-20240410-apic-mmio-fix1d.fd,readonly=off
> > >
> > >
> > > Known issues / TODOs
> > > --------------------
> > >
> > >  * Base tree in some cases reports "Unpatched return thunk in use. This should
> > >    not happen!" the first time it runs an SVM/SEV/SNP guests. This a recent
> > >    regression upstream and unrelated to this series:
> > >
> > >      https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobwfwyVxUqMq2kWeka3N4tXA@mail.gmail.com/T/
> > >
> > >  * 2MB hugepage support has been dropped pending discussion on how we plan to
> > >    re-enable it in gmem.
> > >
> > >  * Host kexec should work, but there is a known issue with host kdump support
> > >    while SNP guests are running that will be addressed as a follow-up.
> > >
> > >  * SNP kselftests are currently a WIP and will be included as part of SNP
> > >    upstreaming efforts in the near-term.
> > >
> > >
> > > SEV-SNP Overview
> > > ----------------
> > >
> > > This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
> > > changes required to add KVM support for SEV-SNP. This series builds upon
> > > SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
> > > initialization support, which is now in linux-next.
> > >
> > > While series provides the basic building blocks to support booting the
> > > SEV-SNP VMs, it does not cover all the security enhancement introduced by
> > > the SEV-SNP such as interrupt protection, which will added in the future.
> > >
> > > With SNP, when pages are marked as guest-owned in the RMP table, they are
> > > assigned to a specific guest/ASID, as well as a specific GFN with in the
> > > guest. Any attempts to map it in the RMP table to a different guest/ASID,
> > > or a different GFN within a guest/ASID, will result in an RMP nested page
> > > fault.
> > >
> > > Prior to accessing a guest-owned page, the guest must validate it with a
> > > special PVALIDATE instruction which will set a special bit in the RMP table
> > > for the guest. This is the only way to set the validated bit outside of the
> > > initial pre-encrypted guest payload/image; any attempts outside the guest to
> > > modify the RMP entry from that point forward will result in the validated
> > > bit being cleared, at which point the guest will trigger an exception if it
> > > attempts to access that page so it can be made aware of possible tampering.
> > >
> > > One exception to this is the initial guest payload, which is pre-validated
> > > by the firmware prior to launching. The guest can use Guest Message requests
> > > to fetch an attestation report which will include the measurement of the
> > > initial image so that the guest can verify it was booted with the expected
> > > image/environment.
> > >
> > > After boot, guests can use Page State Change requests to switch pages
> > > between shared/hypervisor-owned and private/guest-owned to share data for
> > > things like DMA, virtio buffers, and other GHCB requests.
> > >
> > > In this implementation of SEV-SNP, private guest memory is managed by a new
> > > kernel framework called guest_memfd (gmem). With gmem, a new
> > > KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
> > > MMU whether a particular GFN should be backed by shared (normal) memory or
> > > private (gmem-allocated) memory. To tie into this, Page State Change
> > > requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
> > > then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
> > > private/shared state in the KVM MMU.
> > >
> > > The gmem / KVM MMU hooks implemented in this series will then update the RMP
> > > table entries for the backing PFNs to set them to guest-owned/private when
> > > mapping private pages into the guest via KVM MMU, or use the normal KVM MMU
> > > handling in the case of shared pages where the corresponding RMP table
> > > entries are left in the default shared/hypervisor-owned state.
> > >
> > > Feedback/review is very much appreciated!
> > >
> > > -Mike
> > >
> > >
> > > Changes since v14:
> > >
> > >  * switch to vendor-agnostic KVM_HC_MAP_GPA_RANGE exit for forwarding
> > >    page-state change requests to userspace instead of an SNP-specific exit
> > >    (Sean)
> > >  * drop SNP_PAUSE_ATTESTATION/SNP_RESUME_ATTESTATION interfaces, instead
> > >    add handling in KVM_EXIT_VMGEXIT so that VMMs can implement their own
> > >    mechanisms for keeping userspace-supplied certificates in-sync with
> > >    firmware's TCB/endorsement key (Sean)
> > >  * carve out SEV-ES-specific handling for GHCB protocol 2, add control of
> > >    the protocol version, and post as a separate prereq patchset (Sean)
> > >  * use more consistent error-handling in snp_launch_{start,update,finish},
> > >    simplify logic based on review comments (Sean)
> > >  * rename .gmem_validate_fault to .private_max_mapping_level and rework
> > >    logic based on review suggestions (Sean)
> > >  * reduce number of pr_debug()'s in series, avoid multiple WARN's in
> > >    succession (Sean)
> > >  * improve documentation and comments throughout
> > >
> > > Changes since v13:
> > >
> > >  * rebase to new kvm-coco-queue and wire up to PFERR_PRIVATE_ACCESS (Paolo)
> > >  * handle setting kvm->arch.has_private_mem in same location as
> > >    kvm->arch.has_protected_state (Paolo)
> > >  * add flags and additional padding fields to
> > >    snp_launch{start,update,finish} APIs to address alignment and
> > >    expandability (Paolo)
> > >  * update snp_launch_update() to update input struct values to reflect
> > >    current progress of command in situations where mulitple calls are
> > >    needed (Paolo)
> > >  * update snp_launch_update() to avoid copying/accessing 'src' parameter
> > >    when dealing with zero pages. (Paolo)
> > >  * update snp_launch_update() to use u64 as length input parameter instead
> > >    of u32 and adjust padding accordingly
> > >  * modify ordering of SNP_POLICY_MASK_* definitions to be consistent with
> > >    bit order of corresponding flags
> > >  * let firmware handle enforcement of policy bits corresponding to
> > >    user-specified minimum API version
> > >  * add missing "0x" prefixs in pr_debug()'s for snp_launch_start()
> > >  * fix handling of VMSAs during in-place migration (Paolo)
> > >
> > > Changes since v12:
> > >
> > >  * rebased to latest kvm-coco-queue branch (commit 4d2deb62185f)
> > >  * add more input validation for SNP_LAUNCH_START, especially for handling
> > >    things like MBO/MBZ policy bits, and API major/minor minimums. (Paolo)
> > >  * block SNP KVM instances from being able to run legacy SEV commands (Paolo)
> > >  * don't attempt to measure VMSA for vcpu 0/BSP before the others, let
> > >    userspace deal with the ordering just like with SEV-ES (Paolo)
> > >  * fix up docs for SNP_LAUNCH_FINISH (Paolo)
> > >  * introduce svm->sev_es.snp_has_guest_vmsa flag to better distinguish
> > >    handling for guest-mapped vs non-guest-mapped VMSAs, rename
> > >    'snp_ap_create' flag to 'snp_ap_waiting_for_reset' (Paolo)
> > >  * drop "KVM: SEV: Use a VMSA physical address variable for populating VMCB"
> > >    as it is no longer needed due to above VMSA rework
> > >  * replace pr_debug_ratelimited() messages for RMP #NPFs with a single trace
> > >    event
> > >  * handle transient PSMASH_FAIL_INUSE return codes in kvm_gmem_invalidate(),
> > >    switch to WARN_ON*()'s to indicate remaining error cases are not expected
> > >    and should not be seen in practice. (Paolo)
> > >  * add a cond_resched() in kvm_gmem_invalidate() to avoid soft lock-ups when
> > >    cleaning up large guest memory ranges.
> > >  * rename VLEK_REQUIRED to VCEK_DISABLE. it's be more applicable if another
> > >    key type ever gets added.
> > >  * don't allow attestation to be paused while an attestation request is
> > >    being processed by firmware (Tom)
> > >  * add missing Documentation entry for SNP_VLEK_LOAD
> > >  * collect Reviewed-by's from Paolo and Tom
> > >
> > >
> > > ----------------------------------------------------------------
> > > Ashish Kalra (1):
> > >       KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
> > >
> > > Brijesh Singh (8):
> > >       KVM: SEV: Add initial SEV-SNP support
> > >       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
> > >       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
> > >       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
> > >       KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
> > >       KVM: SEV: Add support to handle RMP nested page faults
> > >       KVM: SVM: Add module parameter to enable SEV-SNP
> > >       KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
> > >
> > > Michael Roth (10):
> > >       Revert "KVM: x86: Add gmem hook for determining max NPT mapping level"
> > >       KVM: x86: Add hook for determining max NPT mapping level
> > >       KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
> > >       KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
> > >       KVM: SEV: Add support to handle Page State Change VMGEXIT
> > >       KVM: SEV: Implement gmem hook for initializing private pages
> > >       KVM: SEV: Implement gmem hook for invalidating private pages
> > >       KVM: x86: Implement hook for determining max NPT mapping level
> > >       KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
> > >       crypto: ccp: Add the SNP_VLEK_LOAD command
> > >
> > > Tom Lendacky (1):
> > >       KVM: SEV: Support SEV-SNP AP Creation NAE event
> > >
> > >  Documentation/virt/coco/sev-guest.rst              |   19 +
> > >  Documentation/virt/kvm/api.rst                     |   87 ++
> > >  .../virt/kvm/x86/amd-memory-encryption.rst         |  110 +-
> > >  arch/x86/include/asm/kvm-x86-ops.h                 |    2 +-
> > >  arch/x86/include/asm/kvm_host.h                    |    5 +-
> > >  arch/x86/include/asm/sev-common.h                  |   25 +
> > >  arch/x86/include/asm/sev.h                         |    3 +
> > >  arch/x86/include/asm/svm.h                         |    9 +-
> > >  arch/x86/include/uapi/asm/kvm.h                    |   48 +
> > >  arch/x86/kvm/Kconfig                               |    3 +
> > >  arch/x86/kvm/mmu.h                                 |    2 -
> > >  arch/x86/kvm/mmu/mmu.c                             |   27 +-
> > >  arch/x86/kvm/svm/sev.c                             | 1538 +++++++++++++++++++-
> > >  arch/x86/kvm/svm/svm.c                             |   44 +-
> > >  arch/x86/kvm/svm/svm.h                             |   52 +
> > >  arch/x86/kvm/trace.h                               |   31 +
> > >  arch/x86/kvm/x86.c                                 |   17 +
> > >  drivers/crypto/ccp/sev-dev.c                       |   36 +
> > >  include/linux/psp-sev.h                            |    4 +-
> > >  include/uapi/linux/kvm.h                           |   23 +
> > >  include/uapi/linux/psp-sev.h                       |   27 +
> > >  include/uapi/linux/sev-guest.h                     |    9 +
> > >  virt/kvm/guest_memfd.c                             |    4 +-
> > >  23 files changed, 2081 insertions(+), 44 deletions(-)
> > >
> > 
> > 
> 

