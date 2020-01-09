Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F98135CA6
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbgAIPYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:24:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732359AbgAIPYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 10:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4kUKKeAf2s8djmV5zny/Aq4FrGtcS96wgzcVBqpzxsI=;
        b=awADI+23+mRuH3DuMavjWTmLx4Rsz9WqVlveitTGbOnsJZd2ZgGekd6zbLvrfW0zkpq6jE
        pHXHCqMZjAJGluzZoZTmcyfR6jrr9/1gGIm02vO+cbJ8zfx/tAlzfcFfFRx3Uv0XvCTom3
        GckhdnhRiS2ulFYp2UKvgIatTXeRZsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105--h2u7_6uOF6RjR-my6orjA-1; Thu, 09 Jan 2020 10:23:45 -0500
X-MC-Unique: -h2u7_6uOF6RjR-my6orjA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E57231800D4E;
        Thu,  9 Jan 2020 15:23:43 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE46980608;
        Thu,  9 Jan 2020 15:23:36 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-ppc@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 15/15] vl: Make current_machine a local variable
Date:   Thu,  9 Jan 2020 16:21:33 +0100
Message-Id: <20200109152133.23649-16-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-1-philmd@redhat.com>
References: <20200109152133.23649-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we now only use current_machine in vl.c, stop exporting
it as a global variable in "hw/board.h", and make it static
to vl.c.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 include/hw/boards.h | 2 --
 vl.c                | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index 61f8bb8e5a..b0c0d4376d 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -59,8 +59,6 @@ void memory_region_allocate_system_memory(MemoryRegion =
*mr, Object *owner,
 #define MACHINE_CLASS(klass) \
     OBJECT_CLASS_CHECK(MachineClass, (klass), TYPE_MACHINE)
=20
-extern MachineState *current_machine;
-
 void machine_run_board_init(MachineState *machine);
 bool machine_usb(MachineState *machine);
 int machine_phandle_start(MachineState *machine);
diff --git a/vl.c b/vl.c
index 3ff3548183..7a69af4bef 100644
--- a/vl.c
+++ b/vl.c
@@ -214,6 +214,8 @@ static int default_sdcard =3D 1;
 static int default_vga =3D 1;
 static int default_net =3D 1;
=20
+static MachineState *current_machine;
+
 static struct {
     const char *driver;
     int *flag;
@@ -1164,8 +1166,6 @@ static int usb_parse(const char *cmdline)
 /***********************************************************/
 /* machine registration */
=20
-MachineState *current_machine;
-
 static MachineClass *find_machine(const char *name, GSList *machines)
 {
     GSList *el;
--=20
2.21.1

