Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43A2722B8C
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbjFEPmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbjFEPmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:42:24 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22474FF
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:42:03 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b01d912924so46013955ad.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979720; x=1688571720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBfW759GkKFTzUJgKoX8uA384VuYsPAE0vmOulKke4E=;
        b=GsQQh15wVmlQHwcRg9bvdxbzEsIGOVvPRMdnOxcyy4n1fhB5ont6tYc4awzRi/gt3O
         iUjoTaMkIWsWK3dH28thritzx0yAslkk+BN2vdV4D6204M0SFaEXtwQIAPi1NkVGUlgZ
         C0YxsDT87raETp6RcOovcG213qgc6eXcPP4GnOrMXNocbyxafgrBSR/q1SMnnFWWHjx/
         nbbaTY7phpfSP2g2ij0o/oT2WEwFNAkw8pO3JDBmiWyqybqBGlk1B8dPl+fWDDXVYY6K
         H1+vfHwTaM+2A4/c/5UQZiCygzg6nJBGzkMLLYF8eci8uvftIgKmacSvOb9nuweRi/FQ
         qiVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979720; x=1688571720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBfW759GkKFTzUJgKoX8uA384VuYsPAE0vmOulKke4E=;
        b=lh4HRvKnH3HdfpmDreGXhO3JyOapw9Pl/sDpZGa4wKkdbYQC0kYuVw6cmPV/rGMVi9
         GWMzPmgeie2osPyC2OeKPgGSZXTeZGuoab2jWV339RTPQcwChkQoBiY7qtgE/jglJpde
         FIhK3tCmNMVX8A00IqJ7suRlmA5KDUfY/VyDO84q00dyrsED9bE896syTLNTiNEx0qhL
         uG+t5DUm6kSAip5wraV7/+jawMzVkBdzjpn+DOI0K6rSDrYGcCTwVERNw8eHD7lIp457
         PpYNx1UK+Ge/8B/fdUA2Dgan+Zu29Z2+p0gv1qzaBl9cQFjBaOpHV3moga8j+LPXOANP
         QbQQ==
X-Gm-Message-State: AC+VfDwuJ+vbjLhuxHp+8QYhxhxfycAccBnB2fWL9VoeUBthrn/0IN9/
        lCsopPz99yO7JKHUW/I1W4mrhg==
X-Google-Smtp-Source: ACHHUZ7rKTugKoVEziJV+gkC7XJI8FhQ4EESaFrT4CkW2ElkLsjNLgehEW4rqgWAicr6PBGWCEKbdQ==
X-Received: by 2002:a17:902:ecc2:b0:1b0:42d1:ecd0 with SMTP id a2-20020a170902ecc200b001b042d1ecd0mr8656899plh.66.1685979719813;
        Mon, 05 Jun 2023 08:41:59 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:41:59 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v21 22/27] riscv: Add sysctl to set the default vector rule for new processes
Date:   Mon,  5 Jun 2023 11:07:19 +0000
Message-Id: <20230605110724.21391-23-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
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
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
---
Changelog v20:
 - Use READ_ONCE to access riscv_v_implicit_uacc (Björn)
---
 arch/riscv/kernel/vector.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index a7dec9230164..f9c8e19ab301 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -180,7 +180,7 @@ void riscv_v_vstate_ctrl_init(struct task_struct *tsk)
 
 	next = riscv_v_ctrl_get_next(tsk);
 	if (!next) {
-		if (riscv_v_implicit_uacc)
+		if (READ_ONCE(riscv_v_implicit_uacc))
 			cur = PR_RISCV_V_VSTATE_CTRL_ON;
 		else
 			cur = PR_RISCV_V_VSTATE_CTRL_OFF;
@@ -243,3 +243,34 @@ long riscv_v_vstate_ctrl_set_current(unsigned long arg)
 
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

