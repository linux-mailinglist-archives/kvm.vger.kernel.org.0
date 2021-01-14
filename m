Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9312F6ED3
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 00:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbhANXON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 18:14:13 -0500
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:1122
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730612AbhANXOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 18:14:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNX0azJHSWBExM+aU1CjBdlTQrDlU8kBtpn+q53UOxJdRKxwGm7dvqrGEuqw+e9fy+Ht+sEWrGU0lYTzyd+pBaFtIgJ+bXa0G7hoBIu+oB+Iganu2Ju8ZLWOoFwkgKakn5X2GP4AqP4G5jwIxOmmVHaem2BfzCifG1Duu/M7sHGBnjcyj5yaxn41UTdRx179lcBOX/z27Y9rPGxj3tk3xsHFdivAdD743jDgkGCSEn3QxRfoV0n3l5HIAx6pwELMjpVbZeNcaQetojGrX8zSSGggc2C/giykJu3e8pclSYr3QSBQHg4M40MTmz5Qkc3Qg0+vg2awE/69VPP9x92TXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RR4A/N+dHdf2kJUGloeATQgrbAqV+8e8m+BX5sC3A4A=;
 b=U/3OeRjstt6yQnqR/TyDQs7AJAvk8ZJQ/4w2kgWIxzLXryihVZ338VTY3lbTHKeAAdSlUfQjyXzqXkRw3bO8xRMFBSbc8MSeYgfi2dh01hVlTnxOiDeVwa8Kzl1mUKEF6MmVV8RFiNiMw+0uIB1ngJRpfNykACwK6SV0HrGZ5tbs/AjTUqRW4QCw+B914Kad7NVUTiRTIOOzjzNZAApn5RO/3gmMHGFD6wOOthe5VJoio7pURWw9DN1UBrGAGlib3e38J8S7l59gnjO0nphsohN1bnuX/eHKq6ciBtXonuuKIp//iwVflDtZc9pi1vSVWpyUP+G0bN8y230pivB8GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RR4A/N+dHdf2kJUGloeATQgrbAqV+8e8m+BX5sC3A4A=;
 b=wNCtIH3O+yjaj0suAO8QCRpTOS7oLg41EUNHw74fDQX7Yx8a4zno6CTESWuNQPEC5v8Pwe57s0jgB7OhGKsrdN0IzV4dPEzMcjfCPDccd/5zrkRTg9+9F5rqPdwHHeFBr42TGybeIkqgJbsxsfukYBTNfatMPaKd3FxooOsD6A4=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2503.namprd12.prod.outlook.com (2603:10b6:4:b2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 23:13:06 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 23:13:06 +0000
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
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v5 2/6] sev/i386: Require in-kernel irqchip support for SEV-ES guests
Date:   Thu, 14 Jan 2021 17:12:32 -0600
Message-Id: <d959102a84943107c7c2e58d5e2760d2ef4750a9.1610665956.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1610665956.git.thomas.lendacky@amd.com>
References: <cover.1610665956.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0145.namprd05.prod.outlook.com
 (2603:10b6:803:2c::23) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0145.namprd05.prod.outlook.com (2603:10b6:803:2c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Thu, 14 Jan 2021 23:13:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 293b86f6-64ba-49b0-755e-08d8b8e1f34d
X-MS-TrafficTypeDiagnostic: DM5PR12MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25037731EA405F38CF2E32C9ECA80@DM5PR12MB2503.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1NTPYAPG1WqH1FvWBuOoVuioeIl+9xPxzxjMTRkVXyJ9fV5PhxhLuH79rJCdmrH/Q+97li8rtNp7PZk94AyI778cBMn1gxAVMXz7r3mEXWHIIRQk4oJJ6ov/p2SQaYIh/eDHBvCqS+iaohm9gNgRNxuBt/WmLSrLDzv+3JRofCyiRN8JAPUfXXhmGRhL0r4RAqQmyXvQiXTY7ENxPpQnV2gn20PqVB/wo1vOazNHojrmuB5UNdxinV1Vj8r0sdNyY8ZBSLJNxUJ3zGQ/I2v+AiGMOcbPUxsvGjFFpuN0PtNhLj/ldYfIstGnIrvGncre0c2/0kHIBIXnOGfe22VZTeBLnJ8nJyWuguZnJ9+dxihBMjNuk92VBtmitRXnuMJAMS/qKYH29fzvNlHXVsBWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(8936002)(54906003)(186003)(6666004)(6486002)(16526019)(86362001)(4744005)(7696005)(956004)(66476007)(66556008)(52116002)(316002)(5660300002)(7416002)(2616005)(4326008)(36756003)(26005)(478600001)(2906002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q36mazhHSNpcvsnvVbFgVaFKJwF0xQUhFA3+EWZPv72+OVHw8bM0XjeAtFo0?=
 =?us-ascii?Q?w42AOVVp2dK5HjtxxrrZhVwZDDfemHcCZ+9VZgC+8iXwGpSRPWCNrycU17Bl?=
 =?us-ascii?Q?p/UGQkh+92SeX3D+ghW10KS/Gyc+uyiYFNGJjV97MX2CrvFXSgqrJcNhzcK9?=
 =?us-ascii?Q?EVQWvRm1kL/S/7q4sS9apgCjgBTcoH+Oqor86I37g2sOe3W0JfKdVQ48lLVP?=
 =?us-ascii?Q?nZ8zKqsmcFQh9ARW+plk3qozgXw8ktyagiDguH/gBDFW1rMWNYDoG8wZ7bs8?=
 =?us-ascii?Q?Uejpz7UTyra0z65esIK1Z5F6/9tHzjo7YjZkq9cGmOCasJq+9w+oLv9bOTTo?=
 =?us-ascii?Q?OkxhQ5w3Fiu5zzeJOaweGqEShh0rMSMpiU0yFWu+Rif+VQU+oee1V7GURCom?=
 =?us-ascii?Q?mb0utJ5Ym6JOxZKDQuRIV3nOxC6ePqSK3Re9FC87XDusW4aL9VbjNCiEA1to?=
 =?us-ascii?Q?LnixujYYWEiN4rhF/0lT7OSkZrZFZB5Sfs44ctBMu8E9S/LHZPcDksKSrBap?=
 =?us-ascii?Q?gVHhuhUgpASaA7YPV4+838dOBc6aWJnF/CNnPfAJ2hFc1lT0Jm9H2b6CVGAH?=
 =?us-ascii?Q?4nkhxdhHSvbv96BVR5Ya4MEYXiaNFMzxV3HERkqTeDjThk0pwp54sNvd3VjS?=
 =?us-ascii?Q?CPpe8xBZnC8HwqBNcKA06n4H0oBGL1zRiCu898h81GVKi2mhfjVr1CZqTlxu?=
 =?us-ascii?Q?nTxRK9I2uhpFNLA06+TJ7t4UTSUMAl3Q6dJ/nPVH/DscKOJXyFbglh+OieRM?=
 =?us-ascii?Q?X/2PjGKvFC0L13be5q2cs9YE0IiwB+NX9lLZHJOVHLSU+d+p+8rAUi6v25qi?=
 =?us-ascii?Q?24fahEYExf8FHuOB5ILsVS5F8pjeAHyFLoWToqBiyHLbC0zIcUHAIIJwJtKF?=
 =?us-ascii?Q?Bp+MJxrKLEQRVmEEPz5ZE/x4jNf8PtzAUc8TN509A354cBmG+KtjjGodTUWU?=
 =?us-ascii?Q?vJIrh//qlIahzwL4JgGuSrB5dwDo7EKndRtn5E47oaWHsDQ6p4k21yEMTFqg?=
 =?us-ascii?Q?RyiQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 23:13:06.1237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 293b86f6-64ba-49b0-755e-08d8b8e1f34d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u77riJCCjeIqsU9n3PiJ1WendN5pC7WmvWRZOfKZDX+hn8H1yb4LnxBV+UdWmgObJedRem30u9yd/JmQXtC0xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In prep for AP booting, require the use of in-kernel irqchip support. This
lessens the Qemu support burden required to boot APs.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index fce2128c07..ddec7ebaa7 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -776,6 +776,12 @@ sev_guest_init(const char *id)
     sev->api_minor = status.api_minor;
 
     if (sev_es_enabled()) {
+        if (!kvm_kernel_irqchip_allowed()) {
+            error_report("%s: SEV-ES guests require in-kernel irqchip support",
+                         __func__);
+            goto err;
+        }
+
         if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
             error_report("%s: guest policy requires SEV-ES, but "
                          "host SEV-ES support unavailable",
-- 
2.30.0

