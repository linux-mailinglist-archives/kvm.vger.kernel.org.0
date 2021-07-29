Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B843DAA4C
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 19:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhG2RdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 13:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhG2RdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 13:33:14 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC67DC061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:11 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id 6-20020a9219060000b029020c886c9370so3620371ilz.10
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IUAgcYkag1NiPbd+mXPBp8dXhawZvssq6Di9/a5YdLs=;
        b=GcOvMPEco+eux+TmDoYNsRaaOejWHLKAyRrwnBDwpSWtWzdC3rb14kIaDHm4syKLMK
         qXpAS1QSEElGa94JfIQpOyRCxjpe0mjk+mNeYAGo7OyovEgl9KUcGpkJPosJehcAyImT
         jzyDL04kGtj5rXStK0zK5McqYUmmhAdyECOI4TUOLO+/fJkqPw+i8vwZbjUOomTjaTqL
         jfCdpazBqyUX6EtCP9E2ys1mw1UKorwDidMcGEjCT+TYgGWDxp03K1odafHQZSDmcV7a
         7/ygLTaB7DmiZ0Ej/nB4laIVF7A/obg/6X7U/MlFhQ0ZaW0nXWPc3hNblWvvT9vlJ8Fi
         VnzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IUAgcYkag1NiPbd+mXPBp8dXhawZvssq6Di9/a5YdLs=;
        b=L5JJAvivNx9Vt/n5HyjzdPb8bSHtVtXupQqfObMa8rRqE/awwy2efCCfJNcIgZ+oYK
         c4Qgi8vcgXGV3o0FQtw0kw369AleHl7fQ14xNM+rt0pCpUZvrUYQrAv9a/rO5+CwKEZY
         D/Nwq1y1mC4Yz6HIr65kIdWac21YgK9DpwM/Ya7kfIVsVv+Q6OVhwk7yvOV1O8uaDgWN
         ee/OeipCu73uzi0ry6cWOt0Dk7c862B1toXOizSO8O95FxnR/8YAaunQze/WDdOo8Lm7
         12LrLseX14TuNLJ751rl65UxNE7rFYD70zPfD2/w7AY397fHMLsWOVUnlKWXtcjf52ND
         eEmA==
X-Gm-Message-State: AOAM533a69lnQ5SgzE80Di/fW3IjeURTtcVVOlIaEej8OOsmmmnyrKBA
        wzs/nWXpgNHNLN6c7lLng4v4hI1qa7N4WJkPPm+vLr7IBWn9iputFcVPbfdfaFV8ZygZ2q5jUFp
        LcYzcqAblxw5lRfvmYVquq+Qn9njk7e0MR0GqiWhjCsyRWUhRuDC7QSoRgg==
X-Google-Smtp-Source: ABdhPJzIHqarJsPcoFboJdKN+I7p7vL8Y7lSuDHscPZ9OrPx+91TExRbaZTvtuFOYzlAOgkLx+TgjWZrPtc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:a1c8:: with SMTP id o8mr5321340jah.50.1627579990995;
 Thu, 29 Jul 2021 10:33:10 -0700 (PDT)
Date:   Thu, 29 Jul 2021 17:32:54 +0000
In-Reply-To: <20210729173300.181775-1-oupton@google.com>
Message-Id: <20210729173300.181775-8-oupton@google.com>
Mime-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v5 07/13] selftests: KVM: Add helpers for vCPU device attributes
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vCPU file descriptors are abstracted away from test code in KVM
selftests, meaning that tests cannot directly access a vCPU's device
attributes. Add helpers that tests can use to get at vCPU device
attributes.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  9 +++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 38 +++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a8ac5d52e17b..1b3ef5757819 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -240,6 +240,15 @@ int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		      void *val, bool write);
 
+int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr);
+int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			 uint64_t attr);
+int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr, void *val, bool write);
+int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			 uint64_t attr, void *val, bool write);
+
 const char *exit_reason_str(unsigned int exit_reason);
 
 void virt_pgd_alloc(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0ffc2d39c80d..0fe66ca6139a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2040,6 +2040,44 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 	return ret;
 }
 
+int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
+
+	return _kvm_device_check_attr(vcpu->fd, group, attr);
+}
+
+int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+				 uint64_t attr)
+{
+	int ret = _vcpu_has_device_attr(vm, vcpuid, group, attr);
+
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	return ret;
+}
+
+int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			     uint64_t attr, void *val, bool write)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
+
+	return _kvm_device_access(vcpu->fd, group, attr, val, write);
+}
+
+int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			    uint64_t attr, void *val, bool write)
+{
+	int ret = _vcpu_access_device_attr(vm, vcpuid, group, attr, val, write);
+
+	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	return ret;
+}
+
 /*
  * VM Dump
  *
-- 
2.32.0.432.gabb21c7263-goog

