Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B89744423
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 23:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjF3V5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 17:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjF3V5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 17:57:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BCEA2;
        Fri, 30 Jun 2023 14:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfYjU94Cnp06BXBw5UiRvIRCry8BPZEoYJOfUqeLOmPcov+IzIIzh6FfdcywTlQojkBFfPrNTPKhz6MhmdMHOAE5IdOQussuo5qf1xPyo1zr2R63Sr0QDq+65564dYVyu6rMWwTQmIKgFwo2mHq6dvU1x8SkbhIao/BsZFYHamzpC0M2jBwTYc9YZdalYsrfSs/MnnWxbp3gX1+Fxsso4GdkMImp7rhYwDp0YLa0q+D069m9HbRltQkQAmca7OpbKE7FVdQeuwcBtPiPR9piOQ+mzk0KvYb+9/lVw9Bg2Q1absC2sgz26R9Ojs8qINdQbwjEmSChDzIz9lGoxkCldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+iP/yKKjl5mdIjpVbAtOLYWO3fTzTwcqvi2QUrxpywA=;
 b=NL5WNRrNrPN/ZgOw2kvgxt2ScqjJE9T70CIt44UpTkUISi+AJNM3Pw2rY8Xb3/Pyu6DuVeu6nRX0hzjv7/Z0I3NasLMPL8afi+hdQgwsygv05CHdkD0GDgKJJOU8Uwjw332jP7QmJKkBAeKzlm1ZNwRO2YJ6ifzk+10K7/i3HHrHQ+N6b44J0Y8ukLc7UtLawazzm0MpU6HLSuVTXC0S6dfXpgRdnhjQm3cm0SwVNq7aMzR3v7gWfscumoW5x89utGdtVoGfIHuSKSuqXCDWdWclNg2O/GG1XGHoT3y2XQDGman01wkm1/u3bVh/MIOTtzZCI5DuFQ3xxByPVh/suQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iP/yKKjl5mdIjpVbAtOLYWO3fTzTwcqvi2QUrxpywA=;
 b=aorNiie7NFRWzpxynbEUyhNvR8XyDo9C/1bNYcN8A02dXHJcoSJ29Dnnditld1YyKDTRCVQxB8p8xfO/iX8+oDv8uqTWZQXWn4v4YQldY1/uZtkzNVUyPBRX8WFB11Qsesli7xIzw/Ja0Rs06mpEivYK/y/bz0w+DjdixyT5jQU=
Received: from SJ0PR13CA0084.namprd13.prod.outlook.com (2603:10b6:a03:2c4::29)
 by BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 21:57:31 +0000
Received: from DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:2c4:cafe::7b) by SJ0PR13CA0084.outlook.office365.com
 (2603:10b6:a03:2c4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.10 via Frontend
 Transport; Fri, 30 Jun 2023 21:57:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT078.mail.protection.outlook.com (10.13.173.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.43 via Frontend Transport; Fri, 30 Jun 2023 21:57:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 30 Jun
 2023 16:57:29 -0500
Date:   Thu, 29 Jun 2023 16:02:04 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH RFC v9 05/51] x86/coco: move CONFIG_HAS_CC_PLATFORM check
 down into coco/Makefile
Message-ID: <20230629210204.tknoh7p3hw45jcp4@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-6-michael.roth@amd.com>
 <20230620120920.GAZJGW8B6XHrsoLGCJ@fat_crate.local>
 <20230620204315.xr7wtcrowc7oprka@amd.com>
 <20230621085400.GDZJK6qMeOU2monJDv@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230621085400.GDZJK6qMeOU2monJDv@fat_crate.local>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT078:EE_|BL1PR12MB5062:EE_
X-MS-Office365-Filtering-Correlation-Id: f0427086-2cf8-440e-9a14-08db79b4fff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2sMGfiNIQZezfcZ+PMzMdNlgxoADlvJl2Lni3o1m/an0dVjtH/TvzKf9pgnnM8aK6EchpUcimIfT2GE4BKWCWXtWXwFyo2sffHuQE3pb+0HkGQZTo3mzfAvqbymOFNjolh/RVms2Dpqy2IDA48n4Ex6zXSE/7SaC9s/Nkm2k4eWrl7Ix5Wg9MDX2oAZzTu0TrUqA4KtdOqXIMF3qC4akTccxbif13LtRYO5hFgBCv00wqukWGUa236DlYiMFPF11/uncY1906z+1xSsbyj1PzjlIm1PRqeBzUIQ1FPUwsx6TP1UTBPV3TGlbfmr0WCTImzbAC67/Pe1FUqNyP//zlHOev+Y8RPuGJn7fDwJ5vuQZJXXX8EfiyeMlZmPIK86zodgAcVm0lWAIGAN76Q3CB9F4yhRvDPKgdCaT5FyyW93XPuRKevfGgNw4iP3eT6NyVa38aczMQd1gHKKCMDudRz6ZEU69vjQqoJY/sf+bHWfI7sXUxyq2BUBvOQuslkSMbaJRApASVvuDgF1QHx2UukzzYoRj4ZKKZfnS1VkiZl7YPO+o++dx74NCx6zqFPWOWLG2OETx7fWRgSKOI/+MiVJTb8fDf0xviQVU1IGOafN2/TiVStiB31XL3kNTCC6C/ikEqbwkpubXChwN/VPK3g8gPoxISeKUtYlOos6DDITkZaE4c3z+sMtjTX/TzA4PEb/o1ZmUR5Yjo2G54u4eHcsVSWRm7HNRWkdCZK3P//9LuCr9/ir5EK3WJvgS1wy7Sb0jUPW+VCQtmd2gzqQqdTI4/oi/oFoOADdLiMDDpqs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199021)(40470700004)(46966006)(36840700001)(336012)(426003)(47076005)(40460700003)(2616005)(2906002)(81166007)(356005)(82740400003)(36860700001)(40480700001)(36756003)(8936002)(8676002)(82310400005)(5660300002)(86362001)(54906003)(966005)(41300700001)(6916009)(4326008)(70206006)(70586007)(6666004)(316002)(478600001)(16526019)(186003)(44832011)(1076003)(7406005)(7416002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 21:57:29.7373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0427086-2cf8-440e-9a14-08db79b4fff1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5062
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 21, 2023 at 10:54:00AM +0200, Borislav Petkov wrote:
> On Tue, Jun 20, 2023 at 03:43:15PM -0500, Michael Roth wrote:
> > Basically, arch/x86/coco/Makefile is never processed if arch/x86/Kbuild
> > indicates that CONFIG_HAS_CC_PLATFORM is not set. So if we want to have
> > stuff in arch/x86/coco/Makefile that build for !CONFIG_HAS_CC_PLATFORM,
> > like SNP host support, which does not rely on CONFIG_HAS_CC_PLATFORM
> > being set, that check needs to be moved down into arch/x86/coco/Makefile.
> 
> Ok, so if you put SNP host support into arch/x86/virt/svm/sev.c, that
> should work too and won't have any relation to CONFIG_HAS_CC_PLATFORM,
> right?

Right, that works out just as well, and ends up being a bit more
straightforward. I have it implemented here:

  https://github.com/mdroth/linux/commits/snp-host-latest-v9b

  https://github.com/mdroth/linux/commit/a889a2dd64b62d9c3bf74cf02e7d8d71c7061667

and dropped the patch that reworks arch/x86/coco/Makefile.

Thanks,

Mike

> 
> The CC_PLATFORM thing is a way to check for confidential computing guest
> features by abstracting the capabilities so that you don't have to check
> *each* and *every* conf guest type in the conditionals and thus go nuts.
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
