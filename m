Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AE53F30A8
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbhHTQCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:02:36 -0400
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:53792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233795AbhHTQBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbdQw+gcVbpacfCFut6S7TwBXREGtyTP4T0b+4RhNYh4YuJA6GYUTDT+Oi4aH9MYnFts9HFQVJJpkNiKjoGMShTZD6xTptdcg/zArYgmun78nH9hzLBZtpbZ4LuSx1aSaHvDz2jJsvYQDrf2CPUNcDs52WTg3JqaQHFkkKnz7B1M1JQECD9CxvFKaUHIXqvzndcp+oMy+X8VqmkgXBfYKL+EGgm6pNv59f4rUM7lin2OR5yqQijIbzIHM1XQr0E8iABc9o9SiR+1ySfV96cQTRsFfm37lngPtzsH8q81RO1y5flrW9sSqhnWxXjlkza13j+HNoz4GzaPzCyxJS8hpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5Hu5DkJ7LdKmBWY1fO8ipCCK/p6x+o4WD5oR1GhaHc=;
 b=HK/4kGXbrpluRyCbPyqSvDW8vLDO9kkuNJQUoUrnGh8izuntPSxiwdIoB7gDsCWKyFeGQ1QfvzN5g28D/mFbJJ4crPJO1CT9w7PFTH85FycPlW14WgMqaEK3yxznbdHPa0wKVtYvbjsDsUhP9HpYkuofFwiVUAvBJjvutuW+nw/P4vHjZJ03651tRpbBJdhpT/epDMSsk1vQR9zHaBiCIni65/Hbyogr8LeEyVK/1atB1Ve1L1sSIzCi2vMMu9p4wopYr9eYdlurrZ0/HGByOYJBnLCkG1peD47HNvgOFjtGIIxkIV4KYicBr0XYJ3ZAntN3d7gYVhD/udeQmSAZUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5Hu5DkJ7LdKmBWY1fO8ipCCK/p6x+o4WD5oR1GhaHc=;
 b=bKO4LLYuufMpgiiPmvE8jmbEZN5tpzDJpeiLEdCjvd3+mrsA8oPVVu6NqsGheCwpS+pfOprBmUBxH6Ep2wArOCZKZ2wtahrlK0IcTIUuQnm3qgW6t8E/KO9VYifKoY6PYz0KJTlXZyRh3tWRRT5urTA8WQUB7JQTROAttyTMGaU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:17 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:17 +0000
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
Subject: [PATCH Part2 v5 18/45] crypto: ccp: Provide APIs to query extended attestation report
Date:   Fri, 20 Aug 2021 10:58:51 -0500
Message-Id: <20210820155918.7518-19-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b98a94fc-dade-4d1c-8796-08d963f39a48
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2685B465E8C6D427A7E30864E5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8GSUqxIbPmNYsLg+ayXhyKo7b9h2Vb0x5BBuo7/25RQxTd3orTetMJhh5BxNU/W8bZCyvg0tCkFSxmceAEhZKEHp9zzxq5yGQHXP+FjAikvivMmNlOmTSG/9pgq1quvNfYIGIO5JJaecFalhcdRnngkkFN2SaD6XJHrprnZb5vGblkT4oiCQjfVG14/h7VwNQqNsTMgRSIUa7ii60Kt8VJho8DLEuh4E5JrECKBP0gFocxyg5gkWsZa+c+MkFUZ8VH0vcQs3h6LJL00vEUTrSTARj2RFAaTFfzQ+VdKBsb1PStayaB/JqL+JZZd1bax0SyfjA6HFzdjJj19dIYPMfq6S5TAiytLys8xLtkZenGaETYRbJOAQyyB+fUKwIiUQ22hmpk0jtoQucwGE1PRAaZuGWMBlRbJBnfZsekK1OBICTrXuYF367lm3tt/MBrbyPZhpXXenpJJIP0wjskwHnxjCcab4Fi4RZ4mAXR9z66oOp7TpQCNxi+VvCivW9h03B7ccuV7HEuUagWUCRrUPJFiFk/ldnPgLS57LUpeAsfv+z6gajUDZIdDqt2Th0bQneJKKogVeciwggJjpvwu7sHePLg730FoObLW6+zAfaY037PxIqAy7xMCMZJiTgOgOyx8UW6NACPGj8r4IAx9ptkgJx6/Hnxa5A0yoZ4jyVa1XO0DhY/B79WwCS5FVZW0B9aQqdYvJB3bu0ML8BU/Iwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(83380400001)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k2AZqOYymyEpagRax8lcWz0rQmrOCg5dQML3ZhpQXCza0v8tB9FasWlBjZ2/?=
 =?us-ascii?Q?OioVhWqjCyKJZ6XiRkLuIht7Sjue20fxnJX6kIo2qE6zUBBsMD+ajbBWs41v?=
 =?us-ascii?Q?RW7vQV9qPJIcPFuXCTLYy3pzWpM7Q94LNjQr9SuUgX2Qhg7lvdFM600vWV2L?=
 =?us-ascii?Q?IKWsXPfcsq4+MQjdrPcK8/EPyni75Q+1oAXUcX1pPqHb37GixACqAb7+6IjZ?=
 =?us-ascii?Q?ekvcrAkhcuPN5cBPvYO+aMiiigpS9Cqgw14TC17c3gep+PYh2tKfILqQNkol?=
 =?us-ascii?Q?Wg5jFFsJvUF8TNWOwBSrtvw9+73HmB+Lpbk+qdmK8BrU7ZMl27XCe0xzTW5S?=
 =?us-ascii?Q?w8JM/DeIVvp76uDlE0M6KbPfRDD8JiSzPkoNgiAOj/x7ySM9ppfDaroaNVK1?=
 =?us-ascii?Q?kccyI6f5wSpQuVRm9qB4EfZcT+4AKPOeluGOzFk0fJCbqHgxC+2jkyUkebAz?=
 =?us-ascii?Q?pZ/bGglk2RQvUVVHckOw2bg/XeRYZzrHrcmCBVsKGtFgsiLtG/lvFn4Ia/Sm?=
 =?us-ascii?Q?9n5rH36hkuRrafMtPYYkTiAYsFnOYv0X5r0dXztE2FY8quUorNm3BwlPVaDi?=
 =?us-ascii?Q?E58xzIFHa57Nbisoe8U39UGtx2TOgFqCRQPFIzTTyanvgdXz4nbpJ+rwzo5q?=
 =?us-ascii?Q?ZUErSylXtZndmcuUVFSMcOBRllWYWDorOFmDVvN9aTPsJH04lQvDDPGtN0M1?=
 =?us-ascii?Q?LiuRDuevEi12eN5pf0ZY9r0IbK+yWvIYwR9tNSVC2usAH5z+v9qxT8TtGBEd?=
 =?us-ascii?Q?BlmlL36MHQYzKIYICVAE+bbN2uLK0F4py/HQue7S3DCRw2g+P+lzIxXCSi1S?=
 =?us-ascii?Q?3Q+TYHHFCj4fP6h8ImXfMWpZa/x2SmvsZn8Gq6mKDrooTxdhJLJGx8X/3dKw?=
 =?us-ascii?Q?JQROg528ZEyrZuaesrqYtZgsbQmVDYKqeofCLCeY5lRI8/RugX0Mh+hMW8R8?=
 =?us-ascii?Q?kLVWx8XL4HRJhQKsFtynByipENMCfHxo8XFgRy3PrJ1P8QP7uVmfpR3z/C3b?=
 =?us-ascii?Q?l8bko33sdjWANWFjk35v6xuBdDerW0F/4vHo1chItph3nMHdB+3zalIwyUhz?=
 =?us-ascii?Q?meoHZgtVum/PJdE58mv77W2xAuLSbrjIVBCP3gUiaFqT+WUj5zjP4QCYnYE6?=
 =?us-ascii?Q?8Nqa+kqbg8MzdDNi6d4vu8aiJTYv2/HUM49WEKVqZhZ39tfKOM0MOgUozo+m?=
 =?us-ascii?Q?tzdtY6yKI8vvCg45VhFWqsmvPoArDfqIZsSqOFHJuUfxu9CrHhL6FGSQtQFe?=
 =?us-ascii?Q?qgCTbEL6L3EUmyUgfnZPVmN48PWnZl4GvXlhXdhvy38dcqqMDVzooq00rtUM?=
 =?us-ascii?Q?pqPqF4mlu3am4U5J186iIkgY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b98a94fc-dade-4d1c-8796-08d963f39a48
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:16.8242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyFyc5GabL48U6WmtRJTGhOlCKGbpSSiT8DT57hspA5m2mSw5q58RnPcrsTRrNe7wxBMDB1U9s/wgJkyUocj7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of the GHCB specification defines VMGEXIT that is used to get
the extended attestation report. The extended attestation report includes
the certificate blobs provided through the SNP_SET_EXT_CONFIG.

