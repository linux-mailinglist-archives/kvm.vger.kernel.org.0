Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61337679EB
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbjG2Ak7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbjG2AkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:40:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E99C2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d2a7ec86216so468999276.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591072; x=1691195872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Yb5xazjAjbiDk0o4gEkkEuwr9pc6IYfbApM8E9AAcm8=;
        b=YO9ijSHOh5J1cVuChDXZrdsVMawU/dKC3CusW0Frvs07EOOTfINmzinv3GCCjT5pnx
         rOBnaYJ1R1OxykK+OmmG9x2M32byq/ygaqkkxRor1oohX534+fRV0Fzb/g+Z9GJAAFnW
         jexdmXQtuj7Yuu1Yap+4hcJXPNpYrAz7Y0Iw6sVCZTa347oPpKJaGpHJFiBeeTjF0raL
         UHcE4kvGQCnvr0Q42EmvlTszcZBmYKHtuPzFuNbbVtZFsYxggy0fjjFWI9bye8ZychB7
         V+Xqe9MeAa+YJY+J/TBov5lI1fOh7IPV6YbaCwxhJGiYJp20yNxXDngwT0t7StyBgLNo
         R6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591072; x=1691195872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yb5xazjAjbiDk0o4gEkkEuwr9pc6IYfbApM8E9AAcm8=;
        b=KwZp9Y+OVnaooa1jvide9H0oxjQ4ZXIdqZr3KGdHPaeqwTU3rq36QGK8LcIsGBxowq
         Vd+RJNu8MUYLFHOjIHmThAjLlmP+vhf8DLNBBwru6Wjd9wy88v4XRdl6ujZdt3Q7YpNR
         wksXKE7Zi672Xit42kREs6gCnHTj0sycyQQg0T/SOW8GumdSDEzNZfDVOCj4NuhFq4Ug
         tBLxJVSvMpgDI0T8NDDCKlTjWlBpbe8cmf29ZPIdhwh3y12e+ArNpD5dJkhFFyD7jaq2
         8mq4WM5GeUp4XhjTycjVIXs/TgctHUl6/LhFRAI0p/DjcExhGLja0LmcB6Zz7bK8w7+n
         cLjw==
X-Gm-Message-State: ABy/qLYUQ6YzfzjOEjvf1dhvEjaVyXgYyDF+B/A7GnvY2gDY9HZhRd0B
        WPgk50KzF0yRP3nteSknsQ2rXcENKjM=
X-Google-Smtp-Source: APBJJlHAddbDc2cMcbZUidB0HowWy2488J/QjMe6Knuj2J162JyE2GJ2xbHLQj0Pd31iUQBNjID5BYp2vlY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1582:b0:d0a:353b:b93b with SMTP id
 k2-20020a056902158200b00d0a353bb93bmr18375ybu.3.1690591071769; Fri, 28 Jul
 2023 17:37:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:43 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-35-seanjc@google.com>
Subject: [PATCH v4 34/34] KVM: selftests: Use GUEST_FAIL() in ARM's arch timer helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use GUEST_FAIL() in ARM's arch timer helpers now that printf-based
guest asserts are the default (and only) style of guest asserts, and
say goodbye to the GUEST_ASSERT_1() alias.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/aarch64/arch_timer.h       | 12 ++++++------
 tools/testing/selftests/kvm/include/ucall_common.h   |  4 ----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
index cb7c03de3a21..b3e97525cb55 100644
--- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -41,7 +41,7 @@ static inline uint64_t timer_get_cntct(enum arch_timer timer)
 	case PHYSICAL:
 		return read_sysreg(cntpct_el0);
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	/* We should not reach here */
@@ -58,7 +58,7 @@ static inline void timer_set_cval(enum arch_timer timer, uint64_t cval)
 		write_sysreg(cval, cntp_cval_el0);
 		break;
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	isb();
@@ -72,7 +72,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
 	case PHYSICAL:
 		return read_sysreg(cntp_cval_el0);
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	/* We should not reach here */
@@ -89,7 +89,7 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
 		write_sysreg(tval, cntp_tval_el0);
 		break;
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	isb();
@@ -105,7 +105,7 @@ static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
 		write_sysreg(ctl, cntp_ctl_el0);
 		break;
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	isb();
@@ -119,7 +119,7 @@ static inline uint32_t timer_get_ctl(enum arch_timer timer)
 	case PHYSICAL:
 		return read_sysreg(cntp_ctl_el0);
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	/* We should not reach here */
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index b7e964b3182e..4cf69fa8bfba 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -102,8 +102,4 @@ do {										\
 		    (const char *)(ucall).args[GUEST_FILE],			\
 		    (ucall).args[GUEST_LINE], "%s", (ucall).buffer)
 
-/* FIXME: Drop this alias once the param-based guest asserts are gone. */
-#define GUEST_ASSERT_1(_condition, arg1) \
-	__GUEST_ASSERT(_condition, "arg1 = 0x%lx", arg1)
-
 #endif /* SELFTEST_KVM_UCALL_COMMON_H */
-- 
2.41.0.487.g6d72f3e995-goog

