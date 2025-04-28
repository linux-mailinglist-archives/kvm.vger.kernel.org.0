Return-Path: <kvm+bounces-44600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8029EA9F9F7
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1C3A188C4BF
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 19:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22542973D8;
	Mon, 28 Apr 2025 19:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f0v7/0lK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50631C2DB2;
	Mon, 28 Apr 2025 19:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745869948; cv=fail; b=TOPaopuixIcGtnRKYyHbLtT8FGw6t26aLuqDQUrOm/StAJYDpUbnFvV/YDf9u2p+qbKEyES8fZg2l45WauoYu2FPiHBi4SkDYOZ9C8RmN06syXT8h2DzTulhlZSLTB/p4m1MICz3J5GWTK9cijhpISofQjcNNbEO+FQecw6lT+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745869948; c=relaxed/simple;
	bh=QkKaByQB+hdZlOojQr0npgdchoUuavr5TjMlqDvKaxU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jMPB9fkO/OUVRg5POnlWinY88Rf0K+8u1T/UzaeuFzOISSI3J+EAi7TcyF4+mQHa4Lx+uu9KPSLF2e1QcmUnR+pmP3FGT5g9Qr3jG2zq1R/jhgQ4DK1nJ+0/55r3UvFle6DQAEbbn67F4hvCJQhBH2Bz0o/kYbahsdl2hbIYuj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f0v7/0lK; arc=fail smtp.client-ip=40.107.92.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9kJX6fN/rQCCcDJ//W0zaD/AAuqbzG2fBQjhvuXBgQL1uiu5H/QZlizWGMqrmTBDb9962vF1u3vgSWKMmcEY2yix8aNJ1QkqrIEnwLZBXNortv2dXZHTJxv1wJuiGRWPg5spsFM+hJfxkBsFh4OSCV4o8fTojV9Fj5U2P6MVHybunRCnBgrkerjriK0beu85A7LvEvdqPjVOFGoECCjCO+JIu/0rksHjSDMrehtd3Y9OdhhI4v7c4Dybam0KgP4l1DVG3UjjbJ9SrCbTDrGQ6YEcc4qYCGgSYFsGf+z2Bz2QJ9+G4vCIR7yjss8KjvmAdFsZbrrbgCjN6UgGf2fAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5/bj5QA9aO0L06IZsB/QsbTzGMO0B9HKbM4A5soaYSk=;
 b=nQXzMokAaDvHKtT82E0fiwltXB/SG7HfYXWlcYNxNN7sIUPQVYCtRBVNzfA4MRMhUw8yXAl8IKrLyMv/E6jByhn3jeAl/h6mB2U+LHCcS8/Sv4ndMlGRG6X+hPikx2TCgZ+6UsD6GiXcL/4gH7MeG2kggmsacdni3scVLE2RPcCfOdcOD34XGjybSPnYcbbU3TUObvLtiFk4LhtnOAEtounnH8zKm0qTOuLumiWXKnWB/IC+I9ou5yZVt8K08sPCbBEBEBRFW9gFgm0MRA6Seh/J1+NWtBoy6GkyXh/Xxj7vnufIUyjpth9UkhHWJAWvpxlh+6Ph0qKGyKN623XM2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/bj5QA9aO0L06IZsB/QsbTzGMO0B9HKbM4A5soaYSk=;
 b=f0v7/0lKEOLsNtC3lGFR86JVrWsXuSS/cifQ3Y540TaHWFHofvBmmaK6iHQc7HhMH72vBlSCiJVgpxfRQ/cdqrIts5Cv9IaEBW8R/g94tjnGyTdEdZkwHxTlo8JOdHxDA2cAoJKxUmXNtGMxwJoT8ggYRzyJr19OWjzamrQuPuc=
