Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B374A398C50
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhFBORZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:17:25 -0400
Received: from mail-bn8nam11on2046.outbound.protection.outlook.com ([40.107.236.46]:14177
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232086AbhFBOPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:15:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5dM77ilCsrnsKmWcP0aCRLj0G4TkE5YCg/Y12ziFyjAvMMMVGwSOGCc2L1BRnoM7LrUL2lvTEzViOKHSOUHOrwnniI5vwOuNRQc4Q/pMxsSjX7jgbTMwPWlhYYCHLGHOOoVtTzGP7vdYKcr5hc6cJ2z7XBx5Ix9Q2wCNFkyk+gU/tIu1NovDyqk8RC95hQQkkdIb3kQmpYMJnxcvE9wCCs1EcFfZSaKQB6+vUq9Ce5YM651Uqv3yCZ58DeDau6EeizcIhpoh8XQGcnkDKAkWW90va/RuKvDih9aQLFPiesqlYX8UeOywYJ869TPxSvcZTduX/0S6C8cXMGjsuxwtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuTtlJI+WhUL7P1v0QZxB9ntK8AC1kuUHWv7DNtgqec=;
 b=eG6Qz3huKK0qlmPrFcoFrtWGYaudvGz5H7+kVdMpMJj0oNsbowciBl8FbYyAZehHZe+CxKl27FjbLAQE7P4V1y+gSPo5/rSyEXs5rp0PUS/PmuwIJGuVSKQSGCo01L2vK0OGh2lHd4DScVmn2gsyVQfs0PzBnapbQYIKsc9AsgNLkM7dYPuws5hFFE+iTxamKUhQF+4FwurWbz5ANycsH20Z1N4Z8UPmZmdMiVat+OcB8EvEhupEQ8VJgU5TwsR5bOXI06/7IYgvCJ9ui5LFH0+k7uY8QLToKKRzVVulHmV+C4gEqV9U6rRDyNO4Pq/XZ8H4ZC16+N6uKaVnu1PQpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuTtlJI+WhUL7P1v0QZxB9ntK8AC1kuUHWv7DNtgqec=;
 b=FHwo2nRsY1QSriOYA2ZMFRGHq0uJY7gfGbzO6A156oKqDBKZaVkNdYK0dm2wXGPS+I+qbp9GHs/2vc5wvclV1mnbLLJYYYY+RJCrnVSteZUgy2b9q01VotGNDksqE7AQF5Nb1AtF3I5WueyGrhG48GWydUMW578erYLbdZg8yMY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:43 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:43 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 12/37] crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
