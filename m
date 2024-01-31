Return-Path: <kvm+bounces-7607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CBE844B3C
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:50:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6444F291E8B
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 22:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C283A8CA;
	Wed, 31 Jan 2024 22:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Joqiy+3I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414D13A1AC
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 22:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706741418; cv=none; b=TBD98ZBpJV/4X47i30u+MOmJHeQ0QpNFSyQSWNYKP35CRHIgTDfo3Y4poYTAg25be0YgVYbyKw5crfFydxWszLCwOY5Taib/5921HHUL+Ro73syxgKzvPwdtkGyuMo+kfeJ5abSNpzKOLUna51JupHvtqH1zqM4KX8V8X5u7eOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706741418; c=relaxed/simple;
	bh=Lpb3WwW/AoBdR5r08zXNH24gj3WmL9Y6tGHn7yyMmas=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mjF32SpqKGMpIQwt7xepJV0xJB6SM4SC17hXUr8GD9ehEMlXO3Ri4OTW0vEJHhDcZNsOz0boUKnr3I010tTkcJLoeYFjenF5+u+HRvjjnY3Levlso4ULb0Du+pGOLP33ZW/Ef18yBGc9ridrfoht0tGvqi5gS+QUz5iuvC1SAdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Joqiy+3I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706741415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8s9Z4w0oeoXTNZwVmUdV7m8lOeT75qbXwsQyi6Cf5T8=;
	b=Joqiy+3I8OtPd7zti6MIWAlZVBBANtCbLe/0XwxJ/QdKBluBnzr6gx/KEntViRhbNqd0/G
	+j6UpMKRTNidN97dmegjZWFQF5UEyfUc7uiyseFirJ2AE73tT4Wt1iVDiEDMn82d+Qw/uX
	sZXr13D65xhPwojOnvBsK5ItB9tGD7Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-JX0H0HIiNS2UuuLmby9pVA-1; Wed, 31 Jan 2024 17:50:11 -0500
X-MC-Unique: JX0H0HIiNS2UuuLmby9pVA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 320F58493E5;
	Wed, 31 Jan 2024 22:50:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10D9C2166B31;
	Wed, 31 Jan 2024 22:50:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: dionnaglaze@google.com,
	seanjc@google.com
Subject: [PATCH 1/3] uapi: introduce uapi-friendly macros for GENMASK
Date: Wed, 31 Jan 2024 17:50:08 -0500
Message-Id: <20240131225010.2872733-2-pbonzini@redhat.com>
In-Reply-To: <20240131225010.2872733-1-pbonzini@redhat.com>
References: <20240131225010.2872733-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Move __GENMASK and __GENMASK_ULL from include/ to include/uapi/ so that they can
be used to define masks in userspace API headers.  Compared to what is already
in include/linux/bits.h, the definitions need to use the uglified versions of
UL(), ULL(), BITS_PER_LONG and BITS_PER_LONG_LONG (which did not even exist),
but otherwise expand to the same content.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/bits.h                   |  8 +-------
 include/uapi/asm-generic/bitsperlong.h |  4 ++++
 include/uapi/linux/bits.h              | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 7 deletions(-)
 create mode 100644 include/uapi/linux/bits.h

diff --git a/include/linux/bits.h b/include/linux/bits.h
index 7c0cf5031abe..0eb24d21aac2 100644
--- a/include/linux/bits.h
+++ b/include/linux/bits.h
@@ -4,6 +4,7 @@
 
 #include <linux/const.h>
 #include <vdso/bits.h>
+#include <uapi/linux/bits.h>
 #include <asm/bitsperlong.h>
 
 #define BIT_MASK(nr)		(UL(1) << ((nr) % BITS_PER_LONG))
@@ -30,15 +31,8 @@
 #define GENMASK_INPUT_CHECK(h, l) 0
 #endif
 
-#define __GENMASK(h, l) \
-	(((~UL(0)) - (UL(1) << (l)) + 1) & \
-	 (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
 #define GENMASK(h, l) \
 	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
-
-#define __GENMASK_ULL(h, l) \
-	(((~ULL(0)) - (ULL(1) << (l)) + 1) & \
-	 (~ULL(0) >> (BITS_PER_LONG_LONG - 1 - (h))))
 #define GENMASK_ULL(h, l) \
 	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_ULL(h, l))
 
diff --git a/include/uapi/asm-generic/bitsperlong.h b/include/uapi/asm-generic/bitsperlong.h
index 352cb81947b8..fadb3f857f28 100644
--- a/include/uapi/asm-generic/bitsperlong.h
+++ b/include/uapi/asm-generic/bitsperlong.h
@@ -24,4 +24,8 @@
 #endif
 #endif
 
+#ifndef __BITS_PER_LONG_LONG
+#define __BITS_PER_LONG_LONG 64
+#endif
+
 #endif /* _UAPI__ASM_GENERIC_BITS_PER_LONG */
diff --git a/include/uapi/linux/bits.h b/include/uapi/linux/bits.h
new file mode 100644
index 000000000000..3c2a101986a3
--- /dev/null
+++ b/include/uapi/linux/bits.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* bits.h: Macros for dealing with bitmasks.  */
+
+#ifndef _UAPI_LINUX_BITS_H
+#define _UAPI_LINUX_BITS_H
+
+#define __GENMASK(h, l) \
+        (((~_UL(0)) - (_UL(1) << (l)) + 1) & \
+         (~_UL(0) >> (__BITS_PER_LONG - 1 - (h))))
+
+#define __GENMASK_ULL(h, l) \
+        (((~_ULL(0)) - (_ULL(1) << (l)) + 1) & \
+         (~_ULL(0) >> (__BITS_PER_LONG_LONG - 1 - (h))))
+
+#endif /* _UAPI_LINUX_BITS_H */
-- 
2.39.0



