Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBD96BBB5A
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjCORtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjCORti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:38 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F1340E8
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:25 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id m35so3582040wms.4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppSEIztWs3xXXlNFmxb7gCAEPQ7PlB98pYGLeW4YOYE=;
        b=WIO3ei+bYW7ojkqoukS+1PJLDudVTHC6RYsQF8hYA5vEQyo2CFtShEbvs0+omK2dcf
         dHIPYNEucLD1qgZ+YHpLk4QZww4ts2+QRHBBgu0XqttzygMdHCzbwYEsrivMNNjuxO1/
         Hf0+uxEmKTqMHLJ+Je7miLs8erttyjnqU6BbkoSC348P+JhGOwmce8mbog/KJ4iT/R64
         tHF+IPu69rmbHK07Bj60SYaxfQL8BCKlxQNtnPuUUZMjGGCNnT9Kqh3Bf57bLjwHvIEB
         2seWWKTdwhhNbvJeHp5W9sgHtv/0lOHROuPzyjsycDYf/r7QZ/c3B6KPiMFKhkj9zO6x
         I8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ppSEIztWs3xXXlNFmxb7gCAEPQ7PlB98pYGLeW4YOYE=;
        b=cKaTk6mcY4aeoaXJNkfA2ZTjdH8ErUd8gE8V5q4qz2+YR+yAwGBVz+KpyxBelGqhmA
         2aacNSiGW4AIdknSk7/hIhqP+OEO/E3UmF5DNqEBfLB7L+cdXYq8m6s/Xs09knLntSNZ
         xlM9WVET9AM25P0cwcDG7hXHld9mG3QWIlMwdyRCRJNu7EHdXeuccFrNs2TbhoVUGqMF
         GkDdjVDq7FMPPSpqrwk2+nqhrMNpOA1JdFckF4/Xb3zUn5D/ovfQF97yLqVbqf9sOVfh
         mOYfdkADpQjZfGTUBJUKmYypJKEStMNYD4F9DNzD6zTtS2SiHJHAasvh2bBFJrl2rYzi
         uadw==
X-Gm-Message-State: AO0yUKWy2mhGyyhHa6+IbX9L96l9JMLQ+6134A/Hqod+G62mEfhcV3qp
        D+ML1BG5iKWYtVpdzQM+ReJ6XA==
X-Google-Smtp-Source: AK7set+JYvMR70JtFfX1kCSrzwqWSYlcBlKVoOvXWPZWJyDWAaD4ET92OU/0CvN70RO8bGPmmBMuqA==
X-Received: by 2002:a05:600c:1548:b0:3ed:252e:869f with SMTP id f8-20020a05600c154800b003ed252e869fmr10413534wmg.13.1678902563579;
        Wed, 15 Mar 2023 10:49:23 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a5-20020a056000100500b002cea299a575sm5100861wrx.101.2023.03.15.10.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:22 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 45E101FFC0;
        Wed, 15 Mar 2023 17:43:32 +0000 (GMT)
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
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 09/32] include/exec: fix kerneldoc definition
Date:   Wed, 15 Mar 2023 17:43:08 +0000
Message-Id: <20230315174331.2959-10-alex.bennee@linaro.org>
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

The kerneldoc processor complains about the mismatched variable name.
Fix it.

Message-Id: <20230310103123.2118519-11-alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/exec/memory.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 6fa0b071f0..15ade918ba 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1738,7 +1738,7 @@ void memory_region_notify_iommu_one(IOMMUNotifier *notifier,
  *
  * @notifier: the notifier to be notified
  */
-void memory_region_unmap_iommu_notifier_range(IOMMUNotifier *n);
+void memory_region_unmap_iommu_notifier_range(IOMMUNotifier *notifier);
 
 
 /**
-- 
2.39.2

