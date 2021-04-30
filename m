Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D84236FA05
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhD3MTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:19:53 -0400
Received: from mail-dm6nam10on2056.outbound.protection.outlook.com ([40.107.93.56]:37728
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232681AbhD3MTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:19:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMY90+jUdQtK301/3CgTzvl1LNPKeP6LJ9c55crkMgzDueYZaD1Ii+DRf8cPryf9Fy5DkaoG9C7JhsxgP3WF13TGc+4Az3QTb3GbPLoRy2IbGy8+obxqv1P6452pG/NU/sEkWjSLZtO/yT58pjaJfq5JtglFO6E9mv1wfXmAliwp2pKFerjqH3N8te2I2x3j9ah8aT/X/kDhEz4u+KFo/g9yntwuhaNTy12Vp+LG5W+tMUbvfE7W/rEPM/ykqq/hf13C5lqafxt0vAPF7vZBJmIem9boLatEAmZ5VwnE3QufI1A40UtVmq3tr6lsLTBr9s32Nwj/k5/Ikrrd5No/7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s38/RqnccsTxLl3TUbffPy5DEuIA45t9N2/vTTyMRbk=;
 b=S+YX4db25VYwEtFr7ljD8YQ4MM6Jc4tinfGBKI4JAvWbAHp5D5W6a4tiw16S+tfvaC98r8n2JsfXvDqMPpeHr1go6tdD7tE4awpmpkdnWFrmZct5fU35VOLV+rDJlKz5GnRn9+OPAdNMsmcF7+R5H0OSJwuGnuA8+2ZjhlZHpFiqpxuPWmXZyD6uwQNVDBbsOAr8DXzcWSxHVMiaGNPmeDplZEePppTDFNZi3CBK1CcWnon+sfz+JzxS+CI5lqAYMpmhhDe2aULJfj3mxvbhttSYh3gbh3alF6WBsivli0Sb7cGyyp3IwoAKHWHLa315soTW2NRZx631V1H7Z1xIFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s38/RqnccsTxLl3TUbffPy5DEuIA45t9N2/vTTyMRbk=;
 b=hvP9M7wIaV3kjsQUqUP6pqBzPD3ogEAStfwxggTKZuLAxHA+Qy3BREpjUV3fBcxCTEfjTm/G1ocbU/Quhjs2zkvZM9HWRWqDnlwCWnkhJEEjhoMzjPsI5MUETB2XNM9oqQBJWYn+I67T6LE6vfkg5W4/RnFiz+fwbYIoraN5+/E=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 12:17:05 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:17:05 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 20/20] virt: Add SEV-SNP guest driver
