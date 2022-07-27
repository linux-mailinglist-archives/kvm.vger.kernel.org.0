Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02A85835AB
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 01:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbiG0Xeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 19:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiG0Xee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 19:34:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E821356B99
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 16:34:33 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i9-20020a170902cf0900b0016d1e277547so211348plg.0
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 16:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tcg4fyWcMhApmssB1rrZxLEKjBF7sSie1JOHuz2QyKw=;
        b=Y22uyc7My63H8qiFF1kgEwUBLMnNiTDQAspI9xMCMaI8CL4pMsFZwEy5qqqu/OAbjk
         dCkhYEVY81t7juGyB3KIxXTQ16K2PW8Lbb0TiJluF1RHfns+Gpb4V79FfA53W3Jo94he
         OhcXVYyDhnTAEAhhX4NcAbrMDp1GYhjOIRVOBGVk99IfkIzYylefYMyoW1sFSV14LpXR
         /loGYZXkjgZj34YAUF1U+FsjpNVxIp22oA9ihhclEeuBB1IqhuA/NrFqXW3aYoCx0I57
         74hrMCbtPcUJHybQ8N6HeVjtcLXTs1aNHY455CaZL+xFrrAx8aGJU+hv7v53sWhV6ZIR
         zeaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tcg4fyWcMhApmssB1rrZxLEKjBF7sSie1JOHuz2QyKw=;
        b=UCNpgIUK5LQzzzkhZGeL6dOXQIiOg+YMkSGItD7KlFAN0Q3ePDjq0cBomY7UKXNHX/
         LOjSerx7P1vFNXYxp/vI5PqgfuJe8H9h+zA5kB/fCwPzifVl0G1xqxfErWzPgtJc89fb
         lNwhCQZ0SYldWjEjKaTBHXkVMtskPR1EVHKSsAweYWbBW3OxJc8hKtvlIixArbhKbZ0Y
         aBh5eA0WqynY220QzYshbuLS8Wp5EdTHwX3R23S1B+Sx22Aiweel8QFi/LEvIlojjcrm
         5d0c3/cb7aKdgc8B07Mhh4dz5v3asWK35yBqB0euN++eosLdNRIg8vf6fIo1KdaQ7jIj
         g+Fg==
X-Gm-Message-State: AJIora/vJAEILpaZPxsR2zfdKmCOGpJ8sujc+7zO8w1t4wVIlrFEYJzi
        em6plCn0Rqd830WFwgQCzIo4aD80E3k=
X-Google-Smtp-Source: AGRyM1v9kW5QkJ7txPbJ2wbBnmnKx7n0zh8SlRr9e8pUg1+T0qGL/PY7sqMWVgiX+DZcxx9VtWqNPiGmxJI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9e9b:0:b0:528:2948:e974 with SMTP id
 p27-20020aa79e9b000000b005282948e974mr24092040pfq.79.1658964873498; Wed, 27
 Jul 2022 16:34:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Jul 2022 23:34:22 +0000
In-Reply-To: <20220727233424.2968356-1-seanjc@google.com>
Message-Id: <20220727233424.2968356-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220727233424.2968356-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 1/3] KVM: x86: Refresh PMU after writes to MSR_IA32_PERF_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
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

Refresh the PMU if userspace modifies MSR_IA32_PERF_CAPABILITIES.  KVM
consumes the vCPU's PERF_CAPABILITIES when enumerating PEBS support, but
relies on CPUID updates to refresh the PMU.  I.e. KVM will do the wrong
thing if userspace stuffs PERF_CAPABILITIES _after_ setting guest CPUID.

Opportunistically fix a curly-brace indentation.

Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5366f884e9a7..362c538285db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3543,9 +3543,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 
 		vcpu->arch.perf_capabilities = data;
-
+		kvm_pmu_refresh(vcpu);
 		return 0;
-		}
+	}
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
 	case MSR_K7_HWCR:
-- 
2.37.1.359.gd136c6c3e2-goog

