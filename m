Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389E436FA98
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhD3MlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:41:04 -0400
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:60768
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232761AbhD3MkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGCO9A9lp2vRWb0pht09BQMq8vtlb3CAW58Tq5RVJDeMOR79TMifzrq023UhiArBeJ9Qq468j07KN58QopAIlNYfY816a5vi9ekcciZNQJ62uQEoQMvAJYFsVC7pfM9sF6iyguFtvMI3XDOGMX6NG48QBp5U9UPBFibMQ4BIcflqinqe9a1dvQj9ZZvLL1IFjT3tNjyNVEhYOvdmtYg8nAwIgN7Mss0loap7nUGmdAyccVTkd+j4rYJiZ7lxdPDsXO7FZKKGx9V3/vJcDus/K31iqS6Q1Sjlu8J+D2rauAwkyGmKgC7AdF4hFl8akuFZyD62BOrPf5HQw+B7dzF85Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1w0L6EGb1S7ha7zRDf2sE/cGRpglkxWktLSVr9pwXjw=;
 b=XgbyeV7v3j4TxOoeGYTGMIRrMVfrWUg7nXsXStu62zJpaEsDDgHtMSC8cYaNlG/Bd+NGa96o0byiuPT0LmsCBev1waQxWJJOBoop6f5zyMwuzllL2px9TGxD/qFlZ2hOOu/za3m6r5Od+Vb4DyvnFF1olz/OA0vaH15lhfA9mJQO4osreqSExbRbnjZ+TrN2Ek1MwJpJIVBslGEjtGOEhsqMq54p2vM6bN9Pk5/3dyE4Y/lRSAfatf0aFEppQDqpnFnkgLpN4/Rk6AnrMBEojZo1kTh+8HRR9F3MsZ54UnYBqp9ls57CKxn9LQnMC1lU3HElAowtsMsJAaF6rhcrxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1w0L6EGb1S7ha7zRDf2sE/cGRpglkxWktLSVr9pwXjw=;
 b=VgJ8Kdfhpyg8H1nqWbXiNjJ/dskWAoYTr4m8gqppw441poYVK4Q8NZnUre7i0nbmtkp+mp0lJHV8uAf+eMDMjTC5oegLvsT9Bj+EaBPKQKbU43A0vZkpET/9bnYOJqfyec8LFKy+yTUcutNwmAFtYuHfYe9peXO5qFPTOWsEkHE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:04 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 14/37] crypto: ccp: Shutdown SNP firmware on kexec
