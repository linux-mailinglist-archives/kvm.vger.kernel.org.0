Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E960E6BBB5E
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbjCORt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjCORtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:40 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EB6199CD
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:23 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m18-20020a05600c3b1200b003ed2a3d635eso1827730wms.4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fw0yP+1ZBc/H2+o37ZgzxeatA+xGyE5UatghhgQrblQ=;
        b=PK6Qx2aRoV5zGR34fqA44kbG5SL34c4aG9XoK14NFI1vNkR58VJFp6iYJzwahWraro
         WMzZ0OnyjAvroGfTigg2jjF70WRV1+CvKYr/3QxYVd84QD6/l8fbHjEcR9amdzMVo2y5
         GOmXm43nw1k7zoMiC72SJipwi2L3Z1Wq2fZZ8kcJGr2oAYYN1ae5XxLTAb9llw4pD75F
         rk4aBg0g/Q/ambXEU/vM56V0n4Mr469XXlsGI/S8s2LlCx/373glwaCnhoOG75vMAHNC
         cKHL7HEGo+8UTHu//jsY9h3gdCK8T2JPZ+Vk7GSHWhM37IJuuMhbkeTA9xoZr3m93bPC
         eCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fw0yP+1ZBc/H2+o37ZgzxeatA+xGyE5UatghhgQrblQ=;
        b=ozPGVlUzSyDmHghd5IT/bKnNIhVdWxaTx0jbSlMfHGcyLsGaX9479zu1cUo926sPHI
         hzIUAMVNerdGOKHRYpybiV9z1CklZGHLxtNS0uYmK3JbxMJLehui5E3dl+b66ddFJeuE
         JAXAIkoPFP0YSgc7LgLRaq1VLVuI7SSmoucJybOd1WDoqiha3ZPwjHqkyaomOvfUtZU0
         Gaonwwb0iih3MtjEF4jEMpu4kvZHoEWpyBh4R8Jt0h3iVJ1sv71242VXMWaIPbxzo40D
         gR2Gc2z3teU1dquBkQ6VdKOOMK5wVcgRAH4/8hqZ0iGz9Jal4DCFogXD5h+0cCVG5BTc
         h3kQ==
X-Gm-Message-State: AO0yUKVRqzxq5C3NlHCTFKcF3S1ywqK6chWyv/ecA2MUUPIGm9Xbg+li
        vwrt2w0n2aJ+TGZEt6961/ymow==
X-Google-Smtp-Source: AK7set+9tTnIiQ8OrC2YjJzoPKpiOia23IRE+7BDnXFLCbUFl2v0rbWH5IJ6secCAdDaaUvPQvuPQQ==
X-Received: by 2002:a05:600c:4590:b0:3df:1673:90b6 with SMTP id r16-20020a05600c459000b003df167390b6mr18850717wmo.39.1678902562456;
        Wed, 15 Mar 2023 10:49:22 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id c9-20020a7bc009000000b003ed3084669asm2602107wmb.14.2023.03.15.10.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:21 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id D228C1FFD2;
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
        Alexander Graf <graf@amazon.com>,
        Paul Durrant <pdurrant@amazon.com>,
        David Wooodhouse <dwmw@amazon.co.uk>
Subject: [PATCH v2 28/32] contrib/gitdm: add Amazon to the domain map
Date:   Wed, 15 Mar 2023 17:43:27 +0000
Message-Id: <20230315174331.2959-29-alex.bennee@linaro.org>
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

We have multiple contributors from both .co.uk and .com versions of
the address.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Paul Durrant <pdurrant@amazon.com>
Cc: David Wooodhouse <dwmw@amazon.co.uk>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230310180332.2274827-7-alex.bennee@linaro.org>
---
 contrib/gitdm/domain-map | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/contrib/gitdm/domain-map b/contrib/gitdm/domain-map
index 4a988c5b5f..8dce276a1c 100644
--- a/contrib/gitdm/domain-map
+++ b/contrib/gitdm/domain-map
@@ -4,6 +4,8 @@
 # This maps email domains to nice easy to read company names
 #
 
+amazon.com      Amazon
+amazon.co.uk    Amazon
 amd.com         AMD
 aspeedtech.com  ASPEED Technology Inc.
 baidu.com       Baidu
-- 
2.39.2

