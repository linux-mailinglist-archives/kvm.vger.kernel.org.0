Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E4B3E1DA7
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 22:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241239AbhHEU4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 16:56:04 -0400
Received: from mail-mw2nam08on2063.outbound.protection.outlook.com ([40.107.101.63]:38145
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241501AbhHEU4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 16:56:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGsH1Iu7mhKHxpVqzP2RmfqPEVU1JCtpVY2VUOHATcdX6Y1rC4POOAS+mXPi8LE0ro1f9+fcfW+rZHAserwOXqT1A+dziH0cnaobdHm2dmfuwbJjaZvhvrWj1XhSpdVjd87Ot07Qwb1uASA+DrJey4tp+0ESOTdyWZ6Vi1G2AQhNECC0mZcQXkU3bqWcbA2r6TfndYWMjhmuUfAGk0r81Mi/t/LGWrphNbwHBXgV0K0pTB7Bb+ncO0wl4XRpB+JYPq4+B1SKU1/yiBIrqipcBMY3t+59cKUo0gimu8lYdk+nwVNnPbfRlsy8ccT6sr6Y44/l9gUlqvh+pjToK+bP1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JDGnryRLPoif3dWdeXtl+XTWT4egS2NkNNWbaX5CvE=;
 b=IjqjaJTDTf4CGknqUF9zEAzZUHcQ0A8+lGdv2js5U0jL74OQ1HWhjNQpijUH8JS9d4zMZBgHoB6jbpm9vV8Vm1cmWxDlbutBq9XJhpne7IOnEv+/sZkFcbriNgMbpb6fVn8w0CaY+KOM6K1kItkuUCDHVKZtjNe69Hhvu9m4Q1HrDHphQEdbhFot2L1hv5uU31b6B8oH/WZwZGx/GEfWmkT4I2bZJfBP8LGkVetyp7vfNCo1lnHA7W5VFsKljVY5k6CW83DBz0ceSI3Af/LJ+2861g7hnjVzHUg9YT+mZfesl+WBbagl8yiS3GtqRNWGfdxWa2C6DA9JxLq9XUreQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JDGnryRLPoif3dWdeXtl+XTWT4egS2NkNNWbaX5CvE=;
 b=gIXi7zDnpEnAKg+p2PTKJ6XHQWJJBS5Yjmzm22NXGr8KxgH+NNpYUagZjwxWZEVTDBXcEQ0HeR732YxgM7m2fEKFvtyLbQbOf2i7A9oB9VUpWR1CWod9gVwJWs3xFkhUuF4rHHjNJ1EirXTKGXciVjolMJqyBC1fANyKPm8226Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR1201MB0107.namprd12.prod.outlook.com (2603:10b6:4:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Thu, 5 Aug
 2021 20:55:47 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 20:55:47 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        wei.huang2@amd.com
Subject: [PATCH v1 3/3] KVM: SVM: Add 5-level page table support for SVM
Date:   Thu,  5 Aug 2021 15:55:04 -0500
Message-Id: <20210805205504.2647362-4-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805205504.2647362-1-wei.huang2@amd.com>
References: <20210805205504.2647362-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0168.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::23) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SA0PR11CA0168.namprd11.prod.outlook.com (2603:10b6:806:1bb::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 20:55:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4147ef05-f658-455d-0e80-08d958536652
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0107:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0107E5C0184C141F040CCA31CFF29@DM5PR1201MB0107.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: skVKsm4r4G82qgos+uFWpwdfrEyhHtYbXPL+T62dOwGu+FvDusa3LkFfufW4lQusewEa/fdJlgJVYMpFaJ6n2xV83823s6sbzUW+Qo3qpLnxjVvpPC0aXZZSBadbKMQLu1eLyNRbBJy7m7R7tD8e6k5N1wo13vRS0PIQacygfhBoqiGsZCwt5LeNI1GALAy7NqLCSXmTKlQnPUj4lBYxm7zUuW1T4XU10MCkiMh9xXFAYAy8Kr4wI+Odvu+/lttFLf8db6Wnrt7Y5O3VDrlR8FYHcKxrNv+hGdsVEJCnk3qQummVYVVd/BixuwsgQDL537MyvaQ6zKZBAWzM62pogHthY6uYMuVBY/HvxbK4hH3hBNYNTklIqK37HR21p1RiAvuc+dGW2w0l3TUn1lVlzC5wpxE5Yr9YR1mjBzXvrdtHthFXWlSd2hp1KNa1OZJi0+LT8fXo7KabUCzL1WSBlpaWIgKwmepSJM8BAdxWxJE17Wpu9XhHcf3Ux7AqRVfGWnmgXHitn+upoTtL1XaK0EIrJ1PJwLj0Jisu3ZU0LwlkTRvcKXL/TgEiSgL4j8xjCOisc+ySYxxxjaLpuGT+0EkZyrgE1iPjpFEbV+ak1chSUamjLPy+NGzFo5jl4vt5eJQFWmy0A2KlyAQcEe1NP2iJvygo25K69IZdE0KJ7QppySiw1AtW09bfcJKwH6rXRD6t82RftpdB/Mrv+Eatxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(7416002)(26005)(6666004)(6916009)(66556008)(66476007)(66946007)(186003)(7696005)(52116002)(8936002)(86362001)(83380400001)(8676002)(2906002)(36756003)(956004)(1076003)(38350700002)(6486002)(316002)(2616005)(478600001)(5660300002)(38100700002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YL85H4qHY4W0rNMgyuNdm2bWQ6ONXb3rU9LrfPJU5ay5LcxZlpJ+V/T4AkQA?=
 =?us-ascii?Q?8ikxoW3+ylNJHqaxksfz9K1dd/Zwvqx0Zc5izw5fZMvAyxyoHNqfXxAemJTE?=
 =?us-ascii?Q?azwF2tySwu8OQWcrdlnrk58wbvTOMR7d+JpqSiXs21IrD8kWrPF+VN3URLQP?=
 =?us-ascii?Q?YXPnpFpAsMdYGXJw3AcjJxbhf/ciz3ch3uAUYLtX73pGkQTp9xRU5ZuIPh5W?=
 =?us-ascii?Q?hjxRXoNABU0A9VSVbFTWNTI/69wT7s2YtdVVFcQWSgPdNWIV6gsUYKjgjFgm?=
 =?us-ascii?Q?/KD00T15NCR7iYXu2HOAn6fheFpgHdQRV+oChx3LEGTDqtNbVWtrZXmsJa8p?=
 =?us-ascii?Q?W9u8sN6S3ljv+ShmjlWZ5t0JbsDUIlUZmeLCyL0NVykQbJcMS/aOiZzNiHAq?=
 =?us-ascii?Q?D/shCK4g5cShRAc1SiA4nzfzC+kHxmoKKLSQ7bUDsDW8EA91b1+OLBbHQjuq?=
 =?us-ascii?Q?/ejWObzAlMAz5XsD735XJc/7LhJViS0PeUyh+f+QAA4xEeSNO2bM2ACOj7wq?=
 =?us-ascii?Q?Ne3xBxVUHpcII/fniIA+K5Bu6eWXrBBnOEEE0pVLVq1b70wiBjkvv6rQ4+QA?=
 =?us-ascii?Q?9DXK0CQZGW8cBUkr+ra5iLElsq9FEw6gcDjW5AXlENz8KvEHYq5YLRVmWDpL?=
 =?us-ascii?Q?Lf4/zU0WNBt799v8WJaLG5K0Yuc0r5qOSnHO8S6qnY/gyYApsFdEF/vACs4O?=
 =?us-ascii?Q?dEx5T9wrQUYlH8inpghmYc1a8J1MKcSuM3/tB56orQHxAFQ0mae7D+/Qow4i?=
 =?us-ascii?Q?Hr325KgLwmg/4oYA004+uDMnAEa8KKZvqnfTzW3zM8A6RyzFnkQ5/tyFfZ2J?=
 =?us-ascii?Q?2pzcaeGa674VQbg/4/nSgIuATDFWFiQjyE2mwmEkdA1fXMZvBOzHAsx4XVdz?=
 =?us-ascii?Q?THXIFs0ZK9zT99tI+flCAnxBp+CVkE7AEGOrViYfWi5eD1Vpp8dMsgRygPu0?=
 =?us-ascii?Q?HAv4EC/a5SggKRB3ZH/emIvFmfJfdl8q5215jO2Ey4uf8piI99ppFN5Hq/yv?=
 =?us-ascii?Q?tGy4I0yaX5BPlVrmTbayPLhdWzzk3ogwIITy0gDl9RM5U49ukp6auJeCVsLB?=
 =?us-ascii?Q?xhUNMjE3dPFI4zyRsCrWSCufOUXXhGG5qX4t4rNIv/sGNxsZMjre+eIjTtK6?=
 =?us-ascii?Q?QWaJJ+mVgn5H2+eqGhowXgb8EobZzWnG/Gu0fD2a2k4bwCNQ18v7KYTP9cSM?=
 =?us-ascii?Q?CYbvjU2Qk19JvTS7H8DoLic7X0E6luQz4vAC2CCsfK/oEsNmUFEAdFT6Fbkj?=
 =?us-ascii?Q?w6aUFKwehgREkIkvKainUsCw8CxkVKOCBr2tTot/hTPNrE6zPBXn7XCeOfIL?=
 =?us-ascii?Q?ACzn7jgLNauMqhoH+if/fv1U?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4147ef05-f658-455d-0e80-08d958536652
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 20:55:47.3738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6371eLeC8F6hjngoRfm+FfyHtzKhBcO0/VsRfbDroDWdIkNudWqc9815uwu2GhI6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Future AMD CPUs will support 5-level page table which is indicated by
X86_CR4_LA57 flag. When the 5-level page table is enabled on host OS,
the nested page table for guest VMs must use 5-level as well. Update
get_npt_level() function to reflect this requirement. In the meanwhile,
remove the code that prevents kvm-amd driver from being loaded when
5-level page table is detected.

Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 04710e10d04a..f91ff7d2d9f9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -261,7 +261,9 @@ u32 svm_msrpm_offset(u32 msr)
 static int svm_get_npt_level(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
-	return PT64_ROOT_4LEVEL;
+	bool la57 = (cr4_read_shadow() & X86_CR4_LA57) != 0;
+
+	return la57 ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
 #else
 	return PT32E_ROOT_LEVEL;
 #endif
@@ -462,11 +464,6 @@ static int has_svm(void)
 		return 0;
 	}
 
-	if (pgtable_l5_enabled()) {
-		pr_info("KVM doesn't yet support 5-level paging on AMD SVM\n");
-		return 0;
-	}
-
 	return 1;
 }
 
-- 
2.31.1

