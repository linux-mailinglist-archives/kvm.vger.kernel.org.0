Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101847B620B
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 09:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjJCHFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 03:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbjJCHFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 03:05:03 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE69C9
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 00:05:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3248aa5cf4eso622738f8f.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 00:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696316699; x=1696921499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4dGNWXL4bt/YZVly7d1oK3PqrthsZjp41Sj7J9uNPxE=;
        b=FdxXa3K2TOM32wk7GV/mfDxBxfYPOKilYY36yNu+4OAQMK0nLnbFxlLQJxIDDaIIo2
         scsK+d6DKDQwnESPVRgbH7uPMMVWElQ56Sfijm9XlCHQMCUIKDcc55JGF8C5gHbuGIfx
         wERNvhOkhkjv13Jw/5SzCf6IXbNMzSYXiM7ukDALG5fyTrGbxoW6+KkLfNUtzLcNqMvV
         qetCal3vfk4m9UfJZ4vy3DYGG1pbnalJwgUf9ZLntz2ZgHciOqYZ3sph7GzwSRFbWEif
         EP+Ih3rFvpVpJgygCUhSQU55zxO38Fjk7y3NeisXcf/ENiyH8gqhnx9e94dR3lOT9K8X
         sjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696316699; x=1696921499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4dGNWXL4bt/YZVly7d1oK3PqrthsZjp41Sj7J9uNPxE=;
        b=OPSDWUGHq0rtqMPhUhvN/2we9WJZrmIeCWZGdyYulGYmbq7ro+4sScqZY0xsltjnLp
         nKa/k96vxtq/58VrzTEXY3ihFj60HDLg/qymO4RrNrbglytc7PMLpe/iqoGKHorjYL7X
         AxbtyS7j9YtjEgLGQ9FubJEccVtyyv6VuveguiwGOn2vmPyo5n79/rcWmy5pfSdKlMDl
         kaLAY2yK/CRYRCF/DCFp/aRc3FCN5s/si9uI3aJNtGKjp8Cu7npP7+jPp2ekJSLdFJ4n
         23VE9C8JrYGIbOP9Ar2y8IETwyyjsCyskKRD4pCW0rcBNsLukut4a+1vyDmJBT+kQgeE
         FzxA==
X-Gm-Message-State: AOJu0YxBfJHqTOY+GXNa3Un5w6WRraLNejlg3W1K41ZnFaVAZWHOgwBf
        osx9hHGKWC6Ls89W6CoyZa0PeA==
X-Google-Smtp-Source: AGHT+IEtMLpY0vDY8IiNQlnwRAuBYlQaQaB3YsnFQvO7ycOaQmgl/yRWmUy1V6VmkwiBs0q8c2c4lw==
X-Received: by 2002:a5d:58c2:0:b0:321:f74d:ade6 with SMTP id o2-20020a5d58c2000000b00321f74dade6mr11933643wrf.40.1696316699144;
        Tue, 03 Oct 2023 00:04:59 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id d18-20020a056000115200b00326c952716esm818614wrx.61.2023.10.03.00.04.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 00:04:58 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 4/4] target/ppc: Prohibit target specific KVM prototypes on user emulation
Date:   Tue,  3 Oct 2023 09:04:26 +0200
Message-ID: <20231003070427.69621-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231003070427.69621-1-philmd@linaro.org>
References: <20231003070427.69621-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

None of these target-specific prototypes should be used
by user emulation. Remove their declaration there, so we
get a compile failure if ever used (instead of having to
deal with linker and its possible optimizations, such
dead code removal).

Suggested-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>
---
 target/ppc/kvm_ppc.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 6a4dd9c560..1975fb5ee6 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -13,6 +13,10 @@
 #include "exec/hwaddr.h"
 #include "cpu.h"
 
+#ifdef CONFIG_USER_ONLY
+#error Cannot include kvm_ppc.h from user emulation
+#endif
+
 #ifdef CONFIG_KVM
 
 uint32_t kvmppc_get_tbfreq(void);
-- 
2.41.0

