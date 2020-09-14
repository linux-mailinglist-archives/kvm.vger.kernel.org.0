Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB73269637
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgINUSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:18:23 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:7038
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726161AbgINURp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:17:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFq+VQk/CfcZNVuZGvfZyXMDvs6eRWLioct5gifMtiF9sQ/zevAZXpejO1DF+9to7TZxjwb8oIsNRmWWtTPglD1CqXAfKr9IFMxWdq+nMDKAJ1dITAQSaSbEwVjiBgQtZ8WGoTURfOFHnmP5u6jVdpxb3dhAVudfIxggdmaTKIQfv7e0LfXV8Z6seUiDGi2JmW7QawNNLfFaoZdawD+SazWGvI+WVLI+8J3q8qwDvorKc1gYOqFeN/P8lfO78edA/JAvperQmoYzNXVL7oUthAK2Jqtr9UiyRU91MDUkTCEo252mVPZ1pRWyoPR+ALMMqHvuHxVD4u6sNSvi3g4V4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BvxN/opVS0M6RRUBUGIg6JNjdfL/tcEMRo0tXd0+HA=;
 b=PTe06S1brL/Um0zu6/U8E9/V2hx3gLp7wIszC9q5fYfUAC9lDVLqbggU+9ro9/Muff67WUbhlJ+0Y2DYm0aBW3BmgqN2QdY7vngN9QRYnlI4sbd5eQTNO5Mb5Mqzvx1n25Xj/mEYtvyTd40gab3E531UJijWkwX5K7vgaR9piWeg33GrdfoNHzKFH9HsT+OgC2oMRGEx5jXXumnzqJlXLarFO79mUVuPR+KubuSJFQTDBKTeFQTz1jgqeVYyyHPFBjavyhlh4KS6voAHytsTQzfXq93+SqLJcE5lsX+CG6hb+fEIzgKbWoaozIOTa7Lb5NgTBkeP5WC/NhQIyFhTbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BvxN/opVS0M6RRUBUGIg6JNjdfL/tcEMRo0tXd0+HA=;
 b=bPw4aqJCUi6CoiRPASzXufLPAgEJXZ3xgWWjZGzR61FJaWrIUsoJjmGlE7TldzltLLjZ8i4EqYyh8K+IKxt5D4rxpgRkVQPYAJd6wIXA3iAyAgiaEN2CyjZW06MPLlhzV1p+KblK0JF8w83uIEXuBhfE86vikYmDpaKv0lTLn5A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:17:11 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:17:11 +0000
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
Subject: [RFC PATCH 09/35] KVM: SVM: Do not emulate MMIO under SEV-ES
Date:   Mon, 14 Sep 2020 15:15:23 -0500
Message-Id: <c4ccb48b41f3996bc9000730309455e449cb1136.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:5:bc::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR13CA0006.namprd13.prod.outlook.com (2603:10b6:5:bc::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.4 via Frontend Transport; Mon, 14 Sep 2020 20:17:10 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e46faa4a-4805-4088-1476-08d858eb297a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11630F01B51017094F12899FEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hLtcEQo82JOwImHwXzkdqLuydAUSpBU6bZ/IbQuScdAOWa3uHP+0R+RUKgOYLvuhEbS/N02fW+nHqUAI7Ooyq8dqJb/BCjcIT38csLdZ7BzrhruscaV+8MuuvJumQeLuydo7B0GgQFaf4DdY9gEaGMwykjcjZAAsoqHOQQi/1p4AUufokQNTdcDkerGCD52IZpeWKPuz3Yf07zdpCY2ue2/W0xb4WSdVDlcu74XX6xErIqk/YBXOLKuq468A+d57BvugxRrd4JvjK2qtBw0rSy8wDfGFymzj9UOf7DGr5ah9lEzsAs7Tzl5/7FCgB67GaiEVeD06RhB3Q7PnfdpyUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 06vqAw2W3Gxq7lndheMiacZs74A2GFy0N/RzOZVa7fadfbxk7eoia0O5zWwdRlqij5CRneY5wpgeAk2KHsWFRPCPxRlNhMIeCb0rJTwUzboopLgTCn9cL0tAc/9naWJFfuFCUBcyY3ltGg9YiRN6K7+9ugiWUiGh48x1O/LDR+v1CZjfbM8eLOzwGHxicS0isUa9luSCIrQGnxg963aYJp4R49XhWhyPtT7lJTN8bs5kdW0ZwRF71mGvSspniicymGMNoYdSaD7FGo5SyhJKBPcetrBuhPM/akHmc//28UYWWlPNgP/TK07srdisYUMLBp5twcnlkA8dx0+0bjbujkRYw4OUjKns7J1q8y/C5xHUJWNBdlCjvDIeYZv8lvMJksQyXt0ILxqNMpShyZMF142p0YipM426+VV8Z90kLi9HUSTkz2d2+Lv+Z6MQ/wuB2DqLYZDOmGaK192BM9vdCHVtngPuRNZ7xLUaUZ6JZdVpB58BTP0JLNfkPzepDPb+nGGP06O0JZUYFeobTUS6zIVYH4fNFdSw+K1GoqHhD5p6WaAfQ5aaY+uV70mQvoSf6HuUjmulG4yPi9mzvKweb9JkLqTdBUjqBvpWoOtIsipO0nckAWaZLFS4xKjEKKcLFskGNi8S5tp/8+HGWV/7cA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e46faa4a-4805-4088-1476-08d858eb297a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:17:11.0949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBbYJR6pmB75RPy/3wE6WLWZeNBjp0kpN4T2MsuUWbnb1USP9Rnlagv6mLZ+qD/+0jrMQ7MEAJTsfpzZ1E5soA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a guest is running as an SEV-ES guest, it is not possible to emulate
MMIO. Add support to prevent trying to perform MMIO emulation.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a5d0207e7189..2e1b8b876286 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5485,6 +5485,13 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
 		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
 emulate:
+	/*
+	 * When the guest is an SEV-ES guest, emulation is not possible.  Allow
+	 * the guest to handle the MMIO emulation.
+	 */
+	if (vcpu->arch.vmsa_encrypted)
+		return 1;
+
 	/*
 	 * On AMD platforms, under certain conditions insn_len may be zero on #NPF.
 	 * This can happen if a guest gets a page-fault on data access but the HW
-- 
2.28.0

