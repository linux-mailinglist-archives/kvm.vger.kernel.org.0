Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8251404302
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349950AbhIIBl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349973AbhIIBk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:40:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA17BC0613D9
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y134-20020a25dc8c000000b0059f0301df0fso357134ybe.21
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QFzaphrb6MUUmunc6a6PS61JVYVIo4B9xEZOBe9g7Fo=;
        b=OLiKiebf2TxifAFIXy3Xc+KcOCQ/0AGYdrE4MhqknFVHdroim3LDpPE5sbASnxry8W
         ghCwia/tmngpglMpIPxqFiP/MURbu6c5Zh04SGNyNjrRUwXb8msisPMuTnnvPkAmp8ld
         XaU8Y/HKaoWMRtpKDZ1RIjIx0Zfa9OZP+kfhw7YYEn6EkSg84iz0n3ox9rYxOhGMoyAc
         PJynGxE7Gh2YmOv8iN2CyaJMw760I7ez+eq7P7opjhhuBEdHdiYjYKq2/nzYHc6u2Opa
         7I4bUJNYcVxZpfxT158n0bnulcLHoTMeunqeYJ0nIT69aIpW+yLjqlg29DzurHUuGODU
         nq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QFzaphrb6MUUmunc6a6PS61JVYVIo4B9xEZOBe9g7Fo=;
        b=iObIy8jkrakVsk7a/lBeUuzHQdCJtrl31bPZ0uEJw4gp5TMu1J4GX3DBq6toi4iL2f
         Lx8YaCaOj+kI9eCLEosk1SfgOKH5ZekcrdLyYOaLOvsV00ogfojI8pisJvF0dGUi/fIR
         mfK1Ra4Vn+T5vB0bHP8GnEng4xHI4DzGGaE4P2slaNVrMtXiGec+gH36EC4eBwsXW7Ao
         hAR0hgMtC59g+v4J9j3Lra6sa/id1qZSjK1B3q/I01bzvr/U6feG6I7+3mWHzRaijvzE
         Fwsb5hO/GTejaybfGyDx8MQ/Aj5wrgpgvAg2bwg0DBaU1CSjoUki1KDCmVnK4qrripY5
         UNhA==
X-Gm-Message-State: AOAM531tilFO5bP7GpkWcAKy5DgYcB2UKAoOjz2ZdIA8oPm9izPC66VB
        gWgYblHECalwaV67Sr87QMiEMy76mvLw
X-Google-Smtp-Source: ABdhPJyIJlWSvy9ha4r+TmbXK5U100h0ul3t0NMi635x/oKJd6ScJd3FEJZ8ks+Ji3XU4v7IezN+undvXWOe
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:802:: with SMTP id 2mr528307ybi.61.1631151535888;
 Wed, 08 Sep 2021 18:38:55 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:13 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-14-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 13/18] KVM: selftests: Add support to get the VM's mode
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The host utility functions (in upcoming patches) may
want to know the mode of the VM. Hence, create
vm_get_mode() to return the same.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c     | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index d5d0ca919928..9842bf5e2c2e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -400,5 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 int vm_get_nr_vcpus(struct kvm_vm *vm);
+enum vm_guest_mode vm_get_mode(struct kvm_vm *vm);
 
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1b5349b5132f..ad73ca921e2e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2350,3 +2350,8 @@ int vm_get_nr_vcpus(struct kvm_vm *vm)
 {
 	return vm->nr_vcpus;
 }
+
+enum vm_guest_mode vm_get_mode(struct kvm_vm *vm)
+{
+	return vm->mode;
+}
-- 
2.33.0.153.gba50c8fa24-goog

