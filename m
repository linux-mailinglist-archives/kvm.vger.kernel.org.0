Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6B06CCE14
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 01:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjC1XeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 19:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjC1XeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 19:34:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3802030FA;
        Tue, 28 Mar 2023 16:34:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6KZQfGogxJzB7QVCoypIGnXISkoRd9m4abYQaw/u7IjQJSKuCjmXT/aUQtBdsW8zMMwt7WMWJkUHEP3BndwO5zg3Ioo/zlzLxz/AdJT+4y/rXXQ3ylCW37QZqZIaSRoraGCdrHJGzkmW75HDSKpYOaG1NaDwqJp7l3dauh6btlNDYrHvpOMCP3EQauFSOvQFVG11GcttSVahMtn8nKzvJjpnh+BX/yjhX6oKBWOX+mAspRhN+lysF44ikSVqdQiOatlGzbRewdDVN/KD2UhqLxLjMd1rc7I+rUtreFoJyFBEIo8gPPawt///k1h7XTg1kyqKVn+pI+0NEc33QGY4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLHvBVFpG3LUrJvWdbpbu2aCSXfgqgsb7s5DMTT0rmM=;
 b=ScZbWnGSA/mXWJhomKN3bFqUeOTfNdEMbBaln2qDT6xABP3ATYlycgAQMP1jKhCPwGnI6wgTG0p03boI/6Fq6bduQvRJQpVEgYuJ41FgRarsPPUo+CFxLNifIoeG9Ro/0OMQTC5c/1uGWPQbJjHckgfSclQhKKLSvjajjMYJj38nqW0cu/7k5PktyVuA41n+pB+XSyAM6weFwLk/RTNcVVOBHXk2q6USV7v1qrn5g6lDHF8lwySBOT/VcSnkn+qCOL2LLOO6jlZeF0e4lqxTJx512QIo0XP39w0elT8Ha7rzzx74tWqehEpjG1cygiMKQ0eqRucnFj3qDAMSpiFzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLHvBVFpG3LUrJvWdbpbu2aCSXfgqgsb7s5DMTT0rmM=;
 b=UvJ1RDzTSgmgVM+Y0FnW3vqsM97SIVtLLwIN/QQeZi8ODeGpKGZUXYQ7/b6ZYniRML76pVGGWPkBSYFNmjW6y3uh0mDwE+awT3s8FcWuopfS+W7Me2MeOu/tjJcG5fZ6qa42E3M6vh8i6neM/LhZq6UsID6UvI92QQAwobbnS3A=
Received: from BN9PR03CA0929.namprd03.prod.outlook.com (2603:10b6:408:107::34)
 by PH7PR12MB8826.namprd12.prod.outlook.com (2603:10b6:510:26a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 23:34:10 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::12) by BN9PR03CA0929.outlook.office365.com
 (2603:10b6:408:107::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Tue, 28 Mar 2023 23:34:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Tue, 28 Mar 2023 23:34:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 28 Mar
 2023 18:34:09 -0500
Date:   Tue, 28 Mar 2023 17:12:58 -0500
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 15/56] x86/sev: Invalidate pages from the direct
 map when adding them to the RMP table
