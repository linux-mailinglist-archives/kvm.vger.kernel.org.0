Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1724662D1
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357393AbhLBL5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346488AbhLBL5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 06:57:21 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15EEC06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 03:53:58 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c6-20020a05600c0ac600b0033c3aedd30aso3361400wmr.5
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 03:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O1VjI2U7XfRKbg+ZSN6i6QVFf+SzgfTpuCobVzeKOYA=;
        b=AZ6RZnRldc+wfjD7JyNw6gVSzMplldw/x0sXKFmvOTWX3o5QfKU8dEdAOs8ovGCvAx
         +3t9SQWgsaXbcjijZx2L7h5bLu4pHt+EAKzxd5DT0RdYn7ZMMDkua1FFgPNpZWYHbi/I
         olqpTc7K1bIvjBJykg4RE7jTYaDxNhyAKojMUI0/sy3mugJ1JAaqO0fM3hrU6VRzy7v0
         r7cpZNC441WuUmlMskvHTEofZiDvVZ/YwjgWAgWZx/M1pB+3pkcZe+C4uom+LkCKlpR/
         mavFXZYdL+q8DSR3GMu6gwg7b2pqveN89XtUhM4euL78f5BFMuXuoELzSnoQ0xT7dR99
         EyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O1VjI2U7XfRKbg+ZSN6i6QVFf+SzgfTpuCobVzeKOYA=;
        b=gZAy9/at2qXML5B1XP9PfieQmQZAIgzt5pt+Uc7awezGJ9QlYcIIEXgNXZwCvXP6R0
         SwPyJheKmd7TuhtLz3lkskzF+qQikdZ0OnfMszqCJTSSjHtSnF4XRVxE7esGc/TxB1l7
         JRx0BovGKrd91/wpIfl5Vonh+xjifXqOfy79gCvjj2m3aXH/OIXZM8oQxvO5BPLR8x0l
         /LHN8Odk3ueYPf3NmOdy7GLfCEIZbpV/Mv5F6x6lxlf7MTKfkz8TkVxzcsgsMYjnPLNG
         pEQIUTP9s2S7uCZx/Sb8y4SKv6IF37FbNC01MFFZ0823oCJN669HNGyp0Wb2G5uqaX9k
         uQjg==
X-Gm-Message-State: AOAM530v3rQ5hJ2YTflmJDw3u8DOIp1yUES9ZF/ZcxhkkkiwwWcU+Dzv
        bfXRk93KvAyGRjOO8vmzZXE/qw==
X-Google-Smtp-Source: ABdhPJzB8IQIjbi+vExxEGobek/s0HfYc8nfaQmzYUgGnjdRCz1Mc2+bXvqXWGaBGzOoxzN3h7vz3g==
X-Received: by 2002:a1c:4d15:: with SMTP id o21mr5670343wmh.171.1638446037479;
        Thu, 02 Dec 2021 03:53:57 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id f15sm2448078wmg.30.2021.12.02.03.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 03:53:53 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9C93D1FF99;
        Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v9 2/9] arm/flat.lds: don't drop debug during link
Date:   Thu,  2 Dec 2021 11:53:45 +0000
Message-Id: <20211202115352.951548-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is useful to keep the debug in the .elf file so we can debug and it
doesn't get copied across to the final .flat file. Of course we still
need to ensure we apply the offset when we load the symbols based on
where QEMU decided to load the kernel.

  (gdb) symbol-file ./builds/arm64/arm/tlbflush-data.elf -o 0x40080000

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20211118184650.661575-3-alex.bennee@linaro.org>
---
 arm/flat.lds | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arm/flat.lds b/arm/flat.lds
index 6fb459ef..47fcb649 100644
--- a/arm/flat.lds
+++ b/arm/flat.lds
@@ -62,7 +62,6 @@ SECTIONS
     /DISCARD/ : {
         *(.note*)
         *(.interp)
-        *(.debug*)
         *(.comment)
         *(.dynamic)
     }
-- 
2.30.2

