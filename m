Return-Path: <kvm+bounces-16317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC6E78B873A
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A45DDB21469
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D6151C44;
	Wed,  1 May 2024 09:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hhdFfRMp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7CF1DFDE;
	Wed,  1 May 2024 09:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554378; cv=fail; b=ITtMrfGZaKFRNpGwllPdLvcIck/ztLLZDwNhcJtNOqWUAMTJJXhSSOL6EXRtwSQ+OOneP+UxmQwNrRp7uNPEoKt+p7gPmE5mhBx9r+Ccky7VRaNgiYs+uVIRCOivDK1KiUBP9YG54YwGtZAr40Bvo5+y1LB6k8TMpzG81VD2ZEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554378; c=relaxed/simple;
	bh=gmL4udGgV2x6xxYceh5KDXcZ8ilHLlyEcPMu/isz0Lo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBS4Oi8r/Q5V04NLRiglWHoFJTqrFrmGkLcrISGkOTSPNzNMgRuqWsM3PFqftG4VFyxk3wFDSMQW1quMFtMGd3bLSGscVhjLpujhGmhp5XPEqIOoUjxOvbAvI8DGhlxn7wC5Ws7isqfZ4LaeUf+RWv8x9n9qsbsDIYBIcyvBDgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hhdFfRMp; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euz/LBgcQHSnCYvWGLTaXNiVQAPteE2Zn+NdyIeiXEGH0y3Ocg7tYlguLjhKiWoLTQOaO50CrvcRvIiOgc7S2O+sqJTF5OIT1epkZQU/qBatD4Gb+KElmPDo1I475UPa2RZz0fvHLc4m3H/QHhI6xAjYmW5hICovs0jdUXjxcEqw98FhjMg5NNgvmREKiQdtO0kUwCdb+1lkSESBbbA6ZIJHi5ZCFEuZt8bu1sBMV6UFA8NlPYDob9U9bz5KrDj3wfLbumJ8f+eWXzLrCP/By0U+54oRiXocfC/TRBzK+eFn9ZfUlhAfBdpoYZfdFa82qxGy5kmZkrZyqwBP0VD+2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpKnivgAVH2H/wCIQAMeWVTFrkr7yKIT0Qi9SSKf8jk=;
 b=au2DfYocEIGFA83z2eMYqy6TknYOXMwKGa5rcGrMTX+6JjBDWlk491bDr8CM/fdATMa/r0uVlLdvZpENKA+5gtl2LqyqBswiPgR/Ahvcji/lvy0fIMJp1YFSPM6XZwunAbuvx9OC45v/DqQ1KciYUfQZz3TPrj2U2nMDymDiUi5JFGlCgtWxA2BDPwbK4/WMKW+c0mWKmENNmEnE8sIqv7h79ziRKsZ1jN9fLAaGMv0Z5jDfYY7etbs8d6r+RNZMRA/hVL25W7rwz4o8ekSrh4fBVbeIsjKpfSV27aCkdr0nN0fpKuIEplmdCpj8A+St4GVvHmGTB/cimjrD4P+URA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpKnivgAVH2H/wCIQAMeWVTFrkr7yKIT0Qi9SSKf8jk=;
 b=hhdFfRMp3SwneAGvgueb/kBipUwfChQDdukYjL2PPWFqhxoTpQDrSlLW0ABiif0Fbt0xCOTk04eOBDC8mak5bohF9yNkE0UsNzokZSIAjwNbfNXK9nV/hGaeGggE4Cov8xP0cY7IKo7elTs4P9J5I4RcgJlT4tFywr+dN23c7mM=
