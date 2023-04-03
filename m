Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E616D3C09
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 05:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjDCDNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 23:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjDCDNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 23:13:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261B830E2
        for <kvm@vger.kernel.org>; Sun,  2 Apr 2023 20:13:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fO2+6Eav/8HbhKgR8QTmSR3TwUWGyetqxrAKJN8b+r+70epVTraQAb4mqo9AcF4IlISmwoe7kyyULz2b1Gb6kur4ez8L9YgMk5pTcYLJcnTez5roS3yk4Np8TISoVlBCsCq/qja8WJw/A0KjbFfmd/ydzpqbO2ohLsZl7Epajc31O87C1CZZ6bkluqvsrU13sGQnZ6sJs6MxQnIrUyfJv7RcAkUVr+H2UiXrYIwlkN6/VkMGLRCF3w3v/6T8lE5l3vtzOsg92DssPV1lenuqCULVlqgPBf0/7Hg2igr0DCT/LafDYD02Qlp4SsMaKQSKlt9mjZlnf2Hc861IeptJww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wy/sINq1UzDIWpmF5QWD+l+VOpForLdBvt0pGbqfCKs=;
 b=Gt2aVkeiaB5KPzvB4yNjbOfiROv6YGQ4bzau4gHq2Qp14WQX/r75odVWjNJsh8toZtQrxtP5RZzIT6+woZz6tuiGaUHFl6WHvbTJraD5ZbqNMCHgvUF48iRRHu57nFhP/wC3JKkkrJM44ty2WrCZG+hcoECyrp+6xv8ourWGc2N/mU4nlViMGgsscdNTJRj6pwAL0RmZ2+qX2Yt3p9lmPlw2bp7tqhrIBG76GTVzCZVAU/w/z0jEvjOIl7xYCSRPMf/2X5CvaTlDYYP9BM9ViRYgYPEScim7irJWmBRgli9TBWf5OVt/ST7JelkB9bc3OSS7/g2WuCRpl+t4Ppyr5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wy/sINq1UzDIWpmF5QWD+l+VOpForLdBvt0pGbqfCKs=;
 b=kr/KjrY3eRUH1vx+xcFGoO8U9FqpMBxNtdmSfMuq6DWwDru2kkGrO/gE+yJVnxj9YRKrgpD6ryQYsz77X+8e04T8EGuH5cMSeoxq1QtM2Fa4eC6gyXEmyC0xAs3JOQ15a5MEv+pPy6iVboQi/RHyYH9VUuOn/Axf9BkScPv6OUk=
Received: from MW2PR16CA0040.namprd16.prod.outlook.com (2603:10b6:907:1::17)
 by SN7PR12MB6912.namprd12.prod.outlook.com (2603:10b6:806:26d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 03:12:56 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::f8) by MW2PR16CA0040.outlook.office365.com
 (2603:10b6:907:1::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Mon, 3 Apr 2023 03:12:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.16 via Frontend Transport; Mon, 3 Apr 2023 03:12:55 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 2 Apr
 2023 22:12:52 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <qemu-devel@nongnu.org>, Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH qemu] sev/i386: Fix error reporting
Date:   Mon, 3 Apr 2023 13:12:31 +1000
Message-ID: <20230403031231.2003480-1-aik@amd.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT034:EE_|SN7PR12MB6912:EE_
X-MS-Office365-Filtering-Correlation-Id: b5b9ed9b-1ebc-4574-af60-08db33f1521f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XK2OqHgKAWx3Ha5Rz4WKWq1R8uMyRozQZVrw8LAC7iuX6T4yWNXnqoi3tM59bE6DfssFMAsSf74fQD1zLxptiOdobcFNlUvbTclIINfbUv0JUuJrYOepokmPOMH9nXkxN0mXXZOaSTH4w+B6i3DDSAcyXMkN54sJQFGjtAZwAVb9bZ7aF5zQXTJ5q/7IHfZ8jUxR0FNY+ma+d9eaE1r2LZ/rio7zCfY0oZUT17UHro9H3xxN69wlm/6r4PnvRob3++jT4lKh3+pmWHQlhv3Lin4W0VvK4Mv076c4cSCzdenn0RkQHe5P92YpMsMFkg2uuHgj6gD5EfhXwZqQmzZIdEDq4HD9XRkDwahB5GDfzrW4dvaKJoNbYrmbupaoXQX27D2J+SJaXRiXh7IiSrCM9olwgqbhnk27hTVVPMbHvMn83/IZ7AtbpRNXlkH+48nNsBZUiYL5twIHfJc3IJIiItY+TuOY9jDpex2e9OD1SaQlDcUd8Wy2XDcYt4PyWKQMSsGGrxXSMgYeKbFUOiQ/RHHiOKkp1oz2RFaVeWBBGABCLJFxY/IiKaAUPFvlNsjMPe33gccEeW8b+Y74RZqL0zdJ4DP1/AJdo/9sJRXh9GwiLUiJw7mEgJtTkOhaDXzxMkHDJGcH0GOFlV8EyTHFdS0FEWvU8Cv41KsdWZuDDsVCeQyeEW6EC91QAp4d059UnP6AqGG6rFQUz8/PBaRFN5F36nQxQpAMbUUj5uurOlU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199021)(40470700004)(46966006)(36840700001)(82310400005)(2906002)(36756003)(40460700003)(40480700001)(2616005)(83380400001)(336012)(16526019)(186003)(47076005)(26005)(1076003)(6666004)(4326008)(8676002)(70586007)(36860700001)(478600001)(70206006)(81166007)(6916009)(41300700001)(5660300002)(82740400003)(356005)(54906003)(316002)(426003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 03:12:55.9594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b9ed9b-1ebc-4574-af60-08db33f1521f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6912
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

c9f5aaa6bce8 ("sev: Add Error ** to sev_kvm_init()") converted
error_report() to error_setg(), however it missed one error_report()
and other 2 changes added error_report() after conversion. The result
is the caller - kvm_init() - crashes in error_report_err as local_err
is NULL.

Follow the pattern and use error_setg instead of error_report.

Fixes: 9681f8677f26 ("sev/i386: Require in-kernel irqchip support for SEV-ES guests")
Fixes: 6b98e96f1842 ("sev/i386: Add initial support for SEV-ES")
Fixes: c9f5aaa6bce8 ("sev: Add Error ** to sev_kvm_init()")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 target/i386/sev.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 859e06f6ad..6b640b5c1f 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -922,7 +922,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     ret = ram_block_discard_disable(true);
     if (ret) {
-        error_report("%s: cannot disable RAM discard", __func__);
+        error_setg(errp, "%s: cannot disable RAM discard", __func__);
         return -1;
     }
 
@@ -968,15 +968,14 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     if (sev_es_enabled()) {
         if (!kvm_kernel_irqchip_allowed()) {
-            error_report("%s: SEV-ES guests require in-kernel irqchip support",
-                         __func__);
+            error_setg(errp, "%s: SEV-ES guests require in-kernel irqchip support",
+                       __func__);
             goto err;
         }
 
         if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
-            error_report("%s: guest policy requires SEV-ES, but "
-                         "host SEV-ES support unavailable",
-                         __func__);
+            error_setg(errp, "%s: guest policy requires SEV-ES, but host SEV-ES support unavailable",
+                       __func__);
             goto err;
         }
         cmd = KVM_SEV_ES_INIT;
-- 
2.39.1

