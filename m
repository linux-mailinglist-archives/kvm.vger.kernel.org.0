Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDA47CB65D
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 00:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbjJPWMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 18:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbjJPWMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 18:12:53 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6A6118
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 15:12:37 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a88f9a1cf7so14038877b3.3
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 15:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697494352; x=1698099152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nlOFJVJKwCyOkTDzXzl1CakzMdWMCCz61hy0Fckv7a0=;
        b=c+fI5AxD4Qwb5yWCmYwzoZP7RRznGQWlW9Q7YF/2gOkPpohO25Nh1NAg6Fces9ULCZ
         0DHqsKMJPV/OiH57W0yU6rJIIXt8jHJ0v0ML5bMOihK9jWjBUSkCuXqOtjRdmlFdU5wx
         4iBVGN+VPudjpWqGW0qN7BEOhuj/zfhfZmVFpBEYUujshVgjCqurYrtzKE0ST4D3gmWE
         mbnW3I9zjGm4e581TFPjBHH8uNejNfcsDxQAgXMa2Cv0C69AfPPbNNi9dxvW2fZ2mS02
         zbPrDAdxTY0UYeMBomOuSXDKpcYgRWnL02n9nUEkHenVCxSLMD7ZbiBNK8HvRR9m+W59
         aRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697494352; x=1698099152;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nlOFJVJKwCyOkTDzXzl1CakzMdWMCCz61hy0Fckv7a0=;
        b=kn9TjLdL2We4e0SvdFdF2FIcBE9ecXteUR4K4AbTSJ01ckf7i1RjsXEGgzdYpxGUc0
         uDv2qOrWMiUM7+5c75GIeIFo4exwKw6KERgKTHd5EFImsIc1ThELbebjpArtI4jFBf0n
         /cXMu6M7Dvz1VGvr3vLYqWcFcO4zbbg0Y5aL/spgjwRIXjfO346KVLbVWh0plTNL7Ve2
         rsCvPu/2pCRC0G3LaPC1TI6/OygJsLEQCMX6bMePepoUvWhSKhzJ2uQM1VVKr/NCca5s
         RIXjc+7XvWfpGSW7rV0slbrBQThQJKy+UxgoIV8XlG4HvDUFvDsa4K6GfV2bPr7vLUbx
         UxOw==
X-Gm-Message-State: AOJu0Yzz9jMG5EbitjW6IGYxjo6WH4jtB1kPrnADpeA31/sdt7VFDIOa
        x8lLe8v28OwiNWpz/OfoxhTraV0cSY17xA==
X-Google-Smtp-Source: AGHT+IE7ToMuPCIR8YUqMnrdGxYQ8AswL8Zg8VazLhyd9pZLFyfp9eFeOHb4cwbj6mO8GLaZhf2KNrz2ZcHNVg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:92d7:0:b0:59b:c811:a709 with SMTP id
 j206-20020a8192d7000000b0059bc811a709mr12156ywg.0.1697494352441; Mon, 16 Oct
 2023 15:12:32 -0700 (PDT)
Date:   Mon, 16 Oct 2023 15:12:28 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231016221228.1348318-1-dmatlack@google.com>
Subject: [PATCH] KVM: x86/mmu: Stop kicking vCPUs to sync the dirty log when
 PML is disabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop kicking vCPUs in kvm_arch_sync_dirty_log() when PML is disabled.
Kicking vCPUs when PML is disabled serves no purpose and could
negatively impact guest performance.

This restores KVM's behavior to prior to 5.12 commit a018eba53870 ("KVM:
x86: Move MMU's PML logic to common code"), which replaced a
static_call_cond(kvm_x86_flush_log_dirty) with unconditional calls to
kvm_vcpu_kick().

Fixes: a018eba53870 ("KVM: x86: Move MMU's PML logic to common code")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 41cce5031126..af97de19b2ce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6259,6 +6259,9 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
+	if (!kvm_x86_ops.cpu_dirty_log_size)
+		return;
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vcpu_kick(vcpu);
 }

base-commit: ba8c993c3748931a307648616f68892bcb6afe28
-- 
2.42.0.655.g421f12c284-goog

