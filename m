Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE6C36FA9D
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhD3MlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:41:25 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:41101
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232829AbhD3Mk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6CCGhIh9gqKDLYyeHJzYkr2jCkpDadWtz6yd5nm9xDsKFG6akCxmSfoYNrOJ9fux7wJoYLYQYOdLaa+VdTKOHPGnusYowRrHzx1j9ZwR7idFdiwpYSlJKmM7S1VnzHSDWsEAc/1rGF9PEgspYdSmZJCr85QvcqbQOe3tk/niXnTFOizZMz/SMFA5B0dtrbbquNc8+6Aa+M8rB0DdzmSJruVEhchVsxa1zGPlZsjBtmgMEHg+j1SZOJK2DOfbHe3xBGHnXCb0eqEVKN6z/92CbtE/azVqLOuAebiHUg2EgSKn5mhFhEIc0JP6sa5fyS23us1SKBT7uleSHA7afG2MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RT1+J9qLZY4BDfPR+RqA5g0B40GtvlEPYK5anVAg6c=;
 b=I57eKeettnH1Tyq678LaJhprrzQgq0raeYX7egwpdh/wdL0lCpCYdLN51smg95gD7M5WnhW2aOh7Dx4kNam5grQVHC7FvAscrsMZT92YXXeWbfgIJrl/U/8DXNflP1NVMEMbv5lNrfZ5kVQgrelI5GyR7WmG8iR2XlFEqi89Nkx164v7QbWu498b0FP/B5PHX20NuOKBH8DfSx1EF4a3KQMyCqnm0winxjx9pd4o+gNzVUlGVMLlH/Dexj8behFtLoWkaiXXdeywV52GGSSUpGlxM15tEwfKh2b8GuM+RGA5Nj5vVOZr5ODh5LVE1+wJ8sZ7yWTPBkL8fLcIymvB8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RT1+J9qLZY4BDfPR+RqA5g0B40GtvlEPYK5anVAg6c=;
 b=e7sX7rdgDBojQakT+2uhh3VKATBDb1WhZLXIpuWwEgN4PkDhyuEYQIcMA0M6f17nRs+ELP9EoakUJikrAmh+11kG8USgdeGGEyX9IhwkVKshodAfGwU6C0bXoc+dNr6Ie88PICysZPlg3MeE6vIyjy9+UREwwKakhlBeo3w8lKQ=
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
Subject: [PATCH Part2 RFC v2 15/37] crypto:ccp: Provide APIs to issue SEV-SNP commands
Date:   Fri, 30 Apr 2021 07:38:00 -0500
Message-Id: <20210430123822.13825-16-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d38fa0e3-871d-4dc5-07c8-08d90bd4f08c
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB283278B5825FC187F51C77D7E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5Y+DInIFKwtUQCJI/12zxBbqOc7EcstLo6XnTo75wUoKqHtMr18QkfN1kmHJq8iYCK02D/xHiE/RcgluQnCFYvf3t3NvzcWWbFgu3iGTj4FbKQj0lG49mNr9A9PSWJ+RIWx31rxFn1kfxFoijLckS8Lks4BiRaO680oSUd6Qb52fp+pOTrmvgJEh/IQdtNZu4gvq0EBGAE4YFfzpfMXRrWeuTfwLxSs4onIpO5YWaXgs+QKUiLVCEspvypwxCtCjbzh8KWojmVpg+2HB3V0T2v0UZ6SJuB2FJqbkZxVlgkWOkiQQEoR+Pv8Ygd6InyZKOiO+gX5uy2TB9Oxwme3dN1xj2ZUiAxDiSFsptQstWuHZqHHJjURp+S/YVR0hoOoDWFGZkSDBDABZICfEHPzJ1L5aRcy0gjqR7jgxdGULOcWmd7+zOVTUfDY+Ugg25iiGaGZEnX9J5Lump7P0ms/gaCsHf7m6obY0LcF5vu0LnwQgX+tojN0vhufCM6j3UQ2/jNbuWpAW1dqqRIrHq79Lrj52V1XRVo0IBU84N1wm+S3dthmQrcfidd47l3XafiBuPTjyj8+obKbsHcQcpVgQ8lUWS6xFe/XPtKxwMMo0Gxnn3Qu2bGhIf9Ms6LbfSVDXeT6uAT22P1VtWhoQKhwVKUCabuVLMHymKNySrzXCn2AfOQTVMe9PM7y33GyEg5v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(86362001)(38350700002)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?27iyU0brGfo2Odhyd8eXtLv0v43audoTH1urEQmxUdXjVaFkSf6zdxmuD/YR?=
 =?us-ascii?Q?E/bmUs0YkirpgLT9HfhR+T/1kvcIVgZ6d4E0bg9LVVZBPDicZ2y6NAiRmF40?=
 =?us-ascii?Q?7+up2WSWuOcO7oqc5JJJaLmofiNAZfA1miEJ47LgQYM052jJQx9oWkxVVDe5?=
 =?us-ascii?Q?NGyhqT3NsKsnE0HByjjm7m9kNL65EwC9XJ0SJlxpOWVrGbi030qPniIRfplT?=
 =?us-ascii?Q?3mzVXalcDrwCwjxKVGJeqIWTuwBCmuMC5kaXQxBmzzUbpayfkjRXJVc9DSAf?=
 =?us-ascii?Q?MhhUAkJnhmoa60j0lKnvLv392DnFmaG3711/eNieFoopQATvtLia0e2xzWss?=
 =?us-ascii?Q?+q1SkGddqkpDLoVRDtlktoSBcs6kIXoe7D4BQ0vjOBxhxJGY4oLNEoLwK5+m?=
 =?us-ascii?Q?n+mgyZ62pPpb2rX0cFL2fKvdJwhELlECOalQoppF2Aun0uwP/iHtVoBi9jT4?=
 =?us-ascii?Q?yaCv2WDU5cUY5/pBo67oSAPBAgkbMw3b7qdQdwMeVtXlyhEqB4cCElA1fZB6?=
 =?us-ascii?Q?TnmvBhr27D+b29s9E+LgpBYIC/OE/s5xVOZ90qG8AgvaKsPNiuYTEuvSzWyK?=
 =?us-ascii?Q?p7NpkHcJzf19vqICpZ+SaIzZY5CpIym77LdUWArz8890DV3mULMKsfF62dGW?=
 =?us-ascii?Q?LdDiV/VV9+VuZNuwNyU8TJ6aE+sCutj4xsmNVZqdin3ZVyQRL655nDR0Zwq4?=
 =?us-ascii?Q?uTZ7t7s0p4sHxZfWAIgDdGM4czHt/2za1dWMq+H09fr/MY4voq5YifOCSTYB?=
 =?us-ascii?Q?58SoQrFusu4ySnHLhph0NNTaWkCZ+AGCeC7LtK3dJnL+1HSyvHSx5dKJYugW?=
 =?us-ascii?Q?ewz34JGEnlSSr5ysPdx4mEJnoQ/GySHdGiZ4/CGEXYNsHGk8SybHy/6E7fuo?=
 =?us-ascii?Q?MbbZYtFYPHhP1zKKLiAa1tcwFvfiKjN+CgMOe0F61//g1inLYyyMhYD9nEkK?=
 =?us-ascii?Q?o3SVhIEtJx+wv7w6MA6PbN07qd9ixKEMUF5VivWsqzbCukwb4k5Xxx+JYI9i?=
 =?us-ascii?Q?tlkVl0eQtsGmj8b2NqOjeJaCjouliuNtz3gokihPUBHel5ffC8cE7AeHx6mB?=
 =?us-ascii?Q?7Qr4s1uNxunHybvAWDqbh5pHjW6zqxerhUXByzsrhOBZhPRtu9+abVBT1MGS?=
 =?us-ascii?Q?EG1/Ojfa0aDMzfzBtH3ou3mlOGdVqi55SaNmUtSrI5ieExH9zQNZHcpbKsLs?=
 =?us-ascii?Q?/pXLonPvWtB0HmIg+PiVXtEpJk1T99CdYcL6lljy+o7YTISTAxIekyyCsULz?=
 =?us-ascii?Q?XmtbSgg/ty/mCYWoqqo++uzIfyoLNeloy95f2TDNqLlwIlxOp9EH3iGMHOJu?=
 =?us-ascii?Q?oi0ufM75i88dL+QkyTtEObXN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d38fa0e3-871d-4dc5-07c8-08d90bd4f08c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:04.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfQwZgh4lb8MgdPAWmnjliKIq/2CwE4zLI29oDH0L/B2GfCD/Y1QvHiNZIy5Mh8wuFksRUGeoZeE4RsjdAzhAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide the APIs for the hypervisor to manage an SEV-SNP guest. The
