Return-Path: <kvm+bounces-5385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 792778207D0
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 316A72817E8
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BB215494;
	Sat, 30 Dec 2023 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gqn3Yr46"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D5B14AAB;
	Sat, 30 Dec 2023 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wz+XZ/DLYXvdl+aku87UeCyPz9OPwVAG3xhDqJPdC4Or9YhyrJiBoEKcAsACbg6+20QfGCHxnxlmbvYpcXHNmZhkM8lrxxVINZKB8RiaYXNaOoTVeqw/3K1RXQVFYMehJFoHcy3A7AtnHMKsbcVPEF5SxAu7HN8nLI2OUstOMxUnGICDdv4Nd2jD2Kw8Ao+C1Ws0P1NbADQgFz3Ge82qh83iVtKouYc+Pyao1xg8Ru7Sf72mq+EOLcU2JAs3Y2PniV6CATDF8xHylMTOm36fNE4IrKbdhJ54WvjfWDvYhi02MioMNjcv03h094Mq8Wya7C9gfkfa2NDwns1gN5dz/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=moebtuYTyEc0/LE1dW8F46TzLn10L89AmkiC0kglrVY=;
 b=n5jU9SjT3iGNSzpWLmvQuyTJU6Lo8rrKTmvR5+GL4VXpbN6+6XRqB2c8fn9RB9EVReTmUKQHUXNeTwZXiGqxa48oV88jabmTSd4DktTSJq4OvF9vKLQhUQeY1wlNvaOL63S/sV7FddUISEXqgUIXZwiRUlAUvlFYSVXsrCxFZDotuknkbVvnwipYtzncV4Enh3HM+x/+Q3Hqz/FgzAx1NhjOHWCW2szs229N60d/a25BPXzIhIWk/Vky4hrco5evjg3Jxq0jElxIZ/GPjnBEXE/jpww8MPySCeGeVgSuj/EJdSIcn/rjmBRxLhM27dwzH6NBzrQiggi3sPcsQ4twog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moebtuYTyEc0/LE1dW8F46TzLn10L89AmkiC0kglrVY=;
 b=gqn3Yr46x7DkRsras/Y5Q+APwc9arQpNXZBl/3ogk68Fkwrwf6TAI1WsJCQDi1sAka3M+jUPERI0T+TpYbD7vkpgQjLEDCbqf3DK+1hhFXGlFxlCPZ+HYsSWzbK0sYUunG6JPWYpbFNXoMPh3YjNVhGiwAGMJMqVa9n2P3HIPs0=
Received: from MN2PR04CA0016.namprd04.prod.outlook.com (2603:10b6:208:d4::29)
 by DM6PR12MB4401.namprd12.prod.outlook.com (2603:10b6:5:2a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 17:29:33 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:d4:cafe::25) by MN2PR04CA0016.outlook.office365.com
 (2603:10b6:208:d4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Sat, 30 Dec 2023 17:29:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:29:33 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:29:33 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v11 22/35] KVM: SEV: Add support to handle Page State Change VMGEXIT
Date: Sat, 30 Dec 2023 11:23:38 -0600
Message-ID: <20231230172351.574091-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|DM6PR12MB4401:EE_
X-MS-Office365-Filtering-Correlation-Id: ef2210a5-70ca-4218-2653-08dc095ce38d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TIzICcJpbjg4dg273j2AGiXggZ3E/t6A8mga/ux+2XDcreqdQVt5cmehu3V4i6Z1EQ+9homr9CqDWtdC//nQRB+/+GJ2MA68vM3SDjxwt22darq80OVHwvzqp/S4ea2jJAlsuhHZcuhUmYGi7C5AirDJxKPfl+Tzih7YXYXnh+0cCwb9KJNemXcPSl0j379wo4AY4EvODIQYKaoZHO5/xk6/Nak9i4buK5UEAjeoBrjkbgXGPzul+urq6ba3SNggoaQYv6ygX4VCPxw2Wc6+CNxl2YYw3zvVZB1fIeULAtOfo7dkw3v+phbc9QJt0Em/qW2IXkmyU46HRMFvo6/9HlVNBS1j8nTMpb1v/UhOOFLloeCWfrDAi5LEPvN9OZE7JLlotAOmVoqHcyMHmwNWUUro6TI526baEJzWaTcQTDgrKtcB2aGOgl3yEWTSMPh+eyQJ+JGfwSBMctw4hL4Uj5FjXy/3Pmq/e7rPsdVClKP/rg0AScalIfIlO4FcmU0g+qK+rniV9NVZFgrYmM4lT8JEFst/+8sTikngJTHhFNEhtV7AbjwI7KtY22isjXJ36zUJk5pGbRgbUYTp5nx/BF0+hgeARZ+HcdD96esEbWuUPTGGtYog0BGOU9SyM6gH3OUEZG7bGz+Ae+itC+GrlQdwEvkb5YAv6IXKnuVymZ2N1uDswkzzYwhxC/oQoyBIA9h4I1FZzVT21bJS+AarP7cr7xAJtciNWyJw+I5dnrrSirsGGw5xvF8t+g0RyZyUFUJV4ukH8rEXrzJxla9EdQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(1800799012)(64100799003)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(36860700001)(478600001)(40460700003)(41300700001)(82740400003)(44832011)(356005)(6916009)(36756003)(4326008)(86362001)(316002)(81166007)(54906003)(70206006)(70586007)(47076005)(336012)(426003)(16526019)(26005)(1076003)(40480700001)(83380400001)(8936002)(8676002)(2616005)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:29:33.8462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef2210a5-70ca-4218-2653-08dc095ce38d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4401

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification version 2.

