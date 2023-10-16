Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DE77CAD5C
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjJPPWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJPPWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:22:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9446AC;
        Mon, 16 Oct 2023 08:22:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SH8Fr6nG1NXcXesPkoqsB4dkwA/Ns8Thy+iK+565/EWsiT1GX+gG7f67wkcLq5K0uJOs/GK1MdCE7iYQVZgs/ac/hsSDi/NamuSgr5WilN4hjrNqw/+5vMHJymswFB44Q6ke4umuF2zTtFtx8k8pB3ot1JuUoGVd0zPXKbuE3pnzSlmWTBwOOQLI6psXTBwNbruCfx1ET+mKGiwhNJ9a0GnNwa8TT/z+AuqTKmo9c4xMgzO/xkxO6MOy7Xq0CdtSjgIxLiWuWPrSfGuCCjTdUtKwpi5XLDjrTM/pMooNvj8fIBejp2OpCgG0IVD9RKecdr8QIo7yDAZBcZ7aq9nAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnOgOgc/xF/znhbhik3tEbOGfsPAveHaNExXmuj1Jmo=;
 b=jcPmj4FKYo2SD6JYJo936UZm9TbOlO7uXQk9uC4jTXgxw1QwYmrLOa2woHHvYrre5pN3JGGCoEm0kwvfJNuDmbLTFdJn3WdjmEOuuGXpq/pGuq6AvUt6XbyMN3au6kAi69iP/Vs0J8WqY9qtbSMAJ7R4qBXSWSdbyGO0BfRd5RTByraag5Rsz2gZtOWWlAB/nlmeMdXEmgAZAuh10dIJNfD3H1YY77Bkyrz2t9oyJXrWbmBCLP0bGq9Qdo3YwG29cflnknKh+2P+GhhyEMn1e7Hw83yxnCFaDcnCU2+W0ONAliuU44XYYFUSZP3dbRSa6grdFga62u+8K2Dn5DMiCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnOgOgc/xF/znhbhik3tEbOGfsPAveHaNExXmuj1Jmo=;
 b=GvgUPKWPXx9rg7Oinm3/BGmrMipaIMD5RauhBrS/iaxRnR+6QFoI1J11fQvgxsJ4AGgBXhmd/0snVNsw1SWjtN/gjNXSxHcdBH/Ohfvo9gMQhJwVMDNc226E8ahjwOy8mGLqsJAZ3oZrd1o6ZbP6KFUILTpUxNAye8rIMctlOZk=
Received: from DM6PR03CA0100.namprd03.prod.outlook.com (2603:10b6:5:333::33)
 by CH3PR12MB7524.namprd12.prod.outlook.com (2603:10b6:610:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 15:22:10 +0000
Received: from DS3PEPF000099DE.namprd04.prod.outlook.com
 (2603:10b6:5:333:cafe::6e) by DM6PR03CA0100.outlook.office365.com
 (2603:10b6:5:333::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 15:22:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DE.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 15:22:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 10:22:09 -0500
Date:   Mon, 16 Oct 2023 10:21:48 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Greg KH <gregkh@linuxfoundation.org>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <seanjc@google.com>,
        <vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v10 01/50] KVM: SVM: INTERCEPT_RDTSCP is never
 intercepted anyway
Message-ID: <20231016152148.4atqpxd3wnyfp7ri@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-2-michael.roth@amd.com>
 <2023101627-species-unscrew-2730@gregkh>
 <359d7c57-2a71-419d-b63f-4c5610f48b0f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <359d7c57-2a71-419d-b63f-4c5610f48b0f@redhat.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DE:EE_|CH3PR12MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: 85fd791b-2960-4e09-dfcc-08dbce5baa83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3+sJEFckqSoXgwRWjkt+1dxMUc65pQjuXZM3fafq1oWYhxYpFDxjIgjyxWhrkyKvOBt0/kASqfwJgZT5cWlhrCvlcHesHmxS3CRXTW3Kbfmt4DoQi88eXlPKnl/ECDhIz0X1F6cIcQm4QAVntM9X0+a1/+rQFMyLLX6CrwqrjcxzS5p4jKJBkrA8UKnd7nSvOYla8Wh2s8XCw5Y4ZI9ibmQGeZQwRPFO5laffkx4rAwKUEwox6JaGPHhN6d41fhQqTbVA/DXJo+UtU3ftabOyu10hI7MtqNGfyC7H18GO5pvPvrF1OhwzEir+W30e0fomerW4+M5nVbf0sLUHkb77RRUkMl5DKrZ76oTMJHEJge/YYmCidojbf0ojSXysm3weJ024OzFy30R8zB79ACULKWVFSVAvlRIepzxn4/F33HXhNX43ANJDQ2Gr+bSAJtoU7FrpmNoEVN0E2qSEHCUbXsJZ9xYJ7O1kY87s9KXu2wokoii/Q3jeGEgqZ2ph0MrI0rszSPxSH/0hkkzFTRzIKRKJibs3TaH6s7te10uvnLgDhUv7TzjDysPX3HgQvGpb9+Z5gXefOeCoiapfkXu/f0U0VXp+djJV92JFj5+TYLxWsTO5Sz57awtF93+qfs8HD0EFWALLdwq0PA3tJeGSJHGzDWrn13gBOT9Qb54OQClc08AudutMC6B22W3OdAZ/5feU8xSqHAdpcAXJ/CNjOgPMsYWQ6pXxwEhzsTL3vLKXY8NpR1igxrtee5YtT5L/cCyykXKtC48sNKyVkAHbg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(136003)(376002)(346002)(230922051799003)(64100799003)(1800799009)(186009)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(40460700003)(16526019)(336012)(1076003)(26005)(2616005)(426003)(6666004)(53546011)(36860700001)(47076005)(83380400001)(7406005)(44832011)(7416002)(41300700001)(5660300002)(8676002)(4326008)(2906002)(478600001)(8936002)(70586007)(54906003)(70206006)(6916009)(316002)(82740400003)(356005)(81166007)(86362001)(36756003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 15:22:10.0390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85fd791b-2960-4e09-dfcc-08dbce5baa83
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS3PEPF000099DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7524
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 05:14:38PM +0200, Paolo Bonzini wrote:
> On 10/16/23 17:12, Greg KH wrote:
> > On Mon, Oct 16, 2023 at 08:27:30AM -0500, Michael Roth wrote:
> > > From: Paolo Bonzini <pbonzini@redhat.com>
> > > 
> > > svm_recalc_instruction_intercepts() is always called at least once
> > > before the vCPU is started, so the setting or clearing of the RDTSCP
> > > intercept can be dropped from the TSC_AUX virtualization support.
> > > 
> > > Extracted from a patch by Tom Lendacky.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > (cherry picked from commit e8d93d5d93f85949e7299be289c6e7e1154b2f78)
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >   arch/x86/kvm/svm/sev.c | 5 +----
> > >   1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > What stable tree(s) are you wanting this applied to (same for the others
> > in this series)?  It's already in the 6.1.56 release, and the Fixes tag
> > is for 5.19, so I don't see where it could be missing from?
> 
> I tink it's missing in the (destined for 6.7) tree that Michael is basing
> this series on, so he's cherry picking it from Linus's tree.

Yes, this and PATCH #2 are both prereqs that have already been applied
upstream, and are only being included in this series because they are
preqs for PATCH #3 which is new. Sorry for any confusion.

-Mike

> 
> Paolo
> 
