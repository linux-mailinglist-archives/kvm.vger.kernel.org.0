Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7D3774F26
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjHHXOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjHHXNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:13:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295DF1FCA
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:13:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d4df4a2c5dcso4105646276.2
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536426; x=1692141226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Py+nSHfjFpCHBtL754s2ZDTBxkx7EXVyuksTqbxeHnc=;
        b=Oobg/4/cdAOs54dQe4pnW/zbnaNBnlVLOanu5KZLTomKfQ+83/vesNasPXZkLytB/U
         yYuKOE66BlODpHN9VhrFvp9Li0ev2MyXeTQUiPUTJXSqU/0hjP6ffhaAu0DG8ceB9nRE
         7OEcsCUnawXNgnypHlVh6Ec+JBvBdbe6XhVEonXZ+4qbC9GAWgGFzjJ3qRCswmvnVSma
         K5WwlTP0idKzpgOBSRweJG4IFK7UjuzmMKGp5q7vQRUWRszUZlz518kqL6rhealjSgNW
         mURZVtnykI4uxjQF/p6Pbnppkymu8J5PbIwCL6iiQiL/zSW8l5u4ktomsh5R1SKCNTJU
         7Yaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536426; x=1692141226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Py+nSHfjFpCHBtL754s2ZDTBxkx7EXVyuksTqbxeHnc=;
        b=U5q383O0ujHnfp1Ipmk+bP3ySHIMGTnpZb4gRxOvIKSX6NRxp2dwoKI63mEkzX+CWy
         bpGol/4Gn/tzUg/uLLntXoqB6rGHINXcy2qimugWv+G6lmbila07yqAemP5f2MwwVyus
         qMVRRlgPjqK0zTpofsrj6bvt9lSc6XQJ7yanqFpjwQhLSDqeUi0LwbJ9B5SypYAeomJ9
         qR71R7YCg17AQ7CDmtpSRfKjQQ+qCtHGsLh1gMGFen9NKblZOKYmLLCUpBa6v5ssqAWq
         FIXZ/ogm03GLAV6uobpkAreBsLpHIxoGf3n3P1f5lFRiI8vaUu+HjN5InwuzhWhQ9bqI
         2GZw==
X-Gm-Message-State: AOJu0YzSYpKgfXXWBAtQz08oipKdE57fHoJ0DGYYQeAddQDpoNCZy3nh
        Bnnoc/nDbExh3ASvlr7xcfq+aWYb4Tk5
X-Google-Smtp-Source: AGHT+IFrEavsUv9CvI5rpWtoTRkTdNCW4hRKDt4k4H2kyQ7TTHO7qYga0LwAZMMkm4LGrdXgqeyzUr1J01Xw
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6902:1788:b0:d45:1b81:1154 with SMTP
 id ca8-20020a056902178800b00d451b811154mr21434ybb.2.1691536426494; Tue, 08
 Aug 2023 16:13:46 -0700 (PDT)
Date:   Tue,  8 Aug 2023 23:13:27 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-12-rananta@google.com>
Subject: [PATCH v8 11/14] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
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
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
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

Implement kvm_arch_flush_remote_tlbs_range() for arm64
to invalidate the given range in the TLB.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/mmu.c              | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 20f2ba149c70c..8f2d99eaab036 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1113,6 +1113,8 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0ac721fa27f18..294078ce16349 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -172,6 +172,14 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+				      gfn_t gfn, u64 nr_pages)
+{
+	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
+				start_gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
+	return 0;
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
-- 
2.41.0.640.ga95def55d0-goog

