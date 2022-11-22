Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D90963322D
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 02:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiKVBdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 20:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiKVBdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 20:33:13 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C08DB94AB
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 17:33:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id n9-20020a17090a2bc900b0021010dca313so6752627pje.7
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 17:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jw+pa4Hghc6DNqT2ZjHPvBrmIDFJee53B5N07cXK5TA=;
        b=VQiF6B2AiWPxuDaU543wmXQ9fJI73usRCS2tEaUARqzdNYWpa0vkycXr2Q3TCD8DT+
         qEV3F9EJqmNGYVgf/FeGkZW4qpTYvYdLuSJh5nI1sjK7Gkj3BvzbOPBsRtPDBKBdBfrS
         RPmLWdrKBMvio8ukGXoClhqdFtRISRID8Vz43PLr2UDvMLKysBWO/ddPOnNDqMAbLbMk
         aaVUuSovyMALqMoaCFXuGE8w58N8DbKYrPQKHhsfERzQYv5rBBxn2+RClCYIs4bKVY3l
         rlBU9J+8hFpSP/pO5M4DmnlowkAMx1dXoieVn4gjokqbQhgY4o0IAUUU0Y7PJ29r7O/P
         rDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Jw+pa4Hghc6DNqT2ZjHPvBrmIDFJee53B5N07cXK5TA=;
        b=pb3N2ahgpWwI6+XWJA5MR+MW8SpPInWlcgY9JNs6tXXjPRaU5RHzbs+6QeXSiMBQ+Y
         bbsylAwj6ZqAPN+P/wVXMtfc+x93OB/WrwxZi20q9C5PQMzxCXH5z3pLa9G5WCvzw2Vc
         FaHm/ih4GltKKmHMtXzN7asq2BrKTSdWI6eBPXOEiNUV3kBdmgz0GABkj9ZcRcphKZSc
         MFi9ZibiNLvpBkaQwfcFEj2QZ+MxNmHd5wtgRGaCHToy1sdObUEGy72zEcry//ODxvME
         pW4aOWIElgV6a/xkcJBvYYXwIGlDgj8sKK6dsZC0nMmisGBfMxX5PoNIHpddwotEA/ET
         0FhA==
X-Gm-Message-State: ANoB5plJ79q69ciqWBwpx1cY75kAT3Rj98XH1lIPMi6SE+jC9cszpiCI
        AtDUqtnWKcdJiRF/534f0BRjTCREfOA=
X-Google-Smtp-Source: AA0mqf5IUv74w5o2HIig6Dio77QDCV1b85+y917UKkiYu9TTQzt1AZFzYf0mg5S3BiZmCmqlB7GCfjezLro=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:54c2:0:b0:56b:fb4f:3d7c with SMTP id
 i185-20020a6254c2000000b0056bfb4f3d7cmr23246950pfb.54.1669080791735; Mon, 21
 Nov 2022 17:33:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Nov 2022 01:33:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122013309.1872347-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Define and use a custom static assert in lib headers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define and use kvm_static_assert() in the common KVM selftests headers to
provide deterministic behavior, and to allow creating static asserts
without dummy messages.

The kernel's static_assert() makes the message param optional, and on the
surface, tools/include/linux/build_bug.h appears to follow suit.  However,
glibc may override static_assert() and redefine it as a direct alias of
_Static_assert(), which makes the message parameter mandatory.  This leads
to non-deterministic behavior as KVM selftests code that utilizes
static_assert() without a custom message may or not compile depending on
the order of includes.  E.g. recently added asserts in
x86_64/processor.h fail on some systems with errors like

  In file included from lib/memstress.c:11:0:
  include/x86_64/processor.h: In function =E2=80=98this_cpu_has_p=E2=80=99:
  include/x86_64/processor.h:193:34: error: expected =E2=80=98,=E2=80=99 be=
fore =E2=80=98)=E2=80=99 token
    static_assert(low_bit < high_bit);     \
                                    ^
due to _Static_assert() expecting a comma before a message.  The "message
optional" version of static_assert() uses macro magic to strip away the
comma when presented with empty an __VA_ARGS__

  #ifndef static_assert
  #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #ex=
pr)
  #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
  #endif // static_assert

and effectively generates "_Static_assert(expr, #expr)".

The incompatible version of static_assert() gets defined by this snippet
in /usr/include/assert.h:

  #if defined __USE_ISOC11 && !defined __cplusplus
  # undef static_assert
  # define static_assert _Static_assert
  #endif

which yields "_Static_assert(expr)" and thus fails as above.

KVM selftests don't actually care about using C11, but __USE_ISOC11 gets
defined because of _GNU_SOURCE, which many tests do #define.  _GNU_SOURCE
triggers a massive pile of defines in /usr/include/features.h, including
_ISOC11_SOURCE:

  /* If _GNU_SOURCE was defined by the user, turn on all the other features=
.  */
  #ifdef _GNU_SOURCE
  # undef  _ISOC95_SOURCE
  # define _ISOC95_SOURCE 1
  # undef  _ISOC99_SOURCE
  # define _ISOC99_SOURCE 1
  # undef  _ISOC11_SOURCE
  # define _ISOC11_SOURCE 1
  # undef  _POSIX_SOURCE
  # define _POSIX_SOURCE  1
  # undef  _POSIX_C_SOURCE
  # define _POSIX_C_SOURCE        200809L
  # undef  _XOPEN_SOURCE
  # define _XOPEN_SOURCE  700
  # undef  _XOPEN_SOURCE_EXTENDED
  # define _XOPEN_SOURCE_EXTENDED 1
  # undef  _LARGEFILE64_SOURCE
  # define _LARGEFILE64_SOURCE    1
  # undef  _DEFAULT_SOURCE
  # define _DEFAULT_SOURCE        1
  # undef  _ATFILE_SOURCE
  # define _ATFILE_SOURCE 1
  #endif

