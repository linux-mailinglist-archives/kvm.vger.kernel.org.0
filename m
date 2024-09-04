Return-Path: <kvm+bounces-25853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AAEDA96BA43
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37B1B1F21421
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D82B1D5CED;
	Wed,  4 Sep 2024 11:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RNXUWryM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295891D0974
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448736; cv=none; b=RITEYijylmMPAF0wkl58g+TU3rkGRT5dBH4intmOfXv1lBaCm/rOrnnM0o2EZn/+ATxuVwXhR0bUe3J5NfUp76rW3QsuA0k8ux+w6/YgmJ+/vl5hZJr1n8gxi52DZ+Qc+wqZKHTd9Y6nVDr4w2BlN7hofcBOdlJ9xU33BVIe45A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448736; c=relaxed/simple;
	bh=7+GTVr4QMMy1cDqCdN64Bnp+xJ873QbTUin232uIsd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=KpRD4wBYzyNeHucFcXkAcl4Cxb0Jkt1tDLpQPVSKw8Gdu4/RpJuJWPLEH3AbPncUp0Aq16L/CfLVqve5nbTCh90x4EHeR+7WnNSODnFWzQcD0YtFr1wCPs3UvCxXWXg/2646PHUIAYDFYyFP9vFfcz9070zNKPZqbeA1XgnqnRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RNXUWryM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mx0VBf7PIZMmG9UblVDStv63N2fkZrKVnw2Bb2K1RLo=;
	b=RNXUWryMXlx75uwUxurhGDvYu47ALU4QPQ6cppppVHQ1vA3BI4MbaSjMYtxg/R4RmuQYIM
	5Znv6kndb7BiOYKbdvg9Gtv37ViW9l06LgRgt8q8icEzRrFa6S670ziqvm0p/bquG34qQX
	wanHx5d+KiAqLtxXcuMrNx8X2qttce0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-f_RRaaRgPMeBbeFZ_Pxv9g-1; Wed,
 04 Sep 2024 07:18:49 -0400
X-MC-Unique: f_RRaaRgPMeBbeFZ_Pxv9g-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF53D1955DA6;
	Wed,  4 Sep 2024 11:18:45 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8C501956086;
	Wed,  4 Sep 2024 11:18:43 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id AF9F021E68BD; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com,
	andrew@codeconstruct.com.au,
	andrew@daynix.com,
	arei.gonglei@huawei.com,
	berrange@redhat.com,
	berto@igalia.com,
	borntraeger@linux.ibm.com,
	clg@kaod.org,
	david@redhat.com,
	den@openvz.org,
	eblake@redhat.com,
	eduardo@habkost.net,
	farman@linux.ibm.com,
	farosas@suse.de,
	hreitz@redhat.com,
	idryomov@gmail.com,
	iii@linux.ibm.com,
	jamin_lin@aspeedtech.com,
	jasowang@redhat.com,
	joel@jms.id.au,
	jsnow@redhat.com,
	kwolf@redhat.com,
	leetroy@gmail.com,
	marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com,
	michael.roth@amd.com,
	mst@redhat.com,
	mtosatti@redhat.com,
	nsg@linux.ibm.com,
	pasic@linux.ibm.com,
	pbonzini@redhat.com,
	peter.maydell@linaro.org,
	peterx@redhat.com,
	philmd@linaro.org,
	pizhenwei@bytedance.com,
	pl@dlhnet.de,
	richard.henderson@linaro.org,
	stefanha@redhat.com,
	steven_lee@aspeedtech.com,
	thuth@redhat.com,
	vsementsov@yandex-team.ru,
	wangyanan55@huawei.com,
	yuri.benditovich@daynix.com,
	zhao1.liu@intel.com,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	avihaih@nvidia.com
