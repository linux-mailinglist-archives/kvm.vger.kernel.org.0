Return-Path: <kvm+bounces-6471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EADC5832E00
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 18:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B5981C23DB7
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 17:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA78455E42;
	Fri, 19 Jan 2024 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="j1quTAeS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDB81E89D;
	Fri, 19 Jan 2024 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705684771; cv=none; b=hn9IvIqtvR6DjVpANCKuTAIMhIiU2uDDfN71Uyrp1TMTnQjllfuxq2ISlJYGdvWJuJaq1nTcbP7C4qKMhYRB71aW8ZHUc5u9Qk2tFm7PHtqguYqlaEjqmrhSWIv8JFl9epAe6tSwMDI/yZ8svhcPChUEwCtF5UvoLVOr3emjRPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705684771; c=relaxed/simple;
	bh=CK/0Aoa+/v7BnWsoJWfhnuzTqtszbtAFqKUL9lUNoZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYmFtM9oIi8G+G95RyFbpaDuY1SPDTK1RnB6gIJGN2SdR+wVCIxKMMlVblz3288tuEhSdhAOrwBeFeI4tNzwMWYXGEb94vcHCv8mSmmeuk4AdUOtMy1zYeekpJZD3ap1YFSMb5VF0Lb8edonIVb+RzWWmUPhdw4KszxRSDToYng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=j1quTAeS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6B02340E0196;
	Fri, 19 Jan 2024 17:19:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id h04YqUawuOR8; Fri, 19 Jan 2024 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705684755; bh=NdrGqYCswYjMHLxbiJgEfA0hlUGLDTLb3/kX/wziqeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j1quTAeSmUm1ll46vFDaoQmHyCL7AwF8bic9OCrukpZKVBPElnE2QuE0EMgtKPg58
	 YeonZ9pip1dOs800Cq2VHa6t2gELDt/DVXeqFHLFYk4kIbsQdPXxOXvi1j+gXF5Uyd
	 f1eJAZRTfv56lJXf/sseS3RjfTL+ur4uLCV79NrDbbS41Qu4Qd1TQYSg9fAI2suFQe
	 i6PHTXDY6RXvq69RyZ2B57obqD3SaXpEX9PFUlsr2wVL4bXH3zbfairUV+ExzUwubZ
	 t5sD6SPlgjmoMig0Wi9VoZPmJY9h7E+OuKGyDiVy/Zk9ymB1UHSdO7gbiiOpU201Qo
	 101DB7+TKrPb+6vl37W5bufxdoEJnzd/hBBB1CxT5GP1jbZMSRq+Z4nMhBg4et8bIe
	 6zxgwtRxvSEPxCOw7DSrlAHZjfcexc6f7PHUXXzgHxatTUcZqFigJysdFnLIFWR/6Y
	 BsTI0+QH1mSbDtk/ZcIR4RVDwkO08fB8Zh2VmwcqjL6fN31/Fdk/jch5LemVAw3yKV
	 OeEWU6uni7QrJydiYDcDt+91q7/NZQObr+ZP44MPK2vUGPrBmgY2VH4jHHePet1dJA
	 NK7duI1enku15GCpklEEav0VZlUtghNcnI0K1cUMNHjRx2mGnKPCCSbnUKZ8HZ96lu
	 kWSo8Whu3ZQfi9H66mf3Ly9M=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B015040E01B2;
	Fri, 19 Jan 2024 17:18:38 +0000 (UTC)
Date: Fri, 19 Jan 2024 18:18:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Subject: Re: [PATCH v1 18/26] crypto: ccp: Handle legacy SEV commands when
 SNP is enabled