Received: from BN9PR03CA0523.namprd03.prod.outlook.com (2603:10b6:408:131::18)
 by SN7PR12MB7154.namprd12.prod.outlook.com (2603:10b6:806:2a5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 09:06:12 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:131:cafe::f7) by BN9PR03CA0523.outlook.office365.com
 (2603:10b6:408:131::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36 via Frontend
 Transport; Wed, 1 May 2024 09:06:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:06:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:06:10 -0500
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
Subject: [PATCH v15 19/20] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Wed, 1 May 2024 03:52:09 -0500
Message-ID: <20240501085210.2213060-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|SN7PR12MB7154:EE_
X-MS-Office365-Filtering-Correlation-Id: 445e63d8-c90d-4659-70d0-08dc69bdf2be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|1800799015|82310400014|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XHWBHG4RyxSyohYa7PC8PGj6bbR4/2e4nSNfl4gjBCRIpyb1FtiT2u2yYuro?=
 =?us-ascii?Q?VM5KQm5pKQn7N4+R6xswO4oU6guC5pwebB4JDID0VlVlB/msUjKK8BW4AZj/?=
 =?us-ascii?Q?iX1w9t0773870SSDHpOw/IWMgq0WlJ40TPZpH9ThQUBtJtA9Qgge/7QyM+SW?=
 =?us-ascii?Q?dcEkqXHCMUluHhp63dYdf14vzKVe+77X4dZYKFbk5LRhPc2PmbKknyGre4Aq?=
 =?us-ascii?Q?EaJtfXiKvQVUzngcK3HQOmMPWHcPcUHIpU4gYOjkfDUTcb/lMc4ZXiJjCQF7?=
 =?us-ascii?Q?zshr/puC6cOCBV3E87lfq1qhG8hLqcAScUA85JnGEc98bNGWydTmblgDcKOX?=
 =?us-ascii?Q?He2X9oc0S+88X0vB0D/rir+rKVO11HEL0c3NqJ07yL4QQX9HkjUSmMv8BkbD?=
 =?us-ascii?Q?cfi4ETdHSc9rdufOu9ctYj+fGZuoTJYRNzciu1iRgCm9XumFdwpOZ3PCVLfH?=
 =?us-ascii?Q?ewzh9Ptwb/duzqo0OnwVXgDjy+NXIpHk9j3X0/IR4ss1JtZgWA3MBr9xqZ/0?=
 =?us-ascii?Q?0piCiSAFS22hecrO99t67JrU3CxFaVleaUhtdFr0OAZmxnMO1RCPaXtdB22k?=
 =?us-ascii?Q?fdM1pjVMrq6/XsmFVEiPJNKSIzhyfF/6r8FcHFutawlBuGeqP/3NId4dQyi+?=
 =?us-ascii?Q?aiQobzNTNzvww62Q5ktAR1bjh4KbNVfeqzVwaSs//YLbz3ypf5duT6KjDDeW?=
 =?us-ascii?Q?FSCfu9QeDkTaTOjcB9TPaoNRkaXBmI5S/g5icspAA90VZcPZIDibMtmfJzU6?=
 =?us-ascii?Q?b0akTMs+xuidicz3Yb0Dy5UlGTaUVStCaFMTRsy+n3bDTAnn09JrNFnw9LTj?=
 =?us-ascii?Q?X62r0YMhX47m0Ix99go5Fgu+5C+4lZiAkeORzZUQs1LmJEuD0ErSxGL8pvLs?=
 =?us-ascii?Q?SffdSh+Y1g6xTXhAeqS21d6AReJVATVe6TAoWCOJfppIT+sYsnnYxHd5SNvE?=
 =?us-ascii?Q?5yokwJjewzcWFM7s/N+lSNO1EKO3MZuNRV2nsdG8s6nmi9ArMtVRmLvc9no3?=
 =?us-ascii?Q?nSWwBgMnxukCvqmNEpHgyVvDnB3dTsN6Em6j6kilMwRRlJHnVkQDBiwsFZr5?=
 =?us-ascii?Q?Wj36kPxXwQzeXp1lDFy9o9Ag7A2HCBXlH3ocmwgDTPNGynjJPEIxtPQRPcBW?=
 =?us-ascii?Q?GxNaIiCHafz2Yf3sG28qq8IPN5WhNHwfEj9iEnv57wS8t290RgDuQuYa7dIu?=
 =?us-ascii?Q?hQjS12WTNl93zxEDbeMIdueDRO5PtpPziLhng+Hqi4se4/WtOXsq9dMYJEeW?=
 =?us-ascii?Q?8qX9ZQ81OfFHflh33APt87a7sWyoq1b3gou5GG+e7HkxOku7Cp/zHHekNbDH?=
 =?us-ascii?Q?RVpKAtOom5vGx8gBowqQKOj3OGOijDETWRW9YJN0xZOnEYyXCxeWGedRPbJB?=
 =?us-ascii?Q?6zMPfrJjaBrOSPvnKbI7P4QyeWls?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(82310400014)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:06:12.1445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 445e63d8-c90d-4659-70d0-08dc69bdf2be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7154

Version 2 of GHCB specification added support for the SNP Extended Guest
Request Message NAE event. This event serves a nearly identical purpose
to the previously-added SNP_GUEST_REQUEST event, but allows for
additional certificate data to be supplied via an additional
guest-supplied buffer to be used mainly for verifying the signature of
an attestation report as returned by firmware.

This certificate data is supplied by userspace, so unlike with
SNP_GUEST_REQUEST events, SNP_EXTENDED_GUEST_REQUEST events are first
forwarded to userspace via a KVM_EXIT_VMGEXIT exit structure, and then
the firmware request is made after the certificate data has been fetched
from userspace.

Since there is a potential for race conditions where the
userspace-supplied certificate data may be out-of-sync relative to the
reported TCB or VLEK that firmware will use when signing attestation
reports, a hook is also provided so that userspace can be informed once
the attestation request is actually completed. See the updates to
Documentation/ for more details on these aspects.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst | 87 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/sev.c         | 86 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h         |  3 ++
 include/uapi/linux/kvm.h       | 23 +++++++++
 4 files changed, 199 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f0b76ff5030d..f3780ac98d56 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7060,6 +7060,93 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_VMGEXIT */
+		struct kvm_user_vmgexit {
+  #define KVM_USER_VMGEXIT_REQ_CERTS		1
+			__u32 type; /* KVM_USER_VMGEXIT_* type */
+			union {
+				struct {
+					__u64 data_gpa;
+					__u64 data_npages;
+  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_INVALID_LEN   1
+  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_BUSY          2
+  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_GENERIC       (1 << 31)
+					__u32 ret;
+  #define KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE	BIT(0)
+					__u8 flags;
+  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING	0
+  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE		1
+					__u8 status;
+				} req_certs;
+			};
+		};
+
+
+If exit reason is KVM_EXIT_VMGEXIT then it indicates that an SEV-SNP guest
+has issued a VMGEXIT instruction (as documented by the AMD Architecture
+Programmer's Manual (APM)) to the hypervisor that needs to be serviced by
+userspace. These are generally handled by the host kernel, but in some
+cases some aspects of handling a VMGEXIT are done in userspace.
+
+A kvm_user_vmgexit structure is defined to encapsulate the data to be
+sent to or returned by userspace. The type field defines the specific type
+of exit that needs to be serviced, and that type is used as a discriminator
+to determine which union type should be used for input/output.
+
+KVM_USER_VMGEXIT_REQ_CERTS
+--------------------------
+
+When an SEV-SNP issues a guest request for an attestation report, it has the
+option of issuing it in the form an *extended* guest request when a
+certificate blob is returned alongside the attestation report so the guest
+can validate the endorsement key used by SNP firmware to sign the report.
+These certificates are managed by userspace and are requested via
+KVM_EXIT_VMGEXITs using the KVM_USER_VMGEXIT_REQ_CERTS type.
+
+For the KVM_USER_VMGEXIT_REQ_CERTS type, the req_certs union type
+is used. The kernel will supply in 'data_gpa' the value the guest supplies
+via the RAX field of the GHCB when issuing extended guest requests.
+'data_npages' will similarly contain the value the guest supplies in RBX
+denoting the number of shared pages available to write the certificate
+data into.
+
+  - If the supplied number of pages is sufficient, userspace should write
+    the certificate data blob (in the format defined by the GHCB spec) in
+    the address indicated by 'data_gpa' and set 'ret' to 0.
+
+  - If the number of pages supplied is not sufficient, userspace must write
+    the required number of pages in 'data_npages' and then set 'ret' to 1.
+
+  - If userspace is temporarily unable to handle the request, 'ret' should
+    be set to 2 to inform the guest to retry later.
+
+  - If some other error occurred, userspace should set 'ret' to a non-zero
+    value that is distinct from the specific return values mentioned above.
+
+Generally some care needs be taken to keep the returned certificate data in
+sync with the actual endorsement key in use by firmware at the time the
+attestation request is sent to SNP firmware. The recommended scheme to do
+this is for the VMM to obtain a shared or exclusive lock on the path the
+certificate blob file resides at before reading it and returning it to KVM,
+and that it continues to hold the lock until the attestation request is
+actually sent to firmware. To facilitate this, the VMM can set the
+KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE flag before returning the
+certificate blob, in which case another KVM_EXIT_VMGEXIT of type
+KVM_USER_VMGEXIT_REQ_CERTS will be sent to userspace with
+KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE being set in the status field to
+indicate the request is fully-completed and that any associated locks can be
+released.
+
+Tools/libraries that perform updates to SNP firmware TCB values or endorsement
+keys (e.g. firmware interfaces such as SNP_COMMIT, SNP_SET_CONFIG, or
+SNP_VLEK_LOAD, see Documentation/virt/coco/sev-guest.rst for more details) in
+such a way that the certificate blob needs to be updated, should similarly
+take an exclusive lock on the certificate blob for the duration of any updates
+to firmware or the certificate blob contents to ensure that VMMs using the
+above scheme will not return certificate blob data that is out of sync with
+firmware.
 
 6. Capabilities that can be enabled on vCPUs
 ============================================
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5c6262f3232f..35f0bd91f92e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3297,6 +3297,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!sev_snp_guest(vcpu->kvm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
+		if (!sev_snp_guest(vcpu->kvm) || !kvm_ghcb_rax_is_valid(svm) ||
+		    !kvm_ghcb_rbx_is_valid(svm))
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -3988,6 +3993,84 @@ static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
 }
 
+static int snp_complete_ext_guest_req(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control;
+	struct kvm *kvm = vcpu->kvm;
+	sev_ret_code fw_err = 0;
+	int vmm_ret;
+
+	vmm_ret = vcpu->run->vmgexit.req_certs.ret;
+	if (vmm_ret) {
+		if (vmm_ret == SNP_GUEST_VMM_ERR_INVALID_LEN)
+			vcpu->arch.regs[VCPU_REGS_RBX] =
+				vcpu->run->vmgexit.req_certs.data_npages;
+		goto out;
+	}
+
+	/*
+	 * The request was completed on the previous completion callback and
+	 * this completion is only for the STATUS_DONE userspace notification.
+	 */
+	if (vcpu->run->vmgexit.req_certs.status == KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE)
+		goto out_resume;
+
+	control = &svm->vmcb->control;
+
+	if (__snp_handle_guest_req(kvm, control->exit_info_1,
+				   control->exit_info_2, &fw_err))
+		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+
+out:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+
+	if (vcpu->run->vmgexit.req_certs.flags & KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE) {
+		vcpu->run->vmgexit.req_certs.status = KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE;
+		vcpu->run->vmgexit.req_certs.flags = 0;
+		return 0; /* notify userspace of completion */
+	}
+
+out_resume:
+	return 1; /* resume guest */
+}
+
+static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
+{
+	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long data_npages;
+	sev_ret_code fw_err;
+	gpa_t data_gpa;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		goto abort_request;
+
+	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
+	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
+
+	if (!IS_ALIGNED(data_gpa, PAGE_SIZE))
+		goto abort_request;
+
+	/*
+	 * Grab the certificates from userspace so that can be bundled with
+	 * attestation/guest requests.
+	 */
+	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_REQ_CERTS;
+	vcpu->run->vmgexit.req_certs.data_gpa = data_gpa;
+	vcpu->run->vmgexit.req_certs.data_npages = data_npages;
+	vcpu->run->vmgexit.req_certs.flags = 0;
+	vcpu->run->vmgexit.req_certs.status = KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING;
+	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_req;
+
+	return 0; /* forward request to userspace */
+
+abort_request:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+	return 1; /* resume guest */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4266,6 +4349,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
+		ret = snp_begin_ext_guest_req(vcpu);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e325ede0f463..83c562b4712a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -309,6 +309,9 @@ struct vcpu_svm {
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;
+
+	/* Transaction ID associated with SNP config updates */
+	u64 snp_transaction_id;
 };
 
 struct svm_cpu_data {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..106367d87189 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,26 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_user_vmgexit {
+#define KVM_USER_VMGEXIT_REQ_CERTS		1
+	__u32 type; /* KVM_USER_VMGEXIT_* type */
+	union {
+		struct {
+			__u64 data_gpa;
+			__u64 data_npages;
+#define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_INVALID_LEN   1
+#define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_BUSY          2
+#define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_GENERIC       (1 << 31)
+			__u32 ret;
+#define KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE	BIT(0)
+			__u8 flags;
+#define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING	0
+#define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE		1
+			__u8 status;
+		} req_certs;
+	};
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -178,6 +198,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_VMGEXIT          40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -433,6 +454,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_VMGEXIT */
+		struct kvm_user_vmgexit vmgexit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1


