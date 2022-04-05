Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D81B4F5519
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449406AbiDFF3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449945AbiDFBQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C0A4FC4C;
        Tue,  5 Apr 2022 16:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vfk08PPk4smgxb8VS9RROcyxK4RT9wpALei/nHLNOUKBO4xAl0beal78v/WU1qDRnuLdUwrQOY0/5Sic0rOU+0OyGybNhzOMdkF9QJKIgS1a5Xj8vkxS/Xw6218SmoV1sdfYWpULTYk5kJ/7pwnyuig9Xz5H/Gmh88bcKmz/eAmo+JPDgfZHm6tZHj6OKDQvt8AfAMkUym7Sf0/oArI5wR5S36e81ZSgqSEqmeczsXdHCSeN7IDIGDlJrhBXe0YCpLA4d5PE/EwkF4zYRs9r/GxJGFRDjoHUq3ign8y50L0ffp8EqU/uUFWbozxqZf85B1H0FX7UI8RMdNYl//q4nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xKjoUHOl3YbE4t3lQhS1EJzqOoO8xsAbGBQoN7TSBE=;
 b=cyP3r3kBxSy5Bgp+syXdX5qg3aKHMk+xEU1web2twkTTv+9Pu2B1Lhk4ck8vJxklK4ABLoaEpxT5VX6h7XoLrVfoQNDZnPRQDt+C+BkyzJpr+sJqXWOjqtZjYiHASQVYuPTolu7GDNbDuzw5IOSoEhm1ZcAP6aZuWqDAtwzhCEfI3XJIUPJAtamtpQiJzWY3/S1VxHeTqOy1kOIwJVyy/Ur6DEJFXw/IICzeWOmP/Mrv/99WEAlrywzMzDdYVGm430CCFK4LD/uAwt5LTLIJQh5B8NZ+EfEjRiaiyV8HG8/nkaQcXMoDmWxLtLxNlkobsD9wOQRlrmA7rVPlmRVubg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xKjoUHOl3YbE4t3lQhS1EJzqOoO8xsAbGBQoN7TSBE=;
 b=tOV4laaZQjdKhtBjLnec5AtKMLuKuv66VmonjwW1c4q8wvQvdB+yIiK3XTotWPNSXc9sk7bLLE+bSX/KxrXDUSmeoBxs7wmlMizEYgsGpjraNz76tBB3+D0a7apcryGaaAPT+HwEhfow41uB6ozR9cLmW/bNKTG/ki58TfRn+20=
Received: from MW4PR04CA0085.namprd04.prod.outlook.com (2603:10b6:303:6b::30)
 by MW5PR12MB5652.namprd12.prod.outlook.com (2603:10b6:303:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:25 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::49) by MW4PR04CA0085.outlook.office365.com
 (2603:10b6:303:6b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:19 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:17 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 01/12] x86/cpufeatures: Introduce x2AVIC CPUID bit
Date:   Tue, 5 Apr 2022 18:08:44 -0500
Message-ID: <20220405230855.15376-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1eb105a-22ff-4ee6-86d6-08da175950d0
X-MS-TrafficTypeDiagnostic: MW5PR12MB5652:EE_
X-Microsoft-Antispam-PRVS: <MW5PR12MB56521750BF8832B9912A6E9BF3E49@MW5PR12MB5652.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1YZuTbycRwanIqlLcmHybJwq0IEOg+iMgjCfN91k1LkVCyorLxW7re47js9PcGjTi1+BRPL8yajwZhJfMIIbaM3bgRw0rRaJMqagfpuZKQFjrTnHCLzW/ytMyiG3nobM7uEv/7AnjECSyx/eiljmy6eRQNrMgJC7B5n7EcDLXp610vn2ZC6KGJU2BNVEeOfi7d9V40vY/Bg3kxPbh1/LJzhyuuq7jUOie8xUz2J6677McALgGglNfaDJx8bu5iMyQwkUb+neprUJ/aqj9k/AEcavzMTlDBg3tPiGMK7eQWnbFkVfLJxlHzb+P99xKNMdObBVoa2vTyQi4SmCNLJnZOpb2VdVHYIZMQthXij1wam4njPFqP/1rI9psYPk3HeLfXIgT9DGlRUp1Wocq8F3VaxywAEMCqfHe24bgl0BXby3H6xI0b56h5TH/+IZQQQHoImu61JeYcH3LZE94/oK/EO4q98p769dVwICJLXw5YEZfVD0Yi0xApKWfYmTxXq4vX6z7Puaa8nDUJeRnKTrcGVvmHVTZOXpGUZiCCvNDe3cUrz6iafmDrloCEpjuLkgQmNArtZrGps/rLSZNfOZLMA0y1VWtjAuKAOcmPgHTpJB2FqUAnlSvpUJ2r86q7aNWUdJ1MKFazUcMBtG1L7JU99vEbLiIRQoHP0TT6mNRS3cdlWEsYzY6zkPult+9XGqsVFsfrn2j3cWFaZ3xL4kAQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36860700001)(336012)(356005)(40460700003)(81166007)(8676002)(7696005)(82310400005)(4326008)(6666004)(47076005)(44832011)(508600001)(86362001)(4744005)(2906002)(426003)(16526019)(8936002)(5660300002)(26005)(7416002)(110136005)(2616005)(54906003)(70586007)(1076003)(316002)(186003)(36756003)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:19.9374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1eb105a-22ff-4ee6-86d6-08da175950d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5652
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new feature bit for virtualized x2APIC (x2AVIC) in
CPUID_Fn8000000A_EDX [SVM Revision and Feature Identification].

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 65d147974f8d..659856ee81b7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -345,6 +345,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
-- 
2.25.1

