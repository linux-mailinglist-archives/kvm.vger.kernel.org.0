Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5D56FC3FE
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbjEIKds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbjEIKde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:33:34 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D174106E7
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:33:25 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-643ac91c51fso3107842b3a.1
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628402; x=1686220402;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=941FZ9JR8q5CEhK2jSJwDse+5gwyYf1wDxuvPa9cwEY=;
        b=An7cnHT+loomL/g7RPJmFt75o6e0J+e4OnOK/7+TXoVdE0nczQr9FSgNtsTA8dGa6l
         oXlXl7mwBZOFnD6EQIrBdlqArIc9rVndl/oGZPf/MWlv6mO2tjsTT03YHNw1ywBFECAW
         FKU9PP5P50HYEcMnrxwzcAj03n5dxcznQO6tM3Au55xmfaUb0CY4IG8AQ4H30aNtKOZn
         yVVKy+VO6yNMuIU2hydnKL9Na7YRePysTlTdtSn1z0BqqWy2aSgG927vfJg7IpJHaAgL
         ni330YvIhU3/uX84oahdFv/wkb3JsgKE01aKtRdEcWK+pM3q/i3jvEjy0++kjkvrUkfN
         yD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628402; x=1686220402;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=941FZ9JR8q5CEhK2jSJwDse+5gwyYf1wDxuvPa9cwEY=;
        b=klrO5fhMdYE9OLJH2twxdA9Bqshcp09XAAb0it+xZnWVy6zAVZoik8AUnGg78m8qQu
         9zNNYJni2jmYrJ6pbVLEhvYhYV9A/8Xy/Q4tm88Q3t0abgSvdyNQ49Jhh1y2CElesA4Y
         ezve8T0RT5ejMbxnRTMTYpgKJtty72OxW44benDa2Nw8aZgBZHiOUqZICZpAgmIntbiy
         qifHZ0EwZwjkz4z6pkny/9RIwvcAkPUf/stJTREAo2MtEhbVMwooh851VbtgU/R7L/vH
         1dxrABFMPEkGA4XNg8j3qeRLPny2n5wsyzbECKG+4feA1TF/LnHqPUbbTiV4hfM1cARu
         IU5Q==
X-Gm-Message-State: AC+VfDw8oZzDxYdovfmTghpBVhwgbRQHKXrIyAVCAIbEiav+AIIUR+2a
        2UjZybmhsatt/S2NOsVKihdkNg==
X-Google-Smtp-Source: ACHHUZ4L8N85doaQ33hgQswXAJ2/iV0cFZ2Wf2RzXa8ycldgql4vMle8s5Eb4TVPCsn5L6rx7lVvJA==
X-Received: by 2002:a17:902:b583:b0:1a9:20ea:f49b with SMTP id a3-20020a170902b58300b001a920eaf49bmr14245517pls.24.1683628402118;
        Tue, 09 May 2023 03:33:22 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:33:21 -0700 (PDT)
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
Subject: [PATCH -next v19 21/24] riscv: Add sysctl to set the default vector rule for new processes
Date:   Tue,  9 May 2023 10:30:30 +0000
Message-Id: <20230509103033.11285-22-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/riscv/kernel/vector.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 16ccb35625a9..1c4ac821e008 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -233,3 +233,34 @@ unsigned int riscv_v_vstate_ctrl_set_current(unsigned long arg)
 
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

