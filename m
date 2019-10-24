Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09480E3372
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393557AbfJXNHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55737 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393548AbfJXNHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:07:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zTSzgalkw9qlrrhqQs428qBy292FUf7dpnq5c4qJjf4=;
        b=h/HpqGsg3jPbyKJghcBqzjPVY4K6RsjM8+ijK78UpVOQ9NLS6d5R9SuaR9/TW5/m1ST5+e
        dHXSbhjYu02Lnrbsk/ZSAdS8qSkY69BHlQdltly3dr8TINRYIQOkPqAWC9LsS3Mn2ovlMZ
        D/HWgg48qAOdIRcqYUFQubSu93IFVQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-2YTHzEIQP1ukgN4dWbdFIA-1; Thu, 24 Oct 2019 09:07:14 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48D691005512;
        Thu, 24 Oct 2019 13:07:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CD815D70E;
        Thu, 24 Oct 2019 13:07:12 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL 07/10] lib: arm64: Add missing ISB in flush_tlb_page
Date:   Thu, 24 Oct 2019 15:06:58 +0200
Message-Id: <20191024130701.31238-8-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 2YTHzEIQP1ukgN4dWbdFIA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Linux commit d0b7a302d58a made it abundantly clear that certain CPU
implementations require an ISB after a DSB. Add the missing ISB to
flush_tlb_page. No changes are required for flush_tlb_all, as the function
already had the ISB.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm64/asm/mmu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index fa554b0c20ae..72d75eafc882 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -24,6 +24,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
 =09dsb(ishst);
 =09asm("tlbi=09vaae1is, %0" :: "r" (page));
 =09dsb(ish);
+=09isb();
 }
=20
 static inline void flush_dcache_addr(unsigned long vaddr)
--=20
2.21.0