The snp_guest_ext_guest_request() will be used by the hypervisor to get
the extended attestation report. See the GHCB specification for more
details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 43 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 24 ++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9ba194acbe85..e2650c3d0d0a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -22,6 +22,7 @@
 #include <linux/firmware.h>
 #include <linux/gfp.h>
 #include <linux/cpufeature.h>
+#include <linux/sev-guest.h>
 
 #include <asm/smp.h>
 
@@ -1677,6 +1678,48 @@ int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
 }
 EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
 
+int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
+				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
+{
+	unsigned long expected_npages;
+	struct sev_device *sev;
+	int rc;
+
+	if (!psp_master || !psp_master->sev_data)
+		return -ENODEV;
+
+	sev = psp_master->sev_data;
+
+	if (!sev->snp_inited)
+		return -EINVAL;
+
+	/*
+	 * Check if there is enough space to copy the certificate chain. Otherwise
+	 * return ERROR code defined in the GHCB specification.
+	 */
+	expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
+	if (*npages < expected_npages) {
+		*npages = expected_npages;
+		*fw_err = SNP_GUEST_REQ_INVALID_LEN;
+		return -EINVAL;
+	}
+
+	rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)&fw_err);
+	if (rc)
+		return rc;
+
+	/* Copy the certificate blob */
+	if (sev->snp_certs_data) {
+		*npages = expected_npages;
+		memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);
+	} else {
+		*npages = 0;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 00bd684dc094..ea94ce4d834a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -924,6 +924,23 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
 
+/**
+ * snp_guest_ext_guest_request - perform the SNP extended guest request command
+ *  defined in the GHCB specification.
+ *
+ * @data: the input guest request structure
+ * @vaddr: address where the certificate blob need to be copied.
+ * @npages: number of pages for the certificate blob.
+ *    If the specified page count is less than the certificate blob size, then the
+ *    required page count is returned with error code defined in the GHCB spec.
+ *    If the specified page count is more than the certificate blob size, then
+ *    page count is updated to reflect the amount of valid data copied in the
+ *    vaddr.
+ */
+int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
+				unsigned long vaddr, unsigned long *npages,
+				unsigned long *error);
+
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
 static inline int
@@ -971,6 +988,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 
 static inline void snp_free_firmware_page(void *addr) { }
 
+static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
+					      unsigned long vaddr, unsigned long *n,
+					      unsigned long *error)
+{
+	return -ENODEV;
+}
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.17.1

