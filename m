Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF5C135C99
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732358AbgAIPXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:23:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56279 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731096AbgAIPXY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 10:23:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EA7clJKJ1RuwQZV3nJY9EmgysBuWFpNyPg81lJP16ic=;
        b=CLfFxVALDOunx+OFI+P+RX5LQd3qBu88lOVf/PRqUIwe63q+kPlMGG+/Ucr3F+irQjz3Tr
        cr2Z8+vpDZqLIU/8BC5mPRc4+AVvG3sv7Wma5d99yRvxswH5uRfr8VDHmRKjsdBnZSB8bm
        g8X9znrG5TT5ESbbqpID/kWOReuYk9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-Bssf6NODNKGQ5QTbYx0F5Q-1; Thu, 09 Jan 2020 10:23:22 -0500
X-MC-Unique: Bssf6NODNKGQ5QTbYx0F5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93700107ACC4;
        Thu,  9 Jan 2020 15:23:20 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B76B61CB;
        Thu,  9 Jan 2020 15:23:14 +0000 (UTC)
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
Subject: [PATCH 12/15] accel: Introduce the current_accel() method
Date:   Thu,  9 Jan 2020 16:21:30 +0100
Message-Id: <20200109152133.23649-13-philmd@redhat.com>
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

We want to remove the global current_machine. The accel/
code access few times current_machine->accelerator. Introduce
the current_accel() method first, it will then be easier to
replace 'current_machine' by MACHINE(qdev_get_machine()).

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 include/sysemu/accel.h | 2 ++
 accel/accel.c          | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/sysemu/accel.h b/include/sysemu/accel.h
index d4c1429711..47e5788530 100644
--- a/include/sysemu/accel.h
+++ b/include/sysemu/accel.h
@@ -70,4 +70,6 @@ int accel_init_machine(AccelState *accel, MachineState =
*ms);
 /* Called just before os_setup_post (ie just before drop OS privs) */
 void accel_setup_post(MachineState *ms);
=20
+AccelState *current_accel(void);
+
 #endif
diff --git a/accel/accel.c b/accel/accel.c
index 1c5c3a6abb..cb555e3b06 100644
--- a/accel/accel.c
+++ b/accel/accel.c
@@ -63,6 +63,11 @@ int accel_init_machine(AccelState *accel, MachineState=
 *ms)
     return ret;
 }
=20
+AccelState *current_accel(void)
+{
+    return current_machine->accelerator;
+}
+
 void accel_setup_post(MachineState *ms)
 {
     AccelState *accel =3D ms->accelerator;
--=20
2.21.1