Received: from MW4PR03CA0331.namprd03.prod.outlook.com (2603:10b6:303:dc::6)
 by SA1PR12MB8887.namprd12.prod.outlook.com (2603:10b6:806:386::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Mon, 28 Apr
 2025 19:52:22 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:303:dc:cafe::91) by MW4PR03CA0331.outlook.office365.com
 (2603:10b6:303:dc::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Mon,
 28 Apr 2025 19:52:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Mon, 28 Apr 2025 19:52:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Apr
 2025 14:52:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <liam.merwick@oracle.com>,
	<dionnaglaze@google.com>, <huibo.wang@amd.com>
Subject: [PATCH v6 1/2] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
Date: Mon, 28 Apr 2025 14:51:12 -0500
Message-ID: <20250428195113.392303-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250428195113.392303-1-michael.roth@amd.com>
References: <20250428195113.392303-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|SA1PR12MB8887:EE_
X-MS-Office365-Filtering-Correlation-Id: 336becda-5c82-428c-e325-08dd868e3001
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e3q68q/ondzJCWvlGapTSe1rthIVVAPk4dWZT3cvvXMZKIzwSzw2935iS6S5?=
 =?us-ascii?Q?Yfucq7XmypXFNVD9/KPwo44HQns0IQDRbpKeU3anEm+Ku+jdJzJVXeli9z+2?=
 =?us-ascii?Q?zTucCq4MnEiX9rg57LhPve6iCbhbtcyzj+lHp32EoPCbUU+pFKF/cOkd4L2e?=
 =?us-ascii?Q?+dW/ExBB0m7dc+pQYsikC2JLKPNBuOF6HvlT7vj1mUzi2+QLp8cAJv46HVpB?=
 =?us-ascii?Q?QicyNbIorGXgUfZJCgMkKttVAv0XBEzCUbQtrrQKH60K+9aVMgGddcUtZ+j3?=
 =?us-ascii?Q?OKHyHgpMBe9TdNSkX1j/YYrr8vuZZd7C2nLW00j6gaJKae9FxMum+v2+EflZ?=
 =?us-ascii?Q?AgzWRsn7OhSn7xyFefJjyPu5/vwujv5aoKegCsHmKoothRMHntzIzoKvSP1i?=
 =?us-ascii?Q?MxsvEq3IAEgKTUkv9+HO67bG637jKoD12YE8QaUxHQkfka0BVS7WFIjomg4S?=
 =?us-ascii?Q?Xdn+dP/wtP31UmQjcZ0nuX+DaFLuIuaxS4ss+jCHdAWdGMjdONZumCHy2O9/?=
 =?us-ascii?Q?ifJKCrxaTAREV/APULcHNFRF2NxB2B+sabGyZ80UOcxJkh9Mk7OZ1dr3akp0?=
 =?us-ascii?Q?uKYPaOYu9hEDJsh1HueHMkfWKA3RHck3VUYieTDiq0ZSstOOMcn8ASkzjyyy?=
 =?us-ascii?Q?qACccxnAS8CjvgAnGAMyGjyCB1QRH4D1RMR7eaedRsQlChYm1bBeTdhv+xKp?=
 =?us-ascii?Q?zvE+pYN83ontGWU6tSvPOaJ06MYBiVXeM2YMmaEteK3QiFa/YGR5owj4Jl69?=
 =?us-ascii?Q?9un/hGj56n6N8z4rb67gS2NZ6g9eGB+fR1NJ/7zhi2qBSrY3HfZt8Re472s7?=
 =?us-ascii?Q?kKSvbCJRL8mSlmT0UMulpYFSp6wYkrit0t5i5QqW2GAZsu/e6VbHlxTDJkVc?=
 =?us-ascii?Q?z6uWlUtmzxKVuMsOitrnnozn1nrf9mL2HTzWZ14aO1ZTMbwCEcA4BxOFjQjg?=
 =?us-ascii?Q?eUHXNzq6h2xFFEbXKcyzNgx27jIUVN6R7muQxj/UPIBR5M8JDKzTl6jorLGn?=
 =?us-ascii?Q?QxHNR9llsA8aRDi8P/7qaZkm3pyMwU8diPbUtyavYAzEH9PymxvAopKIXuug?=
 =?us-ascii?Q?qu0nZp3hg5FPSlglPfrpH1sRhVG4ylewBV52Yvy3StmNYEGvksbO4SQgj6dI?=
 =?us-ascii?Q?0bkI94nC0EdsJDVZ0vIpBiLfIPOsU+aIwBSXPYQzjVKIhT7lr/rpkYJ6729C?=
 =?us-ascii?Q?5o0iHP/KekknA/pOH4arouORc3r6zGVO5SQQeDDesFPTnpEEkGGw9dKlNoBX?=
 =?us-ascii?Q?5oH7lU7NLhwfDFxSnaCSBj4KqefzDYUt3DtkJOuG5B62sGJ6l1vUIDq87qjl?=
 =?us-ascii?Q?AjudGK9Fx/0w08sPfmdk7bRJZSmTeMcjzx2EJTiXrvDaMeuqUF2z8cxomBtt?=
 =?us-ascii?Q?oNsTUcOgT6qhKLc1N7EJ+McxaKf14cUzYMYk7Kgu/Yo0HSyvavvOgg0ty8BA?=
 =?us-ascii?Q?A0l6eLb+B3/8eKbYnETiAOiAtMFbZYVexHRHJ/ix3pLH+KeHar78D/wdN7yD?=
 =?us-ascii?Q?GSU/4E/tuIlj1OO0B8a0LSSuaF8ueuAfVRlA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 19:52:20.3980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 336becda-5c82-428c-e325-08dd868e3001
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8887

For SEV-SNP, the host can optionally provide a certificate table to the
guest when it issues an attestation request to firmware (see GHCB 2.0
specification regarding "SNP Extended Guest Requests"). This certificate
table can then be used to verify the endorsement key used by firmware to
sign the attestation report.

While it is possible for guests to obtain the certificates through other
means, handling it via the host provides more flexibility in being able
to keep the certificate data in sync with the endorsement key throughout
host-side operations that might resulting in the endorsement key
changing.

In the case of KVM, userspace will be responsible for fetching the
certificate table and keeping it in sync with any modifications to the
endorsement key by other userspace management tools. Define a new
KVM_EXIT_SNP_REQ_CERTS event where userspace is provided with the GPA of
the buffer the guest has provided as part of the attestation request so
that userspace can write the certificate data into it while relying on
filesystem-based locking to keep the certificates up-to-date relative to
the endorsement keys installed/utilized by firmware at the time the
certificates are fetched.

  [Melody: Update the documentation scheme about how file locking is
  expected to happen.]

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 Documentation/virt/kvm/api.rst | 80 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/sev.c         | 50 ++++++++++++++++++---
 arch/x86/kvm/svm/svm.h         |  1 +
 include/uapi/linux/kvm.h       |  9 ++++
 include/uapi/linux/sev-guest.h |  8 ++++
 5 files changed, 142 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ad1859f4699e..a838289618b5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7194,6 +7194,86 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct kvm_exit_snp_req_certs {
+			__u64 gfn;
+			__u64 npages;
+			__u64 ret;
+		};
+
+This event provides a way to request certificate data from userspace and
+have it written into guest memory. This is intended to handle attestation
+requests made by SEV-SNP guests (using the Extended Guest Requests GHCB
+command as defined by the GHCB 2.0 specification for SEV-SNP guests),
+where additional certificate data corresponding to the endorsement key
+used by firmware to sign an attestation report can be optionally provided
+by userspace to pass along to the guest together with the
+firmware-provided attestation report.
+
+KVM will supply in `gfn` the non-private guest page that userspace should
+use to write the contents of certificate data. The format of this
+certificate data is defined in the GHCB 2.0 specification (see section
+"SNP Extended Guest Request"). KVM will also supply in `npages` the
+number of contiguous pages available for writing the certificate data
+into.
+
+  - If the supplied number of pages is sufficient, userspace must write
+    the certificate table blob (in the format defined by the GHCB spec)
+    into the address corresponding to `gfn` and set `ret` to 0 to indicate
+    success. If no certificate data is available, then userspace can
+    write an empty certificate table into the address corresponding to
+    `gfn`.
+
+  - If the number of pages supplied is not sufficient, userspace must set
+    the required number of pages in `npages` and then set `ret` to
+    ``ENOSPC``.
+
+  - If the certificate cannot be immediately provided, userspace should set
+    `ret` to ``EAGAIN``, which will inform the guest to retry the request
+    later. One scenario where this would be useful is if the certificate
+    is in the process of being updated and cannot be fetched until the
+    update completes (see the NOTE below regarding how file-locking can
+    be used to orchestrate such updates between management/guests).
+
+  - To indicate to the guest that a general error occurred while fetching
+    the certificate, userspace should set `ret` to ``EIO``.
+
+  - All other possible values for `ret` are reserved for future use.
+
+NOTE: The endorsement key used by firmware may change as a result of
+management activities like updating SEV-SNP firmware or loading new
+endorsement keys, so some care should be taken to keep the returned
+certificate data in sync with the actual endorsement key in use by
+firmware at the time the attestation request is sent to SNP firmware. The
+recommended scheme to do this is to use file locking (e.g. via fcntl()'s
+F_OFD_SETLK) in the following manner:
+
+  - The VMM should obtain a shared/read or exclusive/write lock on the
+  certificate blob file before reading it and returning it to KVM, and
+  continue to hold the lock until the attestation request is actually
+  sent to firmware. To facilitate this, the VMM can set the
+  ``immediate_exit`` flag of kvm_run just after supplying the
+  certificate data, and just before and resuming the vCPU. This will
+  ensure the vCPU will exit again to userspace with ``-EINTR`` after
+  it finishes fetching the attestation request from firmware, at which
+  point the VMM can safely drop the file lock.
+
+  - Tools/libraries that perform updates to SNP firmware TCB values or
+    endorsement keys (e.g. via /dev/sev interfaces such as ``SNP_COMMIT``,
+    ``SNP_SET_CONFIG``, or ``SNP_VLEK_LOAD``, see
+    Documentation/virt/coco/sev-guest.rst for more details) in such a way
+    that the certificate blob needs to be updated, should similarly take an
+    exclusive lock on the certificate blob for the duration of any updates
+    to endorsement keys or the certificate blob contents to ensure that
+    VMMs using the above scheme will not return certificate blob data that
+    is out of sync with the endorsement key used by firmware.
+
+This scheme is recommended so that tools can use a fairly generic/natural
+approach to synchronizing firmware/certificate updates via file-locking,
+which should make it easier to maintain interoperability across
+tools/VMMs/vendors.
 
 .. _cap_enable:
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..b74e2be2cbaf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4042,6 +4042,36 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	return ret;
 }
 
