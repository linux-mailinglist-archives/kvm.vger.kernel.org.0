Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDAF40EA73
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345746AbhIPS6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343779AbhIPS5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:32 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67853C04A15E
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:03 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id k9-20020a05620a138900b003d59b580010so44719011qki.18
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Lf2+OEFIK0DZ90wJh7r/ap0DRDUXtW/FHZQIxM7aCWs=;
        b=OITDpvH3x47XxN6kO7/uIZZCcH87kVGWV1zze6CTqPoC0xc4xzgliRMfE64m3NEX80
         GyZZzBRKHNvNwBUtA3psK6dCbAuZ1BPrC9Wl2EWblOPhm668jYBsUxNbsVUsjiClpMeZ
         +WrBoG3O8UkRRbPERQzyEgpYKao6TIIMlfW0ZGJ6+BM90PftlP56VjGG9pKDpLOKQQJd
         Z2VxMBz+6AgHeLgz02agykPsLNoqzY10MBYH3VaJMvVjlhRDnGu0MeAkDbiPZtbf3XJa
         +eaCwjBjdsslhdJdRm5WurKJGa0hwRKdBFY6f2bdC0scVg+Suflb4TP7jvFPzQD3DFys
         ssew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Lf2+OEFIK0DZ90wJh7r/ap0DRDUXtW/FHZQIxM7aCWs=;
        b=KiJ06IpGAET4D853lS1DrBEosBSDuq22rbIjunn4IFROemdY0kCEC9SYy7tQ/qrnZM
         +qqSUkqEY89NJB0ksKwzQl7/tIjOxSqOFGrBwg2vHLYaRoWKG9G/2EQquzmwfPN9a18M
         ZtMMuK6BjHGyEuPPkbQhoQthgsTa9tOHUy2cMol3Qcid3GGfjQVSqQCet5xOxNoqwWCX
         Kpcv0AOH1gEJ+a6NMS9LilhHkOUHCmM1kd55GFCbejYeatS+JbBMhJS7VZ0Fb+8GS79l
         EzrMDgPYx9Mhvnb2JOQkZQ5TgTq+PhVkaMSCAcIxYb5IHE93oDbUMI0+nexNS6pb1AXa
         cEJA==
X-Gm-Message-State: AOAM531hxb+TKlH4NGejfHhyW5YxBJdpLcekwueyNL/0dAZxuUNgWjXG
        mGfUvTnl+qL/75hh17NDluTpTO2eQtFZ2BfkdGOAV+vPGGgXmtDvTOsavuwuUL3JucdAsqF9wD9
        77BIKDEB4dvaX9QcsQ/hQADJJBzbgtrwufrCt/mVFlUguFpe8B8DocJMiww==
X-Google-Smtp-Source: ABdhPJwYPmdbsJ31AQtWH9mTug2gOZOVdIfRujXipfU/0mTRAqDcQpmUVVXp1iBNavHQTcnnUliFBYKJ7Mc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:1444:: with SMTP id
 b4mr6740209qvy.33.1631816162488; Thu, 16 Sep 2021 11:16:02 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:50 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-5-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 4/9] selftests: KVM: Add helpers for vCPU device attributes
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
2.33.0.464.g1972c5931b-goog