Message-ID: <20240119171816.GKZaqu2M_1Pu7Q4mBn@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-19-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-19-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:46AM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The behavior of legacy SEV commands is altered when the firmware is
> initialized for SNP support. In that case, all command buffer memory
> that may get written to by legacy SEV commands must be marked as
> firmware-owned in the RMP table prior to issuing the command.
> 
> Additionally, when a command buffer contains a system physical address
> that points to additional buffers that firmware may write to, special
> handling is needed depending on whether:
> 
>   1) the system physical address points to guest memory
>   2) the system physical address points to host memory
> 
> To handle case #1, the pages of these buffers are changed to
> firmware-owned in the RMP table before issuing the command, and restored
> to after the command completes.
> 
> For case #2, a bounce buffer is used instead of the original address.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 421 ++++++++++++++++++++++++++++++++++-
>  drivers/crypto/ccp/sev-dev.h |   3 +
>  2 files changed, 414 insertions(+), 10 deletions(-)

Definitely better, thanks.

Some cleanups ontop:

---

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8cfb376ca2e7..7681c094c7ff 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -514,18 +514,21 @@ static void *sev_fw_alloc(unsigned long len)
  * struct cmd_buf_desc - descriptors for managing legacy SEV command address
  * parameters corresponding to buffers that may be written to by firmware.
  *
- * @paddr_ptr: pointer the address parameter in the command buffer, which may
- *	need to be saved/restored depending on whether a bounce buffer is used.
- *	Must be NULL if this descriptor is only an end-of-list indicator.
+ * @paddr: address which may need to be saved/restored depending on whether
+ * a bounce buffer is used. Must be NULL if this descriptor is only an
+ * end-of-list indicator.
+ *
  * @paddr_orig: storage for the original address parameter, which can be used to
- *	restore the original value in @paddr_ptr in cases where it is replaced
- *	with the address of a bounce buffer.
- * @len: length of buffer located at the address originally stored at @paddr_ptr
+ * restore the original value in @paddr in cases where it is replaced with
+ * the address of a bounce buffer.
+ *
+ * @len: length of buffer located at the address originally stored at @paddr
+ *
  * @guest_owned: true if the address corresponds to guest-owned pages, in which
- *	case bounce buffers are not needed.
+ * case bounce buffers are not needed.
  */
 struct cmd_buf_desc {
-	u64 *paddr_ptr;
+	u64 paddr;
 	u64 paddr_orig;
 	u32 len;
 	bool guest_owned;
@@ -549,30 +552,30 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
 	case SEV_CMD_PDH_CERT_EXPORT: {
 		struct sev_data_pdh_cert_export *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->pdh_cert_address;
+		desc_list[0].paddr = data->pdh_cert_address;
 		desc_list[0].len = data->pdh_cert_len;
-		desc_list[1].paddr_ptr = &data->cert_chain_address;
+		desc_list[1].paddr = data->cert_chain_address;
 		desc_list[1].len = data->cert_chain_len;
 		break;
 	}
 	case SEV_CMD_GET_ID: {
 		struct sev_data_get_id *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].paddr = data->address;
 		desc_list[0].len = data->len;
 		break;
 	}
 	case SEV_CMD_PEK_CSR: {
 		struct sev_data_pek_csr *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].paddr = data->address;
 		desc_list[0].len = data->len;
 		break;
 	}
 	case SEV_CMD_LAUNCH_UPDATE_DATA: {
 		struct sev_data_launch_update_data *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].paddr = data->address;
 		desc_list[0].len = data->len;
 		desc_list[0].guest_owned = true;
 		break;
@@ -580,7 +583,7 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
 	case SEV_CMD_LAUNCH_UPDATE_VMSA: {
 		struct sev_data_launch_update_vmsa *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].paddr = data->address;
 		desc_list[0].len = data->len;
 		desc_list[0].guest_owned = true;
 		break;
