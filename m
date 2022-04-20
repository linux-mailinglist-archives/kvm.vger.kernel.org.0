Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB23F508C6F
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380324AbiDTPxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 11:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380211AbiDTPxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 11:53:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7127533359;
        Wed, 20 Apr 2022 08:50:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ko7z4hqRZ2PDBslnE0szOmQMy+bFSVQCxAbCbPnO4MVA+9kIVDFjwlZZ+PwsVauKd0Xdxe+9/N05QE/Y4aIgS5mvmR4khaBcVpPtwOQJX9TEEAgrzcOGjKzKaN3NvYagXwwrCvb7qf99t+cmZWLefZ3rArc/mgVUqDeN6jaxObDJQQLhemb72Y1OBci4lc60j+RGDLm1+Y5aezUuF5+v7XyEQg975NsX4kB5V4DqBIDgau06uyM9SIdIG4Rgjs1/vyrcY4BfAil+BEsf8nRHSF8M4/UxpkIalaBAoI89JF5o36RWTisKWzf/lrbgIuzrgicQNfxUn+5Ff6vgmlhk7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vERCj8v9Zj2m8Wx79KdPwqjV0jMHyaOPSvheCrJ9/bY=;
 b=VqfpIWtgSk63QTOZTRNsBJTFi508MDUavW3j1xZVrqOz0wMTEpVoKhB51RvD1vcDfZAHwgym7bc9SCQy51jMsJILeEs/qKZh+BUJ2MDmfa3nPheBpE8KP4JXYzvo0bWZkSJMVgQb+qvmMIjeDJty1ZW8uK2zOnnK4FjphF3ebcnM2S9dOj4wwKavbkT2EWS1jrruard1x4hsP4GZnaLFL9TK588ZLwuN9ohGIBVGVa3hx9zySCvWoecJ6Tv4PT9dIAEQoebGaoo4tJUDHSnBkg+d/VB9s3gS4+XJAC49J41p5O3KLbSFlCkY2SGWpYT43xW878SKSlOL+8/nhNryKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vERCj8v9Zj2m8Wx79KdPwqjV0jMHyaOPSvheCrJ9/bY=;
 b=gF+csGeem+0qb0317GgR9mnDIea3c0BIFvuYxqwUAswrM4B/apJSjt7XWI7Ccno/BwpnTXee3xxlkHdr4iw+YBeI2mV1zWUnawREOLCWw8cvW0gnMsU4sc5JoL8koZRiKKpvyD2t6rFyIX8Nb+zUSfCE/oP7osvSkdgtiDqx1iM=
Received: from MW4PR03CA0062.namprd03.prod.outlook.com (2603:10b6:303:b6::7)
 by BY5PR12MB4869.namprd12.prod.outlook.com (2603:10b6:a03:1d9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 20 Apr
 2022 15:50:17 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::a3) by MW4PR03CA0062.outlook.office365.com
 (2603:10b6:303:b6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Wed, 20 Apr 2022 15:50:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Wed, 20 Apr 2022 15:50:16 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Apr
 2022 10:50:13 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH V2 0/2] KVM: SVM: Optimize AVIC incomplete IPI #vmexit handling
Date:   Wed, 20 Apr 2022 10:49:52 -0500
Message-ID: <20220420154954.19305-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d945a9aa-1a22-49f5-e51d-08da22e5775b
X-MS-TrafficTypeDiagnostic: BY5PR12MB4869:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4869706227CE71EA942899A9F3F59@BY5PR12MB4869.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WuDfBaq56oYOq2qac/G6tPkiAn/zBAgxUI8YcJR1Yux8SItvQpG9uxulKnsH1ZzdLeF0j7pIh1KN9WSLP042JTVtpTvPjL2o/MQrDnEbqHW+aMHWiAf0rlpwKoXCRU/PzniQ1DPhE7k6CpSiKst7VeMNGyYSQbbvv8YwY1oFeXH5OSJbU1gKeZm5O3tqjOXRc5rRjFJSudS9JuWLrCvdyrW3FMrjLtS0wKe845Ib+C5Ar/LzlKOYrVqRV7E5lNWKqW3DEtqAdApqBHyJxbFF8p4eNP3vg9NTNSzOBFsXs090eS8ZJ2PyfN/051VMSGHOH16BpZDA31QAQHhJ3SEUNzV/uAxdA07GcxdmQhgwx1+ijkT7iwAD7Vh8lNLfSDAmQmaBrYkafO1MXJbt5ScE/q8aVXCDIep81ZnUkqri4ammHQAz+BlqP6Lxp6enGdFFyOSNYxlgM6PZXk3tSu9nXiH++ngFcnfb0i+oHkYSVirpZc9tzq5VzBZup5gLINFBLRplK342+DKS87WpWBp0xvPRz+w+8OIBHJbNBYbfrXN8+zhQadJCEiVK+fOEimN1XPX+d9XcztEB+jKy/OQqV9ga+s+ypRCHvJXqEy9tDVIpKU7nF4HeKa/QkyK77Ryvndx4RQXD5lgLiGks4+cmbsQCdzYCJ2aBlzh3S+Fg0GB1U2GKd2/7jZ5qtjOp4FykuQf3RIuir94v6kAx0LD4e0S9ICTVLNHWKeHWuA/bRmXS5+hpHfAga0ShtA5XQK5VUZoELzXgLEPtdUPTvflLCX6SPzKbMLWt1JWmMcCZpbc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8936002)(508600001)(36860700001)(86362001)(356005)(40460700003)(110136005)(316002)(83380400001)(7696005)(336012)(47076005)(426003)(36756003)(54906003)(44832011)(70586007)(81166007)(4744005)(26005)(2906002)(70206006)(186003)(4326008)(1076003)(16526019)(5660300002)(2616005)(82310400005)(6666004)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:50:16.9994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d945a9aa-1a22-49f5-e51d-08da22e5775b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4869
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduce a fast-path when handling AVIC incomplete IPI #vmexit
for AVIC, and introduce a new tracepoint for the slow-path processing.

Regards,
Suravee

Change from v1: (https://lore.kernel.org/lkml/20220414051151.77710-1-suravee.suthikulpanit@amd.com/T/)
 * Rebased on top of Linux 5.18-rc3
 * Patch 1/2:
    - Update commit shortlog to be more meaningful
    - Refactor to remove x2AVIC related logic for now, which will be included
      in the x2AVIC patch series.

Suravee Suthikulpanit (2):
  KVM: SVM: Use target APIC ID to complete AVIC IRQs when possible
  KVM: SVM: Introduce trace point for the slow-path of
    avic_kic_target_vcpus

 arch/x86/kvm/svm/avic.c | 74 ++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/trace.h    | 20 +++++++++++
 arch/x86/kvm/x86.c      |  1 +
 3 files changed, 91 insertions(+), 4 deletions(-)

-- 
2.25.1

