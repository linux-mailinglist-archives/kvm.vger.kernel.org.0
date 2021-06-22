Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2154A3B064A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 15:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhFVN5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 09:57:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231492AbhFVN5r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 09:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624370131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4iGTabNP1Yd0Y27SUqRUQZyMTdtA5xyHE9vKfDmgaI0=;
        b=EWW5kshWlrGPxwTTU8MPXRmEQm22ZsL4+JBRiNMtyN+6GtYubNKamX5GusELk1mcikkWvR
        yAl75+nTXFhvta9b2+9rycBnMTjAOB353Bs0G+UfgRVnfDugZ29mGjF5T5VhvwnBeNOtss
        Bxon8yoPwDBom8aB5o86m46ZMTtGaWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-sJA19gtEOIGPYKip5XiAXg-1; Tue, 22 Jun 2021 09:55:29 -0400
X-MC-Unique: sJA19gtEOIGPYKip5XiAXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B7CB10C1ADC;
        Tue, 22 Jun 2021 13:55:28 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9786A69CB4;
        Tue, 22 Jun 2021 13:55:26 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH 2/4] powerpc: Probe whether the compiler understands -mabi=no-altivec
Date:   Tue, 22 Jun 2021 15:55:15 +0200
Message-Id: <20210622135517.234801-3-thuth@redhat.com>
In-Reply-To: <20210622135517.234801-1-thuth@redhat.com>
References: <20210622135517.234801-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang does not support "-mabi=no-altivec", so let's check whether
this option is supported before using it.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 powerpc/Makefile.common | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 4c3121a..12c280c 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -17,9 +17,11 @@ all: directories $(TEST_DIR)/boot_rom.bin $(tests-all)
 
 ##################################################################
 
+mabi_no_altivec := $(call cc-option,-mabi=no-altivec,"")
+
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
-CFLAGS += -O2 -msoft-float -mabi=no-altivec -mno-altivec
+CFLAGS += -O2 -msoft-float -mno-altivec $(mabi_no_altivec)
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 CFLAGS += -Wa,-mregnames
 
-- 
2.27.0

