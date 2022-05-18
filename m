Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1321452BBD1
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbiERN0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237800AbiERNZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:48 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B011AF;
        Wed, 18 May 2022 06:25:47 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 31so2122890pgp.8;
        Wed, 18 May 2022 06:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fWq2dft195z67E3HmJbQS7CQHaiqAGijLUxUajn85g8=;
        b=SAmoBGLWGdD9VZvDpKQEOA25kznLhwkX3Asno5SON222ZqJ9OTUZOmLCwDXVCbqJpm
         AIHkHTKIH78SItD9TV/qOxSkrghPH7RMSjApSt57Rbl8XW1wEH0SK/8+nfGrPVnoqqkX
         17HnINiFrua8UMbdX0QUj0NCDbQgPvQ9qAjOsHBWPNaHXof7UMyTSaotuk6jsWxT95hm
         e/2L+og0C73hUEQuh82ExL6ud3w1m910srRYWkjLd6teA1OQ5zOAt9+yeEfFnhhKXjwK
         a4F1lXvsW6132LJrnhJ8U5nNSCkqKvcrWZQ+yLMSYZOrdoGJFi8BMriSKrqodjH3gvNW
         S6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fWq2dft195z67E3HmJbQS7CQHaiqAGijLUxUajn85g8=;
        b=0b4MVa4q7NHGGEiBUScVbpn3hOpEJQQd+yw51Liej1TMYlJCAtXqNWMe5KOuswxr/8
         D4sVKukh8YX51WgoPuNCpyqLk1dKoznmnvELjoJbBnTS6JuCf+78SixTRu4jCaKZ2EWY
         X4rQuKxud+NK+2ICXdLxeo3meCkxbb3Un9k4NnP4QEZ0ahrLgf7FK/DUvT/sHnS1pe8f
         oTkUGLqOxsVN+wbhI2k6psvcx+XG214WQC3YK1HxMT66j2u/1R68g+mzdWGbjyu+RNoh
         JgkZA6OeASSzEwidW6QorarCDmc9ViXTV1+dUpQGUxxyiVojxNEpJGhQiz3kr5TAvp/W
         6XLg==
X-Gm-Message-State: AOAM533ZcpaG1kOVCGrE6aBRLwCCDoZxGH070ho7tK4WuHxTUWG9sL3m
        QKLDJyaU+HxTbohZuV+xx28=
X-Google-Smtp-Source: ABdhPJxCiW4vNidQr8d3khFMkKX2tm2oQM/WD8vaW3HKyU18UDKF1u8TMcdp4aq/dq6zQW78s0K6nQ==
X-Received: by 2002:a62:c545:0:b0:50d:2d0f:2e8a with SMTP id j66-20020a62c545000000b0050d2d0f2e8amr28009615pfg.12.1652880346560;
        Wed, 18 May 2022 06:25:46 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:46 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 10/11] KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
Date:   Wed, 18 May 2022 21:25:11 +0800
Message-Id: <20220518132512.37864-11-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

With the help of perf_get_hw_event_config(), KVM could query the correct
EVENTSEL_{EVENT, UMASK} pair of a kernel-generic hw event directly from
the different *_perfmon_event_map[] by the kernel's pre-defined perf_hw_id.

Also extend the bit range of the comparison field to
AMD64_RAW_EVENT_MASK_NB to prevent AMD from
defining EventSelect[11:8] into perfmon_event_map[] one day.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 33bf08fc0282..7dc949f6a92c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -517,13 +517,8 @@ static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 	unsigned int perf_hw_id)
 {
-	u64 old_eventsel = pmc->eventsel;
-	unsigned int config;
-
-	pmc->eventsel &= (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
-	config = static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc);
-	pmc->eventsel = old_eventsel;
-	return config == perf_hw_id;
+	return !((pmc->eventsel ^ perf_get_hw_event_config(perf_hw_id)) &
+		AMD64_RAW_EVENT_MASK_NB);
 }
 
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
-- 
2.36.1

