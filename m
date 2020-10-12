Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91F528C19F
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 21:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391474AbgJLTrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 15:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391409AbgJLTrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 15:47:41 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BD7C0613D1
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 12:47:40 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x42so4516655qta.13
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 12:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=1YrX9GUhgPQyMnYXJdhQSfkoDP0wFql3Dv1WNFSe/Xw=;
        b=RSsNxKiM/hry07GlwUJNzrS+Oewp4HhV5nB7BAY+iGeYZbzsasxC6ID40o9GsJjaBY
         LsShF5wmqfpNT5B+aLbh8CGuSJdrYX6qPFADU4JEOto2lyfS5kN8yd+Coa8Z8zvJoqkv
         VeCnJCGXyHBBQUK3x6/ox9m6bgYSoFL/hUQFqwQ2YuKTPY5mvoQh708lWRpm6rGEmDr3
         +6Y6EMn/U4d3pFPRmO23LoH7mKs/0F54LKliz9uCn7HwkEjRy9IyZ4tsW2P+u0fHsMY/
         ctKiFLcs6ZHdVrFfoJpw5vWZ0Y7Gg1IiWmEbwKwqMmwCtWtx8fVuFsk2KkGwf5sMkmkN
         1+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1YrX9GUhgPQyMnYXJdhQSfkoDP0wFql3Dv1WNFSe/Xw=;
        b=IJgjk+/GXa8U9Q1x6eQMVWgEfY1PI5niPTamRR5fI4s8E7VNhbxFoJeJEGH0q/fzJd
         R5clTtBGgJFp8ST0lhSmHye5F6AX5djCqGZiudVJAKBKkaKQmw8JneIVhcM1/o4XETWW
         LOZrT3h5lBNeBZuaDlacsTjMKHh0C3LoDHTOsqOd0uRzUW3AQ+pjE52JY71ke2U6ZhmR
         QPoggm1wQ1ZFMJ83tvZjizcB0OiFlPwP8U6a4yW4cmd1xYklXnQmEvfq+bux9qA4HP4H
         wVJ1CBqS2Hf4HqiYxO7K8dVnNjT487aw/SK0wYmTd5Bu+TfDm21vd4wFKGu4dQBmdt0v
         po4w==
X-Gm-Message-State: AOAM533MDekXYOJ66bsz3D10m7NVmYbNS+4xX+49HQ8iNlu14MwFHZpG
        BVIH2Z7DmY4I/D6ZoS0otEC97DT5lZN+bQB0
X-Google-Smtp-Source: ABdhPJyiDH6WELvU1C4u5vLw49fcAiLkW/O9LDaVpdUboCjQpNJep0+RXXKVtvhkq1Lj+fPJLGHieWmq/iV1Q1J4
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:ad4:5387:: with SMTP id
 i7mr26166682qvv.43.1602532060003; Mon, 12 Oct 2020 12:47:40 -0700 (PDT)
Date:   Mon, 12 Oct 2020 12:47:14 -0700
In-Reply-To: <20201012194716.3950330-1-aaronlewis@google.com>
Message-Id: <20201012194716.3950330-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20201012194716.3950330-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v3 2/4] selftests: kvm: Clear uc so UCALL_NONE is being
 properly reported
From:   Aaron Lewis <aaronlewis@google.com>
To:     graf@amazon.com
Cc:     pshier@google.com, jmattson@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure the out value 'uc' in get_ucall() is properly reporting
UCALL_NONE if the call fails.  The return value will be correctly
reported, however, the out parameter 'uc' will not be.  Clear the struct
to ensure the correct value is being reported in the out parameter.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 tools/testing/selftests/kvm/lib/aarch64/ucall.c | 3 +++
 tools/testing/selftests/kvm/lib/s390x/ucall.c   | 3 +++
 tools/testing/selftests/kvm/lib/x86_64/ucall.c  | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index c8e0ec20d3bf..2f37b90ee1a9 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -94,6 +94,9 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
 	struct kvm_run *run = vcpu_state(vm, vcpu_id);
 	struct ucall ucall = {};
 
+	if (uc)
+		memset(uc, 0, sizeof(*uc));
+
 	if (run->exit_reason == KVM_EXIT_MMIO &&
 	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
 		vm_vaddr_t gva;
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index fd589dc9bfab..9d3b0f15249a 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -38,6 +38,9 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
 	struct kvm_run *run = vcpu_state(vm, vcpu_id);
 	struct ucall ucall = {};
 
+	if (uc)
+		memset(uc, 0, sizeof(*uc));
+
 	if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
 	    run->s390_sieic.icptcode == 4 &&
 	    (run->s390_sieic.ipa >> 8) == 0x83 &&    /* 0x83 means DIAGNOSE */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index da4d89ad5419..a3489973e290 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -40,6 +40,9 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
 	struct kvm_run *run = vcpu_state(vm, vcpu_id);
 	struct ucall ucall = {};
 
+	if (uc)
+		memset(uc, 0, sizeof(*uc));
+
 	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
 		struct kvm_regs regs;
 
-- 
2.28.0.1011.ga647a8990f-goog

