Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5980B347EA6
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbhCXRFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:44 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:50400
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237048AbhCXRFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4xe+Dc7SJ189w66rF26UMtNRjAGOLH+ilGNzPKINKKBKagQHPlEusJBOaZcLLlT/l6xFWql+DcAwLzs14zpsRLBoshEyxdc7Jv6/xUYWjHK3+A33SAu36OGL9e2x5BKj9YR2r95ADXPbeaKvbdQPY2nQ4NU1bp4jwzT5uS8HZUlJRXOv9Z9EE6GufzuaV2lo0ukYb++dYJzp7K8orp9s8eUNG9evRtEa30wwA/3IkZVjMSPyn/3Cd3qwQCZ7YS2IWJ9eLbzNEFhmn21PltphRsgz4OaaNuKJNryMj7bWeUlC7QZyXM71R4j/O7l7HbcO8PouDABWBRNU1T8CVOfOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USWAPSDrkPixl8ICG9MoZEp/4U9M7ze9vOMJuwexQAk=;
 b=QYfnxJNLX4pZRArzkj8luTONtfNNdUbFbqQqTZFjh7PlJnQAhrZsynVKxxbWHhi1KeGd8MeBtRnGzfcJ2r4E4/sZ4VOquWVwctBzeO4S2aXCzqk3/mcFgmZ+D9olZSKvPkmwhnWZ6UspfncJa7iOdrt5VzzuE+A3JoAvCpWvJtWV8Dr2Y+FGeqaYaj2QA5fyPCr4N+vyU+2j7hgjxSgg64l6SZLLcjnHqM0NhWbXL3MXO2JGgtRdsehgMsSfL84Olc+OPxvExPnI5jzhGM5vMouWHjQIm3ud2aBf2CbcPEXl57VvmhP8DgO+IiWPcf55FrWMfi8Rr0Kzr5j5d+Ft3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USWAPSDrkPixl8ICG9MoZEp/4U9M7ze9vOMJuwexQAk=;
 b=T4srTx+VBFok1WZsDzEsQsl8mLYxUhawPHJ2rgLRMmknn2d5nZMkv+p7/sfiQi2UVQ+/SJKbm6z4q4j0fEA6FyMul/UwN2jbTn2Q5iJ4ArhoaysAVylkT70othuxoDdcZ9JqhuEUitzrHei7V2g+12ADjL0B3CQcBDGTS5OoVdY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:05:00 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:00 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 12/30] crypto ccp: handle the legacy SEV command when SNP is enabled
