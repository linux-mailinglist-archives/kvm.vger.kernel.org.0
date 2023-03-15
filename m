Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D26BBB1D
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjCORnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjCORnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:42 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2626588D93
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:35 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o7so8676836wrg.5
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9R+WJAtyA8SeJ/1as6Ou9Go9GUXAmG0Tw994EVyLcw=;
        b=ZhgBQUWyxDhfXpmiHE0qRJgUZoPsqcJNfS562fDJLhlpne/3qqTUMowB/RqfnxCDV9
         OpqoaVD2EBKJXMRVDbCjo4ulwDbCQokWJLYVm/dAp961A74gTdezvO5F1R13phhCECrG
         49E+uaQqfR/RQIJNvWwyAqraPCQZVMhQZnSO9B0kDtVhhBWO7gA85O0Vft/pzzYRTBh2
         76m2r1ATby/XIdrQ+hDgqEGM+XKHdpMDvrjefHNAmAwqiKn8h8rP6iax0Kp2b/ry8hTg
         EMEHxNXuzNgfNZhazljSnz2gayYU4Kkd8/4TIkpyemgIY4rMMyDJ6rgXuH2jEkdgBrAV
         Kvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9R+WJAtyA8SeJ/1as6Ou9Go9GUXAmG0Tw994EVyLcw=;
        b=27wwhZBreX9DOqz//WTqvvp+/1gFj7DXkAkOCxrjNFfofswdDnuOCjkP+Su8sWMP6H
         7a8wEjoi0ZW/7dT5A2XlJT3uSxObYeFGcWQsxyVWCq7uQt1b8WSWHNUC0+bqPMzjMOE9
         9ceef0VJVNoz+IjHmjteSJjcF9K4rtzIsGBmHM5T86h03enD0K45sqDvrSwse0zaPeUp
         YfmhqBsN7kntdffqW9qv07OUTfbH0TVcu0iJagsAXxCgVp5wJxMWA7d85rdv+h+L2l4Q
         aT5wCku7JmNihsZPlnqfcsid+W2gfWc7lqcMW+M77pTjHm2/+Uuq0zNEh6lguaJsAZ++
         fqJQ==
X-Gm-Message-State: AO0yUKV+TCb6WMJB+iBneYfoV4DImC3tYU/4QWT/DER9fG34nArdANk2
        zGEUmj9HyL5VJNNKI33WVz4zhA==
X-Google-Smtp-Source: AK7set8Dhi27SZ1Yod4B/3p18OZTi50hw0TASccWTVO+VGxSbh7e9Zrr93tKTrOVclPFrXdp9BCQ8A==
X-Received: by 2002:a5d:4247:0:b0:2ce:ae57:71db with SMTP id s7-20020a5d4247000000b002ceae5771dbmr2165726wrr.33.1678902213439;
        Wed, 15 Mar 2023 10:43:33 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id o13-20020a5d4a8d000000b002c5534db60bsm5185782wrq.71.2023.03.15.10.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:32 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 714F61FFBA;
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
        Fabiano Rosas <farosas@suse.de>
Subject: [PATCH v2 02/32] tests/docker: all add DOCKER_BUILDKIT to RUNC environment
Date:   Wed, 15 Mar 2023 17:43:01 +0000
Message-Id: <20230315174331.2959-3-alex.bennee@linaro.org>
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

It seems we also need to pass DOCKER_BUILDKIT as an argument to docker
itself to get the full benefit of caching.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Suggested-by: Fabiano Rosas <farosas@suse.de>
---
 tests/docker/Makefile.include | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/docker/Makefile.include b/tests/docker/Makefile.include
index 54ed77f671..9401525325 100644
--- a/tests/docker/Makefile.include
+++ b/tests/docker/Makefile.include
@@ -39,7 +39,7 @@ docker-qemu-src: $(DOCKER_SRC_COPY)
 # General rule for building docker images.
 docker-image-%: $(DOCKER_FILES_DIR)/%.docker
 	  $(call quiet-command,			\
-		$(RUNC) build				\
+		DOCKER_BUILDKIT=1 $(RUNC) build		\
 		$(if $V,,--quiet)			\
 		$(if $(NOCACHE),--no-cache,		\
 			$(if $(DOCKER_REGISTRY),--cache-from $(DOCKER_REGISTRY)/qemu/$*)) \
-- 
2.39.2

