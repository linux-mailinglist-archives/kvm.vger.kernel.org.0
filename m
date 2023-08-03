Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2566C76EBAE
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236586AbjHCOCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236588AbjHCOCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:02:18 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9018C212A
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:01:03 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6bc9efb5091so697806a34.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071259; x=1691676059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAcynScOpmJJpAgbkOZYKn6ILQea1aDVBL6bd0lWO7g=;
        b=h5wyGZdJugOapVTfRnHPWCqmuQ9bCO45+4hqZwI2EqNaFNIjubOL6dva8fyv4jLr5O
         xbfQyVMF2ZQyB6k19gH7XQKMviR4uuhjAVI9H8vb/0MJeGnslZORMBmqzgkWmgybTPrG
         LS2c2KCjkSZOJcmfHUstcgf0CUWTdUkmPpSA2BelrXV8adTExbXSf2DHSKJGiJS7O3i9
         Ep1av+4DO+qPtMhsWUDPJaTfHdBBnHSDiA9owbLM+SBg3ku+1wxKHwVwyNWynVEomwDA
         +jRKqr4/rlD819kJ9oXsOdMCejAAz7nCE+hMYZNI9RgbVWMWk3Xj2FPw0HXmnnvJQgNz
         tZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071259; x=1691676059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hAcynScOpmJJpAgbkOZYKn6ILQea1aDVBL6bd0lWO7g=;
        b=SiAAA4geRZv8FDlbIT168Kn91WNsKFa7IH8BKB9UDBn1di1mZMTbcx2XibSCYNRrnB
         ktdZ+tBrnEqYyv3AWBnwJJwi3MxJsY2OXoFcG+fm6YS75uyfvqdSgHD5bla31h7u6fmg
         94TbDwRwt45R0aXDNxL0cyFWp3kMS4ZaRernYShQ/P6JspP7ErXIPhFd8fF/JUFw3a5x
         pJwxuMfB1tU1m1M1qf3U8uB5Iw1kAvlskbvdNPHw04KUDmjeW2OjlukeyguVqMiAbive
         dMIScivZzAl7V2UJKy1/dQ3JgNkaXbJSs7AH5PscMC7ygmzpOoaFvIyO6xAZz8nEKauU
         gCvA==
X-Gm-Message-State: ABy/qLZjaYYLo+p7Fl4rQc7uzhRTAshpLIfz+3Zbhz7KIzIXTSrwLRve
        fRhjqJ3oI8o01oPCNkvpZNE8XA==
X-Google-Smtp-Source: APBJJlHllE/EaunMqwLTs5cwVf8bqP6wD0HL99VVwT6cKqI+jaDH/VDH2t/f1OSr6sXmNFPwBWf53Q==
X-Received: by 2002:a05:6830:4621:b0:6bc:a626:701b with SMTP id ba33-20020a056830462100b006bca626701bmr7019403otb.17.1691071259085;
        Thu, 03 Aug 2023 07:00:59 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:58 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 10/10] docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG
Date:   Thu,  3 Aug 2023 11:00:22 -0300
Message-ID: <20230803140022.399333-11-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803140022.399333-1-dbarboza@ventanamicro.com>
References: <20230803140022.399333-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The EBUSY errno is being used for KVM_SET_ONE_REG as a way to tell
userspace that a given reg can't be changed after the vcpu started.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 Documentation/virt/kvm/api.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c0ddd3035462..3249fb56cc69 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2259,6 +2259,8 @@ Errors:
   EINVAL   invalid register ID, or no such register or used with VMs in
            protected virtualization mode on s390
   EPERM    (arm64) register access not allowed before vcpu finalization
+  EBUSY    (riscv) changing register value not allowed after the vcpu
+           has run at least once
   ======   ============================================================
 
 (These error codes are indicative only: do not rely on a specific error
-- 
2.41.0

