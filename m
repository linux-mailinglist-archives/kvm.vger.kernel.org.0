Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2F4768FB6
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 10:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbjGaIMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 04:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjGaIL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 04:11:56 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5B710DD;
        Mon, 31 Jul 2023 01:08:21 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 71dfb90a1353d-48651709fa5so1330047e0c.1;
        Mon, 31 Jul 2023 01:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690790900; x=1691395700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FKkqGPurpa2QsGpfBoKL8nVGiAlS2IV7agqK5BJUOfg=;
        b=k38sp1FMAN8WRbhTcW8fgQnUaJCQyzuuQ8ydgegW6F1R553bfg3LrAXR+gtuAaMMNq
         hO5o9jgCoIdqp+eFRniJoFqtrD0GWJOGg5iAEUyN2hELt8rvYGicpoe6nUWwfofB1Lo3
         Nh1A7i1NQ+ZH2GJBjHYa119xqVlP0yM4w0cAEx1ja1GULspD9ooy7g8Q8q9IEJmRH27O
         sorKz38ma8Lcn3JkyKq+MmmCvdeqLaGgE+XYETBJYAfp3J6zaeEte0NlkRk9rkkv3j+V
         NvtBXkwmy5abwwW8wHPrxMkha0VQFAT+6zfJnRj9hgY8U+/pF8iMcPGxSLaO7MsBaW4g
         2Pnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690790900; x=1691395700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FKkqGPurpa2QsGpfBoKL8nVGiAlS2IV7agqK5BJUOfg=;
        b=l58J2PW8JbfgnXEl9+/budlQ8YbTYRYWWpD0g/ynUUl2zhOi4yTssCAex7uyPVLwSG
         2NC6bx71BAGg6sgu7KNMDZeJkQvbhLTvTClivxRCdOCoRuAI03msmdaQLgzHc7SVPSd9
         TWOdgIv1CTWivn1pqtsuLzL64KUYWiIqfkoltRlV54HE5y4OAfMn1LwdT1Xu4QKANxSj
         gmXm+IOluzcfbtY2BObAkyDXv0746SX1y4C/IWcEFuJ4uTZKUqQ3EZ9IjhQbjxpg6G4y
         rSsuhkARXzMxsrYGh2QY9FR2UwjDH3U7RIcQN5NciHcu1iXDfcobnqqVLCLRCLQYtQDz
         8n9g==
X-Gm-Message-State: ABy/qLaKgU0GISvLu+sxe7RXg4Uvq9L15hds6l6eGlJh6Xlm0E7eK/9B
        IyMcpJBN2ZW+eOmZsOfOn0jUhOL/k0zav9qM
X-Google-Smtp-Source: APBJJlFxX7mhAF99t3hyyJiWWSTMq8Qgbdc992j4HYR2W6llKKMSri4SgYSUhIakbVr4QTm2151ORQ==
X-Received: by 2002:a1f:5443:0:b0:486:4867:2363 with SMTP id i64-20020a1f5443000000b0048648672363mr4126459vkb.5.1690790900398;
        Mon, 31 Jul 2023 01:08:20 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n15-20020a170902d2cf00b001b54a88e6adsm7853304plc.309.2023.07.31.01.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 01:08:18 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] KVM: x86/tsc: Don't sync user changes to TSC with KVM-initiated change
Date:   Mon, 31 Jul 2023 16:07:58 +0800
Message-ID: <20230731080758.29482-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add kvm->arch.user_changed_tsc to avoid synchronizing user changes to
the TSC with the KVM-initiated change in kvm_arch_vcpu_postcreate() by
conditioning this mess on userspace having written the TSC at least
once already.

Here lies UAPI baggage: user-initiated TSC write with a small delta
(1 second) of virtual cycle time against real time is interpreted as an
attempt to synchronize the CPU. In such a scenario, the vcpu's tsc_offset
is not configured as expected, resulting in significant guest service
response latency, which is observed in our production environment.

Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Original-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
V2 -> V3 Changelog:
- Use the kvm->arch.user_changed_tsc proposal; (Oliver & Paolo)
V2: https://lore.kernel.org/kvm/20230724073516.45394-1-likexu@tencent.com/

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 23 ++++++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38d..e8d423ef1474 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1303,6 +1303,7 @@ struct kvm_arch {
 	u64 cur_tsc_offset;
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
+	bool user_changed_tsc;
 
 	u32 default_tsc_khz;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 278dbd37dab2..eeaf4ad9174d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2713,7 +2713,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm_track_tsc_matching(vcpu);
 }
 
-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data, bool user_initiated)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
@@ -2734,20 +2734,29 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 			 * kvm_clock stable after CPU hotplug
 			 */
 			synchronizing = true;
-		} else {
+		} else if (kvm->arch.user_changed_tsc) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
 			/*
-			 * Special case: TSC write with a small delta (1 second)
-			 * of virtual cycle time against real time is
-			 * interpreted as an attempt to synchronize the CPU.
+			 * Here lies UAPI baggage: user-initiated TSC write with
+			 * a small delta (1 second) of virtual cycle time
+			 * against real time is interpreted as an attempt to
+			 * synchronize the CPU.
+			 *
+			 * Don't synchronize user changes to the TSC with the
+			 * KVM-initiated change in kvm_arch_vcpu_postcreate()
+			 * by conditioning this mess on userspace having
+			 * written the TSC at least once already.
 			 */
 			synchronizing = data < tsc_exp + tsc_hz &&
 					data + tsc_hz > tsc_exp;
 		}
 	}
 
+	if (user_initiated)
+		kvm->arch.user_changed_tsc = true;
+
 	/*
 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
 	 * TSC, we add elapsed time in this computation.  We could let the
@@ -3776,7 +3785,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_TSC:
 		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, data, true);
 		} else {
 			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
@@ -11950,7 +11959,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, 0, false);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */

base-commit: 5a7591176c47cce363c1eed704241e5d1c42c5a6
-- 
2.41.0

