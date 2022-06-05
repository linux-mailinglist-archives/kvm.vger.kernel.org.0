Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD64053DA87
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349634AbiFEGdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349714AbiFEGdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:33:36 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4340F3879C;
        Sat,  4 Jun 2022 23:33:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s68so10469794pgs.10;
        Sat, 04 Jun 2022 23:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R820kjNKIxbkGEAKTjC7XUwmvnnoaBu0HN4Qfosm3J0=;
        b=pmsz3LNUmmxXTlSH9mZq67G4T5JalQR7Q1TcEhZ4W7pXtvGEZy4FQZMZ/qblh3ixTW
         7CZcSllLwHNsW6FPTtTV9997ab6JGfsz2B4IC/EACpIoziaY6FDDiBt2GdiaJusgg5Nx
         bmfxEfap/5p6MN2FFZuN8wNqlePip3y734oU4PhxJc08ftB8GyUI5er5PnDPBXTmbgvn
         MziFrDWK+VH5vIjMdU3oOcII2pcrLWHanfQHu/qKVkOls68jsxiWtQucgREH6X6ziZBl
         honP47ocaRKZYEH1dcTSDneznUormOOsU9EdLPs+LQ3rElDreTp8wTvgmFQrhO1cVe5R
         pvaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R820kjNKIxbkGEAKTjC7XUwmvnnoaBu0HN4Qfosm3J0=;
        b=OxsRnQV4f0/BKg87h2dVBDLCpA3gCRjnipePi6Rl9oSbWGOhrCxt7YeQSJLKMY8j35
         URhkBbkqcRHg09HUheiC5ykvdGg4PTMKn04yATau7WMbrJHvrz6Ir/4HbYoV7pDxVu2b
         CSMNrHAc6a/Ckp7UZEMoJJEo/QhZD4UPg2sSIFkwz0pk3S3WpRq01SjpF+aqrj5lxnSP
         DR1Sq23+135bW/wZQS306RCGh5iSVOelIJ9fDioluXhd5gqH0sywE//M/iHQRMCE0vRo
         R19OQulcAN7Lyu/13WcPBNry2RCVNPPJZMINBLxSLwHtDuCYe03tiwmmywcScJkK/p9e
         1rWA==
X-Gm-Message-State: AOAM530ZvzoRi7ZnmmywZrwCF6bsywYhJyMpWZScbMXxjTpyr+Q1rv/v
        BaVT2kric2HrcMOU0G1uKZbaSdC7OKA=
X-Google-Smtp-Source: ABdhPJznYNZ0pj5UHlTWjlFW8AWtjRydz077P6+f3/XnU070x08h25mql69PfY4IpMbns4iHrE9Fqg==
X-Received: by 2002:a65:60d3:0:b0:39c:f431:5859 with SMTP id r19-20020a6560d3000000b0039cf4315859mr15641488pgv.442.1654410814670;
        Sat, 04 Jun 2022 23:33:34 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id i19-20020a17090320d300b00163f8ddf160sm8110451plb.161.2022.06.04.23.33.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:33:34 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 2/6] KVM: X86/MMU: Remove unused PT32_DIR_BASE_ADDR_MASK from mmu.c
Date:   Sun,  5 Jun 2022 14:34:13 +0800
Message-Id: <20220605063417.308311-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605063417.308311-1-jiangshanlai@gmail.com>
References: <20220605063417.308311-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

It is unused.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efe5a3dca1e0..c935fdfc2544 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -125,8 +125,6 @@ module_param(dbg, bool, 0644);
 
 
 #define PT32_BASE_ADDR_MASK PAGE_MASK
-#define PT32_DIR_BASE_ADDR_MASK \
-	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
 #define PT32_LVL_ADDR_MASK(level) \
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
 					    * PT32_LEVEL_BITS))) - 1))
-- 
2.19.1.6.gb485710b

