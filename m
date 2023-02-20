Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3453169D3E8
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjBTTMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjBTTMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:12:14 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD191A649;
        Mon, 20 Feb 2023 11:11:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LesiwY9wpa7r9Ap9qkVzdAFkPEdizHTsmMxq3aK1eu828F2kXo0o3ewj1RJH0M9HLfXAvJaiGRk8hfWQj5YydvJNrxBgy5wf+KsNdIUpIQxyIfMTRj+amNiEeouSK7yD+KaYpjvfYQwbMXkXMbiGqD9vd1z031Ku0kqJSIuoP3n3u11bd4Di+4qWgZyDRf08mAu2CiCbefDzfMSTvzpZ4RdEwub06yvzr19yuWvXX81sil51ToiAmeMRSSE2WWVZ2QvnJr8I2P/1u6Iopau0ytUCB3CGvTVewDXxBHpMNLFGoVOT5RzExec5tsneFMm0serFOOsBomHB1m+rHa+cPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3nf73drwaLvEnfy8UVO8myJaOVWglmANxn8btDUER8=;
 b=XVY9hpW8EB1ty4unAKiA0XxKpFtjQ3xaF8gyPTlvdvRXjpxti1baRE/eGk8wNZweg2K1O1SX7N0CxoVPBGnie8DlEohUw1WjIgtbh8IdMTNCIEZFlr5dxEH/77TN6y++2mWWAuyqfzhCfgaR+FIJfYSlNcHWcsOlI7wf4V89GbGEo6wakBxyJJzHZF97HejfWRYhMfl/cgIn0O36bFiwSJYLF7+d/Ad8jcwQkMYT6I2sfP19U6tmpV7mf+3AvSMSpLsdB78EUwI6ebDdrwAhlCRWrt3W6PlIkB0i9gk1OrAhrD2vSTiS2f0qouTBdqfAvN34pxuewco+kG/JqhZjSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3nf73drwaLvEnfy8UVO8myJaOVWglmANxn8btDUER8=;
 b=Ab2OZ72FdQ/JPayIcGtzQZD2blDZZRubTdMYMjF3xGOtBrVszkTU2sQOguah3bwqANVU+4854QSSkR61WeL+U3ukbxtCiV0zb8qfCnS2UBpuUund0usm+DTecBSTf2jlQ7rfugFGDztSyQbHxb3u3g/ticBc6l6CXg5Lfy8e6Bs=
Received: from MW4PR04CA0298.namprd04.prod.outlook.com (2603:10b6:303:89::33)
 by SJ2PR12MB8009.namprd12.prod.outlook.com (2603:10b6:a03:4c7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Mon, 20 Feb
 2023 19:02:05 +0000
Received: from CO1NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::8c) by MW4PR04CA0298.outlook.office365.com
 (2603:10b6:303:89::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 19:02:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT080.mail.protection.outlook.com (10.13.174.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 19:02:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 13:02:04 -0600
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
Subject: [PATCH RFC v8 06/56] KVM: Split out memory attribute xarray updates to helper function
Date:   Mon, 20 Feb 2023 12:37:57 -0600
Message-ID: <20230220183847.59159-7-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT080:EE_|SJ2PR12MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eaa5440-d3bc-470f-2352-08db1374f541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZFMXZt6POvfTIKz07tkXAkp6GtKZCxbDSIK5Alq+8AsCTBxdZyvAQIK7+btA9m+IDdZez5NdfUYpxAzE1+xKXQFYGlfnD3jdVyGmguJ/l3V0MkHWDCy1UTr6iRJj3lJ1oqZIxxsPCdqO+g24RqVPRiaosD91MTDb15UdKAwEwaKdlZmOrcyJ9c4e1RAax2CxGF/rPZl2mD7wU3ko5p0ufzPOmZSmBOmjmodIKtNoAS9pJ2gm6tgD38lFEgmUzcndZN5fxEaUntQ2bkg5/v1P1Llycrm5vlz+IJ6Byr9yZpnO51zrmyv0BFpT5JLojH/0FbQmjOgRKaqKmsUcSCzbO9jJHMIBHDF90XWfrrMvTN1kd1eKLt6BwkxxBsDeuV3WaaRs9353fly5rk6x1mqv+t0e7zB72dZxgnTjeGf0UiXiiYJCHnWatIY5aUCoMC4OnxiDIpYXJv8wydWWrLKHiGuVo8dVhMolFKJ+NpgA9OOedv5YvFH14G8Xg9kBx1OZvAcL6JOC2vgRf45r0jSXMOwg3BXSWtzJHsyzlXxFu9aAUrHjWzz1TK+TVdAqHbKyoiRMPZZPfw7il9Z433V+7W62bFtF+dMfO1QBoJFFQLvD1luPo9tP2QF9GPN5/GWLIJOau+VYci0jaDwgJN9AzAz45H6kbsrV24d6RcTFYFp5dzmvUBY3jKhu8MDZWHTZ+4zL51hyb6IN7roE4m+rz619qrPJciNC+208fz1RgbM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199018)(36840700001)(46966006)(40470700004)(86362001)(54906003)(8936002)(7406005)(36860700001)(336012)(426003)(41300700001)(2616005)(316002)(7416002)(70586007)(2906002)(70206006)(5660300002)(44832011)(36756003)(81166007)(15650500001)(6916009)(8676002)(4326008)(356005)(478600001)(16526019)(6666004)(40480700001)(26005)(186003)(1076003)(40460700003)(47076005)(82310400005)(82740400003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 19:02:05.3471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eaa5440-d3bc-470f-2352-08db1374f541
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8009
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be useful to other callers that need to update memory
attributes for things like setting up the initial private memory payload
for a guest.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 26 ++++++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c615650ed256..57d56cd09a61 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -993,6 +993,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module);
 void kvm_exit(void);
 
 void kvm_get_kvm(struct kvm *kvm);
+int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end, u64 attributes);
 bool kvm_get_kvm_safe(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4ccd655dd5af..c740b56d6ba4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2645,12 +2645,28 @@ static void kvm_post_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
 	}
 }
 
+int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end,
+			   u64 attributes)
+{
+	gfn_t index;
+	void *entry;
+
+	entry = attributes ? xa_mk_value(attributes) : NULL;
+
+	for (index = start; index < end; index++)
+		if (xa_err(xa_store(&kvm->mem_attr_array, index, entry,
+				    GFP_KERNEL_ACCOUNT)))
+			break;
+
+	return index;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_set_region_attr);
+
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
 	gfn_t start, end;
 	unsigned long i;
-	void *entry;
 
 	/* flags is currently not used. */
 	if (attrs->flags)
@@ -2665,8 +2681,6 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	start = attrs->address >> PAGE_SHIFT;
 	end = (attrs->address + attrs->size - 1 + PAGE_SIZE) >> PAGE_SHIFT;
 
-	entry = attrs->attributes ? xa_mk_value(attrs->attributes) : NULL;
-
 	mutex_lock(&kvm->slots_lock);
 
 	KVM_MMU_LOCK(kvm);
@@ -2674,11 +2688,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	kvm_mmu_invalidate_range_add(kvm, start, end);
 	KVM_MMU_UNLOCK(kvm);
 
-	for (i = start; i < end; i++)
-		if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
-				    GFP_KERNEL_ACCOUNT)))
-			break;
-
+	i = kvm_vm_set_region_attr(kvm, start, end, attrs->attributes);
 
 	KVM_MMU_LOCK(kvm);
 	if (i > start)
-- 
2.25.1