commands for SEV-SNP is defined in the SEV-SNP firmware specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++
 include/linux/psp-sev.h      | 74 ++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 23ad6e7696df..75ec67ba2b55 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1010,6 +1010,30 @@ int sev_guest_df_flush(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, data, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_decommission);
+
+int snp_guest_df_flush(int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_df_flush);
+
+int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, data, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_page_reclaim);
+
+int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, data, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 1b53e8782250..63ef766cbd7a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -860,6 +860,65 @@ int sev_guest_df_flush(int *error);
  */
 int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 
+/**
+ * snp_guest_df_flush - perform SNP DF_FLUSH command
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
+int snp_guest_df_flush(int *error);
+
+/**
+ * snp_guest_decommission - perform SNP_DECOMMISSION command
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
+int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error);
+
+/**
+ * snp_guest_page_reclaim - perform SNP_PAGE_RECLAIM command
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
+int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
+
+/**
+ * snp_guest_dbg_decrypt - perform SEV SNP_DBG_DECRYPT command
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
+int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
+
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
@@ -887,6 +946,21 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
+static inline int
+snp_guest_decommission(struct sev_data_snp_decommission *data, int *error) { return -ENODEV; }
+
+static inline int snp_guest_df_flush(int *error) { return -ENODEV; }
+
+static inline int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
+{
+	return -ENODEV;
+}
+
+static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
+{
+	return -ENODEV;
+}
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.17.1

