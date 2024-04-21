Return-Path: <kvm+bounces-15440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D3438AC094
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA305B20B43
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C923B185;
	Sun, 21 Apr 2024 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mBUq2h6F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5153AC16;
	Sun, 21 Apr 2024 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722911; cv=fail; b=aILeASed3RXXC2PV6rac5uoKW5Xnah/ot8yjOx/zic9yO/m7VyfSd0uV1RJKgdJa8yQEZ8008s+zQ+l+9zsv46mpsTs61KeS9OIkihdEBex+umJlR3z8cIVLa+DMxn/dwlwToWG4frP8MN4WouISy9OmnUI/Hmqxn/Y8yKwD788=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722911; c=relaxed/simple;
	bh=Em5JaNDgMsMN5aAHwObuTrTg7NYqEHJNGk7vqUFH714=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ssDexg8p+36CTxIrL0+FohGKJ1o9gjBmT+z/4CUnasbOiJ5sWaCZDloZK5IyWiyyAPGoe9v7lxHuPXMy55N/mVZ4FKOYRMFnpKlrDTObfZuFLvL67IEVVkoq6IHYtWxid4oAvc0eG07dq62DXKy1ES5JDUtH6AS8EkU8hwNF9oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mBUq2h6F; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlfbPQ4chavtj2GAhNzFPVWIKtcfd9HXo5eCpSdE1mWONgDv0J+0Xb9mQ3Ik9VDmrnDNMc1JqeXabdYeaBzOIXfpiOTOqo6miIL4SdoQzKKW3mYIjwq9ThjWbPJfHSDSZ6o/uJf9p+4ml3EAcRusMiS8Ku1N9zh6STDJESKYibho6Ha5kqIEb3Bq2rn66MjkvHBydVQsJzT4yV/3wmRmlYfqxHqsFWCPbrPXZEK0XHlN1WXzl5EikB4Ud/5N7ipSn3ZyUWwd9OPNDDBUoav2IH7b2s86D5+eBWLeYj8K7J9SvwshJKhgfVyqZ5BgGwHV1X9J5KhyxkuAGk4cn444IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrwzof3RVQhyZxlUzlSBLTxrCF2ZDlYFNuyZSJEeWoo=;
 b=QiW+5s0OhTtm1ZCdAyQfOoX5wZTxRfDW55JidxwfVhWKVgIPdZOsEKZy5bNkRAJV9GLbjRiK0VE/WsYMIW7E1B5emJPXUBpOQu90scMXV5qAyuVwp5dwdLf+eaNvoT8QfC6g9Db47ZBBYKDYWRby+w/YJpgu0I82uwii4J+rKyWXWW9ZBdGC2jw7a8gUqnxPkXr2DNfDp17PsjjTfJpKhiVHHsfIaZkBbannFRK7h0C/bciEwXYMGUl6G44I0Q2DVgWgNQcmb7kL6suZjnMx0DtFouD+Gi06hQ4IP4m9YMkzVy9Q6i39hSXebT/NClRnOp9CzubCx6RLgWvqKRj9Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrwzof3RVQhyZxlUzlSBLTxrCF2ZDlYFNuyZSJEeWoo=;
 b=mBUq2h6FzyxZrZFhfOV885V3NsKBl7SjL8YtLlOb6jcWSk4fyFhym3yfLTpWnSN/gpUursb/TIdZaxdVmsrvD0ksH+o/uKAqpeP1/bcyG0RUVQFUfuUeOwnP5QIQVJ+omizSQNk3RMuSrmqCXkkU/7qbVZ86dmllKt0hDBMhcUM=
