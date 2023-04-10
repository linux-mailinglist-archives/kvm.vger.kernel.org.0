Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BFD6DC5EB
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjDJKva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjDJKv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:51:26 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6714B524C;
        Mon, 10 Apr 2023 03:51:25 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y6so3266944plp.2;
        Mon, 10 Apr 2023 03:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123885; x=1683715885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nclgzq8WtyZ1+xk1YTVx+Ewh/gXBkQ8n12moFV2Itz4=;
        b=C/x6kxugKGtAGTrMH1tpfg/1M/hRHZRFz+TG3lC7ikHjxq1rq9oWYnLC2bNP0LPMG1
         A0kQNgTSRrvk4YSSt7cEy9V7iGOpvts4IZ6jA3TZduXgcV/MGiDr9Oj28hIN5nsgRavo
         IFDkS7dEcb1bIZkBWBUK+KJJszIk4vtyo6hLYfsE2RQnkx83pUh8CVN+c/R1CzT4wFnz
         LOIurwilFQKWmkM/fZPSAeO9GN92bXyokF28vJURbncNFh5+s5I25o1cvH0Q7/1zxKGs
         Y+3WaEfFY7nUKWViNM28J0qBVcxzmMif3bxyBnDkpCVa3+yXt03tzq8ECpn2VkV1EfxL
         52ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123885; x=1683715885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nclgzq8WtyZ1+xk1YTVx+Ewh/gXBkQ8n12moFV2Itz4=;
        b=J25diYgygdH5UZ72gpidDP+Gpav/leSFxvUKz0qyIerI1+UGzPJpJe+IT5eCCfAxW2
         Wivz29brrk7JzdR00QVshMYGLh8g8vfpmHEHVTmvcloxjpfcohfN44h4FjW+mq3+GNjN
         75gc65g8kcLjTx57LEkbU0P9Vw8brjsNEJODrQXtsxd3MZm53Ya8Ri40jNGMz3+i0dpN
         zLNbCdttd9HK3ThfaPAkiMNJrc7vwR1T913w+a9KrMAFLKzskmFp9+vI0vb5Gpc5VBb2
         3joRS94mEE+4B33kjUsR9rW0lnsR9kQhi86Hqy7BUymgMtYLuXGF0F6oKPu56AhK97B9
         7TnA==
X-Gm-Message-State: AAQBX9fMZPKq4X9LAAWVMWZcvL2FFq+rO5TmUw6qu6FU2zooyjUzPJce
        Xi4wIGb05OhxpyWgYf6KMMljC4X1Hj34BQ==
X-Google-Smtp-Source: AKy350Z8WqRqiSvdGcreKnPE6ZKaAV3Vm7B+zv/kjtVUPmq5Ug7UGAmCULR1vvv8jV4JvwyFYuunlQ==
X-Received: by 2002:a05:6a20:4c28:b0:cb:91ee:dca0 with SMTP id fm40-20020a056a204c2800b000cb91eedca0mr10018990pzb.41.1681123884754;
        Mon, 10 Apr 2023 03:51:24 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:24 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 04/10] KVM: x86: Explicitly zero cpuid "0xa" leaf when PMU is disabled
Date:   Mon, 10 Apr 2023 18:50:50 +0800
Message-Id: <20230410105056.60973-5-likexu@tencent.com>
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

Add an explicit !enable_pmu check as relying on kvm_pmu_cap to be
zeroed isn't obvious. Although when !enable_pmu, KVM will have
zero-padded kvm_pmu_cap to do subsequent CPUID leaf assignments.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b736ddb42088..52a7acf2c965 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -970,7 +970,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		union cpuid10_eax eax;
 		union cpuid10_edx edx;
 
-		if (!static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
+		if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 			break;
 		}
-- 
2.40.0

