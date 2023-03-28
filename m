Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB836CCE1A
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 01:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjC1XfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 19:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjC1XfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 19:35:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF092D56;
        Tue, 28 Mar 2023 16:34:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aq3+2+iROt6Cp+jvJg/kjX8sk0gMVZe2osplaQ7Xq2V1o9IltUrVRT/EzDTVWSpYv3U02nzh7FRv6rifnBSVprJB5sBcZn+Lphy6B9bSV17tdhDYu+pl49wvr00FteDBt9NWGwrodyjuSWDndBdihK3WQsIziVjP8/FtucGDjIdfM7daJCj7vP7jYHuqkQWktXi9pvVeNtcfT8rT0aAPaYSTaBjq8Mv/2bijDO7jfGwSS5CNl0YRnNaK8jzZ2izzSfpxowokxNU3Tl07Lxqv4VJNdXNb51BTmfN12Ds20T2GiPpy1Y1i11SJouAs8MpjXyG5Mqjf0Do8vQwtj1UScA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qnQ4hMDbgmzulrJmRXdEQSRCEUjhwT5IRjHNs8n/Www=;
 b=a3Zj+XqqQYccMbzSEww2+g6Z9tZMnLb/saAEXOTW7PuM2mkSUGtMP1ZyLMbVfg9RpW03W/dRL6WS3PXmL5K/DYsend3CBrFnjOYK1xTgnBtBnRUURBSKCOEBnkT5kFusRNvqrAAxF0WS8xh4QzIkrJIYMh76N7tgd4Jl30GcUtMuOG5i3E/9625HO4F3RPVXMZca7cv+IkY4v8vspLu9JF0u13eydHFqTXZBtfGbyj/pzjUTlmsazCguDxgcHbn/d/xNSLCanOcIsOz9TlawUbXf8MO0xrkJPtfqpFpbKfsJkBiq5JblQKz95vP1A0Ce+KSzN1kYXakYZiqAomQqIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnQ4hMDbgmzulrJmRXdEQSRCEUjhwT5IRjHNs8n/Www=;
 b=PZvW3zGNq11gY02+BL+3vRDUehJq7InPEPitJezsW4w/tXky7X6K+3T7gu9esL1vUJdzk47ZKfrHBEvn18/EYBrPFVx/ESp1nL6NZ6IkAi2tM5C/xhUJnzwcxbIKrSdmdjv9RrQGnEhjUzV1W3tKGgQChCXzpGlerkVp6sYGOy0=
