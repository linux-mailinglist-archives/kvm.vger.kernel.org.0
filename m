Return-Path: <kvm+bounces-7067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA19183D3AE
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F739288370
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E6D2B642;
	Fri, 26 Jan 2024 04:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P3us/8Oa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA2714008;
	Fri, 26 Jan 2024 04:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244367; cv=fail; b=I6T5cWid3QvQHtR/H3NHlVnlYi0TktnDlAQLCYtZl8bA+nb9t4qGW5eSi6SbhRDXemip15qnjpimQAHL3TdWp6gOVMBzj4V/3l8/RrM0h5LL0/DLlqvOk/Ek4taModwnzQavcNZZIwDF84Nu4z3AFXxicSpn00OutC6+FzLNrx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244367; c=relaxed/simple;
	bh=QrUPs3kaQ9AWLVT4OpRpS5jvj5xXKkaI6mDQqf2c4/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9ni1wwnjVMAHA8JtkmD4A2gUT2m1ooceGSTQMlTP0Jz6H7kFTpoqPwtxUSJ5svyNOMOPBc3i0Nmz72zsr5gVBZ4v1j4umz+B/2C+ECjnCyaHg1YzCgy90b501pSJaO7Jc6wqi+SroZaQxv5fsi2yYI9RAEqlqjtkLBR3M+n8Ig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P3us/8Oa; arc=fail smtp.client-ip=40.107.95.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSB9w4dLGJxZ7b4ItNCX7ZA2t/8x7/Xk9xCQk/azdaj5ghsNBqNDwITrZUvGSCguEiqfEizxE3taY76BnSAgnanj11EwlXVXRsvPzTRVv3V2vHLopkKIvR8MtkPNsykYj8EElxXgmtbWL0sQHAWv3KdV/iSQdPDps9ily8usYQSJQ8p3JYt5IOk6fiudmRJ/lD/HlKkbXTNthMmKzPSqeGwAfxMzBQe2xkzf3/RZvBx+7CZTpYyqi92GMTD85y/mp4DB6JFDxQgi5idlsHDZQa2GV32+NVbf8QpEVkdgPcUjnDlCBF5o0Jeu9mfQQZhDA+pqhIjBhAUu1DpDo/g7wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P24ey68QgkCCklEFwnPZMKuFWRudOfuqK8Rb9REQ1Dc=;
 b=Huy7oOmrkC79hDZeFQWEOyXXGJ07zdYp44xxqFdq36hZyQLiPe83S5mdQ9cy4RqXrHo83oHugMCAdLu9PB7JEVtBbUf9ao0w+zYS97ecTupgZkG/oDYp3qZLwxjJO9XUzeBjfFGCqtb0BHd52CV1VfqKKDs+/1tPTaliPddVS2UL9rWfPvEPrlB5nLDMc6wfwlWDiWoM2V/9sO5ZhvWuPAz4fDmUz6ZLI/xM7nMIwchyNid+EYojK+8j1ctnAap69LWmhejZccQE8JBgtmjahab7UciAzUgxDAfZNKTgSrAKr28O7LoNFI3nXVYNAuNSJNq63khMGmH8GUplofcGRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P24ey68QgkCCklEFwnPZMKuFWRudOfuqK8Rb9REQ1Dc=;
 b=P3us/8OakS9/enVf+ULHDxHhuWks7ZCBbZuZZhMtuRaGtkR5OBklfWb7ipcRu/sxo+Wgi/ts3mputIy67fBfpxa+hrF55SyzjGimd5jcx7yCzR3TqMhJDakjYw/DO2RhARyfCz7k6+5VrvH4kfKDIy07BCrKrm4Bb4VERaaPP8E=
Received: from DM6PR03CA0031.namprd03.prod.outlook.com (2603:10b6:5:40::44) by
 DM4PR12MB5987.namprd12.prod.outlook.com (2603:10b6:8:6a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.24; Fri, 26 Jan 2024 04:46:03 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:5:40:cafe::fc) by DM6PR03CA0031.outlook.office365.com
 (2603:10b6:5:40::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.33 via Frontend
 Transport; Fri, 26 Jan 2024 04:46:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:46:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:46:02 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v2 23/25] crypto: ccp: Add the SNP_PLATFORM_STATUS command
