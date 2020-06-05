Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7466E1EFAD0
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 16:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgFEOVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 10:21:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20110 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728970AbgFEOUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 10:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591366838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tYrH+EqixLCGC0o9Vgv8h3T7kXXMELTRVth7woAonUk=;
        b=ZcD+SvbYI+xwFHK8R/lo6oC7BSQikOCWkpYy/QFUOWXxYHTg8+/nauHUVwaBBNv05/3RTz
        jqN98n6Nfa9shlAVK0l/ICC5otmSqnuceWVUyOaS5df9LG8J0QdnSEMaHoKtAJ12IK2VDz
        sth0q32TpNIE15OAoZxFx4+FCuxrOFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-Dy9Io7yKN9-dp3U52YM0uA-1; Fri, 05 Jun 2020 10:20:37 -0400
X-MC-Unique: Dy9Io7yKN9-dp3U52YM0uA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91AEB1005510;
        Fri,  5 Jun 2020 14:20:35 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6B2E6292E;
        Fri,  5 Jun 2020 14:20:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: Fix "make ARCH=x86_64" build with
Date:   Fri,  5 Jun 2020 16:20:28 +0200
Message-Id: <20200605142028.550068-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marcelo reports that kvm selftests fail to build with
"make ARCH=x86_64":

gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99
 -fno-stack-protector -fno-PIE -I../../../../tools/include
 -I../../../../tools/arch/x86_64/include  -I../../../../usr/include/
 -Iinclude -Ilib -Iinclude/x86_64 -I.. -c lib/kvm_util.c
 -o /var/tmp/20200604202744-bin/lib/kvm_util.o

In file included from lib/kvm_util.c:11:
include/x86_64/processor.h:14:10: fatal error: asm/msr-index.h: No such
 file or directory

 #include <asm/msr-index.h>
          ^~~~~~~~~~~~~~~~~
compilation terminated.

"make ARCH=x86", however, works. The problem is that arch specific headers
for x86_64 live in 'tools/arch/x86/include', not in
'tools/arch/x86_64/include'.

Fixes: 66d69e081b52 ("selftests: fix kvm relocatable native/cross builds and installs")
Reported-by: Marcelo Bandeira Condotta <mcondotta@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index b4ff112e5c7e..4a166588d99f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -83,7 +83,11 @@ LIBKVM += $(LIBKVM_$(UNAME_M))
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
+ifeq ($(ARCH),x86_64)
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
+else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
+endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-- 
2.25.4

