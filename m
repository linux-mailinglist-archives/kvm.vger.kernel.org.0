Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F02A412AE7
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241631AbhIUCCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbhIUB5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:46 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1B7C08EA7E
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 18:01:40 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id r5-20020ac85e85000000b0029bd6ee5179so198822583qtx.18
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 18:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XqeN3hyu4xVF/UFXFp3XkUay0dLcSsRd5uf44abCA2Q=;
        b=HlQnSCmXttBhWRfulvS9JxQUQJlpPBD/crbVGiQ7AxEI2pbDQrmfVVS1TrWccw05Ez
         eCEsECHpCm917mn23DJC9oZgkSzmu3asArrLun7/xRx3hNhroie5AKTRnXBi6yxoKHoC
         b8GKFhPnoo+BgJywlBZdiDb/6n/3Q1mq5w/RXjJVKxT7iiB2y++xEYRtbRwzJi8A/huk
         FaDjs6fz5H1BJJ8DL/iyaU72EoY1d5tkHHZEoT5qdqIDOkY+8BkMvBelQfJ8mdzapsbD
         d/9Sj6LOnSH4Dq2uOAaFw4RaX7m0U6znUaYtajJHJWAvtiliUjl7xZwx2mdQh50WPD7E
         XLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XqeN3hyu4xVF/UFXFp3XkUay0dLcSsRd5uf44abCA2Q=;
        b=Z0M/jkDC8f4nIf5ApU4bpKzgcwUU87ruLRcoYqJllLTYZWG2YfntUS5Ou/NNdOh/M/
         IB4RgdoGrT+ftfVFVWgbhdcCoRYHJpz1D1OSN7NxqsWKKkldNcM4E6+/3e4zBe9cILma
         PmTW5WBDTNtYZ2M72HId/z5oLxfRWUJ/iHA02sbKhltBO4BsZ8hdRJ9nKQCfCMrF16Xu
         jjROJ3zn1a8BV9N39q+vgq/XbpbZ8ir6h+3BacYtvRP0bRoOtThciIn/DN38UrXQO8r8
         /2ySJ1XXHRpBubxiAFy+vBfwWSAG7dFnTYpryCT2l1qjQk6kF1YX0nI4nK7X8iJRvAd4
         AfSQ==
X-Gm-Message-State: AOAM530LT52o71dvAKad/Viq5tH92d1FaJ7PtrSlyYVHY6zzyuKNAwt4
        ftU204+vl7jML19U1CxvD6mXAYkm4ZYbhjaMaDIrhxno927w87L4HIS39TR/dJ3blbTHzrHwIsQ
        mVlx9Jij9BIH23224sLnWa7DOftid2QZzr/bSxMIELuyE/ArV1ZynvhMOyw==
X-Google-Smtp-Source: ABdhPJw4f4/voRxb0xXPFNT+rq0rQnSg1TwSBIEaiOSR4mzrEZAZp1YmF5XBLZs+tg0K7NHBTbfgA7u7PCM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:408:: with SMTP id
 z8mr19753705qvx.21.1632186099152; Mon, 20 Sep 2021 18:01:39 -0700 (PDT)
Date:   Tue, 21 Sep 2021 01:01:20 +0000
In-Reply-To: <20210921010120.1256762-1-oupton@google.com>
Message-Id: <20210921010120.1256762-3-oupton@google.com>
Mime-Version: 1.0
References: <20210921010120.1256762-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 2/2] selftests: KVM: Fix 'asm-operand-width' warnings in steal_time.c
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Building steal_time.c for arm64 with clang throws the following:

>> steal_time.c:130:22: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
          : "=r" (ret) : "r" (func), "r" (arg) :
                              ^
>> steal_time.c:130:34: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
          : "=r" (ret) : "r" (func), "r" (arg) :
                                          ^

Silence by casting operands to 64 bits.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/steal_time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index ecec30865a74..eb75b31122c5 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -127,7 +127,7 @@ static int64_t smccc(uint32_t func, uint32_t arg)
 		"mov	x1, %2\n"
 		"hvc	#0\n"
 		"mov	%0, x0\n"
-	: "=r" (ret) : "r" (func), "r" (arg) :
+	: "=r" (ret) : "r" ((uint64_t)func), "r" ((uint64_t)arg) :
 	  "x0", "x1", "x2", "x3");
 
 	return ret;
-- 
2.33.0.464.g1972c5931b-goog