+static int snp_req_certs_err(struct vcpu_svm *svm, u32 vmm_error)
+{
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_error, 0));
+
+	return 1; /* resume guest */
+}
+
+static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	switch (READ_ONCE(vcpu->run->snp_req_certs.ret)) {
+	case 0:
+		return snp_handle_guest_req(svm, control->exit_info_1,
+					    control->exit_info_2);
+	case ENOSPC:
+		vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
+		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_INVALID_LEN);
+	case EAGAIN:
+		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_BUSY);
+	case EIO:
+		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_GENERIC);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
 static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
 {
 	struct kvm *kvm = svm->vcpu.kvm;
@@ -4057,14 +4087,13 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	/*
 	 * As per GHCB spec, requests of type MSG_REPORT_REQ also allow for
 	 * additional certificate data to be provided alongside the attestation
-	 * report via the guest-provided data pages indicated by RAX/RBX. The
-	 * certificate data is optional and requires additional KVM enablement
-	 * to provide an interface for userspace to provide it, but KVM still
-	 * needs to be able to handle extended guest requests either way. So
-	 * provide a stub implementation that will always return an empty
-	 * certificate table in the guest-provided data pages.
+	 * report via the guest-provided data pages indicated by RAX/RBX. If
+	 * userspace enables KVM_EXIT_SNP_REQ_CERTS, then exit to userspace
+	 * to fetch the certificate data. Otherwise, return an empty certificate
+	 * table in the guest-provided data pages.
 	 */
 	if (msg_type == SNP_MSG_REPORT_REQ) {
+		struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 		struct kvm_vcpu *vcpu = &svm->vcpu;
 		u64 data_npages;
 		gpa_t data_gpa;
@@ -4078,6 +4107,15 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 		if (!PAGE_ALIGNED(data_gpa))
 			goto request_invalid;
 
+		if (sev->snp_certs_enabled) {
+			vcpu->run->exit_reason = KVM_EXIT_SNP_REQ_CERTS;
+			vcpu->run->snp_req_certs.gfn = gpa_to_gfn(data_gpa);
+			vcpu->run->snp_req_certs.npages = data_npages;
+			vcpu->run->snp_req_certs.ret = 0;
+			vcpu->arch.complete_userspace_io = snp_complete_req_certs;
+			return 0; /* fetch certs from userspace */
+		}
+
 		/*
 		 * As per GHCB spec (see "SNP Extended Guest Request"), the
 		 * certificate table is terminated by 24-bytes of zeroes.
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d4490eaed55d..b7472c225812 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -112,6 +112,7 @@ struct kvm_sev_info {
 	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
 	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
+	bool snp_certs_enabled;	/* SNP certificate-fetching support. */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c6988e2c68d5..c07d0b1ce7d1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,12 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_exit_snp_req_certs {
+	__u64 gfn;
+	__u64 npages;
+	__u64 ret;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -178,6 +184,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_SNP_REQ_CERTS    40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -447,6 +454,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct kvm_exit_snp_req_certs snp_req_certs;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index fcdfea767fca..38767aba4ff3 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -95,5 +95,13 @@ struct snp_ext_report_req {
 
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
+/*
+ * The GHCB spec essentially states that all non-zero error codes other than
+ * those explicitly defined above should be treated as an error by the guest.
+ * Define a generic error to cover that case, and choose a value that is not
+ * likely to overlap with new explicit error codes should more be added to
+ * the GHCB spec later.
+ */
+#define SNP_GUEST_VMM_ERR_GENERIC       (~0U)
 
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
-- 
2.25.1


