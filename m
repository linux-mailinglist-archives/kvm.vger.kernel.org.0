Return-Path: <kvm+bounces-11905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 447C387CBA8
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 11:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AC58283383
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 10:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0DE31B7FB;
	Fri, 15 Mar 2024 10:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJZFsfp3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D7B1B7E5
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 10:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710500112; cv=none; b=i70sKt6aIVEvA79j0FWfwOhmWIXHlnevCsCbKnUSeHI6wq3FLl+L18v2Z3b6ALgY2+gHZ6lZK/2AQmLvvIM2bA9BeW62KOKvRz5V5/gEMJy9Cq8W+ugj9a2lnpf+Xo+c9hWmuTrg+op1wDfg6qIgWSjFl/hy2lAeSpdqunbKt00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710500112; c=relaxed/simple;
	bh=egKFcFy18uI/dVjWoyZvuW3VcQWXWF1qul2r340oNl0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=nTJWqK+b6nuP6/zWZdoeNDNecyX9CnhhwopsHgxJHxCLYvgEFIwmNerhHlw4dmuBQSXXu4+r9zf6a/62tAWlAibGDwdOz3yfyo+ofsiCl1qA23FsVuXhRLOx4XXfonverIw1ke7wf/kN+MpZlqSdqPmrlxN0Z5fE6fa8f+5+zPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJZFsfp3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710500110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WKnajArjwdqkW9mul8mVcKUVfLxGaXnxMQu51jtLd0s=;
	b=EJZFsfp3CZHFnvO5glH25XjBBOko4LOi+0BBJIsomhb5ru+FY0l5b+Nv0ITUFW/8/nH46Z
	Ob4d7fmnCF0oGCVrFzeEQWRi9iPntwlBIIOSHJUgX28ZYBPL4rTG4oLC+Et9GGwEJoXaJC
	Yu1F3CUUsDr80DiVf6E4Z9ELtsf8Ykk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495--O4F-DR8Na-mU1jF5OHwsA-1; Fri, 15 Mar 2024 06:55:08 -0400
X-MC-Unique: -O4F-DR8Na-mU1jF5OHwsA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8513851780;
	Fri, 15 Mar 2024 10:55:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8484492BD0;
	Fri, 15 Mar 2024 10:55:07 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH] selftests: kvm: remove meaningless assignments in Makefiles
Date: Fri, 15 Mar 2024 06:55:07 -0400
Message-Id: <20240315105507.2519851-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

$(shell ...) expands to the output of the command. It expands to the
empty string when the command does not print anything to stdout.
Hence, $(shell mkdir ...) is sufficient and does not need any
variable assignment in front of it.

Commit c2bd08ba20a5 ("treewide: remove meaningless assignments in
Makefiles", 2024-02-23) did this to all of tools/ but ignored in-flight
changes to tools/testing/selftests/kvm/Makefile, so reapply the change.

Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 19f5710bb456..741c7dc16afc 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -277,7 +277,7 @@ TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBKVM_OBJS))
 TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TEST_GEN_OBJ))
 -include $(TEST_DEP_FILES)
 
-x := $(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
+$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
 
 $(filter-out $(SPLIT_TEST_GEN_PROGS), $(TEST_GEN_PROGS)) \
 $(TEST_GEN_PROGS_EXTENDED): %: %.o
@@ -309,7 +309,7 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
 $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
 
-x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
+$(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 $(SPLIT_TEST_GEN_OBJ): $(GEN_HDRS)
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
-- 
2.39.1


