Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B279281898
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbgJBRE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:04:56 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:5358
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgJBREw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:04:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BD0BlrBuidbqVushDdDaq07x/x+OGVE/JwxU+ybVzHWu8FI8+sJq3yGGS4e14F2qrHMwc8eEAB3zY2z4VqOqvggbdIsq5GpHCso8H2r7I2s7KQ/vmr30BCr1P2X97MsdLvnzfT2UAaRKyhNLsJXEJRzjHtLQsNnd9RYz0UvaM4ZdST4uKr+1pJpbp5evULNl0xSLb/NQnJo+EbRcbl0xw+UJq2bHHWGIna9mf1egouZ1Yzp918Mzqi26KCAO+KaLELskz+nrx45XRafCJggQxot6Yd3OaQckvOLe/KKxBL5Zra7iUlG99ObWjydGL+w9uF0E+KYnFZiZeVIFpZ6e0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNn3jaew8XO0L6no39bfs+U3xXbIJZEge8BMcwA5xaA=;
 b=T+XW7NHkjPmpVuYr/hhS5ETgzmxDTV3WvKDJDnCqhDSeGtPXf2p+82sjUnyc5WwKayHJ3h5652xjnQarsLvoryWHUoZdgX6Q0tQJUA9kRxy3uPmGf6pvftmvrlZJW1NrF8sgmN3pkl4GZ+zPNo6AYSDwomF8olADS3z3WlRvGqB240S07UxEV646SEL7LpcqrJA5r5luYagpPuY+x4ErhBEnVtyzjDtG/ji5U6PtB2GVUTpqT6ZFn3d/u9FvA1YyrkvXnvzPWoZ4HUCVQ3LQLCyj+oNyJpjd11hQVFYgylfdOY7mhfaM7dzE2AA8XQmum423xIgNC0QijyrHUCB8AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNn3jaew8XO0L6no39bfs+U3xXbIJZEge8BMcwA5xaA=;
 b=GQg9HH6/myNIlMHvUU8F0FPtz95PvzM0B/SivkiDUmERmowd+gTeBO5YEs+sFrHhTXykgOyCdaHAwWrMhu+K3bBQgDI30tmF7bf6+GzxyllL7kV+5bD4f2hOy0iE+2u8avETplrob3Shu4W2Ud6cIo8OqxQAchzp1THHCXeg38I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:04:21 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:04:21 +0000
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
Subject: [RFC PATCH v2 08/33] KVM: SVM: Do not allow instruction emulation under SEV-ES
Date:   Fri,  2 Oct 2020 12:02:32 -0500
Message-Id: <e06c1536f1bc6d34df5a683a7555d711051cb8d8.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0023.namprd02.prod.outlook.com
 (2603:10b6:803:2b::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0201CA0023.namprd02.prod.outlook.com (2603:10b6:803:2b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Fri, 2 Oct 2020 17:04:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a1af74d0-1c2f-46ec-cfb8-08d866f53488
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1706E96B647533882494DB92EC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bGrksvNLQs9Ojc5ltOzKOMMZkdrVoZBYYlbpxC5KXULnpmCmPKRduCr3sMgJYFlCp/wlz/Nb+l3T1+BKt0QRxxEvEnOiE45vyBwRxDg3ySGY5EM+pySxXHqu/ssMpH3uvry1EEbjM7OZ/6+y8lzM2sUEF+47HtBmVSmZgiWBIRyEaIpxwZfZBLtPfzj7cMYjQ793mmtKJGrvkXdCkbXVLrbXE2L3baXDZPPHKwDsLzjBr7dS9TnYcJKQ28TNa7jNX/guZQ1tFtBnrm86wTsj3OcLSh97anOruJPH7QKD0kvupyfr4+ETDb+wWww3kLhbIQzJTDHeaS9ZAJQuZzfv8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(4744005)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gMxsnkguLBkHF1J12g9yol7jMkukQJYRojrDLrZrKxl0vwf3FVJRbmPJJke0sKax4oQEq7HzhWxcu0RXcby72FuAjFwBehJHikqX+uQKFS0HNgAdJpnJgjbpjgUjy8ulzBe4dJuEMlkEPdItBhAhiwVoI4otjPD+8+bw/vHKD5gfygWJETLtbYEzsBc7h8XrTZUfq8s1wzAuoXnX5Xkp+qEy0YpPylwLobKoJkPF2shT4vpNVC1NlBFfdjpB7jh6BTzSTas/CC3qaipnkZriceLBX5kdhGwm4hsLqOFMqmlCshd5eoWrBXIZjpoWgxu58elVwFDiMWM4SkRWAQ34wgS0ayJf2NDe+6c3535A7TACzyGRWoUMEB8QBIdnngJX4jh0rezhjG23dXloOXNHFNLz5RefDtsL6CKV/BROXywN/tOFr7Y11VQ8q9yffe3pJ02lfKsmFCBqOJNUTEhZnETJRkw4c446IqMn5GSgo+oB2+TtQ6/yJOzV2U84/HUBzOD51zoPie6J+HEfZMhw/b+4kjaqo9tgatb5xtvWOyAF1KyRAKTGnKTfTwMRjRpkRSQEuqOFlUAroyEy7zZqjqRMkr5Q3L9ONDBE/rhO8rbzJ9crTsuOG1SFkJ5VmUeILO5p5Jqp3I37Pg/3lfRdmQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1af74d0-1c2f-46ec-cfb8-08d866f53488
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:04:21.0375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzY0mGuxJOr9tZq9VZHCC4CJAyW322NiYlv1r00zRWbr/Gk7/8CFzoFsDcg/QhcdXDT+jq1ed5BoKh4Of1TAOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
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
index 5270735bbdd8..51041eb9758a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4201,6 +4201,12 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
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

