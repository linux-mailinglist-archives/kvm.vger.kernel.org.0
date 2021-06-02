Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FEE398C21
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhFBOPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:15:07 -0400
Received: from mail-dm3nam07on2058.outbound.protection.outlook.com ([40.107.95.58]:30496
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231577AbhFBOOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IlrsWkbIRI5WR73zbkyQdUSqA1DxyWADxEKiONXPzUikgAZhk10nF3HiaDGI1LfXkVVCaR7yaFIcii+EXsnE7+4HF4RzZyd2cqOibem3rRvXYrqrDr4/DmM26c6BcrzO3UVkJLgnuxbH5Q1RoxcWcatwi9E6KQ4UjHRs6ixwlafx17oIy7T4T2j6cjHyj588njh1u6HpNdloRFd6Zinjw6fBmHe6fJ6BNwiIA7KduXhgtcfx6VDm9FlqLPNEgAC8CytzHJquYSicStgBtfongXnvgqgYdALYbM+tGkPUry7woGdYJ+OoytLg7bGcNhp6ozZsUTpnoXrUWzAdQ/0u/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCVBTJ4FkMf/LVJ8T6ab3ZBuJBaCUbSHHcaR8JsMZ44=;
 b=SlHc5CSL2xnizRhyYV3Xit/CamOV6ftEjy6Yyc86WnaZl2yILY43VK9v7TPx0QA/tkJ6frd9dNgJzX9O2SeY1yVzSBBBuMm/EcMaXac0WDUlzCSYHvs0k0F/Y75KmKv7owTxqsX7GFGH2QFXuWZxgc1T7SG9JBHuEaut5mpmUAxe+KjVfP813fzYkH3+L96viTk671+mgX2c/W92PT99Y05GZkMArVqTDi1Ukj0XWL4R3kBt/4cEDRb70n7vDkYFIWYzTPnl1Bm2XNkweysaYOcRqwWpDvaltqC0UykTAoXNGcnxqUi4cINRt1GOgm6VOAmt2cGd46YCB81uH0Fnlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCVBTJ4FkMf/LVJ8T6ab3ZBuJBaCUbSHHcaR8JsMZ44=;
 b=ZXp6XVQYooibXtonB/puQ/5gJyKtCB3T9+r0671zW37MmVfc412LiBd6IXn5kzipUXTDqI1GurIj7+Je82RnfWISHveq8ila9fsZ22WytsWnWj5jAX0XC9GnvAnNEeErsD02ZGEZGgeDl3eeGLa9cSK0dc6C3MbV7uTtjqUXXS8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:45 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:45 +0000
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
Subject: [PATCH Part2 RFC v3 14/37] crypto:ccp: Provide APIs to issue SEV-SNP commands
Date:   Wed,  2 Jun 2021 09:10:34 -0500
Message-Id: <20210602141057.27107-15-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99290dbf-bee0-415c-1b7f-08d925d05aa2
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495E4D24774C7205369FF3FE53D9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2iiSJzswINHcWpY18ijCQO2JcTsmPWeRT+m7JOEc4x/KTdmwxL1d/crWE7+RQKExIsHq+oV0CBFjKbF4ecu82GFUT1Xz/1VPGdGHnUUPUNG6Zbwd+khqZi2E8SdFp3mWsltM16gDzSGU26otYk7YUuUn8XNqM/cc6PznXSxWpoEQvqtq69gAzR7cMrUGwguFfMbB0WiwZk6+nEhcaOAXtak3g4EAdWPh2ibhQeao73FoVjk9MWG0vvjOEbizemukHwNQa4b+DdQ22jVl1z88s22vYygelLMefRGqA41WPoEKlEQGqLAfQAm6roGYiJuxXDJeG/vUOtrstRJP38WpOF5EBSQwFyq4cQ5Zu8tOOvdy+k3X45hkay9pD9JWW6MTNgiXUCaB5VvzQJRgCwR4id7+aZANap+XgWzUP2uDUH0KzG3lVhSjxvAo0I+jK6d3QqE2qemFEVwGGXkpwK2eHwcoX05+HfyTS2/QLR7MBm6XUX4u82qxTWq6tLaCarna5DceQMJVmufpPLOf6mY25RPOH6GJnFM0cPACpAkHUUnbu7As0D5vZTUgJwrAzOTxGAA428WMC4eL7S542FmM+lq1KDnL/Hbe086tEXIaEp0chvkBfqTiPGDL59Iv72p2Ud4vU98stmDpR6M5a9uO/zhZ3vrOfUEQPnHFfrF31BtG5okaRbHc8tMVhU38Ny6K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(54906003)(44832011)(8676002)(2616005)(956004)(478600001)(6486002)(316002)(86362001)(4326008)(7416002)(6666004)(38100700002)(7696005)(38350700002)(52116002)(16526019)(26005)(186003)(2906002)(5660300002)(66946007)(8936002)(36756003)(66556008)(66476007)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SduIdjJww+g3wrgRqbbatnozuZ9wsshODX5es3yuPxgOgkiH3RWAm66I95XB?=
 =?us-ascii?Q?6Dk3Q91FWqT/kdEVjglsWh4joSCBD7dRSnGH0ZT3bcclsQHBEkMOHHCtNVat?=
 =?us-ascii?Q?vmLg5bVyDpgXfRoB+EsA0TdQ1FjZ7GtsZC/Vn20zrxIxDP1LwmirlRUP2rcM?=
 =?us-ascii?Q?PyIMjXvGSu6FBjiNCUizjVCal+Ch+1nc0816t6RXhsA6r23QrCqDCRkTjWAF?=
 =?us-ascii?Q?1M0XCViisPv1X68UWKI9aaNZtgVW2L84t5YDrELkV2Nf6G7myP88ZOAn5MZj?=
 =?us-ascii?Q?vqVw2rYEqAUgZKeHtHKUoDZMNkyD/A1pqeEpAWHWEVAtn/jPAvUuCtW/iRzG?=
 =?us-ascii?Q?3ey9Z5lkIrhWBvWeUqy5w1x6yqFYBgEt6PHOWZo2o04ov4R9imDnhtj02FKp?=
 =?us-ascii?Q?SlpM0b6yzyh80dV9gVy3Fm183+6FEv6Yhlq63w6o2BwZsAWtv9T50RuqesGJ?=
 =?us-ascii?Q?rxWfzIFMm9QDpGMO7JQDYuiiX07xdnfZFLRVkpDMO9j0uyjeodFBqN6p2YfC?=
 =?us-ascii?Q?Eb9Cs4XK1b4ekCRALkRyO6aDG+7tC3dL3JzK3j+nkDrlA8XL4bB+1XNR7mOq?=
 =?us-ascii?Q?Mz6ZWUNvlkPS9qzch1aEpb1ZyOIWtUh/NZyqi0lVQA+7++o0rTb69ysbEixp?=
 =?us-ascii?Q?kvXgft6nEx86NDeYtahMtd1fUeKsNSiQy+rJRzCn4hPhedqTMI5KPmwVDyhu?=
 =?us-ascii?Q?R8TuMgeGsat647O+CSDEDloepwqijiwUTT1mPfrgWte6Up1DpzwrYaZFR2eu?=
 =?us-ascii?Q?sxQCtZ7ALPet8yAacCG26OgNqz5Mj0OcXbwuizMXUE3pujax+OqaguC9H9re?=
 =?us-ascii?Q?uRZXHkQJuJ5frqGxKjh9jNEYJISAaSZ4Km/3cHTaBR2kMhLWbTUd9xUiiRFe?=
 =?us-ascii?Q?Jacf1JexvQrZ0mEB/VxFvrPANqGy7z274U1aD5RgeVn2CpXwItk4FYgxJqs7?=
 =?us-ascii?Q?GM3Lh7tESlPu/JSfTWX+n/wM4JZl6Pte8NWarHhgDxYjs5cKqAG7PVVllp7O?=
 =?us-ascii?Q?WKr5e11rAptWnPLKewhMwZvpL5l7iCzORxqDOYPb3fqE/kCOrGVeziClnIU3?=
 =?us-ascii?Q?i9U3ioYx4VqQDjpxh13r+FM+LG9er76Nm/pVFGIIBVN1YHfVczRvCnBGDpJp?=
 =?us-ascii?Q?xLTHmKxEIOpEEFfv2Lv5rP6iDYaAWgiqRerdJBH+9MbQ+6gC+XDh5Oa2pr3F?=
 =?us-ascii?Q?++Yf+JqS769OkCWAMQJ+8BU5iNiJiaftx09ewHjyjEE8jJ1X+FTMb/cGakiC?=
 =?us-ascii?Q?VBLnW4VR7UesRUUPr/8n1I1+A0JMg042NhBKJVpxgDIieXhBcJ7vGWFUYTQk?=
 =?us-ascii?Q?yYn8Mla4KLjTsLiex7NmAwEG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99290dbf-bee0-415c-1b7f-08d925d05aa2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:45.5573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UCMficEVXTd0Zx4QMYOHqU+i3lubG2CbkQ6owAQoXDwa7xTFe2gWmCqArgE1CyZfnilznBi1OKql4LbYKbJBTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
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
index b225face37b1..def2996111db 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1014,6 +1014,30 @@ int sev_guest_df_flush(int *error)
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

