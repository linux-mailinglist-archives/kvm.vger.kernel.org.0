Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98C023ABFD
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 19:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgHCR7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 13:59:18 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:64728 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgHCR7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 13:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596477556; x=1628013556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/WuBKKqQJ2DS9gLpxSbna82b/Rj8bNfTeDN1/MeY4to=;
  b=ldIiBbwi01R8GjOrznEfGRVF91p35hAR0FPw2lTYTs87y9JjAOW15NkB
   zfyVA7JENPYaSmcW78RjzjLvNySUBxiaOoM4ujX844OelayDqOVWeKNRl
   nPr5lo7oaRjyprQrTKhrxY/7xtnIMDL3N2vz+mh9bgdtEErFB8K1J5Do5
   qynOt+d22XVMr72LyZrMnWXiMPcWGJaavLqI4IVG4aj8ATlMOVa8j79Es
   d6sH/IIeKr9QXm8iyiWxtNWxjiJjNSS1WFphXXwCxoJCJrbxbz0iAOxIP
   AI61/mvIhUHuWEbaOqow0NOVuHQpDndAmt/6SD2Pv9tylBY//Gv4SULXl
   w==;
IronPort-SDR: hjvCoNLI7Qmdt/N/TBHIluW8PrnS1zVkC7z/tsj0dJ2B4JyjoyiVDlrc/9rm1P6iFo/UhOD0s1
 gq81Aei+iE4DNGTNP6gdHw1g9ehNc48cB7Et9I4z4OgvxMqM8/OsIvd3QbX8DQRaegDuuhTlXu
 QsrP7VPZEQob2+xQuVB3gipO+jY8oY6uTWGeXSC8pe2h/8db0uSSqmt91UHK0yZyg7nUChEccY
 ObL2I/dAf5aKkZRDW97N6a9EfPnKwDB92V6JCM5bLwDBYdlG8ReMEx+lguWmqW00fkS8f2+Hrr
 nMs=
X-IronPort-AV: E=Sophos;i="5.75,430,1589212800"; 
   d="scan'208";a="144033181"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2020 01:59:04 +0800
IronPort-SDR: 4VAC0m8TM8E3fJxPustvPVkRIyVs3DuwvS4bCPK7ne4qP583hDFvVWsO+RdpJnSZdbnFBoifzF
 u6y28LnvxXiw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 10:47:06 -0700
IronPort-SDR: b+L5ix2uhA5t3rcfUs2Aw7nrz9gwA9OaAzaqQxbJ4RQos5fVRvplQWg6A9RrXVtMjAiNbZUBpf
 aiMRiMpi9kvA==
WDCIronportException: Internal
Received: from cnf007830.ad.shared (HELO jedi-01.hgst.com) ([10.86.58.196])
  by uls-op-cesaip01.wdc.com with ESMTP; 03 Aug 2020 10:59:03 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>
Subject: [PATCH 1/6] RISC-V: Add a non-void return for sbi v02 functions
Date:   Mon,  3 Aug 2020 10:58:41 -0700
Message-Id: <20200803175846.26272-2-atish.patra@wdc.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200803175846.26272-1-atish.patra@wdc.com>
References: <20200803175846.26272-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SBI v0.2 functions can return an error code from SBI implementation.
We are already processing the SBI error code and coverts it to the Linux
error code.

Propagate to the error code to the caller as well. As of now, kvm is the
only user of these error codes.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/include/asm/sbi.h |  8 ++++----
 arch/riscv/kernel/sbi.c      | 32 ++++++++++++++++----------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 653edb25d495..2355515785eb 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -100,13 +100,13 @@ int sbi_console_getchar(void);
 void sbi_set_timer(uint64_t stime_value);
 void sbi_shutdown(void);
 void sbi_clear_ipi(void);