Date:   Wed, 24 Mar 2021 12:04:18 -0500
Message-Id: <20210324170436.31843-13-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 769d9387-8c4a-4d26-3a8c-08d8eee6f596
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557C98413F79940BC4756F5E5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R0qR1apenws3tPrJDfOih5Y2NOUQUV5jRerbZhdPAEJ8BfnCjNZ2bwLhBdCG+ldzjqzCYh6X4+TxQYGBsw9o0HZsN7n8SM67O6flyePiUzSYHj1L4Ue/rcDMWbchNoMzhkpGs5r2SS8YU9/HQgGhcKMzW7RHrZMDXcx9610w+s6ixlM12cnsIm0Momv51Xc8ntcl4/42cUuNkk81ZXgWMkjQumT+1ae5rkLF5zEKcyQQTZs000DSugg7Nlom4GPt96oqe6gdQSWRfk4J5i7RRcMAgP6j9JgSMZkXpqBGa4J2zZh3RQWTFacp6g94OEXQxojcLH3hituSFWoVbz9g0EY7mjEbz5xj68ElIrML40jdURAf/GyowrzlUQHhF15GBhSwqarNCl+H9himvnZ4UdFjjOItv6fBwfAqJrwSla/L49gwiNjhUzBW+MRjaBPVU31BP1K3vMuATTjn/acNLf5xuPOiILujUEgiRuGmxYfHPNdxLqMv7gWH0a/uKGaWGTa4ITqGPips5AKShVeX6kD6Qr04+hdyvLStvGNteJCteHr4kAlZuh1bziFBKnkFaRtX2XXFyFN7/BXt4J/RoqPWeEs77zNFYsXQeZF7awpsyH/vjpoBIrYx3fAHPgd6SF999X6Con/d2hPIMOJObjOqd/3CjQ/aAKAlBVzD7VGjPgiWwEw7g3Ra1OOs7stM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002)(71600200004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Rw2ZGcgxs5MUidHwH/nhYnPN+pcVjaYDU2KatjcYkBwxmT0qG2QbcChVY6vm?=
 =?us-ascii?Q?NbrdPNAns+tCMAPS9gm0Sw2oUXvjAg+q0JBWLMQpSX3plhWSIKdnoiAGYXxj?=
 =?us-ascii?Q?Nkw02pW1bWUTb9wXCP3aLQ8gopI8U3d7TINpwubq5Ky9GpmQClRdWkYeYe4i?=
 =?us-ascii?Q?d6WsQLd8acDH0d0ncTtn4TVfow/B56+Qgw6n+EuOCn0n2AJ2TyFKtPMGQQCc?=
 =?us-ascii?Q?WQcUVBlYaW7sCpNsjvXlpZvTU9DdX/LKXWlckerxHY+1MbbyMHDCEvfJOMPS?=
 =?us-ascii?Q?gW4BqaVC4Nc43CIVCeXTHJDPaAJ1x+QjXk2Nv6h2UWn10zGsu5mDaWt+CM+9?=
 =?us-ascii?Q?cm3yvMEkOSkfN4mLG4PoMP2zFLsvkZ4W/OTNWN+kT0VFqJUzmtNjnltiCDiD?=
 =?us-ascii?Q?4esAdXwAhck6jLorRqpXVWYfDrqDLBjVIlgcub994u3xVHfzOcRk2qc1dBFX?=
 =?us-ascii?Q?JYEdF4tah1uRvz1MXdNR8RqqcOejhyoW3XZ+bdIAVd66EPS+sJT5JqBkfk2H?=
 =?us-ascii?Q?0bV1rgYLaJt562+hE7/dy+2+PbTYGug/PWuaR70ekqH4GI6Glm2xtSswLxe5?=
 =?us-ascii?Q?UMEEDMW+dReFSXJUOl/7yCXXrpY8NkEx09zGe+kN77M1JLPU4dAvUfe8B6/Y?=
 =?us-ascii?Q?n6LdxZSzLdhMZOET1Z01jlnzl7ewZO/CuNsfv12aYaH8fhAQoQMmhOmyj8J0?=
 =?us-ascii?Q?HoBqFi1cMxK+74JVUMIPO+GD5LFhA5bpFPm5AYKmSak6Ijcvxgbbo5PonoBn?=
 =?us-ascii?Q?/nZDrMg2/88FhCdGE/4OVc9Nk7wxkwvc/dI3RfRmEC1ZVf+ukPkaG+dOKIyV?=
 =?us-ascii?Q?D0OgqTlfPXFsjZy+5gThB8D67dqK8DAuY+idBbGCPw6Jn6V0Gz0jZZvQavFN?=
 =?us-ascii?Q?bqFxPsY48XyDCcp8RnP8zg5dA99Tgj7VZpJHVFMpzG/EeI36phk3KZke8WIe?=
 =?us-ascii?Q?HDz0cKGxvcbQKq7xt+PG/b7aedK4zIIVCxgY/jwm4Ql7zq7oA1zLhzeCoIjd?=
 =?us-ascii?Q?lvQ9SdrqyrTBHs/LUgNEDPaP8Gx/M5NV8z9apHBYhurmwyJ46gMosXlXFmZW?=
 =?us-ascii?Q?djMJiXidSkLX7NuDVbsBnOvyfrZGMFF3Q46W47uxnBQ5PggmI9VtP6Y/0Of6?=
 =?us-ascii?Q?lkM0u4FL94Y62G2aM2MW2ZaLAl6fFt8ceKxppAZkWCE6xOHXUCYcJ5boON0j?=
 =?us-ascii?Q?1tAfm7hg4qwdaD0O2isUUEPu2xIIWcNLACOzKSRCo4WBQ6wdB/FZhpr/3FHa?=
 =?us-ascii?Q?/J22kIaJ33SGJsUpcH4sJbA8hE6QEoasxxkMn2dvI0Q6++nlo4hx91B5YkzQ?=
 =?us-ascii?Q?DSw9zzzsYwqSvAh4bN5+TBsr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769d9387-8c4a-4d26-3a8c-08d8eee6f596
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:00.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRFz+srWdYmcp4RZIm7z4aCxUY3Pv+/JB48Dx9s9xvX6ZaXj6adSQk8Lmu/1Z7nEIvJheAH4duDcT0jQb7UpJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The behavior of the SEV-legacy commands is altered when the SNP firmware
is in the INIT state. When SNP is in INIT state, all the SEV-legacy
commands that cause the firmware to write to memory must be in the
firmware state before issuing the command..

See SEV-SNP spec section 5.3.7 for more detail.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 90 +++++++++++++++++++++++++++++++++---
 drivers/crypto/ccp/sev-dev.h |  1 +
 2 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 242c4775eb56..4aa9d4505d71 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -148,12 +148,35 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
+static bool sev_legacy_cmd_buf_writable(int cmd)
+{
+	switch (cmd) {
+	case SEV_CMD_PLATFORM_STATUS:
+	case SEV_CMD_GUEST_STATUS:
+	case SEV_CMD_LAUNCH_START:
+	case SEV_CMD_RECEIVE_START:
+	case SEV_CMD_LAUNCH_MEASURE:
+	case SEV_CMD_SEND_START:
+	case SEV_CMD_SEND_UPDATE_DATA:
+	case SEV_CMD_SEND_UPDATE_VMSA:
+	case SEV_CMD_PEK_CSR:
+	case SEV_CMD_PDH_CERT_EXPORT:
+	case SEV_CMD_GET_ID:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
+	size_t cmd_buf_len = sev_cmd_buffer_len(cmd);
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
 	unsigned int phys_lsb, phys_msb;
 	unsigned int reg, ret = 0;
+	struct page *cmd_page = NULL;
+	struct rmpupdate e = {};
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
@@ -163,15 +186,47 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	sev = psp->sev_data;
 
+	/*
+	 * Check If SNP is initialized and we are asked to execute a legacy
+	 * command that requires write by the firmware in the command buffer.
+	 * In that case use an intermediate command buffer page to complete the
+	 * operation.
+	 *
+	 * NOTE: If the command buffer contains a pointer which will be modified
+	 * by the firmware then caller must take care of it.
+	 */
+	if (sev->snp_inited && sev_legacy_cmd_buf_writable(cmd)) {
+		cmd_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!cmd_page)
+			return -ENOMEM;
+
+		memcpy(page_address(cmd_page), data, cmd_buf_len);
+
+		/* make it as a firmware page */
+		e.immutable = true;
+		e.assigned = true;
+		ret = rmptable_rmpupdate(cmd_page, &e);
+		if (ret) {
+			dev_err(sev->dev, "sev cmd id %#x, failed to change to firmware state (spa 0x%lx ret %d).\n",
+				cmd, page_to_pfn(cmd_page) << PAGE_SHIFT, ret);
+			goto e_free;
+		}
+	}
+
 	/* Get the physical address of the command buffer */
-	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
-	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
+	if (cmd_page) {
+		phys_lsb = data ? lower_32_bits(__sme_page_pa(cmd_page)) : 0;
+		phys_msb = data ? upper_32_bits(__sme_page_pa(cmd_page)) : 0;
+	} else {
+		phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
+		phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
+	}
 
 	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
 		cmd, phys_msb, phys_lsb, psp_timeout);
 
 	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			     sev_cmd_buffer_len(cmd), false);
