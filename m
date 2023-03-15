Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93F66BBB57
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjCORtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjCORti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:38 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2D412CEA
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:22 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p13-20020a05600c358d00b003ed346d4522so1599529wmq.2
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmiQu8mdrNxNFQhkZw0dMyYO7f3kURdPYmnUakKXAyA=;
        b=QxREuuwpdR15RN5JNit0xAyeDMNaCwDEIqGbqscfA9c3UMUJLDCUDtiTakVi9cvFU9
         aGtaNmcnergtPFuoykuf19BTHGmBIUSK5omOrtfcnvm5whLWBC4Qing/g/RCg3Mz+gKO
         RQSnbsQ4EeNwNEC1mXukX45B6c5mlFfa7EQW1EbSuocQGtM+qZAluf5+IDh/eLNaWuhM
         vEsqkbXHFXS9qILKMuFLJMsGGTOfVaw9oaj0g1mptuvY3sOY4YIXD48p4/BlYNznmaPw
         pV3iIYWcOmw1PZGvQ/2e98XgVpV4FZ+iI7Jlbpm1fHyDRLocOa/4OmTEfu+K1DqoQhwL
         70Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QmiQu8mdrNxNFQhkZw0dMyYO7f3kURdPYmnUakKXAyA=;
        b=rJGMo6YRQ+ppNRShrmrUTet0PBBiasG83R+VQd9znsi4SQGpQEZNgAYRMYTaBJuMkC
         CQXEpjRsb1hQnR/jqVjCcOrXLtHbJV54Z0KZ+KdrN3GhB8IU7Y9pEcgccvgxNA8bwAof
         MXySkXDuxfNlR2IggZRg5LEFKOQ91hFkh+0xcpBb3qKqNogm6ROp3iPFzwa/jy8foDG+
         48ky79aYkvMz1A8TlZRCZYmjy7SeDxlQdv8Svua6CjpfXjw/5Mkm3b1Kd2qUvoxfqPJY
         Lldki9Tc5d/CrLo2dDexS770OOZpQ8SbnOjTW6K7CM1aU+Rsf1/5gw6TmPNVjtClxxrT
         KWxQ==
X-Gm-Message-State: AO0yUKV6bUdFJK3a57RnM4kDu0eNeUG2KlFSq7kPTsuTr3t93ZN0i2tM
        KfA9+oRzDnVoTOlFQjny65+HHg==
X-Google-Smtp-Source: AK7set9mhg7pMWhlmLatyhhIVpIKdwTmTGQRYQ0Z15qTkXGp9B265GROjYVJvdWLpQgKJBWjsBqT+Q==
X-Received: by 2002:a05:600c:5102:b0:3ed:26d1:825f with SMTP id o2-20020a05600c510200b003ed26d1825fmr9307899wms.16.1678902561402;
        Wed, 15 Mar 2023 10:49:21 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id e10-20020adffc4a000000b002cfed482e9asm4453518wrs.61.2023.03.15.10.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:20 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 199A31FFD4;
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
        Anton Johansson <anjo@rev.ng>,
        =?UTF-8?q?Niccol=C3=B2=20Izzo?= <nizzo@rev.ng>,
        Paolo Montesel <babush@rev.ng>,
        Alessandro Di Federico <ale@rev.ng>
Subject: [PATCH v2 30/32] contrib/gitdm: add revng to domain map
Date:   Wed, 15 Mar 2023 17:43:29 +0000
Message-Id: <20230315174331.2959-31-alex.bennee@linaro.org>
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

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Anton Johansson <anjo@rev.ng>
Cc: Niccolò Izzo <nizzo@rev.ng>
Cc: Paolo Montesel <babush@rev.ng>
Reviewed-by: Alessandro Di Federico <ale@rev.ng>
Message-Id: <20230310180332.2274827-9-alex.bennee@linaro.org>
---
 contrib/gitdm/domain-map | 1 +
 1 file changed, 1 insertion(+)

diff --git a/contrib/gitdm/domain-map b/contrib/gitdm/domain-map
index 0b6c77eee0..fa9cb5430f 100644
--- a/contrib/gitdm/domain-map
+++ b/contrib/gitdm/domain-map
@@ -36,6 +36,7 @@ oracle.com      Oracle
 proxmox.com     Proxmox
 quicinc.com     Qualcomm Innovation Center
 redhat.com      Red Hat
+rev.ng          revng
 rt-rk.com       RT-RK
 samsung.com     Samsung
 siemens.com     Siemens
-- 
2.39.2

