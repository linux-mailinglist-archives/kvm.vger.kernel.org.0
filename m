Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1F83ECC0C
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhHPAN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbhHPAN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:13:27 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5632C061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:56 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id o5-20020a6bf8050000b02905b026202a6fso4528762ioh.21
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qqp/SiKQXNqb52XXOCheL4cR6htl4LO0kcJJeErQ0KM=;
        b=nV85gIhy5Mdy9FrQ4UM0C4NrSPFVkV71ujHfJ8rK8gp3QoY27qqM575XGRKe+58Vo2
         kcDC+dHLR7nkG5AVQdTUDca2fvIU1oUAbfEzIp0AAlP+WEGTD+pPoEyg9LJuklv9maAW
         RjsAIwwWh1y4qKsik7fUndJerBUoqxZc/d6HCtUjoCOSsDEub+WSTdzzLCAgK6LgfChf
         Dbbbam0nAMIpFzZjagiCPdWQjKm1rOUo5cUqL3Dy5eqUOxCMjo7f2AyBl+LaI+wAdni1
         lCyPnsv3btnqTsR4tpajBW19R23leqbTIGNT28fgUD2ryFhkLY8d51B6tbYnNYadBzSm
         s07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qqp/SiKQXNqb52XXOCheL4cR6htl4LO0kcJJeErQ0KM=;
        b=DJG+zoHZwylix1RLeaOubcUT/qhNCUWlSjnVqSwWlOJkY3dOe8oqp77oOvk2ig3sRY
         F26FtVopYOLDQfJnqsuIt4pHRpZaTQblOX4zvE3oD/OUJjoD8MNc0gEHNJRZYAfZAboH
         C/+Gdj7N0SWiy9BxbU8kIx9fKLk0hVwW7yZ8mG282K7gAKwqMagD05BVpiUzY8nnQaLQ
         bxmLeSHqn3WACDHvW+Udl+r7r3AjzcX9nBeKCFwR3w4smEPlTlLtJH9piWuhCuKGr2gL
         KRFR8ZPM9YTbtgLx7RkFX+ps46axz3oScG9BIBkTo2qu3NQ9/5fAm1o0iJugJ+YxdoTQ
         okVw==
X-Gm-Message-State: AOAM533DdpAJ+L0+AaswKD3ujysNYRXN3Vs8IuIxNhT84gG6HBnH3L8W
        AuFmAQmD2cx499/5qHuYUr6HEyVQ1p+1g+p86JzksnD+tF3/YgeKdiSZ5S52JDUhAsGrgZmpoJe
        7SUyaDw4Qx8hNqVfw14WHKZgGTeb02kRK3mBRCOwDcaGuXR5IOitpu000fQ==
X-Google-Smtp-Source: ABdhPJyPI7VnyfiX7cslqPDObv36x6Z1p0K9s6gygAZTtPKm2R0kUptF5KEoa2qPPVC4Q7CE4xo3WGA2Xus=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:cd89:: with SMTP id l9mr11939190jap.29.1629072776109;
 Sun, 15 Aug 2021 17:12:56 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:41 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-5-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 4/9] selftests: KVM: Add helpers for vCPU device attributes
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
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
2.33.0.rc1.237.g0d66db33f3-goog