Date:   Fri, 30 Apr 2021 07:16:16 -0500
Message-Id: <20210430121616.2295-21-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:17:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e74b4c7-43ce-4416-2268-08d90bd1dc0d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26402F6F09F411F04885C101E55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LMBfolT0gjTHVdLO+TcwO4zVkM6bO9aO3kCC4u/0fLQHYhucyNFDe7nlVxPlQsVdbPQ9N6tTHrKBaIucgm51uvoaLKZgWBZ+7slyMpSpf0pNHFmeYYK2JvHIu3i81qzgD+q7YmDjcj5zUdPwcXVgZAMIMYW0QiN1XCFFnKl/8dNNTYNDdXshuVjU2JYjS/MJhz2+mNFFd+m1nqFZAfIwsMMcOWVW2TRvYyhsaKZmWgf7LUoor0c6v2g6T6VOyqOmF8hOpMTcXjbb/LK9WfUgBdq8SJczo5DJmxZWdJ4gMj7G8kz9T3PZQGK2hApUh8wDT8t/ujd3NzvRvv2uaKrDrEiEodhNdjlOrkwwlaVFlqqDYpFwzXi6xIl5XxkDJtXaZmy4vaOUA5qvd/ns05ql+x/JM9UX1F78qChONs0Muz0S/qlgGu90y4G1g3zSIzfGppmNdJ9rHxJdk6ghwBWXlcoMzSzOCktR4TAAjKjJINO2g7gV1edRYvss+dIk5vbH3jwglS5mI5ttDpcuKp/2oWCK0aZ/npdMk1PozPSxngQRKDK7naqpKhoy1lSXuqkIuewvKM0p/EYpImZJxLG6ay65SvzeDrhzMzLVoVrFdPNosb2ocnei9pdzPMdQjVrHEnF+3b7ZP27OfER3vx4A8xL9Wpe6+hQETeSsYFG/IPgXhJrZFTsp6RXs3AY43SuZd+8FzGRb4vUyFxyfBZVTEBwn9wibQDMnZShELOQlOy0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(966005)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(30864003)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(83380400001)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rzz6utR9cCkYXLbETbMoRgZ/iWZfCSKh4wYs8dlMVLd7XvBro8/qTCP/cy8H?=
 =?us-ascii?Q?ku8nAZvBCat68yE+zV+mfjaq+9waT6fKGBer/+d+LnCGPZbvMv4OZTAEJZj3?=
 =?us-ascii?Q?Ch+wJ7dC9fgBw3sKuTRIYLwiyfU+rdv8WiYjYLkXhvrCCc5XrZjPv7qEbkjY?=
 =?us-ascii?Q?JYBVvQH94Itc1PKbabUeOzQkcE/jEkeR8Smi6k/4p1aj6NCXVZeRDrXwPRxo?=
 =?us-ascii?Q?glo6LyKY9w5YFad5IRrCKKl71IQknXL683gUXXUTm1vdvWQFEFRL9RzKWroA?=
 =?us-ascii?Q?gpCWId6utrLUeLPw/u3Zcthyc1ON136W8WIreursY81nnzWrtMsfMMI0LQkz?=
 =?us-ascii?Q?SpXlHkrcXDEA68eNKWyphouR66rTOMpxhvY2c9wVEIdNdUWOV0GY1Symn0na?=
 =?us-ascii?Q?3Fm8D1Dk5z5wt9aU2G0sruLRHzI2TlpSfNArp45QIuHXF64ZjUalpa1OGV5/?=
 =?us-ascii?Q?+vANOgACQtNL9PZiwP2rx47XBkal8AlxiVO+0YnBRWgK20RIAHHhgBcDiBO8?=
 =?us-ascii?Q?zWX/B1azfA5/kghuVHS8AFWMbv2m+1toXeUt0OvlCcaIPOsbiKsZtOImFWSq?=
 =?us-ascii?Q?8ugA/CZR6bjYCwkXFpMTXBUppJi2epP7yVdYKSMR9mEf6RZwXdxe5IvPHC+0?=
 =?us-ascii?Q?Ee2IVscemRtJi8F9ntuH/IyK/U/MsFK9vNWzSuqteg2KafkpwKx2Vld1csC+?=
 =?us-ascii?Q?SipwVd/YR3WhUNYOx6ZwLs+YpUW5mGoEgkFjpYi2Sg1+0cHmTLFuJx8BXmvt?=
 =?us-ascii?Q?o+Ac4pys0v1qIPDDAlqoDWuGk0zOmoMmZ+VbX9emEjY0biWsBz30jYY10w8H?=
 =?us-ascii?Q?UUW+NN0u/dpKTWkJiQtt0WkuxwpljN1XV6g2JneCqcvjRqBLHcH7Pv7UOoJZ?=
 =?us-ascii?Q?Iqx7RnLk8ziVctZH57o2v4Qd6oPdG6sc6p9VZOJWWlfl6nyj8RcRI6abUg6n?=
 =?us-ascii?Q?qXKaBZcs/CDQl1jI1i+KAzlhmgi/U228LjB2cHUvx1g51oKoeTJNmdZdy+xf?=
 =?us-ascii?Q?UzNQtvTG3S931JhYU7bXSBEzftO1EqGQuI2Y47Bop25S7hUTHxJKudXpACer?=
 =?us-ascii?Q?6l1MqDRLl+iF8qFCuLSwbh/FCYNNMctHWmCRcOa/sqmuVCEREdkAUZAlzhFM?=
 =?us-ascii?Q?HaoP/YW4o5c5SuXmgVPOOx2LRIKWKPV1ep0W45FsAbRgzrOoUROsgmUVnzdl?=
 =?us-ascii?Q?86e74+KOWOUxzK1MWKS38LGWj+x1my6kOHJNSU9BWGDrDfB9Itp/DBZpOkyh?=
 =?us-ascii?Q?QchI+qMwyA37mI/tpLExo4bedRJSlGbst1daHjDFvaSIrZx1RoFjqUjSX+9K?=
 =?us-ascii?Q?AQ0zoNBLSkCg1qhuB7pX3MpO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e74b4c7-43ce-4416-2268-08d90bd1dc0d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:17:01.9073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwwS2GEfiG7/3E0LpI4fEHb/RpVIfWbe6wMbLtW/edHoGYONQUpoojYO0/+hMSO5mjzCLEsqxMJ+3n0QkNfejQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP specification provides the guest a mechanisum to communicate with
