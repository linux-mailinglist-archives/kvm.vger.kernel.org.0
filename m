Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF906DC5EC
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjDJKv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDJKvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:51:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BBD4EEF;
        Mon, 10 Apr 2023 03:51:31 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-24677297572so110641a91.1;
        Mon, 10 Apr 2023 03:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123889; x=1683715889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdQCFY7on5P+S/gm8INkvpwBpAxQTaUMH+FZDvUGdXY=;
        b=ho2riEP7y1sxLHyQL07IlwBlbWd14tnATzi3WcnzbTF2fZGfrEmQR816WFcw/eiaac
         5bUOLFVPCMh56byqJvK/O/xajl/T6PGSi9416bagR7CADPOC6Zhv27L7ATGr/xp3ZTVy
         WUpYf/6U5Jutdbwz5ieBo+TPR8qB5JagpfuFzUTzwb/E5wI61EWXA+iPMAnhL54saXaR
         muy+/fuB+eMmV7i/CmNOcOQ070rArwKZv7chlMwxuT4FQVDGQwKvw7S/xvCD1Y4mfblT
         ItWOfHajAmUAM/yBlSfeZ+b/8Slju2WEXkhP0HBwLAfC+HJ8wfqEfbUrbIPsF3Nf9Hxg
         OF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123889; x=1683715889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdQCFY7on5P+S/gm8INkvpwBpAxQTaUMH+FZDvUGdXY=;
        b=VbFXChg8BOtSbPhXgRlgkaNhpotyP0BGo/6Vj649viUezjrDmJtQoKD125Fn2IlwZy
         x6f01u3xb5dHVT27FvG6riooruNZKDV8pPTN22Dd6bq8v4MpkuwKUxaswX+L0cEHYwTj
         lKYS4pw944Al2bBxW8yP/oSnS65+6bDcWh+HdNbulDFzcBYtkogq514/rnExZXqHLomN
         iI9lvuc0uK/D9c1yOXrp78g3o+FxICf8TA7qlUr150gg7xrtQTw/HkQP7nOXauqRGZOU
         b+ChOROgPV7rZX7UbIZbo6ok1ToPAVkxx9uF2xjJxdWbaiUCkj/T/rPyrbWYR0QyKl1f
         U/Fw==
X-Gm-Message-State: AAQBX9eL01TM+bTLTQMABnP8ApD1f3abnMi5xWUBwzr7Vy9cphnGF1X6
        qVb0yefs5rd75McshIoC/dvZTE9Ds5PZ1g==
X-Google-Smtp-Source: AKy350Y2H5MnE21z1fJM5d+wBKkUnCfLnEpP37PjlWbxSWNTt1qP3IA1yZs/v2Tywlu2yQgEz5GoKQ==
X-Received: by 2002:a62:5255:0:b0:638:7e00:48c4 with SMTP id g82-20020a625255000000b006387e0048c4mr2452892pfb.21.1681123889559;
        Mon, 10 Apr 2023 03:51:29 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:29 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 07/10] KVM: x86/pmu: Constrain the num of guest counters with kvm_pmu_cap
Date:   Mon, 10 Apr 2023 18:50:53 +0800
Message-Id: <20230410105056.60973-8-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230410105056.60973-1-likexu@tencent.com>
References: <20230410105056.60973-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

A sanity check is added to limit the number of AMD guest counters,
which help avoid a situation if KVM only has access to 4 counters, but
user space sets guest X86_FEATURE_PERFCTR_CORE anyways.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 70143275e0a7..825b9cc26ae5 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -170,6 +170,9 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	else
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
 
+	pmu->nr_arch_gp_counters = min_t(unsigned int, pmu->nr_arch_gp_counters,
+					 kvm_pmu_cap.num_counters_gp);
+
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
 	pmu->reserved_bits = 0xfffffff000280000ull;
 	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
-- 
2.40.0

