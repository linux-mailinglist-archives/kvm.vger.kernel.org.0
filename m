Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADACB135CA2
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732387AbgAIPXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:23:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34595 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732382AbgAIPXm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 10:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNApPi1X+zRXACouBoiVidpyff+gUxoQCsbtOGpF3sA=;
        b=gwNh8iYRfNmQxJftqIx4be9cPMJ18IZdMRGUfzLrNqUetGnnQacLbeUkYujHB190pBiNdn
        7KRvlmKS93z3tnrCcPVWOuv7k4Ko55RyA8GzTGU9I42pwNycuCzV2jBP6yTPspsvKZUFc8
        8+LkbdbW31m3veb8URKxynzMa6Rp8/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-okIuNwqmOrWMJxTPVr8mUw-1; Thu, 09 Jan 2020 10:23:37 -0500
X-MC-Unique: okIuNwqmOrWMJxTPVr8mUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41CB0DB20;
        Thu,  9 Jan 2020 15:23:36 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BA467FB5C;
        Thu,  9 Jan 2020 15:23:27 +0000 (UTC)
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
Subject: [PATCH 14/15] accel/accel: Replace current_machine by qdev_get_machine()
Date:   Thu,  9 Jan 2020 16:21:32 +0100
Message-Id: <20200109152133.23649-15-philmd@redhat.com>
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
 accel/accel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/accel/accel.c b/accel/accel.c
index cb555e3b06..777d6ba119 100644
--- a/accel/accel.c
+++ b/accel/accel.c
@@ -65,7 +65,9 @@ int accel_init_machine(AccelState *accel, MachineState =
*ms)
=20
 AccelState *current_accel(void)
 {
-    return current_machine->accelerator;
+    MachineState *ms =3D MACHINE(qdev_get_machine());
+
+    return ms->accelerator;
 }
=20
 void accel_setup_post(MachineState *ms)
--=20
2.21.1

