Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FE16B5692
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjCKAYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjCKAXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:23:40 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579FA5D449
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:25 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pb4-20020a17090b3c0400b00237873bd59bso2839870pjb.2
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MQo4WmE7f97mSOHZkI3jr5btwmig+br9PEj++8GmA1Y=;
        b=bl3n2+O+/VcIrUul70a5c+psPIylTaKZidknn7ZUMJ1VKDYON2kZjsj+qY8mlUsf3H
         trT5CCOCqbqQzkNkr7qgSz7MW2T5nLyGwtnrq+dTu/4WboCT7gmBjgkcKB2lVQwxHML9
         P62aQv5xuNUt9STojA6Vr1mSxq8grcBmiGzmLRGU6MPnI6sz6t/Qh/JBg6pg+M6dEPLL
         TYko2KDQWHHz3Xs7yTY6tz4i2DxoK+UJdwG1yB6ish/k+gmiYui1QPheJvkZJuOzRuDw
         0h7vffFzjdPTnAg9LysYD0norRIil7HfS/4M4biE3kx7voJQNWrLPNM+Zdxyo5syMIlO
         6fBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MQo4WmE7f97mSOHZkI3jr5btwmig+br9PEj++8GmA1Y=;
        b=J9BTQJYJ33xPfgkFY/jU2WHmyItY7U1vet8tc831J23iastbTqjrgbKgiXzGOfrQcz
         O/Nv5e8WkB/bohW6u9rShtBxCSuh6GyQjd9RVpgGxcSb46Gb8xeNUThugaGssHUVIfPk
         w+FW58Ht3nNtunQDAhGK1lO8KjiBHeB/RmkQtqEbQ0cnrNunAGW6r1m9jEhWl/AFQ/iV
         WZ8QBGrwF0buLTt5Y7qi17bj07I8wapR82DIvk6QMIqXzRYRZxEf29gAsDlSA5IJdcAu
         7Nnesc6sW0ksyqkpUQGPwJYOlxCzH9mSKwEpEkp32MEVP2hu9s3sAhr9n0Bs7q7SkiTT
         plng==
X-Gm-Message-State: AO0yUKV0YvEq5/PBiO9wkPzaBKk2gWnbWt37q1M0wZXLX0Yk3sv8Nnrf
        FgmCSWxHI4heRw9pq8Yxnu6uK+Scz28=
X-Google-Smtp-Source: AK7set+CIJ9m8jH9oNknQz7rK0QCgrymV+VOsddjSAaAVGPMq+29db0qr1UEOPNYnEU8mkEPVUrV1e/vI+o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4e04:b0:239:d0ab:a7c9 with SMTP id
 n4-20020a17090a4e0400b00239d0aba7c9mr9622929pjh.4.1678494201193; Fri, 10 Mar
 2023 16:23:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:39 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-9-seanjc@google.com>
Subject: [PATCH v2 08/27] drm/i915/gvt: Use an "unsigned long" to iterate over
 memslot gfns
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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

Use an "unsigned long" instead of an "int" when iterating over the gfns
in a memslot.  The number of pages in the memslot is tracked as an
"unsigned long", e.g. KVMGT could theoretically break if a KVM memslot
larger than 16TiB were deleted (2^32 * 4KiB).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 90997cc385b4..68be66395598 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1634,7 +1634,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		struct kvm_page_track_notifier_node *node)
 {
-	int i;
+	unsigned long i;
 	gfn_t gfn;
 	struct intel_vgpu *info =
 		container_of(node, struct intel_vgpu, track_node);
-- 
2.40.0.rc1.284.g88254d51c5-goog