Forward these requests to userspace as KVM_EXIT_VMGEXITs, similar to how
it is done for requests that don't use a GHCB page.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst | 14 ++++++++++++++
 arch/x86/kvm/svm/sev.c         | 16 ++++++++++++++++
 include/uapi/linux/kvm.h       |  5 +++++
 3 files changed, 35 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 682490230feb..2a526b4f8e06 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7036,6 +7036,7 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 		/* KVM_EXIT_VMGEXIT */
 		struct kvm_user_vmgexit {
 		#define KVM_USER_VMGEXIT_PSC_MSR	1
+		#define KVM_USER_VMGEXIT_PSC		2
 			__u32 type; /* KVM_USER_VMGEXIT_* type */
 			union {
 				struct {
@@ -7045,9 +7046,14 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 					__u8 op;
 					__u32 ret;
 				} psc_msr;
+				struct {
+					__u64 shared_gpa;
+					__u64 ret;
+				} psc;
 			};
 		};
 
+
 If exit reason is KVM_EXIT_VMGEXIT then it indicates that an SEV-SNP guest
 has issued a VMGEXIT instruction (as documented by the AMD Architecture
 Programmer's Manual (APM)) to the hypervisor that needs to be serviced by
@@ -7065,6 +7071,14 @@ update the private/shared state of the GPA using the corresponding
 KVM_SET_MEMORY_ATTRIBUTES ioctl. The 'ret' field is to be set to 0 by
 userpace on success, or some non-zero value on failure.
 
+For the KVM_USER_VMGEXIT_PSC type, the psc union type is used. The kernel
+will supply the GPA of the Page State Structure defined in the GHCB spec.
+Userspace will process this structure as defined by the GHCB, and issue
+KVM_SET_MEMORY_ATTRIBUTES ioctls to set the GPAs therein to the expected
+private/shared state. Userspace will return a value in 'ret' that is in
+agreement with the GHCB-defined return values that the guest will expect
+in the SW_EXITINFO2 field of the GHCB in response to these requests.
+
 6. Capabilities that can be enabled on vCPUs
 ============================================
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 37e65d5700b8..8b6143110411 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3087,6 +3087,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3305,6 +3306,15 @@ static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
 	return 0; /* forward request to userspace */
 }
 
+static int snp_complete_psc(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, vcpu->run->vmgexit.psc.ret);
+
+	return 1; /* resume guest */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3542,6 +3552,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_PSC:
+		vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+		vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC;
+		vcpu->run->vmgexit.psc.shared_gpa = svm->sev_es.sw_scratch;
+		vcpu->arch.complete_userspace_io = snp_complete_psc;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 62093ddf7ec3..e0599144387b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -169,6 +169,7 @@ struct kvm_xen_exit {
 
 struct kvm_user_vmgexit {
 #define KVM_USER_VMGEXIT_PSC_MSR	1
+#define KVM_USER_VMGEXIT_PSC		2
 	__u32 type; /* KVM_USER_VMGEXIT_* type */
 	union {
 		struct {
@@ -178,6 +179,10 @@ struct kvm_user_vmgexit {
 			__u8 op;
 			__u32 ret;
 		} psc_msr;
+		struct {
+			__u64 shared_gpa;
+			__u64 ret;
+		} psc;
 	};
 };
 
-- 
2.25.1


