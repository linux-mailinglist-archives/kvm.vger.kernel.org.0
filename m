Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B009398C1B
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhFBOOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:14:54 -0400
Received: from mail-dm3nam07on2077.outbound.protection.outlook.com ([40.107.95.77]:45953
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230093AbhFBOOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGDPsyS4ZxhEg4hiaiascxQ7QpmbXicT3WNikyRfsDS4iONCTQZtucYrdO8/lO8i2hsx0vFsSKcZD4JWX/UxjWtwuxCW3JxuE266gh5sCoK0mEWdRgHuDdmhOvPjz6Qje2JaVnGLqVv/NVmZpvtzf3Yvyd8MW5LvoA9c6UlmYylIElgLt5/36Le5EQnr1lE0pRPaKu0dyfehxCIrscVE4uNwk9/b+Wl2JNNGLnh9mheKWqRBBEunk4H94Z48uQgslp5EmieErNvNN13xRs6olAT3/xQu7rSuSLNnsF8Ds5xF6K3ZcsGpd+JC7TW0RzfKuYQijxWxH6Zq3m7YoLf/9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SA+GvkxqcIKuAmhsi0VrzFsAQZ2+ZzX/nHKGnHU+H0I=;
 b=AGk7TZj7dC0JHWr7fCIYSKRBd+vQXM1AmA7ewuhZpnJXvn0mgP43bGeOSfkwYoDqlH7S4yztmFEA+wmWqepY7stLy+Inrqcp00Ms3BA3U6OCipWcRD5bsdK/7NKwc/YM6axTLAqyLm1R6dADfk8MuYR1AGYm45S1oigmRQxE4A8a0XvZasVpXhYMPZTov7svIJv/m49LbYrtKF8iOmN62vbojPgKCQ4V/Xt8OzLMOXEK6HoJKZitqmlwyhrtmrE9lGAqcFGmVZyhRZG4Q5l/tUd9s3WKAxgo+ASUREx+OB+7Rz63WUSAkoi+s8022B/xNHpdiGrHpHiRlsyePdKatA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SA+GvkxqcIKuAmhsi0VrzFsAQZ2+ZzX/nHKGnHU+H0I=;
 b=KlcbnCxUeLYZTOu7fnt0wy5vx7WkxbMADWMQb2H4pKJPb6S2nOyJNdsx130ulc31nfn0tI3autdQSv+EFq18XmVCexqfc+G9JmO47GFB9WHHRWeQrfxFDClu4kikPrvh3GU0HpQ1fMFoBHns8yfMm1mB3SzL71pFwZ+KXxD0fbk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:45 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:45 +0000
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
Subject: [PATCH Part2 RFC v3 13/37] crypto: ccp: Shutdown SNP firmware on kexec
Date:   Wed,  2 Jun 2021 09:10:33 -0500
Message-Id: <20210602141057.27107-14-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f35e2d1b-f209-41d8-a08b-08d925d059fe
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44956D002F4628F3E16C4071E53D9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8NFa4KWEyWqKdCBxPsG/ScuhA0vo5Ur628Ztj9I+dBZGoU0avUG/u3kO8hDlfVyRE5IyH2eVmsKVj6ZFl/3o6PbB58pYIfl4qSZjlOtd9hcPHRyulztbfdL/i4ISaWg+ZynqTm21nFOSKv6/FTUfm0VIyZDCEotKXGVWIm3PASNVL09oQ21Bn/MuFtZjgBmAXkBjqkpIy8cBdF0tv1ejl6rccmJAZxyCPrltLA9qWgLEQxa6o/rOSOO0oV0xVwNDUlcfEAGj/RTUKhKxlY6InOeR0sBYBQfqVAj+C2FEwHV8PlGDqSpSBMiLYWMTfiRbxjWrQWuHxy9b29PwJ0A5GMFN520EWhMj1UMe1l49hfQNrLTzEboym3UMwEbDWdO/JrAiBylWLuD9UQQ41NvLqR1xhYyJCvz8qG+wDe7zcCWaEi+4SacoW9fF6YwTOiKM9RMjf7CDUtYstw2WKC4QS3ohRHAzRcdOp9mxa1BN/jhodsANHhBXpDQyiNHoqdYOEetAEBF0kXDnV8lNELYUE7to+xOXluDg+WTmYYe+VBFPZnAgGkjPqYNRm0aot3HkYFQ8FutVGMmN1eUUKRs+GwkELbbIFN0VyW/U5uX3bvK6w7EOIXyDQdjHZrr01R0VZPnb5n13j1TVbeVmlVl9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(54906003)(44832011)(8676002)(2616005)(956004)(478600001)(6486002)(316002)(86362001)(4326008)(7416002)(6666004)(38100700002)(7696005)(38350700002)(52116002)(16526019)(26005)(186003)(2906002)(5660300002)(66946007)(8936002)(83380400001)(36756003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6dNlb4UavJy88d2ZFHiT3FrNwBVEHXwSQF34vEkeK/9oWtwHfsVzEuERVJ9N?=
 =?us-ascii?Q?ylKGVZF6b4B3pEknP4C/rEIXYJvUsK8SK77Qi9u7gZYErV0s9mrd9E4aTyBq?=
 =?us-ascii?Q?VT5UkbUwutGbfUgEoelLSpwE1a5Ub1QlLuRrB+JN4eZI/eIbRz3BMd24TKde?=
 =?us-ascii?Q?TuIYfgl67vZlyK/mwXHVpQ8laUb7tFAG2sfPu+A1JH1GkNAvu14RmmNpYxDO?=
 =?us-ascii?Q?V4zy7CMy0shFvE+ixdRhAzh81PoOS96WqQbNirRmPwbT8Gh4bygb1pxNO13H?=
 =?us-ascii?Q?KN4ad13sCgUf5i1FuHI8SS6lsTbl7coN6jsrexsbFi3Ize6ONxU1ovDu0dsT?=
 =?us-ascii?Q?C+m9idbaYkw/nYjUsd/b29saEe1H9cV8bOTl3vFsY+ec1hWgwrpmCkzndeQE?=
 =?us-ascii?Q?nx2hVv0C3TgKgcnWZIeOzMcXOFm1BMAPRUcR8SmvlQT/De/oSsJXE6XTXJE6?=
 =?us-ascii?Q?cqKRgCFbBbLODl/buohtXWbVcERQ3e4ZzcT+xz02mg0kyh0R7GPB5qhLCiND?=
 =?us-ascii?Q?3sPGHY/+ZjkvCx4pUw386k9dQninzrAdi0Mu9Cj4JECSIPoF+U9BsTV00eGI?=
 =?us-ascii?Q?Qnsg2yMHzHraYYjpvPqVYtMsHjeVdiuN145gUI+lLVsudko5j2A3ogZMvr2w?=
 =?us-ascii?Q?bLfxPiLGeI67Gth9Y/yOZ5YynTmDuMdurHiI1M9pCdGeVQY3FdFLmNYMCdMh?=
 =?us-ascii?Q?+MLFUdNN3weVi7/afrL3WDGDg0btI3IM+jXxRs58jwpieDlXEckBUFmFq1ux?=
 =?us-ascii?Q?2XOOPVtaNbUDqRSNCvDXhY6jyheUvNXm85j0/qhGxT+z0LbwwfEMOsn8dflR?=
 =?us-ascii?Q?PItFgrjU5/9tjnCc9EJqsR8rHMsl7jWX7X8UGVAiwHTx/DJG0EKs1bWQFr7N?=
 =?us-ascii?Q?/TJArYSOs4zqd6Jf1XsO5NFfHJ6AMtrKsPilBwJA9aM5myKiO52E8aX8DNl3?=
 =?us-ascii?Q?A2LByEyaafEgD2RlhQvIqSRS7rEqli0yYVhyOH0GVThNucAKqyGZcBVvW4tG?=
 =?us-ascii?Q?k0/lgn+gRdY4Thj8m+fqv365GKGEIjpsaW9mPXvoRH34MVgF9taQY4XJTMaE?=
 =?us-ascii?Q?ZoyybY7kyJllViNvLn1ulMLT+jaHzoEhszXUntf0UjjE/cIQqQaCwLyNXeNA?=
 =?us-ascii?Q?+9E0+EoaenUxgMMcCJtFI8RqOuV9q8a+Mx0kUHBYAZMvtaN2nhmBYNS/R8ac?=
 =?us-ascii?Q?/5IjHeDk4lVIj3qrF47iGBDRw3vhRXqDAvwQRPYEg25mS/eWry0RzTUEZSXe?=
 =?us-ascii?Q?FNVRa89YtXldtzkTOLxQk3o77gydl634o3KYhQaq9u8zBfgKo+KgtM57eQlO?=
 =?us-ascii?Q?GI6FzKdcUMkqZtoX25rXi69n?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f35e2d1b-f209-41d8-a08b-08d925d059fe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:44.4799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/NlmFy8BklacN89fQZrdQhTBPvkx9g67AzV2T3zqD7FnKuoqH1Fm5M4Jzluo0SExPM89Lo3CYN7jhfg3EPT5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the kernel is getting ready to kexec, it calls the device_shutdown()
to allow drivers to cleanup before the kexec. If SEV firmware is
initialized then shut it down before kexec'ing the new kernel.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 53 +++++++++++++++++-------------------
 drivers/crypto/ccp/sp-pci.c  | 12 ++++++++
 2 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2203167dbc2e..b225face37b1 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -310,6 +310,9 @@ static int __sev_platform_shutdown_locked(int *error)
 	struct sev_device *sev = psp_master->sev_data;
 	int ret;
 
+	if (sev->state == SEV_STATE_UNINIT)
+		return 0;
+
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
 	if (ret)
 		return ret;
@@ -1115,6 +1118,22 @@ int sev_dev_init(struct psp_device *psp)
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
@@ -1122,6 +1141,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	sev_firmware_shutdown(sev);
+
 	if (sev->misc)
 		kref_put(&misc_dev->refcount, sev_exit);
 
@@ -1152,21 +1173,6 @@ void sev_pci_init(void)
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
@@ -1224,19 +1230,10 @@ void sev_pci_init(void)
 
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
index f468594ef8af..fb1b499bf04d 100644
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
@@ -369,6 +380,7 @@ static struct pci_driver sp_pci_driver = {
 	.id_table = sp_pci_table,
 	.probe = sp_pci_probe,
 	.remove = sp_pci_remove,
+	.shutdown = sp_pci_shutdown,
 	.driver.pm = &sp_pci_pm_ops,
 };
 
-- 
2.17.1

