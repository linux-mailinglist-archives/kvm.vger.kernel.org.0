Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D801265A7
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 16:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfLSPYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 10:24:04 -0500
Received: from mail-eopbgr700049.outbound.protection.outlook.com ([40.107.70.49]:29152
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726759AbfLSPYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 10:24:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNFF7S2oyikJkfRhQ6dadrBbhQWtRQn6b/8Zdly+2u3IsdrZSuR/yh+J/ykqFt8Bia6sUb/kC6P5CgTcXI/ieg5K5MZ4BCb/NUYcZGwPWaixXNhlwpwJl2UJZ7PlPGF55GZpRAIJBdn+x3bDSTEEnFwLnBWImnIQ5jUEIgCuIcR4smt6vVxGMslJSxTPWaFtkP/Y/jxZZoiX593rgu2GYWEInf8BPs0FZkC3Im+OuEA72IT+gHjDVBj7rTvkf3Fm0H4xit931mQjO9rq5TpnOIDJwKLF+AE8JTba1954aPaa6uC46weWIuOfG/8HuCapdPSwrMEiZRLmYnO0UYTDJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=colmVbztxjP6DO7DVSkO1JYZKkoKN0QbvkdUXky0O94=;
 b=gxrMkdPNenzrjdGumh9/qrIqnSxkuAmf2VXI0XB0mhA/8Ht37QMxBxG6OYVYX2hO71hmfz3A/QPOGFlh7D94QNmrnh7sksUwTMaUNZ17qbMX5/yvbuJIDyp1g5uuF584kwYvvhUEsbE8aMFgo8f6XqJIH2ZP9DQFun4SIXX5qd52WTnQ4Iu5C1kapsj44vqf+xGZJdepZ8uLMZ/xAsg59r3q5zbzn2JNHvkaCqNoXK4S3C433WPa6iqYdhChhHhCfQMTj2CIBcTxUuFT650mhli8vizYWiwTwDWZ1THwvZWzEgPa+huBzVO7vzV5TiWqtl0CR/aSw/c9iODNgiALwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=colmVbztxjP6DO7DVSkO1JYZKkoKN0QbvkdUXky0O94=;
 b=zafQFKN7hf8jMnaweOv5l2bsHGDv3MWi2RI9y7ge+OO+yjz+lQR0QbxuZl9XVd/VRyqo5m8tKWroFEM0X3NWoAiIDftCrGQ5j5LWmCCb+EYBW+NhE8Ky1s3J5bjsWP12Fc/FpJ3yQvSD4K07/iUosE4Q5pM6kTaaQV9RUuebvMk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=John.Allen@amd.com; 
Received: from DM5PR12MB2423.namprd12.prod.outlook.com (52.132.140.158) by
 DM5PR12MB1708.namprd12.prod.outlook.com (10.175.89.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 19 Dec 2019 15:23:59 +0000
Received: from DM5PR12MB2423.namprd12.prod.outlook.com
 ([fe80::84ad:4e59:7686:d79c]) by DM5PR12MB2423.namprd12.prod.outlook.com
 ([fe80::84ad:4e59:7686:d79c%3]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 15:23:59 +0000
From:   John Allen <john.allen@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, John Allen <john.allen@amd.com>
Subject: [PATCH] kvm/svm: PKU not currently supported
Date:   Thu, 19 Dec 2019 09:23:32 -0600
Message-Id: <20191219152332.28857-1-john.allen@amd.com>
X-Mailer: git-send-email 2.24.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM3PR12CA0067.namprd12.prod.outlook.com
 (2603:10b6:0:57::11) To DM5PR12MB2423.namprd12.prod.outlook.com
 (2603:10b6:4:b3::30)
MIME-Version: 1.0
X-Mailer: git-send-email 2.24.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c1383e8f-10a8-4740-38ff-08d7849778ab
X-MS-TrafficTypeDiagnostic: DM5PR12MB1708:|DM5PR12MB1708:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB170844025F1AD2A63A7548C69A520@DM5PR12MB1708.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0256C18696
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(189003)(199004)(6486002)(66946007)(66556008)(316002)(4744005)(44832011)(6666004)(6916009)(6506007)(6512007)(2906002)(4326008)(36756003)(66476007)(186003)(5660300002)(8936002)(26005)(478600001)(86362001)(81166006)(81156014)(52116002)(1076003)(2616005)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1708;H:DM5PR12MB2423.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8LKmk6L+W3OPdVTRQ1OB4HdUY865BTrZwSBO9nWQG72ABCKfo+DEC58o/vLuJPpp7CC+ZFioKd3NUGeUduia83yTr7eRpQ5QbBomfayn/gDRbYHNqKcJ+FjEHdrhOZiz4UWywP0Z0P2Dih7453t3O1E57p2uxxI876JypHKZZvUiD0yhPq3V/FYBvPH/9dd8iUicykHGCl4sCMMEePW0npcy32Hj+sbiWBEqTu+m0tDpH/RSNpMRDp/9z1EYmHqNr7Eqb9gjD66R3RFBB7ekYtY0VMq3D5EmY5QcP0qcmSWpetTVWxc2bT3rqlpLuuDZDY0oTK9/omb2smoWLB97gYn6C5oIyNxFrbNWIICYkkRcL/bcCmt4cWO1DL8DigiFJCMHYl2iPbI5Xpg7p/lThQ2yhfx4olDO79TrUSTTaCRMyAyOnxH8xHvG9M1jkq5s
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1383e8f-10a8-4740-38ff-08d7849778ab
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2019 15:23:59.7448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: izVw4Znde0Ge/4/7HsSpTs4drbqRuvZnM/r+cLoKKkOaXtFb8SqiIz5geeGD3oIxvT6ngDRpRPsFSo7FY5lXkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1708
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current SVM implementation does not have support for handling PKU. Guests
running on a host with future AMD cpus that support the feature will read
garbage from the PKRU register and will hit segmentation faults on boot as
memory is getting marked as protected that should not be. Ensure that cpuid
from SVM does not advertise the feature.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 122d4ce3b1ab..f911aa1b41c8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5933,6 +5933,8 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 		if (avic)
 			entry->ecx &= ~bit(X86_FEATURE_X2APIC);
 		break;
+	case 0x7:
+		entry->ecx &= ~bit(X86_FEATURE_PKU);
 	case 0x80000001:
 		if (nested)
 			entry->ecx |= (1 << 2); /* Set SVM bit */
-- 
2.24.0

