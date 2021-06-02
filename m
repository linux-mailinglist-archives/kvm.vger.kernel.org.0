Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9FE398C3E
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFBOQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:16:26 -0400
Received: from mail-dm3nam07on2058.outbound.protection.outlook.com ([40.107.95.58]:6980
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230031AbhFBOOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9HbEJwFF8DwElwcAq0dM8mQCrIOp0iGFvYm3MlLTgWmlP7wJXduTmzeuct1ogL0vH4C802dG6s05zvjIMSCoD/NYFBxcFsGtKSbTg7+nZvZzr5nkr1QFwbI2ViAyFqZD9Dym2XpIQqrOFY3wEMSo68iVyDMWpj6M+so1ejbTsUJ2jRe5FzAsIWwURPS+Ot6jkiUA8Ek3zDjzlOphAjEe7A4rbvd367ZkJSeuxwbuy2u4dmWvQ48tio1LHfpPDAWHdLfYTER4PcQqm26UNNiBCYafa6+0+I5EbTgcg/2jz6IG4Qnx/imiPurFNtlXj2hnIXhMLDukF/Jf+Xqxb2ByA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOlQ2aCoAvg7b5HxXGUyXDe7t2qSxR8TcFCpfqVN4UI=;
 b=S6oL2SuU0sB2uMlPZO3g1/6E89O2NXZlzvEqT/2VroH/YFXRxugJ5qiWHVherDBVZtj1pacbMCP69V0uz/VhcgbJSf21x9ZW5nGfw8Bq1usBJW8QwRScgJX3MOBaqbOXdCDPolq/XdCGzRbat1XayZoKdOL1ATIXPG83Zl7He3Aod/Tax4qtKHj9bWeP8BIrkH3PpfwzRKhJCoNQUUjua9HWdyCK3eSoxPi/2c4YWt+qFPCRToda8xTTJcxgNd5PrMUxhki42NnCk37vLJdtMbUCXNvbvpkj12b1vKk2VtU990+nCsrWyf2VOZxan07lqMNQEm1j8TZPO229/xpX7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOlQ2aCoAvg7b5HxXGUyXDe7t2qSxR8TcFCpfqVN4UI=;
 b=Tca6a5YZQ/zGz9QQNMeJnHB1ZKx0aKN8POWLXfarhldOkNNf7ZYu6vTrqAbaCl7ITTA5b0M1loVOPhDcGrxEgBPOU3QkWNYdi7NxvpLbt/TusKeAD+tcOILrZP25rABYwJUlY23SSrp6iV+wc4UK9dZMc1oWgoAYMA3v9he+11I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:47 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:47 +0000
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
Subject: [PATCH Part2 RFC v3 15/37] crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
Date:   Wed,  2 Jun 2021 09:10:35 -0500
Message-Id: <20210602141057.27107-16-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 151b1f33-4e24-4cfe-77b9-08d925d05b4a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495294B660939A57A31B64BE53D9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lx8WJvuuPwyatsYg0v2aLfUvDN+u/Krc90HGMTaLEFbDNrgDlzLPMuaAhd+RFdC8QwGPeS/pB+dIYm8AjADNyDlP3E7X4hj5Oo/YkBmDbTBtGjVxEur6J/kuO4TSne1o6HrTt9zffFylfPG/OB744p4AueecqliE6lODlSea8/o5wugBXXUNX/Mf0vD0M3wzbwqIM2uqF+vEj5FJgMoWG2eWUVysfaC29MtrFF5B6fxHKlXrCtZHo/jnYMsPjIUglQ5ke6MaK3p2Hym0oR2vLemcLk4sh1mwuREHDxfxrolgxGJkffiaKXwCCYYXoR3pd3PZL8swuVeVtAOUgV2UjqYvhs0b4nZHT160SZEh/fFGSzHyU38XuBjdRZcIETKJ9cT6NfhcZFmKfHxMRCMR+rX57HNRfOpPKgtJiwS9fkIdb1uTVtAGGuJDJwFwoNQ71Yoclz79q6ulu6D1kEnJRwTdaE5uy6tMRdtB6H/tSVnnv8TkY97+uT3tTm2vlgQJM4ZZcfrlb+cDtiKjVsqlmliQ2mmgpF9Qj7ml/hIgqm0/MLf/NSVKgMjza5dlzJPLsLQ8lTvvVw3FHhV9yksl48eVJOi5bIGwGo3SB4kPikH0TBkq/XalY5WcLBPvzPdgeUdHtk7etQ6XO2H9oZpnDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(54906003)(44832011)(8676002)(2616005)(956004)(478600001)(6486002)(316002)(86362001)(4326008)(7416002)(6666004)(38100700002)(7696005)(38350700002)(52116002)(16526019)(26005)(186003)(2906002)(5660300002)(66946007)(8936002)(83380400001)(36756003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Pxy3rbvJzGkgF2Tv0M0axEYe/6JZbRQSUTQJSsenhsEIzV+KoK/aaD91wF/B?=
 =?us-ascii?Q?p7xEv2CgO3tjAde2w6J0xAM09tEBLyBf3JUBEjk+SOGBkBl76kWYoHBXgkN8?=
 =?us-ascii?Q?Qz+o2xxQbSfCa1BhmkO/KXCoK1IxvC0xY4QUTvKiN/xgVZqbQTPxY+eMAxYl?=
 =?us-ascii?Q?avn3IHTXkZUAdwC5HMfw7woxGG4k5pBaIjlyz75VF5G23TXXBic9YK09dMkU?=
 =?us-ascii?Q?Te+UOsNYoRjozlhZiHmcOxLpHwXyCH08jmaacO8lcHQOqrMlTnnq//No4ea2?=
 =?us-ascii?Q?3e5PYnEy8YG2TmmlHqIoruat6VoOWzx8l0MvOdZQyqb1BO5KP6j+6k0+pUv/?=
 =?us-ascii?Q?ZQagUUJFt8YI652lGMSOQGuO/IMiLL2KRxLRsFiylHbvT1sM1RL4JLuYJ72r?=
 =?us-ascii?Q?6hX6Zz8nkWmWL7HckYWlC2Ri+QoFz/ggbBu4YjZzG8GinzY1BJxaLE2SgDzy?=
 =?us-ascii?Q?jHsX7B5UllvquDTLUoZO0a0Z24sQG0QkGm2sw/gHLtraNTrNCcLJ4D7eTlkz?=
 =?us-ascii?Q?14LBkA7YT/EGNA6HRin+RH4DmD1qC4fMhzX+g6SaztzxC+prwefJpQh+l9p6?=
 =?us-ascii?Q?4wbNnjcawl4PqQGuIIjNPFvFnoJMvGyY4ZG9xJeiIoATl5hujiqsUWX+6g7c?=
 =?us-ascii?Q?Foum7yXs8wwKVSK8EysVrBjEvJjWhxc9W4uWNJSK5ksZ5yEGjkm5Lqdglig/?=
 =?us-ascii?Q?KuJHWb1IOfnB9jiQZNeuFek9MXwm3NRhdSsYNHcxCYG40izlC4cNRJYsEbM2?=
 =?us-ascii?Q?8e9r+6GDt4do3EtrBu5DkWmCdg8Wt1MdYNO/a/WTNOMO1NtTnXJxHc4Q/Men?=
 =?us-ascii?Q?+KsRPTgCODWrOg8M6HtxSogqKjIs1Hc0vcxJyXcbtGzs5Ch6cR+XfwyMaRJ9?=
 =?us-ascii?Q?Zuz6AJqtbLUmAhRMSR3T0d7ewURtupldIyaRLvcRqlul2N9qUonk6eIVWrE5?=
 =?us-ascii?Q?Hqyn62Bvo+rEHDnUYJ3fXWHi0A8gXEgwfwmp5+/mrPLedClRMryA/sIro9It?=
 =?us-ascii?Q?00q0LDYzSehxVBfnKVe+SrSxftlaEhagHeFwQZp1DfYaDVw72hsRjBuQxE+q?=
 =?us-ascii?Q?H/qRk3Sjve+kfn3lsgT5xsTHo3NTZYKntKKykR+s4+BZMZRWK4OMzTS4B8+O?=
 =?us-ascii?Q?vs5p1PM9pKtQRPZs/C9Gk0eZ0RbhuX9xyrZ59yLZWVgeT701jgPMNEGQRxqK?=
 =?us-ascii?Q?jhx/rYmWeQRX/midPEY+2NX+7PHtwqHrQbZo0DAnkRiXVzpajR0fnH82/+Ee?=
 =?us-ascii?Q?pYIX+rNIW1xarYIOYRCUzs7jdw76paG2Kf/SBgwmZuQCEjfzSCjPs3kQv8iJ?=
 =?us-ascii?Q?2EQdtgmFA0gDqB4ud/Rpmxap?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 151b1f33-4e24-4cfe-77b9-08d925d05b4a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:46.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7rOshOIz0W37jhJfeifaYPjIGnOAnXxuZHHdm3sbYX5mOnIki97ut2pEJOph3gHjCuPMYdo0jmTMxqX6tzZGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
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
 drivers/crypto/ccp/sev-dev.c | 142 +++++++++++++++++++++++++++++++----
 include/linux/psp-sev.h      |  11 +++
 2 files changed, 140 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index def2996111db..cbf77cbf1887 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -54,6 +54,14 @@ static int psp_timeout;
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
@@ -151,6 +159,112 @@ static int sev_cmd_buffer_len(int cmd)
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
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+	int rc;
+
+	if (!psp || !psp->sev_data)
+		return 0;
+
+	/* If SEV-SNP is initialized then add the page in RMP table. */
+	sev = psp->sev_data;
+	if (!sev->snp_inited)
+		return 0;
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
+		pr_warn("Failed to set page state (leaking it)\n");
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
+	if (snp_set_rmptable_state(paddr, 1 << order, &val, false, true)) {
+		pr_warn("Failed to set page state (leaking it)\n");
+		return;
+	}
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
@@ -273,7 +387,7 @@ static int __sev_platform_init_locked(int *error)
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
 		data.tmr_address = tmr_pa;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
@@ -627,6 +741,8 @@ static int __sev_snp_init_locked(int *error)
 	sev->snp_inited = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
+
 	return rc;
 }
 
@@ -1150,8 +1266,8 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		/* The TMR area was encrypted, flush it from the cache */
 		wbinvd_on_all_cpus();
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
+
+		__snp_free_firmware_pages(virt_to_page(sev_es_tmr), get_order(sev_es_tmr_size));
 		sev_es_tmr = NULL;
 	}
 
@@ -1201,16 +1317,6 @@ void sev_pci_init(void)
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
@@ -1226,6 +1332,16 @@ void sev_pci_init(void)
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

