Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B423F30D4
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbhHTQEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:40 -0400
Received: from mail-bn8nam08on2075.outbound.protection.outlook.com ([40.107.100.75]:31200
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235058AbhHTQCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vi8yQUMocoZZEWXkCN3mBToS2YYUoPmELCVT9z/Yj6zwUfk1r8KDBfwjCnZ65yG2tb2OYaVCCRk5ZgCYymptCtjV7xOzsfsdEVNCR+PdgPxEl5uNbdvbXbCB/iiWUoy1V4JuU+8YiPot0k+jRAH22kr25VXR+NCPlgk7XHx/pi0779H1Tz6hlt0Q4eyl+9DJDvOFx9xwup0wSwaUVaSaViaon88nLwIetM6jspjz1IZqL2mZc8Ti75AXFAqed0lieN76m8tN9lL523VgkCRVPS4gS+YHtwpIre9iQLX4ufu9oVs+oxK5L/jPE5OVMIdgWqS6qr133qjEJFeSo7agVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMkse73w5tkrzdj6pQpvphgcrT0KVFGyNiLZybif57c=;
 b=H9sH4FPiimoMYKorTlLOyO6Xu90PZbOUbuFvjl0+9l9P8wiqvaOpYYxoRJAmJzMHLg7WI0sJD1GflwVby8zTvTs3NxUwOQD2epLp36HOx7jr8V3nuu9/l2I26mYRXUF6NcOOuzV7MtK83aY4HcDrcqqNJkL7CM66Qlu22sZ2XFD6jzr+WW4vR1YhGqNrmXO0OvGzj9QfF4INfXnWenjhEvSeQLzVJPt4f4BPf3Xc9HcpqtYg2EZMHRrRzMNVe3kWFsrB7kgApXXq9c8oNn5GCpk7U81USCseN8CuQ5IHvClV+2LPF1MBWN4xMIifaBci4NRwO2WfLUWHttonu40C1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMkse73w5tkrzdj6pQpvphgcrT0KVFGyNiLZybif57c=;
 b=noBzu8q0+X+tnH5qzgThLvjgpysmcrKuuXa4YLqdchtLOzbyqty0t9L/jz5HEW11Ug1HQYY4vrRuknZ3i93AUnibknbu2FQ4TlRAkpqPhvNIUFuqKSTWhMEjUIU2OV0dJK7WZECt8yC7rY6H10RIdxvW4jSOJYqVJ5AsgS/a0b4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:09 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:09 +0000
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
Subject: [PATCH Part2 v5 12/45] crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
Date:   Fri, 20 Aug 2021 10:58:45 -0500
Message-Id: <20210820155918.7518-13-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 270ec9a8-c7f7-464b-c08e-08d963f395b0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438423E15B430EBF8BA92980E5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/IlW31MjNaFoU1JexA1GoeMjJs/c6SxsziG3zx1EZqdBhLX+fC1XaI+9KsFClIveumzAxHVuHTL4G+q/vial8WzUFUx01kreUPn9vm8EdRaRAhxc9CtNywA4kYRQx+Iv3VAsffYp2Ns5w7yWLfVJqn4Ur3ZZagOBF9nw9NFtx0NQnDokH3B6Y5zl8R2J6HA2acaII3aF6I5S9xLelI8P00hbJR7xKTJSXt11BEiknLXZXHsJE3f+ikLb1iL4lGtdMo+J3OC5q2hdUPyeYfgTpoDNQ1VtdLUGa9ef0WKzQvRM7XDZhAf5mOkw7SCr2A1r0za+RmNemdxZ4MchzrboAGcN9IEW4tj4K7e3RIsHwU3JOvQmqyYHCvEICYIMymber1zkDjv3IRqQAqXMeugx2Zwls4PxWPfoIBXlDNotIbJxLCtBkOBIbOjCxuFi2EXTLQk9kTPoGE83JiZXvuDcYlsNJhNM8O3uk62iHW6m4clgS4HRNZxLSbvn7c/yn4/7dJKAOVhQgQeT5KMuLD6o+OQFCpTuUwR1ud02rUWd8Rlyj1ZOw/n5qHz4FEX8EEFbrcVhHSLSUUYOZpdY2gPPFSVxZmPw8EZMZXtVZVxrwzhowQsAtpnqcPtR+pXpfxJ47+LvSGRtgMaXS19wRHA8Nm8u7G7JVG4l+ULBNkQMxB6037eFbvwV6mZGhueEQ8NecEA8hxEOCvCj1z7A2Er3MulWxdScQmuDnmDQNKoQfM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Fg254qmYiqXqdF9sAfE5/gsb18pl2arLxPXo3Xgh5kfKUjNJJTHIHgsFCzZ?=
 =?us-ascii?Q?RZONoF2aAB9sq6vfJbmGzbqG/a4EneuoaQODwV3pdzBxYppw/UKhiJFM2Drp?=
 =?us-ascii?Q?H9U/WdIDiO+h4a/ccBRQAw5z006DPefbil8N3Td8uRRsOem8xXoxba127EA3?=
 =?us-ascii?Q?mLRu3dbCvqVL1iL3FzeDmBp4e0fz1FBKJCfpLIUPoIyFC66yK9raKuSR7MiO?=
 =?us-ascii?Q?dJ5/OxbyBx/PHjrTvDTiC5QDjgZewnL0Ga2Vj0rU9c5+ld4PKogcot0Aeo0l?=
 =?us-ascii?Q?noMaGGGES1F6OVg8re4NnUSWOtb2G4KK6UEe2ldn2xrYDfsvP7qiy7C2RIxj?=
 =?us-ascii?Q?UouE51SRAAciAu/L2X44TuwZ1YFfLDgotHcGaFQbeP6c9T/DgQgMoKAP39On?=
 =?us-ascii?Q?d8F+OLsW5tE9JvvSV0fK9Yqkj3tizQKrsa9mkk8TlKp4HrlsPZCZ3A8ZJ2tW?=
 =?us-ascii?Q?1aWUu8grMmeVD84ug/qH5kngUmrWhlK199yqqLFsk7yAdCD+WNK7+cXa0IFl?=
 =?us-ascii?Q?Sh+YeKYyl5mPpEdGjEt7lIIfD/lR2eRu6s0IAm1D0rrj0ActZAiGibcDioRV?=
 =?us-ascii?Q?4COBy0/w1o7QMyrcpcPr6SFQDdShrDl/UnkTHTVnd4FhHFFXowUIhNnp9vgE?=
 =?us-ascii?Q?CE465wV/+iHjclUepzaf0LYRTY4Ir7VU/PtmtLKL50MwwlZiLXiFQ/QjCV2O?=
 =?us-ascii?Q?WpZotIiz7gr3PdC+Vvp+dLlaqeN/FH+araooWM5pv7PstSWhStUYjGa5e5N3?=
 =?us-ascii?Q?o631oUUqMPsAjomNiRaVqycU2ESeb03YpUDJT1zMXHGAwO/m57V9lBsyQ3vb?=
 =?us-ascii?Q?QW7VG4SqGbmfydvKp4m1JFOFffG7m81CVyzA/+T1Em4CKgOIkUIo6FbM8ifP?=
 =?us-ascii?Q?zWUiai51e2B3hx+q/BmPe6EssfJXB2hVAOjp+rOcsDK6VXIr+FjDlsL3Pfa+?=
 =?us-ascii?Q?hfFqYPfZyue0ugzzh7dCrGQWRLEtUgCRiZjp9uzXdb4VzCEsULRX0mV3V7UI?=
 =?us-ascii?Q?zqRegGKl6KCGS8GTQ7Ibja+3IGsjfWH1EWTrn9DTv1l4Ro5HST1T1Ed/4Ayy?=
 =?us-ascii?Q?EowrenokXKq0lEwZkv8z18JM1XQEmdZeHIO+n5pJK2VGpn63LfG6JJOIccb3?=
 =?us-ascii?Q?Q+ao5mly47W0BrbB8SNi5QmfReAiyRN25hEk5WvXrB6w9TtWOR35mv9nu3Qs?=
 =?us-ascii?Q?qZlJKsKnzd99ebTvhuffWBsYGuDsP8f2ncazjkmc1yA3fU02399UuwZWF4HR?=
 =?us-ascii?Q?wls0yYm0x/lJx9rEWvp3gIGK+TU6kgZe5b+EELeNYXEvEQOnX7pRtJNaLcIp?=
 =?us-ascii?Q?AfQQjqKapTVxBq6XRuIgoVwU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270ec9a8-c7f7-464b-c08e-08d963f395b0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:09.1436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5qul4Q+SJoYs6cYAq7NNApadBumCcSx4L7lTLL/kw6459FwaisjDLj8KShRB9Lerdi8925fFKy72YU8UirdUXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before SNP VMs can be launched, the platform must be appropriately
configured and initialized. Platform initialization is accomplished via
the SNP_INIT command.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 123 +++++++++++++++++++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  16 +++++
 3 files changed, 136 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f5dbadba82ff..1321f6fb07c5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -32,6 +32,10 @@
 #define SEV_FW_FILE		"amd/sev.fw"
 #define SEV_FW_NAME_SIZE	64
 
+/* Minimum firmware version required for the SEV-SNP support */
+#define SNP_MIN_API_MAJOR	1
+#define SNP_MIN_API_MINOR	30
+
 static DEFINE_MUTEX(sev_cmd_mutex);
 static struct sev_misc_dev *misc_dev;
 
@@ -598,6 +602,95 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
+static void snp_set_hsave_pa(void *arg)
+{
+	wrmsrl(MSR_VM_HSAVE_PA, 0);
+}
+
+static int __sev_snp_init_locked(int *error)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+	int rc = 0;
+
+	if (!psp || !psp->sev_data)
+		return -ENODEV;
+
+	sev = psp->sev_data;
+
+	if (sev->snp_inited)
+		return 0;
+
+	/*
+	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
+	 * across all cores.
+	 */
+	on_each_cpu(snp_set_hsave_pa, NULL, 1);
+
+	/* Prepare for first SEV guest launch after INIT */
+	wbinvd_on_all_cpus();
+
+	/* Issue the SNP_INIT firmware command. */
+	rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
+	if (rc)
+		return rc;
+
+	sev->snp_inited = true;
+	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
+
+	return rc;
+}
+
+int sev_snp_init(int *error)
+{
+	int rc;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENODEV;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_snp_init_locked(error);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sev_snp_init);
+
+static int __sev_snp_shutdown_locked(int *error)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	int ret;
+
+	if (!sev->snp_inited)
+		return 0;
+
+	/* SHUTDOWN requires the DF_FLUSH */
+	wbinvd_on_all_cpus();
+	__sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN, NULL, error);
+	if (ret) {
+		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
+		return ret;
+	}
+
+	sev->snp_inited = false;
+	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
+
+	return ret;
+}
+
+static int sev_snp_shutdown(int *error)
+{
+	int rc;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_snp_shutdown_locked(NULL);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+
 static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1048,6 +1141,8 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 			   get_order(SEV_ES_TMR_SIZE));
 		sev_es_tmr = NULL;
 	}
