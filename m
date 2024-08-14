Return-Path: <kvm+bounces-24211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 847BF9525E4
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FE82B23DFF
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09D614D708;
	Wed, 14 Aug 2024 22:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="myu9rKTY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E206B144D1A
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 22:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723675300; cv=none; b=g/UPQoQKUUHoTmxbN4Q5wol3pueUwyoyeZctGHBtizV99MVMGnqhbYHv6KbvYdDWPwTYx4dJ9hsGu7hLIB6bfO1JJi4U1eyyIyyz7slBv1aDd+Z1hP7Z+DXYfJwPXdp9zMOtnhMdIw9JrUoXuqUXsnGOtFEgx1gGKEC+LPmaOGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723675300; c=relaxed/simple;
	bh=2aKgGCeRNvlVjTeVgK1GayG6XFPtka9uNDkIqd+wzmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aVlGdGOaTfNh0uHDhKtXnrA1yIMMaYjJi3QukIoBe7nxzUL/0aAa2jYKEXOiykjFnqLQOAE09MxD+PUa8ANqu0g2OdzOpjjFcISHc9IW1GRvOhLnlOanWwup7XfqfQcPKayweU+j00WH9IZU8Co5iG/DBo4KnCFPx7Eh6LdW5Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=myu9rKTY; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fd69e44596so2492285ad.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723675297; x=1724280097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BA0vIbfMo/Ez2DzL8kYXbRUniB5/Y+edtyx+BnopKwA=;
        b=myu9rKTYd0vVhS7mchgjb5cAss/lV5/afEDBQgk+pe8XFAUqGtvL+/hSNJO3XauW3c
         XSfbX+eS88fAeq47K5lrHO/nCMWTDkRHKUmMvQVUggcg8l5HLS+tdc6UFqmI4KH8hL6w
         bcJx50S8UKZnSwPIuyQq9W7P1lQfMCfPTlyUyCnm3RUhUucecHNt6IZ2sEjluUrrv66Q
         91b62clFfYXtdnZmUT14f9icAb8kfPZNUY/yORpW2jKhOmfbRZwgPB6eW8/zXpphr7Po
         QB4TYjPfKT7s2WryrPfY9s07xR6t9CWbzSf3FRJr3QT683XiYseqsIVhkPFUDpl8x6UE
         moiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723675297; x=1724280097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BA0vIbfMo/Ez2DzL8kYXbRUniB5/Y+edtyx+BnopKwA=;
        b=gbsqnyigwCMSrYLIuUzRrUzvRqHEXdH9Rj2jlHWJ7IBSrO7OODmQQs8CNBiH8FMbes
         4xcPTVhDqyDX0wCXrsP4VCUqAuGkT8fVksAoERF4nGpOa7R/R8Ggcz2oZG9+t7tdasaf
         nxU39//4mprowrkxTGw2+WH9J3+7BPeiM3ERUJp5kgDvNKNtEWNJbTF+fp93DQnpjENM
         SmdvF5NmtylP5u20XJDK/7bpAe4ZeEbHjq0vMEse/QjGHuV6tu554S5HlsvtQMeeMh6p
         uM3i7NQBZx3DaJUCfJq9eOTLNdaCRNnkswbYjIHqdXEz8lAhUpug3qZ5mj0rFtrF2uId
         oCCw==
X-Forwarded-Encrypted: i=1; AJvYcCUi/P9fEE67QHTKWgzie3WB37r3Qr5C2C2An/HxY1D1stZuUy0eSQwr8CgvaQcmp1yeCFaZYEdnKdHYbLuZP7wJ+QXS
X-Gm-Message-State: AOJu0YwE1J7AkMyAYKaLDmp4d6XaHPQbrqZxRoJWVAoq78TiEx090c/W
	3OKUs8cTiIq5x7Ac4bf1crgkINV/alJ/JGPchNABZhdXWMZxn0MAdU5X3lv/RdU=
X-Google-Smtp-Source: AGHT+IHLOMuA2xNQUnJ7j4Sv3gvsivnE3ZDnjeWx9uHlBTc7JPSjJLnmaTR7KYUm/tE1ewGigV07vg==
X-Received: by 2002:a17:902:e807:b0:1f9:e2c0:d962 with SMTP id d9443c01a7336-201ee519f73mr13281165ad.31.1723675297099;
        Wed, 14 Aug 2024 15:41:37 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00:5b09:8db7:b002:cf61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03b2874sm1225595ad.308.2024.08.14.15.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 15:41:36 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 1/4] meson: hide tsan related warnings
Date: Wed, 14 Aug 2024 15:41:29 -0700
Message-Id: <20240814224132.897098-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When building with gcc-12 -fsanitize=thread, gcc reports some
constructions not supported with tsan.
Found on debian stable.

qemu/include/qemu/atomic.h:36:52: error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’ [-Werror=tsan]
   36 | #define smp_mb()                     ({ barrier(); __atomic_thread_fence(__ATOMIC_SEQ_CST); })
      |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 meson.build | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 81ecd4bae7c..52e5aa95cc0 100644
--- a/meson.build
+++ b/meson.build
@@ -499,7 +499,15 @@ if get_option('tsan')
                          prefix: '#include <sanitizer/tsan_interface.h>')
     error('Cannot enable TSAN due to missing fiber annotation interface')
   endif
-  qemu_cflags = ['-fsanitize=thread'] + qemu_cflags
+  tsan_warn_suppress = []
+  # gcc (>=11) will report constructions not supported by tsan:
+  # "error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’"
+  # https://gcc.gnu.org/gcc-11/changes.html
+  # However, clang does not support this warning and this triggers an error.
+  if cc.has_argument('-Wno-tsan')
+    tsan_warn_suppress = ['-Wno-tsan']
+  endif
+  qemu_cflags = ['-fsanitize=thread'] + tsan_warn_suppress + qemu_cflags
   qemu_ldflags = ['-fsanitize=thread'] + qemu_ldflags
 endif
 
-- 
2.39.2


