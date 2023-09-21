Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4788D7A9813
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjIUR36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjIUR2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:28:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D090153650
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:16:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59c09bcf078so16582727b3.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695316604; x=1695921404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cWVtF+fs1Usi+Rms/xg03923pHwopRJzuckxmMamX6A=;
        b=n1JDcaLS3QeCXxqU5CrZYcwCXmEFcfnrqvuehEaqvNiQF7jpOB5nLY29f4VmS0PkDj
         ETajjqf3dD8V6WLGCqG2G2m1I+QuqsMeTXTKE13zrqC/ELYbyXCZvPaWZY1dDRTChBEy
         lD4cu9ioDYoXZMykyYB2PFN5LNXrupuh1j7sGyysGL8JUDp1FgjIC5F9B1AB0Ldc3udt
         eRMmRKdwQUsbBdLxrRMAZs3ZjepGksI4XNWVe1VLMukL6RpE3jBnOtdsAHlPwLvm0ra2
         jxvH9E04zaF0LHE4dGm780j9/uKyLmTinPVelZKDexPiUuPjiBIHl8YCVnJOP6OeERMT
         lQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695316604; x=1695921404;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cWVtF+fs1Usi+Rms/xg03923pHwopRJzuckxmMamX6A=;
        b=XGWDmmRR/2ltr5o75OnN8CaCHiFcnuMyQxD4bycM0B/YZpLVWpUO8/F6VODd8C4Lmw
         wlDjix8//6hswHx9gdOrOHKIkWlTEIzSXK15fdL1aiYCqVcvAtnKAApf6sQTJpTaxCHo
         mC/G44c17HbJrhet34W83SxQNqlbooYYlMAhaN2yASyC6f3ARY+t1jWx0CqDW4TRXnYP
         JV378kz+AgISn1iRjXLUxzbyJwYrpBrBKo/CShIX2o73kkRG04SqkEn65Wy7pX52gIYg
         WsEekG2Hm7Yn+RnPOmeze0W7XZTsZhZVHX4bIM4Tts7rYPYsWxZbJpkZrr5CoAaa0ZeU
         8TQA==
X-Gm-Message-State: AOJu0YzTF7xoIjUPYzenf8EmzpW4c/yLIFPLXlvZdgsH8SSy9FAmXgMC
        zMnZjZU+R+ju3VH/sTpPBNel5IrHEXg=
X-Google-Smtp-Source: AGHT+IF7YpypDgLAEH9RbqQ5ZX2J+3/XnO4CKGwOS3uMOFrTbYjpQET5KdjsfemTXZvMtGJwV7V4Ozr3gzc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b709:0:b0:59b:e669:c944 with SMTP id
 v9-20020a81b709000000b0059be669c944mr90231ywh.3.1695316603960; Thu, 21 Sep
 2023 10:16:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 10:16:41 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921171641.3641776-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Treat %llx like %lx when formatting guest printf
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Treat %ll* formats the same as %l* formats when processing printfs from
the guest so that using e.g. %llx instead of %lx generates the expected
output.  Ideally, unexpected formats would generate compile-time warnings
or errors, but it's not at all obvious how to actually accomplish that.

Alternatively, guest_vsnprintf() could assert on an unexpected format,
but since the vast majority of printfs are for failed guest asserts,
getting *something* printed is better than nothing.

E.g. before

 ==== Test Assertion Failure ====
  x86_64/private_mem_conversions_test.c:265: mem[i] == 0
  pid=4286 tid=4290 errno=4 - Interrupted system call
     1	0x0000000000401c74: __test_mem_conversions at private_mem_conversions_test.c:336
     2	0x00007f3aae6076da: ?? ??:0
     3	0x00007f3aae32161e: ?? ??:0
  Expected 0x0 at offset 0 (gpa 0x%lx), got 0x0

and after

 ==== Test Assertion Failure ====
  x86_64/private_mem_conversions_test.c:265: mem[i] == 0
  pid=5664 tid=5668 errno=4 - Interrupted system call
     1	0x0000000000401c74: __test_mem_conversions at private_mem_conversions_test.c:336
     2	0x00007fbe180076da: ?? ??:0
     3	0x00007fbe17d2161e: ?? ??:0
  Expected 0x0 at offset 0 (gpa 0x100000000), got 0xcc

Fixes: e5119382499c ("KVM: selftests: Add guest_snprintf() to KVM selftests")
Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/guest_sprintf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index c4a69d8aeb68..74627514c4d4 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -200,6 +200,13 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 			++fmt;
 		}
 
+		/*
+		 * Play nice with %llu, %llx, etc.  KVM selftests only support
+		 * 64-bit builds, so just treat %ll* the same as %l*.
+		 */
+		if (qualifier == 'l' && *fmt == 'l')
+			++fmt;
+
 		/* default base */
 		base = 10;
 

base-commit: 7c7cce2cf7ee2ac54851ba1fbcf0e968932e32b9
-- 
2.42.0.515.g380fc7ccd1-goog

