Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F3A36FA8B
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhD3Mkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:31 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:33505
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232621AbhD3MkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTyUm2miM+AwaRQ8zbKP4Q4/xtnzSz9vSkvP5sInDG+NUfAJgMVuaNlaIXPJzjvyR1SpRhk5v37G15KEIpM8J8fC70sEv0VDlCtLHWI+Wjj4LxAtWReRc3ZGg+zt2qbEVhD90RmYJxli5n6vdrSEu60U7W7M59IJsgimngwdqUcJ0vNk8GCAcJk6hEf2VAyqXSDdtPFR7Tip+JNHceIZIAypEWHqNe9uLkz/fBzJfnQ9lGMLeHJqFJXEXZY8QC3Uc44BY2XmxDlcPi8o/+h/5+vzPR28aEouZfpeznTbVqlAI62GxCNpEgAu2UsW/ISLL5cPQjzNzNflcHav0jw0Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSvLT5c4c8Rex9ju7Ee2TBu8M+BEnYf3VBY0VkT0DCY=;
 b=Zt8L2C192vmfxLkwtw+37yqdDqZnL6hCw201xadbCLFAm2fH/wHP7PKs2kYNGFg5XKNPGl6fafrVOMv9TN0A+mnbGm9MA3sLdzDVVP9P5xDtYOY+sJXPl4EF5GZVqAyU47XhsPGyV95hfGWirJyXpimisJT4hukLGDjTdVjwlXUFiJ0LaR+wu9C1DLT3JOW0pa/mf4V6uW+Jp/14igHNPs0BmyusFE6pweNhlnJvVetsvQKAQRlARqyEN0CMWaxtHdVgiNWLeivqZIDEhVJxA/nrMdpxLKqiWBXfBwhmuMyGG0Qt0loyk1ml46HWoYVvxc470AJ01bHq3lcFOCjMNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSvLT5c4c8Rex9ju7Ee2TBu8M+BEnYf3VBY0VkT0DCY=;
 b=dt3G/7Y07c4JHJoCm60G6N6y1cIxdZlQaw4UifogPeKR8zCwFnWclicXpzBIEYzNtGc5yC32aA5yURBkK5e0/TVl9DIk35mlxNqEEOUum4+uUVP+O7fl73XD1NW2xQabZXh9N7uH9pMMOtiCA+RDJymMVuaJUvvJEgUxX2NhhZQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:03 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:03 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 13/37] crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
