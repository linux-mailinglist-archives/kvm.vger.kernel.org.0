Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0146F6BBB5B
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjCORtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjCORti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:38 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A21241F4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:24 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so1831152wmq.1
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJUdD1KDNN10uHV14kT9b5pVemIcBVsEPAiKGCkA3/I=;
        b=ZiJwizY+BEQyfg+Q/JLMGsdkQBe18LLAHEYUWqsiE2UzVpoafO6VnoUkgfIPF1UF2C
         AvHMfi1Zr4Gw+gU/glYhKQrPHig6ofDlVVSvHAknUmPOMV+KsOyu1ap5MFw86PoVzZFW
         hRlf689u9iXJwNoLzIh4+flVAro/FQfytj2H61FRa0BWvwNGSYnYylvMS/e2dsBa+uYf
         CdquL8gPnq9mTBiAINiXTynie2t6fwHS67wIcfJ6ZsSjj/Y/hgKw8TjhzQ5V3bDGJo3p
         peJrW+oyDPqBXVDrJXAHlvdp3/ngS+p7onB5PHuDMel60FN8u/BKxfjngHNycMIUH5CZ
         5NFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CJUdD1KDNN10uHV14kT9b5pVemIcBVsEPAiKGCkA3/I=;
        b=L7viVrfzhZqdkn4QZgdNBgrtwjwlkllm1nWNkY3+oDdvwVdzEaAfSnoZE3j7nHfOyp
         nD2RRYjAqcHdxAhGwlckI826aWn71y4RF0iDFA34cOcp/SVfyQA5IAxaC6C7piBml+Ye
         cKV7cNPeztYENnXE84KC5c3VLiX/mqYzXgzIjJ7mYfAx/irSKlvO/YfLMeiAgdzfLqej
         M0/ibyBt4tTS92qF7NxwVR+sgFJz7meotpglW8kbTnhjdTfRcM71iTUGvBn3bMxLGHXV
         r00GWtmp3dcm7TzaWwTnJ6sXBQ6cyZ4ggP67ObyfjQhNUCpfaRiTscvOFB60KCiTVH3M
         wR1w==
X-Gm-Message-State: AO0yUKXG+aQq45tzJ2q3ClUTwM7ncrb1fLAGNC9k9x+ww6h67xU3aFI+
        5vQDL7YnGNO1FwA1PWSz0bwMfg==
X-Google-Smtp-Source: AK7set/SqHuK6PEIsW6F6a7dde4PpYY9pyyZZEy/OPTtCssSDeS8nLFAk0KOyc38M7fngm1jtMAPMQ==
X-Received: by 2002:a05:600c:4452:b0:3ed:2709:2edf with SMTP id v18-20020a05600c445200b003ed27092edfmr10925367wmn.13.1678902563350;
        Wed, 15 Mar 2023 10:49:23 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p18-20020adfe612000000b002c3f9404c45sm5219633wrm.7.2023.03.15.10.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:22 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id F30251FFD3;
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
        Guo Ren <guoren@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH v2 29/32] contrib/gitdm: add Alibaba to the domain-map
Date:   Wed, 15 Mar 2023 17:43:28 +0000
Message-Id: <20230315174331.2959-30-alex.bennee@linaro.org>
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

This replaces the previous attempt to add c-sky.com. Group everything
under Alibaba now.

Added as requested by LIU Zhiwei.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Acked-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: LIU Zhiwei <zhiwei_liu@linux.alibaba.com>
Message-Id: <20230310180332.2274827-8-alex.bennee@linaro.org>
---
 contrib/gitdm/domain-map        | 1 +
 contrib/gitdm/group-map-alibaba | 7 +++++++
 gitdm.config                    | 1 +
 3 files changed, 9 insertions(+)
 create mode 100644 contrib/gitdm/group-map-alibaba

diff --git a/contrib/gitdm/domain-map b/contrib/gitdm/domain-map
index 8dce276a1c..0b6c77eee0 100644
--- a/contrib/gitdm/domain-map
+++ b/contrib/gitdm/domain-map
@@ -4,6 +4,7 @@
 # This maps email domains to nice easy to read company names
 #
 
+linux.alibaba.com Alibaba
 amazon.com      Amazon
 amazon.co.uk    Amazon
 amd.com         AMD
diff --git a/contrib/gitdm/group-map-alibaba b/contrib/gitdm/group-map-alibaba
new file mode 100644
index 0000000000..0ebbe6b06e
--- /dev/null
+++ b/contrib/gitdm/group-map-alibaba
@@ -0,0 +1,7 @@
+#
+# Alibaba contributors including its subsidiaries 
+#
+
+# c-sky.com, now part of T-Head, wholly-owned entity of Alibaba Group
+ren_guo@c-sky.com
+zhiwei_liu@c-sky.com
diff --git a/gitdm.config b/gitdm.config
index 907ffde017..df4ba829ca 100644
--- a/gitdm.config
+++ b/gitdm.config
@@ -31,6 +31,7 @@ EmailMap contrib/gitdm/domain-map
 # identifiable corporate emails. Please keep this list sorted.
 #
 
+GroupMap contrib/gitdm/group-map-alibaba Alibaba
 GroupMap contrib/gitdm/group-map-cadence Cadence Design Systems
 GroupMap contrib/gitdm/group-map-codeweavers CodeWeavers
 GroupMap contrib/gitdm/group-map-facebook Facebook
-- 
2.39.2

