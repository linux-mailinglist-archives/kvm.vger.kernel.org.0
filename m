Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71D16ACD72
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 20:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjCFTC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 14:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCFTC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 14:02:26 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5002E4A1C0
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 11:02:05 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x64-20020a25ce43000000b00ae6d5855d78so11536469ybe.12
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 11:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678129324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XCoFR/ZEz+o/3af75F9xOrPS2psj7bAuPaV+hSWOgQo=;
        b=UtpACFkTBCbOuRJEDO4GIV5VZyNtvBXfzND3oU3x+MTJtqKf4RC+aJ4iEUgKvk/Gbv
         QwvfJnU9JToxEfS+WRcwSwlVT4IlfuPHxbDlaSiueIsWANa2Ta9bs7g2Xb/SoaztXvbW
         AcZzwTzgMy8MObXk877NToyNHzCNVG6tPs8bD3L2lDLtP1vJbpQNVe/QUw4MOneGcben
         A12+mWFZoMCKAD0Z64Pf8fB/rO0lgxgHvfoLNCDEimxkEwLixX3fA9CtbPgaW1lHLH/k
         mZfeAEacPOyAvkjV/89Ze4YmYA+t2BabNvI12wvTJZnOvTvidyImSKerp51EgZ1O07yo
         W1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678129324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCoFR/ZEz+o/3af75F9xOrPS2psj7bAuPaV+hSWOgQo=;
        b=hbgfurpwI1LcjnmYvxvJ1JFfmNBxDOdzJeJk1GQQYG/FgYWEsxNnJdlWmE8V6+ba4k
         Ky39lCZ5lVSkbN4nxTHdz6j7lSMbqwk9E22qJoSXPnLv9LKEy0/7+C5M10ZOtexBo1WG
         ahXMb03LI/qBFpw52JDnKZdaon7jX6tRNomNIyKYtw4ltuJstJ6oVKsMjD8MrlSaP9u2
         ZNJ2E5L+O9lxnZAx0x8IioJbx+zOHQSSpKa2c3A/LDoHo6OO06Hv21K92e99/eGVxFQz
         RB44xZkDzW8KBD5mBi1nTSb6uGz6haMBq9+mWkXu9UcSXMYiO2OC/Hcd+Nl0YJfTie9V
         KX+w==
X-Gm-Message-State: AO0yUKVmuyYqMjbK+pDt5QThv6Dp25qP8GV+tXfdOut6JePzsXhKNCUY
        rnd6r/5WVrML/1l665OrflMIxKCC01rzcA==
X-Google-Smtp-Source: AK7set//cZ5G8Yg9tzyC35+cBUfG5YD+QOMFZSqm+c6ivqgffhDJvoZQbaLGDxeXrS7rdZX3Y2pHJ1bn0bJjqg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:ac4b:0:b0:533:9ffb:cb12 with SMTP id
 z11-20020a81ac4b000000b005339ffbcb12mr7643877ywj.10.1678129324575; Mon, 06
 Mar 2023 11:02:04 -0800 (PST)
Date:   Mon,  6 Mar 2023 11:01:55 -0800
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230306190156.434452-1-dmatlack@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306190156.434452-4-dmatlack@google.com>
Subject: [PATCH v2 3/4] KVM: Allow custom names for KVM_STAT()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        David Matlack <dmatlack@google.com>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow custom names to be specified for stats built on KVM_STAT() via a
new inner macro __KVM_STAT(). e.g.

  KVM_STAT(VM, CUMULATIVE, NONE, foo),
  __KVM_STAT(VM, CUMULATIVE, NONE, bar, "custom_name"),
  ...

Custom name support enables decoupling the userspace-visible stat names
from their internal representation in C. This can allow future commits
to refactor the various stats structs without impacting userspace tools
that read KVM stats.

This also allows stats to be stored in data structures such as arrays,
without needing unions to access specific stats. For example, the union
for pages_{4k,2m,1g} is no longer necessary. At Google, we have several
other out-of-tree stats that would benefit from this support.

No functional change intended.

