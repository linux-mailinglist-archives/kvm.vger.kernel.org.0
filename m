Return-Path: <kvm+bounces-17222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BDF8C2BB8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F0C71F264D9
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8472013BC2A;
	Fri, 10 May 2024 21:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BaW8GBDd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8991E50A;
	Fri, 10 May 2024 21:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376023; cv=fail; b=shJ7pr8PSqJL4zjku0sut4px8Aj+6UTT77e0oSHGY75jgFwgd+LHUHO+HAPqEWQrUd10SwlpENP6tLZ40O5VKACIWoolULDdZUDKVotsUegEZLKd5fj1MKjpg67OpK6NbEsdIjwySes44jncvSe50LFWXyrItGYzwV1NI6NyyzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376023; c=relaxed/simple;
	bh=qq+LzuA6/F/n9MAi1f1sSPIDhS1q+yKXp8gnxHfzTbY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qyCoC3wHILmCVKrPRrD/m3fjEM7KOqj+DvLHNIaPU/xBrO4+X6IlMJyPsKWgzuabXN5kPilYfGmOV2MtAEs9HSgkmek1GCkihxIyYowjK0TIu0LPC87sK5RXaH1Z6kP0T47U+zabjzfwZBLYsaXmW3XnRQNxQyhhA7OZCb6dY54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BaW8GBDd; arc=fail smtp.client-ip=40.107.95.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEpmL0ZJei7/fFt4WlsV5SuBkETED0srtBb0eKQn7wlbAslR0kKs9IyLqq/mqJ2G+HxEA0LA5c1HzWiixN7e+HOs6lgdlk+qMQy1NYIv6lrmF/iPIRWhIWUdJ65grU/047CSrwpdf05XlV4MZtnUYOGP0+r4Dg1GGV8sa/m6sMJrMrSdpuYw5pZBvJj1XkM/CLbUGusQkX4W6xfwIj4yGMqc26jWNdWq1nUXe7DCaD/5or0mBtKWrTAo5zC4xGz+yy+0+h1C7aUqJbSAmHdgKNa8rKgml1kr/0zjztdERBr0pVvMFwp1NvU2zjwfARG0+0M8wvkAM/23QcG4YJQeog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEPvc8sfs2dT4aUFDZf7AguOgqs8sZ4STptfn0aYLEA=;
 b=NuQxmz34+ccCdQtt59SAhdQhWl3l/7/s0GXYBTLBE3asDwf40YdUJ9lBTSGG5Xtak0f/wGbzlc9C8/vW/Ax4nP/K4ExGuRhm+suOyIr9Hi+TdpFrsVzA0GyAmCiofcYUkw/9/kmaWx3mD61ga7RYA/CiD9EYkznOALYIpdxCZVHc3y85IXD4lwUZF1wqpXFzeB4Py7dqQOygEHhdsotW6QrCXVqrDiN9ZoWqHEC9kiSy9M0ru4rqQEANyaTW9bkNFmNqHECOUTwcxl+TW1jdeWaCVCqcNX+Jb+o98spyeKsWHRBHL6OAJFsF/I9F+eVs6/pN38tI0mGQrLSYYS+Bag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEPvc8sfs2dT4aUFDZf7AguOgqs8sZ4STptfn0aYLEA=;
 b=BaW8GBDdcDVq26+odrU7pIaIwf4F4ypyFQT+0s6M2uBmElgPwuIDe6hPofpvS0+mkEEUm5E/vFfeuTT3/33fhu/fvbIdn2i/NSGMGbwpFX6OWQ4lJL2RtsJ8Ndo6AVDOBJbdfKV/i3PPFp6+JDvnrmEQn1ZbKw32lNSRaHc3FlI=
