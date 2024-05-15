Return-Path: <kvm+bounces-17413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 136A68C5EC6
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C326B210E5
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D1CEBE;
	Wed, 15 May 2024 01:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pq2tQnPq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35F0EEAA;
	Wed, 15 May 2024 01:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715736399; cv=fail; b=CPjsDDHu/7GHcLR1zVbonHhFICg7qOuVeeZ5fAJudKyiXXs+/geb3OQiz2/vhaPIemMgVeIFVXiU3VIiToG9S4pUm3uHj5FlYMLfLVn1KiSssucm+xf5BOQgHAjp5XQlLQejaLBr+OxCtIyF3+RXf1knaHsrjyYG7g1lGaIcxYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715736399; c=relaxed/simple;
	bh=6QWNd/JEr6t6zeEiKOmm6cVODfx6e1iRYuOdj3/Hoa0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGOUKHxGOhaIlegP3m+0gY3EuLM+6VU+IyUoYfCUfc4bXd710/IRWK1MFBpXTPVkoYbk+lzaJKFlSsBnf1jQC9qOz12hWqXMr6Lt5SM1EovpLEWrQdXkCZTJoB/t8lqt2l9c0nNEoWC+Bhluhu7NH0/rKYmX7XPwNsHuM5dxy84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pq2tQnPq; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuQ1JbAoJ2hfQ8diJG62LMCBeyP7bJbTSz6Tr/dntoXym5ZoziBU/RHK61D3IDDpaFzYy6d372GNMHrvu1R8U2FmeE2U4b+GkwiIq6+AXEnhPaaUcvrI9V7jnTU3QDw8voa47KkMjAAiCVOZyGnTpIWm8BYaAhu16XWSNrfacZjpZPDFdUi4D8qFQ70WC7Vr7BeHYuhi3AE6ACjrg/TwX3SDh5gK6sPX603lNvXM0gOnmSiSoTnhkKLV3ddpnSR1A+i+Jd0o8SBu5uVaIXUPBuCxT1oSW8lGj0MhkVJh4FSuVso6AjTOViUqJV8SJj0Evka6Kysclub3Aa9ujtWwcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Lwbtk12C5KpZZ5ttgA9lQEJfFfc1mrP4y8q28NdZK0=;
 b=aXQyOhKDUByEMJg/xb9lM5aguFaP8gzbgn7EpxkBf0d9ykWDrSXVEAK/3jD0zKrbqEwKmo75UdNn/oXTvsopQgqBz/dXzNK/dfJ4ODdq4ohKsXB8HEDlPXgWKnqsghnXJzkr53lMlZJyIrP5NVYpwZPZCJPLRkWDYT/QC/LEAjDUObRwTo7z5rgaEELswvkru68WJFxTa/1cOb2NbS0yU0zmxSwh8w0PrkRN0Hehrjnmk5xnL6M016S+nQXvESo9SlI7G3w07Ez63jiAHBkoU8TwmWFOV4pmc7DEzTEImBOTCkvXxvmt6hYYqA3oZItoEuET+K6teif/YynMUoVbXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Lwbtk12C5KpZZ5ttgA9lQEJfFfc1mrP4y8q28NdZK0=;
 b=Pq2tQnPq46C26qj1Vk3mPaTYd3bSso78TCBM3Lwo+P+WZSXI76p/UwGTkNc3ij/TpuMkltIuQk7L80UUl8NWp28dpSephhNLQx090a36xUnKfSv0LZFzoZh70M64EJuPz/FIg5KW3uL75a64UHQcrEHr7+JyO9aKxDdGhA5l5Qo=