@@ -588,14 +591,14 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
 	case SEV_CMD_LAUNCH_MEASURE: {
 		struct sev_data_launch_measure *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].paddr = data->address;
 		desc_list[0].len = data->len;
 		break;
 	}
 	case SEV_CMD_LAUNCH_UPDATE_SECRET: {
 		struct sev_data_launch_secret *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->guest_address;
+		desc_list[0].paddr = data->guest_address;
 		desc_list[0].len = data->guest_len;
 		desc_list[0].guest_owned = true;
 		break;
@@ -603,7 +606,7 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
 	case SEV_CMD_DBG_DECRYPT: {
 		struct sev_data_dbg *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->dst_addr;
+		desc_list[0].paddr = data->dst_addr;
 		desc_list[0].len = data->len;
 		desc_list[0].guest_owned = true;
 		break;
@@ -611,7 +614,7 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
 	case SEV_CMD_DBG_ENCRYPT: {
 		struct sev_data_dbg *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->dst_addr;
+		desc_list[0].paddr = data->dst_addr;
 		desc_list[0].len = data->len;
 		desc_list[0].guest_owned = true;
 		break;
@@ -619,39 +622,39 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
 	case SEV_CMD_ATTESTATION_REPORT: {
 		struct sev_data_attestation_report *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->address;
+		desc_list[0].paddr = data->address;
 		desc_list[0].len = data->len;
 		break;
 	}
 	case SEV_CMD_SEND_START: {
 		struct sev_data_send_start *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->session_address;
+		desc_list[0].paddr = data->session_address;
 		desc_list[0].len = data->session_len;
 		break;
 	}
 	case SEV_CMD_SEND_UPDATE_DATA: {
 		struct sev_data_send_update_data *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->hdr_address;
+		desc_list[0].paddr = data->hdr_address;
 		desc_list[0].len = data->hdr_len;
-		desc_list[1].paddr_ptr = &data->trans_address;
+		desc_list[1].paddr = data->trans_address;
 		desc_list[1].len = data->trans_len;
 		break;
 	}
 	case SEV_CMD_SEND_UPDATE_VMSA: {
 		struct sev_data_send_update_vmsa *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->hdr_address;
+		desc_list[0].paddr = data->hdr_address;
 		desc_list[0].len = data->hdr_len;
-		desc_list[1].paddr_ptr = &data->trans_address;
+		desc_list[1].paddr = data->trans_address;
 		desc_list[1].len = data->trans_len;
 		break;
 	}
 	case SEV_CMD_RECEIVE_UPDATE_DATA: {
 		struct sev_data_receive_update_data *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->guest_address;
+		desc_list[0].paddr = data->guest_address;
 		desc_list[0].len = data->guest_len;
 		desc_list[0].guest_owned = true;
 		break;
@@ -659,7 +662,7 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
 	case SEV_CMD_RECEIVE_UPDATE_VMSA: {
 		struct sev_data_receive_update_vmsa *data = cmd_buf;
 
-		desc_list[0].paddr_ptr = &data->guest_address;
+		desc_list[0].paddr = data->guest_address;
 		desc_list[0].len = data->guest_len;
 		desc_list[0].guest_owned = true;
 		break;
@@ -687,16 +690,16 @@ static int snp_map_cmd_buf_desc(struct cmd_buf_desc *desc)
 			return -ENOMEM;
 		}
 
-		desc->paddr_orig = *desc->paddr_ptr;
-		*desc->paddr_ptr = __psp_pa(page_to_virt(page));
+		desc->paddr_orig = desc->paddr;
+		desc->paddr = __psp_pa(page_to_virt(page));
 	}
 
-	paddr = *desc->paddr_ptr;
+	paddr = desc->paddr;
 	npages = PAGE_ALIGN(desc->len) >> PAGE_SHIFT;
 
 	/* Transition the buffer to firmware-owned. */
 	if (rmp_mark_pages_firmware(paddr, npages, true)) {
-		pr_warn("Failed move pages to firmware-owned state for SEV legacy command.\n");
+		pr_warn("Error moving pages to firmware-owned state for SEV legacy command.\n");
 		return -EFAULT;
 	}
 
@@ -705,31 +708,29 @@ static int snp_map_cmd_buf_desc(struct cmd_buf_desc *desc)
 
 static int snp_unmap_cmd_buf_desc(struct cmd_buf_desc *desc)
 {
-	unsigned long paddr;
 	unsigned int npages;
 
 	if (!desc->len)
 		return 0;
 
-	paddr = *desc->paddr_ptr;
 	npages = PAGE_ALIGN(desc->len) >> PAGE_SHIFT;
 
 	/* Transition the buffers back to hypervisor-owned. */
-	if (snp_reclaim_pages(paddr, npages, true)) {
+	if (snp_reclaim_pages(desc->paddr, npages, true)) {
 		pr_warn("Failed to reclaim firmware-owned pages while issuing SEV legacy command.\n");
 		return -EFAULT;
 	}
 
 	/* Copy data from bounce buffer and then free it. */
 	if (!desc->guest_owned) {
-		void *bounce_buf = __va(__sme_clr(paddr));
+		void *bounce_buf = __va(__sme_clr(desc->paddr));
 		void *dst_buf = __va(__sme_clr(desc->paddr_orig));
 
 		memcpy(dst_buf, bounce_buf, desc->len);
 		__free_pages(virt_to_page(bounce_buf), get_order(desc->len));
 
 		/* Restore the original address in the command buffer. */
-		*desc->paddr_ptr = desc->paddr_orig;
+		desc->paddr = desc->paddr_orig;
 	}
 
 	return 0;
@@ -737,14 +738,14 @@ static int snp_unmap_cmd_buf_desc(struct cmd_buf_desc *desc)
 
 static int snp_map_cmd_buf_desc_list(int cmd, void *cmd_buf, struct cmd_buf_desc *desc_list)
 {
-	int i, n;
+	int i;
 
 	snp_populate_cmd_buf_desc_list(cmd, cmd_buf, desc_list);
 
 	for (i = 0; i < CMD_BUF_DESC_MAX; i++) {
 		struct cmd_buf_desc *desc = &desc_list[i];
 
-		if (!desc->paddr_ptr)
+		if (!desc->paddr)
 			break;
 
 		if (snp_map_cmd_buf_desc(desc))
@@ -754,8 +755,7 @@ static int snp_map_cmd_buf_desc_list(int cmd, void *cmd_buf, struct cmd_buf_desc
 	return 0;
 
 err_unmap:
-	n = i;
-	for (i = 0; i < n; i++)
+	for (i--; i >= 0; i--)
 		snp_unmap_cmd_buf_desc(&desc_list[i]);
 
 	return -EFAULT;
@@ -768,7 +768,7 @@ static int snp_unmap_cmd_buf_desc_list(struct cmd_buf_desc *desc_list)
 	for (i = 0; i < CMD_BUF_DESC_MAX; i++) {
 		struct cmd_buf_desc *desc = &desc_list[i];
 
-		if (!desc->paddr_ptr)
+		if (!desc->paddr)
 			break;
 
 		if (snp_unmap_cmd_buf_desc(desc))
@@ -799,8 +799,8 @@ static bool sev_cmd_buf_writable(int cmd)
 	}
 }
 
-/* After SNP is INIT'ed, the behavior of legacy SEV commands is changed. */
-static bool snp_legacy_handling_needed(int cmd)
+/* After SNP is initialized, the behavior of legacy SEV commands is changed. */
+static inline bool snp_legacy_handling_needed(int cmd)
 {
 	struct sev_device *sev = psp_master->sev_data;
 
@@ -891,7 +891,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 			sev->cmd_buf_backup_active = true;
 		} else {
 			dev_err(sev->dev,
-				"SEV: too many firmware commands are in-progress, no command buffers available.\n");
+				"SEV: too many firmware commands in progress, no command buffers available.\n");
 			return -EBUSY;
 		}
 
@@ -904,7 +904,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 		ret = snp_prep_cmd_buf(cmd, cmd_buf, desc_list);
 		if (ret) {
 			dev_err(sev->dev,
-				"SEV: failed to prepare buffer for legacy command %#x. Error: %d\n",
+				"SEV: failed to prepare buffer for legacy command 0x%#x. Error: %d\n",
 				cmd, ret);
 			return ret;
 		}


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

