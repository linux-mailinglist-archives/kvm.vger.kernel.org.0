Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75E73D99F4
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 02:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhG2AKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 20:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbhG2AKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 20:10:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5104C0613D5
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d69-20020a25e6480000b02904f4a117bd74so4859710ybh.17
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IUAgcYkag1NiPbd+mXPBp8dXhawZvssq6Di9/a5YdLs=;
        b=UFPfkEt2Wiu+0I4qHuRT+SudB7u+R4uu6nTX+yPKUa1aH6dJA7RebzUf6cItvoxTw8
         nxQfL3904yX5Ymloa5LtlF9uDOtt2FGJXyn0/Xj3LdftI1gnRQwUciIRy2Criyw+QD58
         8FjtnQH0RQPgv77hB9nhLdSejcP3H6C1/dsB/PmJeQzmq45h3KdxsR7SUkRjonrP9Zwd
         TvKM2eu85IrzXh53daCNDnAb1ngxO8R7gaVuP12uNcsvvZh0kl6eJDvDGkMysphlLOuY
         BxhByiTs/W1Lf43OAXgt0fUhjrEUAfU8YJWaOxizbetXVxnRWnWigETxMR99sfmQ5H/g
         YQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IUAgcYkag1NiPbd+mXPBp8dXhawZvssq6Di9/a5YdLs=;
        b=caW0sZo1NJLdcuo2mCEmmGpDZnVI4BPXyp4azoCrqqsVfAzCgAvKuSkWTXbX+BNym0
         ouZGeOeiLIw6C1/FyPZLW8aiR0QHae61N7XEka/HiUE8qQi53xpAzqz0Qqoidw3Y7FSm
         Enx1vwsUQxDPqxVfY9NHJ5I6US6MeGZXEkzpSX3UiviDXWcgygIs/MUGAJoSgHjXTRxl
         ysBvNire9op1DZLXH1xLDMBD6d4UoXqRPIWyoY4OyDH4MFHBOPb2uUWiXKtGNpAgW/58
         OvZZZZXwp5cHPeF9uc10UAQQxYKsEOcNlwz3sMzYZrxrvZ95wcfgXT8vmDOK4/UMnfXA
         PPEA==
X-Gm-Message-State: AOAM530dlZZjLlhwk394BPVhKyNMUANG6zb09xggdDmdF9LR7+nBRV9o
        ypq+yAl9e+4Hq2iSvne1/LrbopWxQXStB547K5P8ERgg25ND+yG2rHKD6tmUbcdPNIUksFzgW+R
        zlTCgY3Nhmr5F2gXLtQImdolFw7/qc4hlc8tBonbIFze+cGg8R2YrPvzdiA==
X-Google-Smtp-Source: ABdhPJwQrrrfQJGqhb5/fUcliWc42ytbyzvsoA7Gc/SMvqHBRfXEhx/woyJjI1XZIgpXTcBJLyECPgAvLrI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:9d0f:: with SMTP id i15mr3056274ybp.311.1627517428919;
 Wed, 28 Jul 2021 17:10:28 -0700 (PDT)
Date:   Thu, 29 Jul 2021 00:10:06 +0000
In-Reply-To: <20210729001012.70394-1-oupton@google.com>
Message-Id: <20210729001012.70394-8-oupton@google.com>
Mime-Version: 1.0
References: <20210729001012.70394-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v4 07/13] selftests: KVM: Add helpers for vCPU device attributes
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

