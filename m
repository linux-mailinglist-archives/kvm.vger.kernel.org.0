Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC02B6BBB61
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbjCORuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbjCORtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:40 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B590C64E
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:22 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id y14so5405809wrq.4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25098w81ZdJk4QE1ACGYU4dK9BpaVvc0WWo+YnpOAf4=;
        b=QN3whXVxLzdtGE51UGwAD23ywKq58FRXPycm/Vc9nh5PPS1Uo13fp3QYfWIulzq4kv
         iib1JLnABOibWaoZ1Uav2ko4+0gFvDfbeVazxOdZCsd1BY1SZdIm/hpsbkIf7VqmczgT
         kWW/jaoHTSRuo4U6NXZ+8t5k+GB5PIW5IJVbVA0GiW0WAoFOSuL+0i4kUsdMsDGqaFsv
         1E6GxNZYvwuc4CyNdkY99R14kDit97mGGDfVpngCHD1PPhrDrqUCbeqCY8dZGsn2ZigU
         +n827P4xyDA58e3za28F5JhcV3e5EL0nZD6tfz9PLkySG22kozH/+dJ0ciruSBl5dY18
         sxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=25098w81ZdJk4QE1ACGYU4dK9BpaVvc0WWo+YnpOAf4=;
        b=xHM9sxrBjbKOGawuHU9Gb1LQBe9GyPFSQAqQIblr56o0Cpg7JfRxme/Rp5E1U9gT77
         DYOa+DZW3osqnfcaMOyeqTK9E+OeJmUYAWxoJsA7nLf8LAlW40Gew2h5stVIEeR/Sm/C
         NC87gDx5/2ngiTOESsq5MT4pjgEV3vHarzK6Jq3locN4nNZUaHu5jkCaIqeCUZ5ziFpS
         ItNFPM0DVRKoOKDAiAlwPjinOXyPubU17JKJ3X4wBawuSOs14uwjIcHda42sXVeoek43
         viEKFb2fPVcR3QU1Tb6OmZlklb30Uyx7b1D6D/2DCtCDu40g58m3fCmgkQSVcNfVx0iM
         /Bqg==
X-Gm-Message-State: AO0yUKXe7QkwOmBAs8pvIf4kTQTnWjyShW2jSK6KEfWK1MQy6fr1kn3+
        Mv6gCKDNxzBKPbqeVac/OsGOhA==
X-Google-Smtp-Source: AK7set+zKLqQw1FieiYvterxdkE8mVIrpMUd2TN7Lke7O9MNzTVTzlt4lti0owlJLuWJs402ZKDmIA==
X-Received: by 2002:a05:6000:1b86:b0:2c5:594f:121d with SMTP id r6-20020a0560001b8600b002c5594f121dmr2723624wru.12.1678902560646;
        Wed, 15 Mar 2023 10:49:20 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p13-20020a056000018d00b002cea974e759sm4992230wrx.88.2023.03.15.10.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:19 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9B5881FFBE;
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
        Steven Lee <steven_lee@aspeedtech.com>,
        Troy Lee <troy_lee@aspeedtech.com>,
        Howard Chiu <howard_chiu@aspeedtech.com>,
        Jamin Lin <jamin_lin@aspeedtech.com>
Subject: [PATCH v2 26/32] contrib/gitdm: Add ASPEED Technology to the domain map
Date:   Wed, 15 Mar 2023 17:43:25 +0000
Message-Id: <20230315174331.2959-27-alex.bennee@linaro.org>
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

We have a number of contributors from this domain which is a corporate
endeavour.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Steven Lee <steven_lee@aspeedtech.com>
Cc: Troy Lee <troy_lee@aspeedtech.com>
Cc: Howard Chiu <howard_chiu@aspeedtech.com>
Cc: Jamin Lin <jamin_lin@aspeedtech.com>
Reviewed-by: Troy Lee <troy_lee@aspeedtech.com>
Message-Id: <20230310180332.2274827-4-alex.bennee@linaro.org>
---
 contrib/gitdm/domain-map | 1 +
 1 file changed, 1 insertion(+)

diff --git a/contrib/gitdm/domain-map b/contrib/gitdm/domain-map
index 8913a886c9..65e40fe8e1 100644
--- a/contrib/gitdm/domain-map
+++ b/contrib/gitdm/domain-map
@@ -5,6 +5,7 @@
 #
 
 amd.com         AMD
+aspeedtech.com  ASPEED Technology Inc.
 baidu.com       Baidu
 bytedance.com   ByteDance
 cmss.chinamobile.com China Mobile
-- 
2.39.2

