Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73C14A6ACB
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 05:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244299AbiBBENk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 23:13:40 -0500
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:53569
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244041AbiBBENf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 23:13:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqYrS75lwLY2Yko41sElU1SHti1PkYVIO3swAmt5NYnOei4m0Z6Xb68Afb5zdW7ykw+3PqBsN92v0Z6KzDjFMKVc3qklu/7ovZYRq0N6S9BxXkAsdgmtrMGGxsBODYKTZf1eckewoi3YV+Ed9FxppRa0c55nyXbehmsg0GqxOfs28M/9jc+Wt0zKtDrZLaNZY2K79elXs4NETLaohEIQe+JgugfFpnV2Z6xLZwo+EkZoXd75RTWMklhpSAMj58e68Eo3x+JmP5lxq+NZuTzfnYbc1ZuI7WjigM0+TLvFX3Yy8GM/MU79NmDK+6adyzYE/khdNKWL9nhSIAv7liSJgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYrcdxL/0Nmp4KpM+BbFq2Viz+0j2qsvxaFq4m+huW4=;
 b=TnV5mTm9Y5Ed+6McIBj2dKO3bzZoBEZ4iJkbIZOpI9h48AzDgTVnVVG70X4xu31eIjbuZ/8yFPoZtpxdDrY0I7j3sdnt3df9fEHy4JVrgg27WkDT4dirOIs/VAbsGJICwBGCjt61jSbv+osndsHnP3Q+8i+i6oiKbgTgq8wHcvDTDTU2qpdFgBAFvaT43FiPE8L5xcYFIMIzOvavfuPtji6couNOuEv4lUX73ZN7/ZnSJcrPIoH9PUCY/oFTO38MUFD21rR4Kr/jUy5uEdjb67Q+/7dHdCKJppw1v5UBmCA1SxxXTOiEos9Yt1OViUjG9OaGIW42dP5xwtWo61jLCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYrcdxL/0Nmp4KpM+BbFq2Viz+0j2qsvxaFq4m+huW4=;
 b=Kb2R7sOI7HkF20AJTw+22gHk4csT18bd8A34yEugrzJBxWa8KctoehVnP1nenVH/t2xviGM2uueE2fAepP6I/UjqEMcDjFG8yi5a4Owe9OIaEEUEh3LxAROQ0uXbed/auOJkU22gcVkKPs5jRa2m8d7nnW6yY75rcbckFGiuJR8=
Received: from DM6PR11CA0066.namprd11.prod.outlook.com (2603:10b6:5:14c::43)
 by BN6PR12MB1713.namprd12.prod.outlook.com (2603:10b6:404:106::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Wed, 2 Feb
 2022 04:13:32 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::4a) by DM6PR11CA0066.outlook.office365.com
 (2603:10b6:5:14c::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Wed, 2 Feb 2022 04:13:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 04:13:32 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 1 Feb
 2022 22:13:30 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <seanjc@google.com>, <mlevitsk@redhat.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 2/3] x86/apic: Add helper function to get maximum physical APIC ID
Date:   Tue, 1 Feb 2022 22:11:11 -0600
Message-ID: <20220202041112.273017-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
References: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b549264e-4dd9-49df-f866-08d9e6025ff2
X-MS-TrafficTypeDiagnostic: BN6PR12MB1713:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB171391F7DCA336E1DF06D16CF3279@BN6PR12MB1713.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 63BTeXs9+CQhWmX3B1tXFoQLflTFqzbCwRd4TniS9ppHw6ltSec0wvPJ7AtjO9yw5Mibz3d/6b/vAnNMIed91fqOCnfD6XwtSvhTetQFt91AErhhb/haWR8dQP9wRsGT+oUpCD3yFgY+lm2tyBl7yZ8kwPFlpWdonuqjY69FwkXYdfoI9syYv1++E1vo9g0XTGB1cOX3RZYP/OG65bsWDnMadwvhV8VaKYBgP9iqOIKAd521mYrc24l4q+zF+25kffkJLS0fhmsgR23yUnqwX1hQBiHtpsMlpjQhrbun2kKAT+bHfMtv/R2X7AwK/X8+hL/gDLoHmyKX9LDHltD2isCIZCFUWN9yAw7fMkTjsifkfe3LnOWI7kXlMz9HUKJsuj3MXblmSYkIcPuN5iy9ak1h1SKJ1Zx0y09XfNIjV1FXRhXZLSLx8pUtRNVSH6sTbvpBAmx7hACQf6QX/kyd7wQCpL3Z3qhCWdV3jy2Fip/yC+6Nl419lq2v15oszfwXE7GkxgmeYwpJus8LsXUvwQgsKeFYQitpmeHVcA0YDvkkOO0EPhyCeXThUbyU9YvxQECl0SrNTV2Ip3e9z5Ws57KS6y+AEvW3MZIxEYfv+Pdt0U0RBmZYP8OvDega1+ot8ttUspdatLiMyUXd9vtyjX4BFmv3xhoWDJSc3pBYLfCc+G1J3yda8Yk3p/nVhYfPWt9msRhiM00YT99Iz3io9Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(316002)(356005)(1076003)(36756003)(186003)(26005)(81166007)(110136005)(54906003)(16526019)(2616005)(5660300002)(44832011)(7416002)(82310400004)(2906002)(47076005)(8676002)(4326008)(8936002)(70586007)(70206006)(40460700003)(6666004)(508600001)(336012)(426003)(7696005)(86362001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 04:13:32.2780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b549264e-4dd9-49df-f866-08d9e6025ff2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1713
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

