Return-Path: <kvm+bounces-8565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A62D851AA7
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 18:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8ED181F27F74
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 17:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C11B3DBBC;
	Mon, 12 Feb 2024 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qhdu/GRQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74D53CF68;
	Mon, 12 Feb 2024 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757438; cv=fail; b=Ks5h0N1lifKLNBWwrsO3ZWMKJ7HHr1gtcVjj/XE9GYKy883CCo55ilv1h1t37o/hci3ZBnZ/Odga1YgOUHoaCJQ8PAfyEwM1Kel4vLTCKDQpSHh5PQvu5VJwDsffxv1UuVIqfmFs5jwkvtFc3zAQsJL3OSuZ8yVAZGt82dug3E0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757438; c=relaxed/simple;
	bh=NSW0eHxCWaIUBwhJXsuB0WtWNj1Wt43COFcmn7vMZ9A=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=am8i5Ej8sTy9fFN6WZd8/Io3ggH/SqMZG1ZQk2KyilHcTMbnJ+YYW2TKEanXPiWVvKG5xOGfwEjSA03Rz+260lg6qk+WKcVNN7hIcOrb2eYBxOU+PO4CYgyCBM5bhK8tLCG7/r5juxUIX4QZVpBAEf8+576Nt6ls/xBGqzIQL44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qhdu/GRQ; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AizATzjVBhJQfsbfWiBjMX3VXrLOmgecAwjVpT73DmritP4ItaXq5JwUKVZ65lmTdnWEmap+x0vqhOxFPJyzClEcVMF4RXETlIECjXxTn9X7e26rnMxrlL85/JwcU0rbZlPZEQHYOwHZw0htb9ZubiOQn0GwiJOEQsVDO8OSkr3a0eXGzHJm3Pe8MQjXsm3+0Ts2BvCHh87oDn0SfPre1fFhJWGeJo7gJMY7HrX4K6qozZyJ1OdfAUUAargoFyPSnS/3xzrsn0dmUOQ6mKSen/u0hKEgvxIgbtAGFrwihnK1zUTPy2X9YGXXHK6zUPKIoEzxco69fVQ7QtQGQkGtEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amNcMs5Lgijt4IOF8Lqf21S6M19aiimiHeLgME974Ug=;
 b=U66ZLrPr92NO2LFzX3OgLgQn+RL6BNNcyGP7KZVq8UqtZFtVLhMJEvNgaeBmwaw4yJDX0tEv3ElpxwgKe9c8vLRc1wDxJ2avpGHM2QUes+/PjcFbC8u8Jk57jk8YAKAHuStgYRtTWMxGYczNJP0hT+4Vq3LH18DeUyTPovIvYiomTIdw9BiTBIkr9QA7VK9+HYwZH/OVwjUxeCe9ci1B7dh1A24ECGgig/R3UDu+LDhrasAql/7uwkU9XKAQ21rk7MYhtl6k85OhOHn9/Im2r44k+6TM2Ual4XCcia3WV/Ds9T6jvy/U5w9WZruwTPuAl8Gcbp8tRc50TTlpmwaJFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amNcMs5Lgijt4IOF8Lqf21S6M19aiimiHeLgME974Ug=;
 b=Qhdu/GRQQrV7sdzQV/1NB1C0yInpPa/YfWGJSSxEtWllq/VtcTe7UrtTTcLvdHpGlhXahf6WSbQkHyG37fEVXvJxtQfdcmQrAxs55KauYzV7JF/CxUbPXyvPBlU/6QiKx/38zsfd9lh6a47n5y8KoGePFlJireCT0SltLr1evm0=
