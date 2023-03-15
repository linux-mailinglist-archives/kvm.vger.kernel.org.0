Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2717D6BBB1E
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjCORnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjCORnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:41 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E246EB91
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:34 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id bi20so3207149wmb.2
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPBxtuZayVwd1PI4OscScs4qATQvFUKtmAmbGppJOUk=;
        b=KcGql0/7IgcNhepi+xqfK9yjRZmz5FgW9J/YDaTpHWvyj2+gAYSeWKgjY4J5d3zBmX
         Kw6PMZxgwto55OcsXxt3pmNxF99tuNdnj+mlFcjlz1/ykfFZD4PDM43HKMAd2fveavOO
         Nicuy3gBI8VN5ulVPBcEFiggGc6rpGffNJh2IiAxLFMMxTzcM23ST2eTCLrypmBgoq3W
         jRu+0eofg9MLfk0Zg0yZykm2/hxwKPVid4Sg1+A2xfEBvTn9xBA0uFgR+/w9xZWKpdBC
         x4yIqiHumPMRQeRZqrkKcReDATeqWKrAnbdi/zqgRNY0W3mGnH9uuOqszoF+yzxFr4Ok
         T/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPBxtuZayVwd1PI4OscScs4qATQvFUKtmAmbGppJOUk=;
        b=ajEn0d/hgRX5XQK6y9VCjDE7qyIOrOhyfd12SdwjILRnFmd9N9kil65Lp3BmPwSR88
         RYViXeV/hBdpGxYIhG5cg02O7qwbQu7hU0JgucPBYS6mRZB5/7+3GH76HSKUEQm4jI1U
         xdb6WA0SJcjdfKxzMCnOIFqDcVKaZmOyWB7DXXlZHyWmkDbPowZgxEZCk5ItAOWheAr7
         /wQfUoVs0QjSxkY5xI0Y4QZrX1U0+HWzLCuUJzTUupWt3D8Ji2lGmfbsbxytJy5sL/8D
         +mdjl9yYvb2B8M4D7+/Twb+FSw7/Dwv3Qua3PMT7KUMK6jjnd2FrJQbCSBtnXRSZyvkI
         yE6w==
X-Gm-Message-State: AO0yUKXO+VnB8vPdX4tN0ppPuhDN1IWFVXaYLyqQoE7oFZyr4lFd9R7S
        y2uFKZ0NUrCYYmlswlHdyeC2tg==
X-Google-Smtp-Source: AK7set/HGuw6Hz91V9TBamDPPuFeeJ0AHXcNOIRi4MIJ6rN+K+L6bT4CmSH3iapR+muMZEFgp7Gt2g==
X-Received: by 2002:a05:600c:4453:b0:3de:a525:1d05 with SMTP id v19-20020a05600c445300b003dea5251d05mr14778762wmn.8.1678902212765;
        Wed, 15 Mar 2023 10:43:32 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id e4-20020a05600c4e4400b003e8f0334db8sm2637932wmq.5.2023.03.15.10.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:32 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 53F411FFB8;
        Wed, 15 Mar 2023 17:43:31 +0000 (GMT)
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
        Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Subject: [PATCH v2 01/32] tests/avocado: update AArch64 tests to Alpine 3.17.2
Date:   Wed, 15 Mar 2023 17:43:00 +0000
Message-Id: <20230315174331.2959-2-alex.bennee@linaro.org>
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

From: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>

To test Alpine boot on SBSA-Ref target we need Alpine Linux
'standard' image as 'virt' one lacks kernel modules.

So to minimalize Avocado cache I move test to 'standard' image.

Signed-off-by: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230310103123.2118519-2-alex.bennee@linaro.org>
Message-Id: <20230302191146.1790560-1-marcin.juszkiewicz@linaro.org>
---
 tests/avocado/machine_aarch64_virt.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/avocado/machine_aarch64_virt.py b/tests/avocado/machine_aarch64_virt.py
index 25dab8dc00..a90dc6ff4b 100644
--- a/tests/avocado/machine_aarch64_virt.py
+++ b/tests/avocado/machine_aarch64_virt.py
@@ -38,11 +38,11 @@ def test_alpine_virt_tcg_gic_max(self):
         :avocado: tags=accel:tcg
         """
         iso_url = ('https://dl-cdn.alpinelinux.org/'
-                   'alpine/v3.16/releases/aarch64/'
-                   'alpine-virt-3.16.3-aarch64.iso')
+                   'alpine/v3.17/releases/aarch64/'
+                   'alpine-standard-3.17.2-aarch64.iso')
 
         # Alpine use sha256 so I recalculated this myself
-        iso_sha1 = '0683bc089486d55c91bf6607d5ecb93925769bc0'
+        iso_sha1 = '76284fcd7b41fe899b0c2375ceb8470803eea839'
         iso_path = self.fetch_asset(iso_url, asset_hash=iso_sha1)
 
         self.vm.set_console()
@@ -65,7 +65,7 @@ def test_alpine_virt_tcg_gic_max(self):
         self.vm.add_args('-object', 'rng-random,id=rng0,filename=/dev/urandom')
 
         self.vm.launch()
-        self.wait_for_console_pattern('Welcome to Alpine Linux 3.16')
+        self.wait_for_console_pattern('Welcome to Alpine Linux 3.17')
 
 
     def common_aarch64_virt(self, machine):
-- 
2.39.2

