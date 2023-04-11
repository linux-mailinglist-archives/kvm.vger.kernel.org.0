Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2286DDB56
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 14:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjDKM63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 08:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDKM61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 08:58:27 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17BF49CF;
        Tue, 11 Apr 2023 05:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dX5dSqxCKp/8uvRSy5+ooB4aBs1vNfvk6J3Jcwb7YCs8hfXCO1Juubia5QRTPkaYyVVvHWrDkoTfHU67dgs+uTQXdYiYmF2US1pQwwshLz0iuElkZx0cyCmgE6qLNEwaErkodhJd0iXQGEP48y/3zALe7vHJq3CQ/uWFGZ6BWwPBPeSUf+8XMGEp3evauiWqUFZeX248aHVqpJcYMwWOTYCm03ofBjuvf2n29mSNjeGHH4sqTd/qKXMMaEsWlFyhSWdZhmEogIYGyviet1043WmjF4iD9qT79S8wFe/UWTQX1g8t2/hARbb6gsN44vVeDWqMc7CI4rem2ecNxPnWhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FuByVT643bdw8QFPZxSQ5U8zZSAol1+19KDcOn4tXEc=;
 b=Xwl5jRPcICSdGMMiF2go4UtBwVmOQMoITeP+IMdrqxIL3mXbfzC9ZCOflMLOlEOv8PtsBuJJwoT1P7j3aJA/f6+jBoWfoLvs1GzfskshiIn+/VB5R05Qzgt02XMqxq6GTFVp+Y/ndzvco286ZENcwN/MBuHSloQCowS00gTVecSBSxsxdu4eCJ0mlxpq4ZHGwtcOGcL67snjELm/Hzz/nGDBlwVKPB6KlwEmvPGxk2F3yVqlvG7vs3meHSV/2bGhEUFMB2zQGABnEy8PTOFEugconNG+1IufsqXstG7gAswpsQk1apawgy0+txCSK4x7XaErcQjFVLi8efmTD/7DDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FuByVT643bdw8QFPZxSQ5U8zZSAol1+19KDcOn4tXEc=;
 b=LdDpqjDA7S6J/ct14OF+BjS0Nr4egfWcZxUqcK68a63/AylYEmVGHyj30TS+n0Y/IFKAEeOtXiQWOMsi3gnZPanpFk8wvbUJ48fUmDAhaIsqVQxk1GgFF8K66AOC2GtV6UxkumMytL2Iv7DULbUe7PfbKbQzCcejJWhSfsyEGHk=
