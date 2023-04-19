Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595906E84C8
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjDSWWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbjDSWVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:21:34 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F93A212F
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:10 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-246eebbde1cso209964a91.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942738; x=1684534738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LnnJUnDn5Gg0VxA4G2224aJuFesVpwMyXWuJ35Yh1EA=;
        b=qN2qG27GHv+d9gUwWztkTi8p+g3aaC2rFXOZGwLc8eAMBqzRu7eT8kWoOJLWLTW0Eo
         Z5lYOlCFWymONdQ75UX7d1w0T/hT7irv6Jb4eLBvu7abb5vVm52aXVMSJ1GMw0Dbzqsr
         +1z7/IHpZr9TOWWv65z2G7cezkDsdmOF3T3T+GedPiWIaC/Kuy6PLSFoobdSxJzll2MD
         g1noklYQNjPoDJtmIYCLWo0ww78Wd6QJJJ0qNcx7/a9E59ARcqxtApq0JG/1pIkk/aOb
         ezm4wy13mbTPlO+a9FFwfpQuhkNR1dmeg9ddTlU2Pq0Tpw9j5c0vXUUJGHEIdY9VbyGW
         1hlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942738; x=1684534738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LnnJUnDn5Gg0VxA4G2224aJuFesVpwMyXWuJ35Yh1EA=;
        b=JaXAmT/TPPXUKkQrV4ccLb5rGrZ9XC+4kxIQKg04jedSOT3hRjf6dexTx6EIX0NXic
         XuoWOHD1IssM0mzuQmGljV3j2S+d7xkjr2Dddn5ASUgC0uMI7xZSyE7E95nFOMQDP+Ck
         Jy16WQi9YS+nn+Uq86ep+pgJVVWU9cgxRmxMFYajcVN+swegByK3KmZr75BELAdu/bwA
         q26V2/M/MoXpiXW8p3T1rdON/gnAg4KvZRQBHu/hr6150/+tMw81m+QS1b42xgiRbwkU
         mSfXo1GXgwkWrgljsEnnz1e48pJaEF9KsEd6VVFt2vVIN/NuYM0OMRG0ao89AIf+nAOg
         xRqA==
X-Gm-Message-State: AAQBX9fJ5JkfocCknOzpCjXqzziGgd8JLFp66MamdvDo5z7BMs05R/Fs
        IMlQ9TxitUQkVUUhCnuzqolaWg==
X-Google-Smtp-Source: AKy350aHmxw5PVAlBIl9T883RKpr61ycrn0Nkrml8nQtl+RbpvzosCcY4lybRtm63StCXT7HS5Gtsg==
X-Received: by 2002:a17:90b:38c6:b0:237:c209:5b14 with SMTP id nn6-20020a17090b38c600b00237c2095b14mr3820467pjb.22.1681942738315;
        Wed, 19 Apr 2023 15:18:58 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:58 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Atish Patra <atishp@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 40/48] RISC-V: COVE: Add COVH invalidate, validate, promote, demote and remove APIs.
Date:   Wed, 19 Apr 2023 15:17:08 -0700
Message-Id: <20230419221716.3603068-41-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

SBI_EXT_COVH_TVM_INVALIDATE_PAGES: Invalidates the pages in the specified
range of guest physical address space. The host can now work upon the
range without TVM's interaction. Any access from TVM to the range will
result in a page-fault which will be reported to the host.

SBI_EXT_COVH_TVM_VALIDATE_PAGES: Marks the invalidated pages in the
specified range of guest physical address space as present and TVM
can now access the pages.

SBI_EXT_COVH_TVM_PROMOTE_PAGES: Promotes a set of contiguous mappings
to the requested page size. This is mainly to support huge-pages.

SBI_EXT_COVH_TVM_DEMOTE_PAGES: Demotes a huge page mapping to a set
of contiguous mappings at the target size.

SBI_EXT_COVH_TVM_REMOVE_PAGES: Removes mappings from a TVM. The range
to be unmapped must already have been invalidated and fenced, and must
lie within a removable region of guest physical address space.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
---
 arch/riscv/include/asm/kvm_cove_sbi.h | 16 +++++++
 arch/riscv/include/asm/sbi.h          |  5 +++
 arch/riscv/kvm/cove_sbi.c             | 65 +++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_cove_sbi.h b/arch/riscv/include/asm/kvm_cove_sbi.h
