Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C07F19E59D
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgDDOiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30047 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726229AbgDDOh5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 Apr 2020 10:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Euu3Q40ZKuRWEaooJhTwQlVK70xJGz+tBDjXBAOUp2U=;
        b=Q5dJRyAoXwx7ZODsuaMB03Vm3ZG1t+k+oM0VNa4/EuupMy/t7pl+IcPNOvo8ZROj/EdVWn
        3RBUWcwb92lRXKY9E5uS3T8lGrtX5rSmfbiOeQHm9XtVdl8T3gsdra0qKWa3ENi1AHD8YB
        basY5aujSMY3HynHHO89ZW5JUeDlNE4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189--hQdh5ltMr2zW6mDooqKXg-1; Sat, 04 Apr 2020 10:37:53 -0400
X-MC-Unique: -hQdh5ltMr2zW6mDooqKXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3743518AB2E3;
        Sat,  4 Apr 2020 14:37:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2549F9B912;
        Sat,  4 Apr 2020 14:37:48 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PULL kvm-unit-tests 05/39] arm64: timer: Make irq_received volatile
Date:   Sat,  4 Apr 2020 16:36:57 +0200
Message-Id: <20200404143731.208138-6-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
2.25.1