Subject: [PATCH v2 08/19] qapi/ui: Drop temporary 'prefix'
Date: Wed,  4 Sep 2024 13:18:25 +0200
Message-ID: <20240904111836.3273842-9-armbru@redhat.com>
In-Reply-To: <20240904111836.3273842-1-armbru@redhat.com>
References: <20240904111836.3273842-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Recent commit "qapi: Smarter camel_to_upper() to reduce need for
'prefix'" added a temporary 'prefix' to delay changing the generated
code.

Revert it.  This improves DisplayGLMode's generated enumeration
constant prefix from DISPLAYGL_MODE to DISPLAY_GL_MODE.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 qapi/ui.json      |  1 -
 system/vl.c       |  2 +-
 ui/dbus.c         |  8 ++++----
 ui/egl-context.c  |  2 +-
 ui/egl-headless.c |  2 +-
 ui/egl-helpers.c  | 12 ++++++------
 ui/gtk.c          |  4 ++--
 ui/sdl2-gl.c      |  8 ++++----
 ui/sdl2.c         |  2 +-
 ui/spice-core.c   |  2 +-
 10 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/qapi/ui.json b/qapi/ui.json
index f61a2b6b65..460a26b981 100644
--- a/qapi/ui.json
+++ b/qapi/ui.json
@@ -1397,7 +1397,6 @@
 # Since: 3.0
 ##
 { 'enum'    : 'DisplayGLMode',
-  'prefix'  : 'DISPLAYGL_MODE', # TODO drop
   'data'    : [ 'off', 'on', 'core', 'es' ] }
 
 ##
diff --git a/system/vl.c b/system/vl.c
index 01b8b8e77a..fe547ca47c 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -1971,7 +1971,7 @@ static void qemu_create_early_backends(void)
 
     qemu_console_early_init();
 
