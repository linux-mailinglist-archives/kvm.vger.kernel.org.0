Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C1F722B9C
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbjFEPnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjFEPnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:43:22 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C87E4C
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:42:58 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b010338d82so22642675ad.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979752; x=1688571752;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GbKkWHcrIgmeU53Vku19x3Zfwadjf8vHA4LYRH5wmCY=;
        b=Fs+iSAQ26EuErgnKPEjcmBTy4eNZK9hqe+pb0SH0SZWFh8DPByC8+H1iiEbnYkIaKh
         eZjtX0qRh82RKh+ELSEojK5e65RuZ0CKZTsesRGER5bDwHdsZn051qdpkMQbSvgH+f59
         pcAIgMJLnxHQifCdBojIgeb7wpbLT+18TMbA2qZGD7LkeChlgrW4fpJehmY/CyeeDWaF
         QAsCNdIhOot2rzOPWyzSZfZLr7ja6J8mMLthqvKqwQw/79XsaMm+7rtegqT4KkjBskVm
         iuRfRTQtIgDPQM0BQPedH2seS974wyDc5B0HR6WzXy9Le4CX2cWubTgxhtCLHC4NFibP
         gFYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979752; x=1688571752;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GbKkWHcrIgmeU53Vku19x3Zfwadjf8vHA4LYRH5wmCY=;
        b=kXaoRF+GUEnAgeK5jzqL/3xVfFud9kkrFHXZn/SCaVEjfRG4MDiiP1/Wld30FI3Y8W
         mYpsewdHDGpSIeg8J4uBrNLEqTQSAh3uEnAiNyBD0JU8J9U2JI1UWxsQUYThHa+wvrNE
         5PM9+DhhE09B8hQhSjf0cDH+i1JToxo6IRWsCYTz5ckQlVn2rPnbKPW360vIaZQhsaOt
         EZVmDtM+CM4ZPKJWUXWMAWPq2Vc8SxhSeu7ZiGH8YWuhnqL1LuKPmIJQZvgGmPRUEwkZ
         hhtzxBf+gROKyM8ws4wv/UpGb7/v3AJdWLyFu4m17AST+MShVLxzlCQ7wRqrGUQpTRIs
         Qh1A==
X-Gm-Message-State: AC+VfDzJzO7CmDxlaR9Rs7XCY4hz4daiEbfM8nD1vTYSDA/xaam7e/yo
        JT+dAc988otW+2zFh+aDJGyDhA==
X-Google-Smtp-Source: ACHHUZ7S3X2JsL5hHF0bKLSbGHCJWcERbwDqGTA5uH+49EFqOOvFm/YH7BsXtElZU5mUItovy54HgA==
X-Received: by 2002:a17:902:e886:b0:1b0:7c3c:31f9 with SMTP id w6-20020a170902e88600b001b07c3c31f9mr3863001plg.53.1685979752011;
        Mon, 05 Jun 2023 08:42:32 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:42:31 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Shuah Khan <shuah@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v21 27/27] selftests: add .gitignore file for RISC-V hwprobe
Date:   Mon,  5 Jun 2023 11:07:24 +0000
Message-Id: <20230605110724.21391-28-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The executable file "hwprobe" should be ignored by git, adding it to fix
that.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 tools/testing/selftests/riscv/hwprobe/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/riscv/hwprobe/.gitignore

diff --git a/tools/testing/selftests/riscv/hwprobe/.gitignore b/tools/testing/selftests/riscv/hwprobe/.gitignore
new file mode 100644
index 000000000000..8113dc3bdd03
--- /dev/null
+++ b/tools/testing/selftests/riscv/hwprobe/.gitignore
@@ -0,0 +1 @@
+hwprobe
-- 
2.17.1

