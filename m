Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AAA52D074
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiESK1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiESK1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A38A7E1C;
        Thu, 19 May 2022 03:27:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAHkoiZKMBw3A1GJdJ3zMq1peizeEXl4IglqltbEs20bRlxs6DWw76rn0C9g7uQrU7kqP63ol10FQ8RTd0+cYjNy6pOFMJIfo2nXvmW+QRQW6eOISFnblS177U+E72xS1xiJfma90yQsSgD4tlrnS8gMeyOroXxPepadrxgjKxvbncw87MpMIiToBHecKrptu1s8t2KhZdNZXot/QMyo9MUrgWCv3UUOTg0PjUo57nQFSORJFjvA+1Dq+VpdPO/bRw/J1rOzs3xANGT4QW/HyF+5i6cJnSyA7hFX5595/7WyS/eEeRgl1ZW8KjaeQ6rjVGb/OzxKTZlEv9R38O8B5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWn/vash+REJVBPvFVe6fL5edyLf62h5NzBGmBUCpiU=;
 b=EcbkK/TsZEw6I4ufJYNHv32YTtG0+r3rHiSWvebCiQmmEKwhohW3n9NJ1fpjsvKwxBW+VJjuY5ITATLxuBOf2MYiWw0zVv6SBj8uxgv8as6qUJnn5KBGy5haMSfVfDsj+5yWNpIVLqRHYQDcKN2g3UMTG0SGEmZDCXakX1GiaB7kCURWsl4kIe2U+xJi3GO8YsHycmIVt3VioCjKGImtSnRfyln+qUFUEXg1ZD70Br6rGY43Qa8+tZvXY/T8y6DwtV4AK7Mf/fbH5kgfsGUItAu3t6MKy4eA/BOO3EPK+sAwcdgHTu4U7PU9XXZ9EH/gGJqgklw3IXXptofXo7WbiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWn/vash+REJVBPvFVe6fL5edyLf62h5NzBGmBUCpiU=;
 b=CFzUH3Z6ew8J5Meij052HN2Wd8y2LsHRSoniX7nMLxOxe5IgFWXLqHVxxAMdVVjqLzn1lP3y0HUki6qZsqo5UdveNc/JxrvsB9KHbjOCmgqBZMnnFu6zwLK2ngCBfcxhjWf1oGBGdA8kAx8M3PsIkFVv4DwHHGsz8DfHxk0j0D0=
Received: from DS7PR05CA0038.namprd05.prod.outlook.com (2603:10b6:8:2f::23) by
 CH2PR12MB3927.namprd12.prod.outlook.com (2603:10b6:610:2d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 10:27:31 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::ee) by DS7PR05CA0038.outlook.office365.com
 (2603:10b6:8:2f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7 via Frontend
 Transport; Thu, 19 May 2022 10:27:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:31 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:30 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 06/17] KVM: SVM: Do not support updating APIC ID when in x2APIC mode
Date:   Thu, 19 May 2022 05:26:58 -0500
Message-ID: <20220519102709.24125-7-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94b69030-1311-4c9e-61c3-08da39822eaa
X-MS-TrafficTypeDiagnostic: CH2PR12MB3927:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3927562F3199BB77B2E06F05F3D09@CH2PR12MB3927.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8exGQvoFVBhwSFI9w+WbLmD2sM5x61orTRLj1Bit0oVcMuR93569BjMKGSjNHF1tAz2fQoar0DPJekbRk2qLB3YlylPv7hX+doAkxTnSf2RZrJv3LLgXxIZmuXDvBbvQ72NlR7hni28XPpoWMZDzGA7Gi/eVKp4+utJdQCYts4tu2f7kBed+eENLLdPPFyQ27lb+hcMy5L58PqIpXVKjZ4UmRv+p4WgaRfDhX9lbedkcn4PVCn/Z0GKmbbCmCisnirrdf02jukQbh/BnQBbHNmsw/1MUZSQNNNA+Pa4Nsk5JDgWQ5oqrbWBdGCWcBRog/wGDfCbHjy8fiYcKuw0gxHbgCLs1Si/DH+16HvVC2fB5ajILAvsf+o3GzlAV9xbLpep0LSsKFaMneeX+VJOgZXhhWJ12jEM+JSNfDnQo4URWEG+ZSNFhZredOfmLgEncwjd94Pnd1gYpnJklWRTPEFKFd1Ujzj9J6AL2v6F3SswooE4TTj5G9T4ivNbE4jQ+79iYiKGryaR6lpzBMYqh5IpTSN4+yR0PqQdBF/pnXOYP5mNY5J1t1QH+36rqZ3CyJuWUFjFLe0U60ZlC3fLjxFxkQvju298IolF7vTPnLvMiBHebK8NFzbB4lCdf3ty0kR/KTjexnlNYOGUuyaP3VaxvbA3Wv+Jx20FOcfgeO9tCHI8Q04iQrkJJ3nr5g1FIzPePQD2i2FEsLmVtTDKHiw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8936002)(36860700001)(186003)(44832011)(356005)(40460700003)(7696005)(1076003)(2906002)(70206006)(6666004)(70586007)(2616005)(26005)(8676002)(82310400005)(426003)(83380400001)(110136005)(54906003)(316002)(336012)(47076005)(16526019)(86362001)(508600001)(5660300002)(81166007)(4326008)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:31.6702
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b69030-1311-4c9e-61c3-08da39822eaa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3927
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In X2APIC mode, the Logical Destination Register is read-only,
which provides a fixed mapping between the logical and physical
APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
and the processor uses the X2APIC ID in the backing page to create
a vCPU’s logical ID.

In addition, KVM does not support updating APIC ID in x2APIC mode,
which means AVIC does not need to handle this case.

Therefore, check x2APIC mode when handling physical and logical
APIC ID update, and when invalidating logical APIC ID table.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 560c8a886199..7aa75931bec1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -493,8 +493,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
-	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
+	u32 *entry;
 
+	/* Note: x2AVIC does not use logical APIC ID table */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return;
+
+	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
 	if (entry)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
@@ -506,6 +511,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/* AVIC does not support LDR update for x2APIC */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return 0;
+
 	if (ldr == svm->ldr_reg)
 		return 0;
 
@@ -526,6 +535,14 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/*
+	 * KVM does not support apic ID update for x2APIC.
+	 * Also, need to check if the APIC ID exceed 254.
+	 */
+	if (apic_x2apic_mode(vcpu->arch.apic) ||
+	    (vcpu->vcpu_id >= APIC_BROADCAST))
+		return 0;
+
 	if (vcpu->vcpu_id == id)
 		return 0;
 
-- 
2.25.1