Received: from CH2PR14CA0039.namprd14.prod.outlook.com (2603:10b6:610:56::19)
 by BY1PR12MB8446.namprd12.prod.outlook.com (2603:10b6:a03:52d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Wed, 15 May
 2024 01:26:28 +0000
Received: from CH1PEPF0000AD81.namprd04.prod.outlook.com
 (2603:10b6:610:56:cafe::5c) by CH2PR14CA0039.outlook.office365.com
 (2603:10b6:610:56::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26 via Frontend
 Transport; Wed, 15 May 2024 01:26:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD81.mail.protection.outlook.com (10.167.244.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Wed, 15 May 2024 01:26:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 14 May
 2024 20:26:23 -0500
From: Michael Roth <michael.roth@amd.com>
To: <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: [PATCH] KVM: SEV: Replace KVM_EXIT_VMGEXIT with KVM_EXIT_SNP_REQ_CERTS
Date: Tue, 14 May 2024 20:25:52 -0500
Message-ID: <20240515012552.801134-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ZkN25BPuLtTUmDKk@google.com>
References: <ZkN25BPuLtTUmDKk@google.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD81:EE_|BY1PR12MB8446:EE_
X-MS-Office365-Filtering-Correlation-Id: 9462bb7a-00a4-4703-2d2a-08dc747e0b4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|36860700004|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IyRFGDQFr/0qG0JlqwQudv+8/qnhZje8/qPFufhvv1ldIyuJC8ZPt+b9x1TK?=
 =?us-ascii?Q?Llgg22gri2PeI7h4fm/YLoLv029BF7z5uErqWGG2eIf1JAf9kWK67bOEysER?=
 =?us-ascii?Q?AzsAhyC5OoM77N0rGnOqFlB2b/jl9acsX4YaMMycKB3WqdV9ErKKt7mFEG7Z?=
 =?us-ascii?Q?TYZuR5+jRabdBqk45x+ClojpVR2Go3ijeySZ0j7LtkZVgQ50zbHLS4DmSzj8?=
 =?us-ascii?Q?G8kRzyLCGYk8N3wTeAgdzXD0111JkFJ98hrqASxZZIabehQUx+pjn9nO8tFT?=
 =?us-ascii?Q?Hky60KrHxs9MMgB7EJlIyZgPPTUaM6uNRoHAu3Tplv+sxH5Q6F0ln+5z/rAc?=
 =?us-ascii?Q?lKminVJjRNWr9GBI1AwO904tfBa2EFkiFO6pWtEfYELoybtxUzQvY3fhwH8r?=
 =?us-ascii?Q?xETLP3WMlBH6TlH1Axeqogw8pXyiYEU0gafieEAOpe77vzFdKXqYPM22WUHB?=
 =?us-ascii?Q?yGWeskKNirdN9AoPxAsPPb1iXjISpaAPUFLl71gDwzUyG1upywaJzy3mSbWP?=
 =?us-ascii?Q?V/FZs0Oah+Mwiz5XYBTjv2aWRP7abDvz3b3DdET8Vi3cuLsb+U/BPno/2BGz?=
 =?us-ascii?Q?afCjs7fLBZrA0iV3uAC6ozIOYNzYd0zCDVHpa7ruNoUgbtzjcfUPA2YsJbE1?=
 =?us-ascii?Q?8sbdGXZAbuP6Y+MnplPSi9aB87gLLncsOqW11DE2yfbcPAKnbuAHD2KpYCv0?=
 =?us-ascii?Q?jrQGHkSDFUgCs9VaPsD6nkupIyjLWbgzvMcrabzYTs/Hpi5r6QMvVTtDAMVR?=
 =?us-ascii?Q?xI4YuuyYNKBVVjDERGh4uk8TWT3YeA7YDWJd9uidBgmXLubGzemObDDvSax9?=
 =?us-ascii?Q?RVGw7fE/jzTxdIbFiJxSEw7dMHZ4wN74V7MuhWTit/+BUbeh25GfcVE5v0yo?=
 =?us-ascii?Q?jgevDQiNlim8/BblhU4AoTBk5t0bEslMe8ORUMX14dZ8UWiuNsu9Wuid0oa5?=
 =?us-ascii?Q?UbffdpjLOaN03vmFuTFEviEgwY5tpBh4CtfKcjCpIAOCR06Bdfnel6/sOA0s?=
 =?us-ascii?Q?Tg51mJpZg7Wvx4QZoNbH6DxWcpT9Fxlrav03OewjyC4oTBmyivSMVrIPhdfl?=
 =?us-ascii?Q?ZgA6RUp49p4x570ixZJKCFjKx+r0nAEw46yDEfD2J8yWkaZOesE00UgOYfNz?=
 =?us-ascii?Q?EyBKJuK8cFCVFSZxQmrfXjKWbzUIY6Zav53/CUwuE64fXZ8xatfh4Rf0simM?=
 =?us-ascii?Q?EWTsmx+rOtgazW21Nk2PMnU+Nzmxs3t+QUj9lQjf9VMX/W9dh0Vw+E8vx5NB?=
 =?us-ascii?Q?rTFE3BXtvmbw/cpLzOBUOqywIMeonC0vSWtFLLesKyUsQM5nrEQQRZneUUrQ?=
 =?us-ascii?Q?QKUbH0pCaAj3Emg46ZmlJR/t+2HqdoWc2CVOT0vccPNuOBKq0V6NCEH1N/iX?=
 =?us-ascii?Q?QqCgfWsZ5wA/wFkEsx1Oiq8RvHZk?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(36860700004)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 01:26:28.3254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9462bb7a-00a4-4703-2d2a-08dc747e0b4a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD81.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8446

It's not clear if SNP guests will need any other SNP-specific userspace
exit types in the future, and if they do, it's not clear that they would
necessary be related to VMGEXIT events or something else entirely.

So, rather than trying to anticipate future use-cases and have a single
union structure to manage the associated parameters, just use a common
KVM_EXIT_SNP_* prefix, but otherwise treat these as separate events, and
go ahead and convert the only VMGEXIT type currently defined,
KVM_USER_VMGEXIT_REQ_CERTS, over to KVM_EXIT_SNP_REQ_CERTS.

Also, formally document that kvm_run->immediate_exit is guaranteed to
handle userspace IO completion callbacks before returning to userspace
with -EINTR, and use this mechanism to allow userspace to use this
mechanism as a means to know when an attestation request is complete and
the KVM_EXIT_SNP_REQ_CERTS event is fully-finished, allowing userspace
to at that point handle any certificate synchronization cleanup like
releasing file locks/etc.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
Hi Sean,

Here's an attempt to address your concerns regarding
KVM_EXIT_VMGEXIT/KVM_USER_VMGEXIT_REQ_CERTS. Please let me know what
you think.

The main gist of it is that it leverages kvm->immediate_edit rather than
a flag in the kvm_run exit struct to receive notification when the
attestation has been completed and the certificate is no longer needed.

Additionally it drops the confusing KVM_EXIT_VMGEXIT naming in favor of
the KVM_EXIT_SNP_* prefix, and rather than introduce infrastructure and
a union to handle other SNP-specific types in the future, it simply
defines KVM_EXIT_SNP_REQ_CERTS as a one-off event so we are free to
handle future SNP-specific/SNP-related userspace exits however makes
sense for future cases.

Thanks,

Mike

 Documentation/virt/kvm/api.rst | 64 +++++++++++-----------------------
 arch/x86/kvm/svm/sev.c         | 28 +++------------
 include/uapi/linux/kvm.h       | 31 ++++++++--------
 3 files changed, 43 insertions(+), 80 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6ab8b5b7c64e..ea05c16f3438 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6381,6 +6381,11 @@ to avoid usage of KVM_SET_SIGNAL_MASK, which has worse scalability.
 Rather than blocking the signal outside KVM_RUN, userspace can set up
 a signal handler that sets run->immediate_exit to a non-zero value.
 
+Also note that any KVM_EXIT_* events that have associated completion
+callbacks that KVM needs to process when KVM_RUN is called will be
+processed *before* exiting again to userspace with -EINTR as a result
+of run->immediate_exit.
+
 This field is ignored if KVM_CAP_IMMEDIATE_EXIT is not available.
 
 ::
@@ -7069,50 +7074,24 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
 ::
 
-		/* KVM_EXIT_VMGEXIT */
-		struct kvm_user_vmgexit {
-  #define KVM_USER_VMGEXIT_REQ_CERTS		1
-			__u32 type; /* KVM_USER_VMGEXIT_* type */
-			union {
-				struct {
-					__u64 data_gpa;
-					__u64 data_npages;
-  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_INVALID_LEN   1
-  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_BUSY          2
-  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_GENERIC       (1 << 31)
-					__u32 ret;
-  #define KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE	BIT(0)
-					__u8 flags;
-  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING	0
-  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE		1
-					__u8 status;
-				} req_certs;
-			};
-		};
-
-
-If exit reason is KVM_EXIT_VMGEXIT then it indicates that an SEV-SNP guest
-has issued a VMGEXIT instruction (as documented by the AMD Architecture
-Programmer's Manual (APM)) to the hypervisor that needs to be serviced by
-userspace. These are generally handled by the host kernel, but in some
-cases some aspects of handling a VMGEXIT are done in userspace.
-
-A kvm_user_vmgexit structure is defined to encapsulate the data to be
-sent to or returned by userspace. The type field defines the specific type
-of exit that needs to be serviced, and that type is used as a discriminator
-to determine which union type should be used for input/output.
-
-KVM_USER_VMGEXIT_REQ_CERTS
---------------------------
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct {
+			__u64 data_gpa;
+			__u64 data_npages;
+  #define KVM_EXIT_SNP_REQ_CERTS_ERROR_INVALID_LEN   1
+  #define KVM_EXIT_SNP_REQ_CERTS_ERROR_BUSY          2
+  #define KVM_EXIT_SNP_REQ_CERTS_ERROR_GENERIC       (1 << 31)
+			__u32 ret;
+		} snp_req_certs;
 
 When an SEV-SNP issues a guest request for an attestation report, it has the
 option of issuing it in the form an *extended* guest request when a
 certificate blob is returned alongside the attestation report so the guest
 can validate the endorsement key used by SNP firmware to sign the report.
 These certificates are managed by userspace and are requested via
-KVM_EXIT_VMGEXITs using the KVM_USER_VMGEXIT_REQ_CERTS type.
+KVM_EXIT_SNP exits using the KVM_EXIT_SNP_REQ_CERTS type.
 
-For the KVM_USER_VMGEXIT_REQ_CERTS type, the req_certs union type
+For the KVM_EXIT_SNP_REQ_CERTS type, the req_certs union type
 is used. The kernel will supply in 'data_gpa' the value the guest supplies
 via the RAX field of the GHCB when issuing extended guest requests.
 'data_npages' will similarly contain the value the guest supplies in RBX
@@ -7139,12 +7118,11 @@ this is for the VMM to obtain a shared or exclusive lock on the path the
 certificate blob file resides at before reading it and returning it to KVM,
 and that it continues to hold the lock until the attestation request is
 actually sent to firmware. To facilitate this, the VMM can set the
-KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE flag before returning the
-certificate blob, in which case another KVM_EXIT_VMGEXIT of type
-KVM_USER_VMGEXIT_REQ_CERTS will be sent to userspace with
-KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE being set in the status field to
-indicate the request is fully-completed and that any associated locks can be
-released.
+run->immediate_exit flag before returning the certificate blob, in which
+case KVM is guaranteed to complete the issuing of all pending IO completion
+callbacks before exiting to userspace with EINTR. At this point userspace
+can release any locks it may have taken when the KVM_EXIT_SNP_REQ_CERTS exit
+was originally received.
 
 Tools/libraries that perform updates to SNP firmware TCB values or endorsement
 keys (e.g. firmware interfaces such as SNP_COMMIT, SNP_SET_CONFIG, or
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6cf665c410b2..e6318bbd8a6a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4006,21 +4006,14 @@ static int snp_complete_ext_guest_req(struct kvm_vcpu *vcpu)
 	sev_ret_code fw_err = 0;
 	int vmm_ret;
 
-	vmm_ret = vcpu->run->vmgexit.req_certs.ret;
+	vmm_ret = vcpu->run->snp_req_certs.ret;
 	if (vmm_ret) {
 		if (vmm_ret == SNP_GUEST_VMM_ERR_INVALID_LEN)
 			vcpu->arch.regs[VCPU_REGS_RBX] =
-				vcpu->run->vmgexit.req_certs.data_npages;
+				vcpu->run->snp_req_certs.data_npages;
 		goto out;
 	}
 
-	/*
-	 * The request was completed on the previous completion callback and
-	 * this completion is only for the STATUS_DONE userspace notification.
-	 */
-	if (vcpu->run->vmgexit.req_certs.status == KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE)
-		goto out_resume;
-
 	control = &svm->vmcb->control;
 
 	if (__snp_handle_guest_req(kvm, control->exit_info_1,
@@ -4029,14 +4022,6 @@ static int snp_complete_ext_guest_req(struct kvm_vcpu *vcpu)
 
 out:
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
-
-	if (vcpu->run->vmgexit.req_certs.flags & KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE) {
-		vcpu->run->vmgexit.req_certs.status = KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE;
-		vcpu->run->vmgexit.req_certs.flags = 0;
-		return 0; /* notify userspace of completion */
-	}
-
-out_resume:
 	return 1; /* resume guest */
 }
 
@@ -4060,12 +4045,9 @@ static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
 	 * Grab the certificates from userspace so that can be bundled with
 	 * attestation/guest requests.
 	 */
-	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
-	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_REQ_CERTS;
-	vcpu->run->vmgexit.req_certs.data_gpa = data_gpa;
-	vcpu->run->vmgexit.req_certs.data_npages = data_npages;
-	vcpu->run->vmgexit.req_certs.flags = 0;
-	vcpu->run->vmgexit.req_certs.status = KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING;
+	vcpu->run->exit_reason = KVM_EXIT_SNP_REQ_CERTS;
+	vcpu->run->snp_req_certs.data_gpa = data_gpa;
+	vcpu->run->snp_req_certs.data_npages = data_npages;
 	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_req;
 
 	return 0; /* forward request to userspace */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 106367d87189..8ebfc91dc967 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,22 +135,17 @@ struct kvm_xen_exit {
 	} u;
 };
 
-struct kvm_user_vmgexit {
-#define KVM_USER_VMGEXIT_REQ_CERTS		1
-	__u32 type; /* KVM_USER_VMGEXIT_* type */
+struct kvm_exit_snp {
+#define KVM_EXIT_SNP_REQ_CERTS		1
+	__u32 type; /* KVM_EXIT_SNP_* type */
 	union {
 		struct {
 			__u64 data_gpa;
 			__u64 data_npages;
-#define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_INVALID_LEN   1
-#define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_BUSY          2
-#define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_GENERIC       (1 << 31)
+#define KVM_EXIT_SNP_REQ_CERTS_ERROR_INVALID_LEN   1
+#define KVM_EXIT_SNP_REQ_CERTS_ERROR_BUSY          2
+#define KVM_EXIT_SNP_REQ_CERTS_ERROR_GENERIC       (1 << 31)
 			__u32 ret;
-#define KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE	BIT(0)
-			__u8 flags;
-#define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING	0
-#define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE		1
-			__u8 status;
 		} req_certs;
 	};
 };
@@ -198,7 +193,7 @@ struct kvm_user_vmgexit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
-#define KVM_EXIT_VMGEXIT          40
+#define KVM_EXIT_SNP_REQUEST_CERTS 40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -454,8 +449,16 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
-		/* KVM_EXIT_VMGEXIT */
-		struct kvm_user_vmgexit vmgexit;
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct {
+			__u64 data_gpa;
+			__u64 data_npages;
+#define KVM_EXIT_SNP_REQ_CERTS_ERROR_INVALID_LEN   1
+#define KVM_EXIT_SNP_REQ_CERTS_ERROR_BUSY          2
+#define KVM_EXIT_SNP_REQ_CERTS_ERROR_GENERIC       (1 << 31)
+			__u32 ret;
+		} snp_req_certs;
+
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1


