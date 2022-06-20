Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2374552825
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347685AbiFTXUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347688AbiFTXUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:20:22 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20615.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E2129C8B;
        Mon, 20 Jun 2022 16:15:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYwaI0tgXV8iujoQ0STf87VgKmtCejm+HHmvfptTkN9alywJGXnmvYQQZRxmhMuVT5yVMBHlE7Zv64/pEBOYc4YVFNcz3apgpSKa0n9fIO083gVOts/uHDLQrwxZzohR9jrNyT+y91Ed8uNW83AwB2aXD12UowOfvpqStfvXupZiZkMERPHCfijUqfRoiAwBXKrjIqpEJmjDGFRA06klt8+4pEaEb3yhc9AVn7R8UVnkSzPDbKekO4u8be5/PZ0cwb/6K+VoQBkfuQlMfEQphC8FY1gEvDWMZCNO3GuqM8V7Nr86SE1r1Cv9V0O5KPsnW6pj6NOBZnWbUDSPshq47g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8mVgporlVHbBNT8Cx4HixJv280dWnam0Bd62mXNBPA=;
 b=iIVgHZZ3mlX3fcFQlVeWvIZboL/gwNbER+v4xGwRKiUuV1H/TaiJq28dhXrCXtUT/GewtUdan9d7L5dIJ0rvhrjB+gaI7GzylgdE0MzTJ0rVwsnuvouXCPsVesFQQK3gU31hQ5UKX0A+WW0aYiedmJL+wDl1110ISBRBSC+kgqj+wcE3L+SeI8rYTf4H5/1o7cSRNS7X9yKNc9OdVgpia0jjr+OL/GOGZSYzQ0vqkDAfmDUqI/aGtx8++3/LdizMMZx6RiP6CDEtP0c8k2KVEtMeQQ6fGkfNvq2xPxGlj9JdekGnySqM6+hEAB8/KImP5+1Kk3VHLmh9UkVMUSpKIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8mVgporlVHbBNT8Cx4HixJv280dWnam0Bd62mXNBPA=;
 b=YE7imnvJqYPUpSGlIqaGycrigKYbaSqqmb0ubWvz25gYzm0NFSXMLpOhgxg3bUWn5Ai4bFCXL+uWp+ezxxJPVob25uN4mpRZaRtWRb8W4+9n1go7Vmt3ARxox82u4/1ddhjNVpHxtTED6g9Qd/K2F471EyGghg0xrnXqczPx/OY=
Received: from CPYP284CA0023.BRAP284.PROD.OUTLOOK.COM (2603:10d6:103:69::10)
 by DM5PR12MB1852.namprd12.prod.outlook.com (2603:10b6:3:10a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Mon, 20 Jun
 2022 23:15:26 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10d6:103:69:cafe::e8) by CPYP284CA0023.outlook.office365.com
 (2603:10d6:103:69::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Mon, 20 Jun 2022 23:15:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:15:24 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:15:21 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 48/49] *debug: warn and retry failed rmpupdates
