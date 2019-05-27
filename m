Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B802B90F
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 18:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfE0Q0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 12:26:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfE0Q0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 12:26:39 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2FFF233027D
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 16:26:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3722460BE2;
        Mon, 27 May 2019 16:26:38 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com
Subject: [PATCH] arm64: timer: ensure pending signal was cleared
Date:   Mon, 27 May 2019 18:26:36 +0200
Message-Id: <20190527162636.28878-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 27 May 2019 16:26:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure set_timer_irq_enabled() clears the pending interrupt from
the gic before proceeding with the next test.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arm/timer.c b/arm/timer.c
index 275d0494083d..eebc451722d9 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -231,6 +231,7 @@ static void test_timer(struct timer_info *info)
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
 	set_timer_irq_enabled(info, true);
+	report("interrupt signal no longer pending", !gic_timer_pending(info));
 
 	report("latency within 10 ms", test_cval_10msec(info));
 	report("interrupt received", info->irq_received);
-- 
2.18.1

