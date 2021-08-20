Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836423F3094
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhHTQBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:45 -0400
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:53792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238185AbhHTQBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I20tG+bPSMAZDABkHoyDnvWkcUgRWyY7V0ZeMvuYPK0Ji+MKcLeYDqaoT5LD9LkIWcXKjqpwekNPehWAdHdNWxdHQLJFBAl9r7PrQ9EMhCg94FP1abEj+ECu54JPI3dvFGyytekwOe53Qb97MBimhIBdmA2ig96TgY4Ub2EajzX+Jp4xorzyFtv+CLHEaxJRYNcHKz0WdkhFAhKs5OP7PkZ7Zu5g3Lpnoy4Ba1j4doqt1m8HBj2tzgGu0zR6SjD3GVPHBbfOJ/msBKfwf667LHr7JoZ5ErqGc8z/51UtHNysGFBitmvNzY04dBomdnBsuAhBWdQoAfXpzhaHGTmyAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ts5ts4ARhpDGyvhlzDfFHTvYw+BPLNST5kgGTYzF4lY=;
 b=UC6cz5kRGYT6PAudDZbPvbesd+luQKTSZPb6FOa6KwisXvR9Nlgur6DFC8jifnmYxpQVJUkriMkJtHisSpGRLe05kFA+w69razkteERrVbM4jqMLIzCZGDLdqhYQUaD8RNGaexbsQ/9vKQx9p3I0Xz2WQazy3VPVlPKDssTe8klmN1ydrr6BkX9nOIF8ny8NvcIQTaCNLkDMk9VCzdwRFsTS0HifUv8lQkkztB3E2fZ1l3BAq1YtqRrK7s00bceVJMXKa2HMBVn2QfwQ7XCXmsflHcKWpTI7EbR0snbfggTNu30QxN2xJ10KlZMcUGBqN1pThunfyEf0cSRZ6osd1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ts5ts4ARhpDGyvhlzDfFHTvYw+BPLNST5kgGTYzF4lY=;
 b=QoYN3mb0TF5ql0KGJVfrB8VGX9yvOQa2Stwjes8AfiJ+ZI5oQCKI7sf61WD5pTwqjqD5XJyWtJX274k0vq1rZHEVO6NCYVuZ6v1H1BhHJ8On9sCkSiMA5wIyO2vK0U/2NCpO/bvKFhPQeCfa4vcuOZDf8IuzHgXWvL0pwXIhLIE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:14 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:14 +0000
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
Subject: [PATCH Part2 v5 16/45] crypto: ccp: Add the SNP_PLATFORM_STATUS command
Date:   Fri, 20 Aug 2021 10:58:49 -0500
Message-Id: <20210820155918.7518-17-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7834603a-bf8a-4306-423e-08d963f398d6
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268533E9193A9605EDAB306DE5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hsHCxtvKXZQEfhTOQfpGQ3mCcFOH2+nr9xyZSjqlN3jpBdzX1x1oY3p9gJoZK8iqqmCShKW9LWFu01CIUDM1zLYxJT3vtx7HidDAVMCJNSrZKHAQeBETMN5aU0jGYvj2jq4UIwzB0wbLoxG+tPYdUfJ2HWT3ZLmQd4FStvgyKgUps70bBwvi0XCPBlH35HDuqpKqeUb7i7OWT7GXaBKTYYxIjmQY1jYMHGW3zpoJ26ljlGOijx1hmOhdNoTarX8IDhMeiTifiLOBDIHEIyCjg/TrBhqcc875z+JQ8c0gYqjltwoERqo8g1CFix+fJ6rkkdkOeGuoeUncvm31myW2qU3PpFMi165PGGIIKzmVop2zO7oUxwPGt5QXKkvP3VWXmkpCvjuQv0/MsbZI1lppXTMeaSP/IoCwX8A2XtJLjlg4m+s71sf6nNyPf4Ew6nyg4xAYaN2vcAQt44W4kIVebgemDbqrfOAT2nt94wPqHVdV5TmNELOopScPtttlCWmoEeuaQo8m405rQUtCmRxV3TylRh4XuvGFKItls95+BYKUP/RrHS1MJJSYSlUQbDUDAfASCjcECaD2emwEdX6M2/oguvVXD4DPQoe8m33FXEVxQzbNmf4zVGxiciFOmZfo+GsGD2FiUkzysiDRj7wHA02SKz32r52jh9ku7yW0tmcRWuh7gneA37lGX5EW0MhxxDOX8WTjfn3vV8Wl2huYeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(83380400001)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AGAi0wusnI5fTUx+merz3UsP0I8LpoTJsjxyOJILBNI2iz7mqfxUs5ha2puD?=
 =?us-ascii?Q?oYCspu1YauCyAj522Ryp9wUxn7MZb7//o+Kladih+QQClJW5zthxnt5RYehM?=
 =?us-ascii?Q?rngHQj2SEoWfGl3+GTF1tmBv7suQvpXe//ruRc95qWlMVvfzwxSLO4Vc7Rv0?=
 =?us-ascii?Q?OhVz6FrqKir1qXF6gZLONWvWCyqowwUAzmbT00SC+A3IBwrKdmtjG/wv5ZZq?=
 =?us-ascii?Q?OrZuHHEEFsSfKgEzP6BpF75CQ+5bMxTMeRqzKhGwHnDofP+HFd/ijMDYELO3?=
 =?us-ascii?Q?5MK4G93mNnh8IetDUdES7yPPSt1WIRcpZ2dczsv6Rr0sacZx1nNisj2EXAU8?=
 =?us-ascii?Q?I9F+McYRM0dlfDRApRU5YMlsTOtN6IhhnMCDw8nxg6tP6g5ITm1ut6dCmA0u?=
 =?us-ascii?Q?chXAjLakhvLDCawniZEmJxYS/sRS88r6VkwU/7frfMiTsi7PBoFFjp6eGooL?=
 =?us-ascii?Q?USTe+rpwFQFqimoeEFoM67PztkzOb1Sj0Uim6YqZ96n/Or5Z9D0/6yhxxzFj?=
 =?us-ascii?Q?eyqhDoqJ63k9OOdJpd5vXcEZvSqHQK7g8BCaazWLY8E1Jpz6lxyNiSN8p7d4?=
 =?us-ascii?Q?hZf5Mtn9d5dAUnP7lQOb7jLN8jJkabx95hAXdJzh6DiPJnnneLtqGEq8lT+c?=
 =?us-ascii?Q?wGkW/Vdyb+y3fnVfJWDStE709mW0PCqHC3wuPZT0OYWx5Di9BKIEoa5lCX32?=
 =?us-ascii?Q?NsakYTXZ9S4VbCRTTaDdjAg02yZRXyDwA2ct2NVAqTVbHM0jkbm89a0WHaRK?=
 =?us-ascii?Q?vXaNzeJ7rlGDkWv82SKfahDq/F7V7oyur07h66H6cA/+VPv3d5Z+hbIRv8cM?=
 =?us-ascii?Q?sAHCo32H/rSjh0Rcb0xFss4rB4DYv/R6QHxdM+21FG4hosO/VcUr4rswjUgA?=
 =?us-ascii?Q?aidY1+DYsD+x08y7B4yUgw6yZjhtXdl40DFU6ChrU1uicQwyXaArtG1Q3vOa?=
 =?us-ascii?Q?ozT3ZA/4/qxtc5rNPg+5h7+PaTpzUNE35PcgL4ytLnHli4uuXMQIT/yxgGKi?=
 =?us-ascii?Q?BZsIqhLtFX4a9DG3Q1dDGgA2RkrkcYpHW4tvpPD5yTYkeOyrlXIYOg+XDjSP?=
 =?us-ascii?Q?NnUbcQUSWQGabQnLwnOOC0G890JLuPrH9MeXh6/arZzSdNJXXzRpIQBYlRRr?=
 =?us-ascii?Q?6//vAzu2KKdTQToQnv/n9kl5Xp8KmVHtkVGvxLze/MpLGhlDtA0z1OyfudJY?=
 =?us-ascii?Q?PqQZDvc3gNAMxizxp1L0y5fZ+tNxDAymndqrsR1v4M0iwqdyIHK3maVT4R3E?=
 =?us-ascii?Q?uOMNkPxvV4s3XmFjKSuLAVJc+VCZxDJ0jIo/j3uPTe7oylh0W64zN6dEfBm9?=
 =?us-ascii?Q?oV3iVlf1BvxDWD7j9R7tKIcm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7834603a-bf8a-4306-423e-08d963f398d6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:14.4045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SUpFbttGsLJmJ8xFNxC3ZG3GATF6FbKSK/wD5pyri7CD//Buwiz6EIO26F3fJYBfiBLkQ/CGh4SFlZyJz1rbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The command can be used by the userspace to query the SNP platform status
