Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6121B1148
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 18:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgDTQRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 12:17:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29563 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726061AbgDTQRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 12:17:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587399467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aVmMlP4bgEOgyhPBBrYrGgIG5tzuNNZSz4+8vsE0HJo=;
        b=HnLsVv5lsKBB1lu5s0gWnTn0S1z5AGyTKHoNbNRCDt0jgZPucd4D4QFySgkMPDxtgB7Xh4
        yWcXj6/yndTR4sYJuo824bX53dbQ0oyAzndD3SGPOkIum33OQ9g4UjFI1pGrRlY8WNEhOq
        c8Wm/r8upuEF3+70pZ82tcYpvvg8faY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-4C7849F1MoOjHETHB0DVtQ-1; Mon, 20 Apr 2020 12:17:45 -0400
X-MC-Unique: 4C7849F1MoOjHETHB0DVtQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33106190B2B3;
        Mon, 20 Apr 2020 16:17:44 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-8.rdu2.redhat.com [10.10.116.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA1295C64E;
        Mon, 20 Apr 2020 16:17:41 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] kvm: Disable objtool frame pointer checking for vmenter.S
Date:   Mon, 20 Apr 2020 11:17:37 -0500
Message-Id: <01fae42917bacad18be8d2cbc771353da6603473.1587398610.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Frame pointers are completely broken by vmenter.S because it clobbers
RBP:

  arch/x86/kvm/svm/vmenter.o: warning: objtool: __svm_vcpu_run()+0xe4: BP=
 used as a scratch register

That's unavoidable, so just skip checking that file when frame pointers
are configured in.

On the other hand, ORC can handle that code just fine, so leave objtool
enabled in the !FRAME_POINTER case.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/kvm/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index a789759b7261..4a3081e9f4b5 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -3,6 +3,10 @@
 ccflags-y +=3D -Iarch/x86/kvm
 ccflags-$(CONFIG_KVM_WERROR) +=3D -Werror
=20
+ifeq ($(CONFIG_FRAME_POINTER),y)
+OBJECT_FILES_NON_STANDARD_vmenter.o :=3D y
+endif
+
 KVM :=3D ../../../virt/kvm
=20
 kvm-y			+=3D $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
--=20
2.21.1

