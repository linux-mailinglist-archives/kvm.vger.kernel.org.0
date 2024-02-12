Return-Path: <kvm+bounces-8563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A7398519F8
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 17:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE5571C21CFD
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 16:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3723D555;
	Mon, 12 Feb 2024 16:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G5WmLzJu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D653C699;
	Mon, 12 Feb 2024 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707756521; cv=fail; b=P1HCSJGy5wHPpgoTre8M2aWEDP5RXW0MTpgEDu2qrzf8P9XjoTfex1f/zyzQFJxQYfKhTltLDM+swVXeQYaL42tLd6dTvW3LV7xqS2gScnOBW/GSPYsHEV68FFQb2dBiklIsXFaAhvjYYWsCDpy30/aY/Ac2ZgSKpbTIqSD547U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707756521; c=relaxed/simple;
	bh=l7OAEpOSeipd+I7UPuUvvIEjro6bxpmH/wjc3SmpjXw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=En6Mb3ib15Zx8CvY/gu8LhlfXPT6/bpMkQXavw3++Yvk+fn2pimotW6uErUOhp9myiRS6G2EpZgUCWCffO9p3c3uT+uLAZQJ4iaAFwKeAGgdTHNvQYquwJkYT8XAojQoSSFqHLa3kMiBnHhqETiHDuAu3EampDEzqjracvkJIG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G5WmLzJu; arc=fail smtp.client-ip=40.107.94.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUddeyoPkPO/20q+ZoUGIk0dN1732sIBPvfUUKVowQejtn9HjJWFpDEU8P4MUC6fX0OWhDHTOOwqkbhcZuZ01LvYQuROa9NR2D3Wg0w7sGYuRUQGMxHNdQu93FxvO7F5YhMncX3W4EahP0v8pNmqNBQSeLug2v5uNb6fE1UjedGA7dwRgT7HYJ6LzPvX6fhBMtCVFMyIQF+a7VMK/Hxe+eIX1SwmNxLfbGU5LjZqnkNWH/JxYUDU5UNwxEBeSE3pc5aLBQQTXNFXIWcrGWDa56tEgtRjNRRj1vUKxya9C+n6+1t9Kfmdi0xcjsrmrc1Nz37cgls0dMp03k6vPSzcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y6fuWCc0jG1unLA95FAG0wKoLIczJavaPCUrOzohaZM=;
 b=GBvOgtU14V01brxDBkGCKeG8EefQaeWZrucygvHQIIxwHDWNU+XI6ObJGZ/6cXtqP/Sx40ob//OY2ZlXz5aT173QFWHiGXFByEE4MNz6DolIgwGeX85ohNosY3396OnKQAbCq0FWTzvZ4TNRprWHRSffM3I0oX6SmT2Imw2DSltBwhMiMSPL8OI+LTomcN/wxhmsu3x1A3dR7Da1ylJnq3qTXN2w+NwVKz/WzKBjkuaO3r/1w66rTMM7aSOJfWx7ZtANVjr7lReDd19pzg6eqKvS2AAy/Edg1qaWitAkz3AD/igdNH71rcrgtYPYiOJL/FY6mKijJoyESFWZe7rOAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6fuWCc0jG1unLA95FAG0wKoLIczJavaPCUrOzohaZM=;
 b=G5WmLzJuRtvFKYpAg73RvkuA6OqpKO9HOeaQCHAyGcwCuPysD8s0BqguqVSPA+FtDNygsrgVmRuMNpt7PP1CkLFXwPqAPDmWirq6am7tUL2qBm8vGKabpTitQDaeG6rN/VOufK+n41Oo3tjRxfrxdY/Zjw2str5+BqeHRgFW+OU=
