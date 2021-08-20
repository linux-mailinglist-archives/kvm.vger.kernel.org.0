Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA5F3F3086
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbhHTQBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:17 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:58929
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241308AbhHTQAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:00:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYcGzeqcU44SexcCi/wDxIfzbGDyE9XTxbvp1l76+g9u0DwJIJPpP1J0XZZk+tWxlhNCjXYZadjv0t+ZzCXl7JCXOW4O00Hjr/aWIJgTD17C82RUwqKCUC6+X7Swspb3s9JZhqIXcsi1y01TlCDz9/Bks8s0qflGu196XhF8tXFek6dl4G21RNHCktZ8s8H42OHtW5Jcead+MgbcY1uIZAqBnZz2eLIqfiG9SVtC8kXVzOtmWK1LVwhU1aQKgC8C/iXcsMLlFbOIw2JUQDVPNdVUKfF+rgehWT7fWNbNRqVltm/t/B+XU5mlV9Neq/xT2CpsFuaWGBriw3iZIl7kHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxM8REmDVI1BmWY/+ZQiY0oAx762oxcfQUDoGBZr1pg=;
 b=hGBSdLlUJ9hAojQ0CuB6Fv7F/0qr5KrXDiT5qtlsCvbeWL7Dj1IUw8oyULBEZTdefSVDdGM0VRlUiyhf54q1+Naz+dshwYZyvl+Va/jsODkncsVA7YxoVMJQKofDll/xXh6OSbBVRQGIozgJHB5h8NmVEuRJfGCLu1j21Cf+a7wS/JwylPIGsLpo0F8aDmNVAeU7hDwIukBbICE+Fg2hjeZsJeNsYUQozfo/vVow23p81mCHlX0SlTUXkXyVt6xchtJ7wmYq2B3azjbJaWfTFEvdSWM6e5tx26K8/giqq3wZRDZipTLzP6aFj3iiQ6Fr09gxfI7cPYzG+KBlKi1k1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxM8REmDVI1BmWY/+ZQiY0oAx762oxcfQUDoGBZr1pg=;
 b=gGRn7NpKVYmQrCubCdVm+gJfpo7NmCCoCo+WzGg4AJ54mN1jLIKyqxMNe2PvZ9NQ4xZ0qDn5PZlPpCJkism6qsu/EhfEvZOq5CV2an9brGusJPM2465U54r2AAP9pqX7UFRNp6yAbiYmgqLsASjqxJls2GWAV7gBU8Iz5NZOrpY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:11 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:11 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 14/45] crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
