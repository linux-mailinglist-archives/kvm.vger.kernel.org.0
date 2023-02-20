Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20EB569D192
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 17:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjBTQmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 11:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjBTQmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 11:42:19 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DC41E5EC;
        Mon, 20 Feb 2023 08:41:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5L7DJf4LmtelcC9wBjZcNgb6+ELX7sAhrS3RViOZPq7ukAQkZHDHLuhnso/3TetGMUP0tzuyGdNjxUXhEKZt5KGyKSc1OW179SkGTQC1E2m36Ifs2TFx8hct5QD8HOBpZmUCcr0u+W5C2nTgeaz6Djq01KGTE7SnWGGeaBH1dvUe7jfpyi+3f6/cMLcAHi3MoI90C/GTR3nWK4klRGWDbt0+sUfulyxamJVEMzqCm+DVQeENv0BLAUYUAhgq1yFYmGIe7B+dluN7ybZNEvCbWrKGORbMcqEmH+ka5Lk9Lx7p4cwtLleUQ7iHCa873oa09VyOwUKvzhGTi73BaLckQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MYG2F/Kz+L66kuyTglO+w54eANn764HnkaGxzcD/lIo=;
 b=ja+wRfDFx66hQVuYY4e0ZVuKvF9bXwOHuCJGXkcrs4OG5CweokyzdeeBjvTKaYM6EIEFhb7EncSkB/evZs0Hm1HcuNjRKb+TNgn0AVY+iLEc5/oiJMuho0hvkBd8QpLeZuz4fzOUTQJuIJOGTGX04Sk5QjZj+EcOiexmLJPTKjf5Dd1wyEpAkep4BMjFT0HYhSqlwKGpn4zAqaBYbvDR4qWaUSCKvU+tKoo0oDHlI3OmvyxoIc05PRvQdSaEYjhE7vJ3FZkkqsQGTlLjGdWWaM/59+lD+sh4n86b9x+sKydefJKLNwJBtTy4Pqvqit6mmowuttZwxrnak49ncsfnvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYG2F/Kz+L66kuyTglO+w54eANn764HnkaGxzcD/lIo=;
 b=b+hRllSZL33xnPNb455ex0qZG3NS8LcxVtfkdSzJu8WEVabrhLx4tm1ZSWrsKmHcYB6ltIrv8KdA4zdOzFiedtVH4jNTuZIyNh1mL/Qct/aSrGdjEUt+SkqzZc0zMk0Zuyg/Bph/+VMbv3ll6EEwi+mnLMAdbOWszLzPKTwBDpQ=
