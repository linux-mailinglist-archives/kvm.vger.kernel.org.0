Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D23694CE9
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 17:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjBMQbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 11:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjBMQbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 11:31:49 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5379D1DBAB
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:42 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so9492407wmb.2
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5R9IHW3Vc8hHuytFcQqc/EbsgNLSr+qUBtW2LZuwhKo=;
        b=mOvd2eMD6QLHz2v4lsp37mHHKKF2WTr+lT6m5AFMibytX39ZrCQbcVZetFrpk3Sbte
         n2nZyb0KnigW310tkHtMVoZFiKAs21VD9w0dDzFqZ9mVJkmYFMqbaV+g5HqlTEZ9NxBs
         B0iOyOY0hcMJXZx9zk6sYcq2ioZMpRdHc2bQ6v4meVPLWQyAhoGoJzeChBqUvxBt7M3/
         uSfVEdSBzXvkyd/Mvi1Qn4oLnZ6DLhzZHWOrSGz1T5lkZLvYWOnm6q4Hw98GLsmRXttH
         tVi2OwnbYHUMlJH+S30PuIpcBbKoJaHTSdYi+uf+EDWuGHuUXQe8OQsY3l70kE6eKjO7
         oXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5R9IHW3Vc8hHuytFcQqc/EbsgNLSr+qUBtW2LZuwhKo=;
        b=QhQn9itOA6zcAU9xPk8w32eQaRgzeeD+og4iwZ77Arx+aGVmPRLaGTgO2jyImgTWua
         YZYVntUkgEsM+l93vwxOh/qUn919f6GO4Bob4Pf5tSgm6WRsMg+Eabo8K1o0pMBo1YxF
         D71mQX496EchtLqIPZq8fA20vEn5yoHGYZIGpxtGUXOK1MqLqq+Xt/YyWZhZpsFtN57k
         enl7Qw1jgCsgxMbv7VSa7qlU/tZga1uOq9ILGLJGWC4xbe/j+SmbSGvfvoZJLbqQhYYS
         4uczoPrlUkDuVGZA0icUULxRl5+YGOVjFecQ3BhfyJ4DL31zv8IDuHEsX6FkCxy/EIz0
         oTYg==
X-Gm-Message-State: AO0yUKWbiyfURC4ixGkpBbEynWw/7/C3ChMrr8iMTH7uLgnEYI6gGqR2
        +/E1L28yLpTU4F6v1txMnw/NfkDW6nHUW6Aa
X-Google-Smtp-Source: AK7set//U03qp8rXuTdVuLS/9D+F7/9YZA8Byw1LnudM3CTwbMgDqUxnUsCjvN/ChQuTe21MPf+LsA==
X-Received: by 2002:a05:600c:330a:b0:3df:de27:4191 with SMTP id q10-20020a05600c330a00b003dfde274191mr19226786wmp.16.1676305900763;
        Mon, 13 Feb 2023 08:31:40 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af2efd00225e3e97da45b943.dip0.t-ipconnect.de. [2003:f6:af2e:fd00:225e:3e97:da45:b943])
        by smtp.gmail.com with ESMTPSA id s7-20020a5d5107000000b002c556a4f1casm3877993wrt.42.2023.02.13.08.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:31:40 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 4/5] KVM: x86: Shrink struct kvm_vcpu_arch
Date:   Mon, 13 Feb 2023 17:33:50 +0100
Message-Id: <20230213163351.30704-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213163351.30704-1-minipli@grsecurity.net>
References: <20230213163351.30704-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reshuffle the members of struct kvm_vcpu_arch to make use of otherwise
unused padding holes, allowing denser packing without disrupting their
grouping.

This allows us to shrink the object size by 48 bytes for 64 bit builds.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
Instead of attempting to create an optimal shuffle by sorting members by
their alignment constraints, I intended to keep the members grouped by
their meaning to keep the maintainability of the code.

 arch/x86/include/asm/kvm_host.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 040eee3e9583..5036456b05b0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -824,18 +824,18 @@ struct kvm_vcpu_arch {
 
 	int halt_request; /* real mode on Intel only */
 
+	u32 kvm_cpuid_base;
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
-	u32 kvm_cpuid_base;
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
 
 	/* emulate context */
 
-	struct x86_emulate_ctxt *emulate_ctxt;
 	bool emulate_regs_need_sync_to_vcpu;
 	bool emulate_regs_need_sync_from_vcpu;
+	struct x86_emulate_ctxt *emulate_ctxt;
 	int (*complete_userspace_io)(struct kvm_vcpu *vcpu);
 
 	gpa_t time;
@@ -916,17 +916,17 @@ struct kvm_vcpu_arch {
 	unsigned long last_retry_addr;
 
 	struct {
-		bool halted;
 		gfn_t gfns[ASYNC_PF_PER_VCPU];
 		struct gfn_to_hva_cache data;
 		u64 msr_en_val; /* MSR_KVM_ASYNC_PF_EN */
 		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
-		u16 vec;
 		u32 id;
+		u16 vec;
 		bool send_user_only;
 		u32 host_apf_flags;
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
+		bool halted;
 	} apf;
 
 	/* OSVW MSRs (AMD only) */
@@ -942,6 +942,9 @@ struct kvm_vcpu_arch {
 
 	u64 msr_kvm_poll_control;
 
+	/* set at EPT violation at this point */
+	unsigned long exit_qualification;
+
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
 	 * more of the PTEs used to translate the write itself, i.e. the access
@@ -959,9 +962,6 @@ struct kvm_vcpu_arch {
 	 */
 	bool write_fault_to_shadow_pgtable;
 
-	/* set at EPT violation at this point */
-	unsigned long exit_qualification;
-
 	/* pv related host specific info */
 	struct {
 		bool pv_unhalted;
@@ -979,9 +979,6 @@ struct kvm_vcpu_arch {
 	/* Host CPU on which VM-entry was most recently attempted */
 	int last_vmentry_cpu;
 
-	/* AMD MSRC001_0015 Hardware Configuration */
-	u64 msr_hwcr;
-
 	/* pv related cpuid info */
 	struct {
 		/*
@@ -1006,6 +1003,9 @@ struct kvm_vcpu_arch {
 	 */
 	bool pdptrs_from_userspace;
 
+	/* AMD MSRC001_0015 Hardware Configuration */
+	u64 msr_hwcr;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
-- 
2.39.1