Link: https://lore.kernel.org/all/20211019000459.3163029-1-jingzhangos@google.com/
Suggested-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6673ae757c4e..fa026e8997b2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1761,40 +1761,43 @@ struct _kvm_stats_desc {
 	.name = _name,							       \
 }
 
-#define VM_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,    \
-			      _bucket_size)				       \
-	_KVM_STATS_DESC(struct kvm_vm_stat, generic._stat, #_stat, _type,      \
+#define VM_GENERIC_STATS_DESC(_stat, _name, _type, _unit, _base, _exponent,    \
+			      _size, _bucket_size)			       \
+	_KVM_STATS_DESC(struct kvm_vm_stat, generic._stat, _name, _type,       \
 			_unit, _base, _exponent, _size, _bucket_size)
 
-#define VCPU_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,  \
-				_bucket_size)				       \
-	_KVM_STATS_DESC(struct kvm_vcpu_stat, generic._stat, #_stat, _type,    \
+#define VCPU_GENERIC_STATS_DESC(_stat, _name, _type, _unit, _base, _exponent,  \
+				_size, _bucket_size)			       \
+	_KVM_STATS_DESC(struct kvm_vcpu_stat, generic._stat, _name, _type,     \
 			_unit, _base, _exponent, _size, _bucket_size)
 
-#define VM_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+#define VM_STATS_DESC(_stat, _name, _type, _unit, _base, _exponent, _size,     \
 		      _bucket_size)					       \
-	_KVM_STATS_DESC(struct kvm_vm_stat, _stat, #_stat, _type, _unit,       \
+	_KVM_STATS_DESC(struct kvm_vm_stat, _stat, _name, _type, _unit,	       \
 			_base, _exponent, _size, _bucket_size)
 
-#define VCPU_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+#define VCPU_STATS_DESC(_stat, _name, _type, _unit, _base, _exponent, _size,   \
 			_bucket_size)					       \
-	_KVM_STATS_DESC(struct kvm_vcpu_stat, _stat, #_stat, _type, _unit,     \
+	_KVM_STATS_DESC(struct kvm_vcpu_stat, _stat, _name, _type, _unit,      \
 			_base, _exponent, _size, _bucket_size)
 
 /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
-#define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz)		       \
-	SCOPE##_STATS_DESC(stat, type, unit, base, exp, sz, bsz)
+#define STATS_DESC(SCOPE, stat, name, type, unit, base, exp, sz, bsz)	       \
+	SCOPE##_STATS_DESC(stat, name, type, unit, base, exp, sz, bsz)
 
-#define KVM_STAT(SCOPE, TYPE, UNIT, _stat)				       \
-	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_##TYPE,			       \
+#define __KVM_STAT(SCOPE, TYPE, UNIT, _stat, _name)			       \
+	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_##TYPE,		       \
 		   KVM_STATS_UNIT_##UNIT, KVM_STATS_BASE_POW10, 0, 1, 0)
 
+#define KVM_STAT(SCOPE, TYPE, UNIT, _stat)				       \
+	__KVM_STAT(SCOPE, TYPE, UNIT, _stat, #_stat)
+
 #define KVM_STAT_NSEC(SCOPE, _stat)					       \
-	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_CUMULATIVE,		       \
+	STATS_DESC(SCOPE, _stat, #_stat, KVM_STATS_TYPE_CUMULATIVE,	       \
 		   KVM_STATS_UNIT_SECONDS, KVM_STATS_BASE_POW10, -9, 1, 0)
 
 #define KVM_HIST_NSEC(SCOPE, TYPE, _stat, _size, _bucket_size)		       \
-	STATS_DESC(VCPU_GENERIC, _stat, KVM_STATS_TYPE_##TYPE##_HIST,	       \
+	STATS_DESC(VCPU_GENERIC, _stat, #_stat, KVM_STATS_TYPE_##TYPE##_HIST,  \
 		   KVM_STATS_UNIT_SECONDS, KVM_STATS_BASE_POW10, -9,	       \
 		   _size, _bucket_size)
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