Received: from SA0PR11CA0201.namprd11.prod.outlook.com (2603:10b6:806:1bc::26)
 by CYXPR12MB9386.namprd12.prod.outlook.com (2603:10b6:930:de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Mon, 12 Feb
 2024 17:03:53 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:1bc:cafe::23) by SA0PR11CA0201.outlook.office365.com
 (2603:10b6:806:1bc::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.38 via Frontend
 Transport; Mon, 12 Feb 2024 17:03:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7249.19 via Frontend Transport; Mon, 12 Feb 2024 17:03:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 12 Feb
 2024 11:03:51 -0600
Date: Mon, 12 Feb 2024 11:03:38 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: Re: [PATCH v11 30/35] KVM: x86: Add gmem hook for determining max
 NPT mapping level
Message-ID: <20240212170338.7rp2mutmg7hbtxr5@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
 <20231230172351.574091-31-michael.roth@amd.com>
 <CABgObfYX74NwYPV8dHGfLjBBp5JMGsN5OSQaJrgHQTghVdrD1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYX74NwYPV8dHGfLjBBp5JMGsN5OSQaJrgHQTghVdrD1g@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|CYXPR12MB9386:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d53b2b-f6f4-4ac3-96d1-08dc2bec972f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pTdP4DUoDTkWCldh544oNPWDyVX19cFved0gdVxLxeYdTfRWHxAExN6OWsoMMaH8dcYQV+MZvUyKufcdcOADNawx8bmkrxnvBz0pZIJX6hJQMI1rreErP47IeIB6p+SYXrEfOzCa/w7HjTWJKv6NabLc8ViTKCZUY77K4cXhzFDwum+EZ8BoI4I2zvkDqYVXNs78J1YHO4UwX8ireBh69Lg1pKvAr+qd2NMwswMwRVTRXDQeQ0L8ttcGeFzkJU98UTVw53KLDqE6rA6PZoqTyu7nSWe6Sefa/ItKkENT5eKPo2x52KTZOIhV7gyNRHWHBuS55Ch76wnjQPgqDNo/4ioxhJuG1wLv4Ig1GPfi+CFUb0NOLI5raQIyt1YUkiqd2k6LWkvaNKahSLl+7nmu64gKeeDSNB5bexCxxOwsAxTl6mXLWnR+TJAD2svmrAXwpbsg/DzxFQAIX3qM/+NS0w9CHld6vWuLhzVX2g/UySzTLfTpxjYELMveyHf85aSgHu5Y7Y8dqvRIK2woN2Zd9JzaIREZsP8hLjHXcNTd9KXW9r2e0wdyGRoY2c+5Y4QqwiUeP/lotEA377DI1BvLcrSOOKVxCZkeKFWrspAygGA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(1800799012)(186009)(82310400011)(451199024)(64100799003)(36840700001)(40470700004)(46966006)(4326008)(44832011)(8676002)(41300700001)(8936002)(2906002)(5660300002)(7416002)(7406005)(356005)(81166007)(83380400001)(86362001)(36756003)(26005)(1076003)(16526019)(2616005)(70586007)(70206006)(426003)(53546011)(6666004)(336012)(82740400003)(316002)(54906003)(6916009)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2024 17:03:52.7741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d53b2b-f6f4-4ac3-96d1-08dc2bec972f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9386

On Mon, Feb 12, 2024 at 11:50:26AM +0100, Paolo Bonzini wrote:
> On Sat, Dec 30, 2023 at 6:32 PM Michael Roth <michael.roth@amd.com> wrote:
> >         int max_order, r;
> > +       u8 max_level;
> >
> >         if (!kvm_slot_can_be_private(fault->slot)) {
> >                 kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > @@ -4321,8 +4322,15 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >                 return r;
> >         }
> >
> > -       fault->max_level = min(kvm_max_level_for_order(max_order),
> > -                              fault->max_level);
> > +       max_level = kvm_max_level_for_order(max_order);
> > +       r = static_call(kvm_x86_gmem_max_level)(vcpu->kvm, fault->pfn,
> > +                                               fault->gfn, &max_level);
> 
> Might as well pass &fault->max_level directly to the callback, with no
> change to the vendor-specific code.
> 
> I'll include the MMU part in a generic series to be the base for both
> Intel TDX and AMD SEV-SNP, and will do that change.

Sounds good. I'm not sure why I did it that way originally, but what
you're suggesting does seem like it should be equivalent.

-Mike

> 
> Paolo
> 
> > +       if (r) {
> > +               kvm_release_pfn_clean(fault->pfn);
> > +               return r;
> > +       }
> > +
> > +       fault->max_level = min(max_level, fault->max_level);
> >         fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> >
> >         return RET_PF_CONTINUE;
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 85f63b6842b6..5eb836b73131 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -4315,3 +4315,30 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
> >                 pfn += use_2m_update ? PTRS_PER_PMD : 1;
> >         }
> >  }
> > +
> > +int sev_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level)
> > +{
> > +       int level, rc;
> > +       bool assigned;
> > +
> > +       if (!sev_snp_guest(kvm))
> > +               return 0;
> > +
> > +       rc = snp_lookup_rmpentry(pfn, &assigned, &level);
> > +       if (rc) {
> > +               pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level %d error %d\n",
> > +                                  gfn, pfn, level, rc);
> > +               return -ENOENT;
> > +       }
> > +
> > +       if (!assigned) {
> > +               pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx level %d\n",
> > +                                  gfn, pfn, level);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (level < *max_level)
> > +               *max_level = level;
> > +
> > +       return 0;
> > +}
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index f26b8c2a8be4..f745022f7454 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5067,6 +5067,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >         .alloc_apic_backing_page = svm_alloc_apic_backing_page,
> >
> >         .gmem_prepare = sev_gmem_prepare,
> > +       .gmem_max_level = sev_gmem_max_level,
> >         .gmem_invalidate = sev_gmem_invalidate,
> >  };
> >
> > --
> > 2.25.1
> >
> 

