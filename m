Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2AC40EA74
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345789AbhIPS6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238777AbhIPS5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:32 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693FDC04A15D
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:02 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 23-20020a05620a071700b00426392c0e6eso44851737qkc.4
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JJZ190EFBdoAROgHmhQViRGxGG559ZmU5Q/9tQKxLoY=;
        b=VXFxleX8XZbxaXGsk52pqIxNLQlkPnbly3aXNjlVihcthPwkd7vAB2Ak2ReYQFp9Gz
         XNRC4NG00zHZWIHAqSy8Xe5QfHf2iqo04aBflACa0wBiSyaXPe41s9VLzvd0ze9jnmsk
         RDVfUZcyLzHoCDoidFIb1uEDOnlAcaLO7ll4PjIsWhMEwsl2NyGzWZj+GqNsRmgV9cyQ
         x24xui9+LrpOpWh2dLRRwg3b/yJbwu8oKo1k943MMDbWls0v3XpScoPeIvfAD0kuf4WM
         V8zsVGw4LFa0PpNqKVVgKta63ymqxpGPok4eoZB5FbmvmYMNpIrxqU4VMtlRfzAamFPi
         QU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JJZ190EFBdoAROgHmhQViRGxGG559ZmU5Q/9tQKxLoY=;
        b=Zb5Y2Nxbq3IzRhP8y+V+IgKIowoNHJGH5VuBfqYVZDYwuZNFPmxyT2r+Vbc5v49M0N
         0zjtrRZswqwupnndX7l5dguvy09r/qcgs4DQSfVTYszsThY4vgMjbHhmkOEFtDV7W2Lg
         CZYhPlpbTKH6LweLpiMHqYfKIn3v2m9ZRPf/IQbJ3Jd71rNQGxY9/YNq2asgUGIfm3Jm
         NqnNsTCLWyHqX0bsIC5fr/1vou12qhel5Y6ovpEcraj9CaQRP0h4TuM3y6C5d36389rE
         wL/ktoXy8u8H5RfqMY6hi31PGFRrTHDqZQe9SnP3VatG/NNWofBLR5dKagruoGGB/jAC
         41/A==
X-Gm-Message-State: AOAM531NJ82gktuHZq5WuHCZrB/2bQF9QtNUHCIdsDRcx/lp4YZLz1Kd
        9kis5lk+NnSA7DlU8Uf1b28Wk85Gy/tmPMfTO3H2t/gtgxD6oNO1AzMCGh5xcsPfiwMQGO1827B
        8gNYuQQUF6NIfiDxsK19BPYqSFtW/JGXzyI5Dx4LzPw4bXuAaDaU9U2o0IQ==
X-Google-Smtp-Source: ABdhPJwltYXH4Kr/7Jd29on+c2F3YNghXUrtcqQSctncJpRrq17F9VQCTldOwtteX8HrCI551yoAzX3DyD4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:146d:: with SMTP id
 c13mr6829626qvy.46.1631816161461; Thu, 16 Sep 2021 11:16:01 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:49 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-4-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 3/9] selftests: KVM: Fix kvm device helper ioctl assertions
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

The KVM_CREATE_DEVICE and KVM_{GET,SET}_DEVICE_ATTR ioctls are defined
to return a value of zero on success. As such, tighten the assertions in
the helper functions to only pass if the return code is zero.

Suggested-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..0ffc2d39c80d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1984,7 +1984,7 @@ int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
 {
 	int ret = _kvm_device_check_attr(dev_fd, group, attr);
 
-	TEST_ASSERT(ret >= 0, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
@@ -2008,7 +2008,7 @@ int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
 	ret = _kvm_create_device(vm, type, test, &fd);
 
 	if (!test) {
-		TEST_ASSERT(ret >= 0,
+		TEST_ASSERT(!ret,
 			    "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
 		return fd;
 	}
@@ -2036,7 +2036,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 {
 	int ret = _kvm_device_access(dev_fd, group, attr, val, write);
 
-	TEST_ASSERT(ret >= 0, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
-- 
2.33.0.464.g1972c5931b-goog

