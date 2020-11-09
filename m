Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3932AC866
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgKIW1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:27:31 -0500
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:58363
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729452AbgKIW1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:27:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAaAJBDQs6+YUC5/QhK/t83EsPWYr4DlOSg3pyR0LDrs8O1LenCwwMAHvv/6SZfcdnTg9K8uAryT7XEejSL85+DhHuXUsvfw+qEp/3ft7SiOtxSWchdAIKPZ1r0R9bVDBuCWPbWg7i4G5rpmRRAq19Jlozca1XhxgHiL5sig4premHj57DcBJKMZwHTyuFP5sT2RZTrds9tJ00Pq2ld7qVRW2YYYDl5jabby1A1/cghs/tRLuU8K5evEoWrCaWCHM6je9rpMp+pZfEciz7iSyvT6MM7HJPvD09cpw4QKiJpUBMaC91J11IsO8uHr7YoU9eHWRN/mA2cOGc/Zj6lu0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RhuXIfqSRyztA4U1jk+19FuqBF3k/BPQjzIwfqFKtA=;
 b=GNjSLfGsJ/hYrlBnOLqQYM9foISzHcRO24Q8gMWR2Pl6hiGZM27auv+yfmV/X9aB2mQNQnqdsMElEvj869y6MJA/lV7tfwn+zIfvyNi7zOlNPXRCURApe+Myj7iKkwKPqUzA92wIwRLljNsGGYw0Yk2AqaEQcyYAzc4J4ANaSKJIkTPaFP2uhB1ACdyBNy5AnPc2xTmYjIhQJSr/180gwjecxwK35ACAq7snk1N+NHnhdNHk/AkvZCYV101T2JcJaSoeIw+EF+L6oUgJ8U7lOFufY0Ns6NvO8RPhlhGQGDog2sYjG9Gk2keCssmEulypyEQChPvP9GXFs8x/mwLSbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RhuXIfqSRyztA4U1jk+19FuqBF3k/BPQjzIwfqFKtA=;
 b=RADFxLV/p3W+lz8/3GdQNCtxRBYZqL3hqV3oBLyya8xyppn8znmrP3RXw8a1YWwlS9a06UT8m6QepcG866t3JsqCNfhJfx2VfU8tHySn2aNs1rkggf1a2T2sdkAk7HxljxNmzFJBpb6g+kKeOAOFBCVyDPwT9ZMtSrHAvhEIQCA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:27:27 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:27:27 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 09/34] KVM: SVM: Do not allow instruction emulation under SEV-ES
Date:   Mon,  9 Nov 2020 16:25:35 -0600
Message-Id: <c78a24d5c617c2388263f157b37d5331e3dc1cfb.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR14CA0062.namprd14.prod.outlook.com
 (2603:10b6:5:18f::39) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR14CA0062.namprd14.prod.outlook.com (2603:10b6:5:18f::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:27:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19757c2e-6d5d-41d9-f467-08d884fea30a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058A7BBD3487EA127D12A0AECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s0u8BjGc71/L9m6dLfCd5jupFnLd5TYgAKGU8OBPBH/mmFXJ/l7Vs14JchGyh2gI84kIHkgvKy4BKN7VISPswCMFRVS1xFM9xXUvRZ5IaiZmnQLBSP1TnwYnoDnZt8Mm8glYcEu97uQE+/HAmzAIxgcmlq4wWzrl4CAp562dvFT+zKCsUU8gGnac3JMJoUHoSVWNxYuWpj4pci9tnL2SD/y0YWJlaW8gVEVTH24sEguUYEOCTLKbR2H/5rGExf2ZY++NHrxP786wHPHRPdoEKabnt/AB1szef0EEAlL5/orXMaXnZIyOQL9OLvvI0kXFAD4Sk5E2TCOzfROGEDuytg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(4744005)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mpyXP7RPPoY45v/+6atLfpu2OATHa/9EelJkcPVimPwAt7Uiw8dWSkvOa242sqyAl+greBjtU4AyuhjbAOg/styZA7lxZ8xDnjf2XdJhFYoB6Hpayl3U2A73fhknQHv5PGTpgfWcjb5NhYBLaLUlbucGZjbCcXhJ+XBcbjxp9qCCyU/HTyYDQTYuKy4A61inyDWokElVKGvWzmYdfNGU7njcDEQU+il/T3gsJm06gJfnSKa39EoVdGpCfU3YNBkSQSYQlL/YLoU3yuIGOk0PcvLI2yM2zTi7NOp1T5hcUq4qlTO2x1MmLSUnaLbFnip1JLMz8Rr1ta9UzT2fA452ZeCIHIdRvqfJ0j7PRZ3gwF2+ReA1TdPUQK0wJuy3F+ft1OvdVQ22uEvAAeZxNnur9Tfegqz8IoMKnk6XFM93SByPHNRp2uL/sa8lsw27Fqa1Lw5tol4myrCNz+conxTY07Zlmgv+9K1rEZGuHS1SXifBud8PN7uEi+c873yM2JBStV6zMObWFf0l1YbrqUYEcGSKvT8zmMOAUoQjPSls4ObUCDr60YrFMPQiw84u7O4xU00jAR4m/DzLxNWzOPCKBcrzpsrTZrPFMvjO4jhfkTw4UVa39VifK/aUXoi58oRtVu8NapT2ak4ZBxwTu478sw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19757c2e-6d5d-41d9-f467-08d884fea30a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:27:26.8657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5YIlCHL+zqoWRzcS8ISEPwILYmErdUjTvJbt+KdbDQAfUuIBDhXZTl5C0av3Iu2t10O2We3/xMZuXuxD7I7jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a guest is running as an SEV-ES guest, it is not possible to emulate
instructions. Add support to prevent instruction emulation.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7f805cd5bbe7..0e5f83912b56 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4195,6 +4195,12 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	bool smep, smap, is_user;
 	unsigned long cr4;
 
+	/*
+	 * When the guest is an SEV-ES guest, emulation is not possible.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		return false;
+
 	/*
 	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
 	 *
-- 
2.28.0