Received: from DS7PR03CA0209.namprd03.prod.outlook.com (2603:10b6:5:3b6::34)
 by PH7PR12MB6787.namprd12.prod.outlook.com (2603:10b6:510:1ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:08:23 +0000
Received: from CY4PEPF0000FCC1.namprd03.prod.outlook.com
 (2603:10b6:5:3b6:cafe::8) by DS7PR03CA0209.outlook.office365.com
 (2603:10b6:5:3b6::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:08:23 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC1.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:08:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:08:20 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v14 21/22] crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION commands
Date: Sun, 21 Apr 2024 13:01:21 -0500
Message-ID: <20240421180122.1650812-22-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC1:EE_|PH7PR12MB6787:EE_
X-MS-Office365-Filtering-Correlation-Id: 276599a1-f3d7-4eb7-4b86-08dc622e0795
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mab1Krx9HrNJ1ocHgLLI4hv71P2gMkOS1CVuiBvp6u5zGODxqXsXbB/nLTR0?=
 =?us-ascii?Q?xvBnc1BT8L92zFp6AsLDc3GSnOP3Y8jYidAgvy/6LbQveIl+5/XLAaKa4NZK?=
 =?us-ascii?Q?JJtbOCcHhVukhhcfHr7Pz8A4KSEI6us0n1lbUmtHfgLp4N7HMKZd+V7kisu/?=
 =?us-ascii?Q?cBNKPWgvcjzEgeudxaaGv8f3xzMGVGdzUFosWQ4dI6xJvgXWdqoiEbPZTWH6?=
 =?us-ascii?Q?w4G6skDlWCs3bAMKSSkmzQOU969sGB7sAIl0pyxoY6/Fem13LONb6q7pDqxl?=
 =?us-ascii?Q?HBoyB2/PMiN3K2hW2+wSPb5r/xB01ovaZmPW7UYO5olnn7mWw6TccK9aemtG?=
 =?us-ascii?Q?jfQZ0UPnh47cX/ch9FOiqKvgCgytb1fl3B4rvWWxOG/GXlfAbfzS0X6rq9FI?=
 =?us-ascii?Q?nuMYQDVqX469k61dUOYjIvwJZHwaVmhFdvpz+eEqyLusaWZZxs0MyZ6o3LWi?=
 =?us-ascii?Q?WfuoJNzlqqSSWjRX/Q6d6fkkK8ScnZ6vlL4LxGIZD7AgH7n5kpiRCUHibdX9?=
 =?us-ascii?Q?w/q2j9ise0ZpR9v9VdTaLH4Jd6WP39t6aOw+kCsmYsWy1umreimCWFJvsFNB?=
 =?us-ascii?Q?vJTp/+iVHumUIiDCEwv8jVPC4+BiNhdpLbO+svD7Jes4GdQMBuwmJglN6J0r?=
 =?us-ascii?Q?4lWio7E0u8L7viLz+zn3A5cYSbSuLIpWJ4Wu1/E0a5Y5GEufzu3B8valeB3z?=
 =?us-ascii?Q?6zzW9rOIiSqf2EYLk9xCtTPBnbsuXGIIFH1cnF/y0k7CBR58GNtt4JVp5ZqF?=
 =?us-ascii?Q?GTSROahfcpl+p5XdzVJWrHTygVzwx0iIgYAYzxee5uSRXM4Sa9z/cEuDctXX?=
 =?us-ascii?Q?ewPNQSEEmK6yEaMFvwZ4lFyZnlz0nZM5xMj0dmrZKGM/NBLGN7UxyHnjrbJA?=
 =?us-ascii?Q?l6kwVPjY4EtxblU+XtW2CX0YPCw9n9e9/wpTGzSZQKGi1f5aFDTlTMtmOh6T?=
 =?us-ascii?Q?6PAk/Y5orm5xbKDPHPu7RbMtN4cirnoh6kHFgZv2cWMS2cDPxGgUc57kihEA?=
 =?us-ascii?Q?9QqtCNUVotOm1yo7cIQSJ/eXD2MEUhBdJBGBSH6McxkOrWNlisPkL2slF4M3?=
 =?us-ascii?Q?cgoB7ZaJnaVHHKda/tt8PeOAeUEjIfLd2NDDJZASZL/Ti2mL5hxSYoPx4MZR?=
 =?us-ascii?Q?CJStPMw2p2+uzfTDSaWLLR4qidbNvHhYF0m/ixqtNNWlTA+II6ugUeQlDLcf?=
 =?us-ascii?Q?EBFv2qXTWutn+jJGcL/PNGWaJ7KwwKaGcuLZ1Ff5vuTdhiRQPBXDa7YLFLMk?=
 =?us-ascii?Q?2v7wbb3WJ5Ts+Gnf2ysF2C/zpaZbgrXeqVYRZAt0PkE+ydsvriM2lQDRygbT?=
 =?us-ascii?Q?o+lm5+4+X2aLw+a11ry1HX6/A1UhrAKEq90KSUz7356Qi/Nli++SrQ0xEADh?=
 =?us-ascii?Q?NeRuIp3ek/yNVyaXkjrTIzfmvGwl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:08:21.4072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 276599a1-f3d7-4eb7-4b86-08dc622e0795
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6787

These commands can be used to pause servicing of guest attestation
requests. This useful when updating the reported TCB or signing key with
commands such as SNP_SET_CONFIG/SNP_COMMIT/SNP_VLEK_LOAD, since they may
in turn require updates to userspace-supplied certificates, and if an
attestation request happens to be in-flight at the time those updates
are occurring there is potential for a guest to receive a certificate
blob that is out of sync with the effective signing key for the
attestation report.

These interfaces also provide some versatility with how similar
firmware/certificate update activities can be handled in the future.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 50 +++++++++++++++++++++++++--
 arch/x86/include/asm/sev.h            |  6 ++++
 arch/x86/virt/svm/sev.c               | 43 +++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c          | 47 +++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h          | 12 +++++++
 5 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index de68d3a4b540..ab192a008ba7 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -128,8 +128,6 @@ the SEV-SNP specification for further details.
 
 The SNP_GET_EXT_REPORT ioctl is similar to the SNP_GET_REPORT. The difference is
 related to the additional certificate data that is returned with the report.
-The certificate data returned is being provided by the hypervisor through the
-SNP_SET_EXT_CONFIG.
 
 The ioctl uses the SNP_GUEST_REQUEST (MSG_REPORT_REQ) command provided by the SEV-SNP
 firmware to get the attestation report.
@@ -195,6 +193,54 @@ them into the system after obtaining them from the KDS, and corresponds
 closely to the SNP_VLEK_LOAD firmware command specified in the SEV-SNP
 spec.
 
+2.8 SNP_PAUSE_ATTESTATION / SNP_RESUME_ATTESTATION
+--------------------------------------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (out): struct sev_user_data_snp_pause_transaction
+:Returns (out): 0 on success, -negative on error
+
+When requesting attestation reports, SNP guests have the option of issuing
+an extended guest request which allows host userspace to supply additional
+certificate data that can be used to validate the signature used to sign
+the attestation report. This signature is generated using a key that is
+derived from the reported TCB that can be set via the SNP_SET_CONFIG and
+SNP_COMMIT ioctls, so the accompanying certificate data needs to be kept in
+sync with the changes made to the reported TCB via these ioctls.
+
+Similarly, interfaces like SNP_LOAD_VLEK can modify the key used to sign
+the attestation reports, which may in turn require updating the certificate
+data provided to guests via extended guest requests.
+
+To allow for updating the reported TCB, endorsement key, and any certificate
+data in a manner that is atomic to guests, the SNP_PAUSE_ATTESTATION and
+SNP_RESUME_ATTESTATION commands are provided.
+
+After SNP_PAUSE_ATTESTATION is issued, any attestation report requests via
+extended guest requests that are in-progress, or received after
+SNP_PAUSE_ATTESTATION is issued, will result in the guest receiving a
+GHCB-defined error message instructing it to retry the request. Once all
+the desired reported TCB, endorsement keys, or certificate data updates
+are completed on the host, the SNP_RESUME_ATTESTATION command must be
+issued to allow guest attestation requests to proceed.
+
+In general, hosts should serialize updates of this sort and never have more
+than 1 outstanding transaction in flight that could result in the
+interleaving of multiple SNP_PAUSE_ATTESTATION/SNP_RESUME_ATTESTATION pairs.
+To guard against this, SNP_PAUSE_ATTESTATION will fail if another process
+has already paused attestation requests.
+
+However, there may be occassions where a transaction needs to be aborted due
+to unexpected activity in userspace such as timeouts, crashes, etc., so
+SNP_RESUME_ATTESTATION will always succeed. Nonetheless, this could
+potentially lead to SNP_RESUME_ATTESTATION being called out of sequence, so
+to allow for callers of SNP_{PAUSE,RESUME}_ATTESTATION to detect such
+occurrences, each ioctl will return a transaction ID in the response so the
+caller can monitor whether the start/end ID both match. If they don't, the
+caller should assume that attestation has been paused/resumed unexpectedly,
+and take whatever measures it deems necessary such as logging, reporting,
+auditing the sequence of events.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 3a06f06b847a..ee24ef815e35 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -82,6 +82,8 @@ extern void vc_no_ghcb(void);
 extern void vc_boot_ghcb(void);
 extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
+extern struct mutex snp_pause_attestation_lock;
+
 /* PVALIDATE return codes */
 #define PVALIDATE_FAIL_SIZEMISMATCH	6
 
@@ -272,6 +274,8 @@ int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immut
 int rmp_make_shared(u64 pfn, enum pg_level level);
 void snp_leak_pages(u64 pfn, unsigned int npages);
 void kdump_sev_callback(void);
+int snp_pause_attestation(u64 *transaction_id);
+void snp_resume_attestation(u64 *transaction_id);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -285,6 +289,8 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
+static inline int snp_pause_attestation(u64 *transaction_id) { return 0; }
+static inline void snp_resume_attestation(u64 *transaction_id) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index ab0e8448bb6e..b75f2e7d4012 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -70,6 +70,11 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
 static unsigned long snp_nr_leaked_pages;
 
+/* For synchronizing TCB/certificate updates with extended guest requests */
+DEFINE_MUTEX(snp_pause_attestation_lock);
+static u64 snp_transaction_id;
+static bool snp_attestation_paused;
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -568,3 +573,41 @@ void kdump_sev_callback(void)
 	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		wbinvd();
 }
