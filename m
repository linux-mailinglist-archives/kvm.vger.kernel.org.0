Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD79D7679AB
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbjG2Ag5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjG2Agw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:36:52 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240212135
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:51 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5844e92ee6bso26604987b3.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591010; x=1691195810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PdMhF3+dbu8TQ3iqZdPs1TdexnvVx+yUupHryp41YZs=;
        b=g48/ENXsZE3ltSl/IkRKy7TA29P1cX8hWNyuXQnOISi+o77fY0rzEcEpSaUCGzHtbC
         PhFE3nvUYKdM+6pL08G0PIiG/YDC0ZfEhHxCv90zQYJNzPUm015+GM8Ijwd4pGJIOXH3
         yTpeOeHTHgFfv3+kFWRtYrvW4JAD+m3tSo+Pxr/TbHE8msuKXqOmrPh8c4IM0wy/t+uw
         mx1NhRmD4Yg573qf2o0VyjOuMvUaDiRQsccLWxEQqeHf98TR2+Q5dM0FleJ1LtBbFwYD
         745nuvDW6t0CkMPbv9trtc4Ozl5io5Xc1LwmNLArSe2A/F0whCXtl59d8/f6Aot9QnOI
         5ahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591010; x=1691195810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PdMhF3+dbu8TQ3iqZdPs1TdexnvVx+yUupHryp41YZs=;
        b=Vd3DEXcjt76UTFZiSA7Bz4DeD6LWVxugLKG+zYccooAcOP4rQPA43CKrO3dZ6UxxR7
         hIZfNWbx4WPRSN0JjC7HFTy/tJY2yDd4k3Utb7UVavjUmvVqnzHtq/i9ZWHQEE3KTXJ0
         vHNd/mpxMhNKtwNXuG3z+LCcTOf0FeBrd2orXePTKdMVE4L8KyYkSINLnH5gDTawVS88
         YDUdShPrtnO9wNNl++p0NQKLeryAbmzEBs8L3DMGNq2xmTk8jDAZdLxdJllGSUp8Un0j
         Z2vYWl6cD3GcTefJBhVpsKGAPMLu6/cwveAr4QCr7iHv6cfNHiHFLk2M48R97jj24raF
         P4uQ==
X-Gm-Message-State: ABy/qLZyO6QrC7oRva5ZPPH+1KfPUbe3jJlFZ6wj2IHKXZLod6o3tp6M
        XX7swHpKIlnBiDcURKxCbmtHMmtPlSk=
X-Google-Smtp-Source: APBJJlGuzgz3q+P1cDjpB54/biLUxD1UZvVtGqhl9fq0g3fJKAZGyLsES9Mt8giS31GV85E5u4iJ8Uv2pTE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2083:0:b0:d0d:4910:cf0b with SMTP id
 g125-20020a252083000000b00d0d4910cf0bmr18518ybg.10.1690591010455; Fri, 28 Jul
 2023 17:36:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:11 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-3-seanjc@google.com>
Subject: [PATCH v4 02/34] KVM: selftests: Make TEST_ASSERT_EQ() output look
 like normal TEST_ASSERT()
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up TEST_ASSERT_EQ() so that the (mostly) raw code is captured in the
main assert message, not the helper macro's code.  E.g. make this:

  x86_64/tsc_msrs_test.c:106: __a == __b
  pid=40470 tid=40470 errno=0 - Success
     1	0x000000000040170e: main at tsc_msrs_test.c:106
     2	0x0000000000416f23: __libc_start_call_main at libc-start.o:?
     3	0x000000000041856f: __libc_start_main_impl at ??:?
     4	0x0000000000401ef0: _start at ??:?
  TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val + 1) failed.
	rounded_host_rdmsr(MSR_IA32_TSC) is 0
	val + 1 is 0x1

look like this:

  x86_64/tsc_msrs_test.c:106: rounded_host_rdmsr(MSR_IA32_TSC) == val + 1
  pid=5737 tid=5737 errno=0 - Success
     1	0x0000000000401714: main at tsc_msrs_test.c:106
     2	0x0000000000415c23: __libc_start_call_main at libc-start.o:?
     3	0x000000000041726f: __libc_start_main_impl at ??:?
     4	0x0000000000401e60: _start at ??:?
  0 != 0x1 (rounded_host_rdmsr(MSR_IA32_TSC) != val + 1)

Opportunstically clean up the formatting of the entire macro.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index e734e52d8a3a..a4bea44f990c 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -53,14 +53,13 @@ void test_assert(bool exp, const char *exp_str,
 #define TEST_ASSERT(e, fmt, ...) \
 	test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
 
-#define TEST_ASSERT_EQ(a, b) do { \
-	typeof(a) __a = (a); \
-	typeof(b) __b = (b); \
-	TEST_ASSERT(__a == __b, \
-		    "TEST_ASSERT_EQ(%s, %s) failed.\n" \
-		    "\t%s is %#lx\n" \
-		    "\t%s is %#lx", \
-		    #a, #b, #a, (unsigned long) __a, #b, (unsigned long) __b); \
+#define TEST_ASSERT_EQ(a, b)						\
+do {									\
+	typeof(a) __a = (a);						\
+	typeof(b) __b = (b);						\
+	test_assert(__a == __b, #a " == " #b, __FILE__, __LINE__,	\
+		    "%#lx != %#lx (%s != %s)",				\
+		    (unsigned long)(__a), (unsigned long)(__b), #a, #b);\
 } while (0)
 
 #define TEST_ASSERT_KVM_EXIT_REASON(vcpu, expected) do {		\
-- 
2.41.0.487.g6d72f3e995-goog

