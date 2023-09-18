Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E51E7A4F73
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjIRQmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjIRQmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:42:24 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B280A2D69
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-51e28cac164so12373095a12.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053021; x=1695657821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSCS2zUfZAE6ogrinmDPrOXdED/BfB+BaLaX0u0zcLg=;
        b=DrsWzepJBQKFVAtKapF2DbXUL7A+GJxmCStgp/qH2o5iu+8icPa6iZk1+xQIGgqFrc
         hpIfaNb7PIN0g3GYs/XMTF/aVOtHieYKIM/EPFg+G0wpd1I6OOc34aYok/LANaNCOl90
         wQAYPMBNnYbvlFPhq04fpR+tFmAMVc4Wo5VOSuSJXk7926X0bmO52JmhNju17yiRKicC
         J4n0Rm2TClt1SiWGcQT8+NGFIScdEbSXkDyNVkpHg5uaFkZ6VdzH1sOaDSDzAKkH35ZA
         OYUiUR1DDKc3fbqVKwz0EwBgBX7O+aV26FDjAYtiQ2es6/ct+4H2TTqApA7iyzcd94ae
         kAxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053021; x=1695657821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fSCS2zUfZAE6ogrinmDPrOXdED/BfB+BaLaX0u0zcLg=;
        b=xH4zSRtMaflNV0JYCSzwD4D8YSGgh2985Sg16jDXKo8B9kJiOqb8iFgKnx7Oi/nqgI
         A9ht2yFO1i8wrMElKqiBAA/EGVCsP19gDuAnprXsJamIQnW50akIuSLjNhI2HIMz9mxl
         B9YcBLcgZSJTcnImKqDuENKWJjFCzMMP2PZ8nvcyEjmKFUVDLQWWeRyFp/oA63K1l44u
         K1ePxuZRe4BJpu/N13tSb9yq+wS4P+KXZPDVCfvICs/V3Z1tmpWByblE5q0psXU4ogay
         CFZLajqBVhknyL3ikkKQ1r250Peb3kZUP3iiP4Bpt8yWwkPrBZ8tu3hgQpqXXAFAdaYC
         WZ/w==
X-Gm-Message-State: AOJu0YylvlSbdtVgH7tNKtvFzyXN4ffJTgtG/S6WMD634KGe2bHabGGx
        p3RmCsZsP7E9kfD70pG+9M/tow==
X-Google-Smtp-Source: AGHT+IFbTianQZOGFuSjVlX566F74BXdJs5acopl7EmpAQkaG51ohmS+uPCdYH5B96NaIiVcrKe7YA==
X-Received: by 2002:a17:907:62a6:b0:9ad:cbc0:9f47 with SMTP id nd38-20020a17090762a600b009adcbc09f47mr116109ejc.12.1695053021006;
        Mon, 18 Sep 2023 09:03:41 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id ck9-20020a0564021c0900b005231e3d89efsm2684962edb.31.2023.09.18.09.03.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:40 -0700 (PDT)
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
Subject: [PATCH 08/22] exec/cpu: RFC Destroy vCPU address spaces in cpu_common_unrealize()
Date:   Mon, 18 Sep 2023 18:02:41 +0200
Message-ID: <20230918160257.30127-9-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We create at least one vCPU address space by default in
qemu_init_vcpu(), itself called in cpu_common_realizefn().
Since we don't have qemu_deinit_vcpu() helper (we probably
don't need any), simply destroy all the address spaces in
cpu_common_unrealizefn(), *after* the thread is destroyed.

Note: all targets were leaking the vCPU address spaces upon
vCPU unrealize (like hot-unplugged actions).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/core/cpu-common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index e5841c59df..35c0cc4dad 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -224,6 +224,11 @@ static void cpu_common_unrealizefn(DeviceState *dev)
 
     /* Destroy vCPU thread */
     cpu_remove_sync(cpu);
+
+    /* Destroy CPU address space */
+    for (unsigned idx = 0; idx < cpu->num_ases; idx++) {
+        cpu_address_space_destroy(cpu, idx);
+    }
 }
 
 static void cpu_common_initfn(Object *obj)
-- 
2.41.0

