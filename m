Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0B36606BC
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 19:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbjAFS5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 13:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbjAFS5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 13:57:13 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B80B7DE2A
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 10:57:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRO5mBlM1GYesnjY7WI21C4m40kdoUEuzqcvjCVuD2Yt+ZGAKjIVXwwp4zDZNFRMaHunsCrVYXs/D2yW3ifuvlUOjbkIiYOkPBtEFfu/4XViY4tfWobJn9/FYNDF38PDZL2lukpOLW14iGHiqn+KbOhoGFC35ZPgMeLTnauLSmQXqwAneDkNFJGE1bhmgI34ce4z0CuV560tsuDd+oXIAnTnT99/i+XfbWN8s9VM0Ch/fwcINcJ1NVSmFRP8KdnWwWq3FC6lq2zce+g/5FGM1YB0dURqVYBaD6x/fTr0I5GiaqAzvxbl4CwIAJ6LteyNvYz6u6TFAGuKl8ZTnZa/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxeFWfdcTzvbL95V3ndbqWNM/dSi9uWoJb7MwTbTc84=;
 b=mECJ9Irq+pIPheZLpwPGOIUeNorE4fPGPGnAngbr7xO2aycE22GpEguqzzrpki7p6UuLPJDYbQ3JCSKuDwz6/EaPpK1cSpbCCUNkQuYTHqTnOM+4gWM1310h60yN9ZfXVyvryc+kJx+mMiVFi/j2pIF7t6PNb7g8tjV+KHtPNSdEIthaGvhSkDqtCXRU55C9aLa36hukM2SRh7g/Wc/4r2uT+hAriftOLPwYA2EH+V29tygeHf3qYRu8NVFIfEQs2MQpiJkx7Iodd+pAoelxkty23bpOQ/8O4klKqevyrvNT8ABf/x7IZjyL1Flxl4p1d899N9C5Zv3KB/jvUtvJDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxeFWfdcTzvbL95V3ndbqWNM/dSi9uWoJb7MwTbTc84=;
 b=rYCkvhPleN9XWbQLT49vbQHDMk26IZSvZK7aOt7KMaRXNCDVPRdjsNogwwiafrZGbrCTmCm0NkeCwR0t4zc2CrJu48a2uDB1iXEUEfcVA7/q5O21kNFF707s60rUWT4mi8GdlEOL51kN/x2jZo7eXsJNyrA8GtYZlbmpXk00Zr4=
Received: from MN2PR08CA0005.namprd08.prod.outlook.com (2603:10b6:208:239::10)
 by CY8PR12MB7659.namprd12.prod.outlook.com (2603:10b6:930:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 18:57:08 +0000
Received: from BL02EPF00010208.namprd05.prod.outlook.com
 (2603:10b6:208:239:cafe::11) by MN2PR08CA0005.outlook.office365.com
 (2603:10b6:208:239::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 18:57:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010208.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.15 via Frontend Transport; Fri, 6 Jan 2023 18:57:08 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 6 Jan
 2023 12:57:06 -0600
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>
Subject: [PATCH v2 0/5] target/i386: Update AMD EPYC CPU Models
Date:   Fri, 6 Jan 2023 12:56:55 -0600
Message-ID: <20230106185700.28744-1-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010208:EE_|CY8PR12MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: 56f23f81-f6fd-43cc-5965-08daf017cf73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ub+sIbxAYmml6DcmLXXJuhZqLlmLtZQTgVlTMCFdXqh/B+C6GMo8PaZpGlzvIhYBofKPVBNH3sebwXEJwfgl1424PmLj2Ukyp5s7rYM5Emnuy1qUh1HBLz1P33X/1NAxhbzdDesBB3G0FjXKWwj+aQLS3IFcXcGktW3tegqjisOTskTm9dIN02LZ7pwVWwMkuFDDpCdIzFCZTOhuTgnPxKgIohUlH7KMeO+N75bFKYlK66Gylr42bHAo3acKF7hXypQwrJ6LO2AWd/I2VaIhOJ7r0z+0F+nTd8iREliIL0aZ1khtRjJqvTF1xiaX46vu1/zw1msXSLBtAhm+7iUOduyfXrAXE26ODVW5r0y8titg+gz5F+jxSaTsIrT0eh5VhNvr54K1V8LJfdkmg1s7AEjrAea14WHkAJ1mj+ZeAitlocK94b4LV8xuQ/kwDxFy4E2vMtB+docbqPvTfGNfthjFjex3ytJKMEsRbOXSV+Y0btzl+6x5l8LsKkfNV+/GwJmwtmctOGubJawCmkFRyAEnZaFz9t4Lp5iNeiX+VzJsSq9xFPwRaw2aDbKQvHktpZ4uPhPIroHguopBVHsHhBUNec4QeB4A8Fo1mtCrsBWs2Opw8yeO71r3wuGnqvl03Fq7p51oxdUUQe98XRc4gCgRAuaV9JIyIOSEuSubJQH1gWJNJBFIsDX5titY7+9lsXLaud5hKWdhDYsQxu48uQxfnnc5oZIwKZCWiGxHsGvR9coWCTlg1YvO5/q/Txi7r4oWpEc8qm4yOQpNYaqD9/x5fHj110KLBGStw4nX99ndmNv9rXvIi7ygqWTqjZMPJNPZyw8MgPM8jpQawZRVbg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(7416002)(2906002)(5660300002)(44832011)(8676002)(41300700001)(4326008)(15650500001)(8936002)(70586007)(70206006)(6916009)(54906003)(966005)(316002)(478600001)(82310400005)(26005)(186003)(16526019)(7696005)(336012)(6666004)(40480700001)(426003)(47076005)(83380400001)(2616005)(40460700003)(81166007)(356005)(82740400003)(1076003)(86362001)(36756003)(36860700001)(170073001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:57:08.0922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f23f81-f6fd-43cc-5965-08daf017cf73
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds following changes.
a. Allow versioned CPUs to specify new cache_info pointers.
b. Add EPYC-v4, EPYC-Rome-v3 and EPYC-Milan-v2 fixing the
   cache_info.complex_indexing.
c. Introduce EPYC-Milan-v2 by adding few missing feature bits.
---
v2:
  Refreshed the patches on top of latest master.
  Changed the feature NULL_SELECT_CLEARS_BASE to NULL_SEL_CLR_BASE to
  match the kernel name.
  https://lore.kernel.org/kvm/20221205233235.622491-3-kim.phillips@amd.com/

v1: https://lore.kernel.org/kvm/167001034454.62456.7111414518087569436.stgit@bmoger-ubuntu/


Babu Moger (3):
  target/i386: Add a couple of feature bits in 8000_0008_EBX
  target/i386: Add feature bits for CPUID_Fn80000021_EAX
  target/i386: Add missing feature bits in EPYC-Milan model

Michael Roth (2):
  target/i386: allow versioned CPUs to specify new cache_info
  target/i386: Add new EPYC CPU versions with updated cache_info

 target/i386/cpu.c | 252 +++++++++++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.h |  12 +++
 2 files changed, 259 insertions(+), 5 deletions(-)

-- 
2.34.1

