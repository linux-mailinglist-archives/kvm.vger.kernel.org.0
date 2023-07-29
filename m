Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4247679B0
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbjG2AhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbjG2Ag6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:36:58 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930E635A9
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:54 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56cf9a86277so26556947b3.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591014; x=1691195814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Z3Pu8s+tZVLEYyiWqFZT+4FnWB/kYWBw56lgxTY04lg=;
        b=QhOCz4agpP5D5cbpsEZdNZlI5wRey05iapUs6eqbsCyeWw7ESGDEaWL+JAIY5SreVo
         j4pjb93sMrM6hSxu6w1NyfTe0JbHBmnKzcSv8XEHiOxiqzRovWo0kdaZNgOMIaC1LEmO
         uBeX0ALUqhXhfo9xI+4stfGH9a4o+HD2bd3H/Z2c/1xXwHy1QrfRssnf1Gu3oPEy3rvP
         Cp4Y2ayDWQqnOoPjgFaSM4cN0ajnTBpyLN0nMdsGRL7mNczp8jpfjXG/KGcgbQSSClEe
         jHWhHsMP3HKknY07k/h2dlQ/7+/Qp8Z/7Ko2t314af5vv9Hv0O/jrmNV/8FUZdmWsODb
         9/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591014; x=1691195814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z3Pu8s+tZVLEYyiWqFZT+4FnWB/kYWBw56lgxTY04lg=;
        b=RR9aqv7tP8PxfipHV05yOZy7sAGEFPhcznEbz9MyzppOYLeu4AzN9C1EhAzH8NxZof
         Vgmf2V2/GD8CeaugSLGr5AZw0TaWA1JYOBi+xDvx3QVYBOPFB5hvkEPu+TwQOxt3IF/8
         Lt9DE1ZiLdF95/fotcyYuT+sMBKmfOGmpHo1J/cKLxVMHGbWzZ0FAUWwLW6TjvHbEemS
         GT7NzAjmpNFBAVW9L8Jhci6mJFHHBsEonpxrNYA89ZlTF67Tc73JD94e0GhbYUFYccZa
         4v4KNit7Jyeci/TgMgmCvBfG32R9+JYs19sUYAedWgIGEk2b7i4B0CoRvDVr7i/q67FC
         U9MQ==
X-Gm-Message-State: ABy/qLZ6OFkHYvmD0TpBCBwIapYpkDBhbbSboT+L6DAg0741KvYgZb7g
        Zd7Q4Zh6Dr36vABAUIO4LtN8ukYqqz4=
X-Google-Smtp-Source: APBJJlGW0fmejVcH9KMrFQrUYFzrJ+xt9BpeDmhOtEq6gjiJBZGY9QsusOFgjsma9PSCF+gN7f3Yz2Qr00k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad27:0:b0:581:3899:91bc with SMTP id
 l39-20020a81ad27000000b00581389991bcmr22355ywh.6.1690591013864; Fri, 28 Jul
 2023 17:36:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:13 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-5-seanjc@google.com>
Subject: [PATCH v4 04/34] KVM: selftests: Add strnlen() to the string overrides
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

From: Aaron Lewis <aaronlewis@google.com>

Add strnlen() to the string overrides to allow it to be called in the
guest.

The implementation for strnlen() was taken from the kernel's generic
version, lib/string.c.

This will be needed when printf() is introduced.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile              | 1 +
 tools/testing/selftests/kvm/lib/string_override.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c692cc86e7da..f6c14ab476ac 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -204,6 +204,7 @@ endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD\
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
+	-fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
 	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
diff --git a/tools/testing/selftests/kvm/lib/string_override.c b/tools/testing/selftests/kvm/lib/string_override.c
index 632398adc229..5d1c87277c49 100644
--- a/tools/testing/selftests/kvm/lib/string_override.c
+++ b/tools/testing/selftests/kvm/lib/string_override.c
@@ -37,3 +37,12 @@ void *memset(void *s, int c, size_t count)
 		*xs++ = c;
 	return s;
 }
+
+size_t strnlen(const char *s, size_t count)
+{
+	const char *sc;
+
+	for (sc = s; count-- && *sc != '\0'; ++sc)
+		/* nothing */;
+	return sc - s;
+}
-- 
2.41.0.487.g6d72f3e995-goog

