Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1BE7A4F6C
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjIRQma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjIRQmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:42:16 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A401712
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:56 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-500a8b2b73eso7543003e87.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053091; x=1695657891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMzTvk0FEO6I+ReA5ceoXcLeA6ER1WjzLpFKcs1vmU4=;
        b=POxpTtvRLsy2KrAPmkEKhjGKXMfIUvVFSGXJNTSc6J/LJUUwFqKL52eAggUZEzTyCw
         rahSekiU1eGAlWdauZ4zZGLgJ2vgrNZFvqJPSs4Kve2QpqHF+om4n3yTM5A6Yk5YPXQq
         Ska0KVFnjzJcXEQk36xDyeSu9YcdW1ZlageIzWPHwmusD9SFWWRPeuur7HCLG/o0i3xS
         j2shSeWCNEknu68rEncQXIj3+i2OYVGeBSm9rTB//3eHwIgII9B2jzPJX0ATlg2OrZfT
         qrIi3OqPC2E/CLrqBM9jPWdW8AJ7OhY24o/hWHueNdFZa6+apXAXkqmMoDpvosIIzfbf
         Fzjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053091; x=1695657891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GMzTvk0FEO6I+ReA5ceoXcLeA6ER1WjzLpFKcs1vmU4=;
        b=FdzijzIXK5UNkMqqOfMdnQTQE9bcI86LyOUzm3O586CeBv2jHYF4ie+2OXlqp71in9
         MQ+W1fm8exSxCxf2ZzRAfCWz4S3zQx8vcu/g1/tSDIZSo1FpjXiusVWc2frcNybWKQ3l
         gAyJwrMvo7QGtRiDNp+zLtDLhGRbkSgZAOtT9O/jgeshWXzrrjTZUzo6BZ/C/O6ECedJ
         TPi+WOLyZY1nVLf4KtJYzhYmgJ06e+jV/MdN/gcORJA+mABBXkJsGxrULJraRBHsAKwq
         2ByZtswE7n3g+3s2v1aQTABHDNqaJC6spw4YyWdASVvatNxORwOBZI5C25nOCBzgGAMR
         gT3A==
X-Gm-Message-State: AOJu0YzkvcN9mhiBpCwcNHrFu88KoRbhXMsxGNUViiEgZ/5hMOcJhMkH
        Pih/s+SABpGJsH93dhbEArk3jA==
X-Google-Smtp-Source: AGHT+IF2lowlwslUXKPMUOsRhTSe1sID6DU3fFY6oz4zaM9BZXy8URyT0npkn+KMnJlFujwR995gHQ==
X-Received: by 2002:a05:6512:3f8:b0:503:95d:f2bd with SMTP id n24-20020a05651203f800b00503095df2bdmr4180507lfq.34.1695053091074;
        Mon, 18 Sep 2023 09:04:51 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id i8-20020a0564020f0800b005309eb7544fsm4528407eda.45.2023.09.18.09.04.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:50 -0700 (PDT)
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
Subject: [PATCH 21/22] exec/cpu: Have cpu_exec_realize() return a boolean
Date:   Mon, 18 Sep 2023 18:02:54 +0200
Message-ID: <20230918160257.30127-22-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following the example documented since commit e3fe3988d7 ("error:
Document Error API usage rules"), have cpu_exec_realizefn()
return a boolean indicating whether an error is set or not.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h | 2 +-
 cpu.c                 | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 1e940f6bb5..3dc6968428 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -1014,7 +1014,7 @@ G_NORETURN void cpu_abort(CPUState *cpu, const char *fmt, ...)
 /* $(top_srcdir)/cpu.c */
 void cpu_class_init_props(DeviceClass *dc);
 void cpu_exec_initfn(CPUState *cpu);
-void cpu_exec_realizefn(CPUState *cpu, Error **errp);
+bool cpu_exec_realizefn(CPUState *cpu, Error **errp);
 void cpu_exec_unrealizefn(CPUState *cpu);
 
 /**
diff --git a/cpu.c b/cpu.c
index 84b03c09ac..96ae440b81 100644
--- a/cpu.c
+++ b/cpu.c
@@ -131,7 +131,7 @@ const VMStateDescription vmstate_cpu_common = {
 };
 #endif
 
-void cpu_exec_realizefn(CPUState *cpu, Error **errp)
+bool cpu_exec_realizefn(CPUState *cpu, Error **errp)
 {
     /* cache the cpu class for the hotpath */
     cpu->cc = CPU_GET_CLASS(cpu);
@@ -142,7 +142,7 @@ void cpu_exec_realizefn(CPUState *cpu, Error **errp)
     }
 
     if (!accel_cpu_realizefn(cpu, errp)) {
-        return;
+        return false;
     }
 
     /* NB: errp parameter is unused currently */
@@ -169,6 +169,8 @@ void cpu_exec_realizefn(CPUState *cpu, Error **errp)
         vmstate_register(NULL, cpu->cpu_index, cpu->cc->sysemu_ops->legacy_vmsd, cpu);
     }
 #endif /* CONFIG_USER_ONLY */
+
+    return true;
 }
 
 void cpu_exec_unrealizefn(CPUState *cpu)
-- 
2.41.0

