Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0453C7813
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 22:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhGMUki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 16:40:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231499AbhGMUki (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 16:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626208667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xy/M8DyJhkeHcfgLxk1yBVOnSySApjGIhNjf8/Qokmo=;
        b=OgWvRM0Q5/Ci2Hca3xY/KsEmuQLMMKVdvRJKED2/UmAqqCy+M3FNfWNwgBG0Z/621yB/iE
        VLIXzUaBdh/ILlaEihaRgO5QLwMoPSGYB+p/EFlz6NtiD83PDTdrsPbg0R6QDYIfFAf2tU
        EDQgDBbr8z8ut93Ljx6Xt/0M5RC70e4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-PpdtELlKPxWgPnX-vBHNYQ-1; Tue, 13 Jul 2021 16:37:46 -0400
X-MC-Unique: PpdtELlKPxWgPnX-vBHNYQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEBBA801107;
        Tue, 13 Jul 2021 20:37:44 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.22.8.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 270541002D71;
        Tue, 13 Jul 2021 20:37:44 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, pbonzini@redhat.com
Subject: [PATCH 1/2] KVM: selftests: change pthread_yield to sched_yield
Date:   Tue, 13 Jul 2021 22:37:41 +0200
Message-Id: <20210713203742.29680-2-drjones@redhat.com>
In-Reply-To: <20210713203742.29680-1-drjones@redhat.com>
References: <20210713203742.29680-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With later GCC we get

 steal_time.c: In function ‘main’:
 steal_time.c:323:25: warning: ‘pthread_yield’ is deprecated: pthread_yield is deprecated, use sched_yield instead [-Wdeprecated-declarations]

Let's follow the instructions and use sched_yield instead.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/steal_time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index b0031f2d38fd..ecec30865a74 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -320,7 +320,7 @@ int main(int ac, char **av)
 		run_delay = get_run_delay();
 		pthread_create(&thread, &attr, do_steal_time, NULL);
 		do
-			pthread_yield();
+			sched_yield();
 		while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS);
 		pthread_join(thread, NULL);
 		run_delay = get_run_delay() - run_delay;
-- 
2.31.1

