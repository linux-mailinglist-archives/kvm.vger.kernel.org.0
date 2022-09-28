Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC78E5EE49A
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 20:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiI1StD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 14:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiI1StB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 14:49:01 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84133E1195
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:49:00 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h19-20020a63e153000000b00434dfee8dbaso7859358pgk.18
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=TtOHi6e92kA0TOmjMk92oNS7bkOOqOLRO3L0QpCkPeA=;
        b=K3x4iKg7JNuL+8lYu5TZAjuPJhTtgWHoBB19AmxscQcay2tGdU1hGjUuVIBuMhMkj7
         oPnKrStZksCm9cGfUTDEjz32+IS+FejtfMwbC8mFSn7CLPEem6+oRlH1eq95msWQ0X1w
         frIBXZQj86SQFLE/pDcZMUaGrSg61VaS+mGLmO0TqF+Nfp/Nu+q9JXA7D3IRTaFPuD1C
         Rbdcq+WFyU+9jjjLKx7r2xlXaB8CV17/axekcpJjeAZS+y7GlsFOP/zvuIV0Sqpc6g3F
         hkwy5a9q5bF5XG/Iotf7Ou74jBu7rMgRizigkjQI58yiR+C+0rqZNMdkpC6NuM3himUC
         8Wsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=TtOHi6e92kA0TOmjMk92oNS7bkOOqOLRO3L0QpCkPeA=;
        b=R3/xkmRcaQZ5VSw2zoT+iiH2y7/M/1NudbYTxap/RabtLlv6LaWqV1OvLoYgz7V3Ci
         iOQL5RqbzPy8mP/yMT/NA2qvWEgu6aEOij/mbEqaiFUg0i0cwZzuSMYKnKcJtzPjGzrX
         7xO4gUNkp67CJWr5ivlOHZjwonc271z4ZRLeCxuMfKHQZqY+qq5QOwD/U0KY1c+lCSNs
         CtzIHK1H4YYvbCKLqHNOZjcfqhMbzwQL2bf65rIPm13EPG/AvnZqCONSbnIVnrLGtcMH
         GSxTRrlpXqTOWfOOL5MFy5ivFPzGr4RWkGeul3mXgTb+NMWfZI+Xr8Un4sUjPJgP9J2E
         kuQA==
X-Gm-Message-State: ACrzQf09Pis/87R0B+fYqrjSnns8jY4HM1P12lVWEgiHPVvp0a0XAY5t
        2ffQz8eGWH1R5tB/6uFNZe14kq44qfxiaA==
X-Google-Smtp-Source: AMsMyM4hb+iM1q8rtTWxdw8TpZYS4xtfKRWYoVoIxCFKgo+PEasLigEfD5gA2tRH07MUP8tqe0YKfOdCzN4/mw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:902:724a:b0:177:fd96:37bf with SMTP
 id c10-20020a170902724a00b00177fd9637bfmr1067380pll.25.1664390940011; Wed, 28
 Sep 2022 11:49:00 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:48:51 -0700
In-Reply-To: <20220928184853.1681781-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220928184853.1681781-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928184853.1681781-2-dmatlack@google.com>
Subject: [PATCH v2 1/3] KVM: selftests: Tell the compiler that code after
 TEST_FAIL() is unreachable
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add __builtin_unreachable() to TEST_FAIL() so that the compiler knows
that any code after a TEST_FAIL() is unreachable.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 5c5a88180b6c..befc754ce9b3 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -63,8 +63,10 @@ void test_assert(bool exp, const char *exp_str,
 		    #a, #b, #a, (unsigned long) __a, #b, (unsigned long) __b); \
 } while (0)
 
-#define TEST_FAIL(fmt, ...) \
-	TEST_ASSERT(false, fmt, ##__VA_ARGS__)
+#define TEST_FAIL(fmt, ...) do { \
+	TEST_ASSERT(false, fmt, ##__VA_ARGS__); \
+	__builtin_unreachable(); \
+} while (0)
 
 size_t parse_size(const char *size);
 
-- 
2.37.3.998.g577e59143f-goog

