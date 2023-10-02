Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913147B53FE
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 15:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbjJBNeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 09:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbjJBNeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 09:34:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBE2B0;
        Mon,  2 Oct 2023 06:34:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTeKXAb7TKfwvJ6T6WGGl9ay2EUc5KSPm1jU3CJVJ1QoRsvs7ldtklfK+lchLozWCA6tFmHwBk5LYvdhCUT29OuN2enAIRWCSCyqPQPWG083mVIXoScr22ZqmrNiJL3PbHXmh9TDJ6tMal4IttC/wkHN2D6zLzxltYgUSdZPP2h50/1R8nq2ExY/dCnqiIpYONUk0sWVfOCww7tOGrafItCjpWeSqLf+AgiVMi3byNrjTtqFPJGS0BFXHdMOANv1V/ZGB8v9N5r5dq/VQqaJ3fHkC6Xpgy9sBOq+/9Et+S9J6pxc+xBn9ynuWoY29tzVm5co9qFPDkinfPyXDMGffg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBr3H9Fof6C2rQ+R0hX5Qo5gec0q79rzUFpMk481wJk=;
 b=Iao62v4Bjc82yMHlJzZAk97ulhagEHtpiT2B1ZSi61tuXUarMTpK41LAwBqjJaUza4hGJpru26oHezkJoA6geBr7pj1g3DFmCA4EdnWBabDpFqiaMDCaUditFhI02YNPfxgjhx9qJJOL5VgGGTyCK7sKMKwjZG2x1orbblMi+eGhsvnrB7OZBpZpX4U9DoNST8wQU/Hjykh9tsyh4IHo5NT1ruiHLxdd1xipLIdUvSyhxf/bSvGf2JhJFR1MeGcByAGYjnTc92448Ogt4Zd95hDPWU62qFM6MdiwXC2HVdoxoXWhgKQ0S9o5eyqDZOVqQHFSB+qQnlmxeYa6Gq015w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBr3H9Fof6C2rQ+R0hX5Qo5gec0q79rzUFpMk481wJk=;
 b=ak0eV03bAH5Lt4E4K0xi1c/euJSXnx3MllDAQJezSA+lD+zxYFG30Bj4k1NOtsseT88fTWCAvYjEfYX5f4VvNtnP8aoJ57Wn76lU29Ta8tke5wPKc+8zEVcRsMoDMYdgdZAdxE3oU1QOqU709sAQTBNkUqCLWdgeEiDoj9cAq/4=
Received: from BL0PR02CA0113.namprd02.prod.outlook.com (2603:10b6:208:35::18)
 by MW4PR12MB6706.namprd12.prod.outlook.com (2603:10b6:303:1e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.33; Mon, 2 Oct
 2023 13:34:11 +0000
Received: from BL6PEPF0001AB4F.namprd04.prod.outlook.com
 (2603:10b6:208:35:cafe::3c) by BL0PR02CA0113.outlook.office365.com
 (2603:10b6:208:35::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.30 via Frontend
 Transport; Mon, 2 Oct 2023 13:34:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4F.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.14 via Frontend Transport; Mon, 2 Oct 2023 13:34:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 2 Oct
 2023 08:34:10 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH gmem FIXUP] KVM: Don't re-use inodes when creating guest_memfd files
Date:   Mon, 2 Oct 2023 08:32:30 -0500
Message-ID: <20231002133230.195738-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4F:EE_|MW4PR12MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: 1745b447-b49d-4a25-cd1c-08dbc34c4311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pq/2V7qh4a2n87zYe9nBr9A+TN+1qDl9IxCvooJW5f9ENnnbeOXYKCs6njg5dXPaH2GVVkzew+HDMB1T/xcxyOlVq0hSkZoPnowbXrBP5ssVXH71DquMNEQZLwVuNJCpcE/TowEVBz2Gz0scDwY3TcmVrSONPLtCTTaXrqNptuM+luuJwI8V8XEIAoy4BQSobZwbUzyqg8RaxOiRgjtgQwC1usGN7YnSwtaAVccthaBlQvoC1+EqMfJ6yhQD3em1hNHZpCT4WoHbM91AdJFE23YJIOSTninsl0ABgivKy9WnnegnGr1tfvSwCFMQO2KOXymhIS2vb0FrLpE1bGJauBTgXvYF/mf7KZG2UTCO6Jl9FyhjPq2gi0j14MQpvbyMZKjIgORl//3RNRH3eVAjtIVbQU6bGgvyQykAk7bnGbR3VKACo9P3hUiLVc62mDUEuYZ7hFHVVhMEXYuGbfcbK6oZ2gR2/a3a3wU8HNxPx5mVtdYDh6LrGpsIQ3kr4TpYts0jntJTL9JxMRWX91XFql9th0hqW2Lg/wPMUEIp9H+verJLJVzyQRsKOARqFe99XeIHO/UfmGrpd8Tf4s9y9Ok/Aodqp/9Wr9yOIDqyBsWZK/egQmoFYWfEjSKlZLV4BPgq13mR1kwuaGqi3xxu1P/qpdDSzAwDIJnJXkitKa+V2GdELX6CljdbLPAaJR+2NCWtx/jwQkckDkXh+c0qnJN1a0YthaizzYScKAJmHwgs5w3Li+NLEof7ZKLp0+zcbO1jfVLc2255URSsY3AQSw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(230922051799003)(64100799003)(451199024)(186009)(82310400011)(1800799009)(36840700001)(46966006)(40470700004)(36756003)(478600001)(81166007)(316002)(70206006)(70586007)(54906003)(356005)(40480700001)(6916009)(40460700003)(6666004)(41300700001)(426003)(44832011)(336012)(47076005)(8936002)(8676002)(26005)(83380400001)(2616005)(1076003)(4326008)(16526019)(86362001)(82740400003)(36860700001)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 13:34:11.2759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1745b447-b49d-4a25-cd1c-08dbc34c4311
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB4F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6706
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

anon_inode_getfile() uses a singleton inode, which results in the inode
size changing based with each new KVM_CREATE_GUEST_MEMFD call, which
can later lead to previously-created guest_memfd files failing bounds
checks that are later performed when memslots are bound to them. More
generally, the inode may be associated with other state that cannot be
shared across multiple guest_memfd instances.

Revert back to having 1 inode per guest_memfd instance by using the
"secure" variant of anon_inode_getfile().

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Fixes: 0f7e60a5f42a ("kvm: guestmem: do not use a file system")
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 fs/anon_inodes.c       | 1 +
 virt/kvm/guest_memfd.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 24192a7667ed..4190336180ee 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -176,6 +176,7 @@ struct file *anon_inode_getfile_secure(const char *name,
 	return __anon_inode_getfile(name, fops, priv, flags,
 				    context_inode, true);
 }
+EXPORT_SYMBOL_GPL(anon_inode_getfile_secure);
 
 static int __anon_inode_getfd(const char *name,
 			      const struct file_operations *fops,
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 78928ebd1bff..4d74b66cfbf7 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -378,8 +378,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fd;
 	}
 
-	file = anon_inode_getfile(anon_name, &kvm_gmem_fops, gmem,
-				  O_RDWR);
+	file = anon_inode_getfile_secure(anon_name, &kvm_gmem_fops, gmem,
+					 O_RDWR, NULL);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
 		goto err_gmem;
-- 
2.25.1

