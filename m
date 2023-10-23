Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1EC7D4009
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 21:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbjJWTP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 15:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjJWTPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 15:15:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57460D7D
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:45 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9d4e38f79so25889975ad.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698088544; x=1698693344; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eiZt/+wI9eMzujwJOYn4T7DeU3jLiOyNdg1QxK6FtbU=;
        b=gOAWmjEgZtYGEB0iSjm8I3RM8CCti76P/TArNciMEhBu4ewCA8rleY3mAdcliL/M8P
         rsDprRgvh9h/2ONyCx3r+05jng4vapHNZuftBVVDBkQAL4JKAU+4k6e/DAjra2OWADJK
         pzQL+1x0H5m5UofZbv8i17sSWXOZSWtupJH89sy0SEt0EL3ysT/qGLOuqP0k845IvBKJ
         TPVk7+KIrkQmK7stimX2zUBLDWItUzyvmOL13Kq+0nXvkGpWa81AnB3TLvhXG/XcIXpb
         2Jp26uyP1nhha0F8/N8bbYPg+UFX48TH6ANJLZjN1ZtqQpzfY67CtM7aUpRrenSYhAv2
         F8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698088544; x=1698693344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eiZt/+wI9eMzujwJOYn4T7DeU3jLiOyNdg1QxK6FtbU=;
        b=VCaI+Vdhl3N4mDm5lZYCbLO5SSsAxpJJabIRbvlmsloDud7c6+LTF90wOTB7XyXZ1J
         6pJedLqxbK/Gz1JgidWaFQr4xW47zzOdDVKi+ui7J7AdNa1nDZMkzAQTnKcACQHYXXe7
         UCjdlYy1GxTOz0HWZChQ2PoZCb/UhnvO80bvf+mnwKG2rOflQyt9Ul/LFSYt2m8QYepq
         QxIYieBENeXU3jCrSlC0uNO74k/H3t3K0dL8U+Zj/k2YPvpoJHY257w31Q5OOdTWpwl9
         oRlZeuSoKLBv6TKZDGAO+IvJtOSlaOnwiYhcis4uENJ5+UAMQhvLfqtBMCK/dnHggXJO
         4F6Q==
X-Gm-Message-State: AOJu0Ywawvcbe5tG9jMUmUzigDsfJltXhWT23sSTo1SvAUBriTTRWy5U
        EvFrqhBh+m9UxUeRV5rmVc7DIUXK9OU=
X-Google-Smtp-Source: AGHT+IHvM/7DrpLAUS1fN1/Iuse8ZMaLK7cnoqKjQ8ah5h6JCEi7IlOdAQVO9GcFeJcEm3diY01sNu6/VXQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c101:b0:1c9:f356:b7d5 with SMTP id
 1-20020a170902c10100b001c9f356b7d5mr181646pli.7.1698088544608; Mon, 23 Oct
 2023 12:15:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 12:15:32 -0700
In-Reply-To: <20231023191532.2405326-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023191532.2405326-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023191532.2405326-6-seanjc@google.com>
Subject: [PATCH gmem 5/5] KVM: selftests: Verify default pattern was written
 in private mem conversion
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>
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

Add a super paranoid sanity check in the private mem conversion test to
verify that the initial "default" pattern was actually written.  The check
doesn't add meaningful test coverage, the goal is mostly to aid in debug
if something goes sideways, e.g. to give the user confidence that the
writes didn't somehow get dropped entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/private_mem_conversions_test.c  | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index 8a2f924fd031..91f343609e18 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -129,6 +129,7 @@ static void guest_test_explicit_conversion(uint64_t base_gpa, bool do_fallocate)
 
 	/* Memory should be shared by default. */
 	memset((void *)base_gpa, def_p, PER_CPU_DATA_SIZE);
+	memcmp_g(base_gpa, def_p, PER_CPU_DATA_SIZE);
 	guest_sync_shared(base_gpa, PER_CPU_DATA_SIZE, def_p, init_p);
 
 	memcmp_g(base_gpa, init_p, PER_CPU_DATA_SIZE);
-- 
2.42.0.758.gaed0368e0e-goog

