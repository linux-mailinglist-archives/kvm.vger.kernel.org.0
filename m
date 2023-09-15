Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650AD7A28C5
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 22:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbjIOU5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 16:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237559AbjIOU5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 16:57:02 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B26A3582;
        Fri, 15 Sep 2023 13:55:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oy9nOOPloHoL3fTwkJa2HsgqMpGyfMalBG5QIVY5RLWXOf8JZh9aabRY6icbgUsCshi9Zpm7lQh7/QwWRohSHqRS7c2V8W/4zpBAy6MeDNxIADuJZ56+6t4jfcKyzm3A3RMN1RqYvJxckntLTZZ18gx4y/XelMdpiWE7Fl8VKdgDrkFa2dGNZgB/E9F3w4K4AYyk0epPKMlxavMhkIhTjbxgANDRH1AxwfMuK2r3/rCbz0qmwjsZIaa1R49Z0xC4uRhufc7mbX1ilGHR1nX17J9ylv58gnP1ZH+lhwMKuau96GbrY4nIQGDac62d0yxouTnMta7Qfh/3d8gwJ7AF5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0g3ITE/3XkDQm278FlQDGmDt2ok16Ml64QUGw1Wm4I=;
 b=LlfVamTGhmQsNcGxARoIbhUScf3yF+YugwRD+TGxAuwMiISca+zxsjL5HMSQDxSdy1uUjLrrlpDWRXNUWZvF2+xzAvRPcVDrS9OB8V2fkDtI/kZEng7Jz6ymOtgBx/OlCa3T1BnCSBQ3ctteQ40QE+9cEpL3yQKjyld1kLyxOwg25owUIYbeqYIul7QwaUYIY2FHsggTSpafOrz8rkV4dpSyfdPdF1jtpLVqhbHX22lah2sa28JBy3MLUK2SG2L2ouM+Wz38O/o8aS1+c1tFK7fxz/rcr+U4jCHGVfpjwFUhFaQiE/wksEYFjts3+FyFBWlS6p29B1iGkdvsmsQTcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0g3ITE/3XkDQm278FlQDGmDt2ok16Ml64QUGw1Wm4I=;
 b=iqsVTjROwa7AX/WVys3nNZr6H9F7/jb4cPygS0OAYeLFox7FUnKEnnidveiAu21XIWKY0k5HZV0TPowRRZFmfCYs6vOCvfWJsOqR+YW6dBHJvyn2j+zGJmyn7YGtP8/uX3v4qw6cwrtwk9i51wZAdpWt8lCgFGUK5v0esHA+Rn4=
Received: from DM6PR06CA0009.namprd06.prod.outlook.com (2603:10b6:5:120::22)
 by DS0PR12MB8814.namprd12.prod.outlook.com (2603:10b6:8:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Fri, 15 Sep
 2023 20:54:45 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:5:120:cafe::3d) by DM6PR06CA0009.outlook.office365.com
 (2603:10b6:5:120::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21 via Frontend
 Transport; Fri, 15 Sep 2023 20:54:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Fri, 15 Sep 2023 20:54:45 +0000
Received: from tlendack-t1.amdoffice.net (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 15 Sep 2023 15:54:44 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Subject: [PATCH v2 0/3] SEV-ES TSC_AUX virtualization fix and optimization
Date:   Fri, 15 Sep 2023 15:54:29 -0500
Message-ID: <cover.1694811272.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|DS0PR12MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: 945ef883-7f5b-4abf-6c9c-08dbb62dfe2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 611YW5zm5eb4nX6XbRMp0VrwBrxpewe4xtqd38i4rk1wfmboAPKi201wtznsOr6BWhC+7auveLx2MZ/kdCO8YQbvyDRaTk8QVyaDGT5Wl+1umLc6NXgCzSPcqpM3yK372j/sHoBHZIvTvJEMY0EsXIa3FeJJEgdeIkiwUz7srlJNZkPpGCrxq+IOE2AKWBllalidbT1Z82x2gNawZqWy+noagm0uFxpm15zARaeNHg7MY8TbkjlAPGgtEdf+mjZECVD0ouvneCHQXXIPCxsjGEHQxscL+3w1Bzlf7AqsQUqpoqa6Ff2z47C1i95DXpyoXMWkgXvQtpDFulSGEgZpWafSUOSRBgOciNIEIGPHsV97RjSJ18HjXDR8SzGJbTQYKf1qgjindRED526+00O4SATTb1VarWxQptcXCPmaW7WTDaberre68Jgy261Yy0BWpnQBkzpfT3bjWfPFn/ClDlsP6Ic2QZ1TUqIHV3OF0gYsmIZW9z+sjZ0agYm8EB0jpcxmUDstXyZT2MbYcu0t3FZXVlYBMuqvmuc6VmN4XwdM3baoR8VIN0SdhJvBleS6oWkBm+MzAwxtyT33HM9ZsKEP3aQdORBzUqj/uxt7KNLnSWo4H+wzOxGbDWePkeJ3Jx83/BA1jzKnkfuCvq6wLDETTbAWDx9Kqbnfl8LSTeTrwCtcPNe234GRvIvyzKvssK3tDD+nKSEHAAnOfjS25GFs4j0VewUJgIkeO/stkqQKSAydgyvVcA59mouG72U3
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199024)(82310400011)(186009)(1800799009)(46966006)(36840700001)(40470700004)(4326008)(356005)(6666004)(82740400003)(81166007)(36756003)(86362001)(36860700001)(110136005)(40480700001)(47076005)(426003)(336012)(70206006)(478600001)(41300700001)(2906002)(5660300002)(8936002)(83380400001)(966005)(70586007)(8676002)(316002)(16526019)(40460700003)(2616005)(26005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 20:54:45.6267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 945ef883-7f5b-4abf-6c9c-08dbb62dfe2f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8814
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series provides fixes to the TSC_AUX virtualization support
and an optimization to reduce the number of WRMSRs to TSC_AUX when
it is virtualized.

---

Changes since v1:
- Move TSC_AUX virtualization support out of init_vmcb_after_set_cpuid()
  path and into the vcpu_after_set_cpuid() path
- Add an additional patch to properly set or clear intercepts based
  on TSC_AUX virtualization requirements
- Simplify the TSC_AUX virtualization optimization to set the host save
  area TSC_AUX value once during svm_hardware_enable().
- Since the TSC_AUX virtualization can't be disabled for an SEV-ES guest,
  eliminate the "v_tsc_aux" flag and check against the host feature and
  type of guest, directly.

Patches based on https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
and commit:
  7c7cce2cf7ee ("Merge tag 'kvmarm-fixes-6.6-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

Tom Lendacky (3):
  KVM: SVM: Fix TSC_AUX virtualization setup
  KVM: SVM: Fix TSC_AUX virtualization intercept update logic
  KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX

 arch/x86/kvm/svm/sev.c | 34 +++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c | 43 ++++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 62 insertions(+), 16 deletions(-)

-- 
2.41.0

