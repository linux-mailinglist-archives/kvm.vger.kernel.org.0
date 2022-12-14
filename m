Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AF964D074
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiLNT52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiLNT4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:56:46 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968E82CCB9;
        Wed, 14 Dec 2022 11:53:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFLsjPqMaAEfNX2KlAaIkyj9ysofX8OSCR35KqCsUVS/wcO9M6E1/tcanvFaaT4OiWUNwN9hFRyuQ4srsEwrJCEhKxF7aAEL3SDSjTwIIJ/SOv2U1t1ju7az1d8zEp3eGW6fAToet25kIUX3JS1FjGFU+UP9gHoKX98K2xCy136kAPVdvLkVx0iJR838NhKtiu/ur816vrgWpN0zudFBWw1Q+wOx7XvNIYMrUE1CdoAAlBWOeB9ugO6m/yGgI8PfN7v/2IqHzmsBRQi3YtInz3v4yHX5Cec41CHh1w3XN3YG+ykjJbq4m5F/mJ5UgNInjADkFODQu7NxHPCLaK6Aww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=seEEnfJ+CbxvtpbqyiuTUKriJBTOcgWKYjy5NAOfINI=;
 b=h7x0osrR+X9DLSmjDZ21oJAtHHPAm9TvXoNeKV0hDSsR29SKWLdb1Igv1y9apv/vVeAS3m8/xEh5G8IIMzL+oaZ8mfGta2sZqyXQcjf0Wmt8/WUJMv31WxNVcoHhB6Gk3IQ60RtgOVMpdjCkBftNKXOdO5U07vz2O5Hc6eja1Zu7+37mvobeghsEA3j3FFdJ58YlPBr8+S3p7pI7RdfCr6FWcyL1Tu68C95NrAidja36i8bLZgWRu5boKduh7G0HUsErF1Cgo1ukuv4c06ogwuMPHNilFO2ZBSZVGlW/nzWC7mTrB02wMyDGwZedft9oRqMGYWeL+bbqVCvUe3fyeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seEEnfJ+CbxvtpbqyiuTUKriJBTOcgWKYjy5NAOfINI=;
 b=i3U1dAUjYpBMm9E4gVveUWzivtUSkuXPOqbpZB3Jq0zU2EDEM2T5D68EAuaSNokbckinZAaZw5jqHX0m7/JM3SHt5LkspBrIoPFKTggv9bW17Uc1Kfg+EHpiE0FbgKzDJKJ/JfSBCdl7G6+YGmdqxVQtx4fHFpGjEU/cFYXor3g=
Received: from MW4PR04CA0298.namprd04.prod.outlook.com (2603:10b6:303:89::33)
 by PH0PR12MB5498.namprd12.prod.outlook.com (2603:10b6:510:d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:53:45 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::6a) by MW4PR04CA0298.outlook.office365.com
 (2603:10b6:303:89::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:53:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:53:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:53:43 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 27/64] crypto: ccp: Introduce snp leaked pages list
