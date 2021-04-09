Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DA135A144
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 16:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhDIOjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 10:39:17 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:10656
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232990AbhDIOjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 10:39:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naMuSY1XZe+tp8Smgo/YZER8X+AcJU0HsEo3F3gV41klJ4oX+Gj0VgxY32E+/iRORiyDNWsKT6XWJh7RkbgHHCgHelD1psmtwU0yncOkUgjY3zlk7K2pSfaOd3IbD1eOeSO+0oFEMv2jPs0KJ6ovH+Vy1G0nPLo9k580xQ2jFF3o9SyBJd4CxfCx2qR4FN0+sM+5Sv0UcBmTynTKaEUZcjdT46TXXWVibqBIZLtiwa2xTkQ0NSG3FHBiyvBpsuDKAw+XNilJPO+cK5BkNTQ6SejRU8kwsUIYzEUQ/+uRL4s/3I0Hueja9bx/sxVns12Q0XFI5dAfC+JJcZsFGahZww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+aiyox32en7oa/GuwpXrDIQJAZsf73+oicLCivVhTY=;
 b=E/5mjK03rj2LVTYkPKOS7xdVjac82w7MR7Jb2UO7xvw/eI2hrZ0Zo3PHQe8vUWtbTr0bqB1Z3hjcymANKrWZzD2x/98iU4/C+JnAmTdrLfHeF3S0u5dwdKwkoQX9S366SOEDgJE/xck6alr4WhDNto8nvsKyv/QTZHIDCAF2wwg1jsS1uMXever2DGJuJTqNf2+dfYv/ciJxNcwNdRIeiD2b2hUaUpdV8LYOatuO4GCf9Lf2hS6J26q5zRWEREZ+g9bN8NW5yvWi9ip6m4/23uw6vnYlDs/TpZ8JaR1hDCZ8ubEbFEErj6Ai0ECEVoFA4FB3s54WL0HSG1rfwanGVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+aiyox32en7oa/GuwpXrDIQJAZsf73+oicLCivVhTY=;
 b=c9a5mpOSmASf5/an+BlbVJ8VSBc++BoXaDfMsfr9WSIRGA0HfT4Y1jpQ3Oe20ZVCaVdf/xSsd9LjWPe/35NrrlNv7cfgawc8xgJlLtzgTQ1T8qhl1590/THRKeU3z4fk/050ytIwOz8++q9LT1/LuDR1lRUgZidmgIrwrMYSYCE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0123.namprd12.prod.outlook.com (2603:10b6:4:50::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.16; Fri, 9 Apr 2021 14:39:00 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4020.021; Fri, 9 Apr 2021
 14:39:00 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3] KVM: SVM: Make sure GHCB is mapped before updating
