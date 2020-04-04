Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98C19E5AC
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgDDOh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:37:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34679 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726248AbgDDOh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:37:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4TH7o6uPii+FVWXIRQDwrHwi8uTL0Zd9SNThpzh1Yhs=;
        b=axxVR5v+RL5nxtCS+ru3FnMTEtQpustGR9fQVFKCglWZqyLQQJTcaxAsqgwqjA4fsWgBB2
        y+9J6UxaJ24KDMMa7BlZQqptjJsr3Y6xPG/OAUMhxhehpEp2e8bUaw66eXWC8+dccjoVdW
        NmLSD/l6TAgWVeA5/xopP4Qyk/CTXyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-jqwY0IBlPfCljN1pw65vkw-1; Sat, 04 Apr 2020 10:37:53 -0400
X-MC-Unique: jqwY0IBlPfCljN1pw65vkw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CD5B107B113;
        Sat,  4 Apr 2020 14:37:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42CBA9B912;
        Sat,  4 Apr 2020 14:37:35 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PULL kvm-unit-tests 01/39] Makefile: Use no-stack-protector compiler options
Date:   Sat,  4 Apr 2020 16:36:53 +0200
Message-Id: <20200404143731.208138-2-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Let's fix the typos so that the -fno-stack-protector and
-fno-stack-protector-all compiler options are actually used.

Tested by compiling for arm64, x86_64 and ppc64 little endian. Before the
patch, the arguments were missing from the gcc invocation; after the patc=
h,
they were present. Also fixes a compilation error that I was seeing with
aarch64 gcc version 9.2.0, where the linker was complaining about an
undefined reference to the symbol __stack_chk_guard.

Fixes: e5c73790f5f0 ("build: don't reevaluate cc-option shell command")
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Drew Jones <drjones@redhat.com>
CC: Laurent Vivier <lvivier@redhat.com>
CC: Thomas Huth <thuth@redhat.com>
CC: David Hildenbrand <david@redhat.com>
CC: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Laurent Vivier <lvivier@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 767b6c6a51d0..754ed65ecd2f 100644
--- a/Makefile
+++ b/Makefile
@@ -55,8 +55,8 @@ COMMON_CFLAGS +=3D -Wignored-qualifiers -Werror
=20
 frame-pointer-flag=3D-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointe=
r
 fomit_frame_pointer :=3D $(call cc-option, $(frame-pointer-flag), "")
-fnostack_protector :=3D $(call cc-option, -fno-stack-protector, "")
-fnostack_protector_all :=3D $(call cc-option, -fno-stack-protector-all, =
"")
+fno_stack_protector :=3D $(call cc-option, -fno-stack-protector, "")
+fno_stack_protector_all :=3D $(call cc-option, -fno-stack-protector-all,=
 "")
 wno_frame_address :=3D $(call cc-option, -Wno-frame-address, "")
 fno_pic :=3D $(call cc-option, -fno-pic, "")
 no_pie :=3D $(call cc-option, -no-pie, "")
--=20
2.25.1