Date:   Wed, 14 Dec 2022 13:40:19 -0600
Message-ID: <20221214194056.161492-28-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|PH0PR12MB5498:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ceaea20-884d-4181-ee7a-08dade0ce8b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gP9aD4ws7DSQm6KeWTkzAanosuEgd6BdgytIwVYwYp3wxqBDsNio9LIBEPfsMU2gBh9hUtrxePLTtcKHyMZL+eELz7gyfcJO1+TlMz0PMLjQ+ER9f/gZJNpel1jG77pwQ7Jno9mMRO/3QRbSbJUbUV4GjVJPnNzp7jx3EsNrF75tVPLiNWc9PZ5/yuoYPZ4w+5310sd2TWj9PJJtWyGXP05NorN4tz8PHhg38SFYEatO9aRda/krhJe/2tBIiTDN0Ungjan+AbJCUmFi7z+mS/SsiaNLVglu6sb3JuIFSEDdK7FPQJ7lN23efLWYqkzNICdgHjUUQkW9VAWLFTC4TuxopNdsvDXCsybrtrlWbqHV5rF74T4Fq17a+flpgJmqx6ZRgzL1wFUMH89e1kceftOCQ55Mho5HWKZpZyh7xDNj+KqtAhx48SkXB7TyS3Kw7oOa5ltAb0+xgc8eQPXvvJKKsQt656rqPbJv+Y57dyuC8m2FS9LMFh349hhyGaBZpljtzx84hmmbCA9vOnY43Myz+Arj++achJUyGSOUHmW2BDMUObIuXK8LRTMm57SttITu2L6bN9kNr6Ck4M79NWfceyOFDaLCxXCyheCaUjq0ofYfNJ3H2odYkbXTNsb+6E4uyhQ7FtFfkhj2yW6JbtOxg+nc80wItuX300DuWXfKGGssWtOO+KCzIMurnTM3Wo49+1jRmu91RJB/YBhONRxql5ChJYOV7IdS04ugvaY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(70586007)(36756003)(16526019)(40480700001)(8676002)(426003)(4326008)(336012)(47076005)(70206006)(1076003)(7406005)(54906003)(6916009)(316002)(2616005)(86362001)(7416002)(5660300002)(2906002)(44832011)(82740400003)(41300700001)(356005)(40460700003)(8936002)(81166007)(83380400001)(6666004)(478600001)(186003)(26005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:53:44.9642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ceaea20-884d-4181-ee7a-08dade0ce8b2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5498
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Pages are unsafe to be released back to the page-allocator, if they
have been transitioned to firmware/guest state and can't be reclaimed
or transitioned back to hypervisor/shared state. In this case add
them to an internal leaked pages list to ensure that they are not freed
or touched/accessed to cause fatal page faults.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 28 ++++++++++++++++++++++++++++
 include/linux/psp-sev.h      |  8 ++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 35f605936f1b..eca4e59b0f44 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -42,6 +42,12 @@
 static DEFINE_MUTEX(sev_cmd_mutex);
 static struct sev_misc_dev *misc_dev;
 
+/* list of pages which are leaked and cannot be reclaimed */
+static LIST_HEAD(snp_leaked_pages_list);
+static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
+
+static atomic_long_t snp_nr_leaked_pages = ATOMIC_LONG_INIT(0);
+
 static int psp_cmd_timeout = 100;
 module_param(psp_cmd_timeout, int, 0644);
 MODULE_PARM_DESC(psp_cmd_timeout, " default timeout value, in seconds, for PSP commands");
@@ -188,6 +194,28 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
+void snp_mark_pages_offline(unsigned long pfn, unsigned int npages)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	WARN(1, "psc failed, pfn 0x%lx pages %d (marked offline)\n", pfn, npages);
+
+	spin_lock(&snp_leaked_pages_list_lock);
+	while (npages--) {
+		/*
+		 * Reuse the page's buddy list for chaining into the leaked
+		 * pages list. This page should not be on a free list currently
+		 * and is also unsafe to be added to a free list.
+		 */
+		list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
+		sev_dump_rmpentry(pfn);
+		pfn++;
+	}
+	spin_unlock(&snp_leaked_pages_list_lock);
+	atomic_long_inc(&snp_nr_leaked_pages);
+}
+EXPORT_SYMBOL_GPL(snp_mark_pages_offline);
+
 static void *sev_fw_alloc(unsigned long len)
 {
 	struct page *page;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 46f61e3ae33b..8edf5c548fbf 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -923,6 +923,12 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 
+/**
+ * sev_mark_pages_offline - insert non-reclaimed firmware/guest pages
+ * into a leaked pages list.
+ */
+void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
+
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
 static inline int
@@ -951,6 +957,8 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
+void snp_mark_pages_offline(unsigned long pfn, unsigned int npages) {}
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.25.1

