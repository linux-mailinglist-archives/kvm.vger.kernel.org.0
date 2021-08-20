Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D453F30A3
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhHTQCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:02:21 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:20576
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236641AbhHTQBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyJoLW5O1aLGP88kD3Zynk6hgwyRrVINSSHA/dgCdfrrhciCsKjlRpnxnY3Nz1MRQm53Oj8K2AKzWeUxILD5sReqnGyNBoPlWNafaYzoX0fR4a4b42IBBUsttsJMJa11lu9xx6bUvoJ8/54pGP0dUiZilDWzjKi0Ody0vjIu9QZNhmtOHSVQE+CeukFy2V+oPN2vEzTE4YYoIq4qLXKpaGnqz+IwXksEFotKgBlVGRdHVhsswu6Pt0vmv5e8disILZ6Qz+nQVemOX/zEPSe1Bzr0gHSZaOReaTS5qholcTF+IxCg6n+7g2mNDiPkIeyVYHlQ9KHFLaONEqCh2Hjaag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPryMDZPhO3hrlwHpI7SXBuaBntaQGIugY6Hne+e64k=;
 b=CHcgYCwVteMFmjdbiwLJMF58YCp+tLqEgvOhnH7+SkETvvCEG6gR+dBaF58VmGsCbCIN8lohxV9Yd+Rs3CxD0PHLap05tLXnCjHnMwNapXkNTBXE4R+C3sp2+qygWXAIU5F1LzwI4ZgZ4o48xjhLpcy7hPwOpINGvbEAQMScsNCQXEiCV2gYzCu0R3jIO/gh64Im/8Fz+CKGfPEz3rGA2CpnSv0CdYrPBQ7lkjhonBbazRjXvf0PAqI84+9Zuepzxip0sqaglImzwfwYMTBxEApG2ibCVDaseaL40LW0fs7IfpWSzKAJ08PpR329N1Fg6yaBXblHhIOUqxIp9EH9Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPryMDZPhO3hrlwHpI7SXBuaBntaQGIugY6Hne+e64k=;
 b=2Z222RL77BnhH2MsEN9inZ5VRoXu+qB0WLvXOBGEevKZHIkUCGIU/B/+CTx887J8QYt4iE/MiNsRAS3M3WhTWmm9zszBHNBs3jWb3SBJu9qcUVJUlI5zZ5+whb8XcI26NL4cbr6v14nES1bjNk4Louj2XbNdXha4tknAb/OntGE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:15 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:15 +0000
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
Subject: [PATCH Part2 v5 17/45] crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
Date:   Fri, 20 Aug 2021 10:58:50 -0500
Message-Id: <20210820155918.7518-18-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f4e2e4a-cb99-447f-3ddb-08d963f3998f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26855823D6CBEDD04F964679E5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DK4nXC/nrczRpi2HIgXAbdsX9yu4edu7SVcED1tgp1LNHQ0/7oYAOaeYBeIGt9/msqCuuhPQoakxlbMOsbDZ+R2IIEj5CwqzZiVSlnEhr69r7uV2Ego90u56GpVKnkWr6rVEszxMm6J4X5wIDtH9ly7woCZYGyrIpJqfPpsdr8I911WEzLPnf4OcAjAP+pYDJrmXmg/L9BbGwiKm/ARAgvmpnGNVpTZeHPO6ww+HIjECDSLZRMjgqbOLD7EqbBKWsbqtSf2ldX5ytREHNHPjCOrtUUV5Rss6Sif0NOqb/UUWEO6v2SBHiJ7sEsXIDaJFIw+UUrGZ7rfSO5pOjrg4/DIZVNNNbHSk713Cmp1jJeRfElY1qjmm8OLQP0XQm5hcfEqygZjnUWi4uG6ns4CMOAW2yt1KdwebsO66Uf2uWGAv/H7X2DaKUKdtao1lNgEQ8bnnHoCLWO1RZITvAcWCiIF9hPg4mH8Yppxi11lb+u1DfqKa5oQAzL12AU5ELBFJOgmplpTyOEX5IBlSV35rQLX0xcmZL4qB90qS0ZUeNrgqikvDlaxTGWn5rFamj9eqqgFtHqX53FWhyBmAP9pnmcvvFs8Hl5uErVvzeEthBY27OmIbQqGZGc185czn+otVCIuVXwnwvYXA3SiKuWoZJdtRbFCzReMZeFbhnjVjtrgQg/sGTh9JwYDLZJksj+DOjKWEJ6C1GbEZBMt8fuwmAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(83380400001)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2mPR26Q76+y6D+T1Gngm7zAdWpRTu8NbLl6hSK6me/YmXHaDbKvDa8X74N4T?=
 =?us-ascii?Q?0T08kfke5OzdaO3NZ6PIlbydKwGsU8Ct4z8KvjVp9g5Vo00stkVP5EbRjzCq?=
 =?us-ascii?Q?WLgsEJL4Dc0swJBglaUtLyjZAmi4ZC5yQkeXPaefii/QnwuE/FXFSz05lV63?=
 =?us-ascii?Q?PgnLViZxzyF6yDZ9Def2dA0A9o17+vzKdBE0rVwqmXd2dSrN4Vp6+Tu16aVH?=
 =?us-ascii?Q?kyP9cdOf314qWprcNcf4+MuWbPKpZAbX3myFs8BDVOhkEjyqPUtOeZLSi7w8?=
 =?us-ascii?Q?VT5LaM/7Ad0lbh5TQBHtAQWzSncZvNAmR4eJ6nSIywBBE4R+PXkQaB9ksRFu?=
 =?us-ascii?Q?OZ+Z5zz21OGbJfjqnS009rPFh9LClfC0g87JehQZndqF4C29NzYbFBJVnM6O?=
 =?us-ascii?Q?DiwIMYyl2dEdXLSpuVR+DBZQ/s2xMAh8YHX28uDZI4b34MqvnaCo+8Od26Cm?=
 =?us-ascii?Q?2soeCU7fImYryHzxVn32clq+gW08TxP95v3vEktFPFHD4/eagfky1OEhCuo9?=
 =?us-ascii?Q?+dD0OPlDI1Wj1lCKNHkBO7yEqfh0GK9bIC+nB7A7b/1wGx/1Ges5dT4fXxaT?=
 =?us-ascii?Q?5ZQzWEjBFy1eYkMXomuZsRQ/M0r191K5qnOZuEvYa1a90TFMV1UAPFLI88RM?=
 =?us-ascii?Q?4fDjWRkAoTMD94gsG8hjtS7fk3D7mgSsGRyRtrRiFmg2EVRzBxPeHRUOgbhh?=
 =?us-ascii?Q?4O3VmLIcyD5Sux/EERG7k1tjyq0d5ScrrxnEWbKkjnwYkYw7m8BU1d81wwzi?=
 =?us-ascii?Q?fDclAm3LOKYf9liWgpvhwmbzgFbwRlmA9xnKNAIAeJBCqNdvDlD1rbItc7kn?=
 =?us-ascii?Q?t62KgBUT1jJG1PjosBN+Yv1Ed2d2fMK/apkwojdrv4D1UssR4j8FFgD0Wz49?=
 =?us-ascii?Q?XbDQuO7/bFi8/MgK3ChKjSKo29gS/GUfI5F5zyX4TblAGFypH0j/Y2Q6ujGV?=
 =?us-ascii?Q?NsZmEaunPScfHuLK7t9Dl4DsScRBDtzijOKnFlEWprCmJ73Nl4AJtJWHoP4N?=
 =?us-ascii?Q?fyBq6jAO8donKdJgZqMSXhyTI07jQf7GEfDwWDbaGtzk+3Lpr3MKYKEYHNKs?=
 =?us-ascii?Q?5vd0ICLuklLkR81XpCQ1BruT66tM7/MrdGjNI7yDknGTL8Sh4CgkOn/AeCFQ?=
 =?us-ascii?Q?TSFfLmkuyTCHlV2ag5N1cSuFNkR4C4Cy4mSwI3u8cCgsIuRpAiJM7pa/DfEp?=
 =?us-ascii?Q?2Fi+x5HDlehJY+9LGgQqyn/IDyj0DHk0Likwmxun0G1AnUq7r058Tz3DTBr8?=
 =?us-ascii?Q?68VLBJrjcpj5ZpjWw+1Dz998z57eh5vR83FuyNIzHmwLkA2SDuLzKkIXz3Iu?=
 =?us-ascii?Q?iV/jgMp+sj4p8tM1AjZSTcSB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4e2e4a-cb99-447f-3ddb-08d963f3998f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:15.6338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPVCjv9uBVpLnfjXPV2x6AIjA2LiVHnCCYC8furGCRDVYydPKJzyIirCBHzZ++1pIf2tsW8usbF+XnMpASuf8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP firmware provides the SNP_CONFIG command used to set the
