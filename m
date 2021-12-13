Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB43472B72
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 12:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbhLMLcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 06:32:24 -0500
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:5281
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235984AbhLMLcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 06:32:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+XkAHwykD0fNZY0el3FzHGkiai15inhLxqiU4ldWUXkGK6Nl2kEn4HB0vcdb07CqQ9oM+g6BkNtZVs4CD/fxuk04W8nBbASMRQiQr1cE12bIkkDOwt1qB6EBCYraKMDGrsZLThImqlhEKZMIORJwfV67hwWNVezlv8cRmIwmYk5gV4VHLDVFCKAthEuMxiN8z2eFGKw2BVyZnuk8Q6jitDIYOxhSrsI/LZEM2DEH6uPP8wvxCYSmZbOqAHxKS1J1+pJ01h0LCOeUSPCu0SunU9sRfOYa3PtddDy5kAsppQv1Hpgud+nXo1lqQuBc0tM3+AOVdUJ11xzcF9z3tyyTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYrcdxL/0Nmp4KpM+BbFq2Viz+0j2qsvxaFq4m+huW4=;
 b=WzXf14pxNB5rI2hMrz/6BNJC3+k22V8YvMu9v5S0l6ntbdD4CKY8LKk3oFtzEJQAQIU3+lUqgqq+MFvC30CVMysEc/E5F0ei02AqmvCR/GkY48O6RHbJQ6zlen3Bq1rrfQLwXCOK5E6kFiIMZfOENq+inE7m45DDvjIY0aMOqrUudpnf2FqPkQb48m7KWh1O7MWnNW89dWvv9Mpj2sj1JrcQSvtWuCxhx2FF/lMH7v7LuIwJQGuR3imrrCyJ0J8oEosk5Lcs+VsH41tOsWOn0fPyxLolfmP8j1lU8xNify5+NjxB/CHBy7Ms8Jvt9vu8xW83gveLpFQsMARXDaLIrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYrcdxL/0Nmp4KpM+BbFq2Viz+0j2qsvxaFq4m+huW4=;
 b=NnyDtV7bVhm49h+tjHCbpLQz6r5Eb3imD0PiRIygEbb6WBGJ2Cu6uwU76Ms7cXi6sPxWUzJiRWrH2Xy4uS7kSr9tv84Hz2y1TWJUafb/nsjSWrJK700Jus6Wu/9XdS7DzYl3UjZY394uPT9qgJHUwNk7aqJ/royGNmE5oma1Efc=
Received: from DS7PR05CA0044.namprd05.prod.outlook.com (2603:10b6:8:2f::10) by
 SJ0PR12MB5469.namprd12.prod.outlook.com (2603:10b6:a03:37f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 11:32:18 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::f6) by DS7PR05CA0044.outlook.office365.com
 (2603:10b6:8:2f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.7 via Frontend
 Transport; Mon, 13 Dec 2021 11:32:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 11:32:18 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 05:32:16 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <seanjc@google.com>,
        <mlevitsk@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <thomas.lendacky@amd.com>, <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 2/3] x86/apic: Add helper function to get maximum physical APIC ID
Date:   Mon, 13 Dec 2021 05:31:09 -0600
Message-ID: <20211213113110.12143-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6039a4f0-b548-45e2-c44c-08d9be2c3865
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5469:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5469B667986F0888759FD384F3749@SJ0PR12MB5469.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a9IAFcBID9BUIVnEutVwSQdUD2Is4vGOX28dL7KFlhrtfy6Tlrl9ikpHZw8cSwZg2HXBTOYkrC5cyDCal8WQLw7MavA66z7Jq7crAXpsYqj16bKjdxecLUNnEUv41MDCLQS0Zqck81c54Q5E/MN5qhBYSjBfsuMQu+zZQtrHqIZ7h/adx+qIKGYHNj7JbCgRRwgu234iFXZV4f2ZhQv+7V9uZf1TTPuL1mJHnXYZReja1r0bZAlj47W/QJJPQVGQnwY6zRHiTYtMkNrfVttWXyNYSjatIey74YRvo55ouWdwrX/shOQ3TilkGC9vmwYo+/lqC0cKaaH+0thapYwAeoYhIv1hsWfCrwk94KReh0cvRBHH93R7xbvf7yvFrE36eyxPvv9KmS9IdhWTzQ3Jblj+Dp9rjc82KL/9CyDr3/bO4MxZj2gru9HsYG/ldi2zeKy8NigwJL6ubeh2oBz0x9H1WkVd70jG+8xj1qkZjhrFXfg7FhvrxWSv8izaZVqREEBMM5dFyatmH5Wm4bVV3RXR3zkM8M+kwE3qyOjZR8bLSvypa/ZP9vzAtBegI6MTDlguz8l91Xv9v4dh5u311RxhdKHo41U59rifvztaNwVbbseZFXmMNbVDACyngLTpqanKPj8QTb4ac9GaG4f8LLUyyx+ukB2B1gYArZX1BwZt9/eesSGfbu42UsJPiw6yR6r46peQtd8ZjvJOaE4ymcN8RRrDpNTE1dnWmZWAjmn7iO/0duTxagDB1/xEWFxzokVAiQ8bknyhzXSQ482ycyPVU0JVNrjt1RK54R+JMzU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(86362001)(6666004)(186003)(44832011)(36860700001)(336012)(16526019)(40460700001)(2906002)(426003)(70206006)(36756003)(1076003)(8676002)(26005)(2616005)(47076005)(110136005)(316002)(8936002)(54906003)(508600001)(70586007)(356005)(7696005)(4326008)(82310400004)(81166007)(5660300002)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 11:32:18.2864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6039a4f0-b548-45e2-c44c-08d9be2c3865
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5469
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export the max_physical_apicid via a helper function since this information
is required by AMD SVM AVIC support.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/apic.h | 1 +
 arch/x86/kernel/apic/apic.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 48067af94678..77d9cb2a7e28 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -435,6 +435,7 @@ static inline void apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v)) {}
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 extern void apic_ack_irq(struct irq_data *data);
+extern u32 apic_get_max_phys_apicid(void);
 
 static inline void ack_APIC_irq(void)
 {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b70344bf6600..47653d8c05f2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2361,6 +2361,12 @@ bool apic_id_is_primary_thread(unsigned int apicid)
 }
 #endif
 
+u32 apic_get_max_phys_apicid(void)
+{
+	return max_physical_apicid;
+}
+EXPORT_SYMBOL_GPL(apic_get_max_phys_apicid);
+
 /*
  * Should use this API to allocate logical CPU IDs to keep nr_logical_cpuids
  * and cpuid_to_apicid[] synchronized.
-- 
2.25.1

