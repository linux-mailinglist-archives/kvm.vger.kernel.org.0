Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20473B064E
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhFVN5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 09:57:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231517AbhFVN5t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 09:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624370133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vbnrv+ql87RxObwI8g+u0AJ73UbGfiSxFvVFRy2BCE=;
        b=BuJLo6DuCl5RGvd/A4pbTASWNrfsfXYmk1logvi+nv69Ay5658Y/+Lo/GoHu+ECNQNnJgO
        6N4iCZlnqUq0lW4yV7WFCeTaw9FZiLSVqoxKjIipmY2JUAKdp32zqdsZaKGIPLIIt2umiw
        LOhaM7FzXrmmn/Dajmdka932BBJelNA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-oNkcgZldPBSc2kHu_lDHZg-1; Tue, 22 Jun 2021 09:55:31 -0400
X-MC-Unique: oNkcgZldPBSc2kHu_lDHZg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA22E101F7A4;
        Tue, 22 Jun 2021 13:55:30 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4FF469CB4;
        Tue, 22 Jun 2021 13:55:28 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH 3/4] lib/s390x: Fix the epsw inline assembly
Date:   Tue, 22 Jun 2021 15:55:16 +0200
Message-Id: <20210622135517.234801-4-thuth@redhat.com>
In-Reply-To: <20210622135517.234801-1-thuth@redhat.com>
References: <20210622135517.234801-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the Principles of Operation, the epsw instruction
does not touch the second register if it is r0. With GCC we were
lucky so far that it never tried to use r0 here, but when compiling
the kvm-unit-tests with Clang, this indeed happens and leads to
very weird crashes. Thus let's make sure to never use r0 for the
second operand of the epsw instruction.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 3aa5da9..15cf7d4 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -265,7 +265,7 @@ static inline uint64_t extract_psw_mask(void)
 
 	asm volatile(
 		"	epsw	%0,%1\n"
-		: "+r" (mask_upper), "+r" (mask_lower) : : );
+		: "=r" (mask_upper), "=a" (mask_lower));
 
 	return (uint64_t) mask_upper << 32 | mask_lower;
 }
-- 
2.27.0

