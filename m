Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D640D347EA2
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237159AbhCXRFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:40 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:50400
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237044AbhCXRFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNIhQBXwc/LEtIdXq4nk+PWarLhmzVRua/Nd0Y0YglOBezr6rzHmAYDDBH/7h+w/lfPZbVyGcqOewzKMY61s9ePexTsq5YfoUW8+stP1gUsqfKLX5hln4w3l1R1LR/rQfsBxyz86f5zAcN+md/9cuAc7OBkE8nNjPZFwZI9daF0dYTaG1tAZ98InYOkO79iAJkfD1F4G8LX8+w/saX8HDSooBLcS12BhrgP01d1DHj/0uE3J/H+pFQ6bYzQtuzyGIeiHQoaaHf6hNjn+5CPmz9US/GaUrws8tHOjXmc1u8Ol656aW16cre9CNyatyOXcCnDUCFNceCey7LPe0H0koQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL4so6K4Duxd2cYW0iNJTrQh2PfwP1WZNs7lcYb3RT8=;
 b=oBH/mQ68zpgcTm7yV/ax2mUlqv+rnQGCV/EPXQJZButngoxKv0+lboUyRyxqWRMqFq99nRT+2X3FlLrK5jA3nQjmu1dX7I0bCFrUCXwnhU4g++5l6u7+TPKvhruJYNrHWIHGyiiUHTCbgI+b2iKi5AkaZq6F9/ZMKoHAiw69q9ZVT+0ELsrfbowMlb5BssDQpAsGcpHHwj5+K7xw8U7NSnj+nr71e1cz5Es4va0ayRQKpalTvnYTwEn6DIyB/SHHXySKK1OAQX6QPldUFkEHz/a+JcFN/EMTjeR61PrbPuLvAhm0YAUjhFx2wnaG9D2yyRpiALo35eI3gE/4gRIx1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL4so6K4Duxd2cYW0iNJTrQh2PfwP1WZNs7lcYb3RT8=;
 b=24iWt0KpoIxSW4Xv2zeG8tTdHHJv/Z+jaFrirQ4Hsl6gOLLW4FA5x23QyO8RmDmCuEY63sypb55AFmjyMIQTpQMURupkx1UAlI0KTes+uNkEPekBNfegp3apEpG1jRSCSw5jhOnaTBhXgKFLfWMztxp1Dprgb+8tS6ceoYM0fzo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:59 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:59 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 10/30] crypto: ccp: shutdown SNP firmware on kexec
