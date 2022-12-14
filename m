Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9153D64D07C
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiLNT70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiLNT5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:57:47 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858B02E6AF;
        Wed, 14 Dec 2022 11:54:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2PdguFxVzo3NQMZEf6bc7xhUpuvwxv5MqckWRb086YJ4mTYD77pIXz2+s+RPgeTcFbBt9ybU39a9TS8tD7lGYm3X0uv8HVaB5+I8Gfy4H9zgc8LM7sX41qVeHqG2SvYsX/J5o1Ihd9d9KxHG/79A8Ix/ghL8IIR3eO9Li4BUIsr3VoUIkAR/IqqgraoiLVAwbA1mOTYsZpAMy8lpohsPfG+ZBxQhmYHXMukqGL8qm1B7FbQq5k1CbtvQ6kbBZzjt92dalSRAW60maKj0AROlmjPTU+UaWLepy2eJCOkw+0jrQgZJMKmAJ3BFgQ0exo8Tjy48z+z3LewbXEioWu24A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElAldfZLGPcU/rNHWtctMMov4dLZSL+ESPt383t1qiY=;
 b=l42UQo5NWB3ZZOiLBc+5FjF/piY9OsORngEjpFUgCxgpcybkUQ7sg21iBrHHLhHd6CaPkyknwUo3xfOozst0G8zjITTSqu5gxQZSe2az7wf3kM1U3ZrtxNviJUMZAJGaFBnW6cDMyusDdpFt3wUX/kDuqhDIQrY6nkBLeh1ijphKGu7vlCNTaGPUQfVnLKr5gFVr7+fLTy3TiC0dYxGbzf/bXz92QL6/gdaXHUolEliBbD7/VfzWEucf5c1OenxkR/qBWiznoN971DMgsjnS6E1t97FTmK1fchzTEvuwOlxyvTCosh0PGJUw+aZ4511NWDu47/+vCLLBYJlu/iyP5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElAldfZLGPcU/rNHWtctMMov4dLZSL+ESPt383t1qiY=;
 b=LKuauPaUAW+0jpL0M/N+m5MWUYLoOFYuYeQ5CPvJXbkkRrBzyyMsHfee1Unu26bNdw9IXJE+FDenAGcHJckACGqbrxcjUJNZxBKNYOsj/ICiQkZSbMnfLeKjYNYW7gsSRx0NS3gVfv8slsJbzGff1ejh6itvMcUM55RwHVitG9k=