Received: from MW4PR03CA0222.namprd03.prod.outlook.com (2603:10b6:303:b9::17)
 by BL1PR12MB5922.namprd12.prod.outlook.com (2603:10b6:208:399::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Tue, 11 Apr
 2023 12:58:20 +0000
Received: from CO1NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::6b) by MW4PR03CA0222.outlook.office365.com
 (2603:10b6:303:b9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38 via Frontend
 Transport; Tue, 11 Apr 2023 12:58:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT109.mail.protection.outlook.com (10.13.174.176) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:58:19 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:58:14 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Pankaj Gupta" <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        "Santosh Shukla" <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v5 2/6] KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
Date:   Tue, 11 Apr 2023 22:57:14 +1000
Message-ID: <20230411125718.2297768-3-aik@amd.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411125718.2297768-1-aik@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT109:EE_|BL1PR12MB5922:EE_
X-MS-Office365-Filtering-Correlation-Id: e283461c-13e7-42e3-7a32-08db3a8c6ccd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WG/EdI/MH68MVcPGu1YEf6QHXxNsvScgK9p0j73iiS9NDneeEBDtpheXTEdmawOhp8ehFYxAqGNPmc347TM9iN4vK/NOejLc/NkyCpxIA2WZMNcCNqKQ9fi9nsd/V5JDCazd9RDq8lnDdc8+KMm0y3tq3FO4ULuKZjdxJ2m/S7mX3urINqUUjZJIs9k2vqvIPm2irI2CC4OvUz3cNmWotJ1qMUDOh7pNOzcsADXyxkEPAd3HzIx92/GS/ewH979rTLt6M2SqK9DrjJ5J5QLw3H1amIPLTiV6SC2qCro5dcUc6R4SS2K01rSK6FO7tZrtwdnS8+36V9RrHtwTBYOCVJP2QTE8JSfqkX5lBvYj3bm3z9mVj9J+9BesQKIy8SIb01e44qdzSQ2sKlUlkCLw2w8etvcBToR7poVMFE82P1HZ+VPLylkVEER1xACjNnCL8TviAB9WZ/TIo3NTLfA8HVqo4gL8M8TFAGifzMKmrJZFqVmzQTANUVr5tI/XkbADJR+XliF0+ELne0E0u+T8umlivLFxYc6jI4Z/b1Y+pWVlv602M9H/7HoH89KWdA2qcFYiMGg5nDkgBS7OMic2ur+rcEsNxLPIMtOOKYg8ep69UcZaHlz+R1xUQcDw3L2ljE/2W2+7UrIzNakPRrbsqmFp+4qJsVHsv9owaMxiFUiX+42Y/8NVF++KY1780wM6ckJWXOgQ7QvEfWZHsriOojQUZLBh874mcgtXj/6tHjg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(47076005)(336012)(2616005)(83380400001)(36860700001)(16526019)(478600001)(316002)(1076003)(26005)(54906003)(2906002)(4326008)(5660300002)(81166007)(36756003)(426003)(40460700003)(82740400003)(70206006)(82310400005)(41300700001)(70586007)(6916009)(8676002)(8936002)(356005)(40480700001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:58:19.6732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e283461c-13e7-42e3-7a32-08db3a8c6ccd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5922
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently SVM setup is done sequentially in
init_vmcb() -> sev_init_vmcb() -> sev_es_init_vmcb() and tries
keeping SVM/SEV/SEV-ES bits separated. One of the exceptions
is #GP intercept which init_vmcb() skips setting for SEV guests and
then sev_es_init_vmcb() needlessly clears it.

Remove the SEV check from init_vmcb(). Clear the #GP intercept in
sev_init_vmcb(). SEV-ES will use the SEV setting.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Santosh Shukla <santosh.shukla@amd.com>
---
Changes:
v5:
* new in the series
---
 arch/x86/kvm/svm/sev.c | 9 ++++++---
 arch/x86/kvm/svm/svm.c | 5 ++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c25aeb550cd9..0f4761a57d86 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2968,9 +2968,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, TRAP_CR4_WRITE);
 	svm_set_intercept(svm, TRAP_CR8_WRITE);
 
-	/* No support for enable_vmware_backdoor */
-	clr_exception_intercept(svm, GP_VECTOR);
-
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
@@ -2996,6 +2993,12 @@ void sev_init_vmcb(struct vcpu_svm *svm)
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
 	clr_exception_intercept(svm, UD_VECTOR);
 
+	/*
+	 * Don't intercept #GP for SEV guests, e.g. for the VMware backdoor, as
+	 * KVM can't decrypt guest memory to decode the faulting instruction.
+	 */
+	clr_exception_intercept(svm, GP_VECTOR);
+
 	if (sev_es_guest(svm->vcpu.kvm))
 		sev_es_init_vmcb(svm);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1e1c1eb13392..dc12de325cca 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1253,10 +1253,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
 	 * We intercept those #GP and allow access to them anyway
-	 * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
-	 * decrypt guest memory to decode the faulting instruction.
+	 * as VMware does.
 	 */
-	if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
+	if (enable_vmware_backdoor)
 		set_exception_intercept(svm, GP_VECTOR);
 
 	svm_set_intercept(svm, INTERCEPT_INTR);
-- 
2.39.1