Date:   Fri, 20 Aug 2021 10:58:47 -0500
Message-Id: <20210820155918.7518-15-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65c05a95-cc38-442d-7488-08d963f39740
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45741CE97B0673C61EDD79CBE5C19@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PDMPstfEGxkp/hmSKcouzB1Fj12KWxc/HK229AIwJv2WvgiIMi7+7+XlOatR6dwTCjc+hv5jwn3prZ4Y+9huE8JKeo3agz85Ht/Q3pkOupm12s0BM0baImuGvr8xIHVTX0aRVYgg0kSE1F4+252/mBxOXv8bU2QkWavmexiVatjLzlQwMpOMrHL9vvF63RckRf5tRqQ7Jq/WdNZw5rRX3L9s8m1HxRQm9jnn8208a9A3XTLz6A8stL2hBOEbIQ7oTgb361AtiWy6rtMI6/r3fBMQnT2sCyk0U5tpbdjLb1fuONm1FqD2esrIdJEb3/peJgdPmEr0G9KHMKAj4gt2elVaBLDKdcZceB9gGsW2/5rZWYMURn4FrVSWcLj5+ERUJi/WlfYf1U5S0+SEPMXb6TB1UYE38GPx8xeKViYP7lg1VNgpK9dt0xeJYohglSd+cL205bI8NgQxzMNCfrGdbpiQqRjynJBm9hsfHNtm6uY+6G3JTyGYVnNG4kjqf5POn+iWlvw8VcwQNwEgNAIz/FRCpbO4uFo8RcD9WEqGzOXozQs5PlO1p1c6egTA95cWgFgyDC1+3hKAKdJexPoeo3X+gS3M+L497efLs7FbnEDrscbWKkhuvaVWcVozJwr29h4gJ8jUZNqE9pmNp3mqVW1vSjCltYnVALkOdonxNQJXzOWfsN8wek/YbHs/hXtyRu9AnkK6JnubvqQLXW3OwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(38100700002)(316002)(38350700002)(5660300002)(26005)(44832011)(4326008)(66556008)(54906003)(7416002)(7406005)(8676002)(66476007)(86362001)(66946007)(6666004)(2616005)(956004)(8936002)(2906002)(36756003)(83380400001)(478600001)(6486002)(7696005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wg6w0FtZSkYdcjSvKupmQOA/19aQ4P+WP0gAfMa5PkeSE7IDJ7wBRlhQglaE?=
 =?us-ascii?Q?nZMI1Nova9W3VRSg6G7J3bg2IHJW0JmTxERU1okNU6i+2SsZifjjXVqySU/H?=
 =?us-ascii?Q?4JdEPk/SpThJwugcf2cwpXYuX1lyhoF/EwwkpwxndjEdPo9br1p00P3ctuI8?=
 =?us-ascii?Q?kvWJNlpYyCCFzCUgE495D4BW9fjrnC97IF0RCYB9IlpA8tdemQqPRFYT7z2n?=
 =?us-ascii?Q?rdS+7lomjxGnfHi6T7X0ET8f0s+88jDSG+bZqKXN4nYoO9/ukRbz9w5hBxxt?=
 =?us-ascii?Q?q36k3Ws9IWkYZLVvF+f/tn9OcEVxDBbPROXiInL5wCFDnXm8F27YfEcBUXvQ?=
 =?us-ascii?Q?QU5UJdyjr6fVHrQiLYwgzzNmoYvOOq+yPc5b/T/5FFNPbmZFxzqAt3BrWo7p?=
 =?us-ascii?Q?GCxTaNQZrIy5cYRAdj+M2PevF3o7SKeJrzD75jOAL43fisv3CafDpYbJsyUJ?=
 =?us-ascii?Q?GBONcTNnfQyQpzRF+HOgiwrNzHYxWPALMnl3HIDQUhcADdFEsBClQHdc25hf?=
 =?us-ascii?Q?MOt/SpRa1THq+D4Lwe90X7XYLMKReZXcPTQuw0cHUv6vdls5PzEh4HwjJEvG?=
 =?us-ascii?Q?JhqOB870sRkezCtEnAc1ZxeTPRnoOFlbzz09Y+joe6aZQOK03drgP5u6tnDR?=
 =?us-ascii?Q?JjbFOLb9/OP1E76nJNCjzK/lWb5QJvAI5hCoB8ELkhPBXZ6qlSmeucSwtDS2?=
 =?us-ascii?Q?A67gpYrYw+ey1uPI6oIuJ6it3MJEQGZDJTZE2SRk9z9exh7IAQGknGKBve0w?=
 =?us-ascii?Q?V44kphRSV4YmnSZe+I5Vope/1tbl8Xga8O8sXiu5WuAPHI3QMglLLpfZyfUn?=
 =?us-ascii?Q?DnLg/cuHW1lBIJs4FD8ebhDa3ZWJeNGfYJAN8GdyOc0zQh5TlAtIhwQGYxI+?=
 =?us-ascii?Q?bPC9xb5stxi74UhRb9MrJc6LD6HnbAAIr9euBSKxb1rkudkEotbXWKuINVDz?=
 =?us-ascii?Q?YfqL2F1v9Lp4rvEtN8ykVzmIZCjmmLgdkxURhXKyIXXxs/4eBR8gDg3RNYek?=
 =?us-ascii?Q?DeJSmSW+FXI6rXgAWGYRgp2EC4oKIuojVrbH9rGmg5g3kY26iXNOrXolgR6Q?=
 =?us-ascii?Q?3aqYc1ALFamkVamZqvgDhHSRlC3Ij3RD28UMO2Csi3sXCazQBBVM8HCBDysI?=
 =?us-ascii?Q?ShtzGHX9RaZXga0pxFMBCIvmT6ggYG2lprdst1SeoP3f4A2cR+j7OMVmlGxG?=
 =?us-ascii?Q?ab68WLPMECmnBPQYgZNJW0NarssV22GgNf2r5H9Co2pLdlEUP997FH96SDsa?=
 =?us-ascii?Q?Efc+ClEty7iwHmWRP2ppWU8A7XPhxh0MtkL+MJBtxDgmcJJyXSXLy4fcEH9n?=
 =?us-ascii?Q?Ks8bpr310yvyTMcH5gO/RPd1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c05a95-cc38-442d-7488-08d963f39740
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:11.7571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MnbwHWsGmRUzQ8Yzr/hqOnnU9TS3xXCVYA+0d5t9k3G4QYAIO7JdZajdZlwfe81VCzen/PkXhRHAsPXbYV1P1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The behavior and requirement for the SEV-legacy command is altered when
the SNP firmware is in the INIT state. See SEV-SNP firmware specification
for more details.

Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
when SNP is enabled to satify new requirements for the SNP. Continue
allocating a 1mb region for !SNP configuration.

While at it, provide API that can be used by others to allocate a page
that can be used by the firmware. The immediate user for this API will
be the KVM driver. The KVM driver to need to allocate a firmware context
page during the guest creation. The context page need to be updated
by the firmware. See the SEV-SNP specification for further details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 169 ++++++++++++++++++++++++++++++++++-
 include/linux/psp-sev.h      |  11 +++
 2 files changed, 176 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 01edad9116f2..34dc358b13b9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -62,6 +62,14 @@ static int psp_timeout;
 #define SEV_ES_TMR_SIZE		(1024 * 1024)
 static void *sev_es_tmr;
 
+/* When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB size. */
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
@@ -159,6 +167,156 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
+static void snp_leak_pages(unsigned long pfn, unsigned int npages)
+{
+	WARN(1, "psc failed, pfn 0x%lx pages %d (leaking)\n", pfn, npages);
+	while (npages--) {
+		memory_failure(pfn, 0);
+		dump_rmpentry(pfn);
+		pfn++;
+	}
+}
+
+static int snp_reclaim_pages(unsigned long pfn, unsigned int npages, bool locked)
+{
+	struct sev_data_snp_page_reclaim data;
+	int ret, err, i, n = 0;
+
+	for (i = 0; i < npages; i++) {
+		memset(&data, 0, sizeof(data));
+		data.paddr = pfn << PAGE_SHIFT;
+
+		if (locked)
+			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+		else
+			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+		if (ret)
+			goto cleanup;
+
+		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
+		if (ret)
+			goto cleanup;
+
+		pfn++;
+		n++;
+	}
+
+	return 0;
+
+cleanup:
+	/*
+	 * If failed to reclaim the page then page is no longer safe to
+	 * be released, leak it.
+	 */
+	snp_leak_pages(pfn, npages - n);
+	return ret;
+}
+
+static inline int rmp_make_firmware(unsigned long pfn, int level)
+{
+	return rmp_make_private(pfn, 0, level, 0, true);
+}
+
+static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, bool to_fw, bool locked,
+			     bool need_reclaim)
+{
+	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT; /* Cbit maybe set in the paddr */
+	int rc, n = 0, i;
+
+	for (i = 0; i < npages; i++) {
+		if (to_fw)
+			rc = rmp_make_firmware(pfn, PG_LEVEL_4K);
+		else
+			rc = need_reclaim ? snp_reclaim_pages(pfn, 1, locked) :
+					    rmp_make_shared(pfn, PG_LEVEL_4K);
+		if (rc)
+			goto cleanup;
+
+		pfn++;
+		n++;
+	}
+
+	return 0;
+
+cleanup:
+	/* Try unrolling the firmware state changes */
+	if (to_fw) {
+		/*
+		 * Reclaim the pages which were already changed to the
+		 * firmware state.
+		 */
+		snp_reclaim_pages(paddr >> PAGE_SHIFT, n, locked);
+
+		return rc;
+	}
+
+	/*
+	 * If failed to change the page state to shared, then its not safe
+	 * to release the page back to the system, leak it.
+	 */
+	snp_leak_pages(pfn, npages - n);
+
+	return rc;
+}
+
+static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
+{
+	unsigned long npages = 1ul << order, paddr;
+	struct sev_device *sev;
+	struct page *page;
+
+	if (!psp_master || !psp_master->sev_data)
+		return ERR_PTR(-EINVAL);
+
+	page = alloc_pages(gfp_mask, order);
+	if (!page)
+		return NULL;
+
+	/* If SEV-SNP is initialized then add the page in RMP table. */
+	sev = psp_master->sev_data;
+	if (!sev->snp_inited)
+		return page;
+
+	paddr = __pa((unsigned long)page_address(page));
+	if (snp_set_rmp_state(paddr, npages, true, locked, false))
+		return NULL;
+
+	return page;
+}
+
+void *snp_alloc_firmware_page(gfp_t gfp_mask)
+{
+	struct page *page;
+
+	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
+
+	return page ? page_address(page) : NULL;
+}
+EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
+
+static void __snp_free_firmware_pages(struct page *page, int order, bool locked)
+{
+	unsigned long paddr, npages = 1ul << order;
+
+	if (!page)
+		return;
+
+	paddr = __pa((unsigned long)page_address(page));
+	if (snp_set_rmp_state(paddr, npages, false, locked, true))
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
+	__snp_free_firmware_pages(virt_to_page(addr), 0, false);
+}
+EXPORT_SYMBOL(snp_free_firmware_page);
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp = psp_master;
@@ -281,7 +439,7 @@ static int __sev_platform_init_locked(int *error)
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
 		data.tmr_address = tmr_pa;
