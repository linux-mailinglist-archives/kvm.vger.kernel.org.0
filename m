Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A41773E25
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 18:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjHHQ0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 12:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjHHQY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 12:24:56 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9734680;
        Tue,  8 Aug 2023 08:50:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-686f38692b3so5758422b3a.2;
        Tue, 08 Aug 2023 08:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691509814; x=1692114614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=spb37hPxHiQ6VKeG6FvbJMaAIA7hEyup+mU7mymo2x0=;
        b=PcpyrqKOijHUgVigXsYO3nXKoVP7VhrfEf8GkIjKZJA3seCPgSPaaZeqUt6Hx5kKdl
         ArHGqLj0DJPYTrHY5+2NihzAbO0DLpUe8CUzM4Pwh7/epK0YVgcc0coQjw59cY6DGUY5
         VfwxvUP3xmwAEF7Xh9z3YmNjuPAutYcerIkoVYSa9yZ0Q21j+u1hVo9WNTbdqh1IhCPz
         x9cnu8ydPo28b7b9SSF7rW4s4Oc2YelGo/yts2jWG+W86rO5Z+T6X0NvAxd0GfdkZs2i
         L6Wt8+CTrKNld7gN8Sxrn0nlDiG/opU3Elj9BAIphPiQ86EDlMtcmOVvZ2z4oLK9rmon
         xNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691509814; x=1692114614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=spb37hPxHiQ6VKeG6FvbJMaAIA7hEyup+mU7mymo2x0=;
        b=mA/9lNek9hpsVLDaXbP7omTp6eyCae70oMRkG3O0LIOR+onOGdvZC/HsCtr8HQ+BiK
         CFg2CKB/Td8kWVf+1Tfe0sbo6t46/PYGzI5iOy8xYtvSPyrVn3SEIoqiprxSKi0KYQq+
         dmZz+IZbjOoNXiP1TOziDXzXOOt5b3QT7N13IGoFyrJy5775oaYYkJBxavbAQ4d6IpnS
         rTMixFv+INQyjfUIjYyphV95EVYA0a3gMiP2v1ucyPVAsCDje/df6TS4r2JEh3LvfgDe
         nDdQ3f5REWSAKwbpV9S/HRl3sfmqLcvmQSrPgpscmL0YZeEYBunfwYWCq+TxYzLWiIwE
         vrGg==
X-Gm-Message-State: AOJu0Yw26lkt3rp5jV3Sy4jUg1NRcRRzJupe4E2bCg3MuDIaOOt8tNaH
        QhRJ2VRtAqkK99vLxwyJun7leFTgO/CuJyja
X-Google-Smtp-Source: AGHT+IGQNx+wOVRBlSfz+B2zl7HuSCAJuDZ2SdWOcpEtn8lhGBAFG0smFutJem3kpV7MpREXc6wlDQ==
X-Received: by 2002:a05:6a00:c89:b0:668:8b43:8ded with SMTP id a9-20020a056a000c8900b006688b438dedmr17353836pfv.26.1691494825613;
        Tue, 08 Aug 2023 04:40:25 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e16-20020a62ee10000000b00686f0133b49sm7868558pfi.63.2023.08.08.04.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 04:40:24 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Remove unused "const u8 *new" for kvm_mmu_track_write()
Date:   Tue,  8 Aug 2023 19:40:06 +0800
Message-ID: <20230808114006.73970-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The incoming parameter @new has not been required since commit 0e0fee5c539b
("kvm: mmu: Fix race in emulated page table writes"). And the callback
kvmgt_page_track_write() registered by KVMGT still formally consumes it.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/mmu.h            | 3 +--
 arch/x86/kvm/mmu/mmu.c        | 3 +--
 arch/x86/kvm/mmu/page_track.h | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 253fb2093d5d..27531ce6b739 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -121,8 +121,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
-void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			 int bytes);
+void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes);
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9e4cd8b4a202..d742fae074c1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5638,8 +5638,7 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 	return spte;
 }
 
-void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			 int bytes)
+void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *sp;
diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
index 62f98c6c5af3..ea5dfd53b5c4 100644
--- a/arch/x86/kvm/mmu/page_track.h
+++ b/arch/x86/kvm/mmu/page_track.h
@@ -52,7 +52,7 @@ static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 {
 	__kvm_page_track_write(vcpu->kvm, gpa, new, bytes);
 
-	kvm_mmu_track_write(vcpu, gpa, new, bytes);
+	kvm_mmu_track_write(vcpu, gpa, bytes);
 }
 
 #endif /* __KVM_X86_PAGE_TRACK_H */

base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 
2.41.0

