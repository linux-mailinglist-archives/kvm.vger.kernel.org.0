Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94EA96D82E3
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238634AbjDEQFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238396AbjDEQFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:05:12 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFE16582
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:05:04 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id m2so36727142wrh.6
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xxoSzGepGv7BmEwhIUriUkTSi2iiaajTQsAiWFvibwk=;
        b=DQmQx5IbN6E4g6+BkWxA6gztVY7c/sHCIzd5stHTLyHiWOEkRlEtrivX3vqbDbGjL7
         XxhqdFKDllanEdiwIR+2geFMKUEf51/bjTU6C1eN4FPCiqJiX82RtiNDDdUc4v8TZMlS
         hfE9xJx7iUvpEr/MKnWta3hPHTH4tZxYVjBbZjbRVHV9SQjjE7MOqQkE5Vx8Ki+X5wTp
         c5TkfIiumSxeeb7KERAMfNwXTLH281hiqor5R3BeKHaP0CWh9xqCJFkqSyE1Ryn0CRfG
         Wa9APsQXMmO/K9sEl+9/eYdh12Me4fUTC8mQAdjssj9vMZeCKSBjNoCuzIYv3M364S11
         1Z3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xxoSzGepGv7BmEwhIUriUkTSi2iiaajTQsAiWFvibwk=;
        b=Rwd54se1rY2rdH9gSMvvj0oDYriwvJC6wjYNeDUIacAPc1bydo4Si1RMxLm1SHSnyr
         bNH7uWLmz6XGFQMthErPMHLWALML0Wue8MDiSMjlXcACxYkgvkl5FAEUKwe+8+PG+szu
         qb1j2gZ4woWx+BR5PBwpnG7iHI8Y2j0QiM6sV4waGDesV1jPeRnpkxhrW/uan9T2g+dv
         XbqoMJsXK+qhvG5ahFm4GANdbo8FwNm1VFw4vQuTaLvxO40BrhC+aVbkUsd+HR0URAW2
         Xb78ZLvTv719n9Y4mL6qaRZ/mgYUf8tkjOVudD8RUYbCLXx9pml3RRqb2wZVsJ2viOka
         5U7Q==
X-Gm-Message-State: AAQBX9dLO92SUZhaQ7jQmKgl6vyxvuTuGwcJybCuK4/fB0ucoy3mkO5F
        7IIITEm0NtI+RYWvq5ADLhYiIg==
X-Google-Smtp-Source: AKy350bS4fbO2z32Jbhpsnm4njKJVeihL7eN5HhQ5ZKA2WfgsKUiX7r37OaZuRjkvBKDgyCpYJKbBg==
X-Received: by 2002:adf:de8f:0:b0:2dc:c0da:409 with SMTP id w15-20020adfde8f000000b002dcc0da0409mr3979004wrl.27.1680710703263;
        Wed, 05 Apr 2023 09:05:03 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id k16-20020a056000005000b002e116cbe24esm15293404wrx.32.2023.04.05.09.05.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:05:02 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 01/10] sysemu/kvm: Remove unused headers
Date:   Wed,  5 Apr 2023 18:04:45 +0200
Message-Id: <20230405160454.97436-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405160454.97436-1-philmd@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
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

All types used are forward-declared in "qemu/typedefs.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index cc6c678ed8..7902acdfd9 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -16,9 +16,6 @@
 #ifndef QEMU_KVM_H
 #define QEMU_KVM_H
 
-#include "qemu/queue.h"
-#include "hw/core/cpu.h"
-#include "exec/memattrs.h"
 #include "qemu/accel.h"
 #include "qom/object.h"
 
-- 
2.38.1

