Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7061269632
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgINURZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:17:25 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbgINURJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:17:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgJIT8oz3evdnOnud4+d6YYERsmImiQjlS/1JD1ALjeTZLoIC/4Cr0VcwNFoTa++A9HOJ+ZR5m+aPoXXl8WIonYNBR738BFJajcr4bLMfXXWdEwSqTa8HTXf4oUrefbUzCqEhhjXeaiH8LWqmIhFid+8pOs6QRmp6jkd34dvt/bXS/xmlJuIGTY9mWTYJ5xOn77RGEDOdDfVLFc/6mKWFHJTbt/hMB4PevL0QTsssnCmMVpdusOj1Mie525cnxpgN2j87Pu28qkBaxcoBfCtKo3QwzopDY5ckg5OHNgsl09DD98R+0KiMrzc03LIhFw87o2oDARvI1vLiEZiee+E1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaAt1EACuc436NaKECVjXdsTcv9y++x3yWXF819pil4=;
 b=Fk20yJh0GrBKr77uPPvK+3d+dJGRalQJUykX+s5z/+HBDcqfX4i080W+0EZZW196ZBNLqTC1Y88D7DvXsj1oIyXn5VhzQyi3eBfFtkQI3piXnN8AxsHeq66HMJaweNMr05ARCB0J2UR9JyKI4ALHAbQeTZwiKBcavFJXnghwF7q4Z1Rgx2MdiiuM9UZWc6lGeS5tLi+a4OYMNHJoDPAp5CvrhoHlHqTX323P3n3XSE0E+SI9Y7wJRfOTs4XMtpl7QqPyXpPD9ThEV4ZQpVM1smzM0SbA8p3mxuNOZY7TGJcoOcSvkkXIgCxCk1esoyG0n90EvfPgGZ+tivIFblXbIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaAt1EACuc436NaKECVjXdsTcv9y++x3yWXF819pil4=;
 b=hAz8Ce0pxg8/5Bqm36jag5RqKChMOvWxaOsDYQ/HZn9XU+qwzdZj0b7PdCv13BvCdPZX02HvRvaHvpzb7RzMRa2fkPaweWWM1LzgEww/UxyRxGgQe9uG0o7LWj9YcTdZCbqkPHt+kVGl2Sylp6WYpCqaQMFiGB+fbC2coow/PQI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:16:55 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:16:55 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 07/35] KVM: SVM: Modify DRx register intercepts for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:21 -0500
Message-Id: <081d45d7c76c97407eefb1f32d96ba6212c639be.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:0:56::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM3PR12CA0056.namprd12.prod.outlook.com (2603:10b6:0:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:16:54 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6029b45-f04c-48b8-f10e-08d858eb200f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1163C902A55BD4256B9531ACEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:110;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FegvyExD5u9KcKE0Dr0nFzY1cBVsoujqN7QHt2lMzmfOfYwa4ifiWgfHR3o5x8i28k+SjPXzquUmuUKlrt7DGv0DnshuOE3w/piA8dVKls/C+g1QrZP6BQ09qcHWeSSdagf7B99rXSxCnVtVQrelQrnwtTVBl7SPn9gf5Fe8T3wchnODTNEtmahkrToimmJSEju2VM6nd9kMTfmKAo5xzenMpMylJ8CbfoF2DQzAA3Df+6HDxGpuZ7/uPR+oYBIAHL8lyr6FXcyyjMYdD6us4nrWzPJgTbU18XK8AJEHzwlttTgcaA6KvHs0WD1xG+E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YjnsF/1xqvbnSqA+0bmWABpMKIjwM+1T/cJrsU7lbuGY4P06YP0e8pnkw/HOkgX4XWNELDLTGfCZSIoFza54ESQ80Yo4JqPmWXk/WJv+O5iCCZM9BKZze7YLTAcbZ4573Wds4v4bPv4hTJ+n2QDCxTkWv1JlyM9emHaH937/WQQCbHfpZ35+1UfvKxAbECqvcZRlWhfbprE82oqcgUqtBNLY7SidFbBz5FwQBL/duyfptphfqAeweqLxfPD0MZDirDIe8m9oxegwPv6c7M4Kzfp/+JRt+L0vLPdJoDrESqgWomKhkikje0CxhL5QmFA2MfKdQOrKLPGA+42CY3MG1mltWCuGQox77g4WtDQf8qOQ3Ybyl0msJc8T9+Wf3M4XZoVJnhIEuUBD6p+zUo6sw5w7R2DL6nNKTT7Of4Sp1WSoTVfFmHZD1GiyxeyywDQxOhALs6bjzLypm5aP50kDAAs7mmXB73DbJ5uY+uHExYVY/eBS+OzrRZrpMmGDGTc9IA1h4xFJbsBKjoYqk3oF/O7NxbuRVS/Ah/5DJy8p1Jm+V5LSTm5H6XspEg6QxVSuyWfVpsuW/QoEnTa3aTLtIC7STEqnNWxugOoPwleImynCk7BUPWS6ElV3t9LenhYdrS5V2nI5OQ5hQTeR1MCnNQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6029b45-f04c-48b8-f10e-08d858eb200f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:16:55.3438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqfIHhOhNCdHAM1QRZc/Zv2WDFjjto+MmkPfH6GsJMyUo9bq6UJ0OsH8DLDJ7JvK8wuuxDh54wBO0WTSdPa1VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

An SEV-ES guest must only and always intercept DR7 reads and writes.
Update set_dr_intercepts() and clr_dr_intercepts() to account for this.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.h | 89 ++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ff587536f571..9953ee7f54cd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -190,6 +190,28 @@ static inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
 	return container_of(kvm, struct kvm_svm, kvm);
 }
 
