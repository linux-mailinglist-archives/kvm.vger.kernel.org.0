Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F2162CF61
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 01:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiKQARX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 19:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiKQARV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 19:17:21 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B90B2F3AE
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:17:20 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-38e82825a64so3188447b3.20
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U3IZKsuc9ltcu/+mzZPVDH2wCFVrb8m8TbR4/5Q4IxQ=;
        b=e2V4cbt4u5l2kNBLhooZVsqCFE5v27Z6ryzHyE+M91aNsWiuaElXPm7WioBQtC1Vh7
         mPqyYcevdiSyjJMXWuLugDRibJATiyj08fes9IoxtHGh59+Vmtuyo1ocAmI/qhLZMUnB
         v02Fh9hUjGrulCiC2J7Zt87EnPT7ngftCq01aTaNUsACRjEeqaDJBKeZ6HDCTl6fGtex
         lgmIY84qMojRjDQjkL9lPx1JGIPUJgHIv1fs6gI47E0T5S82mQ8RGvoJlEeqISWxor5/
         HXJQuYGduqI3rxDNA3fWuwKkG4y3VvVGLAIzqsmKbbQqamNE67rH+uBEj8L0DYykkzfz
         quzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3IZKsuc9ltcu/+mzZPVDH2wCFVrb8m8TbR4/5Q4IxQ=;
        b=r1LG5HICEHHc01++xUOPs/T4avV7WsHZ4uB+t3XSUBr6cH4H7613MDh0JyBfflFoZq
         AOvZktve0Hhj4ETzkS5eMR45tnHUZSbY9MAfY3AksAuLavlj5+xjc+DxrdmW+9XwQ266
         LIz4gr+jBuDda/EZ8ERDOohMgKwx9gMnpiUELT3gYrV3PyY5/ScXZ7lpYDdLxFAUrfYu
         UadUae0OCPlHHgjzQfzRXqIjyENmHmMkCbpMW4jOU5au03FCYm4ObOxirAOhMm7n7u5r
         4Uk2jqPaQERVrrIes5kvtXJFYZrY+iEnkrV4OdXzLM016FBV9QyuFmV+5WRDnk6vLyWd
         jOfQ==
X-Gm-Message-State: ANoB5pnFPCaZOBuUnkd8eLKCKvLxfcLIEbxuRc7AzhIscLQLMTTThSZf
        2R50G6CKDVbjUwrtqUQAspqS5bSzEYsuZw==
X-Google-Smtp-Source: AA0mqf6WMSuYmOr8jFkt8gMx2bE+5LbrR0NtVlbmjlhMcSBTdQs4tqaWrQ/Sl4mljDdytvI5WLVAS2tjLyPUGw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:bb90:0:b0:6da:633f:20a with SMTP id
 y16-20020a25bb90000000b006da633f020amr106642ybg.363.1668644239483; Wed, 16
 Nov 2022 16:17:19 -0800 (PST)
Date:   Wed, 16 Nov 2022 16:16:56 -0800
In-Reply-To: <20221117001657.1067231-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221117001657.1067231-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117001657.1067231-3-dmatlack@google.com>
Subject: [RFC PATCH 2/3] KVM: Avoid re-reading kvm->max_halt_poll_ns during halt-polling
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Yanan Wang <wangyanan55@huawei.com>
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

Avoid re-reading kvm->max_halt_poll_ns multiple times during
halt-polling except when it is explicitly useful, e.g. to check if the
max time changed across a halt. kvm->max_halt_poll_ns can be changed at
any time by userspace via KVM_CAP_HALT_POLL.

This bug is unlikely to cause any serious side-effects. In the worst
case one halt polls for shorter or longer than it should, and then is
fixed up on the next halt. Furthmore, this is still possible since
kvm->max_halt_poll_ns are not synchronized with halts.

Fixes: acd05785e48c ("kvm: add capability for halt polling")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4b868f33c45d..78caf19608eb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3488,6 +3488,11 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 	}
 }
 
+static unsigned int kvm_vcpu_max_halt_poll_ns(struct kvm_vcpu *vcpu)
+{
+	return READ_ONCE(vcpu->kvm->max_halt_poll_ns);
+}
+
 /*
  * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  If halt
  * polling is enabled, busy wait for a short time before blocking to avoid the
@@ -3496,14 +3501,15 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
  */
 void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
+	unsigned int max_halt_poll_ns = kvm_vcpu_max_halt_poll_ns(vcpu);
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	ktime_t start, cur, poll_end;
 	bool waited = false;
 	bool do_halt_poll;
 	u64 halt_ns;
 
-	if (vcpu->halt_poll_ns > vcpu->kvm->max_halt_poll_ns)
-		vcpu->halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
+	if (vcpu->halt_poll_ns > max_halt_poll_ns)
+		vcpu->halt_poll_ns = max_halt_poll_ns;
 
 	do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
 
@@ -3545,18 +3551,21 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 		update_halt_poll_stats(vcpu, start, poll_end, !waited);
 
 	if (halt_poll_allowed) {
+		/* Recompute the max halt poll time in case it changed. */
+		max_halt_poll_ns = kvm_vcpu_max_halt_poll_ns(vcpu);
+
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
-		} else if (vcpu->kvm->max_halt_poll_ns) {
+		} else if (max_halt_poll_ns) {
 			if (halt_ns <= vcpu->halt_poll_ns)
 				;
 			/* we had a long block, shrink polling */
 			else if (vcpu->halt_poll_ns &&
-				 halt_ns > vcpu->kvm->max_halt_poll_ns)
+				 halt_ns > max_halt_poll_ns)
 				shrink_halt_poll_ns(vcpu);
 			/* we had a short halt and our poll time is too small */
-			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
-				 halt_ns < vcpu->kvm->max_halt_poll_ns)
+			else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
+				 halt_ns < max_halt_poll_ns)
 				grow_halt_poll_ns(vcpu);
 		} else {
 			vcpu->halt_poll_ns = 0;
-- 
2.38.1.431.g37b22c650d-goog

