Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E273F737621
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 22:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjFTUgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 16:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjFTUgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 16:36:24 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA913F1;
        Tue, 20 Jun 2023 13:36:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2ke0oviZ9OFHDBer2ilcitzsId2dT1KwocA7CGfjFY1xecxfy3M/4HhvpwXP6bhuI/gg2JVTq02ILKrGB3ZQ76AWk+uZs1dN8neXv14AGDbJqcZOmfsb11La05QXPiAcbXmleb5k+CWbJADE+BqLXRMZaw6MHCcORFxDB6E0sK0yTbuEyIFvyjYuwzXKd7pJdsse0TbXNm3PjMnbCW9ariIVRCq4B9AupCfaHDOZSYcWdTwA7mHSWoU5kxpEkJil1BuUOu51KfLYbRXayxNQL13aGHKOa0XJn7/6zOzYNXxCaU/816X8+srfA0jQZgFWuAwZ3+LsViPETi6VW5btg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cD6G5gycf+cT4vh+ZgSuc7hnJwtzwkznW8RVmQT+8l0=;
 b=Redxj5rYCo/uWDlm9qM8vPiqsGbKIE0TDV7rsbepVHmkRC/RLQ+qXCMOU4djsvi255fIA2wHcEb6eAP08Q2D2lwFw3YNnCU7ZTeG3gJhsiHdbbTV2ddWXi5yL4720pT/uUsH+10kzv0mmTj65atoKhcoltKedGSqfSY7L8ghYNFjARNuD0e+uTflSsM2g5Ls5jKu8R+ZNkNKgCwCnPNzXG/p0XP/SzePOrgy50D7b7GJbiR3GOOKm3wfaf2JUlLR4EP40ajcOFTLmvodAv9yJwawFKZW57gdCvHJywaMXVUqqJOUhVpo9mCLrpd5Q1JexFmi/7UgBjJMxacU2nfsRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cD6G5gycf+cT4vh+ZgSuc7hnJwtzwkznW8RVmQT+8l0=;
 b=trezN5WvTPn8vLqDbuhdNnYC1RzKCF/zKT6jGvGTUYeh+g/JYqEJhk9kyneHZuANK76Qvcf3Kfx741zHo1hVLG+VWG7jjC1xL7Rqim+JwfyHnkvZt+QlTzwHGuHUtwyebmiFPXKdhgkE1xbHOzVzK8DHxVAsGk8KXiMwAwK4rZA=
Received: from SJ0PR13CA0081.namprd13.prod.outlook.com (2603:10b6:a03:2c4::26)
 by BY5PR12MB4324.namprd12.prod.outlook.com (2603:10b6:a03:209::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Tue, 20 Jun
 2023 20:36:20 +0000
Received: from MWH0EPF000971E7.namprd02.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::78) by SJ0PR13CA0081.outlook.office365.com
 (2603:10b6:a03:2c4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 20:36:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E7.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.19 via Frontend Transport; Tue, 20 Jun 2023 20:36:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 20 Jun
 2023 15:36:17 -0500
Date:   Tue, 20 Jun 2023 15:36:00 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
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
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Message-ID: <20230620203600.esoqyoumxb5n3snd@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-5-michael.roth@amd.com>
 <20230619162703.GRZJCB10+Xg8fn8XLx@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230619162703.GRZJCB10+Xg8fn8XLx@fat_crate.local>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E7:EE_|BY5PR12MB4324:EE_
X-MS-Office365-Filtering-Correlation-Id: 482f99a3-d210-49dd-a0c5-08db71ce00a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKgOgY5pOCuu1FEPZ1mak3GsqE1wyr1dhROwsP+T5Js+sT7azQYpQXMfAJuXpjWAel9WaRLuXJd35b36dSeVIYspUAm78NWRRI4dCbuCKCV/zLDNn9XS2a4OkjGdIiRgEwNFBCrW0cSYVJ0fWWxRYPmStV+dMBu+NiStBNYwbVGXMTR0+POm5JGThQzB2JqIyMHsHPRhoB8dkI+e48Na6Cos/wx5v2RCtPjPtxNnX1+QVNh6KbvYZQKA610AT8h23fvK2xyt7kDATu5UnSWDnS0Jm83AfIXQUjHwFHz2FFp0O3A8fi3GdJxzrcIU0ov2HUoAwvTl96MKwnl9Lh/pzxVrkfclRutf1P6IPLbjvsF+YeyuLaRbRPS1NGGdi+vGLxzTPDdsi477+AVd1lJHITMDhWOHnpjHYL7geSb9vR1cAnYDU/nM5g28m42GbM5pck57HemH5nM19thgUj6YjqsLRXOC40AByPRaNvKa25w0xuBk4wHO47BL5KZsRGVdUiybsGo01MOvyXvBY+VKQVSPurRJD8Ugi3ejK1CZPEOBSsLNbHOCdfsZe8AxDl3FFYpxvgcUnpIQ1FL8JCo/ZSe4nq8PL6qHtrjrgpNw73PJR3UUSk3Wp6HIGfuv9jcYZXgjQKnrWp/j1PjEaaMV+8gIIFrcYK71An3E0XoOEf4eMu48IiElF95UiMHr81PPtmBen4Z0rZnmpEFisrVJHOimuExnum1HPnCEhP7SuF7/Qkrnxc6IvvT5AMVPaeCv2CE2xoEevx97UiM0/FD4SA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(966005)(6666004)(478600001)(47076005)(83380400001)(2616005)(16526019)(186003)(1076003)(36756003)(426003)(336012)(26005)(86362001)(82310400005)(82740400003)(356005)(81166007)(36860700001)(40480700001)(70586007)(70206006)(4326008)(6916009)(316002)(41300700001)(7406005)(7416002)(44832011)(2906002)(5660300002)(8936002)(8676002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 20:36:18.9288
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 482f99a3-d210-49dd-a0c5-08db71ce00a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000971E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4324
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 19, 2023 at 06:27:03PM +0200, Borislav Petkov wrote:
> On Sun, Jun 11, 2023 at 11:25:12PM -0500, Michael Roth wrote:
> > This will be used to determine whether or not an #NPF should be serviced
> > using a normal page vs. a guarded/gmem one.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  7 +++++++
> >  arch/x86/kvm/mmu/mmu_internal.h | 35 ++++++++++++++++++++++++++++++++-
> >  2 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index b3bd24f2a390..c26f76641121 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1445,6 +1445,13 @@ struct kvm_arch {
> >  	 */
> >  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> >  	struct kvm_mmu_memory_cache split_desc_cache;
> > +
> > +	/*
> > +	 * When set, used to determine whether a fault should be treated as
> 	   ^^^^^^^^
> 
> And when not set? Invalid?
> 
> I guess so, judging by the code below.

Yes, or more specifically, "When not set, treat the value set by
userspace via KVM_SET_MEMORY_ATTRIBUTES as the authority on whether to
treat a fault as private or not. In this case, KVM_EXIT_MEMORY_FAULT
events won't be generated, so there will never be a mismatch between
what hardware indicates via page fault flags vs. what software has
assigned via KVM_SET_MEMORY_ATTRIBUTES".

-Mike

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
