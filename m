Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5971FAED0
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 12:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgFPK7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 06:59:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22473 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728217AbgFPK7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 06:59:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592305188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=VSb5JMG1sxeC0xJQaXKMewCIfOw5Nog4KVL7A45ysQk=;
        b=DlRr78wbg1IejgE0QWuf0038T1GKCUUWvuw8/LJhRtB0Bf0jNDbwAtj2owkGSuDPxnRF4h
        WcJA2rFeH6udgNDZe+M8WCsJfhsXMb14gBzI+IfBttlbNumYkFPD2U/rVDIkdl3o5nUhRt
        baOf7td1hePd4ONRNxDe+8M3ukW7ocE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-aQ9ly5QJOI-RNW31h3pRQw-1; Tue, 16 Jun 2020 06:59:44 -0400
X-MC-Unique: aQ9ly5QJOI-RNW31h3pRQw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A76F11009618;
        Tue, 16 Jun 2020 10:59:43 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6813A19C71;
        Tue, 16 Jun 2020 10:59:42 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     like.xu@linux.intel.com, vkuznets@redhat.com
Subject: [kvm-unit-tests PATCH] x86/pmu: Fix compilation on 32-bit hosts
Date:   Tue, 16 Jun 2020 12:59:40 +0200
Message-Id: <20200616105940.2907-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When building for 32-bit hosts, the compiler currently complains:

 x86/pmu.c: In function 'check_gp_counters_write_width':
 x86/pmu.c:490:30: error: left shift count >= width of type

Use the correct suffix to avoid this problem.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 57a2b23..91a6fb4 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -487,7 +487,7 @@ static void do_unsupported_width_counter_write(void *index)
 static void  check_gp_counters_write_width(void)
 {
 	u64 val_64 = 0xffffff0123456789ull;
-	u64 val_32 = val_64 & ((1ul << 32) - 1);
+	u64 val_32 = val_64 & ((1ull << 32) - 1);
 	u64 val_max_width = val_64 & ((1ul << eax.split.bit_width) - 1);
 	int i;
 
-- 
2.18.1

