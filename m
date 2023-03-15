Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A6A6BBB94
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjCOR71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjCOR7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:59:24 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECF83586
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:59:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id m2so5321120wrh.6
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678903160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1+Gk3L/rczHKMe28JnxrdRGaPdgdS8ubf+6dS/l9u58=;
        b=hkPzoFNd99iXpoYx6FG+w8nHFEN4RMLQo3Cd/YQCkEhmc5tjF3J+qrGi8dzEDcxIRg
         xxSJt0lMjuB2FnpMF4IRwlqejNRQ4im4R0KTFu+zydbLqjRV10JGlEP//pmLLZ7+dUdY
         xBgrA25jFkMRoWb1XEyd2EbRdGppNk55CbTUqPsh+raPcGsFUZ6tGSMX9A7b+uuY1YQj
         Wuw8OpdLzuVXmEWAysxCQfduSbyt+3dWInpwxtxSxSdIIIoyfHGHHjJ+0SqyJbF3ZTUE
         Qyhu0ciL78Zc2i8Cgkfo5RwJ15AW9YRTAkkpPIdQ4xHqT94hQhOXa4r4u0BpGw7wTOAe
         sWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678903160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1+Gk3L/rczHKMe28JnxrdRGaPdgdS8ubf+6dS/l9u58=;
        b=mhfq63MYWJVRIvCj9XEPCSlHSh3ixpUj4LSC/iUOmdLJHXwI8q6m6jFbr4X+IxjgQD
         9c7gmFmOc0aXS5GVH7EvoNi/d0+UWfFmDvScB0TPOO+x4u6+DUTUv576ABS0rYTQRwYc
         s+GtXxLNVm44caOJAa6i3zLuGnGlSlbFZQ6YgPiVEv5WFlUaxN/0h3vnEExCisszCQkS
         HqO/wkFtytDZpFpyvgjTzqapk2yjQjMZJdWIfNzDAOR25Lf/pDtMkdRwd26Po3UD3pmZ
         fUYCD8ct3A9vCdZu7NDz1M40F6tyee+vHAzXVbLbKY2QmbwF52xk7ubxJMbsmaL+cM5j
         eqBg==
X-Gm-Message-State: AO0yUKX/PC8FMSnN1jVHqCfPu/BMLoKQnG4Gidgv62vnvYx6la4vwTHS
        /+c6t6twwW8oOrtbz7OWPSyu6w==
X-Google-Smtp-Source: AK7set/zrsufmF8RrZGctv1IvMNdQDZqzbPhQicK04ZcvAUgxke5K+K8UyrmrWcXrGXLhhtv3q8bHw==
X-Received: by 2002:a5d:4586:0:b0:2cf:e65a:a5fc with SMTP id p6-20020a5d4586000000b002cfe65aa5fcmr2674157wrq.8.1678903160472;
        Wed, 15 Mar 2023 10:59:20 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id x1-20020a5d60c1000000b002cfe63ded49sm5215148wrt.26.2023.03.15.10.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:59:20 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B70CA1FFD1;
        Wed, 15 Mar 2023 17:43:44 +0000 (GMT)
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
        Milica Lazarevic <milica.lazarevic@syrmia.com>
Subject: [PATCH v2 27/32] contrib/gitdm: Add SYRMIA to the domain map
Date:   Wed, 15 Mar 2023 17:43:26 +0000
Message-Id: <20230315174331.2959-28-alex.bennee@linaro.org>
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

The company website lists QEMU amongst the things they work on so I
assume these are corporate contributions.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Milica Lazarevic <milica.lazarevic@syrmia.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230310180332.2274827-6-alex.bennee@linaro.org>
---
 contrib/gitdm/domain-map | 1 +
 1 file changed, 1 insertion(+)

diff --git a/contrib/gitdm/domain-map b/contrib/gitdm/domain-map
index 65e40fe8e1..4a988c5b5f 100644
--- a/contrib/gitdm/domain-map
+++ b/contrib/gitdm/domain-map
@@ -39,6 +39,7 @@ siemens.com     Siemens
 sifive.com      SiFive
 suse.com        SUSE
 suse.de         SUSE
+syrmia.com      SYRMIA
 ventanamicro.com Ventana Micro Systems
 virtuozzo.com   Virtuozzo
 vrull.eu        VRULL
-- 
2.39.2

