Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5066C6BCD
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjCWPCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjCWPCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:02:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C8C36686
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so2345033pjz.1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583669;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U+ouetyhXDlSjJJrs7uB9nNBREilJX6aCD2bcZWQVec=;
        b=CTVAyxXuZQajxAGCxDiblOwdF6oTSft+FYeysyuhJ/h7OntJ0akZBDT1uUC6xXIhGt
         V59bRkFFoNHXVo1L5auDb1xzyzkowkZQ1JfG0iEYg9lMZiixduQPEZ57qSeNxIJ140HG
         FOwCekVIUcluoDRvWd6kaOL+d69HCMWpkGQfsJCfWAdferXxduhKsAvCSQmvrnDn63o4
         wjGNdEX0uVwWV8BOZiX2plGjf7e+b19Vz/4eYr4rm7eOP0+KgH74Xiv8OiHafxzZr0lP
         eaurdK4tMrqmMLxi0Peq8riIOHb185yFZY6Pyd3qIELT5ivmv4j5X8AnOzZMdsl3DORE
         8HZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583669;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+ouetyhXDlSjJJrs7uB9nNBREilJX6aCD2bcZWQVec=;
        b=FiG6jmHIS+hRLso6160pe79d6wbBJUy3W4NNiVBKmXscS16xjfsK5o5WNLwcCOapGg
         oOzUA3VHUZLQ8XedvwjIId+VyPzhtSbnkqa1QQ9/CCdRjlBnMJq/gxuueEbL6TZbsH9u
         UeSaYM24HZ2ukD6EEXnyz76kEzJ1fych8mfdCS0e+9XiEC5wcdxeK2t1NuHhLCLc9TP8
         62ySYEE0XxHyXGP00UPAN/kYBu83wTPlT3D38LC5jv3qU5D+Ea3OOES+TzlIdkn0woIh
         /Vv5tsTJ0z8WwVdT+olu6SmTVjXuimZW16ozIjkcXE4kMqoHD3jhJoLScamyWdTKgqhs
         FLgg==
X-Gm-Message-State: AO0yUKXFX0bGSR+TJtZ1obfaxWBAocKQIGjfNEv6HGQfSlbJzBX4co/S
        3Z0kFvo8Kacvn2YhxGkh3NZizQ==
X-Google-Smtp-Source: AK7set8rM63JHpwDOS1Hl4On1gtG8fPUiROZmSOfWhxCHPK1Cemsm4kUqDHJHPMQawySJxqBigleLQ==
X-Received: by 2002:a17:90a:d583:b0:237:c5cc:15bf with SMTP id v3-20020a17090ad58300b00237c5cc15bfmr8344876pju.13.1679583669355;
        Thu, 23 Mar 2023 08:01:09 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.08.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 08:01:08 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH -next v16 15/20] riscv: signal: validate altstack to reflect Vector
Date:   Thu, 23 Mar 2023 14:59:19 +0000
Message-Id: <20230323145924.4194-16-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230323145924.4194-1-andy.chiu@sifive.com>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 arch/riscv/kernel/signal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 6b8bf935b33a..ffde81cfadb7 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -494,3 +494,10 @@ void __init init_rt_signal_env(void)
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

