Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72250708605
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjERQXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjERQXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:23:15 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F74E69
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64384c6797eso1740465b3a.2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426972; x=1687018972;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GbKkWHcrIgmeU53Vku19x3Zfwadjf8vHA4LYRH5wmCY=;
        b=NEzuFRUUhNOcH1q+Rm2j6i6gqGIp6xJPZ7cmA5mkGLFv+USZnOvW7CPzqUHuq0jVHu
         GtA7ZEFRhmBIY4mXuhnEnYyqYwcE+TU3PjI6DHlKhvnDeybKpslFBiEnvmkF/gS22vvD
         HHSJJElg9ZauzU3ulLEqqbltCizHYYAiTB0PEj5PhBig4wJl7H8VgLLgx/R7TNvTn0rC
         eMlyKdU5WWy6/GzMGahUnd0JVXFLZq0/+vTrnvDRootsNqND47vi78ULS+0TqeeadBGI
         Z+r3F1+htzAnsixZgXU6oR1vcL0hrQbjsFwGymu+x/afZ/DEKYgEmIqavy48mY8M9S6d
         ziKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426972; x=1687018972;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GbKkWHcrIgmeU53Vku19x3Zfwadjf8vHA4LYRH5wmCY=;
        b=QNcnZ7Qq8Ta5oBM0EP8Z3FN0rr+DYqLgfppmzc+JFPfNlv2coX5ntE/ql6YJyLOk3I
         OSw5Uc8t3JhxlrCOdC2sdK+pT+f/mhRqZspWW5LkFOy8yTdj12rULmWta7wNtMg8uDNA
         +a9nWrCbqoXQ9xseJdF2Tbs1jEbHqNNBKMYyzrjyvr2yIxO9jid4+d9UFpbtT84+vsuB
         3bw4T63SR7XC+loVWFDOMDyI3t65BfPhj5O2jbnxYMQbLnb9cOKiQOlK+LZAAaVNtMpE
         hi+ffKi+XD4KtUrcDtFB2sSDVzgtU79oaOXNxFcKIELTGhMxW1naado0u0s55XYOm6Nh
         XT/g==
X-Gm-Message-State: AC+VfDwyAvy3FmICKXz2A/gZKg1dIjmgB00qTGHQOR2Q+kjhpE4z9yvn
        Xq5CmerbqLzOJxe0+/x2EYYZnQ==
X-Google-Smtp-Source: ACHHUZ4cNt92/WP2ysaHY9D2AcqqSWS+D+pEmSvvEFQxQEF0lgCg7dMBCSKN+WsgVX9S5/lGcyi2ig==
X-Received: by 2002:a05:6a00:1a55:b0:648:d20c:37dd with SMTP id h21-20020a056a001a5500b00648d20c37ddmr5634519pfv.18.1684426971795;
        Thu, 18 May 2023 09:22:51 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:22:51 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Shuah Khan <shuah@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v20 26/26] selftests: add .gitignore file for RISC-V hwprobe
Date:   Thu, 18 May 2023 16:19:49 +0000
Message-Id: <20230518161949.11203-27-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