-    if (dpy.has_gl && dpy.gl != DISPLAYGL_MODE_OFF && display_opengl == 0) {
+    if (dpy.has_gl && dpy.gl != DISPLAY_GL_MODE_OFF && display_opengl == 0) {
 #if defined(CONFIG_OPENGL)
         error_report("OpenGL is not supported by display backend '%s'",
                      DisplayType_str(dpy.type));
diff --git a/ui/dbus.c b/ui/dbus.c
index e08b5de064..7ecd39e784 100644
--- a/ui/dbus.c
+++ b/ui/dbus.c
@@ -176,7 +176,7 @@ dbus_display_add_console(DBusDisplay *dd, int idx, Error **errp)
     assert(con);
 
     if (qemu_console_is_graphic(con) &&
-        dd->gl_mode != DISPLAYGL_MODE_OFF) {
+        dd->gl_mode != DISPLAY_GL_MODE_OFF) {
         qemu_console_set_display_gl_ctx(con, &dd->glctx);
     }
 
@@ -466,9 +466,9 @@ static const TypeInfo dbus_vc_type_info = {
 static void
 early_dbus_init(DisplayOptions *opts)
 {
-    DisplayGLMode mode = opts->has_gl ? opts->gl : DISPLAYGL_MODE_OFF;
+    DisplayGLMode mode = opts->has_gl ? opts->gl : DISPLAY_GL_MODE_OFF;
 
-    if (mode != DISPLAYGL_MODE_OFF) {
+    if (mode != DISPLAY_GL_MODE_OFF) {
 #ifdef CONFIG_OPENGL
         egl_init(opts->u.dbus.rendernode, mode, &error_fatal);
 #else
@@ -482,7 +482,7 @@ early_dbus_init(DisplayOptions *opts)
 static void
 dbus_init(DisplayState *ds, DisplayOptions *opts)
 {
-    DisplayGLMode mode = opts->has_gl ? opts->gl : DISPLAYGL_MODE_OFF;
+    DisplayGLMode mode = opts->has_gl ? opts->gl : DISPLAY_GL_MODE_OFF;
 
     if (opts->u.dbus.addr && opts->u.dbus.p2p) {
         error_report("dbus: can't accept both addr=X and p2p=yes options");
diff --git a/ui/egl-context.c b/ui/egl-context.c
index 9e0df466f3..aed3e3ba1f 100644
--- a/ui/egl-context.c
+++ b/ui/egl-context.c
@@ -17,7 +17,7 @@ QEMUGLContext qemu_egl_create_context(DisplayGLCtx *dgc,
        EGL_CONTEXT_MINOR_VERSION_KHR, params->minor_ver,
        EGL_NONE
    };
-   bool gles = (qemu_egl_mode == DISPLAYGL_MODE_ES);
+   bool gles = (qemu_egl_mode == DISPLAY_GL_MODE_ES);
 
    ctx = eglCreateContext(qemu_egl_display, qemu_egl_config,
                           eglGetCurrentContext(),
diff --git a/ui/egl-headless.c b/ui/egl-headless.c
index 6187249c73..1f6b845500 100644
--- a/ui/egl-headless.c
+++ b/ui/egl-headless.c
@@ -207,7 +207,7 @@ static const DisplayGLCtxOps eglctx_ops = {
 
 static void early_egl_headless_init(DisplayOptions *opts)
 {
-    DisplayGLMode mode = DISPLAYGL_MODE_ON;
+    DisplayGLMode mode = DISPLAY_GL_MODE_ON;
 
     if (opts->has_gl) {
         mode = opts->gl;
diff --git a/ui/egl-helpers.c b/ui/egl-helpers.c
index 99b2ebbe23..81a57fa975 100644
--- a/ui/egl-helpers.c
+++ b/ui/egl-helpers.c
@@ -503,7 +503,7 @@ static int qemu_egl_init_dpy(EGLNativeDisplayType dpy,
     EGLint major, minor;
     EGLBoolean b;
     EGLint n;
-    bool gles = (mode == DISPLAYGL_MODE_ES);
+    bool gles = (mode == DISPLAY_GL_MODE_ES);
 
     qemu_egl_display = qemu_egl_get_display(dpy, platform);
     if (qemu_egl_display == EGL_NO_DISPLAY) {
@@ -533,7 +533,7 @@ static int qemu_egl_init_dpy(EGLNativeDisplayType dpy,
         return -1;
     }
 
-    qemu_egl_mode = gles ? DISPLAYGL_MODE_ES : DISPLAYGL_MODE_CORE;
+    qemu_egl_mode = gles ? DISPLAY_GL_MODE_ES : DISPLAY_GL_MODE_CORE;
     return 0;
 }
 
@@ -564,8 +564,8 @@ int qemu_egl_init_dpy_mesa(EGLNativeDisplayType dpy, DisplayGLMode mode)
 int qemu_egl_init_dpy_win32(EGLNativeDisplayType dpy, DisplayGLMode mode)
 {
     /* prefer GL ES, as that's what ANGLE supports */
-    if (mode == DISPLAYGL_MODE_ON) {
-        mode = DISPLAYGL_MODE_ES;
+    if (mode == DISPLAY_GL_MODE_ON) {
+        mode = DISPLAY_GL_MODE_ES;
     }
 
     if (qemu_egl_init_dpy(dpy, 0, mode) < 0) {
@@ -618,7 +618,7 @@ EGLContext qemu_egl_init_ctx(void)
         EGL_CONTEXT_CLIENT_VERSION, 2,
         EGL_NONE
     };
-    bool gles = (qemu_egl_mode == DISPLAYGL_MODE_ES);
+    bool gles = (qemu_egl_mode == DISPLAY_GL_MODE_ES);
     EGLContext ectx;
     EGLBoolean b;
 
@@ -642,7 +642,7 @@ bool egl_init(const char *rendernode, DisplayGLMode mode, Error **errp)
 {
     ERRP_GUARD();
 
-    if (mode == DISPLAYGL_MODE_OFF) {
+    if (mode == DISPLAY_GL_MODE_OFF) {
         error_setg(errp, "egl: turning off GL doesn't make sense");
         return false;
     }
diff --git a/ui/gtk.c b/ui/gtk.c
index 8e14c2ac81..bf9d3dd679 100644
--- a/ui/gtk.c
+++ b/ui/gtk.c
@@ -2514,7 +2514,7 @@ static void early_gtk_display_init(DisplayOptions *opts)
     }
 
     assert(opts->type == DISPLAY_TYPE_GTK);
-    if (opts->has_gl && opts->gl != DISPLAYGL_MODE_OFF) {
+    if (opts->has_gl && opts->gl != DISPLAY_GL_MODE_OFF) {
 #if defined(CONFIG_OPENGL)
 #if defined(GDK_WINDOWING_WAYLAND)
         if (GDK_IS_WAYLAND_DISPLAY(gdk_display_get_default())) {
@@ -2530,7 +2530,7 @@ static void early_gtk_display_init(DisplayOptions *opts)
 #endif
         {
 #ifdef CONFIG_X11
-            DisplayGLMode mode = opts->has_gl ? opts->gl : DISPLAYGL_MODE_ON;
+            DisplayGLMode mode = opts->has_gl ? opts->gl : DISPLAY_GL_MODE_ON;
             gtk_egl_init(mode);
 #endif
         }
diff --git a/ui/sdl2-gl.c b/ui/sdl2-gl.c
index 91b7ee2419..e01d9ab0c7 100644
--- a/ui/sdl2-gl.c
+++ b/ui/sdl2-gl.c
@@ -147,11 +147,11 @@ QEMUGLContext sdl2_gl_create_context(DisplayGLCtx *dgc,
     SDL_GL_MakeCurrent(scon->real_window, scon->winctx);
 
     SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, 1);
-    if (scon->opts->gl == DISPLAYGL_MODE_ON ||
-        scon->opts->gl == DISPLAYGL_MODE_CORE) {
+    if (scon->opts->gl == DISPLAY_GL_MODE_ON ||
+        scon->opts->gl == DISPLAY_GL_MODE_CORE) {
         SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,
                             SDL_GL_CONTEXT_PROFILE_CORE);
-    } else if (scon->opts->gl == DISPLAYGL_MODE_ES) {
+    } else if (scon->opts->gl == DISPLAY_GL_MODE_ES) {
         SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,
                             SDL_GL_CONTEXT_PROFILE_ES);
     }
@@ -163,7 +163,7 @@ QEMUGLContext sdl2_gl_create_context(DisplayGLCtx *dgc,
     /* If SDL fail to create a GL context and we use the "on" flag,
      * then try to fallback to GLES.
      */
-    if (!ctx && scon->opts->gl == DISPLAYGL_MODE_ON) {
+    if (!ctx && scon->opts->gl == DISPLAY_GL_MODE_ON) {
         SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,
                             SDL_GL_CONTEXT_PROFILE_ES);
         ctx = SDL_GL_CreateContext(scon->real_window);
diff --git a/ui/sdl2.c b/ui/sdl2.c
index 98ed974371..251ce97796 100644
--- a/ui/sdl2.c
+++ b/ui/sdl2.c
@@ -107,7 +107,7 @@ void sdl2_window_create(struct sdl2_console *scon)
     if (scon->opengl) {
         const char *driver = "opengl";
 
-        if (scon->opts->gl == DISPLAYGL_MODE_ES) {
+        if (scon->opts->gl == DISPLAY_GL_MODE_ES) {
             driver = "opengles2";
         }
 
diff --git a/ui/spice-core.c b/ui/spice-core.c
index 15be640286..bd9dbe03f1 100644
--- a/ui/spice-core.c
+++ b/ui/spice-core.c
@@ -840,7 +840,7 @@ static void qemu_spice_init(void)
                          "incompatible with -spice port/tls-port");
             exit(1);
         }
-        egl_init(qemu_opt_get(opts, "rendernode"), DISPLAYGL_MODE_ON, &error_fatal);
+        egl_init(qemu_opt_get(opts, "rendernode"), DISPLAY_GL_MODE_ON, &error_fatal);
         spice_opengl = 1;
     }
 #endif
-- 
2.46.0


