Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7DA69D3A2
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjBTTAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjBTTAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:00:30 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D440DCDC7;
        Mon, 20 Feb 2023 11:00:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDrNglJ0xX+zgLTD59mSx1wmnALZDybesPSuIBlYzitQGXvAdvvCCcdYFxI/6Dr2lhVnqZPn1cE8lnkH/WIES8eTvBbZ3aQicnOKaHB+xiX5vExO+Q/IZMn0q3m2kmXBczxLXBwZHFxY9qjUJ8hGzsd5ft6U7k3ybKEdRqsDqqmBRqjKkrYiif03lKsWS+IagQtZ+ILCgZHdqa3/a9Txa0DbCI87jZDUxDPp/DI7mguVgaqqUFInPv5v9NtSScUQPWkFOcpkd+N0sst7KiezWOU9j7ttkvQgSui8SpvighvQIDorhtntfCLG0wlMgJA7XqGnLwsOM4DjuDiVfbJV8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwVXnDi9jaA4a8BdNgxHpkNnSMn7CrcmD4LD5ZDYAv4=;
 b=jycO1AGj8yOntyPS8sC7YAhw+aOEiOKNvcSTuMBRzmUFoWOlEK9zywiP1QlpU9jbnmn4I5SyDxVxP0NwUav8UkFD12fRAqC4cbP/NsdzJp9yEYqCLHDDHeHTswY0h/uh1mXheVTdP22bw2mVA2XsAfTh7301UM1wR2PpukZpaDfTYqJ8Tt0h0Wa7SPqLjSMbkomwVmYMftqaP4HcY1KrzLDfoakBQmPg+vb8fkXLK8cdFk7RsohR5klcFyPMotqHPTrBG4kjCi0ZoW5ggohE7gb8CfXlzVpiYn/WYtDC0kdxGBSiqniNESxWhHy87TjHOUZdWQF69XYAWdMAU54nUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwVXnDi9jaA4a8BdNgxHpkNnSMn7CrcmD4LD5ZDYAv4=;
 b=CpdKZCb3MWz0LJjObZyBRJdvEZt0gYkfYJlOWMtpTp4Y9glzScmTUGFCELmTJOUWaYIYnf0wG8YDWfHrx4wID8R25GvKevV37WOqYz/ncrYkqoYuwMUX/or5Xf1wM3au42yMMz7smX4NHB76n6tOgpnBIqp2blubyTTuQNsaDhw=
Received: from BL0PR01CA0019.prod.exchangelabs.com (2603:10b6:208:71::32) by
 SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Mon, 20 Feb 2023 18:57:34 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:71:cafe::99) by BL0PR01CA0019.outlook.office365.com
 (2603:10b6:208:71::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:57:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:57:33 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:57:31 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 46/56] KVM: SVM: Use a VMSA physical address variable for populating VMCB
Date:   Mon, 20 Feb 2023 12:38:37 -0600
Message-ID: <20230220183847.59159-47-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|SA0PR12MB4557:EE_
X-MS-Office365-Filtering-Correlation-Id: 84fdfd86-3f56-46c7-f60d-08db13745371
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntxKMRTEXGB1icnLd1eH5EPjxNCt3N1sncm2ALlg0usUPaCz4o5e6q/dljRC/kJ7m58BJmThAGPaQr8hZ2adFYBSXfTuDxrqQH39lxIWMmOyC/Rp/40NoDOdJ6JdkSIVhsP2NGvYyPY35Dn0x4YtdWQv+Gb6+RyRpjTZwWxw+ofeYb8zLV2MAcmFWCEbAhgRCUlHKXt7UPFBBWE7dL3qHpY2iu6TvygwTx6r95UBCkWJqxOFYLfk7b0pKjg6vwO46oY9Iy91qjQ1I24prgSNQhcZkmI1/z6TH9p6O9MsFTQPjE5+vudBzdBn04ylArJ3rIMmMmgMczyTJO1QuZkgwKtZ6hgtbFMJpe3T7y8/CVz5g91wAHAucKPEYi1zqvAf+0R/0O3PX3RCHCeFw5X/TC05H2+xtcwTvm2PzOfMaa5HKa1vI2TbXTZzwPO0h065eLCqCwr2snsv3E4OFj7zssfaeP8dW6kO9U5JFd8hgXAeoMIthbsBVuadSS562zE+DgeE7wARCzxEyv1fQwkFWXAWYfA/rpfS3kkoRVHsDa+/9Cl4+Nd9KH4o5leRSRwpy6UsTXAtWmaVpTjuNzMkobCHnri94yNaJeXteHEUeJOWDIMZr7lT9l0it79nuxfGHDUehDHO50+k/0OJ+mUUqbckXfS0MDABGfRnTUg2JlsF2UtY6sDyhSUEUvhBzLfjRpSWSbFgguuU6AwpiXLheVD17QSL7ZFdxxAlPCqbX/Y=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(36840700001)(46966006)(40470700004)(36756003)(40480700001)(8936002)(7416002)(82310400005)(44832011)(356005)(5660300002)(7406005)(86362001)(1076003)(82740400003)(41300700001)(186003)(4326008)(26005)(36860700001)(2906002)(8676002)(83380400001)(316002)(54906003)(70206006)(6916009)(40460700003)(70586007)(16526019)(47076005)(2616005)(478600001)(81166007)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:57:33.8137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84fdfd86-3f56-46c7-f60d-08db13745371
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation to support SEV-SNP AP Creation, use a variable that holds
the VMSA physical address rather than converting the virtual address.
This will allow SEV-SNP AP Creation to set the new physical address that
will be used should the vCPU reset path be taken.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++---
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 92179614102e..6bec2712ecc6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3849,10 +3849,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
-	 * VMCB page. Do not include the encryption mask on the VMSA physical
-	 * address since hardware will access it using the guest key.
+	 * VMCB page.
 	 */
-	svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
+	svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f9ab4bf6d245..745f736d9c98 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1410,9 +1410,16 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (vmsa_page)
+	if (vmsa_page) {
 		svm->sev_es.vmsa = page_address(vmsa_page);
 
+		/*
+		 * Do not include the encryption mask on the VMSA physical
+		 * address since hardware will access it using the guest key.
+		 */
+		svm->sev_es.vmsa_pa = __pa(svm->sev_es.vmsa);
+	}
+
 	svm->guest_state_loaded = false;
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4a9ffb7e5139..b6ca6657aa6c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -198,6 +198,7 @@ struct vcpu_sev_es_state {
 	struct sev_es_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
+	hpa_t vmsa_pa;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
 
-- 
2.25.1

