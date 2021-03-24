Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB15347EA4
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbhCXRFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:43 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:50400
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237047AbhCXRFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Puz3y+wInmHEtv9Uz0MAPPgPLwlIutZRaFbNDJOCTAMm6r4njNYXvxKOSAPUu0XoLCfK/LLabNqWQyYQkdZOBquEzGZpHpNu2W8jKcknWmtbvUDcoqS7f4Lb5NgHCmJEwFGWqfz98acjkGpmvHHxj6hkkMLZnkjdFZLBhdYokWCo0I1K+PlLFn+JU5fqsXphb+uZ6XVl9ur1NX3uKYuZNgzSTW620fGYfnpV5wLpdy9xgy5eZMd+OPUhL/MFS1GwwzJlGLnhHpkNbPebzmobj4I/7Ij6m+bEDsuo81Q9lRp8K4H4RpUYJYK1hr7wYRwq5Y0OG01bz63v45E0mDKOpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ij9VyltMae1y0jaZt3/gH2pMt/vbKrK9SCRaYzkZA8c=;
 b=BF7zWHSxrUBpgGuKahSPBQs4/QIAM7zKNymf0GeluS06hCKPkJ7EqQhfgEulMWY/L/BiuZ2AGU1IWJXd9g2cNj6WllAahNsJJUf0A1UHfJ1IxeNH+Rt4nvGA5MWr7GmUrukRC4fsNRD6YK2jVdaFp/CtCiuV88q/zxkT9zosCNzz47QMf9agYQgJUI22zNgyfwsNvkzj5FUHmkQfa+JE8vcP3VxIGq//j89//RPnmgCxDjHIF9TLGKLbfgRDT00qC4ge670K7DgoiRivL3lmlV4/BNfXXQEECLEeqzAfIMemgFzpg9/jhfNQ8lDpTKFrOKPKhUp4Z+YwTiiattqvDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ij9VyltMae1y0jaZt3/gH2pMt/vbKrK9SCRaYzkZA8c=;
 b=kxCrki7jORxZgYHY1xI0SP5ZfG7ziOMigAFRALGPEWDCnCW9+LV10wSeEyA0RnSgvUImrJpY938Id7eMcXS6kkPmnkAmRVW8WwI+4OkMsetVQZ895RwMA4xLLuAy3axkdc9G1syMovJ9CIqtUFptEpntqGF5AQASV413mJWLdnk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:59 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:59 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 11/30] crypto:ccp: provide APIs to issue SEV-SNP commands
