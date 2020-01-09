Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCE0135C92
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732338AbgAIPWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:22:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31883 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732336AbgAIPWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 10:22:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zSEVdD4q81/iEc/2OJsdkw6WfL0iI9AF0OwFhiGUJrs=;
        b=UHDPgxYHjxSblBdRNFQ1LLm5hYpPPSsEJ03le59reVjsRAvAAGo7ZQcctI56hR2b6HIjG2
        F69l4/dBDFhmNtTaqkbVrfQEKZvKUiIdqjG0/qCxlnpslUfU+rOoj07KZrGVmb6qYFfReJ
        8r5n2Ig5U1J+S9vVJIdWNC7V1mFbV6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-YHDvjnUkN62ZEraTmN9r2g-1; Thu, 09 Jan 2020 10:22:45 -0500
X-MC-Unique: YHDvjnUkN62ZEraTmN9r2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D8698C4B4E;
        Thu,  9 Jan 2020 15:22:43 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD97980602;
        Thu,  9 Jan 2020 15:22:37 +0000 (UTC)
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
Subject: [PATCH 07/15] hw/core/machine-qmp-cmds: Replace current_machine by qdev_get_machine()
Date:   Thu,  9 Jan 2020 16:21:25 +0100
Message-Id: <20200109152133.23649-8-philmd@redhat.com>
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
 hw/core/machine-qmp-cmds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/core/machine-qmp-cmds.c b/hw/core/machine-qmp-cmds.c
index eed5aeb2f7..5a04d00e4f 100644
--- a/hw/core/machine-qmp-cmds.c
+++ b/hw/core/machine-qmp-cmds.c
@@ -280,9 +280,9 @@ void qmp_cpu_add(int64_t id, Error **errp)
 {
     MachineClass *mc;
=20
-    mc =3D MACHINE_GET_CLASS(current_machine);
+    mc =3D MACHINE_GET_CLASS(qdev_get_machine());
     if (mc->hot_add_cpu) {
-        mc->hot_add_cpu(current_machine, id, errp);
+        mc->hot_add_cpu(MACHINE(qdev_get_machine()), id, errp);
     } else {
         error_setg(errp, "Not supported");
     }
--=20
2.21.1