system-wide configuration value for SNP guests. The information includes
the TCB version string to be reported in guest attestation reports.

Version 2 of the GHCB specification adds an NAE (SNP extended guest
request) that a guest can use to query the reports that include additional
certificates.

In both cases, userspace provided additional data is included in the
attestation reports. The userspace will use the SNP_SET_EXT_CONFIG
command to give the certificate blob and the reported TCB version string
at once. Note that the specification defines certificate blob with a
specific GUID format; the userspace is responsible for building the
proper certificate blob. The ioctl treats it an opaque blob.

While it is not defined in the spec, but let's add SNP_GET_EXT_CONFIG
command that can be used to obtain the data programmed through the
SNP_SET_EXT_CONFIG.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/virt/coco/sevguest.rst |  28 +++++++
 drivers/crypto/ccp/sev-dev.c         | 115 +++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h         |   3 +
 include/uapi/linux/psp-sev.h         |  17 ++++
 4 files changed, 163 insertions(+)

diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
index 7c51da010039..64a1b5167b33 100644
--- a/Documentation/virt/coco/sevguest.rst
+++ b/Documentation/virt/coco/sevguest.rst
@@ -134,3 +134,31 @@ See GHCB specification for further detail on how to parse the certificate blob.
 The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
 status includes API major, minor version and more. See the SEV-SNP
 specification for further details.
