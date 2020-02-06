Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2DD154906
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgBFQYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:24:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27779 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727392AbgBFQYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:24:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVn3KA9sEn9fMwY63Oid8rmv0wn5jHhT2Lb83C9NoNE=;
        b=XCj9pxPAnCNaGUI33Qpro8K8DYJOss1vDDsOFcWoL9YcUc9agTzT+mcN2JQfyXJIyMge6V
        NORzJi8yQkte0Zq63KyqS73LeQu+LrC3cdYKP91MrVAEoq6NqS231lMROEemE0hDrLWPGU
        ehUF9qemR6ODiZTuT67jw0cYsJ8Q0QA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-lLGbsx5PPqO-h-8cZbfiCw-1; Thu, 06 Feb 2020 11:24:41 -0500
X-MC-Unique: lLGbsx5PPqO-h-8cZbfiCw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FCDA800D54;
        Thu,  6 Feb 2020 16:24:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A20A91001B05;
        Thu,  6 Feb 2020 16:24:36 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>,
        Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PULL kvm-unit-tests 01/10] Makefile: Use no-stack-protector compiler options
Date:   Thu,  6 Feb 2020 17:24:25 +0100
Message-Id: <20200206162434.14624-2-drjones@redhat.com>
In-Reply-To: <20200206162434.14624-1-drjones@redhat.com>
References: <20200206162434.14624-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
2.21.1

