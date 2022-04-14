Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3706C500557
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 07:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbiDNFOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 01:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiDNFOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 01:14:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF730BBD;
        Wed, 13 Apr 2022 22:12:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c03G6c6EjypV2OToi6R0KiKdGpQ3gKW4d+fOhK++UTNPfWLimQVFVkGsS4Zm0GO3ZrEWolZOaubTMnr7no4wAJFx820pujvxoU0u7TteU4pfAcmbr9tMmAjLzV51USQTJmHlyglqK2FHTWopD3iU7hf/2m9HdlVRnhlI6RQb3tvCMA6E6rirlJD4jqiItrW3Jv1aYjt3Xsmaw/xRLK2t4X6nIzqdkxK74xGHBMgcPBdvLC7w+jU4G5SPb4+b2J868wCTWUOVB09UAdsAxczxs2BQeqLvfnuFrxRgqTmbxRZrnGjM5z9JV3btUXXGi7Ie90hW/5seLl2vkW+VUxl02A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tR2W1hChd1rU51Y++dsTOafcCSGsX9eadmo9n3Q3ke0=;
 b=oIW+bMxcTNFeuCslEZi5OCPHceYJ+S3AaRrMqm4Co4hiUuS3F+BGS5CFm9e6bkpqOuPEkwawXpV9dIaLxFYpqkapkW+NJzDKzVGsWV7SUtE+66o7o3U7Gp4jrRqHhqnTL6qAKsiVURjO9UdrBhZfU4yYBxhESn33brZiXrbiChB51Un8gc4vtbvbsoweCZZpOUUKsV9hqRzL1y89OWWSWF1n4fCgWtzG860mp94uso83JDnValgkwVTT8ViPUtKX9VcG+tlUwfkof+qIkXgJmOolmSJDjtm4yvRwGKq3fojNE5mgFbfqEr3F2zm9xZ6xW10fr9Wwqtz04lqZZ9891A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tR2W1hChd1rU51Y++dsTOafcCSGsX9eadmo9n3Q3ke0=;
 b=mlyDH/rzxuoXWyvUfKAYAAwVqqCF6y/D7MZ+c/49QOYazShS8N+KEObtFBnYPb8aCSFRS4FvjMIv1fP6yfuoa9Up2PVK0dCQgutXm1AXmZ+9NJfuxuIKu7Q1kMD8VEWSOUoMO8FxDKtpoBMendhkjikwW2r19dbQ1IPCf5cHU+k=
Received: from MW3PR06CA0017.namprd06.prod.outlook.com (2603:10b6:303:2a::22)
 by MN0PR12MB5739.namprd12.prod.outlook.com (2603:10b6:208:372::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 05:12:08 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::80) by MW3PR06CA0017.outlook.office365.com
 (2603:10b6:303:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30 via Frontend
 Transport; Thu, 14 Apr 2022 05:12:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 05:12:07 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 14 Apr
 2022 00:12:06 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/2] KVM: SVM: Optimize AVIC incomplete IPI #vmexit handling
Date:   Thu, 14 Apr 2022 00:11:49 -0500
Message-ID: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4053e6af-1fd0-4cae-5f5d-08da1dd552dd
X-MS-TrafficTypeDiagnostic: MN0PR12MB5739:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB573920F7A5A245198803C1A3F3EF9@MN0PR12MB5739.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TfUhX6caPyd5dfq4vICDwDamvW8vGwYZ4OATamJue0Di7BB5JnviLpdG5xd9wETbSPb17k/ynVHOhkRkphA3XPg1Uz6Pq6VqOlMTo++rx7EmOIRz6ZREjO8tlCXhzTzjsJbDNi6/bdLSSukIhDB1KGZZMJRXCnZzB+Pap17v8vp6RxJULV2CMKuE3Zmgi7CF5pjt5mjUtIHpYlQrI/U6NYTndWo3NSIJb9oWkaL6xRdQhsoKh0fUk6uc1Tf/MrCDBecbIWG5nOLj21qAL/PgPb+4J1Ff67LKkm8gPHvSL2lxnhZx+fZqVYUkRTeoBq8DhIwN4cuvzyTub83ghLQEIBFwPGtSAIF6mRHGgql3Ubnw6c/A9F3Z1oRf1689C3aRtZCLiy/yehkxPnujuR05QnaN/XdvE2GPlif529rvMvOSkFzq4D5zl51Zq0FcmMVhOrbNkM+73sXBSP+oBCsaj8HnTHB7ndXPLsxk78c5OZhUHK0XUyBV+2JHcLAh0wjgp+SToBrHkEWw9C9/XgU+S/pFDMVMaiqWNDehQchh2ZI4E+tNFEi0jrHInFCmixbpBupWO8e5FmpVzXtnjOCRWLL+0FUSoMfe5ES2zIpp+pxDWHlC03uhddoHlFH3PGvH9tTEBsiYbXMSSf/1X+u+pvO6fCOMe5OvMq49vFJhQn0GbWLoyv9xAnKaueCiUIlYdCRhhW+7dXpIGmu15GfMwcaQzCjGHitSWC+q+36xKEvsIOGXuNZXqNtvTt4TwJoJiyquIeM8bG8/7jYgfZovoiK1if3VC60LUKd3Nc7mH+E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(356005)(86362001)(5660300002)(81166007)(4744005)(44832011)(8936002)(6666004)(26005)(2616005)(2906002)(40460700003)(83380400001)(316002)(47076005)(1076003)(7696005)(426003)(16526019)(186003)(336012)(110136005)(54906003)(36860700001)(70206006)(70586007)(8676002)(4326008)(82310400005)(508600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 05:12:07.9950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4053e6af-1fd0-4cae-5f5d-08da1dd552dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduce a fast-path when handling AVIC incomplete IPI #vmexit
for AVIC and x2AVIC, and introduce a new tracepoint for the slow-path
processing.

Please note that the prereq of this series is:
  [PATCH v2 00/12] Introducing AMD x2APIC Virtualization (x2AVIC) support
  (https://lore.kernel.org/lkml/20220412115822.14351-2-suravee.suthikulpanit@amd.com/T/)

Regards,
Suravee

Suravee Suthikulpanit (2):
  KVM: SVM: Introduce avic_kick_target_vcpus_fast()
  KVM: SVM: Introduce trace point for the slow-path of
    avic_kic_target_vcpus

 arch/x86/kvm/svm/avic.c | 93 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/trace.h    | 20 +++++++++
 arch/x86/kvm/x86.c      |  1 +
 3 files changed, 110 insertions(+), 4 deletions(-)

-- 
2.25.1

