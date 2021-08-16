Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF523ECC0E
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhHPANe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbhHPAN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:13:29 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD4CC061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:58 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id y20-20020a056e020f5400b00224400d1c21so6844023ilj.11
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LDn71X/mteHSm80S6t26TyxwkEj27LrlTf7lB/WnK0E=;
        b=tFGja0lkfeepK+FkjFeq/aVGW+mKNcPoNNlqpTMnu0V3vovCmctbotfMUDQjFSAcD4
         6HOZbhkVK/AJkuPU4vE4cvo6B1mF3aDEYLG107YqyjKseSoClfb8cG4UAZjnRyke0Ce+
         WkIpMN+ybYGn2RRLaX7uoEOw+pTWEzeY7aTzSFVuig04pceKNl0TVXOGaDRVgK2a8Vhr
         2DXYsb5DVrL2L3qN297jolFCHfD3H6kPSjk+gIA/ush9nBL2y5iojzV6Yx6PC74aeADD
         Cak/sRa9pm9NFS5qTT+cpb8hE/wID6LMeB6ol1Ypc7u2S47YZbKgp0UUN7W+RYGywGaI
         mVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LDn71X/mteHSm80S6t26TyxwkEj27LrlTf7lB/WnK0E=;
        b=OCXhRbC6eT90M7Or+INfOg8f/grCSjaYYXNyE/6AninWBKn2HB7kbNbYbXK3ppx2Ag
         jIlTYYNEsfafJGuctGddKcRzybNf14YgnYnM7Oy6ytyxSCdeyekrYP72WXJEHSfbbiFd
         +KspuB8Tm7LRwS9mzrW2K0aMKR5WE4lvXuanjsHnwpvYAgXnSG2H4HZGpn0uMrxIb4sf
         ceBCEapyth2tvBLLmfpO9fASex0gav95v1jqSvCRwY5mQbDBgTRld5+ue2Nh94AJOacL
         rPTXC8UFPaaSXui1SzDn5q7STiiYk+/xtHIhDFSd64zKbimymVnVMUVjXQMa/5AqyMIQ
         qH9g==
X-Gm-Message-State: AOAM532OW55LE6ZmPvdt0EMCDYjraw7W8m7k7sCWxuIt/bk3uWVBI4ri
        9XQ59nRJyDnNJbZxXFrejkkUOWTMYACQK5mDzQsTO90Pj+ClZATyT9+q9jjrDjY922RN1Q1aILV
        JI1mWb/E9aosL0NSw1gzgzue+0OHwvzo2Wkk0pF0k8utY3kZLb0jdoKZMUg==
X-Google-Smtp-Source: ABdhPJxBGSNKp7nAwuyx4V4ZkrlD3NGCg0jwXeIu/+7/9/7758jjyZKMe4CTsweb4Xrvpxd+DmoDyTn6Lyo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:fb07:: with SMTP id h7mr3843368iog.201.1629072778180;
 Sun, 15 Aug 2021 17:12:58 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:43 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-7-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 6/9] selftests: KVM: Add helper to check for register presence
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

The KVM_GET_REG_LIST vCPU ioctl returns a list of supported registers
for a given vCPU. Add a helper to check if a register exists in the list
of supported registers.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 1b3ef5757819..077082dd2ca7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -215,6 +215,8 @@ void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
 		  struct kvm_fpu *fpu);
 void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
 		  struct kvm_fpu *fpu);
+
+bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id);
 void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
 void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
 #ifdef __KVM_HAVE_VCPU_EVENTS
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0fe66ca6139a..a5801d4ed37d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1823,6 +1823,25 @@ void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
 		    ret, errno, strerror(errno));
 }
 
+bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id)
+{
+	struct kvm_reg_list *list;
+	bool ret = false;
+	uint64_t i;
+
+	list = vcpu_get_reg_list(vm, vcpuid);
+
+	for (i = 0; i < list->n; i++) {
+		if (list->reg[i] == reg_id) {
+			ret = true;
+			break;
+		}
+	}
+
+	free(list);
+	return ret;
+}
+
 void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
 {
 	int ret;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

