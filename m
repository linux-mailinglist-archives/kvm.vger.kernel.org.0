Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868C369D33A
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjBTSuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbjBTSuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:50:22 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C81F1F4A4;
        Mon, 20 Feb 2023 10:49:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ole9GU0zWR3/b+S4gYdeyVkdUo/cMFnNZaILpCDDxbXPNgzNFTjB7CQ72t3pTDmRi+eclw+PLdx2/WOkLfArgjyPjCvXSO9lX2YTTDyVVTdhAC4922aE/Ar68Ypj9eI5Aaqp/S+Zq7DlyyoJzqTzN6y+xAWcJqJmu6kY3hxhscXz2/g2FFCi0xcV60hDBNgt4ArcGhwNlG2w96Ci69LHrOpxsEEXUloEft5HBvxNyrP+4clmXarIrSTbSKk3EPGBggYWqivvu4sNP6TrqA+CfmVCBsx79aZJLLSEe0tq69U4Qp7bXm/3MjeGj7GmkQCb3vNwOjbYM1hh4yVa/6PcrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=seEEnfJ+CbxvtpbqyiuTUKriJBTOcgWKYjy5NAOfINI=;
 b=akJ9eaS11qk3imPQFZ3n2DRgLgrq4BAws1+6NFqSjqhWwzpHl/tw1SLwFFAeQfEWRqdGmGQUPqZEbSyGrwF9arTybMSSpNceKKxWIU7ofZI9vTS/QO2XRseXl9HHgAZDtJQj81rkqxYbukiVxQt9Pb8+wBmbzW06h5f1oQsxIVnGikwiPz7wUpU8BjtU7YZfKg5OshHw2DZSn/iJROtXSGut4HVQ0lTDnvcfXwtKBQxLf98omToj8MX6GBo/vchrH+bJt+o0EGISlgAMSgXkf2FfY04WSuU/ZXwjftn3eHjCVG5tSFj/vca6jzkePcvcLaRlUTZrrll36bohDJ7vIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seEEnfJ+CbxvtpbqyiuTUKriJBTOcgWKYjy5NAOfINI=;
 b=n1NEJiIu9sy4pdj/cbLikX+AtOBHwb345q8eu0MtzHxLrKnr1ct/3hyV0sYKgqhOEshMyLyOmHkw01EEWxvXujTsrbWRkXOql/AnQT8CYaP34xWJm2abcGFDWu33jEWpeRkaR7bwzO9ZWxKLjlU00lw0noaAy7Fl+Q4bqX0035g=
Received: from CY5PR15CA0025.namprd15.prod.outlook.com (2603:10b6:930:14::34)
 by BL1PR12MB5972.namprd12.prod.outlook.com (2603:10b6:208:39b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Mon, 20 Feb
 2023 18:48:47 +0000
Received: from CY4PEPF0000C96B.namprd02.prod.outlook.com
 (2603:10b6:930:14:cafe::4) by CY5PR15CA0025.outlook.office365.com
 (2603:10b6:930:14::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:48:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96B.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:48:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:48:46 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 23/56] crypto: ccp: Introduce snp leaked pages list
Date:   Mon, 20 Feb 2023 12:38:14 -0600
Message-ID: <20230220183847.59159-24-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96B:EE_|BL1PR12MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: f230206c-2aeb-446a-2a31-08db1373199d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: by2b9i7Dx5H1HZZbyroDY7gIQGOuRUiDqZfbmUXkXW4Ohr8JRFbGci/RAF3GQ1mLv0z6IFV6RytZd3Zpm6l2iEZVKMK8Mapx1duFmSa7jAfijfAuTrFk4iNgmYmWjuCPjmey3H+yfXSbVx0s/WnBoS5qjFS1/qLC1b5SbY+hv3qODW6XQkVuhBBO8TNAHrtuWnciTlR7VgLpYJDeOdVyGIu+WC/JNSN0y2AwK5OwoqP3DBXr3vv6T/B2nyfTnehJmcAXfcjlFa8jZUjEmLJwfunS1hjw9cMdACDGqRRLozCC9VfYJt2UJ32sjc6upCrBRbgu1t4cZx3zp2VHFANuKUMJ4Fqxsut648NuCRaAlIzpE0e2kgzzBDEakbdxZDHKIfTtzlGJJWz7by2kb/SE2ZzZVGB7OevVlxgIiOzdtO6K7Ps20UX7KxeAZCuNciv6m7w1OJIDudtUmoB/1SUYhQsY97A45hqDqQlkt5/IZrUBhRVvFkN77al8igmU1XIdXKpJbL7ZrxKpIyeG4IN3mzQe0eFnZ1aen4M2756m4f7cjI/5T9AwmJbsu8biP9SlTaAx7IOVp28gSJ5/FTaEwdPMAWsTAellO/g8jR/Z0hGYyoWuGEckEqixosR9huzNo5DnxuTkqhb8LHCsw3tc5npAxgWHhH8QbyR6poNggYR4Msn7SMJ5Q8osOVb4I0Sk3MS+qkZBoOXBhD5WcFyVd+CmO7VyjbhCgbA2r1BRoqg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199018)(46966006)(36840700001)(40470700004)(54906003)(316002)(82740400003)(40460700003)(41300700001)(16526019)(478600001)(8676002)(70206006)(186003)(26005)(1076003)(4326008)(356005)(70586007)(82310400005)(6916009)(8936002)(6666004)(81166007)(44832011)(7416002)(7406005)(5660300002)(47076005)(2906002)(336012)(86362001)(36756003)(2616005)(40480700001)(426003)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:48:47.4016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f230206c-2aeb-446a-2a31-08db1373199d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5972
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

