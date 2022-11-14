Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AA56279B2
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbiKNJ5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiKNJ5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:57:05 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE9FBE24;
        Mon, 14 Nov 2022 01:56:43 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so13290219pji.1;
        Mon, 14 Nov 2022 01:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYqHxPIIGiydwMniNgTkMQToQgboZx9lhkgkluMSPm8=;
        b=VdrqI4Vyw7A9PqbXfHc7X5zw7szDlFu2N1gJXuRArP9njEYvYi+6mH/3KS7QcqW1cd
         UNJr6K1h+eOv7mTxRNm2UKH/dobbm/FtrbK9rGGUgApgcDG2u5J4fmQQm47WwI11yhlT
         94jLOcaCyhEFcNTPaT+EFRISkxO8SnPFVy4Mmuk/bRo2P+bDf9Ntk5eHZk3AL1LAlOKL
         BKT5ZbPKJfN5u6QAZ5Cpb7W1DkaZ5p1i4voKL3wBjgBMr0b3PWwXxaK9Rw10b1OaRijY
         BEnH5F1T06cNywBjftKME/XuGJdkZGlj3b3xFUcErchpAzFslAlAtpCo2mFEsSufp8/r
         iAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYqHxPIIGiydwMniNgTkMQToQgboZx9lhkgkluMSPm8=;
        b=nxUEeCqmzr/ZOSXwiF1jmpLiJfXLYQTYEDkYApSvLo/UVl7ZyhIh/zBltCBvsardWh
         Yl1TVkaNf/I499yg1ZSRlxhypw1C1BKJIneqePc4f/c14Xn1chRiAwqW+1qxtZaoezlx
         kQxZ3gox9VCprUzLmYjRwUnOak0sENZEsYFkE9eGOTNnQyizJpjOVNAuAyYeZuHTSKyF
         74dGIGGtQFVPVby/qjbj7ASkcFeuXXGW7rPFAVF9IgCOx3hIYdrBhxks3clTgqPv6s2e
         nw9p6VeexTL4o3jW7VvEqViCKhlK7dv80y7e8SaI1iofi/Wgn3QbYDLq1ubaRYCyQuz6
         2/uw==
X-Gm-Message-State: ANoB5pkl1ODHd5jW/DMnNL93TrshptXBE5l1dUSrKXCLWEaE1pjsprgo
        I8fV81Qz8sUjHMVf7uw9OYQ=
X-Google-Smtp-Source: AA0mqf5B7qvKQJGIFLjWC0mix23jpeFB4p03FZYnJc8WrkKaYo5LUsgr4ZwzT1gK/4ve56lVq+YyxQ==
X-Received: by 2002:a17:902:c20c:b0:186:9c32:79d9 with SMTP id 12-20020a170902c20c00b001869c3279d9mr13524247pll.47.1668419802570;
        Mon, 14 Nov 2022 01:56:42 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:42 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] KVM: x86: Remove unnecessary export of kvm_inject_nmi()
Date:   Mon, 14 Nov 2022 17:55:58 +0800
Message-Id: <20221114095606.39785-7-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
References: <20221114095606.39785-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Don't export x86's kvm_inject_nmi(), the helper isn't used by
KVM x86's vendor modules. Add declaration to header file out of
existing callers' need.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 1 -
 arch/x86/kvm/x86.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 818aff135261..c03e599166b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -802,7 +802,6 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 	atomic_inc(&vcpu->arch.nmi_queued);
 	kvm_make_request(KVM_REQ_NMI, vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_nmi);
 
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 69811b4f3eac..c5ff5b05af49 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -308,6 +308,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
+void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
 extern u64 host_xcr0;
 extern u64 host_xss;
-- 
2.38.1

