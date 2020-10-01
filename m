Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA7F27FA24
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 09:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgJAHWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 03:22:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731433AbgJAHWx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 03:22:53 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601536973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=hXFxCA1THgFF6E/WD3R3Q+VIFfK2zhJenxQYSaQDe00=;
        b=G0hnpuzKhLbOYcggE7iX2wIfylI2v52My+lhv55ytdQgXIbsRF2k5s5reU57BYYfVAvlXu
        MH2K5JGPBdGS8YH5pHdwFkX47dXx50uQCra2/hvDvFK8O1m1Xo8m9AUNRq4WB8fLq0GNZ9
        EPy2Ws+stbQBy4BEirzYjicn7FZhglM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-c8K0NzUkMu2jkX3iQADj1w-1; Thu, 01 Oct 2020 03:22:51 -0400
X-MC-Unique: c8K0NzUkMu2jkX3iQADj1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72F9B186DD20
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 07:22:50 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3561B60BF1;
        Thu,  1 Oct 2020 07:22:49 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, lvivier@redhat.com
Subject: [PATCH v2 6/7] lib/arm64/spinlock: Fix inline assembly for Clang
Date:   Thu,  1 Oct 2020 09:22:33 +0200
Message-Id: <20201001072234.143703-7-thuth@redhat.com>
In-Reply-To: <20201001072234.143703-1-thuth@redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

