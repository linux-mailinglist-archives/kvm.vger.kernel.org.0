Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2908136FA9B
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhD3MlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:41:23 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:33505
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232834AbhD3Mk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EV6XHxUHugOBCHxzZ17/5RJ3RcUdlubyjfSr6GoK3QobsheyWj9H45A3MNM8fM5UqB5NDg2/RFlaQ6KpIL8mHshrFuP/n4fM5kimggxtuv89a+gQjWp/TmMcXlbZp44/Vg9ryJ3OnwcP/oTxxkL90T20f0va08phPgzDoaCOTMNNU60ZQbqqeY2i520sykkWGGrUiE8sRzXXnD2MnVVtDCoWtsjh4ozw/FlYmMDO0Uqxr7tEZm5OhWJw67RjrmwJOOKrj7qjNdvFhbuMd5S3VXDrJUhvlJgsOqIDZ5TMb0WtD16c5i5kTW/rT3Mist9yQ+VwLNhS2EnGxcR22elMkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8sXDfQdXi6R8XUjIbg5/MM7nQb/5bgMWCmUfGjfFqE=;
 b=L47M0lEdYmyeBwqsPxlMfvq9X/czgaU4jlQfSg2TLI0fGULoNVeTCaa7lFlEW/rxyKTYkBHfpfACmXQ7gt4hi7uD9pWuevrouYBdEsA2Sb1FESRBX68bQ01fpiJzvhTtQg/LD0LnvOvZ07A79TKelB31swLVmcltF8ERDTFTXCFQ+oq/pcB2ycOccvEBfJKmfbj8Yb80AXCKrSF//dTBhq7wNnRsUP7HwZI4xjtjwGRjxKWWbnFrvJvN+K0peU4lsYKr54jFKmexfuQ57VkhTU+JsluKAZ8MsNf2r1te/S6UVfhpkw5a9BUr+P/ixEekrGZqEWduhQups568yCK5HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8sXDfQdXi6R8XUjIbg5/MM7nQb/5bgMWCmUfGjfFqE=;
 b=AH9CxQRQ3Z8Ko8EoV3I3+BpiCS3/NKcfiyEEBY3jEWK6/YGbMQ/0fkHWPqK/iBcYDgPcQBAr7cB15xoUzWBtGZIL8t48xxjRZoFi1M3qKmZ8o5GfKDcTfxEiGEaRnVO8neUpWfqaijZ4UApXYhkb5WpnbXt7fk4PNws/kM81z8w=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:05 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:05 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 16/37] crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
