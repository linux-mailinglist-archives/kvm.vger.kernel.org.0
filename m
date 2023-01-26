Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFBE67D46C
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjAZSkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjAZSku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:40:50 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02AB68114
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:40:49 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5073cf66299so29815107b3.17
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFZa9l3vyucfCG4Eq3J8ahjsI/hEp3XR7lOR7mP5Tis=;
        b=VN8PcPha7Z2Hg2wUqIDXSVB9mIu3m5t7TqCWhS7ECVnfl8R6VT46nDUUpIdPd8qYIu
         sPbmuYUrqofSVjFpAQL/fHfGTywYaxsZmAQ4hg3IUfTCV8TgsrkwIG8rB6V8so/pVILl
         FbZnf6P1zimoFc9xDC9Nk70G/4VeIh3saPIAZ7GaELcRYjZXPiiuTvAxlL2J7MK+GgBB
         R79bSmOGc2ymgpjljLv3Gs+t2Fpik0oiOCH+4+ATd2NpUHX4NQuK4+vww/XPqJ3KVOzW
         Dzdepdf9i5pi4SZVLHZGzkaG3RO4gSy6JIe5EWncXIGCyemgDUkXQuACg068oRZAaLUa
         bEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oFZa9l3vyucfCG4Eq3J8ahjsI/hEp3XR7lOR7mP5Tis=;
        b=0ppqFPoWRTMHvfgYab4qJfn4EMHVxGtkotlSVmwwQtHsGvvmtkLwIGnefuygXWU/pi
         pCJ8fxrEGJq+11K8jMflv8onqgtWf/uzjvLWdCxdSpNCx3Tc/vY5YDp0d9Vxmm+MAYwY
         QlBPGNp/SNDM08hioUiz7+gtuhOf2+JsBHR+nJNRupYdZ+9XQ+KfcBSmBsm2T9eGUZS5
         bG6n4+qGgprhD7D7mlWacbZapuumdwyRFPKiX1CT8GUpwUIizdQsVXaXGEBQ5DSo8RtT
         PvG1Ws1g6v2Lh2mZunmHfpTcWzMi85W4UWJhQXvZRFf+aN/A7quMIk/vBVaQbkunPrmB
         8LPA==
X-Gm-Message-State: AO0yUKVDTlwxpd/85b4C6d2t7uRgz1Nm2OpNuO55oHZty8dtG9aytOae
        LNXBhZvHR6cvWqZNlI2x21+4llEld/x5NA==
X-Google-Smtp-Source: AK7set+zuBoUhMsYx0pNBabOkZre6s4lpq4SlxleAkv4G0uh1Va2tnBH9KvK2TQFyhdS6n4IjKUpzb9Uws//rg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:5204:0:b0:507:86ae:c733 with SMTP id
 g4-20020a815204000000b0050786aec733mr835986ywb.358.1674758448911; Thu, 26 Jan
 2023 10:40:48 -0800 (PST)
Date:   Thu, 26 Jan 2023 10:40:23 -0800
In-Reply-To: <20230126184025.2294823-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230126184025.2294823-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126184025.2294823-6-dmatlack@google.com>
Subject: [PATCH v2 5/7] KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        David Matlack <dmatlack@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use gfn_t instead of u64 for the start_gfn parameter to
kvm_flush_remote_tlbs_range(), since that is the standard type for GFNs
throughout KVM.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 215a8b7f5e03..34b670e719af 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -247,7 +247,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 3bb21d29d84c..0dba4d8304a6 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -170,7 +170,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 
 /* Flush the given page (huge or not) of guest memory. */
 static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
-- 
2.39.1.456.gfc5497dd1b-goog