Received: from MW4PR03CA0232.namprd03.prod.outlook.com (2603:10b6:303:b9::27)
 by CY5PR12MB6455.namprd12.prod.outlook.com (2603:10b6:930:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:54:27 +0000
Received: from CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::e5) by MW4PR03CA0232.outlook.office365.com
 (2603:10b6:303:b9::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:54:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT110.mail.protection.outlook.com (10.13.175.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:54:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:54:25 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 29/64] crypto: ccp: Handle the legacy SEV command when SNP is enabled
Date:   Wed, 14 Dec 2022 13:40:21 -0600
Message-ID: <20221214194056.161492-30-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT110:EE_|CY5PR12MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: 113efb0f-d98d-4f5c-7a21-08dade0d01cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SdM7ErY81ZD54rCfIEVC5FlQE+BIa7re3KmA3c+8Qf7IF5/YliC6ItOlEh5WLdZHHf31JvTqOCulVfZEwidvG4l6P5mKQyLMddsGA1v/flKatmNqUxbiLl8uGMKvWVngjoJlI2GbUwOFoNRoZwlsSxKQKjNc1qwc9n1xQy+R3DqPOJZ7A5Y9h5gjWmMNiHMnQYakL2h2WAvuYNffXt3BC+8sHYWs//mGSL+oa5QTCSEZU2weI6Gv4QVuuy9ktSNYfhX5p+4tORHPeBI1Kkgt2AR3fRdH8Hcs+jlFDr1Cu2fZGmQezJIPsT978pU5GCpBpPiq4QSuSB/nucPmzlgBTijHjzjPHRvAH51+J84ROxGi4IzmH4axkizQ6EV/FM9cX140tJg2AUDpaD8tVFlZo7QdeiAtb3HogjkFp0DVoW5iSb+AVUXJf+ulkycmXTfMUewOSXNClGrrgK1yzx6tbWlp3aLOK0lhJWyzW4sN+/CRXfCK9JUlmFov8MctAt0n5eIq10YuH3NMmB72Gj5C0dkutBXgjJ0nwkEOulqGdEko5hi908tXP6cCns1o1GGN/hRKLElvIjwFW6YLcK2Z0E2ju8/QFeYSQwK/TZ3Na+8UOD/FLeqe+7l3Hms6PI3EL41lXTUgUg8DnDWmeTJ5CA2/WvYCygnq1+I1NxEZqCpfeyisCXMaomQTwIDuy0vMY2ILoB2jpUPYKOHRkBHm3K7sw793GKUmp2kSAmWmCoo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199015)(36840700001)(46966006)(40470700004)(2906002)(82310400005)(2616005)(1076003)(6666004)(36756003)(47076005)(316002)(26005)(6916009)(7406005)(40480700001)(478600001)(7416002)(16526019)(8936002)(83380400001)(70206006)(54906003)(336012)(186003)(426003)(70586007)(8676002)(40460700003)(4326008)(5660300002)(41300700001)(81166007)(86362001)(30864003)(356005)(44832011)(82740400003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:54:27.1059
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 113efb0f-d98d-4f5c-7a21-08dade0d01cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6455
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The behavior of the SEV-legacy commands is altered when the SNP firmware
is in the INIT state. When SNP is in INIT state, all the SEV-legacy
commands that cause the firmware to write to memory must be in the
firmware state before issuing the command..

A command buffer may contains a system physical address that the firmware
may write to. There are two cases that need to be handled:

1) system physical address points to a guest memory
2) system physical address points to a host memory

To handle the case #1, change the page state to the firmware in the RMP
table before issuing the command and restore the state to shared after the
command completes.

For the case #2, use a bounce buffer to complete the request.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 370 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |  12 ++
 2 files changed, 372 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 4c12e98a1219..5eb2e8f364d4 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -286,6 +286,30 @@ static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, boo
 	return rc;
 }
 
