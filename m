Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F21D549C90
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbiFMTA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346255AbiFMTAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:00:21 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453B59969B
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:49 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 18-20020a621512000000b0051b90b3a793so2542931pfv.8
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WzGiy8MvhiIUMi0s+wtsSIHmWc5cSwuMnyGQLZRW9iE=;
        b=TmRZ8aVm8k7OvscC44C/b2jeDc4I79KMJqDidpu3fidjaRCDoHLjhsWb/Vr5AiMZTf
         cYPhbxDt12l+cE3KFcvcEa5obW/XZsdbPKAx+2BliPFQIyKy0DePwMuknXTWQMVRf6Ed
         QJw6IZfHxdVp+FEa2WnNHrxENVPpEzIH9VjXFoZZf+wPZH221AWWvXkvQv4YHeG+Ek44
         bV8JTq23EsoRQyFSXipy4q7+fnGnu62yHj3vPpOCKUxgyJ8th5exzKEnDGvmoDc5arLu
         JXgJLz6cmOKwTiyYPTkjsG80WWC99rp/aWetKZjQ6LK9KpqGhuP0AWxY6XgkEMzTYIWA
         Onlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WzGiy8MvhiIUMi0s+wtsSIHmWc5cSwuMnyGQLZRW9iE=;
        b=yeoH2EGxG5Euu/0ryyfOo65hOgFag2qqR8hdU0UhSKOuodoywUI+bsgBGYih9wqLvh
         weWVOO+Zrei+bK7QgCbuxlKvGdxJ9xXtaT5l6aesBR3aPhyOh0YaF0ypZ8QgY5+ViMvv
         fgCuOBYpNmXVdDzjhku3ojoAa33eC7Oe62bHtnbQSRVZopCb2YSzv26bQ/fHiAgp91pq
         W+9tIWrqesiZg8jMAJm7tqgKc+5GFpQ8TV1MPGTQ2Uo7YAtkLb4h+sTwai2vBlkXR1H4
         o93MPtDiivrJLM0beL6E6th4RH/BxlASbPOWBj26LZp/C8Ki5o9GkYyj3veOSZv0O42A
         NROA==
X-Gm-Message-State: AJIora/YnkyNAWlB0q0bhKj9TbjMaoCe/jhnPjoYfATLZOPHljBQ9g2h
        7GHzTsugyARnp9nDDjM22qm7TCYUls0=
X-Google-Smtp-Source: AGRyM1tYM/Hx79fv6bDuIWPkGeu+wRbTZRlEQXOt3Rbnug4Kp1EytPfKuwr/kETntYYPlu30Xh55c7O7jd4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d551:b0:168:93b6:a94a with SMTP id
 z17-20020a170902d55100b0016893b6a94amr77699plf.149.1655137188739; Mon, 13 Jun
 2022 09:19:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 16:19:40 +0000
In-Reply-To: <20220613161942.1586791-1-seanjc@google.com>
Message-Id: <20220613161942.1586791-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220613161942.1586791-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 2/4] KVM: selftests: Call a dummy helper in VM/vCPU ioctls()
 to enforce type
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the goofy static_assert on the size of the @vm/@vcpu parameters
with a call to a dummy helper, i.e. let the compiler naturally complain
about an incompatible type instead of homebrewing a poor replacement.

Reported-by: Andrew Jones <drjones@redhat.com>
Fixes: fcba483e8246 ("KVM: selftests: Sanity check input to ioctls() at build time")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 57 ++++++++++---------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index cdaea2383543..7ebfc8c7de17 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -186,50 +186,55 @@ static inline bool kvm_has_cap(long cap)
 	ioctl(fd, cmd, arg);							\
 })
 
-#define __kvm_ioctl(kvm_fd, cmd, arg)						\
+#define __kvm_ioctl(kvm_fd, cmd, arg)				\
 	kvm_do_ioctl(kvm_fd, cmd, arg)
 
 
-#define _kvm_ioctl(kvm_fd, cmd, name, arg)					\
-({										\
-	int ret = __kvm_ioctl(kvm_fd, cmd, arg);				\
-										\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));			\
+#define _kvm_ioctl(kvm_fd, cmd, name, arg)			\
+({								\
+	int ret = __kvm_ioctl(kvm_fd, cmd, arg);		\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));	\
 })
 
 #define kvm_ioctl(kvm_fd, cmd, arg) \
 	_kvm_ioctl(kvm_fd, cmd, #cmd, arg)
 
-#define __vm_ioctl(vm, cmd, arg)						\
-({										\
-	static_assert(sizeof(*(vm)) == sizeof(struct kvm_vm), "");		\
-	kvm_do_ioctl((vm)->fd, cmd, arg);					\
+static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
+
+#define __vm_ioctl(vm, cmd, arg)				\
+({								\
+	static_assert_is_vm(vm);				\
+	kvm_do_ioctl((vm)->fd, cmd, arg);			\
 })
 
-#define _vm_ioctl(vm, cmd, name, arg)						\
-({										\
-	int ret = __vm_ioctl(vm, cmd, arg);					\
-										\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));			\
+#define _vm_ioctl(vm, cmd, name, arg)				\
+({								\
+	int ret = __vm_ioctl(vm, cmd, arg);			\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));	\
 })
 
-#define vm_ioctl(vm, cmd, arg)							\
+#define vm_ioctl(vm, cmd, arg)					\
 	_vm_ioctl(vm, cmd, #cmd, arg)
 
-#define __vcpu_ioctl(vcpu, cmd, arg)						\
-({										\
-	static_assert(sizeof(*(vcpu)) == sizeof(struct kvm_vcpu), "");		\
-	kvm_do_ioctl((vcpu)->fd, cmd, arg);					\
+
+static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
+
+#define __vcpu_ioctl(vcpu, cmd, arg)				\
+({								\
+	static_assert_is_vcpu(vcpu);				\
+	kvm_do_ioctl((vcpu)->fd, cmd, arg);			\
 })
 
-#define _vcpu_ioctl(vcpu, cmd, name, arg)					\
-({										\
-	int ret = __vcpu_ioctl(vcpu, cmd, arg);					\
-										\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));			\
+#define _vcpu_ioctl(vcpu, cmd, name, arg)			\
+({								\
+	int ret = __vcpu_ioctl(vcpu, cmd, arg);			\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));	\
 })
 
-#define vcpu_ioctl(vcpu, cmd, arg)						\
+#define vcpu_ioctl(vcpu, cmd, arg)				\
 	_vcpu_ioctl(vcpu, cmd, #cmd, arg)
 
 /*
-- 
2.36.1.476.g0c4daa206d-goog