Date:   Mon, 20 Jun 2022 23:15:13 +0000
Message-ID: <e78c2c9bd5c5b7dc262f41a85e75056f4af20b88.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d64c1ae-c0ae-4d38-72f9-08da5312c12c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1852:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1852D5686C80704DA5E564E68EB09@DM5PR12MB1852.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0vc00GkCxtEWymMsNyxuWpcPUXgpZwvyX+ftm+XeS65Q+LCs9lD13tQeOS1YkV9MTTqhSYX58Y0il3dgT/v7sRUPZrLHigD5KaI2CgeqEGqtnMTKTANB5xpNW+9S1FwhSOLlP3ed5DMP2oQEeN4RZikb/0nfki+hL/KEK9GO9r5a7Mx/d/D0JyQeVNe5CTUgYSFSF3itKx4A4Yzu6OT060fzVvbl67fnSHwOn5SO+365av2l0Owzj8Duh5GK/l2w4RxemFZyCaSDQlT1BfKYSn23r/8irocAywwKTWRmmf5n8g44EQ+6G1nOBmjWo7yHbSMy0Q00/JqZqg2FWAQJncWdUBjiiQcDL2ykvTcUowlyb8Occa912ZvNP1O+R47TzuhurOW8jEYWVCaAfAYTxDECdeJd+bc+xGZf6YkZ1Z0DHz+PNTUsN6dRWvNnHILiaMglGPO1NsWqtiWLA4kWAAq8YYRR2S/g5WCzytuufhHBr1LV9ZEW0ycs+7EB9Evp+Pi489YJiXw0n3JhfQ9qkIZeI7YIkfEZqg9Wghue1US+xPDUSOnce8gFh2fWb1wBz4fzYbViYpAha1hRUvJ2+lub+oGFVEkbhiliWTBGJrdJwh1BFVFZOdwhl2dlNftlcAGjCzxrWBFZ4oSxHhp8dtIa7q7GldwRFbLOBKfxLk9pcwK13v+wOl+KzNbjUs255In/CfazbLs7nmQKFH6KdjtQyAYkfMjpXnu8d+beVggIuUnhyMRlaR+DsdE4JQDVaKUzLRFoY+w1WPQjMikQTw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(40470700004)(46966006)(36840700001)(36860700001)(82310400005)(40460700003)(86362001)(356005)(5660300002)(8936002)(82740400003)(81166007)(478600001)(7416002)(7406005)(2906002)(316002)(40480700001)(70586007)(4326008)(8676002)(336012)(6666004)(186003)(47076005)(426003)(70206006)(83380400001)(7696005)(110136005)(2616005)(26005)(41300700001)(16526019)(54906003)(36756003)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:15:24.0841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d64c1ae-c0ae-4d38-72f9-08da5312c12c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1852
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

In some cases on B0 hardware exhibits something like the following
behavior (where M < 512):

  Guest A                        | Guest B
 |-------------------------------|----------------------------------|
 |                               | rc = rmpupdate pfn=N*512,4K,priv
 | rmpupdate pfn=N*512+M,4K,priv |
 | rc = FAIL_OVERLAP            | rc = SUCCESS

The FAIL_OVERLAP might possible be the result of hardware temporarily
treating Guest B's rmpupdate for pfn=N*512 as a 2M update, causing the
subsequent update from Guest A for pfn=N*512+M to report FAIL_OVERLAP
at that particular instance. Retrying the update for N*512+M immediately
afterward seems to resolve the FAIL_OVERLAP issue reliably however.

A similar failure has also been observed when transitioning pages back
to shared during VM destroy. In this case repeating the rmpupdate does
not always seem to resolve the failure immediately.

Both situations are much more likely to occur if THP is disabled, or
if it is enabled/disabled while guests are actively being
started/stopped.

Include some debug/error information to get a better idea of the
behavior on different hardware, and add the rmpupdate retry as a
workaround for Milan B0 testing.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/sev.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 6640a639fffc..5ae8c9f853c8 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2530,6 +2530,7 @@ static int rmpupdate(u64 pfn, struct rmpupdate *val)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
 	int ret, level, npages;
+	int retries = 0;
 
 	if (!pfn_valid(pfn))
 		return -EINVAL;
@@ -2552,12 +2553,26 @@ static int rmpupdate(u64 pfn, struct rmpupdate *val)
 		}
 	}
 
+retry:
 	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
 		     : "=a"(ret)
 		     : "a"(paddr), "c"((unsigned long)val)
 		     : "memory", "cc");
 
+	if (ret) {
+		if (!retries) {
+			pr_err("rmpupdate failed, ret: %d, pfn: %llx, npages: %d, level: %d, retrying (max: %d)...\n",
+			       ret, pfn, npages, level, 2 * num_present_cpus());
+			dump_stack();
+		}
+		retries++;
+		if (retries < 2 * num_present_cpus())
+			goto retry;
+	} else if (retries > 0) {
+		pr_err("rmpupdate for pfn %llx succeeded after %d retries\n", pfn, retries);
+	}
+
 	/*
 	 * Restore the direct map after the page is removed from the RMP table.
 	 */
-- 
2.25.1