+
+int snp_pause_attestation(u64 *transaction_id)
+{
+	mutex_lock(&snp_pause_attestation_lock);
+
+	if (snp_attestation_paused) {
+		mutex_unlock(&snp_pause_attestation_lock);
+		return -EBUSY;
+	}
+
+	/*
+	 * The actual transaction ID update will happen when
+	 * snp_resume_attestation() is called, so return
+	 * the *anticipated* transaction ID that will be
+	 * returned by snp_resume_attestation(). This is
+	 * to ensure that unbalanced/aborted transactions will
+	 * be noticeable when the caller that started the
+	 * transaction calls snp_resume_attestation().
+	 */
+	*transaction_id = snp_transaction_id + 1;
+	snp_attestation_paused = true;
+
+	mutex_unlock(&snp_pause_attestation_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_pause_attestation);
+
+void snp_resume_attestation(u64 *transaction_id)
+{
+	mutex_lock(&snp_pause_attestation_lock);
+
+	snp_attestation_paused = false;
+	*transaction_id = ++snp_transaction_id;
+
+	mutex_unlock(&snp_pause_attestation_lock);
+}
+EXPORT_SYMBOL_GPL(snp_resume_attestation);
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 97a7959406ee..7eb18a273731 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2060,6 +2060,47 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
+static int sev_ioctl_do_snp_pause_attestation(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_user_data_snp_pause_attestation transaction = {0};
+	struct sev_device *sev = psp_master->sev_data;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	ret = snp_pause_attestation(&transaction.id);
+	if (ret)
+		return ret;
+
+	if (copy_to_user((void __user *)argp->data, &transaction, sizeof(transaction)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int sev_ioctl_do_snp_resume_attestation(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_user_data_snp_pause_attestation transaction = {0};
+	struct sev_device *sev = psp_master->sev_data;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	snp_resume_attestation(&transaction.id);
+
+	if (copy_to_user((void __user *)argp->data, &transaction, sizeof(transaction)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -2123,6 +2164,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SNP_VLEK_LOAD:
 		ret = sev_ioctl_do_snp_vlek_load(&input, writable);
 		break;
+	case SNP_PAUSE_ATTESTATION:
+		ret = sev_ioctl_do_snp_pause_attestation(&input, writable);
+		break;
+	case SNP_RESUME_ATTESTATION:
+		ret = sev_ioctl_do_snp_resume_attestation(&input, writable);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 2289b7c76c59..7b35b2814a99 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -32,6 +32,8 @@ enum {
 	SNP_COMMIT,
 	SNP_SET_CONFIG,
 	SNP_VLEK_LOAD,
+	SNP_PAUSE_ATTESTATION,
+	SNP_RESUME_ATTESTATION,
 
 	SEV_MAX,
 };
@@ -241,6 +243,16 @@ struct sev_user_data_snp_wrapped_vlek_hashstick {
 	__u8 data[432];				/* In */
 } __packed;
 
+/**
+ * struct sev_user_data_snp_pause_attestation - metadata for pausing attestation
+ *
+ * @id: the ID of the transaction started/ended by a call to SNP_PAUSE_ATTESTATION
+ *	or SNP_RESUME_ATTESTATION, respectively.
+ */
+struct sev_user_data_snp_pause_attestation {
+	__u64 id;				/* Out */
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1


