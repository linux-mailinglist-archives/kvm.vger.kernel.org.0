Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E61A49536C
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 18:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiATRjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 12:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiATRjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 12:39:11 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD32EC061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:39:10 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p7-20020a1709026b8700b0014a8d8fbf6fso1137819plk.23
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y8xiYhpGFxFKO0m5kKEQAv7sJcYQ8XNaG5VWu+Ph1Do=;
        b=cxVEz/H8VmQKRFKyBX9M5zJfWSbMQF/9OYmwT3emggmM5vHdPkxOzmFJ/7E1fw9s4I
         skfzh+KiXt6JilmOaf4TRbQ8gThLlMirAnJ20zcwe1v983odsxUGySnflgtdBXa0rj/e
         yX1+pk2cj7MPKaB/+3a4I6iZRZU5UYbh5yZSyzx/MQOHNH6RwJEri4iEiY/YIXCeye/+
         785WAZWGYiljM+NKeMh6QaQurHDmcwaUuuzokGrQauOsmdOJxF7wylWixNDcZZwrPsdg
         4bmg1SAJX8PwQ8Sp6mkyEBlqZ2eYlP0U4isT0ToH/trq3Rpi9ieUsOWXS5iT4lXdzjk7
         qmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y8xiYhpGFxFKO0m5kKEQAv7sJcYQ8XNaG5VWu+Ph1Do=;
        b=LzbmzXZA6SeLeZlAaJ0aopfEfvjP0srCBveeuRY4FcjeefgfzaWtasQ6bufvi3y3a8
         ZZGpD8agP/Eq63Zt6KhnYZUzmQmu/cxncV4U/GHVr1Mk/uv3ovyGXcsoHS7hIo3H4Udb
         9QtFgQ5lPZ+IeZ0DclriEiGxPuj8FU3MRr2XZToNkDYEiIBkgwxsnv9jH7MNvnTl03yA
         Cpv7yEzETB5ernRQM1OxQKARfb34rs/rvEbar+sLRl8BMnxnETbXHeh14D7pCapBlobx
         2PcaUfadG7gGXg3NoCLiu+OnalDFPKBEx2c3hkxR7tU87WUddDGAH/MKAZwjv7epS5J/
         as/g==
X-Gm-Message-State: AOAM530x2xofvh41uHKzUbOrZizQSmLox9n/RU7YIw1vtenTUYoKJpKG
        pQ8PJU1S7Ax+r3f99hsnvQ+XAqrBopFcSURIlRgeZz7GvsyEvhSLIH28DhE0y/4CX7xg7gy2oYg
        UTgyaORrWbOCIMGMoZGRrA+VMo0BSjVuR6d5JT+ROvFaTW5vmP8mBm+4NFsZr8pg=
X-Google-Smtp-Source: ABdhPJzC9BYvVT5ASp9sIiU7EiVvDcMTqU9YuxgO9saDyOy0sn9U/9+7qbwuVqwSHnzd7o0FcQeLF6JwoZs67A==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:33cb:: with SMTP id
 lk11mr11871701pjb.246.1642700350242; Thu, 20 Jan 2022 09:39:10 -0800 (PST)
Date:   Thu, 20 Jan 2022 09:39:04 -0800
In-Reply-To: <20220120173905.1047015-1-ricarkol@google.com>
Message-Id: <20220120173905.1047015-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220120173905.1047015-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 1/2] kvm: selftests: aarch64: fix assert in gicv3_access_reg
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The val argument in gicv3_access_reg can have any value when used for a
read, not necessarily 0.  Fix the assert by checking val only for
writes.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 00f613c0583c..e4945fe66620 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -159,7 +159,7 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 	uint32_t cpu_or_dist;
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
-	GUEST_ASSERT(*val < (1U << bits_per_field));
+	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
 	/* Some registers like IROUTER are 64 bit long. Those are currently not
 	 * supported by readl nor writel, so just asserting here until then.
 	 */
-- 
2.35.0.rc0.227.g00780c9af4-goog

