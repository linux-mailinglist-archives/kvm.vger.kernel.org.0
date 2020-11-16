Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5459E2B4C0C
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 18:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbgKPRCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 12:02:34 -0500
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:16737
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732502AbgKPRCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 12:02:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEil32iAGq+WuwvOY8EzR5lTZHzVQrpndhhU00DffZsIsoYIvPMug7YF3+u3gjQyoOYx1wDIho49YZW7zqR2KZZNaoBxZ1GiVkTINhmVXdjyxEDrI0vqyvFWQAoGEHIhdwivpiPEUhPLS4G/fnRqDHmmmgxSXO/6L1VbzES4ejI9fEVQzCZAZfgQv+piX6E7CmBb1SpNWxlFBGWuNyv9elSnbFJCHL5kTlIRLP9Z6rgaCCV6P1XRrwlGWM0AakvXk3+G637GmiA1gxED2QfMGPbZCgGaJ5OHr6ag3MUvGp87zw9XKCKCX90gzw4Zqbdo7H49ufMV3gy7NiAfatuiQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HwLxd1NROFUCuu7wqamBzkODr/KJ5H+JQDwMutOx44=;
 b=RGoKdAtso+Ihiv2d9bJnN8cH3+TIjueNmuSoYdTXg34lRG457SvUlH+skFG9KdrX8KVjxVmMJ4ZBgxk59BDnMpGzD2Yzu9ajMs4tEn6U1yfmKp+HkrwTx0fbr/KYWdcnYtkTs8DfZqwWEVi6DOUFLB4a9QydJnv6g86zGMC114/Y5gimnkAICgk8VCtMd0ZvsBXOee0Y+bPE7SkkO1qYKwOP5WiSm3F+JsVZZ4OF0TVzaJxu8pgFTvE8YMXzs8s9ryjKdrKNn62X1jKT7NowDdM+zn4bZ2Uve0wz36QnRDjQEALeb6HivItO73nKDhYRso5RicwfpqiuYmHKJ3TTxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HwLxd1NROFUCuu7wqamBzkODr/KJ5H+JQDwMutOx44=;
 b=ER0ESuLF5uHqI/RNTM3O+lHYg+yhhGHL6bARCEBoMLStilAmuk/65ND3xnpOazOKh61H670AO6aycdVGZLkKZVzRt5FQFEBj9JNTYULgQGE4KyHxOMRizJfoC+egqu2PwfiXsihb1+ocVHBR1Cupj2Ply6j3LPwZp+GVXZX+IMk=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4603.namprd12.prod.outlook.com (2603:10b6:5:166::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.28; Mon, 16 Nov 2020 17:02:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Mon, 16 Nov
 2020 17:02:31 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH] kvm/i386: Set proper nested state format for SVM
