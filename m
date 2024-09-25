Return-Path: <kvm+bounces-27479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D318986560
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDA601C2408B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF27A13BAC3;
	Wed, 25 Sep 2024 17:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mYTSXDzt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044884AEF2
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284312; cv=none; b=V7n/XShk5pPWx0ReEzKMLrXJOMVsJo/DMgr1KlOInXyrObag2E4J7ygzRJ20dNt9mD65ZeI43utB24xcy8ESWemFIT491WvGoF2tsow0uvU3ZJMg3wZmAUENZYaiLve36ztQq9++Z+mBHsbl7GHJo/8BTygxignH/1el6gxAcmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284312; c=relaxed/simple;
	bh=28vXbYY3NnUgjx+dHCeL74DCpQMF3AD60aLX+nWUK6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K25rDWhH7u12tvkx8C4hneoI/Vvgcpqax3t1at4yON+gIbo65UOb53VhvcSyepAY3cytQofhtyc7YYTsPu9NAQtNAyTegRgU8H/NF7Fhr6QcU3q6FjqJfW5kVPnSFlyQbRFZlJu2/4o8J/JD0T9Wczxue5QBvfgAu1Xi3TX2wtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mYTSXDzt; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42cc43454d5so132285e9.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284309; x=1727889109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycFC3pmsoWssj1+GB+z++1OZtt6It3e2DUWkH7pV350=;
        b=mYTSXDztzTdHz94iYoZLa19eBc/VXpRnIZqWNK3p44rjh8sPU7ohtg3SBIxwu72V+Z
         yD4LvqiWg7+vchk03luH8kfrjhBWAIElqGHRzm8cudAx2/tM6mSTz0QjyqBkvdRcxKPZ
         sLfzRZc1TKQ1M3hCPHQ3XcqQk/HqJKFb5nKs0Pl3Oi8Sn8ZOEs0x1MoaRcc0+cpOjmHM
         m1PnRzLWriBEQsvCn1Dqh1u7tI76oeHUar9moRI8H112LeJl+LAW7+X6h1xnff6N3Esr
         iXKIEc5HW2c0RnROiMNflRkRQWcser36Nnk2z2jSUVUwkVsofna87gISFFXN9aRZaUeT
         QqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284309; x=1727889109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ycFC3pmsoWssj1+GB+z++1OZtt6It3e2DUWkH7pV350=;
        b=o+YPMKFyhBGtu8Ql6TXYmE1LcOo5WTMGEBSDMaS301ERfiYgsjKk9m6WXdqr+1bRUS
         6/VsTORsRh1xYTc7nCdaYCo70T5AuMwtP5GwzEG8u5Qn3yT1VT6sfnE8uNk7/XoOBOgK
         czNluepsV2z6B5VD5UtG/Y98PHoI9Dfu1tRi08jHJhVY/+eLd92LEwIKpXZM3m4afn7q
         06SE8VR6GC33w99TD4OqJjre+dJdahe7Vbhwqz9Cn9oe0PU44CuEX2BKocj7lh/I14RO
         +MkHoAdw94ut0/tQrcnNdG7QIp662IhkY8QlXinYCv3VpBezUkBg7waWnpSJikAmkdp7
         4/vg==
X-Forwarded-Encrypted: i=1; AJvYcCVQJp3tWV5nwNca8Kcjscam2ZfAQ+MP4PLpkljypMOkAMRA9KHhUUQ+cTNzSqccblwKCqY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpM0cydtoFmb06/5vE75Z83B7TI0zWSejonClCDmfkQfK4k36k
	xlFwD3mll3Sd64G9oACq7fF8bZs71NeM8twygEG083jjzlCsd++1OZ3b6LQZifA=
X-Google-Smtp-Source: AGHT+IFRxeZoSgBmmopQctlKDB9ApqhA+1oJ+LWS6CG6+0s5NaCxN5dtRqAGt/nMi5ztrLWq2e6P4w==
X-Received: by 2002:a05:600c:1c05:b0:426:6158:962d with SMTP id 5b1f17b1804b1-42e961445d3mr23154945e9.23.1727284309232;
        Wed, 25 Sep 2024 10:11:49 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e902560cfsm56646345e9.0.2024.09.25.10.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:45 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id CA71C5FA36;
	Wed, 25 Sep 2024 18:11:40 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	kvm@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	devel@lists.libvirt.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	Beraldo Leal <bleal@redhat.com>
Subject: [PATCH 05/10] meson: hide tsan related warnings
Date: Wed, 25 Sep 2024 18:11:35 +0100
Message-Id: <20240925171140.1307033-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240925171140.1307033-1-alex.bennee@linaro.org>
References: <20240925171140.1307033-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierrick Bouvier <pierrick.bouvier@linaro.org>

When building with gcc-12 -fsanitize=thread, gcc reports some
constructions not supported with tsan.
Found on debian stable.

qemu/include/qemu/atomic.h:36:52: error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’ [-Werror=tsan]
   36 | #define smp_mb()                     ({ barrier(); __atomic_thread_fence(__ATOMIC_SEQ_CST); })
      |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20240910174013.1433331-2-pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 meson.build | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 10464466ff..ceee6b22c8 100644
--- a/meson.build
+++ b/meson.build
@@ -518,7 +518,15 @@ if get_option('tsan')
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
2.39.5


