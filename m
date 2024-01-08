Return-Path: <kvm+bounces-5842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D57B882756C
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 17:38:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E346AB2290C
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF7B5467A;
	Mon,  8 Jan 2024 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SoCgnFHk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C8953E3E
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 16:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704731867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8JyAVituzHKzz/zXpAv4OyXDfgV7BDAfn1K6NqR7fpw=;
	b=SoCgnFHkdt2bGSZhVpbxugzlii7A0UlDJhcSuPqp7weTQdlZ/zMYbxdxit+NTmaa0f3ha9
	EE8oY5737PSF76e3m0jKjlwCFbNCNDgYRq7ojodaagIi35bH5mWqb162VKXnxVTK9AdeFr
	IxJYtXTSIGCpJFhfGdse21xe3VnBmCg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-K2rcKz65PC2__aIEFAB_Tw-1; Mon,
 08 Jan 2024 11:37:42 -0500
X-MC-Unique: K2rcKz65PC2__aIEFAB_Tw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5094B3813BC2;
	Mon,  8 Jan 2024 16:37:41 +0000 (UTC)
Received: from localhost (unknown [10.39.194.85])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 14E8B2026F95;
	Mon,  8 Jan 2024 16:37:40 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	qemu-block@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	kvm@vger.kernel.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	qemu-arm@nongnu.org,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jiri Slaby <jslaby@suse.cz>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Paul Durrant <paul@xen.org>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Kevin Wolf <kwolf@redhat.com>,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	xen-devel@lists.xenproject.org,
	Anthony Perard <anthony.perard@citrix.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-ppc@nongnu.org,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Song Gao <gaosong@loongson.cn>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexander Graf <agraf@csgraf.de>,
	Markus Armbruster <armbru@redhat.com>,
	John Snow <jsnow@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Stefan Weil <sw@weilnetz.de>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Hailiang Zhang <zhanghailiang@xfusion.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Michael Roth <michael.roth@amd.com>,
	Fam Zheng <fam@euphon.net>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	David Gibson <david@gibson.dropbear.id.au>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stafford Horne <shorne@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Cameron Esfahani <dirty@apple.com>,
	Eric Farman <farman@linux.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Hanna Reitz <hreitz@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Bin Meng <bin.meng@windriver.com>,
	Fabiano Rosas <farosas@suse.de>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PULL 1/6] iothread: Remove unused Error** argument in aio_context_set_aio_params
Date: Mon,  8 Jan 2024 11:37:30 -0500
Message-ID: <20240108163735.254732-2-stefanha@redhat.com>
In-Reply-To: <20240108163735.254732-1-stefanha@redhat.com>
References: <20240108163735.254732-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Philippe Mathieu-Daudé <philmd@linaro.org>

aio_context_set_aio_params() doesn't use its undocumented
Error** argument. Remove it to simplify.

Note this removes a use of "unchecked Error**" in
iothread_set_aio_context_params().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231120171806.19361-1-philmd@linaro.org>
---
 include/block/aio.h | 3 +--
 iothread.c          | 3 +--
 util/aio-posix.c    | 3 +--
 util/aio-win32.c    | 3 +--
 util/main-loop.c    | 5 +----
 5 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/block/aio.h b/include/block/aio.h
index af05512a7d..c802a392e5 100644
--- a/include/block/aio.h
+++ b/include/block/aio.h
@@ -699,8 +699,7 @@ void aio_context_set_poll_params(AioContext *ctx, int64_t max_ns,
  * @max_batch: maximum number of requests in a batch, 0 means that the
  *             engine will use its default
  */
-void aio_context_set_aio_params(AioContext *ctx, int64_t max_batch,
-                                Error **errp);
+void aio_context_set_aio_params(AioContext *ctx, int64_t max_batch);
 
 /**
  * aio_context_set_thread_pool_params:
diff --git a/iothread.c b/iothread.c
index b753286414..6c1fc8c856 100644
--- a/iothread.c
+++ b/iothread.c
@@ -170,8 +170,7 @@ static void iothread_set_aio_context_params(EventLoopBase *base, Error **errp)
     }
 
     aio_context_set_aio_params(iothread->ctx,
-                               iothread->parent_obj.aio_max_batch,
-                               errp);
+                               iothread->parent_obj.aio_max_batch);
 
     aio_context_set_thread_pool_params(iothread->ctx, base->thread_pool_min,
                                        base->thread_pool_max, errp);
diff --git a/util/aio-posix.c b/util/aio-posix.c
index 7f2c99729d..266c9dd35f 100644
--- a/util/aio-posix.c
+++ b/util/aio-posix.c
@@ -777,8 +777,7 @@ void aio_context_set_poll_params(AioContext *ctx, int64_t max_ns,
     aio_notify(ctx);
 }
 
-void aio_context_set_aio_params(AioContext *ctx, int64_t max_batch,
-                                Error **errp)
+void aio_context_set_aio_params(AioContext *ctx, int64_t max_batch)
 {
     /*
      * No thread synchronization here, it doesn't matter if an incorrect value
diff --git a/util/aio-win32.c b/util/aio-win32.c
index 948ef47a4d..d144f9391f 100644
--- a/util/aio-win32.c
+++ b/util/aio-win32.c
@@ -438,7 +438,6 @@ void aio_context_set_poll_params(AioContext *ctx, int64_t max_ns,
     }
 }
 
-void aio_context_set_aio_params(AioContext *ctx, int64_t max_batch,
-                                Error **errp)
+void aio_context_set_aio_params(AioContext *ctx, int64_t max_batch)
 {
 }
diff --git a/util/main-loop.c b/util/main-loop.c
index 797b640c41..63b4cda84a 100644
--- a/util/main-loop.c
+++ b/util/main-loop.c
@@ -192,10 +192,7 @@ static void main_loop_update_params(EventLoopBase *base, Error **errp)
         return;
     }
 
-    aio_context_set_aio_params(qemu_aio_context, base->aio_max_batch, errp);
-    if (*errp) {
-        return;
-    }
+    aio_context_set_aio_params(qemu_aio_context, base->aio_max_batch);
 
     aio_context_set_thread_pool_params(qemu_aio_context, base->thread_pool_min,
                                        base->thread_pool_max, errp);
-- 
2.43.0


