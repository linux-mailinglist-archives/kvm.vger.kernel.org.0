Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CF669D19C
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 17:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbjBTQna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 11:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjBTQnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 11:43:19 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7930820698;
        Mon, 20 Feb 2023 08:42:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F33TLFEtUX5NqerECMz5nFJxNQwFlFIj3H5VIu5po3HvvBE2stSSf+bQEYHjnl8Zwc8cy8au0GWfifTmoIlZhSNKeuvZZq59YRyWrU3Q6bh8EShJYFsDBahua2o9yt/yEmWPwa+KHuDQ9SD1FJl8ZB8L2xVt62uH3vzsrzWJ2jsyqdbHa/cvQiByFI6c2klvbqiWW7KKLHDT5BtSJ4f8AOxOaRffdMJN4IDvmj6zBf9iyzc5gMKjRj9OBr7/vuAt7gxra7+RqjmJnnTEZ8MZiS/J28j3njS2zN+gwb6OnBfwzuBehqmFmAzFDu4/etABL8VWsx/hEJkhI7I8yHQepA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLQ/RWrACO1o5MYjZUYoB3LJRMJTWPICSChnPqiBt28=;
 b=NLG9FGYWXH8fTIrKr4ZN3ncUbW4B5+UUSgIbuJS2///Kebjo4+vB1vfXVu1dkCe+O/9fD/cF1e7+OkQ7j4plGUceQ8/eLS/aq0+5v4NsSbKHpGKBlBdf9rVEI/M7ARh0rB4cxnl/EHmtvVS2vs8cMXkE2oKJJ7IBCjGov7H7uZeWC60E1ZDx+OBTnET87JhJrtKODhjYTEmonlEkPpf45oVGGAiDLqyNA9/gmngXvxATYvJ52uaLyGO9i9rvUvVFzl4Quq4BDyx0znwtLNC30Uh/jAvQZMZC+0oYdEgOH1cvmQl3oE65SgAvzE8bF2/soyMknyqG51CjSZ3DRuunEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLQ/RWrACO1o5MYjZUYoB3LJRMJTWPICSChnPqiBt28=;
 b=XJ2LSsWtc5kSl6xSCxN2kIAL/f4miZp0n0qEkgmhM+moc14clp0/EsAU42sAOFhckNyoWo3YQyzZnjYA/6xv31KebDllG2vgrRo44o4oMXbeBWR/NtU7wpvfJkdws8fgPqZAPt/V9M2yqcxUtqQvXuDA50R9GwWZml9Pi1vx/Sg=
Received: from BN0PR04CA0002.namprd04.prod.outlook.com (2603:10b6:408:ee::7)
 by DM6PR12MB4201.namprd12.prod.outlook.com (2603:10b6:5:216::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Mon, 20 Feb
 2023 16:41:58 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::8e) by BN0PR04CA0002.outlook.office365.com
 (2603:10b6:408:ee::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 16:41:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 16:41:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 10:41:57 -0600
Date:   Mon, 20 Feb 2023 10:26:47 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH RFC v7 13/64] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <20230220162647.czmii5swwsz2wdhy@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-14-michael.roth@amd.com>
 <Y9qx5NbZIRdpHy5J@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y9qx5NbZIRdpHy5J@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT024:EE_|DM6PR12MB4201:EE_
X-MS-Office365-Filtering-Correlation-Id: 694e7b28-0130-4090-89ae-08db136161e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2m3pYoHWSGb0SBzbly7FNKN8ADjjFxz5WeVQpft0EGc1wg/40pnNnv2ediqoAzeiPhvdehUPpWR8ORnTCm/s7CzyOjUjO8BxI/B0JpGo4N0lQzMwr/I0o6/MT2zKxcim+jVbcx0VUO53zs3/jiwN4Kx65LrXw4CFSLkOW/D0HJ/riq5HBJxb6BQ806OLf8nY9mR+XEi3izTy+HdfuipDbcGNBwoCIAI7J91j7W/rg+3P/oqaHJ8jUAJvTRkVsL17P3TEAqyHhklaV3wAWJ8l1FuchOXKNmexqokdg6klc0CacC/NTN6I9JOK4l8UnSKhQ1EnKSoMsWFxYm6CF5mLUjOLBCjUUxXZ4/I3CSnutSLnqBmAq2vq4MaF+Mby4rZJeN1ZsbxDhmFv3OuRhFzXKbc2PBabvEEoP1Q5a1ZEFfuOQcxeahW33cW7nZyHV5+73HuZfJ7I5+OpYVBMO065iNN+Nw3mRILG6uxFkahj3vf/20xoCRgghHys0sYbIwfQsYhsWteLh/XwLMLts7gqZwsEfU6gY3FoVPY0SVm+vyp28PQUS1YYKa9daLDGrTkTOF8sGZyI2uM2zIm1dNHxQw+Qw+TVj63+j4GQNCBbsAK1RLNfCXuBwvVnAcZ2lcd4MbH8cDv84uXtvfT1mFRFQkh9F8ueBe6ZFwQfKCapvXSQXgLk2EIs4cnvSjPKO1pmNqafZVtMc3SptMgUhovQomU0rIaiWF+1liR1Rp451hE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199018)(46966006)(40470700004)(36840700001)(16526019)(966005)(26005)(2616005)(7406005)(186003)(41300700001)(6666004)(1076003)(5660300002)(7416002)(336012)(316002)(83380400001)(426003)(478600001)(47076005)(8936002)(6916009)(81166007)(36860700001)(356005)(4326008)(70206006)(8676002)(40460700003)(40480700001)(70586007)(36756003)(54906003)(82310400005)(86362001)(44832011)(82740400003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 16:41:57.7882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 694e7b28-0130-4090-89ae-08db136161e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4201
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 07:39:32PM +0100, Borislav Petkov wrote:
> On Wed, Dec 14, 2022 at 01:40:05PM -0600, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > Add CPU feature detection for Secure Encrypted Virtualization with
> > Secure Nested Paging. This feature adds a strong memory integrity
> > protection to help prevent malicious hypervisor-based attacks like
> > data replay, memory re-mapping, and more.
> > 
> > Link: https://lore.kernel.org/all/YrGINaPc3cojG6%2F3@zn.tnic/
> 
> That points to some review feedback I've given - dunno if it is
> relevant.
> 
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> 
> I read this as Jarkko has handled this patch too. Is that the case?

Yes we shared some patches via an internal tree at some stages.

-Mike

> 
> > Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> 
> Those last two are ok - you took ovef from Ashish.
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