-void sbi_send_ipi(const unsigned long *hart_mask);
-void sbi_remote_fence_i(const unsigned long *hart_mask);
-void sbi_remote_sfence_vma(const unsigned long *hart_mask,
+int sbi_send_ipi(const unsigned long *hart_mask);
+int sbi_remote_fence_i(const unsigned long *hart_mask);
+int sbi_remote_sfence_vma(const unsigned long *hart_mask,
 			   unsigned long start,
 			   unsigned long size);
 
-void sbi_remote_sfence_vma_asid(const unsigned long *hart_mask,
+int sbi_remote_sfence_vma_asid(const unsigned long *hart_mask,
 				unsigned long start,
 				unsigned long size,
 				unsigned long asid);
diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index f383ef5672b2..53c44c831eb8 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -351,7 +351,7 @@ static int __sbi_rfence_v02(int fid, const unsigned long *hart_mask,
  * sbi_set_timer() - Program the timer for next timer event.
  * @stime_value: The value after which next timer event should fire.
  *
- * Return: None
+ * Return: None.
  */
 void sbi_set_timer(uint64_t stime_value)
 {
@@ -362,11 +362,11 @@ void sbi_set_timer(uint64_t stime_value)
  * sbi_send_ipi() - Send an IPI to any hart.
  * @hart_mask: A cpu mask containing all the target harts.
  *
- * Return: None
+ * Return: 0 on success, appropriate linux error code otherwise.
  */
-void sbi_send_ipi(const unsigned long *hart_mask)
+int sbi_send_ipi(const unsigned long *hart_mask)
 {
-	__sbi_send_ipi(hart_mask);
+	return __sbi_send_ipi(hart_mask);
 }
 EXPORT_SYMBOL(sbi_send_ipi);
 
@@ -374,12 +374,12 @@ EXPORT_SYMBOL(sbi_send_ipi);
  * sbi_remote_fence_i() - Execute FENCE.I instruction on given remote harts.
  * @hart_mask: A cpu mask containing all the target harts.
  *
- * Return: None
+ * Return: 0 on success, appropriate linux error code otherwise.
  */
-void sbi_remote_fence_i(const unsigned long *hart_mask)
+int sbi_remote_fence_i(const unsigned long *hart_mask)
 {
-	__sbi_rfence(SBI_EXT_RFENCE_REMOTE_FENCE_I,
-		     hart_mask, 0, 0, 0, 0);
+	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_FENCE_I,
+			    hart_mask, 0, 0, 0, 0);
 }
 EXPORT_SYMBOL(sbi_remote_fence_i);
 
@@ -390,14 +390,14 @@ EXPORT_SYMBOL(sbi_remote_fence_i);
  * @start: Start of the virtual address
  * @size: Total size of the virtual address range.
  *
- * Return: None
+ * Return: 0 on success, appropriate linux error code otherwise.
  */
-void sbi_remote_sfence_vma(const unsigned long *hart_mask,
+int sbi_remote_sfence_vma(const unsigned long *hart_mask,
 			   unsigned long start,
 			   unsigned long size)
 {
-	__sbi_rfence(SBI_EXT_RFENCE_REMOTE_SFENCE_VMA,
-		     hart_mask, start, size, 0, 0);
+	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_SFENCE_VMA,
+			    hart_mask, start, size, 0, 0);
 }
 EXPORT_SYMBOL(sbi_remote_sfence_vma);
 
@@ -410,15 +410,15 @@ EXPORT_SYMBOL(sbi_remote_sfence_vma);
  * @size: Total size of the virtual address range.
  * @asid: The value of address space identifier (ASID).
  *
- * Return: None
+ * Return: 0 on success, appropriate linux error code otherwise.
  */
-void sbi_remote_sfence_vma_asid(const unsigned long *hart_mask,
+int sbi_remote_sfence_vma_asid(const unsigned long *hart_mask,
 				unsigned long start,
 				unsigned long size,
 				unsigned long asid)
 {
-	__sbi_rfence(SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID,
-		     hart_mask, start, size, asid, 0);
+	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID,
+			    hart_mask, start, size, asid, 0);
 }
 EXPORT_SYMBOL(sbi_remote_sfence_vma_asid);
 
-- 
2.24.0

