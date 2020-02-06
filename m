Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC6015490C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBFQYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:24:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34490 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727620AbgBFQYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7iRAUQiItMHQV7bN4+Gq3+cja/5TP9eqSYrL3+0FwWg=;
        b=T+8l0PIqiHAO9NRvuVGnjEB8wyEpTdaFTZpJsL/R1/HtugwYf5nGgNyZGkZfyRpQDTDCLA
        /NIGP1XPzT2aJf8GxbqvjnK8bDVQXCU5XdVG1Ku9YDuRz+mqXyKN5vWCyqjP32T3fj9k77
        U4a2u9hl0sEmkE8xnk++KdQgYitVV9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-8OLxPBo8NLG46LYCubvEow-1; Thu, 06 Feb 2020 11:24:47 -0500
X-MC-Unique: 8OLxPBo8NLG46LYCubvEow-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB5DE18AB2C2;
        Thu,  6 Feb 2020 16:24:45 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C73621001B05;
        Thu,  6 Feb 2020 16:24:44 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PULL kvm-unit-tests 05/10] arm64: timer: Make irq_received volatile
Date:   Thu,  6 Feb 2020 17:24:29 +0100
Message-Id: <20200206162434.14624-6-drjones@redhat.com>
In-Reply-To: <20200206162434.14624-1-drjones@redhat.com>
References: <20200206162434.14624-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

The irq_received field is modified by the interrupt handler. Make it
volatile so that the compiler doesn't reorder accesses with regard to
the instruction that will be causing the interrupt.

Suggested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index e758e84855c3..82f891147b35 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -109,7 +109,7 @@ static void write_ptimer_ctl(u64 val)
 struct timer_info {
 	u32 irq;
 	u32 irq_flags;
-	bool irq_received;
+	volatile bool irq_received;
 	u64 (*read_counter)(void);
 	u64 (*read_cval)(void);
 	void (*write_cval)(u64);
--=20
2.21.1

