Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D562E44BE76
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 11:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhKJKV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 05:21:29 -0500
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:20065
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231208AbhKJKVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 05:21:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnVt1dyTU/7DTyU6L7Y/lDciN2x+FnNQV+sHrK9flo+J5xxrywl2QSFzUMPotkPqzSc+LmgVOenYzZFcV15nsX5oAtDmYxG+vMPPQYhnDfp4l3TCa8TvSRBQXZ84BamzGlItI6hCq8vtYGxs4eDeDMukv+REDUBt8Way0UYJfRhCPztlcLS5ui4Q+Nbyv4OSEgFuxC81UvBCW7dqShjvfvB8j/lpIMbVW9j0jNwmt+B6fsEbWkHw9o5kLXqGIEAK/euvBseiEqTaVclZvhv6wJxKxdfwCkNUyMMh/8QM8DK8wLMQAlSBTwHmErqxLq8IOky2UsAEtp5AIQI+muJafg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7IxYuQVjoP9kkn2N7Up6cVHXCHxz3TCDm3Zz81pnG0=;
 b=jbWNfahHl4ucd5dvuu4RXRSrttJbs3IbLDwFQ4QefqFKoIJS/P9EZfSNpskM2S0VGuSu+0oHQybeGBNRwQDqJdN3Lx2//CUaitJCmjRgUpk/mkJ1hjTkfDrFH4Js2L9i5bJwv3pywc415D221zlKQChgxAkX40E6Lh4USfHCNYKGu1QMBBQqFmtCt17+cOIEoRUnOYLfLhP0VjqLINO8nNZXIigcd3NLQQbwIVEzNOnWjhc1jT5C9kIRjiAc4JKWwh8UapsX7Wh+1gYOkHuNcqS3w4ZZsKbnLvbUxhLjyWONxxvufPvKiPVF1VV8X+oaU/edhzXdgQ1ZQapwjdGyaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7IxYuQVjoP9kkn2N7Up6cVHXCHxz3TCDm3Zz81pnG0=;
 b=kbYMV8DuKMox3NEfeEiwg4pYyvGUQUUYkxilM9jPATkQrNDS/IlJOYNISP68jtWHI7IPtPmkNRyqU1C/JPgYgUkn48Y6IQWKIraQI8Ppn0Ui5xHsuHBAl4nqi2FP61u97t8j6L05ZPWVwxBsZpo3nMqc6RXDkLPvhn51OI9cliI=
Received: from DM6PR13CA0017.namprd13.prod.outlook.com (2603:10b6:5:bc::30) by
 DM6PR12MB2714.namprd12.prod.outlook.com (2603:10b6:5:42::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.15; Wed, 10 Nov 2021 10:18:35 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::70) by DM6PR13CA0017.outlook.office365.com
 (2603:10b6:5:bc::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.7 via Frontend
 Transport; Wed, 10 Nov 2021 10:18:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 10:18:35 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 10 Nov 2021 04:18:34 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <peterz@infradead.org>,
        <hpa@zytor.com>, <thomas.lendacky@amd.com>, <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/2] x86/apic: Add helper function to get maximum physical APIC ID
Date:   Wed, 10 Nov 2021 04:18:04 -0600
Message-ID: <20211110101805.16343-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211110101805.16343-1-suravee.suthikulpanit@amd.com>
References: <20211110101805.16343-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd26cec7-92d7-49c0-ec3a-08d9a433748f
X-MS-TrafficTypeDiagnostic: DM6PR12MB2714:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2714306AB0EDCAE496C4072FF3939@DM6PR12MB2714.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wqNv7RnuEXoXpxRFlht0I2OxZb5AwVZkKAMKGGDmYBglqK2jAxaxH92xnSdlnLxVZxbA9WB8SsahU19xn1f+SW3gDsOp/6Vi1kNDYZpYMkCF2ShA1yDhGg8MGyqYyNjFT8oyg5J/ngiRN51SD0tdZ1Ja4PtCX2xwU5LF1ZI/Ft8sdXsQjy27WqAnW63bvnCL0o/oemIrOjjle1G9OFyU92qr21kNNr1tOBSJu+5C4B7Og+hiWY8ZCjsELJdfjQkz2cO6BKoaXzYIdnyl5El2sYd48APz45VMBQw2Fg0mLMIK4MMHv7EKNarV1BbzOZ/VwQfcgpnY0mTbVjw1lY+c8qTs7jSYG2NkfpIYiCSY387XiQ6T8S1OAeKbV6zAqq+KyQ3KLOvyyJZM+w9vHoGqduT8JmRW8sIB1XvqzENVdir6VtS0BrJAVYKAxcRf4ckTpbEfqH1znEkxDs+SeKt+ranEFQtkrcG1tZAodoUADxTaahVBSoo10ifk6Nn9edBjgKVrH9jdPw/9Abquz7cCt6rXex3N/btYsjNLR4UGse8TSNikrs7IiEHQPwm00Garg7JvL9PrZnLMehzn0N/72N7vu8TLrEIWkWhQv4+NJHqKYLimzdero2Ni8zFegAoaTg/Bucuy3JeEt6v4USBsrbCkPk1KQTmGoXuGRtf2daZb4L0RHcPVTarUW1ROAyUoobmcTh5t3nEeISfa1wXS7hZkCtJ4ebEmnJNsIgKeVKM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(2906002)(8676002)(1076003)(186003)(36756003)(82310400003)(5660300002)(4326008)(7416002)(16526019)(426003)(316002)(8936002)(6666004)(47076005)(36860700001)(336012)(110136005)(81166007)(54906003)(508600001)(86362001)(70586007)(70206006)(356005)(26005)(44832011)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 10:18:35.4782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd26cec7-92d7-49c0-ec3a-08d9a433748f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2714
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export the max_physical_apicid via a helper function since this information
is required by AMD SVM AVIC support.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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

