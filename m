Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A283FA152
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 23:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhH0V71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 17:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhH0V7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 17:59:25 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12891C0613D9
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 14:58:36 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id k12-20020a05620a0b8c00b003d5c8646ec2so1618660qkh.20
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 14:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cnx8MV/iIdfnNKhivOjhJ2a0G3hLtk8JhdyLdiJTHU4=;
        b=LtCeEPuf1s00VFa7aOcMIfwN9jnd75qkZ9gzNqNQcwWEniYjs/3D83bO9UERdXmvO5
         oKO4gs34e+D0zEuC72QhnZ20J7YtfCJqOFD8TNukOsGZV3UDmxFtnw4ezBuz88Z9iSGx
         J44TeYACFHGC7svMAzgfZf4iXmRaJJr9ITLzBgtCKxN1i35WammzXpmheHhpsMCypyUB
         3t05X8MQx/o65j+lj6xtcFotBr8utSSOjLvAQGjMfGvGdSaeV3tw6xAh4LlZzayASEMf
         vPMlSXiIYMBgIZE7L0RqsKIN51viU0dZkXU6c92hws6Uk/kfRLXh2AKkeAqZ77olLufS
         wMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cnx8MV/iIdfnNKhivOjhJ2a0G3hLtk8JhdyLdiJTHU4=;
        b=Tx6IFg1hC4paMr5YugUhP/4qr1S/rf/jzXzsDhpDZUTUfILcOTj2DkqbwzS746lBZY
         CJm2KFYzAtc+4UCEd4PnW3V5cDSjz9Nsx7QPxvqFMrr4ZGO9EaIY9f2UuTvt1U2guSYY
         isCXxlVlopNJOurqWJagbEC/PBsc0DvSuD3f6dg9R0kOpW1KjFh+HxVBrgan5sV0h8Cf
         QAg148mHYTsbRmAWDPX3j6rGgvGJ619cpyPBWQ3W5NyYviim/gPbethKvrApvpX5tdMQ
         U35KKWc+IFBVYmn69jZ/GhXPW53BbqZ/koNLrCcLDTZGmgtbhvFMHXs/MdrkQw5gV8Sj
         CbEA==
X-Gm-Message-State: AOAM530ixESOwTernfiDTkPkhw+gn3iQnPQ8Ich9yNpfKMMIBiQcnlHW
        g6v7r5dsxr5qlCYjD8yi2wUXcZjcu9aIM58xCDKWTJ/rbJjJEL15GrdCdPu/Rc73SGk8oLkfS8T
        XwVyPI/S7GDo2A9hcczKUMUTaYwBJjZtCWrtPzza6+GU5LynEIQeyxvqFFw==
X-Google-Smtp-Source: ABdhPJxlN8oeb0z4aA4E8CXHbvnDa6MT2IGvjTVLccWcC0CvIbwsk0TsHuuWIaBNDYgrU4hQng0Vn3csM6U=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:1843:: with SMTP id
 d3mr12228530qvy.10.1630101515145; Fri, 27 Aug 2021 14:58:35 -0700 (PDT)
Date:   Fri, 27 Aug 2021 21:58:27 +0000
In-Reply-To: <20210827215827.3774670-1-oupton@google.com>
Message-Id: <20210827215827.3774670-3-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com> <20210827215827.3774670-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [RFC kvmtool PATCH 2/2] arm64: Add support for KVM_CAP_ARM_SYSTEM_SUSPEND
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>, reijiw@google.com,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM now allows a guest to issue the SYSTEM_SUSPEND PSCI call with buy-in
from the VMM. Opt in to the new capability and handle the
KVM_SYSTEM_EVENT_SUSPEND exit subtype by ignoring the guest request and
entering KVM again. Since KVM has already configured the guest to
resume, this will result in the guest immediately coming out of reset.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arm/kvm.c         | 12 ++++++++++++
 include/kvm/kvm.h |  1 +
 kvm-cpu.c         |  5 +++++
 kvm.c             |  7 +++++++
 4 files changed, 25 insertions(+)

diff --git a/arm/kvm.c b/arm/kvm.c
index 5aea18f..0a53c46 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -59,6 +59,18 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 {
+	if (kvm__supports_vm_extension(kvm, KVM_CAP_ARM_SYSTEM_SUSPEND)) {
+		struct kvm_enable_cap cap = {
+			.cap = KVM_CAP_ARM_SYSTEM_SUSPEND
+		};
+		int err;
+
+		err = kvm__enable_vm_extension(kvm, &cap);
+		if (err)
+			die("Failed to enable KVM_CAP_ARM_SYSTEM_SUSPEND "
+			    "[err %d]", err);
+	}
+
 	/*
 	 * Allocate guest memory. We must align our buffer to 64K to
 	 * correlate with the maximum guest page size for virtio-mmio.
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 56e9c8e..c797516 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -236,6 +236,7 @@ static inline bool host_ptr_in_ram(struct kvm *kvm, void *p)
 
 bool kvm__supports_extension(struct kvm *kvm, unsigned int extension);
 bool kvm__supports_vm_extension(struct kvm *kvm, unsigned int extension);
+int kvm__enable_vm_extension(struct kvm *kvm, struct kvm_enable_cap *cap);
 
 static inline void kvm__set_thread_name(const char *name)
 {
diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7dec088..1fedacf 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -236,6 +236,11 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 				 */
 				kvm__reboot(cpu->kvm);
 				goto exit_kvm;
+			case KVM_SYSTEM_EVENT_SUSPEND:
+				/*
+				 * Ignore the guest; kvm will resume it normally
+				 */
+				break;
 			};
 			break;
 		default: {
diff --git a/kvm.c b/kvm.c
index e327541..66815b4 100644
--- a/kvm.c
+++ b/kvm.c
@@ -123,6 +123,13 @@ bool kvm__supports_vm_extension(struct kvm *kvm, unsigned int extension)
 	return ret;
 }
 
+int kvm__enable_vm_extension(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	int ret = ioctl(kvm->vm_fd, KVM_ENABLE_CAP, cap);
+
+	return ret ? errno : 0;
+}
+
 bool kvm__supports_extension(struct kvm *kvm, unsigned int extension)
 {
 	int ret;
-- 
2.33.0.259.gc128427fd7-goog

