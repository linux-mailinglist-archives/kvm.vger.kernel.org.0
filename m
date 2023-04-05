Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BDE6D82E5
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238764AbjDEQFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238396AbjDEQFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:05:16 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCCD61A9
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:05:11 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so23715081wmq.2
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR5kvRphrC8o/hHrAZxx+p2NR9QjIUYlt0J+xt0JrLs=;
        b=Kue5crNsn30pNOYpY9SPsIZwYEzatKWT1JwNyC4Tz7AI+Dm1LFg9LUQzgpf2K6tikc
         mk/JLoWJuJW2YMb/u8tpJRDDD7NE7oEZWhjMD1NIUNYPSkllpMt4dfkpHFl4mXkmb2/c
         TNeHcs9kjwshAlFLaAd4rINe8sxW9leo230jyONFwRebI56QBZwVXxxrhO9P73poHXtK
         Y8QJ/YWtGqiDl6UF/8eCPHY7/WUX9shWQCd5AGt9lFkl2TKo5jGKRk9cKJNCtgCpeGep
         9jtSe7h0htiRpqIt8S8VefTo70S/iyC9ehr9mAsFxriP5352D4IpRYJpO5PNI1YHwluK
         zLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR5kvRphrC8o/hHrAZxx+p2NR9QjIUYlt0J+xt0JrLs=;
        b=A9hdibBR0jBu+9JU2ANsbNQTXD4NboFg9R+wT7ZeGueCQNNf0rwo3IOJ3FUH4TpzYi
         YhOY4JLdWfgZcvv0o+1LjSk/k365JkrXAvvIbcD6V8gn9CAvelmLj08CfDh5Il3UxaCq
         Qvk+X0IqxL/VO2zSI9nXwkhbZt8tOoXOLLavePaGGJEoeWaX70C3SeBQKG67CPE7lbb4
         YKjCBcJH3F7LxiAY7wQbcR/ZSdjYT/xTcSlO5a22A1f2peIPsQLkmq34CbpLEXlo7sD+
         DgSvlhToih8HuWymivPPn7Tzxerm8M7LW6Lx29B5XC0AAw7FEgPq9bUroLiXIL2GdWiG
         h1Kw==
X-Gm-Message-State: AAQBX9f7Xj4MKniXyFtQ6uXw4y9RBYzolkGyaWZQwMoT74yJRpuVIaG/
        T1yEBDiT9dHL7qmsMJjVx+YKRQ==
X-Google-Smtp-Source: AKy350ZaWzKW7gNGd6JCeIyd+5HFBIKAziuH2LQaatqde7bMAk2r3xVbM5UGjlxR3ZLELjGpAEwkSQ==
X-Received: by 2002:a7b:c7d4:0:b0:3ed:809b:79ac with SMTP id z20-20020a7bc7d4000000b003ed809b79acmr5056954wmk.19.1680710709383;
        Wed, 05 Apr 2023 09:05:09 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id t6-20020a05600c450600b003ee2a0d49dbsm2642061wmo.25.2023.04.05.09.05.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:05:08 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 02/10] accel/kvm: Declare kvm_direct_msi_allowed in stubs
Date:   Wed,  5 Apr 2023 18:04:46 +0200
Message-Id: <20230405160454.97436-3-philmd@linaro.org>
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

Avoid when calling kvm_direct_msi_enabled() from
arm_gicv3_its_common.c the next commit:

  Undefined symbols for architecture arm64:
    "_kvm_direct_msi_allowed", referenced from:
        _its_class_name in hw_intc_arm_gicv3_its_common.c.o
  ld: symbol(s) not found for architecture arm64

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/stubs/kvm-stub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 5d2dd8f351..235dc661bc 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -27,6 +27,7 @@ bool kvm_allowed;
 bool kvm_readonly_mem_allowed;
 bool kvm_ioeventfd_any_length_allowed;
 bool kvm_msi_use_devid;
+bool kvm_direct_msi_allowed;
 
 void kvm_flush_coalesced_mmio_buffer(void)
 {
-- 
2.38.1

