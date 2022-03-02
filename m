Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085894CACF2
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244400AbiCBSHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbiCBSHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:07:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C6DB14083
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646244409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GU2PkYv/oO0WBN6akEtPQqLOjiJQ79hZYXxHxM/rB9g=;
        b=DjPgub6PQ1bgmjRqrANKmfQu7isYKPrFFx4VDRD4g6NfOUQs4CZlCZc/PCw1K7SMSDuYvj
        mUAxHxT0bzkpFpMB3yMAp2qQcTa1GCaLuciRwSnmcJ403/qgOmeRKDIZKd3PQzYbAzbsAr
        deWl4A73j6iLvWX59HW5am0HPtyr7kE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-cj2pkYG1PbGXtrc4Ml26FA-1; Wed, 02 Mar 2022 13:06:46 -0500
X-MC-Unique: cj2pkYG1PbGXtrc4Ml26FA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07D001091DA2;
        Wed,  2 Mar 2022 18:06:44 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED82F7DE2F;
        Wed,  2 Mar 2022 18:06:04 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        qemu-block@nongnu.org, vgoyal@redhat.com,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-s390x@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Kevin Wolf <kwolf@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v2 3/3] configure, meson: allow enabling vhost-user on all POSIX systems
Date:   Wed,  2 Mar 2022 19:03:18 +0100
Message-Id: <20220302180318.28893-4-slp@redhat.com>
In-Reply-To: <20220302180318.28893-1-slp@redhat.com>
References: <20220302180318.28893-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

