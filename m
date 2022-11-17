Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1D462CF60
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 01:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiKQARW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 19:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKQART (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 19:17:19 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDD12F3AE
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:17:18 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-348608c1cd3so3511727b3.10
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wWePj0bQA1/kzPBMW9NDA2i6PqA43d1wk3qWgf/1HPQ=;
        b=Ccqan6Io0sccVr56cWwZ5bc8eYLQQ8TsUx7pJZYs5pgYbAH7BABVJVA7h5OuJFMVs8
         p0Dhn38bluFQFKnNyFs9v+f2314YeOkSztoi6UT8c7MAq8lXp44rtJLR2R5+D+0O8Etl
         kFFtW1Bv1wXWEggnpnQ6rHisTDDSdPlGxT7/KqrCFIMMCEGbT4pz2IvI2bGNZngU5kxM
         Zy2yBmCFlzFjpbYTYdSLEsdOLk1xNhpm1tB1r4XgWR2GOLUOn8kO32Ik0LxcTAb1FjSJ
         vNb+jqDVMAqlmOOj+Er3hcvqCJotWSHGz64xBqehCpeHslXn6xYfbOZjZ9mEL3Xi2+Q0
         VivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wWePj0bQA1/kzPBMW9NDA2i6PqA43d1wk3qWgf/1HPQ=;
        b=bp5Q6bdkUURQBaoXGk8M8P6wKS0cfFONPUK47QE7Q+wUjoxV2UCynnTZs2gg9yH8P8
         dnCjugedmZLyC94+OWzFkbYFqUVeFFgApY7zjrOxIooL12bk1gwpJVGFWIRwRFkRgRI8
         c66x1irGEGHghhWZ0R0chYWMfSJI5+ojP91Wi0l7y0k6W+U9msuua8gjIxYv8trHCC+s
         5akK6SeKG9RSwiykt/MjpeKZx+CC+B7Pf6m9ZnWKadA52Bex7GEFvcoRbo8NMA4W9HIX
         cfoelg3izNGXNWDOHsE1V/UXq0pr9bQfnQj7c3pdnbdxkGyePEiEieQ9T5BBFMM5zczW
         YcGg==
X-Gm-Message-State: ACrzQf3xNj3GPhTtvKkxk1NrJjUw396tl75DjGfWT0nVsTaybvMBuK4f
        EiqwyTFL7oS1BWOhk59WY+lHwir9MhkwzQ==
X-Google-Smtp-Source: AMsMyM6mqt9TJeQDgekBXV4PA9YAEpC68Hafg4FU8gT5Xw8qZCKneVC03BOR+B0yQpSxPQQdevYnXHmhUyvPxg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:cbd3:0:b0:357:adb2:41af with SMTP id
 n202-20020a0dcbd3000000b00357adb241afmr63171409ywd.240.1668644237665; Wed, 16
 Nov 2022 16:17:17 -0800 (PST)
Date:   Wed, 16 Nov 2022 16:16:55 -0800
In-Reply-To: <20221117001657.1067231-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221117001657.1067231-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117001657.1067231-2-dmatlack@google.com>
Subject: [RFC PATCH 1/3] KVM: Cap vcpu->halt_poll_ns before halting rather
 than after
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Yanan Wang <wangyanan55@huawei.com>
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

Cap vcpu->halt_poll_ns based on the max halt polling time just before
halting, rather than after the last halt. This arguably provides better
accuracy if an admin disables halt polling in between halts, although
the improvement is nominal.

A side-effect of this change is that grow_halt_poll_ns() no longer needs
to access vcpu->kvm->max_halt_poll_ns, which will be useful in a future
commit where the max halt polling time can come from the module parameter
halt_poll_ns instead.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 43bbe4fde078..4b868f33c45d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3385,9 +3385,6 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
 	if (val < grow_start)
 		val = grow_start;
 
-	if (val > vcpu->kvm->max_halt_poll_ns)
-		val = vcpu->kvm->max_halt_poll_ns;
-
 	vcpu->halt_poll_ns = val;
 out:
 	trace_kvm_halt_poll_ns_grow(vcpu->vcpu_id, val, old);
@@ -3500,11 +3497,16 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
-	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
 	ktime_t start, cur, poll_end;
 	bool waited = false;
+	bool do_halt_poll;
 	u64 halt_ns;
 
+	if (vcpu->halt_poll_ns > vcpu->kvm->max_halt_poll_ns)
+		vcpu->halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
+
+	do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
+
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(start, vcpu->halt_poll_ns);
-- 
2.38.1.431.g37b22c650d-goog

