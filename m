Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C74C36FAA6
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhD3MmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:42:06 -0400
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:34272
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233085AbhD3Mk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DL9d199ob8NAx46a7G/qrSNK9OmVeH+FeCc7ECuKJ3JgzAGkcMzn2uf8wAd3ufL2uET5vB2QccB/PJk5bfP3VOrkNUbATkHO4STrZ5g52nTZvX7ll8Bd3/WSVvJ7bgIo/PR/HY4w0wUEDu3Jl+EHAvisGAZ3KnI986oK7GhnVy0D7oBGrRM5ms/YpULkIudxzHlhid5opSh89rFjzWuDa7M2Mx0gFTWTlqoCqefpJjxuNXzPZh1NAp3e67W/qSGKpFonnNtaFqg0ep0/dsVpJmLpxb9yRpZA7scNxHLlQvcIncKWAkcZuNhX1TTuIRJSvi5L4I8xlWg9kGUma7qvEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZE2CcOYFhZt4yJzG5OKU21ZrwkSbwJlmkaR/S3PFbA=;
 b=U5DqTnkO/7XKw/N1HSQqn5Wvec5QzCS8twRV8P0oD6bwQSMU8DSo/EMxKCFJ68UMQjmmhy0dNxDeg6Jr2DJ528WcqwWfbguRGOA1F6Llbb7sW0t6F4Z9iZQUL58IHRCAqhW3G6P282SjGtksp8XeV9Iva7PB2DdsPur0bNaZOchlKVacnSSMg759olflh2KCOge9xew7y0WNDaZphB+CWK6rRdwdPtMB6GoJFSWeLC+7AvhqqMhJq0LhAPmTb38nDm1ncMY2jQWKssjviRYn3ZEo2Ix/Wc7Mb3UxvIA6gqCiXMhT4s0bOvfnPCljVHvUwxF+m0zsk2goOmLaR7hFAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZE2CcOYFhZt4yJzG5OKU21ZrwkSbwJlmkaR/S3PFbA=;
 b=Fz+dsPClmM/l9QYC+lV1pOk9A7DmLFrrswtFMfeiW0vrG2l/yCqxNwYJmZVLxwQUiYE0Y5g93B7tewK2jE2ERde1F0bjK52GRmqFi7RgRpoGqtx4WlXuP/dOlAzML7xcWvQqlYdy7A/+EEqkTD4bkzSoCmP1PdFxUSOkWgo70Pw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:06 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:06 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 17/37] crypto: ccp: Handle the legacy SEV command when SNP is enabled
