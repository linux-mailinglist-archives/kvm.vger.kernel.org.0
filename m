Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B7727766B
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgIXQQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727058AbgIXQQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=hXFxCA1THgFF6E/WD3R3Q+VIFfK2zhJenxQYSaQDe00=;
        b=UcTIXN9auVpNFb3exgoPjRLPlVpok8eWZfrax9mFKJ4fxUFLC82tmne+SWTfABnjK5gs2I
        1d99R/mHLNnhlumbmHRGjnwxxICU5ymqkkvESUVjJFC8QXCbF/Try08TPyg1KE6RoT5PvP
        nHMM8R+F0Fz7+yL5ZCQTvPWeEyYIDSQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-jBXSIpZmNnypE4lA6YcW5Q-1; Thu, 24 Sep 2020 12:16:51 -0400
X-MC-Unique: jBXSIpZmNnypE4lA6YcW5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4D7985B66C;
        Thu, 24 Sep 2020 16:16:50 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10CB173662;
        Thu, 24 Sep 2020 16:16:48 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 7/9] lib/arm64/spinlock: Fix inline assembly for Clang
Date:   Thu, 24 Sep 2020 18:16:10 +0200
Message-Id: <20200924161612.144549-8-thuth@redhat.com>
In-Reply-To: <20200924161612.144549-1-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

/home/travis/build/huth/kvm-unit-tests/lib/arm64/spinlock.c:29:12: error:
 value size does not match register size specified by the constraint and
 modifier [-Werror,-Wasm-operand-widths]
                : "=&r" (val), "=&r" (fail)
                         ^
/home/travis/build/huth/kvm-unit-tests/lib/arm64/spinlock.c:27:9: note: use
 constraint modifier "w"
                "       mov     %0, #1\n"
                                ^~
                                %w0

Use the "w" modifier as suggested to fix the issue.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/arm64/spinlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/arm64/spinlock.c b/lib/arm64/spinlock.c
index fac4fc9..258303d 100644
--- a/lib/arm64/spinlock.c
+++ b/lib/arm64/spinlock.c
@@ -24,7 +24,7 @@ void spin_lock(struct spinlock *lock)
 		asm volatile(
 		"1:	ldaxr	%w0, [%2]\n"
 		"	cbnz	%w0, 1b\n"
-		"	mov	%0, #1\n"
+		"	mov	%w0, #1\n"
 		"	stxr	%w1, %w0, [%2]\n"
 		: "=&r" (val), "=&r" (fail)
 		: "r" (&lock->v)
-- 
2.18.2

