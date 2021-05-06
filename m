Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B78375C1F
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 22:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhEFUP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 16:15:56 -0400
Received: from mail-bn7nam10on2083.outbound.protection.outlook.com ([40.107.92.83]:1825
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233572AbhEFUPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 16:15:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcH/mAwgVUSiK3tmkFpf51O5MuWB2toFF8KzJvvdDOmhZ83oicUmldjB9BLxVns5r3ReA3ldfrha06lZ0pv5QIdoE8MwsCTa+JzsAL9bcbpK8scRBmLN149xtS2Ebh6OB2e0YdCFf/2E51AlO/kWLPXMAp77tSrqE+Jtd76K2NpNu3uctRGkO3EqJt+zuDQSuiWEQWI1m7jR9e4IApp80M0t9LD1ypi2g9XlcapzlqX9Ae3IS8Dwuxw5+hk2TOHXPjxuWpNhIozAcgW5qi5RIGa1ZsdZJEEv2ITw2yV+ayqvdZpvQ40syze4Grdu5cL7TpQLoI92Tobf7l757Yv6rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8CIZrvBAGJs/QawVq0AwmgWuOWA8aw6TENObZMBMO0=;
 b=llUvI9mpqTvpLtmfo1zhhVPCYLIxz9FcVDd1b1pP6DxP1Lr5L4sq6b/RdWnX4vBz+V+7lo2WIrQIxVMmBmPu72wd3Im4EWgKXO3dfnzZdBAVkOPrtyRHQ/HC+QIyoYtCwJsiu9xXNB1Nyfs03GXyvG04Xpx7UXhv6g7v9FJvYPKLAPGpnRG4rMu4B5DfXdlFbXfKyBNAZS+PTiqWlXvhuz0n33bv67R6BewL3bt3lL68GQe/1NYrc3tJCUCARWG8v2kJb183H0xoLEjrE1adwc3ijysXndzKzBu3tMCyLjmW1WLdkkHBxsTFefu/7EBeLNd613/p85QdYfmYJ6VCTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8CIZrvBAGJs/QawVq0AwmgWuOWA8aw6TENObZMBMO0=;
 b=LkV2dp7GwSWc46RzDEFSmeWrnQX960ySBL00X0cPojSnaJSB5VIaVVzZjl5ToHW4lThMl2PguCrCrrEGoxGqQxC7GKE2UHt/DQF81Ii70Z/GV/Q/YFpLYEW1dqSEi3oX32y65Y08i6mQWwFWXKtwOQpo4amnh+YFgNxNyVaV0Tg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4958.namprd12.prod.outlook.com (2603:10b6:5:20a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.26; Thu, 6 May 2021 20:14:55 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 20:14:55 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] KVM: SVM: Move GHCB unmapping to fix RCU warning
Date:   Thu,  6 May 2021 15:14:41 -0500
Message-Id: <b2f9b79d15166f2c3e4375c0d9bc3268b7696455.1620332081.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:802:20::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0057.namprd12.prod.outlook.com (2603:10b6:802:20::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 20:14:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4bb3163-5bd8-4ff0-c488-08d910cb9d59
X-MS-TrafficTypeDiagnostic: DM6PR12MB4958:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4958C6FA8491B06A7E7C779EEC589@DM6PR12MB4958.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pZMatCLiMkY+i5XexglfvLanbwIjDhibxK44ktmw+OJf6zp9oyx9Dih+lu1RJtvGcG8CV0QTs/zd4ETjsSNs8lU/4+iOQ/oAMQVQ8Fmzorz+4BPP51h6YVHS5ULMjlb7vaJZXC05vMC7+S63eboe8e6gVjLYS3ZsgRWcFtTrR3p56rfjudJ/tUs+6wFvcRQ2HNv+L6y9LLSCnVT0IrzDG8x40TT2+b6ZTAupb14uIKkcIbwY4Nan2kBFDWpaLhXMGAbOvaBokTwHoaa0SkcEG0CbPbZ4TVxF9BecimEmsszplKj2h8cM/phb0jMdGd4Ukma3r5UCMiPDzE5dToG79RV6qstBrCIGR0kNXlD/QxZISEjro4Kj9Kp85bYWCas+mbQodn3kdC3MYHrdkAmEm21QxmDIn0y5IavnqIx3vt6sX/Jg9ukPR2kTYx15RAJO3qWPqidAXBNbr9eNLreMH0T9EIyOnMvsgdA8WRraV07MH4GCha+g6oqwY8jiMc7ezgnN0/lz1Wjk8Dp4oVPYdDZDh0KHtPUc7eCqWj3wSju+/gLTG1mrazG2YxR18UIdvPNUB945HzVP4cIWkSKbontTDE5jiJwWK9kNaEK2JXmj2Cqq3Ue0R5Gnh0+ropl6JnAAqp+XzEy7QW8ihd0M3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(6486002)(16526019)(66556008)(5660300002)(956004)(83380400001)(38350700002)(66476007)(86362001)(8676002)(4326008)(38100700002)(66946007)(2616005)(316002)(7416002)(8936002)(52116002)(54906003)(2906002)(7696005)(26005)(6666004)(36756003)(186003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MbqMK58H4s4dvNEqm4sE/yaburecBu3zwTkhzn2k5NcCQRT843IBSH9X/nDq?=
 =?us-ascii?Q?BVQQncb5mqWHbX/FUeX4Ce8AEunmCu+NAOpP7y4YT4XjeSXbAiDwnG4Kq+uz?=
 =?us-ascii?Q?j8jc9R+SCIpEawAinZjwcHomh0rCn3aQQ72HiNCF5RzrN0A2Wfmo2ozmYDBH?=
 =?us-ascii?Q?BSZgmC7W8GY3MqZ7NsRbVUH29EKhrWO+qK0qCmCRAs+zOgQBUY/M32TTm18q?=
 =?us-ascii?Q?WnjXDdGcDFPoJxFD/7g1SJIf7FTaHkLeTd581FF0kaJBTTb4FMrpJeT7455t?=
 =?us-ascii?Q?O667RwLeDgmYZSekyQDTMnkJJQZfjasay4Sktpju3WQ53adQGXmin0n/HKDF?=
 =?us-ascii?Q?LiIFH8rZYKhtAzYV3UTm+zDfg7TEyUVe/2nX+OPP7GVxrMPWU/euPvQwzHWb?=
 =?us-ascii?Q?1Vgq3udTCpo6SAkWZpzYHfUU5P/Jbcif4b5TcCWAEksVjO9O3WIH+J3OOx6r?=
 =?us-ascii?Q?Fks5h7s/JsUiQ6G1sKbEzxmFL8cfgLgHHc1RYAzWf/QWIaKPYhMa0TvOzhBK?=
 =?us-ascii?Q?PmzR/4PNFP6rQ5pnAmBDmH32hfVZIMg+utgpn0LQlvNi/Co8xRV8dNXWAYMR?=
 =?us-ascii?Q?PGp05zNM9Ih5jHwDZNLDHffiH73AL7W7IpoNolsLudChd4fCi/6tbmMYik/v?=
 =?us-ascii?Q?d3d2aNrRRCpQ2Yg5j2ZvR3qazAOHVKZFf0wRHOIxjtFajqlAM0QuqD8FLVq1?=
 =?us-ascii?Q?pTeHyjrZTjKWG9Sr6pWnaa2Z9xLuFMzZH8+bcofB7/sOsYhmQq1AZnngXBWm?=
 =?us-ascii?Q?Iiv0YkzHTEersJfw6eS7U+xhB8LbcLZQ/wfDb3wWVJNtSTAMO5ZxMGvs7Kmt?=
 =?us-ascii?Q?4+pazFzNzeNAk+FWvaBtwSHItz6HZV20okqlfRDD6fiXafqt/p4WxHP4Rq00?=
 =?us-ascii?Q?qtkRMSPSZjsmApP+VdEdmXLt3Pe4jPIrNPwJTzchwquHgFk/8t1GB2bQe0KQ?=
 =?us-ascii?Q?k+bRwt+PzpyZvWpwlyGstnyop/Y/QvPCG+tee4GetarggLhBWsdk3RFyQFUn?=
 =?us-ascii?Q?nxSuqGbokI9EAP98jdb25z/0rdqJOI2r2tI0s4/USnMOTQu8pQ9y7/GOKo5/?=
 =?us-ascii?Q?7q8wagh91n63ZRXreifBBQwK2lvEkHkGupmeny/8AfDBz+XcxVoaaZ7opqg+?=
 =?us-ascii?Q?aY4ksLL3Y/KJKMt8TvY8ancUxFNXRvqk9nUKA5rdFH5VlYoG/cb214aLOtZL?=
 =?us-ascii?Q?XcR9y4qn9kIlqVVYP06dOoUkvduT2OQUPrlq7hrEH5Nt5ZpFSdtejCASJQJs?=
 =?us-ascii?Q?crDOeoUOj2/s1jzomdS+MrVaGeJl1AU5nMc+WJ6zdeJ00zeQpmuQkeMnLolR?=
 =?us-ascii?Q?SucEW9W/xNEbVspvlXudb5hx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bb3163-5bd8-4ff0-c488-08d910cb9d59
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 20:14:55.5626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5EF1SkhDZGs7qLQeiQbOgHIakJyhVfm7vza5WG4CvoDkQj59aLWJpHbR0w2L+avfYaMruQneul79SwyWhMHow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4958
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an SEV-ES guest is running, the GHCB is unmapped as part of the
vCPU run support. However, kvm_vcpu_unmap() triggers an RCU dereference
warning with CONFIG_PROVE_LOCKING=y because the SRCU lock is released
before invoking the vCPU run support.

Move the GHCB unmapping into the prepare_guest_switch callback, which is
invoked while still holding the SRCU lock, eliminating the RCU dereference
warning.

Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 5 +----
 arch/x86/kvm/svm/svm.c | 3 +++
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a9d8d6aafdb8..5f70be4e36aa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2198,7 +2198,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	return -EINVAL;
 }
 
-static void pre_sev_es_run(struct vcpu_svm *svm)
+void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
 	if (!svm->ghcb)
 		return;
@@ -2234,9 +2234,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 	int asid = sev_get_asid(svm->vcpu.kvm);
 
-	/* Perform any SEV-ES pre-run actions */
-	pre_sev_es_run(svm);
-
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a7271f31df47..e9f9aacc8f51 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1424,6 +1424,9 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
+	if (sev_es_guest(vcpu->kvm))
+		sev_es_unmap_ghcb(svm);
+
 	if (svm->guest_state_loaded)
 		return;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 84b3133c2251..e44567ceb865 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -581,6 +581,7 @@ void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
+void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
-- 
2.31.0