Date:   Wed,  2 Jun 2021 09:10:32 -0500
Message-Id: <20210602141057.27107-13-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f65a89c6-c2a9-456d-077c-08d925d05957
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23681783729258EB5590EBF6E53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3rZUSmjsuzZufBudDfjbA20/8tKgwP9gs3i2330q4jSzlfUkX3IZK7WfMKNNLt+bCXZeRNtuOU+JZq9iiqW9yRHkPwEWW64c15hj8Jg7oagz97NgDNGZAwUJZMaoVY9GrOwxLtKxg/xh2mA5fqd7xgGOltFZ8XA6wYBawOn2+HUKv3RFivGyorf7fU9Oh97cRw0paXnUzIITpCIhK1w+cl/Ii0ErpUuFpSlmaohR/iG6obplMcwv26ee/9qA606vhBJ6V4mG0QKIH8BZDwEYeEYtX4XYVvH4YPNSSm9QexvLVeb/g8HkpJZQ3zzotBqHO7VtanDQaBYSffOyp5eRbK97/putz6CDRJgNfRTQox+CFkc4S2mZZ2wOiNOS4e7JR62rOnO3evfpJ2aiyeNCsqrANQGNtRzDDfB3qyCwSWb1PjGJW3I26grtL8Gg4c/VVle7l4SnSYIC5wwy92KD+7TndyL6CxF0SjNOkW07iXZqgISdGnViOJZ0EMF9VV0tPLpm39hZyHqIEgb/yV2rKqE43dHlFjTozLY3DGxkYkYFX2w6gis/YLcT+dOlQN4Z4DFuVGATIAL2h0HTLgfprhhlK1geKJC8Yv58hUfAo1cwIjPMQ4hCoEkrFqCupRt9zizzPel7T7F679TsiyH3fykfzTL9VGQe2vQXTFLxwWpMlPffKB641zKWS+B6TdC0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?N0zHONSA6PE6B23xhflEql0rXZUFzO4GNi6lh8Ir9R88Qn8aOVmXBze7uEK6?=
 =?us-ascii?Q?w6nm++mpKwklz9t0kI6dyXvsC9KHJQ+77rZKwIKrIH82WVhqXe6ZmW/uZPVp?=
 =?us-ascii?Q?Jou2I0Maszygt7jwNnIfLVHQnXU6PJLJL/0sRx5XNy3HCb42m27IHTzlh8Yj?=
 =?us-ascii?Q?bMhzhMEmz7BnGEVi2sY8svPV/7AOBh2GlZWBKnPGpoiqmI5pHaUPkdP8bKNe?=
 =?us-ascii?Q?+qDzhjwbE/l3maT3Aftlamjv9i1smFcS5aw0FRZo2aH1cqU1Apu5KFIdzvVg?=
 =?us-ascii?Q?aBvJLEvkne06cFhgTxm6ZNMzAgM3AkgTeRL0oLi0V33LVLIhAUOAJBwew5f2?=
 =?us-ascii?Q?lWtSpn4vU9hlKKp0WTtC9KWUKBrxmupYcznvSErghcgDvjnJO6+9UXOo/dp6?=
 =?us-ascii?Q?QUetoK0e5TvJz+vE6yOT6Pus4aV304kqB5cVCLT7H7o8cxodZqwqfFjmYHo2?=
 =?us-ascii?Q?b6H3TPrnAdc/MzQDLk48GTtJPQZmawb2fK0fCdVPq0qwTz8wxltdvdQulT8m?=
 =?us-ascii?Q?cA/vyN1hJVi3yMsQ0L1bgCG4RtiRFZpQqn7z89F//iL7CeJNPqLMx0Hczh0v?=
 =?us-ascii?Q?18iAYTVDc12qHX/7vOWjoBEJcwmgUdY9AuUzIPC77SBqm36oqVjL6Z69YcrJ?=
 =?us-ascii?Q?HwmkM0JR54PK0q3GIG44LF8RYStVL14LX4hVUNGt2w4tjtzkWvr4v6Qqo8ro?=
 =?us-ascii?Q?Fc/zHexiH6x+9uwjqRMZBhvHpwtp+b0FE+XJR6zClvl04LzVbMA2SJPdO8pp?=
 =?us-ascii?Q?BQG1krPgYM9fCVyDf6KOJrDg5/TRN5wbGqui5C9L425+O4rwXXqNoWf3RAhS?=
 =?us-ascii?Q?OWzjee9fCfDIZPVL9enAtSIghhHrIvKrij+89OPUX0t0oNO7tXAOMa6W4Ks0?=
 =?us-ascii?Q?Aqh6iTUAq5qnWVIAnY5qYwuGHH4S/d2Kh9qlebfSuMR2Kd8eajBGvAuIkpsi?=
 =?us-ascii?Q?WNtar4i07Jd9aiRfyxNI3XyDaGOgADhKrcCGUWzHRzEJb9OGr5nSQrj6TPiI?=
 =?us-ascii?Q?jSfmXSdfG6DEi9B51mq3+Pc/DxLAO7/okd7WaLuYoe7WgegfmrJwaHSn70Qh?=
 =?us-ascii?Q?/5D1KcEm7ljHlsgc7aCzMHBRpDa0oUYtwL3GNrzubCg6y9Ra2AoSeyvTaSzE?=
 =?us-ascii?Q?k5FP2AYFnC/3keCl+o+0tYOyi3DfixZIl3a/dKIEkh9qkitRCOS8lms+7N9L?=
 =?us-ascii?Q?c3SjvOHSGV02/SDGKRWl+bUxrKyXDtirxQolPNuao8lkZ9xKAI2hOa+uDyIG?=
 =?us-ascii?Q?WP2wIYmAn2+y5p9yM3K5ASKmbB2wR2DznSzUDtEXO8KOJazpmE6HS3QdjlRY?=
 =?us-ascii?Q?2hv3A0a5bL6JLMikpz2EQQwQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f65a89c6-c2a9-456d-077c-08d925d05957
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:43.3815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9whaJ3936iNvAMi3R5uxGEQct6Z/ybFANuAl0ksS2ih62Ix/2xm+pxxtcTuFQCg05XiJjTeqIPMZTrQFENSsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before SNP VMs can be launched, the platform must be appropriately
configured and initialized. Platform initialization is accomplished via
the SNP_INIT command.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 111 +++++++++++++++++++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  16 +++++
 3 files changed, 124 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 0331d4cea7da..2203167dbc2e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -591,6 +591,92 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
