Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B766285398
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 23:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgJFVE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 17:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbgJFVE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 17:04:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3C1C0613D2
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 14:04:57 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r1so2212338pjp.5
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 14:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2g0FNjfO6yfE/mjIhsnOQmRpOsnscxNvt2e3DaT6bSc=;
        b=H9TU8QIfg9Ak/995HMJSNRaP1Wqb5UHDmG1e5+bA0f6xmQEJk/XRFD/1frC07hIYKF
         yGNE/5vcEyZRj2GSOmIcjYwH/2MoygFLM2WXU5srqGNqJ1To3+uaBuNTBZ9DvNMHPbRL
         Wrug3tm+JTcx5AONPPiDSXB8C6yb0cac90/emNDPLRfNc4BMrLAPNJWK3NfNLw5BtRxF
         ipF+iEomHWlc4HCaTdzXebiHOI86+GPSncWQ6V7yfvrsiENv8zjQ0Csh8s/VHqqoE5QC
         oaYNKSsm51ebJL5bx3h2XomG0XkFKnpMPXxMOZom1KPrHHFuzb8I+YGt2Z/1vyzVuGZ8
         0w5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2g0FNjfO6yfE/mjIhsnOQmRpOsnscxNvt2e3DaT6bSc=;
        b=LTRVFtGHOkfj6MUhafwNbMjfgaz6tZSkGmxe/IaP9NG6vlSCmRTgHuO/o1YjxhS7ID
         nWsO2Qfx8lIPQcYdMqnQ56OJhe7Y0+4Hm9+ira2hnSqrqrQwNyrJL11MgtsQ9OkDZlK4
         GvYUQ4w5238qumTnj3OfF3Qnn5I7qn4osbTOgidVs/3yp1beBuDNDfA9l+ekG/EBrAAz
         YlxoAEXIxwkSLDMAuQAs/UtjboqJR1aB+MsAxM1vwdOVfLMJlER3CKdZ3Hne5XeSdFwq
         iscNM9iAFhNjNEcijJnWO36ljFQRUtn/pksiM4EHozvpRg5RamSNlBE85se9leiZxl4o
         3zgw==
X-Gm-Message-State: AOAM5303IqIZHxJaKHxTv7lqIYFLNgUbx1C0ekPSNuvtGmCDKEombzOM
        ceCo/P7hfuyLQVFSafI75ONSpCBS6i+3BMjH
X-Google-Smtp-Source: ABdhPJzkMGjN9YPB1VPMYFsGpWZdVETYtw6NT/76OZn/EvEE5dbvXIWET7DTocuih/eDi7+y5pr3/boN0UC/o4q3
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:7884:b029:d3:7817:ed58 with
 SMTP id q4-20020a1709027884b02900d37817ed58mr4949532pll.14.1602018297233;
 Tue, 06 Oct 2020 14:04:57 -0700 (PDT)
Date:   Tue,  6 Oct 2020 14:04:42 -0700
In-Reply-To: <20201006210444.1342641-1-aaronlewis@google.com>
Message-Id: <20201006210444.1342641-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20201006210444.1342641-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 2/4] selftests: kvm: Clear uc so UCALL_NONE is being properly reported
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
2.28.0.806.g8561365e88-goog

