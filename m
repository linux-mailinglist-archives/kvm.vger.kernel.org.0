Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4173F308C
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhHTQBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:37 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:20576
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241462AbhHTQBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRqgvuHrzEtR7+9c/qeHA4d14QnAvoM7qzeZByMfyZZiUwyIgN/fXgej35I2sPZ7iaC8Gy/4toSExgvEcBf9DRKvbiFk26vdfTOyecxyL6BBJeGL2rK4D3rFcIjb86U9Ykk/jErewkrWvPmxUhDyXdXPFd00iXo4v4d+xEBbDhmuPcqwFltCzQC0p6LR1ABkQKxavqhq2nDrbKi5on7q9Cjc78ANm7ZuVV19yx9buB0UQy9sum7UEnm7++tH5qcqRTK4Mp4f0DJf7m8O8VcmtSK7yZAclsJQUueIUz8cfMs/r9T+7mePOX/kFXJWznHla67aWMcv+1yv+fs8/j5xKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfgv3CKnF22LFRG+HYod/AUmZAue0aT/1a/kHGMOP/s=;
 b=n4Te3Z7PqV9PTqf6ecDDjnDFc0Z2WIs3cPr1WRN2FMXQsTC75Jp/uqZ31+nju+dHG8T+pXGhlKxktU8U98SfYvhuewLGlaglR9vlcMhqgiapT+ieXhJGq6989OgZcA6j6hojaQT9OZWDxxyzNwB0EKY0tVE3smtDTDM6o2JjjVLM3l7tHfd58y60HgwDIhFVXeLKMQKXoCYHef2fIjaRMwUe568LpW9Mamx4IvkhTB4LHTujsGoF6uBx4D2mPrvO/WNc+f7dquNvyN1pe1jD11TM/gG1soCLERV71yu3ntVWsegzQMWb3RlrXUx4Oq4edmjA+SZjKdnizZFYwCDXSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfgv3CKnF22LFRG+HYod/AUmZAue0aT/1a/kHGMOP/s=;
 b=cl6sUMib9T6CLU+b+8I7bjJZVis/VyusR5C1QhjNc9bJc4uTD1L9nnpV01fxunHn+wnRyaACsL8XBEQkUDq9yr1ntJvrouf4Mlf5ltpdx+ApCPwfch872fGd62Ig5ZCZFAUjGTMQ8pxyBO604nQ+bRBpWsjAewYFOZnD4qItWCI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:13 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:13 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 15/45] crypto: ccp: Handle the legacy SEV command when SNP is enabled