Received: from BN0PR03CA0034.namprd03.prod.outlook.com (2603:10b6:408:e7::9)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 23:34:57 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::a1) by BN0PR03CA0034.outlook.office365.com
 (2603:10b6:408:e7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Tue, 28 Mar 2023 23:34:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.14 via Frontend Transport; Tue, 28 Mar 2023 23:34:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 28 Mar
 2023 18:34:54 -0500
Date:   Tue, 28 Mar 2023 18:31:01 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@profian.com>
Subject: Re: [PATCH RFC v8 17/56] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <20230328233101.4idfki7ulpyhxrwy@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-18-michael.roth@amd.com>
 <a15fc9a5-c136-47f7-e15e-776a511f3cdb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a15fc9a5-c136-47f7-e15e-776a511f3cdb@intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT021:EE_|SA0PR12MB4510:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e45826c-771b-45ea-3b34-08db2fe50a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aN/gcf8xdFmeaW0Yd/n0Pe/gKnTBoOnt2UisdRKcKbdYca7v2RALGjP22WCH322CGVSERbC0vCIPBLjUdStishmhVtmmJBYp4tliHxN4AB/dMvjHJ7HFN5/jFwKWfNnbrroxbTfpiInMuyQGnEdjNCcaGuM4XhCdkFij1ajXcxmPQZRcimddj0aMaPxjqrxg9PvSkPE6awLIzZP2BtBtiyKZmC934rOLM0K0ODYroqU/qX8G7NmxLN7xLs6jsP1O5WXosLQ+WJUpzeO9/eHbpQ39r1aY2n/SVJDLFTpsQ8DTrfEjuQBmRNyvSdBtTbo7DUMsQGIt6V0rYf/8ELVrAzzBXt5vhCtX6/MnOXJfqhvc+ed47ZHPXJE3NpfCNUOtgGV+NXUfDmFLRE1eNGHked77Fo3pCoxCke5MR2e+PG7T3Z+3eFKSe9oaFYsQlSjf2Fbw69nWcDLjS6f2T5hzXc4mO1QFmM/6G/Z5EY9Mzwx6GgvmYPEWsJMxJYyexOxOCbOe4pCg5FpLzmMrisVZHejacHg3RVp8Q+sr2vCEVAdfDqetIS8wsgVmstdDG9VLXub5dj+dcCKNEqgNpBa0oVnPpugYsc6au0tFRs50yK6KZRRaQ8bo5VeVA9bK6EykewbCg3uZMDGFC7dO5xHPcIz6yrFJPUts3+rFpAuI+iXCJCYgLraSrLbmmTSSUFt4GAtgBkHXCwGWQc22y0BKxQPclWsqgknFFKdxL/moehM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(40460700003)(4326008)(41300700001)(8676002)(356005)(70586007)(6916009)(70206006)(2906002)(36860700001)(36756003)(82740400003)(7406005)(5660300002)(8936002)(81166007)(40480700001)(82310400005)(478600001)(7416002)(44832011)(86362001)(316002)(54906003)(2616005)(6666004)(53546011)(186003)(16526019)(47076005)(26005)(1076003)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 23:34:57.0945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e45826c-771b-45ea-3b34-08db2fe50a64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 08:21:17AM -0800, Dave Hansen wrote:
> On 2/20/23 10:38, Michael Roth wrote:
> > +static int handle_split_page_fault(struct vm_fault *vmf)
> > +{
> > +	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * By the time we get here, we already hold the mm semaphore
> >   *
> > @@ -5078,6 +5084,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
> >  				pmd_migration_entry_wait(mm, vmf.pmd);
> >  			return 0;
> >  		}
> > +
> > +		if (flags & FAULT_FLAG_PAGE_SPLIT)
> > +			return handle_split_page_fault(&vmf);
> 
> I asked this long ago, but how do you prevent these faults from
> occurring on hugetlbfs mappings that can't be split?
> 

In v6 there used to be a KVM ioctl to register a user HVA range for use
with SEV-SNP guests, and as part of that registration the code would scan
all the VMAs encompassed by that range and check for VM_HUGETLB in
vma->vm_flags.

With v7+ this registration mechanism has been replaced with the
new restricted memfd implementation provided by UPM to manage private guest
memory. Normal shmem/memfd backend can specify HugeTLBFS via a
MFD_HUGETLB flag when creating the memfd, but for restricted memfd no
special flags are allowed, so HugeTLBFS isn't possible for the pages
that are used for private memory. Though it might make sense to enforce
that in SNP-specific code still, in case restricted memfd does
eventually gain that ability...

But now, with v7+, the non-private memory that doesn't get allocated via
restricted memfd (and thus can actually be mapped into userspace and
used for things like buffers shared between host/guest), can still be
allocated via HugeTLBFS since there is nothing SNP is doing to
specifically guard against that. So we'd probably want to reimplement
similar logic to what was in v6 to guard against this, since it's these
mapping that would potentially be triggering the RMP faults and require
splitting.

However...

The fact that any pages potentially triggering these #PFs are able to be
mapped as 2M in the first place means that all the PFNs covered by that
2M mapping must also been allocated by via mappable/VMA memory rather
than via restricted memfd where userspace mappings are not possible.

So I think we should be able to drop this patch entirely, as well as
allow the use of HugeTLBFS for non-restricted memfd memory (though
eventually the guest will switch all its memory to private/restricted
so not gaining much there other than reducing management complexity).

-Mike
