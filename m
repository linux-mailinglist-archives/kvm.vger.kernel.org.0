Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3CB6BBB2C
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbjCORoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjCORnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:55 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70316F629
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:49 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m35so3571504wms.4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yN/kmP3UzMt/cUifiAR045QSMUEZthdjOX5czXccge4=;
        b=MntRw3lNrCOMEFZIS1dZ1813x3vJDF1WzRC21hMt60g8mZz+fLhlUSzAhtLkn3k4Ze
         yM/vtKHnDC9htC8OB6T4wN0Rpj+yXIh4eEJnL9TSlekacLZidKLbDkzhDRIyGDQ+sRcF
         LlHkgwvc+i0RYO5L8EtXFr8ehGJLuG3yeB8DNoYQJI5UrZsebC7RLx3l9YPGfF5lmFiu
         HY6doygFty2WcMjZmHv7nKZeo/YtCceCz/kXamcmF0MzKfnwuvbRreflYJ/k/jexm1Ji
         VvD6qMx3BPKvhpljANB7/WapKxL8D0Snzawjq/4Ty9Oq7ir0s6ZgeHA/bbtY8d78+a+e
         +ZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yN/kmP3UzMt/cUifiAR045QSMUEZthdjOX5czXccge4=;
        b=P0rMzpSV8/H6n5GD8HX8OJdMZdrUfPe8jb2HdHV20c9EE5e64L0yIAeBx0540UFHM+
         26X0rWBljn+PRyC2V6WhkHe2fTvNWjdnTtb4c8qpuiVPUrgi8Y05LKacxTLd/6/ERjdG
         fxeu/2FFdPr9j3Ehjll9bUs7ywQabjzj82xThBloKUjZRCvJNh/vfKP0P69D82DE8an+
         E6bdPIb6mK3X4G18v7M+5qn7k4ZP4UPZJDQ6LEH+qYmTF4fSoCoGmbkeqfAYlkM40GUT
         oVH6ycJggRHNkGDSULIw/6EVOjsKX61WPynOJrX9wnG48sPcRoCWQXlokWEuUptmSmT5
         Y42g==
X-Gm-Message-State: AO0yUKUNXklpN/ijD+8ksWcdixjl9B/wVcGfzTTeenEGl4am3mbhvPwI
        r5SIiT6RnaoskxWAQuebOHzAxg==
X-Google-Smtp-Source: AK7set9esCrwmxWtpjhIpHb9F9AjwhmW/LnMk7PpVO78vlhI0oVx/btBNZR1xTzxYFNXMqmeyTMYDg==
X-Received: by 2002:a05:600c:1546:b0:3ed:22f2:554c with SMTP id f6-20020a05600c154600b003ed22f2554cmr11406696wmg.29.1678902229234;
        Wed, 15 Mar 2023 10:43:49 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id l4-20020a1c7904000000b003ed1ff06faasm2469232wme.19.2023.03.15.10.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:47 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 0C44A1FFCD;
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
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2 21/32] iotests: print TAP protocol version when reporting tests
Date:   Wed, 15 Mar 2023 17:43:20 +0000
Message-Id: <20230315174331.2959-22-alex.bennee@linaro.org>
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

From: Daniel P. Berrangé <berrange@redhat.com>

Recently meson started complaining that TAP test reports don't include
the TAP protocol version. While this warning is bogus and has since been
removed from Meson, it looks like good practice to include this header
going forward. The GLib library test harness has started unconditionally
printing the version, so this brings the I/O tests into line.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Acked-by: Hanna Czenczek <hreitz@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230303160727.3977246-5-berrange@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qemu-iotests/testrunner.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qemu-iotests/testrunner.py b/tests/qemu-iotests/testrunner.py
index 5a771da86e..e734800b3d 100644
--- a/tests/qemu-iotests/testrunner.py
+++ b/tests/qemu-iotests/testrunner.py
@@ -391,6 +391,7 @@ def run_tests(self, tests: List[str], jobs: int = 1) -> bool:
         casenotrun = []
 
         if self.tap:
+            print('TAP version 13')
             self.env.print_env('# ')
             print('1..%d' % len(tests))
         else:
-- 
2.39.2

