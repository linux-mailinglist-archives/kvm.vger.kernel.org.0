Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77CD7CB2F2
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 20:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjJPSsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 14:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJPSsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 14:48:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC2A1;
        Mon, 16 Oct 2023 11:48:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ngkjl7Z9c/94tmqVOslfKEov+UbJWfMk39yfLf50P6oCBY9TppcshQRa1RJx6kkmSAaGkfHpTS7fBehFEqVcNpHW1aIGdH9oDww0kMeHl+DriI9kxO/K2Xh1BkZlGLRTjOkHwCxMbTiB9EyNTBoi2OEwvMLzvLTelkVSCKDmjDL6SspDvV+kTBir5G94cmWLE8LkpoCS1ubCoucBIQczY1heiOd3sllpsJv1g2PKnGwR9nLOvn78myNK7/GvO+Z0KsoiAf9AEG98hbp0Fm6yacBt4vetMAAJLScaqeog4LfS5RwAcx8fXhvrIo2L4efz2QaVua62CQp77CZvlEgKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xZrDzqmgX/ieLod7bDL+GWzsXVuVhe5nA05RIZiXks=;
 b=E64LiGif1aiMASrrDqB3oohuqCb1JKDEmNZ7KYqhm2F+KUDnys7XdhmrFNhoX9atipmXhNCbxEeyqaA2epEKhMZBotkVW6wDNZ52ID3Fp7of+8FgVxxgb2M1/FWU05SDJulAzSBM6Ec2lJsL4Z0Zp//CL+pCzJMFt0uOEtaI8D4yvM2wD9vJx59LVdfJj4pC8nqfS8SiPumxN0iBMd/rNmy+K2H6Wlb9um9VRkSO40vcClrFxuSTAbPRFFLxsq7ctdnZPgl05aW+jEF53MUSR4xFw3OqOIN8WaZIZd0cPQo9uol0t3pPRiYpVuyIYbDsNmhCApzQV36OJetuEiUY1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xZrDzqmgX/ieLod7bDL+GWzsXVuVhe5nA05RIZiXks=;
 b=fQWs/FrTkQnIIxXFyj6jqYxz/i1LglR1FpS8ZMw+DLhV60kdgLOaQUda384OHER9brzQlL83RciY09DpmP5mU60E4IRe7gSVGmCnll+etdJ9lSnQv0fxGAzJo6eVMiZSRWIuZ+NYneQnueNQU8rWTfbVFuIa/+pPTFdAYlg2G6U=
Received: from PR1P264CA0096.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:345::11)
 by DS0PR12MB7971.namprd12.prod.outlook.com (2603:10b6:8:14e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 18:48:01 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10a6:102:345:cafe::de) by PR1P264CA0096.outlook.office365.com
 (2603:10a6:102:345::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.30 via Frontend
 Transport; Mon, 16 Oct 2023 18:48:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 18:48:00 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 13:47:59 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <vannapurve@google.com>
Subject: [PATCH gmem] KVM: selftests: Fix gmem conversion tests for multiple vCPUs
Date:   Mon, 16 Oct 2023 13:47:37 -0500
Message-ID: <20231016184737.1027930-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|DS0PR12MB7971:EE_
X-MS-Office365-Filtering-Correlation-Id: 0773d2bf-1aec-4887-0b1d-08dbce786bec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qRYgqWqmbXxiENWxwPa4YcuD+jmHLb3HaNDr5EHFMDimTt8dU+JC5TkkpOaIVQnLW8BVMKcBsW4PPkh0ugpsXojAmVFBXuJD8aMcr/7Pd6RgfDH4iDjvHCr5PwIIzPdgc7zgJS6ph99/HHnZz3aboWm3OGn5OuR4zKsjNGgiLDiZ21eoXtvWPIxvERTkEwj9/QY+MRRhAZyN7t8J2TBXgNoUWJD08JMi/nUkDrpBpqw8+RPlREJ/q4mIg9W8D+phLcIccUeuZrqNJW6ILdYbjgF7Kj03UEU+uHMbawgQ1zsGsvr/hRrNqkIeVCl1JfjatM/3aV4KLtukbujy9pwC7CfZwsSqzeEyD6T6KPhRF15D2E3Z6D+T+UFQshnL0MMYpkgJYHrCSkQRKorc2r8gFpK65O+FQyLrp19xg5wA/yUtX3CPn+uKC+ZTqNIpq5e1TnV4CXjD2PAIeqRXrYuK8EytZuA4+pPRtTsIohfTAOBYHjD4yBK+ZlNfCxehNqWQKYFKQk6GZdXyYNfjpZQrhwXfoLfA9Tn8+XvRHsmwFhEKg1FX0fXSwYtZa2kr4pPowh2A5ZzkQqd+npaf/msr0AFJRiCVXvxRGQ1d+ORF/Xtis3LUujOD2Cx82Pv0eOp6TTTkC3+vUfYvcxHvPj8ihHCANpzucnDDpa4IhMdl4F+gqY7j9U8CG45MZSgWkZP9JpSxZSiHsD1qZdeQNLm5C8tQV4z0OrThoSb5I49gKZ4JID4GCsJrBqo9cZjIjioQX9skxTYSHUU+ZMCNCWWncA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(136003)(376002)(230922051799003)(186009)(1800799009)(82310400011)(451199024)(64100799003)(36840700001)(40470700004)(46966006)(41300700001)(70206006)(478600001)(54906003)(70586007)(6916009)(6666004)(16526019)(1076003)(26005)(426003)(336012)(316002)(2616005)(8936002)(4326008)(8676002)(2906002)(5660300002)(36756003)(44832011)(81166007)(47076005)(36860700001)(83380400001)(82740400003)(356005)(86362001)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 18:48:00.4460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0773d2bf-1aec-4887-0b1d-08dbce786bec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7971
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the private_mem_conversions_test crashes if invoked with the
-n <num_vcpus> option without also specifying multiple memslots via -m.

This is because the current implementation assumes -m is specified and
always sets up the per-vCPU memory with a dedicated memslot for each
vCPU. When -m is not specified, the test skips setting up
memslots/memory for secondary vCPUs.

The current code does seem to try to handle using a single memslot for
multiple vCPUs in some places, e.g. the call-site, but
test_mem_conversions() is missing the important bit of sizing the single
memslot appropriately to handle all the per-vCPU memory. Implement that
handling.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../kvm/x86_64/private_mem_conversions_test.c        | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index c04e7d61a585..5eb693fead33 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -388,10 +388,14 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 		gmem_flags = 0;
 	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
 
-	for (i = 0; i < nr_memslots; i++)
-		vm_mem_add(vm, src_type, BASE_DATA_GPA + size * i,
-			   BASE_DATA_SLOT + i, size / vm->page_size,
-			   KVM_MEM_PRIVATE, memfd, size * i);
+	if (nr_memslots == 1)
+		vm_mem_add(vm, src_type, BASE_DATA_GPA, BASE_DATA_SLOT,
+			   memfd_size / vm->page_size, KVM_MEM_PRIVATE, memfd, 0);
+	else
+		for (i = 0; i < nr_memslots; i++)
+			vm_mem_add(vm, src_type, BASE_DATA_GPA + size * i,
+				   BASE_DATA_SLOT + i, size / vm->page_size,
+				   KVM_MEM_PRIVATE, memfd, size * i);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		uint64_t gpa =  BASE_DATA_GPA + i * size;
-- 
2.25.1

