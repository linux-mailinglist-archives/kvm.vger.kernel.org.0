Return-Path: <kvm+bounces-15012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC218A8D62
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF0AD1C212C4
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CFD4482DB;
	Wed, 17 Apr 2024 20:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zgWBFdbE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2A645957;
	Wed, 17 Apr 2024 20:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713387470; cv=fail; b=bBbifYSf1PrVL7/2tatCWhuW36WT4QagYAzu3ztqq4ci+SXb+gQTR+AN7tO5SUitTgm1kY5Nncic9hbVrDFc5/LyFJ9pQ4UBXVQpCYKDH2Ax67u74qd3D692KPMKLUVW9tNEwPZ7bwqhMuevjclDxqeQhpzoSJtNgRIeDE/lGWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713387470; c=relaxed/simple;
	bh=4u5hn2Hh/87JQ7UPtjEmuh6lj8l9zAnHa0b3wr8ltHo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DyeTDlph2g9QpWLA6zgHIJkQC/SCB9fhY9Vl9t+x/JFM3cloajPiQj7aPPxrZivs+jDaUYt2LnOkJ4mYr1GVKh7Zt1FgEvKkH+VeWi9HEfZRoDM0XFjHL/LLn6kykyHc+oWPoKuLjCiF03r0O3Res2+6ZEq7VUqGT7z591U41KQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zgWBFdbE; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8dv82kSCk21qZKiuMhTBbwFiaDycANa/hONJZBAVnpKQGxXNabYZzbiLxfCjSUnF0Q11cdPO2xlPSb5R+2XsH4GGlbkoefvhlxDtAH18b68yw5Lo9j/GDkCHW5U7A5OEriL4toce78mgT5UHo9EuKHda3W1Z16E/I7z6tX0F3m6NQ20vvJ9UZSxlEZeRSgPFm32zdkl0NlllS2fgrbwMK5oxWPmCb1eEwnCnfE3xBI+BKpsCK3V0GEWL0b3OR1gA/cbj/XuUYbRCfBvBNqcog5S0wvIfROJSWcnMEnz1NJ6xoIgw3Fjbe4sNX8lVfp+Oq3vmTUCMAnAujXh59+mUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAHI1MdqIYTTn8gAftj1rCysaOC6m3lFRtlh7aH/OcU=;
 b=a+EuRZ1Mt9rF2bviFIFzgUglHfPXy1sK7EXQKfmpTM7dvf8HoXIWeZYg/sRNTC7tGSF4rjsxFZmxjdEmty+VvZBFe7/j1AjXbqcenrD/zgY6G+cjXRUj5+6d7pW3td5sadr4wHNyI+D9kp//r5DnwHrhiudmOJz/6++OF9URUDluQXlqzE6t2RcBlVhsayBM+vnlpmPf66d/42msAgYv+XLpDBeDiDhAZbUSjhTAGN2k5jQ4jXJ7+tW7eI8KOPBWp7E/0kAJr5UYeDR2/x36aoWtdc7aJu7s5YPFist8mPGoxsVUoJgzFw7xy4sR/58yyPcJBfoDB+6oghLAGXg+hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAHI1MdqIYTTn8gAftj1rCysaOC6m3lFRtlh7aH/OcU=;
 b=zgWBFdbE0DJXtalccsxSvcBttSQWr3qd0W0OxnVQss7VZDTzIdOzqTFWL3O6nFAzjvkLajKPFFpnY4zQcyl5JobnZQea7J9B9EkiaTZP4EMyo0Bwayo8oDfFNCMDBiqVjL29EJVs29dfYsX1xnWNpwdJUt3LBzQVbXhkFQdcrJU=
Received: from BN9PR03CA0322.namprd03.prod.outlook.com (2603:10b6:408:112::27)
 by IA1PR12MB7637.namprd12.prod.outlook.com (2603:10b6:208:427::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 17 Apr
 2024 20:57:41 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:408:112:cafe::4e) by BN9PR03CA0322.outlook.office365.com
 (2603:10b6:408:112::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.20 via Frontend
 Transport; Wed, 17 Apr 2024 20:57:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Wed, 17 Apr 2024 20:57:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 17 Apr
 2024 15:57:41 -0500
Date: Wed, 17 Apr 2024 15:57:25 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v12 18/29] KVM: SEV: Use a VMSA physical address variable
 for populating VMCB
