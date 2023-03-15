Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74E16BBB55
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjCORtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjCORth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:37 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370E518179
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:23 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id p13-20020a05600c358d00b003ed346d4522so1599546wmq.2
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/pYU24xJraNXcb1pbvZQddkU2/+s0yp2C0zt4F7Fw+M=;
        b=FSv6GKaGQ/Kg3MxbXl59YCA8mVzMfrPGvVsm4nnIGIsCz1P8QvHqwpjDDnvTJBXB9O
         3kRrkTXtc7YOX33Uuzn5g0XKvIVaOudBYldQZWbFGR0Grzqz788BoPKHHSjeWa5M4IUl
         k+tcalcuHzdUNTiXOA5J3gwEgxZUuzzf/9MhXCikK1fzOimj0etlFejn5B9tBGo4Bkby
         Fxtz9PrndjbtxaO+eer3KBZV6bNiHAYfpUXSwdLARgrESAxdtazJYQ/6bCd/b/fcdlH3
         QgfUDWGcKLT3S/Mhk9T+jIyBUbeX1+ABnElzy1YLLv8FQVDeotrpfUcxCMl0L1z2WUOg
         0fRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/pYU24xJraNXcb1pbvZQddkU2/+s0yp2C0zt4F7Fw+M=;
        b=Br1ueBm+m4RsfFrk4Xm1wE8HBwoYYG+N9+4/IQGg5fxPnBKsJXf4y9sC1wR5fWDwyN
         05mi1Bow4jpoZodp9JIOcMmgI0V/Tfnkuem2+EYvIkzCNTXVbI7UIfcOaVWVTY4qLcFO
         qJD1796xXHiN6MYmrHIeL4tvQti5F1zxAYTTVPo0tR0K6Eil5HjaJb29j23r7Si5UqnM
         rHk/fHxTGnSXR6T8NbAf/gy/cidLP/OJQYMxGTa11pjmoborwRsA60uaiMi6pEqkHlus
         DlLCrZw/x8X+5wan+nyf8rf6XuV5d+olPBRBXITfSxxOJCsEDwTlJdVAeGCRu5QElb1s
         kO7Q==
X-Gm-Message-State: AO0yUKVk8rYwvIB4gFGXJWpwKyeqUq4jG3LjlIuClYQTQsbV6Y2WEq9T
        OV0kGsxCkONMG5+NCnx5t2uggw==
X-Google-Smtp-Source: AK7set/P7GdvZPP0Ks+DTuZCG+am6sOYfepTrv4tHn1Vl4U7f6IVQxmhVEBlwq7KYmLJFLG6p+5MvQ==
X-Received: by 2002:a05:600c:4751:b0:3ea:f73e:9d8a with SMTP id w17-20020a05600c475100b003eaf73e9d8amr19673720wmo.30.1678902561668;
        Wed, 15 Mar 2023 10:49:21 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id r6-20020a05600c458600b003ebff290a52sm2868114wmo.28.2023.03.15.10.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:20 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 36CF21FFD5;
        Wed, 15 Mar 2023 17:43:45 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Bernhard Beschow <shentey@gmail.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Bin Meng <bmeng@tinylab.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2 31/32] contrib/gitdm: add more individual contributors
Date:   Wed, 15 Mar 2023 17:43:30 +0000
Message-Id: <20230315174331.2959-32-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315174331.2959-1-alex.bennee@linaro.org>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've only added the names explicitly acked.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Bernhard Beschow <shentey@gmail.com>
Cc: Amarjargal Gundjalam <amarjargal16@gmail.com>
Cc: Bin Meng <bmeng@tinylab.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Strahinja Jankovic <strahinja.p.jankovic@gmail.com>
Acked-by: Bernhard Beschow <shentey@gmail.com>
Message-Id: <20230310180332.2274827-10-alex.bennee@linaro.org>
---
 contrib/gitdm/group-map-individuals | 1 +
 1 file changed, 1 insertion(+)

diff --git a/contrib/gitdm/group-map-individuals b/contrib/gitdm/group-map-individuals
index e2263a5ee3..3264c7383d 100644
--- a/contrib/gitdm/group-map-individuals
+++ b/contrib/gitdm/group-map-individuals
@@ -38,3 +38,4 @@ paul@nowt.org
 git@xen0n.name
 simon@simonsafar.com
 research_trasio@irq.a4lg.com
+shentey@gmail.com
-- 
2.39.2