+static inline bool sev_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev->active;
+#else
+	return false;
+#endif
+}
+
+static inline bool sev_es_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_guest(kvm) && sev->es_active;
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
@@ -244,26 +266,35 @@ static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
 	return vmcb->control.intercept_cr & (1U << bit);
 }
 
+#define SVM_DR_INTERCEPTS		\
+	((1 << INTERCEPT_DR0_READ)	\
+	| (1 << INTERCEPT_DR1_READ)	\
+	| (1 << INTERCEPT_DR2_READ)	\
+	| (1 << INTERCEPT_DR3_READ)	\
+	| (1 << INTERCEPT_DR4_READ)	\
+	| (1 << INTERCEPT_DR5_READ)	\
+	| (1 << INTERCEPT_DR6_READ)	\
+	| (1 << INTERCEPT_DR7_READ)	\
+	| (1 << INTERCEPT_DR0_WRITE)	\
+	| (1 << INTERCEPT_DR1_WRITE)	\
+	| (1 << INTERCEPT_DR2_WRITE)	\
+	| (1 << INTERCEPT_DR3_WRITE)	\
+	| (1 << INTERCEPT_DR4_WRITE)	\
+	| (1 << INTERCEPT_DR5_WRITE)	\
+	| (1 << INTERCEPT_DR6_WRITE)	\
+	| (1 << INTERCEPT_DR7_WRITE))
+
+#define SVM_SEV_ES_DR_INTERCEPTS	\
+	((1 << INTERCEPT_DR7_READ)	\
+	| (1 << INTERCEPT_DR7_WRITE))
+
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_dr = (1 << INTERCEPT_DR0_READ)
-		| (1 << INTERCEPT_DR1_READ)
-		| (1 << INTERCEPT_DR2_READ)
-		| (1 << INTERCEPT_DR3_READ)
-		| (1 << INTERCEPT_DR4_READ)
-		| (1 << INTERCEPT_DR5_READ)
-		| (1 << INTERCEPT_DR6_READ)
-		| (1 << INTERCEPT_DR7_READ)
-		| (1 << INTERCEPT_DR0_WRITE)
-		| (1 << INTERCEPT_DR1_WRITE)
-		| (1 << INTERCEPT_DR2_WRITE)
-		| (1 << INTERCEPT_DR3_WRITE)
-		| (1 << INTERCEPT_DR4_WRITE)
-		| (1 << INTERCEPT_DR5_WRITE)
-		| (1 << INTERCEPT_DR6_WRITE)
-		| (1 << INTERCEPT_DR7_WRITE);
+	vmcb->control.intercept_dr =
+		(sev_es_guest(svm->vcpu.kvm)) ? SVM_SEV_ES_DR_INTERCEPTS
+					      : SVM_DR_INTERCEPTS;
 
 	recalc_intercepts(svm);
 }
@@ -272,7 +303,9 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_dr = 0;
+	vmcb->control.intercept_dr =
+		(sev_es_guest(svm->vcpu.kvm)) ? SVM_SEV_ES_DR_INTERCEPTS
+					      : 0;
 
 	recalc_intercepts(svm);
 }
@@ -472,28 +505,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 extern unsigned int max_sev_asid;
 
-static inline bool sev_guest(struct kvm *kvm)
-{
-#ifdef CONFIG_KVM_AMD_SEV
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev->active;
-#else
-	return false;
-#endif
-}
-
-static inline bool sev_es_guest(struct kvm *kvm)
-{
-#ifdef CONFIG_KVM_AMD_SEV
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev_guest(kvm) && sev->es_active;
-#else
-	return false;
-#endif
-}
-
 static inline bool svm_sev_enabled(void)
 {
 	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
-- 
2.28.0

