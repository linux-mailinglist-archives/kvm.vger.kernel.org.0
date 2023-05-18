Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365D97085F9
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjERQWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjERQWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:22:52 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F36310FA
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:31 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d2da69fdfso34193b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426941; x=1687018941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXLmDwuFl1hIBYmEn8BiIjw8uR8exImuk7v2QQ06HGI=;
        b=V+Us4Le6T3lwbiDvi+H91rnJIcZgu0unNFqjLvxRdYA+JPyR7Hkga5r3hCCKzkKCyI
         3dXM73umBgTF8zahR9lApj8gFkl4iEIO2EYh+9R7vUzW4je/Vc8oJgY25O8qat+ASZFg
         vuy3SjHBbYw8ltUsFBkh4jmHCEKnyR38quaPdAF+CWZugimUFtgsb8cYDo5vLB2fwrjt
         dmVwNoi3++6JmFGeDwRl3c+SE1n/w8tTdhN+Fe4AtjPfLbELEWxMrtcNlREP6s3zm7dW
         K+6Tenwl0fr+uwvvoxlZxzbUAAjG7oiMUxkeltkc4p/MTfaqtaGccbq6NZFspFEf+Gpo
         PliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426941; x=1687018941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oXLmDwuFl1hIBYmEn8BiIjw8uR8exImuk7v2QQ06HGI=;
        b=AGn4BEExxH6MvwLmZWTEJ5ToGj0g0An84f4SYdC/BzPQGYS4LrW0ZHqHPe1aoaBwLl
         hnbKxsCFmBApLwx2oI69nvUjLYeuWg7x7KsIamQQYBl/gVYUK6TDpIoFVmxk4DXa3akP
         Bqd0bLmiMMSZEblOCDtmcrln6+uPCwN/7vQkWDffZRnEkXLw4ZpLBPu90PwMgecuT37w
         g8j/cYimfVs7EBCubDJVdH4MJP4zUVf5aZf+fMUr3Q/PfJPt+rUwW8Wd222yCC/xQlBC
         duc/wTo4TuHfnMXz5N68lewXbZzDIQoXgRhUubL8hxGjiFPqvF5vZ+Lan4uvu3vMf3EV
         V1Bg==
X-Gm-Message-State: AC+VfDxeAtEnMfJogVYnxRyrcaAV+Qm4fgvXoOHcISNxyvcji0s1l59a
        RS6eLQ472d1HI22Lhny3wmrZEA==
X-Google-Smtp-Source: ACHHUZ7pspQwthnUGGL7Ub1wIr9lCRm7UtPbxjpJc4ghLwvFfMdQFoJ0eppPqiny7eMwhjcpJ/snQg==
X-Received: by 2002:a05:6a21:32a8:b0:100:9969:8cf with SMTP id yt40-20020a056a2132a800b00100996908cfmr194460pzb.49.1684426940992;
        Thu, 18 May 2023 09:22:20 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:22:20 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: [PATCH -next v20 21/26] riscv: Add sysctl to set the default vector rule for new processes
Date:   Thu, 18 May 2023 16:19:44 +0000
Message-Id: <20230518161949.11203-22-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To support Vector extension, the series exports variable-length vector
registers on the signal frame. However, this potentially breaks abi if
processing vector registers is required in the signal handler for old
binaries. For example, there is such need if user-level context switch
is triggerred via signals[1].

For this reason, it is best to leave a decision to distro maintainers,
where the enablement of userspace Vector for new launching programs can
be controlled. Developers may also need the switch to experiment with.
The parameter is configurable through sysctl interface so a distro may
turn off Vector early at init script if the break really happens in the
wild.

The switch will only take effects on new execve() calls once set. This
will not effect existing processes that do not call execve(), nor
processes which has been set with a non-default vstate_ctrl by making
explicit PR_RISCV_V_SET_CONTROL prctl() calls.

Link: https://lore.kernel.org/all/87cz4048rp.fsf@all.your.base.are.belong.to.us/
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
---
Changelog v20:
 - Use READ_ONCE to access riscv_v_implicit_uacc (Björn)
---
 arch/riscv/kernel/vector.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 9bee7a201106..25c7f5c93b00 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -184,7 +184,7 @@ void riscv_v_vstate_ctrl_init(struct task_struct *tsk)
 
 	next = riscv_v_ctrl_get_next(tsk);
 	if (!next) {
-		if (riscv_v_implicit_uacc)
+		if (READ_ONCE(riscv_v_implicit_uacc))
 			cur = PR_RISCV_V_VSTATE_CTRL_ON;
 		else
 			cur = PR_RISCV_V_VSTATE_CTRL_OFF;
@@ -247,3 +247,34 @@ long riscv_v_vstate_ctrl_set_current(unsigned long arg)
 
 	return -EINVAL;
 }
+
+#ifdef CONFIG_SYSCTL
+
+static struct ctl_table riscv_v_default_vstate_table[] = {
+	{
+		.procname	= "riscv_v_default_allow",
+		.data		= &riscv_v_implicit_uacc,
+		.maxlen		= sizeof(riscv_v_implicit_uacc),
+		.mode		= 0644,
+		.proc_handler	= proc_dobool,
+	},
+	{ }
+};
+
+static int __init riscv_v_sysctl_init(void)
+{
+	if (has_vector())
+		if (!register_sysctl("abi", riscv_v_default_vstate_table))
+			return -EINVAL;
+	return 0;
+}
+
+#else /* ! CONFIG_SYSCTL */
+static int __init riscv_v_sysctl_init(void) { return 0; }
+#endif /* ! CONFIG_SYSCTL */
+
+static int riscv_v_init(void)
+{
+	return riscv_v_sysctl_init();
+}
+core_initcall(riscv_v_init);
-- 
2.17.1