Message-ID: <20240417205725.yougm6og3cuea2hu@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-19-michael.roth@amd.com>
 <67685ec7-ca61-43f1-8ecd-120ec137e93a@redhat.com>
 <CABgObfZNVR-VKst8dDFZ4gs_zSWE8NE2gj5-Y4TNh0AnBfti7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfZNVR-VKst8dDFZ4gs_zSWE8NE2gj5-Y4TNh0AnBfti7w@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|IA1PR12MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f78c637-caa7-4eee-2cd3-08dc5f2105da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	H/ArEvv3lMhSwBveKfeWg81I2KSLtJMLAxMLZrk7gCoSKk7WEt73DJQhF1nc2VKew1I/fJ8Z/jBzrITn6Gr0mm7EdinY64Fe8XoJD4QvDbOCTeLa8YRVhzKuvCaE81JSYevoBb6S58Mv1zniRKMelAHzNVZ5ZXo6ydWKV0Jkh9Hz3JnHW6+t0bTU4dNDVvUgUq2EQcGJUTpe/dPMMyjmt7YGSgsdIQ+Bho8CX8ZtOtlyZnv9G9tUg5vF06KTYHXfN032wPL21/rfb8GofyUCkODPudiZum8pPXiZSQU/dNhiDErsAzPN0VTtwHBN32IWrddwCTG0lPV2Vx3a6x0jY0/YBVolytMKOCE3gd+QJsknxJNhK1rNRZzYhTEoWdZZqyzeHvHLKwNyom3iSfmSmh3KDBOPmU+tD0iq8qJKLc5RlMA74idTjZtfgpUm2FknfFknVxiy6HUnhvn2BKWckPpT/htwdmJNRLHLueW9ZMsrvnMLwT0iHE6qRt0NusgkZvsegWWE4l9++39whBWlTNqAyPyQA0RrjXfm4Ieos77aZs+VaoSBYJrNfGP4oihtlCcxmArAy0c1WVfSbv4mPUuvHKL8jGXCiI+tMkKH9OVb9ie762v8RpnZXHVSzso5t3VI6DuMhFSifFAsPfAOY46SX8JuuxhmNYtqFODRnYqD58/34CgG5kOU7u3jH9plASuNiLznfoNCziSpW6LYDA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 20:57:41.5730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f78c637-caa7-4eee-2cd3-08dc5f2105da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7637

On Tue, Apr 16, 2024 at 01:53:24PM +0200, Paolo Bonzini wrote:
> On Sat, Mar 30, 2024 at 10:01 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 3/29/24 23:58, Michael Roth wrote:
> > > From: Tom Lendacky<thomas.lendacky@amd.com>
> > >
> > > In preparation to support SEV-SNP AP Creation, use a variable that holds
> > > the VMSA physical address rather than converting the virtual address.
> > > This will allow SEV-SNP AP Creation to set the new physical address that
> > > will be used should the vCPU reset path be taken.
> > >
> > > Signed-off-by: Tom Lendacky<thomas.lendacky@amd.com>
> > > Signed-off-by: Ashish Kalra<ashish.kalra@amd.com>
> > > Signed-off-by: Michael Roth<michael.roth@amd.com>
> > > ---
> >
> > I'll get back to this one after Easter, but it looks like Sean had some
> > objections at https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com/.
> 
> So IIUC the gist of the solution here would be to replace
> 
>    /* Use the new VMSA */
>    svm->sev_es.vmsa_pa = pfn_to_hpa(pfn);
>    svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
> 
> with something like
> 
>    /* Use the new VMSA */
>    __free_page(virt_to_page(svm->sev_es.vmsa));

One downside to free'ing VMSA at this point is there are a number of
additional cleanup routines like wbinvd_on_all_cpus() and in sev_free_vcpu()
which will need to be called before we are able to safely free the page back
to the system.

It would be simple to wrap all that up in an sev_free_vmsa() helper and
also call it here rather than defer it, but from a performance
perspective it would be nice to defer it to shutdown path.


>    svm->sev_es.vmsa = pfn_to_kaddr(pfn);
>    svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);

It turns out sev_es_init_vmcb() always ends up setting control.vmsa_pa
again using the new vmsa stored in sev_es.vmsa before the AP re-enters the
guest:

  svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);

If we modify that code to instead do:

  if (!svm->sev_es.snp_has_guest_vmsa)
    svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
      
Then it will instead continue to use the control.vmsa_pa set here in
__sev_snp_update_protected_guest_state(), in which case svm->sev_es.vmsa
will only ever be used to store the initial VMSA that was allocated by KVM.
Given that...

> 
> and wrap the __free_page() in sev_free_vcpu() with "if
> (!svm->sev_es.snp_ap_create)".

If we take the deferred approach above, then no checks are needed here
and the KVM-allocated VMSA is cleaned up the same way it is handled for
SEV-ES. SNP never needs to piggy-back off of sev_es.vmsa to pass around
VMSAs that reside in guest memory.

I can still rework things to free KVM-allocated VMSA immediately here if
you prefer but for now I have things implemented as above to keep
SEV-ES/SNP handling similar and avoid performance penalty during guest
boot. I've pushed the revised AP creation patch here for reference:

  https://github.com/mdroth/linux/commit/5a7e76231a7629ba62f8b0bba8039d93d3595ecb

Thanks for the suggestions, this all looks a good bit cleaner either way.

-Mike

> 
> This should remove the need for svm->sev_es.vmsa_pa. It is always
> equal to svm->vmcb->control.vmsa_pa anyway.
> 
> Also, it's possible to remove
> 
>    /*
>     * gmem pages aren't currently migratable, but if this ever
>     * changes then care should be taken to ensure
>     * svm->sev_es.vmsa_pa is pinned through some other means.
>     */
>    kvm_release_pfn_clean(pfn);
> 
> if sev_free_vcpu() does
> 
>    if (svm->sev_es.snp_ap_create) {
>      __free_page(virt_to_page(svm->sev_es.vmsa));
>    } else {
>      put_page(virt_to_page(svm->sev_es.vmsa));
>    }
> 
> and while at it, please reverse the polarity of snp_ap_create and
> rename it to snp_ap_created.
> 
> Paolo
> 

