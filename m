Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216A751EAF8
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387627AbiEHCns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiEHCnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D274FBC01;
        Sat,  7 May 2022 19:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EF+z4wdySVY1GXHqH8pBtl+msj8ZTBN0GmAuSI/xiSEK+X2NBlqpChr9JYmA6FYCuQK9XIYpedsLeLyltiWPzcnaVBnmSP07DF/8EQkaFTyBIkdWTJRNSrdeFyyr48yzlo4zjD8wKdNnVaoit69kpkr7w4AmDoN8Z2yKLMvm/CpS/CLJHV7wQUuzcgFZXaxtkFwHvS5d7SCBiRp8QiiMADg7R0qtuLAco+YnRFV3yNmSV7lQREt9s+SSWM5/Wtj4eyx7RMTQ71zx9SThE1MLybc3s0hiTm5ggIupCc4EFZOWsb6nITyF9yOfmGcrtwRZ4uqFF/pTimKXcxYIGj1MUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIxqo7TXYYl0T+tYZvoLGn2rk3JMESoQytRIcfR+RbQ=;
 b=f0uyk6HEHQ/mU0tKH2zJV6u1twskgnTtwQoMRm9nh3lLzbZs4rMnV+WVyJFBKJqaAaji1WJnPTp5Vmctev/c4fYoHHcy53ImSj/+Nyw2siPunkN8ezfstsYvctGI3YlnMuHNZWUCH0vIsBoaQO8S5tcCqr0HFTWMLzpZW2ukmnwjPQpdKDtGTt1XS/k72TzqUWRwzNuHAWO31axVgl5pTR1pQ+0PzV++qY62bJ4dkNJy0dElQ4ngg3arb6iFG+JbiBMJi2RloBYSBQb4uphsrogZZ/CKmqiPT/ValzZ1MfiF9YICHegCBybWkmjudJqm8EjNvYwGznL+eQ/xr3Jg2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIxqo7TXYYl0T+tYZvoLGn2rk3JMESoQytRIcfR+RbQ=;
 b=quLTQIxaIZyIosTbUwZfHmZpYASpCxkGgTu8duhL7KL6sq4ivsARqZl4i+xg2wkZ1uIZ0LpYFsUP+eNgrSBERivBAvgWhhBE2OXfJzNcsLbadR7Nmov44KxZmll6xHSdocsGByAvta5OKUb36ravhMSaNDAEixhH8bSS8pKoTsk=
Received: from MW4P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::28)
 by MN0PR12MB5906.namprd12.prod.outlook.com (2603:10b6:208:37a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 02:39:49 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::99) by MW4P222CA0023.outlook.office365.com
 (2603:10b6:303:114::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Sun, 8 May 2022 02:39:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:48 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:47 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 01/15] x86/cpufeatures: Introduce x2AVIC CPUID bit
Date:   Sat, 7 May 2022 21:39:16 -0500
Message-ID: <20220508023930.12881-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd39aca4-cc65-4991-3d86-08da309c0560
X-MS-TrafficTypeDiagnostic: MN0PR12MB5906:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB59066B024ABBBFE754B81173F3C79@MN0PR12MB5906.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UD7kjFHFAhPSl/Qur979FywzIVMZBAdlPR1elocOEPwwGRdv9MlcZTREGtTS7rqDkGZ/4i6DAVbKBUw6k4j7fNcu2afoLZNRsm+wa30i6qSc337qKJhnkbB0tiHU2P0qFknLbO9StLy3L2BzaTE12yva69QNqRvBV51fzRMDn6g7HHKgIigFzH4F9ndfSWgN5DcRrRf3hzdxF+6JDThcoRQJqL7ox3TR/Wfj+HlGusGa9HYAhvRO36cMKp+bffCATgrnt1D/rPFbQgA1dkKXiKd284jI9I6uR7nmR5871xcmhoB6a8r9E3NU1oesepVZb94+/pkGwC2cf9B/rw3gIEW1TRv1Km0a2oueFcTdMQhwNHm29PLu0W0n1vzzWxQZDaCjmmvZwv/e7vkInqJo0w795SKAa3e0EnOJFWvOYqzyE0WeUNPGfeOgIEmOW/duT/z+LZoCD8SdZhPKbDSDd9FtEKFU4rO+jDZh7vZucNYmYnrWo/ELLuYwlfpPUBm6VKSgZ7JOSAfOVhfCbPjzC+j/V2w4RlyklwYX/+nZ5jd95quxrseS2ceDjgDZlrV1FcviZkgTRvmZhr71TEk5HByxabjvtvCGHTD4VhMJf7PNOJ1Dmo88fZ4pmCSdw82gBiDGxlm59xO4hAjDDVGZ6tbpgf39vX/XqwVot7bKhPljS+GEvK5ggLqr02uLzQ7DQlbxTHSErmWAYZZ46j9oUA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4744005)(82310400005)(8936002)(2906002)(336012)(2616005)(1076003)(426003)(36860700001)(356005)(47076005)(16526019)(54906003)(44832011)(186003)(81166007)(110136005)(40460700003)(6666004)(316002)(5660300002)(508600001)(8676002)(4326008)(7696005)(70586007)(70206006)(26005)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:48.7696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd39aca4-cc65-4991-3d86-08da309c0560
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5906
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 1d6826eac3e6..2721bd1e8e1e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -343,6 +343,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
-- 
2.25.1

