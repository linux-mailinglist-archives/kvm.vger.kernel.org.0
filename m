Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176C3135C96
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732347AbgAIPXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:23:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37125 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732344AbgAIPXH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 10:23:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZEMOGD26t+fMYjJ4LobtAf8vZNWvIS3QswsuquGMzqE=;
        b=XUPBzeErMU4voED02hCBgbSNJbEX5rPbNJdT3z+AgyeVO84x5TvQciFuNx61X2TxPArZcf
        No6DIR1wlg5Jnn+yXA0snHobfINsnKxvZ6EqHPlpFOf3JGakg7sOgSOKaswc8N8tkAnmXE
        NlreojCh8ndelr5G0iFedjeM9ZNriyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-wgHZV1PxPwGTHcuUwuI7bA-1; Thu, 09 Jan 2020 10:23:05 -0500
X-MC-Unique: wgHZV1PxPwGTHcuUwuI7bA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6C531005513;
        Thu,  9 Jan 2020 15:23:03 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CF5F1CB;
        Thu,  9 Jan 2020 15:22:58 +0000 (UTC)
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
Subject: [PATCH 10/15] memory: Replace current_machine by qdev_get_machine()
Date:   Thu,  9 Jan 2020 16:21:28 +0100
Message-Id: <20200109152133.23649-11-philmd@redhat.com>
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
replace 'current_machine' by MACHINE(qdev_get_machine()).

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/memory.c b/memory.c
index d7b9bb6951..57e38b1f50 100644
--- a/memory.c
+++ b/memory.c
@@ -3004,6 +3004,7 @@ static void mtree_print_flatview(gpointer key, gpoi=
nter value,
     int n =3D view->nr;
     int i;
     AddressSpace *as;
+    MachineState *ms;
=20
     qemu_printf("FlatView #%d\n", fvi->counter);
     ++fvi->counter;
@@ -3026,6 +3027,7 @@ static void mtree_print_flatview(gpointer key, gpoi=
nter value,
         return;
     }
=20
+    ms =3D MACHINE(qdev_get_machine());
     while (n--) {
         mr =3D range->mr;
         if (range->offset_in_region) {
@@ -3057,7 +3059,7 @@ static void mtree_print_flatview(gpointer key, gpoi=
nter value,
         if (fvi->ac) {
             for (i =3D 0; i < fv_address_spaces->len; ++i) {
                 as =3D g_array_index(fv_address_spaces, AddressSpace*, i=
);
-                if (fvi->ac->has_memory(current_machine, as,
+                if (fvi->ac->has_memory(ms, as,
                                         int128_get64(range->addr.start),
                                         MR_SIZE(range->addr.size) + 1)) =
{
                     qemu_printf(" %s", fvi->ac->name);
--=20
2.21.1