Date:   Mon, 16 Nov 2020 11:02:20 -0600
Message-Id: <fe53d00fe0d884e812960781284cd48ae9206acc.1605546140.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR10CA0021.namprd10.prod.outlook.com (2603:10b6:4:2::31)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR10CA0021.namprd10.prod.outlook.com (2603:10b6:4:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Mon, 16 Nov 2020 17:02:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 875cb946-18a7-4e67-76ee-08d88a5167cf
X-MS-TrafficTypeDiagnostic: DM6PR12MB4603:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB460391EDD637742E792ADBF9ECE30@DM6PR12MB4603.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fPKmZAgwSpKl6m6q8IK5TGQNMQSgMW0LIC3Pvh/PxLcqOJ11JrMRZkcwqzXunSeEYbbjC6TAqPQf5rFFP3A9HDHzz7oxCFKjoeuyIU1mu8rfj6sV3r1Vv3OErJEORhwsct6GpzuUtQlGpdFN52wc6UMT9euzq3QQyqKwr0YXrSWgHcfPKap1f1aPLeuXBSP0gyY6PesvlLNi52W6npcxJcHQCkt8632A7vSj27+W6eJvJhG0pgk45+xowJ767AAgbe4jijgq39F550GCmVIKXUrCRtyNIPnLxKacT47UutBDHF25yue/q9D+wh9YDRIT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(2906002)(16526019)(26005)(86362001)(478600001)(7696005)(2616005)(956004)(186003)(54906003)(5660300002)(66476007)(36756003)(83380400001)(52116002)(6486002)(8936002)(66556008)(316002)(66946007)(6666004)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ama0HmYMx3TxCYmLVioRy6yghQrO8Xn+frrRoeIIvot4SCaE7tZdfnn/kc6IVw8hCGRRSoX2S8H2sjo7sYLwnJgEOEc62zbhWXKs6DJE1HPfRQrrpEKEChn5EkYAh4Op/dTo6E8EFoTW9uqAgsooN695xMknaqQ9GjaaYGf29Zg+dZQHOVcbSDbTM7mhF5ubwN74uPHI4IdM2TlvjwWcblQN6jMFTr+/6GE/7ArgiS7flktBBiNFlCm0gUh/iISo1nvcrHlgrNhXG0Rqin++/6ypeYorggYLbDLCcNtE6AvKlgyTRTp864Ngjs8BWIiGN5VCF8x4zIRrkSnzb6OixlmLQMhNb2TDdePN3BkKkbcAXHAKacKOEMuCunC5UxGM4ritZvoWW49pXuFwrMaHB4Etyw8cT9CojG8r4CYOp144Fjr89pB0Qp8a6GcL+A2JQNTeIrIFOAFBpkDgQRyNQXKXPnyOzWjDPuqq1NNs9kX7wqEs3hQoJ0Byy+WNWDaH6ssjU9gy/QDXB1lOT1iqqtc4BD9H676SSU24eNNkfzH4hmqhwG1pk7BLLkAMkrzms1yqOIYwcAYwM4ZrJKiSfvCrwG+wTy0ygdPj/QvKwSAfDOmMNLsuLVj7I+dM4nudzwMtkeRkCPxDEp4N+6igCQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 875cb946-18a7-4e67-76ee-08d88a5167cf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 17:02:31.3787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvA3bHV6Q6lZsRygMJmsxMSl702ZKa5vXFedCxONPDJAOeAEJQonPOQI/2ikTLyv2blqiX3S2DudHGeiAoaLgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4603
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Currently, the nested state format is hardcoded to VMX. This will result
in kvm_put_nested_state() returning an error because the KVM SVM support
checks for the nested state to be KVM_STATE_NESTED_FORMAT_SVM. As a
result, kvm_arch_put_registers() errors out early.

Update the setting of the format based on the virtualization feature:
  VMX - KVM_STATE_NESTED_FORMAT_VMX
  SVM - KVM_STATE_NESTED_FORMAT_SVM

Also, fix the code formatting while at it.

Fixes: b16c0e20c7 ("KVM: add support for AMD nested live migration")
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/kvm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index cf46259534..a2934dda02 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1820,12 +1820,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
             env->nested_state = g_malloc0(max_nested_state_len);
             env->nested_state->size = max_nested_state_len;
-            env->nested_state->format = KVM_STATE_NESTED_FORMAT_VMX;
 
             if (cpu_has_vmx(env)) {
-                    vmx_hdr = &env->nested_state->hdr.vmx;
-                    vmx_hdr->vmxon_pa = -1ull;
-                    vmx_hdr->vmcs12_pa = -1ull;
+                env->nested_state->format = KVM_STATE_NESTED_FORMAT_VMX;
+                vmx_hdr = &env->nested_state->hdr.vmx;
+                vmx_hdr->vmxon_pa = -1ull;
+                vmx_hdr->vmcs12_pa = -1ull;
+            } else {
+                env->nested_state->format = KVM_STATE_NESTED_FORMAT_SVM;
             }
         }
     }
-- 
2.28.0