which further down in /usr/include/features.h leads to:

  /* This is to enable the ISO C11 extension.  */
  #if (defined _ISOC11_SOURCE \
       || (defined __STDC_VERSION__ && __STDC_VERSION__ >=3D 201112L))
  # define __USE_ISOC11   1
  #endif

To make matters worse, /usr/include/assert.h doesn't guard against
multiple inclusion by turning itself into a nop, but instead #undefs a
few macros and continues on.  As a result, it's all but impossible to
ensure the "message optional" version of static_assert() will actually be
used, e.g. explicitly including assert.h and #undef'ing static_assert()
doesn't work as a later inclusion of assert.h will again redefine its
version.

  #ifdef  _ASSERT_H

  # undef _ASSERT_H
  # undef assert
  # undef __ASSERT_VOID_CAST

  # ifdef __USE_GNU
  #  undef assert_perror
  # endif

  #endif /* assert.h      */

  #define _ASSERT_H       1
  #include <features.h>

Fixes: fcba483e8246 ("KVM: selftests: Sanity check input to ioctls() at bui=
ld time")
Fixes: ee3795536664 ("KVM: selftests: Refactor X86_FEATURE_* framework to p=
rep for X86_PROPERTY_*")
Fixes: 53a7dc0f215e ("KVM: selftests: Add X86_PROPERTY_* framework to retri=
eve CPUID values")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 14 +++++++++++-
 .../selftests/kvm/include/x86_64/processor.h  | 22 +++++++++----------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/te=
sting/selftests/kvm/include/kvm_util_base.h
index c7685c7038ff..9fa0d340f291 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -22,6 +22,18 @@
=20
 #include "sparsebit.h"
=20
+/*
+ * Provide a version of static_assert() that is guaranteed to have an opti=
onal
+ * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/asser=
t.h)
+ * #undefs and #defines static_assert() as a direct alias to _Static_asser=
t(),
+ * i.e. effectively makes the message mandatory.  Many KVM selftests #defi=
ne
+ * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOURCE=
.  As
+ * a result, static_assert() behavior is non-deterministic and may or may =
not
+ * require a message depending on #include order.
+ */
+#define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
+#define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS=
__, #expr)
+
 #define KVM_DEV_PATH "/dev/kvm"
 #define KVM_MAX_VCPUS 512
=20
@@ -196,7 +208,7 @@ static inline bool kvm_has_cap(long cap)
=20
 #define kvm_do_ioctl(fd, cmd, arg)						\
 ({										\
-	static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
	\
+	kvm_static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd));=
	\
 	ioctl(fd, cmd, arg);							\
 })
=20
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools=
/testing/selftests/kvm/include/x86_64/processor.h
index 5d310abe6c3f..c65717142fda 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -72,11 +72,11 @@ struct kvm_x86_cpu_feature {
 		.bit =3D __bit,							\
 	};									\
 										\
-	static_assert((fn & 0xc0000000) =3D=3D 0 ||					\
-		      (fn & 0xc0000000) =3D=3D 0x40000000 ||			\
-		      (fn & 0xc0000000) =3D=3D 0x80000000 ||			\
-		      (fn & 0xc0000000) =3D=3D 0xc0000000);				\
-	static_assert(idx < BIT(sizeof(feature.index) * BITS_PER_BYTE));	\
+	kvm_static_assert((fn & 0xc0000000) =3D=3D 0 ||				\
+			  (fn & 0xc0000000) =3D=3D 0x40000000 ||			\
+			  (fn & 0xc0000000) =3D=3D 0x80000000 ||			\
+			  (fn & 0xc0000000) =3D=3D 0xc0000000);			\
+	kvm_static_assert(idx < BIT(sizeof(feature.index) * BITS_PER_BYTE));	\
 	feature;								\
 })
=20
@@ -190,12 +190,12 @@ struct kvm_x86_cpu_property {
 		.hi_bit =3D high_bit,						\
 	};									\
 										\
-	static_assert(low_bit < high_bit);					\
-	static_assert((fn & 0xc0000000) =3D=3D 0 ||					\
-		      (fn & 0xc0000000) =3D=3D 0x40000000 ||			\
-		      (fn & 0xc0000000) =3D=3D 0x80000000 ||			\
-		      (fn & 0xc0000000) =3D=3D 0xc0000000);				\
-	static_assert(idx < BIT(sizeof(property.index) * BITS_PER_BYTE));	\
+	kvm_static_assert(low_bit < high_bit);					\
+	kvm_static_assert((fn & 0xc0000000) =3D=3D 0 ||				\
+			  (fn & 0xc0000000) =3D=3D 0x40000000 ||			\
+			  (fn & 0xc0000000) =3D=3D 0x80000000 ||			\
+			  (fn & 0xc0000000) =3D=3D 0xc0000000);			\
+	kvm_static_assert(idx < BIT(sizeof(property.index) * BITS_PER_BYTE));	\
 	property;								\
 })
=20

base-commit: 0fa32dad1e78629cb42999dacd82489503fdf4c2
--=20
2.38.1.584.g0f3c55d4c2-goog

