Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7B1695833
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjBNFJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjBNFIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:46 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A59D1A4AA;
        Mon, 13 Feb 2023 21:08:30 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id ct17so3849037pfb.12;
        Mon, 13 Feb 2023 21:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGZyZD+oFSHPBtvJdi5eUX94B7yH65jttBvLfq2sBHY=;
        b=DGjr5dPheoMmqyZ35GGMNVLFwdr+aYsud7V5ikRqbHU8bOBqg9DMtcaDVpMGvJ6Gm3
         RozvUtMZ8gPkmMJeC2oA2UfHyg5TmEz7pngd+s+NwlPttgN9SVsyngu76fNbHh8wVdS1
         fZ4sSAXDWz3gHm0lVtLuw942/WLQypJqGkWCkwRHCqA+xWGq56yzGRBgm8OtO3DM0qeP
         ECxT9wfaLadKIzRvLcqhLdsifZlGYLtjYUZzCqtMl/Wkp5nvaNK8TONXozJzz0iyulbv
         +xwn/b8lBJEQ9uTmPWfu0lHZjxsaPjcQEJAr3LJ9TQ/8NpZl2oGB/rKTKXSaBQBFDODG
         6TRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGZyZD+oFSHPBtvJdi5eUX94B7yH65jttBvLfq2sBHY=;
        b=UOpWIjFZGprSh2d1sVQqKH42w5/ukdVmk84p8km1rhkKRjmHLxmxJMnCo7Q8Yn/HW8
         B+t50yqKhwo68OzQ++L4N8v4m28/Wm+4grIm50jCDkN2c0jHCD2GC9pR21l3u3J+UXTs
         tIVReG+IIy41wYl+XfMjzrgkweLHkiCqQZtPqbyjkprwrHpYC2InzmtV7RZ6wrx1A5sb
         sPofEcQGnAyQ3mloyoLATzxa1WSb3CayIqrnl9nQ5ql/XgNKmVM65YiGtb/iT+n5WbWI
         HQlIn9zJPbEdCmZQusIrLHXP2JYz0NpbIQCDCDOBqIkc/Mg525PxZjZZ1tfksYaXuSkP
         k/ag==
X-Gm-Message-State: AO0yUKVI9fBDIwKX1NFX5XR8pjyHCgLp2u/QgCnW3umdd1S4/xjmzNxm
        gZviyYcjD1CwQxQE+TcOK8I=
X-Google-Smtp-Source: AK7set8kvsKLYQmWAz3VbEqn3OG5uWzSP+VExguQmet3hnsY/zLwpf/BD187GZ8gY5r1Wci9NFoQbA==
X-Received: by 2002:aa7:96d4:0:b0:5a8:b417:d85e with SMTP id h20-20020aa796d4000000b005a8b417d85emr866791pfq.19.1676351310296;
        Mon, 13 Feb 2023 21:08:30 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:30 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/12] KVM: x86/pmu: Disable vPMU if the minimum num of counters isn't met
Date:   Tue, 14 Feb 2023 13:07:53 +0800
Message-Id: <20230214050757.9623-9-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
References: <20230214050757.9623-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

For compatibility with old software, KVM/AMD should never report less
than four counters if vPMU is supported. Thus KVM should sanity check
the number of counters enumerated by perf and explicitly disable vPMU
support if the min isn't met. E.g. if KVM needs 4 counters and perf says
there are 3, then something is wrong and enumerating 4 to the guest
is only going to cause more troubles.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index d1cc02c8da88..46db5404894e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -170,6 +170,12 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
 		enable_pmu = false;
 
+	/*
+	 * For AMD, disable vPMU if the minimum number of counters isn't met.
+	 */
+	if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS)
+		enable_pmu = false;
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
-- 
2.39.1

