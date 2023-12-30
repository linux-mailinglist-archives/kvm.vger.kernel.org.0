Return-Path: <kvm+bounces-5390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 262888207E0
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:32:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91B76B21DE9
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0B4BE76;
	Sat, 30 Dec 2023 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xbrP/btl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AB214F6C;
	Sat, 30 Dec 2023 17:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpVCekYQPk1jFUis9E//RUOiQwOzSLpb4UyZ2FBbwipxCanp061gO/xBoCxibCRUhNlw9nhQQOwGtZp9hPMU3amnqanFEFz+fjUw2OQ5hZ+OZgKmDO2ve8FjT9jrWfpZy/l4AUSRg6eUMQj/vbAjZp2v74rSmLbR0767bPmPi/o2gm0jtNj3+Up7w5ffMxh+90G6ljbuOxxgUXcnuj4TBdr8RTmoqsA7Y/HCYDPtlEHG+XJohyXWwm6X51C2IhxIUw9M0YWBcGSStx3yOb+xOfSuPjmQcc5KAhTIIGGOfC1TBMN7ym+iit4Ykv+DzuLp+ElJmywg0hH1i/jIiv325w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjyvJ1UWir8S4mCHuVRPOJI4IZRnaj30FvX/iFHnDoQ=;
 b=RCGk/6/fMuCZXNPuT78N/kbeVArJyjPO8PO6uPwtbds7G1IQmmbEdoa9SFLLRzL0uiGGn7olgJHyIwCbAa/VKuBkwrK5A1fL79U6VuTJhZ8Zlk74C+nUPntEW4axrv7KsDFuybGQMLBtH0dZOjqatb+guPDT9TY5nDzTAfssepYzK2loHEmpqMYuCbfpJKF4AseWOTNRRiPU23ORM23iymtFMge3uZac7E9oW9bVfO/jXoDzqdg2OYRSECeTMHTSHfgQZF/ZpRC0bwKiCTAPIcrNr/0w1gmhF7ghqe/RJrduMSMBP1XM+d4nAkF65U8u/nEvQb+gSupbwfPxBgjkRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjyvJ1UWir8S4mCHuVRPOJI4IZRnaj30FvX/iFHnDoQ=;
 b=xbrP/btlNPr3AHek+Exqi3M0kYEXfQJ1iuYLRqg+LdtMPvIY/uAktWuOdV8e22hDF5yDaP51SFSFRH3EUkmtpAicQDqoVFwmPamprgXWfO9vmItgU30HjK2av1e3+9UOaR1dwxm+zKbXXTSZFLNp5jRb08SCeC+CwPOMBU3AfC4=
Received: from MW4PR04CA0081.namprd04.prod.outlook.com (2603:10b6:303:6b::26)
 by BY5PR12MB4324.namprd12.prod.outlook.com (2603:10b6:a03:209::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 17:31:18 +0000
Received: from CO1PEPF000044F0.namprd05.prod.outlook.com
 (2603:10b6:303:6b:cafe::26) by MW4PR04CA0081.outlook.office365.com
 (2603:10b6:303:6b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22 via Frontend
 Transport; Sat, 30 Dec 2023 17:31:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F0.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:31:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:31:17 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 27/35] KVM: SEV: Add support for GHCB-based termination requests
Date: Sat, 30 Dec 2023 11:23:43 -0600
Message-ID: <20231230172351.574091-28-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F0:EE_|BY5PR12MB4324:EE_
X-MS-Office365-Filtering-Correlation-Id: 2404eea3-8317-4777-adc8-08dc095d21da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AQCc5JFhKN9TsISAlRGjfI25oNbpX0Tu7QJyT25F/opuZasH7KN1xmDKAQkfJEvK4igle4cqLyXYCn2WpqTZ60/X/ljoq7nSWJqr6CmYDYhTwGrhnstZ4tVt0fwaJfF1jgqggfmPghId8M3J93Spxhe0Ur9r08HDJa+e9uBJ1bR0kO/9o1Pz/zJuE2jA7izcWSVDNN0wegQdLtUzfwbNpjixvInfidPhvnzsY0YhxLLOV0mR3PFZ0VkBpMS9MY+zKcLRf/ZsJlga5JqMCLtbC4g5BfrdTl6152KOy8MWJMCwTyZ5oq/Hxu5rmXl8MhQya0u3Jx3aoDDrjfVxgUqtVDP9BBgX8mk071yns1oiRlbm59999YulV1FmaTl4EEMpRMxl7fDiNTI7PFCSul42v5kX9olOnTt+JTUr2qZ1tvHO604UnL70MzwV9nXAUKHfxXQyAPxg3KTMo747wun2gR4CjS9fFnrsDlFWst/TrseXW+QKY+1tS3GSE1H1lqCwRn363mAlYE7AmsUBvy0HFlUB1qgXEN2m4ek/Kjs/xntg3T/Of0B3WJ0ezKyxheI7ZM8LwGK9vYTP3VH8k6m96kzTA7uBG+9Z6hvF6VzQdds53i7MQiKnqJNxBSgk7DtoMCKLKAxbHU0q5NpUDcnpkdj6+5tzr6JMk8jwXK7IBF+oBWhGZlkesz53hrHS4ZFC7FBC4NYTEGpaoFByIp74vUDyRAcBFk52xpwtQ/rCaCecnCOidkBXU5JEFDFttwOgLbrixvybPOuBBK3t+TE1Jw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39850400004)(136003)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(82310400011)(186009)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(336012)(426003)(2616005)(16526019)(83380400001)(1076003)(26005)(86362001)(36756003)(81166007)(356005)(82740400003)(4326008)(44832011)(5660300002)(47076005)(7416002)(7406005)(6666004)(36860700001)(8936002)(8676002)(54906003)(70206006)(70586007)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:31:18.2949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2404eea3-8317-4777-adc8-08dc095d21da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4324

GHCB version 2 adds support for a GHCB-based termination request that
a guest can issue when it reaches an error state and wishes to inform
the hypervisor that it should be terminated. Implement support for that
similarly to GHCB MSR-based termination requests that are already
available to SEV-ES guests via earlier versions of the GHCB protocol.

See 'Termination Request' in the 'Invoking VMGEXIT' section of the GHCB
specification for more details.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3bb89c4df5d6..b2ac696c436a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3100,6 +3100,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3782,6 +3783,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_TERM_REQUEST:
+		pr_info("SEV-ES guest requested termination: reason %#llx info %#llx\n",
+			control->exit_info_1, control->exit_info_2);
+		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->run->system_event.ndata = 1;
+		vcpu->run->system_event.data[0] = control->ghcb_gpa;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