Date:   Fri, 30 Apr 2021 07:37:59 -0500
Message-Id: <20210430123822.13825-15-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bc75369-9861-4247-6a4b-08d90bd4f023
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB283271DA53B1D663C8923F43E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7yFO/99glprbPfT3WRb1ZGOEfQOD/svc5Ize7C7LlECqLfxDmEy+s73yPgzcHXN4VGxEwNd5f3pKsryuTDpb0P4zDMkN77gp7hmtvMoZTUccN1hMykbwRifDFInlHdOhxW0Xme+N3IEGYYkkljYAbXMDLseVtcfoW5ayhZH+fJdHSqKOvJecWevpDzSS2m6X3lYIp5Epj3EDT8XTboBZnnWMGHdIUF6gcpfUkuYKRuPCI89YQI52t7RQ3CiJ3KfcgUDp5FuL0mdr1D6euoxz3+zmxr+DfSARC0+shIOxHnDQ77o38FmX5zOi3P2kxyPTsdJJojgHkz1oOdVKTlThMb0g8Ei73LCazTFfl3vLMurDkr0dpJ3xy8Ho52jP2f7s47+Lw8UTTYPBrIjg7faAWnR3VuAzoBoVGfaBIV1zLBZcb4bVFdJDd25freXq1RQ5zhgMWNYygYGZC8d/qqu2aJxYX3gFaGzXTDR503xnWBIHX/IZ4NXL3+kNlyAbqmgYorTSF5bvEMSjIoQbWDd1rA2n4I/qy05VGk3bRfENe9NtbviuR9RlnG1Xk1z9gEPSb+hVbiWBn5f7KpidGm21J6tu5szOP04POrInkalVp6TfNe7fee4eOazTQ3oTdBQHOc8CvDvu8pWgroMMNvMt0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ey8MhoGcDaOkXCG0lrL3e1OOt3rahShbESBRwCevG5PbCQefb9OMaFhFIa9N?=
 =?us-ascii?Q?kQiqig/nchGp0NYOic1nFgpBrYb7L1JwLH09yfgkkJ7umNymHapFjVrXPBdE?=
 =?us-ascii?Q?yqiRScLGWu0OPnD0KUt2eZb50FLPlzt6Wq9TwFUOurDaJPofV1LAiDz//KL8?=
 =?us-ascii?Q?aqONjvjzqb2PNndNO0OnjMW9EtYYiMjN6RNsom/IsW4iI3ACFEZ2CvyFvmwY?=
 =?us-ascii?Q?oBRGgWzno49a+lFSv/7sJ0VR6zNzjSXZaqwZdfLq2lwf2W0xZSz4mcOeMyD5?=
 =?us-ascii?Q?El9dg4dalr4QsVnOc7VYwKJAfn+rNXPogtCk3ppTbeEnFqTcQe6xciqqzTvI?=
 =?us-ascii?Q?bZwGXsHF9zK7xiRRBuFzaSg8/GsXsvOeIMltw3ceOorD8k9pwV+cMc+HjP+N?=
 =?us-ascii?Q?aTw8LyWZA0/dBSaluFZo2LJKe3kdjIV+bKOdatzFoL8rxnYsnr7ZIJtsF2Xr?=
 =?us-ascii?Q?G0WO42c60opQOJFkuQlEKdr9XmkPm5LiqiQrbI8eOFdza7cNN7RFuUJ8xFdK?=
 =?us-ascii?Q?CcEP+jWVjeaHbK1FmAZS+Ly21+GQ94yb7UaGmDIauHAqRfau/334tG3/zKq5?=
 =?us-ascii?Q?pkJNVEI5+o5yUOdEMJirH34OeF7GPlJZRxyN5yN3AcesN09r32YtWRi81DtP?=
 =?us-ascii?Q?5SJw6HPZPGFywbLSzZ3hofGs452ncG9Q2W7nTqetpVpOuB2GKC/NBbGfqImS?=
 =?us-ascii?Q?7siSE4lJxGsawEsNpj7S3XkO2+w6VcYS4sETy2zO/sJH7jDIyiu/UV/rhiFg?=
 =?us-ascii?Q?KKay1nYsyxRxoE4jhgUk9o5ufP01o/d4L6YhNWUe/nCYsW++e/oyM5LCll/p?=
 =?us-ascii?Q?Ooa5lzUVzHPns+kxhBcpHQ0jPgz8Xg94HtUzfo+eNypxci13/6goJhQr+3by?=
 =?us-ascii?Q?92epK069bGZ8l2986gryqU16MoJQ4o3ow/nVfK9eQaSYyg0k+/IORdl5MkUB?=
 =?us-ascii?Q?J0yAS9+7v/BIMzvc1Ew8nL0PDDHA86Sqd0foaLgGZTKhzr8cyWvfk85tPG/h?=
 =?us-ascii?Q?3AmudyvuQUkGL9wg3Yr7s11xGG2dQa8t3kIbH+Seoh6UxSFmavnN8V3ndS/z?=
 =?us-ascii?Q?xyPXjnSBr1o86arql0Mm5FX3vf+sH3VBr1002LJWqR4Qs/DsiPFLkUOWDnum?=
 =?us-ascii?Q?QSzgmzLIr6fx610FMZkR3F7YSxwJj69KULOuN2Z3Yd8y2vJmQQOO2lSD4GH2?=
 =?us-ascii?Q?TSlxhi0gClxwSoKhHWMxK8hKY8tPxhVZDMEFDwzQgUlG0/Kpi6DNis1NZPg0?=
 =?us-ascii?Q?0Pq8zIs4gCpl3AbNv1+g97hIFYxa7S/KMP9TsqTDtYMjx/vReJhVyQ9v0Ush?=
 =?us-ascii?Q?Qkn9brRHhIibLR/lk7EeRM6U?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc75369-9861-4247-6a4b-08d90bd4f023
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:04.1479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6e1vc0JpGJ+ppDDiDFw/2eiMoodDmGqyNdXUxL0fVJO7NnEi2PxTgPwfLkIlUGMXCgS8jCjz5jXntQpZgLSaQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the kernel is getting ready to kexec, it calls the device_shutdown() to
allow drivers to cleanup before the kexec. If SEV firmware is initialized
then shut it down before kexec'ing the new kernel.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 50 ++++++++++++++++--------------------
 drivers/crypto/ccp/sp-pci.c  | 12 +++++++++
 2 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 852bbeac1019..23ad6e7696df 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1109,6 +1109,22 @@ int sev_dev_init(struct psp_device *psp)
 	return ret;
 }
 
+static void sev_firmware_shutdown(struct sev_device *sev)
+{
+	sev_platform_shutdown(NULL);
+
+	if (sev_es_tmr) {
+		/* The TMR area was encrypted, flush it from the cache */
+		wbinvd_on_all_cpus();
+
+		free_pages((unsigned long)sev_es_tmr,
+			   get_order(SEV_ES_TMR_SIZE));
+		sev_es_tmr = NULL;
+	}
+
+	sev_snp_shutdown(NULL);
+}
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
@@ -1116,6 +1132,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	sev_firmware_shutdown(sev);
+
 	if (sev->misc)
 		kref_put(&misc_dev->refcount, sev_exit);
 
@@ -1146,21 +1164,6 @@ void sev_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
 
-	/*
-	 * If platform is not in UNINIT state then firmware upgrade and/or
-	 * platform INIT command will fail. These command require UNINIT state.
-	 *
-	 * In a normal boot we should never run into case where the firmware
-	 * is not in UNINIT state on boot. But in case of kexec boot, a reboot
-	 * may not go through a typical shutdown sequence and may leave the
-	 * firmware in INIT or WORKING state.
-	 */
-
-	if (sev->state != SEV_STATE_UNINIT) {
-		sev_platform_shutdown(NULL);
-		sev->state = SEV_STATE_UNINIT;
-	}
-
 	if (sev_version_greater_or_equal(0, 15) &&
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
@@ -1220,19 +1223,10 @@ void sev_pci_init(void)
 
 void sev_pci_exit(void)
 {
-	if (!psp_master->sev_data)
-		return;
-
-	sev_platform_shutdown(NULL);
-
-	if (sev_es_tmr) {
-		/* The TMR area was encrypted, flush it from the cache */
-		wbinvd_on_all_cpus();
+	struct sev_device *sev = psp_master->sev_data;
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
-		sev_es_tmr = NULL;
-	}
+	if (!sev)
+		return;
 
-	sev_snp_shutdown(NULL);
+	sev_firmware_shutdown(sev);
 }
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

