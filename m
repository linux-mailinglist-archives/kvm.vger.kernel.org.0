Return-Path: <kvm+bounces-5541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A6482334A
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD314285E25
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AABBA1C6A8;
	Wed,  3 Jan 2024 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CLKRlSit"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394141C293
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40d2376db79so95776635e9.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303231; x=1704908031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rOpjk5Xc89URXPry+uTcPrYjjlL9ZRbEnDqtNUUFVo4=;
        b=CLKRlSit49QwMjia8A9mQ/z1sP8zRCuWmyw30fJCvmdr59rEHCmgPkjkCE0rbSIEHM
         +fLvzkO1T8UQuCCuZKizDam0ILN0S3cJCi4msYPy1aeKarLOR2PtvMsyIluy31SzIjFe
         ksOztKdcWxPA/cWHP3DSGoswgPM8+Mm3bZVk4dUtcu+9PLZrChIzIUpDw+jlrdYxVUvm
         1KIvVwBuPvytb+jLqSm+2evH/ohxlED0NrIs2OkvbYWLW8T0pEQtewpkXvAXmPVM+dXD
         7EStLARuUrud2xWqttJhZ3gP+Q2yVTEK7qJ0Alx52sLAMeT2RoBxszthwcqU9K2daoUT
         qngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303231; x=1704908031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rOpjk5Xc89URXPry+uTcPrYjjlL9ZRbEnDqtNUUFVo4=;
        b=NF4ZQ7rCA33JdA780k7FerIdr4vyzTUx0JDNAmjLi73zIeFgn86tSTOInL4x+4Nt6m
         /dsipnNrCimO11E9lgjemnL+1o6opgJf7ZQpsvk3vMX1IG2GGWAm2zEE0phK0IdHMRrg
         2rxd9eji1ovSnjfYwdDsjeIwnGrNLc6YSmXwoXi/hjb0YN1p8JxvWmXiAR4YRoXcSxVQ
         GBJbReitKarfPqSf/0wnaMtSceiBnlQroyVyzP+likqlvc/A5D6C9amu50VuR2/c18U1
         A/HYcwLGmrVygXaAcDsWAyoBAih+QFccdkeQ3uKkxDEBjlXxY5a8Naq77bObZYB7Voq3
         OYAA==
X-Gm-Message-State: AOJu0YwkNfncfLE5S+AsNJsF5LN46B7Wn78STxGKrfjOKBblR8wVaxsF
	nU6v1C0S0NjopK/O+SS8EfCyQSNv4rJ8eg==
X-Google-Smtp-Source: AGHT+IEhbukIbMJxe0XeRt2lHobV2JbuWL9JZcjldNC8OY0732Jbqq6ubAvn3PMQTDTFrXUf5ogLhA==
X-Received: by 2002:a05:600c:a003:b0:404:4b6f:d70d with SMTP id jg3-20020a05600ca00300b004044b6fd70dmr11754074wmb.17.1704303231383;
        Wed, 03 Jan 2024 09:33:51 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id fl27-20020a05600c0b9b00b0040d2dfb10e0sm2979265wmb.11.2024.01.03.09.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:50 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id AB9515F933;
	Wed,  3 Jan 2024 17:33:49 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Bin Meng <bin.meng@windriver.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Laurent Vivier <laurent@vivier.eu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Brian Cain <bcain@quicinc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Beraldo Leal <bleal@redhat.com>,
	Paul Durrant <paul@xen.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-arm@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	John Snow <jsnow@redhat.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH v2 04/43] chardev: use bool for fe_is_open
Date: Wed,  3 Jan 2024 17:33:10 +0000
Message-Id: <20240103173349.398526-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103173349.398526-1-alex.bennee@linaro.org>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The function qemu_chr_fe_init already treats be->fe_open as a bool and
if it acts like a bool it should be one. While we are at it make the
variable name more descriptive and add kdoc decorations.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20231211145959.93759-1-alex.bennee@linaro.org>

---
v2
  - rename to fe_is_open at f4bug's request
---
 include/chardev/char-fe.h | 19 ++++++++++++-------
 chardev/char-fe.c         | 16 ++++++++--------
 chardev/char.c            |  2 +-
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/chardev/char-fe.h b/include/chardev/char-fe.h
index 0ff6f875116..ecef1828355 100644
--- a/include/chardev/char-fe.h
+++ b/include/chardev/char-fe.h
@@ -7,8 +7,12 @@
 typedef void IOEventHandler(void *opaque, QEMUChrEvent event);
 typedef int BackendChangeHandler(void *opaque);
 
