Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54C01C800C
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 04:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgEGCft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 22:35:49 -0400
Received: from mail-dm6nam10on2084.outbound.protection.outlook.com ([40.107.93.84]:6058
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726218AbgEGCft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 22:35:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctsxaRxcRoM8DInmPZ7iHRqV7SCiZdvPboCEjSwm2ytd7DP2AWNAIPQBhyfPMWiokU5PCxI4tZ4zFFyL2fRWMM0SO9+umkQeQZSPMBE6iJ1Q14/G/r2ZGkSuWQa/wrTp5fU9a6uWlXihTwfGM6BiL/Vo71ZOk9xKJNc2xORC8dTjrEOxQFEvWNq1NCGMPYEdzEelsTUBtkriSYND2mqeSvKqAVxWkQWtk5ekkEwOuljApxOyn03E0FSra1YOlZ/jsUQz+Rs3PsKwPDuePsMBFKAXmyMyOyOimDISXepBey2pyWKQzlQh8LfdbyY4HpjVZxsWWMJEmoTOJu7swjV0mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8G7Ca0agfDFFQ3J1uPht5rubdXkJpsWQ9jleN+Qzjpg=;
 b=U6bW2Y8I+K/vAj/xLazjlM3rT7iV3uJWIxGfjC5RlJ+ZxFlAu0RjHzTM8eeb8y0N/RuO7kIw+MLRjJAt8fhbMGAGFRBiJbH0jYO4JMjyaVdvmvLxY7sYQuZi5v6y5mAgUniSYqhN4CNQt/7i/00z9QB3+I5uImUXvLdS/H/WqLsPqf1g9Z3IKJjnK6JaG5iJsBXMT9P3hLjZ6NFYf3DIbn3cTHaAV6B6xXj4Xc5vJvbhPrcpnOiRRF0EQaT8KX930ZLKk2kAHSIxUbKjyaoMZKAElfHK08TwVCOb2TjsrpdeSFxESzyIi6yM1IpIA/ckhkZuLefvtOcna8AnufRJAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8G7Ca0agfDFFQ3J1uPht5rubdXkJpsWQ9jleN+Qzjpg=;
 b=Wjfjz2TjQNQNrTlb/GT49Rr+8OskLHdBzSMEdAYv7pCxQ1h2K8qWxgpPYEOemfvEvpoLLH29Dv39/JjpNNyXRb0VdvKuydcIbrdN91NdVTwi+Rgsj96SpUqvTulX/DxiS4/cgyH02zb51UewvTds4Z5hB52K838X2daP/hl1YhM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1130.namprd12.prod.outlook.com (2603:10b6:3:75::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Thu, 7 May 2020 02:35:45 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 02:35:45 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        mlevitsk@redhat.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2] KVM: SVM: Disable AVIC before setting V_IRQ
Date:   Wed,  6 May 2020 21:35:39 -0500
Message-Id: <1588818939-54264-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0051.namprd02.prod.outlook.com
 (2603:10b6:803:20::13) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by SN4PR0201CA0051.namprd02.prod.outlook.com (2603:10b6:803:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Thu, 7 May 2020 02:35:45 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 207996f9-af26-4e9f-177f-08d7f22f5850
X-MS-TrafficTypeDiagnostic: DM5PR12MB1130:|DM5PR12MB1130:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11307F02672977B7FE769C88F3A50@DM5PR12MB1130.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LA8P/Y6JxDI91OQNn738QNxhUzxkUuV5MwJRHPoQy+Z/Q3SvIBzUQ7IxwSSs9/vTRIuYD+zjQ/F/eyJaxiv/aEW9VWCWkliYQ9TYleTQcz/dZu1pbRavrktphoqBho6CkPVSv9Ob5tBHQkoD59+EybySCiKxZC5Dpxm0AnirAWoTpklVpo1xcrPhEAHBBJqHK/AGFrQMfSrRQo+bFh1KaSR1oS7DOPlSuXUH7CgVRHV7QadO/66h00ssR24cmRn1FcJtQxbb+qb11LJ4ZV4vA1EcZXFDxidEHCwzEWFa/71Lqg3rDMKIVJAiKusnSyYW7JeF5X+qjaW8qzuG5qmCt5rgFL4DzojoJ/1w+SPYxYiDu0IT+DK/zJL4s7hEgrpKZeX2FTGay3HwLJBqaJG+nrZ7owi64HXt2wBbOJpCaFI5gXAY28xORlIb9Wppjr1MRswKN7jayWWwV9Jq/i+ae9EJ0PtKK0d5vS4vizwJhW2GS13852C27K3lgsAv+l1gDt0OKxTMSuTBzPPL2wtJNFsSKJ6Cr3PQid3h2KM9UdNCLhxsOm/7RjEti5ZJKg6lyngzmc4iNj7meVPStkcdtGMA3ZRwOfEe0nVcqPAnxN4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(33430700001)(66946007)(8676002)(66556008)(8936002)(5660300002)(66476007)(4326008)(52116002)(16526019)(26005)(7696005)(966005)(6486002)(2906002)(478600001)(186003)(36756003)(316002)(2616005)(44832011)(33440700001)(6666004)(956004)(86362001)(83300400001)(83310400001)(83320400001)(83280400001)(83290400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Y8+oeBfM0pPiW4vwcyTmbVZeMFYcHcIc3w3LJU04hjNgkkty9sc6xTacKMal7hlBZTG9r5NlkuoiESWHizsN4ufRUTlEV7WGYbcHKFrTJQVe0v3nVEFxBSeYWot9y+Tk/Dy9CWWAiwiKEEHWbxj82VWUH0AkSSavys+xePriqeel83TAoVYQlu49j3laNPqifLVA3iYFruZXuURreu8uKpvW19Vyb1yYcKTHs7wn80Tnue58cWnvmyfex/jAl/QV6ZjZHnxpaIoM3zhL6Yczud3zb8Dl3ZfwSNX6H0O45qw5ICBnhnjZhxrp+LHHtqv2pHZGa+7aq3Z+iNMayohaTBAOnFUiseIsGcU5JZYm8M4KoExbvyZN5lX4wXWYwyO7KaXmOlKQW3VsKrJ+hlwaIwOohaySvEem1vWejbtRaIIE5YIFOpEx9eEdaIZIkJ/nLu/3IRgBCzP5p1uVgABtQmDEzyjKNU+5A/hWcWiFwq/wGtm7sgQx26SsSFPlb09HJHG2F4f5Lj9Pae34JzwfsqO8o1E//vx4ap+KYKN7fakxz276agR1Leri5j94y5mDmzw1olrXUDM8Iya07i33AASuADPwzRZskVzWRyonhhTEF5oASfTnqd06UCRBLPTs5m240eaRqrkNatUAf6NjIXY3etSoTOVgKM6OK66xEWfWwpah3z0kFPbDaGIbfQMHTltFPI6y2pXhFOpqudiGWvgTBgyf57MX3s+VI2Ypbu9rx/62PvVBzziB06w9/WlpjIZnsuQoKjVqVWAS4hNGQ60xqoNVv9bvePMutKSqc1s=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207996f9-af26-4e9f-177f-08d7f22f5850
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 02:35:45.7392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDn//I0STdTOc44A4YMJj+U1N9AY14vbYsw1r94xtrL20mPmvEEQ/H16MNjNzkOTHdAcyqZVWPjSuhTWBypc+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The commit 64b5bd270426 ("KVM: nSVM: ignore L1 interrupt window
while running L2 with V_INTR_MASKING=1") introduced a WARN_ON,
which checks if AVIC is enabled when trying to set V_IRQ
in the VMCB for enabling irq window.

The following warning is triggered because the requesting vcpu
(to deactivate AVIC) does not get to process APICv update request
for itself until the next #vmexit.

WARNING: CPU: 0 PID: 118232 at arch/x86/kvm/svm/svm.c:1372 enable_irq_window+0x6a/0xa0 [kvm_amd]
 RIP: 0010:enable_irq_window+0x6a/0xa0 [kvm_amd]
 Call Trace:
  kvm_arch_vcpu_ioctl_run+0x6e3/0x1b50 [kvm]
  ? kvm_vm_ioctl_irq_line+0x27/0x40 [kvm]
  ? _copy_to_user+0x26/0x30
  ? kvm_vm_ioctl+0xb3e/0xd90 [kvm]
  ? set_next_entity+0x78/0xc0
  kvm_vcpu_ioctl+0x236/0x610 [kvm]
  ksys_ioctl+0x8a/0xc0
  __x64_sys_ioctl+0x1a/0x20
  do_syscall_64+0x58/0x210
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes by sending APICV update request to all other vcpus, and
immediately update APIC for itself.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lkml.org/lkml/2020/5/2/167
Fixes: 64b5bd270426 ("KVM: nSVM: ignore L1 interrupt window while running L2 with V_INTR_MASKING=1")
---
 arch/x86/kvm/x86.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df473f9..69a01ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8085,6 +8085,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
  */
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
+	struct kvm_vcpu *except;
 	unsigned long old, new, expected;
 
 	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
@@ -8110,7 +8111,17 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 	trace_kvm_apicv_update_request(activate, bit);
 	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
 		kvm_x86_ops.pre_update_apicv_exec_ctrl(kvm, activate);
-	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+
+	/*
+	 * Sending request to update APICV for all other vcpus,
+	 * while update the calling vcpu immediately instead of
+	 * waiting for another #VMEXIT to handle the request.
+	 */
+	except = kvm_get_running_vcpu();
+	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
+					 except);
+	if (except)
+		kvm_vcpu_update_apicv(except);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
 
-- 
1.8.3.1

