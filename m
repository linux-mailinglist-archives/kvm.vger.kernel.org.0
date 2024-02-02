Return-Path: <kvm+bounces-7822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8299F8468E2
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 367A7283FC6
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 07:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6471863B;
	Fri,  2 Feb 2024 06:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MdPPs7wn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D8818633;
	Fri,  2 Feb 2024 06:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857152; cv=none; b=YCFxfUJOZLIbusBXXnemMHaZNbPhFBHySlvCJC4KDstiqTTyPfs0a5LexM2oAq9qc6AcWWr0Iu9tsXt9z2k9hKNabUdUtdCEN0HbDIHtVHO8ba9m0hs+5YRGMhBGtbvHYlEfE+t+UI5vkPksobU7O38OmbbSzPI7GB8Pi+j9dXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857152; c=relaxed/simple;
	bh=6JbG9et4ggNViHk+xpnp84ZGRBT58T7v98W3F6J80+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQLYp/q6Fm5dD4SISicFOl1Iy16tKCEzn2i4mwLZ9wqSaxAuaX3ESEY4ozoPzkTHKJQOYrAHmn3LhopUav+ZobM61+esTTO0jtsbXn2BLlg2qN0bnHj+PxcpVdUU/ZvE5hGh0tOmK4uKAly6XinSfzKCiFCZBwMpwapVba1ZlTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MdPPs7wn; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5c229dabbb6so1109599a12.0;
        Thu, 01 Feb 2024 22:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857150; x=1707461950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2A8b0YOIg6lGChxKQRkSufzy4suZ23mRhNBzFJEEdSM=;
        b=MdPPs7wnGcwVQaczChjld4M5qdezWMBJaNJmIRz9q/HWczQ8mnAtAq38Kxv24Xtdub
         WebusI/3P4mDjNxsTl0DG3hxibf1J0dR71ztkDgKWkn+SB55XK+84zH/zglCNnuTvXq2
         izjva+zcevqFmN9bg2RCPk3DNA+wlamRxmtjXCYsW6nEqwqYCl25eYtxcz3iJd7Y2KjO
         1hllkFiqdSJTMev15x86y9x7v5H5D6rrCImGVpYTD82HLoIz4b8cuUL+QELGvKCTOr+9
         NKnkD8VmGwug/4O3C/yby4U7e6Gvs439HstWcRgUm8XVCPc1izlE/HITN7/DybxFHuA8
         ircA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857150; x=1707461950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2A8b0YOIg6lGChxKQRkSufzy4suZ23mRhNBzFJEEdSM=;
        b=v+zanfytUrh9LUBQHDqVY8Z1yubOJjTBkiJUN74iOc9jvuI0Or6BhCu8SjW695KdRC
         uP4vSU2ky921ki4w6nKT2d1Q/v2WSNSi9G5+5bZm/9BLZzq5tD/ODGKRFtegVYWrrlr5
         BuudCsME6Tv5hACKsy7GezdPhFE23TnXAcLXIAXBqkKaSr5x5/ZX87/nd4XxAXTmnABC
         LWfoaTURRaQfQVTP0fgXC8oiHuh1Ij3F+W/cqXeEHzrPGv7YOP2GxRQBtbfnZaTqFzxZ
         HFI7hu8R9qkxuYBgvi5drs4NUtB/C4xkPSJgUg+SIVNoj3znNqPxYNq8jfxAVci13S9E
         73Xw==
X-Gm-Message-State: AOJu0YwByqbxaWKZvohTi6d+L8xFqfkMj8X84bWIrR+c/UBzARsitm9J
	oDOJh7k/8npNkB9MCfrF5HUr0o9X116HJCiFgPe8symePI65acIN
X-Google-Smtp-Source: AGHT+IEFt7kfJGu61jZUZZl3OY3s2dKrBdsO6NiQuZ9E3dIRck/n/RDkAL+FrMyrpMKk6m8nizxRPw==
X-Received: by 2002:a17:902:7c97:b0:1d8:fae3:2216 with SMTP id y23-20020a1709027c9700b001d8fae32216mr5679839pll.35.1706857150341;
        Thu, 01 Feb 2024 22:59:10 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUYncYvmvYyn1bIo4nQyp/+E/FnRz/SeAmt64eUXq2CiSJIqXGaPkB7FxwGpzIlNiEzEzB+LkGRAgVN2ozGXSgcLqCVtAOixnufvjh5CF4R7/qutE1ZgrgE8KPEDt4fEwlzL5vi4cWxKE2403WAfOQvf2qfTnsOZzjq6Bmn0UG5URuvkXMko5RrllOPDZ6rWDnfJe/g/oThk6+GyqcslLMVeLxnrFBw8vNdmX7qajZ8/TLHzwe4MC82JvQe07k0oMntr18YdbhE4iIh2XZVXmUOqvb/OUVvkCBThcjEti0ruRHPUECZ6k6xtj42LMpSwYOklQ9yQrKG5eg1EI/PkK11hDlHCljnGJcrbLlaaeWFCOQqUIS36VObLTPRw2jRtK0FVwVPAm9AWYvxfHOoGpAtpmnBkf8oFFpaUF//HU8VfpLXiNqo3RpxpdXdPQIsTmbOtlx+UbGTdVN/GI9VfcohRq7mEAffaqJs/ZAwZ5xRv1zdOrnEkFhJGpUJORVnhWanLA8LXQ7azRg=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:59:10 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 8/9] Add common/ directory for architecture-independent tests