Date:   Wed, 24 Mar 2021 12:04:16 -0500
Message-Id: <20210324170436.31843-11-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 55fabc58-df1c-4645-d5fe-08d8eee6f4ab
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB455761EF9EA029BE6A5B63EAE5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoJBj3miF+ihG2pdO1xgYAHuETwOQG9fNQgjpSQq6M/dpDKnf29fPMsUDZdXQcT5UgHo2hHcPGnIHq/exGyXxDbRO4l4cnMAGonyJVYDKC5jLTkubPuyR3BagYnjnT7CBlk3I7y6ELXft8v4TQWJHaJPV+WWE1oQcyESyUUFK8ST2JchdDgcRrlofyit4GPCA/VWnt4cQg++E4ujLpNA4CpVEFlDWSMAlWAfN1LyuHBSDlmzHPpi3ZF0YIh1Bht09xPo5uEvdQklUWER4Bz8KgMLjCEV5rkHIwwVCsKp9WDLiuVObjU7mRoq6jXOhnnnCaX5RPBiiLpi/ybT5w7Fuf0B7x0pjALxLMPd1UAl+VLDIZQMUWqK0OsoCrtRFFpte7Nx2ha31eONyzRuW3dqtTwRiEnF2H7oIb+s49xL0fPFvpYS1tAV3evOQnRqZzTukZdIhfqaMwSCLO1fWbqMHbaXiMRQsv82gmzxsV0IatHJV67MTwZ2kTadn6gcSUltYz0vrwEH3PmYHmydxUaTGCKvC/r0j0MNDUes4IqJW8xrsIf0+4+Hls4OacwAHTIvBrU+zpFTrcvaE09MU03AwcQCmu9nry2vnclapMC+CKq8U2VI+QO+CAiv4xHh5UU1/fP+H01qdqAlKXTUdokOnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6PlCbVDSDrML/30+N+qfznLtLvpVzmidf3bprXH/QRl9icbrjr0qA0okv2f4?=
 =?us-ascii?Q?RLOJMo1cduh26GYcXLNaAQOA3R/lH/oZBj0XUQuLFK/ZTv7E1NXFqATA7gXR?=
 =?us-ascii?Q?p7UxvkZvsDLd7hqxnVuOA/5e/tUYhbRY8uvOXDTip+yN2ZLB7UdTVy/IrVu3?=
 =?us-ascii?Q?JdS8cDQqdqU0+uEgCaugiCg0Jrk8hqzor5p+BDUr98RJKEPnZAkiURgVbKCy?=
 =?us-ascii?Q?uS/tPURAxKDfeadfun7J2TKiG9UrxZyY+vCujEjXoWmLNx/6xTzxJvyNn6aS?=
 =?us-ascii?Q?CH0Awon+iSn3/Z7uSM3jiHN4GrGtJbCkdqMQN827aitIMgOdmAK59R1F1FaC?=
 =?us-ascii?Q?le0ooQc/Tf4sBe0d+91/92aFz+vtu99mY86ovYvJVdb/BkAa/6zTGCBc1Nch?=
 =?us-ascii?Q?cY8HUiImnEvrEIhgXWoFH46cy6aApboVeujfJzypYDNhfOamuTjB7U1gIkTd?=
 =?us-ascii?Q?wPDk41iYEFOMUDNvVd5Q5Fw9ARvOoBBg3f8+aqH44LJBN3m7oX5hTF4alO+O?=
 =?us-ascii?Q?Pf+8q2we/qQHY71rv3qAdgHnYp8w7m+yzgRm6ac1wozdRpX7XaOlvrcst89c?=
 =?us-ascii?Q?7izhQ0WuaWHu/8hwJD7us000g1OIJQ8RSvOHlteOcvTofdCvuvT1FhuoXUrn?=
 =?us-ascii?Q?zogVLrgL8LefFof8Cy4KM1YLVj1FC48eG1kovTOzyuIIJbjS4TlDFpRs8AMV?=
 =?us-ascii?Q?+pNWglJGDK7KFkNdDD7a45y2PCmUngUMWk0cunLIUkW5Q38s4WgP2Fy0qGDk?=
 =?us-ascii?Q?tmOeAwRrvjMX9jRyLLJDqQ849r27BBcz7GQQTUdY2XBBoe1CpukwfQYxym+g?=
 =?us-ascii?Q?g/j3eG+KbU4Yhc29UFE3kHFMPbdquid+HSzjPjv+pgblg2ZR7/7CugHxMmZ/?=
 =?us-ascii?Q?yijToDzJiZSgRNjRWJSWM56GtuApKYNHXKukdFhgqTBmSarBOj/0Zp72aHmn?=
 =?us-ascii?Q?NsLp6hA3yF4B45biFM5SUSUFYA3flNRHaBROtHp7qFQtRUuQHXLieIMgvtt2?=
 =?us-ascii?Q?izzhBT0KEHNuP3JHhQ1kZY0oa9vhLKbWk5GXJmA6TZCBJ2POg+4Vy1FK2EFT?=
 =?us-ascii?Q?0HKlg5mqZAqeae210NLAxsRbYmwun+se0obu9Pv+c3RM33i57Wf6vTs3nVOc?=
 =?us-ascii?Q?IKgBR9RKZ3DQqSOeBuxgOm9t9o5zsLbQMhT93hJJh7rKLpOr96HdWr4F3vF7?=
 =?us-ascii?Q?M2svb0/qdmzQSNt9BUi3AwRbRbvXTYyxVtvt7Hcbf2MhktLB6cFjBeKB/7g6?=
 =?us-ascii?Q?P2bC8lwzJTSlENVy9s37EtDDa56TQqL1fngSf7BviUk5gMeXXZtBgLrUveKT?=
 =?us-ascii?Q?uzjbQKDd3gi7+6WJsIhwVEic?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55fabc58-df1c-4645-d5fe-08d8eee6f4ab
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:58.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzqv2Pfmfj0mDFHneyu9HVHu3xurrUcMTsIXDaP3xtL7O5HelfsJJ6HwQXYDQUiw9JQhJ8MLi1RRNVncspwr5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the kernel is getting ready to kexec, it calls the device_shutdown() to
allow drivers to cleanup before the kexec. If SEV firmware is initialized
then shut it down before kexec'ing the new kernel.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 18 ++++++++++++------
 drivers/crypto/ccp/sp-pci.c  | 12 ++++++++++++
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c983a8b040c3..562501c43d8f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1110,6 +1110,15 @@ int sev_dev_init(struct psp_device *psp)
 	return ret;
 }
 
+static void sev_firmware_shutdown(void)
+{
+	if (boot_cpu_has(X86_FEATURE_SEV))
+		sev_platform_shutdown(NULL);
+
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
+		sev_snp_shutdown(NULL);
+}
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
@@ -1117,6 +1126,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	sev_firmware_shutdown();
+
 	if (sev->misc)
 		kref_put(&misc_dev->refcount, sev_exit);
 
@@ -1272,12 +1283,7 @@ void sev_pci_exit(void)
 	if (!psp_master->sev_data)
 		return;
 
-	if (boot_cpu_has(X86_FEATURE_SEV))
-		sev_platform_shutdown(NULL);
-
-	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
-		sev_snp_shutdown(NULL);
-
+	sev_firmware_shutdown();
 
 	if (sev_es_tmr) {
 		/* The TMR area was encrypted, flush it from the cache */
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index f471dbaef1fb..9210bfda91a2 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -239,6 +239,17 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+static void sp_pci_shutdown(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sp_device *sp = dev_get_drvdata(dev);
+
+	if (!sp)
+		return;
+
+	sp_destroy(sp);
+}
+
 static void sp_pci_remove(struct pci_dev *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -368,6 +379,7 @@ static struct pci_driver sp_pci_driver = {
 	.id_table = sp_pci_table,
 	.probe = sp_pci_probe,
 	.remove = sp_pci_remove,
+	.shutdown = sp_pci_shutdown,
 	.driver.pm = &sp_pci_pm_ops,
 };
 
-- 
2.17.1

