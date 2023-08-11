Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39E97786A9
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbjHKEvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjHKEvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:51:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8142D60
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:38 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58419550c3aso20135267b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729498; x=1692334298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FjqK2i9iNfdCdXxEpH6EmuQikOPCWBkIYlUFD/yGaDg=;
        b=r3i6w54chxe/m30aMtVSgvkKBw1KsUaf9mnPdfDF9T7G23UAZLBlzAbYwBcw+8/TEP
         TIXUprktoIJvbhghifoTokWKfb3fsWuJEGznw9UnxoxDzZASXjGptbwbxjCA6kWdWKbv
         1BXyNfas0RyElNo3kSpbNMxJzkQ5DV1JnViee3PvCsXKXzhyRRy66gQtf/gMlx6nPZLS
         W3ZvPJVBTfpDVbg4rpa+Yudvhp7wHsWOtEJhRLCCZ4ljXaPQ97jKH76YhbAKHzFA8haO
         RHWuu4Ft7sFeRAtPpG2uAYJ8O0PHxSXrSq3mACDc91bgObmkiHbVAYRiWp4aDtF5bXrr
         V1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729498; x=1692334298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FjqK2i9iNfdCdXxEpH6EmuQikOPCWBkIYlUFD/yGaDg=;
        b=D0Ye3VPZGZ8YwC9NPPwLwGJVJb9G8uytjRrDeWJa/lXNPfftnDkzuSgoL72Jt//Yq/
         yNCxZbox65sl7H1M4h+AkVt2VfwpjDqtWuZ1jYu+us41UuMYNXlZdwVpfxq6iNy6+PDo
         740nHcxuUYiIof4sqleO/Ql+L90ooCh6bqayokrI9wboviHLz4uj1LsF1cfgJLvRSLzU
         nKZvaAKOQtCiTH5Bc+ex8qxwUXJsVAA47Cpi9bZjBF4SIg7mThTGDPyxHJWfZB4oJAP4
         pQEaZA13DuYOhP2ZWv8SotdWl8Mbh4avJa/txWIwLPt++8VQIuzytzkiBzYZwG8fOQmM
         kmfw==
X-Gm-Message-State: AOJu0YxFNcDlmbKWUiM7Vvg4/ON3jPlCRpcIvLCy8DUiqxf1W27vNuF7
        9kfbT/MoByDulDA9zNrYW+WpW+u9OqaE
X-Google-Smtp-Source: AGHT+IGBvRwTUndHgAap/N4BT+dWrSJMB4+V6DQ3W4WJT35AoKaFobGrZSBaBrpjzeE8RCoth/jJXPL4hWmQ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:ae0e:0:b0:576:8cb6:62a9 with SMTP id
 m14-20020a81ae0e000000b005768cb662a9mr13062ywh.6.1691729497878; Thu, 10 Aug
 2023 21:51:37 -0700 (PDT)
Date:   Fri, 11 Aug 2023 04:51:15 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-3-rananta@google.com>
Subject: [PATCH v9 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no reason for the architectures to declare
kvm_arch_flush_remote_tlbs() in their own headers. Hence to
avoid this duplication, make the declaration global, leaving
the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
as needed.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/mips/include/asm/kvm_host.h | 1 -
 include/linux/kvm_host.h         | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 9b0ad8f3bf327..54a85f1d4f2c8 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -897,6 +897,5 @@ static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
-int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
 #endif /* __MIPS_KVM_HOST_H__ */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e3f968b38ae97..ade5d4500c2ce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	return -ENOTSUPP;
 }
+#else
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 #endif
 
 #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
-- 
2.41.0.640.ga95def55d0-goog

