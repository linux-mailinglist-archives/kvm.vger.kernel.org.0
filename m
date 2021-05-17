Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591C438324B
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbhEQOqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:46:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240154AbhEQOlM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 10:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621262395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6DlYf63LGyb5kPDVzACEXGaInJE+o2P1nGqalbsww+M=;
        b=H13m9edL+TX1Uj1nKi24Xf4RU708pGCIAgcS+IleAvMULF36gcU/v8biz4ZreebQ36WMmB
        Bcbi9zwvmAOSBdR2x8rt+P4P8+Mvuaf1HEAqLtbeVH/5i0JkSGkAMT+hB3YaTLL+PviWo1
        6rwFcR0IwOHzO6YoWEXRCON+bNlwLKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-h2rS_hcCN420g3QF78umNg-1; Mon, 17 May 2021 10:39:53 -0400
X-MC-Unique: h2rS_hcCN420g3QF78umNg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A628410229FE;
        Mon, 17 May 2021 14:39:18 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 384EC5D6D7;
        Mon, 17 May 2021 14:39:17 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 09/10] chr-testdev: Silently fail init
Date:   Mon, 17 May 2021 16:38:59 +0200
Message-Id: <20210517143900.747013-10-drjones@redhat.com>
In-Reply-To: <20210517143900.747013-1-drjones@redhat.com>
References: <20210517143900.747013-1-drjones@redhat.com>
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
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
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