+static void snp_set_hsave_pa(void *arg)
+{
+	wrmsrl(MSR_VM_HSAVE_PA, 0);
+}
+
+static int __sev_snp_init_locked(int *error)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+	int rc = 0;
+
+	if (!psp || !psp->sev_data)
+		return -ENODEV;
+
+	sev = psp->sev_data;
+
+	if (sev->snp_inited)
+		return 0;
+
+	/* SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h across all cores. */
+	on_each_cpu(snp_set_hsave_pa, NULL, 1);
+
+	/* Prepare for first SEV guest launch after INIT */
+	wbinvd_on_all_cpus();
+
+	/* Issue the SNP_INIT firmware command. */
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
+	if (rc)
+		return rc;
+
+	sev->snp_inited = true;
+	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
+
+	return rc;
+}
+
+int sev_snp_init(int *error)
+{
+	int rc;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENODEV;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_snp_init_locked(error);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sev_snp_init);
+
+static int __sev_snp_shutdown_locked(int *error)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	int ret;
+
+	if (!sev->snp_inited)
+		return 0;
+
+	/* SHUTDOWN requires the DF_FLUSH */
+	wbinvd_on_all_cpus();
+	__sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN, NULL, error);
+	if (ret) {
+		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
+		return ret;
+	}
+
+	sev->snp_inited = false;
+	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
+
+	return ret;
+}
+
+static int sev_snp_shutdown(int *error)
+{
+	int rc;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_snp_shutdown_locked(NULL);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+
 static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1095,6 +1181,21 @@ void sev_pci_init(void)
 			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
 	}
 
+	/*
+	 * If boot CPU supports the SNP, then let first attempt to initialize
+	 * the SNP firmware.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
+		rc = sev_snp_init(&error);
+		if (rc) {
+			/*
+			 * If we failed to INIT SNP then don't abort the probe.
+			 * Continue to initialize the legacy SEV firmware.
+			 */
+			dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
+		}
+	}
+
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
 	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
@@ -1109,13 +1210,11 @@ void sev_pci_init(void)
 		rc = sev_platform_init(&error);
 	}
 
-	if (rc) {
+	if (rc)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
-		return;
-	}
 
-	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
-		 sev->api_minor, sev->build);
+	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_inited ?
+		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
 	return;
 
@@ -1138,4 +1237,6 @@ void sev_pci_exit(void)
 			   get_order(SEV_ES_TMR_SIZE));
 		sev_es_tmr = NULL;
 	}
+
+	sev_snp_shutdown(NULL);
 }
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 666c21eb81ab..186ad20cbd24 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -52,6 +52,8 @@ struct sev_device {
 	u8 build;
 
 	void *cmd_buf;
+
+	bool snp_inited;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index c3755099ab55..1b53e8782250 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -748,6 +748,20 @@ struct sev_data_snp_init_ex {
  */
 int sev_platform_init(int *error);
 
+/**
+ * sev_snp_init - perform SEV SNP_INIT command
+ *
+ * @error: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int sev_snp_init(int *error);
+
 /**
  * sev_platform_status - perform SEV PLATFORM_STATUS command
  *
@@ -855,6 +869,8 @@ sev_platform_status(struct sev_user_data_status *status, int *error) { return -E
 
 static inline int sev_platform_init(int *error) { return -ENODEV; }
 
+static inline int sev_snp_init(int *error) { return -ENODEV; }
+
 static inline int
 sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }
 
-- 
2.17.1