+
+	sev_snp_shutdown(NULL);
 }
 
 void sev_dev_destroy(struct psp_device *psp)
@@ -1093,6 +1188,26 @@ void sev_pci_init(void)
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
+	/*
+	 * If boot CPU supports the SNP, then first attempt to initialize
+	 * the SNP firmware.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
+		if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
+			dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
+				SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
+		} else {
+			rc = sev_snp_init(&error);
+			if (rc) {
+				/*
+				 * If we failed to INIT SNP then don't abort the probe.
+				 * Continue to initialize the legacy SEV firmware.
+				 */
+				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
+			}
+		}
+	}
+
 	/* Obtain the TMR memory area for SEV-ES use */
 	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
 	if (tmr_page) {
@@ -1117,13 +1232,11 @@ void sev_pci_init(void)
 		rc = sev_platform_init(&error);
 	}
 
-	if (rc) {
+	if (rc)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
-		return;
-	}
 
-	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
-		 sev->api_minor, sev->build);
+	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_inited ?
+		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
 	return;
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 666c21eb81ab..186ad20cbd24 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -52,6 +52,8 @@ struct sev_device {
 	u8 build;
 
 	void *cmd_buf;
+
+	bool snp_inited;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index c3755099ab55..1b53e8782250 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -748,6 +748,20 @@ struct sev_data_snp_init_ex {
  */
 int sev_platform_init(int *error);
 
+/**
+ * sev_snp_init - perform SEV SNP_INIT command
+ *
+ * @error: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int sev_snp_init(int *error);
+
 /**
  * sev_platform_status - perform SEV PLATFORM_STATUS command
  *
@@ -855,6 +869,8 @@ sev_platform_status(struct sev_user_data_status *status, int *error) { return -E
 
 static inline int sev_platform_init(int *error) { return -ENODEV; }
 
+static inline int sev_snp_init(int *error) { return -ENODEV; }
+
 static inline int
 sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }
 
-- 
2.17.1

