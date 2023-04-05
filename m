Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5876D7975
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbjDEKSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbjDEKSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:18:36 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCDA4C0E
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:18:35 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l27so35660355wrb.2
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6NW9VhhS5fLeVwZeTyWWyTbAHfvPOC/r0zI8X/AYhw=;
        b=FrtFKE2hFxCwSIOxwL7fJNJgclFtRZYFCKSwPQeumlgt6bklL8ZJLOhaxRanBaGmBN
         sSSdwoBuo0PWQIPC5aVYpH3V4lrlZrxSnF6ec08aPzNngc+4NCJth/v+YEXjEI5hAYZ7
         deplHkaFXLIdswcAyfQjoGU7HHGPGzJHJzztDL7n6LAkZeMYnyvPoi+3fXYTgBgP5XWs
         cPr7wmMyCDh4HsAHrXF/xlBABJq7EFQwNi0Rj4haWnYMHlXIAYY+Lsa8OGwO4Mt6ZR/d
         e7uyZyaesG4XjKKufoRM2SpXpgdAnFrSp25xtnMkjXzs/M6Ow7DNjd1C6Ovjn8q1Umho
         74DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E6NW9VhhS5fLeVwZeTyWWyTbAHfvPOC/r0zI8X/AYhw=;
        b=eJl6l7fHs68dkCw0i1lAP5BKh238tJebWuBsCPmvJoMl6kNUZe+jz//2iEzO9/DVsH
         FjxHjb4d19i08WwT12noPIAf59LL7vpnLAVM9a0EkB08rpxdrLah6eus9o8PRp9ZjYqj
         fwC5O1qXBGYw6tvj9rL0FudsWdPfijugV+fzr/VEqOo2AHpjUOcuN94GXD3CcGFfJzXE
         ZpfHue93DJzo68bevCb/3ja0JjWMhGzs6qJ+PVnJzPXCKt1KbTLjhfKuL8f+R/hZlGxQ
         hU0d4rL4bgB47G8n1HPEt/4RdFhPz+Nrsp5XzzP0kfV5MsYn2CW4ZXTPyjgkONqPSWum
         EmZg==
X-Gm-Message-State: AAQBX9cqlhaqUwvVyt5BzDlbTTdHsDbew4DhbgZYPzwVCkHxQxikGynp
        hNGOUmZn7saEeBiXDmfrE7puofNQYxa49/mJ7VM=
X-Google-Smtp-Source: AKy350YkinPPwbt/c64vUzk9lM4SXacH8xjrAIzv8V1BeCK80tQHniLUzIE+5w/+4XbN335yprpGWw==
X-Received: by 2002:a5d:4d11:0:b0:2ce:9819:1c1e with SMTP id z17-20020a5d4d11000000b002ce98191c1emr3913343wrt.30.1680689913858;
        Wed, 05 Apr 2023 03:18:33 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id d9-20020adff849000000b002c56af32e8csm14637033wrq.35.2023.04.05.03.18.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:18:33 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 03/14] accel: Fix a leak on Windows HAX
Date:   Wed,  5 Apr 2023 12:18:00 +0200
Message-Id: <20230405101811.76663-4-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405101811.76663-1-philmd@linaro.org>
References: <20230405101811.76663-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hThread is only used on the error path in hax_kick_vcpu_thread().

Fixes: b0cb0a66d6 ("Plumb the HAXM-based hardware acceleration support")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/hax/hax-all.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index 3e5992a63b..a2321a1eff 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -205,6 +205,9 @@ int hax_vcpu_destroy(CPUState *cpu)
      */
     hax_close_fd(vcpu->fd);
     hax_global.vm->vcpus[vcpu->vcpu_id] = NULL;
+#ifdef _WIN32
+    CloseHandle(cpu->hThread);
+#endif
     g_free(vcpu);
     return 0;
 }
-- 
2.38.1

