Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E212413E6E
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhIVAJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 20:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhIVAIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 20:08:21 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F13EC0617A8
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:06:15 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id d20-20020ac81194000000b002a53ffbd04dso5102307qtj.12
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hykBvrf8DnzH3Q8YHjL/Y0GXRoABX5ADBK+0/12MWfw=;
        b=jKopPzwiybt9fB96grPLhcmov4eHABK3Rn1V3+jC89gDcrIoprd65bnGYY9DP7ju4b
         85kkPs7ZPkL8WlWgMXplyIY3a/z2qIzxH+/FI3XjcdmrliPkx8nPrp2a5kX5Pjc1ywob
         ByTND1+iT+q5EbaKv8lVZV94ko5nNdJrrzXW+BlrNXXtl2FDDO+EPFHPKuUM6DjPG5xB
         A3Kj4DmZiicnBCVFqv70LMvPNdNZybwucvdKO2/8ODrWoNpkysFbo74lUlyrUvFEKlBi
         o1a2jdJRabm/xdF8RFOfzaw+a+ydqqTbWa982xz/HRYZHvnoWhQfVxgfpJMjXOW1pVY7
         0TqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hykBvrf8DnzH3Q8YHjL/Y0GXRoABX5ADBK+0/12MWfw=;
        b=FEW6oh2Qd6eXDZNMGPllt/zMMufwVTcUmoTaK+ruZI3k8M04Gxi6lZLe/E8zNgGwAo
         AxQbD/4oRHtOrTvC0rcuvj9i/kYquMWFLb7jufPsewOOmDCNSlJ6wL9IB2mb+lI6GIyi
         PJD94Sy29Y5Z8pQy97vv3OVkTMenZDekqDGSQeRN6K+IwO1wmw0SspFVNkkHkhr7+/mZ
         Hp/9aFazxVrajIoPEW7/4LKyP4+zTPbzkDG5lkaHqwj8J8HTD/O53MJA2Lt8os4uJm8C
         Gu1ilvuP7UJQfHS7LJcBE+mNyWQ9aH7dVuwEdI4PqfRo5xn8omF3nMM+sJBq+orL5t2L
         uzBQ==
X-Gm-Message-State: AOAM532tpqe9Euj9mFBst25j+AK2JO2QDyIegmZGi5jE0SdYk8N4TLTo
        Bduq2r+so+qcYqL6SyGp9FUEo7LOPS8=
X-Google-Smtp-Source: ABdhPJy5GySvAYc4kjGUgxPeiS0d5MaL33kPbz4EVAybMqnGUcP/K+XpH6FqRymRPMD4ga0cIEmdn6OzCzE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1143:: with SMTP id
 p3mr39279294ybu.420.1632269174363; Tue, 21 Sep 2021 17:06:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Sep 2021 17:05:31 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 14/16] KVM: arm64: Convert to the generic perf callbacks
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop arm64's version of the callbacks in favor of the callbacks provided
by generic KVM, which are semantically identical.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/perf.c | 34 ++--------------------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index 3e99ac4ab2d6..0b902e0d5b5d 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -13,45 +13,15 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 
-static unsigned int kvm_guest_state(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-	unsigned int state;
-
-	if (!vcpu)
-		return 0;
-
-	state = PERF_GUEST_ACTIVE;
-	if (!vcpu_mode_priv(vcpu))
-		state |= PERF_GUEST_USER;
-
-	return state;
-}
-
-static unsigned long kvm_get_guest_ip(void)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	if (WARN_ON_ONCE(!vcpu))
-		return 0;
-
-	return *vcpu_pc(vcpu);
-}
-
-static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.state		= kvm_guest_state,
-	.get_ip		= kvm_get_guest_ip,
-};
-
 void kvm_perf_init(void)
 {
 	if (kvm_pmu_probe_pmuver() != 0xf && !is_protected_kvm_enabled())
 		static_branch_enable(&kvm_arm_pmu_available);
 
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+	kvm_register_perf_callbacks(NULL);
 }
 
 void kvm_perf_teardown(void)
 {
-	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+	kvm_unregister_perf_callbacks();
 }
-- 
2.33.0.464.g1972c5931b-goog