Date:   Fri, 20 Aug 2021 10:58:48 -0500
Message-Id: <20210820155918.7518-16-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3efcc56-24c8-4585-1c55-08d963f3980d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268568F654C1385B990518B6E5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sprdmUCy4CoPA5V4jriMCmNNPPksJTD7UkmD2SKeE3rr+O5oS+y3teEmFBz5XndOgsqSDX7GWBGR9aTGwB+2gl1jdb5BM2FwV5Tv+d8hoyreagTdj1c1EaSyCYsgx/oxN7tXmXwKkIBVide8zZV5zVNF7xjEGLtxz19mzYfwUTDyxvddnnB6cIGeVoeVVEKbWnXCcJ86xhy1Rwh9wlZ4MMzGOhCQa14z5XXSW5fBb2h5R3okqnO0herIrSvurziRxZiQxt78J0rCyDPTlNpUlsiE7IkOWhZ7Xt0HvUhrky4p7oTgY2RSgLKGxtscsuYK9ybynOEFcLlEqtnpyB3w4AsqBm5/RS2puA+zZMGjG0nUSd0CXBX0L4vgo4brZpyyIgO66niKfO7IMV2PbLKJZEtzHnylXNDNEi3L+5vkUfq6grLgu+MhdB3oZb6ePheG6y2CP99a0Br/x6iAjjLb0zARxgzMbFrjbwtO30FI4DVIE/fMt/do7j/dFE/1DeOXvqGnCVpm3ZfWSWBAHJPc+VHKmYllUpVYLJ9Zinc5XkjznXkzVCGeVfH1lCU2AJ3ixzhhgGddU0DTcGOBIVUKXMM/YwTHXnTCaSHIbZMLgh8+NlEV1SMAPdj8nvGgCrlin3kRitYxM1o92dJmmeeJlzSbuyIHsKdRTxjuPSu3+4hUG6Y8ZYzYBWEIrc91cVQyXACAZ9Fe6XSxU1f0Kbc13A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(83380400001)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(30864003)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sg8W4tvWMAV5yg0/ehaTSK1chWvq1681el0B250sLOaFKUuLHcYuOAomJiU4?=
 =?us-ascii?Q?FTHnmMdl196V03pEbHMv3pPByirN34IIMkqkkDFsadnw0rFxuGAfiag4mg47?=
 =?us-ascii?Q?gb4SHd19Ae0p9F3xRXnTd98gP74vT8Gzs5GnjZjSM1GaUKqgflWKwn1Pw/Xc?=
 =?us-ascii?Q?rFfcfB29jQP+TkQExqe2V4+UzWJPvnTStAX8nR3f0H3JHnlytv9TDEysxzFT?=
 =?us-ascii?Q?erz+TImvlJMmU0Dlpb6NkV07nlSyWIZLoLvpH17QjSvL/ZBcHqyu7yF3yxCe?=
 =?us-ascii?Q?v0jtwfUlA+OevBTktWBHHpTu/HKuRLHtE+IN0XbAPhKfJNky90+wyKlVz21g?=
 =?us-ascii?Q?JCQJFeENW8Y9envRTzAc/cEX6vobH4RUfKU0J0WTZt5a69uRbgecBm4gNOP1?=
 =?us-ascii?Q?CltIviPjvbZqYPfOjje6zDsfeEB9OCnn6nPIwlxKZ72RDQoOJ/xP6fQgA3Jt?=
 =?us-ascii?Q?mvvnlOb8IKpajbIqd2Gju0MZU6iYlgTe16Jwlox+5xIZ/RKcUa2uDwZaydU3?=
 =?us-ascii?Q?knmSFxlqKejhnCI85mFBh6Ww4YHvRMz8In9r+dTORoDwR5leU/EnM/9pPKQI?=
 =?us-ascii?Q?iWKgeYOvg8j2LD9IjigOGvw2DdSxsDL2FZiCNm7WOrhECgjT/Yo5rJ2TUWIr?=
 =?us-ascii?Q?FmqaNQlppeoINe4tutvh/9KBjZAAPP84YjhRKmirOb0rb2ny2iFIo07M6nSn?=
 =?us-ascii?Q?83wZv3cIVd3byj30lPZ7KtHDJPEgPhl7jIKf0/oj7x4FwS0AhurshCmWNAEb?=
 =?us-ascii?Q?4kvGIEUk03NOBJ9xXEX0rWl6G4UXsbbWyKJL6es8CfpKzoX4p+TKGbdqmJ6C?=
 =?us-ascii?Q?pb9nuPH6tOweN7tRCdBfUAbgW0x3Nnympsx7oH2gCE1rTi5UnigZk7YnCo0F?=
 =?us-ascii?Q?wr+OXX8qZz0E7bdwqE8RCkybhBDdbas852IIJujXLpBEcrP00G7juXLt+/81?=
 =?us-ascii?Q?3rlYMbFWNCPbri0oxFCUFHeG+4FeYUeokKn1Ivhi7PbgSoYADyrCxwTYFtCr?=
 =?us-ascii?Q?KZoGbnjAUMJBosZ4kkPM89aN7J9+E1Jcf8APnTr3zXXa7dc6Iw3ghVI79Vu1?=
 =?us-ascii?Q?xEdGBhVNE2748CYYmH5yn46+ViwsqIU3xX4DuzaMGb264S105LUZ/5jdBbXy?=
 =?us-ascii?Q?3/fapdZyzrdaWza5mxTL8ymUkBbcxzkLi6lhRpOmn9S/u0LFpNsJKx8LAPKP?=
 =?us-ascii?Q?1f7EX6BSUVB6BjAF3nQ5SeJOzT9ONkxLEpcSWZcITsuMlg3pAd7jUWUo1TXT?=
 =?us-ascii?Q?3HxKPGrISP/jLhCICYgi6GauCpR80/392rZPVy1C6hRbEiC5P/U2tgHEiPim?=
 =?us-ascii?Q?ntNJMw1XbvoVFbxYpc5uaFBH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3efcc56-24c8-4585-1c55-08d963f3980d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:13.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHNxGbMKhgmFLR88Up3duYb+eqM284XuqEofjb3BIs2+2Kz32Qo0EeB+BCFTHHvrfI/htaKgEKz4xHE7F5GLrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
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

To handle the case #1, change the page state to the firmware in the RMP
table before issuing the command and restore the state to shared after the
command completes.

For the case #2, use a bounce buffer to complete the request.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 346 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |  12 ++
 2 files changed, 348 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 34dc358b13b9..4cd7d803a624 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -317,12 +317,295 @@ void snp_free_firmware_page(void *addr)
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
+		if (snp_set_rmp_state(*paddr, npages, true, true, false))
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
+	if (snp_set_rmp_state(__pa(map->host), npages, true, true, false))
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
+		if (snp_set_rmp_state(*paddr, npages, false, true, true))
+			return -EFAULT;
+
+		goto done;
+	}
+
+	/*
+	 * Transition the pre-allocated buffer to hypervisor state before the access.
+	 *
+	 * This is because while changing the page state to firmware, the kernel unmaps
+	 * the pages from the direct map, and to restore the direct map we must
+	 * transition the pages to shared state.
+	 */
+	if (snp_set_rmp_state(__pa(map->host), npages, false, true, true))
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
+#define prep_buffer(name, addr, len, guest, map)  \
+   func(&((typeof(name *))cmd_buf)->addr, ((typeof(name *))cmd_buf)->len, guest, map)
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
+		if (snp_set_rmp_state(__pa(cmd_buf), 1, false, true, false))
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
+		if (snp_set_rmp_state(__pa(cmd_buf), 1, true, true, false))
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
@@ -342,12 +625,28 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
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
@@ -388,15 +687,24 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
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
@@ -1271,10 +1579,12 @@ int sev_dev_init(struct psp_device *psp)
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
@@ -1327,6 +1637,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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
 
@@ -1391,6 +1707,14 @@ void sev_pci_init(void)
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
@@ -1420,12 +1744,14 @@ void sev_pci_init(void)
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