+
+2.4 SNP_SET_EXT_CONFIG
+----------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (in): struct sev_data_snp_ext_config
+:Returns (out): 0 on success, -negative on error
+
+The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
+reported TCB version in the attestation report. The command is similar to
+SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
+command also accepts an additional certificate blob defined in the GHCB
+specification.
+
+If the certs_address is zero, then previous certificate blob will deleted.
+For more information on the certificate blob layout, see the GHCB spec
+(extended guest request message).
+
+
+2.4 SNP_GET_EXT_CONFIG
+----------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (in): struct sev_data_snp_ext_config
+:Returns (out): 0 on success, -negative on error
+
+The SNP_SET_EXT_CONFIG is used to query the system-wide configuration set
+through the SNP_SET_EXT_CONFIG.
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 16c6df5d412c..9ba194acbe85 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1132,6 +1132,10 @@ static int __sev_snp_shutdown_locked(int *error)
 	if (!sev->snp_inited)
 		return 0;
 
+	/* Free the memory used for caching the certificate data */
+	kfree(sev->snp_certs_data);
+	sev->snp_certs_data = NULL;
+
 	/* SHUTDOWN requires the DF_FLUSH */
 	wbinvd_on_all_cpus();
 	__sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
@@ -1436,6 +1440,111 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_ext_snp_config input;
+	int ret;
+
+	if (!sev->snp_inited || !argp->data)
+		return -EINVAL;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	/* Copy the TCB version programmed through the SET_CONFIG to userspace */
+	if (input.config_address) {
+		if (copy_to_user((void * __user)input.config_address,
+				 &sev->snp_config, sizeof(struct sev_user_data_snp_config)))
+			return -EFAULT;
+	}
+
+	/* Copy the extended certs programmed through the SNP_SET_CONFIG */
+	if (input.certs_address && sev->snp_certs_data) {
+		if (input.certs_len < sev->snp_certs_len) {
+			/* Return the certs length to userspace */
+			input.certs_len = sev->snp_certs_len;
+
+			ret = -ENOSR;
+			goto e_done;
+		}
+
+		if (copy_to_user((void * __user)input.certs_address,
+				 sev->snp_certs_data, sev->snp_certs_len))
+			return -EFAULT;
+	}
+
+	ret = 0;
+
+e_done:
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
+static int sev_ioctl_snp_set_config(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_ext_snp_config input;
+	struct sev_user_data_snp_config config;
+	void *certs = NULL;
+	int ret = 0;
+
+	if (!sev->snp_inited || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	/* Copy the certs from userspace */
+	if (input.certs_address) {
+		if (!input.certs_len || !IS_ALIGNED(input.certs_len, PAGE_SIZE))
+			return -EINVAL;
+
+		certs = psp_copy_user_blob(input.certs_address, input.certs_len);
+		if (IS_ERR(certs))
+			return PTR_ERR(certs);
+	}
+
+	/* Issue the PSP command to update the TCB version using the SNP_CONFIG. */
+	if (input.config_address) {
+		if (copy_from_user(&config,
+				   (void __user *)input.config_address, sizeof(config))) {
+			ret = -EFAULT;
+			goto e_free;
+		}
+
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+		if (ret)
+			goto e_free;
+
+		memcpy(&sev->snp_config, &config, sizeof(config));
+	}
+
+	/*
+	 * If the new certs are passed then cache it else free the old certs.
+	 */
+	if (certs) {
+		kfree(sev->snp_certs_data);
+		sev->snp_certs_data = certs;
+		sev->snp_certs_len = input.certs_len;
+	} else {
+		kfree(sev->snp_certs_data);
+		sev->snp_certs_data = NULL;
+		sev->snp_certs_len = 0;
+	}
+
+	return 0;
+
+e_free:
+	kfree(certs);
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -1490,6 +1599,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SNP_PLATFORM_STATUS:
 		ret = sev_ioctl_snp_platform_status(&input);
 		break;
+	case SNP_SET_EXT_CONFIG:
+		ret = sev_ioctl_snp_set_config(&input, writable);
+		break;
+	case SNP_GET_EXT_CONFIG:
+		ret = sev_ioctl_snp_get_config(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index fe5d7a3ebace..d2fe1706311a 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -66,6 +66,9 @@ struct sev_device {
 
 	bool snp_inited;
 	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
+	void *snp_certs_data;
+	u32 snp_certs_len;
+	struct sev_user_data_snp_config snp_config;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index ffd60e8b0a31..60e7a8d1a18e 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -29,6 +29,8 @@ enum {
 	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
 	SEV_GET_ID2,
 	SNP_PLATFORM_STATUS,
+	SNP_SET_EXT_CONFIG,
+	SNP_GET_EXT_CONFIG,
 
 	SEV_MAX,
 };
@@ -190,6 +192,21 @@ struct sev_user_data_snp_config {
 	__u8 rsvd[52];
 } __packed;
 
+/**
+ * struct sev_data_snp_ext_config - system wide configuration value for SNP.
+ *
+ * @config_address: address of the struct sev_user_data_snp_config or 0 when
+ *		reported_tcb does not need to be updated.
+ * @certs_address: address of extended guest request certificate chain or
+ *              0 when previous certificate should be removed on SNP_SET_EXT_CONFIG.
+ * @certs_len: length of the certs
+ */
+struct sev_user_data_ext_snp_config {
+	__u64 config_address;		/* In */
+	__u64 certs_address;		/* In */
+	__u32 certs_len;		/* In */
+};
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.17.1