index 0759f70..b554a8d 100644
--- a/arch/riscv/include/asm/kvm_cove_sbi.h
+++ b/arch/riscv/include/asm/kvm_cove_sbi.h
@@ -59,6 +59,22 @@ int sbi_covh_create_tvm_vcpu(unsigned long tvmid, unsigned long tvm_vcpuid,
 
 int sbi_covh_run_tvm_vcpu(unsigned long tvmid, unsigned long tvm_vcpuid);
 
+int sbi_covh_tvm_invalidate_pages(unsigned long tvmid,
+			     unsigned long tvm_base_page_addr,
+			     unsigned long len);
+int sbi_covh_tvm_validate_pages(unsigned long tvmid,
+			       unsigned long tvm_base_page_addr,
+			       unsigned long len);
+int sbi_covh_tvm_promote_page(unsigned long tvmid,
+			      unsigned long tvm_base_page_addr,
+			      enum sbi_cove_page_type ptype);
+int sbi_covh_tvm_demote_page(unsigned long tvmid,
+			     unsigned long tvm_base_page_addr,
+			     enum sbi_cove_page_type ptype);
+int sbi_covh_tvm_remove_pages(unsigned long tvmid,
+			      unsigned long tvm_base_page_addr,
+			      unsigned long len);
+
 /* Functions related to CoVE Interrupt Management(COVI) Extension */
 int sbi_covi_tvm_aia_init(unsigned long tvm_gid, struct sbi_cove_tvm_aia_params *tvm_aia_params);
 int sbi_covi_set_vcpu_imsic_addr(unsigned long tvm_gid, unsigned long vcpu_id,
diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index e02ee75..03b0cc8 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -369,6 +369,11 @@ enum sbi_ext_covh_fid {
 	SBI_EXT_COVH_TVM_CREATE_VCPU,
 	SBI_EXT_COVH_TVM_VCPU_RUN,
 	SBI_EXT_COVH_TVM_INITIATE_FENCE,
+	SBI_EXT_COVH_TVM_INVALIDATE_PAGES,
+	SBI_EXT_COVH_TVM_VALIDATE_PAGES,
+	SBI_EXT_COVH_TVM_PROMOTE_PAGE,
+	SBI_EXT_COVH_TVM_DEMOTE_PAGE,
+	SBI_EXT_COVH_TVM_REMOVE_PAGES,
 };
 
 enum sbi_ext_covi_fid {
diff --git a/arch/riscv/kvm/cove_sbi.c b/arch/riscv/kvm/cove_sbi.c
index a8901ac..01dc260 100644
--- a/arch/riscv/kvm/cove_sbi.c
+++ b/arch/riscv/kvm/cove_sbi.c
@@ -405,3 +405,68 @@ int sbi_covh_run_tvm_vcpu(unsigned long tvmid, unsigned long vcpuid)
 
 	return 0;
 }
+
+int sbi_covh_tvm_invalidate_pages(unsigned long tvmid,
+			     unsigned long tvm_base_page_addr,
+			     unsigned long len)
+{
+	struct sbiret ret = sbi_ecall(SBI_EXT_COVH,
+				      SBI_EXT_COVH_TVM_INVALIDATE_PAGES, tvmid,
+				      tvm_base_page_addr, len, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tvm_validate_pages(unsigned long tvmid,
+			       unsigned long tvm_base_page_addr,
+			       unsigned long len)
+{
+	struct sbiret ret = sbi_ecall(SBI_EXT_COVH,
+				      SBI_EXT_COVH_TVM_VALIDATE_PAGES, tvmid,
+				      tvm_base_page_addr, len, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tvm_promote_page(unsigned long tvmid,
+			      unsigned long tvm_base_page_addr,
+			      enum sbi_cove_page_type ptype)
+{
+	struct sbiret ret = sbi_ecall(SBI_EXT_COVH,
+				      SBI_EXT_COVH_TVM_PROMOTE_PAGE, tvmid,
+				      tvm_base_page_addr, ptype, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tvm_demote_page(unsigned long tvmid,
+			     unsigned long tvm_base_page_addr,
+			     enum sbi_cove_page_type ptype)
+{
+	struct sbiret ret = sbi_ecall(SBI_EXT_COVH,
+				      SBI_EXT_COVH_TVM_DEMOTE_PAGE, tvmid,
+				      tvm_base_page_addr, ptype, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covh_tvm_remove_pages(unsigned long tvmid,
+			      unsigned long tvm_base_page_addr,
+			      unsigned long len)
+{
+	struct sbiret ret = sbi_ecall(SBI_EXT_COVH,
+				      SBI_EXT_COVH_TVM_REMOVE_PAGES, tvmid,
+				      tvm_base_page_addr, len, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
-- 
2.25.1