Received: from SJ0PR03CA0383.namprd03.prod.outlook.com (2603:10b6:a03:3a1::28)
 by DM4PR12MB6253.namprd12.prod.outlook.com (2603:10b6:8:a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.24; Mon, 12 Feb
 2024 16:48:36 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::21) by SJ0PR03CA0383.outlook.office365.com
 (2603:10b6:a03:3a1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.38 via Frontend
 Transport; Mon, 12 Feb 2024 16:48:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7249.19 via Frontend Transport; Mon, 12 Feb 2024 16:48:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 12 Feb
 2024 10:48:35 -0600
Date: Mon, 12 Feb 2024 10:47:59 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: Re: [PATCH v11 09/35] KVM: x86: Determine shared/private faults
 based on vm_type
Message-ID: <20240212164759.35cb7gds4p2inprg@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
 <20231230172351.574091-10-michael.roth@amd.com>
 <CABgObfanrHTL429Cr8tcMGqs-Ov+6LWeQbzghvjQiGu9tz0EUA@mail.gmail.com>
 <ZcpG6Ul4_8xAsnuy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZcpG6Ul4_8xAsnuy@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|DM4PR12MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: 33846d7f-4fef-4026-5e57-08dc2bea7510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yrP/NggfU4d85NfP6WNH+aZMKyPZvL/Mm8TB3QCQiq2EaCKmRbdIrmvq7z9a29jG1yMaTOINWI6+SY+qgq9wU/6fvM22J6U4dYbtNML2wvqpi/fo7UC46fScodjFwztqAqCDc8edlefbfEkKAH4vIPJpL2HZ4ubey6KfiOLGlyFCobuDma46bgA56eo8eH7OZv1Kvdmrr3GIhXbrYE98j47TfvVvi8mjRhAeRDpivXteVPoPCPcYYPkdr/s9EEec/J01wfE2W5LmD9qnzlV8yLjeGF9kkWKokRfYc79VBHIR9ODBWm0oP4kgsE2pIyxSIY5i+PqI0scuSxWD8SJSUyppL6kag99pilkg+frF3TOh7yW0JcHSo6gNJJBcVzpCyj5BoiBPa4j7VuOEr1idycYeO/EVgkxj5LJIIvVUsSsqIVVK1tbXtgrG7JM0oiQWXDO+l1KrPjV3t/j4r/37WLmcBHWNSm2kHlXjNDgHPY+bIdJid7G6neNpvM/KwPQ65CUDV+30RaS7z2F4+i8k5QMalD5sHnQQoGDVrDEEbM1su4wrvTZCslpQZVxd2N1UE09pQWmv5Qnyhdp3tE+ZDGv+qJUktUsMOtV1dcQaZEVObYi2YNQXRzUyapukAxFi
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(82310400011)(40470700004)(36840700001)(46966006)(26005)(83380400001)(426003)(336012)(41300700001)(1076003)(2616005)(16526019)(44832011)(8676002)(4326008)(8936002)(478600001)(82740400003)(356005)(966005)(81166007)(70206006)(70586007)(36756003)(316002)(6916009)(86362001)(54906003)(6666004)(53546011)(7416002)(2906002)(7406005)(5660300002)(66899024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2024 16:48:36.4866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33846d7f-4fef-4026-5e57-08dc2bea7510
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6253

On Mon, Feb 12, 2024 at 08:27:21AM -0800, Sean Christopherson wrote:
> On Mon, Feb 12, 2024, Paolo Bonzini wrote:
> > On Sat, Dec 30, 2023 at 6:24 PM Michael Roth <michael.roth@amd.com> wrote:
> > >
> > > For KVM_X86_SNP_VM, only the PFERR_GUEST_ENC_MASK flag is needed to
> > > determine with an #NPF is due to a private/shared access by the guest.
> > > Implement that handling here. Also add handling needed to deal with
> > > SNP guests which in some cases will make MMIO accesses with the
> > > encryption bit.
> > >
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c          | 12 ++++++++++--
> > >  arch/x86/kvm/mmu/mmu_internal.h | 20 +++++++++++++++++++-
> > >  2 files changed, 29 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index d3fbfe0686a0..61213f6648a1 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4331,6 +4331,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> > >  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > >  {
> > >         struct kvm_memory_slot *slot = fault->slot;
> > > +       bool private_fault = fault->is_private;
> > 
> > I think it's nicer to just make the fault !is_private in
> > kvm_mmu_do_page_fault().
> 
> Yeah.  I'm starting to recall more of this discussion.  This is one of the reasons
> I suggested/requested stuffing the error code to piggy-back the new SNP bit; doing
> so allows is_private to be computed from the get-go without needing any vendor
> specific hooks.

Makes sense to me. Based on your suggestion here:

  https://lore.kernel.org/kvm/ZcUO5sFEAIH68JIA@google.com/

I was planning to drop this patch and adopt the TDX implementation:

  https://github.com/intel/tdx/commit/3717a903ef453aa7b62e7eb65f230566b7f158d4

-Mike

