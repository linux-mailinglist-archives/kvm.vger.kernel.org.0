Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3BA3C93DF
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 00:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhGNWdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 18:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235538AbhGNWdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 18:33:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0804C061760
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h1-20020a255f410000b02905585436b530so4748627ybm.21
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NLo2orw2GrujjOHbkY0DlGp9/FL5YLDeLP3ALI1aHhM=;
        b=G4hul3bnSLj9qvJAnOnLCK17khPm4foRgCTwXc4l4zgP2yieKnyScK2wI5PUMF8BUf
         Snj5M4N6oJjq9eyI8P9uKkPkxJme8112xSa899olrd4QJvobjBJafq4SaSvBM2RDogHq
         UfHY3z7ZaMgX/v3Pj0LyiRD1snrf53wFsnQDJUFc3KgWeJgKptjQz+U03NtkpBKr3++C
         M+UL3cUjkPqz+GRugB9zn67UJ9rqprl+atvKWF+00wbAxNvoF8UzEwbkG1M4scrD4KFZ
         hi6Sz4U7qmUvCWLh0c/SONN25bNkbYLC3tX3zjhXi7VMM7tyeUpi6Z/mtuAL77EKdGfi
         mxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NLo2orw2GrujjOHbkY0DlGp9/FL5YLDeLP3ALI1aHhM=;
        b=PlFAAw9SmHZXAJ/48A5sFfN/onDAY5cYVninxL7a2If+3kFREnu0SoChU1nsQTi+2Q
         9Bm2VoYEWnwADgMKYrkltyP17u1DE4N4ATnici8Oqqa1FepS0GwjX1yidWi1sorDh2IU
         TYKbTI5XPZc4P15Zh9kefbMFf97AzcJMmACKC7ms7tVAS4cbpv43rHiwQF81jEzLYdVq
         zY+mX4ekiZra6rIvY+NaXGD3bcaQ7S4/ChoBZuIJZ3wWJ3zpJ7iM0yykfcz4E2BPrEE/
         NQvbodJXPwRvqTXq5LLvVG3KpmU3zbAf7SaE0Xs+UL37wE3D+JClrQs0TjC1QTG2ORNY
         tELQ==
X-Gm-Message-State: AOAM532pZksMZ+uiHKrhY7jVscL9s6nqbQrfV8xavYx2wY+oawxboQfB
        Rm+YnctLNhh6PP6binhwZasfvrARqT4ybLFFLKQRTIcVpFzmGlk9biuQNADVhiM7rc+nN61wdTS
        rpl5Ni3e0ftKIMvrVkaZEDC+U/tcePGegyAbecsNFJTnuJU8R+Yi+yqp+VkexDoNkC+nonLM=
X-Google-Smtp-Source: ABdhPJwRpOHjHJzu/zQxNv/BIxT6+OmPYhVERu/lrtpL/BGir7IgLCbLCtnY47LxeFknQwTnK7DC7FRXYtPykbGkxA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:d912:: with SMTP id
 q18mr323595ybg.294.1626301843001; Wed, 14 Jul 2021 15:30:43 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:30:31 +0000
In-Reply-To: <20210714223033.742261-1-jingzhangos@google.com>
Message-Id: <20210714223033.742261-5-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210714223033.742261-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 4/6] KVM: selftests: Add checks for histogram stats
 bucket_size field
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bucket_size field should be non-zero for linear histogram stats and
should be zero for other stats types.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 5906bbc08483..17f65d514915 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -109,6 +109,18 @@ static void stats_test(int stats_fd)
 		/* Check size field, which should not be zero */
 		TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
 				pdesc->name);
+		/* Check bucket_size field */
+		switch (pdesc->flags & KVM_STATS_TYPE_MASK) {
+		case KVM_STATS_TYPE_LINEAR_HIST:
+			TEST_ASSERT(pdesc->bucket_size,
+			    "Bucket size of Linear Histogram stats (%s) is zero",
+			    pdesc->name);
+			break;
+		default:
+			TEST_ASSERT(!pdesc->bucket_size,
+			    "Bucket size of stats (%s) is not zero",
+			    pdesc->name);
+		}
 		size_data += pdesc->size * sizeof(*stats_data);
 	}
 	/* Check overlap */
-- 
2.32.0.402.g57bb445576-goog