Date: Fri,  2 Feb 2024 16:57:39 +1000
Message-ID: <20240202065740.68643-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

x86/sieve.c is used by s390x and arm via symbolic link. Make a new
directory common/ for architecture-independent tests and move
sieve.c here.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/sieve.c    |  2 +-
 common/sieve.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/sieve.c  |  2 +-
 x86/sieve.c    | 52 +-------------------------------------------------
 4 files changed, 54 insertions(+), 53 deletions(-)
 create mode 100644 common/sieve.c
 mode change 100644 => 120000 x86/sieve.c

diff --git a/arm/sieve.c b/arm/sieve.c
index 8f14a5c3..fe299f30 120000
--- a/arm/sieve.c
+++ b/arm/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/common/sieve.c b/common/sieve.c
new file mode 100644
index 00000000..8150f2d9
--- /dev/null
+++ b/common/sieve.c
@@ -0,0 +1,51 @@
+#include "alloc.h"
+#include "libcflat.h"
+
+static int sieve(char* data, int size)
+{
+    int i, j, r = 0;
+
+    for (i = 0; i < size; ++i)
+	data[i] = 1;
+
+    data[0] = data[1] = 0;
+
+    for (i = 2; i < size; ++i)
+	if (data[i]) {
+	    ++r;
+	    for (j = i*2; j < size; j += i)
+		data[j] = 0;
+	}
+    return r;
+}
+
+static void test_sieve(const char *msg, char *data, int size)
+{
+    int r;
+
+    printf("%s:", msg);
+    r = sieve(data, size);
+    printf("%d out of %d\n", r, size);
+}
+
+#define STATIC_SIZE 1000000
+#define VSIZE 100000000
+char static_data[STATIC_SIZE];
+
+int main(void)
+{
+    void *v;
+    int i;
+
+    printf("starting sieve\n");
+    test_sieve("static", static_data, STATIC_SIZE);
+    setup_vm();
+    test_sieve("mapped", static_data, STATIC_SIZE);
+    for (i = 0; i < 3; ++i) {
+	v = malloc(VSIZE);
+	test_sieve("virtual", v, VSIZE);
+	free(v);
+    }
+
+    return 0;
+}
diff --git a/s390x/sieve.c b/s390x/sieve.c
index 8f14a5c3..fe299f30 120000
--- a/s390x/sieve.c
+++ b/s390x/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/x86/sieve.c b/x86/sieve.c
deleted file mode 100644
index 8150f2d9..00000000
--- a/x86/sieve.c
+++ /dev/null
@@ -1,51 +0,0 @@
-#include "alloc.h"
-#include "libcflat.h"
-
-static int sieve(char* data, int size)
-{
-    int i, j, r = 0;
-
-    for (i = 0; i < size; ++i)
-	data[i] = 1;
-
-    data[0] = data[1] = 0;
-
-    for (i = 2; i < size; ++i)
-	if (data[i]) {
-	    ++r;
-	    for (j = i*2; j < size; j += i)
-		data[j] = 0;
-	}
-    return r;
-}
-
-static void test_sieve(const char *msg, char *data, int size)
-{
-    int r;
-
-    printf("%s:", msg);
-    r = sieve(data, size);
-    printf("%d out of %d\n", r, size);
-}
-
-#define STATIC_SIZE 1000000
-#define VSIZE 100000000
-char static_data[STATIC_SIZE];
-
-int main(void)
-{
-    void *v;
-    int i;
-
-    printf("starting sieve\n");
-    test_sieve("static", static_data, STATIC_SIZE);
-    setup_vm();
-    test_sieve("mapped", static_data, STATIC_SIZE);
-    for (i = 0; i < 3; ++i) {
-	v = malloc(VSIZE);
-	test_sieve("virtual", v, VSIZE);
-	free(v);
-    }
-
-    return 0;
-}
diff --git a/x86/sieve.c b/x86/sieve.c
new file mode 120000
index 00000000..fe299f30
--- /dev/null
+++ b/x86/sieve.c
@@ -0,0 +1 @@
+../common/sieve.c
\ No newline at end of file
-- 
2.42.0


