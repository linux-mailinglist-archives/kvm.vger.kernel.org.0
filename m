Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC237A4E72
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjIRQSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjIRQR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:17:57 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C32A2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:09:43 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-52f3ba561d9so10226824a12.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053381; x=1695658181; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbLvVhCdjkLoKVSI3XlIe8h3b/C8JwK6Lt4fUZyBeQw=;
        b=MSEwH4vKfd0quO6q5e7dnGQrLGblqgd85rR3+R1OP9mzcGRwYJ77anICgeWWvtQvq3
         tXOReoA3QkkryDhvazpG2E4LAr9c8saaqDUSuFS9PWunhZkPqwUFc3Rwt2OSku8zGDwP
         37eEzBnbePhYGrhk63TkdlficlUJwX3UfadffN+0gwMbzTi9v08uR0dpIBKt67LnmfEk
         boHbFZfgqsuRac7qipNXCixXQnRcgTJS22mzBuAvDJJAEqConIZl4PJoPnlPn4B96xdc
         AWdzsXIMLq1CnbAKRIADJtUcFIhDxDWLkzANX544ObBYPM+VVBtI6T217ZNY8CGGdrQf
         cW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053381; x=1695658181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbLvVhCdjkLoKVSI3XlIe8h3b/C8JwK6Lt4fUZyBeQw=;
        b=xOrA0aGUm+58geGcdrWuHi1rFgJt5wHInPocM6+UE/zFsjGupA4hVSWEMKgCzTdfNW
         XglZ5UW2AGeG4hGbATvWK7IDMMTD6x3qrEdO9CVjyAr1TYlVbTUEbVQmeIpA49CaIXQn
         x/jIjEf/PCQ9jyMp7Lx6A0vO4+sk3cF1jgJ9yQQmCHHRiuil8bR6gFUFrWxnk0nLuiMy
         5VFcHWNtVUSL1fwY2JpwcLuYXfFWhUwibF7hMvUiiuzyd4mSSTX+nwyGEV4ziZ4Wwmaj
         d7L/O/JTwU4KBugW8Qhu2m7uFtA57R1nQwHBlkkUenMz6tb2vZJdz++VJ7cWV9HRDgwk
         qMrw==
X-Gm-Message-State: AOJu0YygsArK/Lem8MNGZo+CjAMWRkcGjywerAu/+qB4K7XuDc9mjeit
        slqyY7gjcmkd6nrasFoBN0XRogrgtb/9NfEjsDdC6pUP
X-Google-Smtp-Source: AGHT+IGUIRL/Cj2QgpL/SWnZOOte/5aXBCe8PvtqKJ8rdHwjYW7XrtiQqR5SrkqTU7jQZeCu2Klurw==
X-Received: by 2002:a17:906:311a:b0:9a9:f0e6:904e with SMTP id 26-20020a170906311a00b009a9f0e6904emr154241ejx.16.1695053053645;
        Mon, 18 Sep 2023 09:04:13 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id n26-20020a170906119a00b00997cce73cc7sm6586020eja.29.2023.09.18.09.04.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:13 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Brian Cain <bcain@quicinc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
        Claudio Fontana <cfontana@suse.de>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Alessandro Di Federico <ale@rev.ng>,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Chris Wulff <crwulff@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
        Bin Meng <bin.meng@windriver.com>,
        Stafford Horne <shorne@gmail.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kurz <groug@kaod.org>, Michael Rolnik <mrolnik@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 14/22] target/sparc: Init CPU environment *after* accelerator vCPU is realized
Date:   Mon, 18 Sep 2023 18:02:47 +0200
Message-ID: <20230918160257.30127-15-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These fields from the environment don't affect how accelerators
create their vCPU thread. We can safely reorder them *after* the
cpu_exec_realizefn() call. Doing so allows further generic API
simplification (in the next commit).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/sparc/cpu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/target/sparc/cpu.c b/target/sparc/cpu.c
index 2fdc95eda9..88157fcd33 100644
--- a/target/sparc/cpu.c
+++ b/target/sparc/cpu.c
@@ -756,6 +756,12 @@ static void sparc_cpu_realizefn(DeviceState *dev, Error **errp)
     SPARCCPU *cpu = SPARC_CPU(dev);
     CPUSPARCState *env = &cpu->env;
 
+    cpu_exec_realizefn(cs, &local_err);
+    if (local_err != NULL) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
 #if defined(CONFIG_USER_ONLY)
     if ((env->def.features & CPU_FEATURE_FLOAT)) {
         env->def.features |= CPU_FEATURE_FLOAT128;
@@ -776,12 +782,6 @@ static void sparc_cpu_realizefn(DeviceState *dev, Error **errp)
     env->version |= env->def.nwindows - 1;
 #endif
 
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
     scc->parent_realize(dev, errp);
 }
 
-- 
2.41.0

