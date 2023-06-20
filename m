Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0415737640
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 22:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjFTUnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 16:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjFTUnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 16:43:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C93125;
        Tue, 20 Jun 2023 13:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9JADzDuirTzkC7AgMIjHRP6cy7Z5w3Hx1DTHJCWQV/VAGpTUQQZt5clWExcyzOGq2r0BAYMv/WBJflVnFoKgIArqocrrqC+sljNgnhrTQl1Kxx0SbF0o5dQT1fEBG5nrFYUlF729fCOyM+9Y4j67GL8JpCi2VTuSd/U76qswMOqpACPt3m22Y+WjfbSh/vhs0Nt3J2zPr2RQBm/5XuzD9wd+F9qntnu5dT2xY5LJ+YkAg70IKihcTmLrTGTyaMIMSqzMOFxoLuEWAl4cUOKVQRYw1I2a9JcIogUZWldw8fJt5DgWcxF+lCcby0Mwu4BxVYbuUy1R4eVljG7nC6a9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwfQ/e8+tBEbHK2zEBAEbADi5TLtFWo+s3gGjkRKKUY=;
 b=CZ19TV+vtkmPAYGyLERQU3ZerlBV5v642q4T5pDd2BadMyqK7nmwez59uB88UFe4nrODlPf2k9oKnnEOcOoxBMR8G8h63OarVQdMSAAqzPmXcYa7uXv+DKwXOaqOmbE8IMsGAQbQZvu6KkbXcZwNO+CINh6TLBKzgqF81F1peDaPVQ/Q1esgsjSEgt685k4OvMObLTUwb2JlwqaOwizP1cid/tsBLr76TeMP3+04gsMx2o8Go9Ibb7EOahP3Rez95a5oiJDaSLi5cE+BoScyb3pFnn/4OYCLVJ6uQGEawZIVt+0PieQY99RLMcaR4wt5RsoyAjJzR7+6uVE+rDuEvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwfQ/e8+tBEbHK2zEBAEbADi5TLtFWo+s3gGjkRKKUY=;
 b=jOrhUkERAcvHTz2Moeq6j7MsBildnvfoh/4jkvYd414kZQqni5OVCBmfnZ9LUVL39ABaifGDt2VYnrcBu4QuVWv5In4+gSynzByjztLUJy7btXeDyx9TUbJt/6fVPdJn5q5wrBk+1jSudmrtVvcyWL2YOqBgfTKkoYNU4qbEemo=
Received: from SA1P222CA0179.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::9)
 by BY5PR12MB4999.namprd12.prod.outlook.com (2603:10b6:a03:1da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 20:43:30 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:3c4:cafe::f1) by SA1P222CA0179.outlook.office365.com
 (2603:10b6:806:3c4::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.45 via Frontend
 Transport; Tue, 20 Jun 2023 20:43:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.17 via Frontend Transport; Tue, 20 Jun 2023 20:43:30 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 20 Jun
 2023 15:43:29 -0500
Date:   Tue, 20 Jun 2023 15:43:15 -0500
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
Message-ID: <20230620204315.xr7wtcrowc7oprka@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-6-michael.roth@amd.com>
 <20230620120920.GAZJGW8B6XHrsoLGCJ@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230620120920.GAZJGW8B6XHrsoLGCJ@fat_crate.local>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|BY5PR12MB4999:EE_
X-MS-Office365-Filtering-Correlation-Id: ba0eb223-25c3-4014-2738-08db71cf0182
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFJwbo8fmV8FuP8nhC59bSKnyQVLXUBBKPXdnrooa+wPHLQOm4bb0v4M8gJZT0DlwjyrqgtsLJLpk6U8aM5X1gGG9Sa4QvX52bwCXgFnyOHZxHAVCOIgzAFOL4gZJVqRxSVJnDSKsQIEByZDihILWfyR/zgJiyfTbxd+Yn1Mcb+M67vPWQLDJgOTWskdY4+r9TLGqP5P8wlUe0pKWyIRKZ6hxR6u8ySn8UHPHcg1WPiiWd9Lkp/4pTikrtfcjZ8nzkBMrskYeoNEKAyHvSE1W3/nbYxoHFjAEYsU+jngGVZvZ9a8d/cA9BEN7+wygiAGeLj3sLZfiKWCW2npqZuTiZCLePis/84qi1ALSi7i7DhZn964ciXbFwwIVXIRdZpAnOeeGx61gAiZhbb2Bqv7jvHRu9NXv+zrASFsBB1ahdVjrP6BFalbzYro56r/RzBCMA6oMqqD4J7VXAq6YOWM6nfXSfJQN9MIDuNtwD/+X66orc6LFzuRzOSvgThor5SrMnLJHxI+Pd1D6OpbsE5HJF5AroMJi+bKbmtpu5qTc7ReYue8AkFOto1kjFWAeKz9RtJn04Hgb+ZhjOTMdlxKy79iP70JkBFO7XcyQkJKnrr9cjqm+eOjh2vV8ttdvi1oroFXh8mXU6dmDRaiwNGW8KAAgpof8NKpkU142AhbWCe4oK97MQx6WYzPnIvBnQCxHwlqnyrZw07Eiog0rz33tT8931VmsOsftTS6TcWQQbksVJDGpMu2y+ejDVkp3wzcpu7eW/LNMwTpq+vUvDvcE0kz1PqtUNWfruJLEh2GJBk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(478600001)(186003)(16526019)(966005)(6666004)(47076005)(86362001)(26005)(1076003)(54906003)(2616005)(316002)(336012)(426003)(82740400003)(70206006)(81166007)(6916009)(70586007)(4326008)(356005)(36860700001)(8936002)(5660300002)(7416002)(44832011)(7406005)(2906002)(40460700003)(8676002)(41300700001)(36756003)(40480700001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 20:43:30.0064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0eb223-25c3-4014-2738-08db71cf0182
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4999
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

On Tue, Jun 20, 2023 at 02:09:20PM +0200, Borislav Petkov wrote:
> On Sun, Jun 11, 2023 at 11:25:13PM -0500, Michael Roth wrote:
> > Currently CONFIG_HAS_CC_PLATFORM is a prereq for building anything in
> 					^^^^^^
> 
> Use proper english words pls.
> 
> > arch/x86/coco, but that is generally only applicable for guest support.
> > 
> > For SEV-SNP, helpers related purely to host support will also live in
> > arch/x86/coco. To allow for CoCo-related host support code in
> > arch/x86/coco, move that check down into the Makefile and check for it
> > specifically when needed.
> 
> I have no clue what that means. Example?

Basically, arch/x86/coco/Makefile is never processed if arch/x86/Kbuild
indicates that CONFIG_HAS_CC_PLATFORM is not set. So if we want to have
stuff in arch/x86/coco/Makefile that build for !CONFIG_HAS_CC_PLATFORM,
like SNP host support, which does not rely on CONFIG_HAS_CC_PLATFORM
being set, that check needs to be moved down into arch/x86/coco/Makefile.

> 
> The last time we talked about paths, we ended up agreeing on:
> 
> https://lore.kernel.org/all/Yg5nh1RknPRwIrb8@zn.tnic/
> 
> So your "helpers related purely to host support" should go to
> 
> arch/x86/virt/svm/sev*.c
> 
> And just to keep it simple, that should be
> 
> arch/x86/virt/svm/sev.c
> 
> and if there's real need to split that, we can do that later.

Ok, makes sense.

Thanks,

Mike

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
