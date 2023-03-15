Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F556BBB51
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjCORtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCORtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:35 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC5FDBEE
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l12so9797057wrm.10
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0p39ugLOaQczYK3TkGEmL7O7L8Oc7idQkhckXfJwmM=;
        b=WtwBUxM9SxKVr3qJj49Y4EjEKheacdgQwLtGuVgh/MX5QZn7UNEpsmTpIqjXhqwQQM
         HUfUDCUH7s97e3sPZGVjX9RGiSV9IbPDzNpdbvk12ij+Io+nTOkV7Oa7v0ShTrUru8ad
         nnVYIfEPCy1tRhJX8r3WXlXIhqa1vGlJyDVoRuvrCgpBlwaxbanTh6sIRbpCgoA7C+W2
         /uBh/WCLP6W/vB4s6qtZs/WR4CUCY0mq4GDq7FOon295Q1B9lKL4BS3lux4j8P6lKGrm
         vG2l9PFXbHvzn3NJNeWzQMN5u1vulVlBXwoMh8bbBfZgxjS6qbWUf8vM26FsVy9XqJwn
         ZZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0p39ugLOaQczYK3TkGEmL7O7L8Oc7idQkhckXfJwmM=;
        b=kx3PVBvtCCG7uB4JuEPcCwsOHP6/cx1XAJbTzUHX7qVeGd5UoVQuZAq4FgKwEgRuw/
         chmDwGqF86icBO8UCN+GT8XbNlW1YBaM9DINN0z/9qYokaH8HDWRNQsN1RAYVWenWCws
         LE313z338QJnOEHT1A38JDbqXvVmbkvYPGkTL3iIsx7SkfA4LmzQrf+BwCMF20jaxdBR
         jJsgVhmKe8SpVit3kvqSv/8tntNSVvIBLUOrmSzywr14iJ3CUXaAYpA+8Haknm2s5Bsn
         hIK+YJxOZ8kI8ixaLUjRs3lkdB/n8Z9um7e1Z1A4xnycRwGCSgyC4l1gXDwO/hlt3lpx
         RAiA==
X-Gm-Message-State: AO0yUKWy3mxh45sOTEx1iGUF2vaufQHfSvcZnx2nfY6cI5SY1IZXSQQs
        XfhQ85i+og4mPpCtbGU54EGvKg==
X-Google-Smtp-Source: AK7set9ImGBROXe3Myom3AQLa5weFjmBtM5MSWirx/g/R9jPWpAkGyHv1fcI0+Lfs66r1OP7NqOZPA==
X-Received: by 2002:adf:fc4d:0:b0:2cf:ec0b:7d28 with SMTP id e13-20020adffc4d000000b002cfec0b7d28mr2401223wrs.32.1678902559869;
        Wed, 15 Mar 2023 10:49:19 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id x8-20020a5d60c8000000b002cea8664304sm5173443wrt.91.2023.03.15.10.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:19 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 562151FFD6;
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
        Vikram Garhwal <vikram.garhwal@amd.com>,
        Stefano Stabellini <stefano.stabellini@amd.com>,
        Sai Pavan Boddu <sai.pavan.boddu@xilinx.com>,
        Tong Ho <tong.ho@xilinx.com>,
        Francisco Iglesias <francisco.iglesias@amd.com>
Subject: [PATCH v2 32/32] contrib/gitdm: add group map for AMD
Date:   Wed, 15 Mar 2023 17:43:31 +0000
Message-Id: <20230315174331.2959-33-alex.bennee@linaro.org>
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

AMD recently acquired Xilinx and contributors have been transitioning
their emails across.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Vikram Garhwal <vikram.garhwal@amd.com>
Cc: Stefano Stabellini <stefano.stabellini@amd.com>
Cc: Sai Pavan Boddu <sai.pavan.boddu@xilinx.com>
Cc: Tong Ho <tong.ho@xilinx.com>
Reviewed-by: Francisco Iglesias <francisco.iglesias@amd.com>
Message-Id: <20230310180332.2274827-11-alex.bennee@linaro.org>
---
 contrib/gitdm/domain-map    | 1 -
 contrib/gitdm/group-map-amd | 8 ++++++++
 gitdm.config                | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)
 create mode 100644 contrib/gitdm/group-map-amd

diff --git a/contrib/gitdm/domain-map b/contrib/gitdm/domain-map
index fa9cb5430f..f78c69fa54 100644
--- a/contrib/gitdm/domain-map
+++ b/contrib/gitdm/domain-map
@@ -49,6 +49,5 @@ virtuozzo.com   Virtuozzo
 vrull.eu        VRULL
 wdc.com         Western Digital
 windriver.com   Wind River
-xilinx.com      Xilinx
 yadro.com       YADRO
 yandex-team.ru  Yandex
diff --git a/contrib/gitdm/group-map-amd b/contrib/gitdm/group-map-amd
new file mode 100644
index 0000000000..bda4239a8a
--- /dev/null
+++ b/contrib/gitdm/group-map-amd
@@ -0,0 +1,8 @@
+# AMD acquired Xilinx and contributors have been slowly updating emails
+
+edgar.iglesias@xilinx.com
+fnu.vikram@xilinx.com
+francisco.iglesias@xilinx.com
+sai.pavan.boddu@xilinx.com
+stefano.stabellini@xilinx.com
+tong.ho@xilinx.com
diff --git a/gitdm.config b/gitdm.config
index df4ba829ca..9db43ca142 100644
--- a/gitdm.config
+++ b/gitdm.config
@@ -32,6 +32,7 @@ EmailMap contrib/gitdm/domain-map
 #
 
 GroupMap contrib/gitdm/group-map-alibaba Alibaba
+GroupMap contrib/gitdm/group-map-amd AMD
 GroupMap contrib/gitdm/group-map-cadence Cadence Design Systems
 GroupMap contrib/gitdm/group-map-codeweavers CodeWeavers
 GroupMap contrib/gitdm/group-map-facebook Facebook
-- 
2.39.2

