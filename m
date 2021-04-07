Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A706C3574B5
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355519AbhDGTAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 15:00:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355515AbhDGTAF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 15:00:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617821995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+0Uv4KWM+jkXn6tPNx2tatgsR/a1j8uEfJcMGl7pv8=;
        b=XY6L2yjN8PR+/vR60/KjJRnJCov4FMHDzDP/M1cBeZZpPTgd/9KNF47uIczJC1ETZV1oCP
        ARy23QmlYdOS0d8CfenkyAKrcHlgm+VHxEI89geYhaiXLzwLMmTMshlOKU+ccPBCK1RPZE
        LnE9pc68r7zrMvfGIIwhRZYqIUjC3UY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-diBbI1WkPkKIwhvWHFXdAg-1; Wed, 07 Apr 2021 14:59:52 -0400
X-MC-Unique: diBbI1WkPkKIwhvWHFXdAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F90810054F6;
        Wed,  7 Apr 2021 18:59:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C236760CEA;
        Wed,  7 Apr 2021 18:59:47 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 7/8] chr-testdev: Silently fail init
Date:   Wed,  7 Apr 2021 20:59:17 +0200
Message-Id: <20210407185918.371983-8-drjones@redhat.com>
In-Reply-To: <20210407185918.371983-1-drjones@redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If there's no virtio-console / chr-testdev configured, then the user
probably didn't want them. Just silently fail rather than stating
the obvious.

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
2.26.3