Date:   Fri, 30 Apr 2021 07:38:02 -0500
Message-Id: <20210430123822.13825-18-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d9a8cd6-ea6a-4b41-3c5c-08d90bd4f17a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28327681C414B8C48A34DB2BE55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRw+H1ZrnTj5RS9hTPqxzLAVbBDEVjZB1QBWvL0MeBNgRHF/qMwLffFxDjBMIATQuhy+qKXg6ZGrxhYjnMwYH1JJE4u2nelzLHBy2YOW+fBw78LpooYoaQqe74d9gjSJSe0/j8QxHMQvNoLQ1ZkxLDFefVqZnYzNuw2hXmpKYOWj++1s0jNbNyCJkHYeX7/xfbwQwo4wJ1SFEEfAzrApC1+xcGV0zJDgmndaMPEXmwxgMbOj6BefzhQpz6PkUn6YYHEAvHk9qBc2VU1GUwEsfzifXxqAsdzClnDr05s1ULYK4Fay/hAaqXFlXSX7/HlntjzR0WmmANAFoMkDPn2LAUqrYYvw9yfPaeJLPCPg0dC9+L3d0151jKFx9lTij4NcsFSQzL0dvhN8pjbllWlKNNxI90X+8GvsbVLaqjL2hdS7+BmLt4JPNRQye8jBdb+oE14QG1WRwDZzE/nyUjVJiWIyG0ZGGKjnDsdPJWglO/pDkkde68s+7Vk1RwIjTYOIEhsU5zF9mGQ7SXLfjUI7A3BbNQw017aUjDvroD4I92Yy/2xEJWYs8PS6PFSj5mVH4Xf+1sygh+LOA8MoYGlYDKLi4YvZN2Rm31yAKy4JTjgV7PncOSGBmbxEa1Fs3GrXqCPnAlvkObbHz46RYIsZ1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(30864003)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OSWyrs1AuaObJRA7rIn8Y6sUXvU0g+JaBZfPfTMhmvNGOsrLrWsh/Aef9vrD?=
 =?us-ascii?Q?HKN3hdubb/qmUP7fW8c2zuj9V5tay9UF/PTgl8ib3qQUAVIflPIyywBQ2KVD?=
 =?us-ascii?Q?gAZRx94RkQaFNwn7jhlBW0FvQhYfFKAZd/VsZtiGBdbnki249rJq2rMuxftK?=
 =?us-ascii?Q?cGMfBBYk9THWqZxCwp0o1GAz33aSywWijIz/T8czv1xwIA36Me/tPsOvjP4O?=
 =?us-ascii?Q?I3Nb/caqhj8YXFvoZ7pMRcQHcbobX4BKGawPQ/Vk3xOZq9Vf0LpLuTGvpXPA?=
 =?us-ascii?Q?USbmfPDdK6FF73zhzXz8xBueSKS1MiEzPe6SA8kR1jHJiXCTmDturUwErW6p?=
 =?us-ascii?Q?xgiWQ0+cNcpGt0jZc8hn3/BnsDA7ejrdM67pLuvFcBZOfcwdp0t3EAlTQXcd?=
 =?us-ascii?Q?Gdc6zJAqlIOrXjZymkXobOJDrrWtDqV9jnNGNvDEPmIcqmrypm8iCyx8yizl?=
 =?us-ascii?Q?KI5NdLiM6PWE0uJPJybKE/lsYR8QZ6AAWJmhtKZ4qdN55aZ7+lu5VFY/i0bK?=
 =?us-ascii?Q?9sLUUvSqsjGUq0I3TN3CkiIy1ycriUUAFYgQak68GHfGjmKKoOE4Bk/zxSTy?=
 =?us-ascii?Q?LiGgmoOEGT6HAPCFJJFHPXP7u6aWi6+tFYvTXXCAnRBjUW8Cxg2KX3PxU+mY?=
 =?us-ascii?Q?aOvbIY17YonhOhds79ETEs70073Bm7xMrV6ZAlFlCj7pdIC+WOffqgfsbLaZ?=
 =?us-ascii?Q?w8XZSTSsbMwzxGBa4T9o89lSv0iojz+wmAH78NRZWBVYIl7HmH0JVMuK39zn?=
 =?us-ascii?Q?z+weKGQXNypheVTGnAWnSCDbMmWtYLL4ftnRYyX7aLckcktdcCI5lyvjtU//?=
 =?us-ascii?Q?n/qmkx3Wfo2JijmnQdpvmd2oV8gDTS/K+4Iu176a+cQXS8tl/vAropBGpDUk?=
 =?us-ascii?Q?UazaK0Wrw2WbnDFlLZSjYTfd3ACmFZzIL8s2zE1A0Ks3zVBjvaFCnQtGvT3m?=
 =?us-ascii?Q?pMge8jHOVjcWkB4SWAm9UG2VsPBr1V9bBiM3RRCHA/Z+4yNzMnogqwqVgKey?=
 =?us-ascii?Q?bNL07mKZ7hL/ZjQz3igDwBH4fwDHD4r+Qq64TDeVp+Xk+/HJKZb6OnxwIBVJ?=
 =?us-ascii?Q?hGdh7Skp5se1sa5ZE+uP37c7JeZYuCFMKpPNNR/oDjX41cIPmlu2VofdO1dq?=
 =?us-ascii?Q?DfsPSlGwRBBwrLYL2Eg+nhr/bBRM6HFpZsCPbbOD1YSwj1IH6tPa0VJ1CeQT?=
 =?us-ascii?Q?ZigYPCYsmQ4L9qaxdjg5MOm1NGDjFUsVdukpck6DlwuItmIUMa9skTqZvULL?=
 =?us-ascii?Q?+g3JkuG47VFadoU0QPHTckb8fKDFWZLDmNgStN1KqKoeL4K2fYqL6WU7WR5H?=
 =?us-ascii?Q?PFjfjCJzWTHE6qaPMqF+meEz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9a8cd6-ea6a-4b41-3c5c-08d90bd4f17a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:06.3457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYfEAY4JbpgzgQRc1Wbibs2Ff09nyY6WueXaAaVVTKjsWlcGbK1kY0DsWPpo/MGzeIk5tfYVT9Q2gOCKgiauKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The behavior of the SEV-legacy commands is altered when the SNP firmware