report. See the SEV-SNP spec for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/virt/coco/sevguest.rst | 27 +++++++++++++++++
 drivers/crypto/ccp/sev-dev.c         | 45 ++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h         |  1 +
 3 files changed, 73 insertions(+)

diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
index 7acb8696fca4..7c51da010039 100644
--- a/Documentation/virt/coco/sevguest.rst
+++ b/Documentation/virt/coco/sevguest.rst
@@ -52,6 +52,22 @@ to execute due to the firmware error, then fw_err code will be set.
                 __u64 fw_err;
         };
 
+The host ioctl should be called to /dev/sev device. The ioctl accepts command
+id and command input structure.
+
+::
+        struct sev_issue_cmd {
+                /* Command ID */
+                __u32 cmd;
+
+                /* Command request structure */
+                __u64 data;
+
+                /* firmware error code on failure (see psp-sev.h) */
+                __u32 error;
+        };
+
+
 2.1 SNP_GET_REPORT
 ------------------
 
@@ -107,3 +123,14 @@ length of the blob is lesser than expected then snp_ext_report_req.certs_len wil
 be updated with the expected value.
 
 See GHCB specification for further detail on how to parse the certificate blob.
+
+2.3 SNP_PLATFORM_STATUS
+-----------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (in): struct sev_data_snp_platform_status
+:Returns (out): 0 on success, -negative on error
+
+The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
+status includes API major, minor version and more. See the SEV-SNP
+specification for further details.
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 4cd7d803a624..16c6df5d412c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1394,6 +1394,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
+static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_data_snp_platform_status_buf buf;
+	struct page *status_page;
+	void *data;
+	int ret;
+
+	if (!sev->snp_inited || !argp->data)
+		return -EINVAL;
+
+	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!status_page)
+		return -ENOMEM;
+
+	data = page_address(status_page);
+	if (snp_set_rmp_state(__pa(data), 1, true, true, false)) {
+		__free_pages(status_page, 0);
+		return -EFAULT;
+	}
+
+	buf.status_paddr = __psp_pa(data);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
+
+	/* Change the page state before accessing it */
+	if (snp_set_rmp_state(__pa(data), 1, false, true, true)) {
+		snp_leak_pages(__pa(data) >> PAGE_SHIFT, 1);
+		return -EFAULT;
+	}
+
+	if (ret)
+		goto cleanup;
+
+	if (copy_to_user((void __user *)argp->data, data,
+			 sizeof(struct sev_user_data_snp_status)))
+		ret = -EFAULT;
+
+cleanup:
+	__free_pages(status_page, 0);
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -1445,6 +1487,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_GET_ID2:
 		ret = sev_ioctl_do_get_id2(&input);
 		break;
+	case SNP_PLATFORM_STATUS:
+		ret = sev_ioctl_snp_platform_status(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index bed65a891223..ffd60e8b0a31 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -28,6 +28,7 @@ enum {
 	SEV_PEK_CERT_IMPORT,
 	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
 	SEV_GET_ID2,
+	SNP_PLATFORM_STATUS,
 
 	SEV_MAX,
 };
-- 
2.17.1