-		data.tmr_len = SEV_ES_TMR_SIZE;
+		data.tmr_len = sev_es_tmr_size;
 	}
 
 	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
@@ -638,6 +796,8 @@ static int __sev_snp_init_locked(int *error)
 	sev->snp_inited = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
+
 	return rc;
 }
 
@@ -1161,8 +1321,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		/* The TMR area was encrypted, flush it from the cache */
 		wbinvd_on_all_cpus();
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
+		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
+					  get_order(sev_es_tmr_size),
+					  false);
 		sev_es_tmr = NULL;
 	}
 
@@ -1233,7 +1394,7 @@ void sev_pci_init(void)
 	}
 
 	/* Obtain the TMR memory area for SEV-ES use */
-	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
+	tmr_page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(sev_es_tmr_size), false);
 	if (tmr_page) {
 		sev_es_tmr = page_address(tmr_page);
 	} else {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index f2105a8755f9..00bd684dc094 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -12,6 +12,8 @@
 #ifndef __PSP_SEV_H__
 #define __PSP_SEV_H__
 
+#include <linux/sev.h>
+
 #include <uapi/linux/psp-sev.h>
 
 #ifdef CONFIG_X86
@@ -919,6 +921,8 @@ int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
 int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
+void *snp_alloc_firmware_page(gfp_t mask);
+void snp_free_firmware_page(void *addr);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -960,6 +964,13 @@ static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *erro
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