the PSP without risk from a malicious hypervisor who wishes to read, alter,
drop or replay the messages sent. The driver uses snp_issue_guest_request()
to issue GHCB SNP_GUEST_REQUEST NAE event. This command constructs a
trusted channel between the guest and the PSP firmware.

The userspace can use the following ioctls provided by the driver:

1. Request an attestation report that can be used to assume the identity
   and security configuration of the guest.
2. Ask the firmware to provide a key derived from a root key.

See SEV-SNP spec section Guest Messages for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/virt/Kconfig               |   3 +
 drivers/virt/Makefile              |   1 +
 drivers/virt/snp-guest/Kconfig     |  10 +
 drivers/virt/snp-guest/Makefile    |   2 +
 drivers/virt/snp-guest/snp-guest.c | 455 +++++++++++++++++++++++++++++
 include/uapi/linux/snp-guest.h     |  50 ++++
 6 files changed, 521 insertions(+)
 create mode 100644 drivers/virt/snp-guest/Kconfig
 create mode 100644 drivers/virt/snp-guest/Makefile
 create mode 100644 drivers/virt/snp-guest/snp-guest.c
 create mode 100644 include/uapi/linux/snp-guest.h

diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
index 8061e8ef449f..4dec783499ed 100644
--- a/drivers/virt/Kconfig
+++ b/drivers/virt/Kconfig
@@ -36,4 +36,7 @@ source "drivers/virt/vboxguest/Kconfig"
 source "drivers/virt/nitro_enclaves/Kconfig"
 
 source "drivers/virt/acrn/Kconfig"
+
+source "drivers/virt/snp-guest/Kconfig"
+
 endif
diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
index 3e272ea60cd9..8accff502305 100644
--- a/drivers/virt/Makefile
+++ b/drivers/virt/Makefile
@@ -8,3 +8,4 @@ obj-y				+= vboxguest/
 
 obj-$(CONFIG_NITRO_ENCLAVES)	+= nitro_enclaves/
 obj-$(CONFIG_ACRN_HSM)		+= acrn/