-/* This is the backend as seen by frontend, the actual backend is
- * Chardev */
+/**
+ * struct CharBackend - back end as seen by front end
+ * @fe_is_open: the front end is ready for IO
+ *
+ * The actual backend is Chardev
+ */
 struct CharBackend {
     Chardev *chr;
     IOEventHandler *chr_event;
@@ -17,7 +21,7 @@ struct CharBackend {
     BackendChangeHandler *chr_be_change;
     void *opaque;
     int tag;
-    int fe_open;
+    bool fe_is_open;
 };
 
 /**
@@ -156,12 +160,13 @@ void qemu_chr_fe_set_echo(CharBackend *be, bool echo);
 
 /**
  * qemu_chr_fe_set_open:
+ * @be: a CharBackend
+ * @is_open: the front end open status
  *
- * Set character frontend open status.  This is an indication that the
- * front end is ready (or not) to begin doing I/O.
- * Without associated Chardev, do nothing.
+ * This is an indication that the front end is ready (or not) to begin
+ * doing I/O. Without associated Chardev, do nothing.
  */
-void qemu_chr_fe_set_open(CharBackend *be, int fe_open);
+void qemu_chr_fe_set_open(CharBackend *be, bool is_open);
 
 /**
  * qemu_chr_fe_printf:
diff --git a/chardev/char-fe.c b/chardev/char-fe.c
index 7789f7be9c8..20222a4cad5 100644
--- a/chardev/char-fe.c
+++ b/chardev/char-fe.c
@@ -211,7 +211,7 @@ bool qemu_chr_fe_init(CharBackend *b, Chardev *s, Error **errp)
         }
     }
 
-    b->fe_open = false;
+    b->fe_is_open = false;
     b->tag = tag;
     b->chr = s;
     return true;
@@ -257,7 +257,7 @@ void qemu_chr_fe_set_handlers_full(CharBackend *b,
                                    bool sync_state)
 {
     Chardev *s;
-    int fe_open;
+    bool fe_open;
 
     s = b->chr;
     if (!s) {
@@ -265,10 +265,10 @@ void qemu_chr_fe_set_handlers_full(CharBackend *b,
     }
 
     if (!opaque && !fd_can_read && !fd_read && !fd_event) {
-        fe_open = 0;
+        fe_open = false;
         remove_fd_in_watch(s);
     } else {
-        fe_open = 1;
+        fe_open = true;
     }
     b->chr_can_read = fd_can_read;
     b->chr_read = fd_read;
@@ -336,7 +336,7 @@ void qemu_chr_fe_set_echo(CharBackend *be, bool echo)
     }
 }
 
-void qemu_chr_fe_set_open(CharBackend *be, int fe_open)
+void qemu_chr_fe_set_open(CharBackend *be, bool is_open)
 {
     Chardev *chr = be->chr;
 
@@ -344,12 +344,12 @@ void qemu_chr_fe_set_open(CharBackend *be, int fe_open)
         return;
     }
 
-    if (be->fe_open == fe_open) {
+    if (be->fe_is_open == is_open) {
         return;
     }
-    be->fe_open = fe_open;
+    be->fe_is_open = is_open;
     if (CHARDEV_GET_CLASS(chr)->chr_set_fe_open) {
-        CHARDEV_GET_CLASS(chr)->chr_set_fe_open(chr, fe_open);
+        CHARDEV_GET_CLASS(chr)->chr_set_fe_open(chr, is_open);
     }
 }
 
diff --git a/chardev/char.c b/chardev/char.c
index 996a024c7a2..0653b112e92 100644
--- a/chardev/char.c
+++ b/chardev/char.c
@@ -750,7 +750,7 @@ static int qmp_query_chardev_foreach(Object *obj, void *data)
 
     value->label = g_strdup(chr->label);
     value->filename = g_strdup(chr->filename);
-    value->frontend_open = chr->be && chr->be->fe_open;
+    value->frontend_open = chr->be && chr->be->fe_is_open;
 
     QAPI_LIST_PREPEND(*list, value);
 
-- 
2.39.2


