Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4200036EE53
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240801AbhD2QoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:44:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233302AbhD2QoD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 12:44:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619714596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Ma7KqF/omEAl7IA6u7SjFcPlLYC7wcbkLXbqukcVVc=;
        b=ElJuXj9tJGVGS3ufae7+oy1j+6R9zakHOQa5w6D7/sWhOEIrQ3OD0seqqKNyq0JK++dB7u
        +hrs+joehJO1UMyGJBEsVwpUd/DHWfm5DKSi0GpOQQU7pN2feBKQuSZ5My/v5cFSxsA7CI
        +hqPobxItFJMU8jQ2wQUdmWZSH9HWHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512--21hQzLXNLCAiByqVJOiHA-1; Thu, 29 Apr 2021 12:43:12 -0400
X-MC-Unique: -21hQzLXNLCAiByqVJOiHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60E31102C81A;
        Thu, 29 Apr 2021 16:42:36 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F62C641AD;
        Thu, 29 Apr 2021 16:41:54 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests v3 7/8] chr-testdev: Silently fail init
Date:   Thu, 29 Apr 2021 18:41:29 +0200
Message-Id: <20210429164130.405198-8-drjones@redhat.com>
In-Reply-To: <20210429164130.405198-1-drjones@redhat.com>
References: <20210429164130.405198-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If there's no virtio-console / chr-testdev configured, then the user
probably didn't want them. Just silently fail rather than stating
the obvious.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/chr-testdev.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
index 6890f63c8b29..b3c641a833fe 100644
--- a/lib/chr-testdev.c
+++ b/lib/chr-testdev.c
@@ -54,11 +54,8 @@ void chr_testdev_init(void)
 	int ret;
 
 	vcon = virtio_bind(VIRTIO_ID_CONSOLE);
-	if (vcon == NULL) {
-		printf("%s: %s: can't find a virtio-console\n",
-				__func__, TESTDEV_NAME);
+	if (vcon == NULL)
 		return;
-	}
 
 	ret = vcon->config->find_vqs(vcon, 2, vqs, NULL, io_names);
 	if (ret < 0) {
-- 
2.30.2

