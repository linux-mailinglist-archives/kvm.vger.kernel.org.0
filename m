Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9811F279270
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgIYUnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbgIYUnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 16:43:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20615.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766A7C0613D9
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 12:15:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyKTLNzLJS1AU94jxBVtW9QSit/uZGvyM2ZT1fJ0QjZLqLoNzGeWnGKf9FXSwjKvo5zXxuIA7Xx36IjCPWwsYfL5n/ZYKa+pdf9q1SZSq8I6VDxNwW1c8vB8aSTlPYM+3GICQCiHRp7WUo/fHVtGGxE7X4YfQRJHpV0G+WfIPkyRHcqUkZIb2IONBcrSlhH0c+O0ehlWmaPixGjNRGamjl8HcrLgsVKugn4savco2dl160QwSdo+PdqivGNGfONLXFNQph7ghSW6v/yOwIWPlNnwAHzckf1julVJFKkeYDQXt7w5GNGqHQXwHISNqNzIbWwF+TN+MLTQGZaCyoC5EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcEIoxSbsvJlPyskQ0rbz1fEN1HfciJgHrROeNeiM0s=;
 b=W8apDHtgCyK2l9cqSzwe/Q0QEW84yzd70HSG5mhO+PHj/RJj6RxF912xZb7kg0GsD8DA0BNFLPWVq5rRFEdNbma5i1iNThxA+xvhmI6vvBBNV+qfFq0W4BFVLKVz+ylSBBVS1Gnu5pBMbL7OQ9CybpP/ejtuxPyYfFbQVyr5LVLxjQl6z7n3P4ZnZtDwaO/+NjrOU6Uv0I9SVrFkzl8IxxPsXhgYgQF/qei/9H+h8eSz6WkeMXLBIp9q8xf81BB62f+P/U8Nf3oQlXzOwa82XovXmh6ZADYZh8YCWmd3qZyBzo6x+C4gI/981c0naC+shNGzjjVCFXxMD9SWhrmjvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcEIoxSbsvJlPyskQ0rbz1fEN1HfciJgHrROeNeiM0s=;
 b=ZfmhL0e86DoJ8aRPVqzBjs2yeXvu0c7a5375753oROB1WxMK/+eIlbdvPGkqGMsDyh2b4QkhnQZjnGguEQcwisZK2wl19xWtIwD+lgy/H1DBih8lJuGVaqzu4OAf7MvVVxEdTyedtZfFS/I5CtDnhgvQaSKig21MCw9KpQMsTyk=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.22; Fri, 25 Sep 2020 19:04:56 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Fri, 25 Sep 2020
 19:04:56 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 5/6] kvm/i386: Use a per-VM check for SMM capability
Date:   Fri, 25 Sep 2020 14:03:39 -0500
Message-Id: <eaec49f1ce4c8fd69277b1a7c374dcd87b9bb95d.1601060620.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601060620.git.thomas.lendacky@amd.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:3:ac::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR21CA0002.namprd21.prod.outlook.com (2603:10b6:3:ac::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.8 via Frontend Transport; Fri, 25 Sep 2020 19:04:55 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7e59e862-45aa-431b-273e-08d86185e433
X-MS-TrafficTypeDiagnostic: DM6PR12MB4297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4297117BF6ECEA5EF655BC3FEC360@DM6PR12MB4297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0MkHATowLlULWWtDVxg67vliy3nktJCLuicNPHHA881ko8u/1OCA2pPYKCs3QML/8fu29ZCJ5T9QCLFYhjeJefGeau9mudSSi5kTAG1uuZDA0zxWLWfotgL2tSxCvN4GtWDGhWs5O8NNokQJaQeP1s9xj0spOtzMx/5F4u9pLsrak0GE25BUp05QRDPBkV2pgAf9qwV2dBiebttqeqeSdRJdVfuXr426R0kOV4SOZdjjd4ZtoOvtkWk8RxiqeRKcalKX1FHxTkhNL9nPaC0I4699mND2AVw5z7r2q9tu5NXjCBz+D09fKW2gVd29+HW8x9djqFxJTlQge9IhqucvsFuCU0xYM29MBB6RPin97o8iUfFDbzb8iLktO7QDpCm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(26005)(4744005)(7416002)(956004)(186003)(6666004)(16526019)(54906003)(2616005)(6486002)(66556008)(66946007)(36756003)(8936002)(66476007)(86362001)(316002)(478600001)(7696005)(52116002)(2906002)(5660300002)(4326008)(83380400001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BFJg1kd0vupApHrwJS8y97Vah83n67YUO6q3kuGNWV9iAjV6E8H+ZVWAqiDM0N0E5gB/Rrr6mcXv2Q5JtWKehaiJ4Z+SebOGFxYOnFb89chLRih/TClj74Ot1JWVECIpe7uwr2B682RhIVKfNv0MzMM57nAt50v0IckN56aPWxivCXSlODttYF+8bi46tZgiCY2XZkVK1lsEE7k4eepIIjdX+AhqOI+/G0j9aER4oCfbw+eF7DurRxNS7QfmbSybGhmDe0uvw5whpyvxlw8eI+AJXPxtWucMocOXRKaaHLnxWMZmdWxgLz5TeyQk2KrYUPC8m/TCRonhPj8Fh//8b+vLapIteDhocftOsDXvZYKROFh9LkY4nsmB0issWjQDNIulh69md/Ysg81oe/78TyQUIPqX3LpMLy6KPnonG3L9wum+WT7zsZaA6P+XuKRX1TeU+iyenLxYw5xqje4s65aAWB9LHAI42M6Upn/KmSBRyGXaJ0kesiuEY3LEck9Ndsh7mghg80IOSRqEqIyk3M4g4vkmwi1JFISW6PqtGCBLW9LXFHfcHe+dGVYhmVsP+7Ixd2ekjdQBtn9dVHTnb1hj1EFKNpBaSJ+l/uNmacDMy+IoulN9Af9KqR9f4Ouklp/dOrKk9K7e6O2RunHTJw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e59e862-45aa-431b-273e-08d86185e433
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 19:04:56.2346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vtt85i2uKmjWi7BI5trD03OZcOffnwgdsC6leKwjBewCDkI/UJ010pAr8Xk7/LMxC+g7LGfgz+Wtf+tx88rkqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

SMM is not currently supported for an SEV-ES guest by KVM. Change the SMM
capability check from a KVM-wide check to a per-VM check in order to have
a finer-grained SMM capability check.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index eefd1a11b6..917cdf8055 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -134,7 +134,7 @@ int kvm_has_pit_state2(void)
 
 bool kvm_has_smm(void)
 {
-    return kvm_check_extension(kvm_state, KVM_CAP_X86_SMM);
+    return kvm_vm_check_extension(kvm_state, KVM_CAP_X86_SMM);
 }
 
 bool kvm_has_adjust_clock_stable(void)
-- 
2.28.0

