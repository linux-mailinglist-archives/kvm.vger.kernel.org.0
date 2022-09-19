Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B405BD820
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 01:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiISXT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 19:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiISXS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 19:18:58 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A43751413
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:18:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z2so1412716edi.1
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=08Zu8gSbNoVwH6SgINHBVlRGcpHDOzJ+Q2vxMgjaChc=;
        b=LfVaavpRhFpUWtJPmOxeHcORJMDqIlM8LXxn6uYegGeyIw7Hse/ODmgBL9aKBhrBR+
         QDDcqQqAdIZTX3WL1AetyE3jL8Z7UfxdRlbeYmgC3KxoQ1JGUO5P/z0aHKwwmXDVbECj
         AuFfIQm7sMB0W8Fn1uWO/41uzUy2iQROSJACK1zFtCB5Ab5h3m+zMu7WKhoWQK1NOfC6
         FGmzCigSE7vWW/M9qBClZbQwtO4eC/7gkX0vt5SaBL49Jx2Ea8iuUqxrqNunzGJXm1oE
         JWUZFC3ZmBZazxQinxj2ElsyYVRjc4rohZ/gwlRQDOLEWPgCW/Y5CMxXPPgmtldeeeIg
         RE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=08Zu8gSbNoVwH6SgINHBVlRGcpHDOzJ+Q2vxMgjaChc=;
        b=jsm+QSDjQVYJRWc6K7AshbXmbN5iOEnnSxjSWhDJqkv3yXB28OM6oQuHyR67mOynYz
         o76g8c1lNf6se4mknGhDkfwkKk8fgK8aP13ILcEG48sNrZxqW40MBEuT1nWlkVcg7+wK
         A/EZAY35XkS1GqQs2+Waie58PJZBgADEjmv+48Y2F07R5XlfTsRhIjcOgaeZKZrulDkr
         V9+0gighZxqOux24q1fLjsncFR4j+wSKMlIX1DYAq6gQkdjdZD46c+WEFyhUVu+0YM2P
         NmHt1aDbG2blUA+qQi1JCyo9lwYyztg5lrbXK4QsT+Ls8IXnLrPE49TknaRF5qJQEucZ
         hbKw==
X-Gm-Message-State: ACrzQf1cw15hrx1JrJLVxAAUiOYRFv1vP6b+QhdhmqSFDDyS8SiExES+
        lw7Bref1rcek9VkzJMVujls=
X-Google-Smtp-Source: AMsMyM6+ebOfksS7/dKAeoPOeQiFYFMU9VBsL7Wg1bKooGg4PafvZv5MknBjnq/lOyGHV8ZLR+girw==
X-Received: by 2002:a05:6402:50ca:b0:451:a711:1389 with SMTP id h10-20020a05640250ca00b00451a7111389mr17116111edb.239.1663629520004;
        Mon, 19 Sep 2022 16:18:40 -0700 (PDT)
Received: from localhost.localdomain (dynamic-078-054-077-055.78.54.pool.telefonica.de. [78.54.77.55])
        by smtp.gmail.com with ESMTPSA id rn24-20020a170906d93800b00780f6071b5dsm4800926ejb.188.2022.09.19.16.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 16:18:39 -0700 (PDT)
From:   Bernhard Beschow <shentey@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bandan Das <bsd@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Sergio Lopez <slp@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Cameron Esfahani <dirty@apple.com>,
        Michael Rolnik <mrolnik@gmail.com>,
        Song Gao <gaosong@loongson.cn>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Greg Kurz <groug@kaod.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Peter Xu <peterx@redhat.com>, Joel Stanley <joel@jms.id.au>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, haxm-team@intel.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        qemu-ppc@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Helge Deller <deller@gmx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-riscv@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Alexander Graf <agraf@csgraf.de>,
        Thomas Huth <thuth@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Eric Farman <farman@linux.ibm.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Alexander Bulekov <alxndr@bu.edu>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        xen-devel@lists.xenproject.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Snow <jsnow@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair@alistair23.me>,
        Jason Herne <jjherne@linux.ibm.com>,
        Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 4/9] hw/ppc/spapr: Fix code style problems reported by checkpatch
Date:   Tue, 20 Sep 2022 01:17:15 +0200
Message-Id: <20220919231720.163121-5-shentey@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220919231720.163121-1-shentey@gmail.com>
References: <20220919231720.163121-1-shentey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 include/hw/ppc/spapr.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 530d739b1d..04a95669ab 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -848,7 +848,8 @@ static inline uint64_t ppc64_phys_to_real(uint64_t addr)
 
 static inline uint32_t rtas_ld(target_ulong phys, int n)
 {
-    return ldl_be_phys(&address_space_memory, ppc64_phys_to_real(phys + 4*n));
+    return ldl_be_phys(&address_space_memory,
+                       ppc64_phys_to_real(phys + 4 * n));
 }
 
 static inline uint64_t rtas_ldq(target_ulong phys, int n)
@@ -858,7 +859,7 @@ static inline uint64_t rtas_ldq(target_ulong phys, int n)
 
 static inline void rtas_st(target_ulong phys, int n, uint32_t val)
 {
-    stl_be_phys(&address_space_memory, ppc64_phys_to_real(phys + 4*n), val);
+    stl_be_phys(&address_space_memory, ppc64_phys_to_real(phys + 4 * n), val);
 }
 
 typedef void (*spapr_rtas_fn)(PowerPCCPU *cpu, SpaprMachineState *sm,
-- 
2.37.3

