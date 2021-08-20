Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427883F3075
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241313AbhHTQAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:00:47 -0400
Received: from mail-bn8nam08on2075.outbound.protection.outlook.com ([40.107.100.75]:31200
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241328AbhHTQAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fF6Iv7P2QvyGyqWmhXOr5P9v4T+rEvw2UNLG50A9fxEqFrfQS7PN+I+ubMu0ngLs6dnlH+pc74PkEZ1aPOKHxyW0Vp7AFYyZyJlL7uYk3RtevQZSv+M+abBd3V6PU1rMddQXUUW2BOlAb0K1BYi5N51KQKX8DBooEmOs8g6/AD63vPqkWCufSoTD7F6GPd20MLI3UNbABKVbQDl9j0sLJBfehwQ1RsPvRyRP0TEJGOFa/sgKgRtFDNUcMN3I3NMCLM83+mOfxgzuGu8bmmrT4nwZQ90bPvBpUtq4v3vqmDBT2bUydlftgdLsqzPpgyBJcO2VJZt3jtYyzZgL9jYZBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPb0Krkmp5g+egnTw4zbXxw+YrNaWXAd4naJ69WHSYU=;
 b=JjSaIkz4EJ04paViG2/fZDMxPPNd+9zWIdHfekcH/yZvkk8BIztej8RFag328gkH3u8Y7e54ejy0IqoNiKlmZhnDGfjojuW5q9beE2FyvtMm431TL/gohM6zF5gFLDkfmpCWT0Rtzqg+dKP9f7Ldgx+t+4vz9BxjbB1sfnQtds4lEji4saKt6mgCdM0qzauaX5nDnTdZUuoPcwLDJlCPHrjDGZq/YaV5vDHVCh6SdDgVnC9ja7sIt/HK6dMAuPV/4htGWX/R4I1ClGNvQ2z4EKBhTaVZ0MZjU8drnzDHy44yWw+MjQzAJ8ecL4zsYHkR8hunu/hfHs2bBk8FeRM5Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPb0Krkmp5g+egnTw4zbXxw+YrNaWXAd4naJ69WHSYU=;
 b=iO3DBuWpxDra4HGOe7RdQZ1CO+jvc+tx3TqRjrsiIWqjBPFh9f8JULjnSuMMlHf+A0rTbwUiBbCF7/QS9rF9UejdWkG4ITTDi9JprzW+5hNMdEDDkT7nT593IRCmodXdoQKb0t1LxkLQQiKOsSF64i9hcayIL6dnLh6C24B2Fjc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 15:59:56 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 15:59:56 +0000
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
Subject: [PATCH Part2 v5 02/45] iommu/amd: Introduce function to check SEV-SNP support
Date:   Fri, 20 Aug 2021 10:58:35 -0500
Message-Id: <20210820155918.7518-3-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 15:59:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 640aa177-0f1d-46be-f1bf-08d963f38de8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384DEF82BF598F5BEE07A79E5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EyRCeDlMOPKzGSuUzwJD/ZXT7XDQknk5mfqKak/IK718ErPQraVIKhNtRbVfkbM4xmJ021O9lYI16QnI3rOUqDZuzEfPdoI+bSl2jk5hdC8fVAKyHo0VriLezDNi24CmZaJMcNyDXkIIZVN7c0hW8wJkBIvPLva4QqHpdqCRZL2qtcV1NG3AAAzXmjROdn+rxIdznPvUn5x/FxzEI8go14TAre6fvJhAjYg9r9sX7Kba0XCaqQQ9uhhnyTsR0o5xlSnTDyI6MEbLUSL91/ex9tPLTjjCAAAu1wtYBjG3Ynq1ai399k3cgboT0hBwYNSanL8LxR8wRZHuYtlMZ/IsVa+s+q5ohlgAlFX3u7R5yD7Ckc9L9igZEBip01yTN6YjqZpKpntzpR1URUFd/1dsRxN+pEXcJc+39Mf/K0tfIDLtuijdo0kgvoXLybtUAvEnE7Kyb4DUrk4ngad1XLl5XLgQaQljoPLtkMQRyF4GYKECwu2JP0SFbPBegVT3s4V8O89UitNj6ZjxwjiuM2Q4O2Vtl+jCoN1H3IqlXAJwpNRWZCErKE4y9iOcUIGUEeaSWng9AjZZBPnJ7G+9AeiNvu6T6PUI8k/AxSpG9IhsIJGxx5N5WMbX+kiKPSAaiHp2rttB20biOxBZwWsXUGXKLmJrCIOl4rdZZKjDfPaqif7tT5Cdi5Lj4eXxULIuwp34/mf08d7b1VzihvH/zLl15w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i6T83T4twIh4+dUtC8zzxOkltYfaaUDxxNFzwtwng/AVa6YThvTwYW+GvvLP?=
 =?us-ascii?Q?j5/Aol0TBhGHxcGB5auyjFAw2q7EH3KbZDPI3f0qIBvzg8bA/VVWEHacb/Z3?=
 =?us-ascii?Q?Uc3RCD51p2XIc896gEf70nRH36PrHj9AxLPX3MBEqzxsw9a4+rGruhsSZydr?=
 =?us-ascii?Q?Uoaam4UFnuGdW1ZS0XaAWWayE6c/Ys+71p2KVAZqY88SZAEAAclZBjfv96J2?=
 =?us-ascii?Q?M6vx/ha/V0MMltRrLyH76aywj9z2stXaoSacldFIpt/IOYj0Jn2PRjHisWQB?=
 =?us-ascii?Q?B6tv5qalpyeX6ZqRoox0sJP9n+PgSy7e5SaJoYsnUxhJSB7toihLa/yZrhi3?=
 =?us-ascii?Q?5wK43wGOt6W6ffW1AeZFxK5b6BfOJE88Jm31nAzS+nNwtTdCkqEhwPnsM2yO?=
 =?us-ascii?Q?YtyyoTwfUWaIiciH0GnRm6DrEYpkIUjqTYOJnasB6pRTkRp5Uj2tupqWGzHc?=
 =?us-ascii?Q?gS8cS7c149ukziP/PAw+8oUx/nXO6cBPUgocqlD5/xvyY4iZl8Z1U44dvbia?=
 =?us-ascii?Q?eqkn29NczKMI1j75J/v/m0U7upMzdQ/+105g89o+Uy+UTrPl7emIyi6x6B5+?=
 =?us-ascii?Q?II+/UhG8naa826SgMHuHeQE7UXrArUl1ovLkf2jvwsf01uSHyJLarNzkNYpT?=
 =?us-ascii?Q?khv1YChEMS8LN6TucMMi0DtOTcCL24Bp8g40WASPiWuP8RRrDJDcYr3sNxQI?=
 =?us-ascii?Q?igS/ujNCqp1aRj5dX8GBNEvVdSkqFkK83IV5Y3aKjTF3DMd429SsuX1zSZcX?=
 =?us-ascii?Q?dQxewpFOwsprLQ1YKOErSSwEvh9rfSvIzV/C3nFzGrNID7kTgDs6cugoTLWH?=
 =?us-ascii?Q?YQV/ZKkiBj77AVOgS5npZT1tBF1xoKORjCZb1ZnfYqc2arsEdpGaUmx7JRAX?=
 =?us-ascii?Q?Rd767GYyxCcVS/bVb4dktrXHKW2To6NjN3EWU1AcsP9EjEtTcVWdqUkjUdUI?=
 =?us-ascii?Q?QNpLVvWs3ApGO/tPJc2NPfxD9bdLeH1d1tHAkjGZs8u7XTsHmEvBX1g23pZr?=
 =?us-ascii?Q?G1Od874UoQHjnrCh7eupEb4kxacWFenJxq7jV+nwPl0NOVnKzAPZxOXibAXh?=
 =?us-ascii?Q?oH8GXA76WzkZCy/eUoMCXmM7pXcawF6fptGVMiK9GyCgWFbONMCQc1fMUGZ5?=
 =?us-ascii?Q?MbOCQsMm2Ddz+RZOomM4R5PhWzWykW/Ln1Owrs4gOOaqMwIA8njH5z/seMhM?=
 =?us-ascii?Q?np+omB6L8Uhi7c5BaoLMuWc61en8XXPPvfWct883tuiaOPcGlPc9OkcPj4c5?=
 =?us-ascii?Q?P7PbMX4xbGQqpaTncC8TEY7yhT6Y1qD3ZvVqqKzgqkWtOGntB8Pca0rbfPfl?=
 =?us-ascii?Q?+Bx7CuWp3mN30hCkKxKpjiAt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640aa177-0f1d-46be-f1bf-08d963f38de8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 15:59:56.0571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBpA0sNwA4uZNg1MdEcSCylMWiE6cgUkRQ7T3uNrH3nqtSnIRglYwdc6XBj3Yi1AfFvDFvhWp5iG3W8fqHWF6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP support requires that IOMMU must to enabled, see the IOMMU
spec section 2.12 for further details. If IOMMU is not enabled or the
SNPSup extended feature register is not set then the SNP_INIT command
(used for initializing firmware) will fail.

The iommu_sev_snp_supported() can be used to check if IOMMU supports the
SEV-SNP feature.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/iommu/amd/init.c | 30 ++++++++++++++++++++++++++++++
 include/linux/iommu.h    |  9 +++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 46280e6e1535..bd420fb71126 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3320,3 +3320,33 @@ int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn, u64
 
 	return iommu_pc_get_set_reg(iommu, bank, cntr, fxn, value, true);
 }
