Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF51D7D72
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgERPxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 11:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgERPxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 11:53:16 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175AFC061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:16 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u188so42432wmu.1
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YgUO7urc8a2H2l0AjA6/YcXX+FHCC3nhZ10cz3IJGT0=;
        b=IOBfw97bri/HK4rNN8hBH3fS/bLjGzm8A0H/8IkZ8BNpXTH5MWOLMb3YVIeMZKbemA
         3ANvreACUxm3uKFDJZEe4MA+7GDtRxgdRAvLMjOBMc7JlM5setDqR+rAAjGrhOViOGZF
         2Wqfu4cYar/pwmzsrnDNSa2HYymGPUjbGygmgHP6rSFAaV7KZ4Aj7Zf8fLfG4mjSdzoj
         O0xMbKFIM8aKXXnAyWz+2OWRz7ivmrJrmm2ilOqTEom06SGkiN9a0F3K1QeVvnWoTdEt
         L9ra6YC/35hRflgOsBpof5I6H7BbRnEo+uNLoC00Y9tDyfK0lemm9ge5tj8eq1k8Vg70
         hyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=YgUO7urc8a2H2l0AjA6/YcXX+FHCC3nhZ10cz3IJGT0=;
        b=Cy+6osAJMM8IZ7SvfZ8rRCySVJ8+RWbLCct/CGZ1Uqk8MAQF4cTBJKISpngD5obqc+
         6yUR0Tj79mRxvIFMGALylj12t3j5NQmI1P6u8n7bgPVNFu2plo9FXzyN4HpoRAhNusMO
         rqz9T7qDCWwSqiYMbsoejSKRkP1PM6kUhS9fn9b+4siiTfg0Rk8CnwRBgIoOhoq1vWXg
         sOpmZkFv3QwAiqxglkm9Y5KAhIncNr1wI731Q0SDq9E3DL7WlzWak3VXmOGiLbkeMJWt
         AJfJf4n3PMJDJwUqFCENbAc2EUgJG2PEl04QYAPajtl50SkhxWb88q7GamOeFxY03QgY
         FLbA==
X-Gm-Message-State: AOAM533ADu9X/3qs4GUuWIwx0OSJLTubG8OViwv2chp0T8HNrIOFgotn
        fZGAj1CuTu0n1xEqNosYLMk=
X-Google-Smtp-Source: ABdhPJyG3gmRwNj2wCtQakz1KaSpc4CoE3n4quosHaeNbq9NCRoNUZ4NxGqjRfI4JksaALSu8mA24w==
X-Received: by 2002:a1c:4cb:: with SMTP id 194mr42967wme.124.1589817194856;
        Mon, 18 May 2020 08:53:14 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id 7sm17647462wra.50.2020.05.18.08.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:53:14 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 4/7] hw/elf_ops: Do not ignore write failures when loading ELF
Date:   Mon, 18 May 2020 17:53:05 +0200
Message-Id: <20200518155308.15851-5-f4bug@amsat.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200518155308.15851-1-f4bug@amsat.org>
References: <20200518155308.15851-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not ignore the MemTxResult error type returned by
address_space_write().

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 include/hw/elf_ops.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/hw/elf_ops.h b/include/hw/elf_ops.h
index 398a4a2c85..6fdff3dced 100644
--- a/include/hw/elf_ops.h
+++ b/include/hw/elf_ops.h
@@ -553,9 +553,14 @@ static int glue(load_elf, SZ)(const char *name, int fd,
                     rom_add_elf_program(label, mapped_file, data, file_size,
                                         mem_size, addr, as);
                 } else {
-                    address_space_write(as ? as : &address_space_memory,
-                                        addr, MEMTXATTRS_UNSPECIFIED,
-                                        data, file_size);
+                    MemTxResult res;
+
+                    res = address_space_write(as ? as : &address_space_memory,
+                                              addr, MEMTXATTRS_UNSPECIFIED,
+                                              data, file_size);
+                    if (res != MEMTX_OK) {
+                        goto fail;
+                    }
                 }
             }
 
-- 
2.21.3

