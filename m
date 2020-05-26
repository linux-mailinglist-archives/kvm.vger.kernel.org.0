Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C051D55BF
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 18:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgEOQTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 12:19:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27396 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbgEOQTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 12:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589559563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=jyrqhLt/j8WM6W25F/4nHaguhXzjEnraWUNGaaQDntQ=;
        b=HmK6qg17Ccbj1VqTmlNjtnQIF62j/aZJt7g2A7B96DNMXHykGZx6GOZf8igysrGDFQCpf6
        Gzk6bbGqh6yLOJ4SAjSzZVq5jFJr+W6SvoJ+wYEQc7Vlh++cIx9TXbNrKNqOvdHr1dkGPE
        BtE6CSWily9GSYA/kLFOiOyJy6zydkI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-bqPGaupuNxmS7POCrWErMQ-1; Fri, 15 May 2020 12:19:21 -0400
X-MC-Unique: bqPGaupuNxmS7POCrWErMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2079818FF661;
        Fri, 15 May 2020 16:19:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF12A79B6;
        Fri, 15 May 2020 16:19:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: emulate reserved nops from 0f/18 to 0f/1f
Date:   Fri, 15 May 2020 12:19:19 -0400
Message-Id: <20200515161919.29249-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instructions starting with 0f18 up to 0f1f are reserved nops, except those
that were assigned to MPX.  These include the endbr markers used by CET.
List them correctly in the opcode table.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index de5476f8683e..d0e2825ae617 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4800,8 +4800,12 @@ static const struct opcode twobyte_table[256] = {
 	GP(ModRM | DstReg | SrcMem | Mov | Sse, &pfx_0f_10_0f_11),
 	GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_10_0f_11),
 	N, N, N, N, N, N,
-	D(ImplicitOps | ModRM | SrcMem | NoAccess),
-	N, N, N, N, N, N, D(ImplicitOps | ModRM | SrcMem | NoAccess),
+	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 4 * prefetch + 4 * reserved NOP */
+	D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
+	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 8 * reserved NOP */
+	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 8 * reserved NOP */
+	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 8 * reserved NOP */
+	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* NOP + 7 * reserved NOP */
 	/* 0x20 - 0x2F */
 	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_read),
 	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, dr_read, check_dr_read),
-- 
2.18.2

