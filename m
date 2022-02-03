Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B164A8201
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 10:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349974AbiBCJ7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 04:59:33 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:31457
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232318AbiBCJ7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 04:59:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1SM1Hh12Yw2eJmhQxOhZSn93hQ8LOQHxZUzr6PXrBi6Qxu2pgphtvceKqCUgXwBJ+TdyQwpj/yI+BekSzII7UVXf+LeEUoa0NhpC3Q0hn0nhe31r/cEEWmNVdflqoiMRTy3HW2vkKwS5EW5aPaPcUuJd8zlB4+VbSZuOgEYJFg5wWtpHe4Og+JYBNYDbqew5rHrz05RK/CMD1By+e7IC6P/hpWewB3Xot0M9dQmD2O8AdXlyro61FFkLkCzs9v3ncZ81o9eXpgIEhfDRCyfb2cGXHZrdHh9XGwDOKyTfvILHBFBKNIasA2mefm7Zng8dy9fM3zXcntXAhU0FUUz5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVd06XhffNDw6tJ7UMq3Vhz885g4m2On++XRUBb7l3Q=;
 b=RW2CLnhPMlipiz7B3+ZPgijtjc/7XN6FpgZhoOfVtn8JQcXN/VUqpAr3xASoGAHuve9nCyKGR24voHTZ5u5Q8qvsCmI1zpeAjnYjs6K9KRBYkpddM6wggGS24XS+f8Gh5NCnP0OcKBv8btkmnlfQngHdMsNAZ2qPzGLJHrYI7w3c9KYnPLKNVK0aFaETy9mI9FqvNftCUqQbJcGIV7wscLoPVbOHBiQrT9fhrHVjF//HYgltyfOWDTgfZQcdwNRK5EUSP11kn9lyw/cbZeNAOWLX7c3br5ZW1IQPi5l5R+MougmaTLaGSim3PO83DXR2fhwtGXrOCe5NGY/qKfC3cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVd06XhffNDw6tJ7UMq3Vhz885g4m2On++XRUBb7l3Q=;
 b=X8RZmLpr0N1WttbeMPXxNhhSxecG8qXnEKtQGOlw3B3i7U0q1WaYSN7r74kqw1kR9DTM4HRUfNRbVuZut053JnFb7ffkq7WszpM5PZawiCFrRWnvdWEpiSwiIZi4TALv/E46oLn3xLDkzfIacWO770AOJmyZAg8j10i5u6EahKM=