Message-ID: <20230328221258.qkhzwyxr5lebxdmv@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-16-michael.roth@amd.com>
 <140c3675-376a-be37-56da-878b08df5507@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <140c3675-376a-be37-56da-878b08df5507@intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT047:EE_|PH7PR12MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: cea1360a-2934-4aee-78ca-08db2fe4ee44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ATYHQWahOsdW4fIUD5kMXEx4Lyl7WBg1SoWAdi4wa4eKtFfazogLpFJlzPKxB1rwTF9wUzc033fse4GlOd5N6ZWy1+5O39/5QtNp4UtMofn02XxMD1oGcTY5W2IZyyfCInfn1Uq7hP7Fe5XZRtByuBkWllU0PN0s2vvdi4UwsrAln35OO6bWYWEZd4bzrsN41oKMOfuM+KHHpDOhcVZS347D7iEp4TNdvRU2vt0Pz4dswUg1QVdDAt77infeH+SkwYY1T71+zevqbCyoTmu7eTQc4XoidH9nVEcP1+l2Z12adcwJ/X07jVWvzss1NFue922V9Cxo05G0/76m+P+6t2i5biuUuhVuKex+d1CZfFfpVsumr1MZBX+QLZ/IcDKx1gVl2WyQrTdXyp/mPegD1zyLkNmD1Oj8kDpxt66IEw4GLB8l1NFFfF+vr3T+u/6CM+sAXKyOyHtlOsl5tqxGOKiGFwjYV+MRrpUbcnfY4eFbYIU1lPY9NUylAKjmuxkpIxnWkL10rGbNa9j0E1ACHRkceCUb5ppkKxH09bq6uWP5EEnbxZ3IUi4NzFnkMmMZ90m5GfykTIxG+EBa9K8DhWGUppaJlwB5BLQvZLlibOk399lxR9Z3ZOxyMx8RNQU6C+C93gjriKvonv44xk9jt81sWR6gQ5B9rjvmhV/2KwDr94cN/OCwGbnBkinsR2U7O0MNOQb3iM9/wW08+qdzi6gMVLzP3HExZldLRSE2elA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(40460700003)(4326008)(41300700001)(8676002)(356005)(70586007)(6916009)(70206006)(2906002)(36860700001)(36756003)(82740400003)(7406005)(5660300002)(8936002)(81166007)(40480700001)(82310400005)(478600001)(7416002)(44832011)(86362001)(316002)(54906003)(2616005)(6666004)(53546011)(186003)(16526019)(47076005)(26005)(1076003)(83380400001)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 23:34:09.9102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cea1360a-2934-4aee-78ca-08db2fe4ee44
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8826
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 08:15:46AM -0800, Dave Hansen wrote:
> On 2/20/23 10:38, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The integrity guarantee of SEV-SNP is enforced through the RMP table.
> > The RMP is used with standard x86 and IOMMU page tables to enforce
> > memory restrictions and page access rights. The RMP check is enforced as
> > soon as SEV-SNP is enabled globally in the system. When hardware
> > encounters an RMP-check failure, it raises a page-fault exception.
> > 
> > The rmp_make_private() and rmp_make_shared() helpers are used to add
> > or remove the pages from the RMP table. Improve the rmp_make_private()
> > to invalidate state so that pages cannot be used in the direct-map after
> > they are added the RMP table, and restored to their default valid
> > permission after the pages are removed from the RMP table.
> 
> This is a purely "what" changelog.  It doesn't explain the "why" at all.
> 
> Could you please elaborate on why this unmapping operation is necessary?
> 

Here's my attempt at an updated changelog that explains why this handling
is needed:

  With SEV-SNP, if a host attempts to write to a page that is owned by a
  guest (according to the SEV-SNP RMP table), the host will get a #PF with
  a bit set to indicate that an RMP violation occurred. This shouldn't
  normally occur, since guest-owned pages are encrypted, so any attempt to
  write to them would just result in garbage being written.
  
  However, if a host writes to a page via a 2M/1G mapping in the host
  process' page table, the above #PF condition will trigger if *any*
  4K sub-pages mapped by that PTE are guest-owned, even if the write
  is only to 4K pages that are owned by the host.
  
  This becomes an issue with the kernel directmap, which provides a
  static/linear mapping of all kernel memory and defaults to using 2M
  pages. In cases where a page from one of these 2M ranges gets assigned
  to a guest, the kernel can inadvertantly trigger #PF by writing to some
  other page in that 2M region via the virtual addresses provided by the
  directmap.
  
  Address this by removing directmap mappings for these PFNs before
  marking them as guest-owned in the RMP table, which will result in the
  original 2M mapping being split and ensure that guest-owned pages can't
  be written to via the kernel directmap.

-Mike