+static int rmp_mark_pages_shared(unsigned long paddr, unsigned int npages)
+{
+	/* Cbit maybe set in the paddr */
+	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
+	int rc, n = 0, i;
+
+	for (i = 0; i < npages; i++, pfn++, n++) {
+		rc = rmp_make_shared(pfn, PG_LEVEL_4K);
+		if (rc)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	/*
+	 * If failed to change the page state to shared, then its not safe
+	 * to release the page back to the system, leak it.
+	 */
+	snp_mark_pages_offline(pfn, npages - n);
+
+	return rc;
+}
+
 static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
 {
 	unsigned long npages = 1ul << order, paddr;
@@ -487,12 +511,295 @@ static int sev_write_init_ex_file_if_required(int cmd_id)
 	return sev_write_init_ex_file();
 }
 
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
+		page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(SEV_FW_BLOB_MAX_SIZE));
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
+			__free_pages(virt_to_page(map->host), get_order(SEV_FW_BLOB_MAX_SIZE));
+			memset(map, 0, sizeof(*map));
+		}
+	}
+}
+
+static int map_firmware_writeable(u64 *paddr, u32 len, bool guest, struct snp_host_map *map)
+{
+	unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
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
+		if (rmp_mark_pages_firmware(*paddr, npages, true))
+			return -EFAULT;
+
+		goto done;
+	}
+
+	if (!map->host)
+		return -ENOMEM;
+
+	/* Check if the pre-allocated buffer can be used to fullfil the request. */
+	if (len > SEV_FW_BLOB_MAX_SIZE)
+		return -EINVAL;
+
+	/* Transition the pre-allocated buffer to the firmware state. */
+	if (rmp_mark_pages_firmware(__pa(map->host), npages, true))
+		return -EFAULT;
+
+	/* Set the paddr to use pre-allocated firmware buffer */
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
+
+	if (!map->active)
+		return 0;
+
+	/* If paddr points to a guest memory then restore the page state to hypervisor. */
+	if (guest) {
+		if (snp_reclaim_pages(*paddr, npages, true))
+			return -EFAULT;
+
+		goto done;
+	}
+
+	/*
+	 * Transition the pre-allocated buffer to hypervisor state before the access.
+	 *
+	 * This is because while changing the page state to firmware, the kernel unmaps
+	 * the pages from the direct map, and to restore the direct map the pages must
+	 * be transitioned back to the shared state.
+	 */
+	if (snp_reclaim_pages(__pa(map->host), npages, true))
+		return -EFAULT;
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
+#define prep_buffer(name, addr, len, guest, map) \
+	func(&((typeof(name *))cmd_buf)->addr, ((typeof(name *))cmd_buf)->len, guest, map)
+
+static int __snp_cmd_buf_copy(int cmd, void *cmd_buf, bool to_fw, int fw_err)
+{
+	int (*func)(u64 *paddr, u32 len, bool guest, struct snp_host_map *map);
+	struct sev_device *sev = psp_master->sev_data;
+	bool from_fw = !to_fw;
+
+	/*
+	 * After the command is completed, change the command buffer memory to
+	 * hypervisor state.
+	 *
+	 * The immutable bit is automatically cleared by the firmware, so
+	 * no not need to reclaim the page.
+	 */
+	if (from_fw && sev_legacy_cmd_buf_writable(cmd)) {
+		if (rmp_mark_pages_shared(__pa(cmd_buf), 1))
+			return -EFAULT;
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
+				false, &sev->snp_host_map[0]))
+			goto err;
+		break;
+	case SEV_CMD_LAUNCH_UPDATE_DATA:
+		if (prep_buffer(struct sev_data_launch_update_data, address, len,
+				true, &sev->snp_host_map[0]))
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
+		if (rmp_mark_pages_firmware(__pa(cmd_buf), 1, true))
+			return -EFAULT;
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
+	return ((cmd < SEV_CMD_SNP_INIT) && sev->snp_initialized) ? true : false;
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
@@ -512,12 +819,28 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
 	 * physically contiguous.
 	 */
-	if (data)
-		memcpy(sev->cmd_buf, data, buf_len);
+	if (data) {
+		if (sev->cmd_buf_active > 2)
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
+	} else {
+		cmd_buf = sev->cmd_buf;
+	}
 
 	/* Get the physical address of the command buffer */
-	phys_lsb = data ? lower_32_bits(__psp_pa(sev->cmd_buf)) : 0;
-	phys_msb = data ? upper_32_bits(__psp_pa(sev->cmd_buf)) : 0;
+	phys_lsb = data ? lower_32_bits(__psp_pa(cmd_buf)) : 0;
+	phys_msb = data ? upper_32_bits(__psp_pa(cmd_buf)) : 0;
 
 	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
 		cmd, phys_msb, phys_lsb, psp_timeout);
@@ -560,15 +883,24 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 		ret = sev_write_init_ex_file_if_required(cmd);
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
@@ -1579,10 +1911,12 @@ int sev_dev_init(struct psp_device *psp)
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
@@ -1648,6 +1982,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 		snp_range_list = NULL;
 	}
 
+	/*
+	 * The host map need to clear the immutable bit so it must be free'd before the
+	 * SNP firmware shutdown.
+	 */
+	free_snp_host_map(sev);
+
 	sev_snp_shutdown(&error);
 }
 
@@ -1722,6 +2062,14 @@ void sev_pci_init(void)
 				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
 			}
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
@@ -1739,12 +2087,14 @@ void sev_pci_init(void)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			error, rc);
 
+skip_legacy:
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
 	return;
 
 err:
+	free_snp_host_map(sev);
 	psp_master->sev_data = NULL;
 }
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 34767657beb5..19d79f9d4212 100644
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
 
 	bool snp_initialized;
+	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.25.1

