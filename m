Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D059288807
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 13:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388205AbgJILq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 07:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388183AbgJILq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 07:46:28 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AC8C0613D2
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 04:46:27 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id j4so5588210qvn.0
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 04:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=1YrX9GUhgPQyMnYXJdhQSfkoDP0wFql3Dv1WNFSe/Xw=;
        b=ZuxPmwRmW5rvtoRWLxaUGTGWzJCr7moaB2Q3cn1UIisgwPThDnITGbLa3BzoXRVjL4
         eTVO13dhfFSbOKq0TQMQ5H1IIoYJlA9fcTRSwdm7NeiPbuvg0+CFkDqXAXLy7IThRYWh
         5HzNeGPmCpJbyLxD18KqEZH9fXayFAR5vpj+f2mQ3Ded+FVrh1zvCpv1ErzvJjrSYDZ8
         Y0RlhZXfxWo8u3/1XIs0AzdSZsswFArETYpxVKZ+uDOnSncQIpJxRH7vTtmH3TQ/X4io
         yzQSsRqtCpZrZYPfNLI6WgleLJ1P2Qa9puXRYazkziKzXmD4b9nu94N4YhhUY2/GAULH
         KSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1YrX9GUhgPQyMnYXJdhQSfkoDP0wFql3Dv1WNFSe/Xw=;
        b=LAoYkVl5BZNcgkFPA+4uRddXlen2G57PwKwtGu819fdpLzsF7D4shzpJy3CPv81ywz
         bmYgHXyXq+u13UDsXHfUJZzdGsjeLJiCT3sfIZyPgdoNLCIJ4uO28ESK95uw9t+b4mJW
         dz1nVchCpSQ+KXYH7nAGVemroztmnuNyeh8FFc9rImvAFV1LV6HfZ2mdlkc7bKSlfC51
         oh1mP9yubhQjCmBhwn5rtK3zwsnlT1nNyOqGRFMJA0RS3a5V7fSh5rjrV9SwYnH0HjX4
         mbHX/axyCDwFKIOYjDgiSvV5uahVDa0KXcck5jqy2idr13ENkMWO/KmN9HHdtRTUIj7U
         0iYw==
X-Gm-Message-State: AOAM533/NA+OApSDW3DjFvzlyl8fkisyy45W7Obl82m/Yrj2+Xde1A8B
        bAOjVnxNUavG0mcTz9DlOYlerHtHxvOloXD4
X-Google-Smtp-Source: ABdhPJy67guDt/k0gTSUba2vRn3xnIyU+Mv3zQrSeC+kdwK1WIRT0n3ofkgpriH6r7nmXHkTjBjnH1sFKZ6seq6n
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a0c:b902:: with SMTP id
 u2mr11971100qvf.7.1602243986257; Fri, 09 Oct 2020 04:46:26 -0700 (PDT)
Date:   Fri,  9 Oct 2020 04:46:13 -0700
In-Reply-To: <20201009114615.2187411-1-aaronlewis@google.com>
Message-Id: <20201009114615.2187411-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20201009114615.2187411-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 2/4] selftests: kvm: Clear uc so UCALL_NONE is being
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

