Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC72135C91
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732331AbgAIPWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:22:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53186 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732329AbgAIPWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 10:22:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QE12T9YoIYg3KiaFxYrMJ0Yi0XSnGIdy/p9v0TlJLU8=;
        b=LUYQVGDxFAnmlIiseUs6xK8lp4hk3/WqcCptjQ8uZdsFqBUHBMv0q7gVKUcHxOPGBaTZtS
        QOoI4AtgQ0Seaue4wVckJdeHLvw2CCKVFAqIGmmSYVeRpXCfglYnglugGXItuSSk/svsmr
        OwPYYd1Oz1ojLiOmTYgjBo5wXXrSd1I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-3uSQJtr2O2yD9tYK2nha0g-1; Thu, 09 Jan 2020 10:22:38 -0500
X-MC-Unique: 3uSQJtr2O2yD9tYK2nha0g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E55D84E291;
        Thu,  9 Jan 2020 15:22:37 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D285C1CB;
        Thu,  9 Jan 2020 15:22:31 +0000 (UTC)
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
Subject: [PATCH 06/15] migration/savevm: Replace current_machine by qdev_get_machine()
Date:   Thu,  9 Jan 2020 16:21:24 +0100
Message-Id: <20200109152133.23649-7-philmd@redhat.com>
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

As we want to remove the global current_machine,
replace MACHINE_GET_CLASS(current_machine) by
MACHINE_GET_CLASS(qdev_get_machine()).

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 migration/savevm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/migration/savevm.c b/migration/savevm.c
index 59efc1981d..0e8b6a4715 100644
--- a/migration/savevm.c
+++ b/migration/savevm.c
@@ -292,7 +292,8 @@ static uint32_t get_validatable_capabilities_count(vo=
id)
 static int configuration_pre_save(void *opaque)
 {
     SaveState *state =3D opaque;
-    const char *current_name =3D MACHINE_GET_CLASS(current_machine)->nam=
e;
+    MachineClass *mc =3D MACHINE_GET_CLASS(qdev_get_machine());
+    const char *current_name =3D mc->name;
     MigrationState *s =3D migrate_get_current();
     int i, j;
=20
@@ -362,7 +363,8 @@ static bool configuration_validate_capabilities(SaveS=
tate *state)
 static int configuration_post_load(void *opaque, int version_id)
 {
     SaveState *state =3D opaque;
-    const char *current_name =3D MACHINE_GET_CLASS(current_machine)->nam=
e;
+    MachineClass *mc =3D MACHINE_GET_CLASS(qdev_get_machine());
+    const char *current_name =3D mc->name;
=20
     if (strncmp(state->name, current_name, state->len) !=3D 0) {
         error_report("Machine type received is '%.*s' and local is '%s'"=
,
@@ -615,9 +617,7 @@ static void dump_vmstate_vmsd(FILE *out_file,
=20
 static void dump_machine_type(FILE *out_file)
 {
-    MachineClass *mc;
-
-    mc =3D MACHINE_GET_CLASS(current_machine);
+    MachineClass *mc =3D MACHINE_GET_CLASS(qdev_get_machine());
=20
     fprintf(out_file, "  \"vmschkmachine\": {\n");
     fprintf(out_file, "    \"Name\": \"%s\"\n", mc->name);
--=20
2.21.1

