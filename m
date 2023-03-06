Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271946ACD70
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 20:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjCFTC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 14:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCFTCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 14:02:25 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14C834C37
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 11:02:03 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536bf649e70so111624267b3.0
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 11:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678129323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YtNaR+Rua5pfZ3i1GgJ4+hfSm+WXWk7IiLK4Wtb8+uM=;
        b=A42BX/LP2I7Yrldf83rjJjVVWP9EY7MIToR2w3fKfHNuwlJilnDlJG9Ga110/MBKfg
         bANY0GGZpHkSiBa5gtT3zYMm3kqQ6eoCd9XQbU1Nw97OaGmCCVTg5gCJq6SSBEjZs5D2
         WXuRcS2VBsFJxrimrp+JQlNpq+OFmS1Ohh71sBzmcc1MXrTW549F5OJ3aZCaRVfQfJrL
         Xl5df+WIcc/z0GU55ilZ3Am2ARcrEJpAjke5BrZTBJ9d+m4fByyPMgXYOtOtNovF1gQu
         M0K+F9OgIzJN5j3FpXghI6sTRl0hwMpb0KkZDbWtWBZRE7ORKqG1rS1sA7NOJROAsX6B
         zrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678129323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YtNaR+Rua5pfZ3i1GgJ4+hfSm+WXWk7IiLK4Wtb8+uM=;
        b=2fkLFpyypT6f1XrO0GQ6aSe9p8LSQq5yGrPp5S0H0ZEmcNb6KSG5KYPGK3jtBjo+1T
         P1rPf6hGBLoKYr9Fwhtnc6UyOAeyXqNDVPtU2LwcJZlEHwLjjlXKGlXxcTkH37iurBwu
         ufVHyhd3oXKupmGU6YlHzjjztGnd4ctN9OySfeYA0xGiBntKT2ykujmF5yOQtPx0rf9v
         Luec7LkA8NSePiFXNSNLWMXMyIhbILUmAONCybn/FBr3Vr6FYLMy363LW0l1D0BWmp2L
         x+vSoijjbAJKhVwLPImp337yX31pXrSwDCzWIN+4UYEfAJUGwsMSjYmlqMLsQLdUqsHB
         RseA==
X-Gm-Message-State: AO0yUKXNsSVvX9QmhXUjiJVUIOwDQv+wISTa3OSCrJrq8qN+GH/kvUT1
        4FDwBCD0QWmus7/u2zc3vg0NJet8A/Hwcw==
X-Google-Smtp-Source: AK7set90Igml/rc2W0Ya1hk1eHjjJqlvHrIGVSaZmJTzp6vbZseA2XP1DWQDVsfl/YAYC2c0ne8CFj1tJ7LMiQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:ad0d:0:b0:52e:b635:5496 with SMTP id
 l13-20020a81ad0d000000b0052eb6355496mr7126400ywh.2.1678129323101; Mon, 06 Mar
 2023 11:02:03 -0800 (PST)
Date:   Mon,  6 Mar 2023 11:01:54 -0800
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230306190156.434452-1-dmatlack@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306190156.434452-3-dmatlack@google.com>
Subject: [PATCH v2 2/4] KVM: Refactor designated initializer macros for struct _kvm_stats_desc
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
        linux-riscv@lists.infradead.org
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

Refactor the macros that generate struct _kvm_stats_desc designated
initializers to cut down on duplication.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 75 +++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 40 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 02b1151c2753..6673ae757c4e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1744,47 +1744,42 @@ struct _kvm_stats_desc {
 	char name[KVM_STATS_NAME_SIZE];
 };
 
-#define STATS_DESC_COMMON(type, unit, base, exp, sz, bsz)		       \
-	.flags = type | unit | base |					       \
-		 BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |	       \
-		 BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |	       \
-		 BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),	       \
-	.exponent = exp,						       \
-	.size = sz,							       \
-	.bucket_size = bsz
-
-#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
+/* Generates a designated initializer list for a struct _kvm_stats_desc. */
+#define _KVM_STATS_DESC(_struct, _field, _name, _type, _unit, _base,	       \
+			_exponent, _size, _bucket_size)			       \
+{									       \
 	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vm_stat, generic.stat)   \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vcpu_stat, generic.stat) \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VM_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vm_stat, stat)	       \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vcpu_stat, stat)	       \
-		},							       \
-		.name = #stat,						       \
-	}
+		.flags = _type | _unit | _base |			       \
+			 BUILD_BUG_ON_ZERO(_type & ~KVM_STATS_TYPE_MASK) |     \
+			 BUILD_BUG_ON_ZERO(_unit & ~KVM_STATS_UNIT_MASK) |     \
+			 BUILD_BUG_ON_ZERO(_base & ~KVM_STATS_BASE_MASK),      \
+		.exponent = _exponent,					       \
+		.size = _size,						       \
+		.bucket_size = _bucket_size,				       \
+		.offset = offsetof(_struct, _field),			       \
+	},								       \
+	.name = _name,							       \
+}
+
+#define VM_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,    \
+			      _bucket_size)				       \
+	_KVM_STATS_DESC(struct kvm_vm_stat, generic._stat, #_stat, _type,      \
+			_unit, _base, _exponent, _size, _bucket_size)
+
+#define VCPU_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,  \
+				_bucket_size)				       \
+	_KVM_STATS_DESC(struct kvm_vcpu_stat, generic._stat, #_stat, _type,    \
+			_unit, _base, _exponent, _size, _bucket_size)
+
+#define VM_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+		      _bucket_size)					       \
+	_KVM_STATS_DESC(struct kvm_vm_stat, _stat, #_stat, _type, _unit,       \
+			_base, _exponent, _size, _bucket_size)
+
+#define VCPU_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+			_bucket_size)					       \
+	_KVM_STATS_DESC(struct kvm_vcpu_stat, _stat, #_stat, _type, _unit,     \
+			_base, _exponent, _size, _bucket_size)
 
 /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
 #define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz)		       \
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

