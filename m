Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4167085F1
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjERQWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjERQWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:22:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DBBE69
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:21:54 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64d2467d63fso469783b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426913; x=1687018913;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=le6WsiFFpntTNhwR6ZdThyFuzfVMTXPYkTAyRr8nwRI=;
        b=fXXOF4/Pv9vy548q3wB5i638VAiAI5RYEsTrUBc+Lb3gM4Hwm4KD7C22YFD2UYd0ML
         EIj0bIxGhmH+aHUWUB9gwOOaPmFfXe5AqyUqObzTgtiqqDzj5Q4VW4HNpdCjTrhZLV9j
         9oqEDZAwj/wvOqjtp1dRpunkjC/CHuxw0voOQEY7kBVb2SRDde19L3W5bAC8TptVZFqK
         6LZe3vGGTBKDzTJrE62LgcbN2Ok7fJT2iGeFx69qUBMnA8AkjWLkOU4j/UqY74sTYCP0
         OiVpmvYhYne29PDTYzXxEAv6pis1jBjDNnuC79vttpOziIMEnRmCcYdyb61Vi7lRumPc
         kgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426913; x=1687018913;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=le6WsiFFpntTNhwR6ZdThyFuzfVMTXPYkTAyRr8nwRI=;
        b=i7Mq92xm05oQtYFMNfIdBFdbYojQqzkZ0LwWWucDWqtOp1rQo/V0q27VAiHMknji0I
         Tt00Q1BL1zL+mwjxVya+s6fc7RoHfVybeShRInEmHBR+fc5sodfAmq3XU2fJTnkFu9Aa
         OrCkJubGC1xP+SnDXdtuifj63/ZCRktC63YursrQDug3OD2PuWUYooNADSQfWCpaR3Gk
         S902SsWGmtLW72tMu6rlUo2c86d8bQ/1jcoiTEO7d1C0EjfvAAnV1dqPKVGwvJmBKDHM
         o5kqFsFxlX418LajZ+m64wnfNA3JBcXK4/K9OKU4naogCapsrAwHbFBC026Xz++9STXf
         F95Q==
X-Gm-Message-State: AC+VfDyvH+QLs0IOruiFsPHNcDJJqRi+tKVDCN+j06XZuHqjcIXl4Y2+
        TLncsw7NWZJDY43AqHlXWzQyEg==
X-Google-Smtp-Source: ACHHUZ5zF66YmJviWU3jMsRmaNPWP5h2OCQhUdkxpbsBNEDtT+ng2Q1VyqjENFKM+MPelZ+ItaoLOA==
X-Received: by 2002:a05:6a00:17a0:b0:643:ba77:f265 with SMTP id s32-20020a056a0017a000b00643ba77f265mr6240882pfg.25.1684426913165;
        Thu, 18 May 2023 09:21:53 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:21:52 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v20 16/26] riscv: signal: validate altstack to reflect Vector
Date:   Thu, 18 May 2023 16:19:39 +0000
Message-Id: <20230518161949.11203-17-andy.chiu@sifive.com>
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

Some extensions, such as Vector, dynamically change footprint on a
signal frame, so MINSIGSTKSZ is no longer accurate. For example, an
RV64V implementation with vlen = 512 may occupy 2K + 40 + 12 Bytes of a
signal frame with the upcoming support. And processes that do not
execute any vector instructions do not need to reserve the extra
sigframe. So we need a way to guard the allocation size of the sigframe
at process runtime according to current status of V.

Thus, provide the function sigaltstack_size_valid() to validate its size
based on current allocation status of supported extensions.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/kernel/signal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index f117641c1c49..180d951d3624 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -476,3 +476,10 @@ void __init init_rt_signal_env(void)
 	 */
 	signal_minsigstksz = get_rt_frame_size(true);
 }
+
+#ifdef CONFIG_DYNAMIC_SIGFRAME
+bool sigaltstack_size_valid(size_t ss_size)
+{
+	return ss_size > get_rt_frame_size(false);
+}
+#endif /* CONFIG_DYNAMIC_SIGFRAME */
-- 
2.17.1

