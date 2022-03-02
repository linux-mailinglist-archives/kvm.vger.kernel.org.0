Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37594CA3E6
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbiCBLha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241533AbiCBLh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:37:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0404DA418B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 03:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646221006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qb9pfajxXaiGyktL+dfrQe0s0K4x9B79EqLml1X3lZo=;
        b=H/PE8dlkFSqCX1mv7IHmxaxpGadOkQNFVgQoY8MF/QVMRwqEhf7MDExUZ3DIHhpsMZe40H
        hU6zgQqINrn6bRztBMB1CUbwYn8mGiOHzZbgV5KZri35YLXIhwZgw3ZbGDNmAsvfVXvCe0
        4/jewK1RZBe/WXM54UTo8moyZ3Veyf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-ENLXuy0lNkq7HsTh9kSKhw-1; Wed, 02 Mar 2022 06:36:43 -0500
X-MC-Unique: ENLXuy0lNkq7HsTh9kSKhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ACA5801AAD;
        Wed,  2 Mar 2022 11:36:41 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.36.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38AE783286;
        Wed,  2 Mar 2022 11:36:36 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     vgoyal@redhat.com, Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>, Sergio Lopez <slp@redhat.com>
Subject: [PATCH 2/2] Allow building vhost-user in BSD
Date:   Wed,  2 Mar 2022 12:36:44 +0100
Message-Id: <20220302113644.43717-3-slp@redhat.com>
In-Reply-To: <20220302113644.43717-1-slp@redhat.com>
References: <20220302113644.43717-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the possibility of using pipefd as a replacement on operating
systems that doesn't support eventfd, vhost-user can also work on BSD
systems.

This change allows enabling vhost-user on BSD platforms too and
makes libvhost_user (which still depends on eventfd) a linux-only
feature.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 configure   | 5 +++--
 meson.build | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index c56ed53ee3..93aa22e345 100755
--- a/configure
+++ b/configure
@@ -1659,8 +1659,9 @@ fi
 # vhost interdependencies and host support
 
 # vhost backends
-if test "$vhost_user" = "yes" && test "$linux" != "yes"; then
-  error_exit "vhost-user is only available on Linux"
+if test "$vhost_user" = "yes" && \
+    test "$linux" != "yes" && test "$bsd" != "yes" ; then
+  error_exit "vhost-user is only available on Linux and BSD"
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