Received: from BN9PR03CA0085.namprd03.prod.outlook.com (2603:10b6:408:fc::30)
 by IA1PR12MB6233.namprd12.prod.outlook.com (2603:10b6:208:3e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 16:41:36 +0000
Received: from BN8NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::3e) by BN9PR03CA0085.outlook.office365.com
 (2603:10b6:408:fc::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 16:41:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT082.mail.protection.outlook.com (10.13.176.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 16:41:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 10:41:35 -0600
Date:   Mon, 20 Feb 2023 10:22:10 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Borislav Petkov <bp@alien8.de>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: Re: [PATCH RFC v7 04/64] KVM: x86: Add 'fault_is_private' x86 op
Message-ID: <20230220162210.42rjdgbdwbjiextz@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-5-michael.roth@amd.com>
 <Y628y6hQK38+IAev@zn.tnic>
 <20230105024256.ptujtjgzcdmpakoa@amd.com>
 <Y8Fr/F1RV0B8CHq5@zn.tnic>
 <Y8F9a2pmh13aIQZL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y8F9a2pmh13aIQZL@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT082:EE_|IA1PR12MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: b6c2e143-74b1-423a-2241-08db1361556b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cP6+xIqw9Siwm1AsQbGq3lUcyP+SuryfSqfArKD40Dzj2bvBy2ZCoKtQKi+zao/5bZErIalPmMMpkPRKVO3QnbFAQI6pXPmnVHRtnnJEIiuUeUW/QFTifxvF5s7Xt9VULWiDxJwSL+UwIVG7cu2GrKvFGPttm3Cqhzl6R5NOFBw7Z8CVPhMdt+IdSRBrhoEXizRYsXBP8m9XXDMfJwa3glbqBF/4veEwFv5YAmi0f+nT7cp5Ls5xsrFStI7WpqLpCtz+GrBGCA+rXjwlVSsdf2S4QidMIA/xgza4Hhzbi+883+tK5lwhE/JF5sVbCRiPrEnxv0QAY9Np0cE3Hp37XNU8EuSCU2Bg3WgPZ2rDyi2Ss8IV8dQWvVpkww/grOlHIorV4b7r4EcU2wxVZuK9tsNIvNE4t2RQPVnrniZG8H2HbwiReDt4FnkijeVBa/YHZey4edIiE4oiYRECf+zhxcnB9Uosi+/+REpy3ERkR5ycAL6KKIbK9MOtUl/yRnaV+IqMEBKyR3FNoCdwUFYGBYRX3N5fUa/K12cechZBA+DtwWUQb1gBKvpAjJsWvFTGAxSUJfeYcq5n9xs9n1xoqnA4JNPww9u2LvRH9DgnhHJKTCSQ+GWBRym5Bhvy5AF/x/PzVA44J2iIXkQQ9MupVFIAvuEIsNIsUTz+4Tj+F2Nr7iyEqz1jANyQhoYwKq4iiM3F/utOaFOOiZCEod4ujQOXekpczbxcHn3erXcXibA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(66899018)(8676002)(70206006)(70586007)(6916009)(4326008)(316002)(7406005)(54906003)(7416002)(44832011)(8936002)(5660300002)(41300700001)(40460700003)(36756003)(86362001)(356005)(478600001)(16526019)(6666004)(26005)(186003)(1076003)(2616005)(336012)(47076005)(426003)(2906002)(82310400005)(40480700001)(81166007)(36860700001)(82740400003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 16:41:36.7959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6c2e143-74b1-423a-2241-08db1361556b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6233
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 03:48:59PM +0000, Sean Christopherson wrote:
> On Fri, Jan 13, 2023, Borislav Petkov wrote:
> > On Wed, Jan 04, 2023 at 08:42:56PM -0600, Michael Roth wrote:
> > > Obviously I need to add some proper documentation for this, but a 1
> > > return basically means 'private_fault' pass-by-ref arg has been set
> > > with the appropriate value, whereas 0 means "there's no platform-specific
> > > handling for this, so if you have some generic way to determine this
> > > then use that instead".
> > 
> > Still binary, tho, and can be bool, right?
> > 
> > I.e., you can just as well do:
> > 
> >         if (static_call(kvm_x86_fault_is_private)(kvm, gpa, err, &private_fault))
> >                 goto out;
> > 
> > at the call site.
> 
> Ya.  Don't spend too much time trying to make this look super pretty though, there
> are subtle bugs inherited from the base UPM series that need to be sorted out and
> will impact this code.  E.g. invoking kvm_mem_is_private() outside of the protection
> of mmu_invalidate_seq means changes to the attributes may not be reflected in the
> page tables.
> 
> I'm also hoping we can avoid a callback entirely, though that may prove to be
> more pain than gain.  I'm poking at the UPM and testing series right now, will
> circle back to this and TDX in a few weeks to see if there's a sane way to communicate
> shared vs. private without having to resort to a callback, and without having
> races between page faults, KVM_SET_MEMORY_ATTRIBUTES, and KVM_SET_USER_MEMORY_REGION2.

Can circle back on this, but for v8 at least I've kept the callback, but
simplified SVM implementation of it so that it's only needed for SNP. For
protected-SEV it will fall through to the same generic handling used by UPM
self-tests.

It seems like it's safe to have a callback of that sort here for TDX/SNP (or
whatever we end up replacing the callback with), since the #NPF flags
themselves won't change based on attribute updates, and the subsequent
comparison to kvm_mem_is_private() will happen after mmu_invalidate_seq
is logged.

But for protected-SEV and UPM selftests the initial kvm_mem_is_private()
can become stale vs. the one in __kvm_faultin_pfn(), but it seems like ATM
it would only lead to a spurious KVM_EXIT_MEMORY_FAULT, which SEV at least
should treat at an implicit page-state change and be able to recover from.
But yah, not ideal, and maybe for self-tests that makes it difficult to tell
if things are working as expected or not.

Maybe we should just skip setting fault->is_private here in the
non-TDX/non-SNP cases, and just have some other indicator so it's
initialized/ignored in kvm_mem_is_private() later. I think some iterations
of UPM did it this way prior to 'is_private' becoming const.

> 
> > > This is mainly to handle CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING, which
> > > just parrots whatever kvm_mem_is_private() returns to support running
> > > KVM selftests without needed hardware/platform support. If we don't
> > > take care to skip this check where the above fault_is_private() hook
> > > returns 1, then it ends up breaking SNP in cases where the kernel has
> > > been compiled with CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING, since SNP
> > > relies on the page fault flags to make this determination, not
> > > kvm_mem_is_private(), which normally only tracks the memory attributes
> > > set by userspace via KVM_SET_MEMORY_ATTRIBUTES ioctl.
> > 
> > Some of that explanation belongs into the commit message, which is a bit
> > lacking...
> 
> I'll circle back to this too when I give this series (and TDX) a proper look,
> there's got too be a better way to handle this.
> 

It seems like for SNP/TDX we just need to register the shared/encrypted
bits with KVM MMU and let it handle checking the #NPF flags, but can
iterate on that for the next spin when we have a better idea what it
should look like.

-Mike