Date:   Fri,  9 Apr 2021 09:38:42 -0500
Message-Id: <a5d3ebb600a91170fc88599d5a575452b3e31036.1617979121.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0109.namprd05.prod.outlook.com
 (2603:10b6:803:42::26) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0109.namprd05.prod.outlook.com (2603:10b6:803:42::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Fri, 9 Apr 2021 14:38:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29161cff-df3a-493c-0116-08d8fb6536db
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0123:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01232B054979176555EA9C92EC739@DM5PR1201MB0123.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1CP5BlPdmpqwtFvp9s47+vj/a6Fb173beEJf2GnXCJ8R4nIewiubLAdzCEM4ad7kA93yGWxFXX2D2opssSh+Gqkq4+ymkL9Ka9EbB8tdbJxquI0eGUDz9mr+FV34Vpda3wNdMBBFeUS3cUbacuoQakl7LIj/cOzlq0adf5rFGPmSW/pVSjaUXMDeHthJnUZKXeCXiJvma6w+BCq5UYuCtP4aO/Yw+wzmkSdeG8iwrhYKYuxCMLK3IA75/hgf2scXR/BQTo3YVEf1ql2xHebVj4Q7sc+m6rj1yr5OKBcSWmNqlsHs+CqnBG5IwVitZ9QLLx8a4b2lArdyi8vkWvxfZ71mVgnmAHBZaISxorz6Giamcmj8nHcoIjJQqwF6jzDPoKJ947cEtle4caOdOPYxCzT2UpKDWVsKCDVXkI2BH96yTnLy+bTdXEGwC46nldp47dy1SUxwJj6fOMa2HCN4WHKyjCIEF2SJN3kNUNRk1nDico5Xl7ejd+Nze/I4jHrArM1nOAT+h/YckvjfkqgzT0TV5utnrUEWuHjXN8FUffWpzP6P2ls596GkJCpzokhUSYkYrd/SVQFo/i249UCTh2jt1iRpZ/fGLWOLhTIRKZ08YUC2zRPhYKS1BWlks76DaS6vX2x8ssrN+FgXUOiCDDSvEtdK7AXIUGqQOOrYf+mSRFO3JSmV2Rb8a4hKpoyz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(396003)(136003)(346002)(36756003)(54906003)(8676002)(5660300002)(316002)(8936002)(4326008)(38350700001)(38100700001)(16526019)(6666004)(52116002)(186003)(7416002)(83380400001)(2906002)(2616005)(956004)(478600001)(66476007)(66556008)(66946007)(26005)(86362001)(7696005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?c9Et9mnF1m6dT8csLrBwXVFdMIe7as1u9pumdpHxR1tUwcUMgwBSUg5r2tCc?=
 =?us-ascii?Q?TS3CiUmfgdlvkdIECOdDUKgPb+hZQrLlKzsNCLJKIfUDKMuq46xPmRMap07r?=
 =?us-ascii?Q?w1dp9wRFZkkKgAce+SyhBcf4Avq9N9OqklwpgE6Ih7kekwp9DSbG4c6WlkXR?=
 =?us-ascii?Q?miE/Z5m5hz33xy5WXVAYnsP+V6YSnCfDDsS2ZEt0mYh1NWKKC32l4nDYXQly?=
 =?us-ascii?Q?SOii2yeTOZ4kp5Y74ajK2lw3aOyZFvfoLZd+FmRSmWKXCTTqv2cAwjNnqiK1?=
 =?us-ascii?Q?HUXQX9owVKEi/BKRXRhDsBDWxeZcBdXEKc6dPXgTPz4GASnBgKSPpvnZUvGh?=
 =?us-ascii?Q?ypCdGQuJT+60oc6b717A5eH+glMnzewxNAxkkfCi2Vcc/+gYsees6GSmLnKg?=
 =?us-ascii?Q?5WABpag1+62P3Q+lPqH108rXv9m6yBhB66AKl775ZRvLi55fKqIx4t5iOYmv?=
 =?us-ascii?Q?gtntFuwKs4iUWG28e/4fQtD4v71NrPRhv/zf/jV9NZExmgUH/aQ5j+J8VePq?=
 =?us-ascii?Q?PvKUu79gwoY3SSYmM8KNpucd+NhFC9m2IoTQKgQJhIHj8bI0O0T+Bz43drgq?=
 =?us-ascii?Q?4y8d8MrlZXl0UEUNov70SeeoHm+JAls+gYIa5QsuRjbAUwqoehnUcxu5kcSQ?=
 =?us-ascii?Q?maTPmovhH+I0KqqMnw4R6rluLHf7p2XoZopKnJnGKN502DzCyuPSdluwyAZz?=
 =?us-ascii?Q?CQR9irkSZJnos4riFuyDl0LrlWesofBVn8aIZ8tpYWx3BFHvWfK/HCPso+LR?=
 =?us-ascii?Q?hnXQ5G94nOaRg+D2rp2/3ZYN7dCIK+OUTCzLBdILnaYA0jbKOIg8E4JAzWKf?=
 =?us-ascii?Q?/It1PIDid1NehZx8VSgTT3vK71IReRwxaxYe2i4YqCniIR5AkNgMI0BFIwPo?=
 =?us-ascii?Q?PlCKDUOkoo9vbggp7sMCKR2XM/RqUJuABMa/ld/mRpXH9w+bgeAkIvtGbzr4?=
 =?us-ascii?Q?7u/gXXkE1n12QHOj6FVTT7FaGvjo+Y39Uf8vZi6SyX3LfoNsKWXNF/sqqTcS?=
 =?us-ascii?Q?XCp2VlKcrD6rPIrlaGeF1L+lMzS3YoDXQ/IqC5q+L5Mdo5jVLd7PyprvuXS2?=
 =?us-ascii?Q?enhyiKaqsZ38caQYBLjeCJrYtA+Pk5Bh9rrevrQNhINn9YzMqWQG28ukfDr8?=
 =?us-ascii?Q?ET4ZkMQcEmT0qEHgjpkGuJ//WaaohqKezLQIRzVVc9cPzBwHBGK6E1L4/ZfU?=
 =?us-ascii?Q?fQAJ3wDL9MQlAp0nvdibORg9B9rkemirJAmsyMOo3q6N82LGuKq5lGtHwPZ+?=
 =?us-ascii?Q?FZkIOsQKPZeZi4V/9Fc+X0/EqwNgtUSoP9Kej7XPyCfFe10ZeBlLoxEPJouN?=
 =?us-ascii?Q?80/iioyp5Xfv6lKDBnhCz2xj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29161cff-df3a-493c-0116-08d8fb6536db
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 14:39:00.5765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0FpKfBD0hkVPOeFParAAMwO2DusjQaWD4EJSfJ/1h/t5qyX2HHSowtQfBm3yMcUJnerpnB4zF0ookrV61gVHPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Access to the GHCB is mainly in the VMGEXIT path and it is known that the
GHCB will be mapped. But there are two paths where it is possible the GHCB
might not be mapped.

The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
However, if a SIPI is performed without a corresponding AP Reset Hold,
then the GHCB might not be mapped (depending on the previous VMEXIT),
which will result in a NULL pointer dereference.

The svm_complete_emulated_msr() routine will update the GHCB to inform
the caller of a RDMSR/WRMSR operation about any errors. While it is likely
that the GHCB will be mapped in this situation, add a safe guard
in this path to be certain a NULL pointer dereference is not encountered.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

---

Changes from v2:
- Removed WARN_ON_ONCE() from the sev_vcpu_deliver_sipi_vector() path
  since it is guest triggerable and can crash systems with panic_on_warn
  and replaced with pr_warn_once().

Changes from v1:
- Added the svm_complete_emulated_msr() path as suggested by Sean
  Christopherson
- Add a WARN_ON_ONCE() to the sev_vcpu_deliver_sipi_vector() path
---
 arch/x86/kvm/svm/sev.c | 3 +++
 arch/x86/kvm/svm/svm.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 83e00e524513..0a539f8bc212 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2105,5 +2105,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
 	 * non-zero value.
 	 */
+	if (!svm->ghcb)
+		return;
+
 	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 271196400495..534e52ba6045 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2759,7 +2759,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (!sev_es_guest(vcpu->kvm) || !err)
+	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
 	ghcb_set_sw_exit_info_1(svm->ghcb, 1);
-- 
2.31.0