+
+bool iommu_sev_snp_supported(void)
+{
+	struct amd_iommu *iommu;
+
+	/*
+	 * The SEV-SNP support requires that IOMMU must be enabled, and is
+	 * not configured in the passthrough mode.
+	 */
+	if (no_iommu || iommu_default_passthrough()) {
+		pr_err("SEV-SNP: IOMMU is either disabled or configured in passthrough mode.\n");
+		return false;
+	}
+
+	/*
+	 * Iterate through all the IOMMUs and verify the SNPSup feature is
+	 * enabled.
+	 */
+	for_each_iommu(iommu) {
+		if (!iommu_feature(iommu, FEATURE_SNP)) {
+			pr_err("SNPSup is disabled (devid: %02x:%02x.%x)\n",
+			       PCI_BUS_NUM(iommu->devid), PCI_SLOT(iommu->devid),
+			       PCI_FUNC(iommu->devid));
+			return false;
+		}
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(iommu_sev_snp_supported);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 32d448050bf7..269abc17b2c3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -604,6 +604,12 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+bool iommu_sev_snp_supported(void);
+#else
+static inline bool iommu_sev_snp_supported(void) { return false; }
+#endif
+
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -999,6 +1005,9 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
 {
 	return NULL;
 }
+
+static inline bool iommu_sev_snp_supported(void) { return false; }
+
 #endif /* CONFIG_IOMMU_API */
 
 /**
-- 
2.17.1

