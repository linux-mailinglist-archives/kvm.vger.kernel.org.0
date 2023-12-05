Return-Path: <kvm+bounces-3638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A504806177
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 23:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C9B11F21704
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 22:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE1D6E2AC;
	Tue,  5 Dec 2023 22:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XmlIOII2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D3E137
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 14:12:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nv5rwPoNatBMwW7gS1TdOBJnIdUXUFyWxj0eczNcrcHDId/AErFa4sXATZrT6rpWqgW0f4fjN7fUtpo59VG8SDUwQPuFQGm89pbDOdg7pcAlgXIeD9WZaFAT37jbotG5o585PK5XUpihaRZSp27mURQe6KTfF6GtRAFATdGvjQfhKCsHv+2HK+gYcp/GVLDJJdhKWEAE/Ng0Jm6/tEy0DDeNmkHxbyJpr9puel7HM2xii1c7yMwbda5T+FCjVYuPUvCVTdQRgAg0Suzb5QJ4EbKDsXghJ2awIPecUT+5UBbRpQDSZF97P6OHnjOgbtgZXkN/4T9zCUjyfPLY3Exa1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w4WrwYz0+JnRGSL8lDXgBOkvTcgPdke+ZNtp26tX+A=;
 b=LbQsXHXdMYRQ/9fxprxRnCl/5upfd5jUjCcIRaQeFQd2eiYPMuST2HygIjtRJYBKwG6bVko95AptnpndAYE1+PSnikitYJXgAmXIRc8yRYGNXRD3p9ZZaLObY2wk0R3OVn75bskGnCMRym0oXwTe1g001JCz0v/yyVz+4in/B9Y9SrZlNnFiMzmJYglYRDN49KNF5nfOugUcKP2AphHxiyco3U1pLBVe/sgZczh6yEypBFgwo7cLKGgzoTajcu7ubRJ1losGloGeBPPkHULZ6f8Hy3G4eIr+KnnQXx2v16dJT+u/oDWVbhsa8JeizxgZAr/Jdx8Y+WB6Eh8eBBfDqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w4WrwYz0+JnRGSL8lDXgBOkvTcgPdke+ZNtp26tX+A=;
 b=XmlIOII2i0lmJODCp/sKaHpojmB6Og+6JoWaYXhKdsmwNnmXPWC11zza0x8kTgswun4P73feKZX95HPVq5XzSjdV69BWCkge0vXxCxqoAOggLrQ6f0a5RRCe/QmQehgTbfwIA66U2sjcDkxytSg9w2TR0VSg/CGq9KiSpsdvGT8=
