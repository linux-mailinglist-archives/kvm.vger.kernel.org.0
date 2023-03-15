Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866EF6BBB2B
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbjCORoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjCORn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:56 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1342E6188E
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:50 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l1so18036691wry.12
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T6RLGTHhC06sRuIM9yfET4lS4kZArz0/fxEXCzYoxfU=;
        b=fAC659xuS6VIrapKxVxZijPxvTJ+M200zdixFycQ4ZQyCE4xdogcjlbnx5ylO7raI3
         Mioeq5gUp2xatTrlLObKIjRJiIZMkGK40hLku5wD95hLvWh8+yaj28gM9ventjH2lb0Y
         QboltHkPqa+zUNYNrbYNNeuyKZkfJmNq7i2BJSQIXHFqleW/XJULqIehs8MS8aQwPOxO
         zq5eWntd2e7g0ldMaXZWNx2PSK2pEMTq+XjR/9yli77fxfdhlFci6n5E/cy7yIVxUJcH
         DJQvGxC+QJtA3fqGC/CJa+HTivt+S5cx7DlcqQp7mewTUvXI3sNk/LYFVG3A3DRdobXp
         LhTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T6RLGTHhC06sRuIM9yfET4lS4kZArz0/fxEXCzYoxfU=;
        b=7Z+ucVrXC/nSRhv+Pi1DCSDCq9Y2wihDFjf72Bke8LpMRFVjptYQhWnvQ/1wo4ip5Z
         feBCVODNt6GX8HIBgcUm5zdzhFCuTBOvo4WIESdxgNJ3vDek9/XuJo7m0hCl++yJ88oJ
         /gHXccEyX8dU3NdMTItqZ2l1JI8K4ml1SFZSh81nl6g7uGVVhhuzU3pEc6iBQl1vFwJH
         ot8UPq/5op1nG7Alj+/R0EANOISzxRhIGfSR7+/XqmpL2vtbkchbLTRJr/uvT+TlVrZA
         qxTyRjExrBxmqe1H/rf/kW5E4genif6of3y8wXtVuIzcSeIz2ueHyGK+i7CByW1BadCW
         XcLA==
X-Gm-Message-State: AO0yUKUhgC8JO76RcB8WihsB8Et0/eWQfP3PLNunLTQ2vhQ5r+034KtI
        l3NKx2AbuqKQTyy1TQgFTflFzw==
X-Google-Smtp-Source: AK7set/nCJetFyvazGsKb2tomM/gH7sSBDxssaTg4H1Cyj3ggomOEZpQm0BzSLHJoICiFQQSqXit/Q==
X-Received: by 2002:a5d:50cf:0:b0:2d1:14fa:8048 with SMTP id f15-20020a5d50cf000000b002d114fa8048mr1349774wrt.39.1678902228561;
        Wed, 15 Mar 2023 10:43:48 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id e6-20020adffc46000000b002c561805a4csm5253750wrs.45.2023.03.15.10.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:47 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E53981FFCC;
        Wed, 15 Mar 2023 17:43:43 +0000 (GMT)
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
Subject: [PATCH v2 20/32] iotests: strip subdir path when listing tests
Date:   Wed, 15 Mar 2023 17:43:19 +0000
Message-Id: <20230315174331.2959-21-alex.bennee@linaro.org>
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

When asking 'check' to list individual tests by invoking it in dry run
mode, it prints the paths to the tests relative to the base of the
I/O test directory.

When asking 'check' to run an individual test, however, it mandates that
only the unqualified test name is given, without any path prefix. This
inconsistency makes it harder to ask for a list of tests and then invoke
each one.

Thus the test listing code is change to flatten the test names, by
printing only the base name, which can be directly invoked.

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Acked-by: Hanna Czenczek <hreitz@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230303160727.3977246-4-berrange@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qemu-iotests/check | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/qemu-iotests/check b/tests/qemu-iotests/check
index bb294ef556..f2e9d27dcf 100755
--- a/tests/qemu-iotests/check
+++ b/tests/qemu-iotests/check
@@ -184,7 +184,7 @@ if __name__ == '__main__':
         sys.exit(str(e))
 
     if args.dry_run:
-        print('\n'.join(tests))
+        print('\n'.join([os.path.basename(t) for t in tests]))
     else:
         with TestRunner(env, tap=args.tap,
                         color=args.color) as tr:
-- 
2.39.2