Date:   Wed, 24 Mar 2021 12:04:17 -0500
Message-Id: <20210324170436.31843-12-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca4559e1-dbfe-4aa5-69e0-08d8eee6f521
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557391FE884C52E1800E2D3E5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qQHdyxRr/NnZ1LQHDC17POkX7KGJLBTL0eL2+VzOj8ndYxs6/ngoO19qENqp9fYEY1PyrIiivQS/fjlSeZmOxmw2mPPPOpFmuQgi3yl5lJm/f2I2jgviK1hG1xPgDIwY2Z/FWDECk6Z5EL44UIAKe9tS/sWK3zG1/n2BgyT5lsYsm7Yfihzsj8w68QHXum1HVTniJekYvFOcBt9f+WN1R9vyPOEbx4qh+JzoyVXTjPRpid0de939IohztIss7/qCG+ci7SPn4eZBk4V22X0SXFGrU9iAP+zDuu12mR4lScEh5s91b52IoEEfvLIwBkV0h31x/5PIVQ0JwyDzFBcOs8/LgZnVBlU3/gydIhk1okmRetQvl+dmRagVYo16yc3xt1rRAIDj1+g/yUdhA1L+kdt1avI3URjwc9Xg+ZTq/g0NTDzb63XSraItDBkdaQJrCP/amFVkqL13TRzbQurZEvxZ3H3DUb1RMlmxXArwAODvaGDP0I/QR9ruI75iHLlWsgbqug/Y0QP83zB+7xSCd9zOVCwt52UPJH+pw6cws68wvAw1Eicb9xdKVW/iub28B7oyPDS5aU1dJhmyRn/gXaHRLFU+AV3hwpRq9If+9/7KKbk4f7fm6h8KEQnV77uqAfU5Xi03WT4MHU9tXDncO2Mk1geBmiTBnUxsSWe2sVnrqlz/H1/njCSDMCC5tqd/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CPy6CfXGh4P+xoGN/AL4Mbmuksgr27jhuWG1HgIdXLs/o9E22rVdQvRgGtGj?=
 =?us-ascii?Q?AATDotALcj/elKhaxD4fXwdErYtHLLbdnc69bPSKPANWyLhTepml7eck3Frh?=
 =?us-ascii?Q?xnk2v0otl/Hpe1oGUrlVZbcWZDOaVVqBmWqaiJWEfbYNogMzGNrG5mi+qMCY?=
 =?us-ascii?Q?VdOK95FIocFG5IE0uqepc5OWw+2Js61q+9w0qsEkMmT2NYpNrmxXbD2WgDHA?=
 =?us-ascii?Q?tVbW/NGkfJM1iDwytRreOQk51jtzoTHXguCQHdtm8lOCVy0woInhxOXvLZ8k?=
 =?us-ascii?Q?FSpnZBw/Yr4f6kH3ls4E5RSsCusVE7ZSEgDHOLXw2Qmi4rt8VoExsawapAN9?=
 =?us-ascii?Q?W5SOhZUNel67TXTqR4pg0RiSfNva+bEjizGAopmcSVtCUlDPFHYm/j2DjtvM?=
 =?us-ascii?Q?gwA96zqr9MxY1C1zm+pnNkwxi1K5trpXprJmDXwAdu4EikqCPUoPhX7poPVO?=
 =?us-ascii?Q?aKtvgq0jGlRHua9i/eHav7ugzawCHpen0/qppE224JTkdAsnAQMVOpy8e+tT?=
 =?us-ascii?Q?sBYiFxEuhBTL4Q2oyR7yamxUdnujE44pLFhbWXu7FekK81Fl5JszsyBCnLrT?=
 =?us-ascii?Q?3Ta6oNEtjN1ZJDwQOJOEzQoD1Z0dd15CUoFboVTE7usE3mZdDQtfG7JcZP4w?=
 =?us-ascii?Q?2yNcH+7BuNmU7y6ZVBKc2ak7aGeKQC/wwYxDeijth6SlsgkENsQzMTay+mWj?=
 =?us-ascii?Q?Dl+L2lKfFn1WQ8PMSTNXZRoS3Xk9XYsdtmlaOCqToozqyinrkOz1iyOLZ6oV?=
 =?us-ascii?Q?3XsWZ+s8IPPVcQNhapTqPwENk6Ryr73IP3mEr9B68pUVlpLW1lYvPrXmaiED?=
 =?us-ascii?Q?nnxb8WsS4cJRDdVxvR6l8V7SBnbMtXkfteVUbFuYc/bndvM1TAvydDtBaV1T?=
 =?us-ascii?Q?FqPIfd9DFiofY3D4XmsEktHBi1Jw0Q5tHfrGidojwdFh/UXKYeSYbgxRlpmk?=
 =?us-ascii?Q?8kq1oyWreXsXTCqqGsny/BZ9fKRUQRjGpd6S+xHg9QID/35dA5J0FEOixzZE?=
 =?us-ascii?Q?3ZclgND0vgjgP+FYApNNip1Iqt8UPhG5Zk31kHr0/VZgyeUCpqJFu6Hn+YPJ?=
 =?us-ascii?Q?4GoTdNKyPUoL0lQyIOdA7jto2ZLzsyZMCddeDeF7WDk0O/SxZpJKeUwZjxua?=
 =?us-ascii?Q?6abNcp5WYBWWeqG1EQEk9VTA/JQctTj2OJy/9PJK29NwvCK0qATwAcldjkR+?=
 =?us-ascii?Q?gOYB0/qC3Dkb35VyxAt76ur77MuUAhXgihm3xaw+m0kqanFr7mTXx2LeV1VD?=
 =?us-ascii?Q?sy1lGC+z2iAbJy7C/5iT/0NpRcO+WFGiPjQxK0Z34/9Zp/ew2M/6nmflUp96?=
 =?us-ascii?Q?rMopf/Wn9iKP8sAEU1Kijbpq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4559e1-dbfe-4aa5-69e0-08d8eee6f521
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:59.6940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8wG38vvFpqzJSa4gWfuwfdzpoSKAX6/6QMYlK+eaXPXrIzhGEt6DuluXjt0bd8MBAWBb1vZLq/YtxwJ3NA8nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide the APIs for the hypervisor to manage an SEV-SNP guest. The
commands for SEV-SNP is defined in the SEV-SNP firmware specification.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 41 +++++++++++++++++
 include/linux/psp-sev.h      | 85 ++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 562501c43d8f..242c4775eb56 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1019,6 +1019,47 @@ int sev_guest_df_flush(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+int sev_guest_snp_decommission(struct sev_data_snp_decommission *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_snp_decommission);
+
+int sev_guest_snp_df_flush(int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_snp_df_flush);
+
+int sev_snp_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_snp_reclaim);
+
+int sev_snp_unsmash(unsigned long paddr, int *error)
+{
+	struct sev_data_snp_page_unsmash *data;
+	int rc;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	data->paddr = paddr;
+	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_UNSMASH, data, error);
+
+	kfree(data);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sev_snp_unsmash);
+
+int sev_guest_snp_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_snp_dbg_decrypt);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index ec45c18c3b0a..32532df37446 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -821,6 +821,80 @@ int sev_guest_df_flush(int *error);
  */
 int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 
+/**
+ * sev_guest_df_flush - perform SNP DF_FLUSH command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_guest_snp_df_flush(int *error);
+
+/**
+ * sev_guest_snp_decommission - perform SNP_DECOMMISSION command
+ *
+ * @decommission: sev_data_decommission structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_guest_snp_decommission(struct sev_data_snp_decommission *data, int *error);
+
+/**
+ * sev_snp_reclaim - perform SNP_PAGE_RECLAIM command
+ *
+ * @decommission: sev_snp_page_reclaim structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_snp_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
+
+/**
+ * sev_snp_reclaim - perform SNP_PAGE_UNSMASH command
+ *
+ * @decommission: sev_snp_page_unmash structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_snp_unsmash(unsigned long paddr, int *error);
+
+/**
+ * sev_guest_snp_dbg_decrypt - perform SEV SNP_DBG_DECRYPT command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_guest_snp_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
+
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
@@ -848,6 +922,17 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
+static inline int
+sev_guest_snp_decommission(struct sev_data_snp_decommission *data, int *error) { return -ENODEV; }
+
+static inline int sev_guest_snp_df_flush(int *error) { return -ENODEV; }
+
+static inline int sev_snp_reclaim(struct sev_data_snp_page_reclaim *data, int *error) { return -ENODEV; }
+
+static inline int sev_snp_unsmash(unsigned long paddr, int *error) { return -ENODEV; }
+
+static inline int sev_guest_snp_dbg_decrypt(struct sev_data_snp_dbg *data, int *error) { return -ENODEV; }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.17.1