is in the INIT state. When SNP is in INIT state, all the SEV-legacy
commands that cause the firmware to write to memory must be in the
firmware state before issuing the command..

A command buffer may contains a system physical address that the firmware
may write to. There are two cases that need to be handled:

1) system physical address points to a guest memory
2) system physical address points to a host memory

To handle the case #1, map_firmware_writeable() helper simply
changes the page state in the RMP table before and after the command is
sent to the firmware.

For the case #2, the map_firmware_writeable() replaces the host system
physical memory with a pre-allocated firmware page, and after the command
completes, the unmap_firmware_writeable() copies the content from
pre-allocated firmware page to original host system physical.

The unmap_firmware_writeable() calls a __sev_do_cmd_locked() to clear
the immutable bit from the memory page. To support the nested calling,
a separate command buffer is required. Allocate a backup command buffer
and keep reference count of it. If a nested call is detected then use the
backup cmd_buf to complete the command submission.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 348 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |  12 ++
 2 files changed, 350 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index fe104d50d83d..5b3f3f718cfb 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -252,12 +252,299 @@ void snp_free_firmware_page(void *addr)
 }
 EXPORT_SYMBOL(snp_free_firmware_page);
 
+static int alloc_snp_host_map(struct sev_device *sev)
+{
+	struct page *page;
+	int i;
+
+	for (i = 0; i < MAX_SNP_HOST_MAP_BUFS; i++) {
+		struct snp_host_map *map = &sev->snp_host_map[i];
+
+		memset(map, 0, sizeof(*map));
+
+		page = __snp_alloc_firmware_pages(GFP_KERNEL_ACCOUNT,
+						  get_order(SEV_FW_BLOB_MAX_SIZE));
+		if (!page)
+			return -ENOMEM;
+
+		map->host = page_address(page);
+	}
+
+	return 0;
+}
+
+static void free_snp_host_map(struct sev_device *sev)
+{
+	int i;
+
+	for (i = 0; i < MAX_SNP_HOST_MAP_BUFS; i++) {
+		struct snp_host_map *map = &sev->snp_host_map[i];
+
+		if (map->host) {
+			__snp_free_firmware_pages(virt_to_page(map->host),
+						  get_order(SEV_FW_BLOB_MAX_SIZE));
+			memset(map, 0, sizeof(*map));
+		}
+	}
+}
+
+static int map_firmware_writeable(u64 *paddr, u32 len, bool guest, struct snp_host_map *map)
+{
+	unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	int ret;
+
+	map->active = false;
+
+	if (!paddr || !len)
+		return 0;
+
+	map->paddr = *paddr;
+	map->len = len;
+
+	/* If paddr points to a guest memory then change the page state to firmwware. */
+	if (guest) {
+		struct rmpupdate val = {};
+
+		val.immutable = true;
+		val.assigned = true;
+		ret = snp_set_rmptable_state(*paddr, npages, &val, true, false);
+		if (ret)
+			return ret;
+
+		goto done;
+	}
+
+	if (unlikely(!map->host))
+		return -EINVAL;
+
+	/* Check if the pre-allocated buffer can be used to fullfil the request. */
+	if (unlikely(len > SEV_FW_BLOB_MAX_SIZE))
+		return -EINVAL;
+
+	/* Set the paddr to use an intermediate firmware buffer */
+	*paddr = __psp_pa(map->host);
+
+done:
+	map->active = true;
+	return 0;
+}
+
+static int unmap_firmware_writeable(u64 *paddr, u32 len, bool guest, struct snp_host_map *map)
+{
+	unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	int ret;
+
+	if (!map->active)
+		return 0;
+
+	/* If paddr points to a guest memory then restore the page state to hypervisor. */
+	if (guest) {
+		struct rmpupdate val = {};
+
+		ret = snp_set_rmptable_state(*paddr, npages, &val, true, true);
+		if (ret)
+			return ret;
+
+		goto done;
+	}
+
+	/* Copy the response data firmware buffer to the callers buffer. */
+	memcpy(__va(__sme_clr(map->paddr)), map->host, min_t(size_t, len, map->len));
+	*paddr = map->paddr;
+
+done:
+	map->active = false;
+	return 0;
+}
+
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
+	case SEV_CMD_ATTESTATION_REPORT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+#define prep_buffer(name, addr, len, guest, map)  \
+	   func(&((typeof(name *))cmd_buf)->addr, ((typeof(name *))cmd_buf)->len, guest, map)
+
+static int __snp_cmd_buf_copy(int cmd, void *cmd_buf, bool to_fw, int fw_err)
+{
+	int (*func)(u64 *, u32, bool, struct snp_host_map *);
+	struct sev_device *sev = psp_master->sev_data;
+	struct rmpupdate val = {};
+	bool from_fw = !to_fw;
+	int ret;
+
+	/*
+	 * After the command is completed, change the command buffer memory to
+	 * hypervisor state.
+	 *
+	 * The immutable bit is automatically cleared by the firmware, so
+	 * no not need to reclaim the page.
+	 */
+	if (from_fw && sev_legacy_cmd_buf_writable(cmd)) {
+		ret = snp_set_rmptable_state(__pa(cmd_buf), 1, &val, true, false);
+		if (ret)
+			return ret;
+
+		/* No need to go further if firmware failed to execute command. */
+		if (fw_err)
+			return 0;
+	}
+
+	if (to_fw)
+		func = map_firmware_writeable;
+	else
+		func = unmap_firmware_writeable;
+
+	/*
+	 * A command buffer may contains a system physical address. If the address
+	 * points to a host memory then use an intermediate firmware page otherwise
+	 * change the page state in the RMP table.
+	 */
+	switch (cmd) {
+	case SEV_CMD_PDH_CERT_EXPORT:
+		if (prep_buffer(struct sev_data_pdh_cert_export, pdh_cert_address,
+				pdh_cert_len, false, &sev->snp_host_map[0]))
+			goto err;
+		if (prep_buffer(struct sev_data_pdh_cert_export, cert_chain_address,
+				cert_chain_len, false, &sev->snp_host_map[1]))
+			goto err;
+		break;
+	case SEV_CMD_GET_ID:
+		if (prep_buffer(struct sev_data_get_id, address, len,
+				false, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_PEK_CSR:
+		if (prep_buffer(struct sev_data_pek_csr, address, len,
+				    false, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_LAUNCH_UPDATE_DATA:
+		if (prep_buffer(struct sev_data_launch_update_data, address, len,
+				    true, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_LAUNCH_UPDATE_VMSA:
+		if (prep_buffer(struct sev_data_launch_update_vmsa, address, len,
+				true, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_LAUNCH_MEASURE:
+		if (prep_buffer(struct sev_data_launch_measure, address, len,
+				false, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_LAUNCH_UPDATE_SECRET:
+		if (prep_buffer(struct sev_data_launch_secret, guest_address, guest_len,
+				true, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_DBG_DECRYPT:
+		if (prep_buffer(struct sev_data_dbg, dst_addr, len, false,
+				&sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_DBG_ENCRYPT:
+		if (prep_buffer(struct sev_data_dbg, dst_addr, len, true,
+				&sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_ATTESTATION_REPORT:
+		if (prep_buffer(struct sev_data_attestation_report, address, len,
+				false, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_SEND_START:
+		if (prep_buffer(struct sev_data_send_start, session_address,
+				session_len, false, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_SEND_UPDATE_DATA:
+		if (prep_buffer(struct sev_data_send_update_data, hdr_address, hdr_len,
+				false, &sev->snp_host_map[0]))
+			goto err;
+		if (prep_buffer(struct sev_data_send_update_data, trans_address,
+				trans_len, false, &sev->snp_host_map[1]))
+			goto err;
+		break;
+	case SEV_CMD_SEND_UPDATE_VMSA:
+		if (prep_buffer(struct sev_data_send_update_vmsa, hdr_address, hdr_len,
+				false, &sev->snp_host_map[0]))
+			goto err;
+		if (prep_buffer(struct sev_data_send_update_vmsa, trans_address,
+				trans_len, false, &sev->snp_host_map[1]))
+			goto err;
+		break;
+	case SEV_CMD_RECEIVE_UPDATE_DATA:
+		if (prep_buffer(struct sev_data_receive_update_data, guest_address,
+				guest_len, true, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_RECEIVE_UPDATE_VMSA:
+		if (prep_buffer(struct sev_data_receive_update_vmsa, guest_address,
+				guest_len, true, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	default:
+		break;
+	}
+
+	/* The command buffer need to be in the firmware state. */
+	if (to_fw && sev_legacy_cmd_buf_writable(cmd)) {
+		val.assigned = true;
+		val.immutable = true;
+		ret = snp_set_rmptable_state(__pa(cmd_buf), 1, &val, true, false);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+
+err:
+	return -EINVAL;
+}
+
+static inline bool need_firmware_copy(int cmd)
+{
+	struct sev_device *sev = psp_master->sev_data;
+
+	/* After SNP is INIT'ed, the behavior of legacy SEV command is changed. */
+	return ((cmd < SEV_CMD_SNP_INIT) && sev->snp_inited) ? true : false;
+}
+
+static int snp_aware_copy_to_firmware(int cmd, void *data)
+{
+	return __snp_cmd_buf_copy(cmd, data, true, 0);
+}
+
+static int snp_aware_copy_from_firmware(int cmd, void *data, int fw_err)
+{
+	return __snp_cmd_buf_copy(cmd, data, false, fw_err);
+}
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
 	unsigned int phys_lsb, phys_msb;
 	unsigned int reg, ret = 0;
+	void *cmd_buf;
 	int buf_len;
 
 	if (!psp || !psp->sev_data)
@@ -277,12 +564,26 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
 	 * physically contiguous.
 	 */
-	if (data)
-		memcpy(sev->cmd_buf, data, buf_len);
+	if (data) {
+		if (unlikely(sev->cmd_buf_active > 2))
+			return -EBUSY;
+
+		cmd_buf = sev->cmd_buf_active ? sev->cmd_buf_backup : sev->cmd_buf;
+
+		memcpy(cmd_buf, data, buf_len);
+		sev->cmd_buf_active++;
+
+		/*
+		 * The behavior of the SEV-legacy commands is altered when the
+		 * SNP firmware is in the INIT state.
+		 */
+		if (need_firmware_copy(cmd) && snp_aware_copy_to_firmware(cmd, sev->cmd_buf))
+			return -EFAULT;
+	}
 
 	/* Get the physical address of the command buffer */
-	phys_lsb = data ? lower_32_bits(__psp_pa(sev->cmd_buf)) : 0;
-	phys_msb = data ? upper_32_bits(__psp_pa(sev->cmd_buf)) : 0;
+	phys_lsb = data ? lower_32_bits(__psp_pa(cmd_buf)) : 0;
+	phys_msb = data ? upper_32_bits(__psp_pa(cmd_buf)) : 0;
 
 	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
 		cmd, phys_msb, phys_lsb, psp_timeout);
@@ -323,15 +624,24 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 		ret = -EIO;
 	}
 
-	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			     buf_len, false);
-
 	/*
 	 * Copy potential output from the PSP back to data.  Do this even on
 	 * failure in case the caller wants to glean something from the error.
 	 */
-	if (data)
-		memcpy(data, sev->cmd_buf, buf_len);
+	if (data) {
+		/*
+		 * Restore the page state after the command completes.
+		 */
+		if (need_firmware_copy(cmd) &&
+		    snp_aware_copy_from_firmware(cmd, cmd_buf, ret))
+			return -EFAULT;
+
+		memcpy(data, cmd_buf, buf_len);
+		sev->cmd_buf_active--;
+	}
+
+	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
+			     buf_len, false);
 
 	return ret;
 }
@@ -1195,10 +1505,12 @@ int sev_dev_init(struct psp_device *psp)
 	if (!sev)
 		goto e_err;
 
-	sev->cmd_buf = (void *)devm_get_free_pages(dev, GFP_KERNEL, 0);
+	sev->cmd_buf = (void *)devm_get_free_pages(dev, GFP_KERNEL, 1);
 	if (!sev->cmd_buf)
 		goto e_sev;
 
+	sev->cmd_buf_backup = (uint8_t *)sev->cmd_buf + PAGE_SIZE;
+
 	psp->sev_data = sev;
 
 	sev->dev = dev;
@@ -1250,6 +1562,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		sev_es_tmr = NULL;
 	}
 
+	/*
+	 * The host map need to clear the immutable bit so it must be free'd before the
+	 * SNP firmware shutdown.
+	 */
+	free_snp_host_map(sev);
+
 	sev_snp_shutdown(NULL);
 }
 
@@ -1309,6 +1627,14 @@ void sev_pci_init(void)
 			 */
 			dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
 		}
+
+		/*
+		 * Allocate the intermediate buffers used for the legacy command handling.
+		 */
+		if (alloc_snp_host_map(sev)) {
+			dev_notice(sev->dev, "Failed to alloc host map (disabling legacy SEV)\n");
+			goto skip_legacy;
+		}
 	}
 
 	/* Obtain the TMR memory area for SEV-ES use */
@@ -1340,12 +1666,14 @@ void sev_pci_init(void)
 		return;
 	}
 
+skip_legacy:
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_inited ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
 	return;
 
 err:
+	free_snp_host_map(sev);
 	psp_master->sev_data = NULL;
 }
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 186ad20cbd24..fe5d7a3ebace 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -29,11 +29,20 @@
 #define SEV_CMDRESP_CMD_SHIFT		16
 #define SEV_CMDRESP_IOC			BIT(0)
 
+#define MAX_SNP_HOST_MAP_BUFS		2
+
 struct sev_misc_dev {
 	struct kref refcount;
 	struct miscdevice misc;
 };
 
+struct snp_host_map {
+	u64 paddr;
+	u32 len;
+	void *host;
+	bool active;
+};
+
 struct sev_device {
 	struct device *dev;
 	struct psp_device *psp;
@@ -52,8 +61,11 @@ struct sev_device {
 	u8 build;
 
 	void *cmd_buf;
+	void *cmd_buf_backup;
+	int cmd_buf_active;
 
 	bool snp_inited;
+	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.17.1