Received: from PH7P220CA0119.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::6)
 by PH7PR12MB5903.namprd12.prod.outlook.com (2603:10b6:510:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Fri, 10 May
 2024 21:20:17 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:510:32d:cafe::70) by PH7P220CA0119.outlook.office365.com
 (2603:10b6:510:32d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49 via Frontend
 Transport; Fri, 10 May 2024 21:20:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:20:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:20:11 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>
Subject: [PULL 18/19] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Fri, 10 May 2024 16:10:23 -0500
Message-ID: <20240510211024.556136-19-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|PH7PR12MB5903:EE_
X-MS-Office365-Filtering-Correlation-Id: 74b7919a-fc21-47e1-2af9-08dc7136fafa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PWcG0fxGgbp8r3hPtH+DMT7t1cd2jL3wO636MHcfkjIYgzF6YWOIKgheOcbm?=
 =?us-ascii?Q?nT9BMQzWcxKyRbC2Dn7iPzOfughy9JFeW9Zmne6Y7Jm3Vx7tWWtgt47xpZ5m?=
 =?us-ascii?Q?XRex7ITYPukSs+q8KThrwJ5xglMm9SsJyw+XXjAXg0lWmiw30WuuCxdOWfEA?=
 =?us-ascii?Q?UBFLEyOBRxCKhjEiG/7ythTKPZ2YebpVR0P5f/cFiJCeOMkkiOx+A8QOUgWy?=
 =?us-ascii?Q?8DhwHakuhX3YiBUnv8c+LpmDm5Bi7y5OP54yiChTBJWjCoTyebW8phDwkJux?=
 =?us-ascii?Q?MjOTImk7WIfBgNDnd/+DRJmgqX1SWMeAvEtExWwol6i4UpOW5SRSuFe/K5xe?=
 =?us-ascii?Q?G8MKF2ap4u6vHnyu6f9MZpEKqVYg3UmFUh9/JeVXPydE8Wd53BTUhCeKJ0aR?=
 =?us-ascii?Q?U13/uIB9mmKj/SG8WyVfMIUSJw5STO/5/vWQAzFX8pj8JxQQITXqkIZnr+4Q?=
 =?us-ascii?Q?ZMa+WVFoTRSTXWWbABuvWPMw9B788/7YXhlh4QEnAUfMZgqPYR5tsh/f9vix?=
 =?us-ascii?Q?1Yh4mWt12usIUpZWgx2ybrqjZgwGejnUpHJaEcN2uaF+6l0JazORTRNF544i?=
 =?us-ascii?Q?LAUL0EqITPoaz7k+fGYk8MS87kL2nx8HAFs9sDiu0uXTv4VAZsFlSjyh61Ga?=
 =?us-ascii?Q?GLdX/9CBSQrcToLquJ/FXNGbzgiA4ikgbgpl49huoUQiJDfpNCGvVop0D1rx?=
 =?us-ascii?Q?+5Cs0p7kCDK05rC8gfCVjoKJLnTTFxW+fjRBdat3hzhVxNdJJr/e9CuvjziI?=
 =?us-ascii?Q?S7gv+XuTMGjB7xjQMKtA6cXfnK15PJHgF791DerHFTcfAilj3NaN9xnKFRCx?=
 =?us-ascii?Q?iP5DK2nR+3bosbE7heTF72UEW9/VDGV7fr1I2ze5hVFJqmGQXWijsZI2oQQJ?=
 =?us-ascii?Q?7jGXoC1xwVhhdTHip4jK+XTosc66M6Bq6w8bmrLcdoVej5B9Z66rco94+EOn?=
 =?us-ascii?Q?gowbkjjMRbtRahy4pegbEFx08T6xJpEMwrcbc4+g7oDz3UHO4aRi78G2c1uP?=
 =?us-ascii?Q?ZxPXy3GZyCJ01k/SnjEGYMlQCwAclJE5glGmJu56RNVaYSplhmUfOLEt7GDD?=
 =?us-ascii?Q?WJ0q+S6Mocv6EVmul2yueZRjJbYUTJV/c8EqQXzHM5k5BsSkOr7KYw88IFJD?=
 =?us-ascii?Q?IORdy9wv37N7bEKT2h52MoGF+mZBw19ODsAyKTb6N/Byoc7wrDA6xVT3wwRk?=
 =?us-ascii?Q?uNejmMrKSDZNnO1GhgSfQnUAWGwpH1E00HjIc0jQjeIPprXbROIJX0NGYDnb?=
 =?us-ascii?Q?L5CEyTzhpje0YcRjpucgFmWvA7UTB4MqyhjqgsqLJwEyriNIvz5UkxfgUzrj?=
 =?us-ascii?Q?n3Ajmvt2o/M6KXt2bSEJgP7r9CDt5fL29d4JWTN0XsygvzvCK0okk9TVFTYe?=
 =?us-ascii?Q?j2GHFTI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:20:13.1545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b7919a-fc21-47e1-2af9-08dc7136fafa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5903

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
Message-ID: <20240501085210.2213060-20-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
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
index 00d29d278f6e..398266bef2ca 100644
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
@@ -3996,6 +4001,84 @@ static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp
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
@@ -4274,6 +4357,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
index 555c55f50298..97b3683ea324 100644
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


