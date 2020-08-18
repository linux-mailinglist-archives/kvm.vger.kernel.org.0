Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F064F248FFE
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgHRVQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgHRVQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3F1C061344
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:40 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z16so12846900pgh.21
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZSBC6QITtiUi5LbctpjtP20jvHvylt/vFtbjRxW3lKA=;
        b=JaFcduFUEIH38nUDDVH5eBBiiwBmWwU35h6k0zuGTA7OEz/RWXOixTjbF28+NwY8OV
         +HD2ouOEdcvymNbge7iZZbj3udW7elQqv5Dn5WS3C5xlc5USH9aUwuWW2qg1BHwhrMQs
         UDxbD4Y7YA7w0lHDgQ4WQja2wEhfQ+1uPQo6p+dSLRj1DU974BNl9sfuFMO4oO7ynq/C
         nwavp0Mz2lHUWBag/2PqCDEbvtHhxH6A41MfknncMlUv3Qblj3n/xbjjW/FQXjJrxeKx
         aT7pRGJcDj6xHOoVoYC3xjmxzIXe9NzzzgFa2w1kp16OYnw7rSzd5M/ExRmrj8ba9Ukb
         R3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZSBC6QITtiUi5LbctpjtP20jvHvylt/vFtbjRxW3lKA=;
        b=EOisI/l8vjW+R0b5wgl5bW3dx8jQYuxGr/Qqu3DQLH1Dgbdf1sWU7BfVRytBXkQVI6
         AbspkmXvieVpV7wta1ewGdXecY5F1LM7XDGJv4XMefGtUvqBq5yWdsLrr/bLJQoGKD3c
         i4ZxwR5YyNQxel/kx8jGzcKSPIGjWBJddOlTXgTXJcuAG5qaJCxRCY0gUsbOvvTa90W3
         KoFi4ySc+TbVTca4F1cbT76b313TLD3v9Tnp0jLv2+TNd8Dhzhy3/AwyxjiAC7fl0fIK
         RNjoM6N+aAVvLiI1WXgoTqo/vD7bfBlUhy//7Xfnh9nw1SUCCviRsAnPaZ+Tn0CdK6NJ
         Vl6w==
X-Gm-Message-State: AOAM533m9kacD7aNWmcr+trhJxQlAfzmi+pwgcgczjFmGW+jLGhnEQrQ
        pKDciejjjPm7MyzsBGb3KSqwIBfxYGEvhL6P
X-Google-Smtp-Source: ABdhPJzjfZO/VPzEJE0kYL7FGZ3pC41mJZoaR+oiW86MRF5ajeRSYP4UV5SrG8wD8ZarIEARmHQCtOiOKB1ydauY
X-Received: by 2002:a17:902:ed4a:: with SMTP id y10mr16829729plb.106.1597785399960;
 Tue, 18 Aug 2020 14:16:39 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:31 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-10-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 09/12] selftests: kvm: Clear uc so UCALL_NONE is being
 properly reported
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure the out value 'uc' in get_ucall() is properly reporting
UCALL_NONE if the call fails.  The return value will be correctly
reported, however, the out parameter 'uc' will not be.  Clear the struct
to ensure the correct value is being reported in the out parameter.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---

v2 -> v3

 - This commit is new to the series.  This was added to have the ucall changes
   separate from the exception handling changes and the addition of the test.
 - Added support on aarch64 and s390x as well.

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
2.28.0.220.ged08abb693-goog

