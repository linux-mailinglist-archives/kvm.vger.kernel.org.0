Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25F576EF92
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbjHCQdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235559AbjHCQdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:53 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF90B30E9
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:35 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-56ccdb2c7bbso771725eaf.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080415; x=1691685215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAcynScOpmJJpAgbkOZYKn6ILQea1aDVBL6bd0lWO7g=;
        b=haTj4cAaQ8nuB3BJwgKbtJ0OIMlsmmaqEEgNYuTKVDphVbgFKb31Tab8roRlGPx8yS
         2+i3SxJmvxI18SSZFmw8saZXidRJaMXNk3MxrdIdrW80ipC7CMKWW8PrGgFNULu+T/G0
         FGVNORNa6WQ57Jo4xMIqxYSkNRoZl8PNtog1Sz+kWiI1ySJZ921HTMFPZdpX2nqFwqBe
         frOfwlP5XxNtAeIc2v97jbah4yiS5op25qjzwojLXkohpBpoAHiyZTotkANqvsCFYC0S
         qpUKNWj2iB52yBoSlrkE7kHWeQgp8Y0oS97eTb/qWKkfpErro9kJAII6ZsCuzOWn7h0q
         e7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080415; x=1691685215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hAcynScOpmJJpAgbkOZYKn6ILQea1aDVBL6bd0lWO7g=;
        b=FgCjcQvK0QH6X+ytOVl0YSiDg0JRcqzuhfkZwAtv2oiUpz0tlFMUlUsa2wr2/judei
         x3yguLgHtDLba1e0+lNjlSQeHRdy0ocjKBw1Q7xcBDMY7VrfzDIwqpGSnevKqU4va4K6
         hBwBNcLIH64BVDxjftjRDeaTpbQmhZY5GyXGUFOAgSiohbN65SEGA5zjDYKWHVnUbv9Y
         wweiWGf2mIV0K7HRPaHgbveGxEmlQVC/9gQVmectXFxqRSdVTsYkVKRm/XaRHOXYkG/z
         JepUuSihsmLnppVd2nsanpMlhYyrapvslZQvvfBGUQjEuVs38i0tcWcJIYbEYp5BCI+h
         cBDQ==
X-Gm-Message-State: ABy/qLYYwwiwyPMboKh2V4bwDgYKwHiBl4zyPUn3USNO2Yfs1QRMDC1S
        yglDkIf4/wFVPxTpJmq4ulI7gw==
X-Google-Smtp-Source: APBJJlHc0cp5LnSyKvcl8/Xw+xNk5PdlUVq5hrHnfnlDK7OkPy8wfOEtmrs1AxZnyGAB9fvEQliycA==
X-Received: by 2002:a05:6808:e87:b0:3a3:ed69:331 with SMTP id k7-20020a0568080e8700b003a3ed690331mr23614574oil.6.1691080414812;
        Thu, 03 Aug 2023 09:33:34 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:34 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 10/10] docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG
Date:   Thu,  3 Aug 2023 13:33:02 -0300
Message-ID: <20230803163302.445167-11-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803163302.445167-1-dbarboza@ventanamicro.com>
References: <20230803163302.445167-1-dbarboza@ventanamicro.com>
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