+obj-$(CONFIG_SNP_GUEST)		+= snp-guest/
diff --git a/drivers/virt/snp-guest/Kconfig b/drivers/virt/snp-guest/Kconfig
new file mode 100644
index 000000000000..321a9ff7f869
--- /dev/null
+++ b/drivers/virt/snp-guest/Kconfig
@@ -0,0 +1,10 @@
+config SNP_GUEST
+	tristate "AMD SEV-SNP Guest request driver"
+	default y
+	depends on AMD_MEM_ENCRYPT
+	help
+	  Provides AMD SNP guest request driver. The driver can be used by the
+	  guest to communicate with the hypervisor to request the attestation report
+	  and more.
+
+	  If you choose 'M' here, this module will be called snp-guest.
diff --git a/drivers/virt/snp-guest/Makefile b/drivers/virt/snp-guest/Makefile
new file mode 100644
index 000000000000..f0866b9590aa
--- /dev/null
+++ b/drivers/virt/snp-guest/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_SNP_GUEST) += snp-guest.o
diff --git a/drivers/virt/snp-guest/snp-guest.c b/drivers/virt/snp-guest/snp-guest.c
new file mode 100644
index 000000000000..7798705f822a
--- /dev/null
+++ b/drivers/virt/snp-guest/snp-guest.c
@@ -0,0 +1,455 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Secure Encrypted Virtualization Nested Paging (SEV-SNP) guest request interface
+ *
+ * Copyright (C) 2021 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/snp-guest.h>
+#include <linux/platform_device.h>
+#include <linux/miscdevice.h>
+#include <linux/set_memory.h>
+#include <linux/fs.h>
+#include <crypto/aead.h>
+#include <linux/scatterlist.h>
+#include <uapi/linux/snp-guest.h>
+
+#define DEVICE_NAME	"snp-guest"
+#define AAD_LEN		48
+#define MSG_HDR_VER	1
+
+struct snp_guest_crypto {
+	struct crypto_aead *tfm;
+	uint8_t *iv, *authtag;
+	int iv_len, a_len;
+};
+
+struct snp_guest_dev {
+	struct device *dev;
+	struct miscdevice misc;
+
+	void __iomem *base;
+	struct snp_data_secrets_layout *secrets;
+	struct snp_guest_crypto *crypto;
+	struct snp_guest_msg *request, *response;
+};
+
+static DEFINE_MUTEX(snp_cmd_mutex);
+
+static inline struct snp_guest_dev *to_snp_dev(struct file *file)
+{
+	struct miscdevice *dev = file->private_data;
+
+	return container_of(dev, struct snp_guest_dev, misc);
+}
+
+static void free_shared_pages(void *buf, size_t sz)
+{
+	unsigned npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
+
+	/* If fail to restore the encryption mask then leak it. */
+	if (set_memory_encrypted((unsigned long)buf, npages))
+		return;
+
+	__free_pages(virt_to_page(buf), get_order(sz));
+}
+
+static void *alloc_shared_pages(size_t sz)
+{
+	unsigned npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
+	struct page *page;
+	int ret;
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(sz));
+	if (IS_ERR(page))
+		return NULL;
+
+	ret = set_memory_decrypted((unsigned long)page_address(page), npages);
+	if (ret) {
+		__free_pages(page, get_order(sz));
+		return NULL;
+	}
+
+	return page_address(page);
+}
+
+static struct snp_guest_crypto *init_crypto(struct snp_guest_dev *snp_dev)
+{
+	struct snp_data_secrets_layout *secrets = snp_dev->secrets;
+	struct snp_guest_crypto *crypto;
+
+	crypto = kzalloc(sizeof(*crypto), GFP_KERNEL_ACCOUNT);
+	if (!crypto)
+		return NULL;
+
+	crypto->tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
+	if (IS_ERR(crypto->tfm))
+		goto e_free;
+
+	if (crypto_aead_setkey(crypto->tfm, secrets->vmpck0, 32))
+		goto e_free_crypto;
+
+	crypto->iv_len = crypto_aead_ivsize(crypto->tfm);
+	if (crypto->iv_len < 12) {
+		dev_err(snp_dev->dev, "IV length is less than 12.\n");
+		goto e_free_crypto;
+	}
+
+	crypto->iv = kmalloc(crypto->iv_len, GFP_KERNEL_ACCOUNT);
+	if (!crypto->iv)
+		goto e_free_crypto;
+
+	if (crypto_aead_authsize(crypto->tfm) > MAX_AUTHTAG_LEN) {
+		if (crypto_aead_setauthsize(crypto->tfm, MAX_AUTHTAG_LEN)) {
+			dev_err(snp_dev->dev, "failed to set authsize to %d\n", MAX_AUTHTAG_LEN);
+			goto e_free_crypto;
+		}
+	}
+
+	crypto->a_len = crypto_aead_authsize(crypto->tfm);
+	crypto->authtag = kmalloc(crypto->a_len, GFP_KERNEL_ACCOUNT);
+	if (!crypto->authtag)
+		goto e_free_crypto;
+
+	return crypto;
+
+e_free_crypto:
+	crypto_free_aead(crypto->tfm);
+e_free:
+	kfree(crypto->iv);
+	kfree(crypto->authtag);
+	kfree(crypto);
+
+	return NULL;
+}
+
+static void deinit_crypto(struct snp_guest_crypto *crypto)
+{
+	crypto_free_aead(crypto->tfm);
+	kfree(crypto->iv);
+	kfree(crypto->authtag);
+	kfree(crypto);
+}
+
+static int enc_dec_message(struct snp_guest_crypto *crypto, struct snp_guest_msg *msg,
+			   uint8_t *src_buf, uint8_t *dst_buf, size_t len, bool enc)
+{
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+	struct scatterlist src[3], dst[3];
+	DECLARE_CRYPTO_WAIT(wait);
+	struct aead_request *req;
+	int ret;
+
+	req = aead_request_alloc(crypto->tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	/*
+	 * AEAD memory operations:
+	 * +------ AAD -------+------- DATA -----+---- AUTHTAG----+
+	 * |  msg header      |  plaintext       |  hdr->authtag  |
+	 * | bytes 30h - 5Fh  |    or            |                |
+	 * |                  |   cipher         |                |
+	 * +------------------+------------------+----------------+
+	 */
+	sg_init_table(src, 3);
+	sg_set_buf(&src[0], &hdr->algo, AAD_LEN);
+	sg_set_buf(&src[1], src_buf, hdr->msg_sz);
+	sg_set_buf(&src[2], hdr->authtag, crypto->a_len);
+
+	sg_init_table(dst, 3);
+	sg_set_buf(&dst[0], &hdr->algo, AAD_LEN);
+	sg_set_buf(&dst[1], dst_buf, hdr->msg_sz);
+	sg_set_buf(&dst[2], hdr->authtag, crypto->a_len);
+
+	aead_request_set_ad(req, AAD_LEN);
+	aead_request_set_tfm(req, crypto->tfm);
+	aead_request_set_callback(req, 0, crypto_req_done, &wait);
+
+	aead_request_set_crypt(req, src, dst, len, crypto->iv);
+	ret = crypto_wait_req(enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req), &wait);
+
+	aead_request_free(req);
+	return ret;
+}
+
+static int encrypt_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
+			   void *plaintext, size_t len)
+{
+	struct snp_guest_crypto *crypto = snp_dev->crypto;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+
+	memset(crypto->iv, 0, crypto->iv_len);
+	memcpy(crypto->iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
+
+	return enc_dec_message(crypto, msg, plaintext, msg->payload, len, true);
+}
+
+static int decrypt_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
+			   void *plaintext, size_t len)
+{
+	struct snp_guest_crypto *crypto = snp_dev->crypto;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+
+	/* Build IV with response buffer sequence number */
+	memset(crypto->iv, 0, crypto->iv_len);
+	memcpy(crypto->iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
+
+	return enc_dec_message(crypto, msg, msg->payload, plaintext, len, false);
+}
+
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, int msg_type,
+				 struct snp_user_guest_request *input, uint8_t *req_buf,
+				 size_t req_sz, uint8_t *resp_buf, size_t resp_sz, size_t *msg_sz)
+{
+	struct secrets_guest_priv *priv = &snp_dev->secrets->guest_priv;
+	struct snp_guest_msg *response = snp_dev->response;
+	struct snp_guest_msg_hdr *resp_hdr = &response->hdr;
+	struct snp_guest_msg *request = snp_dev->request;
+	struct snp_guest_msg_hdr *req_hdr = &request->hdr;
+	struct snp_guest_crypto *crypto = snp_dev->crypto;
+	struct snp_guest_request_data data;
+	int ret;
+
+	/* The sequence number must begin with non-zero value */
+	if (!priv->msg_seqno_0)
+		priv->msg_seqno_0 = 1;
+
+	/* Populate the request header */
+	memset(req_hdr, 0, sizeof(*req_hdr));
+	req_hdr->algo = SNP_AEAD_AES_256_GCM;
+	req_hdr->hdr_version = MSG_HDR_VER;
+	req_hdr->hdr_sz = sizeof(*req_hdr);
+	req_hdr->msg_type = msg_type;
+	req_hdr->msg_version = input->msg_version;
+	req_hdr->msg_seqno = priv->msg_seqno_0;
+	req_hdr->msg_vmpck = 0;
+	req_hdr->msg_sz = req_sz;
+
+	dev_dbg(snp_dev->dev, "request [msg_seqno %lld msg_type %d msg_version %d msg_sz %d]\n",
+		req_hdr->msg_seqno, req_hdr->msg_type, req_hdr->msg_version, req_hdr->msg_sz);
+
+	/* Encrypt the request message buffer */
+	ret = encrypt_payload(snp_dev, request, req_buf, req_sz);
+	if (ret)
+		return ret;
+
+	/* Call firmware to process the request */
+	data.req_gpa = __pa(request);
+	data.resp_gpa = __pa(response);
+	ret = snp_issue_guest_request(SNP_GUEST_REQUEST, &data);
+	input->fw_err = ret;
+	if (ret)
+		return ret;
+
+	dev_dbg(snp_dev->dev, "response [msg_seqno %lld msg_type %d msg_version %d msg_sz %d]\n",
+		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
+
+	/* Verify that the sequence counter is incremented by 1 */
+	if (resp_hdr->msg_seqno != (req_hdr->msg_seqno + 1))
+		return -EBADMSG;
+
+	/* Save the message counter for the next request */
+	priv->msg_seqno_0 = resp_hdr->msg_seqno + 1;
+
+	/* Verify response message type and version */
+	if ((resp_hdr->msg_type != (req_hdr->msg_type + 1)) ||
+	    (resp_hdr->msg_version != req_hdr->msg_version))
+		return -EBADMSG;
+
+	/* If the message size is greather than our buffer length then return an error. */
+	if (unlikely((resp_hdr->msg_sz + crypto->a_len) > resp_sz))
+		return -EBADMSG;
+
+	/* Decrypt the payload */
+	ret = decrypt_payload(snp_dev, response, resp_buf, resp_hdr->msg_sz + crypto->a_len);
+	if (ret)
+		return ret;
+
+	*msg_sz = resp_hdr->msg_sz;
+	return 0;
+}
+
+static int handle_guest_request(struct snp_guest_dev *snp_dev, int msg_type,
+				struct snp_user_guest_request *input, void *req_buf,
+				size_t req_len, void __user *resp_buf, size_t resp_len)
+{
+	struct snp_guest_crypto *crypto = snp_dev->crypto;
+	struct page *page;
+	size_t msg_len;
+	int ret;
+
+	/* Allocate the buffer to hold response */
+	resp_len += crypto->a_len;
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(resp_len));
+	if (!page)
+		return -ENOMEM;
+
+	ret = __handle_guest_request(snp_dev, msg_type, input, req_buf, req_len,
+			page_address(page), resp_len, &msg_len);
+	if (ret)
+		goto e_free;
+
+	if (copy_to_user(resp_buf, page_address(page), msg_len))
+		ret = -EFAULT;
+
+e_free:
+	__free_pages(page, get_order(resp_len));
+
+	return ret;
+}
+
+static int get_report(struct snp_guest_dev *snp_dev, struct snp_user_guest_request *input)
+{
+	struct snp_user_report __user *report = (struct snp_user_report *)input->data;
+	struct snp_user_report_req req;
+
+	if (copy_from_user(&req, &report->req, sizeof(req)))
+		return -EFAULT;
+
+	return handle_guest_request(snp_dev, SNP_MSG_REPORT_REQ, input, &req.user_data,
+			sizeof(req.user_data), report->response, sizeof(report->response));
+}
+
+static int derive_key(struct snp_guest_dev *snp_dev, struct snp_user_guest_request *input)
+{
+	struct snp_user_derive_key __user *key = (struct snp_user_derive_key *)input->data;
+	struct snp_user_derive_key_req req;
+
+	if (copy_from_user(&req, &key->req, sizeof(req)))
+		return -EFAULT;
+
+	return handle_guest_request(snp_dev, SNP_MSG_KEY_REQ, input, &req, sizeof(req),
+			key->response, sizeof(key->response));
+}
+
+static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
+{
+	struct snp_guest_dev *snp_dev = to_snp_dev(file);
+	struct snp_user_guest_request input;
+	void __user *argp = (void __user *)arg;
+	int ret = -ENOTTY;
+
+	if (copy_from_user(&input, argp, sizeof(input)))
+		return -EFAULT;
+
+	mutex_lock(&snp_cmd_mutex);
+	switch(ioctl) {
+	case SNP_GET_REPORT: {
+		ret = get_report(snp_dev, &input);
+		break;
+	}
+	case SNP_DERIVE_KEY: {
+		ret = derive_key(snp_dev, &input);
+		break;
+	}
+	default: break;
+	}
+
+	mutex_unlock(&snp_cmd_mutex);
+
+	if (copy_to_user(argp, &input, sizeof(input)))
+		return -EFAULT;
+
+	return ret;
+}
+
+static const struct file_operations snp_guest_fops = {
+	.owner	= THIS_MODULE,
+	.unlocked_ioctl = snp_guest_ioctl,
+};
+
+static int __init snp_guest_probe(struct platform_device *pdev)
+{
+	struct snp_guest_dev *snp_dev;
+	struct device *dev = &pdev->dev;
+	struct miscdevice *misc;
+	struct resource *res;
+	int ret;
+
+	snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
+	if (!snp_dev)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, snp_dev);
+	snp_dev->dev = dev;
+
+	res = platform_get_mem_or_io(pdev, 0);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	if (unlikely(resource_type(res) != IORESOURCE_MEM))
+		return -EINVAL;
+
+	snp_dev->base = memremap(res->start, resource_size(res), MEMREMAP_WB);
+	if (IS_ERR(snp_dev->base))
+		return PTR_ERR(snp_dev->base);
+
+	snp_dev->secrets = (struct snp_data_secrets_layout *)snp_dev->base;
+
+	snp_dev->crypto = init_crypto(snp_dev);
+	if (!snp_dev->crypto) {
+		ret = -EINVAL;
+		goto e_unmap;
+	}
+
+	/* Allocate the shared page used for the request and response message. */
+	snp_dev->request = alloc_shared_pages(sizeof(struct snp_guest_msg));
+	if (IS_ERR(snp_dev->request)) {
+		ret = PTR_ERR(snp_dev->request);
+		goto e_unmap;
+	}
+
+	snp_dev->response = alloc_shared_pages(sizeof(struct snp_guest_msg));
+	if (IS_ERR(snp_dev->response)) {
+		ret = PTR_ERR(snp_dev->response);
+		goto e_free_req;
+	}
+
+	misc = &snp_dev->misc;
+	misc->minor = MISC_DYNAMIC_MINOR;
+	misc->name = DEVICE_NAME;
+	misc->fops = &snp_guest_fops;
+
+	return misc_register(misc);
+
+e_free_req:
+	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+e_unmap:
+	memunmap(snp_dev->base);
+	return ret;
+}
+
+static int __exit snp_guest_remove(struct platform_device *pdev)
+{
+	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
+
+	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
+	deinit_crypto(snp_dev->crypto);
+	memunmap(snp_dev->base);
+	misc_deregister(&snp_dev->misc);
+
+	return 0;
+}
+
+static struct platform_driver snp_guest_driver = {
+	.remove		= __exit_p(snp_guest_remove),
+	.driver		= {
+		.name = "snp-guest",
+	},
+};
+
+module_platform_driver_probe(snp_guest_driver, snp_guest_probe);
+
+MODULE_AUTHOR("Brijesh Singh <brijesh.singh@amd.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0.0");
+MODULE_DESCRIPTION("AMD SNP Guest Driver");
diff --git a/include/uapi/linux/snp-guest.h b/include/uapi/linux/snp-guest.h
new file mode 100644
index 000000000000..61ff22092a22
--- /dev/null
+++ b/include/uapi/linux/snp-guest.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Userspace interface for AMD Secure Encrypted Virtualization Nested Paging (SEV-SNP)
+ * guest command request.
+ *
+ * Copyright (C) 2021 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ *
+ * SEV-SNP API specification is available at: https://developer.amd.com/sev/
+ */
+
+#ifndef __UAPI_LINUX_SNP_GUEST_H_
+#define __UAPI_LINUX_SNP_GUEST_H_
+
+#include <linux/types.h>
+
+struct snp_user_report_req {
+	__u8 user_data[64];
+};
+
+struct snp_user_report {
+	struct snp_user_report_req req;
+	__u8 response[4000];	/* see SEV-SNP spec for the response format */
+};
+
+struct snp_user_derive_key_req {
+	__u8 root_key_select;
+	__u64 guest_field_select;
+	__u32 vmpl;
+	__u32 guest_svn;
+	__u64 tcb_version;
+};
+
+struct snp_user_derive_key {
+	struct snp_user_derive_key_req req;
+	__u8 response[64];	/* see SEV-SNP spec for the response format */
+};
+
+struct snp_user_guest_request {
+	__u8 msg_version;	/* Message version number (must be non-zero) */
+	__u64 data;
+	__u32 fw_err;		/* firmware error code on failure (see psp-sev.h) */
+};
+
+#define SNP_GUEST_REQ_IOC_TYPE	'S'
+#define SNP_GET_REPORT _IOWR(SNP_GUEST_REQ_IOC_TYPE, 0x0, struct snp_user_guest_request)
+#define SNP_DERIVE_KEY _IOWR(SNP_GUEST_REQ_IOC_TYPE, 0x1, struct snp_user_guest_request)
+
+#endif /* __UAPI_LINUX_SNP_GUEST_H_ */
-- 
2.17.1

