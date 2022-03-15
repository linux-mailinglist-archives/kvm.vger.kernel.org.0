Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1C84D9DE9
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243902AbiCOOnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349370AbiCOOnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:43:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F25055BC0
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 07:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647355322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F9p92xVdbAU558Jcfq2dXxSaOx5fAK5gBBxvOK2lDYo=;
        b=At5nnrjDBwjZ1UORLtere9g2Yn5yjcK5zGtosgm7bkYVNe4ZyD+SiDuMgNXLQui7IQ8zt5
        uwHWSYnNqFgrYrJdy2P1DoVY00QM67kDMH++gY3a1Wx5CN4y/5SE5/Ud8GfUlpc+DILQDn
        EJssbVC67n9VXKexP57qQpEh/RZLpeI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-f37HFUoKNuCxvBrj_-jyxA-1; Tue, 15 Mar 2022 10:41:59 -0400
X-MC-Unique: f37HFUoKNuCxvBrj_-jyxA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B24CF38021A6;
        Tue, 15 Mar 2022 14:41:58 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.36.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E3128555C82;
        Tue, 15 Mar 2022 14:41:57 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id C2F2121E66FC; Tue, 15 Mar 2022 15:41:56 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, xen-devel@lists.xenproject.org,
        qemu-ppc@nongnu.org, qemu-block@nongnu.org, haxm-team@intel.com,
        qemu-s390x@nongnu.org
Subject: [PATCH v2 1/3] scripts/coccinelle: New use-g_new-etc.cocci
Date:   Tue, 15 Mar 2022 15:41:54 +0100
Message-Id: <20220315144156.1595462-2-armbru@redhat.com>
In-Reply-To: <20220315144156.1595462-1-armbru@redhat.com>
References: <20220315144156.1595462-1-armbru@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the semantic patch from commit b45c03f585 "arm: Use g_new() &
friends where that makes obvious sense".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
---
 scripts/coccinelle/use-g_new-etc.cocci | 75 ++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 scripts/coccinelle/use-g_new-etc.cocci

diff --git a/scripts/coccinelle/use-g_new-etc.cocci b/scripts/coccinelle/use-g_new-etc.cocci
new file mode 100644
index 0000000000..e2280e93b3
--- /dev/null
+++ b/scripts/coccinelle/use-g_new-etc.cocci
@@ -0,0 +1,75 @@
+// Use g_new() & friends where that makes obvious sense
+@@
+type T;
+@@
+-g_malloc(sizeof(T))
++g_new(T, 1)
+@@
+type T;
+@@
+-g_try_malloc(sizeof(T))
++g_try_new(T, 1)
+@@
+type T;
+@@
+-g_malloc0(sizeof(T))
++g_new0(T, 1)
+@@
+type T;
+@@
+-g_try_malloc0(sizeof(T))
++g_try_new0(T, 1)
+@@
+type T;
+expression n;
+@@
+-g_malloc(sizeof(T) * (n))
++g_new(T, n)
+@@
+type T;
+expression n;
+@@
+-g_try_malloc(sizeof(T) * (n))
++g_try_new(T, n)
+@@
+type T;
+expression n;
+@@
+-g_malloc0(sizeof(T) * (n))
++g_new0(T, n)
+@@
+type T;
+expression n;
+@@
+-g_try_malloc0(sizeof(T) * (n))
++g_try_new0(T, n)
+@@
+type T;
+expression p, n;
+@@
+-g_realloc(p, sizeof(T) * (n))
++g_renew(T, p, n)
+@@
+type T;
+expression p, n;
+@@
+-g_try_realloc(p, sizeof(T) * (n))
++g_try_renew(T, p, n)
+@@
+type T;
+expression n;
+@@
+-(T *)g_new(T, n)
++g_new(T, n)
+@@
+type T;
+expression n;
+@@
+-(T *)g_new0(T, n)
++g_new0(T, n)
+@@
+type T;
+expression p, n;
+@@
+-(T *)g_renew(T, p, n)
++g_renew(T, p, n)
-- 
2.35.1

