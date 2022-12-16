Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0491964F3B4
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 23:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLPWHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 17:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiLPWHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 17:07:51 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDA5175A6
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 14:07:48 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id gh17so9290934ejb.6
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 14:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dnjBpu8YAsQiqTIBqdAxGgUmmCKdMDBQ66ZGoKps2Ew=;
        b=V3iElN+pWdNXlbuPkzYch26WWW47kZLvkp4pklr7MqLTRunNn+TowQUCROmuGTluTf
         FsYrRMIjbaKMvwPHXlfASr9BDsiFaNk5utWdmxOagO2T38fiu9GKn2LnXis0PoxQ+y4M
         jQbhdKk5M8mKJ4olp/u/KIfYKN+m7g/B7yk272XBW3r9g7vjxf8hIvdcnnyTrWybBjhD
         QZEnwyq0y5KBYC6dw/g5x1zKU+Ygl2Khg01/qm6G75KuQIWVNQw+qzd370FBZ9tYzVS/
         FXrTuzGh4dxHBWogjOU7q51i3Ndq71mTCiVkLUl/lNwRyIaEDc5r/1JqjfsuvhJLEHat
         jo5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dnjBpu8YAsQiqTIBqdAxGgUmmCKdMDBQ66ZGoKps2Ew=;
        b=SoL33mW5Pz14Zv6N26irlMP/ZCDp4EbFBAsuZ3U1WdHZRzVouPPWYFVdTm7y/kXdXv
         M0jqE2tmQGPGDUUcIb/7E2hxyU7TES0WgEX9E0U/1oC8pCRe0gFaQRydz4YzYVOnbt/A
         RJGUQeV+KrffJHe35akNYmFgPirbdYKW/qZewLiJHRhAYkE/ti6ezgHzIHJyhfig+pW7
         OO+k6DDWTwCwlcTGxZoSHvgZG2pYWdRbMHBX0LT3G4QaRMdBwXTEvZNTLKNWTCFOhyWw
         07oS8OHOiMgfFb/fVfpOHQ6Tv9Y41PTfKv9mDfhuhgu3p5BWB6nZI31cuyRcmM7XLiRq
         lccA==
X-Gm-Message-State: ANoB5pnVSxn9Xamgkn2+1AClJBzQR2M8pKvWPvUBFd0qwFlQpALYDOqb
        mGV9ZcVD/+nbGLsSYlQJgZUZQA==
X-Google-Smtp-Source: AA0mqf5FXdnuw+SCM5bPyadVl6lKNY8k4Ioju8XS7pTqY32yMybMBXqVv08QWaAB2Z4v9CR/OLRXLw==
X-Received: by 2002:a17:906:698f:b0:7ad:d250:b903 with SMTP id i15-20020a170906698f00b007add250b903mr38530813ejr.56.1671228466702;
        Fri, 16 Dec 2022 14:07:46 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id p23-20020a17090653d700b007bed316a6d9sm1308360ejo.18.2022.12.16.14.07.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Dec 2022 14:07:46 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 1/2] sysemu/kvm: Remove CONFIG_USER_ONLY guard
Date:   Fri, 16 Dec 2022 23:07:37 +0100
Message-Id: <20221216220738.7355-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221216220738.7355-1-philmd@linaro.org>
References: <20221216220738.7355-1-philmd@linaro.org>
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

User emulation shouldn't really include this header; if included
these declarations are guarded by CONFIG_KVM_IS_POSSIBLE.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index e9a97eda8c..c8281c07a7 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -471,10 +471,8 @@ uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
 
 void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len);
 
-#if !defined(CONFIG_USER_ONLY)
 int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
                                        hwaddr *phys_addr);
-#endif
 
 #endif /* NEED_CPU_H */
 
-- 
2.38.1

