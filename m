Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F9C3CBE91
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 23:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbhGPV3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 17:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbhGPV3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 17:29:41 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EF2C06175F
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:46 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id w2-20020a056e0213e2b029020f555eb3c6so6190165ilj.1
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6oCR3RsSf0sSKA4Gfkr/K6wh2PtHCE6P4q0EDP+cPOQ=;
        b=B2erstsZ0I91t+mYldLmOLLel1G+aM6Ian9jvA3PqMUvLVVS+sQUUBXObAUf6cMj5+
         PRMGoz5VZCDt8kHkNkVJuACsxAUpJ08ID+Sk/jPDFJvNbbyh9ZXsC8GPQ85zmO2zvEWd
         fU3zD+0XbCXLKnIOik79V0+V3Sibe5nUe9kklumGK3Ngd+YNOK61XTYd53uVBqIBAURa
         zaoxgG4aKHqy87gunI/Sgx6CxgSIGDchWCp1LBYSvGuokfm1Iyy9TPr6UBaqHSewUQiZ
         6/Ojo/16j508dxgP7Ifs1hftC31nyoETYOTqWT9VRSc1pw4lXQZ35nt04bnpGOkN4517
         VYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6oCR3RsSf0sSKA4Gfkr/K6wh2PtHCE6P4q0EDP+cPOQ=;
        b=C9Ono7s/FtkWwdKLKV09uDAvo5hJIbTKgVdCs5M61n1LNSPUESQidRpg65b8gwMrau
         /g9gwRGXdn3ZPe2VPvQNvwUEhTUze67vbJS0HI5uMknabO1Xe/ok5g9e59AfpB7f7VrJ
         vTOlLgxWAEG19TjA8L0i0B2KAxron4dte/QRzh/nxjvUwdSS2Tw8IUaUECgawcCi1XGx
         DI+SfYOYOx1Priipqn6sbll0pXOh/uo/KukVGh8VOhsw9dRnq7WmbeRtsrpo+0y+bOmH
         mWfaNhJS9+QSd5U4RjdTH4s5yHPS6q+B7kOZiP1I69v/a9KrQMiFVU6vm2YKlb2mU/N8
         anIA==
X-Gm-Message-State: AOAM532ocmPdDU4NyujWD9kFoO/XeaneQsf0TGrFurQgTrrBQX2xIUss
        CWbl8uqsbsOsT8X/t36MLkDRUd8Ke+yjvVZzQPqCDBgCogLNjLUD+oplrsp82bS69SEiF0AYdLy
        SLmJUjtsbWdfRqa6Q987NRdT9nYXapwvh7gEz1MjFKf6KWviMGQ8NWgJ3Yw==
X-Google-Smtp-Source: ABdhPJzuRsqE96CDh/UoCvZS6h5E8FyCdDD/dtyia+XfzDZwxA6F3DGOMJ9OV+ka/8G2p263HmaPR1hXhIk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:24ce:: with SMTP id
 y14mr10410273jat.82.1626470805952; Fri, 16 Jul 2021 14:26:45 -0700 (PDT)
Date:   Fri, 16 Jul 2021 21:26:23 +0000
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Message-Id: <20210716212629.2232756-7-oupton@google.com>
Mime-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 06/12] selftests: KVM: Add helpers for vCPU device attributes
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
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vCPU file descriptors are abstracted away from test code in KVM
selftests, meaning that tests cannot directly access a vCPU's device
attributes. Add helpers that tests can use to get at vCPU device
attributes.

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
index 10a8ed691c66..b595e7dc3fc5 100644
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
2.32.0.402.g57bb445576-goog