Received: from CH0PR03CA0263.namprd03.prod.outlook.com (2603:10b6:610:e5::28)
 by SN7PR12MB7370.namprd12.prod.outlook.com (2603:10b6:806:299::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Tue, 5 Dec
 2023 22:12:44 +0000
Received: from DS2PEPF00003440.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::29) by CH0PR03CA0263.outlook.office365.com
 (2603:10b6:610:e5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 22:12:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003440.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 22:12:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 5 Dec
 2023 16:12:42 -0600
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Akihiko Odaki
	<akihiko.odaki@daynix.com>, <kvm@vger.kernel.org>
Subject: [PATCH for-8.2?] i386/sev: Avoid SEV-ES crash due to missing MSR_EFER_LMA bit
Date: Tue, 5 Dec 2023 16:12:19 -0600
Message-ID: <20231205221219.1151930-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003440:EE_|SN7PR12MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bdc09f4-4b81-4923-b51f-08dbf5df4e22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	I+hspJ5DRyov8XzIVxprsTVWZbGhKGpZ75cNq2qPN20l0WgyKUSuNR/frkwQZMz5JPyuqD3/fyW8G3Tca9rAty7JCAOoYuigZAKetFag84pio4zn5erZEB0hv96Ph8ZVGNRb2kYwmtcmurmmDLOSIEUhwgcYo4VkoeV0j39Y2heGtd2l8DPh26usYL/dpkFYoXkeXhoQA0XA+HEiCUq7+Imnsl0YkEwvA3b0LckWrfftto/VKxYXyUbk0GWooR9GBlKfIUemVMuJt+cAYhQhhYILKxJAqIw98vsfjuvNXrz/IaEEie+hINPZ5DivvfvBvB8M0uy1mplLv+qO0QQQm+/rYbz17AUJFWXf6szIWkrjqvbkoixV8KefvvQ8UGiuDjuvbUyWrS9TWN/1hRcHfpmt63xgrdUl2Pt9xMjVFNKPmE6biTvouO+zK6obap1Q4rekr6p9+A//m0UU5WLdrlfrfbskLfN+/LLbXbp5/JzvKo+pHtE9FLgM5vSP7y4iNK7Gtiy8VxpGLDFYOOErLZ2Jew7T7OZplVv5quKIRC+ypSUtFLGm/4CMMcOTd7hsJTyWAvzYo7+DXhgqTBkV67ShfOo6SXmkXDg5wosp054l5vO1wcA7akMumY2YzuK/TsLUJGGZwJGuLQ/2zArf5/Q8WUfnT0rhS9a0xoooryh2dSQFS2VfeFJPaCg+WfnsSt5tQ01WKwYeI5WGEDJotkWkc+fOW+wqRkwvHnChHHQdS5OCdbLcTmMsuLeU7PaYwyX49km0DdprQ6a2AtGgJA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(376002)(396003)(230922051799003)(186009)(64100799003)(82310400011)(1800799012)(451199024)(46966006)(36840700001)(40470700004)(44832011)(316002)(70206006)(54906003)(70586007)(6916009)(36756003)(478600001)(40460700003)(6666004)(5660300002)(41300700001)(2906002)(26005)(336012)(83380400001)(356005)(426003)(82740400003)(47076005)(2616005)(4326008)(16526019)(8936002)(81166007)(36860700001)(1076003)(86362001)(8676002)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 22:12:43.9529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bdc09f4-4b81-4923-b51f-08dbf5df4e22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003440.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7370

Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
exposed a long-running bug in current KVM support for SEV-ES where the
kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
kernel, in which case EFER write traps would result in KVM eventually
seeing MSR_EFER_LMA get set and recording it in such a way that it would
be subsequently visible when accessing it via KVM_GET_SREGS/etc.

However, guests kernels currently rely on MSR_EFER_LMA getting set
automatically when MSR_EFER_LME is set and paging is enabled via
CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
MSR_EFER_LMA even though it is set internally, and when QEMU
subsequently tries to pass this EFER value back to KVM via
KVM_SET_SREGS* it will fail various sanity checks and return -EINVAL,
which is now considered fatal due to the aforementioned QEMU commit.

This can be addressed by inferring the MSR_EFER_LMA bit being set when
paging is enabled and MSR_EFER_LME is set, and synthesizing it to ensure
the expected bits are all present in subsequent handling on the host
side.

Ultimately, this handling will be implemented in the host kernel, but to
avoid breaking QEMU's SEV-ES support when using older host kernels, the
same handling can be done in QEMU just after fetching the register
values via KVM_GET_SREGS*. Implement that here.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: kvm@vger.kernel.org
Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/kvm/kvm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 11b8177eff..0e9e4c1beb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3654,6 +3654,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
     struct kvm_sregs2 sregs;
+    target_ulong cr0_old;
     int i, ret;
 
     ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
@@ -3676,12 +3677,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
     env->gdt.limit = sregs.gdt.limit;
     env->gdt.base = sregs.gdt.base;
 
+    cr0_old = env->cr[0];
     env->cr[0] = sregs.cr0;
     env->cr[2] = sregs.cr2;
     env->cr[3] = sregs.cr3;
     env->cr[4] = sregs.cr4;
 
     env->efer = sregs.efer;
+    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
+        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
+            env->efer |= MSR_EFER_LMA;
+        }
+    }
 
     env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
 
-- 
2.25.1