Date:   Fri, 30 Apr 2021 07:38:01 -0500
Message-Id: <20210430123822.13825-17-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10311aee-1f60-4ec8-85e4-08d90bd4f102
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB283268A7B543A24ED3DFB0CCE55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+1+YwD0couEwcqZx/iSRi7kL3pCq2oA0oUcL78MNWcLquH/2dnYPlGsbg0SXPtbrSY5n1luzwky/9XvvkLD3UB9wbvShPGGWAbMdbnqHd8zZnwSwhJKtLDM24dsb/oM0U1xY9dAOQZmU+hhcMYlDSxDxqlicq2hS+x+fX8iulE+83M+CsnwKOq7+hRYMjW18HW8yP5mC9bSZJDLG+QvSlR3KUKxxAbcF7N1lECwEVxBDx0g2ePoSqHrRmzkJmqTKL/UvpnJFAMYQcNxFzHwKWKVOBRvQmo/lM/4rJbCQDmopA/8J5EmHB5kodIurwn0h9KcQMgAbLbfQyE7Z1kgt/f61eBShJlWNchxOoyf2MZqkRyFFcE1ZgmsAQrEM8ybIwZTMfMlwOwL8kVgbFWhSq59vHN6EvEaN63vSiq0PI8lY2/c4rfsHIVf44tXzdb21vMZMELZHojRer3CFbn4aM0Zw4005w0VoVq23FhiED0aTExsWi3BJtVlULwWq2+UIgsMAMQTgTBr3Rhnde73BX8GHFKtZr9McD1L7hUSYPCkQjgaHFs1UMorfKkuZ5ta3+ahGhdqZGWYqWQGClm2rg9IEl8e3RjRKapVsetHgrSEOfNT6CyEO6xPHneCIEcR0Pcb34wGP0atOtGVhUNwRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JC9Ap7mTfh/tlg4tgM/O+wFShCYhIYWi0taSkQBkedQxoQaunlsTLDDuAgHG?=
 =?us-ascii?Q?fJGyaQXdOS3myIR3lvuzyY1jcGRoIzuihBy5/xygLR7xsvD1hZbeeWTbl0+F?=
 =?us-ascii?Q?dmL5lQuRCC3xpv8keeWKlNBkyUPh8vc5zxrE3FfvXoXv927PD7NpaD8/B8p2?=
 =?us-ascii?Q?zMul9baBbvZt4zKPOxqCqSuujAER6u7R+kaaR1FaqUo9fWPrFvCNx1kcLQTZ?=
 =?us-ascii?Q?L7RGr/wMbEB+LsaZboNaLeHFwhf2z28Wl0vuoG3PaMpEQCf9N4bZTmlO8oSs?=
 =?us-ascii?Q?eZGvBrgY70JQI1LZamJSNMbDd4+jElsX350CsuGenoi3Q4dze4obhe0W72KU?=
 =?us-ascii?Q?SRlb37GN9uSrb+IlHL+RL1c/u9OkGf9iKA/F46fQDYDlkHB0GAcV0tA1pZZK?=
 =?us-ascii?Q?8y5lGdk9/DJs8Xwc/0q7WenU6Cl87bFg9Q+9W1XTI9iTa03tVwgBRIVfeIYG?=
 =?us-ascii?Q?vIq5KzFwmgYd2EC+f+m2/uwnoeViOuBRLjMkQtT1FEdOsDX7l8YmheYJ9Q5C?=
 =?us-ascii?Q?Ij+TQqYXg9t7VqAZ5N9BKvZdfwp2doWNzVUSIA3ivn1BnyBQqZE8k8pI5TWe?=
 =?us-ascii?Q?T4X46wtaOL/MGw24fLigrE8xs+tJjYTYNJSJm9X6M2IdMWyKJbdtNxv5pK+5?=
 =?us-ascii?Q?lQeCCl8ktilIpyAb00Y7m/GtfiYO3yJUpejiF0aNBS9FSny19/cbUMkZmXGA?=
 =?us-ascii?Q?NGnFU/5KJq5XXEwOg+h8fivg3qLdKizund0b8nFpPujN94+8FHiGq/yYoibL?=
 =?us-ascii?Q?xJGHRUSrinVD3O3KSSPT2zRWoTVdSOY7M2UTziHfLrTQsVYF7duSCG1iQryV?=
 =?us-ascii?Q?iI9lqVqsBpgvHlCsQm7G0bH2S3BPx7UCj5pZge3/bR2ddlfDNdr3l99DncKF?=
 =?us-ascii?Q?81F/0uTKbC9QKczyY06ypfRwLAA4JA08A7FPIvwkD7tG/v15muePs/hIBLNe?=
 =?us-ascii?Q?AG/+4A2DWHSQMssf+s4vHhBJBu0ntgwjNCXODjhIW1HmpkCPDVGxfEyv7+rP?=
 =?us-ascii?Q?m3G7KytE2EDjJrc4qSKn7Vutbcm9sMn1YD5hSvZJDnwrqGt2BZjREEtrQUo1?=
 =?us-ascii?Q?eWOzxKBArmJr6pNC+iHLMlYrL/xk6lq4eXqhMJ0afzx8kJgkELe8iGCxB+g2?=
 =?us-ascii?Q?N0Sii5wyjbbJrp63xpyVu1U+Rc2DO9HU21dBJdJWFwpGT8UNA5hButppfoBL?=
 =?us-ascii?Q?U6hrLFVd3m4ADU5vLHuOCy89XLDb5nclmOuneg+axEs3pAZPKdyHgASkIhxh?=
 =?us-ascii?Q?eM6myuODbuOvOGsFHPjwGi5ABj3JzHxlQsgJObSIMeQRUJ7YKF4Ijacys2AY?=
 =?us-ascii?Q?FShhmNPso+4UNOjzrcey6GI1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10311aee-1f60-4ec8-85e4-08d90bd4f102
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:05.6171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FuYdWFZsgbfPhLD8rw0zIyVB9/BuN3qSQ5meFYayoyRFfBkiWcDVqk1SFsRIsCEKlSR0Qjri8vv6aZYz09Oiyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The behavior and requirement for the SEV-legacy command is altered when
the SNP firmware is in the INIT state. See SEV-SNP firmware specification
for more details.

When SNP is INIT state, all the SEV-legacy commands that cause the
firmware to write memory must be in the firmware state. The TMR memory
is allocated by the host but updated by the firmware, so, it must be
in the firmware state.  Additionally, the TMR memory must be a 2MB aligned
instead of the 1MB, and the TMR length need to be 2MB instead of 1MB.
The helper __snp_{alloc,free}_firmware_pages() can be used for allocating
and freeing the memory used by the firmware.

While at it, provide API that can be used by others to allocate a page
that can be used by the firmware. The immediate user for this API will
be the KVM driver. The KVM driver to need to allocate a firmware context
page during the guest creation. The context page need to be updated
by the firmware. See the SEV-SNP specification for further details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 130 +++++++++++++++++++++++++++++++----
 include/linux/psp-sev.h      |  11 +++
 2 files changed, 128 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 75ec67ba2b55..fe104d50d83d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -53,6 +53,14 @@ static int psp_timeout;
 #define SEV_ES_TMR_SIZE		(1024 * 1024)
 static void *sev_es_tmr;
 
