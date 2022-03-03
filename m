Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7042A4CBD43
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 13:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiCCMBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 07:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiCCMBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 07:01:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A03316FDE9
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 04:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646308823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GU2PkYv/oO0WBN6akEtPQqLOjiJQ79hZYXxHxM/rB9g=;
        b=Z3vDCWnv18peahKMKJz4D7qb+Yazko2rBabvod6L2EzDE9FuwiYyMaoxdQswnWl0RQEK6g
        UpjyfAFC+MZ3xa9MqAQFcEvU1oDe+XBSrWqJLxHvv4UN3CwErfXyfve5d9MuNhwT/XgQwA
        yh48wGFGgqdNjSGdvYfL+pJRyiGvUIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-ws9u5eVDPgS5WbHEubGu6g-1; Thu, 03 Mar 2022 07:00:19 -0500
X-MC-Unique: ws9u5eVDPgS5WbHEubGu6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C917F824FA6;
        Thu,  3 Mar 2022 12:00:17 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.37.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00CBE842CC;
        Thu,  3 Mar 2022 12:00:12 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-s390x@nongnu.org, vgoyal@redhat.com,
        Jagannathan Raman <jag.raman@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Eric Farman <farman@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v3 3/4] configure, meson: allow enabling vhost-user on all POSIX systems
Date:   Thu,  3 Mar 2022 12:59:10 +0100
Message-Id: <20220303115911.20962-4-slp@redhat.com>
In-Reply-To: <20220303115911.20962-1-slp@redhat.com>
References: <20220303115911.20962-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the possibility of using a pipe pair via qemu_pipe() as a
replacement on operating systems that doesn't support eventfd,
vhost-user can also work on all POSIX systems.

This change allows enabling vhost-user on all non-Windows platforms
and makes libvhost_user (which still depends on eventfd) a linux-only
feature.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 configure   | 4 ++--
 meson.build | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index c56ed53ee3..daccf4be7c 100755
--- a/configure
+++ b/configure
@@ -1659,8 +1659,8 @@ fi
 # vhost interdependencies and host support
 
 # vhost backends
-if test "$vhost_user" = "yes" && test "$linux" != "yes"; then
-  error_exit "vhost-user is only available on Linux"
+if test "$vhost_user" = "yes" && test "$mingw32" = "yes"; then
+  error_exit "vhost-user is not available on Windows"
 fi
 test "$vhost_vdpa" = "" && vhost_vdpa=$linux
 if test "$vhost_vdpa" = "yes" && test "$linux" != "yes"; then
diff --git a/meson.build b/meson.build
index 8df40bfac4..f2bc439c30 100644
--- a/meson.build
+++ b/meson.build
@@ -2701,7 +2701,7 @@ if have_system or have_user
 endif
 
 vhost_user = not_found
-if 'CONFIG_VHOST_USER' in config_host
+if targetos == 'linux' and 'CONFIG_VHOST_USER' in config_host
   libvhost_user = subproject('libvhost-user')
   vhost_user = libvhost_user.get_variable('vhost_user_dep')
 endif
-- 
2.35.1

