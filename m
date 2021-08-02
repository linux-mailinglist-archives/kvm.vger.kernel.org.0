Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9913DDE1A
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhHBQ4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhHBQ4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:56:52 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2F8C061760
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:56:42 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id i8-20020ac85c080000b029026ae3f4adc9so10224239qti.13
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qUyk13eLyEOR6oe2vEOVV1kByiwt+wSu/VyODCpu9Lg=;
        b=qTdlf41oYQ3fGX3v70dFvv9Cfb4TBTpqXUX1/LYjGGNmKYpSw5mF5vPd5q/l1IkftA
         Zo31WYzRjXjcnVmlNhriRcPKTtUNk43FRCR6rtsLEpPT0shk5nlRzIfKMLEFS5k7/UGF
         U6MK0M8ryORow6DQHeHKDu+tpGtAGOJOW0qbzebsm+9ArupTEMOF/SFSwFQtzbLiKaA3
         nWq85uJJAVPS5aX/RBuv2zo8gBqLcyTDHxFNMcchoblTErKDLsi2dFfUlPNjYkkRQjut
         hy1MNoFq4Y5Lg+vUzdA5Fiw2U5e2PCCI53Acd6e4NlojQbaLBL1RqUan7yiH7q6UeOiY
         9/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qUyk13eLyEOR6oe2vEOVV1kByiwt+wSu/VyODCpu9Lg=;
        b=ovM6NQcwRfq7l5D/uRJhdLb0RfWizGG4FOPp32IpvBa5nts6W7t+d3dV8ME2YPytLt
         ktsoEQyqmsbN/5+sct3VLHymBwq/IRDz2+FGsQZ+JZB1ptVjAdIqqGbN2x4fKRolgHyX
         QEdgadIe80O27L1MjSRJGpmtgVoeM9RXN8CjDusffbfBYIH9tu8Oy5QEkiidnaRRCimT
         8hNJeoomzkvHlmj1yaDQqOV6DjcuNy5bltMZuefIr+/J5j6+ezfQ7o1i/rF/tuI3i/zv
         naKggpPpTeTA1A5GpPHcCfXM5qtlVJvJqFZWBhLu9jsRdoCLC3KMhCvkT+PiNOiztgKI
         LEeg==
X-Gm-Message-State: AOAM533yRiGNBkwZ78vGkVvLprWyiza5VMzvT1ZtvX/YwN9vASWZRJ7x
        OKpt7fduVtsZHnsQL8m11IiM3LgW68HkWUz7cn2ogXO3YDTez89gJK0KCzUGQa2YNif7YqOhQWi
        UtTrWLc0ggCRlJNWymwKQ6Pitjg5n8rAHwWPNy/nQbU1kK+vOlzFJjC+qfZ5DWofKvUN9ing=
X-Google-Smtp-Source: ABdhPJzyn03FMrvI3DW2lujmYEnJN+51+he0wDLUXkIp4Sld9hR6wQIhMTytEAiSkkWBJFITdk7ZsaHzJTJ2VPs9sA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6214:2a3:: with SMTP id
 m3mr17080038qvv.55.1627923401274; Mon, 02 Aug 2021 09:56:41 -0700 (PDT)
Date:   Mon,  2 Aug 2021 16:56:31 +0000
In-Reply-To: <20210802165633.1866976-1-jingzhangos@google.com>
Message-Id: <20210802165633.1866976-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210802165633.1866976-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 3/5] KVM: selftests: Add checks for histogram stats
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
2.32.0.554.ge1b32706d8-goog