+/* When SEV-SNP is enabled the TMR need to be 2MB aligned and 2MB size. */
+#define SEV_SNP_ES_TMR_SIZE	(2 * 1024 * 1024)
+
+static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
+
+static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
+static int sev_do_cmd(int cmd, void *data, int *psp_ret);
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -150,6 +158,100 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
+static int snp_reclaim_page(struct page *page, bool locked)
+{
+	struct sev_data_snp_page_reclaim data = {};
+	int ret, err;
+
+	data.paddr = page_to_pfn(page) << PAGE_SHIFT;
+
+	if (locked)
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+	else
+		ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+
+	return ret;
+}
+
+static int snp_set_rmptable_state(unsigned long paddr, int npages,
+				  struct rmpupdate *val, bool locked, bool need_reclaim)
+{
+	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
+	unsigned long pfn_end = pfn + npages;
+	int rc;
+
+	while (pfn < pfn_end) {
+		if (need_reclaim)
+			if (snp_reclaim_page(pfn_to_page(pfn), locked))
+				return -EFAULT;
+
+		rc = rmpupdate(pfn_to_page(pfn), val);
+		if (rc)
+			return rc;
+
+		pfn++;
+	}
+
+	return 0;
+}
+
+static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
+{
+	struct rmpupdate val = {};
+	unsigned long paddr;
+	struct page *page;
+
+	page = alloc_pages(gfp_mask, order);
+	if (!page)
+		return NULL;
+
+	val.assigned = 1;
+	val.immutable = 1;
+	paddr = __pa((unsigned long)page_address(page));
+
+	if (snp_set_rmptable_state(paddr, 1 << order, &val, false, true)) {
+		__free_pages(page, order);
+		return NULL;
+	}
+
+	return page;
+}
+
+void *snp_alloc_firmware_page(gfp_t gfp_mask)
+{
+	struct page *page;
+
+	page = __snp_alloc_firmware_pages(gfp_mask, 0);
+
+	return page ? page_address(page) : NULL;
+}
+EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
+
+static void __snp_free_firmware_pages(struct page *page, int order)
+{
+	struct rmpupdate val = {};
+	unsigned long paddr;
+
+	if (!page)
+		return;
+
+	paddr = __pa((unsigned long)page_address(page));
+
+	if (snp_set_rmptable_state(paddr, 1 << order, &val, false, true))
+		return;
+
+	__free_pages(page, order);
+}
+
+void snp_free_firmware_page(void *addr)
+{
+	if (!addr)
+		return;
+
+	__snp_free_firmware_pages(virt_to_page(addr), 0);
+}
+EXPORT_SYMBOL(snp_free_firmware_page);
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp = psp_master;
@@ -272,7 +374,7 @@ static int __sev_platform_init_locked(int *error)
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
 		data.tmr_address = tmr_pa;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
@@ -623,6 +725,8 @@ static int __sev_snp_init_locked(int *error)
 	sev->snp_inited = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
+
 	return rc;
 }
 
@@ -1141,8 +1245,8 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		/* The TMR area was encrypted, flush it from the cache */
 		wbinvd_on_all_cpus();
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
+
+		__snp_free_firmware_pages(virt_to_page(sev_es_tmr), get_order(sev_es_tmr_size));
 		sev_es_tmr = NULL;
 	}
 
@@ -1192,16 +1296,6 @@ void sev_pci_init(void)
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
-	/* Obtain the TMR memory area for SEV-ES use */
-	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
-	if (tmr_page) {
-		sev_es_tmr = page_address(tmr_page);
-	} else {
-		sev_es_tmr = NULL;
-		dev_warn(sev->dev,
-			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
-	}
-
 	/*
 	 * If boot CPU supports the SNP, then let first attempt to initialize
 	 * the SNP firmware.
@@ -1217,6 +1311,16 @@ void sev_pci_init(void)
 		}
 	}
 
+	/* Obtain the TMR memory area for SEV-ES use */
+	tmr_page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(sev_es_tmr_size));
+	if (tmr_page) {
+		sev_es_tmr = page_address(tmr_page);
+	} else {
+		sev_es_tmr = NULL;
+		dev_warn(sev->dev,
+			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
+	}
+
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
 	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 63ef766cbd7a..b72a74f6a4e9 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -12,6 +12,8 @@
 #ifndef __PSP_SEV_H__
 #define __PSP_SEV_H__
 
+#include <linux/sev.h>
+
 #include <uapi/linux/psp-sev.h>
 
 #ifdef CONFIG_X86
@@ -920,6 +922,8 @@ int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
 
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
+void *snp_alloc_firmware_page(gfp_t mask);
+void snp_free_firmware_page(void *addr);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -961,6 +965,13 @@ static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *erro
 	return -ENODEV;
 }
 
+static inline void *snp_alloc_firmware_page(gfp_t mask)
+{
+	return NULL;
+}
+
+static inline void snp_free_firmware_page(void *addr) { }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.17.1