Date:   Fri, 30 Apr 2021 07:37:58 -0500
Message-Id: <20210430123822.13825-14-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7516c5e-a1bb-4785-1c2c-08d90bd4efa9
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28325719598CF6C12E15F062E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlnj5p24ANdQP3gk66up4XD82XptTtwPKAvJV12sY73p5r+UmG6NkDH7NDyXN233Y+Ip8vKXZ7eL2jOBK1x2Kh+SXOEQV+gNhgqEOHZ4wn/CebcKkbT3G6Lbek4hDW+qGiTEfqpihMjYMjNLZ1FbppDmh+84NZRFfPWiy+210irjg30J1GICMgkqdQ5gXPHhnnRhXOEF3UuYdA+uzBDbYY4xJDccVyB/HH1deUeTvA4hrZY0GmrnX07R8u7C+OiRHRarKtp7V17GXpqWPyCxNtKjox+s+dd1cT8OfVa8uKuUP4gDPsjbPFls6DJIrq0/6H+E1x0VCMa6cQq8Jh9/vgy+q0WiEOoG5/wqsYNCny0D+fLIhmqz9ZUxm1SlaW5I7CmwJ1xva1k4lVF2mj1MklilTM1C1IeI6WTuEvOvSkLqSDvn6+MgzS0TugcfNRYx/u4kb+hdbLxdzN/U8uNjo2PsSCOU/dlptcv7lMJBO78WAOr8VbQWVYHTHgSBpx5+lXOxsNGYIEhVxLDYDd/YTQzHp6uv5NBIGEOi7Ww5s8HQ+1rfpD0L6RQJGQ1FBNqcyZhWFFw6j4ULSLWQ6v24FkEh5PZuJM+C1oE9SZ4POVITDqmscCrF8aaeffaidUseXW0yODX0RMjHGpSBBhLBtwNFm0v70SqC8uimx+g6h/5tCMi+pT/q5p6A/jnc5hlt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1RbICn2AeONVTon9dKXJfPQ7CwURv8iSrGI3txhmQOUu+TIf6UNOHCDxZZ8z?=
 =?us-ascii?Q?x0zuz1co4ug3m5glU3zkwtp2Vzs7jvTXeevtakMEeTyR1wr6RZE3lS1JMW5+?=
 =?us-ascii?Q?lyuX5mGOKgNHEv5C2CzyYyZA6K49MIHmWa+f2oyKtd5b7H6lSZXSJEbhmYkg?=
 =?us-ascii?Q?3/4F9HH0mO8RNwQrfywQdLZIr+BF9Bn9WKjFR3KlKuyymcqtCDC6ur5IUrFP?=
 =?us-ascii?Q?oVKjhU684zgXbKbs7zMH4NSDUeZdXLWGOI8IQW2ky++J+krR/tmw/axDe0wA?=
 =?us-ascii?Q?56ykjpWFvkk/pt/zFDJCuk4SbTPqeSRwg1aRJa5ExKylGPlFjuoQ26IkI0fj?=
 =?us-ascii?Q?MjMWX+GmMXPRqs4X08zLXDYtuOKvanO594N94uNCJaO3fs0FmpZJgUKBom7J?=
 =?us-ascii?Q?08jqPASm/b8pJ1W90FTPNU0jb2zu7b/1tyujz1QM5QJXFShlZLcFUdtCi3BY?=
 =?us-ascii?Q?la6AYFP459N4YiTBgByL/F4xvdEj9eUii5CAAHg2KI+2RHh85b5Cs1VMEBq6?=
 =?us-ascii?Q?Tu3OFa5Fn1FvYaNdtfaazrBvmQiLuvhetcFYNINmS5sxbUVy2weCv+aXYLb2?=
 =?us-ascii?Q?g2UuJNY4KawgklASuW8h+GSLpim83TJ6LGB0w7Qr83ctkkulUsXeCeuauIQX?=
 =?us-ascii?Q?H9rsAMjKxwrmVgHDIN5Gry5AnAMB7bavxftQ4DJAedz3t/GYKPMbA8OfwMWY?=
 =?us-ascii?Q?44NNh1wF3N5xPt7sA8+hw/BhEiBWoCKhQy6eiHnaqy1nLxmXCFQNFKLEid0A?=
 =?us-ascii?Q?jd4OEe+awsouLMaWfQj+OzlrI22xHTDOr5BCyKZdZZt4snHNG9KD5t8Jtx9c?=
 =?us-ascii?Q?MTC2Gv9t92IkNhee5NDdmHP8MlGU2APem98A/ZDlojz74RARL8m3mxn7Ytj7?=
 =?us-ascii?Q?8+K8EKySSJTgv8omxrNpWFr4ehFNkTkTNXSfOa6if2lht6G98a/XVsBt1JQR?=
 =?us-ascii?Q?8ttcDtYYiqjrcwPMRl8v/h2LSPvThdTYfo+Na/3iVl5dorPC9c2Sot9xeNuF?=
 =?us-ascii?Q?eS6oD1TWXF+f0n1LudjypQZP1QF+f3euQfhsKvJsKZ7riX40T+j6xPX3rIrT?=
 =?us-ascii?Q?ifqv9Row/GP4IP8K8R7QVqPiC3bS8sRsB/H4YMsnrUccJjo46tNz6djEYnza?=
 =?us-ascii?Q?KqZxcPt4ru9+Q45BL9b7pI6QHU7UTMDqdWoSSLCp2xPz68hdoPD+J/0Oag20?=
 =?us-ascii?Q?AmcBeElOOhyNZ05OMFWLFAg4DajsVlit40JXSf7qu39N1/RIdZWGhVLQxFbj?=
 =?us-ascii?Q?4EuvcODMkB5enjCIRvdjdd4f+frIcKhgGkSRkD7F9UgGOM5zuC48h+pADHKM?=
 =?us-ascii?Q?ShDCHnpuxB4KL/jbgYWzobtG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7516c5e-a1bb-4785-1c2c-08d90bd4efa9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:03.3174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: srTKXhwqqt5hXPP72q381uN8JsLbmzrrJhPCV4IdnSqbim06iI/6nuZgCzB2dEWM1UkzvtAKkzoLroilfqZDvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before SNP VMs can be launched, the platform must be appropriately
configured and initialized. Platform initialization is accomplished via
the SNP_INIT command.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 107 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  16 ++++++
 3 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 09d117b99bf5..852bbeac1019 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -590,6 +590,92 @@ static int sev_update_firmware(struct device *dev)
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
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN, NULL, error);
+	if (ret)
+		return ret;
+
+	wbinvd_on_all_cpus();
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
+	if (ret)
+		dev_err(sev->dev, "SEV-SNP firmware DF_FLUSH failed\n");
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
@@ -1089,6 +1175,21 @@ void sev_pci_init(void)
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
@@ -1108,8 +1209,8 @@ void sev_pci_init(void)
 		return;
 	}
 
-	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
-		 sev->api_minor, sev->build);
+	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_inited ?
+		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
 	return;
 
@@ -1132,4 +1233,6 @@ void sev_pci_exit(void)
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

