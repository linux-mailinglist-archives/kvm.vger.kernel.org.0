Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DB9398C56
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhFBORf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:17:35 -0400
Received: from mail-bn8nam11on2088.outbound.protection.outlook.com ([40.107.236.88]:32416
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229762AbhFBOP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:15:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrM/kOYUDZ0XvALZIodZI8oLynEdwRrVcyC+WtJNj2MIjWlYqVTPNKQTmoNk2U0DXjoWE2tF3mHLZMcXgXiEiTx7SEOIdt/VTul3WIoGLmDXiOUqL7fXYRcmZu08Gykt/QyUYIoZ2+APycH4olDdWjk/XEi9vHli6aUX9NqsxE6fagwTi6Ivyr+EJexB1kcTv7/B5HPSF6Tw4NxhvqipP4lSDOhCK7hV/5MUtaV2uYNLTpgMXKA+9VBngrCJjRvvSgvSwf8Pt16onxn2P29erTEUZt7yuKfdYxVUKPRv4ZMlVkt8j67sk+oe9Th6w2ZtxeAoexu3fu8AGs6TCD/O6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4/a7g6CsJ5AEPBd2g0WE1mD86STTW1l6r7T2FpRne4=;
 b=nFnOlbAnvcOteE6LvKP4fElFsSNZBgacJjsf6BTmcqQwd0gp6rPjd0UXj4bJ2/1fFs2nWAdkTHZTFjM/9MdytRyG8nMX5r/RP5M5/dQrm3t/OTDohK1WJY6ytm1aEyEDcNJmrwyJgwL/UO3SE5AQrrZaptaqpviyUwqpbYjSIf15hMzX6v/21ZnBJpkTqUr/GJ1ntlVuVutV3BJxwaxUW21Hj9KI1PKLehooOFOmca6KZ5EgimsRvqlX7e1imWE/O+vndELF0Qo2d9Q7MOKGisVOk3RiDL5eqUiA3UsrKuoipcQO9hBECL1085Ha9+/94rIIwQGAwp69E8ukZoglfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4/a7g6CsJ5AEPBd2g0WE1mD86STTW1l6r7T2FpRne4=;
 b=Ch4lArar0/NGFQOu+YiaYwe6HEtl7YQvj4uP/0Dfy5PaqP2sQDgdLlZdQHxDjyymtg6mlsAdrdCTI137KH4BndJmrDeru6GATNJg97jIecsm7+wLLgPoXu//BzobpINTV9bLUTLGzgTTlDBzcC5fkYvFCVaXkkPK/a7tNtIUxRo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:48 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:48 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 16/37] crypto: ccp: Handle the legacy SEV command when SNP is enabled
Date:   Wed,  2 Jun 2021 09:10:36 -0500
Message-Id: <20210602141057.27107-17-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5c2487b-3e8a-4e6c-dedf-08d925d05c4d
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23683132F7F0C3012DF4F88BE53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjiH7v6f9ql0TVy3l/BWVdOm8+6uwmAUwZIOea1BS+toqHagxEAezciLSGthiJCPRENhqls/UIvjaZfr0UPXeN6/gldAxR6/56bIgwV7dvsbsT+P84uAdvLe6sCUJC5Wr6lxGIOqun3tfHm+CKsx/mgC0f+mcXuXNxwZF4CG+xehc/JfzjkFl3a+GlTuxdOsOKCGueGgdWpUU+2w5W5tiLSJbtU+VmZHhzurC6kSTeItfO82M50BCSoLRfcHHxuM9xFJL2WODSAd//c3ZEHKvTCsvl6PASmBS30VucIg8ryFQNbcA2y+LD1ASUFV5j3zrg5bVnM1Tvjtrl/16lusF4HNNpnW/b/Qyl2++M8VWmla1iWlz6HOUxLYNoOVLl1BcZ0KVN6CmCdqdVLAyyQJWiZT+KbkmRhMi6wG7imMhi9ZGxopfV+i2Nwt+O/e8Hoz2MJ3lELEVU1CMFrEZzQVniWzaI9NtBWuygPXK1oDCcwGY+MkEX4SoGHKpwLq/xSTlmoXaMN2LEi+DIK4ug/Q0Ku2+hEBHzk5TZZPYoh8dnd+Vhx6lEALIsIx8qZ80UGEVZYKdHlaLi8BBWpH03nOdOaPC9AlAPERZ1/W8LQGCStx03oVFVPuHHfopvOUUxjKRJa89o6FQB8HgHalW2Ioog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(30864003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TJcHCSA3gV+d9wG5XeeQKYtx2bjDw6/9dt8c+IfzH5ALYAqBTyjG5sSXpOg6?=
 =?us-ascii?Q?o91B6fYIDJbRhhCPurJABSQSkq1Gl83vkEsQS7djRcwldXg/a7+VNRc9Pix/?=
 =?us-ascii?Q?ucNmrfxQGXocOQpEiomZw347Vyo2D3krKKlOB/2VMd8XxA/zEQ60VWAfQOFd?=
 =?us-ascii?Q?xqa5ifDh2DTqXdq8qI+yDehChsI6iDLFpbZ+Kh3DMacMNPB15MA0zh16cd/f?=
 =?us-ascii?Q?xBBSAq6Bg/9FmforIzOZvc1Ls/84fFmKhPd/G86vGkxHUmztdnWmp0Cun1z1?=
 =?us-ascii?Q?dmvuM4kWqy43aQC+WmYqX21T8plGwFZjqgQ95ZDRICRmq9mesCyWDT1v9d9+?=
 =?us-ascii?Q?JbkfCD1o75Sd8QS0wAqybx1dCDG4WRUmu9G0+Qqk94ObdDSIy+iJ+ggKAMk0?=
 =?us-ascii?Q?BH6pYtaTEh7wt7wVhrpviOhgAs7XHzJuIuKEjCOdhezcijthQH55QHjkItjw?=
 =?us-ascii?Q?iURpv4VidD1H3uYPo3JODgEUsYm+qPHezeHPmQqhb7z+DqUlsMRg+f2Zl3sD?=
 =?us-ascii?Q?LC4YAaL/UDO9OUzZTYQJ3DdfXPdtvx2mkrZL+qMx2cOFbTDVezXMsRJtvQAZ?=
 =?us-ascii?Q?LhAWbgFTZhCBb9JbwV7nAttGMwkpwBxX+5GcaqZHeXg4ZHBLnvPMMVI/5Dlc?=
 =?us-ascii?Q?1U+ftKWTc/q9gR6EPmUCwTixAOK0bH4MIvoPFR09rBV27Y0s3Js6lZ2vwqKC?=
 =?us-ascii?Q?DJunLpVfcWUSOLy2uHTHwxn/R5d4E/yGSBWGXe6COdCSGQO8+TIUs6NhbvnH?=
 =?us-ascii?Q?9HSGltxwWEfLXm34bgfUS/v3UNNzaMm/p6rZlazgbyiSWEmVRqTuvEnakg+a?=
 =?us-ascii?Q?tWrdnzoyhi3ctTBG4MOW6xUjwVBAEzVYbMiSzWoqBs6z0CbSWrUXKUtfcBgS?=
 =?us-ascii?Q?x3yTAzZGGMywpXGJ9cdXp/rvfeqy+FQS85OhuMTlGXcsUdC8wC5p1Onn0i8j?=
 =?us-ascii?Q?oMne975BlAlfvm14q02sORPvrG/N0IoyKAs0ZANCLLBVMDhIUpJgMZsKzfaN?=
 =?us-ascii?Q?uHVFQvAyUVGPUCESTw9W5ao6dZp/bApAE8fDd12Mv8hrpFqp92YNU7AfTDC0?=
 =?us-ascii?Q?Km68embKhy4swCvYpmh/JUHBP8/vBl2AFFP7NP44GchOg4Il94WLPClFD4fH?=
 =?us-ascii?Q?ROLMKTQ2mZUGlQYu3bQPcmOKnUiBphJjp/DVD6PnvJULrBnfnyB23RevebER?=
 =?us-ascii?Q?MwmwEFDDWM5VMm94sD9bvlK2XeeuDN0YDQTDTK5fvVcokmuneym54NKy2ryc?=
 =?us-ascii?Q?m6Xc3pcAPd7EPoIKLa+bUoNROspsHW/86mBtJbzaV8st34YnU6Iv1kSw0Yw7?=
 =?us-ascii?Q?Rir5tKUAZ937c2m4DBuaPhRl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c2487b-3e8a-4e6c-dedf-08d925d05c4d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:48.3547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZgAVMh1VDDh4v5PNy1J19e8rHj3U/LqNBUk421DmDI9WY0IURVhQBiiq3c9B1ZCEmgIw9pH4KvT44FCCEyz5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
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
index cbf77cbf1887..c886d76ae31d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -265,12 +265,299 @@ void snp_free_firmware_page(void *addr)
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
+	int (*func)(u64 *paddr, u32 len, bool guest, struct snp_host_map *map);
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
@@ -290,12 +577,26 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
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
@@ -336,15 +637,24 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
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
@@ -1216,10 +1526,12 @@ int sev_dev_init(struct psp_device *psp)
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
@@ -1271,6 +1583,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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
 
@@ -1330,6 +1648,14 @@ void sev_pci_init(void)
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
@@ -1359,12 +1685,14 @@ void sev_pci_init(void)
 	if (rc)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
 
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

