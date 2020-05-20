Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D131DBB3C
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgETRWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:22:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20122 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbgETRW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=yRQKE5e2wt/obw3+N38gkuEi0HDMFjMCRqa7dn5fQ8g=;
        b=GFMuHPZv6PAx2oRyaC5PdAcXlR5fiFvETluInCWzA7bpfx6S+KIKzuoXwB8kaaF347muFA
        W8KZHwtVz1bh0YT2DbvSQ7mnYpmEYUZAoRrzGx7wdQvl6QrFArQ0mvsHELxiDAlPIbL4Ix
        MU7ZfFel7R2Uor/IWjTwADepBXFYNcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-cUNZzNMVNPm2llGsZ97AYQ-1; Wed, 20 May 2020 13:22:22 -0400
X-MC-Unique: cUNZzNMVNPm2llGsZ97AYQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C617385B690;
        Wed, 20 May 2020 17:22:13 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA32C60554;
        Wed, 20 May 2020 17:22:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 22/24] uaccess: add memzero_user
Date:   Wed, 20 May 2020 13:21:43 -0400
Message-Id: <20200520172145.23284-23-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be used from KVM.  Add it to lib/ so that everyone can use it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/uaccess.h |  1 +
 lib/usercopy.c          | 63 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 67f016010aad..bd8c85b50e67 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -232,6 +232,7 @@ __copy_from_user_inatomic_nocache(void *to, const void __user *from,
 #endif		/* ARCH_HAS_NOCACHE_UACCESS */
 
 extern __must_check int check_zeroed_user(const void __user *from, size_t size);
+extern __must_check int memzero_user(void __user *from, size_t size);
 
 /**
  * copy_struct_from_user: copy a struct from userspace
diff --git a/lib/usercopy.c b/lib/usercopy.c
index cbb4d9ec00f2..82997862bf02 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -33,6 +33,69 @@ unsigned long _copy_to_user(void __user *to, const void *from, unsigned long n)
 EXPORT_SYMBOL(_copy_to_user);
 #endif
 
+/**
+ * memzero_user: write zero bytes to a userspace buffer
+ * @from: Source address, in userspace.
+ * @size: Size of buffer.
+ *
+ * This is effectively shorthand for "memset(from, 0, size)" for
+ * userspace addresses.
+ *
+ * Returns:
+ *  * 0: zeroes have been written to the buffer
+ *  * -EFAULT: access to userspace failed.
+ */
+int memzero_user(void __user *from, size_t size)
+{
+	unsigned long val = 0;
+	unsigned long mask = 0;
+	uintptr_t align = (uintptr_t) from % sizeof(unsigned long);
+
+	if (unlikely(size == 0))
+		return 0;
+
+	from -= align;
+	size += align;
+
+	if (!user_access_begin(from, ALIGN_UP(size, sizeof(unsigned long))))
+		return -EFAULT;
+
+	if (align) {
+		unsafe_get_user(val, (unsigned long __user *) from, err_fault);
+		/* Prepare a mask to keep the first "align" bytes.  */
+		mask = aligned_byte_mask(align);
+	}
+
+	if (size >= sizeof(unsigned long)) {
+		/* The mask only applies to the first full word.  */
+		val &= mask;
+		mask = 0;
+		do {
+			unsafe_put_user(val, (unsigned long __user *) from, err_fault);
+			from += sizeof(unsigned long);
+			size -= sizeof(unsigned long);
+			val = 0;
+		} while (size >= sizeof(unsigned long));
+
+		if (!size)
+			goto done;
+		unsafe_get_user(val, (unsigned long __user *) from, err_fault);
+	}
+
+	/* Bytes after the first "size" have to be kept too. */
+	mask |= ~aligned_byte_mask(size);
+	val &= mask;
+	unsafe_put_user(val, (unsigned long __user *) from, err_fault);
+
+done:
+	user_access_end();
+	return 0;
+err_fault:
+	user_access_end();
+	return -EFAULT;
+}
+EXPORT_SYMBOL(memzero_user);
+
 /**
  * check_zeroed_user: check if a userspace buffer only contains zero bytes
  * @from: Source address, in userspace.
-- 
2.18.2


