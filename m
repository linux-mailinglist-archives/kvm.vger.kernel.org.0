Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D74349639
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 16:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCYP52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 11:57:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229728AbhCYP5I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 11:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616687828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0//FBRo6OokAHUTq5nOdjoQhfXAjaYtHnLIY4ZWJ6U=;
        b=ZQ3ofn0Q7z/cRwXqcaiT/EO0SSqFEZwCfyUC/Gqwytg/sbWjYzTxJGJ1cllo2V+5zF6Zkf
        ToYa4aNj4yflkwItamZ1TsMgpmnOT3nDUrv8ViyAw6zkNnS5RZ+HeTtadFjqj/MLx89Iov
        yrXWL4h7BRBmUC1r/kmIY+ZAAMLTLCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-z6Elz8moOMeskB22z9nwNA-1; Thu, 25 Mar 2021 11:57:03 -0400
X-MC-Unique: z6Elz8moOMeskB22z9nwNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98A961012EE0;
        Thu, 25 Mar 2021 15:57:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B2E05D736;
        Thu, 25 Mar 2021 15:57:01 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, alexandru.elisei@arm.com
Subject: [PATCH kvm-unit-tests 1/2] arm64: argc is an int
Date:   Thu, 25 Mar 2021 16:56:56 +0100
Message-Id: <20210325155657.600897-2-drjones@redhat.com>
In-Reply-To: <20210325155657.600897-1-drjones@redhat.com>
References: <20210325155657.600897-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If argc isn't aligned to eight bytes then loading it as if it's
eight bytes wide is a bad idea. It's only four bytes wide, so we
should only load four bytes.

Reported-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 89321dad7aba..0a85338bcdae 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -100,7 +100,7 @@ start:
 1:
 	/* run the test */
 	adrp	x0, __argc
-	ldr	x0, [x0, :lo12:__argc]
+	ldr	w0, [x0, :lo12:__argc]
 	adrp	x1, __argv
 	add	x1, x1, :lo12:__argv
 	adrp	x2, __environ
-- 
2.26.3

