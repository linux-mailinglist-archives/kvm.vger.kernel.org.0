Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA22964D0B7
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiLNUJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiLNUIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:08:34 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C96237F89;
        Wed, 14 Dec 2022 12:01:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+LQr/sq/5kxOkZlqYhg2UmENgJW9yUsH/NSSHvqhp7Pu9A951k+qpcjCll+aNXD9sqFpADfJu7joXnj5ydfALiENN17Ie4vSHixCfS9Az7/t3Bv1jcG/Ais7a9/AwTHC/RIL0Wo3/VUOZYZ8IusUzpgXyKDFtki95MIh1hZLu8La2enadAUduvTDfI8f0W5TCGxyZ1MVPpwypfjjtGPnnUeS2IV8vzRLcDOZULH6IYYE/NemdtGnJtYZju/5PGI8yPPsEbCiQpaDX23kx/jkGJTUJD3zlcs0XCLEfQ7PcUMlMeO04z8wVXQNTBtIaVGhS5IfQ944kQKZIfHiazZ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmwpFRrETQPvZ04fJ8irqa0gEHOKsSxIthHrtbtX3fA=;
 b=fxsiwWsp9KesXpdtxB5TB+M8m6Jyra9L/GUkiOYCsAKpE7zWglMK/IKdaiXv84gKBL61I/hW3XpD2WQCOnERVUectGOscMFgrzJxWr8eLELHNoeWwjc57eaP6KzP5fPX7ksEohjiH72Q+zcRVd2O1b7ggu20YekRtCunNdpRTlioLSVYHqnvO8xH4yYA77qlGDKGelES7AVkkuWOx0Z1r8JXKeflrCvTWhx9kKjOTrBnJUMhvk7+pf3wA6I8A2M2+Qp+6UXh0VaguQ1E9K7EbDiooFHb0zS3G5MHrvxUoLQotdCkGeo1CrA1eCINubAmi2oLkdXyFY1WJq2dUcm60w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmwpFRrETQPvZ04fJ8irqa0gEHOKsSxIthHrtbtX3fA=;
 b=0ieU/p153QUdR0G4RHpyn9cuT437mF+HWq7udXtEudaJV3HZ725Si0JalrQWdE5D3cD5+DjhUTgsAAqW+jezc5f5falgLtBW1qKFS2NYiHxqYW3wxKOrT+fzbtfA4W4weG0RH2J93VjDT/+5/b94IvJfqv7uos7pK/fu1JChNDs=
Received: from CY5P221CA0087.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:9::30) by
 CY5PR12MB6105.namprd12.prod.outlook.com (2603:10b6:930:2a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 20:01:05 +0000
Received: from CY4PEPF0000C973.namprd02.prod.outlook.com
 (2603:10b6:930:9:cafe::53) by CY5P221CA0087.outlook.office365.com
 (2603:10b6:930:9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:01:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C973.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 20:01:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:01:04 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 46/64] KVM: SVM: Add KVM_EXIT_VMGEXIT
Date:   Wed, 14 Dec 2022 13:40:38 -0600
Message-ID: <20221214194056.161492-47-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C973:EE_|CY5PR12MB6105:EE_
X-MS-Office365-Filtering-Correlation-Id: e3f97380-cc2c-4a8e-2e78-08dade0def5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RLIAeRG3jFUMYUCStQ2am9kZ8uCuwm4eVwjBeikSbJo77z+YiQhzNT7q5Wwigx30C1LZ61Lsd0ojph7gF3bJCcs5YjMIS2j+lQjIE9nEXsjBXbXPWLbcrhXOa5DzQGueXMb7vFYKkbJGV9kPWURUfRmgT0TsnSUT8c+9oC03k1sbeFRLEDQ03ppO+0G7J8H13LTqEn5rUE0TBlaMRmDAQEIgryon3ncszP9SrNwuPWbhrVFayUtxMgPMhTDBsWq/xzgnb6xIBUgJ+juUE7YrPc8o4V6UFXsNB1RxnXQRLicDVmKOzJJdDiuz/ByoT4NfGRKihHvUb7rZ8nINXaYLUHt63WBOIMSlPuRwqIobNmZY1jQ53UCfU+MjLQgFwX3+GjA5lqkXyVtsl78g+ad2Dv9Q7Kjvi3VsVEx2N44RQ1zZeNCRk9/m5LfoJFPGHzLrQNjluOcMJfj1MIfNoV84jYYAbRlrez38tIlw7KDua6FTe5cPDgZT1dl/DyNHTUf36YAaRf42fZvL6MRDpyZ+LoavpdGIi97T8wfuKAoPFc9k0XIq8wMfAO53lU0ozvjyP2DU2+XDKETmGA8eRkXSeWAa6cnDJZNV6yXancyV88A6g9blKKmEXBri8iFntRoMeLqUvyjqQ3tDzjbAIF10NWWazn/Ev1PLWRs875Vm1Nf6cqJxEvfjGY5T1g7fbOVA1VOwDQLxjJEQNE47CO8y5o05YBuShZOc24IS2vHWMTk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199015)(36840700001)(40470700004)(46966006)(44832011)(26005)(2616005)(36756003)(86362001)(186003)(426003)(47076005)(6916009)(36860700001)(4744005)(336012)(16526019)(83380400001)(54906003)(40460700003)(1076003)(2906002)(41300700001)(6666004)(82310400005)(356005)(82740400003)(478600001)(7406005)(81166007)(40480700001)(8936002)(8676002)(316002)(70206006)(4326008)(70586007)(7416002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:01:05.6922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3f97380-cc2c-4a8e-2e78-08dade0def5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C973.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6105
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For private memslots, GHCB page state change requests will be forwarded
to userspace for processing. Define a new KVM_EXIT_VMGEXIT for exits of
this type.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/uapi/linux/kvm.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c468adc1f147..61b1e26ced01 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -301,6 +301,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_MEMORY_FAULT     38
+#define KVM_EXIT_VMGEXIT          50
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -549,6 +550,11 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory;
+		/* KVM_EXIT_VMGEXIT */
+		struct {
+			__u64 ghcb_msr; /* GHCB MSR contents */
+			__u8 error; /* user -> kernel */
+		} vmgexit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1