+			     cmd_buf_len, false);
 
 	iowrite32(phys_lsb, sev->io_regs + sev->vdata->cmdbuff_addr_lo_reg);
 	iowrite32(phys_msb, sev->io_regs + sev->vdata->cmdbuff_addr_hi_reg);
@@ -185,6 +240,24 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	/* wait for command completion */
 	ret = sev_wait_cmd_ioc(sev, &reg, psp_timeout);
+
+	/* if an intermediate page is used then copy the data back to original. */
+	if (cmd_page) {
+		int rc;
+
+		/* make it as a hypervisor page */
+		memset(&e, 0, sizeof(struct rmpupdate));
+		rc = rmptable_rmpupdate(cmd_page, &e);
+		if (rc) {
+			dev_err(sev->dev, "sev cmd id %#x, failed to change to hypervisor state ret=%d.\n",
+				cmd, rc);
+			/* Set the command page to NULL so that the page is leaked. */
+			cmd_page = NULL;
+		} else {
+			memcpy(data, page_address(cmd_page), cmd_buf_len);
+		}
+	}
+
 	if (ret) {
 		if (psp_ret)
 			*psp_ret = 0;
@@ -192,7 +265,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 		dev_err(sev->dev, "sev command %#x timed out, disabling PSP\n", cmd);
 		psp_dead = true;
 
-		return ret;
+		goto e_free;
 	}
 
 	psp_timeout = psp_cmd_timeout;
@@ -207,8 +280,11 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	}
 
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			     sev_cmd_buffer_len(cmd), false);
+			     cmd_buf_len, false);
 
+e_free:
+	if (cmd_page)
+		__free_page(cmd_page);
 	return ret;
 }
 
@@ -234,7 +310,7 @@ static int __sev_platform_init_locked(int *error)
 
 	sev = psp->sev_data;
 
-	if (sev->state == SEV_STATE_INIT)
+	if (sev->legacy_inited && (sev->state == SEV_STATE_INIT))
 		return 0;
 
 	if (sev_es_tmr) {
@@ -255,6 +331,7 @@ static int __sev_platform_init_locked(int *error)
 	if (rc)
 		return rc;
 
+	sev->legacy_inited = true;
 	sev->state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
@@ -289,6 +366,7 @@ static int __sev_platform_shutdown_locked(int *error)
 	if (ret)
 		return ret;
 
+	sev->legacy_inited = false;
 	sev->state = SEV_STATE_UNINIT;
 	dev_dbg(sev->dev, "SEV firmware shutdown\n");
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 18b116a817ff..2ee9665a901d 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -54,6 +54,7 @@ struct sev_device {
 	u8 build;
 
 	bool snp_inited;
+	bool legacy_inited;
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.17.1