Date: Thu, 25 Jan 2024 22:11:23 -0600
Message-ID: <20240126041126.1927228-24-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|DM4PR12MB5987:EE_
X-MS-Office365-Filtering-Correlation-Id: 2faef846-fc4b-4963-0a82-08dc1e29b35e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8P4HI7ieC8Fz2YbYt0FRTzbArB2pJb/HO7caRJZ+Vt5dYOqIAeBTap/ThKzFTa5Idr77OhCfWk1Eixza4rp3RQOL69RsPDrpALV8L6YH4vRNOYS5j5yOSglEP+cB7WNlRW40q37yqSFeyy8a91+BEbHozTST/CVFdLncAUGOR+MR9cxeJenxkVmit+qi+SJ5GEFBFF8KvUHH5yxvx9HFLSQtINJIVOYWO4f0HpyRATLnDaInWMT/Du8sS1G73XGRjJREABMdqNln/GHAkX7eFZn1D8tHSaXP/0Jd5v7AVYnzhLXy9zATRzircYlf3SQnBUF2IUIpSYIsoppaBWObSxQGx2KA+odrmmoErT+8wTa3f54pYWcAPEXUKFGV7X6i8ydeVg5PIMHOGMZDEkSkkdvdB4acAq1WlGZ/tD56VNQ8YeWRfJupUD25LANy3zAZmuhFVTZImbx1E6FlCIX43GmRqAd3bYMx7Vm4I49ggx3DaeS0PX8jdXIsslTBHfuhP0TX+5eSVB57iZVyv8lYiFWhfqH1GjqRTng/3pio3ZEagMbnkMDoo6wb2VvysBHyXz5eVsym+k4RH9kBbohJqd6ZONKiYZ02j8QK4Vki9gIhnhD4uCOiUNYiV//wFKsnWmgq8botFq+UoT9D7gyvkNVJxJO4M8UYALXrP6r9swgLE6+iorGF4fo1ZApn11HuoBpzgyOqaTo0Kn60Ou7P+rAGryagQhuSgUaNa0tCPIRLwh+Tr49rSJlBX7PTx3cty6CuShjyolsmPVrr6Yji2A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(451199024)(64100799003)(82310400011)(1800799012)(186009)(40470700004)(36840700001)(46966006)(40460700003)(40480700001)(70206006)(26005)(70586007)(5660300002)(36860700001)(54906003)(7416002)(316002)(4326008)(16526019)(336012)(8676002)(8936002)(426003)(6666004)(7406005)(1076003)(2906002)(47076005)(6916009)(83380400001)(44832011)(81166007)(356005)(86362001)(478600001)(36756003)(41300700001)(2616005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:46:03.0763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2faef846-fc4b-4963-0a82-08dc1e29b35e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5987

From: Brijesh Singh <brijesh.singh@amd.com>

This command is used to query the SNP platform status. See the SEV-SNP
spec for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 27 ++++++++++++++
 drivers/crypto/ccp/sev-dev.c          | 52 +++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h          |  1 +
 3 files changed, 80 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index 68b0d2363af8..6d3d5d336e5f 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -67,6 +67,22 @@ counter (e.g. counter overflow), then -EIO will be returned.
                 };
         };
 
+The host ioctls are issued to a file descriptor of the /dev/sev device.
+The ioctl accepts the command ID/input structure documented below.
+
+::
+        struct sev_issue_cmd {
+                /* Command ID */
+                __u32 cmd;
+
+                /* Command request structure */
+                __u64 data;
+
+                /* Firmware error code on failure (see psp-sev.h) */
+                __u32 error;
+        };
+
+
 2.1 SNP_GET_REPORT
 ------------------
 
@@ -124,6 +140,17 @@ be updated with the expected value.
 
 See GHCB specification for further detail on how to parse the certificate blob.
 
+2.4 SNP_PLATFORM_STATUS
+-----------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (out): struct sev_user_data_snp_status
+:Returns (out): 0 on success, -negative on error
+
+The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
+status includes API major, minor version and more. See the SEV-SNP
+specification for further details.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9a395f0f9b10..9f6ee0d24781 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1919,6 +1919,55 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
+static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_data_snp_addr buf;
+	struct page *status_page;
+	void *data;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!status_page)
+		return -ENOMEM;
+
+	data = page_address(status_page);
+
+	/*
+	 * Firmware expects status page to be in firmware-owned state, otherwise
+	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
+	 */
+	if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
+		ret = -EFAULT;
+		goto cleanup;
+	}
+
+	buf.address = __psp_pa(data);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
+
+	/*
+	 * Status page will be transitioned to Reclaim state upon success, or
+	 * left in Firmware state in failure. Use snp_reclaim_pages() to
+	 * transition either case back to Hypervisor-owned state.
+	 */
+	if (snp_reclaim_pages(__pa(data), 1, true))
+		return -EFAULT;
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
@@ -1970,6 +2019,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_GET_ID2:
 		ret = sev_ioctl_do_get_id2(&input);
 		break;
+	case SNP_PLATFORM_STATUS:
+		ret = sev_ioctl_do_snp_platform_status(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 207e34217528..f1e2c55a92b4 100644
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
2.25.1