Received: from DM6PR03CA0032.namprd03.prod.outlook.com (2603:10b6:5:40::45) by
 BYAPR12MB3494.namprd12.prod.outlook.com (2603:10b6:a03:ad::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.20; Thu, 3 Feb 2022 09:59:30 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::a4) by DM6PR03CA0032.outlook.office365.com
 (2603:10b6:5:40::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Thu, 3 Feb 2022 09:59:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Thu, 3 Feb 2022 09:59:29 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Thu, 3 Feb
 2022 03:59:19 -0600
From:   Ravi Bangoria <ravi.bangoria@amd.com>
To:     <like.xu.linux@gmail.com>, <jmattson@google.com>,
        <eranian@google.com>, <peterz@infradead.org>
CC:     <ravi.bangoria@amd.com>, <santosh.shukla@amd.com>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <wanpengli@tencent.com>, <vkuznets@redhat.com>, <joro@8bytes.org>,
        <mingo@redhat.com>, <alexander.shishkin@linux.intel.com>,
        <tglx@linutronix.de>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-perf-users@vger.kernel.org>, <ananth.narayan@amd.com>,
        <kim.phillips@amd.com>
Subject: [PATCH v3] perf/amd: Implement erratum #1292 workaround for F19h M00-0Fh
Date:   Thu, 3 Feb 2022 15:28:41 +0530
Message-ID: <20220203095841.7937-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <fe53507b-9732-b47e-32e0-647a9bfc8a80@amd.com>
References: <fe53507b-9732-b47e-32e0-647a9bfc8a80@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af234eb3-5950-40a0-f7b1-08d9e6fbdee6
X-MS-TrafficTypeDiagnostic: BYAPR12MB3494:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3494A1CEFD73DC2D1BC52460E0289@BYAPR12MB3494.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BSxVfb/pUfyFO2Ul4pjlholCII/Wj7PQzjQRRtrY1/VB81ESB9ac0aDDvNuTT0wNTc55eYo2EonNHMRjaXcQyTvSPuyrDeMWGP6ZUz35JmMy7j7/j39Xbr/vUpSdBXWb/PHfYXByqvpdJ4LMMPn+2gUIxoLCDgvP+nNlTH1rDinPYtmD6nIHB5R0zoiGR1QsLsJeNpIG5w0InMGL8f/F0iZD5R2isakcli8b2bSDlZA9Pa0OmhkfN8/ps3XyplA9aGm4kMDV+R3780cQibO/CGARYstFez8GBafG8dfE4EPOby0d+Uo3fAJYXK813QWLX60cFerlpvI4vqZpj5SlvilPE0Z1D7A5xKAhzUnFYXmDeIrrphYwL63j1hIvXx18wgSH59zGIXcnxiHrlyb3bzUpuQCmhZi151+K0YyRQdpfXO68an7OueD3k1Rx5316bWGpRHAGKr9vjN2tQ6UAckU05ukHhdMKBzc9VN227RIJ1mKTu93Y1vxdyQoAax1neFFzupd4YJL/ji4ywhcgkDD8CdEk2TO7yJ3JdCP48rqJEJE2LGSIhVqi8lIHqSP7fYGBJFrS+I3wpNoIynpW4UcUqHfcN6wD4jB32MBNDA/LIpz1s5CgIKDvYEgKjX3lnZUUSXE5C73YxUJBlVjW+iEiXg79E3yu/TMYIz+xfjRhyuAgJnk4DwsahR4Qus5nnMLwJi5rUhCGL7v95gzBLNvIst1jlmFUWKAedTen7yz96vnq+JKx25umtcriPDM6U0uCxbo1peNXD5QXamKEK9WmxVwzxVic2rkBNmr/f9vVMe7MxgXNSHb8uNVQRq6o2qDYRa/HZzDby2rCpMF7ig==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(7416002)(36860700001)(110136005)(26005)(8936002)(8676002)(2616005)(70586007)(426003)(16526019)(336012)(508600001)(356005)(6666004)(1076003)(2906002)(966005)(81166007)(7696005)(186003)(86362001)(70206006)(82310400004)(54906003)(36756003)(44832011)(4326008)(47076005)(40460700003)(316002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 09:59:29.9556
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af234eb3-5950-40a0-f7b1-08d9e6fbdee6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3494
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Perf counter may overcount for a list of Retire Based Events. Implement
workaround for Zen3 Family 19 Model 00-0F processors as suggested in
Revision Guide[1]:

  To count the non-FP affected PMC events correctly:
    o Use Core::X86::Msr::PERF_CTL2 to count the events, and
    o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
    o Program Core::X86::Msr::PERF_CTL2[20] to 0b.

Note that the specified workaround applies only to counting events and
not to sampling events. Thus sampling event will continue functioning
as is.

Although the issue exists on all previous Zen revisions, the workaround
is different and thus not included in this patch.

This patch needs Like's patch[2] to make it work on kvm guest.

[1] https://bugzilla.kernel.org/attachment.cgi?id=298241
[2] https://lore.kernel.org/lkml/20220117055703.52020-1-likexu@tencent.com

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
v2: https://lore.kernel.org/r/20220202105158.7072-1-ravi.bangoria@amd.com
v2->v3:
  - Use EVENT_CONSTRAINT_RANGE() for continuous event codes.

 arch/x86/events/amd/core.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 9687a8aef01c..124ec15851bc 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -874,6 +874,17 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, int idx,
 	}
 }
 
+/* Overcounting of Retire Based Events Erratum */
+static struct event_constraint retire_event_constraints[] __read_mostly = {
+	EVENT_CONSTRAINT_RANGE(0xC0, 0xC5, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT_RANGE(0xC8, 0xCA, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xCC, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0xD1, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0x1000000C7, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT(0x1000000D0, 0x4, AMD64_EVENTSEL_EVENT),
+	EVENT_CONSTRAINT_END
+};
+
 static struct event_constraint pair_constraint;
 
 static struct event_constraint *
@@ -881,10 +892,30 @@ amd_get_event_constraints_f17h(struct cpu_hw_events *cpuc, int idx,
 			       struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct event_constraint *c;
 
 	if (amd_is_pair_event_code(hwc))
 		return &pair_constraint;
 
+	/*
+	 * Although 'Overcounting of Retire Based Events' erratum exists
+	 * for older generation cpus, workaround to set bit 43 works only
+	 * for Family 19h Model 00-0Fh as per the Revision Guide.
+	 */
+	if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model <= 0xf) {
+		if (is_sampling_event(event))
+			goto out;
+
+		for_each_event_constraint(c, retire_event_constraints) {
+			if (constraint_match(c, event->hw.config)) {
+				event->hw.config |= (1ULL << 43);
+				event->hw.config &= ~(1ULL << 20);
+				return c;
+			}
+		}
+	}
+
+out:
 	return &unconstrained;
 }
 
-- 
2.27.0

