Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1941F3DFD75
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbhHDI7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbhHDI7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:59:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA79C0617A1
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j21-20020a25d2150000b029057ac4b4e78fso2260893ybg.4
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kDlmZ2q+VtsAE3exEj8aYy6Fk3kSky3TCXUK2+oaNSo=;
        b=lzMCH9i930DInyi3TgFPeE0uphR3Msy4pTrV5RPcS66cl2mtNGs6v5FMcT24ugSCvu
         9t2LTl5MeANnamFbgsOAhO26iTUlsALVuwLmAlCcO3GJ9l1hjsOAorK4kMvfpjtwNn0A
         BzurnpIA6EmR8GyK1/kV3LTsEcDNwzJRnnugFj0EUJxJYPmqNanYRpUqh9Iho74VI27e
         Za6PQgbIG636DV/zsqE46glgJvckLVfEpvZwIfocJHgnxj1mN/9rtgCngqSXNiD/Gw/d
         kHmREJP/0WVtk9MY2zVUvznJ0l9KvXjtClvLNoYeMw2fOuBBfPoJ8QZKRd6CAiszFLAJ
         PK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kDlmZ2q+VtsAE3exEj8aYy6Fk3kSky3TCXUK2+oaNSo=;
        b=U3fvBLsxUHsoJ4QhSWLKK9HDmtlN+gkU9QKYJE8Wsmscts5ZXdHhKtWBelJi5tnjOJ
         lyPGhresyaMLHY99HH95B4ap5yV9Z3VT2GQuZGdkKcIcXGmPs1RKFnAS685XeyrkK4VY
         wwyl5+gVnRE51+M2iRwz148aOf0hg7HGZ/HoxMzsNugT6dT7YOcvovabR1SnS1Esm1I4
         h7/aCwk3xupY3+V6wMODHDTb/qaEB4pCBqDN3lv+OuNfV9VLrexwWkX6FY3HpA9pE6O9
         IKw9imQ8r+E+TR5DooNwpGLCKHSuslOFFe3g6CFuTgdQ/Wa+iHOGv0jloYxXYmjMTGxj
         lyKA==
X-Gm-Message-State: AOAM531CdPkuA4CQ2qCgZ/MI3RW5al7Uy/GjKeORkWLI8d3c1T2CoEtE
        XtA49yLrd8JPZ7I7ynMAtASxD6QfZHS7BeD9TpLHj2pJ+Wy3TpbjVegQVqoQt5UJGSMMpoLJOI5
        1QDg6kZvtE7xv0kFX/WbCklqIiNuoqFXC7LTg5hTVvANYrvi4iUh/8ZwC8g==
X-Google-Smtp-Source: ABdhPJwoa+pdRQxhpipLNFgpIp6Y6GN/h2wf96Y41BJ+I1JnXOOC4/K6kyDAjQKCzkOIoOhBQEk5G+hqcxc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:be48:: with SMTP id d8mr33406835ybm.521.1628067530295;
 Wed, 04 Aug 2021 01:58:50 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:12 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-15-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 14/21] selftests: KVM: Add helper to check for register presence
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
2.32.0.605.g8dce9f2422-goog

