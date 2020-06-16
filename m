Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E928A1FBE9A
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgFPS4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730463AbgFPS4p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 14:56:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=Egwvk/keyW7bpl+kT1M4wcmKcL4bNR6jVz3e7BvACgA=;
        b=gzsgxA2IJ+1alPUKpAVVN2JO/gCyO1j27oe+8XdfaBCrpT3NhL1/HwHazYeB7eAbbAuRTG
        mF5kEjQ41AKTbKslpl56XYpgApOyBt96RrkQNGBBuZuyKDiNmhpZaQ8/Q6GP0qEj3op5Pg
        s79ob8pnbXYv5iwpdhwQ8v31TW9TZdo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-8dSTDQ4XP7-iu4BISQ-lbg-1; Tue, 16 Jun 2020 14:56:42 -0400
X-MC-Unique: 8dSTDQ4XP7-iu4BISQ-lbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CF145AECA
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:42 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 476EA7CAB0;
        Tue, 16 Jun 2020 18:56:41 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PULL 11/12] x86: disable SSE on 32-bit hosts
Date:   Tue, 16 Jun 2020 20:56:21 +0200
Message-Id: <20200616185622.8644-12-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

On 64-bit hosts we are disabling SSE and SSE2.  Depending on the
compiler however it may use movq instructions for 64-bit transfers
even when targeting 32-bit processors; when CR4.OSFXSR is not set,
this results in an undefined opcode exception, so tell the compiler
to avoid those instructions on 32-bit hosts as well.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20200616140217.104362-1-pbonzini@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/Makefile.i386 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
index d801b80..be9d6bc 100644
--- a/x86/Makefile.i386
+++ b/x86/Makefile.i386
@@ -1,6 +1,7 @@
 cstart.o = $(TEST_DIR)/cstart.o
 bits = 32
 ldarch = elf32-i386
+COMMON_CFLAGS += -mno-sse -mno-sse2
 
 cflatobjs += lib/x86/setjmp32.o
 
-- 
2.18.1

