Return-Path: <kvm+bounces-6564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F6F836815
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01EEA284F61
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1395DF28;
	Mon, 22 Jan 2024 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Tgh5A5Cq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FEA5D905
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935694; cv=none; b=LJI4mMDvCiAbD1QyhMk4tPowNIocjWOwB6l2fp1olLUxJoTQiEli1HvM4kJncz9jWMWLLybTDCJJLSzaYXpWNqPhgKgQQeFhpm/6P2gb47oQENkMDCBdn3Gce0tkOrmghZK+0+I/T1rB5950WFVEDfCZotNbeSfwRKsvIRdcPlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935694; c=relaxed/simple;
	bh=IuKzrwr2e/NXelOSJSqYZeeoW7uE3h1k+m0k0/5P9yw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EggYIG5YxhTGAPSw4WYMVhreD3Dc5g50/BeNuJDRWkpJbdnKfQZeCQ8b3slTbk/MhhfcldubNL+47yS9rQqWMfxLVzPx3yhrKM4qgszu7HQYr/Z2ozdXdQU0ECdP0s+0/ZLCmCGn79ziB0rwX7paburtTc6a7M5DRazPm5dZi9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Tgh5A5Cq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40e60e137aaso36581005e9.0
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 07:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935689; x=1706540489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7VOplgsBBAgAtEJeAgTFkF54S4NCVefHHQnrnHK8t0=;
        b=Tgh5A5Cq0+j8icJmcycEr3DGV93dasRQJTTQkg4Y5JcO1OyVvR0+zlaZZKf6uPZiRA
         3spx9S/pLCAataNItBkRgxBHetyeohAGY64xpRtbUXVjomqZvahlYHDRQ1iSxc41kG4V
         f5KBiZC2FIx5oGMA3xMsUzAcHBcEtTDmhqyuasRq05L1lM8jxXrkHnrKbK/wupRYFFcV
         6RuvrsoBZXzhsSKvjv/sce7bhpZbCPqHQ44loaONSQuy5SbtUB5Att8cJame06ezCN5i
         AJWXUdQHSTjwphZC5d893Th0pjT+4Bv2bddAsftafhzH9+Y/q2GyYGLiXlbGyAWE5Dhx
         +i3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935689; x=1706540489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L7VOplgsBBAgAtEJeAgTFkF54S4NCVefHHQnrnHK8t0=;
        b=O2N1hjAR9lf22ihG6MsVAThOxuTJ6sciisWp/SF15O4WoFhJ2hJayKonRBwpisfrFw
         FGnAJlP8ZwV/BFylKqexFBs4UdRbU7ahlfl3WExYzF3Hp7s0VYcsSOcLoiApNSjPDTmX
         No+UmYXpy8OdT3Gh3+wTHn5rA14WmJk8mqAFWVqWVR2ayuIvWRBGuo3FQ1Kz6uufS+32
         nRN91UqXPVTs5xB13vNOccyOYElnI8mFBFMBacjl8WNVIC4iAtTmyObU3fQOImMKqVJr
         SA7Jdi34ompops+eqBfSMahotLCflZqadSf2uuPQi0r5RpnJpt43ni2f5+spAmWxKSQm
         zYZw==
X-Gm-Message-State: AOJu0Yxt5BvX9w7kwM3RNi/a2ibnv5cS278TixWP4tBeABcASWfR05Jp
	jmAFJbc4t9rDjvH1uT+sUXbtqbLkqmZQTJXUCfHV8vt0/g9P7O52NrG/SfV3vFU=
X-Google-Smtp-Source: AGHT+IFxNTPr8NUI2fFrYkNhQafasrORn8JAkp9EvucZOYRV+FHSy9wjv9TICupAQqM47gPf+Jni/Q==
X-Received: by 2002:a05:600c:154c:b0:40d:7f19:40b1 with SMTP id f12-20020a05600c154c00b0040d7f1940b1mr2366763wmg.169.1705935688882;
        Mon, 22 Jan 2024 07:01:28 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id s15-20020a5d6a8f000000b00336898daceasm11699962wru.96.2024.01.22.07.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 07:01:28 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id AC7E75F936;
	Mon, 22 Jan 2024 14:56:12 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-ppc@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	John Snow <jsnow@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Cleber Rosa <crosa@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Paul Durrant <paul@xen.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v3 16/21] gdbstub: expose api to find registers
Date: Mon, 22 Jan 2024 14:56:05 +0000
Message-Id: <20240122145610.413836-17-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122145610.413836-1-alex.bennee@linaro.org>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Expose an internal API to QEMU to return all the registers for a vCPU.
The list containing the details required to called gdb_read_register().

Based-on: <20231025093128.33116-15-akihiko.odaki@daynix.com>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
Message-Id: <20240103173349.398526-38-alex.bennee@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - rm unused api functions left over
---
 include/exec/gdbstub.h | 28 ++++++++++++++++++++++++++++
 gdbstub/gdbstub.c      | 27 ++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index da9ddfe54c5..eb14b91139b 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -111,6 +111,34 @@ void gdb_feature_builder_end(const GDBFeatureBuilder *builder);
  */
 const GDBFeature *gdb_find_static_feature(const char *xmlname);
 
+/**
+ * gdb_read_register() - Read a register associated with a CPU.
+ * @cpu: The CPU associated with the register.
+ * @buf: The buffer that the read register will be appended to.
+ * @reg: The register's number returned by gdb_find_feature_register().
+ *
+ * Return: The number of read bytes.
+ */
+int gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
+
+/**
+ * typedef GDBRegDesc - a register description from gdbstub
+ */
+typedef struct {
+    int gdb_reg;
+    const char *name;
+    const char *feature_name;
+} GDBRegDesc;
+
+/**
+ * gdb_get_register_list() - Return list of all registers for CPU
+ * @cpu: The CPU being searched
+ *
+ * Returns a GArray of GDBRegDesc, caller frees array but not the
+ * const strings.
+ */
+GArray *gdb_get_register_list(CPUState *cpu);
+
 void gdb_set_stop_cpu(CPUState *cpu);
 
 /* in gdbstub-xml.c, generated by scripts/feature_to_c.py */
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 420ab2a3766..14f2f32e63f 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -490,7 +490,32 @@ const GDBFeature *gdb_find_static_feature(const char *xmlname)
     g_assert_not_reached();
 }
 
-static int gdb_read_register(CPUState *cpu, GByteArray *buf, int reg)
+GArray *gdb_get_register_list(CPUState *cpu)
+{
+    GArray *results = g_array_new(true, true, sizeof(GDBRegDesc));
+
+    /* registers are only available once the CPU is initialised */
+    if (!cpu->gdb_regs) {
+        return results;
+    }
+
+    for (int f = 0; f < cpu->gdb_regs->len; f++) {
+        GDBRegisterState *r = &g_array_index(cpu->gdb_regs, GDBRegisterState, f);
+        for (int i = 0; i < r->feature->num_regs; i++) {
+            const char *name = r->feature->regs[i];
+            GDBRegDesc desc = {
+                r->base_reg + i,
+                name,
+                r->feature->name
+            };
+            g_array_append_val(results, desc);
+        }
+    }
+
+    return results;
+}
+
+int gdb_read_register(CPUState *cpu, GByteArray *buf, int reg)
 {
     CPUClass *cc = CPU_GET_CLASS(cpu);
     GDBRegisterState *r;
-- 
2.39.2


